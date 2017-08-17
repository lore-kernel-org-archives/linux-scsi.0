From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH] scsi: sd_zbc: Disable zoned block devices with scsi-mq
Date: Thu, 17 Aug 2017 21:24:42 +0900
Message-ID: <4cfd0ee8-1f71-ccab-b429-92e9f1034577@wdc.com>
References: <20170817024550.9845-1-damien.lemoal@wdc.com>
 <20170817075916.GA28379@infradead.org>
 <2b78a557-d573-9ba1-0068-56417042ffc8@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:35258 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbdHQMZJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2017 08:25:09 -0400
In-Reply-To: <2b78a557-d573-9ba1-0068-56417042ffc8@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>



On 8/17/17 21:19, Damien Le Moal wrote:
> 
> 
> On 8/17/17 16:59, Christoph Hellwig wrote:
>> On Thu, Aug 17, 2017 at 11:45:50AM +0900, Damien Le Moal wrote:
>>> blk-mq may not maintain write requests order at dispatch time. So host
>>> managed drives will not reliably work. Worse, potential reordering of
>>> write requests on requeue may cause the zone write locking code to
>>> deadlock command dispatch to the disk. So for now, until the write
>>> ordering issue is fixed, do not support zoned block devices with
>>> scsi-mq by showing a 0 LBA capacity disk.
>>
>> NAK.  Please fix the issue instead of this.
> 
> I do have a fix ready to send. All the fixes are at blk-mq level and
> basically ensure that dispatch from the hctx->dispatch list are in order
> for write commands (regular writes, write same and write zeroes).
> It is well tested and at least fixes all the problems I have seen with
> dm-zoned and f2fs.
> 
> But:
> 1) It is not small, so I strongly doubt it is RC material
> 2) We need Bart's patch for "always unprepare requests" which was reverted
> 3) Bart does not really like the solution I implemented...
> 
> I can still send it if you want to have a look.

Or were you thinking of just getting the deadlock fixed without
addressing the reordering problem ? In the end, ZBC disks would still
not be usable, so to me, disabling them is exactly equivalent...

-- 
Damien Le Moal,
Western Digital Research
