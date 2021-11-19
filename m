Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EACC4C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 18:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAA7761A40
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 18:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhKSSXP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 13:23:15 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:46704 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231751AbhKSSXO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Nov 2021 13:23:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1637346012;
        bh=Y88sxabhj9CGU3Tbdikvp0XrX7xemk5smViQuCFxuE8=;
        h=Message-ID:Subject:From:To:Date:From;
        b=El4Dc4Gais46ZDSUQxmWrUlE9Alk2WtJS2Griz8monbOzTB0WecDo7CUJqMk4jOOq
         JwmUZz1TfO4Pce5i90z3FoDiRUt1O/9HxhRz5nVzaJro/dLFz1PIpToA+ITu3SlEqV
         1f6RU2f7V6FUZm6aIj2daYrLXz8/jxRAsgjiwR8I=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 92FE61280C1F;
        Fri, 19 Nov 2021 13:20:12 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sDxXRArctZ4u; Fri, 19 Nov 2021 13:20:12 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1637346012;
        bh=Y88sxabhj9CGU3Tbdikvp0XrX7xemk5smViQuCFxuE8=;
        h=Message-ID:Subject:From:To:Date:From;
        b=El4Dc4Gais46ZDSUQxmWrUlE9Alk2WtJS2Griz8monbOzTB0WecDo7CUJqMk4jOOq
         JwmUZz1TfO4Pce5i90z3FoDiRUt1O/9HxhRz5nVzaJro/dLFz1PIpToA+ITu3SlEqV
         1f6RU2f7V6FUZm6aIj2daYrLXz8/jxRAsgjiwR8I=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 0CAA7128010E;
        Fri, 19 Nov 2021 13:20:11 -0500 (EST)
Message-ID: <0a508ff31bbfa9cd73c24713c54a29ac459e3254.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.16-rc1
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 19 Nov 2021 13:20:10 -0500
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Six fixes, five in drivers (ufs, qla2xxx, iscsi) and one core change to
fix a regression in user space device state setting, which is used by
the iscsi daemons to effect device recovery.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Adrian Hunter (2):
      scsi: ufs: core: Fix another task management completion race
      scsi: ufs: core: Fix task management completion timeout race

Bart Van Assche (1):
      scsi: ufs: core: Improve SCSI abort handling

Ewan D. Milne (1):
      scsi: qla2xxx: Fix mailbox direction flags in qla2xxx_get_adapter_id()

Mike Christie (2):
      scsi: core: sysfs: Fix hang when device state is set via sysfs
      scsi: iscsi: Unblock session then wake up error handler

And the diffstat:

 drivers/scsi/qla2xxx/qla_mbx.c      |  6 ++----
 drivers/scsi/scsi_sysfs.c           | 30 +++++++++++++++++++-----------
 drivers/scsi/scsi_transport_iscsi.c |  6 +++---
 drivers/scsi/ufs/ufshcd.c           |  9 ++-------
 4 files changed, 26 insertions(+), 25 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 73a353153d33..10d2655ef676 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1695,10 +1695,8 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
 		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10;
 	if (IS_FWI2_CAPABLE(vha->hw))
 		mcp->in_mb |= MBX_19|MBX_18|MBX_17|MBX_16;
-	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw)) {
-		mcp->in_mb |= MBX_15;
-		mcp->out_mb |= MBX_7|MBX_21|MBX_22|MBX_23;
-	}
+	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw))
+		mcp->in_mb |= MBX_15|MBX_21|MBX_22|MBX_23;
 
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 55addd78fde4..7afcec250f9b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -792,6 +792,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	int i, ret;
 	struct scsi_device *sdev = to_scsi_device(dev);
 	enum scsi_device_state state = 0;
+	bool rescan_dev = false;
 
 	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
 		const int len = strlen(sdev_states[i].name);
@@ -810,20 +811,27 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	}
 
 	mutex_lock(&sdev->state_mutex);
-	ret = scsi_device_set_state(sdev, state);
-	/*
-	 * If the device state changes to SDEV_RUNNING, we need to
-	 * run the queue to avoid I/O hang, and rescan the device
-	 * to revalidate it. Running the queue first is necessary
-	 * because another thread may be waiting inside
-	 * blk_mq_freeze_queue_wait() and because that call may be
-	 * waiting for pending I/O to finish.
-	 */
-	if (ret == 0 && state == SDEV_RUNNING) {
+	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
+		ret = count;
+	} else {
+		ret = scsi_device_set_state(sdev, state);
+		if (ret == 0 && state == SDEV_RUNNING)
+			rescan_dev = true;
+	}
+	mutex_unlock(&sdev->state_mutex);
+
+	if (rescan_dev) {
+		/*
+		 * If the device state changes to SDEV_RUNNING, we need to
+		 * run the queue to avoid I/O hang, and rescan the device
+		 * to revalidate it. Running the queue first is necessary
+		 * because another thread may be waiting inside
+		 * blk_mq_freeze_queue_wait() and because that call may be
+		 * waiting for pending I/O to finish.
+		 */
 		blk_mq_run_hw_queues(sdev->request_queue, true);
 		scsi_rescan_device(dev);
 	}
-	mutex_unlock(&sdev->state_mutex);
 
 	return ret == 0 ? count : -EINVAL;
 }
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 78343d3f9385..554b6f784223 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1899,12 +1899,12 @@ static void session_recovery_timedout(struct work_struct *work)
 	}
 	spin_unlock_irqrestore(&session->lock, flags);
 
-	if (session->transport->session_recovery_timedout)
-		session->transport->session_recovery_timedout(session);
-
 	ISCSI_DBG_TRANS_SESSION(session, "Unblocking SCSI target\n");
 	scsi_target_unblock(&session->dev, SDEV_TRANSPORT_OFFLINE);
 	ISCSI_DBG_TRANS_SESSION(session, "Completed unblocking SCSI target\n");
+
+	if (session->transport->session_recovery_timedout)
+		session->transport->session_recovery_timedout(session);
 }
 
 static void __iscsi_unblock_session(struct work_struct *work)
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index afd38142b1c0..13c09dbd99b9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6453,9 +6453,8 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 	irqreturn_t ret = IRQ_NONE;
 	int tag;
 
-	pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
-
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
 	issued = hba->outstanding_tasks & ~pending;
 	for_each_set_bit(tag, &issued, hba->nutmrs) {
 		struct request *req = hba->tmf_rqs[tag];
@@ -6616,11 +6615,6 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	err = wait_for_completion_io_timeout(&wait,
 			msecs_to_jiffies(TM_CMD_TIMEOUT));
 	if (!err) {
-		/*
-		 * Make sure that ufshcd_compl_tm() does not trigger a
-		 * use-after-free.
-		 */
-		req->end_io_data = NULL;
 		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_ERR);
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
@@ -7116,6 +7110,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto release;
 	}
 
+	lrbp->cmd = NULL;
 	err = SUCCESS;
 
 release:

