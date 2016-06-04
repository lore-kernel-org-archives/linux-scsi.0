From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH] sd: remove redundant check for BLK_DEF_MAX_SECTORS
Date: Sat, 4 Jun 2016 16:41:23 +0800
Message-ID: <CAGnHSE=ZriFjvdXT5npv92VhqxtN1SqQL+jwMehCq42K3O+=VQ@mail.gmail.com>
References: <1465012678-32547-1-git-send-email-longli@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35467 "EHLO
	mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbcFDIlZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jun 2016 04:41:25 -0400
In-Reply-To: <1465012678-32547-1-git-send-email-longli@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Long Li <longli@microsoft.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The main point there is not to check q->limits.max_sectors against
BLK_DEF_MAX_SECTORS, but sdkp->opt_xfer_blocks against
SD_DEF_XFER_BLOCKS et al.? `rw_max = BLK_DEF_MAX_SECTORS;` there is
merely the fallback when sdkp->opt_xfer_blocks does not pass the
conditions. With your patch `rw_max` can be indeterminate in those
circumstances.

On 4 June 2016 at 11:57, Long Li <longli@microsoft.com> wrote:
> q->limits.max_sectors is already checked against BLK_DEF_MAX_SECTORS in __scsi_alloc_queue(), when it calls blk_queue_max_hw_sectors(). There is no need to check it again in sd.
>
> This change also allows a SCSI driver set an maximum sector size bigger than BLK_DEF_MAX_SECTORS, without returning values on optional VPD page 0xb0 "Block Limits".
>
> Signed-off-by: Long Li <longli@microsoft.com>
>
> ---
>  drivers/scsi/sd.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 60bff78..d8c4047 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2870,11 +2870,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
>             logical_to_bytes(sdp, sdkp->opt_xfer_blocks) >= PAGE_SIZE) {
>                 q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
>                 rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
> -       } else
> -               rw_max = BLK_DEF_MAX_SECTORS;
> -
> -       /* Combine with controller limits */
> -       q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
> +               q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
> +       }
>
>         set_capacity(disk, logical_to_sectors(sdp, sdkp->capacity));
>         sd_config_write_same(sdkp);
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
