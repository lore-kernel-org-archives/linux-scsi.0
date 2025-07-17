Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5682C20E704
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 06:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752732745; cv=none; b=i8EjF7XosI4ShU/MH4VL1dzSWXfBJM2b7uJr9puzwKOaBQXob/J1/WZdYQuFxlaxnwSxu86IsPZpTP7h774uCB5iBYr57uR81N3u/1UeOux1HUa3f0Avrx4kkA6NTjPVwdASAM332MpmPx9lT7fbcsYxOemMEsel0Lr1jmdpNRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752732745; c=relaxed/simple;
	bh=XEnmymd8SpR6WG81RgKfajhBGJjO93ZFaQbaIDV4NE8=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=nxE4OnRKThHgf9egTsePzu7uTNFs2mnm6pck01iQSH7iYErqoXwNCehgK+MJIsK6iHBLJcqLpK6dRC9kpyW7kKy+DbeEH5iSA7kBRwfIRfC601ArCKLaXH2TQip6Ks2mvQtK9bp3kEZ5dVMEO58Yz/mcqM62xcwrvXjunVfmNIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=N64i8l/S; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N64i8l/S"
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250717061221epoutp04c98b0eccd7d2478b5b91ac45ff3e7076~S9SRWPb8Q1299212992epoutp04W
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 06:12:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250717061221epoutp04c98b0eccd7d2478b5b91ac45ff3e7076~S9SRWPb8Q1299212992epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1752732741;
	bh=qvonQUGmccWmCYCbaJ4HTa/1qo4R93iG0ui8zv6DSlU=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=N64i8l/SfE6Obt7NXHTr4COjRpVlgC6hmYzxw2LsK5Zf2Apjorbr3LFAyC6UxamPl
	 gUi9MlMXdeJwm+U1KoOBZupdFOi+KlFfExCcFbZp8hAC/mwoZtuNZ/vjgc4/aIK6Ky
	 CkdqViBgfh3QdbTidi+y5kIdh8ekQjFkawLhrwa4=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPS id
	20250717061220epcas1p196fe20e74afc5b6ca8b26ed50f71382a~S9SQ7pTB82921329213epcas1p1Y;
	Thu, 17 Jul 2025 06:12:20 +0000 (GMT)
Received: from epcas1p3.samsung.com (unknown [182.195.36.222]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bjMyr4B5lz3hhTG; Thu, 17 Jul
	2025 06:12:20 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20250717061219epcas1p323c4a9c56931be487766911f8acd2ae5~S9SPl6sUe0545705457epcas1p3F;
	Thu, 17 Jul 2025 06:12:19 +0000 (GMT)
Received: from sh043lee04 (unknown [10.253.101.72]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250717061219epsmtip16bb1387c11277f6a0ea513fb55d30fdf~S9SPiIb-62866228662epsmtip1k;
	Thu, 17 Jul 2025 06:12:19 +0000 (GMT)
From: "Seunghui Lee" <sh043.lee@samsung.com>
To: "'Bean Huo'" <huobean@gmail.com>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <sdriver.sec@samsung.com>
In-Reply-To: <ff93d49524dd1b79968b690753a3727e695f852d.camel@gmail.com>
Subject: RE: [PATCH] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
Date: Thu, 17 Jul 2025 15:12:19 +0900
Message-ID: <001101dbf6e1$c07a8110$416f8330$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQH3aHPkcZ8xP3B7R0c5EXGU8cAQqgKwpSsnAUiyhkICOzcz6QJIvQEgAeA6CDICNwPcSgIU5iKCs4mkLAA=
Content-Language: ko
X-CMS-MailID: 20250717061219epcas1p323c4a9c56931be487766911f8acd2ae5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b
References: <CGME20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b@epcas1p2.samsung.com>
	<20250714090617.9212-1-sh043.lee@samsung.com>
	<b8fa773234058e68e6006127b3cd848046b75e6f.camel@gmail.com>
	<000901dbf52f$63a69090$2af3b1b0$@samsung.com>
	<cd0959939d2fefe927b66ca12620c094c4cfb7a2.camel@gmail.com>
	<005801dbf61f$7287e7d0$5797b770$@samsung.com>
	<00f301dbf626$2b2a1550$817e3ff0$@samsung.com>
	<ff93d49524dd1b79968b690753a3727e695f852d.camel@gmail.com>

> > > > Subject: Re: [PATCH] ufs: core: Use link recovery when the h8 exit
> > > > failure during runtime resume
> > > >
<snip> 
> 
> Based on my analysis, the tag might be:
> 
> commit 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and
> other error recovery paths"), This commit added the error handling logic
> that calls ufshcd_set_link_broken() and ufshcd_schedule_eh_work() when ret
> is non-zero in the ufshcd_uic_pwr_ctrl() function.
> 
> your patch adds a check for pm_op_in_progress to skip the error handler
> and use link recovery instead during PM operations.
> 
> Therefore, the appropriate Fixes tag for your patch would be:
> 
> Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and
> other error recovery paths")
> 
> But, the problem is dd11376b9f1b ("scsi: ufs: Split the drivers/scsi/ufs
> directory") reorganzied the UFS code layout, it is true that not easy to
> add a proper tag,
> 
> Or we can use both fix tags, or just the last one.
> 
> Let Bart comment on this,
> 
> Kind regards,
> Bean


Thank you so much for sharing it.
I'll add it v2 as requested.

Fixes: 4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and
other error recovery paths")



