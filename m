From: Imre Deak <imre.deak@intel.com>
Subject: Re: [PATCH 1/3] lib/scatterlist: introduce sg_pcopy_from_buffer()
 and sg_pcopy_to_buffer()
Date: Thu, 06 Jun 2013 16:12:30 +0300
Message-ID: <1370524350.23133.11.camel@intelbox>
References: <1370523178-5437-1-git-send-email-akinobu.mita@gmail.com>
	 <1370523178-5437-2-git-send-email-akinobu.mita@gmail.com>
Reply-To: imre.deak@intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52160 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab3FFNMf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jun 2013 09:12:35 -0400
In-Reply-To: <1370523178-5437-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

On Thu, 2013-06-06 at 21:52 +0900, Akinobu Mita wrote:
> The only difference between sg_pcopy_{from,to}_buffer() and
> sg_copy_{from,to}_buffer() is an additional argument that specifies
> the number of bytes to skip the SG list before copying.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Imre Deak <imre.deak@intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  include/linux/scatterlist.h |   5 ++
>  lib/scatterlist.c           | 109 ++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 94 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 5951e3f..f5dee42 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -241,6 +241,11 @@ size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
>  size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
>  			 void *buf, size_t buflen);
>  
> +size_t sg_pcopy_from_buffer(struct scatterlist *sgl, unsigned int nents,
> +			    void *buf, size_t buflen, off_t skip);
> +size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
> +			  void *buf, size_t buflen, off_t skip);
> +
>  /*
>   * Maximum number of entries that will be allocated in one piece, if
>   * a list larger than this is required then chaining will be utilized.
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index a1cf8ca..3b40b72 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -453,6 +453,47 @@ void sg_miter_start(struct sg_mapping_iter *miter, struct scatterlist *sgl,
>  }
>  EXPORT_SYMBOL(sg_miter_start);
>  
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
> +
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
> +
>  /**
>   * sg_miter_next - proceed mapping iterator to the next mapping
>   * @miter: sg mapping iter to proceed
> @@ -478,22 +519,9 @@ bool sg_miter_next(struct sg_mapping_iter *miter)
>  	 * Get to the next page if necessary.
>  	 * __remaining, __offset is adjusted by sg_miter_stop
>  	 */
> -	if (!miter->__remaining) {
> -		struct scatterlist *sg;
> -		unsigned long pgoffset;
> -
> -		if (!__sg_page_iter_next(&miter->piter))
> -			return false;
> -
> -		sg = miter->piter.sg;
> -		pgoffset = miter->piter.sg_pgoffset;
> +	if (!sg_miter_get_next_page(miter))
> +		return false;
>  
> -		miter->__offset = pgoffset ? 0 : sg->offset;
> -		miter->__remaining = sg->offset + sg->length -
> -				(pgoffset << PAGE_SHIFT) - miter->__offset;
> -		miter->__remaining = min_t(unsigned long, miter->__remaining,
> -					   PAGE_SIZE - miter->__offset);
> -	}
>  	miter->page = sg_page_iter_page(&miter->piter);
>  	miter->consumed = miter->length = miter->__remaining;
>  
> @@ -552,14 +580,16 @@ EXPORT_SYMBOL(sg_miter_stop);
>   * @nents:		 Number of SG entries
>   * @buf:		 Where to copy from
>   * @buflen:		 The number of bytes to copy
> - * @to_buffer: 		 transfer direction (non zero == from an sg list to a
> - * 			 buffer, 0 == from a buffer to an sg list
> + * @skip:		 Number of bytes to skip before copying
> + * @to_buffer:		 transfer direction (true == from an sg list to a
> + *			 buffer, false == from a buffer to an sg list
>   *
>   * Returns the number of copied bytes.
>   *
>   **/
>  static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
> -			     void *buf, size_t buflen, int to_buffer)
> +			     void *buf, size_t buflen, off_t skip,
> +			     bool to_buffer)
>  {
>  	unsigned int offset = 0;
>  	struct sg_mapping_iter miter;
> @@ -573,6 +603,9 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
>  
>  	sg_miter_start(&miter, sgl, nents, sg_flags);
>  
> +	if (!sg_miter_seek(&miter, skip))
> +		return false;

Looks ok to me, perhaps adding the seek functionality to the mapping
iterator would make things more generic and the mapping iterator more
resemble the page iterator. So we'd have a new sg_miter_start_offset and
call it here something like:

sg_miter_start_offset(&miter, sgl, nents, sg_flags, skip);

Just my 2 cents,
Imre

> +
>  	local_irq_save(flags);
>  
>  	while (sg_miter_next(&miter) && offset < buflen) {
> @@ -607,7 +640,7 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
>  size_t sg_copy_from_buffer(struct scatterlist *sgl, unsigned int nents,
>  			   void *buf, size_t buflen)
>  {
> -	return sg_copy_buffer(sgl, nents, buf, buflen, 0);
> +	return sg_copy_buffer(sgl, nents, buf, buflen, 0, false);
>  }
>  EXPORT_SYMBOL(sg_copy_from_buffer);
>  
> @@ -624,6 +657,42 @@ EXPORT_SYMBOL(sg_copy_from_buffer);
>  size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
>  			 void *buf, size_t buflen)
>  {
> -	return sg_copy_buffer(sgl, nents, buf, buflen, 1);
> +	return sg_copy_buffer(sgl, nents, buf, buflen, 0, true);
>  }
>  EXPORT_SYMBOL(sg_copy_to_buffer);
> +
> +/**
> + * sg_pcopy_from_buffer - Copy from a linear buffer to an SG list
> + * @sgl:		 The SG list
> + * @nents:		 Number of SG entries
> + * @buf:		 Where to copy from
> + * @skip:		 Number of bytes to skip before copying
> + * @buflen:		 The number of bytes to copy
> + *
> + * Returns the number of copied bytes.
> + *
> + **/
> +size_t sg_pcopy_from_buffer(struct scatterlist *sgl, unsigned int nents,
> +			    void *buf, size_t buflen, off_t skip)
> +{
> +	return sg_copy_buffer(sgl, nents, buf, buflen, skip, false);
> +}
> +EXPORT_SYMBOL(sg_pcopy_from_buffer);
> +
> +/**
> + * sg_pcopy_to_buffer - Copy from an SG list to a linear buffer
> + * @sgl:		 The SG list
> + * @nents:		 Number of SG entries
> + * @buf:		 Where to copy to
> + * @skip:		 Number of bytes to skip before copying
> + * @buflen:		 The number of bytes to copy
> + *
> + * Returns the number of copied bytes.
> + *
> + **/
> +size_t sg_pcopy_to_buffer(struct scatterlist *sgl, unsigned int nents,
> +			  void *buf, size_t buflen, off_t skip)
> +{
> +	return sg_copy_buffer(sgl, nents, buf, buflen, skip, true);
> +}
> +EXPORT_SYMBOL(sg_pcopy_to_buffer);


