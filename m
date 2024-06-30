Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0296F38F83;
	Sun, 30 Jun 2024 20:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719779306; cv=none; b=DBhCRD3/bg01ethteYbNvNl7XKgvFi30szn1JokhTGQFD6QP9xFVp+h492HJaoW+bvcr/t/Jj/cGY+4xOCRYRjFVHkI43fXEgWXoLhQGpIRGksocjbjkA+Q3KfX65TADIZTWgxcnrOUScydlwLeYPucLX0h7MiBIc2ltc7Ndg7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719779306; c=relaxed/simple;
	bh=U/sA5MvJUBq8h5fhwadRVxY167JDsQ8uDvBteyNAt7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u+gs1AiOIL+XQ6r/8d6hUQTiZUUQrmpSw/n/s2E1oiYMtLmov3CqvhYt5B8BtvXS1X+5O1vcrCUX7mXJKVDkv8SC9dlKlAoP2AV2b+Um0xQTbO1pgAYpjmTyYZlDNL3hDPs6UcMmzbrwaX8Y8dXRfQ15wX1mhc8GpEJb4qqV3Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qhTHesS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qhTHesS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5512EC2BD10;
	Sun, 30 Jun 2024 20:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719779305;
	bh=U/sA5MvJUBq8h5fhwadRVxY167JDsQ8uDvBteyNAt7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qhTHesS+BsEr3wWdMtUtimKHbszm3etVLugwxjd8r+Kl3hIupHkfsZFoQ65L4UpHB
	 SsLLcqmZWGN8OPV+Wqtdi0cOTr8NJ+tdp0ewEDRTpRhSn1vUEacRRTZsbI70A2xhve
	 ThU4VzC+BmZOFMJjQ4gKQJjjjTA535K5vZr/I0NqQK6woOgjKZJd+UB0gjfsU78aXj
	 cux7UmY9Zhxzy83FrkP8HrRvhw0hPHAEZ2xCTBMR73kjgjnCVOYIHooLuAGxxKQlIx
	 TDv83SUbHsk/PfasOnBjYQN2yWI23LmlIvKGNFcVZodxHwMXo/UT+9PXIq7uTQqkxI
	 K2C8YAaRNw2dA==
Date: Sun, 30 Jun 2024 22:28:20 +0200
From: Niklas Cassel <cassel@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Jason Yan <yanaijie@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
	Niklas Cassel <niklas.cassel@wdc.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/4] ata,scsi: libata-core: Do not leak memory for
 ata_port struct members
Message-ID: <ZoG_5Jvo8_fEt_8I@ryzen.lan>
References: <20240629124210.181537-6-cassel@kernel.org>
 <20240629124210.181537-8-cassel@kernel.org>
 <18252752-d3ed-4924-ae5c-4d3e0120d973@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18252752-d3ed-4924-ae5c-4d3e0120d973@oracle.com>

On Sun, Jun 30, 2024 at 10:42:45AM +0100, John Garry wrote:
> On 29/06/2024 13:42, Niklas Cassel wrote:
> > libsas is currently not freeing all the struct ata_port struct members,
> > e.g. ncq_sense_buf for a driver supporting Command Duration Limits (CDL).
> > 
> > Add a function, ata_port_free(), that is used to free a ata_port,
> > including its struct members. It makes sense to keep the code related to
> > freeing a ata_port in its own function, which will also free all the
> > struct members of struct ata_port.
> > 
> > Fixes: 18bd7718b5c4 ("scsi: ata: libata: Handle completion of CDL commands using policy 0xD")
> > Signed-off-by: Niklas Cassel <cassel@kernel.org>
> 
> Apart from a couple of nitpicks:
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
> > ---
> >   drivers/ata/libata-core.c          | 24 ++++++++++++++----------
> >   drivers/scsi/libsas/sas_ata.c      |  2 +-
> >   drivers/scsi/libsas/sas_discover.c |  2 +-
> >   include/linux/libata.h             |  1 +
> >   4 files changed, 17 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> > index f47838da75d7..481baa55ebfc 100644
> > --- a/drivers/ata/libata-core.c
> > +++ b/drivers/ata/libata-core.c
> > @@ -5490,6 +5490,18 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
> >   	return ap;
> >   }
> > +void ata_port_free(struct ata_port *ap)
> > +{
> > +	if (!ap)
> > +		return;
> 
> nit: personally I'd have the caller check this. The main reason for that is
> that often it seems an unnecessary check.

People are used to free() family of functions handling NULL,
so I think it is wise to keep it as is.


> 
> > +
> > +	kfree(ap->pmp_link);
> > +	kfree(ap->slave_link);
> > +	kfree(ap->ncq_sense_buf);
> > +	kfree(ap);
> > +}
> > +EXPORT_SYMBOL_GPL(ata_port_free);
> > +
> >   static void ata_devres_release(struct device *gendev, void *res)
> >   {
> >   	struct ata_host *host = dev_get_drvdata(gendev);
> > @@ -5516,15 +5528,7 @@ static void ata_host_release(struct kref *kref)
> >   	int i;
> >   	for (i = 0; i < host->n_ports; i++) {
> > -		struct ata_port *ap = host->ports[i];
> > -
> > -		if (!ap)
> > -			continue;
> > -
> > -		kfree(ap->pmp_link);
> > -		kfree(ap->slave_link);
> > -		kfree(ap->ncq_sense_buf);
> > -		kfree(ap);
> > +		ata_port_free(host->ports[i]);
> >   		host->ports[i] = NULL;
> >   	}
> >   	kfree(host);
> > @@ -5907,7 +5911,7 @@ int ata_host_register(struct ata_host *host, const struct scsi_host_template *sh
> >   	 * allocation time.
> >   	 */
> >   	for (i = host->n_ports; host->ports[i]; i++)
> > -		kfree(host->ports[i]);
> > +		ata_port_free(host->ports[i]);
> >   	/* give ports names and add SCSI hosts */
> >   	for (i = 0; i < host->n_ports; i++) {
> > diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> > index 4c69fc63c119..1f247a8cd185 100644
> > --- a/drivers/scsi/libsas/sas_ata.c
> > +++ b/drivers/scsi/libsas/sas_ata.c
> > @@ -618,7 +618,7 @@ int sas_ata_init(struct domain_device *found_dev)
> >   	return 0;
> >   destroy_port:
> > -	kfree(ap);
> > +	ata_port_free(ap);
> 
> nit: If not a nuisance, could we change the label name to free_port, like
> free_host, below. No big deal.

Sure, will fixup when applying.


> 
> >   free_host:
> >   	ata_host_put(ata_host);
> >   	return rc;
> > diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> > index 8fb7c41c0962..48d975c6dbf2 100644
> > --- a/drivers/scsi/libsas/sas_discover.c
> > +++ b/drivers/scsi/libsas/sas_discover.c
> > @@ -301,7 +301,7 @@ void sas_free_device(struct kref *kref)
> >   	if (dev_is_sata(dev) && dev->sata_dev.ap) {
> >   		ata_sas_tport_delete(dev->sata_dev.ap);
> > -		kfree(dev->sata_dev.ap);
> > +		ata_port_free(dev->sata_dev.ap);
> >   		ata_host_put(dev->sata_dev.ata_host);
> >   		dev->sata_dev.ata_host = NULL;
> >   		dev->sata_dev.ap = NULL;
> > diff --git a/include/linux/libata.h b/include/linux/libata.h
> > index 13fb41d25da6..7d3bd7c9664a 100644
> > --- a/include/linux/libata.h
> > +++ b/include/linux/libata.h
> > @@ -1249,6 +1249,7 @@ extern int ata_slave_link_init(struct ata_port *ap);
> >   extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
> >   					   struct ata_port_info *, struct Scsi_Host *);
> >   extern void ata_port_probe(struct ata_port *ap);
> > +extern void ata_port_free(struct ata_port *ap);
> >   extern int ata_sas_tport_add(struct device *parent, struct ata_port *ap);
> >   extern void ata_sas_tport_delete(struct ata_port *ap);
> >   int ata_sas_device_configure(struct scsi_device *sdev, struct queue_limits *lim,
> 
