Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50CC471CFE
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 09:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788945093; cv=none; b=Rh2rtZYsFTBgzy9sNNeK9UmGKGvLBc2efCtyvBvoUXc9RUkuHp/23HJ03+C2HKfNqv711WNHrz9B9e5cqiGb4fy6kKq0pfajIRJrwufwYKOBTgyuJ04r6gSYixXyo1NZWVYZgs+Oks9iwi/MK80+cynwg+M52Hz2GECN0H9KiL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788945093; c=relaxed/simple;
	bh=I+pJxaqVJa0TSlGxYxIvbXRcDPCenaPlQVKDQd6fJiQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lh437YHbghTiETeNmyZzWNnszHm7FQX7eZ+PmFuo6LbDrcCY1T/hS/d8lHfVas35wx5DCJQbLGjA+Uehnm07AYuoi7V69SyVfvq56cYSXkq3vb/ouu+Gr3XyASQCxAAh+37kbJrctyWWwmJrUKBb7hIXN5yHrOCtGxTIaZFQ8wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=LvzQUMFk; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LvzQUMFk"
X-UUID: 6d8b8e50ac2e11f1b1788b6acf885367-20260909
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=LLu4gYFl4Wew5iASt7rrMwLrvQqTxcczEstYXYC3JZs=;
	b=LvzQUMFk8JiLPZnQIR60Gv0pS3fCrZLjyDNOIICpXDWB1QA7Ooe3N31PC4suHWI3aQ3x9PQ0sxCUbkDOb+iDJB776iWdquO6cd4D9I2CbChsEA1iUr6DcuFn88C+z9eIldWQV0giqgcO4N9mw+3EfZeVUZiX982c+hlYNC2XmoY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:f9e7a76b-7ffe-459d-a642-ad30299b5deb,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:502390dc-e2a3-4c41-83fa-4adacd638ae3,B
	ulkID:nil,BulkQuantity:0,SF:102|123|836|865|888|898,TC:-5,Content:0|15|50|
	99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6d8b8e50ac2e11f1b1788b6acf885367-20260909
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1712330163; Wed, 09 Sep 2026 17:11:23 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 9 Sep 2026 17:11:22 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 9 Sep 2026 17:11:22 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@sandisk.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
	<bvanassche@acm.org>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>
Subject: [PATCH v1] ufs: core: serialize AHIT register access between sysfs and host driver
Date: Wed, 9 Sep 2026 17:10:07 +0800
Message-ID: <20260909091120.1134414-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
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
index 2ba244cf40ac..e88b905eb7bc 100644
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
@@ -11268,6 +11278,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
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

