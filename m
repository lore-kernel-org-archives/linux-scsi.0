From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 5/6] esp_scsi: De-duplicate PIO routines
Date: Mon, 15 Oct 2018 17:17:40 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1810151701360.10@nippy.intranet>
References: <cover.1539391876.git.fthain@telegraphics.com.au> <09d3a141dc16af63921f5414263069e9b4f97222.1539391876.git.fthain@telegraphics.com.au> <a75d4dc3-5966-b437-6f18-da2d6a769ec2@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a75d4dc3-5966-b437-6f18-da2d6a769ec2@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On Mon, 15 Oct 2018, Hannes Reinecke wrote:

> On 10/13/18 2:51 AM, Finn Thain wrote:
> > As a temporary measure, the code to implement PIO transfers was
> > duplicated in zorro_esp and mac_esp. Now that this code has stabilized,
> > move it into the core driver to eliminate the duplication.
> > 
> > This replaces the inline assembler with more portable writesb() calls.
> > Optimizing the m68k writesb() implementation is a separate patch.
> > 
> > Tested-by: Stan Johnson <userm57@yahoo.com>
> > Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> > ---
> >   drivers/scsi/esp_scsi.c  | 126 +++++++++++++++++++++++++
> >   drivers/scsi/esp_scsi.h  |   5 +
> >   drivers/scsi/mac_esp.c   | 173 ++---------------------------------
> >   drivers/scsi/zorro_esp.c | 232 +++++++----------------------------------------
> >   4 files changed, 171 insertions(+), 365 deletions(-)
> > 
> > diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> > index 6ccaf818357e..646701fc22a4 100644
> > --- a/drivers/scsi/esp_scsi.c
> > +++ b/drivers/scsi/esp_scsi.c
> > @@ -2776,3 +2776,129 @@ MODULE_PARM_DESC(esp_debug,
> >   
> >   module_init(esp_init);
> >   module_exit(esp_exit);
> > +
> > +#if IS_ENABLED(CONFIG_SCSI_MAC_ESP) || IS_ENABLED(CONFIG_SCSI_ZORRO_ESP)
> > +static inline unsigned int esp_wait_for_fifo(struct esp *esp)
> > +{
> > +	int i = 500000;
> > +
> > +	do {
> > +		unsigned int fbytes = esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES;
> > +
> > +		if (fbytes)
> > +			return fbytes;
> > +
> > +		udelay(2);
> > +	} while (--i);
> > +
> > +	pr_err("FIFO is empty (sreg %02x)\n", esp_read8(ESP_STATUS));
> > +	return 0;
> > +}
> > +
> > +static inline int esp_wait_for_intr(struct esp *esp)
> > +{
> > +	int i = 500000;
> > +
> > +	do {
> > +		esp->sreg = esp_read8(ESP_STATUS);
> > +		if (esp->sreg & ESP_STAT_INTR)
> > +			return 0;
> > +
> > +		udelay(2);
> > +	} while (--i);
> > +
> > +	pr_err("IRQ timeout (sreg %02x)\n", esp->sreg);
> > +	return 1;
> > +}
> > +
> > +#define ESP_FIFO_SIZE 16
> > +
> > +void esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
> > +		      u32 dma_count, int write, u8 cmd)
> > +{
> > +	u8 phase = esp->sreg & ESP_STAT_PMASK;
> > +
> > +	cmd &= ~ESP_CMD_DMA;
> > +	esp->send_cmd_error = 0;
> > +
> > +	if (write) {
> > +		u8 *dst = (u8 *)addr;
> > +		u8 mask = ~(phase == ESP_MIP ? ESP_INTR_FDONE : ESP_INTR_BSERV);
> > +
> > +		scsi_esp_cmd(esp, cmd);
> > +
> > +		while (1) {
> > +			if (!esp_wait_for_fifo(esp))
> > +				break;
> > +
> > +			*dst++ = esp_read8(ESP_FDATA);
> > +			--esp_count;
> > +
> > +			if (!esp_count)
> > +				break;
> > +
> > +			if (esp_wait_for_intr(esp)) {
> > +				esp->send_cmd_error = 1;
> > +				break;
> > +			}
> > +
> > +			if ((esp->sreg & ESP_STAT_PMASK) != phase)
> > +				break;
> > +
> > +			esp->ireg = esp_read8(ESP_INTRPT);
> > +			if (esp->ireg & mask) {
> > +				esp->send_cmd_error = 1;
> > +				break;
> > +			}
> > +
> > +			if (phase == ESP_MIP)
> > +				scsi_esp_cmd(esp, ESP_CMD_MOK);
> > +
> > +			scsi_esp_cmd(esp, ESP_CMD_TI);
> > +		}
> > +	} else {
> > +		unsigned int n = ESP_FIFO_SIZE;
> > +		u8 *src = (u8 *)addr;
> > +
> > +		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
> > +
> > +		if (n > esp_count)
> > +			n = esp_count;
> > +		writesb(esp->fifo_reg, src, n);
> > +		src += n;
> > +		esp_count -= n;
> > +
> > +		scsi_esp_cmd(esp, cmd);
> > +
> > +		while (esp_count) {
> > +			if (esp_wait_for_intr(esp)) {
> > +				esp->send_cmd_error = 1;
> > +				break;
> > +			}
> > +
> > +			if ((esp->sreg & ESP_STAT_PMASK) != phase)
> > +				break;
> > +
> > +			esp->ireg = esp_read8(ESP_INTRPT);
> > +			if (esp->ireg & ~ESP_INTR_BSERV) {
> > +				esp->send_cmd_error = 1;
> > +				break;
> > +			}
> > +
> > +			n = ESP_FIFO_SIZE -
> > +			    (esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES);
> > +
> > +			if (n > esp_count)
> > +				n = esp_count;
> > +			writesb(esp->fifo_reg, src, n);
> > +			src += n;
> > +			esp_count -= n;
> > +
> > +			scsi_esp_cmd(esp, ESP_CMD_TI);
> > +		}
> > +	}
> > +
> > +	esp->send_cmd_residual = esp_count;
> > +}
> > +EXPORT_SYMBOL(esp_send_pio_cmd);
> > +#endif
> 
> These function are conditional, but
> 
> > diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
> > index d0c032803749..2590e5eda595 100644
> > --- a/drivers/scsi/esp_scsi.h
> > +++ b/drivers/scsi/esp_scsi.h
> > @@ -431,6 +431,7 @@ struct esp_driver_ops {
> >   struct esp {
> >   	void __iomem		*regs;
> >   	void __iomem		*dma_regs;
> > +	u8 __iomem		*fifo_reg;
> >   
> >   	const struct esp_driver_ops *ops;
> >   
> > @@ -540,6 +541,7 @@ struct esp {
> >   	void			*dma;
> >   	int			dmarev;
> >   
> > +	int			send_cmd_error;
> >   	int			send_cmd_residual;
> >   };
> >   
> > @@ -581,4 +583,7 @@ extern void scsi_esp_unregister(struct esp *);
> >   extern irqreturn_t scsi_esp_intr(int, void *);
> >   extern void scsi_esp_cmd(struct esp *, u8);
> >   
> > +extern void esp_send_pio_cmd(struct esp *esp, u32 dma_addr, u32 esp_count,
> > +			     u32 dma_count, int write, u8 cmd);
> > +
> >   #endif /* !(_ESP_SCSI_H) */
> These are not.
> 
> Which will result in building errors when the said configuration is not 
> enabled.

I didn't see errors or new warnings when build-testing with 
CONFIG_SCSI_AM53C974=y with gcc-5.4 or gcc-7.3, nor when build-testing 
CONFIG_SUN3X_ESP=y with gcc-4.4.

Are you perhaps thinking of "declared static but never defined"? That 
doesn't apply here because esp_send_pio_cmd() isn't static. Likewise 
"static declaration of 'foo' follows non-static declaration"...

-- 

> Cheers,
> 
> Hannes
> -- 
> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N?rnberg
> GF: F. Imend?rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N?rnberg)
> 
