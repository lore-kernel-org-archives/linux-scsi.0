From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sg: retrofit SG_FLAG_Q_AT_TAIL flag
Date: Mon, 22 Mar 2010 17:32:38 +0900
Message-ID: <20100322173159V.fujita.tomonori@lab.ntt.co.jp>
References: <4BA604D8.9090604@panasas.com>
	<4BA65DC1.2020102@interlog.com>
	<4BA72526.9040403@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:60610 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301Ab0CVIdf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Mar 2010 04:33:35 -0400
In-Reply-To: <4BA72526.9040403@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bharrosh@panasas.com
Cc: dgilbert@interlog.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, mh-linux-kernel@loup.net

On Mon, 22 Mar 2010 10:07:02 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 03/21/2010 07:56 PM, Douglas Gilbert wrote:
> > Boaz,
> > Thanks for the review.
> > 
> > Now I decided to check the SG_IO ioctl used directly
> > against block devices and it calls:
> >     blk_execute_rq(q, bd_disk, rq, 0);
> > 
> > The last argument is 'at_head' so it has been queuing
> > at_tail for some time. How is that for compatibility??
> > 
> > That almost suggests there should be a
> >    #define SG_FLAG_Q_AT_HEAD 0x20
> > 
> > added to sg.h to cover all the bases.
> > 
> > Doug Gilbert
> > 
> > 
> 
> OK I dug up the original patch and actually It was the same
> with bsg. See the commit log:
> 
> commit 05378940caf979a8655c18b18a17213dcfa52412
> Author: Boaz Harrosh <bharrosh@panasas.com>
> Date:   Tue Mar 24 12:23:40 2009 +0100
> 
>     bsg: add support for tail queuing
>     
>     Currently inherited from sg.c bsg will submit asynchronous request
>      at the head-of-the-queue, (using "at_head" set in the call to
>      blk_execute_rq_nowait()). This is bad in situation where the queues
>      are full, requests will execute out of order, and can cause
>      starvation of the first submitted requests.
>     
>     The sg_io_v4->flags member is used and a bit is allocated to denote the
>     Q_AT_TAIL. Zero is to queue at_head as before, to be compatible with old
>     code at the write/read path. SG_IO code path behavior was changed so to
>     be the same as write/read behavior. SG_IO was very rarely used and breaking
>     compatibility with it is OK at this stage.
>     
>     sg_io_hdr at sg.h also has a flags member and uses 3 bits from the first
>     nibble and one bit from the last nibble. Even though none of these bits
>     are supported by bsg, The second nibble is allocated for use by bsg. Just
>     in case.
>     
>     Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>     CC: Douglas Gilbert <dgilbert@interlog.com>
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> 
> 
> (See second paragraph)
> So bsg had the same compatibility problem between SG_IO and "write".
> What happened is that I found a nasty bug in bsg's SG_IO, just at the
> same time, which proves that SG_IO was never used, (since it would just
> crash), so I decided that it would be cost-less to just break compatibility
> with some thing that never work, for the sake of simple API sameness.
> 
> I do realize now that I have made it hard for sg and SG_IO to comply to new
> API but retain back compatibility. (Sorry)
> 
> Here is my suggestion:
> - Allocate 2 bits at flags, [mask 0x30]
> - Have an enum for these two flags with this meaning:
>   Q_AT_API_COMPATIBLE = 0,
> 	This means for sg and SG_IO to keep their old behaviour. 
> 	sg.c 		- at_head
> 	SG_IO to device - at_tail
> 	bsg both cases  - it is at_head.
>   Q_AT_TAIL = 1,
> 	This means at_tail for all APIs
>   Q_AT_HEAD = 2,
> 	This means at_head for all APIs
>   Q_AT_RESERVED = 3,
> 	Should not be used
> 
> So this is effectively your idea as well but just elaborated on
> more.
> 
> If we do that I think we should maybe join headers, by moving
> common defines to sg.h and #include sg.h from bsg.h.

I don't see any point of adding this feature to sg with such hacky
flags. Why can't we leave sg alone? Just use bsg for things that sg
aren't designed for.
