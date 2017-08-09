From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH] sd_zbc: Write unlock zone from sd_uninit_cmnd()
Date: Wed, 9 Aug 2017 11:47:31 +0900
Message-ID: <cea78872-8e58-549d-87fc-2897e640c31c@wdc.com>
References: <20170808041746.31341-1-damien.lemoal@wdc.com>
 <1502204867.2250.1.camel@wdc.com>
 <d0bdb1af-7d37-9fa2-62e9-56b2ff315924@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:50025 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdHICsc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 22:48:32 -0400
In-Reply-To: <d0bdb1af-7d37-9fa2-62e9-56b2ff315924@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>

Bart,

On 8/9/17 11:19, Damien Le Moal wrote:
> Bart,
> 
> On 8/9/17 00:07, Bart Van Assche wrote:
>> On Tue, 2017-08-08 at 13:17 +0900, Damien Le Moal wrote:
>>> Releasing the write lock of a zone when the write commnand that
>>                                                     ^^^^^^^^
>>                                                     command?
>>> acquired the lock completes can cause deadlocks with scsi-mq due to
>>> potential queue reordering if the lock owning request is requeued and
>>> not executed.
>>
>> Please note that even with scsi-sq requeueing can cause request reordering.
> 
> I am painfully aware of this fact... I will update the commit message to
> reflect this.

Correction: checking the code again, I just realized that the prep_fn
queue function, which calls sd_init_cmnd() and causes a zone to be
write-locked if the prepared command is a write, is called within
blk_peek_request(). That function is called in scsi_request_fn() with
the queue lock held. So for the legacy scsi path, this means that for a
write command to a zone, the operation "lock zone and dequeue command"
is atomic. Thanks to the zone lock, further dequeue of write commands
for the same (locked) zone cannot happen and so there is no reordering
possible for write commands directed at the same zone. Reordering for
other commands is possible, but similarly to regular disks, this is not
a problem with ZBC/ZAC drives.

This is good, but a little suboptimal as request dispatch gets stalled
every time there are multiple write commands to the same zone queued.
This could be optimized to let other command go through and so operate
the drive at higher queue depth and reduce latency for operations like
reads.

The patch "block: Zoned block device single-threaded submission" that I
sent previously and that Christoph Nack-ed is thus in fact not necessary
at all.

>>> Since sd_uninit_cmnd() is always called when a request is requeued,
>>> call sd_zbc_write_unlock_zone() from that function for write requests
>>> that acquired a zone lock. Acquisition of a zone lock by a write command
>>> is indicated using the new command flag SCMD_ZONE_WRITE_LOCK.
>>
>> Hello Damien,
>>
>> Since this patch differs slightly from the version that was posted a few
>> days ago, should a "v2" label have been added to the subject and should a
>> changelog have been included? Anyway:
> 
> Yes, forgot to do that. Reposting.
> 
>> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
> 
> Thanks.
> 

-- 
Damien Le Moal,
Western Digital
