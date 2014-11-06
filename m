From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/10] scsi: Add SPC-3 command definitions
Date: Thu,  6 Nov 2014 09:30:31 +0100
Message-ID: <1415262639-121586-3-git-send-email-hare@suse.de>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbaKFIan (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 03:30:43 -0500
In-Reply-To: <1415262639-121586-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

SPC-3 defines SERVICE ACTION IN(12), SERVICE_ACTION OUT(12),
SERVICE ACTION OUT(16), and SERVICE ACTION BIDIRECTIONAL.
And READ MEDIA SERIAL NUMBER has long since been deprecated.
So update callers to refer to the new cdb name.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c           | 4 ----
 drivers/target/target_core_pr.c    | 2 +-
 include/scsi/scsi.h                | 6 +++++-
 tools/lib/traceevent/plugin_scsi.c | 5 ++++-
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 09ddede..62c96ab 100644
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
index b354c0d..df00fd1 100644
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
+#define SERVICE_ACTION_IN_12 0xab
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
diff --git a/tools/lib/traceevent/plugin_scsi.c b/tools/lib/traceevent/plugin_scsi.c
index c699f47..63aba97 100644
--- a/tools/lib/traceevent/plugin_scsi.c
+++ b/tools/lib/traceevent/plugin_scsi.c
@@ -85,8 +85,9 @@ typedef unsigned int u32;
 #define MOVE_MEDIUM			0xa5
 #define EXCHANGE_MEDIUM			0xa6
 #define READ_12				0xa8
+#define SERVICE_ACTION_out_12		0xa9
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

