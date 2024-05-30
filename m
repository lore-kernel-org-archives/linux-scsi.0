Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E262B9A0;
	Thu, 30 May 2024 06:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717050322; cv=none; b=nsE/54J9vJdtS8Rt3LD8OTcKfo6dkhkpyK0XYA67urUvfaynpUQY0oSLx5lWrhcGdPb+zvuMb7KRIlwF2kdrzH3oYA/gKEI6PlC59BzA1rkWDzDp3STdrUkAPvfN66gKf27AvSo5ElnrzPM829JJAwKR3uIIT47p2qn3lYoDiMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717050322; c=relaxed/simple;
	bh=9IThHmHVyLJ5hdbfWH8g62CjCB03Osd1MetLGQEJOvg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=bkdalPF1NFILxsSLg/JVz2chcZthZPgETcCMfxDbO39bxsjLwi7KPIaiac2PTUFUT9264TSBH8qNT690jnTSygJQa464jlUSjdgu6wO9qRVKTQjWi2eN9dU2jFJrC+1NIQPnqtrXA4VAs+xn+2x/NfKiuyyxO+ATpyaffpwPSlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=JhrDJXY6; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="JhrDJXY6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:References:Reply-To:Cc:To:From:Subject:MIME-Version:Date:
	Message-ID:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	In-Reply-To:References; bh=yQt4cMQXQ51kt8CWUHvAJmRopwcLuvZdstpsxz59W6I=;
	t=1717050319; x=1717482319; b=JhrDJXY6AG5kB/8FY1TUBzK7xbismlEWnj2widVQFATUKcQ
	JMzka+BKt187pdtXoZkWl252OZfZ3nqa0+nl8VLWji+zYK2oDTR/9KAwgRdOavEiTunyKZqlLIGtk
	8KtK982EeHxIOrgl2bFh3aZ6zoptk1bpXQx5uVqmy4ODLLie/d55B6eYv2D/EfksDyCIHLE+Efz5v
	z9nLNX1DVH6KoizwPudxk1UAE6ALunUYqjNQt6FjwwjVxMKemaSFUKtp9KBVJobx0p3FgO9ag8RBb
	GMiQJmfAxs1UPwOT/MNZAsYqh++G75IY724gLQlPslMmPBtWhuT2MU+TGvsQvVHA==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1sCZDs-00064g-Tr; Thu, 30 May 2024 08:25:12 +0200
Message-ID: <f96bd990-20d4-4c41-99f4-401b3ab46652@leemhuis.info>
Date: Thu, 30 May 2024 08:25:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/23] scsi: initialize scsi midlayer limits before
 allocating the queue
From: Thorsten Leemhuis <regressions@leemhuis.info>
To: Michael Ellerman <mpe@ellerman.id.au>, Christoph Hellwig <hch@lst.de>
Cc: John Garry <john.g.garry@oracle.com>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org, benh@kernel.crashing.org,
 linuxppc-dev@lists.ozlabs.org, Guenter Roeck <linux@roeck-us.net>,
 Linux kernel regressions list <regressions@lists.linux.dev>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
References: <20240520151536.GA32532@lst.de>
 <fc6a2243-6982-45e9-a640-9d98c29a8f53@leemhuis.info>
Content-Language: en-US, de-DE
In-Reply-To: <fc6a2243-6982-45e9-a640-9d98c29a8f53@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1717050319;22bc69e5;
X-HE-SMSGID: 1sCZDs-00064g-Tr

On 29.05.24 16:36, Linux regression tracking (Thorsten Leemhuis) wrote:
> [CCing the regression list, as it should be in the loop for regressions:
> https://docs.kernel.org/admin-guide/reporting-regressions.html]
> 
> On 20.05.24 17:15, Christoph Hellwig wrote:
>> Adding ben and the linuxppc list.
> 
> Hmm, no reply and no other progress to get this resolved afaics. So lets
> bring Michael into the mix, he might be able to help out.
> 
> BTW TWIMC: a PowerMac G5 user user reported similar symptoms here
> recently: https://bugzilla.kernel.org/show_bug.cgi?id=218858

And yet another report with similar symptoms, this time with a
"PowerMac7,2 PPC970 0x390202 PowerMac":
https://bugzilla.kernel.org/show_bug.cgi?id=218905

Ciao, Thorsten

>> Context: pata_macio initialization now fails as we enforce that the
>> segment size is set properly.
>>
>> On Wed, May 15, 2024 at 04:52:29PM -0700, Guenter Roeck wrote:
>>> pata_macio_common_init() Calling ata_host_activate() with limit 65280
>>> ...
>>> max_segment_size is 65280; PAGE_SIZE is 65536; BLK_MAX_SEGMENT_SIZE is 65536
>>> WARNING: CPU: 0 PID: 12 at block/blk-settings.c:202 blk_validate_limits+0x2d4/0x364
>>> ...
>>>
>>> This is with PPC_BOOK3S_64 which selects a default page size of 64k.
>>
>> Yeah.  Did you actually manage to use pata macio previously?  Or is
>> it just used because it's part of the pmac default config?
>>
>>> Looking at the old code, I think it did what you suggested above,
>>
>>> but assuming that the driver requested a lower limit on purpose that
>>> may not be the best solution.
>>
>>> Never mind, though - I updated my test configuration to explicitly
>>> configure the page size to 4k to work around the problem. With that,
>>> please consider this report a note in case someone hits the problem
>>> on a real system (and sorry for the noise).
>>
>> Yes, the idea behind this change was to catch such errors.  So far
>> most errors have been drivers setting lower limits than what the
>> hardware can actually handle, but I'd love to track this down.
>>
>> If the hardware can't actually handle the lower limit we should
>> probably just fail the probe gracefully with a well comment if
>> statement instead.
