From: michaelc@cs.wisc.edu
Subject: [PATCH 2/2] scsi_dh_alua: remove REQ_NOMERGE
Date: Sat,  6 Sep 2008 08:39:16 -0500
Message-ID: <1220708356-5225-2-git-send-email-michaelc@cs.wisc.edu>
References: <1220708356-5225-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbYIFNj2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Sep 2008 09:39:28 -0400
In-Reply-To: <1220708356-5225-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We do not need to set REQ_NOMERGE because when the module calls
blk_execute_rq -> blk_execute_rq_nowait, blk_execute_rq_nowait sets
it for us. This brings all the modules in sync for those bits.

Patch was made over scsi-post, but is applyable over scsi-misc.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 6bc55a6..f3faeea 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -110,7 +110,7 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-			 REQ_FAILFAST_DRIVER | REQ_NOMERGE;
+			 REQ_FAILFAST_DRIVER;
 	rq->retries = ALUA_FAILOVER_RETRIES;
 	rq->timeout = ALUA_FAILOVER_TIMEOUT;
 
-- 
1.5.4.1

