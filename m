From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Proposals to change the way all drivers work with SCSI commands
Date: Fri, 11 May 2007 14:49:35 -0500
Message-ID: <1178912975.3692.61.camel@mulgrave.il.steeleye.com>
References: <1178908422.3692.58.camel@mulgrave.il.steeleye.com>
	 <4644C0D9.70006@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:51812 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933960AbXEKTtj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 15:49:39 -0400
In-Reply-To: <4644C0D9.70006@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2007-05-11 at 15:15 -0400, Jeff Garzik wrote:
> James Bottomley wrote:
> > Right at the moment, we're planning to clean up the way SCSI drivers
> > process commands.  The proposals are essentially:
> > 
> >      1. Get rid of the now unnecessary map_single path (every command is
> >         either zero transfer or scatter/gather)
> >      2. use accessors to manipulate the SG lists (mainly so that we can
> >         alter the implementation without affecting the drivers)
> > 
> > It strikes me that in all of this, we could also consider doing the DMA
> > mapping inside the mid layer (instead of in every driver).  This is
> > essentially what libata is already doing ... leading to confusion in
> > SCSI drivers that use libata for SATA.
> 
> My eyes are crossed :)  How does doing DMA mapping in the mid layer lead 
> to confusion in SCSI drivers that use libata for SATA?  Are you talking 
> about aic94xx and ipr only, or other drivers?

Those are the only two that use libata for SATA, yes.

aic94xx is horrible in this regard ... it has to try to distinguish STP
commands that come from libsas (and thus aren't mapped) from ones that
come from libata which are ... and it still doesn't get it entirely
right.

James


