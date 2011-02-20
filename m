From: adam radford <aradford@gmail.com>
Subject: [PATCH 15/15] megaraid_sas: Documentation and Changelog update
Date: Sat, 19 Feb 2011 18:23:32 -0800
Message-ID: <AANLkTinhBLopkSiz27PC9BGEMV6RhiijHCzjWzhfJsgK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001485f6c5ee01cc2f049cad6fb1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55470 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1BTCXd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 21:23:33 -0500
Received: by wwa36 with SMTP id 36so5037643wwa.1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2011 18:23:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--001485f6c5ee01cc2f049cad6fb1
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas updates the
ChangeLog.megaraid_sas file and driver version of the megaraid_sas
driver.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur linux-2.6.38-rc5/Documentation/scsi/ChangeLog.megaraid_sas
linux-2.6.38-rc5.new/Documentation/scsi/ChangeLog.megaraid_sas
--- linux-2.6.38-rc5/Documentation/scsi/ChangeLog.megaraid_sas	2011-02-15
19:23:45.000000000 -0800
+++ linux-2.6.38-rc5.new/Documentation/scsi/ChangeLog.megaraid_sas	2011-02-19
15:18:21.752426376 -0800
@@ -1,3 +1,29 @@
+Release Date    : Sat. Feb 19, 2011 17:00:00 PST 2010 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Adam Radford
+Current Version : 00.00.05.33-rc1
+Old Version     : 00.00.05.29-rc1
+    1. Fix some failure gotos from megasas_probe_one(), etc.
+    2. Add missing check_and_restore_queue_depth() call in
+       complete_cmd_fusion().
+    3. Enable MSI-X before calling megasas_init_fw().
+    4. Call tasklet_schedule() even if outbound_intr_status == 0 for MFI based
+       boards in MSI-X mode.
+    5. Fix megasas_probe_one() to clear PCI_MSIX_FLAGS_ENABLE in msi control
+       register in kdump kernel.
+    6. Fix megasas_get_cmd() to only print "Command pool empty" if
+       megasas_dbg_lvl is set.
+    7. Sanity check user spplied length in megasas_mgmt_fw_ioctl() to prevent
+       NULL pointer dereference in dma_alloc_coherent() when running
+       smartmontools.
+    8. Fix megasas_build_dcdb_fusion() to not filter by TYPE_DISK.
+    9. Fix megasas_build_dcdb_fusion() to use io_request->LUN[1] field.
+    10. Add MR_EVT_CFG_CLEARED to megasas_aen_polling().
+    11. Fix tasklet_init() in megasas_init_fw() to use instancet->tasklet.
+    12. Fix fault state handling in megasas_transition_to_ready().
+    13. Fix max_sectors setting for IEEE SGL's.
+    14. Fix iMR OCR support to work correctly.
+-------------------------------------------------------------------------------
 Release Date    : Tues.  Dec 14, 2010 17:00:00 PST 2010 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Adam Radford
diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
15:09:04.782332317 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
15:10:40.667362798 -0800
@@ -18,12 +18,13 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : v00.00.05.29-rc1
+ *  Version : v00.00.05.33-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
  *           Sumant Patro
  *           Bo Yang
+ *           Adam Radford <linuxraid@lsi.com>
  *
  *  Send feedback to: <megaraidlinux@lsi.com>
  *
diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas.h
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas.h	2011-02-19
14:39:15.186332469 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas.h	2011-02-19
15:09:56.409364538 -0800
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.05.29-rc1"
-#define MEGASAS_RELDATE				"Dec. 7, 2010"
-#define MEGASAS_EXT_VERSION			"Tue. Dec. 7 17:00:00 PDT 2010"
+#define MEGASAS_VERSION				"00.00.05.33-rc1"
+#define MEGASAS_RELDATE				"Feb. 19, 2011"
+#define MEGASAS_EXT_VERSION			"Sat. Feb. 19 17:00:00 PDT 2011"

 /*
  * Device IDs

--001485f6c5ee01cc2f049cad6fb1
Content-Type: application/octet-stream; name="megaraid_sas.patch15"
Content-Disposition: attachment; filename="megaraid_sas.patch15"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkdblgdq0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cu
bWVnYXJhaWRfc2FzIGxpbnV4LTIuNi4zOC1yYzUubmV3L0RvY3VtZW50YXRpb24vc2NzaS9DaGFu
Z2VMb2cubWVnYXJhaWRfc2FzCi0tLSBsaW51eC0yLjYuMzgtcmM1L0RvY3VtZW50YXRpb24vc2Nz
aS9DaGFuZ2VMb2cubWVnYXJhaWRfc2FzCTIwMTEtMDItMTUgMTk6MjM6NDUuMDAwMDAwMDAwIC0w
ODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5ldy9Eb2N1bWVudGF0aW9uL3Njc2kvQ2hhbmdlTG9n
Lm1lZ2FyYWlkX3NhcwkyMDExLTAyLTE5IDE1OjE4OjIxLjc1MjQyNjM3NiAtMDgwMApAQCAtMSwz
ICsxLDI5IEBACitSZWxlYXNlIERhdGUgICAgOiBTYXQuIEZlYiAxOSwgMjAxMSAxNzowMDowMCBQ
U1QgMjAxMCAtCisJCQkoZW1haWxkLWlkOm1lZ2FyYWlkbGludXhAbHNpLmNvbSkKKwkJCUFkYW0g
UmFkZm9yZAorQ3VycmVudCBWZXJzaW9uIDogMDAuMDAuMDUuMzMtcmMxCitPbGQgVmVyc2lvbiAg
ICAgOiAwMC4wMC4wNS4yOS1yYzEKKyAgICAxLiBGaXggc29tZSBmYWlsdXJlIGdvdG9zIGZyb20g
bWVnYXNhc19wcm9iZV9vbmUoKSwgZXRjLgorICAgIDIuIEFkZCBtaXNzaW5nIGNoZWNrX2FuZF9y
ZXN0b3JlX3F1ZXVlX2RlcHRoKCkgY2FsbCBpbgorICAgICAgIGNvbXBsZXRlX2NtZF9mdXNpb24o
KS4KKyAgICAzLiBFbmFibGUgTVNJLVggYmVmb3JlIGNhbGxpbmcgbWVnYXNhc19pbml0X2Z3KCku
CisgICAgNC4gQ2FsbCB0YXNrbGV0X3NjaGVkdWxlKCkgZXZlbiBpZiBvdXRib3VuZF9pbnRyX3N0
YXR1cyA9PSAwIGZvciBNRkkgYmFzZWQKKyAgICAgICBib2FyZHMgaW4gTVNJLVggbW9kZS4KKyAg
ICA1LiBGaXggbWVnYXNhc19wcm9iZV9vbmUoKSB0byBjbGVhciBQQ0lfTVNJWF9GTEFHU19FTkFC
TEUgaW4gbXNpIGNvbnRyb2wKKyAgICAgICByZWdpc3RlciBpbiBrZHVtcCBrZXJuZWwuCisgICAg
Ni4gRml4IG1lZ2FzYXNfZ2V0X2NtZCgpIHRvIG9ubHkgcHJpbnQgIkNvbW1hbmQgcG9vbCBlbXB0
eSIgaWYKKyAgICAgICBtZWdhc2FzX2RiZ19sdmwgaXMgc2V0LgorICAgIDcuIFNhbml0eSBjaGVj
ayB1c2VyIHNwcGxpZWQgbGVuZ3RoIGluIG1lZ2FzYXNfbWdtdF9md19pb2N0bCgpIHRvIHByZXZl
bnQKKyAgICAgICBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UgaW4gZG1hX2FsbG9jX2NvaGVyZW50
KCkgd2hlbiBydW5uaW5nCisgICAgICAgc21hcnRtb250b29scy4KKyAgICA4LiBGaXggbWVnYXNh
c19idWlsZF9kY2RiX2Z1c2lvbigpIHRvIG5vdCBmaWx0ZXIgYnkgVFlQRV9ESVNLLgorICAgIDku
IEZpeCBtZWdhc2FzX2J1aWxkX2RjZGJfZnVzaW9uKCkgdG8gdXNlIGlvX3JlcXVlc3QtPkxVTlsx
XSBmaWVsZC4KKyAgICAxMC4gQWRkIE1SX0VWVF9DRkdfQ0xFQVJFRCB0byBtZWdhc2FzX2Flbl9w
b2xsaW5nKCkuCisgICAgMTEuIEZpeCB0YXNrbGV0X2luaXQoKSBpbiBtZWdhc2FzX2luaXRfZnco
KSB0byB1c2UgaW5zdGFuY2V0LT50YXNrbGV0LgorICAgIDEyLiBGaXggZmF1bHQgc3RhdGUgaGFu
ZGxpbmcgaW4gbWVnYXNhc190cmFuc2l0aW9uX3RvX3JlYWR5KCkuCisgICAgMTMuIEZpeCBtYXhf
c2VjdG9ycyBzZXR0aW5nIGZvciBJRUVFIFNHTCdzLgorICAgIDE0LiBGaXggaU1SIE9DUiBzdXBw
b3J0IHRvIHdvcmsgY29ycmVjdGx5LgorLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogUmVsZWFzZSBE
YXRlICAgIDogVHVlcy4gIERlYyAxNCwgMjAxMCAxNzowMDowMCBQU1QgMjAxMCAtCiAJCQkoZW1h
aWxkLWlkOm1lZ2FyYWlkbGludXhAbHNpLmNvbSkKIAkJCUFkYW0gUmFkZm9yZApkaWZmIC1OYXVy
IGxpbnV4LTIuNi4zOC1yYzUvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19iYXNl
LmMgbGludXgtMi42LjM4LXJjNS5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nh
c19iYXNlLmMKLS0tIGxpbnV4LTIuNi4zOC1yYzUvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2Fy
YWlkX3Nhc19iYXNlLmMJMjAxMS0wMi0xOSAxNTowOTowNC43ODIzMzIzMTcgLTA4MDAKKysrIGxp
bnV4LTIuNi4zOC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFz
ZS5jCTIwMTEtMDItMTkgMTU6MTA6NDAuNjY3MzYyNzk4IC0wODAwCkBAIC0xOCwxMiArMTgsMTMg
QEAKICAqICBGb3VuZGF0aW9uLCBJbmMuLCA1OSBUZW1wbGUgUGxhY2UsIFN1aXRlIDMzMCwgQm9z
dG9uLCBNQSAwMjExMS0xMzA3IFVTQQogICoKICAqICBGSUxFOiBtZWdhcmFpZF9zYXNfYmFzZS5j
Ci0gKiAgVmVyc2lvbiA6IHYwMC4wMC4wNS4yOS1yYzEKKyAqICBWZXJzaW9uIDogdjAwLjAwLjA1
LjMzLXJjMQogICoKICAqICBBdXRob3JzOiBMU0kgQ29ycG9yYXRpb24KICAqICAgICAgICAgICBT
cmVlbml2YXMgQmFnYWxrb3RlCiAgKiAgICAgICAgICAgU3VtYW50IFBhdHJvCiAgKiAgICAgICAg
ICAgQm8gWWFuZworICogICAgICAgICAgIEFkYW0gUmFkZm9yZCA8bGludXhyYWlkQGxzaS5jb20+
CiAgKgogICogIFNlbmQgZmVlZGJhY2sgdG86IDxtZWdhcmFpZGxpbnV4QGxzaS5jb20+CiAgKgpk
aWZmIC1OYXVyIGxpbnV4LTIuNi4zOC1yYzUvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlk
X3Nhcy5oIGxpbnV4LTIuNi4zOC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXMuaAotLS0gbGludXgtMi42LjM4LXJjNS9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzLmgJMjAxMS0wMi0xOSAxNDozOToxNS4xODYzMzI0NjkgLTA4MDAKKysrIGxpbnV4LTIu
Ni4zOC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAkyMDExLTAy
LTE5IDE1OjA5OjU2LjQwOTM2NDUzOCAtMDgwMApAQCAtMzMsOSArMzMsOSBAQAogLyoKICAqIE1l
Z2FSQUlEIFNBUyBEcml2ZXIgbWV0YSBkYXRhCiAgKi8KLSNkZWZpbmUgTUVHQVNBU19WRVJTSU9O
CQkJCSIwMC4wMC4wNS4yOS1yYzEiCi0jZGVmaW5lIE1FR0FTQVNfUkVMREFURQkJCQkiRGVjLiA3
LCAyMDEwIgotI2RlZmluZSBNRUdBU0FTX0VYVF9WRVJTSU9OCQkJIlR1ZS4gRGVjLiA3IDE3OjAw
OjAwIFBEVCAyMDEwIgorI2RlZmluZSBNRUdBU0FTX1ZFUlNJT04JCQkJIjAwLjAwLjA1LjMzLXJj
MSIKKyNkZWZpbmUgTUVHQVNBU19SRUxEQVRFCQkJCSJGZWIuIDE5LCAyMDExIgorI2RlZmluZSBN
RUdBU0FTX0VYVF9WRVJTSU9OCQkJIlNhdC4gRmViLiAxOSAxNzowMDowMCBQRFQgMjAxMSIKIAog
LyoKICAqIERldmljZSBJRHMK
--001485f6c5ee01cc2f049cad6fb1--
