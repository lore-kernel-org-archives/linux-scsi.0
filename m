From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/2] [RFC] block: replace BKL with global mutex
Date: Thu, 15 Apr 2010 09:15:40 -0400
Message-ID: <4BC7117C.7090208@interlog.com>
References: <1271277384-7627-1-git-send-email-arnd@arndb.de> <4BC64633.6010407@interlog.com> <201004150911.45842.arnd@arndb.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201004150911.45842.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Martin K. Petersen" <martin.petersen@oracle.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kai Makisara <Kai.Makisara@kolumbus.fi>
List-Id: linux-scsi@vger.kernel.org

Arnd Bergmann wrote:
> On Thursday 15 April 2010 00:48:19 Douglas Gilbert wrote:
> 
>>> @@ -1322,7 +1331,8 @@ static const struct file_operations sg_fops = {
>>>  	.read = sg_read,
>>>  	.write = sg_write,
>>>  	.poll = sg_poll,
>>> -	.ioctl = sg_ioctl,
>>> +	.llseek = generic_file_llseek,
>> The sg driver has no seek semantics on its read() and
>> write() calls. And sg_open() calls nonseekable_open(). So
>>      .llseek = no_llseek,
>> seems more appropriate.
> 
> Ok, I missed the nonseekable_open here and assumed someone
> might be calling seek on it. I'll use no_llseek then, or
> just leave it alone.
> 
>>> +	.unlocked_ioctl = sg_unlocked_ioctl,
>>>  #ifdef CONFIG_COMPAT
>>>  	.compat_ioctl = sg_compat_ioctl,
>>>  #endif
>> And I just checked st.c (SCSI tape driver) and it calls
>> lock_kernel() .
> 
> Ah, good point. So even if the st driver does not need
> any locking against the block layer, it might need to
> lock its ioctl against sg.

At the level of SCSI commands, tape device state assumptions
made by the st driver could be compromised by SCSI commands
sent by the sg driver. However the BKL was never meant
to address that concern.

 From the comment in st_open() [st.c] it would be using
nonseekable_open() as well but there are apps out there
that do lseek()s on its file descriptors. Not sure
how long nonseekable_open() has been in the sg driver
but no-one has complained to me about it.

> The most simple solution for this would be to let sg
> take both blkdev_mutex and the BKL, which of course
> feels like a step backwards.
> 
> A better way is to get rid of the BKL in sg, which requires
> a better understanding of what it's actually protecting.
> It only gets it in the open and ioctl functions, which is a
> result of the pushdown from the respective file operations.
> Chances are that it's not needed at all, but that's really
> hard to tell. Can you shed some more light on this?

The BKL is not used to protect any of the internal
objects within the sg driver. From memory it was added
in some large code sweep through, not unlike what you
are proposing now.

So I would not be concerned about any kernel locking
interactions between the sg and st drivers. I have
added Kai Makisara (st maintainer) to the cc list.

Doug Gilbert
