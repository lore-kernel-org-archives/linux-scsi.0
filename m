Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98CF2309AC;
	Fri, 22 Nov 2024 02:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732243796; cv=none; b=rCjv2kAaV5wrMRgDrU/5rMmTrVL3UzhrUH85staXjr5xaZfRcmUDyWvLRYpwTFm0C+qPfzC0+yusotjek+97C/Hx25JlLQ/c7tvZvc0AbRQlcJOPqqVsv7DdBea2xjK6wOx2AJxa7WXUoFohcTR6i/wLjUU+eRSuo/rreWUF17A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732243796; c=relaxed/simple;
	bh=cdzMsiV/tKEiouLnKT23Dq0aYQyt65BCw77t6GUW2zg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FWujzbPiWLlsJmYyVVouuJThJ4+iLBy+QqAZeLZp5NUICpIPrf62Ea61JqZXWrRAebC3JkJ7c3En98JFqXotAw0O+BK5Vxp9gA3Qu+7y++8DFJOdJZKlzIdLe0eKZ1ffjlnD1n5K1ydQbPM+x+d+ysxzDNEo2DAshwbvlX8LM10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=DZJyjhwE; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DZJyjhwE"
X-UUID: 6f15d666a87c11ef99858b75a2457dd9-20241122
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=yR4nQ8FcC5S0oePaY8aJ51ztZct7g8GnoM20tznO0Mw=;
	b=DZJyjhwEtmiOo/jZz6dJyo3rKGz+kR0DJl3DWuqyHHiXx4aXdRBd1lJbIZwf0BoEC+0KA9PvrSvh7MdqZAuj59GLJSA39V+t38t58YlMrMQQ1VHT3CYHZ45v5WxiWJnFJoLLMqYoUCtge4uB+ec2qWf5o43dkBEj73C60NBTXtM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.44,REQID:fe1d30fe-9d07-42d2-90a4-3948f9601e03,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:464815b,CLOUDID:8691e4fe-58af-4a77-b036-41f515d81476,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 6f15d666a87c11ef99858b75a2457dd9-20241122
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1866262619; Fri, 22 Nov 2024 10:49:46 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 22 Nov 2024 10:49:45 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 22 Nov 2024 10:49:45 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>,
	<draviv@codeaurora.org>, <stable@vger.kernel.org>
Subject: [PATCH v2] ufs: core: add missing post notify for power mode change
Date: Fri, 22 Nov 2024 10:49:43 +0800
Message-ID: <20241122024943.30589-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

When the power mode change is successful but the power mode
hasn't actually changed, the post notification was missed.
Similar to the approach with hibernate/clock scale/hce enable,
having pre/post notifications in the same function will
make it easier to maintain.

Additionally, supplement the description of power parameters
for the pwr_change_notify callback.

Fixes: 7eb584db73be ("ufs: refactor configuring power mode")
Cc: stable@vger.kernel.org #6.11.x
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c |  7 ++++---
 include/ufs/ufshcd.h      | 10 ++++++----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index abbe7135a977..814402e93a1e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4651,9 +4651,6 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 		dev_err(hba->dev,
 			"%s: power mode change failed %d\n", __func__, ret);
 	} else {
-		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, NULL,
-								pwr_mode);
-
 		memcpy(&hba->pwr_info, pwr_mode,
 			sizeof(struct ufs_pa_layer_attr));
 	}
@@ -4682,6 +4679,10 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 
 	ret = ufshcd_change_power_mode(hba, &final_params);
 
+	if (!ret)
+		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, NULL,
+					&final_params);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 3f68ae3e4330..1db754b4a4d6 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -308,7 +308,9 @@ struct ufs_pwr_mode_info {
  *                       to allow variant specific Uni-Pro initialization.
  * @pwr_change_notify: called before and after a power mode change
  *			is carried out to allow vendor spesific capabilities
- *			to be set.
+ *			to be set. PRE_CHANGE can modify final_params based
+ *			on desired_pwr_mode, but POST_CHANGE must not alter
+ *			the final_params parameter
  * @setup_xfer_req: called before any transfer request is issued
  *                  to set some things
  * @setup_task_mgmt: called before any task management request is issued
@@ -350,9 +352,9 @@ struct ufs_hba_variant_ops {
 	int	(*link_startup_notify)(struct ufs_hba *,
 				       enum ufs_notify_change_status);
 	int	(*pwr_change_notify)(struct ufs_hba *,
-					enum ufs_notify_change_status status,
-					struct ufs_pa_layer_attr *,
-					struct ufs_pa_layer_attr *);
+				enum ufs_notify_change_status status,
+				struct ufs_pa_layer_attr *desired_pwr_mode,
+				struct ufs_pa_layer_attr *final_params);
 	void	(*setup_xfer_req)(struct ufs_hba *hba, int tag,
 				  bool is_scsi_cmd);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
-- 
2.18.0

