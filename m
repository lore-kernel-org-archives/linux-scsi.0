From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] mvsas: always iounmap resources
Date: Mon, 22 Jun 2015 09:43:37 +0200
Message-ID: <20150622074337.GA2899@c203.arch.suse.de>
References: <1432286102-18184-1-git-send-email-jthumshirn@suse.de>
 <557A7CCA.3080406@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799AbbFVHnp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Jun 2015 03:43:45 -0400
Content-Disposition: inline
In-Reply-To: <557A7CCA.3080406@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bvanassche@acm.org>, Ben Hutchings <ben@decadent.org.uk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On Fri, Jun 12, 2015 at 08:31:38AM +0200, Hannes Reinecke wrote:
> On 05/22/2015 11:15 AM, Johannes Thumshirn wrote:
> > In case pci_resource_start() or pci_resource_len() reutrn 0, mvsas_ioremap
> > returns without doing an iounmap() of mvi->regs_ex.
> > 
> > Found by the cocinelle tool.
> > 
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > ---
> >  drivers/scsi/mvsas/mv_init.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> > index 53030b0..04a3205 100644
> > --- a/drivers/scsi/mvsas/mv_init.c
> > +++ b/drivers/scsi/mvsas/mv_init.c
> > @@ -339,8 +339,11 @@ int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex)
> >  
> >  	res_start = pci_resource_start(pdev, bar);
> >  	res_len = pci_resource_len(pdev, bar);
> > -	if (!res_start || !res_len)
> > +	if (!res_start || !res_len) {
> > +		iounmap(mvi->regs_ex);
> > +		mvi->regs_ex = NULL;
> >  		goto err_out;
> > +	}
> >  
> >  	res_flag = pci_resource_flags(pdev, bar);
> >  	if (res_flag & IORESOURCE_CACHEABLE)
> > 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> 

James, any update on this?
Do you intent to take it for 4.2?

Thank,
	Johannes
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
