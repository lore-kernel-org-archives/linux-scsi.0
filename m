Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A62374F5
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jan 2024 12:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hxu+fRZo"
X-UUID: 3f35832caeec11ee9e680517dc993faa-20240109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=OVSdB3ffjjvy/33vCX7gSgD1MBNclv/B3WHdsWG5/r8=;
	b=hxu+fRZowEHHyR5uu1PmFMQ+qIQGpPIi3lIWGLv593mA62r+WM5+9H30ucwXx/BAE9wNJe5nESAGvS+3sj7qqQBovyHuVvvRnGFs8o5ixeFgJAp9TNcC4RLfypXKQ/3fsbe7WiZVooArRacbsGi4vmGQw8KMZhZm4vOglRco2NY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:d64258b5-38cc-435c-9381-5cec7044c47e,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:5d391d7,CLOUDID:984b287f-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
	NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 3f35832caeec11ee9e680517dc993faa-20240109
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1326773871; Tue, 09 Jan 2024 20:40:19 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 9 Jan 2024 20:40:17 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 9 Jan 2024 20:40:17 +0800
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
Subject: [PATCH v1 1/2] scsi: core: move auto suspend timer to Scsi_Host
Date: Tue, 9 Jan 2024 20:40:14 +0800
Message-ID: <20240109124015.31359-2-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20240109124015.31359-1-peter.wang@mediatek.com>
References: <20240109124015.31359-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--20.050800-8.000000
X-TMASE-MatchedRID: kLbINH/kiBSAAYHsHSPDcxn0UD4GU5Iq4OSJW6hGEzv4JyR+b5tvoHB4
	4IkzjfYyThbvLLI8RvPxY0WGgfScAw/mRvSsqYV7nu1HSadECDUxmbT6wQT2a01KG1YrOQW/1C1
	xDg+NhRCT3RiCXcXyqxfOdxvhPLmMmxh0gY/o+VmzLD5kmcW6ZFg3VqSTJ7SoJ3LvjgQ/uICCJD
	nrZiuTOONWoxLD8I/a8NsyesFB+nxBEeXXYJxA3sMOZc2T6sulfS0Ip2eEHnz3IzXlXlpamPoLR
	4+zsDTtAqYBE3k9Mpw=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--20.050800-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 9C69DBFA8D795FB59DCDAE2E2F359226932AD0273A2AF9C9DEB44A49F426C6292000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

Runtime suspend timer is a const value in scsi_host_template, which
host cannot modify this value.
Move it to Scsi_Host for host flexible use.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/scsi/sd.c         | 2 +-
 drivers/ufs/core/ufshcd.c | 9 +++++++--
 include/scsi/scsi_host.h  | 6 +++---
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 542a4bbb21bc..c1dc96331225 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3731,7 +3731,7 @@ static int sd_probe(struct device *dev)
 	blk_pm_runtime_init(sdp->request_queue, dev);
 	if (sdp->rpm_autosuspend) {
 		pm_runtime_set_autosuspend_delay(dev,
-			sdp->host->hostt->rpm_autosuspend_delay);
+			sdp->host->rpm_autosuspend_delay);
 	}
 
 	error = device_add_disk(dev, gd, NULL);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 16d76325039a..f9436d6560c4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7982,11 +7982,13 @@ static void ufshcd_set_active_icc_lvl(struct ufs_hba *hba)
 
 static inline void ufshcd_blk_pm_runtime_init(struct scsi_device *sdev)
 {
+	struct Scsi_Host *shost = sdev->host;
+
 	scsi_autopm_get_device(sdev);
 	blk_pm_runtime_init(sdev->request_queue, &sdev->sdev_gendev);
 	if (sdev->rpm_autosuspend)
 		pm_runtime_set_autosuspend_delay(&sdev->sdev_gendev,
-						 RPM_AUTOSUSPEND_DELAY_MS);
+						 shost->rpm_autosuspend_delay);
 	scsi_autopm_put_device(sdev);
 }
 
@@ -8988,7 +8990,6 @@ static const struct scsi_host_template ufshcd_driver_template = {
 	.track_queue_depth	= 1,
 	.skip_settle_delay	= 1,
 	.sdev_groups		= ufshcd_driver_groups,
-	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
 };
 
 static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
@@ -10439,6 +10440,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	host->max_cmd_len = UFS_CDB_SIZE;
 	host->queuecommand_may_block = !!(hba->caps & UFSHCD_CAP_CLK_GATING);
 
+	/* Use default RPM delay if host not set */
+	if (host->rpm_autosuspend_delay == 0)
+		host->rpm_autosuspend_delay = RPM_AUTOSUSPEND_DELAY_MS;
+
 	hba->max_pwr_info.is_valid = false;
 
 	/* Initialize work queues */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 3b907fc2ef08..b259d42a1e1a 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -497,9 +497,6 @@ struct scsi_host_template {
 	 *   scsi_netlink.h
 	 */
 	u64 vendor_id;
-
-	/* Delay for runtime autosuspend */
-	int rpm_autosuspend_delay;
 };
 
 /*
@@ -713,6 +710,9 @@ struct Scsi_Host {
 	 */
 	struct device *dma_dev;
 
+	/* Delay for runtime autosuspend */
+	int rpm_autosuspend_delay;
+
 	/*
 	 * We should ensure that this is aligned, both for better performance
 	 * and also because some compilers (m68k) don't automatically force
-- 
2.18.0

