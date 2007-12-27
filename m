From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 7/7] sg_ring: convert core ATA code to sg_ring.
Date: Thu, 27 Dec 2007 13:21:39 +0900
Message-ID: <47732853.3010208@gmail.com>
References: <200712191731.26512.rusty@rustcorp.com.au> <200712191838.27363.rusty@rustcorp.com.au> <47721294.7030401@gmail.com> <200712271124.31511.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200712271124.31511.rusty@rustcorp.com.au>
Sender: linux-ide-owner@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Rusty.

Rusty Russell wrote:
> On Wednesday 26 December 2007 19:36:36 Tejun Heo wrote:
>> It would be better to build upon sg chaining as we already have it.  I
>> think it can be made much easier with a bit more safe guards,
>> generalization and some helpers.
> 
>     I did this work to replace sg chaining.  The current chaining code gives 
> us longer sgs, and (if used carefully) the ability to append in some 
> circumstances.  But it's clumsy, and we can do better.  This is my attempt.

Ah.. okay.  That makes sense then.  I fully agree that sg chaining as it
currently stands is pretty ugly to use.  Appending extra entries
requires reserving one extra space in the sg list to be appended to
accommodate the last entry of the original list, which will be used for
chaining now.  Also, it's quite brittle in that information can get out
of sync easily (there's no one API for sg list manipulation, things have
to be done manually).

>     I understand that people are experiencing whiplash from the idea of 
> another change just after the sg chaining changes which have already gone in.  
> 
>     At the very least, I think I'll have to come up with a better transition 
> plan for SCSI drivers, rather than trying to convert them all at once... In 
> theory, sg chaining can be done through the sg ring arrays, but that's pretty 
> horrible.

I don't necessarily think large one time conversion is bad.  They're
necessary at times and make sense when they can increase long term
maintainability of the code.  One thing I'm concerned about is the
mixture of sg chaining and sg ring.  It would be best if we can agree on
conversion plan (or sg chaining extension plan).

Thanks.

-- 
tejun
