From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 09/14] block: Relocate integrity flags
Date: Thu, 03 Jul 2014 13:03:15 +0300
Message-ID: <53B52A63.9090603@dev.mellanox.co.il>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com> <1401334128-15499-10-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:43838 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030217AbaGCKDS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 06:03:18 -0400
Received: by mail-we0-f175.google.com with SMTP id k48so12604306wev.20
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jul 2014 03:03:17 -0700 (PDT)
In-Reply-To: <1401334128-15499-10-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On 5/29/2014 6:28 AM, Martin K. Petersen wrote:
> Move flags affecting the integrity code out of the bio bi_flags and into
> the block integrity payload.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   block/bio-integrity.c     |  4 ++--
>   drivers/scsi/sd_dif.c     |  4 ++--
>   include/linux/bio.h       | 27 ++++++++++++++++++++++++++-
>   include/linux/blk_types.h |  6 ++----
>   4 files changed, 32 insertions(+), 9 deletions(-)
>
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index c91181e3d18d..877bce028766 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -98,7 +98,7 @@ void bio_integrity_free(struct bio *bio)
>   	struct bio_integrity_payload *bip = bio_integrity(bio);
>   	struct bio_set *bs = bio->bi_pool;
>   
> -	if (bip->bip_owns_buf)
> +	if (bip_get_flag(bip, BIP_BLOCK_INTEGRITY))
>   		kfree(page_address(bip->bip_vec->bv_page) +
>   		      bip->bip_vec->bv_offset);
>   
> @@ -299,7 +299,7 @@ int bio_integrity_prep(struct bio *bio)
>   		return -EIO;
>   	}
>   
> -	bip->bip_owns_buf = 1;
> +	bip_set_flag(bip, BIP_BLOCK_INTEGRITY);
>   	bip->bip_iter.bi_size = len;
>   	bip_set_seed(bip, bio->bi_iter.bi_sector);
>   
> diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
> index 1d401f864fbe..95d5cb806f58 100644
> --- a/drivers/scsi/sd_dif.c
> +++ b/drivers/scsi/sd_dif.c
> @@ -326,7 +326,7 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
>   		unsigned int j;
>   
>   		/* Already remapped? */
> -		if (bio_flagged(bio, BIO_MAPPED_INTEGRITY))
> +		if (bip_get_flag(bip, BIP_MAPPED_INTEGRITY))
>   			break;
>   
>   		virt = bip_get_seed(bip) & 0xffffffff;
> @@ -347,7 +347,7 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
>   			kunmap_atomic(sdt);
>   		}
>   
> -		bio->bi_flags |= (1 << BIO_MAPPED_INTEGRITY);
> +		bip_set_flag(bip, BIP_MAPPED_INTEGRITY);
>   	}
>   }
>   
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 295545de8790..adc806325c36 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -296,7 +296,7 @@ struct bio_integrity_payload {
>   
>   	unsigned short		bip_slab;	/* slab the bip came from */
>   	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
> -	unsigned		bip_owns_buf:1;	/* should free bip_buf */
> +	unsigned short		bip_flags;	/* control flags */
>   
>   	struct work_struct	bip_work;	/* I/O completion */
>   
> @@ -304,6 +304,31 @@ struct bio_integrity_payload {
>   	struct bio_vec		bip_inline_vecs[0];/* embedded bvec array */
>   };
>   
> +enum bip_flags {
> +	BIP_BLOCK_INTEGRITY = 0,/* block layer owns integrity data, not fs */
> +	BIP_MAPPED_INTEGRITY,	/* integrity metadata has been remapped */
> +	BIP_CTRL_NOCHECK,	/* disable controller integrity checking */
> +	BIP_DISK_NOCHECK,	/* disable disk integrity checking */
> +};
> +
> +static inline bool bip_get_flag(struct bio_integrity_payload *bip,
> +	enum bip_flags flag)
> +{
> +	if (bip && bip->bip_flags & (1 << flag))
> +		return true;
> +
> +	return false;
> +}
> +
> +static inline void bip_set_flag(struct bio_integrity_payload *bip,
> +	enum bip_flags flag)
> +{
> +	if (!bip)
> +		return;
> +
> +	bip->bip_flags |= (1 << flag);
> +}
> +
>   static inline sector_t bip_get_seed(struct bio_integrity_payload *bip)
>   {
>   	return bip->bip_iter.bi_sector;
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 9cce1fcd6793..b2e389a16534 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -120,10 +120,8 @@ struct bio {
>   #define BIO_USER_MAPPED 6	/* contains user pages */
>   #define BIO_EOPNOTSUPP	7	/* not supported */
>   #define BIO_NULL_MAPPED 8	/* contains invalid user pages */
> -#define BIO_FS_INTEGRITY 9	/* fs owns integrity data, not block layer */
> -#define BIO_QUIET	10	/* Make BIO Quiet */
> -#define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
> -#define BIO_SNAP_STABLE	12	/* bio data must be snapshotted during write */
> +#define BIO_QUIET	9	/* Make BIO Quiet */
> +#define BIO_SNAP_STABLE	10	/* bio data must be snapshotted during write */
>   
>   /*
>    * Flags starting here get preserved by bio_reset() - this includes

Christoph had comments on this, but I'm fine with this either way.

Other than that:

Reviewed-by: Sagi Grimberg<sagig@mellanox.com>


