From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] scsi: aic94xx: Add a missing call to kfree
Date: Tue, 22 Nov 2016 16:51:25 +0100
Message-ID: <a98c4b93-2e49-0d99-18dd-ac00446f3ca7@redhat.com>
References: <20161119174038.20083-1-lambert.quentin@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20161119174038.20083-1-lambert.quentin@gmail.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Quentin Lambert <lambert.quentin@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 19.11.2016 18:40, Quentin Lambert wrote:
> Most error branches following the call to kzalloc contain
> a call to kfree. This patch add these calls where they are
> missing.
>
> This issue was found with Hector.

Hi Quentin,
most error branches also do set the freed pointer to NULL,
please do the same.

tomash

> Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
>
> ---
>  drivers/scsi/aic94xx/aic94xx_hwi.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> --- a/drivers/scsi/aic94xx/aic94xx_hwi.c
> +++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
> @@ -228,8 +228,10 @@ static int asd_init_scbs(struct asd_ha_s
>  	bitmap_bytes = (asd_ha->seq.tc_index_bitmap_bits+7)/8;
>  	bitmap_bytes = BITS_TO_LONGS(bitmap_bytes*8)*sizeof(unsigned long);
>  	asd_ha->seq.tc_index_bitmap = kzalloc(bitmap_bytes, GFP_KERNEL);
> -	if (!asd_ha->seq.tc_index_bitmap)
> +	if (!asd_ha->seq.tc_index_bitmap) {
> +		kfree(asd_ha->seq.tc_index_array);
>  		return -ENOMEM;
> +	}
>  
>  	spin_lock_init(&seq->tc_index_lock);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


