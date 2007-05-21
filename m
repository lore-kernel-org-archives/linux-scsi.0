From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] jazz_esp converted to use esp_core
Date: Tue, 22 May 2007 00:00:41 +0100
Message-ID: <20070521230041.GA12090@infradead.org>
References: <20070521210224.GA24573@alpha.franken.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43616 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764495AbXEUXAn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2007 19:00:43 -0400
Content-Disposition: inline
In-Reply-To: <20070521210224.GA24573@alpha.franken.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, davem@davemloft.net

On Mon, May 21, 2007 at 11:02:24PM +0200, Thomas Bogendoerfer wrote:
> Hi,
> 
> after chasing and fixing two jazz platform bugs and one MIPS dma mapping
> bug, I finally succeeded in using the Dave's new esp_core (great work,
> thank you Dave). Below is the patch.

Very nice driver.  The only thing that confused me a little are
the various helper functions split out of esp_jazz_probe that
make the code a bit odd to read.  Are these intentional or a carry
over from the previous driver?

> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -121,7 +121,7 @@ obj-$(CONFIG_BLK_DEV_3W_XXXX_RAID) += 3w-xxxx.o
>  obj-$(CONFIG_SCSI_3W_9XXX)	+= 3w-9xxx.o
>  obj-$(CONFIG_SCSI_PPA)		+= ppa.o
>  obj-$(CONFIG_SCSI_IMM)		+= imm.o
> -obj-$(CONFIG_JAZZ_ESP)		+= NCR53C9x.o	jazz_esp.o
> +obj-$(CONFIG_JAZZ_ESP)		+= jazz_esp.o

Note to Dave:  it probably would be nice to just build esp_scsi.o
from the makefile like the old NCR53C9x drivers did instead of the
Kconfig hackery, what do you think?

