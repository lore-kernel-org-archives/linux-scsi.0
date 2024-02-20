Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF6A60861
	for <linux-scsi@vger.kernel.org>; Tue, 20 Feb 2024 09:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708422143; cv=none; b=dL8UpTjv8emV8B7BZMk8eqy0CXRs+0mPtGvWaaBR6ouyRwkqvCx7tLzlOOWHqTtDJUme1C6uzSTxu0M8gVencnmEMboiREAhE/uIPByM3V0Ml0q57el5m2rsn01RhiR36jbgQXrygOVBxhiVEfVnPdy4z5lu2a/F2MQXs+5SkEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708422143; c=relaxed/simple;
	bh=n5nMw0uNOcu1gaEksdvjsUjGVTNxaEEqPIuwowM8yNs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oPdBY29wncsYUomGjZybrU3BCE8IjpCgZIZt0UulKjpKy/jXhP0zG5E5WYpP/EQ2zrznZyXQmFhdPcEPbyFCeom2BQigzxPsVOeLToBZhNxFnk8SjlFEZu3gZFrNPfk7F+W0QHEbRW4Akr/+/2UjYv31xsWIeTYe2Do/h/eVR6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=fnv28pBB; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fnv28pBB"
X-UUID: 5431994ccfd411ee9e680517dc993faa-20240220
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Rr34nSYkfVYWl9vNR82EflNeNhAQmo3RiI09pkVtZqg=;
	b=fnv28pBBy/S1UXqVYovP3L+9Nng4NRUzLHCoKXDa1qMIn0smurp2f2SL1MM0z2we39A158Zh3XJz193eZ3kqMfMZTYLhWFrCZAMHUmiIDBTdshmBU8tyKHL8lQepElACwTxL/1L/5qSdBmv2ipwv6LHoczxnCclvXwlO6gP7bXQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:b5f8f23d-5f58-4712-af54-47b2a8ec437b,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6f543d0,CLOUDID:a48a1984-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 5431994ccfd411ee9e680517dc993faa-20240220
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 368156708; Tue, 20 Feb 2024 17:42:14 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 20 Feb 2024 17:42:12 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 20 Feb 2024 17:42:12 +0800
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
Subject: [PATCH v1] ufs: core: adjust config_scsi_dev usage
Date: Tue, 20 Feb 2024 17:42:11 +0800
Message-ID: <20240220094211.20678-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--6.178500-8.000000
X-TMASE-MatchedRID: n/G9Jfep/EYMQLXc2MGSbKTfLKfi4+0tuLwbhNl9B5Us/uUAk6xP7PlY
	oV6p/cSxwX0f1lPumDj1yfaRXbFRICnBjLyZTfQTNCWPXerN72lMQULTNXtspEdmDSBYfnJR5gc
	Q9o9yjpv1vHe0RNYkzJcZ0icLp7DqHxPMjOKY7A8LbigRnpKlKSPzRlrdFGDwHjhYSa0rs6iGR2
	xllP65/tmk23bNIjzMi6H1+hjNWVVt6nh0ne7HIQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.178500-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 2BCA890089EEFB661030E6316E3C738722300088576542079DF0C79E4F013EB42000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

Adjust the usage of config_scis_dev to mach the existing usage of
other vops in ufs driver.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd-priv.h | 7 +++++++
 drivers/ufs/core/ufshcd.c      | 3 +--
 include/ufs/ufshcd.h           | 1 +
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index f42d99ce5bf1..72d5287c15ee 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -288,6 +288,13 @@ static inline int ufshcd_mcq_vops_config_esi(struct ufs_hba *hba)
 	return -EOPNOTSUPP;
 }
 
+static inline void ufshcd_vops_config_scsi_dev(struct ufs_hba *hba,
+					       struct scsi_device *sdev)
+{
+	if (hba->vops && hba->vops->config_scsi_dev)
+		hba->vops->config_scsi_dev(sdev);
+}
+
 extern const struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /**
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 16d76325039a..92f9de1d3152 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5211,8 +5211,7 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	 */
 	sdev->silence_suspend = 1;
 
-	if (hba->vops && hba->vops->config_scsi_dev)
-		hba->vops->config_scsi_dev(sdev);
+	ufshcd_vops_config_scsi_dev(hba, sdev);
 
 	ufshcd_crypto_register(hba, q);
 
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 7f0b2c5599cd..a19d87e7980f 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -327,6 +327,7 @@ struct ufs_pwr_mode_info {
  * @op_runtime_config: called to config Operation and runtime regs Pointers
  * @get_outstanding_cqs: called to get outstanding completion queues
  * @config_esi: called to config Event Specific Interrupt
+ * @config_scsi_dev: called to configure scsi device parameters
  */
 struct ufs_hba_variant_ops {
 	const char *name;
-- 
2.18.0

