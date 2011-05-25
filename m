From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:  __elv_add_request
 OOPS]
Date: Wed, 25 May 2011 21:17:42 +0200
Message-ID: <4DDD55D6.1080909@fusionio.com>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com> <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty> <4DDCB1C8.7040708@fusionio.com> <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty> <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com> <4DDD5240.2060308@fusionio.com> <BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2011-05-25 21:13, Linus Torvalds wrote:
> On Wed, May 25, 2011 at 12:02 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>
>> This is before you get that far, it's actually oopsing on inserting the
>> request on sdev->sdev_queue that is now NULL. The prep state checking
>> happens when sr/sd pulls the request off the queue for processing.
> 
> Ok, please just add a "sdev_alive(sdev)" helper that checks for sdev
> && sdev->sdev_queue. Apparently the issue isn't "this device is
> SDEV_DEL, so don't send commands". Apparently the issue is literally
> "don't oops".

Yep, will do.

> Or maybe the prep state checking could be moved earlier. It seems
> stupid to have a "can I do this command" function that is run too late
> to actually catch the problems..

I don't think we can move it earlier, we essentially have to do the
check at both ends. The "normal" IO path would see that the queue is
dead and error the IO, but this is an internal setup that sets up the
request and then adds it to the stored queue pointer. So it needs to
check this state one way or the other. I think the above fix with the
sdev_alive() will be good enough.

-- 
Jens Axboe
