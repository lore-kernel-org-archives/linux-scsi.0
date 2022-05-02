Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10534C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241907AbiEBV6G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387808AbiEBV5z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:57:55 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C06FD24
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:54:24 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B3A1F1F899;
        Mon,  2 May 2022 21:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651528460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fU2eeqadf72NQOyzHys2QmG3XVR0slnd0zlUuAkSDiI=;
        b=hMXkPKs5rgn+K7fEYBtSvaTYcKWn1+UwT6t8xA+M8KU/ZJo+C4kz20g5DOG/4IvbIvaR0A
        R/woE772zFGFIewRJGIjtpK0x17QsJIGQmDmlvu0IWbLyym5wOAeG8zJuLyLKsHTw2Gv05
        jTAS7D3UzFRjUrDUMrLvJRh+qXk2618=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651528460;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fU2eeqadf72NQOyzHys2QmG3XVR0slnd0zlUuAkSDiI=;
        b=SkS/FyuhcdVN3CT9DMfvVFmavm5WXRhS+H/hX1V3Zu7GLwnGONPTixpkx9tnn6PUpGSry9
        qLSCsGYrtGLEdoDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id AC0EF2C153;
        Mon,  2 May 2022 21:54:20 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id A78AE519413C; Mon,  2 May 2022 23:54:20 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 11/11] csiostor: use separate TMF command
Date:   Mon,  2 May 2022 23:54:16 +0200
Message-Id: <20220502215416.5351-12-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502215416.5351-1-hare@suse.de>
References: <20220502215416.5351-1-hare@suse.de>
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
 drivers/scsi/csiostor/csio_scsi.c | 48 +++++++++++++++++++------------
 3 files changed, 33 insertions(+), 19 deletions(-)

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
index ccbded3353bd..6a5529d6440f 100644
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
index c1c410a1cfe0..b21aa2c43051 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2056,17 +2056,20 @@ csio_tm_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
 
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
@@ -2077,13 +2080,13 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
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
 
@@ -2103,7 +2106,15 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
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
 
@@ -2123,11 +2134,11 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	ioreq->iq_idx		= sqset->iq_idx;
 	ioreq->eq_idx		= sqset->eq_idx;
 
-	csio_scsi_cmnd(ioreq)	= cmnd;
-	cmnd->host_scribble	= (unsigned char *)ioreq;
-	csio_priv(cmnd)->wr_status = 0;
+	csio_scsi_cmnd(ioreq)	= tmf_cmnd;
+	tmf_cmnd->host_scribble	= (unsigned char *)ioreq;
+	csio_priv(tmf_cmnd)->wr_status = 0;
 
-	csio_priv(cmnd)->fc_tm_flags = FCP_TMF_LUN_RESET;
+	csio_priv(tmf_cmnd)->fc_tm_flags = FCP_TMF_LUN_RESET;
 	ioreq->tmo		= CSIO_SCSI_LUNRST_TMO_MS / 1000;
 
 	/*
@@ -2144,7 +2155,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	sld.level = CSIO_LEV_LUN;
 	sld.lnode = ioreq->lnode;
 	sld.rnode = ioreq->rnode;
-	sld.oslun = cmnd->device->lun;
+	sld.oslun = sdev->lun;
 
 	spin_lock_irqsave(&hw->lock, flags);
 	/* Kick off TM SM on the ioreq */
@@ -2154,20 +2165,21 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	if (retval != 0) {
 		csio_err(hw, "Failed to issue LUN reset, req:%p, status:%d\n",
 			    ioreq, retval);
+		tmf_cmnd->host_scribble = NULL;
 		goto fail_ret_ioreq;
 	}
 
 	csio_dbg(hw, "Waiting max %d secs for LUN reset completion\n",
 		    count * (CSIO_SCSI_TM_POLL_MS / 1000));
 	/* Wait for completion */
-	while ((((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == cmnd)
+	while ((((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == tmf_cmnd)
 								&& count--)
 		msleep(CSIO_SCSI_TM_POLL_MS);
 
 	/* LUN reset timed-out */
-	if (((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == cmnd) {
+	if (((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == tmf_cmnd) {
 		csio_err(hw, "LUN reset (%d:%llu) timed out\n",
-			 cmnd->device->id, cmnd->device->lun);
+			 sdev->id, sdev->lun);
 
 		spin_lock_irq(&hw->lock);
 		csio_scsi_drvcleanup(ioreq);
@@ -2178,10 +2190,10 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	}
 
 	/* LUN reset returned, check cached status */
-	if (csio_priv(cmnd)->wr_status != FW_SUCCESS) {
+	if (csio_priv(tmf_cmnd)->wr_status != FW_SUCCESS) {
 		csio_err(hw, "LUN reset failed (%d:%llu), status: %d\n",
-			 cmnd->device->id, cmnd->device->lun,
-			 csio_priv(cmnd)->wr_status);
+			 sdev->id, sdev->lun,
+			 csio_priv(tmf_cmnd)->wr_status);
 		goto fail;
 	}
 
@@ -2201,7 +2213,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	if (retval != 0) {
 		csio_err(hw,
 			 "Attempt to abort I/Os during LUN reset of %llu"
-			 " returned %d\n", cmnd->device->lun, retval);
+			 " returned %d\n", sdev->lun, retval);
 		/* Return I/Os back to active_q */
 		spin_lock_irq(&hw->lock);
 		list_splice_tail_init(&local_q, &scsim->active_q);
@@ -2212,7 +2224,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	CSIO_INC_STATS(rn, n_lun_rst);
 
 	csio_info(hw, "LUN reset occurred (%d:%llu)\n",
-		  cmnd->device->id, cmnd->device->lun);
+		  sdev->id, sdev->lun);
 
 	return SUCCESS;
 
-- 
2.29.2

