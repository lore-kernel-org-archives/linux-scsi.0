From: "James Lamanna" <jlamanna@gmail.com>
Subject: Re: [OOPS] amrestore dies in kmem_cache_free 2.6.16.18 - cannot restore backups!
Date: Sun, 28 May 2006 15:04:20 -0700
Message-ID: <aa4c40ff0605281504w522953f5x63686e898c3a3bc3@mail.gmail.com>
References: <aa4c40ff0605231824j55c998c3oe427dec2404afba0@mail.gmail.com>
	 <Pine.LNX.4.63.0605252224450.4178@kai.makisara.local>
	 <Pine.LNX.4.63.0605271202110.10358@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:53341 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S1750989AbWE1WEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 May 2006 18:04:21 -0400
Received: by py-out-1112.google.com with SMTP id i75so261693pye
        for <linux-scsi@vger.kernel.org>; Sun, 28 May 2006 15:04:20 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.63.0605271202110.10358@kai.makisara.local>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, Bryan Holty <lgeek@frontiernet.net>

On 5/27/06, Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:

[SNIP]

>
>
> Next thing was to patch 2.6.16.18 with the patch at the end: No more
> oopses with any alignment.
>
> James, does this fix your problem ?

Kai-
I'll try and see if I can test this on Tuesday.
I've been traveling for the last few days.

Thanks for your help!

-- James


>
> Kai
>
> --------------------------------8<------------------------------------------
>
> Excerpt from a message from Brian Holty to linux-scsi and linux-kernel on
> Wed, 22 Mar 2006 06:35:39:
>
> ...
> Based on above, I think the most intuitive fix would be the offset addition of
> the first entry to the initialization of nr_pages.
>
> Without this change, for instance, with 4K io's every sg io that is
> dma_aligned for direct io, but not page aligned will cause slab corruption
> and an oops
>
> I am able to run a number of tests with sg that cause the boundary to be
> crossed, and with this fix there is no slab corruption or data corruption.
>
> Thanks Dan, I had been hunting for this for a couple of days!!
>
> Thoughts??
>
> Signed-off-by: Bryan Holty <lgeek@frontiernet.net>
>
>  --- a/drivers/scsi/scsi_lib.c  2006-03-03 13:17:22.000000000 -0600
> +++ b/drivers/scsi/scsi_lib.c   2006-03-22 06:09:09.669599539 -0600
> @@ -368,7 +368,7 @@
>                            int nsegs, unsigned bufflen, gfp_t gfp)
>  {
>         struct request_queue *q = rq->q;
> -       int nr_pages = (bufflen + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +       int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
>         unsigned int data_len = 0, len, bytes, off;
>         struct page *page;
>         struct bio *bio = NULL;
>
