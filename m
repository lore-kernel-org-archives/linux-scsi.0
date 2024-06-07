Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01458DDC9;
	Fri,  7 Jun 2024 03:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717729835; cv=none; b=ZZVMeiYZCVSCZpFmtrMT1levWnBo+KedIxjKY/PBwaPJyaXDSCiyKAS3GF8M74LgVJMPHd52zvCZgjZ0ZtpEyewCV0+nmBmTaZe9TjPkYOc5CXbuc6HGNMboHpOGWDFckw/eEr+gxzJ2LsaR0CKogWh8J6t7x02FrVwT0afpZd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717729835; c=relaxed/simple;
	bh=KBYXw1WdE0b2j8hw4gwU5u0YhldC95Lt4Kb/R5RmV4w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=oOl9ytkrQMOcODut/FLHfBHh54WnxSxgo+z63yRXc5vA+Mlcecm/+GHiF/wjBF7EvPY1NCxJAvWLhvoLXYaN1Ttt/kmJNvl1xMzPt61azLbx/xExCyvtofwPpROdz81+dXX4hpfq7xH3e9TerC43WQlSazqlq5DXmgqZzjFpbpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=a+lPQnr+; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="a+lPQnr+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1717729830;
	bh=9lFwEx/JP+T+tWQXbEOOpWSpvQQLktCyT0QZNUBEBwk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=a+lPQnr+Hnyw9k4PYjdItxkPOKkzpbq1xDGrmf9objw3RJOsGfDNkk6kSXDnqMZAa
	 JnknCa8WBXOCOPeF6PLMjiqipv2f8aEyttcN+W/h4CKUL6DmOfx/m+uaUzFkhIxrr/
	 Q/2ZJZeD3PTtuw48WIFqfGAv7imifCi9XSNcA1Xaphf3B/szumvFTpkUjZoAeasVju
	 Np++rhcJmzGs6m/QnGKZs9p7yuarwU8jTd2NmBsa0MARAmElxFYUmx0feSgupgFiO7
	 8ArAOcVNEMjnJMXXKdD1ryHmh3JFwOp+KSgzF5E+b0md7so63XmiCVjvXKBFhCqYsE
	 gS6Efuir3IqzA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4VwR5w0Q8qz4wc8;
	Fri,  7 Jun 2024 13:10:28 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Niklas Cassel <cassel@kernel.org>
Cc: martin.petersen@oracle.com, dlemoal@kernel.org, hch@lst.de,
 john.g.garry@oracle.com, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 regressions@lists.linux.dev, doru.iorgulescu1@gmail.com
Subject: Re: [PATCH] ata: pata_macio: Fix max_segment_size with PAGE_SIZE ==
 64K
In-Reply-To: <ZmG0TUiw0Nagwroj@ryzen.lan>
References: <20240606111445.400001-1-mpe@ellerman.id.au>
 <ZmG0TUiw0Nagwroj@ryzen.lan>
Date: Fri, 07 Jun 2024 13:10:25 +1000
Message-ID: <87ikylphwe.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Niklas Cassel <cassel@kernel.org> writes:
> On Thu, Jun 06, 2024 at 09:14:45PM +1000, Michael Ellerman wrote:
>> The pata_macio driver advertises a max_segment_size of 0xff00, because
>> the hardware doesn't cope with requests >= 64K.
>> 
>> However the SCSI core requires max_segment_size to be at least
>> PAGE_SIZE, which is a problem for pata_macio when the kernel is built
>> with 64K pages.
>> 
>> In older kernels the SCSI core would just increase the segment size to
>> be equal to PAGE_SIZE, however since the commit tagged below it causes a
>> warning and the device fails to probe:
>> 
>>   WARNING: CPU: 0 PID: 26 at block/blk-settings.c:202 .blk_validate_limits+0x2f8/0x35c
>>   CPU: 0 PID: 26 Comm: kworker/u4:1 Not tainted 6.10.0-rc1 #1
>>   Hardware name: PowerMac7,2 PPC970 0x390202 PowerMac
>>   ...
>>   NIP .blk_validate_limits+0x2f8/0x35c
>>   LR  .blk_alloc_queue+0xc0/0x2f8
>>   Call Trace:
>>     .blk_alloc_queue+0xc0/0x2f8
>>     .blk_mq_alloc_queue+0x60/0xf8
>>     .scsi_alloc_sdev+0x208/0x3c0
>>     .scsi_probe_and_add_lun+0x314/0x52c
>>     .__scsi_add_device+0x170/0x1a4
>>     .ata_scsi_scan_host+0x2bc/0x3e4
>>     .async_port_probe+0x6c/0xa0
>>     .async_run_entry_fn+0x60/0x1bc
>>     .process_one_work+0x228/0x510
>>     .worker_thread+0x360/0x530
>>     .kthread+0x134/0x13c
>>     .start_kernel_thread+0x10/0x14
>>   ...
>>   scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
>> 
>> Although the hardware can't cope with a 64K segment, the driver
>> already deals with that internally by splitting large requests in
>> pata_macio_qc_prep(). That is how the driver has managed to function
>> until now on 64K kernels.
>> 
>> So fix the driver to advertise a max_segment_size of 64K, which avoids
>> the warning and keeps the SCSI core happy.
>> 
>> Fixes: afd53a3d8528 ("scsi: core: Initialize scsi midlayer limits before allocating the queue")
>> Reported-by: Guenter Roeck <linux@roeck-us.net>
>> Closes: https://lore.kernel.org/all/ce2bf6af-4382-4fe1-b392-cc6829f5ceb2@roeck-us.net/
>> Reported-by: Doru Iorgulescu <doru.iorgulescu1@gmail.com>
>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218858
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>
> Applied to libata/for-6.10-fixes:
> https://git.kernel.org/pub/scm/linux/kernel/git/libata/linux.git/log/?h=for-6.10-fixes
>
> With John's Reviewed-by from the other thread:
> https://lore.kernel.org/linux-ide/171362345502.571343.9746199181827642774.b4-ty@oracle.com/T/#t

Thanks.

cheers
