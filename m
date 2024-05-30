Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C021558B8;
	Thu, 30 May 2024 14:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717079307; cv=none; b=ZoVrDsBl0gcFYlXCZOp09nUCA8edR2krUCg4cZwiQhTKIyqv65xIRLAtTDkhvyKHem7nqDGXh0ciVUq8S1z0kH8OoYwEkJ68FwSfPaGcKTI8WWOU5TwRNJxpPau3JU4NXe0I1g4S3XDdgOFTG6Irhd7DpclAJjtXLYpM2X3cVnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717079307; c=relaxed/simple;
	bh=TepJdMu5Kgqt4hFWQ/knF8KsMyDM2pCe5l3NAhbAlr0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rcJRKpULeaPItAlhIfJQzkbMadeOVDNIXP32MeJ2FKNZYCeYPHobWpaG/+BM7cSp4CgLdV77TUOI4OQ+wTwZ/K14mGPUkaxFIaIkZtcgOpMrf1Qhgje4twQkeYAJ+XEQDqLPF265mqqoykvv9JSgy4g8JK+2rYaSLXJO0Mz2nyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=Gq9AAZ2u; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="Gq9AAZ2u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1717079303;
	bh=TepJdMu5Kgqt4hFWQ/knF8KsMyDM2pCe5l3NAhbAlr0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Gq9AAZ2u93VW1D0x6Na4RcZUHk90fmGkZEWk8KeWCfGT4bL493v8+w0tcTJ9hsRkM
	 4XDO0HcsykkcEpCJdlsHn8IcqCapHKhg3S8aluPMzfsmu2wtre70g04ccbHxsqlKfx
	 C4cqvFpr/umZfy9AnM6SmI/NdUQ+q8oLGNvbALKhHqY83jJI6xkA2LwnPuh21keJ22
	 LlU1LoJ0GcAzcYfDUhR1TB49I6xrk3V6xFU+rqyCAF4HK6bTrCm3nUrys+1upui+ze
	 mXbO3gkQecvwBuSOjmSecncOMEgipu1oC1HgQkrjIy0dSNoyFcs2Z4Z6PLRsNJOq6u
	 x12ptIkbo4bhw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VqpWp35Nwz4wcC;
	Fri, 31 May 2024 00:28:22 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: "Linux regression tracking (Thorsten Leemhuis)" <regressions@leemhuis.info>
Cc: John Garry <john.g.garry@oracle.com>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, Damien Le Moal
 <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org, benh@kernel.crashing.org,
 linuxppc-dev@lists.ozlabs.org, Guenter Roeck <linux@roeck-us.net>,
 Christoph Hellwig <hch@lst.de>, Linux kernel regressions list
 <regressions@lists.linux.dev>
Subject: Re: [PATCH 04/23] scsi: initialize scsi midlayer limits before
 allocating the queue
In-Reply-To: <8734pz4gdh.fsf@mail.lhotse>
References: <20240520151536.GA32532@lst.de>
 <fc6a2243-6982-45e9-a640-9d98c29a8f53@leemhuis.info>
 <8734pz4gdh.fsf@mail.lhotse>
Date: Fri, 31 May 2024 00:28:21 +1000
Message-ID: <87wmnb2x2y.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Michael Ellerman <mpe@ellerman.id.au> writes:
> "Linux regression tracking (Thorsten Leemhuis)" <regressions@leemhuis.info> writes:
>> [CCing the regression list, as it should be in the loop for regressions:
>> https://docs.kernel.org/admin-guide/reporting-regressions.html]
>>
>> On 20.05.24 17:15, Christoph Hellwig wrote:
>>> Adding ben and the linuxppc list.
>>
>> Hmm, no reply and no other progress to get this resolved afaics. So lets
>> bring Michael into the mix, he might be able to help out.
>
> Sorry I didn't see the original forward for some reason.
>
> I haven't seen this on my G5, but it's hard drive is on SATA. I think
> the CDROM is pata_macio, but there isn't a disk in the drive to test
> with.
>
>> BTW TWIMC: a PowerMac G5 user user reported similar symptoms here
>> recently: https://bugzilla.kernel.org/show_bug.cgi?id=218858
>
> AFAICS that report is from a 4K page size kernel (Page orders: ...
> virtual = 12), so there must be something else going on?

No that's wrong. The actual hardware page size is 4K, but
CONFIG_PAGE_SIZE and PAGE_SHIFT etc. is 64K.

So at least for this user the driver used to work with 64K pages, and
now doesn't.

cheers
