Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F0715920F;
	Wed, 29 May 2024 14:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716993427; cv=none; b=VGnLlTNt6wLweVPpdamdVs2caNs3YpcjJwVDxWLCJSw19p5lyYmqXG9ytYSjYVkBZvQnGx6ZXVvCIuDhg6745N+5EC0u2gWIvnseYSyEY3n3u0E3m1KlrTGVNDII5cNqDjErjaSZ4blHGbH0SVCZnucGdtJWd3RvYa8iGxgfTzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716993427; c=relaxed/simple;
	bh=pYrTtkOBQOYeyXCIy27DWA6GTTCSA3OpaXyqB8Pa86U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fSO45P+nKBPEIblN4wWRroYLI09EQQ4AnaCyv0bqDVnzdqPoy5YpuVlCrfXhQkC7WuXOpn5/pLCriYDiaN0jmkJcRN/jhQ5Y9WGgUYpXzmTkjmPp+P3Ufi8op1T3GLv9J2JKH0dCKasiH3N9Y0xEA4B8Bvgg+MQkzdKEYhLq94E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=ZveWQ6Dr; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="ZveWQ6Dr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:Reply-To:MIME-Version:Date:
	Message-ID:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	In-Reply-To:References; bh=B7XB8qUIcTmB1ehnipB+Kf3z1BPRYE36ZBSUE8NS1go=;
	t=1716993425; x=1717425425; b=ZveWQ6Dr3LUYuVdUNOPo0tAZkO5ChVyME/VbLMP1uqSiRaE
	yzbEOROreEYOY8mROeCiqHYK/bj/Zrtbeb66pNlA15L0rCy5o1xhVFuTkEzifskJhrzOhg3Aat1/x
	JHFkgSCVLfdWVLAVgq1eMHiE4tki9j15sZGcGfe9pckoXaURMBFNnODVdNP29WAH8L8BFf4S2BfvE
	3+pGS1l0eqgUsTjU6ga2iIPLjOIZfYgKFkHogihuqkeuYcHkUKhHc9r51fRhRWU9whiw4WMxtmzQa
	NgIISdJBWUeB/D5ALf/lnvaEEbuMKfGQyk7lQaVoN8XbMg3ZcerYk2RxItMp2Pig==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1sCKQF-0003Dv-Nj; Wed, 29 May 2024 16:36:59 +0200
Message-ID: <fc6a2243-6982-45e9-a640-9d98c29a8f53@leemhuis.info>
Date: Wed, 29 May 2024 16:36:58 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [PATCH 04/23] scsi: initialize scsi midlayer limits before
 allocating the queue
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: John Garry <john.g.garry@oracle.com>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org, benh@kernel.crashing.org,
 linuxppc-dev@lists.ozlabs.org, Guenter Roeck <linux@roeck-us.net>,
 Christoph Hellwig <hch@lst.de>,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <20240520151536.GA32532@lst.de>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Content-Language: en-US, de-DE
In-Reply-To: <20240520151536.GA32532@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1716993425;08490132;
X-HE-SMSGID: 1sCKQF-0003Dv-Nj

[CCing the regression list, as it should be in the loop for regressions:
https://docs.kernel.org/admin-guide/reporting-regressions.html]

On 20.05.24 17:15, Christoph Hellwig wrote:
> Adding ben and the linuxppc list.

Hmm, no reply and no other progress to get this resolved afaics. So lets
bring Michael into the mix, he might be able to help out.

BTW TWIMC: a PowerMac G5 user user reported similar symptoms here
recently: https://bugzilla.kernel.org/show_bug.cgi?id=218858

Ciao, Thorsten

> Context: pata_macio initialization now fails as we enforce that the
> segment size is set properly.
> 
> On Wed, May 15, 2024 at 04:52:29PM -0700, Guenter Roeck wrote:
>> pata_macio_common_init() Calling ata_host_activate() with limit 65280
>> ...
>> max_segment_size is 65280; PAGE_SIZE is 65536; BLK_MAX_SEGMENT_SIZE is 65536
>> WARNING: CPU: 0 PID: 12 at block/blk-settings.c:202 blk_validate_limits+0x2d4/0x364
>> ...
>>
>> This is with PPC_BOOK3S_64 which selects a default page size of 64k.
> 
> Yeah.  Did you actually manage to use pata macio previously?  Or is
> it just used because it's part of the pmac default config?
> 
>> Looking at the old code, I think it did what you suggested above,
> 
>> but assuming that the driver requested a lower limit on purpose that
>> may not be the best solution.
> 
>> Never mind, though - I updated my test configuration to explicitly
>> configure the page size to 4k to work around the problem. With that,
>> please consider this report a note in case someone hits the problem
>> on a real system (and sorry for the noise).
> 
> Yes, the idea behind this change was to catch such errors.  So far
> most errors have been drivers setting lower limits than what the
> hardware can actually handle, but I'd love to track this down.
> 
> If the hardware can't actually handle the lower limit we should
> probably just fail the probe gracefully with a well comment if
> statement instead.
