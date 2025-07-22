Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0078C28BA85
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 03:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153742; cv=none; b=m50L66dfGjuS/uc3JlPiBVYjLVdIrQ21bMQFSPfisfHmPbDL6rCYe3UinHPysJtMVIXTFGbTzb/8cjpsyh2kP6sacrNFBt9ncKDad/02cS1YaiQ1KpwQnN7yxatYDu4yH7oKL6TOPSG2JWldyrVBzrueFTsmhP+g92n4OKnD65g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153742; c=relaxed/simple;
	bh=KuB8e6RuBqOzgQHtU8VfwF/UppX3XIa5iPkuD9bf2UI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SBKMRU0KEg/z/3eHyWv0KQjs5UYtNctXftyy9hyx0HOQ1J1kLx3YosuhYSuy7w7X4eGXZwmzlzcrKdYOTB1EW4gPa9DZqq0jlRpA5WWLC/8g6Jj+vomYU9xdFGqnx6wWzDhgP+5NxWqHLmV3iW/Deral4uzl0ay39wKSED/HmvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=tnoUH8KA; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="tnoUH8KA"
X-UUID: 2e9abf2066a911f0b33aeb1e7f16c2b6-20250722
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=dGAd9mDWgr0U8jFeJ1AUn+N6lYisgXVmxCe25k485qs=;
	b=tnoUH8KAmzl+3uC2RlnanuS0rhx4kueklcovQxUdk3prob0zZscxtAGvb8RrlBbB3h8NgmGHVGy6XpwZzL1bf3+XCL+LeFJfHAsCzXY0Ni5SQNl48+KsQTPn7r3wn8VQp1ebYdgYEHPCP0SS0KT8ac/+dTyemR6xQbYf4URnEKI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:9ec7f58f-82e2-4d51-a601-8032edd50f32,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:6dce1b50-93b9-417a-b51d-915a29f1620f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2e9abf2066a911f0b33aeb1e7f16c2b6-20250722
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 94970658; Tue, 22 Jul 2025 11:08:46 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 22 Jul 2025 11:08:42 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 22 Jul 2025 11:08:42 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v4 2/9] ufs: host: mediatek: Add DDR_EN setting
Date: Tue, 22 Jul 2025 11:07:17 +0800
Message-ID: <20250722030841.1998783-3-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250722030841.1998783-1-peter.wang@mediatek.com>
References: <20250722030841.1998783-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Naomi Chu <naomi.chu@mediatek.com>

On MT6989 and later platforms, control of DDR_EN has been switched from
SPM to EMI. To prevent abnormal access to DRAM, it is necessary to wait
for 'ddren_ack' or assert 'ddren_urgent' after sending 'ddren_req'.

This patch introduces the DDR_EN configuration in the UFS initialization
flow, utilizing the assertion of 'ddren_urgent' to maintain performance.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Naomi Chu <naomi.chu@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Chun-Hung Wu <chun-hung.wu@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c |  7 +++++++
 drivers/ufs/host/ufs-mediatek.h | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 744efcde1fff..90351fff501c 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -267,6 +267,13 @@ static int ufs_mtk_hce_enable_notify(struct ufs_hba *hba,
 		ufshcd_writel(hba,
 			      ufshcd_readl(hba, REG_UFS_XOUFS_CTRL) | 0x80,
 			      REG_UFS_XOUFS_CTRL);
+
+		/* DDR_EN setting */
+		if (host->ip_ver >= IP_VER_MT6989) {
+			ufshcd_rmwl(hba, UFS_MASK(0x7FFF, 8),
+				0x453000, REG_UFS_MMIO_OPT_CTRL_0);
+		}
+
 	}
 
 	return 0;
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 05d76a6bd772..1082f761bb44 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -192,4 +192,16 @@ struct ufs_mtk_host {
 /* MTK RTT support number */
 #define MTK_MAX_NUM_RTT 2
 
+/* UFSHCI MTK ip version value */
+enum {
+	/* UFSHCI 3.1 */
+	IP_VER_MT6878    = 0x10420200,
+
+	/* UFSHCI 4.0 */
+	IP_VER_MT6897    = 0x10440000,
+	IP_VER_MT6989    = 0x10450000,
+
+	IP_VER_NONE      = 0xFFFFFFFF
+};
+
 #endif /* !_UFS_MEDIATEK_H */
-- 
2.45.2

