From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID
 controller
Date: Thu, 11 Jun 2009 09:08:12 -0500
Message-ID: <1244729292.3998.9.camel@mulgrave.site>
References: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca>
	 <200906111348.02029.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34995 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813AbZFKOIO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2009 10:08:14 -0400
In-Reply-To: <200906111348.02029.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-scsi@vger.kernel.org, gregkh@suse.de

On Thu, 2009-06-11 at 13:47 +0200, Rolf Eike Beer wrote:
> Anil Ravindranath wrote:
> > +static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
> > +{
> > +	struct pmcraid_resource_entry *temp, *res = NULL;
> > +	struct pmcraid_instance *pinstance;
> > +	u8 target, bus, lun;
> > +	unsigned long lock_flags;
> > +	int rc = -ENXIO;
> > +
> > +	pinstance = (struct pmcraid_instance *)scsi_dev->host->hostdata;
> 
> hostdata is void* AFAIR so there is no need to cast. It's C, there is no need 
> to cast to or from void* anywhere if the other thing is a pointer.

Then please read the actual source *before* commenting.  hostdata is an
unsigned long hostdata[0] in struct Scsi_Host because we elongate the
allocation area by howmuch extra space is requested.

The above statement is technically correct; however, since so many
people get this slightly wrong, we have an inline function shost_priv()
which takes the host and returns a void* pointer to the hostdata area,
so it's much better framed as

pinstance = shost_priv(scsi_dev->host);

James


