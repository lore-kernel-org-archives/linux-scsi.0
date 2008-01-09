From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sym53_8xx_2: fixes two bugs related to chip reset
Date: Wed, 09 Jan 2008 17:51:43 -0600
Message-ID: <1199922703.3493.76.camel@localhost.localdomain>
References: <20080109235944.34333eb6.krzysztof.h1@poczta.fm>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35081 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754296AbYAIXvw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 18:51:52 -0500
In-Reply-To: <20080109235944.34333eb6.krzysztof.h1@poczta.fm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx


On Wed, 2008-01-09 at 23:59 +0100, Krzysztof Helt wrote:
> From: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> This patch fixes two bugs pointed by James Bottomley:
> 
>  1. the if (!sym_data->io_reset).  That variable is only ever filled
>     by a stack based completion.  If we find it non empty it means
>     this code has been entered twice and we have a severe problem,
>     so that should just become a BUG_ON(!sym_data->io_reset).
>  2. sym_data->io_reset should be set to NULL before the routine is
>     exited otherwise the PCI recovery code could end up completing
>     what will be a bogus pointer into the stack.
> 
> Big thanks to James Bottomley for help with the patch.
> 
> Signed-off-by: Krzysztof Helt <krzysztof.h1@w.pl>

Well done .. there's actually just one problem remaining:

> ---
> I do not know if I understood correctly all James' tips.
> 
> diff -urp linux-ref/drivers/scsi/sym53c8xx_2/sym_glue.c linux-new/drivers/scsi/sym53c8xx_2/sym_glue.c
> --- linux-ref/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-12-23 20:39:44.000000000 +0100
> +++ linux-new/drivers/scsi/sym53c8xx_2/sym_glue.c	2008-01-09 22:22:30.000000000 +0100
> @@ -609,22 +609,22 @@ static int sym_eh_handler(int op, char *
>  	 */
>  #define WAIT_FOR_PCI_RECOVERY	35
>  	if (pci_channel_offline(pdev)) {
> -		struct completion *io_reset;
>  		int finished_reset = 0;
>  		init_completion(&eh_done);
>  		spin_lock_irq(shost->host_lock);
>  		/* Make sure we didn't race */
>  		if (pci_channel_offline(pdev)) {
> -			if (!sym_data->io_reset)
> -				sym_data->io_reset = &eh_done;
> -			io_reset = sym_data->io_reset;
> +			BUG_ON(!sym_data->io_reset);
> +			sym_data->io_reset = &eh_done;
>  		} else {
>  			finished_reset = 1;
>  		}
>  		spin_unlock_irq(shost->host_lock);
>  		if (!finished_reset)
> -			finished_reset = wait_for_completion_timeout(io_reset,
> +			finished_reset = wait_for_completion_timeout
> +						(sym_data->io_reset,
>  						WAIT_FOR_PCI_RECOVERY*HZ);
> +		sym_data->io_reset = NULL;

This has to be cleared under the host_lock to forestall the (tiny) race
where the pci recovery code checks the value of sym_data->io_reset, we
change it to null and then the pci recovery code completes a NULL
pointer.

Other than this one problem, the code looks fine.

James


