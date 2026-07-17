Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E804429CDB;
	Fri, 17 Jul 2026 15:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784301418; cv=none; b=YJ8YZN+EXPUct2p8FzDgAWxc6+i8AjI/1tFjLESTx8RHh8cLdG8JsPB3bW52JL7DmPeMFGcq0h2l1fZremQgLmk0FM/NDUYxTkG0roRoG//0xDyOvFtRb9/uGrLWpB8CcCvEqWQtlQdKFUG5l1cxqolDkeKQK+KwQchtZqLsLBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784301418; c=relaxed/simple;
	bh=bjj0qshVbtKxe2VGxR5IWTQhFhq8tHGLLfwt55BYYBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCaVpNSwt496ZMHM4HtNyWYy7Q7vxqKtNvCIgx+H6eHH4K8+mCa1YCWcUPr4jpnoofCvqwc79ZOFm7Af8dt3KBnFOc9fCH3r1NigBuzbLyi6+69bmqnMy6yp3X+zQOzmUMItXP82Qlcs9k2K//fQcmLygWXH8rGdoDodWQVR17g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 8878e83681f211f1aa26b74ffac11d73-20260717
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:49176059-9fac-46bf-90f1-bed352749b04,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.12,REQID:49176059-9fac-46bf-90f1-bed352749b04,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:e7bac3a,CLOUDID:e208bff8e74987d628390183d98f13c2,BulkI
	D:260717014305Z231SO2Z,BulkQuantity:3,Recheck:0,SF:10|66|78|81|82|83|102|1
	27|865|898|908|914,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,B
	RR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8878e83681f211f1aa26b74ffac11d73-20260717
X-User: liqiang01@kylinos.cn
Received: from cvdaxia.localdomain [(36.148.177.170)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1497199571; Fri, 17 Jul 2026 23:16:49 +0800
From: Li Qiang <liqiang01@kylinos.cn>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	beanhuo@micron.com,
	can.guo@oss.qualcomm.com,
	adrian.hunter@intel.com,
	tomas.winkler@intel.com
Subject: Re: [PATCH 0/5] scsi: ufs: Fix descriptor parsing and invalid input handling
Date: Fri, 17 Jul 2026 23:16:46 +0800
Message-ID: <20260717151646.10555-1-liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <f7367a69-ae99-4916-a6c7-93ac19c3863d@acm.org>
References: <cover.1784182493.git.liqiang01@kylinos.cn> <f7367a69-ae99-4916-a6c7-93ac19c3863d@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Bart,

These issues were discovered with the assistance of an AI-based static code analysis tool. After manual review, I confirmed that they are real issues, so I submitted patches to fix them.

I have not tested them on physical hardware. Since these patches do not change the main functionality and only add security hardening, I think compile testing is sufficient.

Thanks,
Li Qiang
