Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE21C4320E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A89E7600CC
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239627AbhHQJSO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:18:14 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47744 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239516AbhHQJRV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:21 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CB6A82002D;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GJLbgBiS7QA2K+oaYrzUl/AREUHVEloGWanz8odi41U=;
        b=IQF8il/RTemLVdTM6/0a8sgvdvfJcRs46apLOELGwuG8pjxhIByshg3MWSzvYJ5ZRHOW+7
        0tL180lIZpgXHwlqmUrVZ9wWrdml/sy8hQAIiUb63OMbFjfh9ErJFH1z2QVgOTZl0XJtyg
        PJzn1d+YiQjQrkbY7uUwnL3vMk0jdLg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GJLbgBiS7QA2K+oaYrzUl/AREUHVEloGWanz8odi41U=;
        b=BLkvs5VrMbnemaUQdRJGpWw1rxIjI4dXh6H3Wq/PicQIBBznLLRYAdEStgauYzl4Gri1PH
        /gTn401r8/yayOCg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id C4313A3BBC;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id C1224518CEBB; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 46/51] csiostor: use separate TMF command
Date:   Tue, 17 Aug 2021 11:14:51 +0200
Message-Id: <20210817091456.73342-47-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set one command aside as a TMF command, and use this command to
send the TMF. This avoids having to rely on the passed-in scsi
command when resetting the device.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/csiostor/csio_hw.h   |  2 ++
 drivers/scsi/csiostor/csio_init.c |  2 +-
 drivers/scsi/csiostor/csio_scsi.c | 44 ++++++++++++++++++++-----------
 3 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_hw.h b/drivers/scsi/csiostor/csio_hw.h
index e351af6e7c81..8e22dccd6d88 100644
--- a/drivers/scsi/csiostor/csio_hw.h
+++ b/drivers/scsi/csiostor/csio_hw.h
@@ -68,6 +68,8 @@
 
 #define CSIO_MAX_LUN		0xFFFF
 #define CSIO_MAX_QUEUE		2048
+#define CSIO_TMF_TAG		(CSIO_MAX_QUEUE - 1)
+
 #define CSIO_MAX_CMD_PER_LUN	32
 #define CSIO_MAX_DDP_BUF_SIZE	(1024 * 1024)
 #define CSIO_MAX_SECTOR_SIZE	128
diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 390b07bf92b9..7a80e0cf32d7 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -621,7 +621,7 @@ csio_shost_init(struct csio_hw *hw, struct device *dev,
 	/* Link common lnode to this lnode */
 	ln->dev_num = (shost->host_no << 16);
 
-	shost->can_queue = CSIO_MAX_QUEUE;
+	shost->can_queue = CSIO_MAX_QUEUE - 1;
 	shost->this_id = -1;
 	shost->unique_id = shost->host_no;
 	shost->max_cmd_len = 16; /* Max CDB length supported */
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index c22acfc7caba..0f3c997618c1 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2052,17 +2052,20 @@ csio_tm_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
 
 	/* Wake up the TM handler thread */
 	csio_scsi_cmnd(req) = NULL;
+	cmnd->host_scribble = NULL;
 }
 
 static int
 csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 {
-	struct csio_lnode *ln = shost_priv(cmnd->device->host);
+	struct scsi_device *sdev = cmnd->device;
+	struct csio_lnode *ln = shost_priv(sdev->host);
 	struct csio_hw *hw = csio_lnode_to_hw(ln);
 	struct csio_scsim *scsim = csio_hw_to_scsim(hw);
-	struct csio_rnode *rn = (struct csio_rnode *)(cmnd->device->hostdata);
+	struct csio_rnode *rn = (struct csio_rnode *)(sdev->hostdata);
 	struct csio_ioreq *ioreq = NULL;
 	struct csio_scsi_qset *sqset;
+	struct scsi_cmnd *tmf_cmnd;
 	unsigned long flags;
 	int retval;
 	int count, ret;
@@ -2073,13 +2076,13 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 		goto fail;
 
 	csio_dbg(hw, "Request to reset LUN:%llu (ssni:0x%x tgtid:%d)\n",
-		      cmnd->device->lun, rn->flowid, rn->scsi_id);
+		      sdev->lun, rn->flowid, rn->scsi_id);
 
 	if (!csio_is_lnode_ready(ln)) {
 		csio_err(hw,
 			 "LUN reset cannot be issued on non-ready"
 			 " local node vnpi:0x%x (LUN:%llu)\n",
-			 ln->vnp_flowid, cmnd->device->lun);
+			 ln->vnp_flowid, sdev->lun);
 		goto fail;
 	}
 
@@ -2099,7 +2102,15 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 		csio_err(hw,
 			 "LUN reset cannot be issued on non-ready"
 			 " remote node ssni:0x%x (LUN:%llu)\n",
-			 rn->flowid, cmnd->device->lun);
+			 rn->flowid, sdev->lun);
+		goto fail;
+	}
+
+	tmf_cmnd = scsi_host_find_tag(sdev->host, CSIO_TMF_TAG);
+	if (!tmf_cmnd || tmf_cmnd->host_scribble) {
+		csio_err(hw,
+			 "LUN reset TMF already busy (LUN:%llu)\n",
+			 sdev->lun);
 		goto fail;
 	}
 
@@ -2119,11 +2130,12 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	ioreq->iq_idx		= sqset->iq_idx;
 	ioreq->eq_idx		= sqset->eq_idx;
 
-	csio_scsi_cmnd(ioreq)	= cmnd;
-	cmnd->host_scribble	= (unsigned char *)ioreq;
-	cmnd->SCp.Status	= 0;
+	csio_scsi_cmnd(ioreq)	= tmf_cmnd;
+	tmf_cmnd->host_scribble	= (unsigned char *)ioreq;
+	tmf_cmnd->SCp.Status	= 0;
+	tmf_cmnd->device	= sdev;
 
-	cmnd->SCp.Message	= FCP_TMF_LUN_RESET;
+	tmf_cmnd->SCp.Message	= FCP_TMF_LUN_RESET;
 	ioreq->tmo		= CSIO_SCSI_LUNRST_TMO_MS / 1000;
 
 	/*
@@ -2140,7 +2152,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	sld.level = CSIO_LEV_LUN;
 	sld.lnode = ioreq->lnode;
 	sld.rnode = ioreq->rnode;
-	sld.oslun = cmnd->device->lun;
+	sld.oslun = sdev->lun;
 
 	spin_lock_irqsave(&hw->lock, flags);
 	/* Kick off TM SM on the ioreq */
@@ -2150,6 +2162,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	if (retval != 0) {
 		csio_err(hw, "Failed to issue LUN reset, req:%p, status:%d\n",
 			    ioreq, retval);
+		tmf_cmnd->host_scribble = NULL;
 		goto fail_ret_ioreq;
 	}
 
@@ -2163,20 +2176,21 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	/* LUN reset timed-out */
 	if (((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == cmnd) {
 		csio_err(hw, "LUN reset (%d:%llu) timed out\n",
-			 cmnd->device->id, cmnd->device->lun);
+			 sdev->id, sdev->lun);
 
 		spin_lock_irq(&hw->lock);
 		csio_scsi_drvcleanup(ioreq);
 		list_del_init(&ioreq->sm.sm_list);
 		spin_unlock_irq(&hw->lock);
 
+		tmf_cmnd->host_scribble = NULL;
 		goto fail_ret_ioreq;
 	}
 
 	/* LUN reset returned, check cached status */
-	if (cmnd->SCp.Status != FW_SUCCESS) {
+	if (tmf_cmnd->SCp.Status != FW_SUCCESS) {
 		csio_err(hw, "LUN reset failed (%d:%llu), status: %d\n",
-			 cmnd->device->id, cmnd->device->lun, cmnd->SCp.Status);
+			 sdev->id, sdev->lun, tmf_cmnd->SCp.Status);
 		goto fail;
 	}
 
@@ -2196,7 +2210,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	if (retval != 0) {
 		csio_err(hw,
 			 "Attempt to abort I/Os during LUN reset of %llu"
-			 " returned %d\n", cmnd->device->lun, retval);
+			 " returned %d\n", sdev->lun, retval);
 		/* Return I/Os back to active_q */
 		spin_lock_irq(&hw->lock);
 		list_splice_tail_init(&local_q, &scsim->active_q);
@@ -2207,7 +2221,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	CSIO_INC_STATS(rn, n_lun_rst);
 
 	csio_info(hw, "LUN reset occurred (%d:%llu)\n",
-		  cmnd->device->id, cmnd->device->lun);
+		  sdev->id, sdev->lun);
 
 	return SUCCESS;
 
-- 
2.29.2

