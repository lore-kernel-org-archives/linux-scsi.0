Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF2C13B280
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 10:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758192018; cv=none; b=ql5kAnRKC+Voz4DBNEXAOeEizxNY+LnbGhAk8i3SLI8qvt/2o+3A6dbCx4RiuXS2KPyXzRBuY2lB5WMIe0W+aGqXVzZ4MCybYK3h3MyFaB53lzkgk9WmMozNueBPujVmF1g0Om38XNVbagS29MNDqNNI5dYtHYdl7e8rn4i4oas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758192018; c=relaxed/simple;
	bh=dfEucUySerkNb2w9+JFgu1L2DfuFGu/2ydeIGHmGZkE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M+CXUlPLK+8M9xiue0T2HWNg7bVi5v/DVmFOk6/htDLKnDoosZxle/v9L9pIl8sDdZ3cbh+NphtkRMQ3v0heMlagtInKVtqE7tv4uuXEWbt/iRsTaUNO+xcEQG4dk6R3l85R7yV4JMDgkskHKmg+lUhWj7crp+QRcZcMGQBzjtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=jHp3/eNi; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jHp3/eNi"
X-UUID: d60e5bea947b11f0b33aeb1e7f16c2b6-20250918
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=gxHolkfQ3ut06Oj1uBI3sHCzAqgWmq5Qj7UPQ6rBeAU=;
	b=jHp3/eNiBg6Gpdy99AfWZ8vQHSI0drL7fv8MrSyQNgEZzScZIJsbGfvxUYax4wK5wwJwk5g87AXuNNYCtO+L874x2CMCfY1UZ+YN8oEFK0+J0JQfNYPiBHtiWx2zb405XXT4JP4cslVGRcsF5gXjaucrrxO2/oPkMHxcwlY3xqI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:d1b4ff17-5def-4a56-9989-a7bfd4c8e63f,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:1ca6b93,CLOUDID:2cc170f8-ebfe-43c9-88c9-80cb93f22ca4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|888|898,TC:-5,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d60e5bea947b11f0b33aeb1e7f16c2b6-20250918
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2009458776; Thu, 18 Sep 2025 18:40:04 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 18 Sep 2025 18:40:03 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 18 Sep 2025 18:40:03 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1 06/10] ufs: host: mediatek: Enable interrupts for MCQ mode
Date: Thu, 18 Sep 2025 18:36:16 +0800
Message-ID: <20250918104000.208856-7-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250918104000.208856-1-peter.wang@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Alice Chao <alice.chao@mediatek.com>

Enable interrupts in MCQ mode before making the host
operational in the UFS Mediatek driver. This ensures proper
handling of task request completions and error conditions.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Alice Chao <alice.chao@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c       | 3 ++-
 drivers/ufs/host/ufs-mediatek.c | 2 ++
 drivers/ufs/host/ufs-mediatek.h | 3 +++
 include/ufs/ufshcd.h            | 1 +
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4e0de3a6d9b6..4893838764ae 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -357,7 +357,7 @@ EXPORT_SYMBOL_GPL(ufshcd_disable_irq);
  * @hba: per adapter instance
  * @intrs: interrupt bits
  */
-static void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
+void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
 {
 	u32 old_val = ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 	u32 new_val = old_val | intrs;
@@ -365,6 +365,7 @@ static void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs)
 	if (new_val != old_val)
 		ufshcd_writel(hba, new_val, REG_INTERRUPT_ENABLE);
 }
+EXPORT_SYMBOL_GPL(ufshcd_enable_intr);
 
 /**
  * ufshcd_disable_intr - disable interrupts
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 851a4d839631..18ce985970f3 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1683,6 +1683,8 @@ static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
 
 	if (hba->mcq_enabled) {
 		ufs_mtk_config_mcq(hba, false);
+		/* Enable required interrupts */
+		ufshcd_enable_intr(hba, UFSHCD_ENABLE_MTK_MCQ_INTRS);
 		ufshcd_mcq_make_queues_operational(hba);
 		ufshcd_mcq_config_mac(hba, hba->nutrs);
 		ufshcd_mcq_enable(hba);
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index dfbf78bd8664..73ab67448e87 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -14,6 +14,9 @@
 #define UFSHCD_MAX_Q_NR 8
 #define MTK_MCQ_INVALID_IRQ	0xFFFF
 
+#define UFSHCD_ENABLE_MTK_MCQ_INTRS	\
+				(UTP_TASK_REQ_COMPL | UFSHCD_ERROR_MASK)
+
 /* REG_UFS_MMIO_OPT_CTRL_0 160h */
 #define EHS_EN                  BIT(0)
 #define PFM_IMPV                BIT(1)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a6ed7aa59533..109cbb36c02d 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1496,5 +1496,6 @@ int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask,
 			     const u16 *other_mask, u16 set, u16 clr);
 void ufshcd_force_error_recovery(struct ufs_hba *hba);
 void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on);
+void ufshcd_enable_intr(struct ufs_hba *hba, u32 intrs);
 
 #endif /* End of Header */
-- 
2.45.2

