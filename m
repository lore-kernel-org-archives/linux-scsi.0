From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH 08/17][trivial] scsi: Remove unnecessary casts of void
 ptr returning alloc function return values
Date: Tue, 9 Nov 2010 00:30:21 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1011090027150.4512@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011082334400.23697@swampdragon.chaosbits.net> <1289259266.29216.486.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19803 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab0KHXls (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 18:41:48 -0500
In-Reply-To: <1289259266.29216.486.camel@Joe-Laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, linux-scsi@vger.kernel.org, osst-users@lists.sourceforge.net, "James E.J. Bottomley" <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>

On Mon, 8 Nov 2010, Joe Perches wrote:

> On Tue, 2010-11-09 at 00:09 +0100, Jesper Juhl wrote:
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
> []
> > @@ -4780,7 +4780,7 @@ ahc_init_scbdata(struct ahc_softc *ahc)
> >  	SLIST_INIT(&scb_data->sg_maps);
> >  
> >  	/* Allocate SCB resources */
> > -	scb_data->scbarray = (struct scb *)kmalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC, GFP_ATOMIC);
> > +	scb_data->scbarray = kmalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC, GFP_ATOMIC);
> >  	if (scb_data->scbarray == NULL)
> >  		return (ENOMEM);
> >  	memset(scb_data->scbarray, 0, sizeof(struct scb) * AHC_SCB_MAX_ALLOC);
> 
> This would be better as:
> 
> 	scb_data->scbarray = kcalloc(AHC_SCB_MAX_ALLOC, sizeof(struct scb), GFP_ATOMIC)
> 
> without the memset.
> 

True, I did notice that, and I guess I could have done that as part of 
this patch series, just as there are lots of other minor improvements I 
was tempted to do. But, I wanted to keep the entire patch series to a 
single specific topic, then once they are merged (hopefully) I can follow 
up with other cleanups.

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

