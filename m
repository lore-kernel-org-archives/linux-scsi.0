From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] sd: Consider max_xfer_blocks if opt_xfer_blocks is unusable
Date: Wed, 29 Mar 2017 22:37:34 -0400
Message-ID: <yq1k2774hht.fsf@oracle.com>
References: <20170328044126.10006-1-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170328044126.10006-1-famz@redhat.com> (Fam Zheng's message of
        "Tue, 28 Mar 2017 12:41:26 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Laurence Oberman <loberman@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Fam Zheng <famz@redhat.com> writes:

Fam,

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index fcfeddc..a5c7e67 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2957,6 +2957,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
>  	} else
>  		rw_max = BLK_DEF_MAX_SECTORS;
> +	rw_max = min_not_zero(rw_max, logical_to_sectors(sdp, dev_max));
>  
>  	/* Combine with controller limits */
>  	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));

Instead of updating rw_max twice, how about:

} else
	rw_max = min_not_zero(logical_to_sectors(sdp, dev_max),
                              BLK_DEF_MAX_SECTORS);

?

-- 
Martin K. Petersen	Oracle Linux Engineering
