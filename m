From: Jens Axboe <axboe@suse.de>
Subject: Re: FW:  Re. Allocation of scatter gather table in __init_io
Date: Mon, 9 Aug 2004 10:36:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040809083625.GP10418@suse.de>
References: <E5A17223DA27AB4DABB18A5955F4235545CFCE@EXCHVS1.louisville.stortek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:7606 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266334AbUHIIhB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2004 04:37:01 -0400
Content-Disposition: inline
In-Reply-To: <E5A17223DA27AB4DABB18A5955F4235545CFCE@EXCHVS1.louisville.stortek.com>
List-Id: linux-scsi@vger.kernel.org
To: "Govindan, Thiru" <GovinT@LOUISVILLE.STORTEK.COM>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

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
expected. Sounds like you are not using the correct return value to
check what segment count you should pass the hardware.

-- 
Jens Axboe

