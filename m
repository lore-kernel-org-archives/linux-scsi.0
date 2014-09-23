From: Jens Axboe <axboe@kernel.dk>
Subject: Re: boot stall regression due to blk-mq: use percpu_ref for mq usage
 count
Date: Tue, 23 Sep 2014 09:49:31 -0600
Message-ID: <5421968B.7080309@kernel.dk>
References: <20140919113815.GA10791@lst.de> <541C8047.80705@kernel.dk> <20140923055554.GA10189@lst.de> <20140923055648.GD11740@mtj.dyndns.org> <20140923055924.GA10295@lst.de> <20140923060141.GF11740@mtj.dyndns.org> <20140923060906.GA10547@lst.de> <20140923061152.GI11740@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35059 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbaIWPtf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Sep 2014 11:49:35 -0400
Received: by mail-pa0-f51.google.com with SMTP id eu11so5092917pac.24
        for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2014 08:49:34 -0700 (PDT)
In-Reply-To: <20140923061152.GI11740@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 09/23/2014 12:11 AM, Tejun Heo wrote:
> On Tue, Sep 23, 2014 at 08:09:06AM +0200, Christoph Hellwig wrote:
>> On Tue, Sep 23, 2014 at 02:01:41AM -0400, Tejun Heo wrote:
>>> On Tue, Sep 23, 2014 at 07:59:24AM +0200, Christoph Hellwig wrote:
>>>> "[PATCHSET percpu/for-3.18] percpu_ref: implement switch_to_atomic/percpu()"
>>>>
>>>> looks way to big for 3.17, and the regression was introduced in the 3.17
>>>> merge window.  I'm not sure what was broken before, but it defintively
>>>> survived a lot of testing.
>>>
>>> Do we even care about fixing it for 3.17?  scsi-mq isn't enabled by
>>> default even for 3.18.  The open-coded percpu ref thing was subtly
>>> broken there.  It'd be difficult to trigger but I'm fairly sure it'd
>>> crap out in the wild once in a blue moon.
>>
>> It's compiled in by default, and people are extremly eager to test it.
> 
> Ugh, I don't know.  It's not like we have a very good baseline we can
> go back to and reverting it for -stable and then redoing it seems
> kinda excessive for a yet experimental feature.  Jens?

It's not just scsi-mq, there are active users of blk-mq in the current
tree - like virtio_blk, mtip32xx. None of those are affected by the RCU
slowdown due to these changes, so it's not a big deal to them. But it is
a big deal if we can't tell people to test scsi-mq in 3.17, that was the
entire point of having it there but not default to on. So yeah, this
really should be fixed for 3.17.

I'm not aware of any reports on the existing enter count breaking things
for them. So while it may not be perfect, reverting the percpu ref count
changes for 3.17 may be the best option that we have.

-- 
Jens Axboe

