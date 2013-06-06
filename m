From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] lib/scatterlist: introduce sg_pcopy_from_buffer()
 and sg_pcopy_to_buffer()
Date: Thu, 6 Jun 2013 14:00:41 -0700
Message-ID: <20130606210041.GD5045@htj.dyndns.org>
References: <1370523178-5437-1-git-send-email-akinobu.mita@gmail.com>
 <1370523178-5437-2-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-crypto-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1370523178-5437-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Imre Deak <imre.deak@intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Jun 06, 2013 at 09:52:56PM +0900, Akinobu Mita wrote:
> +static bool sg_miter_get_next_page(struct sg_mapping_iter *miter)
> +{
> +	if (!miter->__remaining) {
> +		struct scatterlist *sg;
> +		unsigned long pgoffset;
> +
> +		if (!__sg_page_iter_next(&miter->piter))
> +			return false;
> +
> +		sg = miter->piter.sg;
> +		pgoffset = miter->piter.sg_pgoffset;
> +
> +		miter->__offset = pgoffset ? 0 : sg->offset;
> +		miter->__remaining = sg->offset + sg->length -
> +				(pgoffset << PAGE_SHIFT) - miter->__offset;
> +		miter->__remaining = min_t(unsigned long, miter->__remaining,
> +					   PAGE_SIZE - miter->__offset);
> +	}
> +
> +	return true;
> +}

It'd be better if separating out this function is a separate patch.
Mixing factoring out something and adding new stuff makes the patch a
bit harder to read.

> +static bool sg_miter_seek(struct sg_mapping_iter *miter, off_t offset)
> +{
> +	WARN_ON(miter->addr);
> +
> +	while (offset) {
> +		off_t consumed;
> +
> +		if (!sg_miter_get_next_page(miter))
> +			return false;
> +
> +		consumed = min_t(off_t, offset, miter->__remaining);
> +		miter->__offset += consumed;
> +		miter->__remaining -= consumed;
> +		offset -= consumed;
> +	}
> +
> +	return true;
> +}

While I think the above should work at the beginning, what if @miter
is in the middle of iteration and __remaining isn't zero?

Looks good to me otherwise.

Thanks.

-- 
tejun
