Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A313A1A3F;
	Tue, 22 Sep 2026 07:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790062652; cv=none; b=OHvbDiHISMyjQQ164bqa9AkyCPqrGSBEpcyBTqaARiL0Edeg5qTVMaI86O7RrfqCmxttjV6cFu7YXJI2MkbC1olicp7PoL76LMwIB+hDjPASctVfW/pdnG1VG2I/Shxt7KCYhNMT+TgrBdhAHWZKhfTSkAMM4ya9RQOGwMpwejM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790062652; c=relaxed/simple;
	bh=xMrolzxkJSTeToNK0mKX1495tYpkMHcupo/dfp8kyg0=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bImRdiuQOZG8O16JAZ4ecvmONQ5rpGgti0x/R0DtdHPCGc4v8KNg9wupi3yM0R0Gq92H5VZ8W1hu0XU1b9Z1EQgAn4+6S2Uo66mIkHxWDF5MmxUp1xXB4CLssK7o9aKdbRWN83ojiCkiSbA9Or6OZAdmWS1nOUCEvT22R8grazw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=T36QLDxg; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="T36QLDxg"
X-UUID: 70e8fe32b65811f1b1788b6acf885367-20260922
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=xMrolzxkJSTeToNK0mKX1495tYpkMHcupo/dfp8kyg0=;
	b=T36QLDxgDPKQCzmwo3/HprjjAybRulUfaTh7KGZAmZOlt+Np2yq0yX8TfUgcMwsky25TaIcmUeruka4qLrSqX+Rzq9XdzvXVWN6LKJjYv5dT24vFHAVLG94jjs3q5OF2VuL5dx/+S3dmGm1SG0/j0oyi8iUtCxpylzXrtVqK7/0=;
X-CID-CACHE: Type:Local,Time:202609221536+08,HitQuantity:2
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:aa78755c-2088-4993-aa13-4411278c8a0c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:b76fa028-9ebf-4787-bb42-3cd26eee85aa,B
	ulkID:nil,BulkQuantity:0,SF:81|82|83|102|136|836|865|888|898,TC:-5,Content
	:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,
	COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 70e8fe32b65811f1b1788b6acf885367-20260922
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 210178657; Tue, 22 Sep 2026 15:37:19 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 22 Sep 2026 15:37:18 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Tue, 22 Sep 2026 15:37:18 +0800
Message-ID: <bab059b9a2dfed258db23993b5a6b4aceca2da49.camel@mediatek.com>
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
From: Peter Wang <peter.wang@mediatek.com>
To: Bart Van Assche <bvanassche@acm.org>, Stanley Jhu <stanleyjhu@google.com>
CC: <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, Bean Huo
	<beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Can Guo
	<can.guo@oss.qualcomm.com>, Manivannan Sadhasivam <mani@kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Tue, 22 Sep 2026 15:37:18 +0800
In-Reply-To: <e3538f10-fb9e-48ce-b48f-bca25c8f3d6c@acm.org>
References: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
	 <20260918143809.3034592-1-stanleyjhu@google.com>
	 <20260918143809.3034592-3-stanleyjhu@google.com>
	 <1ddc5181-f547-465c-bfbe-dbf14a91493e@acm.org>
	 <20260920135014.3528082-1-stanleyjhu@google.com>
	 <e3538f10-fb9e-48ce-b48f-bca25c8f3d6c@acm.org>
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

On Mon, 2026-09-21 at 10:13 -0700, Bart Van Assche wrote:
> In SDB mode, clearing UTRLDBR will cause all pending commands to be
> requeued because the OCS member is initialized to
> OCS_INVALID_COMMAND_STATUS and because ufshcd_transfer_rsp_status()
> translates this status value into DID_REQUEUE << 16. I'm concerned
> that this approach may cause the deadlines for SCSI commands to be
> exceeded. Hence my proposal for MCQ mode not to requeue pending SCSI
> commands but instead to let the SCSI error handler decide what to do
> with these commands.
>=20

Hi Bart,

The current MCQ flow is similar to SDB. We discussed this two years
ago.
Aborted commands will be requeued immediately, just like in SDB mode
https://patchwork.kernel.org/project/linux-scsi/list/?series=3D894411&state=
=3D*

Thanks
Peter
=20


