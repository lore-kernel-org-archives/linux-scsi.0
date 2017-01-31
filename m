From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/10] =?UTF-8?q?=D1=95d:=20remove=20pointless=20REQ=5FTYP?= =?UTF-8?q?E=5FFS=20check?=
Date: Tue, 31 Jan 2017 16:57:23 +0100
Message-ID: <1485878251-6107-3-git-send-email-hch@lst.de>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59610 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbdAaQTP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jan 2017 11:19:15 -0500
In-Reply-To: <1485878251-6107-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org

->done can only be called for fs requests, so no need to check again here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c779986..bd2fb4d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1735,9 +1735,6 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 	unsigned int transferred = scsi_bufflen(scmd) - scsi_get_resid(scmd);
 	unsigned int good_bytes;
 
-	if (scmd->request->cmd_type != REQ_TYPE_FS)
-		return 0;
-
 	info_valid = scsi_get_sense_info_fld(scmd->sense_buffer,
 					     SCSI_SENSE_BUFFERSIZE,
 					     &bad_lba);
-- 
2.1.4

