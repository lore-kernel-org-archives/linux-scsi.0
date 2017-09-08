From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V2 00/12] scsi-mq support for ZBC disks
Date: Fri, 8 Sep 2017 09:12:12 -0700
Message-ID: <c3305202-43d3-20e3-825a-ae5fff462d54@wdc.com>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
 <20170908082040.GA25719@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:55051 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752393AbdIHQM7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Sep 2017 12:12:59 -0400
In-Reply-To: <20170908082040.GA25719@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>, Jens Axboe <axboe@kernel.dk>

Christoph,

On 9/8/17 01:20, Christoph Hellwig wrote:
> I'm really worried about how this is tied into the sd driver.
> 
> From a quick look it seems like the only thing you really need in
> the scheduler that is done through struct scsi_disk is the
> offset + len -> zone number lookup - I'd much rather expose this
> from sd upwards and keep the scheduler in the block code.

The only things that the scheduler needs are:
1) The zone size and the number of zones of the device (for the bitmaps
allocation and offset->zone number conversion).
2) Zone type for the optimization that avoids locking conventional zones.

(2) is optional. We can do without, but still really nice to have from a
performance perspective as conventional zones tend to be used for
storing metadata. So a lot of small random writes is more likely and
high queue depth writing would improve performance significantly.

For (1), the zone size is known through q->limits.chunk_sectors. But the
disk capacity is not known using request_queue only, so the number of
zones cannot be calculated... I thought of exporting it through queue
limits too, but then stacking of device mappers using ZBC drives becomes
a pain as the number of zones needs to be recalculated.

The best solution would really be to be able to get a disk capacity
given a request queue. Any idea on how to do this ?
For optimization (2), there is also the problem that given a request
queue, the block_device struct is not known, so it is not possible to
issue report zones (granted, the scheduler could build the request
directly to do that, but that is really an ugly solution).

I did not find any nice solution for either problem, so ended up tying
the scheduler to sd since the scsi_disk struct already had all the info
needed.

> Except for that this looks like a fine approach to me.

Thanks.

-- 
Damien Le Moal,
Western Digital Research
