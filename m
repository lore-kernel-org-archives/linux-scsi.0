From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 5/6] esp_scsi: De-duplicate PIO routines
Date: Mon, 15 Oct 2018 08:14:34 +0200
Message-ID: <35ac9f31-7068-ab93-4629-363ee0bb4c70@suse.de>
References: <cover.1539497520.git.fthain@telegraphics.com.au>
 <d5fe773ea8c922631836dad2ef2dbb952672c7c7.1539497520.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d5fe773ea8c922631836dad2ef2dbb952672c7c7.1539497520.git.fthain@telegraphics.com.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/14/18 8:12 AM, Finn Thain wrote:
> As a temporary measure, the code to implement PIO transfers was
> duplicated in zorro_esp and mac_esp. Now that it has stabilized
> move the common code into the core driver but don't build it unless
> needed.
> 
> This replaces the inline assembler with more portable writesb() calls.
> Optimizing the m68k writesb() implementation is a separate patch.
> 
> Tested-by: Stan Johnson <userm57@yahoo.com>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>
> ---
> Changed since v1:
>   - Use shost_printk() instead of pr_err().
>   - Add new symbol CONFIG_SCSI_ESP_PIO to Kconfig.
> ---
>   drivers/scsi/Kconfig     |   6 +
>   drivers/scsi/esp_scsi.c  | 128 +++++++++++++++++++++
>   drivers/scsi/esp_scsi.h  |   5 +
>   drivers/scsi/mac_esp.c   | 173 +----------------------------
>   drivers/scsi/zorro_esp.c | 232 ++++++---------------------------------
>   5 files changed, 179 insertions(+), 365 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 35c909bbf8ba..81c6872f24f8 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -42,6 +42,10 @@ config SCSI_DMA
>   	bool
>   	default n
>   
> +config SCSI_ESP_PIO
> +	bool
> +	default n
> +
>   config SCSI_NETLINK
>   	bool
>   	default	n
> @@ -1355,6 +1359,7 @@ config SCSI_ZORRO_ESP
>   	tristate "Zorro ESP SCSI support"
>   	depends on ZORRO && SCSI
>   	select SCSI_SPI_ATTRS
> +	select SCSI_ESP_PIO
>   	help
>   	  Support for various NCR53C9x (ESP) based SCSI controllers on Zorro
>   	  expansion boards for the Amiga.
> @@ -1397,6 +1402,7 @@ config SCSI_MAC_ESP
>   	tristate "Macintosh NCR53c9[46] SCSI"
>   	depends on MAC && SCSI
>   	select SCSI_SPI_ATTRS
> +	select SCSI_ESP_PIO
>   	help
>   	  This is the NCR 53c9x SCSI controller found on most of the 68040
>   	  based Macintoshes.
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 6ccaf818357e..305a322ad13c 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -2776,3 +2776,131 @@ MODULE_PARM_DESC(esp_debug,
>   
>   module_init(esp_init);
>   module_exit(esp_exit);
> +
> +#ifdef CONFIG_SCSI_ESP_PIO
> +static inline unsigned int esp_wait_for_fifo(struct esp *esp)
> +{
> +	int i = 500000;
> +
> +	do {
> +		unsigned int fbytes = esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES;
> +
> +		if (fbytes)
> +			return fbytes;
> +
> +		udelay(2);
> +	} while (--i);
> +
> +	shost_printk(KERN_ERR, esp->host, "FIFO is empty (sreg %02x)\n",
> +		     esp_read8(ESP_STATUS));
> +	return 0;
> +}
> +
> +static inline int esp_wait_for_intr(struct esp *esp)
> +{
> +	int i = 500000;
> +
> +	do {
> +		esp->sreg = esp_read8(ESP_STATUS);
> +		if (esp->sreg & ESP_STAT_INTR)
> +			return 0;
> +
> +		udelay(2);
> +	} while (--i);
> +
> +	shost_printk(KERN_ERR, esp->host, "IRQ timeout (sreg %02x)\n",
> +		     esp->sreg);
> +	return 1;
> +}
> +
> +#define ESP_FIFO_SIZE 16
> +
> +void esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
> +		      u32 dma_count, int write, u8 cmd)
> +{
> +	u8 phase = esp->sreg & ESP_STAT_PMASK;
> +
> +	cmd &= ~ESP_CMD_DMA;
> +	esp->send_cmd_error = 0;
> +
> +	if (write) {
> +		u8 *dst = (u8 *)addr;
> +		u8 mask = ~(phase == ESP_MIP ? ESP_INTR_FDONE : ESP_INTR_BSERV);
> +
> +		scsi_esp_cmd(esp, cmd);
> +
> +		while (1) {
> +			if (!esp_wait_for_fifo(esp))
> +				break;
> +
> +			*dst++ = esp_read8(ESP_FDATA);
> +			--esp_count;
> +
> +			if (!esp_count)
> +				break;
> +
> +			if (esp_wait_for_intr(esp)) {
> +				esp->send_cmd_error = 1;
> +				break;
> +			}
> +
> +			if ((esp->sreg & ESP_STAT_PMASK) != phase)
> +				break;
> +
> +			esp->ireg = esp_read8(ESP_INTRPT);
> +			if (esp->ireg & mask) {
> +				esp->send_cmd_error = 1;
> +				break;
> +			}
> +
> +			if (phase == ESP_MIP)
> +				scsi_esp_cmd(esp, ESP_CMD_MOK);
> +
> +			scsi_esp_cmd(esp, ESP_CMD_TI);
> +		}
> +	} else {
> +		unsigned int n = ESP_FIFO_SIZE;
> +		u8 *src = (u8 *)addr;
> +
> +		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
> +
> +		if (n > esp_count)
> +			n = esp_count;
> +		writesb(esp->fifo_reg, src, n);
> +		src += n;
> +		esp_count -= n;
> +
> +		scsi_esp_cmd(esp, cmd);
> +
> +		while (esp_count) {
> +			if (esp_wait_for_intr(esp)) {
> +				esp->send_cmd_error = 1;
> +				break;
> +			}
> +
> +			if ((esp->sreg & ESP_STAT_PMASK) != phase)
> +				break;
> +
> +			esp->ireg = esp_read8(ESP_INTRPT);
> +			if (esp->ireg & ~ESP_INTR_BSERV) {
> +				esp->send_cmd_error = 1;
> +				break;
> +			}
> +
> +			n = ESP_FIFO_SIZE -
> +			    (esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES);
> +
> +			if (n > esp_count)
> +				n = esp_count;
> +			writesb(esp->fifo_reg, src, n);
> +			src += n;
> +			esp_count -= n;
> +
> +			scsi_esp_cmd(esp, ESP_CMD_TI);
> +		}
> +	}
> +
> +	esp->send_cmd_residual = esp_count;
> +}
> +EXPORT_SYMBOL(esp_send_pio_cmd);
> +#endif
> diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
> index d0c032803749..2590e5eda595 100644
> --- a/drivers/scsi/esp_scsi.h
> +++ b/drivers/scsi/esp_scsi.h
> @@ -431,6 +431,7 @@ struct esp_driver_ops {
>   struct esp {
>   	void __iomem		*regs;
>   	void __iomem		*dma_regs;
> +	u8 __iomem		*fifo_reg;
>   
>   	const struct esp_driver_ops *ops;
>   
> @@ -540,6 +541,7 @@ struct esp {
>   	void			*dma;
>   	int			dmarev;
>   
> +	int			send_cmd_error;
>   	int			send_cmd_residual;
>   };
>   
These variables are only used within esp_send_pio_cmd(); consider making 
them conditional based on the config option.

> @@ -581,4 +583,7 @@ extern void scsi_esp_unregister(struct esp *);
>   extern irqreturn_t scsi_esp_intr(int, void *);
>   extern void scsi_esp_cmd(struct esp *, u8);
>   
> +extern void esp_send_pio_cmd(struct esp *esp, u32 dma_addr, u32 esp_count,
> +			     u32 dma_count, int write, u8 cmd);
> +
>   #endif /* !(_ESP_SCSI_H) */
Same here; the declaration only makes sense when the config option is set.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
