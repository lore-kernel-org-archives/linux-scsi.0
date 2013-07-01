From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/5] scsi: Return ENXIO on invalid device
Date: Mon,  1 Jul 2013 10:12:11 +0200
Message-ID: <1372666331-66996-6-git-send-email-hare@suse.de>
References: <1372666331-66996-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab3GAIMS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jul 2013 04:12:18 -0400
In-Reply-To: <1372666331-66996-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The scsi stack already uses DID_NO_CONNECT internally to signal
an invalid or removed device. This should be mapped to ENXIO,
as this then allows us to use a correct error code in
scsi_prep_return().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c        | 3 +++
 drivers/scsi/scsi_lib.c | 7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1093ca1..875b9da 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2321,6 +2321,9 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		case -ENODATA:
 			error_type = "critical medium";
 			break;
+		case -ENXIO:
+			error_type = "invalid device";
+			break;
 		case -EIO:
 		default:
 			error_type = "I/O";
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 70ca1f6..86d9980 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -712,6 +712,7 @@ EXPORT_SYMBOL(scsi_release_buffers);
  * -EBADE	permanent nexus failure, retry on other path
  * -ENOSPC	No write space available
  * -ENODATA	Medium error
+ * -ENXIO	Invalid or removed device
  * -EIO		unspecified I/O error
  */
 static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
@@ -738,6 +739,10 @@ static int __scsi_error_from_host_byte(struct scsi_cmnd *cmd, int result)
 		set_host_byte(cmd, DID_OK);
 		error = -ENODATA;
 		break;
+	case DID_NO_CONNECT:
+		set_host_byte(cmd, DID_OK);
+		error = -ENXIO;
+		break;
 	default:
 		error = -EIO;
 		break;
@@ -1286,7 +1291,7 @@ int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 
 	switch (ret) {
 	case BLKPREP_KILL:
-		req->errors = DID_NO_CONNECT << 16;
+		req->errors = -ENXIO;
 		/* release the command and kill it */
 		if (req->special) {
 			struct scsi_cmnd *cmd = req->special;
-- 
1.7.12.4

