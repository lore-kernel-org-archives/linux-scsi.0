Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D374936124;
	Tue, 22 Oct 2024 07:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729583142; cv=none; b=L6dOGN9PxKtzqykdxEfAjlv6BP7kO/E9D6bTYiOksXtKvvCU75jAPzCU/9Yc+2dT3IaAIXdqTcz2p1JAR6KQzPwPbGQeK0tWqZxe1Vg6JH086jgTEl3ytwBOr2FfN/ZIQ1imR2QpRn00lnUXytoWZ0AzlXTJg8T1evvoUpa37U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729583142; c=relaxed/simple;
	bh=cIh3TOoCr8Vpu8u8J5nmz829eCRHULPA3N2J4cliIr8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XAo3sjT/qaN4tkREAwHxPUP76YoukZSHGseT2tz5qyyVj++EvcLqPKvp6Zg9DgARm/wQvW6ImicH7myRccanWuDnWYs066XzX9yvObYbeoLhIz7/kd/mTwemAhxk7jD9tXssyjIFVZAuxFJ7FlQznf5kQqMpq0dtFCg3D4CcNdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BeYIQMeI; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BeYIQMeI"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729583140; x=1761119140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cIh3TOoCr8Vpu8u8J5nmz829eCRHULPA3N2J4cliIr8=;
  b=BeYIQMeI8433NN8grR3HRof6zHaecJsS99VDbC1giQTEl6HgVcXkfhVk
   qcEOEnMJFXuaYUZ6iJNKfMcb+DtRZq57xoEYsC2Fh/ElgTJaRNRVqkVJc
   KZK3T4TvEgxsFuqCdW2ePRWoYRE9y737unZ7Iey8xgXFuXLgbA8obHh8Y
   wyMLvqpkePN4m32CL3TPNiBJN/Eha0kEM4OX7cz1meTUCaDEhZx9vJ2mz
   9Xn3uPigDsKj9TRt1rmDvytH2bqisonoivnfgLL6kTn7PSnBzgkYiqCkQ
   w97yAu9bF/3sPP/owZ0XIgivdxBcrSX4dQmwa/qDrvwTfqKKRzyFu+bke
   Q==;
X-CSE-ConnectionGUID: ZSE40qeLQi270E1pKv7jDw==
X-CSE-MsgGUID: 18Uw2Yk8TIu2zOMacxOEHQ==
X-IronPort-AV: E=Sophos;i="6.11,222,1725292800"; 
   d="scan'208";a="29564290"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Oct 2024 15:45:33 +0800
IronPort-SDR: 671749ae_2vr7/pFedV+1IJuPCvFNkeB7OJFluhHSOuyFRF+TFB14DBr
 K7GgQTDaJ7rqcTyoXYuPK8THGi0oiyAxdNKU93w==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Oct 2024 23:43:59 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Oct 2024 00:45:32 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 1/3] scsi: ufs: core: Remove redundant host_lock calls around UTMRLDBR.
Date: Tue, 22 Oct 2024 10:43:17 +0300
Message-Id: <20241022074319.512127-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241022074319.512127-1-avri.altman@wdc.com>
References: <20241022074319.512127-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no need to serialize single read/write calls to the host
controller registers. Remove the redundant host_lock calls that protect
access to the task management doorbell register: UTMRLDBR.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9e6d008f4ea4..29f1cd3375bd 100644
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
@@ -1263,7 +1265,6 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
 static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 					u64 wait_timeout_us)
 {
-	unsigned long flags;
 	int ret = 0;
 	u32 tm_doorbell;
 	u32 tr_pending;
@@ -1271,7 +1272,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 	ktime_t start;
 
 	ufshcd_hold(hba);
-	spin_lock_irqsave(hba->host->host_lock, flags);
 	/*
 	 * Wait for all the outstanding tasks/transfer requests.
 	 * Verify by checking the doorbell registers are clear.
@@ -1292,7 +1292,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 			break;
 		}
 
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		io_schedule_timeout(msecs_to_jiffies(20));
 		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
 		    wait_timeout_us) {
@@ -1304,7 +1303,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 			 */
 			do_last_check = true;
 		}
-		spin_lock_irqsave(hba->host->host_lock, flags);
 	} while (tm_doorbell || tr_pending);
 
 	if (timeout) {
@@ -1314,7 +1312,6 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 		ret = -EBUSY;
 	}
 out:
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_release(hba);
 	return ret;
 }
@@ -6877,13 +6874,13 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
  */
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 {
-	unsigned long flags, pending, issued;
+	unsigned long flags;
+	unsigned long pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
+	unsigned long issued = hba->outstanding_tasks & ~pending;
 	irqreturn_t ret = IRQ_NONE;
 	int tag;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
-	issued = hba->outstanding_tasks & ~pending;
 	for_each_set_bit(tag, &issued, hba->nutmrs) {
 		struct request *req = hba->tmf_rqs[tag];
 		struct completion *c = req->end_io_data;
@@ -7065,12 +7062,13 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	memcpy(hba->utmrdl_base_addr + task_tag, treq, sizeof(*treq));
 	ufshcd_vops_setup_task_mgmt(hba, task_tag, tm_function);
 
-	/* send command to the controller */
 	__set_bit(task_tag, &hba->outstanding_tasks);
-	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
 
 	spin_unlock_irqrestore(host->host_lock, flags);
 
+	/* send command to the controller */
+	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TASK_REQ_DOOR_BELL);
+
 	ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_SEND);
 
 	/* wait until the task management command is completed */
-- 
2.25.1

