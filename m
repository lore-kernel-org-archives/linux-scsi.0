Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBE710A3E
	for <linux-scsi@vger.kernel.org>; Thu,  7 Aug 2025 10:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754563826; cv=none; b=BjjD1JF4WCbZwLyyOUBMS5ap8jI42b+4GAekS+8R92XM60cFzhA62UOZjkbK6OCtc8OGRVzACIx86vY++gEe7dVNz5SgCzuD4dKzTLG37DXk7jwPykncGpK4FvqPXQnYrqEPhJkK3gscqn1DcBfx0BsTegdfztFNtQCTHb6n9Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754563826; c=relaxed/simple;
	bh=Syfn0NEuvRi1yje0O/PsVJqRnUVtWUN/PEXoRX+j6eU=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=L56AtxmXns/yfWtTTmWwuTqSg56nKvindk9JNTkQMaN2XC/dksppgUXVCZHLq/MRymB7QpiGTU3MeJJjvNxesLs8NIxqIYty+GiN4ujboU6vCzMyQz4H47IrD2uE4P4qSPnW6BSLrIPjQdcq34NZC5ptEWy5kNgczSAgT8FV1/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=e2jZcK3M; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="e2jZcK3M"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250807105022epoutp0263032f32e7a927aed584c7589b63ac3a~ZdoAZZjNs1759417594epoutp02M
	for <linux-scsi@vger.kernel.org>; Thu,  7 Aug 2025 10:50:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250807105022epoutp0263032f32e7a927aed584c7589b63ac3a~ZdoAZZjNs1759417594epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754563822;
	bh=4JuxWH0gBRJFGn1yRVR8bYk8LvsjMgUCt5sZEIKMU0w=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=e2jZcK3MhHShok6QY1JpZA90wrloAaNL1f4N67gVCrQ0cHt+aESjgPMQLu6lIPajZ
	 2o/Df62U5i3edTPAuG5HKG+UqZG6SD8MQXyyDyAY0Zuu/WxECQbBS9aTx1fFcHYPrI
	 p3d02kLcxwAKqR9Os+i7I8n+CzqCmsa/sio/i6c8=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250807105021epcas5p3d0cb6d2d9e7317dda010087be19fcb1f~Zdn-wez1Y0694006940epcas5p3R;
	Thu,  7 Aug 2025 10:50:21 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.94]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4byP7x017Dz2SSKb; Thu,  7 Aug
	2025 10:50:21 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250805052803epcas5p47a93b443b6c085e237adbafc4de1f3b7~Yx8BUYASz2721327213epcas5p4k;
	Tue,  5 Aug 2025 05:28:03 +0000 (GMT)
Received: from FDSFTE361 (unknown [107.122.81.127]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250805052802epsmtip299b7db91253d19087c2c9b5618578ed1~Yx7-3VIlX0050500505epsmtip22;
	Tue,  5 Aug 2025 05:28:02 +0000 (GMT)
From: "Bharat Uppal" <bharat.uppal@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <linux-samsung-soc@vger.kernel.org>
Cc: <pankaj.dubey@samsung.com>, <aswani.reddy@samsung.com>, "'Nimesh Sati'"
	<nimesh.sati@samsung.com>
In-Reply-To: <c9cd3d39-37ec-42cf-9458-e3242fe1f302@acm.org>
Subject: RE: [PATCH] scsi: ufs: exynos: fsd: Gate ref_clk and put UFS device
 in reset on suspend
Date: Tue, 5 Aug 2025 10:58:00 +0530
Message-ID: <0ae601dc05c9$b749ba60$25dd2f20$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-in
Thread-Index: AQExeeAfBfzr5YSvfr0wrrMUW8ELmAHKrEFuAhf3ztm1iYbGIA==
X-CMS-MailID: 20250805052803epcas5p47a93b443b6c085e237adbafc4de1f3b7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-541,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250804113654epcas5p1dc2a495e16ff0f66eafc54be67550f23
References: <CGME20250804113654epcas5p1dc2a495e16ff0f66eafc54be67550f23@epcas5p1.samsung.com>
	<20250804113643.75140-1-bharat.uppal@samsung.com>
	<c9cd3d39-37ec-42cf-9458-e3242fe1f302@acm.org>


> -----Original Message-----
> From: Bart Van Assche <bvanassche=40acm.org>
> Sent: 04 August 2025 21:17
> To: Bharat Uppal <bharat.uppal=40samsung.com>; linux-scsi=40vger.kernel.o=
rg;
> linux-kernel=40vger.kernel.org; James.Bottomley=40HansenPartnership.com;
> martin.petersen=40oracle.com; alim.akhtar=40samsung.com;
> avri.altman=40wdc.com; linux-samsung-soc=40vger.kernel.org
> Cc: pankaj.dubey=40samsung.com; aswani.reddy=40samsung.com; Nimesh Sati
> <nimesh.sati=40samsung.com>
> Subject: Re: =5BPATCH=5D scsi: ufs: exynos: fsd: Gate ref_clk and put UFS=
 device in
> reset on suspend
>=20
> On 8/4/25 4:36 AM, Bharat Uppal wrote:
> > +static int fsd_ufs_suspend(struct exynos_ufs *ufs) =7B
> > +	exynos_ufs_gate_clks(ufs);
> > +	hci_writel(ufs, 0 << 0, HCI_GPIO_OUT);
> > +	return 0;
> > +=7D
>=20
> Why '0 << 0' instead of just '0'? Isn't the latter easier to read?
Thanks for reviewing.
Indeed setting 0 is right, but in the same file ufs-exynos.c,  I have seen =
HCI_GPIO_OUT register configured using 0 << 0.
My intent here is to maintain coding style within the file.

With Regards
Bharat Uppal

>=20
> Thanks,
>=20
> Bart.

