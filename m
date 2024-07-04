Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD357125C0;
	Thu,  4 Jul 2024 01:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720057331; cv=none; b=MC+yBHBkttzCvlDDP33VcsZOmUtr3mVbyZR55d/pOZQKxupi4EzFhnFRFyZvoH34Wf9+lYqyDdm7kJTK88de6EKX6Ki8EFwfS4yadgkdt1L0mA6lMOoUik4sAz/xPxPW7Q2v3XEdD60UfKcbYBxFWw5zkKv0/GZ636ZKO2YZAGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720057331; c=relaxed/simple;
	bh=L5pfeTx33tvZp5Q0108felt0l5qLiHIHw76vUpE3yg4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sqBzC4XxHi+/4V2XUgzjD+uLtDPi11C1xWXzzrbJBN1AatPbx9FLrsln4xAxbGwnJ+OXCaC6I1cDPD50uOiQaBfuY9CTdCrkbsYptp70bU9pPyNzmkzjYtPFHNX3Mb/gmO5Ufw1FO5Xysbr32K5haCTJoM5TO50kaPF6STyfFg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 9c362dfc39a611ef93f4611109254879-20240704
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:a5354cc7-1870-4ca8-8a7f-11539d1a9c97,IP:20,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:40
X-CID-INFO: VERSION:1.1.38,REQID:a5354cc7-1870-4ca8-8a7f-11539d1a9c97,IP:20,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:40
X-CID-META: VersionHash:82c5f88,CLOUDID:e83a72d1186fc2e033b0521bd59c2d3f,BulkI
	D:2407040858191VGC4GU1,BulkQuantity:1,Recheck:0,SF:19|45|66|38|25|17|102,T
	C:nil,Content:0,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,C
	OL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: 9c362dfc39a611ef93f4611109254879-20240704
X-User: mengfanhui@kylinos.cn
Received: from localhost.localdomain [(223.70.160.255)] by mailgw.kylinos.cn
	(envelope-from <mengfanhui@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 952528297; Thu, 04 Jul 2024 09:42:01 +0800
From: Fanhui Meng <mengfanhui@kylinos.cn>
To: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [scsi-next v2 0/2] scsi: add megasas_dcmd_timeout helper
Date: Thu,  4 Jul 2024 09:40:47 +0800
Message-Id: <cover.1720056514.git.mengfanhui@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set contains small cleanups for megaraid_sas. Patch 1 adds
a new helper megasas_dcmd_timeout() to reduce duplicate code. Patch 2
makes dcmd_timeout_ocr_possible() static.

Fanhui Meng (2):
  scsi: megaraid_sas: Add megasas_dcmd_timeout helper
  scsi: megaraid_sas: make dcmd_timeout_ocr_possible static

 drivers/scsi/megaraid/megaraid_sas.h      |   2 +
 drivers/scsi/megaraid/megaraid_sas_base.c | 203 ++++------------------
 2 files changed, 38 insertions(+), 167 deletions(-)

-- 
2.25.1

