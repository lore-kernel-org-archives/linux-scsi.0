From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/4] block: Allow bdi re-registration
Date: Wed, 08 Mar 2017 15:17:08 -0800
Message-ID: <1489015028.24892.17.camel@HansenPartnership.com>
References: <20170308164834.14302-1-jack@suse.cz>
         <20170308164834.14302-2-jack@suse.cz>
         <20170308225542.GB21117@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58042 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751917AbdCHXRN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2017 18:17:13 -0500
In-Reply-To: <20170308225542.GB21117@htj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Omar Sandoval <osandov@osandov.com>, Arthur Marsh <arthur.marsh@internode.on.net>, linux-scsi@vger.kernel.org

On Wed, 2017-03-08 at 17:55 -0500, Tejun Heo wrote:
> Hello,
> 
> On Wed, Mar 08, 2017 at 05:48:31PM +0100, Jan Kara wrote:
> > @@ -710,6 +710,11 @@ static void cgwb_bdi_destroy(struct
> > backing_dev_info *bdi)
> >  	 */
> >  	atomic_dec(&bdi->usage_cnt);
> >  	wait_event(cgwb_release_wait, !atomic_read(&bdi
> > ->usage_cnt));
> > +	/*
> > +	 * Grab back our reference so that we hold it when @bdi
> > gets
> > +	 * re-registered.
> > +	 */
> > +	atomic_inc(&bdi->usage_cnt);
> 
> So, this is more re-initializing the ref to the initial state so that
> it can be re-used, right?  Maybe ATOMIC_INIT() is a better choice 
> here just to clarify what's going on?

Seconded.  Eventually this is going to get converted to a refcount_t
and it will dump a spurious warning on the 0->1 transition.  We can
avoid that by making this a proper initialization.

James
