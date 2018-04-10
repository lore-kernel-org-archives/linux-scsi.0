From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Tue, 10 Apr 2018 08:35:25 +0200
Message-ID: <3d7b5a707e216e19eb3defe0586bfbc8@natalenko.name>
References: <10360653.ov98egbaqx@natalenko.name>
 <CAGXu5jL8oLV2xvjBVYv_SNXr74LdgpXEmU7K+cLYpD7jh2chgw@mail.gmail.com>
 <CAGXu5j+mVc6O_=GOF3YQmS4QZxeFgVPQtMxNH8sjBAhpJLjm9w@mail.gmail.com>
 <2679696.GDoj5zcZOu@natalenko.name>
 <CAGXu5jLG9ia+zBNcPt+q+BpJayoUuYwXitOgeHmh=7sPp-s87A@mail.gmail.com>
 <51a7e805058ef7f35b226cbbf0ccc4ff@natalenko.name>
 <CAGXu5jKRrdYjuyLSvc4k4mqttkM7zw-96poQ1GYqRRgPqZFOYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jKRrdYjuyLSvc4k4mqttkM7zw-96poQ1GYqRRgPqZFOYQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org, paolo.valente@linaro.org, keescook@google.com
List-Id: linux-scsi@vger.kernel.org

Hi.

09.04.2018 22:30, Kees Cook wrote:
>> echo 1 | tee /sys/block/sd*/queue/nr_requests
> 
> I can't get this below "4".

Oops, yeah. It cannot be less than BLKDEV_MIN_RQ (which is 4), so it is 
enforced explicitly in queue_requests_store(). It is the same for me.

>> echo 1 | tee /sys/block/sd*/device/queue_depth
> 
> I've got this now too.
> Ah! dm-crypt too. I'll see if I can get that added easily to my tests.
> And XFS! You love your corner cases. ;)

Yeah, so far this wonderful configuration has allowed me to uncover a 
bunch of bugs, and see, we are not done yet ;).

> Two other questions, since you can reproduce this easily:
> - does it reproduce _without_ hardened usercopy? (I would assume yes,
> but you'd just not get any warning until the hangs started.) If it
> does reproduce without hardened usercopy, then a new bisect run could
> narrow the search even more.

Looks like it cannot be disabled via kernel cmdline, so I have to 
re-compile the kernel, right? I can certainly do that anyway.

> - does it reproduce with Linus's current tree?

Will try this too.

> What would imply missing locking, yes? Yikes. But I'd expect
> use-after-free or something, or bad data, not having the pointer slip
> forward?

I still think this has something to do with blk-mq re-queuing capability 
and how BFQ implements it, because there are no sings of issue popping 
up with Kyber so far.

> Quick update: I added dm-crypt (with XFS on top) and it hung my system
> almost immediately. I got no warnings at all, though.

Did your system hang on smartctl hammering too? Have you got some stack 
traces to compare with mine ones?

Regards,
   Oleksandr
