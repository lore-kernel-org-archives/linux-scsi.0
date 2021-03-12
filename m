Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48E8C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 19:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9859164F83
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 19:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbhCLTGA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 14:06:00 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:47350 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234021AbhCLTFr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 12 Mar 2021 14:05:47 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 8078E12807EA;
        Fri, 12 Mar 2021 11:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1615575947;
        bh=ikKEn9GhGFQO9lA1TRu2TSsC7mkDl3mSo8wJsll1EFA=;
        h=Message-ID:Subject:From:To:Date:From;
        b=V94q55dVA02kUberYeGb65dsboGxMGbNPad1vM9FwEWEn2ws72VQ5bwpL0uLqRI1D
         XoM3UOGwZ82bFWqWCQN6YsIJqSbmLcjFs6weebT04YOxBooJyl4hJd+LCBTVfR5aTG
         m4gnFqMPhtehXAmxfZZG+CkLQxtNKHSQCCMoxtE0=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id w1mipbvZivsc; Fri, 12 Mar 2021 11:05:47 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 2E0D112807E9;
        Fri, 12 Mar 2021 11:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1615575947;
        bh=ikKEn9GhGFQO9lA1TRu2TSsC7mkDl3mSo8wJsll1EFA=;
        h=Message-ID:Subject:From:To:Date:From;
        b=V94q55dVA02kUberYeGb65dsboGxMGbNPad1vM9FwEWEn2ws72VQ5bwpL0uLqRI1D
         XoM3UOGwZ82bFWqWCQN6YsIJqSbmLcjFs6weebT04YOxBooJyl4hJd+LCBTVfR5aTG
         m4gnFqMPhtehXAmxfZZG+CkLQxtNKHSQCCMoxtE0=
Message-ID: <a139e36ef462b5a9678edd0e97477ff187d6f1d9.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.12-rc2
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 12 Mar 2021 11:05:45 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

10 updates, a non code maintainer update for vmw_pvscsi, five code
updates for ibmvfc and four for UFS.  All updates are either trivial
patches or bug fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Can Guo (2):
      scsi: ufs: Remove redundant checks of !hba in suspend/resume callbacks
      scsi: ufs: Minor adjustments to error handling

Jiapeng Chong (1):
      scsi: ufs: Convert sysfs sprintf/snprintf family to sysfs_emit

Nitin Rawat (1):
      scsi: ufs: ufs-qcom: Disable interrupt in reset path

Tyrel Datwyler (5):
      scsi: ibmvfc: Reinitialize sub-CRQs and perform channel enquiry after LPM
      scsi: ibmvfc: Store return code of H_FREE_SUB_CRQ during cleanup
      scsi: ibmvfc: Treat H_CLOSED as success during sub-CRQ registration
      scsi: ibmvfc: Fix invalid sub-CRQ handles after hard reset
      scsi: ibmvfc: Simplify handling of sub-CRQ initialization

Vishal Bhakta (1):
      scsi: vmw_pvscsi: MAINTAINERS: Update maintainer

And the diffstat:

 MAINTAINERS                    |  2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c | 62 ++++++++++++++++++++++++------------------
 drivers/scsi/ufs/ufs-qcom.c    | 10 +++++++
 drivers/scsi/ufs/ufshcd.c      | 41 +++++++++-------------------
 drivers/scsi/vmw_pvscsi.c      |  2 --
 drivers/scsi/vmw_pvscsi.h      |  2 --
 6 files changed, 60 insertions(+), 59 deletions(-)

With full diff below.

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index d92f85ca831d..dede3b947834 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19165,7 +19165,7 @@ S:	Maintained
 F:	drivers/infiniband/hw/vmw_pvrdma/
 
 VMware PVSCSI driver
-M:	Jim Gill <jgill@vmware.com>
+M:	Vishal Bhakta <vbhakta@vmware.com>
 M:	VMware PV-Drivers <pv-drivers@vmware.com>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 755313b766b9..338e29d3e025 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -21,6 +21,7 @@
 #include <linux/bsg-lib.h>
 #include <asm/firmware.h>
 #include <asm/irq.h>
+#include <asm/rtas.h>
 #include <asm/vio.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -158,6 +159,9 @@ static void ibmvfc_npiv_logout(struct ibmvfc_host *);
 static void ibmvfc_tgt_implicit_logout_and_del(struct ibmvfc_target *);
 static void ibmvfc_tgt_move_login(struct ibmvfc_target *);
 
+static void ibmvfc_release_sub_crqs(struct ibmvfc_host *);
+static void ibmvfc_init_sub_crqs(struct ibmvfc_host *);
+
 static const char *unknown_error = "unknown error";
 
 static long h_reg_sub_crq(unsigned long unit_address, unsigned long ioba,
@@ -899,6 +903,9 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 {
 	int rc = 0;
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
+	unsigned long flags;
+
+	ibmvfc_release_sub_crqs(vhost);
 
 	/* Re-enable the CRQ */
 	do {
@@ -910,6 +917,15 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	if (rc)
 		dev_err(vhost->dev, "Error enabling adapter (rc=%d)\n", rc);
 
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	spin_lock(vhost->crq.q_lock);
+	vhost->do_enquiry = 1;
+	vhost->using_channels = 0;
+	spin_unlock(vhost->crq.q_lock);
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+
+	ibmvfc_init_sub_crqs(vhost);
+
 	return rc;
 }
 
@@ -926,8 +942,8 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	unsigned long flags;
 	struct vio_dev *vdev = to_vio_dev(vhost->dev);
 	struct ibmvfc_queue *crq = &vhost->crq;
-	struct ibmvfc_queue *scrq;
-	int i;
+
+	ibmvfc_release_sub_crqs(vhost);
 
 	/* Close the CRQ */
 	do {
@@ -947,16 +963,6 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	memset(crq->msgs.crq, 0, PAGE_SIZE);
 	crq->cur = 0;
 
-	if (vhost->scsi_scrqs.scrqs) {
-		for (i = 0; i < nr_scsi_hw_queues; i++) {
-			scrq = &vhost->scsi_scrqs.scrqs[i];
-			spin_lock(scrq->q_lock);
-			memset(scrq->msgs.scrq, 0, PAGE_SIZE);
-			scrq->cur = 0;
-			spin_unlock(scrq->q_lock);
-		}
-	}
-
 	/* And re-open it again */
 	rc = plpar_hcall_norets(H_REG_CRQ, vdev->unit_address,
 				crq->msg_token, PAGE_SIZE);
@@ -966,9 +972,12 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 		dev_warn(vhost->dev, "Partner adapter not ready\n");
 	else if (rc != 0)
 		dev_warn(vhost->dev, "Couldn't register crq (rc=%d)\n", rc);
+
 	spin_unlock(vhost->crq.q_lock);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
+	ibmvfc_init_sub_crqs(vhost);
+
 	return rc;
 }
 
@@ -5642,7 +5651,8 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 	rc = h_reg_sub_crq(vdev->unit_address, scrq->msg_token, PAGE_SIZE,
 			   &scrq->cookie, &scrq->hw_irq);
 
-	if (rc) {
+	/* H_CLOSED indicates successful register, but no CRQ partner */
+	if (rc && rc != H_CLOSED) {
 		dev_warn(dev, "Error registering sub-crq: %d\n", rc);
 		if (rc == H_PARAMETER)
 			dev_warn_once(dev, "Firmware may not support MQ\n");
@@ -5675,8 +5685,8 @@ static int ibmvfc_register_scsi_channel(struct ibmvfc_host *vhost,
 
 irq_failed:
 	do {
-		plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
-	} while (rc == H_BUSY || H_IS_LONG_BUSY(rc));
+		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq->cookie);
+	} while (rtas_busy_delay(rc));
 reg_failed:
 	ibmvfc_free_queue(vhost, scrq);
 	LEAVE;
@@ -5694,6 +5704,7 @@ static void ibmvfc_deregister_scsi_channel(struct ibmvfc_host *vhost, int index)
 
 	free_irq(scrq->irq, scrq);
 	irq_dispose_mapping(scrq->irq);
+	scrq->irq = 0;
 
 	do {
 		rc = plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,
@@ -5707,17 +5718,21 @@ static void ibmvfc_deregister_scsi_channel(struct ibmvfc_host *vhost, int index)
 	LEAVE;
 }
 
-static int ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
+static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 {
 	int i, j;
 
 	ENTER;
+	if (!vhost->mq_enabled)
+		return;
 
 	vhost->scsi_scrqs.scrqs = kcalloc(nr_scsi_hw_queues,
 					  sizeof(*vhost->scsi_scrqs.scrqs),
 					  GFP_KERNEL);
-	if (!vhost->scsi_scrqs.scrqs)
-		return -1;
+	if (!vhost->scsi_scrqs.scrqs) {
+		vhost->do_enquiry = 0;
+		return;
+	}
 
 	for (i = 0; i < nr_scsi_hw_queues; i++) {
 		if (ibmvfc_register_scsi_channel(vhost, i)) {
@@ -5726,13 +5741,12 @@ static int ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 			kfree(vhost->scsi_scrqs.scrqs);
 			vhost->scsi_scrqs.scrqs = NULL;
 			vhost->scsi_scrqs.active_queues = 0;
-			LEAVE;
-			return -1;
+			vhost->do_enquiry = 0;
+			break;
 		}
 	}
 
 	LEAVE;
-	return 0;
 }
 
 static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
@@ -5999,11 +6013,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 		goto remove_shost;
 	}
 
-	if (vhost->mq_enabled) {
-		rc = ibmvfc_init_sub_crqs(vhost);
-		if (rc)
-			dev_warn(dev, "Failed to allocate Sub-CRQs. rc=%d\n", rc);
-	}
+	ibmvfc_init_sub_crqs(vhost);
 
 	if (shost_to_fc_host(shost)->rqst_q)
 		blk_queue_max_segments(shost_to_fc_host(shost)->rqst_q, 1);
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index f97d7b0ae3b6..a9dc8d7c9f78 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -253,12 +253,17 @@ static int ufs_qcom_host_reset(struct ufs_hba *hba)
 {
 	int ret = 0;
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+	bool reenable_intr = false;
 
 	if (!host->core_reset) {
 		dev_warn(hba->dev, "%s: reset control not set\n", __func__);
 		goto out;
 	}
 
+	reenable_intr = hba->is_irq_enabled;
+	disable_irq(hba->irq);
+	hba->is_irq_enabled = false;
+
 	ret = reset_control_assert(host->core_reset);
 	if (ret) {
 		dev_err(hba->dev, "%s: core_reset assert failed, err = %d\n",
@@ -280,6 +285,11 @@ static int ufs_qcom_host_reset(struct ufs_hba *hba)
 
 	usleep_range(1000, 1100);
 
+	if (reenable_intr) {
+		enable_irq(hba->irq);
+		hba->is_irq_enabled = true;
+	}
+
 out:
 	return ret;
 }
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 77161750c9fb..c86760788c72 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -95,8 +95,6 @@
 		       16, 4, buf, __len, false);                        \
 } while (0)
 
-static bool early_suspend;
-
 int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 		     const char *prefix)
 {
@@ -1535,7 +1533,7 @@ static ssize_t ufshcd_clkscale_enable_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", hba->clk_scaling.is_enabled);
+	return sysfs_emit(buf, "%d\n", hba->clk_scaling.is_enabled);
 }
 
 static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
@@ -4987,6 +4985,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 			 * UFS device needs urgent BKOPs.
 			 */
 			if (!hba->pm_op_in_progress &&
+			    !ufshcd_eh_in_progress(hba) &&
 			    ufshcd_is_exception_event(lrbp->ucd_rsp_ptr) &&
 			    schedule_work(&hba->eeh_work)) {
 				/*
@@ -5784,13 +5783,20 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 			ufshcd_suspend_clkscaling(hba);
 		ufshcd_clk_scaling_allow(hba, false);
 	}
+	ufshcd_scsi_block_requests(hba);
+	/* Drain ufshcd_queuecommand() */
+	down_write(&hba->clk_scaling_lock);
+	up_write(&hba->clk_scaling_lock);
+	cancel_work_sync(&hba->eeh_work);
 }
 
 static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 {
+	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, false);
+	ufshcd_clear_ua_wluns(hba);
 	pm_runtime_put(hba->dev);
 }
 
@@ -5882,8 +5888,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_err_handling_prepare(hba);
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_scsi_block_requests(hba);
-	hba->ufshcd_state = UFSHCD_STATE_RESET;
+	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
+		hba->ufshcd_state = UFSHCD_STATE_RESET;
 
 	/* Complete requests that have door-bell cleared by h/w */
 	ufshcd_complete_requests(hba);
@@ -6042,12 +6048,8 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_err_handling_unprepare(hba);
 	up(&hba->host_sem);
-
-	if (!err && needs_reset)
-		ufshcd_clear_ua_wluns(hba);
 }
 
 /**
@@ -7858,6 +7860,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 	unsigned long flags;
 	ktime_t start = ktime_get();
 
+	hba->ufshcd_state = UFSHCD_STATE_RESET;
+
 	ret = ufshcd_link_startup(hba);
 	if (ret)
 		goto out;
@@ -8972,11 +8976,6 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	int ret = 0;
 	ktime_t start = ktime_get();
 
-	if (!hba) {
-		early_suspend = true;
-		return 0;
-	}
-
 	down(&hba->host_sem);
 
 	if (!hba->is_powered)
@@ -9028,14 +9027,6 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 	int ret = 0;
 	ktime_t start = ktime_get();
 
-	if (!hba)
-		return -EINVAL;
-
-	if (unlikely(early_suspend)) {
-		early_suspend = false;
-		down(&hba->host_sem);
-	}
-
 	if (!hba->is_powered || pm_runtime_suspended(hba->dev))
 		/*
 		 * Let the runtime resume take care of resuming
@@ -9068,9 +9059,6 @@ int ufshcd_runtime_suspend(struct ufs_hba *hba)
 	int ret = 0;
 	ktime_t start = ktime_get();
 
-	if (!hba)
-		return -EINVAL;
-
 	if (!hba->is_powered)
 		goto out;
 	else
@@ -9109,9 +9097,6 @@ int ufshcd_runtime_resume(struct ufs_hba *hba)
 	int ret = 0;
 	ktime_t start = ktime_get();
 
-	if (!hba)
-		return -EINVAL;
-
 	if (!hba->is_powered)
 		goto out;
 	else
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 081f54ab7d86..8a79605d9652 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -17,8 +17,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
  *
- * Maintained by: Jim Gill <jgill@vmware.com>
- *
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
index 75966d3f326e..51a82f7803d3 100644
--- a/drivers/scsi/vmw_pvscsi.h
+++ b/drivers/scsi/vmw_pvscsi.h
@@ -17,8 +17,6 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
  *
- * Maintained by: Jim Gill <jgill@vmware.com>
- *
  */
 
 #ifndef _VMW_PVSCSI_H_

