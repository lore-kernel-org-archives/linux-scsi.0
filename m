Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319C918800D;
	Sun, 24 Nov 2024 07:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732432232; cv=none; b=sH/xgJoLhBS/IcJcjo4besfX26vziLL2cVHHP5l44CVSqSKeV2YD1FIUlI73sXtpwgAF/7QlXeSdgi384V41maELCNfKVD34w5BkQCXZxUG2EQKnk4WONoZUB7n5yKhlzcBCl9o6ckSI7Gqjh8Gf79UuB7Zi6d9Uik1PyiYVqhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732432232; c=relaxed/simple;
	bh=cuGox+h7gFiTcWM75U94A70C/d31PVTvBlBGnIeuKvw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Su9gt2dehxGsaurb+uUosfrnhxmtXSdRNMaWgEogEjo01D32r+H9WQuksWxp/KtmeR4jQbc8Xvcdi8BzMPXaZlT84iKx3aXZNk7wtYInjLCCde/bcIycNSoVFrcThikLXVgipQKyww8nQlnB0/34KGMbKi6hzjPc1k9NDQsfhv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=VWpbrYBq; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VWpbrYBq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1732432231; x=1763968231;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cuGox+h7gFiTcWM75U94A70C/d31PVTvBlBGnIeuKvw=;
  b=VWpbrYBqRaZ+/ssu49dxDJ4CWPpSIHfvFYXx/GvpqkQlk3W1zmJHEQR3
   ZCvY7bLtqJZrZ1fzlLSdmCZsh4NhY0F6NzSQR07b40PftZZNndYKi5UZY
   gydNw7eaIgzPNxp6rv0i83I2DYL1ETXN54w86Ce4ux0SrKCzlSbVOswiP
   Iqn/9f9JxQH/X6aIfpo4HcdOYXOc1ZhA3UckjYHvFduoZvpA8wmVjdw9P
   aTNmDMASxodfqdMKDdBg1o3a0MFmSUR5jhXfVvMJUgJXt213FI+d6AZSy
   Glx0AQL4ByC9EMwQjF7PvYU1//4W1uGdy1Ko1SQCRsZFsyiWF5nc3h/En
   w==;
X-CSE-ConnectionGUID: H5DJF2T1TnW6YxvM+UohWA==
X-CSE-MsgGUID: Bz4yMFo8SVSeULLsuNOd8A==
X-IronPort-AV: E=Sophos;i="6.12,180,1728921600"; 
   d="scan'208";a="32127827"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 Nov 2024 15:10:30 +0800
IronPort-SDR: 6742c419_MIAgYV0Q6HHv//CJh83DZ6vz0nJYcrNNthzNGNDSO0ADq1P
 ognUDZs1S6dnH6cgO9AaWKXLskGFVYryDzY9sww==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Nov 2024 22:13:45 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Nov 2024 23:10:29 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v5 2/4] scsi: ufs: core: Prepare to introduce a new clock_gating lock
Date: Sun, 24 Nov 2024 09:08:06 +0200
Message-Id: <20241124070808.194860-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241124070808.194860-1-avri.altman@wdc.com>
References: <20241124070808.194860-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Removed hba->clk_gating.active_reqs check from ufshcd_is_ufs_dev_busy
function to separate clock gating logic from general device busy checks.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e0a7ef1cb052..838bbab97438 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -266,8 +266,7 @@ static bool ufshcd_has_pending_tasks(struct ufs_hba *hba)
 
 static bool ufshcd_is_ufs_dev_busy(struct ufs_hba *hba)
 {
-	return hba->clk_gating.active_reqs || hba->outstanding_reqs ||
-	       ufshcd_has_pending_tasks(hba);
+	return hba->outstanding_reqs || ufshcd_has_pending_tasks(hba);
 }
 
 static const struct ufs_dev_quirk ufs_fixups[] = {
@@ -1949,7 +1948,9 @@ static void ufshcd_gate_work(struct work_struct *work)
 		goto rel_lock;
 	}
 
-	if (ufshcd_is_ufs_dev_busy(hba) || hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
+	if (ufshcd_is_ufs_dev_busy(hba) ||
+	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
+	    hba->clk_gating.active_reqs)
 		goto rel_lock;
 
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -8262,7 +8263,9 @@ static void ufshcd_rtc_work(struct work_struct *work)
 	hba = container_of(to_delayed_work(work), struct ufs_hba, ufs_rtc_update_work);
 
 	 /* Update RTC only when there are no requests in progress and UFSHCI is operational */
-	if (!ufshcd_is_ufs_dev_busy(hba) && hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL)
+	if (!ufshcd_is_ufs_dev_busy(hba) &&
+	    hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL &&
+	    !hba->clk_gating.active_reqs)
 		ufshcd_update_rtc(hba);
 
 	if (ufshcd_is_ufs_dev_active(hba) && hba->dev_info.rtc_update_period)
-- 
2.25.1

