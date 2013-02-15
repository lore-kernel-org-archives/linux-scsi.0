From: Ben Collins <bcollins@ubuntu.com>
Subject: Re: [PATCH] [SCSI] aacraid: Fix invalid bit shifts of DMA address
Date: Fri, 15 Feb 2013 11:19:27 -0500
Message-ID: <EA999CA9-D99A-438A-9037-6F1887737F62@ubuntu.com>
References: <1360939806.5374.375.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:45405 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935977Ab3BOQTb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Feb 2013 11:19:31 -0500
Received: by mail-da0-f49.google.com with SMTP id t11so1523017daj.36
        for <linux-scsi@vger.kernel.org>; Fri, 15 Feb 2013 08:19:30 -0800 (PST)
In-Reply-To: <1360939806.5374.375.camel@deadeye.wl.decadent.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Feb 15, 2013, at 9:50 AM, Ben Hutchings <ben@decadent.org.uk> wrote:

> Commit b5f1758f221e ('[SCSI] aacraid: Fix endian issues in core and
> SRC portions of driver') changed the type of the address variable in
> aac_src_deliver_message() from u64 to dma_addr_t.  In configurations
> with 32-bit dma_addr_t, this results in:
> 
> drivers/scsi/aacraid/src.c: In function 'aac_src_deliver_message':
> drivers/scsi/aacraid/src.c:410:3: warning: right shift count >= width of type [enabled by default]
> drivers/scsi/aacraid/src.c:434:2: warning: right shift count >= width of type [enabled by default]
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: stable <stable@vger.kernel.org> # v3.6+
> ---
> This is compile-tested only.

Still works for me. It would be nice to alleviate the BUG_ON when sizeof(dma_addr_t) == 4. I'm wondering, since this driver sets DMA_BIT_MASK correctly, if this check is even needed.

> Ben.
> 
> drivers/scsi/aacraid/src.c |    4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index 3b021ec..129b984 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -407,7 +407,7 @@ static int aac_src_deliver_message(struct fib *fib)
> 		fib->hw_fib_va->header.StructType = FIB_MAGIC2;
> 		fib->hw_fib_va->header.SenderFibAddress = (u32)address;
> 		fib->hw_fib_va->header.u.TimeStamp = 0;
> -		BUG_ON((u32)(address >> 32) != 0L);
> +		BUG_ON((u64)address >> 32);
> 		address |= fibsize;
> 	} else {
> 		/* Calculate the amount to the fibsize bits */
> @@ -431,7 +431,7 @@ static int aac_src_deliver_message(struct fib *fib)
> 		address |= fibsize;
> 	}
> 
> -	src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
> +	src_writel(dev, MUnit.IQ_H, (u64)address >> 32);
> 	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
> 
> 	return 0;
> 

--
Servergy  : http://www.servergy.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/

