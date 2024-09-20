Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCC6135A69
	for <linux-scsi@vger.kernel.org>; Fri, 20 Sep 2024 09:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726823213; cv=none; b=ucxmDlDcujfEPoUhAGSkX0oqCAVB9UwbcaiVcM8efsr9RrgmO8BfW4jZ8gwG6LhhD33xK5AGHj2ePyjQPYzDKanNiqeJjMPg7rhruUL7JtDaFC4yaOua9zeINtxEHCj4bhKiEtoUAca1zdbTj/ubPgOFVdxTxOxU7s2MAExMxkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726823213; c=relaxed/simple;
	bh=c5kxyNMWXdkI8h6HrT4xCeVDrYlKoovah9fUmHCAPhI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=F4oMpXb5IBYnnM85PmS71wVOwz7vv57YnmJ1AEZ+j8TnkHDpVdVrB88DXth+/u5ZbFbH7kTpEmMPVdOhgdrz+tl96YA4s2dmBSV6/GWGC/cjPFBais26UNyyom6WfIFaMXErPNaLldGd+mbauVKVQ0LVhW6KFgsrOcQl+6gJaAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=By16Ey9m; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="By16Ey9m"
X-UUID: a92905f4772f11ef8b96093e013ec31c-20240920
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=zwo4xBU6lj3FjG+IfMoGyS13z9c2D1Xz4JKX3Twas+Y=;
	b=By16Ey9m2O/BJy6VmFZjyGdrNHGkz7+z3+zU/r5tDnNryP18OdvTtztV7nGlMA4OtrisHks3o7mGSZj8dv4iTOPrBR+zn0w6quuWwGd9HRebCv6covAXWY5hanQsd4dSjD0Bx8mkIRUhXXUvKyCuuS22LLIKcEvFiFgAlO5RNIk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:63e91656-4958-4d53-a6d0-ca2cbe0db3fc,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:509bfc17-b42d-49a6-94d2-a75fa0df01d2,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: a92905f4772f11ef8b96093e013ec31c-20240920
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2014424320; Fri, 20 Sep 2024 17:06:45 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 20 Sep 2024 02:06:44 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 20 Sep 2024 17:06:44 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<powen.kao@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>,
	<quic_nguyenb@quicinc.com>
Subject: [PATCH v7 0/4] fix abort defect
Date: Fri, 20 Sep 2024 17:06:39 +0800
Message-ID: <20240920090643.3566-1-peter.wang@mediatek.com>
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

This series fixes MCQ and SDB abort defect.

V7:
 - Use a variable instead of a flag.
 - Add a check for MCQ mode when setting this variable to UFS_ERR_HANDLER.
 - Print OCS information for OCS_ABORTED and OCS_INVALID_COMMAND_STATUS.
 - Add a MediaTek quirk for handling OCS_ABORTED in SDB mode.
 - Skip notifying SCSI from ISR during SCSI abort (ufshcd_abort()).

V6:
 - Add err handler check before set flag true.

V5:
 - Change flag name.
 - Amend comment and patch description.

V4:
 - Remove nullify SQ entry abort requeue.
 - Add more comment for flag usage and set description.
 - Fix build warning.

V3:
 - Change comment and use variable(rtc) for error print
 - Change flag name and move flag set before ufshcd_clear_cmd
 - Add SDB mode clear UTRLCLR tag receive OCS_ABORTED requeue

V2:
 - Fix mcq_enabled build error.

Peter Wang (4):
  ufs: core: fix the issue of ICU failure
  ufs: core: requeue aborted request
  ufs: core: add a quirk for MediaTek SDB mode aborted
  ufs: core: skip ISR notifying scsi when ufshcd_abort

 drivers/ufs/core/ufs-mcq.c      | 21 ++++++----
 drivers/ufs/core/ufshcd.c       | 68 +++++++++++++++++++++++++--------
 drivers/ufs/host/ufs-mediatek.c |  1 +
 include/ufs/ufshcd.h            | 15 ++++++++
 4 files changed, 83 insertions(+), 22 deletions(-)

-- 
2.45.2

