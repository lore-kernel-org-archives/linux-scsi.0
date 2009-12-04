From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] mac_esp: fix PIO mode
Date: Fri, 04 Dec 2009 09:31:24 -0600
Message-ID: <1259940684.2701.8.camel@mulgrave.site>
References: <alpine.OSX.2.00.0911231452300.468@localhost>
	 <20091202.154045.142858043.davem@davemloft.net>
	 <alpine.OSX.2.00.0912042321220.596@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.0912042321220.596@localhost>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2009-12-04 at 23:58 +1100, Finn Thain wrote:
> On Wed, 2 Dec 2009, David Miller wrote:
> 
> ...
> > 
> > Can you explain why the esp_slave_configure() part of your patch is 
> > necessary?
> > 
> > > Index: linux-2.6.31/drivers/scsi/esp_scsi.c
> > > ===================================================================
> > > --- linux-2.6.31.orig/drivers/scsi/esp_scsi.c	2009-11-23 12:52:45.000000000 +1100
> > > +++ linux-2.6.31/drivers/scsi/esp_scsi.c	2009-11-23 12:53:30.000000000 +1100
> > > @@ -2405,12 +2405,6 @@ static int esp_slave_configure(struct sc
> > >  	struct esp_target_data *tp = &esp->target[dev->id];
> > >  	int goal_tags, queue_depth;
> > >  
> > > -	if (esp->flags & ESP_FLAG_DISABLE_SYNC) {
> > > -		/* Bypass async domain validation */
> > > -		dev->ppr  = 0;
> > > -		dev->sdtr = 0;
> > > -	}
> > > -
> > >  	goal_tags = 0;
> > >  
> > >  	if (dev->tagged_supported) {
> > > @@ -2433,6 +2427,11 @@ static int esp_slave_configure(struct sc
> > >  	}
> > >  	tp->flags |= ESP_TGT_DISCONNECT;
> > >  
> > > +	if (esp->flags & ESP_FLAG_DISABLE_SYNC) {
> > > +		dev->wdtr = spi_support_wide(dev->sdev_target) = 0;
> > > +		dev->sdtr = spi_support_sync(dev->sdev_target) = 0;
> > > +	}
> > > +
> > >  	if (!spi_initial_dv(dev->sdev_target))
> > >  		spi_dv_device(dev);
> > >  
> 
> The aim is that domain validation will not test for sync when we know it 
> can't work (in PIO mode). This is the result:

So this isn't the correct way to handle the problem.  You're altering
the disk capability flags to trick the transport class.  What you want
to be doing is updating esp_set_period so it won't go under whatever you
deem to be a correct period setting (or if it's really async then it
won't set the period at all).

James
