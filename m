From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH] sd_zbc: Write unlock zone from sd_uninit_cmnd()
Date: Wed, 9 Aug 2017 11:19:44 +0900
Message-ID: <d0bdb1af-7d37-9fa2-62e9-56b2ff315924@wdc.com>
References: <20170808041746.31341-1-damien.lemoal@wdc.com>
 <1502204867.2250.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:48027 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751919AbdHICU5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2017 22:20:57 -0400
In-Reply-To: <1502204867.2250.1.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>

Bart,

On 8/9/17 00:07, Bart Van Assche wrote:
> On Tue, 2017-08-08 at 13:17 +0900, Damien Le Moal wrote:
>> Releasing the write lock of a zone when the write commnand that
>                                                     ^^^^^^^^
>                                                     command?
>> acquired the lock completes can cause deadlocks with scsi-mq due to
>> potential queue reordering if the lock owning request is requeued and
>> not executed.
> 
> Please note that even with scsi-sq requeueing can cause request reordering.

I am painfully aware of this fact... I will update the commit message to
reflect this.

>> Since sd_uninit_cmnd() is always called when a request is requeued,
>> call sd_zbc_write_unlock_zone() from that function for write requests
>> that acquired a zone lock. Acquisition of a zone lock by a write command
>> is indicated using the new command flag SCMD_ZONE_WRITE_LOCK.
> 
> Hello Damien,
> 
> Since this patch differs slightly from the version that was posted a few
> days ago, should a "v2" label have been added to the subject and should a
> changelog have been included? Anyway:

Yes, forgot to do that. Reposting.

> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>

Thanks.

-- 
Damien Le Moal,
Western Digital
