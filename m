Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BAA6C18E5A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:30:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15AA120727
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgCJQas (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:30:48 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35576 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726708AbgCJQar (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:30:47 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E035BB331E97050D0D15;
        Wed, 11 Mar 2020 00:30:33 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Mar 2020 00:30:25 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hch@infradead.org>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v2 05/24] csiostor: use reserved command for LUN reset
Date:   Wed, 11 Mar 2020 00:25:31 +0800
Message-ID: <1583857550-12049-6-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

When issuing a LUN reset we should be using a reserved command
to avoid overwriting the original command.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/csiostor/csio_init.c |  3 +-
 drivers/scsi/csiostor/csio_scsi.c | 49 +++++++++++++++++++------------
 2 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 8dea7d53788a..3848289485c9 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -621,7 +621,8 @@ csio_shost_init(struct csio_hw *hw, struct device *dev,
 	/* Link common lnode to this lnode */
 	ln->dev_num = (shost->host_no << 16);
 
-	shost->can_queue = CSIO_MAX_QUEUE;
+	shost->can_queue = CSIO_MAX_QUEUE - 1;
+	shost->nr_reserved_cmds = 1;
 	shost->this_id = -1;
 	shost->unique_id = shost->host_no;
 	shost->max_cmd_len = 16; /* Max CDB length supported */
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 00cf33573136..9eacdb3d4f07 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2057,10 +2057,13 @@ csio_tm_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
 static int
 csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 {
-	struct csio_lnode *ln = shost_priv(cmnd->device->host);
+	struct scsi_cmnd *reset_cmnd;
+	struct scsi_device *sdev = cmnd->device;
+	struct Scsi_Host *shost = sdev->host;
+	struct csio_lnode *ln = shost_priv(sdev->host);
 	struct csio_hw *hw = csio_lnode_to_hw(ln);
 	struct csio_scsim *scsim = csio_hw_to_scsim(hw);
-	struct csio_rnode *rn = (struct csio_rnode *)(cmnd->device->hostdata);
+	struct csio_rnode *rn = (struct csio_rnode *)(sdev->hostdata);
 	struct csio_ioreq *ioreq = NULL;
 	struct csio_scsi_qset *sqset;
 	unsigned long flags;
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
 
@@ -2099,17 +2102,22 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 		csio_err(hw,
 			 "LUN reset cannot be issued on non-ready"
 			 " remote node ssni:0x%x (LUN:%llu)\n",
-			 rn->flowid, cmnd->device->lun);
+			 rn->flowid, sdev->lun);
 		goto fail;
 	}
 
+	reset_cmnd = scsi_get_reserved_cmd(shost);
+	if (!reset_cmnd) {
+		csio_err(hw, "No free TMF request\n");
+		goto fail;
+	}
 	/* Get a free ioreq structure - SM is already set to uninit */
 	ioreq = csio_get_scsi_ioreq_lock(hw, scsim);
 
 	if (!ioreq) {
 		csio_err(hw, "Out of IO request elements. Active # :%d\n",
 			 scsim->stats.n_active);
-		goto fail;
+		goto fail_ret_cmnd;
 	}
 
 	sqset			= &hw->sqset[ln->portid][smp_processor_id()];
@@ -2119,11 +2127,11 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	ioreq->iq_idx		= sqset->iq_idx;
 	ioreq->eq_idx		= sqset->eq_idx;
 
-	csio_scsi_cmnd(ioreq)	= cmnd;
-	cmnd->host_scribble	= (unsigned char *)ioreq;
-	cmnd->SCp.Status	= 0;
+	csio_scsi_cmnd(ioreq)	= reset_cmnd;
+	reset_cmnd->host_scribble	= (unsigned char *)ioreq;
+	reset_cmnd->SCp.Status	= 0;
 
-	cmnd->SCp.Message	= FCP_TMF_LUN_RESET;
+	reset_cmnd->SCp.Message	= FCP_TMF_LUN_RESET;
 	ioreq->tmo		= CSIO_SCSI_LUNRST_TMO_MS / 1000;
 
 	/*
@@ -2140,7 +2148,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	sld.level = CSIO_LEV_LUN;
 	sld.lnode = ioreq->lnode;
 	sld.rnode = ioreq->rnode;
-	sld.oslun = cmnd->device->lun;
+	sld.oslun = sdev->lun;
 
 	spin_lock_irqsave(&hw->lock, flags);
 	/* Kick off TM SM on the ioreq */
@@ -2156,14 +2164,14 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	csio_dbg(hw, "Waiting max %d secs for LUN reset completion\n",
 		    count * (CSIO_SCSI_TM_POLL_MS / 1000));
 	/* Wait for completion */
-	while ((((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == cmnd)
+	while ((((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == reset_cmnd)
 								&& count--)
 		msleep(CSIO_SCSI_TM_POLL_MS);
 
 	/* LUN reset timed-out */
-	if (((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == cmnd) {
+	if (((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == reset_cmnd) {
 		csio_err(hw, "LUN reset (%d:%llu) timed out\n",
-			 cmnd->device->id, cmnd->device->lun);
+			 sdev->id, sdev->lun);
 
 		spin_lock_irq(&hw->lock);
 		csio_scsi_drvcleanup(ioreq);
@@ -2174,11 +2182,12 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	}
 
 	/* LUN reset returned, check cached status */
-	if (cmnd->SCp.Status != FW_SUCCESS) {
+	if (reset_cmnd->SCp.Status != FW_SUCCESS) {
 		csio_err(hw, "LUN reset failed (%d:%llu), status: %d\n",
-			 cmnd->device->id, cmnd->device->lun, cmnd->SCp.Status);
-		goto fail;
+			 sdev->id, sdev->lun, reset_cmnd->SCp.Status);
+		goto fail_ret_cmnd;
 	}
+	scsi_put_reserved_cmd(reset_cmnd);
 
 	/* LUN reset succeeded, Start aborting affected I/Os */
 	/*
@@ -2196,7 +2205,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	if (retval != 0) {
 		csio_err(hw,
 			 "Attempt to abort I/Os during LUN reset of %llu"
-			 " returned %d\n", cmnd->device->lun, retval);
+			 " returned %d\n", sdev->lun, retval);
 		/* Return I/Os back to active_q */
 		spin_lock_irq(&hw->lock);
 		list_splice_tail_init(&local_q, &scsim->active_q);
@@ -2207,12 +2216,14 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	CSIO_INC_STATS(rn, n_lun_rst);
 
 	csio_info(hw, "LUN reset occurred (%d:%llu)\n",
-		  cmnd->device->id, cmnd->device->lun);
+		  sdev->id, sdev->lun);
 
 	return SUCCESS;
 
 fail_ret_ioreq:
 	csio_put_scsi_ioreq_lock(hw, scsim, ioreq);
+fail_ret_cmnd:
+	scsi_put_reserved_cmd(reset_cmnd);
 fail:
 	CSIO_INC_STATS(rn, n_lun_rst_fail);
 	return FAILED;
-- 
2.17.1

