From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V3 09/12] scsi: sd_zbc: Initialize device queue zoned
 structure
Date: Fri, 15 Sep 2017 12:49:15 +0200
Message-ID: <0cb4a5e4-9b3b-9b98-119c-e04119ded4eb@suse.de>
References: <20170915100645.17999-1-damien.lemoal@wdc.com>
 <20170915100645.17999-10-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170915100645.17999-10-damien.lemoal@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 09/15/2017 12:06 PM, Damien Le Moal wrote:
> Allocate and initialize the disk request queue zoned structure on disk
> revalidate. As the bitmap allocation for the seq_zones field of the
> zoned structure is identical to the allocation of the zones write lock
> bitmap, introduce the helper sd_zbc_alloc_zone_bitmap().
> Using this helper, wait for the disk capacity and number of zones to
> stabilize on the second revalidation pass to allocate and initialize
> the bitmaps.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/scsi/sd_zbc.c | 119 +++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 114 insertions(+), 5 deletions(-)
> 
I would've been slightly worried about locking; these things tend to be
reset during revalidate, which happens quite frequently for ATA drives.
You sure you don't need it here?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
