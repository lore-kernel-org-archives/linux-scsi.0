Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E845C4338F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 17:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C8CC60EBB
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 17:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbhHDRaN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 13:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhHDRaM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2021 13:30:12 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D4CC0613D5;
        Wed,  4 Aug 2021 10:29:59 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id DBEAB12810F5;
        Wed,  4 Aug 2021 10:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1628098198;
        bh=nV7FoaiBu/kfJ9Su7TbaD3GNW5DsSz4XpDp4JfntAFI=;
        h=Message-ID:Subject:From:To:Date:From;
        b=V/zfj6h48crdI4Pg/qv7mGK9D2+v5oMvZBiEWVT+YJ3q3X3GjCyDBKgAoXz5ItTcR
         uxoP5r0Ua0PjIzQJjC3I5irrFSHmpV2bFX0yAoN44L+fHK2i8oXoYJnLpndq5PabD5
         0fcxEes5a7pia4De3EHBAMaoBk4dUepmPAeJ4mAM=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id a1Szdpb_fKiV; Wed,  4 Aug 2021 10:29:58 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 8217812810F4;
        Wed,  4 Aug 2021 10:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1628098198;
        bh=nV7FoaiBu/kfJ9Su7TbaD3GNW5DsSz4XpDp4JfntAFI=;
        h=Message-ID:Subject:From:To:Date:From;
        b=V/zfj6h48crdI4Pg/qv7mGK9D2+v5oMvZBiEWVT+YJ3q3X3GjCyDBKgAoXz5ItTcR
         uxoP5r0Ua0PjIzQJjC3I5irrFSHmpV2bFX0yAoN44L+fHK2i8oXoYJnLpndq5PabD5
         0fcxEes5a7pia4De3EHBAMaoBk4dUepmPAeJ4mAM=
Message-ID: <271d6e9404dd961ec5ca9983b4730f61401bc3be.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.14-rc4
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Wed, 04 Aug 2021 10:29:57 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Seven fixes, five in drivers.  The two core changes are a trivial
warning removal in scsi_scan.c and a change to rescan for capacity when
a device makes a user induced (via a write to the state variable)
offline->running transition to fix issues with device mapper.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Harshvardhan Jha (1):
      scsi: megaraid_mm: Fix end of loop tests for list_for_each_entry()

Igor Pylypiv (1):
      scsi: pm80xx: Fix TMF task completion race condition

Li Manyi (1):
      scsi: sr: Return correct event when media event code is 3

Sreekanth Reddy (1):
      scsi: core: Avoid printing an error if target_alloc() returns -ENXIO

Tyrel Datwyler (1):
      scsi: ibmvfc: Fix command state accounting and stale response detection

Ye Bin (1):
      scsi: scsi_dh_rdac: Avoid crash during rdac_bus_attach()

lijinlin (1):
      scsi: core: Fix capacity set to zero after offlinining device

And the diffstat:

 drivers/scsi/device_handler/scsi_dh_rdac.c |  4 ++--
 drivers/scsi/ibmvscsi/ibmvfc.c             | 19 ++++++++++++++++--
 drivers/scsi/ibmvscsi/ibmvfc.h             |  1 +
 drivers/scsi/megaraid/megaraid_mm.c        | 21 ++++++++++++++------
 drivers/scsi/pm8001/pm8001_sas.c           | 32 ++++++++++++++----------------
 drivers/scsi/scsi_scan.c                   |  3 ++-
 drivers/scsi/scsi_sysfs.c                  |  9 ++++++---
 drivers/scsi/sr.c                          |  2 +-
 8 files changed, 59 insertions(+), 32 deletions(-)

With full diff below

James

---

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 25f6e1ac9e7b..66652ab409cc 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -453,8 +453,8 @@ static int initialize_controller(struct scsi_device *sdev,
 		if (!h->ctlr)
 			err = SCSI_DH_RES_TEMP_UNAVAIL;
 		else {
-			list_add_rcu(&h->node, &h->ctlr->dh_list);
 			h->sdev = sdev;
+			list_add_rcu(&h->node, &h->ctlr->dh_list);
 		}
 		spin_unlock(&list_lock);
 		err = SCSI_DH_OK;
@@ -778,11 +778,11 @@ static void rdac_bus_detach( struct scsi_device *sdev )
 	spin_lock(&list_lock);
 	if (h->ctlr) {
 		list_del_rcu(&h->node);
-		h->sdev = NULL;
 		kref_put(&h->ctlr->kref, release_controller);
 	}
 	spin_unlock(&list_lock);
 	sdev->handler_data = NULL;
+	synchronize_rcu();
 	kfree(h);
 }
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index bee1bec49c09..935b01ee44b7 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -807,6 +807,13 @@ static int ibmvfc_init_event_pool(struct ibmvfc_host *vhost,
 	for (i = 0; i < size; ++i) {
 		struct ibmvfc_event *evt = &pool->events[i];
 
+		/*
+		 * evt->active states
+		 *  1 = in flight
+		 *  0 = being completed
+		 * -1 = free/freed
+		 */
+		atomic_set(&evt->active, -1);
 		atomic_set(&evt->free, 1);
 		evt->crq.valid = 0x80;
 		evt->crq.ioba = cpu_to_be64(pool->iu_token + (sizeof(*evt->xfer_iu) * i));
@@ -1017,6 +1024,7 @@ static void ibmvfc_free_event(struct ibmvfc_event *evt)
 
 	BUG_ON(!ibmvfc_valid_event(pool, evt));
 	BUG_ON(atomic_inc_return(&evt->free) != 1);
+	BUG_ON(atomic_dec_and_test(&evt->active));
 
 	spin_lock_irqsave(&evt->queue->l_lock, flags);
 	list_add_tail(&evt->queue_list, &evt->queue->free);
@@ -1072,6 +1080,12 @@ static void ibmvfc_complete_purge(struct list_head *purge_list)
  **/
 static void ibmvfc_fail_request(struct ibmvfc_event *evt, int error_code)
 {
+	/*
+	 * Anything we are failing should still be active. Otherwise, it
+	 * implies we already got a response for the command and are doing
+	 * something bad like double completing it.
+	 */
+	BUG_ON(!atomic_dec_and_test(&evt->active));
 	if (evt->cmnd) {
 		evt->cmnd->result = (error_code << 16);
 		evt->done = ibmvfc_scsi_eh_done;
@@ -1723,6 +1737,7 @@ static int ibmvfc_send_event(struct ibmvfc_event *evt,
 
 		evt->done(evt);
 	} else {
+		atomic_set(&evt->active, 1);
 		spin_unlock_irqrestore(&evt->queue->l_lock, flags);
 		ibmvfc_trc_start(evt);
 	}
@@ -3251,7 +3266,7 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
 		return;
 	}
 
-	if (unlikely(atomic_read(&evt->free))) {
+	if (unlikely(atomic_dec_if_positive(&evt->active))) {
 		dev_err(vhost->dev, "Received duplicate correlation_token 0x%08llx!\n",
 			crq->ioba);
 		return;
@@ -3778,7 +3793,7 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
 		return;
 	}
 
-	if (unlikely(atomic_read(&evt->free))) {
+	if (unlikely(atomic_dec_if_positive(&evt->active))) {
 		dev_err(vhost->dev, "Received duplicate correlation_token 0x%08llx!\n",
 			crq->ioba);
 		return;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 4f0f3baefae4..92fb889d7eb0 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -745,6 +745,7 @@ struct ibmvfc_event {
 	struct ibmvfc_target *tgt;
 	struct scsi_cmnd *cmnd;
 	atomic_t free;
+	atomic_t active;
 	union ibmvfc_iu *xfer_iu;
 	void (*done)(struct ibmvfc_event *evt);
 	void (*_done)(struct ibmvfc_event *evt);
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index abf7b401f5b9..c509440bd161 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -238,7 +238,7 @@ mraid_mm_get_adapter(mimd_t __user *umimd, int *rval)
 	mimd_t		mimd;
 	uint32_t	adapno;
 	int		iterator;
-
+	bool		is_found;
 
 	if (copy_from_user(&mimd, umimd, sizeof(mimd_t))) {
 		*rval = -EFAULT;
@@ -254,12 +254,16 @@ mraid_mm_get_adapter(mimd_t __user *umimd, int *rval)
 
 	adapter = NULL;
 	iterator = 0;
+	is_found = false;
 
 	list_for_each_entry(adapter, &adapters_list_g, list) {
-		if (iterator++ == adapno) break;
+		if (iterator++ == adapno) {
+			is_found = true;
+			break;
+		}
 	}
 
-	if (!adapter) {
+	if (!is_found) {
 		*rval = -ENODEV;
 		return NULL;
 	}
@@ -725,6 +729,7 @@ ioctl_done(uioc_t *kioc)
 	uint32_t	adapno;
 	int		iterator;
 	mraid_mmadp_t*	adapter;
+	bool		is_found;
 
 	/*
 	 * When the kioc returns from driver, make sure it still doesn't
@@ -747,19 +752,23 @@ ioctl_done(uioc_t *kioc)
 		iterator	= 0;
 		adapter		= NULL;
 		adapno		= kioc->adapno;
+		is_found	= false;
 
 		con_log(CL_ANN, ( KERN_WARNING "megaraid cmm: completed "
 					"ioctl that was timedout before\n"));
 
 		list_for_each_entry(adapter, &adapters_list_g, list) {
-			if (iterator++ == adapno) break;
+			if (iterator++ == adapno) {
+				is_found = true;
+				break;
+			}
 		}
 
 		kioc->timedout = 0;
 
-		if (adapter) {
+		if (is_found)
 			mraid_mm_dealloc_kioc( adapter, kioc );
-		}
+
 	}
 	else {
 		wake_up(&wait_q);
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 48548a95327b..32e60f0c3b14 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -684,8 +684,7 @@ int pm8001_dev_found(struct domain_device *dev)
 
 void pm8001_task_done(struct sas_task *task)
 {
-	if (!del_timer(&task->slow_task->timer))
-		return;
+	del_timer(&task->slow_task->timer);
 	complete(&task->slow_task->completion);
 }
 
@@ -693,9 +692,14 @@ static void pm8001_tmf_timedout(struct timer_list *t)
 {
 	struct sas_task_slow *slow = from_timer(slow, t, timer);
 	struct sas_task *task = slow->task;
+	unsigned long flags;
 
-	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
-	complete(&task->slow_task->completion);
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
+		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+		complete(&task->slow_task->completion);
+	}
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
 }
 
 #define PM8001_TASK_TIMEOUT 20
@@ -748,13 +752,10 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 		}
 		res = -TMF_RESP_FUNC_FAILED;
 		/* Even TMF timed out, return direct. */
-		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
-			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-				pm8001_dbg(pm8001_ha, FAIL,
-					   "TMF task[%x]timeout.\n",
-					   tmf->tmf);
-				goto ex_err;
-			}
+		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
+			pm8001_dbg(pm8001_ha, FAIL, "TMF task[%x]timeout.\n",
+				   tmf->tmf);
+			goto ex_err;
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
@@ -834,12 +835,9 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 		wait_for_completion(&task->slow_task->completion);
 		res = TMF_RESP_FUNC_FAILED;
 		/* Even TMF timed out, return direct. */
-		if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
-			if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
-				pm8001_dbg(pm8001_ha, FAIL,
-					   "TMF task timeout.\n");
-				goto ex_err;
-			}
+		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
+			pm8001_dbg(pm8001_ha, FAIL, "TMF task timeout.\n");
+			goto ex_err;
 		}
 
 		if (task->task_status.resp == SAS_TASK_COMPLETE &&
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b059bf2b61d4..5b6996a2401b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -475,7 +475,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 		error = shost->hostt->target_alloc(starget);
 
 		if(error) {
-			dev_printk(KERN_ERR, dev, "target allocation failed, error %d\n", error);
+			if (error != -ENXIO)
+				dev_err(dev, "target allocation failed, error %d\n", error);
 			/* don't want scsi_target_reap to do the final
 			 * put because it will be under the host lock */
 			scsi_target_destroy(starget);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 32489d25158f..ae9bfc658203 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -807,11 +807,14 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	mutex_lock(&sdev->state_mutex);
 	ret = scsi_device_set_state(sdev, state);
 	/*
-	 * If the device state changes to SDEV_RUNNING, we need to run
-	 * the queue to avoid I/O hang.
+	 * If the device state changes to SDEV_RUNNING, we need to
+	 * rescan the device to revalidate it, and run the queue to
+	 * avoid I/O hang.
 	 */
-	if (ret == 0 && state == SDEV_RUNNING)
+	if (ret == 0 && state == SDEV_RUNNING) {
+		scsi_rescan_device(dev);
 		blk_mq_run_hw_queues(sdev->request_queue, true);
+	}
 	mutex_unlock(&sdev->state_mutex);
 
 	return ret == 0 ? count : -EINVAL;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 94c254e9012e..a6d3ac0a6cbc 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -221,7 +221,7 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	else if (med->media_event_code == 2)
 		return DISK_EVENT_MEDIA_CHANGE;
 	else if (med->media_event_code == 3)
-		return DISK_EVENT_EJECT_REQUEST;
+		return DISK_EVENT_MEDIA_CHANGE;
 	return 0;
 }
 

