From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: qla1280 endiannes and 64/32bit fixes
Date: 17 Jan 2004 22:16:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074395819.1756.31.camel@mulgrave>
References: <1074382860.1756.20.camel@mulgrave>
	<20040118024326.GA381527@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:26504 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266206AbUARDR4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Jan 2004 22:17:56 -0500
In-Reply-To: <20040118024326.GA381527@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Jes Sorensen <jes@wildopensource.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-01-17 at 21:43, Jeremy Higdon wrote:
> > @@ -2393,16 +2420,6 @@
> >  	/* Disable RISC load of firmware. */
> >  	ha->flags.disable_risc_code_load =
> >  		nv->cntr_flags_1.disable_loading_risc_code;
> > -
> > -#ifdef QLA_64BIT_PTR
> > -	/* Enable 64bit addressing for OS/System combination supporting it   */
> > -	/* actual NVRAM bit is: nv->cntr_flags_1.enable_64bit_addressing     */
> > -	/* but we will ignore it and use BITS_PER_LONG macro to setup for    */
> > -	/* 64 or 32 bit access of host memory in all x86/ia-64/Alpha systems */
> > -	ha->flags.enable_64bit_addressing = 1;
> > -#else
> > -	ha->flags.enable_64bit_addressing = 0;
> > -#endif
> >  
> >  	if (ha->flags.enable_64bit_addressing) {
> >  		dprintk(2, "scsi(%li): 64 Bit PCI Addressing Enabled\n",
> 
> 
> What is the reason for this change?  Is there an alternate way that this
> gets set?

That's reason number three in the previous email: apparently you can't
simply address the card in 64 bit mode if the nvram is set up for 32 bit
mode.  We either have to take the nvram value or find a way to switch
the card into 64 bit mode.

This was causing transfer failures on a 64 bit parisc box.  The nvram
returns 32 bit, and no transfers were occurring when it was addressed in
64 bit mode.  It may be because there's an endianness failure somewhere
in the 64bit_start_scsi routine, but if there is I couldn't find it. 
The address can't be wrong, because the PA has a pretty fierce IOMMU
that detects DMA to wrong memory.

James





James


