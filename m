Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A686D1C693
	for <linux-scsi@vger.kernel.org>; Tue,  1 Oct 2024 09:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727774367; cv=none; b=cXe+Jtf62H5oWqQNpeG34Ym41ke/Vb8MdPPsymJy68d0hrTMCvwyUAz1iz9M4hHlZA5CSBX3r46j4ycqjs0s8RBpXEknFbI1sw2QJQXFTshRSaqDCTPU8+cwBbkdIuQj7MG8X+SeethouT4DSpG+tqrKWwazrSNNx2s9D4tLkTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727774367; c=relaxed/simple;
	bh=88U6u9XrsdO33FQp949OiPO6bJCiyAXgbWK7d80yB3A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qelBJpu7moTSv0QoHmzEUN3eEb64Hgn0gNtXpQdzlko6xfawipCfObd82tDrwNcEkmwG+kyydqeelzdxRr3KehjgwAZMjNd7Ix/nRwkLOBvgF0j+5SU2sJyvQT4J7ssl/gProrGXgIADBJyVpom6X570q1BGJxEppifPGRsvqd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=opjNCxTK; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="opjNCxTK"
X-UUID: 3d31e2127fd611ef8b96093e013ec31c-20241001
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Kw1ihwJTHHKc5mPxp99TPSiZEROPElBOqpLMJ7vzjvE=;
	b=opjNCxTKMyq8SRGMmQgb+w4x9aXDCM4CoTLCovWM5ijS3C2/oU9j5cgrR7RTKGWBOFoEpEPycnLRzMM1X9X8yAP+LuJkE3VGZbNrdFbxMUDSxg4edASwQ0SOoJKPUhWrn5AMNdDV+jqgvU0xrBmwhXA6yGJGz5HuobI0qB81pX0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:1869f013-6bf4-4e48-9f87-d44a0d704cde,IP:0,U
	RL:0,TC:0,Content:-20,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-20
X-CID-META: VersionHash:6dc6a47,CLOUDID:9a660cd1-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:1,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 3d31e2127fd611ef8b96093e013ec31c-20241001
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 342216660; Tue, 01 Oct 2024 17:19:19 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 1 Oct 2024 02:19:18 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 1 Oct 2024 17:19:18 +0800
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
Subject: [PATCH v10 0/2] fix abort defect
Date: Tue, 1 Oct 2024 17:19:15 +0800
Message-ID: <20241001091917.6917-1-peter.wang@mediatek.com>
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

V10:
 - Requeue OCS: ABORTED request in MCQ mode.

V9:
 - Revise the OCS content printed.
 
V8:
 - Remove the abort variable to simplify the abort process.
 - Correct error handler successfully aborts release flow.
 - Ingore MCQ OCS: ABORTED.

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

Peter Wang (2):
  ufs: core: fix the issue of ICU failure
  ufs: core: requeue aborted request

 drivers/ufs/core/ufs-mcq.c | 15 ++++++++-------
 drivers/ufs/core/ufshcd.c  | 20 ++++----------------
 2 files changed, 12 insertions(+), 23 deletions(-)

-- 
2.45.2

