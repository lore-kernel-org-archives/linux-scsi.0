Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E983BBFAF;
	Fri,  5 Jun 2026 11:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780658484; cv=none; b=E7Af4kJAMcVxtRZW5mYFNoSioOBTLL9d8x/xBRrV2B+2Xb3jru6Ukmn9KnUcN0bvCronKGvCkLVotSSnh6y/7T5Zf9BgR3V5ryqTM9bGrt4LGltor2rdJFqRAzjvZfOneutY/WjmtfmZssnJklNdY6Ffd4rQmyze557WriXQUJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780658484; c=relaxed/simple;
	bh=OgVk+RUqYRILSi1wq86AS2+D7OqLMfYYrQCIRJEWoes=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bxxWnMnXH8eIOdntQk1TISVebAv9bRo0Z4oxSsF/1GBZ2cIq1vILSKhb9Eek/FY2tWSmAXVRYW9EVtBtjWPv23qmqM5BifVEgCoTptA+hDJX3Q1o2zakyONZlyTUE/e9xtqXRjrXKsisDGAuwp71SnHszL3TfhcVXPhiR0zdTWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 655BKTWU027917
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Fri, 5 Jun 2026 19:20:29 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from localhost (10.1.170.248) by exch02.asrmicro.com (10.1.24.122)
 with Microsoft SMTP Server (TLS) id 15.0.847.32; Fri, 5 Jun 2026 19:20:34
 +0800
From: Hongjie Fang <hongjiefang@asrmicro.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <peter.wang@mediatek.com>, <beanhuo@micron.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5] scsi: ufs: core: handle PM commands timeout before SCSI EH
Date: Fri, 5 Jun 2026 19:20:34 +0800
Message-ID: <20260605112034.3802540-1-hongjiefang@asrmicro.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: exch03.asrmicro.com (10.1.24.118) To exch02.asrmicro.com
 (10.1.24.122)
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 655BKTWU027917

A PM START STOP sent from the UFS well-known LU resume path can race with
SCSI EH.

The "wl resume" task flow is:
  __ufshcd_wl_resume()
    ufshcd_set_dev_pwr_mode(UFS_ACTIVE_PWR_MODE)
      ufshcd_execute_start_stop()
        scsi_execute_cmd()
          blk_execute_rq           <-- wait
          scsi_check_passthrough() <-- may retry START STOP

If the first START STOP time out, SCSI EH may already recover the link and
reset the device before scsi_execute_cmd() returns:
  scsi_timeout()
    scsi_eh_scmd_add()
      scsi_error_handler()
        scsi_unjam_host()
          scsi_eh_ready_devs()
            scsi_eh_host_reset()
              ufshcd_eh_host_reset_handler()
                if (hba->pm_op_in_progress)
                  ufshcd_link_recovery()
                    ufshcd_device_reset()
                    ufshcd_host_reset_and_restore()
          ...
          scsi_eh_flush_done_q()   <-- wakeup "wl resume" task
        ...                        <-- host still in SHOST_RECOVERY
        scsi_restart_operations()

A later passthrough retry can then run while the host is still in
SHOST_RECOVERY and hit the SCMD_FAIL_IF_RECOVERING path:
  scsi_queue_rq()
    if (scsi_host_in_recovery(shost) &&
        cmd->flags & SCMD_FAIL_IF_RECOVERING)
      return BLK_STS_OFFLINE

That retry completes with DID_ERROR or DID_NO_CONNECT even though EH may
already have restored the device to an operational ACTIVE state.

Handle these PM timeouts directly from ufshcd_eh_timed_out() instead.
After ufshcd_link_recovery(), complete the timed-out command immediately
if it has not been completed already.

For regular SCSI commands, complete them with DID_REQUEUE to match the
existing MCQ force-completion semantics and allow scsi_execute_cmd() to
retry if needed. For reserved internal device-management commands, finish
the request with DID_TIME_OUT without calling ufshcd_release_scsi_cmd()
since those commands use different resource lifetime rules.

The system_suspending flag is no longer needed because PM command timeout
handling now uses pm_op_in_progress.

Fixes: b8c3a7bac9b6 ("scsi: ufs: Have midlayer retry start stop errors")
Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
---

v5: complete SCSI commands with DID_REQUEUE and use DID_TIME_OUT for
reserved commands suggested by Peter Wang

v4: handle PM timeouts directly from ufshcd_eh_timed_out(), no longer
relay on the extra legacy single-doorbell force-completion path

v3: ufshcd_eh_timed_out() no longer checks the UFS device WLUN or the
START STOP opcode. It only checks whether a PM operation is in progress
for normal SCSI command

v2: handle PM SSU timeout directly from ufshcd_eh_timed_out() suggested
by Bart Van Assche

 drivers/ufs/core/ufshcd.c | 34 +++++++++++++++++++++++++++-------
 include/ufs/ufshcd.h      |  3 ---
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c3f08957d179..cc38588d99eb 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9466,22 +9466,44 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 {
 	struct ufs_hba *hba = shost_priv(scmd->device->host);
 
-	if (!hba->system_suspending) {
+	if (!hba->pm_op_in_progress) {
 		/* Activate the error handler in the SCSI core. */
 		return SCSI_EH_NOT_HANDLED;
 	}
 
 	/*
-	 * If we get here we know that no TMFs are outstanding and also that
-	 * the only pending command is a START STOP UNIT command. Handle the
-	 * timeout of that command directly to prevent a deadlock between
+	 * Handle the timeout directly to prevent a deadlock between
 	 * ufshcd_set_dev_pwr_mode() and ufshcd_err_handler().
 	 */
 	ufshcd_link_recovery(hba);
 	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
 		 __func__, hba->outstanding_tasks);
 
-	return scsi_host_busy(hba->host) ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
+	/*
+	 * ufshcd_link_recovery() may already have completed @scmd, e.g. via
+	 * the existing MCQ force-completion path.
+	 */
+	if (!test_bit(SCMD_STATE_COMPLETE, &scmd->state)) {
+		if (!hba->mcq_enabled) {
+			unsigned long flags;
+			struct request *rq = scsi_cmd_to_rq(scmd);
+
+			spin_lock_irqsave(&hba->outstanding_lock, flags);
+			__clear_bit(rq->tag, &hba->outstanding_reqs);
+			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+		}
+
+		if (ufshcd_is_scsi_cmd(scmd)) {
+			set_host_byte(scmd, DID_REQUEUE);
+			ufshcd_release_scsi_cmd(hba, scmd);
+		} else {
+			set_host_byte(scmd, DID_TIME_OUT);
+		}
+
+		scsi_done(scmd);
+	}
+
+	return SCSI_EH_DONE;
 }
 
 static const struct attribute_group *ufshcd_driver_groups[] = {
@@ -10518,7 +10540,6 @@ static int ufshcd_wl_suspend(struct device *dev)
 
 	hba = shost_priv(sdev->host);
 	down(&hba->host_sem);
-	hba->system_suspending = true;
 
 	if (pm_runtime_suspended(dev))
 		goto out;
@@ -10560,7 +10581,6 @@ static int ufshcd_wl_resume(struct device *dev)
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	if (!ret)
 		hba->is_sys_suspended = false;
-	hba->system_suspending = false;
 	up(&hba->host_sem);
 	return ret;
 }
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index cfbc75d8df83..8280a95c00c7 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1020,8 +1020,6 @@ enum ufshcd_mcq_opr {
  * @caps: bitmask with information about UFS controller capabilities
  * @devfreq: frequency scaling information owned by the devfreq core
  * @clk_scaling: frequency scaling information owned by the UFS driver
- * @system_suspending: system suspend has been started and system resume has
- *	not yet finished.
  * @is_sys_suspended: UFS device has been suspended because of system suspend
  * @urgent_bkops_lvl: keeps track of urgent bkops level for device
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
@@ -1197,7 +1195,6 @@ struct ufs_hba {
 
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
-	bool system_suspending;
 	bool is_sys_suspended;
 
 	enum bkops_status urgent_bkops_lvl;
-- 
2.25.1

