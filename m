Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF2013959D;
	Mon,  1 Jun 2026 04:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780289885; cv=none; b=I7jNhX0xMEHTWxOmUK0GqEAmfAoim1ugCgYw6WYVyOTt8OimugXJeUVHWDTAY/WJKThUoW1o7Ilk6RnsSwlea8dAPzzh07JM0eubxPR0SvvU7WIbALzyz6GAbuCEuE2t6/pWLq5W5hBnUXHzsnfwSNOpBpSddNPKpnPt3ayfPNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780289885; c=relaxed/simple;
	bh=Wfu8mM1F65C3julBL2/5LDTFtCE36tFg0eujZVfkuGM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pcCvqxBLVnzH9CgZXN3Wr6Xfsy+y3aho/5J0zp4+ecCghTGE/0wTuCPTqm8PJfnfvcWLznKBsjMEoRHffC/8Md2/yawMpS2UqGDp5NtMJRaNCOMMC5J4sJxTR6nwXAX9FNjbr9bsxq5/s2rW+SJdSntjk8VELIya/yOLt9TNTOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 6514uu1J082067
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Mon, 1 Jun 2026 12:56:56 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from localhost (10.1.170.248) by exch02.asrmicro.com (10.1.24.122)
 with Microsoft SMTP Server (TLS) id 15.0.847.32; Mon, 1 Jun 2026 12:56:58
 +0800
From: Hongjie Fang <hongjiefang@asrmicro.com>
To: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <peter.wang@mediatek.com>, <beanhuo@micron.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] scsi: ufs: core: handle PM SSU timeout before SCSI EH
Date: Mon, 1 Jun 2026 12:56:58 +0800
Message-ID: <20260601045658.1232848-1-hongjiefang@asrmicro.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: exch02.asrmicro.com (10.1.24.122) To exch02.asrmicro.com
 (10.1.24.122)
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 6514uu1J082067

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

Handle PM SSU timeout directly from ufshcd_eh_timed_out() instead of
letting these commands enter regular SCSI EH. Limit this path to SSU
commands for the UFS device WLUN while a PM operation is in progress.
If link recovery fails, return SCSI_EH_NOT_HANDLED so regular SCSI
timeout handling can take over.

Since this path bypasses scsi_eh_scmd_add(), UFS reset/restore must also
complete the timed-out request itself. MCQ mode already force-completes
requests without CQEs when force_compl is true. Add the same behavior for
the legacy single-doorbell path: first process requests whose doorbell has
already been cleared, then complete the remaining outstanding SCSI requests
with DID_REQUEUE so callers can re-issue commands whose outcome became
unknown after the host reset.

The system_suspending flag is no longer needed because PM SSU timeout
handling now uses pm_op_in_progress and command filtering.

Fixes: b8c3a7bac9b6 ("scsi: ufs: Have midlayer retry start stop errors")
Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
---

v3: ufshcd_eh_timed_out() no longer checks the UFS device WLUN or the
START STOP opcode. It only checks whether a PM operation is in progress
for normal SCSI command

v2: handle PM SSU timeout directly from ufshcd_eh_timed_out() suggested
by Bart Van Assche

 drivers/ufs/core/ufshcd.c | 39 +++++++++++++++++++++++++++++++++++----
 include/ufs/ufshcd.h      |  3 ---
 2 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c3f08957d179..407b93d28f85 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5953,6 +5953,37 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	return IRQ_HANDLED;
 }
 
+static void ufshcd_force_compl_pending_transfer(struct ufs_hba *hba)
+{
+	unsigned long completed_reqs;
+	unsigned long flags;
+	int tag;
+
+	ufshcd_transfer_req_compl(hba);
+
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	completed_reqs = hba->outstanding_reqs;
+	hba->outstanding_reqs = 0;
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
+	for_each_set_bit(tag, &completed_reqs, hba->nutrs) {
+		struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, tag);
+
+		if (cmd && ufshcd_is_scsi_cmd(cmd) &&
+		    !test_bit(SCMD_STATE_COMPLETE, &cmd->state)) {
+			/*
+			 * The host has been reset and the original command
+			 * outcome is unknown. Requeue SCSI commands so callers
+			 * such as ufshcd_set_dev_pwr_mode() can re-issue START
+			 * STOP UNIT and converge the device power mode.
+			 */
+			set_host_byte(cmd, DID_REQUEUE);
+			ufshcd_release_scsi_cmd(hba, cmd);
+			scsi_done(cmd);
+		}
+	}
+}
+
 int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask)
 {
 	return ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
@@ -6517,6 +6548,8 @@ static void ufshcd_complete_requests(struct ufs_hba *hba, bool force_compl)
 {
 	if (hba->mcq_enabled)
 		ufshcd_mcq_compl_pending_transfer(hba, force_compl);
+	else if (force_compl)
+		ufshcd_force_compl_pending_transfer(hba);
 	else
 		ufshcd_transfer_req_compl(hba);
 
@@ -9466,7 +9499,7 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 {
 	struct ufs_hba *hba = shost_priv(scmd->device->host);
 
-	if (!hba->system_suspending) {
+	if (!hba->pm_op_in_progress || !ufshcd_is_scsi_cmd(scmd)) {
 		/* Activate the error handler in the SCSI core. */
 		return SCSI_EH_NOT_HANDLED;
 	}
@@ -9481,7 +9514,7 @@ static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
 	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
 		 __func__, hba->outstanding_tasks);
 
-	return scsi_host_busy(hba->host) ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
+	return SCSI_EH_DONE;
 }
 
 static const struct attribute_group *ufshcd_driver_groups[] = {
@@ -10518,7 +10551,6 @@ static int ufshcd_wl_suspend(struct device *dev)
 
 	hba = shost_priv(sdev->host);
 	down(&hba->host_sem);
-	hba->system_suspending = true;
 
 	if (pm_runtime_suspended(dev))
 		goto out;
@@ -10560,7 +10592,6 @@ static int ufshcd_wl_resume(struct device *dev)
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

