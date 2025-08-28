Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EE930BBAC
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2025 10:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756376205; cv=none; b=ktP//0BH9Vvo92hpTBzwqBV7DsEv5uYgXVB28ebWT7huRa30Xsis+ud9evoH7oolTyuGf+nplV5v1HvfFZvqdFF8/i81An2iYvm92ngMpyvS9AOVIFM7BNopJpRAYmzLX5cbVqLeYubRxVgX58hWGIKE1++KyW8bm01tmGtzwks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756376205; c=relaxed/simple;
	bh=eQ6/+QYc3GtKN89cbuw8yxOlg3HzS1j1uIjLOLeHlUw=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=Y0yWzod0dVaYBKuc2coP29jxOVefY9OWOo0YGknatL9/CMtyYOz4Rn5+jTIx/fZJOARSNnr/XSdsKIOdrxayNWcqB0N+tiBR8PLnnob2mo3crtN9xljO+QM5nH/3lRBjMtZpsWCJmB9yMOt0KzysOCKkb+iuNGHlwNUBpZfn1KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=CkYi5kMx; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CkYi5kMx"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250828101640epoutp04f6c8f296c36b484059b9e3f5850752c0~f5tlMG2hV0109801098epoutp04d
	for <linux-scsi@vger.kernel.org>; Thu, 28 Aug 2025 10:16:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250828101640epoutp04f6c8f296c36b484059b9e3f5850752c0~f5tlMG2hV0109801098epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756376200;
	bh=7WVbLEgCBgW0kxr8siZONXo38qiuBE7Ny1BRGaYyQ2A=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=CkYi5kMx3iyOqZ9y17EC/DFSJSQlfwgkL60NAxPR6nSriqfZALFLSUU5yLg4OQxyb
	 bscMf4PnGUvY+dm8nCjARO//MNPdU6N6oITbGYSdNn67c5m+8WBYByBbfVt+Cet/4y
	 zoQZcOJWXReceNQTRN3WThIaYRmfxqH+jsonVMwQ=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250828101639epcas5p48b80c4a47884cd10bbac3bbc8f4591fc~f5tkKT9_40991509915epcas5p4y;
	Thu, 28 Aug 2025 10:16:39 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.92]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cCHPL3zKGz3hhT3; Thu, 28 Aug
	2025 10:16:38 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250828101638epcas5p47594b2a3f92cfbe02b3135b62e6c71fd~f5tivVJSY0991509915epcas5p4u;
	Thu, 28 Aug 2025 10:16:38 +0000 (GMT)
Received: from FDSFTE361 (unknown [107.122.81.127]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250828101636epsmtip14b3c87b255cbf7a76151549e375f0457~f5thOPiNG2530725307epsmtip1e;
	Thu, 28 Aug 2025 10:16:36 +0000 (GMT)
From: "Bharat Uppal" <bharat.uppal@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <linux-samsung-soc@vger.kernel.org>
Cc: <pankaj.dubey@samsung.com>, <aswani.reddy@samsung.com>, "'Nimesh Sati'"
	<nimesh.sati@samsung.com>, <bharat.uppal@samsung.com>
In-Reply-To: 
Subject: RE: [PATCH] scsi: ufs: exynos: fsd: Gate ref_clk and put UFS device
 in reset on suspend
Date: Thu, 28 Aug 2025 15:46:24 +0530
Message-ID: <005401dc1804$d68d9110$83a8b330$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQExeeAfBfzr5YSvfr0wrrMUW8ELmAHKrEFuAhf3ztm1iYbGIIAkeQeQ
Content-Language: en-in
X-CMS-MailID: 20250828101638epcas5p47594b2a3f92cfbe02b3135b62e6c71fd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-541,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250804113654epcas5p1dc2a495e16ff0f66eafc54be67550f23
References: <CGME20250804113654epcas5p1dc2a495e16ff0f66eafc54be67550f23@epcas5p1.samsung.com>
	<20250804113643.75140-1-bharat.uppal@samsung.com>
	<c9cd3d39-37ec-42cf-9458-e3242fe1f302@acm.org> 

Hi Bart,
I have made the relevant changes and pushed the updated patch.
Can you please review it and close the same.

With Regards
Bharat Uppal

> -----Original Message-----
> From: Bharat Uppal <bharat.uppal=40samsung.com>
> Sent: 05 August 2025 10:58
> To: 'Bart Van Assche' <bvanassche=40acm.org>; 'linux-scsi=40vger.kernel.o=
rg'
> <linux-scsi=40vger.kernel.org>; 'linux-kernel=40vger.kernel.org' <linux-
> kernel=40vger.kernel.org>; 'James.Bottomley=40HansenPartnership.com'
> <James.Bottomley=40HansenPartnership.com>;
> 'martin.petersen=40oracle.com' <martin.petersen=40oracle.com>;
> 'alim.akhtar=40samsung.com' <alim.akhtar=40samsung.com>;
> 'avri.altman=40wdc.com' <avri.altman=40wdc.com>; 'linux-samsung-
> soc=40vger.kernel.org' <linux-samsung-soc=40vger.kernel.org>
> Cc: 'pankaj.dubey=40samsung.com' <pankaj.dubey=40samsung.com>;
> 'aswani.reddy=40samsung.com' <aswani.reddy=40samsung.com>; 'Nimesh Sati'
> <nimesh.sati=40samsung.com>
> Subject: RE: =5BPATCH=5D scsi: ufs: exynos: fsd: Gate ref_clk and put UFS=
 device in
> reset on suspend
>=20
>=20
> > -----Original Message-----
> > From: Bart Van Assche <bvanassche=40acm.org>
> > Sent: 04 August 2025 21:17
> > To: Bharat Uppal <bharat.uppal=40samsung.com>;
> > linux-scsi=40vger.kernel.org; linux-kernel=40vger.kernel.org;
> > James.Bottomley=40HansenPartnership.com;
> > martin.petersen=40oracle.com; alim.akhtar=40samsung.com;
> > avri.altman=40wdc.com; linux-samsung-soc=40vger.kernel.org
> > Cc: pankaj.dubey=40samsung.com; aswani.reddy=40samsung.com; Nimesh
> Sati
> > <nimesh.sati=40samsung.com>
> > Subject: Re: =5BPATCH=5D scsi: ufs: exynos: fsd: Gate ref_clk and put U=
FS
> > device in reset on suspend
> >
> > On 8/4/25 4:36 AM, Bharat Uppal wrote:
> > > +static int fsd_ufs_suspend(struct exynos_ufs *ufs) =7B
> > > +	exynos_ufs_gate_clks(ufs);
> > > +	hci_writel(ufs, 0 << 0, HCI_GPIO_OUT);
> > > +	return 0;
> > > +=7D
> >
> > Why '0 << 0' instead of just '0'? Isn't the latter easier to read?
> Thanks for reviewing.
> Indeed setting 0 is right, but in the same file ufs-exynos.c,  I have see=
n
> HCI_GPIO_OUT register configured using 0 << 0.
> My intent here is to maintain coding style within the file.
>=20
> With Regards
> Bharat Uppal
>=20
> >
> > Thanks,
> >
> > Bart.

