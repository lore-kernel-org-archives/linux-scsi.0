From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2 1/2] scsi: sd: Fix sd_config_write_same()
Date: Thu, 31 Aug 2017 23:36:22 -0400
Message-ID: <yq1tw0num2x.fsf@oracle.com>
References: <20170901010729.16524-1-damien.lemoal@wdc.com>
        <20170901010729.16524-2-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51913 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751040AbdIADgb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2017 23:36:31 -0400
In-Reply-To: <20170901010729.16524-2-damien.lemoal@wdc.com> (Damien Le Moal's
        message of "Fri, 1 Sep 2017 10:07:28 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>


Damien,

> +	if (sdkp->max_ws_blocks &&
> +	    sdkp->physical_block_size > logical_block_size) {
> +		/*
> +		 * Reporting a maximum number of blocks that is not aligned
> +		 * on the device physical size would cause a large write same
> +		 * request to be split into physically unaligned chunks by
> +		 * __blkdev_issue_write_zeroes() and __blkdev_issue_write_same()
> +		 * even if the caller of these functions took care to align the
> +		 * large request. So make sure the maximum reported is aligned
> +		 * to the device physical block size. This is only an optional
> +		 * optimization for regular disks, but this is mandatory to
> +		 * avoid failure of large write same requests directed at
> +		 * sequential write required zones of host-managed ZBC disks.
> +		 */
> +		sector_t phys_mask =
> +			bytes_to_logical(sdkp->device,
> +					 sdkp->physical_block_size) - 1;
> +
> +		sdkp->max_ws_blocks &= ~phys_mask;
> +	}
> +
>  out:
>  	blk_queue_max_write_same_sectors(q, sdkp->max_ws_blocks *
>  					 (logical_block_size >> 9));

ALIGN_DOWN(sdkp->max_ws_blocks, sdkp->physical_block_size)?

-- 
Martin K. Petersen	Oracle Linux Engineering
