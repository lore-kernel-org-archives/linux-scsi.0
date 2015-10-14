From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [RFC v6 03/25] m68k/atari: Replace nvram_{read,write}_byte with
 arch_nvram_ops
Date: Wed, 14 Oct 2015 22:19:37 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1510142216390.4586@nippy.intranet>
References: <20150823104129.517600532@telegraphics.com.au> <20150823104130.287718296@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150823104130.287718296@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, Geert Uytterhoeven <geert@linux-m68k.org>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


James, would you please review and ack this patch, and patch 01/25 also?

On Sun, 23 Aug 2015, Finn Thain wrote:

> By implementing an arch_nvram_ops struct, any platform can re-use the
> drivers/char/nvram module without needing any arch-specific code
> in that module. Atari does so here.
> 
> Atari has one user of nvram_check_checksum() whereas the other platforms
> (i.e. x86 and ARM platforms) have none at all. Replace this
> validate-checksum-and-read-byte sequence with the equivalent
> rtc_nvram_ops.read() call and remove the now unused functions.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> Tested-by: Christian T. Steigies <cts@debian.org>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> ---
> 
> The advantage of the new ops struct over the old global nvram_* functions
> is that the misc device module can be shared by different platforms
> without requiring every platform to implement every nvram_* function.
> E.g. only RTC "CMOS" NVRAMs have a checksum for the entire NVRAM
> and only PowerPC platforms have a "sync" ioctl.
> 
> ---
>  arch/m68k/atari/nvram.c   |   89 ++++++++++++++++++++++++++++------------------
>  drivers/scsi/atari_scsi.c |    8 ++--
>  include/linux/nvram.h     |    9 ++++
>  3 files changed, 70 insertions(+), 36 deletions(-)
> 
> Index: linux/arch/m68k/atari/nvram.c
> ===================================================================
> --- linux.orig/arch/m68k/atari/nvram.c	2015-08-23 20:40:55.000000000 +1000
> +++ linux/arch/m68k/atari/nvram.c	2015-08-23 20:40:57.000000000 +1000
> @@ -38,33 +38,12 @@ unsigned char __nvram_read_byte(int i)
>  	return CMOS_READ(NVRAM_FIRST_BYTE + i);
>  }
>  
> -unsigned char nvram_read_byte(int i)
> -{
> -	unsigned long flags;
> -	unsigned char c;
> -
> -	spin_lock_irqsave(&rtc_lock, flags);
> -	c = __nvram_read_byte(i);
> -	spin_unlock_irqrestore(&rtc_lock, flags);
> -	return c;
> -}
> -EXPORT_SYMBOL(nvram_read_byte);
> -
>  /* This races nicely with trying to read with checksum checking */
>  void __nvram_write_byte(unsigned char c, int i)
>  {
>  	CMOS_WRITE(c, NVRAM_FIRST_BYTE + i);
>  }
>  
> -void nvram_write_byte(unsigned char c, int i)
> -{
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&rtc_lock, flags);
> -	__nvram_write_byte(c, i);
> -	spin_unlock_irqrestore(&rtc_lock, flags);
> -}
> -
>  /* On Ataris, the checksum is over all bytes except the checksum bytes
>   * themselves; these are at the very end.
>   */
> @@ -83,18 +62,6 @@ int __nvram_check_checksum(void)
>  	       (__nvram_read_byte(ATARI_CKS_LOC + 1) == (sum & 0xff));
>  }
>  
> -int nvram_check_checksum(void)
> -{
> -	unsigned long flags;
> -	int rv;
> -
> -	spin_lock_irqsave(&rtc_lock, flags);
> -	rv = __nvram_check_checksum();
> -	spin_unlock_irqrestore(&rtc_lock, flags);
> -	return rv;
> -}
> -EXPORT_SYMBOL(nvram_check_checksum);
> -
>  static void __nvram_set_checksum(void)
>  {
>  	int i;
> @@ -106,6 +73,62 @@ static void __nvram_set_checksum(void)
>  	__nvram_write_byte(sum, ATARI_CKS_LOC + 1);
>  }
>  
> +static ssize_t nvram_read(char *buf, size_t count, loff_t *ppos)
> +{
> +	char *p = buf;
> +	loff_t i;
> +
> +	spin_lock_irq(&rtc_lock);
> +
> +	if (!__nvram_check_checksum()) {
> +		spin_unlock_irq(&rtc_lock);
> +		return -EIO;
> +	}
> +
> +	for (i = *ppos; count > 0 && i < NVRAM_BYTES; --count, ++i, ++p)
> +		*p = __nvram_read_byte(i);
> +
> +	spin_unlock_irq(&rtc_lock);
> +
> +	*ppos = i;
> +	return p - buf;
> +}
> +
> +static ssize_t nvram_write(char *buf, size_t count, loff_t *ppos)
> +{
> +	char *p = buf;
> +	loff_t i;
> +
> +	spin_lock_irq(&rtc_lock);
> +
> +	if (!__nvram_check_checksum()) {
> +		spin_unlock_irq(&rtc_lock);
> +		return -EIO;
> +	}
> +
> +	for (i = *ppos; count > 0 && i < NVRAM_BYTES; --count, ++i, ++p)
> +		__nvram_write_byte(*p, i);
> +
> +	__nvram_set_checksum();
> +
> +	spin_unlock_irq(&rtc_lock);
> +
> +	*ppos = i;
> +	return p - buf;
> +}
> +
> +static ssize_t nvram_get_size(void)
> +{
> +	return NVRAM_BYTES;
> +}
> +
> +const struct nvram_ops arch_nvram_ops = {
> +	.read           = nvram_read,
> +	.write          = nvram_write,
> +	.get_size       = nvram_get_size,
> +};
> +EXPORT_SYMBOL(arch_nvram_ops);
> +
>  #ifdef CONFIG_PROC_FS
>  static struct {
>  	unsigned char val;
> Index: linux/drivers/scsi/atari_scsi.c
> ===================================================================
> --- linux.orig/drivers/scsi/atari_scsi.c	2015-08-23 20:40:53.000000000 +1000
> +++ linux/drivers/scsi/atari_scsi.c	2015-08-23 20:40:57.000000000 +1000
> @@ -880,13 +880,15 @@ static int __init atari_scsi_probe(struc
>  #ifdef CONFIG_NVRAM
>  	else
>  		/* Test if a host id is set in the NVRam */
> -		if (ATARIHW_PRESENT(TT_CLK) && nvram_check_checksum()) {
> -			unsigned char b = nvram_read_byte(14);
> +		if (ATARIHW_PRESENT(TT_CLK)) {
> +			unsigned char b;
> +			loff_t offset = 14;
> +			ssize_t count = arch_nvram_ops.read(&b, 1, &offset);
>  
>  			/* Arbitration enabled? (for TOS)
>  			 * If yes, use configured host ID
>  			 */
> -			if (b & 0x80)
> +			if ((count == 1) && (b & 0x80))
>  				atari_scsi_template.this_id = b & 7;
>  		}
>  #endif
> Index: linux/include/linux/nvram.h
> ===================================================================
> --- linux.orig/include/linux/nvram.h	2015-08-23 20:40:53.000000000 +1000
> +++ linux/include/linux/nvram.h	2015-08-23 20:40:57.000000000 +1000
> @@ -10,4 +10,13 @@ extern void __nvram_write_byte(unsigned
>  extern void nvram_write_byte(unsigned char c, int i);
>  extern int __nvram_check_checksum(void);
>  extern int nvram_check_checksum(void);
> +
> +struct nvram_ops {
> +	ssize_t         (*read)(char *, size_t, loff_t *);
> +	ssize_t         (*write)(char *, size_t, loff_t *);
> +	ssize_t         (*get_size)(void);
> +};
> +
> +extern const struct nvram_ops arch_nvram_ops;
> +
>  #endif  /* _LINUX_NVRAM_H */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
