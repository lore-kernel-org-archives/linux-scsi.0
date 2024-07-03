Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5111DA313;
	Wed,  3 Jul 2024 18:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720032143; cv=none; b=mAxetj4Crvt5KO2RmJBz+URdKfWnDx6HNEBC0qs38Bdo3Vpe+wk7LnzB4z68yTIQhrlkA5oz25GoRtWNdeG65xSzj4ko1+GgWY41ixlRCtnyIbCbQUqWlTIpQZDaHnu/GU4N/KAmpSk/kF8CxcY+gvwZfB9AfRg0D7lj8gJ+NSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720032143; c=relaxed/simple;
	bh=cNSS+Cez9IH/7B7gafdyMnyWXsNccVw8bJBAVv+UVyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E8HoqmIbabPbPD6DbOt4/VMkCStQa9Z/gXBuwQKxGvAoZLx3JyzLDmG+p2fauTNzb4CsS5E82EdObvR/TKCrt3kIifsbk9gmrdjdHW1WfIgsOjYubwgUmzcIvDfblN+a5u6407zoBLPR/QwZL5DWRHakwTLe7NYwYMLZp0dcO1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzFJOHYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzFJOHYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F3DC2BD10;
	Wed,  3 Jul 2024 18:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720032142;
	bh=cNSS+Cez9IH/7B7gafdyMnyWXsNccVw8bJBAVv+UVyA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bzFJOHYYa05Vrhpd2W0x8LhrRuFI+94qBTWqBsEi2mxyNM8wi1kMWjWV2/0pQhhdU
	 /cazu3/R9NYeF4E5W8gz64YwDsV70DP/MZUxaVDwPSrzNe8tqvW8ZS9ESM7PhN/Fmm
	 FZXsrWUrMki2kNTDuQn4vYELtBdQSjx92gohYBzIoKHQz3StvunSwjABACL7cHk244
	 poE1ezV5zVHFJesIX02PrFaDxuQMsvkZvGlO7EBXqJjMkIJ9Qc5NyypbVGuo1ZhVcf
	 LFbFiTFDvxNZVI9tplg7utMGsJRt9F1boDa3qKSSFD5RcE3agKrq2NeO+KTz+moe3q
	 uDladU4SvTXCg==
Date: Wed, 3 Jul 2024 20:42:17 +0200
From: Niklas Cassel <cassel@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
	linux-ide@vger.kernel.org
Subject: Re: [PATCH v3 8/9] ata,scsi: Remove useless ata_sas_port_alloc()
 wrapper
Message-ID: <ZoWbiWZ6v7h9v8XH@ryzen.lan>
References: <20240702160756.596955-11-cassel@kernel.org>
 <20240702160756.596955-19-cassel@kernel.org>
 <665021a5-b17b-41ac-9d45-792ad403f1dc@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <665021a5-b17b-41ac-9d45-792ad403f1dc@oracle.com>

On Wed, Jul 03, 2024 at 11:20:51AM +0100, John Garry wrote:
> On 02/07/2024 17:08, Niklas Cassel wrote:
> > Now when the ap->print_id assignment has moved to ata_port_alloc(),
> > we can remove the useless ata_sas_port_alloc() wrapper.
> 
> nit: I don't know why you say it is useless. It is used today, so has some
> use, right?
> 
> I'd be more inclined to say that it is only used in one location, so can be
> inlined there.

Sure, I will clarify the commit message.
(I will also clarify the commit message for the other commit that also
says 'remove useless wrappers'.)


> 
> > 
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Niklas Cassel <cassel@kernel.org>
> > ---
> >   drivers/ata/libata-core.c     |  1 +
> >   drivers/ata/libata-sata.c     | 35 -----------------------------------
> >   drivers/ata/libata.h          |  1 -
> >   drivers/scsi/libsas/sas_ata.c | 10 ++++++++--
> >   include/linux/libata.h        |  3 +--
> >   5 files changed, 10 insertions(+), 40 deletions(-)
> > 
> > diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> > index 5031064834be..22e7b09c93b1 100644
> > --- a/drivers/ata/libata-core.c
> > +++ b/drivers/ata/libata-core.c
> > @@ -5493,6 +5493,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
> >   	return ap;
> >   }
> > +EXPORT_SYMBOL_GPL(ata_port_alloc);
> >   void ata_port_free(struct ata_port *ap)
> >   {
> > diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> > index b602247604dc..48660d445602 100644
> > --- a/drivers/ata/libata-sata.c
> > +++ b/drivers/ata/libata-sata.c
> > @@ -1204,41 +1204,6 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
> >   }
> >   EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
> > -/**
> > - *	ata_sas_port_alloc - Allocate port for a SAS attached SATA device
> > - *	@host: ATA host container for all SAS ports
> > - *	@port_info: Information from low-level host driver
> > - *	@shost: SCSI host that the scsi device is attached to
> > - *
> > - *	LOCKING:
> > - *	PCI/etc. bus probe sem.
> > - *
> > - *	RETURNS:
> > - *	ata_port pointer on success / NULL on failure.
> > - */
> > -
> > -struct ata_port *ata_sas_port_alloc(struct ata_host *host,
> > -				    struct ata_port_info *port_info,
> > -				    struct Scsi_Host *shost)
> > -{
> > -	struct ata_port *ap;
> > -
> > -	ap = ata_port_alloc(host);
> > -	if (!ap)
> > -		return NULL;
> > -
> > -	ap->port_no = 0;
> > -	ap->pio_mask = port_info->pio_mask;
> > -	ap->mwdma_mask = port_info->mwdma_mask;
> > -	ap->udma_mask = port_info->udma_mask;
> > -	ap->flags |= port_info->flags;
> > -	ap->ops = port_info->port_ops;
> > -	ap->cbl = ATA_CBL_SATA;
> > -
> > -	return ap;
> > -}
> > -EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
> > -
> >   /**
> >    *	ata_sas_device_configure - Default device_configure routine for libata
> >    *				   devices
> > diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> > index 5ea194ae8a8b..6abf265f626e 100644
> > --- a/drivers/ata/libata.h
> > +++ b/drivers/ata/libata.h
> > @@ -81,7 +81,6 @@ extern void ata_link_init(struct ata_port *ap, struct ata_link *link, int pmp);
> >   extern int sata_link_init_spd(struct ata_link *link);
> >   extern int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg);
> >   extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
> > -extern struct ata_port *ata_port_alloc(struct ata_host *host);
> >   extern const char *sata_spd_string(unsigned int spd);
> >   extern unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
> >   				      u8 page, void *buf, unsigned int sectors);
> > diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> > index ab4ddeea4909..80299f517081 100644
> > --- a/drivers/scsi/libsas/sas_ata.c
> > +++ b/drivers/scsi/libsas/sas_ata.c
> > @@ -597,13 +597,19 @@ int sas_ata_init(struct domain_device *found_dev)
> >   	ata_host_init(ata_host, ha->dev, &sas_sata_ops);
> > -	ap = ata_sas_port_alloc(ata_host, &sata_port_info, shost);
> > +	ap = ata_port_alloc(ata_host);
> >   	if (!ap) {
> > -		pr_err("ata_sas_port_alloc failed.\n");
> > +		pr_err("ata_port_alloc failed.\n");
> 
> nit: Are these really useful prints? AFAICS, ata_port_alloc() can only fail
> due to ENOMEM and we generally don't print ENOMEM errors in drivers. I know
> that we change the error code, below, but still I doubt its value.

ata_port_alloc() can also fail if there are no free IDs (ida_alloc_min()
returns -ENOSPC), so I will leave the print for now.


> 
> >   		rc = -ENODEV;
> >   		goto free_host;
> >   	}
> > +	ap->port_no = 0;
> > +	ap->pio_mask = sata_port_info.pio_mask;
> 
> Why do we even have sata_port_info now, if we are not passing a complete
> structure? I mean, why not:
> 
> 	ap->pio_mask = ATA_PI04;

Good point, I will remove the structure and perform the initialization
directly, like you are suggesting. This will remove even more lines :)


> 
> > +	ap->mwdma_mask = sata_port_info.mwdma_mask;
> > +	ap->udma_mask = sata_port_info.udma_mask;
> > +	ap->flags |= sata_port_info.flags;
> > +	ap->ops = sata_port_info.port_ops;
> >   	ap->private_data = found_dev;
> >   	ap->cbl = ATA_CBL_SATA;
> >   	ap->scsi_host = shost;
> > diff --git a/include/linux/libata.h b/include/linux/libata.h
> > index 84a7bfbac9fa..17394098bee9 100644
> > --- a/include/linux/libata.h
> > +++ b/include/linux/libata.h
> > @@ -1244,9 +1244,8 @@ extern int sata_link_debounce(struct ata_link *link,
> >   extern int sata_link_scr_lpm(struct ata_link *link, enum ata_lpm_policy policy,
> >   			     bool spm_wakeup);
> >   extern int ata_slave_link_init(struct ata_port *ap);
> > -extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
> > -					   struct ata_port_info *, struct Scsi_Host *);
> >   extern void ata_port_probe(struct ata_port *ap);
> > +extern struct ata_port *ata_port_alloc(struct ata_host *host);
> >   extern void ata_port_free(struct ata_port *ap);
> >   extern int ata_tport_add(struct device *parent, struct ata_port *ap);
> >   extern void ata_tport_delete(struct ata_port *ap);
> 
