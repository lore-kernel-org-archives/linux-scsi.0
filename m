From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: clean up endianness
Date: Mon, 9 Oct 2006 08:07:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0610090747140.3756@poirot.grange>
References: <Pine.LNX.4.60.0610082208090.20132@poirot.grange>
 <1160363950.3528.23.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:13787 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932243AbWJIGHj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2006 02:07:39 -0400
In-Reply-To: <1160363950.3528.23.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Sun, 8 Oct 2006, James Bottomley wrote:

> On Sun, 2006-10-08 at 22:24 +0200, Guennadi Liakhovetski wrote:
> > -               pSRB->SGBusAddr =
> > cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
> > -               pSRB->SGToBeXferLen = cpu_to_le32(sg_dma_len(psgl));
> > +               pSRB->SGBusAddr = sg_dma_address(psgl);
> > +               pSRB->SGToBeXferLen = sg_dma_len(psgl);
> 
> Are you sure that's what you want to do?  Your Scsi Request Block must
> therefore be purely internal to the driver and not passed across to the
> card in any way, is that correct?

Well, not quite. The reason, why I decided the original code was wrong 
was, that the variables that were initialised with cpu_to_le32() were 
later throughout the driver used in arithmetics:

	pSRB->SGBusAddr += xferCnt;
	(3 times)
		pSRB->SGBusAddr++;
	pSRB->SGBusAddr += pSRB->Saved_Ptr - pSRB->TotalXferredLen;
	xferCnt = pSRB->SGToBeXferLen - residual;
	    pSRB->TotalXferredLen += pSRB->SGToBeXferLen;
	    xferCnt = pSRB->SGToBeXferLen - ResidCnt;
	    pSRB->TotalXferredLen += pSRB->SGToBeXferLen;
	    xferCnt = pSRB->SGToBeXferLen - ResidCnt;
		pSRB->SGToBeXferLen--;
	pSRB->SGToBeXferLen -= pSRB->Saved_Ptr - pSRB->TotalXferredLen;

byte-wise:

	lval = pSRB->SGToBeXferLen;
	DC390_write8 (CtcReg_Low, (u8) lval);
	lval >>= 8;
	DC390_write8 (CtcReg_Mid, (u8) lval);
	lval >>= 8;
	DC390_write8 (CtcReg_High, (u8) lval);

and mixed with "normal" local variables:

	pSRB->SGToBeXferLen = residual;
	    pSRB->SGToBeXferLen = ResidCnt;
	(2 times)

The only place where endianness-correction seems to be needed is this:

	DC390_write32 (DMA_XferAddr, pSRB->SGBusAddr);
	DC390_write32 (DMA_XferCnt, pSRB->SGToBeXferLen);

but don't 32-bit io[rw] routines on BE machines do the swapping internally 
on PCI? I seem to remember having read something about that, not sure 
any more, though. But, at least, it won't be more buggy than before:-) 
Should I swap here?

Thanks
Guennadi
---
Guennadi Liakhovetski
