From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: detect missing data for INQUIRY
Date: Mon, 27 Oct 2008 13:00:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0810271258200.2296-100000@iolanthe.rowland.org>
References: <1225125475.5146.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52791 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751193AbYJ0RA2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2008 13:00:28 -0400
In-Reply-To: <1225125475.5146.24.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: =?ISO-8859-1?Q?=D6rjan?= Nordlund <orjan.nordlund@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 27 Oct 2008, James Bottomley wrote:

> > --- usb-2.6.orig/drivers/scsi/scsi_scan.c
> > +++ usb-2.6/drivers/scsi/scsi_scan.c
> > @@ -602,6 +602,13 @@ static int scsi_probe_lun(struct scsi_de
> >  				    (sshdr.ascq == 0))
> >  					continue;
> >  			}
> > +		} else {
> > +			/*
> > +			 * Additional Length and Vendor fields missing
> > +			 * probably means nothing was transferred.  Try again.
> > +			 */
> > +			if (inq_result[4] == 0 && inq_result[8] == 0)
> > +				continue;
> 
> Really, no.
> 
> A legitimate minimal response from a device is zero in the additional
> length field.  If it does that, then the vendor field is bound to be
> zero as well.
> 
> About the best we can do is check the first four fields.  For them to be
> all zero, it would have to be a minimal response SCSI-1 device (RDF of
> zero) ... hopefully they're all dead by now.

Then you're saying that the patch should everything up to
inq_result[8]?  Or maybe even beyond?  I can do that.  Would that be 
acceptable?

Alan Stern

