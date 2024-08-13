Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.122])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1254A19CD05;
	Tue, 13 Aug 2024 13:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.226.244.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723556924; cv=none; b=XMkFxuzPZvOR1heYIZqwrwi7mfkbdjZp+GyTELopkPwUs/pfvixaaa0/7LIbB1aKCNvoF+oWFILGxrSEr/N1klyxYV3HRiipXOrqKuIgywlDRyFqYPOataExVLT4Eh8ZRg0MEOie6iOEoBEP6rPnzH8FFztTn/yoyMqleNv5JxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723556924; c=relaxed/simple;
	bh=8L+5hdMZi624aswdRULhySVYITXomchoDsxT+/7/Xk4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UsZl2DywZL+B2dU///cFVl5xoAfjeVzXJBqMHmokoeT2V2jZn5ncNS9lheWtZG5ARwPa3AKYmckBTk4PDErZLaxDcpC4j3hSRJ1d0YkwDN3MXHU2r4lPHx4lgfQYqmderND2IHtBMoyt7tTAIRimhOVzeRxulF3Y8bC5yMq+L64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com; spf=pass smtp.mailfrom=xiaomi.com; arc=none smtp.client-ip=207.226.244.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=xiaomi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaomi.com
X-CSE-ConnectionGUID: c6C2O5LqQtiPkbP36ydycw==
X-CSE-MsgGUID: 8cMa+XtKT22D9+IagzsBtA==
X-IronPort-AV: E=Sophos;i="6.09,286,1716220800"; 
   d="scan'208";a="119246640"
From: ZhangHui <zhanghui31@xiaomi.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <alim.akhtar@samsung.com>, <avri.altman@wdc.co>, <bvanassche@acm.org>,
	<peter.wang@mediatek.com>, <manivannan.sadhasivam@linaro.org>,
	<huangjianan@xiaomi.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, zhanghui <zhanghui31@xiaomi.com>
Subject: [PATCH] ufs: core: fix bus timeout in ufshcd_wl_resume flow
Date: Tue, 13 Aug 2024 21:47:29 +0800
Message-ID: <20240813134729.284583-1-zhanghui31@xiaomi.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: bj-mbx11.mioffice.cn (10.237.8.131) To YZ-MBX07.mioffice.cn
 (10.237.88.127)

From: zhanghui <zhanghui31@xiaomi.com>

If the SSU CMD completion flow in UFS resume and the CMD timeout flow occur
simultaneously, the timestamp attribute command will be sent to the device
during the UFS resume flow, while the UFS controller performs a reset in
the timeout error handling flow.

In this scenario, a bus timeout will occur because the UFS resume flow
will attempt to access the UFS host controller registers while the UFS
controller is in a reset state or power cycle.

Call trace:
  arm64_serror_panic+0x6c/0x94
  do_serror+0xbc/0xc8
  el1h_64_error_handler+0x34/0x48
  el1h_64_error+0x68/0x6c
  _raw_spin_unlock+0x18/0x44
  ufshcd_send_command+0x1c0/0x380
  ufshcd_exec_dev_cmd+0x21c/0x29c
  ufshcd_set_timestamp_attr+0x78/0xdc
  __ufshcd_wl_resume+0x228/0x48c
  ufshcd_wl_resume+0x5c/0x1b4
  scsi_bus_resume+0x58/0xa0
  dpm_run_callback+0x6c/0x23c
  __device_resume+0x298/0x46c
  async_resume+0x24/0x3c
  async_run_entry_fn+0x44/0x150
  process_scheduled_works+0x254/0x4f4
  worker_thread+0x244/0x334
  kthread+0x124/0x1f0
  ret_from_fork+0x10/0x20

This patch fixes the issue by adding a check of the UFS controller
register states before sending the device command.

Signed-off-by: zhanghui <zhanghui31@xiaomi.com>
---
 drivers/ufs/core/ufshcd.c | 14 ++++++++++++++
 include/ufs/ufshcd.h      | 13 +++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5e3c67e96956..e5e3e0277d43 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3291,6 +3291,8 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	int err;
 
+	if (hba->ufshcd_reg_state == UFSHCD_REG_RESET)
+		return -EBUSY;
 	/* Protects use of hba->reserved_slot. */
 	lockdep_assert_held(&hba->dev_cmd.lock);
 
@@ -4857,6 +4859,7 @@ static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
 int ufshcd_hba_enable(struct ufs_hba *hba)
 {
 	int ret;
+	unsigned long flags;
 
 	if (hba->quirks & UFSHCI_QUIRK_BROKEN_HCE) {
 		ufshcd_set_link_off(hba);
@@ -4881,6 +4884,13 @@ int ufshcd_hba_enable(struct ufs_hba *hba)
 		ret = ufshcd_hba_execute_hce(hba);
 	}
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (ret)
+		hba->ufshcd_reg_state = UFSHCD_REG_RESET;
+	else
+		hba->ufshcd_reg_state = UFSHCD_REG_OPERATIONAL;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ufshcd_hba_enable);
@@ -7693,7 +7703,11 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 {
 	int err;
+	unsigned long flags;
 
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->ufshcd_reg_state = UFSHCD_REG_RESET;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	/*
 	 * Stop the host controller and complete the requests
 	 * cleared by h/w
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index cac0cdb9a916..e5af4c2114ce 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -523,6 +523,18 @@ enum ufshcd_state {
 	UFSHCD_STATE_ERROR,
 };
 
+/**
+ * enum ufshcd_state - UFS host controller state
+ * @UFSHCD_REG_OPERATIONAL: UFS host controller is enabled, the host controller
+ * register can be accessed.
+ * @UFSHCD_REG_RESET: UFS host controller registers will be reset, can't access
+ * any ufs host controller register.
+ */
+enum ufshcd_reg_state {
+	UFSHCD_REG_OPERATIONAL,
+	UFSHCD_REG_RESET,
+};
+
 enum ufshcd_quirks {
 	/* Interrupt aggregation support is broken */
 	UFSHCD_QUIRK_BROKEN_INTR_AGGR			= 1 << 0,
@@ -1020,6 +1032,7 @@ struct ufs_hba {
 	struct completion *uic_async_done;
 
 	enum ufshcd_state ufshcd_state;
+	enum ufshcd_reg_state ufshcd_reg_state;
 	u32 eh_flags;
 	u32 intr_mask;
 	u16 ee_ctrl_mask;
-- 
2.43.0

