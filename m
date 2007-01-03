From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] scsi_debug: illegal blocking memory allocation
Date: Wed, 3 Jan 2007 14:49:07 +0100
Message-ID: <20070103134907.GV11203@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:21566 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbXACNqT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Jan 2007 08:46:19 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Hi Doug,

resp_inquiry() does a GFP_KERNEL memory allocation, but it's not allowed
to from the queuecommand context. There's no good way to return this
error, so I used DID_ERROR which is used from similar paths. That
doesn't seem quite right though, it would be better to return an error
indicating a later retry would be more appropriate.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 30ee3d7..0c80ed3 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -954,7 +954,9 @@ static int resp_inquiry(struct scsi_cmnd * scp, int target,
 	int alloc_len, n, ret;
 
 	alloc_len = (cmd[3] << 8) + cmd[4];
-	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_KERNEL);
+	arr = kzalloc(SDEBUG_MAX_INQ_ARR_SZ, GFP_ATOMIC);
+	if (!arr)
+		return DID_ERROR << 16;
 	if (devip->wlun)
 		pq_pdt = 0x1e;	/* present, wlun */
 	else if (scsi_debug_no_lun_0 && (0 == devip->lun))

-- 
Jens Axboe

