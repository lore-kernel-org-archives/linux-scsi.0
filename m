From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] QLogic qla2x00 driver fixes
Date: Fri, 25 Feb 2005 06:57:39 -0500
Message-ID: <1109332659.27139.224.camel@compaq-rhel4.xsintricity.com>
References: <1109305293.27139.216.camel@compaq-rhel4.xsintricity.com>
	 <1109318231.6290.27.camel@laptopd505.fenrus.org>
	 <421EE410.7020603@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from mx1.redhat.com ([66.187.233.31]:29638 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262681AbVBYL5z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 06:57:55 -0500
In-Reply-To: <421EE410.7020603@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

On Fri, 2005-02-25 at 03:38 -0500, Jeff Garzik wrote:
> Arjan van de Ven wrote:
> > On Thu, 2005-02-24 at 23:21 -0500, Doug Ledford wrote:
> > 
> >>Don't use cmd->request->nr_hw_segments as it may not be initialized
> >>(SG_IO in particular bypasses anything that initializes this and just
> >>uses scsi_do_req to insert a scsi_request directly on the head of the
> >>queue) 
> > 
> > 
> > should we fix that in the SG_IO layer ?
> 
> Possibly/probably.

I'm not concerned with it personally.  The only reason that the scsi
layer copies the block layer request struct into the scsi
command/request is so that upon completion it has enough information to
mark blocks as either up to date or not while at the same time allowing
the scsi layer to free the original block request at queue time, not at
completion time.  It was never intended to be used by low level drivers.
And since the scsi layer has several ways of bypassing the block layer
to inject commands directly to devices, trying to catch all those
injection points and make them emulate block layer activity when we
already provide everything a low level driver needs in the scsi command
struct is silly.  Just use what's available, reliable, always
initialized, and intended for you to use (cmd->use_sg) instead of trying
to use a roughly duplicate item from a different abstraction layer that
isn't always involved in commands sent to a low level driver (request-
>nr_hw_segments).

> For SCSI drivers specifically, using nr_hw_segments is pointless unless 
> cmd->use_sg goes away.  At which point tons of SCSI drivers want 
> changing anyway.
> 
> 	n_sg = dma_map_sg(..., cmd->use_sg, ...)
> 
> will always do the right thing, when the cmd contains a scatterlist.
> 
> Deviate from the norm and pay the price, really...

Aye, yup.

-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford


