From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH 9/9] sd_zbc: Do not write lock zones for reset
Date: Mon, 24 Apr 2017 09:11:15 +0900
Message-ID: <6125d043-07f9-414f-f999-1773c4adb81f@wdc.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
 <20170421091649.25287-10-damien.lemoal@wdc.com>
 <1492794954.2550.15.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:29425 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163640AbdDXALb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Apr 2017 20:11:31 -0400
In-Reply-To: <1492794954.2550.15.camel@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

Bart,

On 4/22/17 02:15, Bart Van Assche wrote:
> On Fri, 2017-04-21 at 18:16 +0900, damien.lemoal@wdc.com wrote:
>> @@ -250,11 +249,6 @@ int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
>>                /* Unaligned request */
>>                return BLKPREP_KILL;
>>  
>> -     /* Do not allow concurrent reset and writes */
>> -     if (sdkp->zones_wlock &&
>> -         test_and_set_bit(zno, sdkp->zones_wlock))
>> -             return BLKPREP_DEFER;
>> -
> 
> Hello Damien,
> 
> Since concurrent zone resets and writes are easy to detect and since these
> indicate a bug in the application that submits these, should an error
> message
> be logged if that happens? Otherwise this patch looks fine to me.

Yes, we could easily add a warning, but if we consider the 3 possible
cases of reset+write combinations:
1) Reset comes in while a write is already in the queue: The write will
succeed (assuming it is directed at the zone write pointer) and the
reset will also succeed.
2) A write directed at the current write pointer comes in while a reset
is in the queue: the write will fail.
3) A write directed at the beginning of the zone comes in while a reset
is in the queue: the write will succeed.

The warning would trigger only in case (1), but that case may be
actually intentional by the user. Case (2) will get an "indirect"
warning through the write align error, which clearly signals a bug to
the user. For case (3), that may also be intentional by the user (not
recommended though).

So I am afraid that a warning may trigger false-positives and may not be
that useful in the end.

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
