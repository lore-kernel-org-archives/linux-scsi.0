From: Pete Wyckoff <pw@osc.edu>
Subject: Re: bsg locking patches update
Date: Wed, 28 May 2008 10:18:48 -0400
Message-ID: <20080528141848.GA17325@osc.edu>
References: <20080526165318.GA5466@osc.edu> <20080528210048L.tomof@acm.org> <200805281351.m4SDpTIl030554@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:59132 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbYE1OSu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2008 10:18:50 -0400
Content-Disposition: inline
In-Reply-To: <200805281351.m4SDpTIl030554@mbox.iij4u.or.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

fujita.tomonori@lab.ntt.co.jp wrote on Wed, 28 May 2008 22:51 +0900:
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: Re: bsg locking patches update
> Date: Wed, 28 May 2008 21:00:56 +0900
> 
> > On Mon, 26 May 2008 12:53:18 -0400
> > Pete Wyckoff <pw@osc.edu> wrote:
> > 
> > > I finally got around to testing the set of lifetime management
> > > fixes you applied.  This is 2.6.26-rc3 with some varlen, bidi,
> > > iser patches, and iovec on bsg, but nothing that should affect
> > > the locking.
> > > 
> > > I can confirm that the first two of these three old bugs are
> > > no longer reproducable:
> > > 
> > >     http://marc.info/?l=linux-scsi&m=120508166505141&w=2
> > >     http://marc.info/?l=linux-scsi&m=120508177905365&w=2
> > >     http://marc.info/?l=linux-scsi&m=120508178005376&w=2
> > > 
> > > Thanks!  The third, however, is a hang that still can happen.  But
> > > it is very obscure and requires a bit of timing to get right.  As a
> > > reminder, here's the setup, and updated traces.
> > 
> > Ah, sorry about it. I didn't understand the third correctly.
> > 
> > 
> > > Maybe it is necessary to split up that bsg_mutex to use multiple
> > > finer-grained locks.
> > 
> > We could but we use bsg_mutex to protect bsg_device_list and idr. So I
> > think that we don't need hold bsg_mutex during
> > bsg_complete_all_commands. How about this?
> 
> On second thoughts, I realized that the previous patch leads to a race
> between bsg_put_device and __bsg_get_device (__bsg_get_device possibly
> finds a device that is being removed). Here's new one.

Looks good.  I can't see any problems with this approach.  And it
tests okay in my problem scenario, on top of 2.6.26-rc4.  You can
add my tested-by and submit as a bug fix to .26 safely, I think.
Thanks again!

		-- Pete

> diff --git a/block/bsg.c b/block/bsg.c
> index f0b7cd3..7cdec32 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -724,8 +724,13 @@ static int bsg_put_device(struct bsg_device *bd)
>  	mutex_lock(&bsg_mutex);
>  
>  	do_free = atomic_dec_and_test(&bd->ref_count);
> -	if (!do_free)
> +	if (!do_free) {
> +		mutex_unlock(&bsg_mutex);
>  		goto out;
> +	}
> +
> +	hlist_del(&bd->dev_list);
> +	mutex_unlock(&bsg_mutex);
>  
>  	dprintk("%s: tearing down\n", bd->name);
>  
> @@ -741,10 +746,8 @@ static int bsg_put_device(struct bsg_device *bd)
>  	 */
>  	ret = bsg_complete_all_commands(bd);
>  
> -	hlist_del(&bd->dev_list);
>  	kfree(bd);
>  out:
> -	mutex_unlock(&bsg_mutex);
>  	kref_put(&q->bsg_dev.ref, bsg_kref_release_function);
>  	if (do_free)
>  		blk_put_queue(q);
> 
