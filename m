From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID
 controller
Date: Fri, 12 Jun 2009 10:24:35 -0500
Message-ID: <1244820275.4184.27.camel@mulgrave.site>
References: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca>
	 <4A31319C.605@linux.vnet.ibm.com>
	 <da824cf30906120808o7857034an32640102d64ca106@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58838 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759076AbZFLPYi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2009 11:24:38 -0400
In-Reply-To: <da824cf30906120808o7857034an32640102d64ca106@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, gregkh@suse.de

On Fri, 2009-06-12 at 08:08 -0700, Grant Grundler wrote:
> >> +     list_for_each_entry(temp, &pinstance->used_res_q, queue) {
> >> +
> >> +             /* do not expose VSETs with order-ids >= 240 */
> >> +             if (RES_IS_VSET(temp->cfg_entry)) {
> >> +                     target = temp->cfg_entry.unique_flags1;
> >> +                     if (target >= PMCRAID_MAX_VSET_TARGETS)
> >> +                             continue;
> >> +                     bus = PMCRAID_VSET_BUS_ID;
> >> +                     lun = 0;
> >> +             } else if (RES_IS_GSCSI(temp->cfg_entry)) {
> >> +                     target = RES_TARGET(temp->cfg_entry.resource_address);
> >> +                     bus = PMCRAID_PHYS_BUS_ID;
> >> +                     lun = RES_LUN(temp->cfg_entry.resource_address);
> >
> > I assume this means this adapter only supports single byte LUNs...
> 
> ISTR, SCSI-3 spec only defines 5-bits for the LUN field...but my SCSI-foo
> pretty old and I might misremember. It was easy to find this reference:
>     http://en.wikipedia.org/wiki/SCSI_Read_Commands
> 
> I'm sure there something better from t10.org but everything requires
> a login now and I'm sure someone here will just know this.

Actually, no, that was SCSI-2, and even there we used transport updates
to go beyond 32 LUNs.

SCSI-3 defines lun hierarchies up to 8 bytes long.  Identifying the LUN
when you send a command is now the job of the transport.

What brian means is the definition of the lun variable is only 8 bytes
long:

> +	u8 target, bus, lun;

However, if you look at the RES_LUN() definition, it doesn't actually
support any LUNs at all:

> +#define RES_LUN(res_addr)    0x0

James


