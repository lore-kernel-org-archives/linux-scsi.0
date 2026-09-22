Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69106340400;
	Tue, 22 Sep 2026 03:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790046216; cv=none; b=D/SaT71pnsVH5iC1Z7LOHJIKBSNTNv+vhVMZOV7DjHTbCvCSua8NEBdIo0xr9ro85+WDJLO/Nm3N2SSWekjp5Gs4gUU4A2cwJTvDiP1wNRbUBULY4MArcd5SrIXc4DLEhHg8mVka5VS5jDuK2n2FjzOasJlDh9XyBIBLz2LOwO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790046216; c=relaxed/simple;
	bh=/OMYMevv6HzZC6njrgP47kAH5AFxtcbIEwOnZx+CVAo=;
	h=Message-ID:Subject:From:To:CC:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W8waeiDy53lJi50VbPs4JI0T9md6VgJg98wBDdNbK3Bar/+MWv+OsHHhDPPf8W5vBZ4Hrqt/J6Npp6YsF09gGVvpGuF5rlucXrzDySwKBUZLF2VZGSJAFUJPYvggieYD/Ainb9N1YM3qBQnoiQf23XWTzNy6aT3dXUPsOgU6Nkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=aKuvzCII; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="aKuvzCII"
X-UUID: 2e5405b0b63211f18dc8c9802ae25ab1-20260922
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=/OMYMevv6HzZC6njrgP47kAH5AFxtcbIEwOnZx+CVAo=;
	b=aKuvzCIIxeEgz5TdgRVnRYUpA1gD1lQ/5G6Cf7jHzNwf8e6RpEGCOt0CyRNzgpqSbXQF8qHpHSDJB+IUk3pV1e5eNKK0hIXD20y7f/vdGY1Xl9Kc2J6dP+DDimDP/0DUTTxdrpxiaeU/2zaH7oKr0nzzNUvEd+v/zQG15sYEuZ4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:a1c8f662-be6e-41ad-9b60-0a9b17d1be7d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:573023e3-72a5-4ba1-af40-18bbd6ea8ffd,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|836|865|888|898,TC:-5,Content:
	0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2e5405b0b63211f18dc8c9802ae25ab1-20260922
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 427490513; Tue, 22 Sep 2026 11:03:26 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 22 Sep 2026 11:03:25 +0800
Received: from [10.233.130.16] (10.233.130.16) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Tue, 22 Sep 2026 11:03:25 +0800
Message-ID: <6288ff21af758e0f3739edb6c33abe3bfbdba3dd.camel@mediatek.com>
Subject: Re: [PATCH 1/2] scsi: ufs: core: Release command resources instead
 of force-completing
From: Peter Wang <peter.wang@mediatek.com>
To: Bart Van Assche <bvanassche@acm.org>, Stanley Jhu <stanleyjhu@google.com>
CC: "Martin K. Petersen" <mkp@kernel.org>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, Bean Huo
	<beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>, "Manivannan
 Sadhasivam" <mani@kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Tue, 22 Sep 2026 11:03:25 +0800
In-Reply-To: <16af6539-24f8-425e-b411-f191897acfce@acm.org>
References: <20260920143319.3659543-1-stanleyjhu@google.com>
	 <20260920143319.3659543-2-stanleyjhu@google.com>
	 <fee250ea-8e0b-4320-880e-8e2627e7b103@acm.org>
	 <20260921043755.1689675-1-stanleyjhu@google.com>
	 <16af6539-24f8-425e-b411-f191897acfce@acm.org>
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

On Mon, 2026-09-21 at 09:51 -0700, Bart Van Assche wrote:
> > Agreed for the path where SCSI EH drove the reset. The case I am
> > unsure
> > about is the other caller: ufshcd_err_handler() also runs from
> > hba->eh_work, scheduled by ufshcd_check_errors() on UIC and
> > controller
> > errors. Those commands have not timed out and are not on
> > shost->eh_cmd_q, so SCSI EH never finishes them, and the handler
> > leaves
> > them to the reset path on purpose:
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * if host reset is required then s=
kip clearing the pending
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * transfers forcefully because the=
y will get cleared during
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * host reset and restore
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> >=20
> > Should those simply wait for the block layer timeout and come back
> > through SCSI EH?
>=20
> That sounds good to me.
>=20
> Thanks,
>=20
> Bart.

Hi Bart,

It appears unreasonable to wait for the entire 30 second timeout,
as many UIC errors recover promptly. The resulting 30 second stall
would manifest as a noticeable UI freeze. Maybe we shouldn=E2=80=99t let=
=20
eh_host_reset_handler call the EH handler at all?

Thanks
Peter

