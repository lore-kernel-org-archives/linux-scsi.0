From: Brian King <brking@linux.ibm.com>
Subject: Re: [PATCH v4 5/7] scsi: ipr: Eliminate duplicate barriers on
 weakly-ordered archs
Date: Tue, 29 May 2018 15:45:52 -0500
Message-ID: <a10fa941-1729-2890-50cb-59c4a5b5e596@linux.ibm.com>
References: <1521514207-10695-1-git-send-email-okaya@codeaurora.org>
 <1521514207-10695-6-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521514207-10695-6-git-send-email-okaya@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>, linux-scsi@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/19/2018 09:50 PM, Sinan Kaya wrote:
> Code includes barrier() followed by writel(). writel() already has a
> barrier
> on some architectures like arm64.
> 
> This ends up CPU observing two barriers back to back before executing the
> register write.
> 
> Since code already has an explicit barrier call, changing writeX() to
> writeX_relaxed().
> 
> Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
> ---
>  drivers/scsi/ipr.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index e07dd99..209adac 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -762,9 +762,9 @@ static void ipr_mask_and_clear_interrupts(struct ipr_ioa_cfg *ioa_cfg,
> 
>  	/* Set interrupt mask to stop all new interrupts */
>  	if (ioa_cfg->sis64)
> -		writeq(~0, ioa_cfg->regs.set_interrupt_mask_reg);
> +		writeq_relaxed(~0, ioa_cfg->regs.set_interrupt_mask_reg);
>  	else
> -		writel(~0, ioa_cfg->regs.set_interrupt_mask_reg);
> +		writel_relaxed(~0, ioa_cfg->regs.set_interrupt_mask_reg);
> 
>  	/* Clear any pending interrupts */
>  	if (ioa_cfg->sis64)
> @@ -8435,7 +8435,8 @@ static int ipr_reset_enable_ioa(struct ipr_cmnd *ipr_cmd)
>  	wmb();
>  	if (ioa_cfg->sis64) {
>  		/* Set the adapter to the correct endian mode. */
> -		writel(IPR_ENDIAN_SWAP_KEY, ioa_cfg->regs.endian_swap_reg);
> +		writel_relaxed(IPR_ENDIAN_SWAP_KEY,
> +			       ioa_cfg->regs.endian_swap_reg);
>  		int_reg = readl(ioa_cfg->regs.endian_swap_reg);
>  	}
> 

Looks fine to me. Thanks.

Acked-by: Brian King <brking@linux.vnet.ibm.com>

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center
