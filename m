From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 12/12] block: Introduce zoned I/O scheduler
Date: Fri, 15 Sep 2017 12:55:44 +0200
Message-ID: <3aaebd58-bce1-01ab-7b70-4bbe255faaba@suse.de>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
 <20170915100645.17999-13-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40503 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751157AbdIOKzs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Sep 2017 06:55:48 -0400
In-Reply-To: <20170915100645.17999-13-damien.lemoal@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

On 09/15/2017 12:06 PM, Damien Le Moal wrote:
> The zoned I/O scheduler is mostly identical to mq-deadline and retains
> the same configuration attributes. The main difference is that the
> zoned scheduler will ensure that at any time at most one write request
> per sequential zone is in flight (has been dispatched to the disk) in
> order to protect against potential sequential write reordering
> resulting from the concurrent execution of request dispatch by multiple
> contexts.
> 
> This is achieved similarly to the legacy SCSI I/O path by write locking
> zones when a write requests is issued. Subsequent writes to the same
> zone have to wait for the completion of the previously issued write
> before being in turn dispatched to the disk. This ensures that
> sequential writes are processed in the correct order without needing
> any modification to the execution model of blk-mq. In addition, this
> also protects against write reordering at the HBA level (e.g. AHCI).
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  Documentation/block/zoned-iosched.txt |  48 ++
>  block/Kconfig.iosched                 |  12 +
>  block/Makefile                        |   1 +
>  block/zoned-iosched.c                 | 925 ++++++++++++++++++++++++++++++++++
>  4 files changed, 986 insertions(+)
>  create mode 100644 Documentation/block/zoned-iosched.txt
>  create mode 100644 block/zoned-iosched.c
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
