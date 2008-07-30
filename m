From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] BUG: SCSI: usb storage SDHC card doesn't work in
 2.6.27-rc1
Date: Wed, 30 Jul 2008 17:28:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0807301720320.2322-100000@iolanthe.rowland.org>
References: <20080730150953.771b1345.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49425 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752832AbYG3V2u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jul 2008 17:28:50 -0400
In-Reply-To: <20080730150953.771b1345.zaitcev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Douglas Gilbert <dougg@torque.net>, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Matt Frost <artusemrys@sbcglobal.net>, linux-scsi <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Frost <artusemrys@yahoo.com>

On Wed, 30 Jul 2008, Pete Zaitcev wrote:

> On Wed, 30 Jul 2008 17:00:10 -0400 (EDT), Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > +++ 2.6.26/drivers/usb/storage/transport.c
> > @@ -1034,8 +1034,21 @@ int usb_stor_Bulk_transport(struct scsi_
> > +		/* Heuristically detect devices that generate bogus residues
> > +		 * by seeing what happens with INQUIRY and READ CAPACITY
> > +		 * commands.
> > +		 */
> > +		if (bcs->Status == US_BULK_STAT_OK &&
> > +				scsi_get_resid(srb) == 0 &&
> > +					((srb->cmnd[0] == INQUIRY &&
> > +						transfer_length == 36) ||
> > +					(srb->cmnd[0] == READ_CAPACITY &&
> > +						transfer_length == 8))) {
> > +			us->flags |= US_FL_IGNORE_RESIDUE;
> 
> Why do you do this for INQUIRY and READ_CAPACITY only?
> Why not do it for any command?

Because those are the only two commands for which I'm reasonably
certain the device should never return a nonzero residue with Okay
status.  For other commands there might be a valid positive residue --
although if there is then the device should also return Check Condition
status (the spec is unclear on this point).

Actually I'm a little concerned about the READ CAPACITY command; it's
conceivable that a removable-media device with no media present might
return a valid positive residue.  However the chance of something like
that happening and causing a problem is probably sufficiently small
that we can ignore it.

Alan Stern

