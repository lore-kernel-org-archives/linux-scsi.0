From: David Milburn <dmilburn@redhat.com>
Subject: Re: [PATCH] bio_integrity_add_page: check for BIO_POOL_NONE before
 determining nr_vecs on slab
Date: Wed, 05 Feb 2014 08:32:03 -0600
Message-ID: <52F24B63.2040008@redhat.com>
References: <1391013923-24072-1-git-send-email-dmilburn@redhat.com> <yq18utrzg3s.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq18utrzg3s.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@kernel.dk, JBottomley@Parallels.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 02/03/2014 09:55 PM, Martin K. Petersen wrote:
>>>>>> "David" == David Milburn <dmilburn@redhat.com> writes:
>
> David> When enabling DIX T10-DIF-TYPE1-IP protection you can hit the
> David> bip_vec full condition which fails to attach the integrity
> David> metadata and returns 0 back to bio_integrity_prep()
>
> Looks like Kent accidentally broke this when he changed the bvec pool
> setup.
>
> David> - if (bip->bip_vcnt >= bvec_nr_vecs(bip->bip_slab)) {
> David> + if (bip->bip_slab != BIO_POOL_NONE &&
> David> +     bip->bip_vcnt >= bvec_nr_vecs(bip->bip_slab)) {
> David>  		printk(KERN_ERR "%s: bip_vec full\n", __func__);
> David>  		return 0;
> David>  	}
>
> We still need to check that the page will actually fit, though:
>
>
> block: Fix nr_vecs for inline integrity vectors
>
> Commit 9f060e2231ca changed the way we handle allocations for the
> integrity vectors. When the vectors are inline there is no associated
> slab and consequently bvec_nr_vecs() returns 0. Ensure that we check
> against BIP_INLINE_VECS in that case.
>
> Reported-by: David Milburn <dmilburn@redhat.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>
> diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
> index fc60b31453ee..6dea2b90b4d5 100644
> --- a/fs/bio-integrity.c
> +++ b/fs/bio-integrity.c
> @@ -114,6 +114,14 @@ void bio_integrity_free(struct bio *bio)
>   }
>   EXPORT_SYMBOL(bio_integrity_free);
>
> +static inline unsigned int bip_integrity_vecs(struct bio_integrity_payload *bip)
> +{
> +	if (bip->bip_slab == BIO_POOL_NONE)
> +		return BIP_INLINE_VECS;
> +
> +	return bvec_nr_vecs(bip->bip_slab);
> +}
> +
>   /**
>    * bio_integrity_add_page - Attach integrity metadata
>    * @bio:	bio to update
> @@ -129,7 +137,7 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
>   	struct bio_integrity_payload *bip = bio->bi_integrity;
>   	struct bio_vec *iv;
>
> -	if (bip->bip_vcnt >= bvec_nr_vecs(bip->bip_slab)) {
> +	if (bip->bip_vcnt >= bip_integrity_vecs(bip)) {
>   		printk(KERN_ERR "%s: bip_vec full\n", __func__);
>   		return 0;
>   	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Hi Martin,

Your patch has been tested successfully.

Thanks for your help,
David
