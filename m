From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Consider max_xfer_blocks if opt_xfer_blocks is unusable
Date: Mon, 27 Mar 2017 22:11:59 -0400
Message-ID: <yq1r31i5evk.fsf@oracle.com>
References: <20170327141831.20936-1-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33017 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752853AbdC1CMK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2017 22:12:10 -0400
In-Reply-To: <20170327141831.20936-1-famz@redhat.com> (Fam Zheng's message of
        "Mon, 27 Mar 2017 22:18:31 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

Fam Zheng <famz@redhat.com> writes:

Hi Fam,

> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2957,6 +2957,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
>  	} else
>  		rw_max = BLK_DEF_MAX_SECTORS;
> +	rw_max = min_not_zero(rw_max, dev_max);

rw_max is in sectors, dev_max is in logical blocks.

>  
>  	/* Combine with controller limits */
>  	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));

-- 
Martin K. Petersen	Oracle Linux Engineering
