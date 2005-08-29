From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 3/16]  qla2xxx: Correct ISP24xx soft-reset handling.
Date: Mon, 29 Aug 2005 09:04:42 -0700
Message-ID: <20050829160442.GC11393@plap.qlogic.org>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com> <20050827020820.27275.23899.sendpatchset@plap.qlogic.com> <1125109581.5079.160.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:36238 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751080AbVH2QEv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 12:04:51 -0400
Content-Disposition: inline
In-Reply-To: <1125109581.5079.160.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 26 Aug 2005, James Bottomley wrote:

> On Fri, 2005-08-26 at 19:08 -0700, Andrew Vasquez wrote:
> >  		WRT_REG_DWORD(&reg->ctrl_status,
> >  		    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
> > -		RD_REG_DWORD(&reg->ctrl_status);
> > +		/*
> > +		 * It is necessary to delay here since the card doesn't respond
> > +		 * to PCI reads during a reset. On some architectures this will
> > +		 * result in an MCA.
> > +		*/
> > +		udelay(100);
> 
> Removing the read introduces a potential write posting bug, doesn't?

Possibly, but that has been the case all software drivers have had to
contend with after an ISP soft-reset:

	...
	/* Reset ISP chip. */
	WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);

	/* Wait for RISC to recover from reset. */
	if (IS_QLA2100(ha) || IS_QLA2200(ha) || IS_QLA2300(ha)) {
		/*
		 * It is necessary to for a delay here since the
		 * card doesn't respond to PCI reads during a
		 * reset. On some architectures this will
		 * result in an MCA.
		 */
		udelay(20);
		...

During the soft-reset, the ISP cannot respond to the MMIO read until
completion.  On several platforms, the subsequent readl() without the
delay would cause machine checks.

Unfortunately, this has been a risk we've come to accept. We're still
evaluating the possibility of using a config-space read as a means of
flushing any posted writes -- since the RISC state-machines can handle
the request while resetting.  I'll ping the hardware folks again, but
in the interim, the udelay() will need to be present.

--
Andrew Vasquez
