From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 44/47] csiostor: use separate TMF command
Date: Wed, 28 Jun 2017 10:33:10 +0200
Message-ID: <1498638793-44672-45-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53829 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751584AbdF1Idl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:41 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Set one command aside as a TMF command, and use this command to
send the TMF. This avoids having to rely on the passed-in scsi
command when resetting the device.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/csiostor/csio_hw.h   |  2 ++
 drivers/scsi/csiostor/csio_init.c |  2 +-
 drivers/scsi/csiostor/csio_scsi.c | 44 ++++++++++++++++++++++++++-------------
 3 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_hw.h b/drivers/scsi/csiostor/csio_hw.h
index 9acb895..18b2afb 100644
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
index ea0c310..4fd03cf 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -628,7 +628,7 @@ struct csio_lnode *
 	/* Link common lnode to this lnode */
 	ln->dev_num = (shost->host_no << 16);
 
-	shost->can_queue = CSIO_MAX_QUEUE;
+	shost->can_queue = CSIO_MAX_QUEUE - 1;
 	shost->this_id = -1;
 	shost->unique_id = shost->host_no;
 	shost->max_cmd_len = 16; /* Max CDB length supported */
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 93b6891..133f683 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2055,17 +2055,20 @@ static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
 
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
@@ -2076,13 +2079,13 @@ static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
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
 
@@ -2102,7 +2105,15 @@ static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
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
 
@@ -2122,11 +2133,12 @@ static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
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
@@ -2143,7 +2155,7 @@ static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
 	sld.level = CSIO_LEV_LUN;
 	sld.lnode = ioreq->lnode;
 	sld.rnode = ioreq->rnode;
-	sld.oslun = cmnd->device->lun;
+	sld.oslun = sdev->lun;
 
 	spin_lock_irqsave(&hw->lock, flags);
 	/* Kick off TM SM on the ioreq */
@@ -2153,6 +2165,7 @@ static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
 	if (retval != 0) {
 		csio_err(hw, "Failed to issue LUN reset, req:%p, status:%d\n",
 			    ioreq, retval);
+		tmf_cmnd->host_scribble = NULL;
 		goto fail_ret_ioreq;
 	}
 
@@ -2166,20 +2179,21 @@ static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
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
 
@@ -2199,7 +2213,7 @@ static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
 	if (retval != 0) {
 		csio_err(hw,
 			 "Attempt to abort I/Os during LUN reset of %llu"
-			 " returned %d\n", cmnd->device->lun, retval);
+			 " returned %d\n", sdev->lun, retval);
 		/* Return I/Os back to active_q */
 		spin_lock_irq(&hw->lock);
 		list_splice_tail_init(&local_q, &scsim->active_q);
@@ -2210,7 +2224,7 @@ static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
 	CSIO_INC_STATS(rn, n_lun_rst);
 
 	csio_info(hw, "LUN reset occurred (%d:%llu)\n",
-		  cmnd->device->id, cmnd->device->lun);
+		  sdev->id, sdev->lun);
 
 	return SUCCESS;
 
-- 
1.8.5.6
