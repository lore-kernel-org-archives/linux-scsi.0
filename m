From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 5/6] aha152x.c - Fix check_condition code-path
Date: Thu, 2 Aug 2007 15:47:11 -0700
Message-ID: <20070802154711.7eb5e876.rdunlap@xenotime.net>
References: <46ACE62F.4070108@panasas.com>
	<46ACEA0A.5040101@panasas.com>
	<20070730171331.5237bb94.rdunlap@xenotime.net>
	<46AEEBF7.3060808@panasas.com>
	<20070731114021.488735ec.rdunlap@xenotime.net>
	<1185976274.3468.70.camel@localhost.localdomain>
	<20070801093422.f986597d.rdunlap@xenotime.net>
	<46B1BF77.6060804@panasas.com>
	<20070802120926.63a76fce.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:58735 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755559AbXHBWl1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Aug 2007 18:41:27 -0400
Received: from midway.site ([71.245.96.223]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 2 Aug 2007 15:41:24 -0700
In-Reply-To: <20070802120926.63a76fce.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, "=?ISO-8859-1?Q? J=FCrgen_E._Fischer ?=" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "David A. Hinds" <dahinds@users.sourceforge.net>

On Thu, 2 Aug 2007 12:09:26 -0700 Randy Dunlap wrote:

 -------------------------------------------------------------------------------------------------------------
> > diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> > index d30a307..5fe55d0 100644
> > --- a/drivers/scsi/aha152x.c
> > +++ b/drivers/scsi/aha152x.c
> > @@ -1062,7 +1063,7 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
> >   *  queue a command
> >   *
> >   */
> > -static int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
> > +int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
> >  {
> >  #if 0
> >  	if(*SCpnt->cmnd == REQUEST_SENSE) {
> > diff --git a/drivers/scsi/aha152x.h b/drivers/scsi/aha152x.h
> > index ac4bfa4..065612f 100644
> > --- a/drivers/scsi/aha152x.h
> > +++ b/drivers/scsi/aha152x.h
> > @@ -333,5 +333,6 @@ struct aha152x_setup {
> >  struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *);
> >  void aha152x_release(struct Scsi_Host *);
> >  int aha152x_host_reset_host(struct Scsi_Host *);
> > +int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *));
> >  
> >  #endif /* _AHA152X_H */
> > diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
> > index 370802d..e2f5ea5 100644
> > --- a/drivers/scsi/pcmcia/aha152x_stub.c
> > +++ b/drivers/scsi/pcmcia/aha152x_stub.c
> > @@ -137,6 +137,19 @@ static void aha152x_detach(struct pcmcia_device *link)
> >  } /* aha152x_detach */
> >  
> >  /*====================================================================*/
> > +static int aha152x_queue_cs(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
> > +{
> > +struct pcmcia_device *p_dev;
> > +struct device *dev = &SCpnt->device->sdev_gendev;
> > +
> > +	p_dev = to_pcmcia_dev(dev);
> > +	if (p_dev->_removed==1)
> > +		return ENODEV;
> > +	
> > +	return aha152x_queue(SCpnt, done);
> > +}
> > +
> > +/*====================================================================*/
> >  
> >  #define CS_CHECK(fn, ret) \
> >  do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
> > @@ -201,6 +214,7 @@ static int aha152x_config_cs(struct pcmcia_device *link)
> >  	goto cs_failed;
> >      }
> >  
> > +    host->hostt->queuecommand = aha152x_queue_cs;
> >      sprintf(info->node.dev_name, "scsi%d", host->host_no);
> >      link->dev_node = &info->node;
> >      info->host = host;
> > -------------------------------------------------------------------------------------------------------------
> 
> 
> > But you will have to totally check me out on that: to_pcmcia_dev() 
> > thing above.
> 
> Looks OK to me.

but it must not be.  p_dev->_removed is never seen ==1,
so I printk() p_dev above and in drivers/pcmcia/ds.c when
_removed = 1; // is being set.
and they are not the same struct pcmcia_device.

If we can get this working....

> > And maybe it is plain lobotomy. I wish sd.c could Just signal the
> > SCSI device that it is on the shutdown path.
> > 
> > Or maybe my original Question. How can a card identify it's un-presence?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
