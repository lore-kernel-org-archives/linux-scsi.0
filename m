From: Jens Axboe <axboe@suse.de>
Subject: Re: Fw: 2.6.12-mm2: 3ware SATA RAID inaccessible
Date: Tue, 28 Jun 2005 10:25:11 +0200
Message-ID: <20050628082509.GA4410@suse.de>
References: <20050626153941.456543d6.akpm@osdl.org> <1119829031.5038.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:62631 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261734AbVF1IYA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2005 04:24:00 -0400
Content-Disposition: inline
In-Reply-To: <1119829031.5038.15.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, aradford@amcc.com, Nick Orlov <bugfixer@list.ru>

On Sun, Jun 26 2005, James Bottomley wrote:
> +static void tw_unmap_internal(TW_Device_Extension *tw_dev, int request_id)
> +{
> +	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
> +
> +	if (cmd->use_sg) {
> +		struct scatterlist *sg;
> +
> +		sg = (struct scatterlist *)cmd->request_buffer;
> +		kunmap_atomic(sg->page, KM_USER0);

Woops. You have to pass the mapped buffer back in, kunmap_atomic() takes
the returned buffer from kmap_atomic() not the page mapped. Silly yes,
but that is how it is...


-- 
Jens Axboe

