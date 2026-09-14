Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1E6416873
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 08:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789375929; cv=none; b=kJafDcIbfzOXt6Gz0qajwzjsSW1EA9UcEbDVIEId+rX4T1UZmqELWcNK3j6pJC+zyFIZgHHDLiT4OtcMHGRtiukVUeDH6E3n9WgNFCeEvzGN8wA0jwy+5WrCRxMiDMTS5zSO/c99OCQJJAwpLEi/atoAk7gsIqvO7JKJoWpFNcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789375929; c=relaxed/simple;
	bh=nkEg8QHjxoHn8GN7wHagW2zgQ6iCDfNYrzy1dguz570=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p/OgnTG+XT0UALTbpVR4wx8jn9LBLgsc5Bn+a0WUqGsCjq4F2H8gJ0xBq4fNnz7mom7cvunmibALyDdynf4rpfoe0x3ujqLIRDu7RJ58AkG+LOaTYP98Ux3DnAXASgJC+IdTNUmVqdYLUxv8OcnXUgOZ7ELOJ75Qgx+v+ygF/7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=B74cx2Oa; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="B74cx2Oa"
X-UUID: 872de24cb01911f1b1788b6acf885367-20260914
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=yvwXZoaVVI3llVKEiJolksnzD6nYquYciue03eFu2Ec=;
	b=B74cx2OaDPQIxIYqhZQAMtWRpCHrhD9yfj23hwiDaxVDN8RBEuh6AXtEYSQDriWvw4Di4pnFYvhd0NCE0L7v2A81DBSWMuWbEZzF6bzbap7B2GqmBaIyXc1y5EANfgLnjrYFjX3GYFZd02fForW+zKO0x4wuI/5rEovHYitF7kM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2a711c8c-2030-48b6-b5fd-16884bf6e29c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:4e3ce573-33ce-4505-9996-536bc8c7fffe,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|123|836|865|888|898,TC:-5,Content:0|
	15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OS
	I:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 872de24cb01911f1b1788b6acf885367-20260914
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2127189614; Mon, 14 Sep 2026 16:51:51 +0800
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
Subject: [PATCH v2 2/2] ufs: serialize AHIT register access between sysfs and host driver
Date: Mon, 14 Sep 2026 16:49:25 +0800
Message-ID: <20260914085148.136429-3-peter.wang@mediatek.com>
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

A race exists between ufshcd_auto_hibern8_update() and
ufs_mtk_pwr_change_notify() when both paths concurrently access
REG_AUTO_HIBERNATE_IDLE_TIMER. Additionally, the static local
variable used to save/restore AHIT in the power change path is
not re-entrant and may hold a stale value if a sysfs write races
with a gear change.

Introduce ahit_mutex and ahit_disable_depth in struct ufs_hba to
serialize AHIT register access. The depth counter tracks how many
host-driver paths have forced AHIT off; sysfs writes are suppressed
while it is non-zero and the register is restored from hba->ahit
only when the last disabler drops it to zero.

Fixes: f5ca8d0c7a63 ("scsi: ufs: host: mediatek: Disable auto-hibern8 during power mode changes")
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c       | 14 +++++++++++++-
 drivers/ufs/host/ufs-mediatek.c | 16 ++++++++++++----
 include/ufs/ufshcd.h            |  8 ++++++++
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 39a4bdafc1af..c54ff35b4196 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4748,7 +4748,17 @@ void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit)
 	if (!pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)) {
 		ufshcd_rpm_get_sync(hba);
 		ufshcd_hold(hba);
-		ufshcd_configure_auto_hibern8(hba);
+		/*
+		 * Serialize with the host driver's AHIT control. Skip the
+		 * register write while the driver has AHIT forced off; the
+		 * driver programs hba->ahit back when it re-enables it.
+		 * Mutex is taken here (not across the rpm calls above) so it
+		 * never blocks a resume that the driver's path may need.
+		 */
+		mutex_lock(&hba->ahit_mutex);
+		if (!hba->ahit_disable_depth)
+			ufshcd_configure_auto_hibern8(hba);
+		mutex_unlock(&hba->ahit_mutex);
 		ufshcd_release(hba);
 		ufshcd_rpm_put_sync(hba);
 	}
@@ -11272,6 +11282,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	mutex_init(&hba->wb_mutex);
 
+	mutex_init(&hba->ahit_mutex);
+
 	init_rwsem(&hba->clk_scaling_lock);
 
 	ufshcd_init_clk_gating(hba);
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 814c1b7343b9..b6279edde176 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1507,19 +1507,27 @@ static int ufs_mtk_pwr_change_notify(struct ufs_hba *hba,
 				struct ufs_pa_layer_attr *dev_req_params)
 {
 	int ret = 0;
-	static u32 reg;
 
 	switch (stage) {
 	case PRE_CHANGE:
 		if (ufshcd_is_auto_hibern8_supported(hba)) {
-			reg = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
+			/* Block sysfs AHIT writes while we force AHIT off */
+			mutex_lock(&hba->ahit_mutex);
+			hba->ahit_disable_depth++;
+			mutex_unlock(&hba->ahit_mutex);
 			ufs_mtk_auto_hibern8_disable(hba);
 		}
 		ret = ufs_mtk_pre_pwr_change(hba, dev_req_params);
 		break;
 	case POST_CHANGE:
-		if (ufshcd_is_auto_hibern8_supported(hba))
-			ufshcd_writel(hba, reg, REG_AUTO_HIBERNATE_IDLE_TIMER);
+		if (ufshcd_is_auto_hibern8_supported(hba)) {
+			mutex_lock(&hba->ahit_mutex);
+			/* re-enable only when the last disabler drops off */
+			if (!--hba->ahit_disable_depth)
+				ufshcd_writel(hba, hba->ahit,
+					      REG_AUTO_HIBERNATE_IDLE_TIMER);
+			mutex_unlock(&hba->ahit_mutex);
+		}
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index dfd302f2dc7c..be62165b785e 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1132,6 +1132,14 @@ struct ufs_hba {
 
 	/* Auto-Hibernate Idle Timer register value */
 	u32 ahit;
+	/* Serializes AHIT register access between sysfs and the host driver */
+	struct mutex ahit_mutex;
+	/*
+	 * Nesting count of host-driver paths that have AHIT forced off.
+	 * Non-zero blocks sysfs AHIT writes; AHIT is reprogrammed only when
+	 * the last disabler drops it back to zero. Guarded by ahit_mutex.
+	 */
+	int ahit_disable_depth;
 
 	unsigned long outstanding_tasks;
 	spinlock_t outstanding_lock;
-- 
2.45.2

