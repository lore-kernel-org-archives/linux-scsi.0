From: "Govindan, Thiru" <GovinT@LOUISVILLE.STORTEK.COM>
Subject: RE: FW:  Re. Allocation of scatter gather table in __init_io
Date: Mon, 9 Aug 2004 18:09:21 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E5A17223DA27AB4DABB18A5955F4235545CFD2@EXCHVS1.louisville.stortek.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sherman.stortek.com ([129.80.22.146]:6324 "EHLO
	sherman.stortek.com") by vger.kernel.org with ESMTP id S266366AbUHIJJb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Aug 2004 05:09:31 -0400
Received: from sherman.stortek.com (localhost [127.0.0.1])
	by sherman.stortek.com (8.12.10/8.12.0) with ESMTP id i7999UZ3006886
	for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2004 03:09:30 -0600 (MDT)
List-Id: linux-scsi@vger.kernel.org
To: 'Jens Axboe' <axboe@suse.de>
Cc: "Govindan, Thiru" <GovinT@LOUISVILLE.STORTEK.COM>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Jens,
	Ok, but __init_io() does seem to expect that the number of segments
matches the count after merging is done. As shown in the code below, if its
OK to allocate space for the max. number of items then this check is not
needed.
        /*
         * Verify that the count is correct.
         */
        if (count != SCpnt->use_sg) {
                printk("Incorrect number of segments after building
list\n");
#ifdef CONFIG_SCSI_DEBUG_QUEUES
                dump_stats(req, use_clustering, dma_host, count);
#endif
        }


How does the HBA driver know the correct number in this case? Should it use
request_bufflen in the SCSI Command in addition to use_sg, to identify the
number of segments actually there in the list? I'm using a Qlogic HBA and
its just going by the value in use_sg to identify segments in the
scatter-gather list.

Govindan

-----Original Message-----
From: Jens Axboe [mailto:axboe@suse.de] 
Sent: Monday, August 09, 2004 2:36 AM
To: Govindan, Thiru
Cc: 'linux-scsi@vger.kernel.org'
Subject: Re: FW: Re. Allocation of scatter gather table in __init_io


On Mon, Aug 09 2004, Govindan, Thiru wrote:
> Hi,
>     I'm running into an issue that seems to be caused by __init_io()
>     in scsi_merge.c. Apparently __init_io() is allocating the scatter
>     gather list before even merging the segments in the queue. In my
>     case the request nr_segments  has a value of 2 and the scatter
>     gather table is allocated for 2 entries. But  then the logic
>     merges the 2 segments into 1 and fills in one entry, my HBA driver
>     complains that one entry is invalid and panics. Can you clarify
>     how this works, I suppose getting mergeable segments in a request
>     is common and hence __init_io() must allocate the table after
>     having at least identified how may segments are really there.
> 
> Is this a known issue and is there a patch that fixes this?

It has to allocate the space for the table to hold all items, so it's
expected. Sounds like you are not using the correct return value to check
what segment count you should pass the hardware.

-- 
Jens Axboe
