From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH] scsi: sd_zbc: Disable zoned block devices with scsi-mq
Date: Fri, 18 Aug 2017 09:21:55 +0900
Message-ID: <0c359e7a-185c-191f-355f-d86b598e8f4b@wdc.com>
References: <20170817024550.9845-1-damien.lemoal@wdc.com>
 <20170817075916.GA28379@infradead.org>
 <2b78a557-d573-9ba1-0068-56417042ffc8@wdc.com>
 <1502982108.2615.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:37414 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753663AbdHRAXI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2017 20:23:08 -0400
In-Reply-To: <1502982108.2615.1.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@infradead.org" <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>


On 8/18/17 00:01, Bart Van Assche wrote:
> On Thu, 2017-08-17 at 21:19 +0900, Damien Le Moal wrote:
>> On 8/17/17 16:59, Christoph Hellwig wrote:
>>> On Thu, Aug 17, 2017 at 11:45:50AM +0900, Damien Le Moal wrote:
>>>> blk-mq may not maintain write requests order at dispatch time. So host
>>>> managed drives will not reliably work. Worse, potential reordering of
>>>> write requests on requeue may cause the zone write locking code to
>>>> deadlock command dispatch to the disk. So for now, until the write
>>>> ordering issue is fixed, do not support zoned block devices with
>>>> scsi-mq by showing a 0 LBA capacity disk.
>>>
>>> NAK.  Please fix the issue instead of this.
>>
>> I do have a fix ready to send. All the fixes are at blk-mq level and
>> basically ensure that dispatch from the hctx->dispatch list are in order
>> for write commands (regular writes, write same and write zeroes).
>> It is well tested and at least fixes all the problems I have seen with
>> dm-zoned and f2fs.
> 
> Hello Damien,
> 
> Another possible approach is to fix the ipr driver and to resubmit the
> "scsi-mq: Always unprepare before requeuing a request" and "scsi: sd_zbc:
> Write unlock zone from sd_uninit_cmnd()" patches.

Bart,

Yes, getting back "scsi-mq: Always unprepare before requeuing a request"
in would be ideal. Right now, I do not have a clue how to otherwise
avoid the deadlock on mq with a solution that fits both sq and mq, that
is, one that will not get a NAK from Christoph :)
But since we already are at rc5, it is risky to wait for a fix for the
PowerPC boot problem that may not come in time. So still trying.

Best.

-- 
Damien Le Moal,
Western Digital
