From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] tmscsim: clean up endianness
Date: Sun, 08 Oct 2006 22:19:10 -0500
Message-ID: <1160363950.3528.23.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.60.0610082208090.20132@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:5249 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932211AbWJIDTN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 8 Oct 2006 23:19:13 -0400
In-Reply-To: <Pine.LNX.4.60.0610082208090.20132@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Sun, 2006-10-08 at 22:24 +0200, Guennadi Liakhovetski wrote:
> -               pSRB->SGBusAddr =
> cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
> -               pSRB->SGToBeXferLen = cpu_to_le32(sg_dma_len(psgl));
> +               pSRB->SGBusAddr = sg_dma_address(psgl);
> +               pSRB->SGToBeXferLen = sg_dma_len(psgl);

Are you sure that's what you want to do?  Your Scsi Request Block must
therefore be purely internal to the driver and not passed across to the
card in any way, is that correct?

James


