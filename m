From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] make error handling robust in the face of reservations
Date: Fri, 06 Aug 2010 16:02:49 -0500
Message-ID: <1281128569.6245.163.camel@mulgrave.site>
References: <1281125844.6245.109.camel@mulgrave.site>
	 <20100806205655.GM27935@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935105Ab0HFVC5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Aug 2010 17:02:57 -0400
In-Reply-To: <20100806205655.GM27935@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2010-08-06 at 14:56 -0600, Matthew Wilcox wrote:
> On Fri, Aug 06, 2010 at 03:17:24PM -0500, James Bottomley wrote:
> > There's a curious case where devices in clusters are offlining if they
> > go into error handling.  The reason is that in this particular cluster,
> > Test Unit Ready gets a RESERVATION CONFLICT return when another node
> > owns the storage.  This means that all TURs that error handling use are
> > marked failed, so we always assume the device is unrecoverable and take
> > it offline.
> > 
> > Fix this by checking in the error handling code processing returns to
> > see if the command was a TUR and translate the EH return to SUCCESS
> > (after all, if the target managed to return RESERVATION CONFLICT, we've
> > successfully made contact with it).
> 
> Um, the patch doesn't match the description.  According to the code,
> we were unconditionally returning SUCCESS before.  Now we fail everythng
> except TUR.  Was there another part to this patch, or is the description
> bonkers?

The description is unclear 

commit 5f91bb050ecc4ff1d8d3d07edbe550c8f431c5e1
Author: Michael Reed <mdr@sgi.com>
Date:   Mon Aug 10 11:59:28 2009 -0500

    [SCSI] reservation conflict after timeout causes device to be taken
offline

Flipped us from always returning failed to always returning success in
the name of fixing the problem.  This patch should be the final fix.

> > ---
> > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > index 2bf9846..5e2d36f 100644
> > --- a/drivers/scsi/scsi_error.c
> > +++ b/drivers/scsi/scsi_error.c
> > @@ -473,10 +473,12 @@ static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
> >  		 */
> >  		return SUCCESS;
> >  	case RESERVATION_CONFLICT:
> > -		/*
> > -		 * let issuer deal with this, it could be just fine
> > -		 */
> > -		return SUCCESS;
> > +		if (scmd->cmnd[0] == TEST_UNIT_READY)
> > +			/* it is a success, we probed the device and
> > +			 * found it */
> > +			return SUCCESS;
> > +		/* otherwise, we failed to send the command */
> > +		return FAILED;
> >  	case QUEUE_FULL:
> >  		scsi_handle_queue_full(scmd->device);
> >  		/* fall through */
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


