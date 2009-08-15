From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] stex: Add reset code for st_yel
Date: Sat, 15 Aug 2009 07:10:26 -0400
Message-ID: <4A8697A2.3050704@garzik.org>
References: <200908142202591084033@promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:44378 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116AbZHOLKc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Aug 2009 07:10:32 -0400
In-Reply-To: <200908142202591084033@promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ed.lin@promise.com
Cc: "James.Bottomley" <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, promise_linux <promise_linux@promise.com>

Ed Lin wrote:
> Add reset related code for st_yel.
> 1. Set the SS_H2I_INT_RESET bit.
> 2. Wait for the SS_MU_OPERATIONAL flag. This is also part of
>    normal handshake process so move it to handshake routine.
> 3. Continue handshake with the firmware.
> 
> Signed-off-by: Ed Lin <ed.lin@promise.com>
> ---
> 
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index 8d2a95c..b57f92f 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -55,6 +55,7 @@ enum {
>  	OIS	= 0x30,	/* MU_OUTBOUND_INTERRUPT_STATUS */
>  	OIM	= 0x3c,	/* MU_OUTBOUND_INTERRUPT_MASK */
>  
> +	YIOA_STATUS				= 0x00,
>  	YH2I_INT				= 0x20,
>  	YINT_EN					= 0x34,
>  	YI2H_INT				= 0x9c,
> @@ -108,6 +109,10 @@ enum {
>  
>  	SS_HEAD_HANDSHAKE			= 0x80,
>  
> +	SS_H2I_INT_RESET			= 0x100,
> +
> +	SS_MU_OPERATIONAL			= 0x80000000,
> +
>  	STEX_CDB_LENGTH				= 16,
>  	STATUS_VAR_LEN				= 128,
>  
> @@ -884,7 +889,7 @@ static void stex_ss_mu_intr(struct st_hba *hba)
>  		tag = (u16)value;
>  		if (unlikely(tag >= hba->host->can_queue)) {
>  			printk(KERN_WARNING DRV_NAME
> -					"(%s): invalid tag\n", pci_name(hba->pdev));
> +				"(%s): invalid tag\n", pci_name(hba->pdev));
>  			continue;
>  		}
>  
> @@ -1040,16 +1045,28 @@ static int stex_ss_handshake(struct st_hba *hba)
>  	void __iomem *base = hba->mmio_base;
>  	struct st_msg_header *msg_h;
>  	struct handshake_frame *h;
> -	__le32 *scratch = hba->scratch;
> +	__le32 *scratch;
>  	u32 data;
>  	unsigned long before;
>  	int ret = 0;
>  
> -	h = (struct handshake_frame *)(hba->alloc_rq(hba));
> -	msg_h = (struct st_msg_header *)h - 1;
> +	before = jiffies;
> +	while ((readl(base + YIOA_STATUS) & SS_MU_OPERATIONAL) == 0) {
> +		if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
> +			printk(KERN_ERR DRV_NAME
> +				"(%s): firmware not operational\n",
> +				pci_name(hba->pdev));
> +			return -1;
> +		}
> +		rmb();
> +		msleep(1);
> +	}

hmmmmm.  Is that rmb() really necessary?  It does not appear to be so.

At worst, the rmb should occur immediately after the loop, no?

ACK everything else.

	Jeff


