From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-mq problem on proliant DL380 G3 (cciss)
Date: Sun, 02 Nov 2014 18:23:51 -0700
Message-ID: <5456D927.7040403@kernel.dk>
References: <alpine.LRH.2.11.1410291233090.12885@adalberg.ut.ee> <alpine.LRH.2.11.1410291344220.12885@adalberg.ut.ee> <545102FE.3010003@kernel.dk> <20141029183828.GA31689@infradead.org> <alpine.LRH.2.11.1410292205060.16678@adalberg.ut.ee> <54514A7A.8050008@kernel.dk> <alpine.LRH.2.11.1410301317340.19899@adalberg.ut.ee> <20141030151955.GA12158@infradead.org> <alpine.LRH.2.11.1410301916490.13541@adalberg.ut.ee> <20141030174536.GA27799@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34353 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaKCBXy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Nov 2014 20:23:54 -0500
Received: by mail-pd0-f182.google.com with SMTP id fp1so10640188pdb.27
        for <linux-scsi@vger.kernel.org>; Sun, 02 Nov 2014 17:23:53 -0800 (PST)
In-Reply-To: <20141030174536.GA27799@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Meelis Roos <mroos@linux.ee>
Cc: linux-scsi@vger.kernel.org

On 2014-10-30 11:45, Christoph Hellwig wrote:
> On Thu, Oct 30, 2014 at 07:32:52PM +0200, Meelis Roos wrote:
>>> can you try the patch below?  It's a hack and not a proper fix, but it
>>> addresses what seems to be your culprit, given that it is the only
>>> place allocating a request from the error handler.
>>
>> Applied it on top of 3.18-rc2, booted with scsi_mod.use_blk_mq=1 and it
>> booted up fine.
>
> Jens,
>
> any idea what we could do here?  We want to lock the door again ASAP
> after potentially resetting the device state as far as I can read
> the code (the commit message for it is utterly meaningless).
>
> Right now the code allocates the request from the scsi EH thread, which
> already is dangerous but mostly works for the !blk-mq case, but with the
> strict only allocate a request if a tag is available policy this breaks
> down if we still have BLOCK_PC requests that have references on them
> blocking another request queued (ATA cdroms tend to have a queue depth
> of 1).
>
> Given that this always was best effort anyway we might want to move it
> to a separate workqueue to not block EH?

So what we usually do for tagged devices that need some command for 
error handling etc, is to have one tag reserved. The lock/unlock should 
probably be using a reserved request, given how it is invoked as error 
handling. Right now we don't reserve a tag for untagged things like PATA 
cdrom, but we could, since they don't care about the tag anyway. And if 
we had that and reserved grab in the scsi_eh_lock_door(), it should just 
work.

-- 
Jens Axboe

