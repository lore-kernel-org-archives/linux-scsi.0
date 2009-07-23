From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Regression impacts ServeRAID II on IBM xSeries 5500
Date: Thu, 23 Jul 2009 11:02:10 +0900
Message-ID: <20090723110118N.fujita.tomonori@lab.ntt.co.jp>
References: <4A6172F0.60707@davidnewall.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:35636 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbZGWCCU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jul 2009 22:02:20 -0400
In-Reply-To: <4A6172F0.60707@davidnewall.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: davidn@davidnewall.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

Sorry for the delay,

On Sat, 18 Jul 2009 16:30:00 +0930
David Newall <davidn@davidnewall.com> wrote:

> Hello Fujita-san,
> 
> This is my first time reporting a regression.  I hope I'm doing it right.
> 
> According to "git bisect," your patch
> 10db10d144c0248f285242f79daf6b9de6b00a62 is the first bad commit before
> a regression which affects my ServeRAID II controller.  I get segfault
> running ipssend, which is the program used to interrogate and configure
> the SCSI RAID controller.
> 
>     ipssend[5949]: segfault at 20202020 ip b7ece8b1 sp bfce1d1c error 6 in libc-2.9.so[b7e55000+15c000]

Can I get 'ipssend' source code? I'm not sure what ipssend does (I
guess, it issues some special commands via sg).


> Here's what git output on the final bisect:
> 
>     commit 10db10d144c0248f285242f79daf6b9de6b00a62
>     Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>     Date:   Fri Aug 29 12:32:18 2008 +0200
> 
>         sg: convert the indirect IO path to use the block layer
>         
>         This patch converts the indirect IO path (including mmap IO and old
>         struct sg_header) to use the block layer functions (blk_get_request,
>         blk_execute_rq_nowait, blk_rq_map_user, etc) instead of
>         scsi_execute_async().
>         
>         [Jens: fixed compile error with SCSI logging enabled]
>         
>         Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>         Signed-off-by: Douglas Gilbert <dougg@torque.net>
>         Cc: Mike Christie <michaelc@cs.wisc.edu>
>         Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
>         Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Very sorry about that.


>     :040000 040000 a2b5d80fb0a666b49d4bdfc2de3aa15c9d8b1ec7 84a927a0964a616313deb410a1da60dd22e2dc13 M    drivers
>       
> 
> My machine and assistance is at your disposal.  Rather than guess what
> information you want: what can I tell you?

What kernel version do you use, the latest git tree?
