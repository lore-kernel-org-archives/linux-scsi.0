From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v2 78/71] ncr5380: Add support for HP 53C400A-based cards (C2502)
Date: Wed, 9 Dec 2015 12:33:36 +0100
Message-ID: <201512091233.36721.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <1449561099-9981-1-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1512082137380.24631@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:57681 "EHLO
	smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbLILdr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 06:33:47 -0500
In-Reply-To: <alpine.LNX.2.00.1512082137380.24631@nippy.intranet>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tuesday 08 December 2015 12:40:18 Finn Thain wrote:
> 
> On Tue, 8 Dec 2015, Ondrej Zary wrote:
> 
> > HP C2502 cards (based on 53C400A chips) use different magic numbers for 
> > software-based I/O address configuration than other cards. The 
> > configuration is also extended to allow setting the IRQ.
> > 
> > Move the configuration to a new function magic_configure() and move 
> > magic the magic numbers into an array. Add new magic numbers for these 
> > HP cards and hp_53c400a module parameter to use them.
> > 
> > Tested with HP C2502 and DTCT-436P.
> > 
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > ---
> >  drivers/scsi/g_NCR5380.c |   76 ++++++++++++++++++++++++++++++++++++----------
> >  drivers/scsi/g_NCR5380.h |    1 +
> >  2 files changed, 61 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> > index 42fdeaf..121d143 100644
> > --- a/drivers/scsi/g_NCR5380.c
> > +++ b/drivers/scsi/g_NCR5380.c
> > @@ -80,6 +80,7 @@ static int ncr_5380;
> >  static int ncr_53c400;
> >  static int ncr_53c400a;
> >  static int dtc_3181e;
> > +static int hp_53c400a;
> 
> From the photos that I've seen, the HP cards have either NCR or SYMBIOS 
> 53C400A devices.
> 
> You've added a new setup option and a new board type, but the name you've 
> chosen is neither the board type nor the device type. It is a combination.

Because it's a HP board with NCR/SYMBIOS 53C400A chip. Windows driver calls
it "Symbios Logic 53C400A (HP Version)", suggesting that there might be more
compatible cards.
But search did not found any on the web, only C2502. So I'll rename it to
hp_c2502.

> >  
> >  static struct override {
> >  	NCR5380_map_type NCR5380_map_name;
> > @@ -225,6 +226,32 @@ static int __init do_DTC3181E_setup(char *str)
> >  
> >  #endif
> >  
> > +#ifndef SCSI_G_NCR5380_MEM
> > +/*
> > + * Configure I/O address of 53C400A or DTC 3181 by writing magic numbers
> > + * to ports 0x779 and 0x379. Two magic number sequences are known:
> > + *  1. for generic NCR 53C400A-based cards and DTC436 chips
> > + *  2. for HP C2502 card (also based on 53C400A but different decode logic)
> 
> Forgive my ignorance of ISA card design, but that suggests that these 
> magic numbers are only relevant to HP C2502 boards and not SYM 53C400A 
> devices in general (?) ...

Looks like the original magic numbers (they came from the outb() calls, now
in ncr_53c400a_magic[]) are hardcoded in the 53C400A chip (and also DTC
chips).

HP C2502 card has some PALCE chips between the ISA bus and 53C400A. They
probably react to the HP-specific magic numbers (and don't pass the
"original" magic numbers to the 53C400A chip).

> > + */
> > +static void magic_configure(int idx, u8 irq, u8 magic[])
> > +{
> > +	u8 cfg = 0;
> > +
> > +	outb(magic[0], 0x779);
> > +	outb(magic[1], 0x379);
> > +	outb(magic[2], 0x379);
> > +	outb(magic[3], 0x379);
> > +	outb(magic[4], 0x379);
> > +
> > +	/* allowed IRQs for HP 53C400A */
> > +	if (irq != 2 && irq != 3 && irq != 4 && irq != 5 && irq != 7)
> > +		irq = 0;
> > +	if (idx >= 0 && idx <= 7)
> > +		cfg = 0x80 | idx | (irq << 4);
> > +	outb(cfg, 0x379);
> > +}
> > +#endif
> > +
> >  /**
> >   * 	generic_NCR5380_detect	-	look for NCR5380 controllers
> >   *	@tpnt: the scsi template
> > @@ -241,8 +268,9 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
> >  	static int current_override;
> >  	int count;
> >  	unsigned int *ports;
> > +	u8 *magic;
> >  #ifndef SCSI_G_NCR5380_MEM
> > -	int i;
> > +	int i, port_idx;
> >  	unsigned long region_size = 16;
> >  #endif
> >  	static unsigned int __initdata ncr_53c400a_ports[] = {
> > @@ -251,6 +279,12 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
> >  	static unsigned int __initdata dtc_3181e_ports[] = {
> >  		0x220, 0x240, 0x280, 0x2a0, 0x2c0, 0x300, 0x320, 0x340, 0
> >  	};
> > +	static u8 ncr_53c400a_magic[] __initdata = {	/* 53C400A & DTC 3181 */
> > +		0x59, 0xb9, 0xc5, 0xae, 0xa6
> > +	};
> > +	static u8 hp_53c400a_magic[] __initdata = {	/* HP C2502 */
> > +		0x0f, 0x22, 0xf0, 0x20, 0x80
> > +	};
> 
> ... so maybe that should be called 'hp_c2502_magic'?

Yes.

> >  	int flags;
> >  	struct Scsi_Host *instance;
> >  	struct NCR5380_hostdata *hostdata;
> > @@ -273,6 +307,8 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
> >  		overrides[0].board = BOARD_NCR53C400A;
> >  	else if (dtc_3181e)
> >  		overrides[0].board = BOARD_DTC3181E;
> > +	else if (hp_53c400a)
> > +		overrides[0].board = BOARD_HP53C400A;
> >  #ifndef SCSI_G_NCR5380_MEM
> >  	if (!current_override && isapnp_present()) {
> >  		struct pnp_dev *dev = NULL;
> > @@ -326,10 +362,17 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
> >  		case BOARD_NCR53C400A:
> >  			flags = FLAG_NO_DMA_FIXUP;
> >  			ports = ncr_53c400a_ports;
> > +			magic = ncr_53c400a_magic;
> > +			break;
> > +		case BOARD_HP53C400A:
> > +			flags = FLAG_NO_DMA_FIXUP;
> > +			ports = ncr_53c400a_ports;
> > +			magic = hp_53c400a_magic;
> >  			break;
> >  		case BOARD_DTC3181E:
> >  			flags = FLAG_NO_DMA_FIXUP;
> >  			ports = dtc_3181e_ports;
> > +			magic = ncr_53c400a_magic;
> >  			break;
> >  		}
> >  
> > @@ -338,12 +381,7 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
> >  			/* wakeup sequence for the NCR53C400A and DTC3181E */
> >  
> >  			/* Disable the adapter and look for a free io port */
> > -			outb(0x59, 0x779);
> > -			outb(0xb9, 0x379);
> > -			outb(0xc5, 0x379);
> > -			outb(0xae, 0x379);
> > -			outb(0xa6, 0x379);
> > -			outb(0x00, 0x379);

Magic numbers from here were moved to ncr_53c400a_magic[].

> > +			magic_configure(-1, 0, magic);
> >  
> >  			if (overrides[current_override].NCR5380_map_name != PORT_AUTO)
> >  				for (i = 0; ports[i]; i++) {
> > @@ -362,17 +400,14 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
> >  				}
> >  			if (ports[i]) {
> >  				/* At this point we have our region reserved */
> > -				outb(0x59, 0x779);
> > -				outb(0xb9, 0x379);
> > -				outb(0xc5, 0x379);
> > -				outb(0xae, 0x379);
> > -				outb(0xa6, 0x379);
> > -				outb(0x80 | i, 0x379);	/* set io port to be used */
> > +				magic_configure(i, 0, magic); /* no IRQ yet */
> >  				outb(0xc0, ports[i] + 9);
> > -				if (inb(ports[i] + 9) != 0x80)
> > +				if (inb(ports[i] + 9) != 0x80) {
> >  					continue;
> > -				else
> > +				} else {
> >  					overrides[current_override].NCR5380_map_name = ports[i];
> > +					port_idx = i;
> > +				}
> >  			} else
> >  				continue;
> >  		}
> > @@ -418,6 +453,7 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
> >  			hostdata->io_width = 2;	/* 16-bit PDMA */
> >  			/* fall through */
> >  		case BOARD_NCR53C400A:
> > +		case BOARD_HP53C400A:
> >  			hostdata->c400_ctl_status = 9;
> >  			hostdata->c400_blk_cnt = 10;
> >  			hostdata->c400_host_buf = 8;
> > @@ -438,6 +474,7 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
> >  
> >  		if (overrides[current_override].board == BOARD_NCR53C400 ||
> >  		    overrides[current_override].board == BOARD_NCR53C400A ||
> > +		    overrides[current_override].board == BOARD_HP53C400A ||
> >  		    overrides[current_override].board == BOARD_DTC3181E)
> >  			NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
> >  
> > @@ -452,12 +489,18 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
> >  		if (instance->irq == 255)
> >  			instance->irq = NO_IRQ;
> >  
> > -		if (instance->irq != NO_IRQ)
> > +		if (instance->irq != NO_IRQ) {
> > +#ifndef SCSI_G_NCR5380_MEM
> > +			/* set IRQ for HP 53C400A */
> > +			if (overrides[current_override].board == BOARD_HP53C400A)
> > +				magic_configure(port_idx, instance->irq, magic);
> > +#endif
> >  			if (request_irq(instance->irq, generic_NCR5380_intr,
> >  					0, "NCR5380", instance)) {
> >  				printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
> >  				instance->irq = NO_IRQ;
> >  			}
> > +		}
> >  
> >  		if (instance->irq == NO_IRQ) {
> >  			printk(KERN_INFO "scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
> > @@ -743,6 +786,7 @@ module_param(ncr_5380, int, 0);
> >  module_param(ncr_53c400, int, 0);
> >  module_param(ncr_53c400a, int, 0);
> >  module_param(dtc_3181e, int, 0);
> > +module_param(hp_53c400a, int, 0);
> 
> Any reason you did not add the corresponding __setup option?

I wonder if __setup is really required. I thought that it should go away and
module parameters used instead.

> Did you consider re-using the existing ncr_53c400a option (for port & irq 
> settings) and adding a new setup option and module param for card magic?

Looks like a good idea.

> (I like orthogonal command line options. dtc_3181e doesn't really bother 
> me because the dtc-436 device seems to correspond to the 3181e card and 
> vice versa.)
> 
> >  MODULE_LICENSE("GPL");
> >  
> >  #if !defined(SCSI_G_NCR5380_MEM) && defined(MODULE)
> > diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
> > index 5ab64d9..4fbae53 100644
> > --- a/drivers/scsi/g_NCR5380.h
> > +++ b/drivers/scsi/g_NCR5380.h
> > @@ -88,6 +88,7 @@
> >  #define BOARD_NCR53C400	1
> >  #define BOARD_NCR53C400A 2
> >  #define BOARD_DTC3181E	3
> > +#define BOARD_HP53C400A 4
> >  
> >  #endif /* GENERIC_NCR5380_H */
> >  
> > 
> 


-- 
Ondrej Zary
