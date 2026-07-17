Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B222282F3F;
	Fri, 17 Jul 2026 15:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302610; cv=none; b=DqXc5XSlri67ndiwE6uukIUsFezOSvyyeYaRN7nbIW9l+TURWEjoYHK9LPna8OkqL+0AJQgrApv7DU0hLsgEfjJLyHfK5P4GIXpLkA06ZQ5KFimg2UoStJ55UZ5ADG2InAsMtKgTiH5b1/iZmYoxqo0ck9MerzpJ+gNZeGm3m9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302610; c=relaxed/simple;
	bh=NlIGeXMK2BUPyCdvDkfjkR/VAgN3Mbz/+yY4xrROvwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijGxGd/PCkSDh6iGmVCZMnrRApAE/JMTddBra8vv6kSAkalFKuxwPZ+tRGumPC5S6FgvXoR/coBpFzTcfNx7Zfm/D4U1ydpRfYJq3trFGrug2OK3FBaCea0iHOhgA9YsYHodHmclvexx0O+PWTuL7GVElOiz1ZD/iwxkkpOITus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 2917672081f511f1aa26b74ffac11d73-20260717
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:4124ef21-8a6c-4d0e-b9a2-585a5a0cbb8d,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.12,REQID:4124ef21-8a6c-4d0e-b9a2-585a5a0cbb8d,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:e7bac3a,CLOUDID:0b4192f2d89f884797c73edff7f44ca8,BulkI
	D:2607172336413SD2FRFL,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|83|102|1
	27|865|898|908|914,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:ni
	l,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,
	BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2917672081f511f1aa26b74ffac11d73-20260717
X-User: liqiang01@kylinos.cn
Received: from cvdaxia.localdomain [(36.148.177.170)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 251882985; Fri, 17 Jul 2026 23:35:38 +0800
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
Subject: Re: [PATCH 1/5] scsi: ufs: core: Validate string descriptors
Date: Fri, 17 Jul 2026 23:35:34 +0800
Message-ID: <20260717153534.25197-1-liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <3e7ab1d2-4a38-4bb9-860d-17eb0ac65cc7@acm.org>
References: <c68b23bd15e3ff570e95afb5422bc242efd038df.1784182493.git.liqiang01@kylinos.cn> <3e7ab1d2-4a38-4bb9-860d-17eb0ac65cc7@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Bart,

I don't think kasprintf() is suitable here. This path must preserve the raw UTF-16 bytes and return a buffer of uc_str->len bytes for the RPMB device-ID ABI; %.*s treats the data as a C string and would not preserve embedded NUL bytes or the required two-byte padding.

Thanks,
Li Qiang
