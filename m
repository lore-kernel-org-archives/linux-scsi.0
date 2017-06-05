From: "Christian T. Steigies" <cts@debian.org>
Subject: Re: [PATCH] m68k/atari: atari_scsi.c - use m68k_realnum_memory for
 FastRAM test
Date: Mon, 5 Jun 2017 21:17:09 +0200
Message-ID: <20170605191709.GB4005@nunzio.venus.sol>
References: <1496648279-15702-1-git-send-email-schmitzmic@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1496648279-15702-1-git-send-email-schmitzmic@gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: linux-m68k@vger.kernel.org, fthain@telegraphics.com.au, geert@linux-m68k.org, cts@debian.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 05, 2017 at 07:37:59PM +1200, Michael Schmitz wrote:
> m68k_num_memory is unsuitable to test for the presence of FastRAM
> on CT60 if the kernel is located in FastRAM: in arch/m68k/mm/motorola.c
> the ST-RAM chunk is skipped and m68k_num_memory is decremented in this
> case. m68k_realnum_memory still contains the actual number of RAM chunks
> so use that.
> 
> Tested by Christian Steiges on his Falcon with kernel loaded in FastRAM
> - could you please reply with your Tested-by tag, Christian?

Sure, do I need to sign it or is this ok?

Tested-by: Christian T. Steigies <cts@debian.org>
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
> ---
>  drivers/scsi/atari_scsi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index f792420..a75feeb 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -776,7 +776,7 @@ static int __init atari_scsi_probe(struct platform_device *pdev)
>  	 * from/to alternative Ram.
>  	 */
>  	if (ATARIHW_PRESENT(ST_SCSI) && !ATARIHW_PRESENT(EXTD_DMA) &&
> -	    m68k_num_memory > 1) {
> +	    m68k_realnum_memory > 1) {
>  		atari_dma_buffer = atari_stram_alloc(STRAM_BUFFER_SIZE, "SCSI");
>  		if (!atari_dma_buffer) {
>  			pr_err(PFX "can't allocate ST-RAM double buffer\n");
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
