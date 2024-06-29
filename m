Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147993F9F9;
	Sat, 29 Jun 2024 12:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719662991; cv=none; b=CDy81nmfFJpTmx2SOhK5MIH9tG8ZXuRrpRKQWtlPJKRpRU1/JsXIkLiQOV3lv+tkLxHR2RuFHA/5KQZkoX8cC3qcOtahifm70iYsMQF5ztko9qUMI0e1lLu3NfRlZZ6q4IhNwaEGF4DK+4/S+z49iNC4zsZOeasI0/Iej7h5I0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719662991; c=relaxed/simple;
	bh=ts+Uxe4L0bZIoIgpiJ9xP8rIlcc8SP6g7dVg9bhl8gA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ds7SeomkBcUfkywwYTiUzVNapQyqXZcPFdIgz/iwBNry30Sx72w4UEpqjjYM+HM2WOuyb/cgWU+6lb+4vO3JfLuM2gmgj8RDAM30F3DnEJtQ02SKOmYxCPBzY0+EhHncLeThvw9WX4O8FRJvInJxGSwuKgUdXNqqa7TM96A4YoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VANeUdnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VANeUdnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21830C2BBFC;
	Sat, 29 Jun 2024 12:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719662990;
	bh=ts+Uxe4L0bZIoIgpiJ9xP8rIlcc8SP6g7dVg9bhl8gA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VANeUdncAiSm00tYmxbJlFaqAvWC7q293Kwsq8sjZJ+WU5jnJ+5QRojUdn7GWuAoq
	 J8/JojN7Y7nIZyqryy8oWlbKat7CfqWqhWe+P92cRL4e+lcpnNuE7RI5rzQfrUOWM/
	 Or5ZpCx7ZtYTaswRjqmDUNNIwfXceaElhRr7T5vntahO+rUa8IS5M6UhaDmumMzzNN
	 S7JCsvf94QksVgWhzfmgHYPNcAVoiwIorQtXwbqLao9YwL4mZr+iFCC7x34C1NoUJX
	 FrKbLsIHyiFLrxKYorPt0OjcpY/59bomG+YmiurWg8V6fFjtPFabgsawTVIqkDK5dz
	 iXWy7J3qtuNrg==
Date: Sat, 29 Jun 2024 14:09:45 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 05/13] ata,scsi: libata-core: Add ata_port_free()
Message-ID: <Zn_5ifLxcF9JCGH6@ryzen.lan>
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-20-cassel@kernel.org>
 <ec3be157-4096-4817-885b-1cb90ca032b2@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec3be157-4096-4817-885b-1cb90ca032b2@kernel.org>

On Thu, Jun 27, 2024 at 10:15:37AM +0900, Damien Le Moal wrote:
> On 6/27/24 03:00, Niklas Cassel wrote:
> > Add a function, ata_port_free(), that is used to free a ata_port.
> > It makes sense to keep the code related to freeing a ata_port in its own
> > function, which will also free all the struct members of struct ata_port.
> > 
> > libsas is currently not freeing all the struct ata_port struct members,
> > e.g. ncq_sense_buf for a driver supporting Command Duration Limits (CDL).
> 
> This part should be a separate fix patch and sent out this cycle.
> 
> > 
> > Signed-off-by: Niklas Cassel <cassel@kernel.org>
> 
> > @@ -5518,12 +5530,7 @@ static void ata_host_release(struct kref *kref)
> >  	for (i = 0; i < host->n_ports; i++) {
> >  		struct ata_port *ap = host->ports[i];
> >  
> > -		if (ap) {
> > -			kfree(ap->pmp_link);
> > -			kfree(ap->slave_link);
> > -			kfree(ap->ncq_sense_buf);
> > -			kfree(ap);
> > -		}
> > +		ata_port_free(ap);
> 
> The variable "ap" can be removed too.
> 
> >  		host->ports[i] = NULL;
> >  	}
> >  	kfree(host);
> 
> > diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> > index 6e01ddec10c9..951bdc554a10 100644
> > --- a/drivers/scsi/libsas/sas_discover.c
> > +++ b/drivers/scsi/libsas/sas_discover.c
> > @@ -301,7 +301,7 @@ void sas_free_device(struct kref *kref)
> >  
> >  	if (dev_is_sata(dev) && dev->sata_dev.ap) {
> >  		ata_tport_delete(dev->sata_dev.ap);
> > -		kfree(dev->sata_dev.ap);
> > +		ata_port_free(dev->sata_dev.ap);
> 
> Why not have this inside ata_tport_delete() ?

In the current code, the allocating and freeing of the ports
are done separately from adding and deleting a transport.

The tport_del will be called by:
ahci_remove_one()

drivers/base/dd.c:__device_release_driver() will call
device_remove() which will call ahci_remove_one().

ahci_remove_one() (.remove()), will call ata_host_detach(), which calls
ata_port_detach(), which calls ata_tport_delete().

This will not free the port however. That is instead done even later, by:
ata_host_release() will be called even later:
drivers/base/dd.c:__device_release_driver() will call
device_unbind_cleanup(), which will call ata_host_release().

We could evaluate if we want to change this, since ALL libata driver do
call tport_add()/tport_delete(), but since this is a fix patch, I would
rather not do fundamental changes like that in this patch.


> 
> >  		ata_host_put(dev->sata_dev.ata_host);
> >  		dev->sata_dev.ata_host = NULL;
> >  		dev->sata_dev.ap = NULL;
> > diff --git a/include/linux/libata.h b/include/linux/libata.h
> > index 581e166615fa..586f0116d1d7 100644
> > --- a/include/linux/libata.h
> > +++ b/include/linux/libata.h
> > @@ -1249,6 +1249,7 @@ extern int ata_slave_link_init(struct ata_port *ap);
> >  extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
> >  					   struct ata_port_info *, struct Scsi_Host *);
> >  extern void ata_port_probe(struct ata_port *ap);
> > +extern void ata_port_free(struct ata_port *ap);
> >  extern int ata_tport_add(struct device *parent, struct ata_port *ap);
> >  extern void ata_tport_delete(struct ata_port *ap);
> >  int ata_sas_device_configure(struct scsi_device *sdev, struct queue_limits *lim,
> 
> -- 
> Damien Le Moal
> Western Digital Research
> 
