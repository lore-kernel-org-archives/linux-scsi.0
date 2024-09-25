Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B941158557
	for <linux-scsi@vger.kernel.org>; Wed, 25 Sep 2024 10:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727259116; cv=none; b=hGUsqi7BLwugsBsBK6pr457Jiz/BTlyQW/0x4583BSLiJoY7KNK7jxFA/oq4nmFdt2cBT0iEVTQyoxuezj8pFbt5icEnAvtqX6iEed+tJtfZwWxh1FnquJAxRrgOA2tAdnlkJJ8hvbEr7JR8I9ORCEPXUCY2khvW3vie3Uc05vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727259116; c=relaxed/simple;
	bh=r/RV4UnHc00RAjYST219l65rHHa73dtVnSJqzdbG384=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XeC/TyGM+P5AERYtx6K9hrq4wSKWU41Fv2vCkD12IqRBWcCK4fWHI/n1qFVRoRD0UHKUsexJ5+S93HgP8O2o4g5B8hPhibPTmM3vG1OrZHlnCCxxWrVQeutVPhZWwfbce3zDrYL3FMTEz/tSwF2iL4DNvu8Ak6wO2O709/Sp6zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=OsPooZXr; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="OsPooZXr"
X-UUID: 937ecea07b2611efb66947d174671e26-20240925
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=yJkRtRRNHcKSL8pTC/uoggd7XBAV+ua7KNG4SIwtsGc=;
	b=OsPooZXrY7F6feX4PEe45mesWrueYa+L4xll7S1d+xnjsnpSvWI0N6mTm+VtKN4xrLe+pTTUzOwRlBtK/ly849hnI9DE7JhT6T6OFG620xvZahZjRiuwNLdq/HRjjJCFqTAdDCXIJ6ZGdIO/jcNFtAAqx+ZiSVrSmY1ykvwXJAs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:d9ec9e07-4f90-4caa-a26e-2772d8199a76,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:6ce68a9e-8e9a-4ac1-b510-390a86b53c0a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 937ecea07b2611efb66947d174671e26-20240925
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1270620905; Wed, 25 Sep 2024 18:11:48 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 25 Sep 2024 03:11:47 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 25 Sep 2024 18:11:47 +0800
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
Subject: [PATCH v9 0/3] fix abort defect
Date: Wed, 25 Sep 2024 17:55:43 +0800
Message-ID: <20240925095546.19492-1-peter.wang@mediatek.com>
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

Peter Wang (3):
  ufs: core: fix the issue of ICU failure
  ufs: core: fix error handler process for MCQ abort
  ufs: core: add a quirk for MediaTek SDB mode aborted

 drivers/ufs/core/ufs-mcq.c      | 15 ++++++++-------
 drivers/ufs/core/ufshcd.c       | 28 ++++++++++++++++++++++++++--
 drivers/ufs/host/ufs-mediatek.c |  1 +
 include/ufs/ufshcd.h            |  6 ++++++
 4 files changed, 41 insertions(+), 9 deletions(-)

-- 
2.45.2

