From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: uas: kernel BUG at block/blk-tag.c:89 is back again :|
Date: Sun, 06 Jul 2014 14:24:03 +0200
Message-ID: <53B93FE3.8050607@redhat.com>
References: <53B2B4B2.8050100@redhat.com> <20140703060135.GA5292@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbaGFMYg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Jul 2014 08:24:36 -0400
In-Reply-To: <20140703060135.GA5292@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-scsi@vger.kernel.org

Hi,

On 07/03/2014 08:01 AM, Christoph Hellwig wrote:
> Hi Hans,
> 
> please test the path below:

Note, I did a similar patch a while back, but then it was decided to
try and fix the tear-down ordering instead (which seems to have not
completely fixed the issue).

I've just tested this patch and it indeed fixes this. Note if we go
with this fix for 3.16, it should get a CC: stable for 3.15, as
3.15 is affected too.

Thanks,

Hans


> 
> ---
> From: Christoph Hellwig <hch@lst.de>
> Subject: block: don't assume last put of shared tags is for the host
> 
> There is no inherent reason why the last put of a tag structure must be
> the one for the Scsi_Host, as device model objects can be held for
> arbitrary periods.  Merge blk_free_tags and __blk_free_tags into a single
> funtion that just release a references and get rid of the BUG() when the
> host reference wasn't the last.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> diff --git a/block/blk-tag.c b/block/blk-tag.c
> index 3f33d86..a185b86 100644
> --- a/block/blk-tag.c
> +++ b/block/blk-tag.c
> @@ -27,18 +27,15 @@ struct request *blk_queue_find_tag(struct request_queue *q, int tag)
>  EXPORT_SYMBOL(blk_queue_find_tag);
>  
>  /**
> - * __blk_free_tags - release a given set of tag maintenance info
> + * blk_free_tags - release a given set of tag maintenance info
>   * @bqt:	the tag map to free
>   *
> - * Tries to free the specified @bqt.  Returns true if it was
> - * actually freed and false if there are still references using it
> + * Drop the reference count on @bqt and frees it when the last reference
> + * is dropped.
>   */
> -static int __blk_free_tags(struct blk_queue_tag *bqt)
> +void blk_free_tags(struct blk_queue_tag *bqt)
>  {
> -	int retval;
> -
> -	retval = atomic_dec_and_test(&bqt->refcnt);
> -	if (retval) {
> +	if (atomic_dec_and_test(&bqt->refcnt)) {
>  		BUG_ON(find_first_bit(bqt->tag_map, bqt->max_depth) <
>  							bqt->max_depth);
>  
> @@ -50,9 +47,8 @@ static int __blk_free_tags(struct blk_queue_tag *bqt)
>  
>  		kfree(bqt);
>  	}
> -
> -	return retval;
>  }
> +EXPORT_SYMBOL(blk_free_tags);
>  
>  /**
>   * __blk_queue_free_tags - release tag maintenance info
> @@ -69,28 +65,13 @@ void __blk_queue_free_tags(struct request_queue *q)
>  	if (!bqt)
>  		return;
>  
> -	__blk_free_tags(bqt);
> +	blk_free_tags(bqt);
>  
>  	q->queue_tags = NULL;
>  	queue_flag_clear_unlocked(QUEUE_FLAG_QUEUED, q);
>  }
>  
>  /**
> - * blk_free_tags - release a given set of tag maintenance info
> - * @bqt:	the tag map to free
> - *
> - * For externally managed @bqt frees the map.  Callers of this
> - * function must guarantee to have released all the queues that
> - * might have been using this tag map.
> - */
> -void blk_free_tags(struct blk_queue_tag *bqt)
> -{
> -	if (unlikely(!__blk_free_tags(bqt)))
> -		BUG();
> -}
> -EXPORT_SYMBOL(blk_free_tags);
> -
> -/**
>   * blk_queue_free_tags - release tag maintenance info
>   * @q:  the request queue for the device
>   *
> 
