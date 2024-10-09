Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB41B1547DE;
	Wed,  9 Oct 2024 05:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728452376; cv=none; b=ScVw6l8AtJdNEwRX+ZYHMD8B+lOplQ091BYSkZ9lTehTbr2x9zj5+d0CJ1Th/wkjFA3+vB3xdqgZqX06sFqSVKavUAixynxs4tGr2E1gB/nesugHgr7vC3rIBsjHMj4NbsMD7lILfCJ1yDystkuZq+iW/0hFseohg9Y1HEtaCdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728452376; c=relaxed/simple;
	bh=+CLsbmfZs/12mfP7CeP+jAK+LtDxN/YXFdeTn8cwWi4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PxaDAagY02+4k1k4+N8qXPJsgC+iMjEBLSfN9rgh7xW2pgkOoscLIITEgpife+922IeoAQfnABCbir8Tq9QPqNTewKBNqNXBdPnU9TpfSfC8t3Up+tT/jpfdIC4HxvyXCpQij7n3EtfcYgPmt1PM09T56XGNT8cZtpFT6gZxtxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=T6ODwcsS; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="T6ODwcsS"
X-UUID: d544b1a8860011ef88ecadb115cee93b-20241009
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=I3QlM+wHwYxdZQsYINnxa9RWbc46mBL74mYp99QPueo=;
	b=T6ODwcsSUZKhBSZE2QScEcqJAmAasR9rh1cZYk74EIJfVMK70TMceXkJURI/48+8LXk/n3N3e7hECuMfR7RjNE325x48yHeOfTJY++OSny8jRqpFT3PhSV7KsmlriZhiutTASf1Kotg29FUER3cDluWTj0jnbkZy+4tBJ7T/t9M=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:6a5e692d-b50a-4c3f-b2e6-11bc4d97459f,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6dc6a47,CLOUDID:28f3f864-444a-4b47-a99a-591ade3b04b2,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: d544b1a8860011ef88ecadb115cee93b-20241009
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <ed.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 263593157; Wed, 09 Oct 2024 13:39:20 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 8 Oct 2024 22:39:19 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 9 Oct 2024 13:39:19 +0800
From: <ed.tsai@mediatek.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>, Stanley
 Jhu <chu.stanley@gmail.com>, Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
CC: <wsd_upstream@mediatek.com>, <chun-hung.wu@mediatek.com>, Ed Tsai
	<ed.tsai@mediatek.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2] scsi: ufs: ufs-mediatek: configure individual LU queue flags
Date: Wed, 9 Oct 2024 13:38:47 +0800
Message-ID: <20241009053854.15353-1-ed.tsai@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N

From: Ed Tsai <ed.tsai@mediatek.com>

Previously, ufs vops config_scsi_dev was removed because there were no
users. ufs-mediatek needs it to configure the queue flags for each LU
individually. Therefore, bring it back and customize the queue flag as
we required.

In addition, because the SCSI probe_type = PROBE_PREFFER_ASYNCHRONOUS,
sd_probe() is completed by another thread, causing the sd index to be
obtained asynchronously. Directly setting the queue through sysfs is
cumbersome. We do not need to change the queue settings at runtime, so
a simpler and more intuitive approach is to set its flag once the SCSI
device is confirmed to be ready.

Signed-off-by: Ed Tsai <ed.tsai@mediatek.com>
---
 drivers/ufs/core/ufshcd.c       |  3 +++
 drivers/ufs/host/ufs-mediatek.c | 10 ++++++++++
 include/ufs/ufshcd.h            |  1 +
 3 files changed, 14 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7cab103112e1..be50b86269bf 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5253,6 +5253,9 @@ static int ufshcd_device_configure(struct scsi_device *sdev,
 	 */
 	sdev->silence_suspend = 1;
 
+	if (hba->vops && hba->vops->config_scsi_dev)
+		hba->vops->config_scsi_dev(sdev);
+
 	ufshcd_crypto_register(hba, q);
 
 	return 0;
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 9a5919434c4e..0b57623edca5 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1780,6 +1780,15 @@ static int ufs_mtk_config_esi(struct ufs_hba *hba)
 	return ufs_mtk_config_mcq(hba, true);
 }
 
+static void ufs_mtk_config_scsi_dev(struct scsi_device *sdev)
+{
+	struct ufs_hba *hba = shost_priv(sdev->host);
+
+	dev_dbg(hba->dev, "lu %llu scsi device configured", sdev->lun);
+	if (sdev->lun == 2)
+		blk_queue_flag_set(QUEUE_FLAG_SAME_FORCE, sdev->request_queue);
+}
+
 /*
  * struct ufs_hba_mtk_vops - UFS MTK specific variant operations
  *
@@ -1809,6 +1818,7 @@ static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 	.op_runtime_config   = ufs_mtk_op_runtime_config,
 	.mcq_config_resource = ufs_mtk_mcq_config_resource,
 	.config_esi          = ufs_mtk_config_esi,
+	.config_scsi_dev     = ufs_mtk_config_scsi_dev,
 };
 
 /**
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a95282b9f743..800d79dc91fc 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -383,6 +383,7 @@ struct ufs_hba_variant_ops {
 	int	(*get_outstanding_cqs)(struct ufs_hba *hba,
 				       unsigned long *ocqs);
 	int	(*config_esi)(struct ufs_hba *hba);
+	void	(*config_scsi_dev)(struct scsi_device *sdev);
 };
 
 /* clock gating state  */
-- 
2.45.2

