Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 742D8C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 02:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3414E23B55
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 02:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbhAWCbp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 21:31:45 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:58248 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726274AbhAWCbh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Jan 2021 21:31:37 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 214D21280479;
        Fri, 22 Jan 2021 18:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1611369051;
        bh=tMOOyCg6kqiR5GPWz9DXqes6YieQOqAA25I+pnNh3Rc=;
        h=Message-ID:Subject:From:To:Date:From;
        b=h0JBd5obaAHTz5Drw5ZtWOCu1K+NrvY/5QAZGMWl9HlK9TerlcnY/KJc4rcaV8E2K
         fpRnDxfbqar0vr45iEvcZzubmeTcw7/JH+6AQMKwW0t8fRjZuHrxN+GiXlDg8PfvBa
         m4kP/2AqtaMKHYz+w+Hq4GhrjyBhGdvXhOSkgKRY=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ozlBvvGfQ8Tk; Fri, 22 Jan 2021 18:30:51 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id B8F45128046F;
        Fri, 22 Jan 2021 18:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1611369051;
        bh=tMOOyCg6kqiR5GPWz9DXqes6YieQOqAA25I+pnNh3Rc=;
        h=Message-ID:Subject:From:To:Date:From;
        b=h0JBd5obaAHTz5Drw5ZtWOCu1K+NrvY/5QAZGMWl9HlK9TerlcnY/KJc4rcaV8E2K
         fpRnDxfbqar0vr45iEvcZzubmeTcw7/JH+6AQMKwW0t8fRjZuHrxN+GiXlDg8PfvBa
         m4kP/2AqtaMKHYz+w+Hq4GhrjyBhGdvXhOSkgKRY=
Message-ID: <eff0c907e53013d3d620d6b015d77244f8423dc8.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.11-rc4
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 22 Jan 2021 18:30:49 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Twelve minor fixes, all in drivers or doc.  Most of the fixes are
pretty obvious (although we have 2 goes to get the UFS sysfs doc right)
and the biggest change is in the ufs driver which they've extensively
tested.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Adrian Hunter (1):
      scsi: docs: ABI: sysfs-driver-ufs: Add DeepSleep power mode

Arnd Bergmann (1):
      scsi: megaraid_sas: Fix MEGASAS_IOC_FIRMWARE regression

Brian King (1):
      scsi: ibmvfc: Set default timeout to avoid crash during migration

Dinghao Liu (1):
      scsi: fnic: Fix memleak in vnic_dev_init_devcmd2

Jaegeuk Kim (2):
      scsi: ufs: Fix tm request when non-fatal error happens
      scsi: ufs: Fix livelock of ufshcd_clear_ua_wluns()

Javed Hasan (1):
      scsi: libfc: Avoid invoking response handler twice if ep is already completed

Lukas Bulwahn (1):
      scsi: docs: ABI: sysfs-driver-ufs: Rectify table formatting

Martin Wilck (1):
      scsi: scsi_transport_srp: Don't block target in failfast state

Randy Dunlap (1):
      scsi: ufs: ufshcd-pltfrm depends on HAS_IOMEM

Shin'ichiro Kawasaki (1):
      scsi: target: tcmu: Fix use-after-free of se_cmd->priv

Tyrel Datwyler (1):
      scsi: ibmvfc: Fix missing cast of ibmvfc_event pointer to u64 handle

And the diffstat:

 Documentation/ABI/testing/sysfs-driver-ufs | 36 ++++++++++++++++++-----------
 drivers/scsi/fnic/vnic_dev.c               |  8 ++++---
 drivers/scsi/ibmvscsi/ibmvfc.c             |  8 ++++---
 drivers/scsi/libfc/fc_exch.c               | 16 +++++++++++--
 drivers/scsi/megaraid/megaraid_sas_base.c  |  6 ++---
 drivers/scsi/scsi_transport_srp.c          |  9 +++++++-
 drivers/scsi/ufs/Kconfig                   |  1 +
 drivers/scsi/ufs/ufshcd.c                  | 37 ++++++++++++++++++++----------
 drivers/target/target_core_user.c          | 11 ++++++---
 9 files changed, 90 insertions(+), 42 deletions(-)

With full diff below.

James

---

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index adc0d0e91607..75ccc5c62b3c 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -916,21 +916,25 @@ Date:		September 2014
 Contact:	Subhash Jadavani <subhashj@codeaurora.org>
 Description:	This entry could be used to set or show the UFS device
 		runtime power management level. The current driver
-		implementation supports 6 levels with next target states:
+		implementation supports 7 levels with next target states:
 
 		==  ====================================================
-		0   an UFS device will stay active, an UIC link will
+		0   UFS device will stay active, UIC link will
 		    stay active
-		1   an UFS device will stay active, an UIC link will
+		1   UFS device will stay active, UIC link will
 		    hibernate
-		2   an UFS device will moved to sleep, an UIC link will
+		2   UFS device will be moved to sleep, UIC link will
 		    stay active
-		3   an UFS device will moved to sleep, an UIC link will
+		3   UFS device will be moved to sleep, UIC link will
 		    hibernate
-		4   an UFS device will be powered off, an UIC link will
+		4   UFS device will be powered off, UIC link will
 		    hibernate
-		5   an UFS device will be powered off, an UIC link will
+		5   UFS device will be powered off, UIC link will
 		    be powered off
+		6   UFS device will be moved to deep sleep, UIC link
+		    will be powered off. Note, deep sleep might not be
+		    supported in which case this value will not be
+		    accepted
 		==  ====================================================
 
 What:		/sys/bus/platform/drivers/ufshcd/*/rpm_target_dev_state
@@ -954,21 +958,25 @@ Date:		September 2014
 Contact:	Subhash Jadavani <subhashj@codeaurora.org>
 Description:	This entry could be used to set or show the UFS device
 		system power management level. The current driver
-		implementation supports 6 levels with next target states:
+		implementation supports 7 levels with next target states:
 
 		==  ====================================================
-		0   an UFS device will stay active, an UIC link will
+		0   UFS device will stay active, UIC link will
 		    stay active
-		1   an UFS device will stay active, an UIC link will
+		1   UFS device will stay active, UIC link will
 		    hibernate
-		2   an UFS device will moved to sleep, an UIC link will
+		2   UFS device will be moved to sleep, UIC link will
 		    stay active
-		3   an UFS device will moved to sleep, an UIC link will
+		3   UFS device will be moved to sleep, UIC link will
 		    hibernate
-		4   an UFS device will be powered off, an UIC link will
+		4   UFS device will be powered off, UIC link will
 		    hibernate
-		5   an UFS device will be powered off, an UIC link will
+		5   UFS device will be powered off, UIC link will
 		    be powered off
+		6   UFS device will be moved to deep sleep, UIC link
+		    will be powered off. Note, deep sleep might not be
+		    supported in which case this value will not be
+		    accepted
 		==  ====================================================
 
 What:		/sys/bus/platform/drivers/ufshcd/*/spm_target_dev_state
diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index a2beee6e09f0..5988c300cc82 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -444,7 +444,8 @@ static int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 	fetch_index = ioread32(&vdev->devcmd2->wq.ctrl->fetch_index);
 	if (fetch_index == 0xFFFFFFFF) { /* check for hardware gone  */
 		pr_err("error in devcmd2 init");
-		return -ENODEV;
+		err = -ENODEV;
+		goto err_free_wq;
 	}
 
 	/*
@@ -460,7 +461,7 @@ static int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 	err = vnic_dev_alloc_desc_ring(vdev, &vdev->devcmd2->results_ring,
 			DEVCMD2_RING_SIZE, DEVCMD2_DESC_SIZE);
 	if (err)
-		goto err_free_wq;
+		goto err_disable_wq;
 
 	vdev->devcmd2->result =
 		(struct devcmd2_result *) vdev->devcmd2->results_ring.descs;
@@ -481,8 +482,9 @@ static int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 
 err_free_desc_ring:
 	vnic_dev_free_desc_ring(vdev, &vdev->devcmd2->results_ring);
-err_free_wq:
+err_disable_wq:
 	vnic_wq_disable(&vdev->devcmd2->wq);
+err_free_wq:
 	vnic_wq_free(&vdev->devcmd2->wq);
 err_free_devcmd2:
 	kfree(vdev->devcmd2);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 42e4d35e0d35..65f168c41d23 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1744,7 +1744,7 @@ static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
 		iu->pri_task_attr = IBMVFC_SIMPLE_TASK;
 	}
 
-	vfc_cmd->correlation = cpu_to_be64(evt);
+	vfc_cmd->correlation = cpu_to_be64((u64)evt);
 
 	if (likely(!(rc = ibmvfc_map_sg_data(cmnd, evt, vfc_cmd, vhost->dev))))
 		return ibmvfc_send_event(evt, vhost, 0);
@@ -2418,7 +2418,7 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 		tmf->flags = cpu_to_be16((IBMVFC_NO_MEM_DESC | IBMVFC_TMF));
 		evt->sync_iu = &rsp_iu;
 
-		tmf->correlation = cpu_to_be64(evt);
+		tmf->correlation = cpu_to_be64((u64)evt);
 
 		init_completion(&evt->comp);
 		rsp_rc = ibmvfc_send_event(evt, vhost, default_timeout);
@@ -3007,8 +3007,10 @@ static int ibmvfc_slave_configure(struct scsi_device *sdev)
 	unsigned long flags = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (sdev->type == TYPE_DISK)
+	if (sdev->type == TYPE_DISK) {
 		sdev->allow_restart = 1;
+		blk_queue_rq_timeout(sdev->request_queue, 120 * HZ);
+	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return 0;
 }
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index d71afae6191c..841000445b9a 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1623,8 +1623,13 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		rc = fc_exch_done_locked(ep);
 		WARN_ON(fc_seq_exch(sp) != ep);
 		spin_unlock_bh(&ep->ex_lock);
-		if (!rc)
+		if (!rc) {
 			fc_exch_delete(ep);
+		} else {
+			FC_EXCH_DBG(ep, "ep is completed already,"
+					"hence skip calling the resp\n");
+			goto skip_resp;
+		}
 	}
 
 	/*
@@ -1643,6 +1648,7 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	if (!fc_invoke_resp(ep, sp, fp))
 		fc_frame_free(fp);
 
+skip_resp:
 	fc_exch_release(ep);
 	return;
 rel:
@@ -1899,10 +1905,16 @@ static void fc_exch_reset(struct fc_exch *ep)
 
 	fc_exch_hold(ep);
 
-	if (!rc)
+	if (!rc) {
 		fc_exch_delete(ep);
+	} else {
+		FC_EXCH_DBG(ep, "ep is completed already,"
+				"hence skip calling the resp\n");
+		goto skip_resp;
+	}
 
 	fc_invoke_resp(ep, sp, ERR_PTR(-FC_EX_CLOSED));
+skip_resp:
 	fc_seq_set_resp(sp, NULL, ep->arg);
 	fc_exch_release(ep);
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index af192096a82b..63a4f48bdc75 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8244,11 +8244,9 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 			goto out;
 		}
 
+		/* always store 64 bits regardless of addressing */
 		sense_ptr = (void *)cmd->frame + ioc->sense_off;
-		if (instance->consistent_mask_64bit)
-			put_unaligned_le64(sense_handle, sense_ptr);
-		else
-			put_unaligned_le32(sense_handle, sense_ptr);
+		put_unaligned_le64(sense_handle, sense_ptr);
 	}
 
 	/*
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index cba1cf6a1c12..1e939a2a387f 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -541,7 +541,14 @@ int srp_reconnect_rport(struct srp_rport *rport)
 	res = mutex_lock_interruptible(&rport->mutex);
 	if (res)
 		goto out;
-	scsi_target_block(&shost->shost_gendev);
+	if (rport->state != SRP_RPORT_FAIL_FAST)
+		/*
+		 * sdev state must be SDEV_TRANSPORT_OFFLINE, transition
+		 * to SDEV_BLOCK is illegal. Calling scsi_target_unblock()
+		 * later is ok though, scsi_internal_device_unblock_nowait()
+		 * treats SDEV_TRANSPORT_OFFLINE like SDEV_BLOCK.
+		 */
+		scsi_target_block(&shost->shost_gendev);
 	res = rport->state != SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODEV;
 	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
 		 dev_name(&shost->shost_gendev), rport->state, res);
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 3f6dfed4fe84..b915b38c2b27 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -72,6 +72,7 @@ config SCSI_UFS_DWC_TC_PCI
 config SCSI_UFSHCD_PLATFORM
 	tristate "Platform bus based UFS Controller support"
 	depends on SCSI_UFSHCD
+	depends on HAS_IOMEM
 	help
 	This selects the UFS host controller support. Select this if
 	you have an UFS controller on Platform bus.
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e31d2c5c7b23..fb32d122f2e3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3996,6 +3996,8 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
 	if (ret)
 		dev_err(hba->dev, "%s: link recovery failed, err %d",
 			__func__, ret);
+	else
+		ufshcd_clear_ua_wluns(hba);
 
 	return ret;
 }
@@ -4992,7 +4994,8 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		break;
 	} /* end of switch */
 
-	if ((host_byte(result) != DID_OK) && !hba->silence_err_logs)
+	if ((host_byte(result) != DID_OK) &&
+	    (host_byte(result) != DID_REQUEUE) && !hba->silence_err_logs)
 		ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
 	return result;
 }
@@ -6001,6 +6004,9 @@ static void ufshcd_err_handler(struct work_struct *work)
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_err_handling_unprepare(hba);
 	up(&hba->eh_sem);
+
+	if (!err && needs_reset)
+		ufshcd_clear_ua_wluns(hba);
 }
 
 /**
@@ -6295,9 +6301,13 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 	}
 
-	if (enabled_intr_status && retval == IRQ_NONE) {
-		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x\n",
-					__func__, intr_status);
+	if (enabled_intr_status && retval == IRQ_NONE &&
+				!ufshcd_eh_in_progress(hba)) {
+		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x (0x%08x, 0x%08x)\n",
+					__func__,
+					intr_status,
+					hba->ufs_stats.last_intr_status,
+					enabled_intr_status);
 		ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
 	}
 
@@ -6341,7 +6351,10 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	 * Even though we use wait_event() which sleeps indefinitely,
 	 * the maximum wait time is bounded by %TM_CMD_TIMEOUT.
 	 */
-	req = blk_get_request(q, REQ_OP_DRV_OUT, BLK_MQ_REQ_RESERVED);
+	req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
 	req->end_io_data = &wait;
 	free_slot = req->tag;
 	WARN_ON_ONCE(free_slot < 0 || free_slot >= hba->nutmrs);
@@ -6938,14 +6951,11 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	ufshcd_set_clk_freq(hba, true);
 
 	err = ufshcd_hba_enable(hba);
-	if (err)
-		goto out;
 
 	/* Establish the link again and restore the device */
-	err = ufshcd_probe_hba(hba, false);
 	if (!err)
-		ufshcd_clear_ua_wluns(hba);
-out:
+		err = ufshcd_probe_hba(hba, false);
+
 	if (err)
 		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
 	ufshcd_update_evt_hist(hba, UFS_EVT_HOST_RESET, (u32)err);
@@ -7716,6 +7726,8 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
+	ufshcd_clear_ua_wluns(hba);
+
 	/* Initialize devfreq after UFS device is detected */
 	if (ufshcd_is_clkscaling_supported(hba)) {
 		memcpy(&hba->clk_scaling.saved_pwr_info.info,
@@ -7917,8 +7929,6 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 		pm_runtime_put_sync(hba->dev);
 		ufshcd_exit_clk_scaling(hba);
 		ufshcd_hba_exit(hba);
-	} else {
-		ufshcd_clear_ua_wluns(hba);
 	}
 }
 
@@ -8775,6 +8785,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_resume_clkscaling(hba);
 	hba->clk_gating.is_suspended = false;
 	hba->dev_info.b_rpm_dev_flush_capable = false;
+	ufshcd_clear_ua_wluns(hba);
 	ufshcd_release(hba);
 out:
 	if (hba->dev_info.b_rpm_dev_flush_capable) {
@@ -8885,6 +8896,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
 	}
 
+	ufshcd_clear_ua_wluns(hba);
+
 	/* Schedule clock gating in case of no access to UFS device yet */
 	ufshcd_release(hba);
 
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 6b171fff007b..a5991df23581 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -562,8 +562,6 @@ tcmu_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
 
 static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
 {
-	if (tcmu_cmd->se_cmd)
-		tcmu_cmd->se_cmd->priv = NULL;
 	kfree(tcmu_cmd->dbi);
 	kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
 }
@@ -1174,11 +1172,12 @@ tcmu_queue_cmd(struct se_cmd *se_cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	mutex_lock(&udev->cmdr_lock);
-	se_cmd->priv = tcmu_cmd;
 	if (!(se_cmd->transport_state & CMD_T_ABORTED))
 		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
 	if (ret < 0)
 		tcmu_free_cmd(tcmu_cmd);
+	else
+		se_cmd->priv = tcmu_cmd;
 	mutex_unlock(&udev->cmdr_lock);
 	return scsi_ret;
 }
@@ -1241,6 +1240,7 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
 
 		list_del_init(&cmd->queue_entry);
 		tcmu_free_cmd(cmd);
+		se_cmd->priv = NULL;
 		target_complete_cmd(se_cmd, SAM_STAT_TASK_ABORTED);
 		unqueued = true;
 	}
@@ -1332,6 +1332,7 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 	}
 
 done:
+	se_cmd->priv = NULL;
 	if (read_len_valid) {
 		pr_debug("read_len = %d\n", read_len);
 		target_complete_cmd_with_length(cmd->se_cmd,
@@ -1478,6 +1479,7 @@ static void tcmu_check_expired_queue_cmd(struct tcmu_cmd *cmd)
 	se_cmd = cmd->se_cmd;
 	tcmu_free_cmd(cmd);
 
+	se_cmd->priv = NULL;
 	target_complete_cmd(se_cmd, SAM_STAT_TASK_SET_FULL);
 }
 
@@ -1592,6 +1594,7 @@ static void run_qfull_queue(struct tcmu_dev *udev, bool fail)
 			 * removed then LIO core will do the right thing and
 			 * fail the retry.
 			 */
+			tcmu_cmd->se_cmd->priv = NULL;
 			target_complete_cmd(tcmu_cmd->se_cmd, SAM_STAT_BUSY);
 			tcmu_free_cmd(tcmu_cmd);
 			continue;
@@ -1605,6 +1608,7 @@ static void run_qfull_queue(struct tcmu_dev *udev, bool fail)
 			 * Ignore scsi_ret for now. target_complete_cmd
 			 * drops it.
 			 */
+			tcmu_cmd->se_cmd->priv = NULL;
 			target_complete_cmd(tcmu_cmd->se_cmd,
 					    SAM_STAT_CHECK_CONDITION);
 			tcmu_free_cmd(tcmu_cmd);
@@ -2212,6 +2216,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
 			WARN_ON(!cmd->se_cmd);
 			list_del_init(&cmd->queue_entry);
+			cmd->se_cmd->priv = NULL;
 			if (err_level == 1) {
 				/*
 				 * Userspace was not able to start the

