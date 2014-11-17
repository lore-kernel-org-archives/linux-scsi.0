From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/10] scsi: Add SPC-3 command definitions
Date: Mon, 17 Nov 2014 14:25:20 +0100
Message-ID: <1416230728-66425-3-git-send-email-hare@suse.de>
References: <1416230728-66425-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbaKQNZc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 08:25:32 -0500
In-Reply-To: <1416230728-66425-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Robert Elliott <elliott@hp.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

SPC-3 defines SERVICE ACTION IN(12), SERVICE_ACTION OUT(12),
SERVICE ACTION OUT(16), and SERVICE ACTION BIDIRECTIONAL.
And READ MEDIA SERIAL NUMBER has long since been deprecated.
So update callers to refer to the new cdb name.

Tested-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c           |  4 ----
 drivers/target/target_core_pr.c    |  2 +-
 include/scsi/scsi.h                | 10 +++++++---
 tools/lib/traceevent/plugin_scsi.c |  5 ++++-
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 52afabd..aee62f6 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -21,10 +21,6 @@
 
 
 /* Commands with service actions that change the command name */
-#define SERVICE_ACTION_IN_12 0xab
-#define SERVICE_ACTION_OUT_12 0xa9
-#define SERVICE_ACTION_BIDIRECTIONAL 0x9d
-#define SERVICE_ACTION_OUT_16 0x9f
 #define THIRD_PARTY_COPY_OUT 0x83
 #define THIRD_PARTY_COPY_IN 0x84
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 8c60a1a..806bfba 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -459,7 +459,7 @@ static int core_scsi3_pr_seq_non_holder(
 	case ACCESS_CONTROL_OUT:
 	case INQUIRY:
 	case LOG_SENSE:
-	case READ_MEDIA_SERIAL_NUMBER:
+	case SERVICE_ACTION_IN_12:
 	case REPORT_LUNS:
 	case REQUEST_SENSE:
 	case PERSISTENT_RESERVE_IN:
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index b354c0d..8a7f8ad 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -128,8 +128,10 @@ enum scsi_timeouts {
 #define MOVE_MEDIUM           0xa5
 #define EXCHANGE_MEDIUM       0xa6
 #define READ_12               0xa8
+#define SERVICE_ACTION_OUT_12 0xa9
 #define WRITE_12              0xaa
-#define READ_MEDIA_SERIAL_NUMBER 0xab
+#define READ_MEDIA_SERIAL_NUMBER 0xab /* Obsolete with SPC-2 */
+#define SERVICE_ACTION_IN_12  0xab
 #define WRITE_VERIFY_12       0xae
 #define VERIFY_12	      0xaf
 #define SEARCH_HIGH_12        0xb0
@@ -151,7 +153,9 @@ enum scsi_timeouts {
 #define VERIFY_16	      0x8f
 #define SYNCHRONIZE_CACHE_16  0x91
 #define WRITE_SAME_16	      0x93
+#define SERVICE_ACTION_BIDIRECTIONAL 0x9d
 #define SERVICE_ACTION_IN_16  0x9e
+#define SERVICE_ACTION_OUT_16 0x9f
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16  0x10
 #define SAI_GET_LBA_STATUS    0x12
@@ -165,8 +169,8 @@ enum scsi_timeouts {
 #define MI_REPORT_ALIASES     0x0b
 #define MI_REPORT_SUPPORTED_OPERATION_CODES 0x0c
 #define MI_REPORT_SUPPORTED_TASK_MANAGEMENT_FUNCTIONS 0x0d
-#define MI_REPORT_PRIORITY   0x0e
-#define MI_REPORT_TIMESTAMP  0x0f
+#define MI_REPORT_PRIORITY    0x0e
+#define MI_REPORT_TIMESTAMP   0x0f
 #define MI_MANAGEMENT_PROTOCOL_IN 0x10
 /* value for MI_REPORT_TARGET_PGS ext header */
 #define MI_EXT_HDR_PARAM_FMT  0x20
diff --git a/tools/lib/traceevent/plugin_scsi.c b/tools/lib/traceevent/plugin_scsi.c
index c699f47..3727de4 100644
--- a/tools/lib/traceevent/plugin_scsi.c
+++ b/tools/lib/traceevent/plugin_scsi.c
@@ -85,8 +85,9 @@ typedef unsigned int u32;
 #define MOVE_MEDIUM			0xa5
 #define EXCHANGE_MEDIUM			0xa6
 #define READ_12				0xa8
+#define SERVICE_ACTION_OUT_12		0xa9
 #define WRITE_12			0xaa
-#define READ_MEDIA_SERIAL_NUMBER	0xab
+#define SERVICE_ACTION_IN_12		0xab
 #define WRITE_VERIFY_12			0xae
 #define VERIFY_12			0xaf
 #define SEARCH_HIGH_12			0xb0
@@ -107,7 +108,9 @@ typedef unsigned int u32;
 #define VERIFY_16			0x8f
 #define SYNCHRONIZE_CACHE_16		0x91
 #define WRITE_SAME_16			0x93
+#define SERVICE_ACTION_BIDIRECTIONAL	0x9d
 #define SERVICE_ACTION_IN_16		0x9e
+#define SERVICE_ACTION_OUT_16		0x9f
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16		0x10
 #define SAI_GET_LBA_STATUS		0x12
-- 
1.8.5.2

