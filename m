Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B5325F96D
	for <linux-scsi@vger.kernel.org>; Fri, 12 Dec 2025 22:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765579827; cv=none; b=ff2hXYYfjj35EPb3YeKz69sF1iE+d51Vsxu/UpwMWJU1r7QJvD5SYOmU0SvlUpmtaOBh0sP/QDX2shtob5eNiJFYLiEhRLpVb+TJUKKAqPp/6WeC9jzb5vzW+mW7nvdeVs/oujkeGep5fT1ZX5TxJJDjLvsFSqlw5Ajxdj+dNa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765579827; c=relaxed/simple;
	bh=D1FbNq/kwDmYYBhwlsLtJ7U0v8TcQSDF5pYSX4v/NIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BTiL+Rg3c2BU8wzzOFwELAWy7SfXjA3ZcnAzbXPhU4OzN42xopFREPuP+2Co8UdJ4AawmecnClGwjCGOT/424axZgKuB+J9QqBIeweoK7Qj85XqQ5ol8RgK9HEe1HkkE35C5XZUjGY859K1/ghk2zCbtwO9bfaLQpEH/93d6n0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=k+WdgA6D; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="k+WdgA6D"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dSl616tTrz1XM6JZ;
	Fri, 12 Dec 2025 22:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1765579816; x=1768171817; bh=Tabj0XqnCnF4X1wDV293Bwoi
	nFbvvvOImIogviKykPo=; b=k+WdgA6DXV3DDxAaLPtHrvaJbX0FgJCS8o0hUxq8
	H6ZRgleKXTFuztazcZBhO8h2fm1QfObBwTEX2Uk5L034+T+tWeItJ+xbyrEL5UCp
	93FTms9VAV8AEnUPcDIKTG4qtxzAm1xxD/LEMScApCSn6NfWY2Di/BNDjoKEKu+x
	rSdXaQa/Thkqm4Y6RelLfQ0cSWV6Tlma55RpHjhrblk1Qcd4dc/YL1ziXFCAskaX
	s0WZhjY2BmFlPywVZ8eRmorqI9dtiqGUI2IRqtKTgU1d3Q7S+geoMzgrOCNHvFvV
	4t3RorEkZ6OQ3xLgywq+fdsYksT/VRSEjgDJ7I5cST0VJw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FXg1hxuqlrzd; Fri, 12 Dec 2025 22:50:16 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dSl5z4Gvxz1XM31H;
	Fri, 12 Dec 2025 22:50:15 +0000 (UTC)
Message-ID: <e7d257d7-e000-4cad-b82c-df2018c50b08@acm.org>
Date: Fri, 12 Dec 2025 14:50:14 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Remove the alignment check in
 ufshcd_memory_alloc()
To: Shawn Lin <shawn.lin@rock-chips.com>,
 Avri Altman <Avri.Altman@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <1764122900-30868-1-git-send-email-shawn.lin@rock-chips.com>
 <DS1PR16MB675374C98979E25FF23177E9E5DEA@DS1PR16MB6753.namprd16.prod.outlook.com>
 <91ef4f89-8f8e-4d55-a2bf-bf3e381f63c2@rock-chips.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <91ef4f89-8f8e-4d55-a2bf-bf3e381f63c2@rock-chips.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 11/25/25 11:51 PM, Shawn Lin wrote:
> =E5=9C=A8 2025/11/26 =E6=98=9F=E6=9C=9F=E4=B8=89 14:05, Avri Altman =E5=
=86=99=E9=81=93:
>>> The dmam_alloc_coherent() function guarantees page-aligned memory on
>>> successful allocation. The current alignment checks using WARN_ON()=20
>>> for buffers
>>> smaller than PAGE_SIZE are therefore redundant and can be safely=20
>>> removed to
>>> simplify the code.
>> The commit that introduced those checks (339aa1221872) for sizes !=3D=20
>> PAGE_SIZE explained:
>> "...
>> =C2=A0=C2=A0=C2=A0=C2=A0 In the case where these allocations are servi=
ced by e.g. the Arm=20
>> SMMU, the
>> =C2=A0=C2=A0=C2=A0=C2=A0 size and alignment will be determined by its =
supported page=20
>> sizes. In most
>> =C2=A0=C2=A0=C2=A0=C2=A0 cases SZ_4K and a few larger sizes are availa=
ble.
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 In the typical configuration this does not ca=
use problems, but in=20
>> the event
>> =C2=A0=C2=A0=C2=A0=C2=A0 that the system PAGE_SIZE is increased beyond=
 4k, it's no longer=20
>> reasonable
>> =C2=A0=C2=A0=C2=A0=C2=A0 to expect that the allocation will be PAGE_SI=
ZE aligned.
>> ..."
>>
>=20
> Thanks for pointing this out. But I'm thinking the commit message might=
=20
> not be correct.

Probably ...
> Without IOMMU/SMMU support, the allocation must be PAGE_SIZE aligned.
> With IOMMU/SMMU support, the returned address is IOVA, it should be
> the MMU page size aligned. Isn't it always be at least 1K aligned?
>=20
> So, what does "the system PAGE_SIZE is increased beyond 4k...." mean
> regarding to this? The only possble way I see here is the MMU used
> with a e.g, 512B page size, so the returned adress could be 512B
> aligned, which couldn't fit for UTRDL. But is that possible? I doubt, o=
r
> maybe I am missing something, please correct me.

 From Documentation/core-api/dma-api-howto.rst:
"The CPU virtual address and the DMA address are both
guaranteed to be aligned to the smallest PAGE_SIZE order which
is greater than or equal to the requested size.  This invariant
exists (for example) to guarantee that if you allocate a chunk
which is smaller than or equal to 64 kilobytes, the extent of the
buffer you receive will not cross a 64K boundary."

I don't see the MMU mapping size being mentioned in that documentation.
Hence, I think that Shawn's patch is fine.

Bart.
