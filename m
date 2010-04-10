From: michaelc@cs.wisc.edu
Subject: [PATCH 2/4] scsi_dh_emc: request flag cleanup
Date: Fri,  9 Apr 2010 22:07:37 -0500
Message-ID: <1270868859-5147-3-git-send-email-michaelc@cs.wisc.edu>
References: <1270868859-5147-1-git-send-email-michaelc@cs.wisc.edu>
 <1270868859-5147-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab0DJDHu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 23:07:50 -0400
In-Reply-To: <1270868859-5147-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

blk_get_request sets the cmd_flags, so we should not and do not
need to set them. If we did set them to a different value then
it can cause a oops in the elevator code.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/device_handler/scsi_dh_emc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index e8a0bc3..6faf472 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -285,13 +285,11 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 	switch (cmd) {
 	case MODE_SELECT:
 		len = sizeof(short_trespass);
-		rq->cmd_flags |= REQ_RW;
 		rq->cmd[1] = 0x10;
 		rq->cmd[4] = len;
 		break;
 	case MODE_SELECT_10:
 		len = sizeof(long_trespass);
-		rq->cmd_flags |= REQ_RW;
 		rq->cmd[1] = 0x10;
 		rq->cmd[8] = len;
 		break;
-- 
1.6.6.1

