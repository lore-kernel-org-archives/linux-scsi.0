From: Jens Axboe <axboe@suse.de>
Subject: Re: [RFC][PATCH] libata ATAPI alignment
Date: Tue, 2 Aug 2005 10:27:19 +0200
Message-ID: <20050802082719.GA22569@suse.de>
References: <20050729050654.GA10413@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050729050654.GA10413@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 29 2005, Jeff Garzik wrote:
> 
> So, one thing that's terribly ugly about SATA ATAPI is that we need to
> pad DMA transfers to the next 32-bit boundary, if the length is not
> evenly divisible by 4.
> 
> Messing with the scatterlist to accomplish this is terribly ugly
> no matter how you slice it.  One way would be to create my own
> scatterlist, via memcpy and then manual labor.  Another way would be
> to special case a pad buffer, appending it onto the end of various
> scatterlist code.

It's not pretty, but I think it's the only solution currently.

> Complicating matters, we currently must support two methods of data
> buffer submission:  a single kernel virtual address, or a struct
> scatterlist.

Fairly soon the !use_sg case will be gone, at least coming from SCSI. I
hope we can completely get away from the virtual address + length for
any remaining cases, just making it a single entry sg list.

> 
> Review is requested by any and all parties, as well as suggestions for
> a prettier approach.
> 
> This is one of the last steps needed to get ATAPI going.
> 
> 
> 
> diff --git a/drivers/scsi/ahci.c b/drivers/scsi/ahci.c
> --- a/drivers/scsi/ahci.c
> +++ b/drivers/scsi/ahci.c
> @@ -44,7 +44,7 @@
>  
>  enum {
>  	AHCI_PCI_BAR		= 5,
> -	AHCI_MAX_SG		= 168, /* hardware max is 64K */
> +	AHCI_MAX_SG		= 300, /* hardware max is 64K */
>  	AHCI_DMA_BOUNDARY	= 0xffffffff,
>  	AHCI_USE_CLUSTERING	= 0,
>  	AHCI_CMD_SLOT_SZ	= 32 * 32,

Reasoning? I agree, just wondering... How big is the allocated area now?

-- 
Jens Axboe

