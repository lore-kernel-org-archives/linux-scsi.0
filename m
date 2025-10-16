Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2963720F067
	for <linux-scsi@vger.kernel.org>; Thu, 16 Oct 2025 02:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760582121; cv=none; b=UM/GdDogXDomovHmBVHZkX1z/EERgw6AXkl7hvb3oRAKVDApXoRDfw8f78bHhnKuZhE6hFkYgaINhLWELKvJVFQs0VCiFoIVzPXajxep/MHWCrNnQWtppn4p3PjsOL1UfNP7cPryej4zebm7TOhLLm9YseIZ2KC0PxC9+LncJkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760582121; c=relaxed/simple;
	bh=7vGS3o4leZmbydWypsnv/F6HFSmk8ZZppNJw6gMhix0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LvQqFuBjPAWNw3gzHZg7zqWqpze0bSNUhoYaIrcVp0Cc0urNyikAEnuhAKtLN+VksvfGYrwxjPIIg2VLTyFYKVreiVBEA+OHXqVdYgCL0YyLz4yO0/GCZ8cQsgFA5a2H11vAj4slTj/PvH7o/EWxAkh7n+TU42kCNFA4sU1LRb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=uhmFzUP+; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="uhmFzUP+"
X-UUID: bd3d70e2aa3811f0b33aeb1e7f16c2b6-20251016
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=FpQ1sqYlcYyeJd1gub7sZa/OhHsSH5Mep2/th2vBbmo=;
	b=uhmFzUP+YOD2t+l8BEpG0ZiMvN3FrlBRRRZtElGTSbS0q1hjQFZlnqsxDUXN/LiCbpJQo3J+NbR55gYvetqk1/6N7RknEBl6avdWGREpw9d50ARIEgU/EPbSEoERHyWiBXSM+njsdURBeE2aVZlQf6ZxM38RzVzo1jwc3Ot+DRQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:6892d75c-29a6-4dc1-a25e-5b91d987e4df,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:7a111c51-c509-4cf3-8dc0-fcdaad49a6d3,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|836|888|898,TC:-5,Content:0|15|5
	0,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bd3d70e2aa3811f0b33aeb1e7f16c2b6-20251016
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1327098622; Thu, 16 Oct 2025 10:35:11 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Thu, 16 Oct 2025 10:35:08 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Thu, 16 Oct 2025 10:35:08 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<qilin.tan@mediatek.com>, <lin.gui@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v2 0/2] update CQ entry and dump CQE in MCQ mode
Date: Thu, 16 Oct 2025 10:32:30 +0800
Message-ID: <20251016023507.1000664-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

Update the CQ entry format for UFS 4.1 compatibility and
add support for logging CQ entries in MCQ mode, enhancing
debugging capabilities.

Changes since v1:
1. Add big-endian support for cq_entry.
2. Move CQE dumping outside of the dump function.

Peter Wang (2):
  ufs: core: update CQ Entry to UFS 4.1 format
  ufs: core: support dumping CQ entry in MCQ Mode

 drivers/ufs/core/ufshcd.c |  9 ++++++---
 include/ufs/ufshci.h      | 22 +++++++++++++++++++---
 2 files changed, 25 insertions(+), 6 deletions(-)

-- 
2.45.2

