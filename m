From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 01/22] scsi: Add missing SPC-4 CDB and MAINTENANCE_[IN,OUT] service action definitions
Date: Mon, 30 Aug 2010 02:20:18 -0700
Message-ID: <1283160018-6579-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:24273 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754600Ab0H3JUV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2010 05:20:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a handful of missing CDBs defs that are used by TCM
persistent reservation logic in the SPC-4 defined CDB exclusion table for
registrations and reservations.

This includes a number of missing MI_* and MO_* prefixed service actions defs
for MAINTENANCE_IN and MAINTENANCE_OUT that are mentioned wrt to persistent
registration and reservation status for the SCSI Initiator Port.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 include/scsi/scsi.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 8fcb6e0..9c134de 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -107,32 +107,56 @@ struct scsi_cmnd;
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
 #define VERIFY_12	      0xaf
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
+#define WRITE_ATTRIBUTE	      0x8d
 #define VERIFY_16	      0x8f
 #define WRITE_SAME_16	      0x93
 #define SERVICE_ACTION_IN     0x9e
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16  0x10
 #define SAI_GET_LBA_STATUS    0x12
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
 /* values for variable length command */
 #define READ_32		      0x09
 #define VERIFY_32	      0x0a
-- 
1.7.2.2

