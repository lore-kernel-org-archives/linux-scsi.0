From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Making sym-2 do 160 MB/sec
Date: Thu, 20 Feb 2003 18:43:02 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E548706.1080004@torque.net>
References: <20030219120639.3df58497.akpm@digeo.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: linux-scsi@vger.kernel.org

Andrew Morton wrote:
> I have a machine here in which both the controller (53c1010) and the disk
> (IBM IC35L036UCD210-0) can do FAST-80, but the sym2 driver only does FAST-40.
> 
> The below patch fixes it up, and has been fearsomely tested.
> 
> Can anyone tell me whether it is right, and what is generally going on in
> there?
> 
> 
> diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.c~sym-do-160 drivers/scsi/sym53c8xx_2/sym_hipd.c
> --- 25-power4/drivers/scsi/sym53c8xx_2/sym_hipd.c~sym-do-160	2003-02-19 01:04:59.000000000 -0800
> +++ 25-power4-akpm/drivers/scsi/sym53c8xx_2/sym_hipd.c	2003-02-19 01:05:13.000000000 -0800
> @@ -800,7 +800,8 @@ static int sym_prepare_setting(hcb_p np,
>  	 * Btw, 'period' is in tenths of nanoseconds.
>  	 */
>  	period = (4 * div_10M[0] + np->clock_khz - 1) / np->clock_khz;
> -	if	(period <= 250)		np->minsync = 10;
> +	if	(period == 250)		np->minsync = 9;
> +	else if	(period <= 250)		np->minsync = 10;
>  	else if	(period <= 303)		np->minsync = 11;
>  	else if	(period <= 500)		np->minsync = 12;
>  	else				np->minsync = (period + 40 - 1) / 40;

Andrew,
My Tekram 390U3W card attains "FAST-80" with a Fujitsu
MAM3184MP disk. This is with the sym53c8xx_2 driver in
2.5.62 . I haven't noticed any speed problems with earlier
versions of the 2.5 series. lspci reports:

00:0c.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1010
      Ultra3 SCSI Adapter (rev 01)
00:0c.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1010
      Ultra3 SCSI Adapter (rev 01)

Here is some data from the sym53c8xx_2 driver:

$ cat /proc/scsi/sym53c8xx/0
Chip sym53c1010-33, device id 0x20, revision id 0x1
On PCI bus 0, device 12, function 0, IRQ 11
Min. period factor 9, Wide SCSI BUS, DT capable
Max. started commands 510, max. commands per LUN 64

... and here is the relevant boot-up messages from
my /var/log/messages :

sym.0.12.1: setting PCI_COMMAND_PARITY...
sym0: <1010-33> rev 0x1 on pci bus 0 device 12 function 0 irq 11
sym0: using 64 bit DMA addressing
sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: handling phase mismatch from SCRIPTS.
sym0: SCSI BUS has been reset.
sym1: <1010-33> rev 0x1 on pci bus 0 device 12 function 1 irq 11
sym1: using 64 bit DMA addressing
sym1: Symbios NVRAM, ID 7, Fast-80, SE, parity checking
sym1: open drain IRQ line driver, using on-chip SRAM
sym1: using LOAD/STORE-based firmware.
sym1: handling phase mismatch from SCRIPTS.
sym1: SCSI BUS has been reset.
scsi0 : sym-2.1.16a
   Vendor: FUJITSU   Model: MAM3184MP         Rev: 0105
   Type:   Direct-Access                      ANSI SCSI revision: 03
sym0:1:0: tagged command queuing enabled, command queue depth 16.
sym0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
scsi1 : sym-2.1.16a
SCSI device sda: 35885344 512-byte hdwr sectors (18373 MB)
SCSI device sda: drive cache: write back
  sda: sda1 sda2 sda3 sda4 < sda5 >
Attached scsi disk sda at scsi0, channel 0, id 1, lun 0

Here is a snippet from my .config file:

CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_IOMAPPED is not set


Doug Gilbert





