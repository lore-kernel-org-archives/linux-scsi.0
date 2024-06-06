Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822D91BDEF
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2024 23:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717715806; cv=none; b=JEzQEzPCDEhIMx7sTaVRAW43GofiCJlg8UozZBb+M7XCcy51ReDAKWpFQxOOy9DuahkRSU94wsPBDSzBgUPthp9hmh8JD9KESLYK33HtI3L9HI/4/PqhSWjsiLr7y76i4vCxqVA1TwgJczW2Ay7yeC62vpu066lzLKcGCrSlVug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717715806; c=relaxed/simple;
	bh=Sfnq36KhFctDaSyVPcRyvlAGyuRDCZNzUFiVHqcKjE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s/CRjoDnwkfeBk4gKzzTdQShEUYSUe3gq/GpQUIC8zvUMlClJNEJQBItvkMz1p4cMIm09OFEapry+NNDe88DYd9Idb7UCHuFiCJhvxBujlUcVhF/iak91ShWW5xsAwuhDhLZN/gx0f15Ww4Ic4efvwNDcjkaunMV0jHC6QXnyqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lX8MgJM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lX8MgJM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A5BC2BD10;
	Thu,  6 Jun 2024 23:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717715806;
	bh=Sfnq36KhFctDaSyVPcRyvlAGyuRDCZNzUFiVHqcKjE8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lX8MgJM/55POHB46vKkWCaD78ctANpcY6I9nL7co1KlX8qDpzsEgFZZJk2nRxVfiA
	 vGDVI/2t5vQoVFdQYRrLlvGpBgydR/cI0Zu1ZFd3GoHKjKvmTqCA4Fyqec62xceAw/
	 RfCZ/yGxThQ9qVFqvD8reg0rX3Gote+kIWxSe4R4K352VHKgNKSyAkZ4fBGpgFX0Gf
	 0HyipwHNtBpiCzJ3gkOkgn+/sqw5UbCm9AO3MUnRfb/Rh477t0M+KgFEFbTENhUYZ/
	 Gamka4cMpFYVvP98+4Tcw12NbaGRlSPgU346mozwTZHHJn7f02wb17+qXdzHXfqzat
	 gMkWZK8ZovPng==
Message-ID: <bff737e3-ce5a-40c8-a447-249b26540930@kernel.org>
Date: Fri, 7 Jun 2024 08:16:43 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: mpi3mr: Fix SATA NCQ priority support
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
References: <20240606054749.55708-1-dlemoal@kernel.org>
 <ZmGB6I1OQ5TZOHAn@infradead.org>
 <a61c0dc6-40f3-4e01-9657-eadbf3a50c99@kernel.org>
 <ZmGs2wZDO9ZTO0s4@infradead.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <ZmGs2wZDO9ZTO0s4@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/24 21:34, Christoph Hellwig wrote:
> On Thu, Jun 06, 2024 at 09:14:46PM +0900, Damien Le Moal wrote:
>> "also" ? your previous point was not about this function ?
> 
> No, about all the attribute boilerplate code.

Yeah. That boilerplate for the 2 drivers differ only with the internal data
structure used to store the cdl_enable boolean. So I guess we could make these
attributes more generic.

Ideally though, we should do something similar to CDL and have scsi layer deal
with that automatically to avoid SAS drivers to have to do that themselves. And
libata also has the same attributes.

I would like to get this fix in ASAP as I am getting reports back from the field
of NCQ priority not working with mpi3mr. I can send a cleanup series for the
attributes on top of this fix later if that is OK with you.

-- 
Damien Le Moal
Western Digital Research

