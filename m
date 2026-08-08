Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846BE2236F2
	for <linux-scsi@vger.kernel.org>; Sat,  8 Aug 2026 01:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786154006; cv=none; b=uCMcdrJmRDjKWVVtrv9kuu1w1WfDvHCZuwb4HJvFByX+f4fXNENMOMA5DuyrUgCNgdlUTbTX5YybWo73ZSS5Ccnk8Kt60whqPr5hUu/6K3wwussNTgPMbZmVZxJ0OU8kO79LJ4wFGyeg+yxnXgOWznnE98GwF2v+GqX8HLW+siU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786154006; c=relaxed/simple;
	bh=OpN3kOYoH8cf5GVSOsmKcqfJSsOf0bNIWJL3NvqNZ+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ondNUxKY3BaNLGmFuzaMR5b3BTIelPK5oOiVxu8NcTvWE6dDfC4uDTkfiP0dhBtPd69+03AdVqK7f5eALJRwJWdzCtfyUxq+8GbuLDTxzYSzFSUnFRvN/btXuS6mPH1kF6TwSQPAGwIVYrGDVJY4jggsTmL+AxIJkoho3TAyVN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ap5no4Kg; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ap5no4Kg"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cfff5f88dbso2600195ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2026 18:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786154005; x=1786758805; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x7YZFmwdcQGmxOFe9p3BYU5NZ4QrL9PPrK4bUz73FC4=;
        b=Ap5no4KgzN6UljEXD2fsao/u0m1pml4fIxbEsy/AccwMHforyS+oDML1c/0cYetHCl
         UOgKIsHZPzh+jeyFh5vHN1a65CPjxOk4r06xMQG3byCewjoR1015Bfs7dNCuVJLVbIzT
         jwRksZSdzqWo4Hn0THb/zo2WB0zQsgTCH0I6rjHprN2LWvOHNkKxQLV0XNfYj1Tj7kPx
         ZgnSKqHTyAXlmD0PpxIdHmANWIbTafxbXqQGLZqkDoN2TfLECVB1EXZ0MWxZGbS4dBmW
         APudqNe2SrYikux2hyf4zVBIilmPPpLuunMKLd+fzcr5AXXlPXhegDhQ2K6w3DifSDzL
         sftA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786154005; x=1786758805;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x7YZFmwdcQGmxOFe9p3BYU5NZ4QrL9PPrK4bUz73FC4=;
        b=L4KMIEMbrkU9HNhzLAJ+WNp9/AGP/JgKppo1d6im1cyeUop5R70WHGXzGf5zMZnmty
         FcDaJLKRmbC2Gs3rx7L2bxgHuMhY+OU8JxBAy3+1zk/pl6HSxBklfu7HUQgNXXMhvRBQ
         pZ3D6jPmqHN5FuYPSuIYRsyDzs689Hg00iXIw4Eg2OHzdSJe6AA84MiApb9m3THOVzCj
         rP1v1m1ZCsEmVNpxOocJxCdLU+oY9oGIEvIt4urx8vzfYznhth3DnFWAUnuA7bDM4dut
         gql5+v7aGYT/ua3yxSvmqRITx+si7VQEeBsO9Q1Xema5XYY4TZBQSyDLpws1J4rjODOw
         pSxQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq1JMl3BCZMw+7XwQ7tHWjKSyMDRkMlkQJqu+wGZv9nlnKt2Of0Ch0deYcmxFd2eehZHiqY2jDVG1gp@vger.kernel.org
X-Gm-Message-State: AOJu0YzAsQPoDoG9T32fZpmxYS4ejWsbduFC6PaJO24opAkClNGR3LvU
	NonFwrFiU4hjKxCKovmXgRVJUZAXwHju/KTpOtrIN2SmLvTBrmno4H/d
X-Gm-Gg: AR+sD11INT0RBVic3juewjluzWEs3jRdQlF/v+02ZkSNhqf53//QlxWDwlTqJNhD5L8
	gAduq+DuuqeOWzMEKeniN4YaImFHC7dWYCaYBkAGDs8yeaFSuQYWFY6N0ec+csEPM1TNQzSXqMu
	kwyUuTb4M5Zy188OTI45FRKz/EvS8J9eCH4ID11jBB2hFykMa+I2xsEkdg0PPOomJ6qmpT77d5S
	S5WAktMJ97+lcSdBcO5ZHgao8nQpvzanKqU5gGxVqisWk4P/GDRvt620Rm5DH6/Xyx+A0PXcT/y
	oIbMrdAAe9EP+QhiKn2GheKQTDW+wTVWEUKeOLMV9fJZ6M4vzZhncPP/0+HCEbdj2QGpom01o2H
	mIR+d+9rhy0qARd/WR+Xj//W1/v5Z/hLSPO0c4l383JQp6uU4eiBGoeYqOEzDgtJNavQiUibjtS
	covMYnSEylayPtjSzOhGxhi3JPoqPRZs0hH4KaE9D8e3o7QHXsJ9YVyA6BpdoFY1inM0+/KU2lg
	hwNzAjMuUJ0Pp1Sjsb7JhAK0ABpBEwqgkO/2LRkylJ/5AY=
X-Received: by 2002:a17:903:1a10:b0:2cc:f5b8:4c2e with SMTP id d9443c01a7336-2d0ca767b88mr362595825ad.9.1786154004863;
        Fri, 07 Aug 2026 18:53:24 -0700 (PDT)
Received: from [10.1.1.100] (222-152-170-159-fibre.sparkbb.co.nz. [222.152.170.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315be86e90asm12706200eec.3.2026.08.07.18.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 18:53:24 -0700 (PDT)
Message-ID: <0631ac45-1908-4ffc-842c-6a6c26096397@gmail.com>
Date: Sat, 8 Aug 2026 13:53:18 +1200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] scsi: core: Drop Scsi_Host.default_lock
To: Finn Thain <fthain@linux-m68k.org>, Russell King <linux@armlinux.org.uk>,
 John Garry <john.g.garry@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, hch@lst.de, John Garry <john.garry@linux.dev>
References: <20260804113436.2373404-1-john.g.garry@oracle.com>
 <efff8e1d-0eb9-47eb-ba20-6bdbeeea15e1@acm.org>
 <7ab3dca8-83f3-4ec7-8bb4-e9c3508a5c59@oracle.com>
 <9a4ed570-5b19-44ca-9d22-41ab37d21014@acm.org>
 <18de6750-7668-4855-b24d-515760a31032@oracle.com>
 <095e7779-6c40-5257-a684-63cc054c0e20@linux-m68k.org>
Content-Language: en-US
From: Michael Schmitz <schmitzmic@gmail.com>
In-Reply-To: <095e7779-6c40-5257-a684-63cc054c0e20@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Finn,

On 06/08/2026 12:35 PM, Finn Thain wrote:
> On Wed, 5 Aug 2026, John Garry wrote:
>
>> On 04/08/2026 21:08, Bart Van Assche wrote:
>>>> Cool, I'll go through this. But how does it handle the arm v3-related
>>>> drivers, like fas216? At a glance, the script requires gnu-
>>>> a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07 - but I thought that HW like
>>>> this requires an even earlier toolchain version.
>>> Correct. I think that gcc-8 or older is required to generate correct
>>> code. But generating correct code is not required to do build testing.
>>> Hence the following hack in my script for 32-bit ARM architectures that
>>> deletes a GCC version check from a Kconfig file:
>>>
>>>         if [ "${arch%-*}" = "arm" ]; then
>>>   # gcc-9 and later do not support armv3m. Hence the sed commands below.
>>>   local f
>>>   for f in arch/arm/Kconfig arch/arm/mach-rpc/Kconfig; do
>>>       if [ -e "$f" ]; then
>>>       	sed -i 's/GCC_VERSION < 90100 && //' "$f"
>>>       fi
>>>   done
>>>   sed -i 's/select CPU_32v3/select CPU_32v4/' arch/arm/mm/Kconfig
>>>         fi
>> ok, I'll try it, thanks!
>>
>> I do have to question why we maintain support on modern kernels for such
>> obsolete HW. The maintenance burden is not zero, as we see here ...
>>
> The non-zero maintenance burden is a two-way street. That's just the
> downside of the "open" part of "open source", of course.
>
> The maintainer for the relevant hardware port is Russell King whom you
> forgot to Cc. But Linux on obsolete hardware is quite normal in my
> experience, and the issue here is actually the compiler.
>
> I'm not going to attempt to fix the compiler. I don't have the talent,
> time, hardware etc. And yet the MAINTAINERS file lists Michael and I as
> maintainers for two RISCPC drivers:
>
> F:      drivers/scsi/arm/cumana_1.c
> F:      drivers/scsi/arm/oak.c
>
> Given the compiler problem, which I too have long had to work around when
> build-testing NCR5380 drivers, and given that I have no ability to test
> this hardware, I'm thinking of sending a patch to shift the responsibility
> for these files from the NCR5380 entry to Russell's RISCPC entry in
> MAINTAINERS.
>
> Russell and Michael -- do you have any thoughts about this issue?

Not wanting to set a precedent, but seeing as Russell may be the only 
maintainer still in a position to build and hopefully test these 
drivers, moving responsibility for driver code to the arch maintainer 
may be justified here.

I must admit I've been dreadfully slack in testing recent code myself, 
ever since I started running out of memory at boot ...

Cheers,

     Michael


