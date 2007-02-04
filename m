From: David Moore <dcm@MIT.EDU>
Subject: Re: [PATCH] ieee1394: sbp2: enforce 32bit DMA mapping
Date: Sun, 04 Feb 2007 11:06:37 -0500
Message-ID: <1170605197.26464.16.camel@PISCES.MIT.EDU>
References: <tkrat.37326df2d568d12d@s5r6.in-berlin.de>
	<1168802387.2780.1.camel@mulgrave.il.steeleye.com>
	<tkrat.581ea0f6f3fe6292@s5r6.in-berlin.de>
	<tkrat.e82713a8340840b3@s5r6.in-berlin.de>
	<tkrat.61995f33104845d9@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.61995f33104845d9@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Yes, I think you should use GFP_DMA32 instead of GFP_DMA.  GFP_DMA
refers to just the first 16MB of memory.

I'd like to make a similar change in ieee1394/dma.c.  Right now, it
allocates large DMA regions with vmalloc().  One reason why that is bad
is because it often returns physical addresses larger than 32-bits,
causing the hardware to use bounce buffers (and is thus slow, and also
happened to expose a bug in swiotlb).

-David

On Sun, 2007-02-04 at 13:05 +0100, Stefan Richter wrote:
> In order to use OHCI physical DMA, all s/g elements, s/g tables, ORBs,
> and response buffers have to reside within the first 4 GB of the
> FireWire controller's physical address space.  Set the correct mask for
> DMA mappings.
> 
> Also ensure that the memory allocated for command ORBs and s/g tables is
> suitable for DMA.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
> Should I use GFP_DMA32 instead of GFP_DMA?
> 
> 
>  drivers/ieee1394/sbp2.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.20-rc5/drivers/ieee1394/sbp2.c
> ===================================================================
> --- linux-2.6.20-rc5.orig/drivers/ieee1394/sbp2.c
> +++ linux-2.6.20-rc5/drivers/ieee1394/sbp2.c
> @@ -477,7 +477,7 @@ static int sbp2util_create_command_orb_p
>  
>  	spin_lock_irqsave(&lu->cmd_orb_lock, flags);
>  	for (i = 0; i < orbs; i++) {
> -		cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
> +		cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC | GFP_DMA);
>  		if (!cmd) {
>  			spin_unlock_irqrestore(&lu->cmd_orb_lock, flags);
>  			return -ENOMEM;
> @@ -757,6 +757,11 @@ static struct sbp2_lu *sbp2_alloc_device
>  			SBP2_ERR("failed to register lower 4GB address range");
>  			goto failed_alloc;
>  		}
> +#else
> +		if (dma_set_mask(hi->host->device.parent, DMA_32BIT_MASK)) {
> +			SBP2_ERR("failed to set 4GB DMA mask");
> +			goto failed_alloc;
> +		}
>  #endif
>  	}
>  
> 
> 


-------------------------------------------------------------------------
Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier.
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
