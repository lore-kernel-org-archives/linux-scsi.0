From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: advansys needs ISA dma api for ISA support
Date: Tue, 13 Oct 2015 12:59:04 -0700
Message-ID: <1444766344.2208.41.camel@HansenPartnership.com>
References: <5081546.QjQ32dGX2L@wuerfel>
	 <1444663681.2205.14.camel@HansenPartnership.com>
	 <15165188.ED2FR4b9SA@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43198 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbbJMT7H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Oct 2015 15:59:07 -0400
In-Reply-To: <15165188.ED2FR4b9SA@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org

On Mon, 2015-10-12 at 17:44 +0200, Arnd Bergmann wrote:
> On Monday 12 October 2015 08:28:01 James Bottomley wrote:
> > > 
> > > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> > > index d2f480b04a52..d4aa6a1a806c 100644
> > > --- a/drivers/scsi/Kconfig
> > > +++ b/drivers/scsi/Kconfig
> > > @@ -499,6 +499,7 @@ config SCSI_ADVANSYS
> > >       tristate "AdvanSys SCSI support"
> > >       depends on SCSI
> > >       depends on ISA || EISA || PCI
> > > +     depends on ISA_DMA_API || !ISA
> > >       help
> > >         This is a driver for all SCSI host adapters manufactured by
> > >         AdvanSys. It is documented in the kernel source in
> > 
> > This fix looks wrong.  the request_dma code is confined within an #ifdef
> > CONFIG_ISA section but the advansys doesn't actually require an ISA DMA
> > channel to function, so you're saying there are systems with ISA but
> > without request_dma()?
> 
> Yes. Specifically, the ARM EBSA110 and SA1100 platforms can have some
> PIO based ISA devices, but they have nothing close enough to an i8237
> to support the request_dma interface.
> 
> > If so I think we leave the depends alone and try to bring the board up
> > in NO_ISA_DMA mode.
> 
> Ok
> 
> >  That means the narrowboard check should be gated by
> > CONFIG_ISA_DMA_API ... do we also have to gate free_dma as well?
> 
> Yes. A few more as well, as we also don't want to do inb/outb
> instructions to a DMA controller that is not there.
> 
> I've compile-tested the patch below.
> 
> 	Arnd
> 
> 8<-------
> From 67fed3da5dd65abf5e4d01d8731c5217eb823fdb Mon Sep 17 00:00:00 2001
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Sat, 10 Oct 2015 21:13:29 +0200
> Subject: [PATCH] scsi: advansys: fix build without ISA DMA API
> 
> The advansys drvier uses the request_dma function that is used on ISA
> machines for the internal DMA controller, which causes build errors
> on platforms that have ISA slots but do not provide the ISA DMA API:
> 
> drivers/scsi/advansys.c: In function 'advansys_board_found':
> drivers/scsi/advansys.c:11300:10: error: implicit declaration of function 'request_dma' [-Werror=implicit-function-declaration]
> 
> The problem now showed up in ARM randconfig builds after commit
> 6571fb3f8b7f ("advansys: Update to version 3.5 and remove compilation
> warning") made it possible to build on platforms that have neither
> VIRT_TO_BUS nor ISA_DMA_API but that do have ISA.
> 
> This changes the existing #ifdefs in the driver to check for both
> CONFIG_ISA and CONFIG_ISA_DMA_API where appropriate. It should
> still be possible to use the driver in PIO mode with ISA when
> DMA is not available.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 1c1cd657c380..9f8aae40dcc8 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -2883,9 +2883,9 @@ static void asc_prt_asc_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
>  	ASC_DVC_VAR *asc_dvc_varp;
>  	ASCEEP_CONFIG *ep;
>  	int i;
> -#ifdef CONFIG_ISA
> +#if defined(CONFIG_ISA) && defined(CONFIG_ISA_DMA_API)
>  	int isa_dma_speed[] = { 10, 8, 7, 6, 5, 4, 3, 2 };
> -#endif /* CONFIG_ISA */
> +#endif /* ISA */
>  	uchar serialstr[13];
>  
>  	asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
> @@ -2937,13 +2937,13 @@ static void asc_prt_asc_board_eeprom(struct seq_file *m, struct Scsi_Host *shost
>  			   (ep->init_sdtr & ADV_TID_TO_TIDMASK(i)) ? 'Y' : 'N');
>  	seq_putc(m, '\n');
>  
> -#ifdef CONFIG_ISA
> +#if defined(CONFIG_ISA) && defined(CONFIG_ISA_DMA_API)
>  	if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
>  		seq_printf(m,
>  			   " Host ISA DMA speed:   %d MB/S\n",
>  			   isa_dma_speed[ASC_EEP_GET_DMA_SPD(ep)]);
>  	}
> -#endif /* CONFIG_ISA */
> +#endif /* ISA */
>  }
>  
>  /*
> @@ -8664,7 +8664,7 @@ static unsigned char AscGetChipVersion(PortAddr iop_base,
>  	return AscGetChipVerNo(iop_base);
>  }
>  
> -#ifdef CONFIG_ISA
> +#if defined(CONFIG_ISA) && defined(CONFIG_ISA_DMA_API)
>  static void AscEnableIsaDma(uchar dma_channel)
>  {
>  	if (dma_channel < 4) {
> @@ -8675,7 +8675,7 @@ static void AscEnableIsaDma(uchar dma_channel)
>  		outp(0x00D4, (ushort)(dma_channel - 4));
>  	}
>  }
> -#endif /* CONFIG_ISA */
> +#endif /* ISA */
>  
>  static int AscStopQueueExe(PortAddr iop_base)
>  {
> @@ -8704,7 +8704,7 @@ static unsigned int AscGetMaxDmaCount(ushort bus_type)
>  	return ASC_MAX_PCI_DMA_COUNT;
>  }
>  
> -#ifdef CONFIG_ISA
> +#if defined(CONFIG_ISA) && defined(CONFIG_ISA_DMA_API)
>  static ushort AscGetIsaDmaChannel(PortAddr iop_base)
>  {
>  	ushort channel;
> @@ -8754,7 +8754,7 @@ static uchar AscSetIsaDmaSpeed(PortAddr iop_base, uchar speed_value)
>  	AscSetBank(iop_base, 0);
>  	return AscGetIsaDmaSpeed(iop_base);
>  }
> -#endif /* CONFIG_ISA */
> +#endif /* ISA */
>  
>  static void AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
>  {
> @@ -8821,16 +8821,18 @@ static void AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
>  	}
>  
>  	asc_dvc->cfg->isa_dma_speed = ASC_DEF_ISA_DMA_SPEED;
> -#ifdef CONFIG_ISA
> +#if defined(CONFIG_ISA)
>  	if ((asc_dvc->bus_type & ASC_IS_ISA) != 0) {
>  		if (chip_version >= ASC_CHIP_MIN_VER_ISA_PNP) {
>  			AscSetChipIFC(iop_base, IFC_INIT_DEFAULT);
>  			asc_dvc->bus_type = ASC_IS_ISAPNP;
>  		}
> +#if defined(CONFIG_ISA_DMA_API)
>  		asc_dvc->cfg->isa_dma_channel =
>  		    (uchar)AscGetIsaDmaChannel(iop_base);
> +#endif /* ISA DMA */
>  	}
> -#endif /* CONFIG_ISA */
> +#endif /* ISA */
>  	for (i = 0; i <= ASC_MAX_TID; i++) {
>  		asc_dvc->cur_dvc_qng[i] = 0;
>  		asc_dvc->max_dvc_qng[i] = ASC_MAX_SCSI1_QNG;
> @@ -9377,7 +9379,7 @@ static int AscInitSetConfig(struct pci_dev *pdev, struct Scsi_Host *shost)
>  	    asc_dvc->cfg->chip_scsi_id) {
>  		asc_dvc->err_code |= ASC_IERR_SET_SCSI_ID;
>  	}
> -#ifdef CONFIG_ISA
> +#if defined(CONFIG_ISA) && defined(CONFIG_ISA_DMA_API)
>  	if (asc_dvc->bus_type & ASC_IS_ISA) {
>  		AscSetIsaDmaChannel(iop_base, asc_dvc->cfg->isa_dma_channel);
>  		AscSetIsaDmaSpeed(iop_base, asc_dvc->cfg->isa_dma_speed);
> @@ -10986,7 +10988,11 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
>  		switch (asc_dvc_varp->bus_type) {
>  #ifdef CONFIG_ISA
>  		case ASC_IS_ISA:
> +#if defined(CONFIG_ISA_DMA_API)
>  			shost->unchecked_isa_dma = true;
> +#else
> +			shost->unchecked_isa_dma = false;
> +#endif
>  			share_irq = 0;
>  			break;
>  		case ASC_IS_VL:
> @@ -11292,7 +11298,7 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
>  
>  	/* Register DMA Channel for Narrow boards. */
>  	shost->dma_channel = NO_ISA_DMA;	/* Default to no ISA DMA. */
> -#ifdef CONFIG_ISA
> +#if defined(CONFIG_ISA) && defined(CONFIG_ISA_DMA_API)
>  	if (ASC_NARROW_BOARD(boardp)) {
>  		/* Register DMA channel for ISA bus. */
>  		if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
> @@ -11379,7 +11385,7 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
>   err_free_irq:
>  	free_irq(boardp->irq, shost);
>   err_free_dma:
> -#ifdef CONFIG_ISA
> +#if defined(CONFIG_ISA) && defined(CONFIG_ISA_DMA_API)
>  	if (shost->dma_channel != NO_ISA_DMA)
>  		free_dma(shost->dma_channel);
>  #endif
> @@ -11403,7 +11409,7 @@ static int advansys_release(struct Scsi_Host *shost)
>  	ASC_DBG(1, "begin\n");
>  	scsi_remove_host(shost);
>  	free_irq(board->irq, shost);
> -#ifdef CONFIG_ISA
> +#if defined(CONFIG_ISA) && defined(CONFIG_ISA_DMA_API)
>  	if (shost->dma_channel != NO_ISA_DMA) {
>  		ASC_DBG(1, "free_dma()\n");
>  		free_dma(shost->dma_channel);

OK, that makes much more of a mess of the driver than I'd anticipated.
Unless there's an actual use case for forcing the non-DMA channel on the
relevant hardware, let's just go with the dependency based fix.

James


