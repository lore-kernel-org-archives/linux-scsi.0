Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541754EB2B
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 07:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709881374; cv=none; b=hw0lf/tfxyCPjhXlsPvVQaa/FnE7UK/3ZWYfD4qjfTWfp3hl/2g9u42k1wFA7MS+UNfoRwemVHa+vMCm1uv3WCOa3IUW6DqnZA3dhbR6HHBEKTW4FYEOykAOltGF+HEYNwcXfMRWtit+b0mJ+jy8Qsys2l14u/OPBAp81Hyc31A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709881374; c=relaxed/simple;
	bh=FOix3GF6xDVdvLzhfRejaKA2mfX5Q4PyTyV0Uc4/JIs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b9cBwQ3ki61BDUPxkIY/EZI8Q838v6zAkW5ds1mkR87T4AZBUpQucSkwWshqhSoKRUcNzM8sgFgYCGrVJHsh7uU7iuh2LfK0tNkY1TvBGu8e88H7t8LA1q5qqF7fUIVskaErGsJNBU26snA39ps5Q12olXlvUxH/bcynbnB600o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=CqlHclwC; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="CqlHclwC"
X-UUID: dd1f4586dd1911ee935d6952f98a51a9-20240308
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=gT7dGQBmI5VvS3tK3/7lsJiumEuQy1bX+ob0+VMfsWg=;
	b=CqlHclwCQRIJ4wsHEVoHpg1A13O/11mm6Lg9gZoDm6nTW1JYgOev/Gpsny9xr8phu3D+V3qARKeQVBUrAizavP9eMjQajIRq5E+8POKj4m4nCyTzW+x5AjQgjYvsYJcfSs0KkDDwQpPw7n5T8m6vhqInJrskU4V2+XHultfhLQg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:6dea272a-00ca-4b7b-9a54-d50dc8a92f45,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6f543d0,CLOUDID:cebc2a90-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: dd1f4586dd1911ee935d6952f98a51a9-20240308
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1846334345; Fri, 08 Mar 2024 15:02:44 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 8 Mar 2024 15:02:44 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 8 Mar 2024 15:02:44 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<powen.kao@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <chu.stanley@gmail.com>
Subject: [PATCH v1 5/7] ufs: host: mediatek: rename host power control API
Date: Fri, 8 Mar 2024 15:02:39 +0800
Message-ID: <20240308070241.9163-6-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20240308070241.9163-1-peter.wang@mediatek.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--8.937300-8.000000
X-TMASE-MatchedRID: pO+4S45NqGgMQLXc2MGSbNIKqYKXY3SWjeDfyjN4mgcH8UzOewTxw64T
	oUk/aSm109NQNrxIpFbzrL9jlOCHAVfdwZmjAXfzkDpLRKO9xhRA8JZETQujwgZbeEWcL03VFKw
	SiW1W6O1fSVVy8GyA5uIwzQmYBQ97hEy3/eAjCRieAiCmPx4NwBnUJ0Ek6yhjxEHRux+uk8h+IC
	quNi0WJA2oD3nmY3rChgcVucK80GgNmlj9gEVxXtJHoHJr4QNaftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.937300-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 78655E13DE2074A191B0951B86E0854DF9D4D449F74F5D10B32B846BD99D58152000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

From: Po-Wen Kao <powen.kao@mediatek.com>

Host power control is control crypto sram power.
Rename it for easy maintain.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Po-Wen Kao <powen.kao@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek-sip.h | 13 +++----------
 drivers/ufs/host/ufs-mediatek.c     |  4 ++--
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek-sip.h b/drivers/ufs/host/ufs-mediatek-sip.h
index 30146bb1ccbe..fd640846910a 100755
--- a/drivers/ufs/host/ufs-mediatek-sip.h
+++ b/drivers/ufs/host/ufs-mediatek-sip.h
@@ -16,7 +16,7 @@
 #define UFS_MTK_SIP_DEVICE_RESET          BIT(1)
 #define UFS_MTK_SIP_CRYPTO_CTRL           BIT(2)
 #define UFS_MTK_SIP_REF_CLK_NOTIFICATION  BIT(3)
-#define UFS_MTK_SIP_HOST_PWR_CTRL         BIT(5)
+#define UFS_MTK_SIP_SRAM_PWR_CTRL         BIT(5)
 #define UFS_MTK_SIP_GET_VCC_NUM           BIT(6)
 #define UFS_MTK_SIP_DEVICE_PWR_CTRL       BIT(7)
 
@@ -31,13 +31,6 @@ enum ufs_mtk_vcc_num {
 	UFS_VCC_MAX
 };
 
-/*
- * Host Power Control options
- */
-enum {
-	HOST_PWR_HCI = 0,
-	HOST_PWR_MPHY
-};
 
 /*
  * SMC call wrapper function
@@ -78,8 +71,8 @@ static inline void _ufs_mtk_smc(struct ufs_mtk_smc_arg s)
 #define ufs_mtk_device_reset_ctrl(high, res) \
 	ufs_mtk_smc(UFS_MTK_SIP_DEVICE_RESET, &(res), high)
 
-#define ufs_mtk_host_pwr_ctrl(opt, on, res) \
-	ufs_mtk_smc(UFS_MTK_SIP_HOST_PWR_CTRL, &(res), opt, on)
+#define ufs_mtk_sram_pwr_ctrl(on, res) \
+	ufs_mtk_smc(UFS_MTK_SIP_SRAM_PWR_CTRL, &(res), on)
 
 #define ufs_mtk_get_vcc_num(res) \
 	ufs_mtk_smc(UFS_MTK_SIP_GET_VCC_NUM, &(res))
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index ae184e4f90e6..2caf0c1d4e17 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1376,7 +1376,7 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	if (ufshcd_is_link_off(hba))
 		ufs_mtk_device_reset_ctrl(0, res);
 
-	ufs_mtk_host_pwr_ctrl(HOST_PWR_HCI, false, res);
+	ufs_mtk_sram_pwr_ctrl(false, res);
 
 	return 0;
 fail:
@@ -1397,7 +1397,7 @@ static int ufs_mtk_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
 		ufs_mtk_dev_vreg_set_lpm(hba, false);
 
-	ufs_mtk_host_pwr_ctrl(HOST_PWR_HCI, true, res);
+	ufs_mtk_sram_pwr_ctrl(true, res);
 
 	err = ufs_mtk_mphy_power_on(hba, true);
 	if (err)
-- 
2.18.0

