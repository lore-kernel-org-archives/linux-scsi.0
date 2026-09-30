Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE563457E4A;
	Wed, 30 Sep 2026 07:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754908; cv=none; b=lwl/IzNmKga6XiLX+SNOeQDSCryl3Zce/N1nwIa2YagjfnjqngOITLVUjbHuAWI1dGIpeXh0Ifk2tyPi0ZzJtUHrs5d+qBIU6t1iRiSeTtTy2k/LcWBoLdzXIPT/eE4Jt0JyirGCv+Q7+uTMLtbofq9P95mqeo8cgOiK4PWXujc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754908; c=relaxed/simple;
	bh=K1IrY7mc6PTcrxtW/X0ODupEOlA2EUcx7qptV8o3kDc=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CGOurSwje2Cbdt1wHNxCVuwFqwyDZpbwwCLmGKqxAwhDuUPYm6anXKNFOICoqm1vKFUxqacCRslCN6NikFpwvUVy6IIA6QLBraKygivV5juTc7GWIG/6cJ0qXAZLNpUhSDykMGKuzwaC8YfeHwzOcn+KVGiZh+/1CkOS3lUGp3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=orQamPsi; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="orQamPsi"
X-UUID: 39b6906cbca411f18dc8c9802ae25ab1-20260930
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=K1IrY7mc6PTcrxtW/X0ODupEOlA2EUcx7qptV8o3kDc=;
	b=orQamPsioDq2qdVqfX/Dr/Bf2wqiwfcRJ57klw2jpjZox9reelt/56jGwoL+XuTjRublhvOcrJLQk3214h03BEDTH8CsZwEVIDUb10XeuALRgpBNKRjY4aG1NUsffBYtuQThvZM4groNSo/D6NxfPyW9ORFYeG9NpLclyX4APK8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:0b42f285-f731-40c5-acfb-658f21e75d98,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:b0e85de6-a06f-4863-805f-7c30080a71bc,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 39b6906cbca411f18dc8c9802ae25ab1-20260930
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1147909766; Wed, 30 Sep 2026 15:54:55 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 30 Sep 2026 15:54:54 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Wed, 30 Sep 2026 15:54:54 +0800
Message-ID: <7fdb09334fb7d83c76244af2262176cbd21ebefb.camel@mediatek.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Add the aggregated read query opcode
 and its reply format
From: Peter Wang <peter.wang@mediatek.com>
To: <hyenc.jeong@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mkp@kernel.org" <mkp@kernel.org>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
CC: Jinyoung Choi <j-young.choi@samsung.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"can.guo@oss.qualcomm.com" <can.guo@oss.qualcomm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 30 Sep 2026 15:54:54 +0800
In-Reply-To: <1860250540.01790752381858.JavaMail.epsvc@epcpadp2new>
References: <20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p1>
	 <CGME20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p7>
	 <1860250540.01790752381858.JavaMail.epsvc@epcpadp2new>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MTK: N

On Wed, 2026-09-30 at 14:15 +0900, Hyeoncheol Jeong wrote:
> UFS 5.0 adds the AGGREGATED READ query opcode (0x9): a single QUERY
> RESPONSE UPIU returns many descriptors, attributes and flags as a
> chain
> of typed groups (JESD220H 10.7.9.14).
>=20
> Add the AGGREGATION TYPE mask, the group types and the group header,
> and
> let ufshcd_copy_query_response() copy the reply's data segment like a
> descriptor read, recording its length in struct ufs_query_res.
>=20
> Signed-off-by: Hyeoncheol Jeong <hyenc.jeong@samsung.com>

Reviewed-by: Peter Wang <peter.wang@mediatek.com>

