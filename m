From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] 2.6 aacraid: rx check health function update
Date: Fri, 5 Nov 2004 08:06:41 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B4DD8A7@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:28807 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262666AbUKENGo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Nov 2004 08:06:44 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

The bad adapter health is the KERNEL_PANIC (Adapter Kernel Panic, an
indication that a serious hardware problem has been detected inside the
adapter), the allocation failure means we provide a less detailed
indication of failure to the upper layers. If the allocation succeeds,
then the result will indicate the `blink code' which our technical
support departments can decode into a pinpoint of a subsystem failure.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Jens Axboe [mailto:axboe@suse.de] 
Sent: Friday, November 05, 2004 2:25 AM
To: Mark Haverkamp
Cc: James Bottomley; linux-scsi; Salyzyn, Mark
Subject: Re: [PATCH] 2.6 aacraid: rx check health function update

On Thu, Nov 04 2004, Mark Haverkamp wrote:
> This patch updates the rx check health function.  My previous only
> updated the rkt check health code.  This and the previous patch should
> fix the kmalloc return checking bug:
> 
> http://bugme.osdl.org/show_bug.cgi?id=3699 
> 
> Signed-off-by: Mark Haverkamp <markh@osdl.org>
> 
> 
> ===== drivers/scsi/aacraid/rx.c 1.12 vs edited =====
> --- 1.12/drivers/scsi/aacraid/rx.c	2004-11-04 09:32:56 -08:00
> +++ edited/drivers/scsi/aacraid/rx.c	2004-11-04 09:37:33 -08:00
> @@ -274,7 +274,7 @@
>   */
>  static int aac_rx_check_health(struct aac_dev *dev)
>  {
> -	long status = rx_readl(dev, IndexRegs.Mailbox[7]);
> +	u32 status = le32_to_cpu(rx_readl(dev, MUnit.OMRx[0]));
>  
>  	/*
>  	 *	Check to see if the board failed any self tests.
> @@ -285,29 +285,39 @@
>  	 *	Check to see if the board panic'd.
>  	 */
>  	if (status & KERNEL_PANIC) {
> -		char * buffer = kmalloc(512, GFP_KERNEL);
> +		char * buffer;
>  		struct POSTSTATUS {
>  			u32 Post_Command;
>  			u32 Post_Address;
> -		} * post = kmalloc(sizeof(struct POSTSTATUS),
GFP_KERNEL);
> -		dma_addr_t paddr = pci_map_single(dev->pdev, post,
sizeof(struct POSTSTATUS), 2);
> -		dma_addr_t baddr = pci_map_single(dev->pdev, buffer,
512, 1);
> -		u32 status = -1;
> -		int ret = -2;
> +		} * post;
> +		dma_addr_t paddr, baddr;
> +		int ret;
> +
> +		if ((status & 0xFF000000L) == 0xBC000000L)
> +			return (status >> 16) & 0xFF;
> +		buffer = pci_alloc_consistent(dev->pdev, 512, &baddr);
> +		ret = -2;
> +		if (buffer == NULL)
> +			return ret;

I don't think it's a good idea to return bad adapter health, because you
have an allocation failure.

-- 
Jens Axboe

