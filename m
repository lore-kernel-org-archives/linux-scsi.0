From: malahal@us.ibm.com
Subject: Re: [PATCH] AIC94XX: call tasklet_kill while unloading the module
Date: Thu, 19 Oct 2006 15:02:28 -0700
Message-ID: <20061019220228.GA13039@us.ibm.com>
References: <20061019032551.GB19570@us.ibm.com> <1161284239.11219.19.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49286 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1946556AbWJSWCd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 18:02:33 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9JM2Wp6016144
	for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2006 18:02:32 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9JM2W0N252610
	for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2006 18:02:32 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9JM2Wau025809
	for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2006 18:02:32 -0400
Content-Disposition: inline
In-Reply-To: <1161284239.11219.19.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley [James.Bottomley@SteelEye.com] wrote:
> On Wed, 2006-10-18 at 20:25 -0700, malahal@us.ibm.com wrote:
> > Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
> > 
> > diff -r d134b26a8da8 drivers/scsi/aic94xx/aic94xx_init.c
> > --- a/drivers/scsi/aic94xx/aic94xx_init.c	Wed Oct 18 16:34:30 2006 -0700
> > +++ b/drivers/scsi/aic94xx/aic94xx_init.c	Wed Oct 18 18:21:40 2006 -0700
> > @@ -737,6 +737,11 @@ static void __devexit asd_pci_remove(str
> >  	/* XXX more here as needed */
> >  
> >  	free_irq(dev->irq, asd_ha);
> > +
> > +	/* We already disabled interrupts and freed the IRQ. Now, it is
> > +	 * safe to kill the tasklet that processes done list */
> > +	tasklet_kill(&asd_ha->seq.dl_tasklet);
> > +
> 
> Actually, this should be in asd_destroy_ha_caches() which is where the
> asd_init_hw() teardown path is ... not that I'm very happy with this;
> the teardown should be in aic94xx_hwi.c where the init path is ...
> 
> James

James, I think we should stop processing the done list before
we call asd_free_queues() which frees all pending SCB's. So
asd_destroy_ha_caches() is too late for it. I can put it in
asd_free_queues() if you agree.
