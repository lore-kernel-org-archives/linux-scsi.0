From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] scsi: don't reference freed command in scsi_init_sgtable
Date: Fri, 25 Apr 2014 13:09:49 +0200
Message-ID: <1398424190-21325-2-git-send-email-hch@lst.de>
References: <1398424190-21325-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41778 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaDYLHt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2014 07:07:49 -0400
In-Reply-To: <1398424190-21325-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, James Bottomley <JBottomley@Parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

When scsi_init_io fails we have to release our device reference, but
we do this trying to reference the just freed command.  Add a local
scsi_device pointer to fix this.

Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 65a123d..54eff6a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1044,6 +1044,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
  */
 int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
+	struct scsi_device *sdev = cmd->device;
 	struct request *rq = cmd->request;
 
 	int error = scsi_init_sgtable(rq, &cmd->sdb, gfp_mask);
@@ -1091,7 +1092,7 @@ err_exit:
 	scsi_release_buffers(cmd);
 	cmd->request->special = NULL;
 	scsi_put_command(cmd);
-	put_device(&cmd->device->sdev_gendev);
+	put_device(&sdev->sdev_gendev);
 	return error;
 }
 EXPORT_SYMBOL(scsi_init_io);
-- 
1.7.10.4

