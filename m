From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] Update scsi.h CDBs and MANAGEMENT_[IN,OUT] defines
Date: Tue, 15 Sep 2009 00:26:18 -0700
Message-ID: <1252999578.28853.12.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:45094 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757991AbZIOH0V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Sep 2009 03:26:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>

Hi James,

This patch adds a handful of CDB defines that where missing from include/scsi/scsi.h.
I am using these with TCM v3.2 inside of the various CDB exclusion tables listed by SPC-4
for target mode persistent reservations.

It also adds the remaining missing MANAGEMENT_IN and MANAGEMENT_OUT defines, as only the
ALUA related MI_REPORT_TARGET_PGS and MO_SET_TARGET_PGS are currently defined in the upstream
tree.

Please consider this for v2.6.32.

--nab


diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 084478e..e742a24 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -106,29 +106,53 @@ struct scsi_cmnd;
 #define PERSISTENT_RESERVE_OUT 0x5f
 #define VARIABLE_LENGTH_CMD   0x7f
 #define REPORT_LUNS           0xa0
+#define SECURITY_PROTOCOL_IN  0xa2
 #define MAINTENANCE_IN        0xa3
 #define MAINTENANCE_OUT       0xa4
 #define MOVE_MEDIUM           0xa5
 #define EXCHANGE_MEDIUM       0xa6
 #define READ_12               0xa8
 #define WRITE_12              0xaa
+#define READ_MEDIA_SERIAL_NUMBER 0xab
 #define WRITE_VERIFY_12       0xae
 #define SEARCH_HIGH_12        0xb0
 #define SEARCH_EQUAL_12       0xb1
 #define SEARCH_LOW_12         0xb2
+#define SECURITY_PROTOCOL_OUT 0xb5
 #define READ_ELEMENT_STATUS   0xb8
 #define SEND_VOLUME_TAG       0xb6
 #define WRITE_LONG_2          0xea
+#define EXTENDED_COPY         0x83
+#define RECEIVE_COPY_RESULTS  0x84
+#define ACCESS_CONTROL_IN     0x86
+#define ACCESS_CONTROL_OUT    0x87
 #define READ_16               0x88
 #define WRITE_16              0x8a
+#define READ_ATTRIBUTE        0x8c
+#define WRITE_ATTRIBUTE              0x8d
 #define VERIFY_16            0x8f
 #define SERVICE_ACTION_IN     0x9e
 /* values for service action in */
 #define        SAI_READ_CAPACITY_16  0x10
+/* values for VARIABLE_LENGTH_CMD service action codes
+ * see spc4r17 Section D.3.5, table D.7 and D.8 */
+#define VLC_SA_RECEIVE_CREDENTIAL 0x1800
 /* values for maintenance in */
+#define MI_REPORT_IDENTIFYING_INFORMATION 0x05
 #define MI_REPORT_TARGET_PGS  0x0a
+#define MI_REPORT_ALIASES     0x0b
+#define MI_REPORT_SUPPORTED_OPERATION_CODES 0x0c
+#define MI_REPORT_SUPPORTED_TASK_MANAGEMENT_FUNCTIONS 0x0d
+#define MI_REPORT_PRIORITY   0x0e
+#define MI_REPORT_TIMESTAMP  0x0f
+#define MI_MANAGEMENT_PROTOCOL_IN 0x10
 /* values for maintenance out */
+#define MO_SET_IDENTIFYING_INFORMATION 0x06
 #define MO_SET_TARGET_PGS     0x0a
+#define MO_CHANGE_ALIASES     0x0b
+#define MO_SET_PRIORITY       0x0e
+#define MO_SET_TIMESTAMP      0x0f
+#define MO_MANAGEMENT_PROTOCOL_OUT 0x10
 
 /* Values for T10/04-262r7 */
 #define        ATA_16                0x85      /* 16-byte pass-thru */


