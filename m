Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BF01991A5;
	Mon, 18 Nov 2024 14:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731941028; cv=none; b=aJRtj+APl4UhtJCzKjs5h/PAVQEeoS/9+G1iFBOTM0FVGJ2aQRsQZo+dgrC33k63D3Y0XU0DQuxxaww2iEcmT3Ep/yUpOMTFF8nTdQGF3sEHajI0hpdmRyx5i6aSpDO4hv4/GhlJ82I2qgM6J/dHRAyp9GxPndRrD0nrp52HKGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731941028; c=relaxed/simple;
	bh=8McA+5iIb3DIU5AKuV1ZWgCYvpLjpQ+BZIbMzp0xvPA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ONnjYMRdEdeZaAGLygSjaJ4ZrDDMD9Udn591gVRxg9BghVvty0RYCRJ5WhRNEzfXn2vOiiGiLXtUAlOORCmICzp21aeNX/zTzVLL5pb6QWu+LxXk3Zvhm81bzUzcroq0/BWdgi+rCnqh3YkRBKZzKBw1VQP5oStTUQDN04ek0T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Yp4fQL85; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Yp4fQL85"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1731941027; x=1763477027;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8McA+5iIb3DIU5AKuV1ZWgCYvpLjpQ+BZIbMzp0xvPA=;
  b=Yp4fQL85WgfCygqvKoDQXHu6EFAkdIn9EPD6YOt5xgYpsoYkHBOkvr83
   9B5KFYFXJeA0paxpM2F67vvMZXx3Dei7Qm2JHftFpT8aIEGeO/J7xAc1I
   neV9X+x2sVtC+TbqGWWRRKdLDPqXji7VB4elnWuMNtT08L0yGmxbESpKm
   u9z4xviXqRQE50Q3Kzb1soaklefxBshrMrKvCbG7G35tK+JjOZU8VRZCu
   M15TudWwWMlAxROb49vlA78FpSfmNi2ukYvtduS16MbhUBH150v9+WQ21
   E2Y715HXUL/DOW7EZCS3aOJg83PBsq/DflNM6rW5ONUSpXeClQS63g42+
   A==;
X-CSE-ConnectionGUID: sCAtjnnqRCKzGvTulF24Hg==
X-CSE-MsgGUID: 9Rs4FbAnQ/KnKYRnxRi8kg==
X-IronPort-AV: E=Sophos;i="6.12,164,1728921600"; 
   d="scan'208";a="31826980"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2024 22:43:47 +0800
IronPort-SDR: 673b455c_5ZZ1+B0HIab3F8ulq5lkjqs+lssCQuH1vpCDFnf8vayV7kj
 HUK0Jii414hZurFAq7piteVD1ygEeuzcjMsQzSw==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2024 05:47:08 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Nov 2024 06:43:44 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 1/3] scsi: ufs: core: Prepare to introduce a new clock_gating lock
Date: Mon, 18 Nov 2024 16:41:15 +0200
Message-Id: <20241118144117.88483-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241118144117.88483-1-avri.altman@wdc.com>
References: <20241118144117.88483-1-avri.altman@wdc.com>
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
 drivers/ufs/core/ufshcd.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e338867bc96c..be5fe2407382 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -258,10 +258,15 @@ ufs_get_desired_pm_lvl_for_dev_link_state(enum ufs_dev_pwr_mode dev_state,
 	return UFS_PM_LVL_0;
 }
 
+static bool ufshcd_has_pending_tasks(struct ufs_hba *hba)
+{
+	return hba->outstanding_tasks || hba->active_uic_cmd ||
+	       hba->uic_async_done;
+}
+
 static bool ufshcd_is_ufs_dev_busy(struct ufs_hba *hba)
 {
-	return (hba->clk_gating.active_reqs || hba->outstanding_reqs || hba->outstanding_tasks ||
-		hba->active_uic_cmd || hba->uic_async_done);
+	return hba->outstanding_reqs || ufshcd_has_pending_tasks(hba);
 }
 
 static const struct ufs_dev_quirk ufs_fixups[] = {
@@ -1943,7 +1948,9 @@ static void ufshcd_gate_work(struct work_struct *work)
 		goto rel_lock;
 	}
 
-	if (ufshcd_is_ufs_dev_busy(hba) || hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
+	if (ufshcd_is_ufs_dev_busy(hba) ||
+	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
+	    hba->clk_gating.active_reqs)
 		goto rel_lock;
 
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -1999,8 +2006,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
 	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
-	    hba->outstanding_tasks || !hba->clk_gating.is_initialized ||
-	    hba->active_uic_cmd || hba->uic_async_done ||
+	    ufshcd_has_pending_tasks(hba) || !hba->clk_gating.is_initialized ||
 	    hba->clk_gating.state == CLKS_OFF)
 		return;
 
@@ -8221,7 +8227,9 @@ static void ufshcd_rtc_work(struct work_struct *work)
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

