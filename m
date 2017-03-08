From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/4] block: Allow bdi re-registration
Date: Wed, 8 Mar 2017 17:55:42 -0500
Message-ID: <20170308225542.GB21117@htj.duckdns.org>
References: <20170308164834.14302-1-jack@suse.cz>
 <20170308164834.14302-2-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170308164834.14302-2-jack@suse.cz>
Sender: linux-block-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Omar Sandoval <osandov@osandov.com>, Arthur Marsh <arthur.marsh@internode.on.net>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Wed, Mar 08, 2017 at 05:48:31PM +0100, Jan Kara wrote:
> @@ -710,6 +710,11 @@ static void cgwb_bdi_destroy(struct backing_dev_info *bdi)
>  	 */
>  	atomic_dec(&bdi->usage_cnt);
>  	wait_event(cgwb_release_wait, !atomic_read(&bdi->usage_cnt));
> +	/*
> +	 * Grab back our reference so that we hold it when @bdi gets
> +	 * re-registered.
> +	 */
> +	atomic_inc(&bdi->usage_cnt);

So, this is more re-initializing the ref to the initial state so that
it can be re-used, right?  Maybe ATOMIC_INIT() is a better choice here
just to clarify what's going on?

Thanks.

-- 
tejun
