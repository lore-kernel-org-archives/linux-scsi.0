From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: Re: [PATCH 3/5] sd: Implement support for ZBC devices
Date: Wed, 20 Jul 2016 09:54:40 +0900
Message-ID: <09e7748c-1c39-947f-5819-0a70c8fb06ee@hgst.com>
References: <1468934710-93876-1-git-send-email-hare@suse.de>
 <1468934710-93876-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31149 "EHLO
	esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbcGTAyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2016 20:54:50 -0400
In-Reply-To: <1468934710-93876-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>


On 7/19/16 22:25, Hannes Reinecke wrote:
> Implement ZBC support functions to read in the zone information
> and setup the zone tree.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/Kconfig  |   8 +
>  drivers/scsi/Makefile |   1 +
>  drivers/scsi/sd.c     | 129 ++++++------
>  drivers/scsi/sd.h     |  54 +++++
>  drivers/scsi/sd_zbc.c | 538 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 670 insertions(+), 60 deletions(-)
>  create mode 100644 drivers/scsi/sd_zbc.c
[...]
> +/**
> + * sd_zbc_update_zones - Update zone information for @sector
> + * @sdkp: SCSI disk for which the zone information needs to be updated
> + * @sector: sector to be updated
> + * @bufsize: buffersize to be allocated
> + * @update: true if existing zones should be updated
> + */
> +void sd_zbc_update_zones(struct scsi_disk *sdkp, sector_t sector, int bufsize,
> +			 bool update)
> +{
> +	struct request_queue *q = sdkp->disk->queue;
> +	struct zbc_update_work *zbc_work;
> +	struct blk_zone *zone;
> +	struct rb_node *node;
> +	int zone_num = 0, zone_busy = 0, num_rec;
> +	sector_t next_sector = sector;
> +
> +	if (test_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags)) {
> +		sd_zbc_debug(sdkp,
> +			     "zones in reset, not starting update\n");
> +		return;
> +	}
> +
> +retry:
> +	zbc_work = kzalloc(sizeof(struct zbc_update_work) + bufsize,
> +			   update ? GFP_NOWAIT : GFP_KERNEL);

Christoph suggested that GFP_ATOMIC is more appropriate here instead of 
GFP_NOWAIT.

Reviewed-by: Damien Le Moal <damien.lemoal@hgst.com>
Tested-by: Damien Le Moal <damien.lemoal@hgst.com>

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Group, HGST Research,
HGST, a Western Digital brand
Damien.LeMoal@hgst.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.hgst.com
Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.

