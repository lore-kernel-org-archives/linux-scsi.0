From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] libsas: fix lockdep issue with ATA
Date: Tue, 17 Jul 2007 09:12:50 -0500
Message-ID: <1184681570.3378.5.camel@localhost.localdomain>
References: <1184609751.3447.22.camel@localhost.localdomain>
	 <20070717112955.GR5195@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52155 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933552AbXGQOMw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 10:12:52 -0400
In-Reply-To: <20070717112955.GR5195@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2007-07-17 at 13:29 +0200, Jens Axboe wrote:
> On Mon, Jul 16 2007, James Bottomley wrote:
> > lockdep noticed that with ATA support the port->dev_list_lock was
> > entangled at irq context, so it now needs to become IRQ safe
> > 
> > ---
> > This applies against the aic94xx-sas-2.6 tree
> > 
> > James
> > 
> > diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> > index a18c0f6..ce3385c 100644
> > --- a/drivers/scsi/libsas/sas_discover.c
> > +++ b/drivers/scsi/libsas/sas_discover.c
> > @@ -292,9 +292,9 @@ static int sas_get_port_device(struct asd_sas_port *port)
> >  	port->disc.max_level = 0;
> >  
> >  	dev->rphy = rphy;
> > -	spin_lock(&port->dev_list_lock);
> > +	spin_lock_irqsave(&port->dev_list_lock, flags);
> >  	list_add_tail(&dev->dev_list_node, &port->dev_list);
> > -	spin_unlock(&port->dev_list_lock);
> > +	spin_unlock_irqrestore(&port->dev_list_lock, flags);
> >  
> >  	return 0;
> >  }
> 
> already uses GFP_KERNEL, so spin_lock_irq() suffices.
> 
> > @@ -688,12 +688,14 @@ static void sas_discover_domain(struct work_struct *work)
> >  	}
> >  
> >  	if (error) {
> > +		unsigned long flags;
> > +
> >  		sas_rphy_free(dev->rphy);
> >  		dev->rphy = NULL;
> >  
> > -		spin_lock(&port->dev_list_lock);
> > +		spin_lock_irqsave(&port->dev_list_lock, flags);
> >  		list_del_init(&dev->dev_list_node);
> > -		spin_unlock(&port->dev_list_lock);
> > +		spin_unlock_irqrestore(&port->dev_list_lock, flags);
> >  
> >  		kfree(dev); /* not kobject_register-ed yet */
> >  		port->port_dev = NULL;
> 
> process context, no need to save flags here either.

OK, you caught me ... I was just doing the fastest thing I could to get
lockdep to shut up.  By the way, it dumps about 120KB of logs so it's
fun to get an actual trace of this...

I'll make the fixes and resubmit

James


