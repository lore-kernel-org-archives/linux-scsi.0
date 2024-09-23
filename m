Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A34328B6
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2024 08:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727078634; cv=none; b=nQ6jlMM36N/tnD5F3tjd2tEebv2fD0CFcrW0X/pddmNILBHGn8cksUggBesaATALAX/G7ry7BVKc6v+XgEsxF5qbS3BKmbJ080beuX2a0WA/hQCYuFWbAJ7T5b2Ihu6nInuyFucaJQbvpAN7T9a/4fjLIz2Xqefd4U7p3A7lAWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727078634; c=relaxed/simple;
	bh=QP01vQg9GzDUXmw3MucYRZCGFkdJUtJFp+EeZ3q1Jks=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qgRlb8j4IMOHr9Cy2FqdbsbSQVhLMwNxYrUceCrnCQhIsYlt5wuDsFnBT+HFXh4om1IlqLh93V08mb+/A7W0Vz0Zn57QEaWllV4ON0pb+M0w05dbl35xZmyLKrBX8LkyCPr5zjwH/zdoxFOFQjB5KwqmlKOfXiqlAr77EhQd6XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=idoHr4XZ; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="idoHr4XZ"
X-UUID: 5c068152798211ef8b96093e013ec31c-20240923
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=TTktZ6zh7dUMwYiHLZ3lOy4Zva+vrBP4sje0RFE/uJI=;
	b=idoHr4XZQi+z/7/haNp7c+rN1TrPCQOY0sxeuw3gXDTX/+OIEjQov/rnYBU3/miRbQ/eepGHXT8SOjyyniyF4HM5BNOkgxmDYUVWMyswMcZV+sSew4Hd+HaNZ+5f7eXdaLv/MQDmGIchm5tOpulMeKlmsx78AgZhdTlIDR+3dqE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:93e44856-8c6e-45ae-aea6-afda2c9818fa,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:e4639dd0-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 5c068152798211ef8b96093e013ec31c-20240923
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 570675682; Mon, 23 Sep 2024 16:03:46 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 23 Sep 2024 16:03:45 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 23 Sep 2024 16:03:45 +0800
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
Subject: [PATCH v8 0/3] fix abort defect
Date: Mon, 23 Sep 2024 16:03:41 +0800
Message-ID: <20240923080344.19084-1-peter.wang@mediatek.com>
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

