From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: WARNING in block layer triggered in 3.17-rc3
Date: Mon, 8 Sep 2014 10:05:54 -0500
Message-ID: <CADT32e+2dctZOmWLCoaKuWH4CiTywe-yVX3DgqjxWxm+4gU26g@mail.gmail.com>
References: <CADT32eLJOd5AuFSkg34gOJx-7GXe3Lz1xNe3SzCBv9U1F1ikbA@mail.gmail.com>
	<Pine.LNX.4.44L0.1409081047420.1433-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1409081047420.1433-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <axboe@kernel.dk>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

So should a request queue be in bypass mode when the device is being detached
and queue is being unregistereed because requests can get queued up?


On Mon, Sep 8, 2014 at 9:51 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sun, 7 Sep 2014, Shirish Pargaonkar wrote:
>
>> I think the problem is, when a gendisk is detached, its request queue
>> is not put in bypass mode
>> cause when it is re-attached, code tries to put it out of bypass mode,
>> hence the warning.
>>
>> So either of these should work, I have not tested it, just coded it up.
>
> I'm pretty sure that both of your solutions are wrong.
>
> Jens and James, it appears the problem is in blk_register_queue().  The
> code does this:
>
>         /*
>          * Initialization must be complete by now.  Finish the initial
>          * bypass from queue allocation.
>          */
>         queue_flag_set_unlocked(QUEUE_FLAG_INIT_DONE, q);
>         blk_queue_bypass_end(q);
>
> This doesn't work well if the queue is unregistered later and then
> registered again -- which is what happens when the sd driver is unbound
> from a device and then bound again.  It looks like the code should be:
>
>         if (!queue_flag_test_and_set(QUEUE_FLAG_INIT_DONE, q))
>                 blk_queue_bypass_end(q);
>
> Do you agree?  If so, I'll send in patch.
>
> Alan Stern
>
