Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF8ABC433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jan 2021 20:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D3FE2222D
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jan 2021 20:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbhAAUTy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jan 2021 15:19:54 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:38854 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727155AbhAAUTx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jan 2021 15:19:53 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id A570D128088F;
        Fri,  1 Jan 2021 12:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1609532352;
        bh=m6MAAPqyB/fWVkGQ1Ux7Q83yzg5276wMsAU/fcJeagI=;
        h=Message-ID:Subject:From:To:Date:From;
        b=pbqNLjLf2CydUWCKGovncCft6deKqY67ugzqMlxmVuNvn69j64iMfCee/W6t+1VOs
         XJdH9TmaYwZWjw8xKgg7Ar2eBx8pi/6VdoTIB8wde1OYLQsIqS4PvFfIM8SfP7jm6A
         6iCj9h5BUa93FYQ7ZeWF+f7opbN9qFCX+8eyNFKI=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pjLPqLSTCOnG; Fri,  1 Jan 2021 12:19:12 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 3FFA6128088E;
        Fri,  1 Jan 2021 12:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1609532352;
        bh=m6MAAPqyB/fWVkGQ1Ux7Q83yzg5276wMsAU/fcJeagI=;
        h=Message-ID:Subject:From:To:Date:From;
        b=pbqNLjLf2CydUWCKGovncCft6deKqY67ugzqMlxmVuNvn69j64iMfCee/W6t+1VOs
         XJdH9TmaYwZWjw8xKgg7Ar2eBx8pi/6VdoTIB8wde1OYLQsIqS4PvFfIM8SfP7jm6A
         6iCj9h5BUa93FYQ7ZeWF+f7opbN9qFCX+8eyNFKI=
Message-ID: <dd63a06d53c45f9511307085797086351784b1a3.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.11-rc1
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 01 Jan 2021 12:19:11 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a load of driver fixes (12 ufs, 1 mpt3sas, 1 cxgbi).  The big
core two fixes are for power management ("block: Do not accept any
requests while suspended" and "block: Fix a race in the runtime power
management code") which finally sorts out the resume problems we've
occasionally been having.  To make the resume fix, there are seven
necessary precursors which effectively renames REQ_PREEMPT to REQ_PM,
so every "special" request in block is automatically a power management
exempt one.  All of the non-PM preempt cases are removed except for the
one in the SCSI Parallel Interface (spi) domain validation which is a
genuine case where we have to run requests at high priority to validate
the bus so this becomes an autopm get/put protected request.

Originally this change was slated for the merge window but a late
arriving build problem with CONFIG_PM=n derailed that.  However, we
still need the change to fix the PM suspend bugs.  You can validate the
REQ_PREEMPT -> REQ_PM nature of the six transformational patches by
inspecting the output of

git diff fa4d0f1992a9..a4d34da715e3

The biggest risk in this code is the spi domain validation change, so
I've tested it extensively on my several parallel systems here without
incident and it's now run for over a week in -next on either side of
the merge window.

Our backport for stable plan is currently to see if we can get the
lion's share of the power management problems with the first pm fix
since the second one depends on the REQ_PM rename.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Adrian Hunter (4):
      scsi: ufs-pci: Enable UFSHCD_CAP_RPM_AUTOSUSPEND for Intel controllers
      scsi: ufs-pci: Fix recovery from hibernate exit errors for Intel controllers
      scsi: ufs-pci: Ensure UFS device is in PowerDown mode for suspend-to-disk ->poweroff()
      scsi: ufs-pci: Fix restore from S4 for Intel controllers

Alan Stern (1):
      scsi: block: Do not accept any requests while suspended

Bart Van Assche (7):
      scsi: block: Remove RQF_PREEMPT and BLK_MQ_REQ_PREEMPT
      scsi: core: Only process PM requests if rpm_status != RPM_ACTIVE
      scsi: scsi_transport_spi: Set RQF_PM for domain validation commands
      scsi: ide: Mark power management requests with RQF_PM instead of RQF_PREEMPT
      scsi: ide: Do not set the RQF_PREEMPT flag for sense requests
      scsi: block: Introduce BLK_MQ_REQ_PM
      scsi: block: Fix a race in the runtime power management code

Bean Huo (2):
      scsi: ufs: Fix wrong print message in dev_err()
      scsi: ufs: Remove unused macro definition POWER_DESC_MAX_SIZE

Dan Carpenter (1):
      scsi: mpt3sas: Signedness bug in _base_get_diag_triggers()

Randall Huang (1):
      scsi: ufs: Clear UAC for RPMB after ufshcd resets

Randy Dunlap (1):
      scsi: cxgb4i: Fix TLS dependency

Stanley Chu (4):
      scsi: ufs: Un-inline ufshcd_vops_device_reset function
      scsi: ufs: Re-enable WriteBooster after device reset
      scsi: ufs-mediatek: Keep VCC always-on for specific devices
      scsi: ufs: Allow regulators being always-on

Zhen Lei (1):
      scsi: ufs-mediatek: Use correct path to fix compile error

And the diffstat:

 block/blk-core.c                      | 13 ++++---
 block/blk-mq-debugfs.c                |  1 -
 block/blk-mq.c                        |  4 +-
 block/blk-pm.c                        | 15 ++++---
 block/blk-pm.h                        | 14 ++++---
 drivers/ide/ide-atapi.c               |  1 -
 drivers/ide/ide-io.c                  |  7 +---
 drivers/ide/ide-pm.c                  |  2 +-
 drivers/scsi/cxgbi/cxgb4i/Kconfig     |  1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c   |  2 +-
 drivers/scsi/scsi_lib.c               | 27 ++++++-------
 drivers/scsi/scsi_transport_spi.c     | 27 +++++++++----
 drivers/scsi/ufs/ufs-mediatek-trace.h |  2 +-
 drivers/scsi/ufs/ufs-mediatek.c       | 21 ++++++++++
 drivers/scsi/ufs/ufs-mediatek.h       |  1 +
 drivers/scsi/ufs/ufs.h                |  2 +-
 drivers/scsi/ufs/ufshcd-pci.c         | 73 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshcd.c             | 45 +++++++++++++--------
 drivers/scsi/ufs/ufshcd.h             | 14 +++----
 include/linux/blk-mq.h                |  4 +-
 include/linux/blkdev.h                | 18 ++++++---
 21 files changed, 208 insertions(+), 86 deletions(-)

With full diff below

James

---

diff --git a/block/blk-core.c b/block/blk-core.c
index 2db8bda43b6e..2d53e2ff48ff 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -18,6 +18,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/blk-mq.h>
+#include <linux/blk-pm.h>
 #include <linux/highmem.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
@@ -424,11 +425,11 @@ EXPORT_SYMBOL(blk_cleanup_queue);
 /**
  * blk_queue_enter() - try to increase q->q_usage_counter
  * @q: request queue pointer
- * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PREEMPT
+ * @flags: BLK_MQ_REQ_NOWAIT and/or BLK_MQ_REQ_PM
  */
 int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 {
-	const bool pm = flags & BLK_MQ_REQ_PREEMPT;
+	const bool pm = flags & BLK_MQ_REQ_PM;
 
 	while (true) {
 		bool success = false;
@@ -440,7 +441,8 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 			 * responsible for ensuring that that counter is
 			 * globally visible before the queue is unfrozen.
 			 */
-			if (pm || !blk_queue_pm_only(q)) {
+			if ((pm && queue_rpm_status(q) != RPM_SUSPENDED) ||
+			    !blk_queue_pm_only(q)) {
 				success = true;
 			} else {
 				percpu_ref_put(&q->q_usage_counter);
@@ -465,8 +467,7 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 
 		wait_event(q->mq_freeze_wq,
 			   (!q->mq_freeze_depth &&
-			    (pm || (blk_pm_request_resume(q),
-				    !blk_queue_pm_only(q)))) ||
+			    blk_pm_resume_queue(pm, q)) ||
 			   blk_queue_dying(q));
 		if (blk_queue_dying(q))
 			return -ENODEV;
@@ -630,7 +631,7 @@ struct request *blk_get_request(struct request_queue *q, unsigned int op,
 	struct request *req;
 
 	WARN_ON_ONCE(op & REQ_NOWAIT);
-	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PREEMPT));
+	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PM));
 
 	req = blk_mq_alloc_request(q, op, flags);
 	if (!IS_ERR(req) && q->mq_ops->initialize_rq_fn)
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 3094542e12ae..9336a6f8d6ef 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -297,7 +297,6 @@ static const char *const rqf_name[] = {
 	RQF_NAME(MIXED_MERGE),
 	RQF_NAME(MQ_INFLIGHT),
 	RQF_NAME(DONTPREP),
-	RQF_NAME(PREEMPT),
 	RQF_NAME(FAILED),
 	RQF_NAME(QUIET),
 	RQF_NAME(ELVPRIV),
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1b25ec2fe9be..d50504888b68 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -292,8 +292,8 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 	rq->mq_hctx = data->hctx;
 	rq->rq_flags = 0;
 	rq->cmd_flags = data->cmd_flags;
-	if (data->flags & BLK_MQ_REQ_PREEMPT)
-		rq->rq_flags |= RQF_PREEMPT;
+	if (data->flags & BLK_MQ_REQ_PM)
+		rq->rq_flags |= RQF_PM;
 	if (blk_queue_io_stat(data->q))
 		rq->rq_flags |= RQF_IO_STAT;
 	INIT_LIST_HEAD(&rq->queuelist);
diff --git a/block/blk-pm.c b/block/blk-pm.c
index b85234d758f7..17bd020268d4 100644
--- a/block/blk-pm.c
+++ b/block/blk-pm.c
@@ -67,6 +67,10 @@ int blk_pre_runtime_suspend(struct request_queue *q)
 
 	WARN_ON_ONCE(q->rpm_status != RPM_ACTIVE);
 
+	spin_lock_irq(&q->queue_lock);
+	q->rpm_status = RPM_SUSPENDING;
+	spin_unlock_irq(&q->queue_lock);
+
 	/*
 	 * Increase the pm_only counter before checking whether any
 	 * non-PM blk_queue_enter() calls are in progress to avoid that any
@@ -89,15 +93,14 @@ int blk_pre_runtime_suspend(struct request_queue *q)
 	/* Switch q_usage_counter back to per-cpu mode. */
 	blk_mq_unfreeze_queue(q);
 
-	spin_lock_irq(&q->queue_lock);
-	if (ret < 0)
+	if (ret < 0) {
+		spin_lock_irq(&q->queue_lock);
+		q->rpm_status = RPM_ACTIVE;
 		pm_runtime_mark_last_busy(q->dev);
-	else
-		q->rpm_status = RPM_SUSPENDING;
-	spin_unlock_irq(&q->queue_lock);
+		spin_unlock_irq(&q->queue_lock);
 
-	if (ret)
 		blk_clear_pm_only(q);
+	}
 
 	return ret;
 }
diff --git a/block/blk-pm.h b/block/blk-pm.h
index ea5507d23e75..a2283cc9f716 100644
--- a/block/blk-pm.h
+++ b/block/blk-pm.h
@@ -6,11 +6,14 @@
 #include <linux/pm_runtime.h>
 
 #ifdef CONFIG_PM
-static inline void blk_pm_request_resume(struct request_queue *q)
+static inline int blk_pm_resume_queue(const bool pm, struct request_queue *q)
 {
-	if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
-		       q->rpm_status == RPM_SUSPENDING))
-		pm_request_resume(q->dev);
+	if (!q->dev || !blk_queue_pm_only(q))
+		return 1;	/* Nothing to do */
+	if (pm && q->rpm_status != RPM_SUSPENDED)
+		return 1;	/* Request allowed */
+	pm_request_resume(q->dev);
+	return 0;
 }
 
 static inline void blk_pm_mark_last_busy(struct request *rq)
@@ -44,8 +47,9 @@ static inline void blk_pm_put_request(struct request *rq)
 		--rq->q->nr_pending;
 }
 #else
-static inline void blk_pm_request_resume(struct request_queue *q)
+static inline int blk_pm_resume_queue(const bool pm, struct request_queue *q)
 {
+	return 1;
 }
 
 static inline void blk_pm_mark_last_busy(struct request *rq)
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 2162bc80f09e..013ad33fbbc8 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -223,7 +223,6 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 	sense_rq->rq_disk = rq->rq_disk;
 	sense_rq->cmd_flags = REQ_OP_DRV_IN;
 	ide_req(sense_rq)->type = ATA_PRIV_SENSE;
-	sense_rq->rq_flags |= RQF_PREEMPT;
 
 	req->cmd[0] = GPCMD_REQUEST_SENSE;
 	req->cmd[4] = cmd_len;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 1a53c7a75224..4867b67b60d6 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -515,15 +515,10 @@ blk_status_t ide_issue_rq(ide_drive_t *drive, struct request *rq,
 		 * above to return us whatever is in the queue. Since we call
 		 * ide_do_request() ourselves, we end up taking requests while
 		 * the queue is blocked...
-		 * 
-		 * We let requests forced at head of queue with ide-preempt
-		 * though. I hope that doesn't happen too much, hopefully not
-		 * unless the subdriver triggers such a thing in its own PM
-		 * state machine.
 		 */
 		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
 		    ata_pm_request(rq) == 0 &&
-		    (rq->rq_flags & RQF_PREEMPT) == 0) {
+		    (rq->rq_flags & RQF_PM) == 0) {
 			/* there should be no pending command at this point */
 			ide_unlock_port(hwif);
 			goto plug_device;
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 192e6c65d34e..82ab308f1aaf 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -77,7 +77,7 @@ int generic_ide_resume(struct device *dev)
 	}
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, BLK_MQ_REQ_PREEMPT);
+	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, BLK_MQ_REQ_PM);
 	ide_req(rq)->type = ATA_PRIV_PM_RESUME;
 	ide_req(rq)->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_RESUME;
diff --git a/drivers/scsi/cxgbi/cxgb4i/Kconfig b/drivers/scsi/cxgbi/cxgb4i/Kconfig
index b206e266b4e7..8b0deece9758 100644
--- a/drivers/scsi/cxgbi/cxgb4i/Kconfig
+++ b/drivers/scsi/cxgbi/cxgb4i/Kconfig
@@ -4,6 +4,7 @@ config SCSI_CXGB4_ISCSI
 	depends on PCI && INET && (IPV6 || IPV6=n)
 	depends on THERMAL || !THERMAL
 	depends on ETHERNET
+	depends on TLS || TLS=n
 	select NET_VENDOR_CHELSIO
 	select CHELSIO_T4
 	select CHELSIO_LIB
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index b129f3734ed0..26537d503a8b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5027,7 +5027,7 @@ _base_check_for_trigger_pages_support(struct MPT3SAS_ADAPTER *ioc)
 static void
 _base_get_diag_triggers(struct MPT3SAS_ADAPTER *ioc)
 {
-	u16 trigger_flags;
+	int trigger_flags;
 
 	/*
 	 * Default setting of master trigger.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b7ac14571415..91bc39a4c3c3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -249,7 +249,8 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 
 	req = blk_get_request(sdev->request_queue,
 			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);
+			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN,
+			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
 	if (IS_ERR(req))
 		return ret;
 	rq = scsi_req(req);
@@ -1206,6 +1207,8 @@ static blk_status_t
 scsi_device_state_check(struct scsi_device *sdev, struct request *req)
 {
 	switch (sdev->sdev_state) {
+	case SDEV_CREATED:
+		return BLK_STS_OK;
 	case SDEV_OFFLINE:
 	case SDEV_TRANSPORT_OFFLINE:
 		/*
@@ -1232,18 +1235,18 @@ scsi_device_state_check(struct scsi_device *sdev, struct request *req)
 		return BLK_STS_RESOURCE;
 	case SDEV_QUIESCE:
 		/*
-		 * If the devices is blocked we defer normal commands.
+		 * If the device is blocked we only accept power management
+		 * commands.
 		 */
-		if (req && !(req->rq_flags & RQF_PREEMPT))
+		if (req && WARN_ON_ONCE(!(req->rq_flags & RQF_PM)))
 			return BLK_STS_RESOURCE;
 		return BLK_STS_OK;
 	default:
 		/*
 		 * For any other not fully online state we only allow
-		 * special commands.  In particular any user initiated
-		 * command is not allowed.
+		 * power management commands.
 		 */
-		if (req && !(req->rq_flags & RQF_PREEMPT))
+		if (req && !(req->rq_flags & RQF_PM))
 			return BLK_STS_IOERR;
 		return BLK_STS_OK;
 	}
@@ -2517,15 +2520,13 @@ void sdev_evt_send_simple(struct scsi_device *sdev,
 EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
 
 /**
- *	scsi_device_quiesce - Block user issued commands.
+ *	scsi_device_quiesce - Block all commands except power management.
  *	@sdev:	scsi device to quiesce.
  *
  *	This works by trying to transition to the SDEV_QUIESCE state
  *	(which must be a legal transition).  When the device is in this
- *	state, only special requests will be accepted, all others will
- *	be deferred.  Since special requests may also be requeued requests,
- *	a successful return doesn't guarantee the device will be
- *	totally quiescent.
+ *	state, only power management requests will be accepted, all others will
+ *	be deferred.
  *
  *	Must be called with user context, may sleep.
  *
@@ -2587,12 +2588,12 @@ void scsi_device_resume(struct scsi_device *sdev)
 	 * device deleted during suspend)
 	 */
 	mutex_lock(&sdev->state_mutex);
+	if (sdev->sdev_state == SDEV_QUIESCE)
+		scsi_device_set_state(sdev, SDEV_RUNNING);
 	if (sdev->quiesced_by) {
 		sdev->quiesced_by = NULL;
 		blk_clear_pm_only(sdev->request_queue);
 	}
-	if (sdev->sdev_state == SDEV_QUIESCE)
-		scsi_device_set_state(sdev, SDEV_RUNNING);
 	mutex_unlock(&sdev->state_mutex);
 }
 EXPORT_SYMBOL(scsi_device_resume);
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f3d5b1bbd5aa..c37dd15d16d2 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -117,12 +117,16 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		sshdr = &sshdr_tmp;
 
 	for(i = 0; i < DV_RETRIES; i++) {
+		/*
+		 * The purpose of the RQF_PM flag below is to bypass the
+		 * SDEV_QUIESCE state.
+		 */
 		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
 				      sshdr, DV_TIMEOUT, /* retries */ 1,
 				      REQ_FAILFAST_DEV |
 				      REQ_FAILFAST_TRANSPORT |
 				      REQ_FAILFAST_DRIVER,
-				      0, NULL);
+				      RQF_PM, NULL);
 		if (driver_byte(result) != DRIVER_SENSE ||
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
@@ -1005,23 +1009,26 @@ spi_dv_device(struct scsi_device *sdev)
 	 */
 	lock_system_sleep();
 
+	if (scsi_autopm_get_device(sdev))
+		goto unlock_system_sleep;
+
 	if (unlikely(spi_dv_in_progress(starget)))
-		goto unlock;
+		goto put_autopm;
 
 	if (unlikely(scsi_device_get(sdev)))
-		goto unlock;
+		goto put_autopm;
 
 	spi_dv_in_progress(starget) = 1;
 
 	buffer = kzalloc(len, GFP_KERNEL);
 
 	if (unlikely(!buffer))
-		goto out_put;
+		goto put_sdev;
 
 	/* We need to verify that the actual device will quiesce; the
 	 * later target quiesce is just a nice to have */
 	if (unlikely(scsi_device_quiesce(sdev)))
-		goto out_free;
+		goto free_buffer;
 
 	scsi_target_quiesce(starget);
 
@@ -1041,12 +1048,16 @@ spi_dv_device(struct scsi_device *sdev)
 
 	spi_initial_dv(starget) = 1;
 
- out_free:
+free_buffer:
 	kfree(buffer);
- out_put:
+
+put_sdev:
 	spi_dv_in_progress(starget) = 0;
 	scsi_device_put(sdev);
-unlock:
+put_autopm:
+	scsi_autopm_put_device(sdev);
+
+unlock_system_sleep:
 	unlock_system_sleep();
 }
 EXPORT_SYMBOL(spi_dv_device);
diff --git a/drivers/scsi/ufs/ufs-mediatek-trace.h b/drivers/scsi/ufs/ufs-mediatek-trace.h
index fd6f84c1b4e2..895e82ea6ece 100644
--- a/drivers/scsi/ufs/ufs-mediatek-trace.h
+++ b/drivers/scsi/ufs/ufs-mediatek-trace.h
@@ -31,6 +31,6 @@ TRACE_EVENT(ufs_mtk_event,
 
 #undef TRACE_INCLUDE_PATH
 #undef TRACE_INCLUDE_FILE
-#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_PATH ../../drivers/scsi/ufs/
 #define TRACE_INCLUDE_FILE ufs-mediatek-trace
 #include <trace/define_trace.h>
diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 3522458db3bb..80618af7c872 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -70,6 +70,13 @@ static bool ufs_mtk_is_va09_supported(struct ufs_hba *hba)
 	return !!(host->caps & UFS_MTK_CAP_VA09_PWR_CTRL);
 }
 
+static bool ufs_mtk_is_broken_vcc(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+
+	return !!(host->caps & UFS_MTK_CAP_BROKEN_VCC);
+}
+
 static void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)
 {
 	u32 tmp;
@@ -514,6 +521,9 @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
 	if (of_property_read_bool(np, "mediatek,ufs-disable-ah8"))
 		host->caps |= UFS_MTK_CAP_DISABLE_AH8;
 
+	if (of_property_read_bool(np, "mediatek,ufs-broken-vcc"))
+		host->caps |= UFS_MTK_CAP_BROKEN_VCC;
+
 	dev_info(hba->dev, "caps: 0x%x", host->caps);
 }
 
@@ -1003,6 +1013,17 @@ static int ufs_mtk_apply_dev_quirks(struct ufs_hba *hba)
 static void ufs_mtk_fixup_dev_quirks(struct ufs_hba *hba)
 {
 	ufshcd_fixup_dev_quirks(hba, ufs_mtk_dev_fixups);
+
+	if (ufs_mtk_is_broken_vcc(hba) && hba->vreg_info.vcc &&
+	    (hba->dev_quirks & UFS_DEVICE_QUIRK_DELAY_AFTER_LPM)) {
+		hba->vreg_info.vcc->always_on = true;
+		/*
+		 * VCC will be kept always-on thus we don't
+		 * need any delay during regulator operations
+		 */
+		hba->dev_quirks &= ~(UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM |
+			UFS_DEVICE_QUIRK_DELAY_AFTER_LPM);
+	}
 }
 
 static void ufs_mtk_event_notify(struct ufs_hba *hba,
diff --git a/drivers/scsi/ufs/ufs-mediatek.h b/drivers/scsi/ufs/ufs-mediatek.h
index 93d35097dfb0..3f0d3bb769e8 100644
--- a/drivers/scsi/ufs/ufs-mediatek.h
+++ b/drivers/scsi/ufs/ufs-mediatek.h
@@ -81,6 +81,7 @@ enum ufs_mtk_host_caps {
 	UFS_MTK_CAP_BOOST_CRYPT_ENGINE         = 1 << 0,
 	UFS_MTK_CAP_VA09_PWR_CTRL              = 1 << 1,
 	UFS_MTK_CAP_DISABLE_AH8                = 1 << 2,
+	UFS_MTK_CAP_BROKEN_VCC                 = 1 << 3,
 };
 
 struct ufs_mtk_crypt_cfg {
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index d593edb48767..14dfda735adf 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -330,7 +330,6 @@ enum {
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
 };
 
-#define POWER_DESC_MAX_SIZE			0x62
 #define POWER_DESC_MAX_ACTV_ICC_LVLS		16
 
 /* Attribute  bActiveICCLevel parameter bit masks definitions */
@@ -513,6 +512,7 @@ struct ufs_query_res {
 struct ufs_vreg {
 	struct regulator *reg;
 	const char *name;
+	bool always_on;
 	bool enabled;
 	int min_uV;
 	int max_uV;
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index df3a564c3e33..fadd566025b8 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -148,6 +148,8 @@ static int ufs_intel_common_init(struct ufs_hba *hba)
 {
 	struct intel_host *host;
 
+	hba->caps |= UFSHCD_CAP_RPM_AUTOSUSPEND;
+
 	host = devm_kzalloc(hba->dev, sizeof(*host), GFP_KERNEL);
 	if (!host)
 		return -ENOMEM;
@@ -163,6 +165,41 @@ static void ufs_intel_common_exit(struct ufs_hba *hba)
 	intel_ltr_hide(hba->dev);
 }
 
+static int ufs_intel_resume(struct ufs_hba *hba, enum ufs_pm_op op)
+{
+	/*
+	 * To support S4 (suspend-to-disk) with spm_lvl other than 5, the base
+	 * address registers must be restored because the restore kernel can
+	 * have used different addresses.
+	 */
+	ufshcd_writel(hba, lower_32_bits(hba->utrdl_dma_addr),
+		      REG_UTP_TRANSFER_REQ_LIST_BASE_L);
+	ufshcd_writel(hba, upper_32_bits(hba->utrdl_dma_addr),
+		      REG_UTP_TRANSFER_REQ_LIST_BASE_H);
+	ufshcd_writel(hba, lower_32_bits(hba->utmrdl_dma_addr),
+		      REG_UTP_TASK_REQ_LIST_BASE_L);
+	ufshcd_writel(hba, upper_32_bits(hba->utmrdl_dma_addr),
+		      REG_UTP_TASK_REQ_LIST_BASE_H);
+
+	if (ufshcd_is_link_hibern8(hba)) {
+		int ret = ufshcd_uic_hibern8_exit(hba);
+
+		if (!ret) {
+			ufshcd_set_link_active(hba);
+		} else {
+			dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
+				__func__, ret);
+			/*
+			 * Force reset and restore. Any other actions can lead
+			 * to an unrecoverable state.
+			 */
+			ufshcd_set_link_off(hba);
+		}
+	}
+
+	return 0;
+}
+
 static int ufs_intel_ehl_init(struct ufs_hba *hba)
 {
 	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
@@ -174,6 +211,7 @@ static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 	.init			= ufs_intel_common_init,
 	.exit			= ufs_intel_common_exit,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.resume			= ufs_intel_resume,
 };
 
 static struct ufs_hba_variant_ops ufs_intel_ehl_hba_vops = {
@@ -181,6 +219,7 @@ static struct ufs_hba_variant_ops ufs_intel_ehl_hba_vops = {
 	.init			= ufs_intel_ehl_init,
 	.exit			= ufs_intel_common_exit,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.resume			= ufs_intel_resume,
 };
 
 #ifdef CONFIG_PM_SLEEP
@@ -207,6 +246,30 @@ static int ufshcd_pci_resume(struct device *dev)
 {
 	return ufshcd_system_resume(dev_get_drvdata(dev));
 }
+
+/**
+ * ufshcd_pci_poweroff - suspend-to-disk poweroff function
+ * @dev: pointer to PCI device handle
+ *
+ * Returns 0 if successful
+ * Returns non-zero otherwise
+ */
+static int ufshcd_pci_poweroff(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int spm_lvl = hba->spm_lvl;
+	int ret;
+
+	/*
+	 * For poweroff we need to set the UFS device to PowerDown mode.
+	 * Force spm_lvl to ensure that.
+	 */
+	hba->spm_lvl = 5;
+	ret = ufshcd_system_suspend(hba);
+	hba->spm_lvl = spm_lvl;
+	return ret;
+}
+
 #endif /* !CONFIG_PM_SLEEP */
 
 #ifdef CONFIG_PM
@@ -302,8 +365,14 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 }
 
 static const struct dev_pm_ops ufshcd_pci_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_pci_suspend,
-				ufshcd_pci_resume)
+#ifdef CONFIG_PM_SLEEP
+	.suspend	= ufshcd_pci_suspend,
+	.resume		= ufshcd_pci_resume,
+	.freeze		= ufshcd_pci_suspend,
+	.thaw		= ufshcd_pci_resume,
+	.poweroff	= ufshcd_pci_poweroff,
+	.restore	= ufshcd_pci_resume,
+#endif
 	SET_RUNTIME_PM_OPS(ufshcd_pci_runtime_suspend,
 			   ufshcd_pci_runtime_resume,
 			   ufshcd_pci_runtime_idle)
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c1c401b2b69d..e221add25a7e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -225,6 +225,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba);
 static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
+static int ufshcd_clear_ua_wluns(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
@@ -580,6 +581,23 @@ static void ufshcd_print_pwr_info(struct ufs_hba *hba)
 		 hba->pwr_info.hs_rate);
 }
 
+static void ufshcd_device_reset(struct ufs_hba *hba)
+{
+	int err;
+
+	err = ufshcd_vops_device_reset(hba);
+
+	if (!err) {
+		ufshcd_set_ufs_dev_active(hba);
+		if (ufshcd_is_wb_allowed(hba)) {
+			hba->wb_enabled = false;
+			hba->wb_buf_flush_enabled = false;
+		}
+	}
+	if (err != -EOPNOTSUPP)
+		ufshcd_update_evt_hist(hba, UFS_EVT_DEV_RESET, err);
+}
+
 void ufshcd_delay_us(unsigned long us, unsigned long tolerance)
 {
 	if (!us)
@@ -3641,7 +3659,7 @@ static int ufshcd_dme_enable(struct ufs_hba *hba)
 	ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
 	if (ret)
 		dev_err(hba->dev,
-			"dme-reset: error code %d\n", ret);
+			"dme-enable: error code %d\n", ret);
 
 	return ret;
 }
@@ -3932,7 +3950,7 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* Reset the attached device */
-	ufshcd_vops_device_reset(hba);
+	ufshcd_device_reset(hba);
 
 	ret = ufshcd_host_reset_and_restore(hba);
 
@@ -6895,7 +6913,8 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 
 	/* Establish the link again and restore the device */
 	err = ufshcd_probe_hba(hba, false);
-
+	if (!err)
+		ufshcd_clear_ua_wluns(hba);
 out:
 	if (err)
 		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
@@ -6933,7 +6952,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 
 	do {
 		/* Reset the attached device */
-		ufshcd_vops_device_reset(hba);
+		ufshcd_device_reset(hba);
 
 		err = ufshcd_host_reset_and_restore(hba);
 	} while (err && --retries);
@@ -8010,7 +8029,7 @@ static int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg *vreg)
 {
 	int ret = 0;
 
-	if (!vreg || !vreg->enabled)
+	if (!vreg || !vreg->enabled || vreg->always_on)
 		goto out;
 
 	ret = regulator_disable(vreg->reg);
@@ -8379,13 +8398,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * handling context.
 	 */
 	hba->host->eh_noresume = 1;
-	if (hba->wlun_dev_clr_ua) {
-		ret = ufshcd_send_request_sense(hba, sdp);
-		if (ret)
-			goto out;
-		/* Unit attention condition is cleared now */
-		hba->wlun_dev_clr_ua = false;
-	}
+	ufshcd_clear_ua_wluns(hba);
 
 	cmd[4] = pwr_mode << 4;
 
@@ -8406,7 +8419,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 
 	if (!ret)
 		hba->curr_dev_pwr_mode = pwr_mode;
-out:
+
 	scsi_device_put(sdp);
 	hba->host->eh_noresume = 0;
 	return ret;
@@ -8712,7 +8725,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	 * further below.
 	 */
 	if (ufshcd_is_ufs_dev_deepsleep(hba)) {
-		ufshcd_vops_device_reset(hba);
+		ufshcd_device_reset(hba);
 		WARN_ON(!ufshcd_is_link_off(hba));
 	}
 	if (ufshcd_is_link_hibern8(hba) && !ufshcd_uic_hibern8_exit(hba))
@@ -8722,7 +8735,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 set_dev_active:
 	/* Can also get here needing to exit DeepSleep */
 	if (ufshcd_is_ufs_dev_deepsleep(hba)) {
-		ufshcd_vops_device_reset(hba);
+		ufshcd_device_reset(hba);
 		ufshcd_host_reset_and_restore(hba);
 	}
 	if (!ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
@@ -9321,7 +9334,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	/* Reset the attached device */
-	ufshcd_vops_device_reset(hba);
+	ufshcd_device_reset(hba);
 
 	ufshcd_init_crypto(hba);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 08c8a591e6b0..9bb5f0ed4124 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1216,16 +1216,12 @@ static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
 		hba->vops->dbg_register_dump(hba);
 }
 
-static inline void ufshcd_vops_device_reset(struct ufs_hba *hba)
+static inline int ufshcd_vops_device_reset(struct ufs_hba *hba)
 {
-	if (hba->vops && hba->vops->device_reset) {
-		int err = hba->vops->device_reset(hba);
-
-		if (!err)
-			ufshcd_set_ufs_dev_active(hba);
-		if (err != -EOPNOTSUPP)
-			ufshcd_update_evt_hist(hba, UFS_EVT_DEV_RESET, err);
-	}
+	if (hba->vops && hba->vops->device_reset)
+		return hba->vops->device_reset(hba);
+
+	return -EOPNOTSUPP;
 }
 
 static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index b23eeca4d677..88af1df94308 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -444,8 +444,8 @@ enum {
 	BLK_MQ_REQ_NOWAIT	= (__force blk_mq_req_flags_t)(1 << 0),
 	/* allocate from reserved pool */
 	BLK_MQ_REQ_RESERVED	= (__force blk_mq_req_flags_t)(1 << 1),
-	/* set RQF_PREEMPT */
-	BLK_MQ_REQ_PREEMPT	= (__force blk_mq_req_flags_t)(1 << 3),
+	/* set RQF_PM */
+	BLK_MQ_REQ_PM		= (__force blk_mq_req_flags_t)(1 << 2),
 };
 
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 639cae2c158b..2b6fc3fb3a99 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -79,9 +79,6 @@ typedef __u32 __bitwise req_flags_t;
 #define RQF_MQ_INFLIGHT		((__force req_flags_t)(1 << 6))
 /* don't call prep for this one */
 #define RQF_DONTPREP		((__force req_flags_t)(1 << 7))
-/* set for "ide_preempt" requests and also for requests for which the SCSI
-   "quiesce" state must be ignored. */
-#define RQF_PREEMPT		((__force req_flags_t)(1 << 8))
 /* vaguely specified driver internal error.  Ignored by the block layer */
 #define RQF_FAILED		((__force req_flags_t)(1 << 10))
 /* don't warn about errors */
@@ -430,8 +427,7 @@ struct request_queue {
 	unsigned long		queue_flags;
 	/*
 	 * Number of contexts that have called blk_set_pm_only(). If this
-	 * counter is above zero then only RQF_PM and RQF_PREEMPT requests are
-	 * processed.
+	 * counter is above zero then only RQF_PM requests are processed.
 	 */
 	atomic_t		pm_only;
 
@@ -696,6 +692,18 @@ static inline bool queue_is_mq(struct request_queue *q)
 	return q->mq_ops;
 }
 
+#ifdef CONFIG_PM
+static inline enum rpm_status queue_rpm_status(struct request_queue *q)
+{
+	return q->rpm_status;
+}
+#else
+static inline enum rpm_status queue_rpm_status(struct request_queue *q)
+{
+	return RPM_ACTIVE;
+}
+#endif
+
 static inline enum blk_zoned_model
 blk_queue_zoned_model(struct request_queue *q)
 {

