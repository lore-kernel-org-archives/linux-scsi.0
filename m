From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sym53_8xx_2: fixes two bugs related to chip reset
Date: Thu, 10 Jan 2008 16:47:01 -0600
Message-ID: <1200005221.3141.118.camel@localhost.localdomain>
References: <20080109235944.34333eb6.krzysztof.h1@poczta.fm>
	 <1199922703.3493.76.camel@localhost.localdomain>
	 <20080110233118.d2b137ba.krzysztof.h1@poczta.fm>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59984 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587AbYAJWrH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2008 17:47:07 -0500
In-Reply-To: <20080110233118.d2b137ba.krzysztof.h1@poczta.fm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx


On Thu, 2008-01-10 at 23:31 +0100, Krzysztof Helt wrote:
> On Wed, 09 Jan 2008 17:51:43 -0600
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > > diff -urp linux-ref/drivers/scsi/sym53c8xx_2/sym_glue.c linux-new/drivers/scsi/sym53c8xx_2/sym_glue.c
> > > --- linux-ref/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-12-23 20:39:44.000000000 +0100
> > > +++ linux-new/drivers/scsi/sym53c8xx_2/sym_glue.c	2008-01-09 22:22:30.000000000 +0100
> > > @@ -609,22 +609,22 @@ static int sym_eh_handler(int op, char *
> > >  	 */
> > >  #define WAIT_FOR_PCI_RECOVERY	35
> > >  	if (pci_channel_offline(pdev)) {
> > > -		struct completion *io_reset;
> > >  		int finished_reset = 0;
> > >  		init_completion(&eh_done);
> > >  		spin_lock_irq(shost->host_lock);
> > >  		/* Make sure we didn't race */
> > >  		if (pci_channel_offline(pdev)) {
> > > -			if (!sym_data->io_reset)
> > > -				sym_data->io_reset = &eh_done;
> > > -			io_reset = sym_data->io_reset;
> > > +			BUG_ON(!sym_data->io_reset);
> > > +			sym_data->io_reset = &eh_done;
> > >  		} else {
> > >  			finished_reset = 1;
> > >  		}
> > >  		spin_unlock_irq(shost->host_lock);
> > >  		if (!finished_reset)
> > > -			finished_reset = wait_for_completion_timeout(io_reset,
> > > +			finished_reset = wait_for_completion_timeout
> > > +						(sym_data->io_reset,
> > >  						WAIT_FOR_PCI_RECOVERY*HZ);
> > > +		sym_data->io_reset = NULL;
> > 
> > This has to be cleared under the host_lock to forestall the (tiny) race
> > where the pci recovery code checks the value of sym_data->io_reset, we
> > change it to null and then the pci recovery code completes a NULL
> > pointer.
> > 
> 
> It is impossible as the io_reset value is not NULL before and during wait
> completion. The case above would happen only if one thread checked the
> io_reset value (under lock) and it was NULL and before setting it (inside
> locked section) another thread checked the io_reset value (still NULL 
> and also inside locked section = impossible). Otherwise, the BUG_ON() 
> kicked in (the value is already not NULL).

Er, no.  Let me be clearer about the sequence

sym2_io_resume() is racing to complete sym_data->io_reset with
sym_eh_handler()s timeout.  Because you don't set it to NULL under the
host_lock, you can get the sequence

sym2_io_resume() acquires the host lock and checks the value of
sym_data->io_reset and finds it to be not NULL.

sym_eh_handler() NULLs sym_data->io_resume *without* acquiring the host
lock. probably because the wait__for_completion_timeout() times out.

sym2_io_resume() calls complete() on sym_data->io_resume which is now a
NULL pointer and boom.

We never get multiple threads into sym_eh_handler() because it's single
threaded from the error handler thread.

James


