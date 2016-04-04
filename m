From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/4] libata: implement ZBC IN translation
Date: Mon, 4 Apr 2016 11:49:24 -0400
Message-ID: <20160404154924.GU7822@mtj.duckdns.org>
References: <1459763271-125856-1-git-send-email-hare@suse.de>
 <1459763271-125856-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:33333 "EHLO
	mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbcDDPt1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2016 11:49:27 -0400
Content-Disposition: inline
In-Reply-To: <1459763271-125856-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

On Mon, Apr 04, 2016 at 11:47:48AM +0200, Hannes Reinecke wrote:
> +/*

/**

> + * ata_scsi_report_zones_complete
> + *
> + * Convert T-13 little-endian field representation into
> + * T-10 big-endian field representation.
> + */
> +static void ata_scsi_report_zones_complete(struct ata_queued_cmd *qc)
> +{
> +	struct scsi_cmnd *scmd = qc->scsicmd;
> +	struct sg_mapping_iter miter;
> +	unsigned long flags;
> +	unsigned int bytes = 0;
> +
> +	sg_miter_start(&miter, scsi_sglist(scmd), scsi_sg_count(scmd),
> +		       SG_MITER_TO_SG | SG_MITER_ATOMIC);
> +
> +	local_irq_save(flags);
> +	while (sg_miter_next(&miter)) {
> +		unsigned int offset = 0;

Not this patch's fault but ugh........  :(

Thanks.

-- 
tejun
