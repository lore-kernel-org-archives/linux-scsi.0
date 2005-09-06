From: James.Smart@Emulex.Com
Subject: RE: [PATCH] SAS transport class
Date: Tue, 6 Sep 2005 09:40:43 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A75@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:28385 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932462AbVIFNlB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Sep 2005 09:41:01 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de, linux-scsi@vger.kernel.org


> +/**
> + * sas_rport_alloc  --  allocates and initialize a SAS 
> remote port structure
> + * @grandparent:	Parent device of the parent SAS port
> + * @port:		Port number of the parent SAS port
> + * @channel:		SCSI Core channel number
> + * @id:			SCSI Core target id
> + *
> + * Allocates an SAS remote port structure, connected to the 
> port @port of the
> + * Scsi_Host or sas_rport specified by @grandparent.
> + *
> + * Note:
> + *	@channel and @id only make sense for sas ports that 
> support protocols
> + *	support by the SCSI subsystem (ssp, stp or direct 
> attached sata).
> + *
> + *	@id will go away soon, and there will be no visible 
> SPI-ish target
> + *	ID visible to SAS LLDDs.
> + *
> + * Returns:
> + *	SAS port allocated or %NULL if the allocation failed.
> + */
> +struct sas_rport *sas_rport_alloc(struct device *grandparent,
> +		int port, uint channel, uint id)
> +{
> +	struct Scsi_Host *shost = dev_to_shost(grandparent);
> +	struct sas_port *parent;
> +	struct sas_rport *rport;
> +
> +	parent = sas_port_lookup(grandparent, port);
> +	if (!parent)
> +		return NULL;

So this is odd... grandparent ?  why pass in port # (you should
know the object already)?  why is channel skipping over / not
associated with the local port ?

What I would have expected is : 

- sas_port_alloc() to either:
  a) also have a "channel" argument, which gets saved in the local
     port.
  -or-
  b) The port # is actually used as the channel #.

- sas_rport_alloc() becomes:
    sas_rport_alloc(struct device *parent, uint id)
  Where parent is the local port. You can still obtain the shost
  via dev_to_shost(parent), and you can kill all that port searching
  logic.

I'll point out, but not delve into - that you've avoided the target
id bindings again, thus forcing the lldd's/adapters to maintain tables
of port#/SASaddr to target id (if they care, and I believe enterprise
storage will care!).  I can understand if you're going to eventually
insert a generic abstraction layer for scsi's b/c/t/l addressing
scheme, but since it's not here today, I expect you to hold SAS to the
same "code sharing" level as FC.

Also, to deal with cable pulls, SAS reconfiguration and rescanning,
I expect that you will need to add in the block/unblock functionality
that the FC transport has.  [Note: we've seen an issue in the current
FC design, so expect a transport update].

> +void sas_rport_add(struct sas_rport *rport)
> +{
> ....
> +	if (identify->device_type == SAS_END_DEVICE &&
> +	    (identify->target_port_protocols &
> +	     (SAS_PROTOCOL_SSP|SAS_PROTOCOL_STP|SAS_PROTOCOL_SATA)))
> +		scsi_scan_target(&rport->dev, rport->channel,
> +				rport->id, ~0, 0);

I highly recommend the use of workqueues for the scan function as we
did in the fc transport.

-- james s
