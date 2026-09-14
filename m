Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BFF413791
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 08:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789375927; cv=none; b=RSgs6LSwzDedmnxCc6E1MhVER+CfYxymm2CYC+/gKM2/AnxF0dyVcMpTuakoxXG8hyrCcaBQXOSnyTpZR01ZkAWZzSoRqMjnNh04+uy8y9Y9Z1R3dEhWyYKez9bNpvs/qd49+9ytkIjBay51OndDXln0PRVSjOtPsBxiWNT1Y70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789375927; c=relaxed/simple;
	bh=7l0EgbIGgXia/hgNmnWtJ+nXSTV3W3enh47u5OtogJ8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jwiOCr0joiOnOjq1pddppwpxjvfEyB76DVWfYAJ96vc1U0kcZGa349h3EwcDYLfv8tCcPZwkQsBIPXtgZjUZvhb7KIunf7tCCYk9wwbY9Oezj1SUrBM1t7XGGHDwq9P19I5UyYnI1ysoa1XQ2GM67K34abLqoi7C5nKn5sKuCr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=N4ZncBQ5; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="N4ZncBQ5"
X-UUID: 872bbf9eb01911f1b1788b6acf885367-20260914
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=GOuG61iTfPkPb10vCbDXqns0ZDJWlhA4Idvev9NbmVA=;
	b=N4ZncBQ50ltA+15h/nul3EKEozeSkIq1jABRYJNPsq59pOE7I1VgsjJLK5oE19oBvz4/lrhou3O60d8vTXULJwVJI/imnUR0ukOFa5fgHwlXKDwiQcL6DOHu6x3Y0qwa/nfc9ejhW74J/YJOSxw32njMfV4pdZ4k15NdiIRO9Pg=;
X-CID-CACHE: Type:Local,Time:202609141651+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:62ec87ae-017c-4c32-8e33-3ae0945abf13,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:baa7c3dc-e2a3-4c41-83fa-4adacd638ae3,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|123|136|836|865|888|898,TC:-5,Conten
	t:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1
	,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 872bbf9eb01911f1b1788b6acf885367-20260914
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 840278784; Mon, 14 Sep 2026 16:51:51 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 14 Sep 2026 16:51:50 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 14 Sep 2026 16:51:49 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@sandisk.com>, <alim.akhtar@samsung.com>, <bvanassche@acm.org>,
	<santosh.sy@samsung.com>, <h.vinayak@samsung.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>
Subject: [PATCH v2 1/2] ufs: always notify POST_CHANGE even on gear switch failure
Date: Mon, 14 Sep 2026 16:49:24 +0800
Message-ID: <20260914085148.136429-2-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260914085148.136429-1-peter.wang@mediatek.com>
References: <20260914085148.136429-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

Previously, POST_CHANGE was only notified on a successful gear switch.
This could leave the host in an inconsistent state if resources were
acquired in PRE_CHANGE (e.g. disabling auto-hibern8) but never
released due to a missing POST_CHANGE.

Fix this by always calling POST_CHANGE regardless of the gear switch
result. On failure, pass dev_req_params = NULL to signal that there is
nothing to apply; hosts that receive NULL simply skip their post work.

Update the affected vendor drivers (ufs-exynos and ufshcd-pci) to
guard their POST_CHANGE logic with a NULL check so they correctly
handle the failure case.

Fixes: f5ca8d0c7a63 ("scsi: ufs: host: mediatek: Disable auto-hibern8 during power mode changes")
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c     | 8 ++++++--
 drivers/ufs/host/ufs-exynos.c | 4 +++-
 drivers/ufs/host/ufshcd-pci.c | 3 ++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..39a4bdafc1af 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4979,8 +4979,12 @@ int ufshcd_change_power_mode(struct ufs_hba *hba,
 
 	ret = ufshcd_dme_change_power_mode(hba, pwr_mode, pmc_policy);
 
-	if (!ret)
-		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, pwr_mode);
+	/*
+	 * Always notify POST_CHANGE to pair with PRE_CHANGE, even on failure.
+	 * On failure, pass dev_req_params = NULL to indicate nothing to apply.
+	 * POST_CHANGE return value is advisory and does not mask @ret.
+	 */
+	ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, ret ? NULL : pwr_mode);
 
 	return ret;
 }
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index b2f65c465525..3bcbc9ebbb28 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1782,7 +1782,9 @@ static int exynos_ufs_pwr_change_notify(struct ufs_hba *hba,
 		ret = exynos_ufs_pre_pwr_mode(hba, dev_req_params);
 		break;
 	case POST_CHANGE:
-		ret = exynos_ufs_post_pwr_mode(hba, dev_req_params);
+		/* NULL when the gear switch failed: nothing to apply */
+		if (dev_req_params)
+			ret = exynos_ufs_post_pwr_mode(hba, dev_req_params);
 		break;
 	}
 
diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 21bb11c724be..668b57403e62 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -166,7 +166,8 @@ static int ufs_intel_lkf_pwr_change_notify(struct ufs_hba *hba,
 			ufs_intel_set_lanes(hba, 2);
 		break;
 	case POST_CHANGE:
-		if (ufshcd_is_hs_mode(dev_req_params)) {
+		/* NULL when the gear switch failed: nothing to apply */
+		if (dev_req_params && ufshcd_is_hs_mode(dev_req_params)) {
 			u32 peer_granularity;
 
 			usleep_range(1000, 1250);
-- 
2.45.2

