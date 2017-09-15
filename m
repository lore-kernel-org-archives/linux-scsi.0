From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH V3 06/12] scsi: sd_zbc: Rearrange code
Date: Sat, 16 Sep 2017 07:35:36 +0900
Message-ID: <4f51ccc7-1239-9505-564c-ec2c97cc626a@wdc.com>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
 <20170915100645.17999-7-damien.lemoal@wdc.com>
 <1505487062.2852.12.camel@wdc.com> <20170915175117.GG8578@lst.de>
 <1505509340.2417.18.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:9782 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbdIOWg6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 18:36:58 -0400
In-Reply-To: <1505509340.2417.18.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>

On 9/16/17 06:02, Bart Van Assche wrote:
> On Fri, 2017-09-15 at 19:51 +0200, hch@lst.de wrote:
>> On Fri, Sep 15, 2017 at 02:51:03PM +0000, Bart Van Assche wrote:
>>> On Fri, 2017-09-15 at 19:06 +0900, Damien Le Moal wrote:
>>>> Rearrange sd_zbc_setup() to include use_16_for_rw and use_10_for_rw
>>>> assignments and move the calculation of sdkp->zone_shift together
>>>> with the assignment of the verified zone_blocks value in
>>>> sd_zbc_check_zone_size().
>>>
>>> Both functions are called from inside block_device_operations.revalidate_disk.
>>> Isn't that too late to set use_1[06]_for_rw? Shouldn't both be set just after
>>> the slave_alloc callback has been called?
>>
>> Hmm.  sd_read_capacity already is called from the same path and seems
>> to work..
> 
> Hello Christoph,
> 
> My concern is that if both a SCSI LLD and the ZBC code set use_1[06]_for_rw
> that these settings may conflict. Should the ZBC code e.g. refuse that the sd
> driver is attached to a ZBC disk controlled by a SCSI LLD that supports
> use_10_for_rw but not use_16_for_rw?

rw16 is mandatory for ZBC drives. So it has to be set to true. If the
HBA does not support rw16 (why would that happen ?), then the disk
should not be used.

Cheers.

-- 
Damien Le Moal
Western Digital Research
