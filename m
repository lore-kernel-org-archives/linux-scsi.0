From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: qla1280 endiannes and 64/32bit fixes
Date: Sat, 17 Jan 2004 23:08:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040118070807.GB383498@sgi.com>
References: <1074382860.1756.20.camel@mulgrave> <20040118024326.GA381527@sgi.com> <1074395819.1756.31.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:21410 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S266243AbUARHIM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Jan 2004 02:08:12 -0500
Content-Disposition: inline
In-Reply-To: <1074395819.1756.31.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jes Sorensen <jes@wildopensource.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, Jan 17, 2004 at 10:16:57PM -0500, James Bottomley wrote:
> On Sat, 2004-01-17 at 21:43, Jeremy Higdon wrote:
> > > @@ -2393,16 +2420,6 @@
> > >  	/* Disable RISC load of firmware. */
> > >  	ha->flags.disable_risc_code_load =
> > >  		nv->cntr_flags_1.disable_loading_risc_code;
> > > -
> > > -#ifdef QLA_64BIT_PTR
> > > -	/* Enable 64bit addressing for OS/System combination supporting it   */
> > > -	/* actual NVRAM bit is: nv->cntr_flags_1.enable_64bit_addressing     */
> > > -	/* but we will ignore it and use BITS_PER_LONG macro to setup for    */
> > > -	/* 64 or 32 bit access of host memory in all x86/ia-64/Alpha systems */
> > > -	ha->flags.enable_64bit_addressing = 1;
> > > -#else
> > > -	ha->flags.enable_64bit_addressing = 0;
> > > -#endif
> > >  
> > >  	if (ha->flags.enable_64bit_addressing) {
> > >  		dprintk(2, "scsi(%li): 64 Bit PCI Addressing Enabled\n",
> > 
> > 
> > What is the reason for this change?  Is there an alternate way that this
> > gets set?
> 
> That's reason number three in the previous email: apparently you can't
> simply address the card in 64 bit mode if the nvram is set up for 32 bit
> mode.  We either have to take the nvram value or find a way to switch
> the card into 64 bit mode.

I see.  Well, it causes this driver to stop working on our SN2
(Altix) systems.

> This was causing transfer failures on a 64 bit parisc box.  The nvram
> returns 32 bit, and no transfers were occurring when it was addressed in
> 64 bit mode.  It may be because there's an endianness failure somewhere
> in the 64bit_start_scsi routine, but if there is I couldn't find it. 
> The address can't be wrong, because the PA has a pretty fierce IOMMU
> that detects DMA to wrong memory.

It very well could be.  Our ql driver has lots of code to do endian
conversions on our big endian platforms.  That's all excised in our
XSCSI ql driver, since the Altix is little endian.

> James

I'm leaving shortly for a vacation, so hopefully Jes can pursue this
with you for the next few days.

jeremy
