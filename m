From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 38/41] hpsa: improve error messages for driver initiated commands
Date: Thu, 16 Jan 2014 10:14:46 -0600
Message-ID: <20140116161446.GD3776@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com> <20140115223938.5061.20062.stgit@beardog.cce.hp.com> <52D79B8C.9070708@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:25792 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaAPPOs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2014 10:14:48 -0500
Content-Disposition: inline
In-Reply-To: <52D79B8C.9070708@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: jbottomley@parallels.com, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com, scameron@beardog.cce.hp.com

On Thu, Jan 16, 2014 at 09:42:52AM +0100, Hannes Reinecke wrote:
> On 01/15/2014 11:39 PM, Stephen M. Cameron wrote:
> > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > 
> > On encountering unexpected error conditions from driver initiated
> > commands, print something useful like CDB and sense data rather than
> > something useless like the kernel virtual address of the command buffer.
> > 
> > Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > ---
> >  drivers/scsi/hpsa.c |   71 ++++++++++++++++++++++++++++++++-------------------
> >  1 files changed, 44 insertions(+), 27 deletions(-)
> > 
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index 6a50a83..d469974 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -1847,17 +1847,37 @@ static void hpsa_scsi_do_simple_cmd_with_retry(struct ctlr_info *h,
> >  	hpsa_pci_unmap(h->pdev, c, 1, data_direction);
> >  }
> >  
> > -static void hpsa_scsi_interpret_error(struct CommandList *cp)
> > +static void hpsa_print_cmd(struct ctlr_info *h, char *txt,
> > +				struct CommandList *c)
> >  {
> > -	struct ErrorInfo *ei;
> > +	const u8 *cdb = c->Request.CDB;
> > +	const u8 *lun = c->Header.LUN.LunAddrBytes;
> > +
> > +	dev_warn(&h->pdev->dev, "%s: LUN:%02x%02x%02x%02x%02x%02x%02x%02x"
> > +	" CDB:%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x\n",
> > +		txt, lun[0], lun[1], lun[2], lun[3],
> > +		lun[4], lun[5], lun[6], lun[7],
> > +		cdb[0], cdb[1], cdb[2], cdb[3],
> > +		cdb[4], cdb[5], cdb[6], cdb[7],
> > +		cdb[8], cdb[9], cdb[10], cdb[11],
> > +		cdb[12], cdb[13], cdb[14], cdb[15]);
> > +}
> Do you _really_ have to do this?
> We do have scsi_logging_level, which would provide exactly 
> this information.

Not exactly, the mid layer could not print the 8-byte LUNID because
it does not and cannot know it ... 

> Can't you rely on the SCSI stack for logging here and drop all
> the redundancy in the driver?

and furthermore, hpsa_print_cmd() is only called by
hpsa_scsi_interpret_error(), which is only called from:

	hpsa_scsi_do_inquiry
	hpsa_send_reset
	hpsa_get_raid_map
	hpsa_scsi_do_report_luns
	hpsa_send_abort
	
none of which are called from a place where this information
could be passed back to the scsi mid layer because the scsi mid
layer did not build the commands for these cases, they are commands
initiated by the driver (as noted in the changelog entry).

> 
> Thing is, the hpsa driver is already quite chatty:
> 
> hpsa 0000:4f:00.0: Direct-Access     device c0b0t0l0 added.
> hpsa 0000:4f:00.0: RAID              device c0b3t0l0 added.
> scsi 0:0:0:0: Direct-Access     HP       LOGICAL VOLUME   7.24 PQ
> : 0 ANSI: 5
> sd 0:0:0:0: [sda] 286677120 512-byte logical blocks: (146 GB/136
> GiB)
> scsi 0:3:0:0: RAID              HP       P400             7.24 PQ: 0
> ANSI: 0
> 
> So where is the point of the first two messages?
> The enumeration is internal anyway, so it has a very quesionable
> value to the user. And the devices are listed afterwards anyway.
> 
> Hence it _might_ be an idea to remove some of those messages ...

FWIW, I'm usually the one in my group arguing for less messages rather
than more.  I don't always win.

-- steve

