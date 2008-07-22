From: "adam radford" <aradford@gmail.com>
Subject: [PATCH 1/1] 3ware add MSI support
Date: Tue, 22 Jul 2008 16:47:40 -0700
Message-ID: <b1bc6a000807221647s6faefb0eo9ffe946e4b0d2589@mail.gmail.com>
References: <b1bc6a000807221636s2c5ef1faj6ed0c375a14ee995@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_113660_1063474.1216770460048"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:59327 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbYGVXrk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jul 2008 19:47:40 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2112571rvb.1
        for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2008 16:47:40 -0700 (PDT)
In-Reply-To: <b1bc6a000807221636s2c5ef1faj6ed0c375a14ee995@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

------=_Part_113660_1063474.1216770460048
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch for the 3w-9xxx scsi driver applies on top of the
BKL-pushdown changes in -git9.

This patch does the following:

- Increase max AENs drained to 256.
- Add MSI support and "use_msi" module parameter.
- Fix bug in twa_get_param() on 4GB+.
- Use pci_resource_len() for ioremap().

James, could you please apply this?

Thanks,

-Adam

Note: This patch is included in-line below and also as an attachment
in case Gmail hoses the patch.

diff -Naur scsi-misc/drivers/scsi/3w-9xxx.c scsi-misc.new/drivers/scsi/3w-9xxx.c
--- scsi-misc/drivers/scsi/3w-9xxx.c    2008-07-22 15:00:10.000000000 -0700
+++ scsi-misc.new/drivers/scsi/3w-9xxx.c        2008-07-22
15:14:34.000000000 -0700
@@ -4,7 +4,7 @@
   Written By: Adam Radford <linuxraid@amcc.com>
   Modifications By: Tom Couch <linuxraid@amcc.com>

-   Copyright (C) 2004-2007 Applied Micro Circuits Corporation.
+   Copyright (C) 2004-2008 Applied Micro Circuits Corporation.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
@@ -71,6 +71,10 @@
                 Add support for 9650SE controllers.
   2.26.02.009 - Fix dma mask setting to fallback to 32-bit if 64-bit fails.
   2.26.02.010 - Add support for 9690SA controllers.
+   2.26.02.011 - Increase max AENs drained to 256.
+                 Add MSI support and "use_msi" module parameter.
+                 Fix bug in twa_get_param() on 4GB+.
+                 Use pci_resource_len() for ioremap().
 */

 #include <linux/module.h>
@@ -95,7 +99,7 @@
 #include "3w-9xxx.h"

 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.010"
+#define TW_DRIVER_VERSION "2.26.02.011"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
@@ -107,6 +111,10 @@
 MODULE_LICENSE("GPL");
 MODULE_VERSION(TW_DRIVER_VERSION);

+static int use_msi = 0;
+module_param(use_msi, int, S_IRUGO);
+MODULE_PARM_DESC(use_msi, "Use Message Signaled Interrupts.  Default: 0");
+
 /* Function prototypes */
 static void twa_aen_queue_event(TW_Device_Extension *tw_dev,
TW_Command_Apache_Header *header);
 static int twa_aen_read_queue(TW_Device_Extension *tw_dev, int request_id);
@@ -1038,7 +1046,6 @@
       TW_Command_Full *full_command_packet;
       TW_Command *command_packet;
       TW_Param_Apache *param;
-       unsigned long param_value;
       void *retval = NULL;

       /* Setup the command packet */
@@ -1057,9 +1064,8 @@
       param->table_id = cpu_to_le16(table_id | 0x8000);
       param->parameter_id = cpu_to_le16(parameter_id);
       param->parameter_size_bytes = cpu_to_le16(parameter_size_bytes);
-       param_value = tw_dev->generic_buffer_phys[request_id];

-       command_packet->byte8_offset.param.sgl[0].address =
TW_CPU_TO_SGL(param_value);
+       command_packet->byte8_offset.param.sgl[0].address =
TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
       command_packet->byte8_offset.param.sgl[0].length =
cpu_to_le32(TW_SECTOR_SIZE);

       /* Post the command packet to the board */
@@ -2000,7 +2006,7 @@
 {
       struct Scsi_Host *host = NULL;
       TW_Device_Extension *tw_dev;
-       u32 mem_addr;
+       unsigned long mem_addr, mem_len;
       int retval = -ENODEV;

       retval = pci_enable_device(pdev);
@@ -2045,13 +2051,16 @@
               goto out_free_device_extension;
       }

-       if (pdev->device == PCI_DEVICE_ID_3WARE_9000)
+       if (pdev->device == PCI_DEVICE_ID_3WARE_9000) {
               mem_addr = pci_resource_start(pdev, 1);
-       else
+               mem_len = pci_resource_len(pdev, 1);
+       } else {
               mem_addr = pci_resource_start(pdev, 2);
+               mem_len = pci_resource_len(pdev, 2);
+       }

       /* Save base address */
-       tw_dev->base_addr = ioremap(mem_addr, PAGE_SIZE);
+       tw_dev->base_addr = ioremap(mem_addr, mem_len);
       if (!tw_dev->base_addr) {
               TW_PRINTK(tw_dev->host, TW_DRIVER, 0x35, "Failed to ioremap");
               goto out_release_mem_region;
@@ -2086,7 +2095,7 @@

       pci_set_drvdata(pdev, host);

-       printk(KERN_WARNING "3w-9xxx: scsi%d: Found a 3ware 9000 Storage
Controller at 0x%x, IRQ: %d.\n",
+       printk(KERN_WARNING "3w-9xxx: scsi%d: Found a 3ware 9000 Storage
Controller at 0x%lx, IRQ: %d.\n",
              host->host_no, mem_addr, pdev->irq);
       printk(KERN_WARNING "3w-9xxx: scsi%d: Firmware %s, BIOS %s,
Ports: %d.\n",
              host->host_no,
@@ -2097,6 +2106,11 @@
              le32_to_cpu(*(int *)twa_get_param(tw_dev, 2, TW_INFORMATION_TABLE,
                                    TW_PARAM_PORTCOUNT,
TW_PARAM_PORTCOUNT_LENGTH)));

+       /* Try to enable MSI */
+       if (use_msi && (pdev->device != PCI_DEVICE_ID_3WARE_9000) &&
+           !pci_enable_msi(pdev))
+               set_bit(TW_USING_MSI, &tw_dev->flags);
+
       /* Now setup the interrupt handler */
       retval = request_irq(pdev->irq, twa_interrupt, IRQF_SHARED,
"3w-9xxx", tw_dev);
       if (retval) {
@@ -2120,6 +2134,8 @@
       return 0;

 out_remove_host:
+       if (test_bit(TW_USING_MSI, &tw_dev->flags))
+               pci_disable_msi(pdev);
       scsi_remove_host(host);
 out_iounmap:
       iounmap(tw_dev->base_addr);
@@ -2151,6 +2167,10 @@
       /* Shutdown the card */
       __twa_shutdown(tw_dev);

+       /* Disable MSI if enabled */
+       if (test_bit(TW_USING_MSI, &tw_dev->flags))
+               pci_disable_msi(pdev);
+
       /* Free IO remapping */
       iounmap(tw_dev->base_addr);

diff -Naur scsi-misc/drivers/scsi/3w-9xxx.h scsi-misc.new/drivers/scsi/3w-9xxx.h
--- scsi-misc/drivers/scsi/3w-9xxx.h    2008-07-13 14:51:29.000000000 -0700
+++ scsi-misc.new/drivers/scsi/3w-9xxx.h        2008-07-22
15:14:35.000000000 -0700
@@ -4,7 +4,7 @@
   Written By: Adam Radford <linuxraid@amcc.com>
   Modifications By: Tom Couch <linuxraid@amcc.com>

-   Copyright (C) 2004-2007 Applied Micro Circuits Corporation.
+   Copyright (C) 2004-2008 Applied Micro Circuits Corporation.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
@@ -319,8 +319,8 @@

 /* Compatibility defines */
 #define TW_9000_ARCH_ID 0x5
-#define TW_CURRENT_DRIVER_SRL 30
-#define TW_CURRENT_DRIVER_BUILD 80
+#define TW_CURRENT_DRIVER_SRL 35
+#define TW_CURRENT_DRIVER_BUILD 0
 #define TW_CURRENT_DRIVER_BRANCH 0

 /* Phase defines */
@@ -352,8 +352,9 @@
 #define TW_MAX_RESET_TRIES                   2
 #define TW_MAX_CMDS_PER_LUN                  254
 #define TW_MAX_RESPONSE_DRAIN                256
-#define TW_MAX_AEN_DRAIN                     40
+#define TW_MAX_AEN_DRAIN                     255
 #define TW_IN_RESET                           2
+#define TW_USING_MSI                         3
 #define TW_IN_ATTENTION_LOOP                 4
 #define TW_MAX_SECTORS                        256
 #define TW_AEN_WAIT_TIME                      1000

------=_Part_113660_1063474.1216770460048
Content-Type: text/x-patch; name=3ware_2.6.26-git10.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fiz3hz790
Content-Disposition: attachment; filename=3ware_2.6.26-git10.patch

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpLzN3LTl4eHguYyBzY3NpLW1pc2MubmV3
L2RyaXZlcnMvc2NzaS8zdy05eHh4LmMKLS0tIHNjc2ktbWlzYy9kcml2ZXJzL3Njc2kvM3ctOXh4
eC5jCTIwMDgtMDctMjIgMTU6MDA6MTAuMDAwMDAwMDAwIC0wNzAwCisrKyBzY3NpLW1pc2MubmV3
L2RyaXZlcnMvc2NzaS8zdy05eHh4LmMJMjAwOC0wNy0yMiAxNToxNDozNC4wMDAwMDAwMDAgLTA3
MDAKQEAgLTQsNyArNCw3IEBACiAgICBXcml0dGVuIEJ5OiBBZGFtIFJhZGZvcmQgPGxpbnV4cmFp
ZEBhbWNjLmNvbT4KICAgIE1vZGlmaWNhdGlvbnMgQnk6IFRvbSBDb3VjaCA8bGludXhyYWlkQGFt
Y2MuY29tPgogCi0gICBDb3B5cmlnaHQgKEMpIDIwMDQtMjAwNyBBcHBsaWVkIE1pY3JvIENpcmN1
aXRzIENvcnBvcmF0aW9uLgorICAgQ29weXJpZ2h0IChDKSAyMDA0LTIwMDggQXBwbGllZCBNaWNy
byBDaXJjdWl0cyBDb3Jwb3JhdGlvbi4KIAogICAgVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdh
cmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkKICAgIGl0IHVuZGVyIHRo
ZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5
CkBAIC03MSw2ICs3MSwxMCBAQAogICAgICAgICAgICAgICAgICBBZGQgc3VwcG9ydCBmb3IgOTY1
MFNFIGNvbnRyb2xsZXJzLgogICAgMi4yNi4wMi4wMDkgLSBGaXggZG1hIG1hc2sgc2V0dGluZyB0
byBmYWxsYmFjayB0byAzMi1iaXQgaWYgNjQtYml0IGZhaWxzLgogICAgMi4yNi4wMi4wMTAgLSBB
ZGQgc3VwcG9ydCBmb3IgOTY5MFNBIGNvbnRyb2xsZXJzLgorICAgMi4yNi4wMi4wMTEgLSBJbmNy
ZWFzZSBtYXggQUVOcyBkcmFpbmVkIHRvIDI1Ni4KKyAgICAgICAgICAgICAgICAgQWRkIE1TSSBz
dXBwb3J0IGFuZCAidXNlX21zaSIgbW9kdWxlIHBhcmFtZXRlci4KKyAgICAgICAgICAgICAgICAg
Rml4IGJ1ZyBpbiB0d2FfZ2V0X3BhcmFtKCkgb24gNEdCKy4KKyAgICAgICAgICAgICAgICAgVXNl
IHBjaV9yZXNvdXJjZV9sZW4oKSBmb3IgaW9yZW1hcCgpLgogKi8KIAogI2luY2x1ZGUgPGxpbnV4
L21vZHVsZS5oPgpAQCAtOTUsNyArOTksNyBAQAogI2luY2x1ZGUgIjN3LTl4eHguaCIKIAogLyog
R2xvYmFscyAqLwotI2RlZmluZSBUV19EUklWRVJfVkVSU0lPTiAiMi4yNi4wMi4wMTAiCisjZGVm
aW5lIFRXX0RSSVZFUl9WRVJTSU9OICIyLjI2LjAyLjAxMSIKIHN0YXRpYyBUV19EZXZpY2VfRXh0
ZW5zaW9uICp0d2FfZGV2aWNlX2V4dGVuc2lvbl9saXN0W1RXX01BWF9TTE9UXTsKIHN0YXRpYyB1
bnNpZ25lZCBpbnQgdHdhX2RldmljZV9leHRlbnNpb25fY291bnQ7CiBzdGF0aWMgaW50IHR3YV9t
YWpvciA9IC0xOwpAQCAtMTA3LDYgKzExMSwxMCBAQAogTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOwog
TU9EVUxFX1ZFUlNJT04oVFdfRFJJVkVSX1ZFUlNJT04pOwogCitzdGF0aWMgaW50IHVzZV9tc2kg
PSAwOworbW9kdWxlX3BhcmFtKHVzZV9tc2ksIGludCwgU19JUlVHTyk7CitNT0RVTEVfUEFSTV9E
RVNDKHVzZV9tc2ksICJVc2UgTWVzc2FnZSBTaWduYWxlZCBJbnRlcnJ1cHRzLiAgRGVmYXVsdDog
MCIpOworCiAvKiBGdW5jdGlvbiBwcm90b3R5cGVzICovCiBzdGF0aWMgdm9pZCB0d2FfYWVuX3F1
ZXVlX2V2ZW50KFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldiwgVFdfQ29tbWFuZF9BcGFjaGVf
SGVhZGVyICpoZWFkZXIpOwogc3RhdGljIGludCB0d2FfYWVuX3JlYWRfcXVldWUoVFdfRGV2aWNl
X0V4dGVuc2lvbiAqdHdfZGV2LCBpbnQgcmVxdWVzdF9pZCk7CkBAIC0xMDM4LDcgKzEwNDYsNiBA
QAogCVRXX0NvbW1hbmRfRnVsbCAqZnVsbF9jb21tYW5kX3BhY2tldDsKIAlUV19Db21tYW5kICpj
b21tYW5kX3BhY2tldDsKIAlUV19QYXJhbV9BcGFjaGUgKnBhcmFtOwotCXVuc2lnbmVkIGxvbmcg
cGFyYW1fdmFsdWU7CiAJdm9pZCAqcmV0dmFsID0gTlVMTDsKIAogCS8qIFNldHVwIHRoZSBjb21t
YW5kIHBhY2tldCAqLwpAQCAtMTA1Nyw5ICsxMDY0LDggQEAKIAlwYXJhbS0+dGFibGVfaWQgPSBj
cHVfdG9fbGUxNih0YWJsZV9pZCB8IDB4ODAwMCk7CiAJcGFyYW0tPnBhcmFtZXRlcl9pZCA9IGNw
dV90b19sZTE2KHBhcmFtZXRlcl9pZCk7CiAJcGFyYW0tPnBhcmFtZXRlcl9zaXplX2J5dGVzID0g
Y3B1X3RvX2xlMTYocGFyYW1ldGVyX3NpemVfYnl0ZXMpOwotCXBhcmFtX3ZhbHVlID0gdHdfZGV2
LT5nZW5lcmljX2J1ZmZlcl9waHlzW3JlcXVlc3RfaWRdOwogCi0JY29tbWFuZF9wYWNrZXQtPmJ5
dGU4X29mZnNldC5wYXJhbS5zZ2xbMF0uYWRkcmVzcyA9IFRXX0NQVV9UT19TR0wocGFyYW1fdmFs
dWUpOworCWNvbW1hbmRfcGFja2V0LT5ieXRlOF9vZmZzZXQucGFyYW0uc2dsWzBdLmFkZHJlc3Mg
PSBUV19DUFVfVE9fU0dMKHR3X2Rldi0+Z2VuZXJpY19idWZmZXJfcGh5c1tyZXF1ZXN0X2lkXSk7
CiAJY29tbWFuZF9wYWNrZXQtPmJ5dGU4X29mZnNldC5wYXJhbS5zZ2xbMF0ubGVuZ3RoID0gY3B1
X3RvX2xlMzIoVFdfU0VDVE9SX1NJWkUpOwogCiAJLyogUG9zdCB0aGUgY29tbWFuZCBwYWNrZXQg
dG8gdGhlIGJvYXJkICovCkBAIC0yMDAwLDcgKzIwMDYsNyBAQAogewogCXN0cnVjdCBTY3NpX0hv
c3QgKmhvc3QgPSBOVUxMOwogCVRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldjsKLQl1MzIgbWVt
X2FkZHI7CisJdW5zaWduZWQgbG9uZyBtZW1fYWRkciwgbWVtX2xlbjsKIAlpbnQgcmV0dmFsID0g
LUVOT0RFVjsKIAogCXJldHZhbCA9IHBjaV9lbmFibGVfZGV2aWNlKHBkZXYpOwpAQCAtMjA0NSwx
MyArMjA1MSwxNiBAQAogCQlnb3RvIG91dF9mcmVlX2RldmljZV9leHRlbnNpb247CiAJfQogCi0J
aWYgKHBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEXzNXQVJFXzkwMDApCisJaWYgKHBkZXYt
PmRldmljZSA9PSBQQ0lfREVWSUNFX0lEXzNXQVJFXzkwMDApIHsKIAkJbWVtX2FkZHIgPSBwY2lf
cmVzb3VyY2Vfc3RhcnQocGRldiwgMSk7Ci0JZWxzZQorCQltZW1fbGVuID0gcGNpX3Jlc291cmNl
X2xlbihwZGV2LCAxKTsKKwl9IGVsc2UgewogCQltZW1fYWRkciA9IHBjaV9yZXNvdXJjZV9zdGFy
dChwZGV2LCAyKTsKKwkJbWVtX2xlbiA9IHBjaV9yZXNvdXJjZV9sZW4ocGRldiwgMik7CisJfQog
CiAJLyogU2F2ZSBiYXNlIGFkZHJlc3MgKi8KLQl0d19kZXYtPmJhc2VfYWRkciA9IGlvcmVtYXAo
bWVtX2FkZHIsIFBBR0VfU0laRSk7CisJdHdfZGV2LT5iYXNlX2FkZHIgPSBpb3JlbWFwKG1lbV9h
ZGRyLCBtZW1fbGVuKTsKIAlpZiAoIXR3X2Rldi0+YmFzZV9hZGRyKSB7CiAJCVRXX1BSSU5USyh0
d19kZXYtPmhvc3QsIFRXX0RSSVZFUiwgMHgzNSwgIkZhaWxlZCB0byBpb3JlbWFwIik7CiAJCWdv
dG8gb3V0X3JlbGVhc2VfbWVtX3JlZ2lvbjsKQEAgLTIwODYsNyArMjA5NSw3IEBACiAKIAlwY2lf
c2V0X2RydmRhdGEocGRldiwgaG9zdCk7CiAKLQlwcmludGsoS0VSTl9XQVJOSU5HICIzdy05eHh4
OiBzY3NpJWQ6IEZvdW5kIGEgM3dhcmUgOTAwMCBTdG9yYWdlIENvbnRyb2xsZXIgYXQgMHgleCwg
SVJROiAlZC5cbiIsCisJcHJpbnRrKEtFUk5fV0FSTklORyAiM3ctOXh4eDogc2NzaSVkOiBGb3Vu
ZCBhIDN3YXJlIDkwMDAgU3RvcmFnZSBDb250cm9sbGVyIGF0IDB4JWx4LCBJUlE6ICVkLlxuIiwK
IAkgICAgICAgaG9zdC0+aG9zdF9ubywgbWVtX2FkZHIsIHBkZXYtPmlycSk7CiAJcHJpbnRrKEtF
Uk5fV0FSTklORyAiM3ctOXh4eDogc2NzaSVkOiBGaXJtd2FyZSAlcywgQklPUyAlcywgUG9ydHM6
ICVkLlxuIiwKIAkgICAgICAgaG9zdC0+aG9zdF9ubywKQEAgLTIwOTcsNiArMjEwNiwxMSBAQAog
CSAgICAgICBsZTMyX3RvX2NwdSgqKGludCAqKXR3YV9nZXRfcGFyYW0odHdfZGV2LCAyLCBUV19J
TkZPUk1BVElPTl9UQUJMRSwKIAkJCQkgICAgIFRXX1BBUkFNX1BPUlRDT1VOVCwgVFdfUEFSQU1f
UE9SVENPVU5UX0xFTkdUSCkpKTsKIAorCS8qIFRyeSB0byBlbmFibGUgTVNJICovCisJaWYgKHVz
ZV9tc2kgJiYgKHBkZXYtPmRldmljZSAhPSBQQ0lfREVWSUNFX0lEXzNXQVJFXzkwMDApICYmCisJ
ICAgICFwY2lfZW5hYmxlX21zaShwZGV2KSkKKwkJc2V0X2JpdChUV19VU0lOR19NU0ksICZ0d19k
ZXYtPmZsYWdzKTsKKwogCS8qIE5vdyBzZXR1cCB0aGUgaW50ZXJydXB0IGhhbmRsZXIgKi8KIAly
ZXR2YWwgPSByZXF1ZXN0X2lycShwZGV2LT5pcnEsIHR3YV9pbnRlcnJ1cHQsIElSUUZfU0hBUkVE
LCAiM3ctOXh4eCIsIHR3X2Rldik7CiAJaWYgKHJldHZhbCkgewpAQCAtMjEyMCw2ICsyMTM0LDgg
QEAKIAlyZXR1cm4gMDsKIAogb3V0X3JlbW92ZV9ob3N0OgorCWlmICh0ZXN0X2JpdChUV19VU0lO
R19NU0ksICZ0d19kZXYtPmZsYWdzKSkKKwkJcGNpX2Rpc2FibGVfbXNpKHBkZXYpOwogCXNjc2lf
cmVtb3ZlX2hvc3QoaG9zdCk7CiBvdXRfaW91bm1hcDoKIAlpb3VubWFwKHR3X2Rldi0+YmFzZV9h
ZGRyKTsKQEAgLTIxNTEsNiArMjE2NywxMCBAQAogCS8qIFNodXRkb3duIHRoZSBjYXJkICovCiAJ
X190d2Ffc2h1dGRvd24odHdfZGV2KTsKIAorCS8qIERpc2FibGUgTVNJIGlmIGVuYWJsZWQgKi8K
KwlpZiAodGVzdF9iaXQoVFdfVVNJTkdfTVNJLCAmdHdfZGV2LT5mbGFncykpCisJCXBjaV9kaXNh
YmxlX21zaShwZGV2KTsKKwogCS8qIEZyZWUgSU8gcmVtYXBwaW5nICovCiAJaW91bm1hcCh0d19k
ZXYtPmJhc2VfYWRkcik7CiAKZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpLzN3LTl4
eHguaCBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS8zdy05eHh4LmgKLS0tIHNjc2ktbWlzYy9k
cml2ZXJzL3Njc2kvM3ctOXh4eC5oCTIwMDgtMDctMTMgMTQ6NTE6MjkuMDAwMDAwMDAwIC0wNzAw
CisrKyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS8zdy05eHh4LmgJMjAwOC0wNy0yMiAxNTox
NDozNS4wMDAwMDAwMDAgLTA3MDAKQEAgLTQsNyArNCw3IEBACiAgICBXcml0dGVuIEJ5OiBBZGFt
IFJhZGZvcmQgPGxpbnV4cmFpZEBhbWNjLmNvbT4KICAgIE1vZGlmaWNhdGlvbnMgQnk6IFRvbSBD
b3VjaCA8bGludXhyYWlkQGFtY2MuY29tPgogCi0gICBDb3B5cmlnaHQgKEMpIDIwMDQtMjAwNyBB
cHBsaWVkIE1pY3JvIENpcmN1aXRzIENvcnBvcmF0aW9uLgorICAgQ29weXJpZ2h0IChDKSAyMDA0
LTIwMDggQXBwbGllZCBNaWNybyBDaXJjdWl0cyBDb3Jwb3JhdGlvbi4KIAogICAgVGhpcyBwcm9n
cmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2Rp
ZnkKICAgIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vu
c2UgYXMgcHVibGlzaGVkIGJ5CkBAIC0zMTksOCArMzE5LDggQEAKIAogLyogQ29tcGF0aWJpbGl0
eSBkZWZpbmVzICovCiAjZGVmaW5lIFRXXzkwMDBfQVJDSF9JRCAweDUKLSNkZWZpbmUgVFdfQ1VS
UkVOVF9EUklWRVJfU1JMIDMwCi0jZGVmaW5lIFRXX0NVUlJFTlRfRFJJVkVSX0JVSUxEIDgwCisj
ZGVmaW5lIFRXX0NVUlJFTlRfRFJJVkVSX1NSTCAzNQorI2RlZmluZSBUV19DVVJSRU5UX0RSSVZF
Ul9CVUlMRCAwCiAjZGVmaW5lIFRXX0NVUlJFTlRfRFJJVkVSX0JSQU5DSCAwCiAKIC8qIFBoYXNl
IGRlZmluZXMgKi8KQEAgLTM1Miw4ICszNTIsOSBAQAogI2RlZmluZSBUV19NQVhfUkVTRVRfVFJJ
RVMJCSAgICAgIDIKICNkZWZpbmUgVFdfTUFYX0NNRFNfUEVSX0xVTgkJICAgICAgMjU0CiAjZGVm
aW5lIFRXX01BWF9SRVNQT05TRV9EUkFJTgkJICAgICAgMjU2Ci0jZGVmaW5lIFRXX01BWF9BRU5f
RFJBSU4JCSAgICAgIDQwCisjZGVmaW5lIFRXX01BWF9BRU5fRFJBSU4JCSAgICAgIDI1NQogI2Rl
ZmluZSBUV19JTl9SRVNFVCAgICAgICAgICAgICAgICAgICAgICAgICAgIDIKKyNkZWZpbmUgVFdf
VVNJTkdfTVNJCQkJICAgICAgMwogI2RlZmluZSBUV19JTl9BVFRFTlRJT05fTE9PUAkJICAgICAg
NAogI2RlZmluZSBUV19NQVhfU0VDVE9SUyAgICAgICAgICAgICAgICAgICAgICAgIDI1NgogI2Rl
ZmluZSBUV19BRU5fV0FJVF9USU1FICAgICAgICAgICAgICAgICAgICAgIDEwMDAK
------=_Part_113660_1063474.1216770460048--
