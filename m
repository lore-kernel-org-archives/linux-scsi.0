From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: Make sure cmd_flags are 64-bit
Date: Wed,  9 Apr 2014 22:20:48 -0400
Message-ID: <1397096448-22073-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49573 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287AbaDJCVJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2014 22:21:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

cmd_flags in struct request is now 64 bits wide but the scsi_execute
functions truncated arguments passed to int leading to errors. Make sure
the flags parameters are u64.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@fb.com>
CC: Jan Kara <jack@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/scsi/scsi_lib.c    | 4 ++--
 include/scsi/scsi_device.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5681c05ac506..65a123d9c676 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -184,7 +184,7 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
  */
 int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		 int data_direction, void *buffer, unsigned bufflen,
-		 unsigned char *sense, int timeout, int retries, int flags,
+		 unsigned char *sense, int timeout, int retries, u64 flags,
 		 int *resid)
 {
 	struct request *req;
@@ -235,7 +235,7 @@ EXPORT_SYMBOL(scsi_execute);
 int scsi_execute_req_flags(struct scsi_device *sdev, const unsigned char *cmd,
 		     int data_direction, void *buffer, unsigned bufflen,
 		     struct scsi_sense_hdr *sshdr, int timeout, int retries,
-		     int *resid, int flags)
+		     int *resid, u64 flags)
 {
 	char *sense = NULL;
 	int result;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 4e845b80efd3..5853c913d2b0 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -423,11 +423,11 @@ extern int scsi_is_target_device(const struct device *);
 extern int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 			int data_direction, void *buffer, unsigned bufflen,
 			unsigned char *sense, int timeout, int retries,
-			int flag, int *resid);
+			u64 flags, int *resid);
 extern int scsi_execute_req_flags(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-	int retries, int *resid, int flags);
+	int retries, int *resid, u64 flags);
 static inline int scsi_execute_req(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-- 
1.8.3.1

