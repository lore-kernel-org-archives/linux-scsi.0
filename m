From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: add optional MSI support.
Date: Wed, 6 Feb 2008 13:20:42 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F43982A010@ADPE2K703.adaptec.com>
References: <532ABFBDAAC3A34EB12EBA6CEC2838F4397D643D@ADPE2K703.adaptec.com>
	 <20080205234912B.tomof@acm.org>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F4397D6932@ADPE2K703.adaptec.com>
	 <20080206101148L.fujita.tomonori@lab.ntt.co.jp>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F439829BBB@ADPE2K703.adaptec.com>
 <1202320497.3112.92.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F43982A010ADPE2K703adapte_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:54134 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030AbYBFVUo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 16:20:44 -0500
Received: from ADPE2K702.adaptec.com (adaptecpop.adaptec.com [10.25.8.26])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 23624243D9C
	for <linux-scsi@vger.kernel.org>; Wed,  6 Feb 2008 13:20:44 -0800 (PST)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F43982A010ADPE2K703adapte_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Added support for MSI utilizing the aacraid.msi=3D1 parameter. This patch a=
dds some localized or like-minded janitor fixes. Since the default is disab=
led, there is no impact on the code paths unless the customer wishes to exp=
eriment with the MSI performance.

This patch is against current scsi-misc-2.6

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's hand=
ling of patch attachments. Please use the attached file to patch, the inlin=
ed patch is a hand filtered diff -rub unusable to patch but usable for insp=
ection clarity.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/aachba.c  |   56 ++++++++++++++++++++++++++++++------=
-----
 drivers/scsi/aacraid/aacraid.h |    2 +
 drivers/scsi/aacraid/linit.c   |   32 ++++++++++++-----------
 drivers/scsi/aacraid/rx.c      |    5 ++-
 drivers/scsi/aacraid/sa.c      |    4 +-
 5 files changed, 66 insertions(+), 33 deletions(-)

diff -rub a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c     2008-02-06 15:33:31.356341806 -0500
+++ b/drivers/scsi/aacraid/aachba.c     2008-02-06 15:52:33.988699503 -0500
@@ -144,51 +144,77 @@
  */

 static int nondasd =3D -1;
-static int aac_cache =3D 0;
+static int aac_cache;
 static int dacmode =3D -1;
-
+int aac_msi;
 int aac_commit =3D -1;
 int startup_timeout =3D 180;
 int aif_timeout =3D 120;
@@ -159,6 +153,9 @@
 MODULE_PARM_DESC(dacmode, "Control whether dma addressing is using 64 bit =
DAC. 0=3Doff, 1=3Don");
 module_param_named(commit, aac_commit, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(commit, "Control whether a COMMIT_CONFIG is issued to the=
 adapter for foreign arrays.\nThis is typically needed in systems that do n=
ot have a BIOS. 0=3Doff, 1=3Don");
+module_param_named(msi, aac_msi, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(msi, "IRQ handling."
+       " 0=3DPIC(default), 1=3DMSI, 2=3DMSI-X(unsupported, uses MSI)");
 module_param(startup_timeout, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(startup_timeout, "The duration of time in seconds to wait=
 for adapter to have it's kernel up and\nrunning. This is typically adjuste=
d for large systems that do not have a BIOS.");
 module_param(aif_timeout, int, S_IRUGO|S_IWUSR);
@@ -181,7 +184,7 @@
 module_param(expose_physicals, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(expose_physicals, "Expose physical components of the arra=
ys. - 1=3Dprotect 0=3Doff, 1=3Don");

-int aac_reset_devices =3D 0;
+int aac_reset_devices;
 module_param_named(reset_devices, aac_reset_devices, int, S_IRUGO|S_IWUSR)=
;
 MODULE_PARM_DESC(reset_devices, "Force an adapter reset at initialization.=
");

diff -rub a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h    2008-02-06 15:33:31.357341679 -0500
+++ b/drivers/scsi/aacraid/aacraid.h    2008-02-06 15:44:11.908258253 -0500
@@ -1026,6 +1026,7 @@
        u8                      raw_io_64;
        u8                      printf_enabled;
        u8                      in_reset;
+       u8                      msi;
 };

 #define aac_adapter_interrupt(dev) \
@@ -1881,6 +1882,7 @@
 extern int aif_timeout;
 extern int expose_physicals;
 extern int aac_reset_devices;
+extern int aac_msi;
 extern int aac_commit;
 extern int update_interval;
 extern int check_interval;
diff -rub a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c      2008-02-06 15:33:31.358341553 -0500
+++ b/drivers/scsi/aacraid/linit.c      2008-02-06 15:44:11.908258253 -0500
@@ -1039,6 +1039,8 @@
        aac_send_shutdown(aac);
        aac_adapter_disable_int(aac);
        free_irq(aac->pdev->irq, aac);
+       if (aac->msi)
+               pci_disable_msi(aac->pdev);
 }

 static int __devinit aac_probe_one(struct pci_dev *pdev,
diff -rub a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
--- a/drivers/scsi/aacraid/rx.c 2008-02-06 15:33:31.359341426 -0500
+++ b/drivers/scsi/aacraid/rx.c 2008-02-06 15:44:11.909258127 -0500
@@ -625,8 +625,11 @@
        if (aac_init_adapter(dev) =3D=3D NULL)
                goto error_iounmap;
        aac_adapter_comm(dev, dev->comm_interface);
-       if (request_irq(dev->scsi_host_ptr->irq, dev->a_ops.adapter_intr,
+       dev->msi =3D aac_msi && !pci_enable_msi(dev->pdev);
+       if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
                        IRQF_SHARED|IRQF_DISABLED, "aacraid", dev) < 0) {
+               if (dev->msi)
+                       pci_disable_msi(dev->pdev);
                printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
                        name, instance);
                goto error_iounmap;
diff -rub a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
--- a/drivers/scsi/aacraid/sa.c 2008-02-06 15:33:31.359341426 -0500
+++ b/drivers/scsi/aacraid/sa.c 2008-02-06 15:44:11.909258127 -0500
@@ -385,7 +385,7 @@

        if(aac_init_adapter(dev) =3D=3D NULL)
                goto error_irq;
-       if (request_irq(dev->scsi_host_ptr->irq, dev->a_ops.adapter_intr,
+       if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
                        IRQF_SHARED|IRQF_DISABLED,
                        "aacraid", (void *)dev ) < 0) {
                printk(KERN_WARNING "%s%d: Interrupt unavailable.\n",
@@ -403,7 +403,7 @@

 error_irq:
        aac_sa_disable_interrupt(dev);
-       free_irq(dev->scsi_host_ptr->irq, (void *)dev);
+       free_irq(dev->pdev->irq, (void *)dev);

 error_iounmap:


--_002_532ABFBDAAC3A34EB12EBA6CEC2838F43982A010ADPE2K703adapte_
Content-Type: application/octet-stream; name="aacraid_msi.patch"
Content-Description: aacraid_msi.patch
Content-Disposition: attachment; filename="aacraid_msi.patch"; size=9812;
	creation-date="Wed, 06 Feb 2008 12:53:22 GMT";
	modification-date="Wed, 06 Feb 2008 12:53:22 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDgt
MDItMDYgMTU6MzM6MzEuMzU2MzQxODA2IC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDgtMDItMDYgMTU6NTI6MzMuOTg4Njk5NTAzIC0wNTAwCkBAIC0xNDQsNTEg
KzE0NCw3NyBAQAogICovCiAKIHN0YXRpYyBpbnQgbm9uZGFzZCA9IC0xOwotc3RhdGljIGludCBh
YWNfY2FjaGUgPSAwOworc3RhdGljIGludCBhYWNfY2FjaGU7CiBzdGF0aWMgaW50IGRhY21vZGUg
PSAtMTsKLQoraW50IGFhY19tc2k7CiBpbnQgYWFjX2NvbW1pdCA9IC0xOwogaW50IHN0YXJ0dXBf
dGltZW91dCA9IDE4MDsKIGludCBhaWZfdGltZW91dCA9IDEyMDsKIAogbW9kdWxlX3BhcmFtKG5v
bmRhc2QsIGludCwgU19JUlVHT3xTX0lXVVNSKTsKLU1PRFVMRV9QQVJNX0RFU0Mobm9uZGFzZCwg
IkNvbnRyb2wgc2Nhbm5pbmcgb2YgaGJhIGZvciBub25kYXNkIGRldmljZXMuIDA9b2ZmLCAxPW9u
Iik7CitNT0RVTEVfUEFSTV9ERVNDKG5vbmRhc2QsICJDb250cm9sIHNjYW5uaW5nIG9mIGhiYSBm
b3Igbm9uZGFzZCBkZXZpY2VzLiIKKwkiIDA9b2ZmLCAxPW9uIik7CiBtb2R1bGVfcGFyYW1fbmFt
ZWQoY2FjaGUsIGFhY19jYWNoZSwgaW50LCBTX0lSVUdPfFNfSVdVU1IpOwotTU9EVUxFX1BBUk1f
REVTQyhjYWNoZSwgIkRpc2FibGUgUXVldWUgRmx1c2ggY29tbWFuZHM6XG5cdGJpdCAwIC0gRGlz
YWJsZSBGVUEgaW4gV1JJVEUgU0NTSSBjb21tYW5kc1xuXHRiaXQgMSAtIERpc2FibGUgU1lOQ0hS
T05JWkVfQ0FDSEUgU0NTSSBjb21tYW5kXG5cdGJpdCAyIC0gRGlzYWJsZSBvbmx5IGlmIEJhdHRl
cnkgbm90IHByb3RlY3RpbmcgQ2FjaGUiKTsKK01PRFVMRV9QQVJNX0RFU0MoY2FjaGUsICJEaXNh
YmxlIFF1ZXVlIEZsdXNoIGNvbW1hbmRzOlxuIgorCSJcdGJpdCAwIC0gRGlzYWJsZSBGVUEgaW4g
V1JJVEUgU0NTSSBjb21tYW5kc1xuIgorCSJcdGJpdCAxIC0gRGlzYWJsZSBTWU5DSFJPTklaRV9D
QUNIRSBTQ1NJIGNvbW1hbmRcbiIKKwkiXHRiaXQgMiAtIERpc2FibGUgb25seSBpZiBCYXR0ZXJ5
IG5vdCBwcm90ZWN0aW5nIENhY2hlIik7CiBtb2R1bGVfcGFyYW0oZGFjbW9kZSwgaW50LCBTX0lS
VUdPfFNfSVdVU1IpOwotTU9EVUxFX1BBUk1fREVTQyhkYWNtb2RlLCAiQ29udHJvbCB3aGV0aGVy
IGRtYSBhZGRyZXNzaW5nIGlzIHVzaW5nIDY0IGJpdCBEQUMuIDA9b2ZmLCAxPW9uIik7CitNT0RV
TEVfUEFSTV9ERVNDKGRhY21vZGUsICJDb250cm9sIHdoZXRoZXIgZG1hIGFkZHJlc3NpbmcgaXMg
dXNpbmcgNjQgYml0IERBQy4iCisJIiAwPW9mZiwgMT1vbiIpOwogbW9kdWxlX3BhcmFtX25hbWVk
KGNvbW1pdCwgYWFjX2NvbW1pdCwgaW50LCBTX0lSVUdPfFNfSVdVU1IpOwotTU9EVUxFX1BBUk1f
REVTQyhjb21taXQsICJDb250cm9sIHdoZXRoZXIgYSBDT01NSVRfQ09ORklHIGlzIGlzc3VlZCB0
byB0aGUgYWRhcHRlciBmb3IgZm9yZWlnbiBhcnJheXMuXG5UaGlzIGlzIHR5cGljYWxseSBuZWVk
ZWQgaW4gc3lzdGVtcyB0aGF0IGRvIG5vdCBoYXZlIGEgQklPUy4gMD1vZmYsIDE9b24iKTsKK01P
RFVMRV9QQVJNX0RFU0MoY29tbWl0LCAiQ29udHJvbCB3aGV0aGVyIGEgQ09NTUlUX0NPTkZJRyBp
cyBpc3N1ZWQgdG8gdGhlIgorCSIgYWRhcHRlciBmb3IgZm9yZWlnbiBhcnJheXMuXG4iCisJIlRo
aXMgaXMgdHlwaWNhbGx5IG5lZWRlZCBpbiBzeXN0ZW1zIHRoYXQgZG8gbm90IGhhdmUgYSBCSU9T
LiIKKwkiIDA9b2ZmLCAxPW9uIik7Cittb2R1bGVfcGFyYW1fbmFtZWQobXNpLCBhYWNfbXNpLCBp
bnQsIFNfSVJVR098U19JV1VTUik7CitNT0RVTEVfUEFSTV9ERVNDKG1zaSwgIklSUSBoYW5kbGlu
Zy4iCisJIiAwPVBJQyhkZWZhdWx0KSwgMT1NU0ksIDI9TVNJLVgodW5zdXBwb3J0ZWQsIHVzZXMg
TVNJKSIpOwogbW9kdWxlX3BhcmFtKHN0YXJ0dXBfdGltZW91dCwgaW50LCBTX0lSVUdPfFNfSVdV
U1IpOwotTU9EVUxFX1BBUk1fREVTQyhzdGFydHVwX3RpbWVvdXQsICJUaGUgZHVyYXRpb24gb2Yg
dGltZSBpbiBzZWNvbmRzIHRvIHdhaXQgZm9yIGFkYXB0ZXIgdG8gaGF2ZSBpdCdzIGtlcm5lbCB1
cCBhbmRcbnJ1bm5pbmcuIFRoaXMgaXMgdHlwaWNhbGx5IGFkanVzdGVkIGZvciBsYXJnZSBzeXN0
ZW1zIHRoYXQgZG8gbm90IGhhdmUgYSBCSU9TLiIpOworTU9EVUxFX1BBUk1fREVTQyhzdGFydHVw
X3RpbWVvdXQsICJUaGUgZHVyYXRpb24gb2YgdGltZSBpbiBzZWNvbmRzIHRvIHdhaXQgZm9yIgor
CSIgYWRhcHRlciB0byBoYXZlIGl0J3Mga2VybmVsIHVwIGFuZFxuIgorCSJydW5uaW5nLiBUaGlz
IGlzIHR5cGljYWxseSBhZGp1c3RlZCBmb3IgbGFyZ2Ugc3lzdGVtcyB0aGF0IGRvIG5vdCIKKwki
IGhhdmUgYSBCSU9TLiIpOwogbW9kdWxlX3BhcmFtKGFpZl90aW1lb3V0LCBpbnQsIFNfSVJVR098
U19JV1VTUik7Ci1NT0RVTEVfUEFSTV9ERVNDKGFpZl90aW1lb3V0LCAiVGhlIGR1cmF0aW9uIG9m
IHRpbWUgaW4gc2Vjb25kcyB0byB3YWl0IGZvciBhcHBsaWNhdGlvbnMgdG8gcGljayB1cCBBSUZz
IGJlZm9yZVxuZGVyZWdpc3RlcmluZyB0aGVtLiBUaGlzIGlzIHR5cGljYWxseSBhZGp1c3RlZCBm
b3IgaGVhdmlseSBidXJkZW5lZCBzeXN0ZW1zLiIpOworTU9EVUxFX1BBUk1fREVTQyhhaWZfdGlt
ZW91dCwgIlRoZSBkdXJhdGlvbiBvZiB0aW1lIGluIHNlY29uZHMgdG8gd2FpdCBmb3IiCisJIiBh
cHBsaWNhdGlvbnMgdG8gcGljayB1cCBBSUZzIGJlZm9yZVxuIgorCSJkZXJlZ2lzdGVyaW5nIHRo
ZW0uIFRoaXMgaXMgdHlwaWNhbGx5IGFkanVzdGVkIGZvciBoZWF2aWx5IGJ1cmRlbmVkIgorCSIg
c3lzdGVtcy4iKTsKIAogaW50IG51bWFjYiA9IC0xOwogbW9kdWxlX3BhcmFtKG51bWFjYiwgaW50
LCBTX0lSVUdPfFNfSVdVU1IpOwotTU9EVUxFX1BBUk1fREVTQyhudW1hY2IsICJSZXF1ZXN0IGEg
bGltaXQgdG8gdGhlIG51bWJlciBvZiBhZGFwdGVyIGNvbnRyb2wgYmxvY2tzIChGSUIpIGFsbG9j
YXRlZC4gVmFsaWQgdmFsdWVzIGFyZSA1MTIgYW5kIGRvd24uIERlZmF1bHQgaXMgdG8gdXNlIHN1
Z2dlc3Rpb24gZnJvbSBGaXJtd2FyZS4iKTsKK01PRFVMRV9QQVJNX0RFU0MobnVtYWNiLCAiUmVx
dWVzdCBhIGxpbWl0IHRvIHRoZSBudW1iZXIgb2YgYWRhcHRlciBjb250cm9sIgorCSIgYmxvY2tz
IChGSUIpIGFsbG9jYXRlZC4gVmFsaWQgdmFsdWVzIGFyZSA1MTIgYW5kIGRvd24uIERlZmF1bHQg
aXMiCisJIiB0byB1c2Ugc3VnZ2VzdGlvbiBmcm9tIEZpcm13YXJlLiIpOwogCiBpbnQgYWNic2l6
ZSA9IC0xOwogbW9kdWxlX3BhcmFtKGFjYnNpemUsIGludCwgU19JUlVHT3xTX0lXVVNSKTsKLU1P
RFVMRV9QQVJNX0RFU0MoYWNic2l6ZSwgIlJlcXVlc3QgYSBzcGVjaWZpYyBhZGFwdGVyIGNvbnRy
b2wgYmxvY2sgKEZJQikgc2l6ZS4gVmFsaWQgdmFsdWVzIGFyZSA1MTIsIDIwNDgsIDQwOTYgYW5k
IDgxOTIuIERlZmF1bHQgaXMgdG8gdXNlIHN1Z2dlc3Rpb24gZnJvbSBGaXJtd2FyZS4iKTsKK01P
RFVMRV9QQVJNX0RFU0MoYWNic2l6ZSwgIlJlcXVlc3QgYSBzcGVjaWZpYyBhZGFwdGVyIGNvbnRy
b2wgYmxvY2sgKEZJQikiCisJIiBzaXplLiBWYWxpZCB2YWx1ZXMgYXJlIDUxMiwgMjA0OCwgNDA5
NiBhbmQgODE5Mi4gRGVmYXVsdCBpcyB0byB1c2UiCisJIiBzdWdnZXN0aW9uIGZyb20gRmlybXdh
cmUuIik7CiAKIGludCB1cGRhdGVfaW50ZXJ2YWwgPSAzMCAqIDYwOwogbW9kdWxlX3BhcmFtKHVw
ZGF0ZV9pbnRlcnZhbCwgaW50LCBTX0lSVUdPfFNfSVdVU1IpOwotTU9EVUxFX1BBUk1fREVTQyh1
cGRhdGVfaW50ZXJ2YWwsICJJbnRlcnZhbCBpbiBzZWNvbmRzIGJldHdlZW4gdGltZSBzeW5jIHVw
ZGF0ZXMgaXNzdWVkIHRvIGFkYXB0ZXIuIik7CitNT0RVTEVfUEFSTV9ERVNDKHVwZGF0ZV9pbnRl
cnZhbCwgIkludGVydmFsIGluIHNlY29uZHMgYmV0d2VlbiB0aW1lIHN5bmMiCisJIiB1cGRhdGVz
IGlzc3VlZCB0byBhZGFwdGVyLiIpOwogCiBpbnQgY2hlY2tfaW50ZXJ2YWwgPSAyNCAqIDYwICog
NjA7CiBtb2R1bGVfcGFyYW0oY2hlY2tfaW50ZXJ2YWwsIGludCwgU19JUlVHT3xTX0lXVVNSKTsK
LU1PRFVMRV9QQVJNX0RFU0MoY2hlY2tfaW50ZXJ2YWwsICJJbnRlcnZhbCBpbiBzZWNvbmRzIGJl
dHdlZW4gYWRhcHRlciBoZWFsdGggY2hlY2tzLiIpOworTU9EVUxFX1BBUk1fREVTQyhjaGVja19p
bnRlcnZhbCwgIkludGVydmFsIGluIHNlY29uZHMgYmV0d2VlbiBhZGFwdGVyIGhlYWx0aCIKKwki
IGNoZWNrcy4iKTsKIAogaW50IGFhY19jaGVja19yZXNldCA9IDE7CiBtb2R1bGVfcGFyYW1fbmFt
ZWQoY2hlY2tfcmVzZXQsIGFhY19jaGVja19yZXNldCwgaW50LCBTX0lSVUdPfFNfSVdVU1IpOwot
TU9EVUxFX1BBUk1fREVTQyhhYWNfY2hlY2tfcmVzZXQsICJJZiBhZGFwdGVyIGZhaWxzIGhlYWx0
aCBjaGVjaywgcmVzZXQgdGhlIGFkYXB0ZXIuIGEgdmFsdWUgb2YgLTEgZm9yY2VzIHRoZSByZXNl
dCB0byBhZGFwdGVycyBwcm9ncmFtbWVkIHRvIGlnbm9yZSBpdC4iKTsKK01PRFVMRV9QQVJNX0RF
U0MoYWFjX2NoZWNrX3Jlc2V0LCAiSWYgYWRhcHRlciBmYWlscyBoZWFsdGggY2hlY2ssIHJlc2V0
IHRoZSIKKwkiIGFkYXB0ZXIuIGEgdmFsdWUgb2YgLTEgZm9yY2VzIHRoZSByZXNldCB0byBhZGFw
dGVycyBwcm9ncmFtbWVkIHRvIgorCSIgaWdub3JlIGl0LiIpOwogCiBpbnQgZXhwb3NlX3BoeXNp
Y2FscyA9IC0xOwogbW9kdWxlX3BhcmFtKGV4cG9zZV9waHlzaWNhbHMsIGludCwgU19JUlVHT3xT
X0lXVVNSKTsKLU1PRFVMRV9QQVJNX0RFU0MoZXhwb3NlX3BoeXNpY2FscywgIkV4cG9zZSBwaHlz
aWNhbCBjb21wb25lbnRzIG9mIHRoZSBhcnJheXMuIC0xPXByb3RlY3QgMD1vZmYsIDE9b24iKTsK
K01PRFVMRV9QQVJNX0RFU0MoZXhwb3NlX3BoeXNpY2FscywgIkV4cG9zZSBwaHlzaWNhbCBjb21w
b25lbnRzIG9mIHRoZSBhcnJheXMuIgorCSIgLTE9cHJvdGVjdCAwPW9mZiwgMT1vbiIpOwogCi1p
bnQgYWFjX3Jlc2V0X2RldmljZXMgPSAwOworaW50IGFhY19yZXNldF9kZXZpY2VzOwogbW9kdWxl
X3BhcmFtX25hbWVkKHJlc2V0X2RldmljZXMsIGFhY19yZXNldF9kZXZpY2VzLCBpbnQsIFNfSVJV
R098U19JV1VTUik7CiBNT0RVTEVfUEFSTV9ERVNDKHJlc2V0X2RldmljZXMsICJGb3JjZSBhbiBh
ZGFwdGVyIHJlc2V0IGF0IGluaXRpYWxpemF0aW9uLiIpOwogCmRpZmYgLXJ1IGEvZHJpdmVycy9z
Y3NpL2FhY3JhaWQvYWFjcmFpZC5oIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvYWFjcmFpZC5oCi0t
LSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY3JhaWQuaAkyMDA4LTAyLTA2IDE1OjMzOjMxLjM1
NzM0MTY3OSAtMDUwMAorKysgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNyYWlkLmgJMjAwOC0w
Mi0wNiAxNTo0NDoxMS45MDgyNTgyNTMgLTA1MDAKQEAgLTEwMjYsNiArMTAyNiw3IEBACiAJdTgJ
CQlyYXdfaW9fNjQ7CiAJdTgJCQlwcmludGZfZW5hYmxlZDsKIAl1OAkJCWluX3Jlc2V0OworCXU4
CQkJbXNpOwogfTsKIAogI2RlZmluZSBhYWNfYWRhcHRlcl9pbnRlcnJ1cHQoZGV2KSBcCkBAIC0x
ODgxLDYgKzE4ODIsNyBAQAogZXh0ZXJuIGludCBhaWZfdGltZW91dDsKIGV4dGVybiBpbnQgZXhw
b3NlX3BoeXNpY2FsczsKIGV4dGVybiBpbnQgYWFjX3Jlc2V0X2RldmljZXM7CitleHRlcm4gaW50
IGFhY19tc2k7CiBleHRlcm4gaW50IGFhY19jb21taXQ7CiBleHRlcm4gaW50IHVwZGF0ZV9pbnRl
cnZhbDsKIGV4dGVybiBpbnQgY2hlY2tfaW50ZXJ2YWw7CmRpZmYgLXJ1IGEvZHJpdmVycy9zY3Np
L2FhY3JhaWQvbGluaXQuYyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xpbml0LmMKLS0tIGEvZHJp
dmVycy9zY3NpL2FhY3JhaWQvbGluaXQuYwkyMDA4LTAyLTA2IDE1OjMzOjMxLjM1ODM0MTU1MyAt
MDUwMAorKysgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIwMDgtMDItMDYgMTU6NDQ6
MTEuOTA4MjU4MjUzIC0wNTAwCkBAIC0yNzUsOSArMjc1LDkgQEAKIAogLyoqCiAgKglhYWNfZ2V0
X2RyaXZlcl9pZGVudAotICogCUBkZXZ0eXBlOiBpbmRleCBpbnRvIGxvb2t1cCB0YWJsZQorICoJ
QGRldnR5cGU6IGluZGV4IGludG8gbG9va3VwIHRhYmxlCiAgKgotICogCVJldHVybnMgYSBwb2lu
dGVyIHRvIHRoZSBlbnRyeSBpbiB0aGUgZHJpdmVyIGxvb2t1cCB0YWJsZS4KKyAqCVJldHVybnMg
YSBwb2ludGVyIHRvIHRoZSBlbnRyeSBpbiB0aGUgZHJpdmVyIGxvb2t1cCB0YWJsZS4KICAqLwog
CiBzdHJ1Y3QgYWFjX2RyaXZlcl9pZGVudCogYWFjX2dldF9kcml2ZXJfaWRlbnQoaW50IGRldnR5
cGUpCkBAIC0xMDA0LDMyICsxMDA0LDMyIEBACiAKIHN0YXRpYyBzdHJ1Y3Qgc2NzaV9ob3N0X3Rl
bXBsYXRlIGFhY19kcml2ZXJfdGVtcGxhdGUgPSB7CiAJLm1vZHVsZQkJCQk9IFRISVNfTU9EVUxF
LAotCS5uYW1lICAgICAgICAgICAJCT0gIkFBQyIsCisJLm5hbWUJCQkJPSAiQUFDIiwKIAkucHJv
Y19uYW1lCQkJPSBBQUNfRFJJVkVSTkFNRSwKLQkuaW5mbyAgICAgICAgICAgCQk9IGFhY19pbmZv
LAotCS5pb2N0bCAgICAgICAgICAJCT0gYWFjX2lvY3RsLAorCS5pbmZvCQkJCT0gYWFjX2luZm8s
CisJLmlvY3RsCQkJCT0gYWFjX2lvY3RsLAogI2lmZGVmIENPTkZJR19DT01QQVQKIAkuY29tcGF0
X2lvY3RsCQkJPSBhYWNfY29tcGF0X2lvY3RsLAogI2VuZGlmCi0JLnF1ZXVlY29tbWFuZCAgIAkJ
PSBhYWNfcXVldWVjb21tYW5kLAotCS5iaW9zX3BhcmFtICAgICAJCT0gYWFjX2Jpb3NwYXJtLAor
CS5xdWV1ZWNvbW1hbmQJCQk9IGFhY19xdWV1ZWNvbW1hbmQsCisJLmJpb3NfcGFyYW0JCQk9IGFh
Y19iaW9zcGFybSwKIAkuc2hvc3RfYXR0cnMJCQk9IGFhY19hdHRycywKIAkuc2xhdmVfY29uZmln
dXJlCQk9IGFhY19zbGF2ZV9jb25maWd1cmUsCiAJLmNoYW5nZV9xdWV1ZV9kZXB0aAkJPSBhYWNf
Y2hhbmdlX3F1ZXVlX2RlcHRoLAogCS5zZGV2X2F0dHJzCQkJPSBhYWNfZGV2X2F0dHJzLAogCS5l
aF9hYm9ydF9oYW5kbGVyCQk9IGFhY19laF9hYm9ydCwKIAkuZWhfaG9zdF9yZXNldF9oYW5kbGVy
CQk9IGFhY19laF9yZXNldCwKLQkuY2FuX3F1ZXVlICAgICAgCQk9IEFBQ19OVU1fSU9fRklCLAot
CS50aGlzX2lkICAgICAgICAJCT0gTUFYSU1VTV9OVU1fQ09OVEFJTkVSUywKLQkuc2dfdGFibGVz
aXplICAgCQk9IDE2LAotCS5tYXhfc2VjdG9ycyAgICAJCT0gMTI4LAorCS5jYW5fcXVldWUJCQk9
IEFBQ19OVU1fSU9fRklCLAorCS50aGlzX2lkCQkJPSBNQVhJTVVNX05VTV9DT05UQUlORVJTLAor
CS5zZ190YWJsZXNpemUJCQk9IDE2LAorCS5tYXhfc2VjdG9ycwkJCT0gMTI4LAogI2lmIChBQUNf
TlVNX0lPX0ZJQiA+IDI1NikKIAkuY21kX3Blcl9sdW4JCQk9IDI1NiwKICNlbHNlCi0JLmNtZF9w
ZXJfbHVuICAgIAkJPSBBQUNfTlVNX0lPX0ZJQiwKKwkuY21kX3Blcl9sdW4JCQk9IEFBQ19OVU1f
SU9fRklCLAogI2VuZGlmCiAJLnVzZV9jbHVzdGVyaW5nCQkJPSBFTkFCTEVfQ0xVU1RFUklORywK
LQkuZW11bGF0ZWQgICAgICAgICAgICAgICAgICAgICAgID0gMSwKKwkuZW11bGF0ZWQJCQk9IDEs
CiB9OwogCiBzdGF0aWMgdm9pZCBfX2FhY19zaHV0ZG93bihzdHJ1Y3QgYWFjX2RldiAqIGFhYykK
QEAgLTEwMzksNiArMTAzOSw4IEBACiAJYWFjX3NlbmRfc2h1dGRvd24oYWFjKTsKIAlhYWNfYWRh
cHRlcl9kaXNhYmxlX2ludChhYWMpOwogCWZyZWVfaXJxKGFhYy0+cGRldi0+aXJxLCBhYWMpOwor
CWlmIChhYWMtPm1zaSkKKwkJcGNpX2Rpc2FibGVfbXNpKGFhYy0+cGRldik7CiB9CiAKIHN0YXRp
YyBpbnQgX19kZXZpbml0IGFhY19wcm9iZV9vbmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsCkBAIC0x
MjU0LDcgKzEyNTYsNyBAQAogCS5pZF90YWJsZQk9IGFhY19wY2lfdGJsLAogCS5wcm9iZQkJPSBh
YWNfcHJvYmVfb25lLAogCS5yZW1vdmUJCT0gX19kZXZleGl0X3AoYWFjX3JlbW92ZV9vbmUpLAot
CS5zaHV0ZG93biAJPSBhYWNfc2h1dGRvd24sCisJLnNodXRkb3duCT0gYWFjX3NodXRkb3duLAog
fTsKIAogc3RhdGljIGludCBfX2luaXQgYWFjX2luaXQodm9pZCkKQEAgLTEyNzEsNyArMTI3Myw3
IEBACiAJYWFjX2NmZ19tYWpvciA9IHJlZ2lzdGVyX2NocmRldiggMCwgImFhYyIsICZhYWNfY2Zn
X2ZvcHMpOwogCWlmIChhYWNfY2ZnX21ham9yIDwgMCkgewogCQlwcmludGsoS0VSTl9XQVJOSU5H
Ci0JCSAgICAgICAiYWFjcmFpZDogdW5hYmxlIHRvIHJlZ2lzdGVyIFwiYWFjXCIgZGV2aWNlLlxu
Iik7CisJCQkiYWFjcmFpZDogdW5hYmxlIHRvIHJlZ2lzdGVyIFwiYWFjXCIgZGV2aWNlLlxuIik7
CiAJfQogCiAJcmV0dXJuIDA7CmRpZmYgLXJ1IGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvcnguYyBi
L2RyaXZlcnMvc2NzaS9hYWNyYWlkL3J4LmMKLS0tIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvcngu
YwkyMDA4LTAyLTA2IDE1OjMzOjMxLjM1OTM0MTQyNiAtMDUwMAorKysgYi9kcml2ZXJzL3Njc2kv
YWFjcmFpZC9yeC5jCTIwMDgtMDItMDYgMTU6NDQ6MTEuOTA5MjU4MTI3IC0wNTAwCkBAIC02MjUs
OCArNjI1LDExIEBACiAJaWYgKGFhY19pbml0X2FkYXB0ZXIoZGV2KSA9PSBOVUxMKQogCQlnb3Rv
IGVycm9yX2lvdW5tYXA7CiAJYWFjX2FkYXB0ZXJfY29tbShkZXYsIGRldi0+Y29tbV9pbnRlcmZh
Y2UpOwotCWlmIChyZXF1ZXN0X2lycShkZXYtPnNjc2lfaG9zdF9wdHItPmlycSwgZGV2LT5hX29w
cy5hZGFwdGVyX2ludHIsCisJZGV2LT5tc2kgPSBhYWNfbXNpICYmICFwY2lfZW5hYmxlX21zaShk
ZXYtPnBkZXYpOworCWlmIChyZXF1ZXN0X2lycShkZXYtPnBkZXYtPmlycSwgZGV2LT5hX29wcy5h
ZGFwdGVyX2ludHIsCiAJCQlJUlFGX1NIQVJFRHxJUlFGX0RJU0FCTEVELCAiYWFjcmFpZCIsIGRl
dikgPCAwKSB7CisJCWlmIChkZXYtPm1zaSkKKwkJCXBjaV9kaXNhYmxlX21zaShkZXYtPnBkZXYp
OwogCQlwcmludGsoS0VSTl9FUlIgIiVzJWQ6IEludGVycnVwdCB1bmF2YWlsYWJsZS5cbiIsCiAJ
CQluYW1lLCBpbnN0YW5jZSk7CiAJCWdvdG8gZXJyb3JfaW91bm1hcDsKZGlmZiAtcnUgYS9kcml2
ZXJzL3Njc2kvYWFjcmFpZC9zYS5jIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvc2EuYwotLS0gYS9k
cml2ZXJzL3Njc2kvYWFjcmFpZC9zYS5jCTIwMDgtMDItMDYgMTU6MzM6MzEuMzU5MzQxNDI2IC0w
NTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3NhLmMJMjAwOC0wMi0wNiAxNTo0NDoxMS45
MDkyNTgxMjcgLTA1MDAKQEAgLTM4NSw3ICszODUsNyBAQAogCiAJaWYoYWFjX2luaXRfYWRhcHRl
cihkZXYpID09IE5VTEwpCiAJCWdvdG8gZXJyb3JfaXJxOwotCWlmIChyZXF1ZXN0X2lycShkZXYt
PnNjc2lfaG9zdF9wdHItPmlycSwgZGV2LT5hX29wcy5hZGFwdGVyX2ludHIsCisJaWYgKHJlcXVl
c3RfaXJxKGRldi0+cGRldi0+aXJxLCBkZXYtPmFfb3BzLmFkYXB0ZXJfaW50ciwKIAkJCUlSUUZf
U0hBUkVEfElSUUZfRElTQUJMRUQsCiAJCQkiYWFjcmFpZCIsICh2b2lkICopZGV2ICkgPCAwKSB7
CiAJCXByaW50ayhLRVJOX1dBUk5JTkcgIiVzJWQ6IEludGVycnVwdCB1bmF2YWlsYWJsZS5cbiIs
CkBAIC00MDMsNyArNDAzLDcgQEAKIAogZXJyb3JfaXJxOgogCWFhY19zYV9kaXNhYmxlX2ludGVy
cnVwdChkZXYpOwotCWZyZWVfaXJxKGRldi0+c2NzaV9ob3N0X3B0ci0+aXJxLCAodm9pZCAqKWRl
dik7CisJZnJlZV9pcnEoZGV2LT5wZGV2LT5pcnEsICh2b2lkICopZGV2KTsKIAogZXJyb3JfaW91
bm1hcDoKIAo=

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F43982A010ADPE2K703adapte_--
