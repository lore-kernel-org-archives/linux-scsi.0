Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2201E1AE863;
	Thu, 24 Oct 2024 07:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729756370; cv=none; b=GJKq4Fgvik+kGuFVqKzJB4l7U+BLLCPqKwG+lV5T5elGBlBkIqPq4eyrwbmxLfJ+IYu+gkBQ8PBZseQneEJL4mqwToS78k4tV48x98Po342BQO6P3YlU4uW6S5/qsAaZuxBzazyn57X/6U5kDjODtTXo5z8U4elAmzAxi2xt7r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729756370; c=relaxed/simple;
	bh=NYjnmqabNKGDS/WLRXvLR7lqItwGdNIJsjD74Ocw3e8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=krMeIJNMJ620vOP0aixwht+HTVzqgjXuilZP8NXXenLBYtdZDrZXnPakqLjbLwD85MlZuhO1bEb/SPNmsh0WjHw+MBfzOfoSydmSP7shtykxzDVKbAxPRE0sh2740V8HitA5urgyv8BY6JEH9letZ6nE7plvGw3XrGe+xBHUZ7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=MWWsr1z8; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MWWsr1z8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1729756368; x=1761292368;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NYjnmqabNKGDS/WLRXvLR7lqItwGdNIJsjD74Ocw3e8=;
  b=MWWsr1z8VUux7ZkAgechVPUlBr43Fqa2W1Dp5b96YgVn+VemdH8LmH/E
   yP1VIAsEjkawNtAiLxmuRBZrelT6SwmQoSNzkJVxHe+JNIokrjAxaB33W
   1zVY/GhzgSi7lqamrO8NSKwFrHRqzo2XgLbxncScFyt2WJxoaFhmTnCBE
   RjyD4fw5emPW4XeMEEtGFeIfY35Tapy4v7jnYxK1t05wa+f++4/yAWDHf
   2xfybHZqtDpUzzQoVGU8ZMqqUm1PzyFToYIEG2OBPgxDgjPLqWFX/sthb
   00GK9vXc9bBLTgCeXBCHnG6XsISX/wUm92D9h8mq4mhAErydxGcDVRFuz
   g==;
X-CSE-ConnectionGUID: GcAk89KQQUGd71H086u0MA==
X-CSE-MsgGUID: AID6n5ueTd2t/m5VvLn0JA==
X-IronPort-AV: E=Sophos;i="6.11,228,1725292800"; 
   d="scan'208";a="29156102"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 Oct 2024 15:52:43 +0800
IronPort-SDR: 6719ee59_k9Pn0fkzysnqzw1p7yvU0bCoadYhKBW0iIyIV+T63Ru7mCA
 SyZNHuARANUkVhzqIvwNvWKYWMD3S+9gDdT5/aQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Oct 2024 23:51:05 -0700
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Oct 2024 00:52:42 -0700
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 1/3] scsi: ufs: core: Remove redundant host_lock calls around UTMRLDBR.
Date: Thu, 24 Oct 2024 10:50:31 +0300
Message-Id: <20241024075033.562562-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241024075033.562562-1-avri.altman@wdc.com>
References: <20241024075033.562562-1-avri.altman@wdc.com>
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
 drivers/ufs/core/ufshcd.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9e6d008f4ea4..faea4b294bdb 100644
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

