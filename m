From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] SCSI: Synchronization issue while deleting vport
Date: Mon, 08 Mar 2010 22:42:44 +0530
Message-ID: <1268068364.10660.0.camel@mulgrave.site>
References: <1264061732.31083.51.camel@galr-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34519 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab0CHRMu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Mar 2010 12:12:50 -0500
In-Reply-To: <1264061732.31083.51.camel@galr-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gal Rosen <galr@storwize.com>
Cc: linux-scsi@vger.kernel.org, James.Smart@Emulex.Com

On Thu, 2010-01-21 at 10:15 +0200, Gal Rosen wrote:
> diff --git a/drivers/scsi/scsi_transport_fc.c
> b/drivers/scsi/scsi_transport_fc.c
> index 5fd64e7..be96eb0 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -1217,6 +1217,15 @@ store_fc_vport_delete(struct device *dev,
> struct device_attribute *attr,
>  {
>         struct fc_vport *vport = transport_class_to_vport(dev);
>         struct Scsi_Host *shost = vport_to_shost(vport);
> +       unsigned int flags;
> +
> +       spin_lock_irqsave(shost->host_lock, flags);

For a spinlock flags has to be unsigned long, not unsigned int ... but I
can fix that up.

James


