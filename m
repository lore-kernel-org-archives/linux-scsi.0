From: adam radford <aradford@gmail.com>
Subject: [PATCH 10/11]: megaraid_sas: Add MegaRAID 9265/9285 specific code to megaraid_sas.h
Date: Tue, 14 Dec 2010 19:10:05 -0800
Message-ID: <AANLkTi=hujuR38vLgS1m_E+XTttaYy7OKqtNeN9Y6pyW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016363b852020aa3104976a4629
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45481 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726Ab0LODKG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2010 22:10:06 -0500
Received: by qyj19 with SMTP id 19so5587411qyj.19
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2010 19:10:05 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016363b852020aa3104976a4629
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch adds code for the MegaRAID 9265/9285 to megaraid_sas.h.

Signed-off-by: Adam Radford <aradford@gmail.com>

Note: The patch has been included in-line below, and also as an
attachment in case Gmail hoses the patch.

diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas.h
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas.h	2010-12-14
17:06:01.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas.h	2010-12-14
17:22:52.000000000 -0800
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION			"00.00.04.31-rc1"
-#define MEGASAS_RELDATE			"May 3, 2010"
-#define MEGASAS_EXT_VERSION		"Mon. May 3, 11:41:51 PST 2010"
+#define MEGASAS_VERSION				"00.00.05.29-rc1"
+#define MEGASAS_RELDATE				"Dec. 7, 2010"
+#define MEGASAS_EXT_VERSION			"Tue. Dec. 7 17:00:00 PDT 2010"

 /*
  * Device IDs
@@ -47,6 +47,7 @@
 #define	PCI_DEVICE_ID_LSI_SAS0079GEN2		0x0079
 #define	PCI_DEVICE_ID_LSI_SAS0073SKINNY		0x0073
 #define	PCI_DEVICE_ID_LSI_SAS0071SKINNY		0x0071
+#define	PCI_DEVICE_ID_LSI_FUSION		0x005b

 /*
  * =====================================
@@ -436,7 +437,6 @@
 	* Add properties that can be controlled by
 	* a bit in the following structure.
 	*/
-
 	struct {
 		u32     copyBackDisabled            : 1;
 		u32     SMARTerEnabled              : 1;
@@ -716,6 +716,7 @@
 #define MEGASAS_DEFAULT_INIT_ID			-1
 #define MEGASAS_MAX_LUN				8
 #define MEGASAS_MAX_LD				64
+#define MEGASAS_DEFAULT_CMD_PER_LUN		128
 #define MEGASAS_MAX_PD                          (MEGASAS_MAX_PD_CHANNELS * \
 						MEGASAS_MAX_DEV_PER_CHANNEL)
 #define MEGASAS_MAX_LD_IDS			(MEGASAS_MAX_LD_CHANNELS * \
@@ -784,7 +785,10 @@
 */

 struct megasas_register_set {
-	u32 	reserved_0[4];			/*0000h*/
+	u32	doorbell;                       /*0000h*/
+	u32	fusion_seq_offset;		/*0004h*/
+	u32	fusion_host_diag;		/*0008h*/
+	u32	reserved_01;			/*000Ch*/

 	u32 	inbound_msg_0;			/*0010h*/
 	u32 	inbound_msg_1;			/*0014h*/
@@ -804,15 +808,18 @@
 	u32 	inbound_queue_port;		/*0040h*/
 	u32 	outbound_queue_port;		/*0044h*/

-	u32 	reserved_2[22];			/*0048h*/
+	u32	reserved_2[9];			/*0048h*/
+	u32	reply_post_host_index;		/*006Ch*/
+	u32	reserved_2_2[12];		/*0070h*/

 	u32 	outbound_doorbell_clear;	/*00A0h*/

 	u32 	reserved_3[3];			/*00A4h*/

 	u32 	outbound_scratch_pad ;		/*00B0h*/
+	u32	outbound_scratch_pad_2;         /*00B4h*/

-	u32 	reserved_4[3];			/*00B4h*/
+	u32	reserved_4[2];			/*00B8h*/

 	u32 	inbound_low_queue_port ;	/*00C0h*/

@@ -1287,6 +1294,9 @@

 	u16 max_num_sge;
 	u16 max_fw_cmds;
+	/* For Fusion its num IOCTL cmds, for others MFI based its
+	   max_fw_cmds */
+	u16 max_mfi_cmds;
 	u32 max_sectors_per_req;
 	struct megasas_aen_event *ev;

@@ -1336,9 +1346,15 @@
 	struct timer_list io_completion_timer;
 	struct list_head internal_reset_pending_q;

+	/* Ptr to hba specfic information */
+	void *ctrl_context;
 	u8	msi_flag;
 	struct msix_entry msixentry;
+	u64 map_id;
+	struct megasas_cmd *map_update_cmd;
 	unsigned long bar;
+	long reset_flags;
+	struct mutex reset_mutex;
 };

 enum {
@@ -1397,7 +1413,13 @@
 	struct list_head list;
 	struct scsi_cmnd *scmd;
 	struct megasas_instance *instance;
-	u32 frame_count;
+	union {
+		struct {
+			u16 smid;
+			u16 resvd;
+		} context;
+		u32 frame_count;
+	};
 };

 #define MAX_MGMT_ADAPTERS		1024

--0016363b852020aa3104976a4629
Content-Type: application/octet-stream; name="megaraid_sas.patch10"
Content-Disposition: attachment; filename="megaraid_sas.patch10"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghpn35mz0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YXJhaWRfc2FzLmggbGludXgtMi42LjM3LXJjNS5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21l
Z2FyYWlkX3Nhcy5oCi0tLSBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJh
aWQvbWVnYXJhaWRfc2FzLmgJMjAxMC0xMi0xNCAxNzowNjowMS4wMDAwMDAwMDAgLTA4MDAKKysr
IGxpbnV4LTIuNi4zNy1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMu
aAkyMDEwLTEyLTE0IDE3OjIyOjUyLjAwMDAwMDAwMCAtMDgwMApAQCAtMzMsOSArMzMsOSBAQAog
LyoKICAqIE1lZ2FSQUlEIFNBUyBEcml2ZXIgbWV0YSBkYXRhCiAgKi8KLSNkZWZpbmUgTUVHQVNB
U19WRVJTSU9OCQkJIjAwLjAwLjA0LjMxLXJjMSIKLSNkZWZpbmUgTUVHQVNBU19SRUxEQVRFCQkJ
Ik1heSAzLCAyMDEwIgotI2RlZmluZSBNRUdBU0FTX0VYVF9WRVJTSU9OCQkiTW9uLiBNYXkgMywg
MTE6NDE6NTEgUFNUIDIwMTAiCisjZGVmaW5lIE1FR0FTQVNfVkVSU0lPTgkJCQkiMDAuMDAuMDUu
MjktcmMxIgorI2RlZmluZSBNRUdBU0FTX1JFTERBVEUJCQkJIkRlYy4gNywgMjAxMCIKKyNkZWZp
bmUgTUVHQVNBU19FWFRfVkVSU0lPTgkJCSJUdWUuIERlYy4gNyAxNzowMDowMCBQRFQgMjAxMCIK
IAogLyoKICAqIERldmljZSBJRHMKQEAgLTQ3LDYgKzQ3LDcgQEAKICNkZWZpbmUJUENJX0RFVklD
RV9JRF9MU0lfU0FTMDA3OUdFTjIJCTB4MDA3OQogI2RlZmluZQlQQ0lfREVWSUNFX0lEX0xTSV9T
QVMwMDczU0tJTk5ZCQkweDAwNzMKICNkZWZpbmUJUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3MVNL
SU5OWQkJMHgwMDcxCisjZGVmaW5lCVBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTgkJMHgwMDViCiAK
IC8qCiAgKiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09CkBAIC00MzYsNyAr
NDM3LDYgQEAKIAkqIEFkZCBwcm9wZXJ0aWVzIHRoYXQgY2FuIGJlIGNvbnRyb2xsZWQgYnkKIAkq
IGEgYml0IGluIHRoZSBmb2xsb3dpbmcgc3RydWN0dXJlLgogCSovCi0KIAlzdHJ1Y3QgewogCQl1
MzIgICAgIGNvcHlCYWNrRGlzYWJsZWQgICAgICAgICAgICA6IDE7CiAJCXUzMiAgICAgU01BUlRl
ckVuYWJsZWQgICAgICAgICAgICAgIDogMTsKQEAgLTcxNiw2ICs3MTYsNyBAQAogI2RlZmluZSBN
RUdBU0FTX0RFRkFVTFRfSU5JVF9JRAkJCS0xCiAjZGVmaW5lIE1FR0FTQVNfTUFYX0xVTgkJCQk4
CiAjZGVmaW5lIE1FR0FTQVNfTUFYX0xECQkJCTY0CisjZGVmaW5lIE1FR0FTQVNfREVGQVVMVF9D
TURfUEVSX0xVTgkJMTI4CiAjZGVmaW5lIE1FR0FTQVNfTUFYX1BEICAgICAgICAgICAgICAgICAg
ICAgICAgICAoTUVHQVNBU19NQVhfUERfQ0hBTk5FTFMgKiBcCiAJCQkJCQlNRUdBU0FTX01BWF9E
RVZfUEVSX0NIQU5ORUwpCiAjZGVmaW5lIE1FR0FTQVNfTUFYX0xEX0lEUwkJCShNRUdBU0FTX01B
WF9MRF9DSEFOTkVMUyAqIFwKQEAgLTc4NCw3ICs3ODUsMTAgQEAKICovCiAgCiBzdHJ1Y3QgbWVn
YXNhc19yZWdpc3Rlcl9zZXQgewotCXUzMiAJcmVzZXJ2ZWRfMFs0XTsJCQkvKjAwMDBoKi8KKwl1
MzIJZG9vcmJlbGw7ICAgICAgICAgICAgICAgICAgICAgICAvKjAwMDBoKi8KKwl1MzIJZnVzaW9u
X3NlcV9vZmZzZXQ7CQkvKjAwMDRoKi8KKwl1MzIJZnVzaW9uX2hvc3RfZGlhZzsJCS8qMDAwOGgq
LworCXUzMglyZXNlcnZlZF8wMTsJCQkvKjAwMENoKi8KIAogCXUzMiAJaW5ib3VuZF9tc2dfMDsJ
CQkvKjAwMTBoKi8KIAl1MzIgCWluYm91bmRfbXNnXzE7CQkJLyowMDE0aCovCkBAIC04MDQsMTUg
KzgwOCwxOCBAQAogCXUzMiAJaW5ib3VuZF9xdWV1ZV9wb3J0OwkJLyowMDQwaCovCiAJdTMyIAlv
dXRib3VuZF9xdWV1ZV9wb3J0OwkJLyowMDQ0aCovCiAKLQl1MzIgCXJlc2VydmVkXzJbMjJdOwkJ
CS8qMDA0OGgqLworCXUzMglyZXNlcnZlZF8yWzldOwkJCS8qMDA0OGgqLworCXUzMglyZXBseV9w
b3N0X2hvc3RfaW5kZXg7CQkvKjAwNkNoKi8KKwl1MzIJcmVzZXJ2ZWRfMl8yWzEyXTsJCS8qMDA3
MGgqLwogCiAJdTMyIAlvdXRib3VuZF9kb29yYmVsbF9jbGVhcjsJLyowMEEwaCovCiAKIAl1MzIg
CXJlc2VydmVkXzNbM107CQkJLyowMEE0aCovCiAKIAl1MzIgCW91dGJvdW5kX3NjcmF0Y2hfcGFk
IDsJCS8qMDBCMGgqLworCXUzMglvdXRib3VuZF9zY3JhdGNoX3BhZF8yOyAgICAgICAgIC8qMDBC
NGgqLwogCi0JdTMyIAlyZXNlcnZlZF80WzNdOwkJCS8qMDBCNGgqLworCXUzMglyZXNlcnZlZF80
WzJdOwkJCS8qMDBCOGgqLwogCiAJdTMyIAlpbmJvdW5kX2xvd19xdWV1ZV9wb3J0IDsJLyowMEMw
aCovCiAKQEAgLTEyODcsNiArMTI5NCw5IEBACiAKIAl1MTYgbWF4X251bV9zZ2U7CiAJdTE2IG1h
eF9md19jbWRzOworCS8qIEZvciBGdXNpb24gaXRzIG51bSBJT0NUTCBjbWRzLCBmb3Igb3RoZXJz
IE1GSSBiYXNlZCBpdHMKKwkgICBtYXhfZndfY21kcyAqLworCXUxNiBtYXhfbWZpX2NtZHM7CiAJ
dTMyIG1heF9zZWN0b3JzX3Blcl9yZXE7CiAJc3RydWN0IG1lZ2FzYXNfYWVuX2V2ZW50ICpldjsK
IApAQCAtMTMzNiw5ICsxMzQ2LDE1IEBACiAJc3RydWN0IHRpbWVyX2xpc3QgaW9fY29tcGxldGlv
bl90aW1lcjsKIAlzdHJ1Y3QgbGlzdF9oZWFkIGludGVybmFsX3Jlc2V0X3BlbmRpbmdfcTsKIAor
CS8qIFB0ciB0byBoYmEgc3BlY2ZpYyBpbmZvcm1hdGlvbiAqLworCXZvaWQgKmN0cmxfY29udGV4
dDsKIAl1OAltc2lfZmxhZzsKIAlzdHJ1Y3QgbXNpeF9lbnRyeSBtc2l4ZW50cnk7CisJdTY0IG1h
cF9pZDsKKwlzdHJ1Y3QgbWVnYXNhc19jbWQgKm1hcF91cGRhdGVfY21kOwogCXVuc2lnbmVkIGxv
bmcgYmFyOworCWxvbmcgcmVzZXRfZmxhZ3M7CisJc3RydWN0IG11dGV4IHJlc2V0X211dGV4Owog
fTsKIAogZW51bSB7CkBAIC0xMzk3LDcgKzE0MTMsMTMgQEAKIAlzdHJ1Y3QgbGlzdF9oZWFkIGxp
c3Q7CiAJc3RydWN0IHNjc2lfY21uZCAqc2NtZDsKIAlzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAq
aW5zdGFuY2U7Ci0JdTMyIGZyYW1lX2NvdW50OworCXVuaW9uIHsKKwkJc3RydWN0IHsKKwkJCXUx
NiBzbWlkOworCQkJdTE2IHJlc3ZkOworCQl9IGNvbnRleHQ7CisJCXUzMiBmcmFtZV9jb3VudDsK
Kwl9OwogfTsKIAogI2RlZmluZSBNQVhfTUdNVF9BREFQVEVSUwkJMTAyNAo=
--0016363b852020aa3104976a4629--
