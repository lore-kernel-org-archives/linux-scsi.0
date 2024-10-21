Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2241D1EABD0;
	Mon, 21 Oct 2024 12:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729512340; cv=none; b=Z1EnGrwVAwU1eJdkpyDoRdm2SsotIOrWkW0p3Ww2I9s574JhZ9qPDW60Evxr2pFIiiZF8H7MiIrWMgD68mU+LWA2KCUjBcdcJAs9NmDHmOX3aODSVHyEc0LC6ahvL7w81IjYRHvxXRhccu8mbp1Z99MGFsFc05sVC4v5mW+J9+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729512340; c=relaxed/simple;
	bh=ocX7JjbQByOOQt04KMmvwMOoXw+gk3Nf8nVfX6M107U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YNUdxQ9/abHpwL7YWAcYosz0/n/WApAppB4ByjyEzKenzkp1TEGOz7pc/xK9lg78kbDmZjV+Cv3GVWGKRJlgX9tbI7Qcm4POCLjbCtC3+MgZAJEqMsU2zfHRVZaFkxPaaroozRa1YwRLlbgPoH0xhMaeODnkM2IeuO8A7iusZAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=dHY6JMNI; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="dHY6JMNI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729512337; x=1761048337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ocX7JjbQByOOQt04KMmvwMOoXw+gk3Nf8nVfX6M107U=;
  b=dHY6JMNIKXOKHvd2fBTQ8R5Fh7Dt9cdqAHBUzrUwk53EfviSfYadcjt6
   BsqqiCumsX3GjZx8A8FY3uboiMZ7TuxdXwk2xZC6XMa5tmc05x/egDIsO
   6eexyPoqUfs6/45Og/dmZAM05T/5vOUeVbpc1dq4cvdblmNF0kFIqGtT3
   9xwmV/FeDqLJ+qV8rGlq70WFjhEgnH//LyeUjFZStcrqG/TiCB+o1ZB/u
   gphydH8yRq1HoyP7QlMJqM3QQrUVNHPdkLmO0h+dgvx/wX87hAxWWof1T
   fbOnkfL1AQXiiVXzV3rsVBWOVv9y4afP8Xl9X6+u4N/fYDY2Zq9yWMzLR
   A==;
X-CSE-ConnectionGUID: CUTOTaWxSyaKKq/80h3XYw==
X-CSE-MsgGUID: xTIf7CsNQpqo7GXHvljyKw==
X-IronPort-AV: E=Sophos;i="6.11,220,1725292800"; 
   d="scan'208";a="29967111"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Oct 2024 20:05:37 +0800
IronPort-SDR: 6716367c_Y+MyB6p61C+f6sOhQ0g6G12jZTUugn4GGW4dRABi3fe27cS
 gqzcW+83BfTy+oUS2j4Zgj1yZJSQHJr9T577DhA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2024 04:09:48 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2024 05:05:36 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 1/4] scsi: ufs: core: Introduce a new host register lock
Date: Mon, 21 Oct 2024 15:03:10 +0300
Message-Id: <20241021120313.493371-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241021120313.493371-1-avri.altman@wdc.com>
References: <20241021120313.493371-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new host register read/write lock.  Use it to protect access
to the task management doorbell register: UTMRLDBR.  This is not the
UTRLDBR which is already protected by its own outstanding_lock.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 26 ++++++++++++++++++--------
 include/ufs/ufshcd.h      |  3 +++
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9e6d008f4ea4..21eda055fb7d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1245,11 +1245,13 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
 static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
 {
 	const struct scsi_device *sdev;
+	unsigned long flags;
 	u32 pending = 0;
 
-	lockdep_assert_held(hba->host->host_lock);
+	spin_lock_irqsave(hba->host->host_lock, flags);
 	__shost_for_each_device(sdev, hba->host)
 		pending += sbitmap_weight(&sdev->budget_map);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	return pending;
 }
@@ -1271,7 +1273,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 	ktime_t start;
 
 	ufshcd_hold(hba);
-	spin_lock_irqsave(hba->host->host_lock, flags);
 	/*
 	 * Wait for all the outstanding tasks/transfer requests.
 	 * Verify by checking the doorbell registers are clear.
@@ -1283,7 +1284,10 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 			goto out;
 		}
 
+		spin_lock_irqsave(&hba->reg_lock, flags);
 		tm_doorbell = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
+		spin_unlock_irqrestore(&hba->reg_lock, flags);
+
 		tr_pending = ufshcd_pending_cmds(hba);
 		if (!tm_doorbell && !tr_pending) {
 			timeout = false;
@@ -1292,7 +1296,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 			break;
 		}
 
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		io_schedule_timeout(msecs_to_jiffies(20));
 		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
 		    wait_timeout_us) {
@@ -1304,7 +1307,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 			 */
 			do_last_check = true;
 		}
-		spin_lock_irqsave(hba->host->host_lock, flags);
 	} while (tm_doorbell || tr_pending);
 
 	if (timeout) {
@@ -1314,7 +1316,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 		ret = -EBUSY;
 	}
 out:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_release(hba);
 	return ret;
 }
@@ -6881,9 +6882,13 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 	irqreturn_t ret = IRQ_NONE;
 	int tag;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
+	spin_lock_irqsave(&hba->reg_lock, flags);
 	pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
+	spin_unlock_irqrestore(&hba->reg_lock, flags);
+
 	issued = hba->outstanding_tasks & ~pending;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
 	for_each_set_bit(tag, &issued, hba->nutmrs) {
 		struct request *req = hba->tmf_rqs[tag];
 		struct completion *c = req->end_io_data;
@@ -7065,11 +7070,13 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	memcpy(hba->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
 	ufshcd_vops_setup_task_mgmt(hba, task_tag, tm_function);
 
+	spin_unlock_irqrestore(host->host_lock, flags);
+
+	spin_lock_irqsave(&hba->reg_lock, flags);
 	/* send command to the controller */
 	__set_bit(task_tag, &hba->outstanding_tasks);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
-
-	spin_unlock_irqrestore(host->host_lock, flags);
+	spin_unlock_irqrestore(&hba->reg_lock, flags);
 
 	ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_SEND);
 
@@ -10469,6 +10476,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	sema_init(&hba->host_sem, 1);
 
+	/* Initialize host register read/write spinlock */
+	spin_lock_init(&hba->reg_lock);
+
 	/* Initialize UIC command mutex */
 	mutex_init(&hba->uic_cmd_mutex);
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a95282b9f743..6712833cc156 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -847,6 +847,7 @@ enum ufshcd_mcq_opr {
  * @host: Scsi_Host instance of the driver
  * @dev: device handle
  * @ufs_device_wlun: WLUN that controls the entire UFS device.
+ * @reg_lock: protect register reads/writes
  * @hwmon_device: device instance registered with the hwmon core.
  * @curr_dev_pwr_mode: active UFS device power mode.
  * @uic_link_state: active state of the link to the UFS device.
@@ -978,6 +979,8 @@ struct ufs_hba {
 	struct device *dev;
 	struct scsi_device *ufs_device_wlun;
 
+	spinlock_t reg_lock;
+
 #ifdef CONFIG_SCSI_UFS_HWMON
 	struct device *hwmon_device;
 #endif
-- 
2.25.1

