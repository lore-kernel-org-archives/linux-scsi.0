From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] scsi: don't reference freed command in scsi_prep_return
Date: Tue, 15 Apr 2014 12:24:56 +0200
Message-ID: <1397557496-21194-3-git-send-email-hch@lst.de>
References: <1397557496-21194-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51854 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaDOKWt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Apr 2014 06:22:49 -0400
In-Reply-To: <1397557496-21194-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

In the kill case of scsi_prep_return we have to release our device
reference, but we do this trying to reference the just freed command.
Use the local sdev pointer instead.

Reported-by: Joe Lawrence <joe.lawrence@stratus.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 54eff6a..7fa54fe 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1274,7 +1274,7 @@ int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 			struct scsi_cmnd *cmd = req->special;
 			scsi_release_buffers(cmd);
 			scsi_put_command(cmd);
-			put_device(&cmd->device->sdev_gendev);
+			put_device(&sdev->sdev_gendev);
 			req->special = NULL;
 		}
 		break;
-- 
1.7.10.4

