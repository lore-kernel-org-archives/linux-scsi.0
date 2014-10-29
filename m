From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-mq problem on proliant DL380 G3 (cciss)
Date: Wed, 29 Oct 2014 09:08:46 -0600
Message-ID: <545102FE.3010003@kernel.dk>
References: <alpine.LRH.2.11.1410291233090.12885@adalberg.ut.ee> <alpine.LRH.2.11.1410291344220.12885@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43095 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbaJ2PIt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2014 11:08:49 -0400
Received: by mail-pa0-f50.google.com with SMTP id eu11so3384350pac.9
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2014 08:08:49 -0700 (PDT)
In-Reply-To: <alpine.LRH.2.11.1410291344220.12885@adalberg.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On 2014-10-29 05:46, Meelis Roos wrote:
>> I tried 3.18-rc2 with blk-mq default on on HP ProLiant DL380 G3 (with HP
>> CCISS RAID controller). It fails late in the bootup with "task
>> scsi_eh_1:720 blocked for more than 120 seconds." messages.
>>
>> Booting with scsi_mod.use_blk_mq=0 fixes the problem.
>
> Another test server with MPT SCSI RAID has similar problem,
> scsi_mode.use_blk_mq=0 cures it but I can not get good trace (no serail
> console). 3.18.0-rc2-00043-gf7e87a4 was tested there.

The first issue looks like scsi cdrom and error handling, it must be 
leaking requests hence we hang on allocation of a new one. cciss doesn't 
use blk_mq regardless of the scsi setting. Does the mpt box also have a 
libata driven cdrom?

-- 
Jens Axboe

