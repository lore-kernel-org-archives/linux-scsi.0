Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0155B3F4DEB;
	Wed, 30 Sep 2026 07:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754950; cv=none; b=cOLL2pqCQ6uldkPwAoFTuzMRIS2gVDoEE1+R3dhYSPuMxa+IiVQW8sdtx3hO4CfAVUMNLtew9BSK12fARKZw64HxkEYhcv7sllSxleJ48OL/D4umGl1gu8i8rWr7gUpNbWBTiR/beRa8hapyS8cFLtsUMTvcoY+IgWPfJPs5ptM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754950; c=relaxed/simple;
	bh=B9dKQMrl81SvGauYE7esNuwZmF9jAO2bHP30BJAAS00=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IgE/W0e2Mm0rhgKqQB9ZJNtGnxgkw32MhefoQKP+D5EsAvrhV+HwF58v0YiM94PykAR3t3TWGWZ0FrB4ykuf4ZImD3v9slSdf1nSMHMdfKB5/x7E2tuqP2tj8a/ou0g7BOE52n1URhkPGh7fIKw5iVxixttI48PvQ4txR8lP1Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=LORIkH78; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LORIkH78"
X-UUID: 55f02608bca411f18dc8c9802ae25ab1-20260930
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=TgYUVKMcHeQnZuLO8zQrRpKr0h+wD7vb+q76obf6niM=;
	b=LORIkH78m05SEwoMbloGpzTjs9LXruM97OhTCNXIiayEoqvNwatvnHewHPuVyO0ibTCe2NvHAQ2G+I1WqR37WlzGf5LYZ9AhDckoPAl0nG8Sgew98tYutOqjXHktDCK96JPp/adQZnt/oKOlgb9UbcWFqCRO1KUtjkXu9UTAOek=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:fbc0330e-8c7c-4749-814d-df171c7047cb,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:86854f39-d9dc-4114-a414-20e4faf2028f,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 55f02608bca411f18dc8c9802ae25ab1-20260930
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 809517287; Wed, 30 Sep 2026 15:55:42 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 30 Sep 2026 15:55:41 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Wed, 30 Sep 2026 15:55:41 +0800
Message-ID: <b97d4532feb310a3cbd49a4040c01f6607997fdf.camel@mediatek.com>
Subject: Re: [PATCH v2 2/2] scsi: ufs: Serve the device init reads from one
 aggregated read
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
Date: Wed, 30 Sep 2026 15:55:41 +0800
In-Reply-To: <1653986196.21790747102619.JavaMail.epsvc@epcpadp1new>
References: <20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p1>
	 <CGME20260930050201epcms2p13ab67182445b0555acc8d27b927cda86@epcms2p2>
	 <1653986196.21790747102619.JavaMail.epsvc@epcpadp1new>
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

On Wed, 2026-09-30 at 14:18 +0900, Hyeoncheol Jeong wrote:
> Device init reads several attributes and flags one query at a time.
> On
> UFS 5.0, issue one AGGREGATED READ once the device descriptor has
> established wSpecVersion, cache the reply, and serve the following
> attribute, flag and ID-string reads from it. Anything not present,
> and
> older devices or a rejected opcode, fall back to individual queries.
>=20
> The following per-item queries are folded into the one aggregated
> read:
>=20
> Attributes (ALL_ATTRS group)
> 	0x0c bMaxNumOfRTT=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - ufshcd_set_rtt()
> 	0x17 bRefClkGatingWaitTime=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 -
> ufshcd_get_ref_clk_gating_wait()
> 	0x1e bWriteBoosterBufferLifeTimeEst - ufshcd_wb_probe()
>=20
> Flags (ALL_FLAGS group)
> 	0x03 fPowerOnWPEn=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -
> ufshcd_device_params_init()
>=20
> Strings (STRING_DESC groups)
> 	Product Name string=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - ufs_get_device_desc()
> 	Serial Number string=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 -
> ufshcd_create_device_id()
>=20
> (bWriteBoosterBufferLifeTimeEst is served from the packet only in the
> shared-buffer mode)
>=20
> Signed-off-by: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
> ---

Reviewed-by: Peter Wang <peter.wang@mediatek.com>

