From: Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: [PATCH 1/1] scsi: Fix max transfer length for 4k disks
Date: Tue, 3 Feb 2015 11:25:12 -0800
Message-ID: <CAHdzE--L=qP534X9WshZ0BnA66Hn+r1D8fD1drrSKMkfSFNKPA@mail.gmail.com>
References: <201501292155.t0TLt4qF025739@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:50613 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266AbbBCTZN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2015 14:25:13 -0500
Received: by mail-vc0-f170.google.com with SMTP id kv7so17564364vcb.1
        for <linux-scsi@vger.kernel.org>; Tue, 03 Feb 2015 11:25:12 -0800 (PST)
In-Reply-To: <201501292155.t0TLt4qF025739@d01av05.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, stable@vger.kernel.org

On Thu, Jan 29, 2015 at 1:54 PM, Brian King <brking@linux.vnet.ibm.com> wrote:
>
> The following patch fixes an issue observed with 4k sector disks
> where the max_hw_sectors attribute was getting set too large in
> sd_revalidate_disk. Since sdkp->max_xfer_blocks is in units
> of SCSI logical blocks and queue_max_hw_sectors is in units of
> 512 byte blocks, on a 4k sector disk, every time we went through
> sd_revalidate_disk, we were taking the current value of
> queue_max_hw_sectors and increasing it by a factor of 8. Fix
> this by only shifting sdkp->max_xfer_blocks.
>
> Cc: stable<stable@vger.kernel.org>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>
>  drivers/scsi/sd.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff -puN drivers/scsi/sd.c~sd_revalidate_4k drivers/scsi/sd.c
> --- linux/drivers/scsi/sd.c~sd_revalidate_4k    2015-01-29 14:44:23.316171187 -0600
> +++ linux-bjking1/drivers/scsi/sd.c     2015-01-29 14:51:05.846126392 -0600
> @@ -2800,9 +2800,11 @@ static int sd_revalidate_disk(struct gen
>          */
>         sd_set_flush_flag(sdkp);
>
> -       max_xfer = min_not_zero(queue_max_hw_sectors(sdkp->disk->queue),
> -                               sdkp->max_xfer_blocks);
> +       max_xfer = sdkp->max_xfer_blocks;
>         max_xfer <<= ilog2(sdp->sector_size) - 9;
> +
> +       max_xfer = min_not_zero(queue_max_hw_sectors(sdkp->disk->queue),
> +                               max_xfer);
>         blk_queue_max_hw_sectors(sdkp->disk->queue, max_xfer);
>         set_capacity(disk, sdkp->capacity);
>         sd_config_write_same(sdkp);

Heh, nice find.

Tested-by: Venkatesh Srinivas <venkateshs@google.com>

-- vs;
