From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH] sd_zbc: Write unlock zone from sd_uninit_cmnd()
Date: Wed, 9 Aug 2017 13:07:54 +0900
Message-ID: <122fbf61-0de5-fa7e-2024-a0763ad70b13@wdc.com>
References: <20170808041746.31341-1-damien.lemoal@wdc.com>
 <1502204867.2250.1.camel@wdc.com>
 <d0bdb1af-7d37-9fa2-62e9-56b2ff315924@wdc.com>
 <cea78872-8e58-549d-87fc-2897e640c31c@wdc.com>
 <1502251037.2784.2.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:21263 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdHIEIh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2017 00:08:37 -0400
In-Reply-To: <1502251037.2784.2.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>



On 8/9/17 12:57, Bart Van Assche wrote:
> On Wed, 2017-08-09 at 11:47 +0900, Damien Le Moal wrote:
>> On 8/9/17 11:19, Damien Le Moal wrote:
>>> On 8/9/17 00:07, Bart Van Assche wrote:
>>>> On Tue, 2017-08-08 at 13:17 +0900, Damien Le Moal wrote:
>>>>> acquired the lock completes can cause deadlocks with scsi-mq due to
>>>>> potential queue reordering if the lock owning request is requeued and
>>>>> not executed.
>>>>
>>>> Please note that even with scsi-sq requeueing can cause request reordering.
>>>
>>> I am painfully aware of this fact... I will update the commit message to
>>> reflect this.
>>
>> Correction: checking the code again, I just realized that the prep_fn
>> queue function, which calls sd_init_cmnd() and causes a zone to be
>> write-locked if the prepared command is a write, is called within
>> blk_peek_request(). That function is called in scsi_request_fn() with
>> the queue lock held. So for the legacy scsi path, this means that for a
>> write command to a zone, the operation "lock zone and dequeue command"
>> is atomic. Thanks to the zone lock, further dequeue of write commands
>> for the same (locked) zone cannot happen and so there is no reordering
>> possible for write commands directed at the same zone. Reordering for
>> other commands is possible, but similarly to regular disks, this is not
>> a problem with ZBC/ZAC drives.
> 
> Hello Damien,
> 
> The locking approach in the upstream code indeed prevents reordering of
> write requests that apply to the same zone. However, this patch modifies
> the locking approach. Are you sure that with this patch applied no request
> reordering will occur if requests are requeued since this patch causes the
> zone lock to be released before requeuing occurs?

scsi_requeue_command() calls blk_unprep_request() and
blk_requeue_request under the queue lock. So atomically.
I think that suppresses any possibility of write requests to the same
zone to be reordered.

Best regards.

-- 
Damien Le Moal,
Western Digital
