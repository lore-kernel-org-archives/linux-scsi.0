Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C0345C12
	for <linux-scsi@vger.kernel.org>; Fri,  1 Mar 2024 03:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709264781; cv=none; b=LgLaeP7D6opsPywDJARa93acz9pHRUgvk2JwYMin5wotONSK1Qeybb6ODlR0DqraoS2l1nS3QWAub526OF6+AbzvHag7EQ6hqT3KeA6rLNrcyDrcBUpCP9zvqz6gfOeLpJEtB9fSNI7n969pVMAaziU+Aq9jJPbNq0yxMM7tj+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709264781; c=relaxed/simple;
	bh=iNkJ1ntQQ70wiItkAxBObKNrMoTyaPJ5kZ0ruDm3EZs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SUNSKhFtm6AUWmMogS1537vP77eoW8B1Ur3i7UE+HqzkHvz9s5EIYUshib9qIo+1NHCqsDGk+PS1pM+t0cfleDV+eFkbsALAxmBLG6eVpNb2tymBe+3rSJaeoG00K4//g5JZbrr21SnAtQRczGvISL1jMsdRW4ks0G5+hrho76o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Qe4avecc; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Qe4avecc"
X-UUID: 401817f4d77e11ee935d6952f98a51a9-20240301
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=CPu3l9H69Jhri37bGWe8fRzSRrxBLsJfYK5gBNQ9uTM=;
	b=Qe4aveccJrr54NB/ZyXnk3+VPznCfYUrT5OEd6rMMTnSQ3iedT4n6kUcHIn4ATLIIV0iDX6fwR1NH5wk5urIsWKpnwX5urCjnGtvLgt2HVL2IgodQ28KJEkaUSO7LN9HL9G+eaZpL1HDcQQAHDjH1xNNbOL6wXwyfJdB8qIqeIk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:8cd52849-4c4f-4d0f-bcaa-c974b3de24be,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:6f543d0,CLOUDID:4c1ffb80-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 401817f4d77e11ee935d6952f98a51a9-20240301
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1577241430; Fri, 01 Mar 2024 11:46:13 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 1 Mar 2024 11:46:11 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 1 Mar 2024 11:46:11 +0800
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
Subject: [PATCH v3] ufs: core: add config_scsi_dev vops comment
Date: Fri, 1 Mar 2024 11:46:10 +0800
Message-ID: <20240301034610.24928-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--5.435400-8.000000
X-TMASE-MatchedRID: MACTyP4PrdMMQLXc2MGSbFz+axQLnAVBTJDl9FKHbrm7qpOHKudqc/mv
	83Rzid1phgjat2+RfEfdRIKCUEZlk49oUcx9VMLgFEUknJ/kEl5jFT88f69nG/oLR4+zsDTtjoc
	zmuoPCq1ze+i+Dlv5ABEG8YoH0A3pTlOaLF8YOD+mDC7RQmDzf6yO1uMZNQBO
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.435400-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 4542F3BD3F18A93542461E9E6F76A2ECD8F0E86ED94C860EEEA7DBD32B326C622000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

Add config_scsi_dev vops comment.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 include/ufs/ufshcd.h | 1 +
 1 file changed, 1 insertion(+)

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

