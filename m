Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD9A3148CF;
	Wed, 30 Sep 2026 07:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790753503; cv=none; b=ZRFXXoqhGCsG/SMmn/kN/ugLlu4uzJarjz76eM4Br+JHrIsFASvQM+3uZYNNraZXssxY+snh8vjVHYCg5dKkO7vqnP9XZWVHEjKtDUYflE1mWZspcu3GOoORef6FUwdShQHYtbyESa177iGzosdEtgT6qSXETsmik/GQoWMCQ8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790753503; c=relaxed/simple;
	bh=8RbBNvD5zYgVtUnFeYwNOG8gwaphZ3zhnA+wm7+v+fM=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tJF29s87VNvTIRHInG/7l+fKGqF3Q5U9io00WEzgSasXF1C0TIuj4TIvMJErt6st+GcD+SFp9tO/BfEjBbZ0mtCpp2UeiboqfwS+2Wt6GG49h8ZV1fQQ5JhjK1rXbqh5DaFNvtW58pJdqLv2IqeH9wUcC1b6fUkCV5btAkLP4fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=hsPhGXUu; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hsPhGXUu"
X-UUID: f2d675c0bca011f18dc8c9802ae25ab1-20260930
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=8RbBNvD5zYgVtUnFeYwNOG8gwaphZ3zhnA+wm7+v+fM=;
	b=hsPhGXUu05NyhJyshSgPLNj6nn7+g498VL6XUxLMCqkJKF9uUtL1aFA5Vlpz/xU2BVGYBMdmGS9Eivm//Y/y7DdC0I6Z+zI+CsuUV3wPtT2MzNQg8Bq9oRVJknco/cOSosBFiUtKak5elT4VJO62RVpKmCNA8VLfLCLPr8uzUdQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:cddc1909-fb19-4828-80d3-ae9acd568ff8,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:cf30cc94-3103-4fdb-b79c-08de0e281a5d,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|136|836|865|888|898,TC:-5,Cont
	ent:0|15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:
	-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f2d675c0bca011f18dc8c9802ae25ab1-20260930
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1525355678; Wed, 30 Sep 2026 15:31:28 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 30 Sep 2026 15:31:26 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs13n2.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Wed, 30 Sep 2026 15:31:26 +0800
Message-ID: <4c12d6cac263f962d8653d2b40c8fb6a2e6ac2f7.camel@mediatek.com>
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
From: Peter Wang <peter.wang@mediatek.com>
To: Bart Van Assche <bvanassche@acm.org>, Stanley Jhu <stanleyjhu@google.com>
CC: <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, Bean Huo
	<beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Can Guo
	<can.guo@oss.qualcomm.com>, Manivannan Sadhasivam <mani@kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Wed, 30 Sep 2026 15:31:26 +0800
In-Reply-To: <400fdf78-c021-4fa4-9024-6575e01bec89@acm.org>
References: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
	 <20260918143809.3034592-1-stanleyjhu@google.com>
	 <20260918143809.3034592-3-stanleyjhu@google.com>
	 <1ddc5181-f547-465c-bfbe-dbf14a91493e@acm.org>
	 <20260920135014.3528082-1-stanleyjhu@google.com>
	 <e3538f10-fb9e-48ce-b48f-bca25c8f3d6c@acm.org>
	 <bab059b9a2dfed258db23993b5a6b4aceca2da49.camel@mediatek.com>
	 <df31eb82-7211-415a-9ec1-53ecbc3e39b0@acm.org>
	 <f116f82d28f7af4cfca76adf5cff6093fdf393a2.camel@mediatek.com>
	 <CAE14pdfbxX7BWzKg9z7ytB9rZPAp40ipXk8NPOdAp2Jv7eq6Xw@mail.gmail.com>
	 <eac2f886-61af-4b3e-b237-88d59cc4eab3@acm.org>
	 <400fdf78-c021-4fa4-9024-6575e01bec89@acm.org>
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

On Fri, 2026-09-25 at 10:26 -0700, Bart Van Assche wrote:
> A correction: the INIT_LIST_HEAD(&cmd->eh_entry) statement is not
> reached while SCSI host recovery is in progress because
> SCMD_STATE_COMPLETE is set for all pending commands before the SCSI
> host recovery starts. scsi_done() skips SCSI commands for which that
> bit is set due to the following code:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(test_and_set_bit(=
SCMD_STATE_COMPLETE, &cmd-
> >state)))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 return;
>=20
> Hence, the scmd->result value is ignored if scsi_done() is called
> while SCSI host recovery is in progress.
>=20
> Bart.

Thanks to Bart and Stanley for the detailed explanation.
It is clear to me now.

Thanks
Peter

