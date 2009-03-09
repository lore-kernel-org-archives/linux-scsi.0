From: adam radford <aradford@gmail.com>
Subject: [PATCH] 3ware add power management support
Date: Mon, 9 Mar 2009 12:15:01 -0800
Message-ID: <b1bc6a000903091315i44174cedie33cb79718a2f53@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001517573dd00d18540464b54a52
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.181]:34564 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZCIUPD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2009 16:15:03 -0400
Received: by el-out-1112.google.com with SMTP id b25so1035801elf.1
        for <linux-scsi@vger.kernel.org>; Mon, 09 Mar 2009 13:15:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

--001517573dd00d18540464b54a52
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch for the 3w-9xxx scsi driver applies on top of scsi-misc
and is for 2.6.30.

This patch does the following:  Add power management support.

James,  could you please apply this?

Thanks,

-Adam

Signed-off-by: Adam Radford <aradford@gmail.com>

Note: This patch is included in-line below and also as an attachment
in case Gmail hoses the patch.

diff -Naur scsi-misc/drivers/scsi/3w-9xxx.c scsi-misc.new/drivers/scsi/3w-9xxx.c
--- scsi-misc/drivers/scsi/3w-9xxx.c	2008-12-24 15:26:37.000000000 -0800
+++ scsi-misc.new/drivers/scsi/3w-9xxx.c	2009-03-09 09:09:51.000000000 -0700
@@ -4,7 +4,7 @@
    Written By: Adam Radford <linuxraid@amcc.com>
    Modifications By: Tom Couch <linuxraid@amcc.com>

-   Copyright (C) 2004-2008 Applied Micro Circuits Corporation.
+   Copyright (C) 2004-2009 Applied Micro Circuits Corporation.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -75,6 +75,7 @@
                  Add MSI support and "use_msi" module parameter.
                  Fix bug in twa_get_param() on 4GB+.
                  Use pci_resource_len() for ioremap().
+   2.26.02.012 - Add power management support.
 */

 #include <linux/module.h>
@@ -99,7 +100,7 @@
 #include "3w-9xxx.h"

 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.011"
+#define TW_DRIVER_VERSION "2.26.02.012"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
@@ -2182,6 +2183,98 @@
 	twa_device_extension_count--;
 } /* End twa_remove() */

+#ifdef CONFIG_PM
+/* This function is called on PCI suspend */
+static int twa_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
+
+	printk(KERN_WARNING "3w-9xxx: Suspending host %d.\n", tw_dev->host->host_no);
+
+	TW_DISABLE_INTERRUPTS(tw_dev);
+	free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
+
+	if (test_bit(TW_USING_MSI, &tw_dev->flags))
+		pci_disable_msi(pdev);
+
+	/* Tell the card we are shutting down */
+	if (twa_initconnection(tw_dev, 1, 0, 0, 0, 0, 0, NULL, NULL, NULL,
NULL, NULL)) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x38, "Connection shutdown
failed during suspend");
+	} else {
+		printk(KERN_WARNING "3w-9xxx: Suspend complete.\n");
+	}
+	TW_CLEAR_ALL_INTERRUPTS(tw_dev);
+
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+	return 0;
+} /* End twa_suspend() */
+
+/* This function is called on PCI resume */
+static int twa_resume(struct pci_dev *pdev)
+{
+	int retval = 0;
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
+
+	printk(KERN_WARNING "3w-9xxx: Resuming host %d.\n", tw_dev->host->host_no);
+	pci_set_power_state(pdev, PCI_D0);
+	pci_enable_wake(pdev, PCI_D0, 0);
+	pci_restore_state(pdev);
+
+	retval = pci_enable_device(pdev);
+	if (retval) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x39, "Enable device failed
during resume");
+		return retval;
+	}
+
+	pci_set_master(pdev);
+	pci_try_set_mwi(pdev);
+
+	if (pci_set_dma_mask(pdev, DMA_64BIT_MASK)
+	    || pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))
+		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)
+		    || pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+			TW_PRINTK(host, TW_DRIVER, 0x40, "Failed to set dma mask during resume");
+			retval = -ENODEV;
+			goto out_disable_device;
+		}
+
+	/* Initialize the card */
+	if (twa_reset_sequence(tw_dev, 0)) {
+		retval = -ENODEV;
+		goto out_disable_device;
+	}
+
+	/* Now setup the interrupt handler */
+	retval = request_irq(pdev->irq, twa_interrupt, IRQF_SHARED,
"3w-9xxx", tw_dev);
+	if (retval) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x42, "Error requesting IRQ
during resume");
+		retval = -ENODEV;
+		goto out_disable_device;
+	}
+
+	/* Now enable MSI if enabled */
+	if (test_bit(TW_USING_MSI, &tw_dev->flags))
+		pci_enable_msi(pdev);
+	
+	/* Re-enable interrupts on the card */
+	TW_ENABLE_AND_CLEAR_INTERRUPTS(tw_dev);
+
+	printk(KERN_WARNING "3w-9xxx: Resume complete.\n");
+	return 0;
+
+out_disable_device:
+	scsi_remove_host(host);
+	pci_disable_device(pdev);
+
+	return retval;
+} /* End twa_resume() */
+#endif
+
 /* PCI Devices supported by this driver */
 static struct pci_device_id twa_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9000,
@@ -2202,6 +2295,10 @@
 	.id_table	= twa_pci_tbl,
 	.probe		= twa_probe,
 	.remove		= twa_remove,
+#ifdef CONFIG_PM
+	.suspend	= twa_suspend,
+	.resume		= twa_resume,
+#endif
 	.shutdown	= twa_shutdown
 };

diff -Naur scsi-misc/drivers/scsi/3w-9xxx.h scsi-misc.new/drivers/scsi/3w-9xxx.h
--- scsi-misc/drivers/scsi/3w-9xxx.h	2008-12-24 15:26:37.000000000 -0800
+++ scsi-misc.new/drivers/scsi/3w-9xxx.h	2009-03-09 09:09:52.000000000 -0700
@@ -4,7 +4,7 @@
    Written By: Adam Radford <linuxraid@amcc.com>
    Modifications By: Tom Couch <linuxraid@amcc.com>

-   Copyright (C) 2004-2008 Applied Micro Circuits Corporation.
+   Copyright (C) 2004-2009 Applied Micro Circuits Corporation.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by

--001517573dd00d18540464b54a52
Content-Type: text/x-patch; charset=US-ASCII; name="3ware_2.6.30.patch"
Content-Disposition: attachment; filename="3ware_2.6.30.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fs3js2420

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpLzN3LTl4eHguYyBzY3NpLW1pc2MubmV3
L2RyaXZlcnMvc2NzaS8zdy05eHh4LmMKLS0tIHNjc2ktbWlzYy9kcml2ZXJzL3Njc2kvM3ctOXh4
eC5jCTIwMDgtMTItMjQgMTU6MjY6MzcuMDAwMDAwMDAwIC0wODAwCisrKyBzY3NpLW1pc2MubmV3
L2RyaXZlcnMvc2NzaS8zdy05eHh4LmMJMjAwOS0wMy0wOSAwOTowOTo1MS4wMDAwMDAwMDAgLTA3
MDAKQEAgLTQsNyArNCw3IEBACiAgICBXcml0dGVuIEJ5OiBBZGFtIFJhZGZvcmQgPGxpbnV4cmFp
ZEBhbWNjLmNvbT4KICAgIE1vZGlmaWNhdGlvbnMgQnk6IFRvbSBDb3VjaCA8bGludXhyYWlkQGFt
Y2MuY29tPgogCi0gICBDb3B5cmlnaHQgKEMpIDIwMDQtMjAwOCBBcHBsaWVkIE1pY3JvIENpcmN1
aXRzIENvcnBvcmF0aW9uLgorICAgQ29weXJpZ2h0IChDKSAyMDA0LTIwMDkgQXBwbGllZCBNaWNy
byBDaXJjdWl0cyBDb3Jwb3JhdGlvbi4KIAogICAgVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdh
cmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkKICAgIGl0IHVuZGVyIHRo
ZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5
CkBAIC03NSw2ICs3NSw3IEBACiAgICAgICAgICAgICAgICAgIEFkZCBNU0kgc3VwcG9ydCBhbmQg
InVzZV9tc2kiIG1vZHVsZSBwYXJhbWV0ZXIuCiAgICAgICAgICAgICAgICAgIEZpeCBidWcgaW4g
dHdhX2dldF9wYXJhbSgpIG9uIDRHQisuCiAgICAgICAgICAgICAgICAgIFVzZSBwY2lfcmVzb3Vy
Y2VfbGVuKCkgZm9yIGlvcmVtYXAoKS4KKyAgIDIuMjYuMDIuMDEyIC0gQWRkIHBvd2VyIG1hbmFn
ZW1lbnQgc3VwcG9ydC4KICovCiAKICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KQEAgLTk5LDcg
KzEwMCw3IEBACiAjaW5jbHVkZSAiM3ctOXh4eC5oIgogCiAvKiBHbG9iYWxzICovCi0jZGVmaW5l
IFRXX0RSSVZFUl9WRVJTSU9OICIyLjI2LjAyLjAxMSIKKyNkZWZpbmUgVFdfRFJJVkVSX1ZFUlNJ
T04gIjIuMjYuMDIuMDEyIgogc3RhdGljIFRXX0RldmljZV9FeHRlbnNpb24gKnR3YV9kZXZpY2Vf
ZXh0ZW5zaW9uX2xpc3RbVFdfTUFYX1NMT1RdOwogc3RhdGljIHVuc2lnbmVkIGludCB0d2FfZGV2
aWNlX2V4dGVuc2lvbl9jb3VudDsKIHN0YXRpYyBpbnQgdHdhX21ham9yID0gLTE7CkBAIC0yMTgy
LDYgKzIxODMsOTggQEAKIAl0d2FfZGV2aWNlX2V4dGVuc2lvbl9jb3VudC0tOwogfSAvKiBFbmQg
dHdhX3JlbW92ZSgpICovCiAKKyNpZmRlZiBDT05GSUdfUE0KKy8qIFRoaXMgZnVuY3Rpb24gaXMg
Y2FsbGVkIG9uIFBDSSBzdXNwZW5kICovCitzdGF0aWMgaW50IHR3YV9zdXNwZW5kKHN0cnVjdCBw
Y2lfZGV2ICpwZGV2LCBwbV9tZXNzYWdlX3Qgc3RhdGUpCit7CisJc3RydWN0IFNjc2lfSG9zdCAq
aG9zdCA9IHBjaV9nZXRfZHJ2ZGF0YShwZGV2KTsKKwlUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19k
ZXYgPSAoVFdfRGV2aWNlX0V4dGVuc2lvbiAqKWhvc3QtPmhvc3RkYXRhOworCisJcHJpbnRrKEtF
Uk5fV0FSTklORyAiM3ctOXh4eDogU3VzcGVuZGluZyBob3N0ICVkLlxuIiwgdHdfZGV2LT5ob3N0
LT5ob3N0X25vKTsKKworCVRXX0RJU0FCTEVfSU5URVJSVVBUUyh0d19kZXYpOworCWZyZWVfaXJx
KHR3X2Rldi0+dHdfcGNpX2Rldi0+aXJxLCB0d19kZXYpOworCisJaWYgKHRlc3RfYml0KFRXX1VT
SU5HX01TSSwgJnR3X2Rldi0+ZmxhZ3MpKQorCQlwY2lfZGlzYWJsZV9tc2kocGRldik7CisKKwkv
KiBUZWxsIHRoZSBjYXJkIHdlIGFyZSBzaHV0dGluZyBkb3duICovCisJaWYgKHR3YV9pbml0Y29u
bmVjdGlvbih0d19kZXYsIDEsIDAsIDAsIDAsIDAsIDAsIE5VTEwsIE5VTEwsIE5VTEwsIE5VTEws
IE5VTEwpKSB7CisJCVRXX1BSSU5USyh0d19kZXYtPmhvc3QsIFRXX0RSSVZFUiwgMHgzOCwgIkNv
bm5lY3Rpb24gc2h1dGRvd24gZmFpbGVkIGR1cmluZyBzdXNwZW5kIik7CisJfSBlbHNlIHsKKwkJ
cHJpbnRrKEtFUk5fV0FSTklORyAiM3ctOXh4eDogU3VzcGVuZCBjb21wbGV0ZS5cbiIpOworCX0K
KwlUV19DTEVBUl9BTExfSU5URVJSVVBUUyh0d19kZXYpOworCisJcGNpX3NhdmVfc3RhdGUocGRl
dik7CisJcGNpX2Rpc2FibGVfZGV2aWNlKHBkZXYpOworCXBjaV9zZXRfcG93ZXJfc3RhdGUocGRl
diwgcGNpX2Nob29zZV9zdGF0ZShwZGV2LCBzdGF0ZSkpOworCisJcmV0dXJuIDA7Cit9IC8qIEVu
ZCB0d2Ffc3VzcGVuZCgpICovCisKKy8qIFRoaXMgZnVuY3Rpb24gaXMgY2FsbGVkIG9uIFBDSSBy
ZXN1bWUgKi8KK3N0YXRpYyBpbnQgdHdhX3Jlc3VtZShzdHJ1Y3QgcGNpX2RldiAqcGRldikKK3sK
KwlpbnQgcmV0dmFsID0gMDsKKwlzdHJ1Y3QgU2NzaV9Ib3N0ICpob3N0ID0gcGNpX2dldF9kcnZk
YXRhKHBkZXYpOworCVRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldiA9IChUV19EZXZpY2VfRXh0
ZW5zaW9uICopaG9zdC0+aG9zdGRhdGE7CisKKwlwcmludGsoS0VSTl9XQVJOSU5HICIzdy05eHh4
OiBSZXN1bWluZyBob3N0ICVkLlxuIiwgdHdfZGV2LT5ob3N0LT5ob3N0X25vKTsKKwlwY2lfc2V0
X3Bvd2VyX3N0YXRlKHBkZXYsIFBDSV9EMCk7CisJcGNpX2VuYWJsZV93YWtlKHBkZXYsIFBDSV9E
MCwgMCk7CisJcGNpX3Jlc3RvcmVfc3RhdGUocGRldik7CisKKwlyZXR2YWwgPSBwY2lfZW5hYmxl
X2RldmljZShwZGV2KTsKKwlpZiAocmV0dmFsKSB7CisJCVRXX1BSSU5USyh0d19kZXYtPmhvc3Qs
IFRXX0RSSVZFUiwgMHgzOSwgIkVuYWJsZSBkZXZpY2UgZmFpbGVkIGR1cmluZyByZXN1bWUiKTsK
KwkJcmV0dXJuIHJldHZhbDsKKwl9CisKKwlwY2lfc2V0X21hc3RlcihwZGV2KTsKKwlwY2lfdHJ5
X3NldF9td2kocGRldik7CisKKwlpZiAocGNpX3NldF9kbWFfbWFzayhwZGV2LCBETUFfNjRCSVRf
TUFTSykKKwkgICAgfHwgcGNpX3NldF9jb25zaXN0ZW50X2RtYV9tYXNrKHBkZXYsIERNQV82NEJJ
VF9NQVNLKSkKKwkJaWYgKHBjaV9zZXRfZG1hX21hc2socGRldiwgRE1BXzMyQklUX01BU0spCisJ
CSAgICB8fCBwY2lfc2V0X2NvbnNpc3RlbnRfZG1hX21hc2socGRldiwgRE1BXzMyQklUX01BU0sp
KSB7CisJCQlUV19QUklOVEsoaG9zdCwgVFdfRFJJVkVSLCAweDQwLCAiRmFpbGVkIHRvIHNldCBk
bWEgbWFzayBkdXJpbmcgcmVzdW1lIik7CisJCQlyZXR2YWwgPSAtRU5PREVWOworCQkJZ290byBv
dXRfZGlzYWJsZV9kZXZpY2U7CisJCX0KKworCS8qIEluaXRpYWxpemUgdGhlIGNhcmQgKi8KKwlp
ZiAodHdhX3Jlc2V0X3NlcXVlbmNlKHR3X2RldiwgMCkpIHsKKwkJcmV0dmFsID0gLUVOT0RFVjsK
KwkJZ290byBvdXRfZGlzYWJsZV9kZXZpY2U7CisJfQorCisJLyogTm93IHNldHVwIHRoZSBpbnRl
cnJ1cHQgaGFuZGxlciAqLworCXJldHZhbCA9IHJlcXVlc3RfaXJxKHBkZXYtPmlycSwgdHdhX2lu
dGVycnVwdCwgSVJRRl9TSEFSRUQsICIzdy05eHh4IiwgdHdfZGV2KTsKKwlpZiAocmV0dmFsKSB7
CisJCVRXX1BSSU5USyh0d19kZXYtPmhvc3QsIFRXX0RSSVZFUiwgMHg0MiwgIkVycm9yIHJlcXVl
c3RpbmcgSVJRIGR1cmluZyByZXN1bWUiKTsKKwkJcmV0dmFsID0gLUVOT0RFVjsKKwkJZ290byBv
dXRfZGlzYWJsZV9kZXZpY2U7CisJfQorCisJLyogTm93IGVuYWJsZSBNU0kgaWYgZW5hYmxlZCAq
LworCWlmICh0ZXN0X2JpdChUV19VU0lOR19NU0ksICZ0d19kZXYtPmZsYWdzKSkKKwkJcGNpX2Vu
YWJsZV9tc2kocGRldik7CisJCisJLyogUmUtZW5hYmxlIGludGVycnVwdHMgb24gdGhlIGNhcmQg
Ki8KKwlUV19FTkFCTEVfQU5EX0NMRUFSX0lOVEVSUlVQVFModHdfZGV2KTsKKworCXByaW50ayhL
RVJOX1dBUk5JTkcgIjN3LTl4eHg6IFJlc3VtZSBjb21wbGV0ZS5cbiIpOworCXJldHVybiAwOwor
CitvdXRfZGlzYWJsZV9kZXZpY2U6CisJc2NzaV9yZW1vdmVfaG9zdChob3N0KTsKKwlwY2lfZGlz
YWJsZV9kZXZpY2UocGRldik7CisKKwlyZXR1cm4gcmV0dmFsOworfSAvKiBFbmQgdHdhX3Jlc3Vt
ZSgpICovCisjZW5kaWYKKwogLyogUENJIERldmljZXMgc3VwcG9ydGVkIGJ5IHRoaXMgZHJpdmVy
ICovCiBzdGF0aWMgc3RydWN0IHBjaV9kZXZpY2VfaWQgdHdhX3BjaV90YmxbXSBfX2RldmluaXRk
YXRhID0gewogCXsgUENJX1ZFTkRPUl9JRF8zV0FSRSwgUENJX0RFVklDRV9JRF8zV0FSRV85MDAw
LApAQCAtMjIwMiw2ICsyMjk1LDEwIEBACiAJLmlkX3RhYmxlCT0gdHdhX3BjaV90YmwsCiAJLnBy
b2JlCQk9IHR3YV9wcm9iZSwKIAkucmVtb3ZlCQk9IHR3YV9yZW1vdmUsCisjaWZkZWYgQ09ORklH
X1BNCisJLnN1c3BlbmQJPSB0d2Ffc3VzcGVuZCwKKwkucmVzdW1lCQk9IHR3YV9yZXN1bWUsCisj
ZW5kaWYKIAkuc2h1dGRvd24JPSB0d2Ffc2h1dGRvd24KIH07CiAKZGlmZiAtTmF1ciBzY3NpLW1p
c2MvZHJpdmVycy9zY3NpLzN3LTl4eHguaCBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS8zdy05
eHh4LmgKLS0tIHNjc2ktbWlzYy9kcml2ZXJzL3Njc2kvM3ctOXh4eC5oCTIwMDgtMTItMjQgMTU6
MjY6MzcuMDAwMDAwMDAwIC0wODAwCisrKyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS8zdy05
eHh4LmgJMjAwOS0wMy0wOSAwOTowOTo1Mi4wMDAwMDAwMDAgLTA3MDAKQEAgLTQsNyArNCw3IEBA
CiAgICBXcml0dGVuIEJ5OiBBZGFtIFJhZGZvcmQgPGxpbnV4cmFpZEBhbWNjLmNvbT4KICAgIE1v
ZGlmaWNhdGlvbnMgQnk6IFRvbSBDb3VjaCA8bGludXhyYWlkQGFtY2MuY29tPgogCi0gICBDb3B5
cmlnaHQgKEMpIDIwMDQtMjAwOCBBcHBsaWVkIE1pY3JvIENpcmN1aXRzIENvcnBvcmF0aW9uLgor
ICAgQ29weXJpZ2h0IChDKSAyMDA0LTIwMDkgQXBwbGllZCBNaWNybyBDaXJjdWl0cyBDb3Jwb3Jh
dGlvbi4KIAogICAgVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0
cmlidXRlIGl0IGFuZC9vciBtb2RpZnkKICAgIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05V
IEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5Cg==
--001517573dd00d18540464b54a52--
