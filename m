From: Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] sym53_8xx_2: fixes two bugs related to chip reset
Date: Thu, 10 Jan 2008 23:31:18 +0100
Message-ID: <20080110233118.d2b137ba.krzysztof.h1@poczta.fm>
References: <20080109235944.34333eb6.krzysztof.h1@poczta.fm>
	<1199922703.3493.76.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:13541 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754544AbYAJW1u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 17:27:50 -0500
In-Reply-To: <1199922703.3493.76.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx

On Wed, 09 Jan 2008 17:51:43 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > diff -urp linux-ref/drivers/scsi/sym53c8xx_2/sym_glue.c linux-new/drivers/scsi/sym53c8xx_2/sym_glue.c
> > --- linux-ref/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-12-23 20:39:44.000000000 +0100
> > +++ linux-new/drivers/scsi/sym53c8xx_2/sym_glue.c	2008-01-09 22:22:30.000000000 +0100
> > @@ -609,22 +609,22 @@ static int sym_eh_handler(int op, char *
> >  	 */
> >  #define WAIT_FOR_PCI_RECOVERY	35
> >  	if (pci_channel_offline(pdev)) {
> > -		struct completion *io_reset;
> >  		int finished_reset = 0;
> >  		init_completion(&eh_done);
> >  		spin_lock_irq(shost->host_lock);
> >  		/* Make sure we didn't race */
> >  		if (pci_channel_offline(pdev)) {
> > -			if (!sym_data->io_reset)
> > -				sym_data->io_reset = &eh_done;
> > -			io_reset = sym_data->io_reset;
> > +			BUG_ON(!sym_data->io_reset);
> > +			sym_data->io_reset = &eh_done;
> >  		} else {
> >  			finished_reset = 1;
> >  		}
> >  		spin_unlock_irq(shost->host_lock);
> >  		if (!finished_reset)
> > -			finished_reset = wait_for_completion_timeout(io_reset,
> > +			finished_reset = wait_for_completion_timeout
> > +						(sym_data->io_reset,
> >  						WAIT_FOR_PCI_RECOVERY*HZ);
> > +		sym_data->io_reset = NULL;
> 
> This has to be cleared under the host_lock to forestall the (tiny) race
> where the pci recovery code checks the value of sym_data->io_reset, we
> change it to null and then the pci recovery code completes a NULL
> pointer.
> 

It is impossible as the io_reset value is not NULL before and during wait
completion. The case above would happen only if one thread checked the
io_reset value (under lock) and it was NULL and before setting it (inside
locked section) another thread checked the io_reset value (still NULL 
and also inside locked section = impossible). Otherwise, the BUG_ON() 
kicked in (the value is already not NULL).

Another case is if you consider changing the io_reset value after the
locked section but before wait_for_completion_timeout(). In this case,
putting spinlock around the io_reset clearing does not change anything.
There is still a chance of race if the io_reset is cleared after one thread
leaves the locked section then another one clearing the io_reset (under lock)
then completion by the first thread happens with NULL pointer.

Am I right? I understand that you asked for change like this:
+  		spin_lock_irq(shost->host_lock);
+		sym_data->io_reset = NULL;
+  		spin_unlock_irq(shost->host_lock);

Maybe, better solution is to clear the io_reset field inside the 
sym2_io_resume() (as it was done)? It would be cleared only
after the completion and before it is cleared the BUG_ON() guards
against race. The 2nd race case described above is impossible 
in such solution.

However, another version of the patch is needed as the BUG_ON condition
should be BUG_ON(sym_data->io_reset) and not 
BUG_ON(!sym_data->io_reset).

So, I wait for your opinion to the lock issue. If you still consider version with
the change presented above better, I'll add it.

Kind regards,
Krzysztof

----------------------------------------------------------------------
Rozdajemy nagrody! 

Sprawdz >> http://link.interia.pl/f1cbf


