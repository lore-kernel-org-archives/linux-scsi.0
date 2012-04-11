From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: dramatic I/O slowdown after upgrading 2.6.38->3.0+
Date: Wed, 11 Apr 2012 21:55:39 +0400
Message-ID: <4F85C59B.3090707@msgid.tls.msk.ru>
References: <4F75E46E.2000503@msgid.tls.msk.ru> <20120405232913.GA6640@quack.suse.cz> <4F7E74F4.90604@msgid.tls.msk.ru> <20120410022628.GN18323@dastard> <4F83CC86.2010805@msgid.tls.msk.ru> <20120410151326.GA4936@quack.suse.cz> <4F855173.40902@msgid.tls.msk.ru> <4F85BD2F.80905@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F85BD2F.80905@cs.wisc.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11.04.2012 21:19, Mike Christie wrote:
> On 04/11/2012 04:40 AM, Michael Tokarev wrote:
>> On 10.04.2012 19:13, Jan Kara wrote:
>>>> On Tue 10-04-12 10:00:38, Michael Tokarev wrote:
>> []
>>>>>>   2.6.38:
>>>>>>   # dd if=/dev/sdb of=/dev/null bs=1M iflag=direct count=100
>>>>>>   100+0 records in
>>>>>>   100+0 records out
>>>>>>   104857600 bytes (105 MB) copied, 1.73126 s, 60.6 MB/s
>>>>>>
>>>>>>   3.0:
>>>>>>   # dd if=/dev/sdb of=/dev/null bs=1M iflag=direct count=100
>>>>>>   100+0 records in
>>>>>>   100+0 records out
>>>>>>   104857600 bytes (105 MB) copied, 29.4508 s, 3.6 MB/s
>>>>>>
>>>>>> That's about 20 times difference on direct read from the
>>>>>> same - idle - device!!
>>>>   Huh, that's a huge difference for such a trivial load. So we can rule out
>>>> filesystems, writeback, mm. I also wouldn't think it's IO scheduler but
>>>> you can always check by comparing dd numbers after
>>>>   echo none >/sys/block/sdb/queue/scheduler
> 
> Did you try newer 3.X kernels or just 3.0?

I tried 3.3.1, it shows exactly the same very slow speed
(about 3 MB/sec vs 60 MB/sec).

> We were hitting a similar problem with iscsi. Same workload and it
> started with 2.6.38. I think it turned out to be this issue:
> 
> // thread with issue like what we hit:
> http://thread.gmane.org/gmane.linux.kernel/1244680

This thread refers to buffered I/O as far as I can see.  Note
I especially used iflag=direct of dd to rule out all buffer
operations.  The I/O really is very very slow, the disk is
100% busy all this time (which is also not the situation
described in the thread you referenced above - there, disk
(SSD) does not have enough work to do).

> // Patch that I think fixed issue:
> commit 3deaa7190a8da38453c4fabd9dec7f66d17fff67
> Author: Shaohua Li <shaohua.li@intel.com>
> Date:   Fri Feb 3 15:37:17 2012 -0800
> 
>     readahead: fix pipeline break caused by block plug

I think this patch is included into 3.3 kernel, it was
in 3.3-rc2 if my git-fu is right.  If it is, I tried it
(as 3.3.1) and it didn't help at all.

Thank you!

/mjt
