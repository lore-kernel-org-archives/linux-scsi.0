Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5842EAF9
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2025 03:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749614372; cv=none; b=f/+XiidTM1yw0elXfSTbeeiRFAeDnsQaIlOiAExe1Nk6uBuuECytGStUEhwj9LIL+PYj6fMCh79QQzNWfLJaOxxNKkxcbQLV9LUHID7EfIe4k4XAhchwa+YKmcMBhe030XVZXDTvr/oxdedSjGkho7crrRWHPouMm0eTV/iAZwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749614372; c=relaxed/simple;
	bh=E4u1TPOoPhFmOE4ZBbk0rDT7Q0JmD8GGlCsJ7J38Zgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rxC/sWq1rjVK9m5DOXYxrk4R4KyPovdquQLhMF38y/vTOh/yW3ON+G2mIK0wrckoB7ux0UMnmEPv0VJ1tMF6AGvBNrGWvPZteoX6egk0ClCkCVq9YW9idF96CRArKyHhiGrZ4/a8C2gcv2SHtG/HQrDewYzmCEDiDR9uOBlLlQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i6Cz9wTz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i6Cz9wTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B850C4CEEE;
	Wed, 11 Jun 2025 03:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749614372;
	bh=E4u1TPOoPhFmOE4ZBbk0rDT7Q0JmD8GGlCsJ7J38Zgg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i6Cz9wTz8zrg7tr6jLj21fsMw3NYIy1E7j7ut5EUGtil9Cpslv+go/RFra3KVtDFF
	 wdjvzf/9JmTse/gyrBezHVQry5jnNgIAtKwXrFnc9OkEtzYOW22LYtE63Si6ImJ0b1
	 R8dVAAhteH2TrCgo2koAP0ee5qGKWy/iBUh39zwk5QECF84+uzcdCX6zF9hoiDKIMH
	 bO8v4shudU9JwM3y+Kl7IvcdjQY+4oQdPiNa+0qp7MKfQbfz/zROh5qH1lKCeecGdc
	 0Z+GjpEKEeQKWHyTI2qLQzmtXFtD0c8Y8GLVdUt9hkzcOdnQQ3r/v3AqxLoOdwxF+z
	 j13SiWlCTD2ww==
Message-ID: <b46403b6-3eaf-4152-ad2a-c6c5402dfcac@kernel.org>
Date: Wed, 11 Jun 2025 12:57:45 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Improve ATA NCQ command error in mpt3sas and mpi3mr
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
References: <20250606052747.742998-1-dlemoal@kernel.org>
 <aEZ2C93sEiFRzGEE@infradead.org>
 <CALOAHbDmSjaBjG7-yTm4FOxwY-mhR0ea610ZyTb-TPzLZOu2Lw@mail.gmail.com>
 <a177a03c-5545-4211-a401-da15722c2e65@kernel.org>
 <CALOAHbC2nhFN7FR5k+9V6=Bx+b4wpT_XZ8R6U-TPKHFn6tss-A@mail.gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <CALOAHbC2nhFN7FR5k+9V6=Bx+b4wpT_XZ8R6U-TPKHFn6tss-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/11/25 12:27 PM, Yafang Shao wrote:
> On Mon, Jun 9, 2025 at 3:18 PM Damien Le Moal <dlemoal@kernel.org> wrote:
>>
>> On 6/9/25 16:09, Yafang Shao wrote:
>>> On Mon, Jun 9, 2025 at 1:50 PM Christoph Hellwig <hch@infradead.org> wrote:
>>>>
>>>> Adding Yafang Shao <laoar.shao@gmail.com>, who has a test case, which
>>>> I think promted this.
>>
>> Note that cdl-tools test suite has many test cases that do not pass without the
>> mpi3mr patch. CDL makes it easy to trigger the issue.
>>
>>>
>>> Thank you for the information and for addressing this so quickly!
>>>
>>>>
>>>> Yafang, can you check if this makes the writeback errors you're seeing
>>>> go away?
>>>
>>> I’m happy to test the fix and will share the results as soon as I have them.
>>
>> Thanks. And my apologies for forgetting to CC you on these patches.
> 
> We have developed and deployed a hotfix to hundreds of our production
> servers equipped with this drive, and it has been functioning as
> expected so far. We are currently rolling it out to the remaining
> production servers, though the process may take some time to complete.
> 
> Additionally, we encountered a writeback error in the libata driver,
> which appears to be related to DID_TIME_OUT. Do you have any insights
> into this issue?
> 
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#30 FAILED Result:
> hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK cmd_age=31s

No idea. Timeout is hard to debug... A bus trace would help. It could be that
the drives are really bad and taking too long per command, thus causing time
out for commands that are at the end of the queue. E.g., if you hit many bad
sectors with read commands, the drive internal retry mechanism may cause such
read command to take several seconds. So if you are running the drives at high
queue depth, this can easily cause timeouts for the commands that are at the
end of the queue.

> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#30 CDB: Write(16) 8a
> 00 00 00 00 08 2c eb 4a 58 00 00 02 c0 00 00
> [Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 35113355864 op
> 0x1:(WRITE) flags 0x100000 phys_seg 88 prio class 2
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#29 FAILED Result:
> hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK cmd_age=31s
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#29 CDB: Write(16) 8a
> 00 00 00 00 08 2c eb 45 18 00 00 05 40 00 00
> [Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 35113354520 op
> 0x1:(WRITE) flags 0x104000 phys_seg 168 prio class 2
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#28 FAILED Result:
> hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK cmd_age=31s
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#28 CDB: Write(16) 8a
> 00 00 00 00 08 2c eb 42 58 00 00 02 c0 00 00
> [Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 35113353816 op
> 0x1:(WRITE) flags 0x100000 phys_seg 88 prio class 2
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#22 FAILED Result:
> hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK cmd_age=31s
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#22 CDB: Read(16) 88
> 00 00 00 00 03 d8 33 44 18 00 00 02 c0 00 00
> [Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 16512140312 op
> 0x0:(READ) flags 0x80700 phys_seg 88 prio class 2
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#21 FAILED Result:
> hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK cmd_age=31s
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#21 CDB: Read(16) 88
> 00 00 00 00 03 d8 33 3e d8 00 00 05 40 00 00
> [Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 16512138968 op
> 0x0:(READ) flags 0x84700 phys_seg 168 prio class 2
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#20 FAILED Result:
> hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK cmd_age=31s
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#20 CDB: Read(16) 88
> 00 00 00 00 03 d8 33 3c 18 00 00 02 c0 00 00
> [Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 16512138264 op
> 0x0:(READ) flags 0x80700 phys_seg 88 prio class 2
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#19 FAILED Result:
> hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK cmd_age=31s
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#19 CDB: Write(16) 8a
> 00 00 00 00 08 2c eb 3d 18 00 00 05 40 00 00
> [Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 35113352472 op
> 0x1:(WRITE) flags 0x104000 phys_seg 168 prio class 2
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#15 FAILED Result:
> hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK cmd_age=31s
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#15 CDB: Read(16) 88
> 00 00 00 00 03 2c e9 4e b8 00 00 00 98 00 00
> [Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 13638389432 op
> 0x0:(READ) flags 0x80700 phys_seg 19 prio class 2
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#14 FAILED Result:
> hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK cmd_age=31s
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#14 CDB: Read(16) 88
> 00 00 00 00 03 2c e9 4c b8 00 00 02 00 00 00
> [Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 13638388920 op
> 0x0:(READ) flags 0x80700 phys_seg 64 prio class 2
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#13 FAILED Result:
> hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK cmd_age=31s
> [Tue Jun 10 13:27:47 2025] sd 14:0:0:0: [sdl] tag#13 CDB: Read(16) 88
> 00 00 00 00 03 d8 33 36 d8 00 00 05 40 00 00
> [Tue Jun 10 13:27:47 2025] I/O error, dev sdl, sector 16512136920 op
> 0x0:(READ) flags 0x84700 phys_seg 168 prio class 2
> [Tue Jun 10 13:27:47 2025] XFS (sdl): metadata I/O error in
> "xfs_imap_to_bp+0x4f/0x70 [xfs]" at daddr 0x4804c4398 len 32 error 5
> [Tue Jun 10 13:27:48 2025] sdl: writeback error on inode 32213499599,
> offset 0, sector 35113332208
> 


-- 
Damien Le Moal
Western Digital Research
