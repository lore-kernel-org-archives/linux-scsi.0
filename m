From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V2 1/2] scsi: sd: Fix sd_config_write_same()
Date: Fri, 1 Sep 2017 17:45:57 +0900
Message-ID: <7597666d-ee7d-8189-1d47-4ed86891d574@wdc.com>
References: <20170901010729.16524-1-damien.lemoal@wdc.com>
 <20170901010729.16524-2-damien.lemoal@wdc.com> <yq1tw0num2x.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:44840 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbdIAIrA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Sep 2017 04:47:00 -0400
In-Reply-To: <yq1tw0num2x.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>

Martin,

On 9/1/17 12:36, Martin K. Petersen wrote:
> 
> Damien,
> 
>> +	if (sdkp->max_ws_blocks &&
>> +	    sdkp->physical_block_size > logical_block_size) {
>> +		/*
>> +		 * Reporting a maximum number of blocks that is not aligned
>> +		 * on the device physical size would cause a large write same
>> +		 * request to be split into physically unaligned chunks by
>> +		 * __blkdev_issue_write_zeroes() and __blkdev_issue_write_same()
>> +		 * even if the caller of these functions took care to align the
>> +		 * large request. So make sure the maximum reported is aligned
>> +		 * to the device physical block size. This is only an optional
>> +		 * optimization for regular disks, but this is mandatory to
>> +		 * avoid failure of large write same requests directed at
>> +		 * sequential write required zones of host-managed ZBC disks.
>> +		 */
>> +		sector_t phys_mask =
>> +			bytes_to_logical(sdkp->device,
>> +					 sdkp->physical_block_size) - 1;
>> +
>> +		sdkp->max_ws_blocks &= ~phys_mask;
>> +	}
>> +
>>  out:
>>  	blk_queue_max_write_same_sectors(q, sdkp->max_ws_blocks *
>>  					 (logical_block_size >> 9));
> 
> ALIGN_DOWN(sdkp->max_ws_blocks, sdkp->physical_block_size)?

Sure. But let's use the same unit then :)

sdkp->max_ws_blocks =
	ALIGN_DOWN(sdkp->max_ws_blocks,
	   bytes_to_logical(sdkp->device, sdkp->physical_block_size));

Isn't it ?

Do you want me to resend ?

Thank you.

-- 
Damien Le Moal,
Western Digital
