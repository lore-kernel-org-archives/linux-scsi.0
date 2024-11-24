Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA7317C21B;
	Sun, 24 Nov 2024 07:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732432232; cv=none; b=WI8Ux2HlwITh0Q0WPEuKhOF81/QwpFI4HXZOFkp9bvfwX1Z3GuB9OQkPC0R7KFodbojdLhM1C3nxBJlFdLqdghGlSQ4p/AxC1J2djdrPv/YSLXG0rFkczQ94n5+cGH1D0HYBowRauMyExJi7W2nQpM6Z6dZgPrxrafQ73BkfdTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732432232; c=relaxed/simple;
	bh=oQrk5Hkea18ry2jQ5QDwE6l9h5XKpc7q8t2KD7t3x5U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hcg9l5FVgbpNaVzKykVVrlaeKMDtSYxHjE6/BCm9w6cvmQ86nbTQhZ2zhsSRGZEa425SAI0lv4qO+oIqbdBAaSyWFyESHTti4SqEnS1bHRiKBzgAmLEusHt6+jnh87dEDY7XmNycxVTVyZVQvIAUktiWv69su3WX9mF7aMM8tLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=Vjps4Bb5; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Vjps4Bb5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1732432230; x=1763968230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oQrk5Hkea18ry2jQ5QDwE6l9h5XKpc7q8t2KD7t3x5U=;
  b=Vjps4Bb5v58aI7XbLKVLRYePvnWSJhbjDqa3buwc0gXBRKsB9i6e/GkX
   dbsfSKejx3tz5P4LEmQQcsRg+n+7U6TFIdUATulmQCLVDBuM+6szzpGLY
   xGUjVLhgpW2q/jDIDOCE3es6lchxEDybCIZ/y+FeSoaT6IcjLF49fBZF1
   bCuqYBrhYv9lAJ4XDzxKHAxyVpBqrtbZ+qiWCVIbdi/VhVHeYl/jyxD31
   y81yY1yN7B6C5gpQzQ0fGfn2DDFlCockWlxRprDvXkvIIileXghl7xGYo
   jqz27eSm5K/DmV2seIMB5wNyXMPZ41BhmP2lxMtoXGx87qbV9cKCfmPis
   A==;
X-CSE-ConnectionGUID: gUopVunOTVWfMDfxqTKpow==
X-CSE-MsgGUID: 3hZ/+T74QBGEwEEFD+AXCg==
X-IronPort-AV: E=Sophos;i="6.12,180,1728921600"; 
   d="scan'208";a="32127823"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 Nov 2024 15:10:25 +0800
IronPort-SDR: 6742c415_E7CsR2Ac7R81dpZ4fa8Ocvx8tC8+OaYZEWglvJAHiSGCvaQ
 x6foekNlkNgwVhkCLmJ0NbaiVHeXZIfM9wL8EFA==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Nov 2024 22:13:41 -0800
WDCIronportException: Internal
Received: from avri-office.ad.shared (HELO avri-office.sdcorp.global.sandisk.com) ([10.45.31.142])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Nov 2024 23:10:24 -0800
From: Avri Altman <avri.altman@wdc.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v5 1/4] scsi: ufs: core: Introduce ufshcd_has_pending_tasks
Date: Sun, 24 Nov 2024 09:08:05 +0200
Message-Id: <20241124070808.194860-2-avri.altman@wdc.com>
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

Prepare to removed hba->clk_gating.active_reqs check from
ufshcd_is_ufs_dev_busy.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/ufs/core/ufshcd.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index acc3607bbd9c..e0a7ef1cb052 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -258,10 +258,16 @@ ufs_get_desired_pm_lvl_for_dev_link_state(enum ufs_dev_pwr_mode dev_state,
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
+	return hba->clk_gating.active_reqs || hba->outstanding_reqs ||
+	       ufshcd_has_pending_tasks(hba);
 }
 
 static const struct ufs_dev_quirk ufs_fixups[] = {
@@ -1999,8 +2005,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
 
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
 	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
-	    hba->outstanding_tasks || !hba->clk_gating.is_initialized ||
-	    hba->active_uic_cmd || hba->uic_async_done ||
+	    ufshcd_has_pending_tasks(hba) || !hba->clk_gating.is_initialized ||
 	    hba->clk_gating.state == CLKS_OFF)
 		return;
 
-- 
2.25.1

