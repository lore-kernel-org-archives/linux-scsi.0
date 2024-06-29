Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A188E22331;
	Sat, 29 Jun 2024 12:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719663847; cv=none; b=SNWOT3Ee/U5jfETRUCHTQlAFy8/1tZ7N4pZhrmrrclrbaVSEOiMnGhXoGmOyk9m4MDexhSxhw2fBd44iyirmXScTHTT9P1W5InOJ2JtRgbYcAc3rMsX3m9DkOnE20ocx/Ictu6VcFr2/yNSlnsKN8z7IbIsLe0FxlMTvJVWBX+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719663847; c=relaxed/simple;
	bh=zPXo+n3//dk6HIjF0ZxI18E903fUAYP6h6eLp5AOcUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mZusBso6h46SNZvLp8n11W6GWgPaOC13ztuRu4kqMwmfXF0qsLmXEPPTo+LWOfaKnTOhH0qEZn/ap/qtNgXnqx3JMTINihUVcE/LgnG1A+77qxwqA2YnPg5EMHKUhR3BfqVGGrUa9xnYFTwuvirgakyX5t/Y+9a30ECA/3UGM3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWC7eFxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWC7eFxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A2AC2BBFC;
	Sat, 29 Jun 2024 12:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719663847;
	bh=zPXo+n3//dk6HIjF0ZxI18E903fUAYP6h6eLp5AOcUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jWC7eFxo9EmEU/qLepHwBgiBqZRJ8fYGgK6cnnkWscIMPGkTo3KucFVZvu5oWzLQw
	 AaHquY9utrPeWKiVos9qif0deUHr3rJYf/3LcpyJcyeXc3/xb1vfFfqo27dt4jAmG2
	 fejU4+LNslQpOFsFtMFEOiNItlrAUz+SgEVpPxq0SF2fwx1FKLyHeq8TWF6IeIq88W
	 g2FIXIWVvo+kNTSpo5CQdaSgoDJZD4Ffed6MWIXpuqpH6kgQEW7PFRZ0V6sOh/8RzV
	 ttobVd1kFQDgH2pw8rHUUABfZCpLLGI8X2+NU+Zc2zrriXMG38Di9YTInsECV+pg9W
	 RucRA+pplK7Bw==
Date: Sat, 29 Jun 2024 14:24:02 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 07/13] ata: libata-core: Remove support for decreasing
 the number of ports
Message-ID: <Zn_84jtODcbCKc3Z@ryzen.lan>
References: <20240626180031.4050226-15-cassel@kernel.org>
 <20240626180031.4050226-22-cassel@kernel.org>
 <e2feb368-5e78-495d-be06-380027663e1f@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2feb368-5e78-495d-be06-380027663e1f@suse.de>

On Thu, Jun 27, 2024 at 08:35:49AM +0200, Hannes Reinecke wrote:
> On 6/26/24 20:00, Niklas Cassel wrote:
> > Commit f31871951b38 ("libata: separate out ata_host_alloc() and
> > ata_host_register()") added ata_host_alloc(), where the API allowed
> > a LLD to overallocate the number of ports supplied to ata_host_alloc(),
> > as long as the LLD decreased host->n_ports before calling
> > ata_host_register().
> > 
> > However, this functionally has never ever been used by a single LLD.
> > 
> > Because of the current API design, the assignment of ap->print_id is
> > deferred until registration time, which is bad, because that means that
> > the ata_port_*() print functions cannot be used by a LLD until after
> > registration time, which means that a LLD is forced to use a print
> > function that is non-port specific, even for a port specific error.
> > 
> > Remove the support for decreasing the number of ports, such that it will
> > be possible to assign ap->print_id earlier.
> > 
> > Signed-off-by: Niklas Cassel <cassel@kernel.org>
> > ---
> >   drivers/ata/libata-core.c | 24 ++++++++++--------------
> >   include/linux/libata.h    |  2 +-
> >   2 files changed, 11 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> > index 591020ea8989..a213a9c0d0a5 100644
> > --- a/drivers/ata/libata-core.c
> > +++ b/drivers/ata/libata-core.c
> > @@ -5550,24 +5550,19 @@ EXPORT_SYMBOL_GPL(ata_host_put);
> >   /**
> >    *	ata_host_alloc - allocate and init basic ATA host resources
> >    *	@dev: generic device this host is associated with
> > - *	@max_ports: maximum number of ATA ports associated with this host
> > + *	@n_ports: the number of ATA ports associated with this host
> >    *
> >    *	Allocate and initialize basic ATA host resources.  LLD calls
> >    *	this function to allocate a host, initializes it fully and
> >    *	attaches it using ata_host_register().
> >    *
> > - *	@max_ports ports are allocated and host->n_ports is
> > - *	initialized to @max_ports.  The caller is allowed to decrease
> > - *	host->n_ports before calling ata_host_register().  The unused
> > - *	ports will be automatically freed on registration.
> > - *
> >    *	RETURNS:
> >    *	Allocate ATA host on success, NULL on failure.
> >    *
> >    *	LOCKING:
> >    *	Inherited from calling layer (may sleep).
> >    */
> > -struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
> > +struct ata_host *ata_host_alloc(struct device *dev, int n_ports)
> >   {
> >   	struct ata_host *host;
> >   	size_t sz;
> > @@ -5575,7 +5570,7 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
> >   	void *dr;
> >   	/* alloc a container for our list of ATA ports (buses) */
> > -	sz = sizeof(struct ata_host) + (max_ports + 1) * sizeof(void *);
> > +	sz = sizeof(struct ata_host) + (n_ports + 1) * sizeof(void *);
> >   	host = kzalloc(sz, GFP_KERNEL);
> >   	if (!host)
> >   		return NULL;
> > @@ -5595,11 +5590,11 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
> >   	spin_lock_init(&host->lock);
> >   	mutex_init(&host->eh_mutex);
> >   	host->dev = dev;
> > -	host->n_ports = max_ports;
> > +	host->n_ports = n_ports;
> >   	kref_init(&host->kref);
> >   	/* allocate ports bound to this host */
> > -	for (i = 0; i < max_ports; i++) {
> > +	for (i = 0; i < n_ports; i++) {
> >   		struct ata_port *ap;
> >   		ap = ata_port_alloc(host);
> > @@ -5908,12 +5903,13 @@ int ata_host_register(struct ata_host *host, const struct scsi_host_template *sh
> >   		return -EINVAL;
> >   	}
> > -	/* Blow away unused ports.  This happens when LLD can't
> > -	 * determine the exact number of ports to allocate at
> > -	 * allocation time.
> > +	/*
> > +	 * For a driver using ata_host_register(), the ports are allocated by
> > +	 * ata_host_alloc(), which also allocates the host->ports array.
> > +	 * The number of array elements must match host->n_ports.
> >   	 */
> >   	for (i = host->n_ports; host->ports[i]; i++)
> > -		kfree(host->ports[i]);
> > +		WARN_ON(host->ports[i]);
> What a patently ugly check.
> So you are relying on the caller to have zeroed the memory upfront.
> But what happens if the caller allocated n_ports, zeroed the memory up to
> that point, and then filled in all 'ports' slots?
> ports[n_ports - 1] is set to a pointer, but ports[n_ports] is _not_
> allocated, and there is no guarantee it'll be zero.
> Causing a memory overrun and all sorts of things.
> 
> This needs to go, as it's now pointless anyway.

For what it is worth, this ugly code was there before this patch :)

However, it seems that ata_host_alloc() allocates max_ports + 1:
https://github.com/torvalds/linux/blob/v6.10-rc5/drivers/ata/libata-core.c#L5568-L5570

So I think this should be safe....

But yes, super ugly...


Kind regards,
Niklas
