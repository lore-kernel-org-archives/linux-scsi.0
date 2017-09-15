From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 11/12] scsi: sd_zbc: Disable zone write locking with
 scsi-mq
Date: Fri, 15 Sep 2017 12:52:53 +0200
Message-ID: <3c67bba5-a866-b947-5014-947f509a0a19@suse.de>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
 <20170915100645.17999-12-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40340 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751157AbdIOKwz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Sep 2017 06:52:55 -0400
In-Reply-To: <20170915100645.17999-12-damien.lemoal@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

On 09/15/2017 12:06 PM, Damien Le Moal wrote:
> In the case of a ZBC disk used with scsi-mq, zone write locking does
> not prevent write reordering in sequential zones. Unlike the legacy
> case, zone locking is done after the command request is removed from
> the scheduler dispatch queue. That is, at the time of zone locking,
> the write command may already be out of order, making locking
> ineffective. Write order guarantees can only be provided by an
> adapted I/O scheduler.
> 
> Disable zone write locking in sd_zbc_write_lock_zone() if the disk is
> used with scsi-mq. As the disk zones_wlock bitmap is not necessry,
> do not allocate it.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Bart Van Assche <Bart.VanAssche@wdc.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/sd_zbc.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
