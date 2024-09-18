Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5289423B0
	for <linux-scsi@vger.kernel.org>; Wed, 18 Sep 2024 06:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726642070; cv=none; b=CAXB/4neAluT7FmF60ackVZa7PdHUCFgJMn0yiuY4xdas57id7CTf0kAGER140wPhXrXAa0TqWALq45JQrEf/52HYgRZbwZqGjNZJh0XMR702Fy0cYC6IfgyMwoWwqYmwuUyljEzS1AqcaS9TW/3wIbVpfmxUjLO/cWlYA35jjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726642070; c=relaxed/simple;
	bh=7molbCH+4Oxgs7cSunHpqCo1cLuuytcEOYchQ+dJ5rk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=pxyH8buihofjtMVCOvYyOo7hx1PBwGY24S3sMazkBst2pinOE+ZjGyrqq2JGOaJOQQPl41cWebYXU4RvK87uacMAKsCEOSQOtkNh8V1AcibqoNcO3uNlxX9f9/So4D/5pzyDHbUVkDZAkBzsVHnAujcUg+eERuLek2rJo5gJWDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=dDixTifc; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dDixTifc"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240918064743epoutp029c18a63dceb2489df6e9ffe764a6bd56~2Q87pgrx72564425644epoutp02K
	for <linux-scsi@vger.kernel.org>; Wed, 18 Sep 2024 06:47:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240918064743epoutp029c18a63dceb2489df6e9ffe764a6bd56~2Q87pgrx72564425644epoutp02K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1726642063;
	bh=jYdDIM61rLfK0sbYeOdIoHCyY98urG+92WC1lv7H3EU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dDixTifcRRe6g2ROPHyiZYoVjIznfnp0EC5mwPr48OgXxmkNFLsKprdjYG7tAnphk
	 5HlWRkY/a7zhcf4q6BIslmbOg4PabM6rrS1vYJ1apGSTmC83XK2edIr1QWi8Mqp9xu
	 lLBRgLOPtUvGMrGKB3xUNvCgEqjCkV6NYuXBe1qY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240918064742epcas5p2969ab58dbc7631e2d59ca245d304c660~2Q87QF7Ot0584005840epcas5p2Q;
	Wed, 18 Sep 2024 06:47:42 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4X7q3147Dqz4x9Pv; Wed, 18 Sep
	2024 06:47:41 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C1.8E.09640.D877AE66; Wed, 18 Sep 2024 15:47:41 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240918064651epcas5p418d61389752da25e5fc50e6a50a111b8~2Q8LznB2w2037020370epcas5p4E;
	Wed, 18 Sep 2024 06:46:51 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240918064651epsmtrp23995a57e9cdd729b9bae2631404646d5~2Q8LvwawO1973319733epsmtrp2k;
	Wed, 18 Sep 2024 06:46:51 +0000 (GMT)
X-AuditID: b6c32a49-a57ff700000025a8-25-66ea778d5c70
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6A.D3.08456.B577AE66; Wed, 18 Sep 2024 15:46:51 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240918064650epsmtip2f1a3a529f7506fa5be05a6349e84272e~2Q8KrfkBj1101711017epsmtip2B;
	Wed, 18 Sep 2024 06:46:50 +0000 (GMT)
Date: Wed, 18 Sep 2024 12:09:10 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-nvme@lists.infradead.org
Subject: Re: fine-grained PI control
Message-ID: <20240918063910.hqntgm5jy2jisys2@green245>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <yq1ttgz5l6d.fsf@ca-mkp.ca.oracle.com>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKJsWRmVeSWpSXmKPExsWy7bCmpm5v+as0g73zpS1Wrj7KZHH0/1s2
	i723tC3mL3vKbtF9fQebxfLj/5gc2Dw2L6n32H2zgc3j49NbLB59W1YxenzeJBfAGpVtk5Ga
	mJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0X0mhLDGnFCgU
	kFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnbH9gHXB
	NI6K03sesjcwPmPrYuTkkBAwkdi9+z9LFyMXh5DAbkaJq1ueQjmfGCWef3rNDuF8Y5SYenYa
	I0xLx65NbBCJvYwSs44egWp5xijxsn85M0gVi4CqxP/pXUwgNpuAusSR561g3SICphKTP20F
	62YWWMIo8ePPTbBLhAVUJLbPuAVm8wqYSRycfooZwhaUODnzCQuIzSlgLHHmz1l2EFtUQEZi
	xtKvzBAnfWSX2LI1FMJ2kXjWPocFwhaWeHV8CzuELSXx+d1eqK/TJX5cfsoEYRdINB/bB/Wa
	vUTrqX6wmcwCGRLnjrRC1ctKTD21jgkizifR+/sJVC+vxI55MLaSRPvKOVC2hMTecw1QtofE
	zl3NrJAQWscoMXfaNrYJjPKzkPw2C8k+CNtKovNDE+ssRg4gW1pi+T8OCFNTYv0u/QWMrKsY
	JVMLinPTU4tNCwzzUsvhMZ6cn7uJEZw+tTx3MN598EHvECMTB+MhRgkOZiURXvEPL9OEeFMS
	K6tSi/Lji0pzUosPMZoCI2sis5Rocj4wgeeVxBuaWBqYmJmZmVgamxkqifO+bp2bIiSQnliS
	mp2aWpBaBNPHxMEp1cAk98RwafCByYZbP8qWXJzw/OjZpqI1J0SF7NefOnN1odENg9yfk47G
	HMzoeHUvJr+Lt40ldtLJepbv3o21njcm/Wlz64ro5zYpELvrXPk0QsrL2zm+xfmh8EIOPt6Z
	58rNryeedb9rd07ed+aVDdGmoVdTFvjvqnjmspA1d7HLZWGft8X3s6Q919a2aKbtsWS+u3Wd
	q9zVM3/FZY4GphpviYlJCcr4XXZ8okf3XNbdse+XpVn8ttF738156vHzS2eWx1c/WPUiTd5v
	vcx5hZm7bxdN3RUdslhmudWmI0u39r3glvrVpJG/6WHTY8nH8rFBnFvs3ygJFLtcMZzRrGp4
	pq6pYv/HbYprdrXeCV2mxFKckWioxVxUnAgACajEfCgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWy7bCSvG50+as0gw3LVSxWrj7KZHH0/1s2
	i723tC3mL3vKbtF9fQebxfLj/5gc2Dw2L6n32H2zgc3j49NbLB59W1YxenzeJBfAGsVlk5Ka
	k1mWWqRvl8CV0dYzn7ngBGvFocVbmRoYN7F0MXJySAiYSHTs2sQGYgsJ7GaUOHg2BiIuIXHq
	5TJGCFtYYuW/5+xdjFxANU8YJU692cAKkmARUJX4P72LCcRmE1CXOPK8FaxBRMBUYvKnrWwg
	DcwCSxglfvy5CbZBWEBFYvuMW2A2r4CZxMHpp5ghNkdJ9JzrgIoLSpyc+QTsOmagmnmbHwLV
	cADZ0hLL/3GAhDkFjCXO/DnLDmKLCshIzFj6lXkCo+AsJN2zkHTPQuhewMi8ilEytaA4Nz23
	2LDAKC+1XK84Mbe4NC9dLzk/dxMjOOi1tHYw7ln1Qe8QIxMH4yFGCQ5mJRFe8Q8v04R4UxIr
	q1KL8uOLSnNSiw8xSnOwKInzfnvdmyIkkJ5YkpqdmlqQWgSTZeLglGpgMvH+ZsH/ouT1cdZ7
	/s2Oqi7n2b5cvbyHzWyhJ7c92wmHnX/UNy3Y5fZ56gohlzNfzgYo/Hu/cG7wFx2PjTdW/Mk3
	LVR7KRd116zbevd0R4Ewf95XsU8ePd+l8GdF1vrW8/cU9INMr6nZ+p+wmBTQkXm6J9r43Dv/
	G2eStvmerbsjXCVu2mTcF/BJ6smKk57TT6yQ3/goL1ev29hxbrBkkbIEmztzllaQTbBLRQWf
	30qhDX7KHzTaXOY9r9I681PIrW9K/+q/nNdVFL4tuL/yQ7Py5B+JX94suWixfeni8lWKbb+l
	Qp2s1jzV8Y+af/9ZdZy9b/vyi3xPrv2elOo422WStken8vnHElkHW0KnKbEUZyQaajEXFScC
	AGBOgtTpAgAA
X-CMS-MailID: 20240918064651epcas5p418d61389752da25e5fc50e6a50a111b8
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----BXry2NbAWZo9yJTNih6DAV11S-FgciuNcVifFwRAucM.VCOc=_34c99_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240918064651epcas5p418d61389752da25e5fc50e6a50a111b8
References: <20240705083205.2111277-1-hch@lst.de>
	<yq1ttgz5l6d.fsf@ca-mkp.ca.oracle.com>
	<CGME20240918064651epcas5p418d61389752da25e5fc50e6a50a111b8@epcas5p4.samsung.com>

------BXry2NbAWZo9yJTNih6DAV11S-FgciuNcVifFwRAucM.VCOc=_34c99_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

>
>Another wrinkle is that SCSI does not have a way to directly specify
>which tags to check. You can check guard only, check app+ref only, or
>all three. But you can't just check the ref tag if that's what you want
>to do.

Hi Martin,

When the drive is formatted with type1 integrity and dix is supported,
the block layer would generate/verify the guard and reftag. For scsi,
apptag would also need to be generated/verified as reftag-check can't
be specified alone. But I am not not able to find (in SCSI code) where
exactly: 
1. this apptag is being generated
2. and getting added to the PI buffer and scsi command.

Can you please point to where/how it is handled.

Thank you,
Anuj Gupta

------BXry2NbAWZo9yJTNih6DAV11S-FgciuNcVifFwRAucM.VCOc=_34c99_
Content-Type: text/plain; charset="utf-8"


------BXry2NbAWZo9yJTNih6DAV11S-FgciuNcVifFwRAucM.VCOc=_34c99_--
