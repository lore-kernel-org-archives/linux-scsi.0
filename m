From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 23/29] atari_scsi: Convert to platform device
Date: Mon, 20 Oct 2014 20:33:11 +1300
Message-ID: <5444BAB7.5000908@gmail.com>
References: <20141002065628.256592712@telegraphics.com.au> <20141002065633.766165263@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20141002065633.766165263@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

not certain it is related to this exact patch - the driver crashes 
pretty much on the spot when selecting the first target on the bus.

Panic log:
Atari SCSI: resetting the SCSI bus... done
scsi host0: Atari native SCSI, io_port 0x0, n_io_port 0, base 0x0, irq 
0, can_queue 8, cmd_per_lun 1, sg_tablesize 0, this_id 7, options { 
REAL_DMA SUPPORT_TAGS }
blk_queue_max_segments: set to minimum 1
blk_queue_max_segments: set to minimum 1
blk_queue_max_segments: set to minimum 1
Unable to handle kernel NULL pointer dereference at virtual address 00000158
Oops: 00000000
Modules linked in:
PC: [<000cd87e>] do_coredump+0x3a/0xbe4
SR: 2204  SP: 20803c8c  a2: 00a70000
d0: 00000000    d1: 003c0000    d2: 00000006    d3: 20803dbc
d4: 00025930    d5: 20802000    a0: 00b59c70    a1: 20802000
Process kworker/0:1 (pid: 69, task=00a70000)
Frame format=4 fault addr=00000158 fslw=01050200
Stack from 20803cc8:
        00000006 20803dbc 00025930 20802000 0002b9be 0000001f 20803dd0 
0002aa56
        00a3c540 00b59c70 0008d3e0 00a07cc0 003a8074 00c75000 0002a664 
00000007
        00a7035c 20803dd0 20803e80 00000000 00000000 00000000 00000000 
00000000
        00a70374 0002a9d0 00c75000 00002200 20803dd0 00a70000 00000007 
00a7035c
        0002a5fe 00a70000 0002aa82 00002200 20803dbc 20803dd0 0002aa56 
00a3c540
        0002c5da 00b59c70 0002c6c4 20803dd0 00002200 20803f06 20803f00 
00000000
Call Trace: [<00025930>] do_group_exit+0x0/0x9e
 [<0002b9be>] do_signal_stop+0x0/0x186
 [<0002aa56>] dequeue_signal+0x0/0x118
 [<0008d3e0>] kmem_cache_free+0x10a/0x128
 [<0002a664>] __sigqueue_free+0x32/0x3a
 [<0002a9d0>] __dequeue_signal+0xaa/0x130
 [<00002200>] do_one_initcall+0x18c/0x1d4
 [<0002a5fe>] recalc_sigpending+0x6/0x1e
 [<0002aa82>] dequeue_signal+0x2c/0x118
 [<00002200>] do_one_initcall+0x18c/0x1d4
 [<0002aa56>] dequeue_signal+0x0/0x118
 [<0002c5da>] get_signal+0x7e/0x4aa
 [<0002c6c4>] get_signal+0x168/0x4aa
 [<00002200>] do_one_initcall+0x18c/0x1d4
 [<0019bc12>] NCR5380_transfer_pio.isra.6+0x0/0x1da
 [<000308b6>] move_linked_works+0x0/0x9c
 [<0000428c>] do_signal+0x1a/0x1d8
 [<00002200>] do_one_initcall+0x18c/0x1d4
 [<0019d390>] NCR5380_main+0x9c6/0xd98
 [<00046030>] handle_simple_irq+0x36/0x56
 [<00002c36>] do_IRQ+0x26/0x32
[<00002200>] do_one_initcall+0x18c/0x1d4
 [<00002b1c>] auto_irqhandler_fixup+0x4/0xc
 [<00002200>] do_one_initcall+0x18c/0x1d4
 [<00004a1a>] do_notify_resume+0x3a/0x44
 [<00002ac8>] do_signal_return+0x10/0x1a
 [<0019bc12>] NCR5380_transfer_pio.isra.6+0x0/0x1da
 [<000308b6>] move_linked_works+0x0/0x9c
 [<00002200>] do_one_initcall+0x18c/0x1d4
 [<0019d390>] NCR5380_main+0x9c6/0xd98
 [<00030a2a>] worker_enter_idle+0x0/0x146
 [<00032a08>] process_one_work+0x0/0x2a8
 [<00032cb0>] process_scheduled_works+0x0/0x30
 [<000308b6>] move_linked_works+0x0/0x9c
 [<00032cb0>] process_scheduled_works+0x0/0x30
 [<000308b6>] move_linked_works+0x0/0x9c
 [<00081c00>] change_protection_range+0x150/0x1cc
 [<00032b14>] process_one_work+0x10c/0x2a8
 [<002254bc>] schedule+0x0/0x58
 [<00032dea>] worker_thread+0x10a/0x4d0
 [<0003ee30>] __init_waitqueue_head+0x0/0xc
 [<00032ce0>] worker_thread+0x0/0x4d0
 [<0003ee30>] __init_waitqueue_head+0x0/0xc
 [<00036ee0>] kthread+0xa4/0xc0
 [<00036e3c>] kthread+0x0/0xc0
 [<0000299c>] ret_from_kernel_thread+0xc/0x14

Code: 026c ffa4 206a 0354 2028 0170 2d40 ffac <202b> 0158 2d40 ffb0 286b 
014c 4a8c 670c 4aac 0014 6706 e8c0 0782 660a 4cee 38fc
Disabling lock debugging due to kernel taint

Unable to handle kernel NULL pointer dereference at virtual address 00000158
Oops: 00000000
Modules linked in:
PC: [<000372c2>] kthread_data+0x8/0x10
SR: 2700  SP: 20803af0  a2: 00a70000
d0: 00000003    d1: faf65c54    d2: 00a70000    d3: 00a701e8
d4: 00025930    d5: 20802000    a0: 00000000    a1: 00a90474
Process kworker/0:1 (pid: 69, task=00a70000)
Frame format=4 fault addr=fffffff0 fslw=01050020
Stack from 20803b2c:
        00033976 00a70000 002252a6 00a70000 00000000 00000001 20803b98 
00025930
        20802000 00a70164 0000001f 00a70000 20803b98 00a6fff8 000255b8 
00a90000
        00025526 01050200 20803dbc 00025930 20802000 0002b9be 0000001f 
20803c8c
        00223674 20803dd0 20803d6c 20803b98 20803b98 00a701ac 0000581c 
0000000b
        00000007 00000001 00274ae2 0026dce5 0026e477 00000000 20803c8c 
00006806
        0026e477 20803c8c 00000000 0026e45f 00000158 20803c8c 0002aa56 
00000007
Call Trace: [<00033976>] wq_worker_sleeping+0xa/0x82
 [<002252a6>] __schedule+0x21e/0x394
 [<00025930>] do_group_exit+0x0/0x9e
 [<000255b8>] do_exit+0x550/0x846
 [<00025526>] do_exit+0x4be/0x846
 [<00025930>] do_group_exit+0x0/0x9e
 [<0002b9be>] do_signal_stop+0x0/0x186
 [<00223674>] printk+0x0/0x24
 [<0000581c>] bad_super_trap+0x0/0xb2
 [<00006806>] send_fault_sig+0xaa/0xea
 [<0002aa56>] dequeue_signal+0x0/0x118
 [<00005e5e>] buserr_c+0x254/0x390
 [<0002aa56>] dequeue_signal+0x0/0x118
 [<00002950>] buserr+0x20/0x28
 [<00025930>] do_group_exit+0x0/0x9e
 [<00025930>] do_group_exit+0x0/0x9e
 [<0002b9be>] do_signal_stop+0x0/0x186
 [<0002aa56>] dequeue_signal+0x0/0x118
 [<0008d3e0>] kmem_cache_free+0x10a/0x128
 [<0002a664>] __sigqueue_free+0x32/0x3a
 [<0002a9d0>] __dequeue_signal+0xaa/0x130
 [<00002200>] do_one_initcall+0x18c/0x1d4
 [<0002a5fe>] recalc_sigpending+0x6/0x1e
 [<0002aa82>] dequeue_signal+0x2c/0x118
 [<00002200>] do_one_initcall+0x18c/0x1d4
 [<0002aa56>] dequeue_signal+0x0/0x118
 [<0002c5da>] get_signal+0x7e/0x4aa
[<0002c6c4>] get_signal+0x168/0x4aa
 [<00002200>] do_one_initcall+0x18c/0x1d4
 [<0019bc12>] NCR5380_transfer_pio.isra.6+0x0/0x1da
 [<000308b6>] move_linked_works+0x0/0x9c
 [<0000428c>] do_signal+0x1a/0x1d8
 [<00002200>] do_one_initcall+0x18c/0x1d4
 [<0019d390>] NCR5380_main+0x9c6/0xd98
 [<00046030>] handle_simple_irq+0x36/0x56
 [<00002c36>] do_IRQ+0x26/0x32
 [<00002200>] do_one_initcall+0x18c/0x1d4
 [<00002b1c>] auto_irqhandler_fixup+0x4/0xc
 [<00002200>] do_one_initcall+0x18c/0x1d4
 [<00004a1a>] do_notify_resume+0x3a/0x44
 [<00002ac8>] do_signal_return+0x10/0x1a
 [<0019bc12>] NCR5380_transfer_pio.isra.6+0x0/0x1da
 [<000308b6>] move_linked_works+0x0/0x9c
 [<00002200>] do_one_initcall+0x18c/0x1d4
 [<0019d390>] NCR5380_main+0x9c6/0xd98
 [<00030a2a>] worker_enter_idle+0x0/0x146
 [<00032a08>] process_one_work+0x0/0x2a8
 [<00032cb0>] process_scheduled_works+0x0/0x30
 [<000308b6>] move_linked_works+0x0/0x9c
 [<00032cb0>] process_scheduled_works+0x0/0x30
 [<000308b6>] move_linked_works+0x0/0x9c
 [<00081c00>] change_protection_range+0x150/0x1cc
 [<00032b14>] process_one_work+0x10c/0x2a8
 [<002254bc>] schedule+0x0/0x58
 [<00032dea>] worker_thread+0x10a/0x4d0
 [<0003ee30>] __init_waitqueue_head+0x0/0xc
 [<00032ce0>] worker_thread+0x0/0x4d0
 [<0003ee30>] __init_waitqueue_head+0x0/0xc
 [<00036ee0>] kthread+0xa4/0xc0
 [<00036e3c>] kthread+0x0/0xc0
 [<0000299c>] ret_from_kernel_thread+0xc/0x14

Code: e9e8 0141 ffeb 4e75 206f 0004 2068 01bc <2068> fff0 2008 4e75 598f 
2f0e 206f 000c 2068 01bc 4def 0008 42a6 4878 0004 4868
Fixing recursive fault but reboot is needed!

(loops until reset)

Same kernel version (Geert's m68k tree as of yesterday) with your 
earlier patch series applied runs OK. 

Cheers,

    Michael

> Convert atari_scsi to platform device and eliminate scsi_register().
>
> Validate __setup options later on so that module options are checked as well.
>
> Remove the comment about the scsi mid-layer disabling the host irq as it
> is no longer true (AFAICT). Also remove the obsolete slow interrupt stuff
> (IRQ_TYPE_SLOW == 0 anyway).
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>  arch/m68k/atari/config.c  |    5 
>  drivers/scsi/atari_scsi.c |  426 ++++++++++++++++++++++------------------------
>  drivers/scsi/atari_scsi.h |   17 -
>  3 files changed, 217 insertions(+), 231 deletions(-)
>
> Index: linux/arch/m68k/atari/config.c
> ===================================================================
> --- linux.orig/arch/m68k/atari/config.c	2014-10-02 16:55:28.000000000 +1000
> +++ linux/arch/m68k/atari/config.c	2014-10-02 16:56:21.000000000 +1000
> @@ -892,6 +892,11 @@ int __init atari_platform_init(void)
>  	}
>  #endif
>  
> +#ifdef CONFIG_ATARI_SCSI
> +	if (ATARIHW_PRESENT(ST_SCSI) || ATARIHW_PRESENT(TT_SCSI))
> +		platform_device_register_simple("atari_scsi", -1, NULL, 0);
> +#endif
> +
>  	return rv;
>  }
>  
> Index: linux/drivers/scsi/atari_scsi.c
> ===================================================================
> --- linux.orig/drivers/scsi/atari_scsi.c	2014-10-02 16:56:20.000000000 +1000
> +++ linux/drivers/scsi/atari_scsi.c	2014-10-02 16:56:21.000000000 +1000
> @@ -74,33 +74,26 @@
>  #define	MAX_TAGS 32
>  
>  #include <linux/types.h>
> -#include <linux/stddef.h>
> -#include <linux/ctype.h>
>  #include <linux/delay.h>
> -#include <linux/mm.h>
>  #include <linux/blkdev.h>
>  #include <linux/interrupt.h>
>  #include <linux/init.h>
>  #include <linux/nvram.h>
>  #include <linux/bitops.h>
>  #include <linux/wait.h>
> +#include <linux/platform_device.h>
>  
>  #include <asm/setup.h>
>  #include <asm/atarihw.h>
>  #include <asm/atariints.h>
> -#include <asm/page.h>
> -#include <asm/pgtable.h>
> -#include <asm/irq.h>
> -#include <asm/traps.h>
> -
> -#include <scsi/scsi_host.h>
> -#include "atari_scsi.h"
> -#include "NCR5380.h"
>  #include <asm/atari_stdma.h>
>  #include <asm/atari_stram.h>
>  #include <asm/io.h>
>  
> -#include <linux/stat.h>
> +#include <scsi/scsi_host.h>
> +
> +#include "atari_scsi.h"
> +#include "NCR5380.h"
>  
>  #define	IS_A_TT()	ATARIHW_PRESENT(TT_SCSI)
>  
> @@ -176,25 +169,9 @@ static inline void DISABLE_IRQ(void)
>  #define	AFTER_RESET_DELAY	(5*HZ/2)
>  #endif
>  
> -/***************************** Prototypes *****************************/
> -
>  #ifdef REAL_DMA
>  static void atari_scsi_fetch_restbytes(void);
>  #endif
> -static irqreturn_t scsi_tt_intr(int irq, void *dummy);
> -static irqreturn_t scsi_falcon_intr(int irq, void *dummy);
> -static void falcon_release_lock_if_possible(struct NCR5380_hostdata *hostdata);
> -static int falcon_get_lock(void);
> -#ifdef CONFIG_ATARI_SCSI_RESET_BOOT
> -static void atari_scsi_reset_boot(void);
> -#endif
> -static unsigned char atari_scsi_tt_reg_read(unsigned char reg);
> -static void atari_scsi_tt_reg_write(unsigned char reg, unsigned char value);
> -static unsigned char atari_scsi_falcon_reg_read(unsigned char reg);
> -static void atari_scsi_falcon_reg_write(unsigned char reg, unsigned char value);
> -
> -/************************* End of Prototypes **************************/
> -
>  
>  static struct Scsi_Host *atari_scsi_host;
>  static unsigned char (*atari_scsi_reg_read)(unsigned char reg);
> @@ -518,160 +495,12 @@ static int falcon_get_lock(void)
>  	}
>  }
>  
> -
> -static int __init atari_scsi_detect(struct scsi_host_template *host)
> -{
> -	static int called = 0;
> -	struct Scsi_Host *instance;
> -
> -	if (!MACH_IS_ATARI ||
> -	    (!ATARIHW_PRESENT(ST_SCSI) && !ATARIHW_PRESENT(TT_SCSI)) ||
> -	    called)
> -		return 0;
> -
> -	host->proc_name = "Atari";
> -
> -	atari_scsi_reg_read  = IS_A_TT() ? atari_scsi_tt_reg_read :
> -					   atari_scsi_falcon_reg_read;
> -	atari_scsi_reg_write = IS_A_TT() ? atari_scsi_tt_reg_write :
> -					   atari_scsi_falcon_reg_write;
> -
> -	/* setup variables */
> -	host->can_queue =
> -		(setup_can_queue > 0) ? setup_can_queue :
> -		IS_A_TT() ? ATARI_TT_CAN_QUEUE : ATARI_FALCON_CAN_QUEUE;
> -	host->cmd_per_lun =
> -		(setup_cmd_per_lun > 0) ? setup_cmd_per_lun :
> -		IS_A_TT() ? ATARI_TT_CMD_PER_LUN : ATARI_FALCON_CMD_PER_LUN;
> -	/* Force sg_tablesize to 0 on a Falcon! */
> -	host->sg_tablesize =
> -		!IS_A_TT() ? ATARI_FALCON_SG_TABLESIZE :
> -		(setup_sg_tablesize >= 0) ? setup_sg_tablesize : ATARI_TT_SG_TABLESIZE;
> -
> -	if (setup_hostid >= 0)
> -		host->this_id = setup_hostid;
> -	else {
> -		/* use 7 as default */
> -		host->this_id = 7;
> -		/* Test if a host id is set in the NVRam */
> -		if (ATARIHW_PRESENT(TT_CLK) && nvram_check_checksum()) {
> -			unsigned char b = nvram_read_byte( 14 );
> -			/* Arbitration enabled? (for TOS) If yes, use configured host ID */
> -			if (b & 0x80)
> -				host->this_id = b & 7;
> -		}
> -	}
> -
> -#ifdef SUPPORT_TAGS
> -	if (setup_use_tagged_queuing < 0)
> -		setup_use_tagged_queuing = 0;
> -#endif
> -#ifdef REAL_DMA
> -	/* If running on a Falcon and if there's TT-Ram (i.e., more than one
> -	 * memory block, since there's always ST-Ram in a Falcon), then allocate a
> -	 * STRAM_BUFFER_SIZE byte dribble buffer for transfers from/to alternative
> -	 * Ram.
> -	 */
> -	if (MACH_IS_ATARI && ATARIHW_PRESENT(ST_SCSI) &&
> -	    !ATARIHW_PRESENT(EXTD_DMA) && m68k_num_memory > 1) {
> -		atari_dma_buffer = atari_stram_alloc(STRAM_BUFFER_SIZE, "SCSI");
> -		if (!atari_dma_buffer) {
> -			printk(KERN_ERR "atari_scsi_detect: can't allocate ST-RAM "
> -					"double buffer\n");
> -			return 0;
> -		}
> -		atari_dma_phys_buffer = atari_stram_to_phys(atari_dma_buffer);
> -		atari_dma_orig_addr = 0;
> -	}
> -#endif
> -	instance = scsi_register(host, sizeof(struct NCR5380_hostdata));
> -	if (instance == NULL) {
> -		atari_stram_free(atari_dma_buffer);
> -		atari_dma_buffer = 0;
> -		return 0;
> -	}
> -	atari_scsi_host = instance;
> -	/*
> -	 * Set irq to 0, to avoid that the mid-level code disables our interrupt
> -	 * during queue_command calls. This is completely unnecessary, and even
> -	 * worse causes bad problems on the Falcon, where the int is shared with
> -	 * IDE and floppy!
> -	 */
> -       instance->irq = 0;
> -
> -#ifdef CONFIG_ATARI_SCSI_RESET_BOOT
> -	atari_scsi_reset_boot();
> -#endif
> -	NCR5380_init(instance, 0);
> -
> -	if (IS_A_TT()) {
> -
> -		/* This int is actually "pseudo-slow", i.e. it acts like a slow
> -		 * interrupt after having cleared the pending flag for the DMA
> -		 * interrupt. */
> -		if (request_irq(IRQ_TT_MFP_SCSI, scsi_tt_intr, IRQ_TYPE_SLOW,
> -				 "SCSI NCR5380", instance)) {
> -			printk(KERN_ERR "atari_scsi_detect: cannot allocate irq %d, aborting",IRQ_TT_MFP_SCSI);
> -			scsi_unregister(atari_scsi_host);
> -			atari_stram_free(atari_dma_buffer);
> -			atari_dma_buffer = 0;
> -			return 0;
> -		}
> -		tt_mfp.active_edge |= 0x80;		/* SCSI int on L->H */
> -#ifdef REAL_DMA
> -		tt_scsi_dma.dma_ctrl = 0;
> -		atari_dma_residual = 0;
> -
> -		if (MACH_IS_MEDUSA) {
> -			/* While the read overruns (described by Drew Eckhardt in
> -			 * NCR5380.c) never happened on TTs, they do in fact on the Medusa
> -			 * (This was the cause why SCSI didn't work right for so long
> -			 * there.) Since handling the overruns slows down a bit, I turned
> -			 * the #ifdef's into a runtime condition.
> -			 *
> -			 * In principle it should be sufficient to do max. 1 byte with
> -			 * PIO, but there is another problem on the Medusa with the DMA
> -			 * rest data register. So 'atari_read_overruns' is currently set
> -			 * to 4 to avoid having transfers that aren't a multiple of 4. If
> -			 * the rest data bug is fixed, this can be lowered to 1.
> -			 */
> -			atari_read_overruns = 4;
> -		}
> -#endif /*REAL_DMA*/
> -	} else { /* ! IS_A_TT */
> -
> -		/* Nothing to do for the interrupt: the ST-DMA is initialized
> -		 * already by atari_init_INTS()
> -		 */
> -
> -#ifdef REAL_DMA
> -		atari_dma_residual = 0;
> -		atari_dma_active = 0;
> -		atari_dma_stram_mask = (ATARIHW_PRESENT(EXTD_DMA) ? 0x00000000
> -					: 0xff000000);
> -#endif
> -	}
> -
> -	called = 1;
> -	return 1;
> -}
> -
> -static int atari_scsi_release(struct Scsi_Host *sh)
> -{
> -	if (IS_A_TT())
> -		free_irq(IRQ_TT_MFP_SCSI, sh);
> -	if (atari_dma_buffer)
> -		atari_stram_free(atari_dma_buffer);
> -	NCR5380_exit(sh);
> -	return 1;
> -}
> -
>  #ifndef MODULE
>  static int __init atari_scsi_setup(char *str)
>  {
>  	/* Format of atascsi parameter is:
>  	 *   atascsi=<can_queue>,<cmd_per_lun>,<sg_tablesize>,<hostid>,<use_tags>
> -	 * Defaults depend on TT or Falcon, hostid determined at run time.
> +	 * Defaults depend on TT or Falcon, determined at run time.
>  	 * Negative values mean don't change.
>  	 */
>  	int ints[6];
> @@ -682,36 +511,17 @@ static int __init atari_scsi_setup(char
>  		printk("atari_scsi_setup: no arguments!\n");
>  		return 0;
>  	}
> -
> -	if (ints[0] >= 1) {
> -		if (ints[1] > 0)
> -			/* no limits on this, just > 0 */
> -			setup_can_queue = ints[1];
> -	}
> -	if (ints[0] >= 2) {
> -		if (ints[2] > 0)
> -			setup_cmd_per_lun = ints[2];
> -	}
> -	if (ints[0] >= 3) {
> -		if (ints[3] >= 0) {
> -			setup_sg_tablesize = ints[3];
> -			/* Must be <= SG_ALL (255) */
> -			if (setup_sg_tablesize > SG_ALL)
> -				setup_sg_tablesize = SG_ALL;
> -		}
> -	}
> -	if (ints[0] >= 4) {
> -		/* Must be between 0 and 7 */
> -		if (ints[4] >= 0 && ints[4] <= 7)
> -			setup_hostid = ints[4];
> -		else if (ints[4] > 7)
> -			printk("atari_scsi_setup: invalid host ID %d !\n", ints[4]);
> -	}
> +	if (ints[0] >= 1)
> +		setup_can_queue = ints[1];
> +	if (ints[0] >= 2)
> +		setup_cmd_per_lun = ints[2];
> +	if (ints[0] >= 3)
> +		setup_sg_tablesize = ints[3];
> +	if (ints[0] >= 4)
> +		setup_hostid = ints[4];
>  #ifdef SUPPORT_TAGS
> -	if (ints[0] >= 5) {
> -		if (ints[5] >= 0)
> -			setup_use_tagged_queuing = !!ints[5];
> -	}
> +	if (ints[0] >= 5)
> +		setup_use_tagged_queuing = ints[5];
>  #endif
>  
>  	return 1;
> @@ -1020,23 +830,211 @@ static int atari_scsi_bus_reset(struct s
>  	return rv;
>  }
>  
> -static struct scsi_host_template driver_template = {
> +#define DRV_MODULE_NAME         "atari_scsi"
> +#define PFX                     DRV_MODULE_NAME ": "
> +
> +static struct scsi_host_template atari_scsi_template = {
> +	.module			= THIS_MODULE,
> +	.proc_name		= DRV_MODULE_NAME,
>  	.show_info		= atari_scsi_show_info,
>  	.name			= "Atari native SCSI",
> -	.detect			= atari_scsi_detect,
> -	.release		= atari_scsi_release,
>  	.info			= atari_scsi_info,
>  	.queuecommand		= atari_scsi_queue_command,
>  	.eh_abort_handler	= atari_scsi_abort,
>  	.eh_bus_reset_handler	= atari_scsi_bus_reset,
> -	.can_queue		= 0, /* initialized at run-time */
> -	.this_id		= 0, /* initialized at run-time */
> -	.sg_tablesize		= 0, /* initialized at run-time */
> -	.cmd_per_lun		= 0, /* initialized at run-time */
> +	.this_id		= 7,
>  	.use_clustering		= DISABLE_CLUSTERING
>  };
>  
> +static int __init atari_scsi_probe(struct platform_device *pdev)
> +{
> +	struct Scsi_Host *instance;
> +	int error;
> +
> +	if (!MACH_IS_ATARI)
> +		return -ENODEV;
> +
> +	if (ATARIHW_PRESENT(TT_SCSI)) {
> +		atari_scsi_reg_read  = atari_scsi_tt_reg_read;
> +		atari_scsi_reg_write = atari_scsi_tt_reg_write;
> +	} else if (ATARIHW_PRESENT(ST_SCSI)) {
> +		atari_scsi_reg_read  = atari_scsi_falcon_reg_read;
> +		atari_scsi_reg_write = atari_scsi_falcon_reg_write;
> +	} else
> +		return -ENODEV;
> +
> +	/* The values for CMD_PER_LUN and CAN_QUEUE are somehow arbitrary.
> +	 * Higher values should work, too; try it!
> +	 * (But cmd_per_lun costs memory!)
> +	 *
> +	 * But there seems to be a bug somewhere that requires CAN_QUEUE to be
> +	 * 2*CMD_PER_LUN. At least on a TT, no spurious timeouts seen since
> +	 * changed CMD_PER_LUN...
> +	 *
> +	 * Note: The Falcon currently uses 8/1 setting due to unsolved problems
> +	 * with cmd_per_lun != 1
> +	 */
> +	if (IS_A_TT()) {
> +		atari_scsi_template.can_queue    = 16;
> +		atari_scsi_template.cmd_per_lun  = 8;
> +		atari_scsi_template.sg_tablesize = SG_ALL;
> +	} else {
> +		atari_scsi_template.can_queue    = 8;
> +		atari_scsi_template.cmd_per_lun  = 1;
> +		atari_scsi_template.sg_tablesize = SG_NONE;
> +	}
> +
> +	if (setup_can_queue > 0)
> +		atari_scsi_template.can_queue = setup_can_queue;
> +
> +	if (setup_cmd_per_lun > 0)
> +		atari_scsi_template.cmd_per_lun = setup_cmd_per_lun;
> +
> +	/* Leave sg_tablesize at 0 on a Falcon! */
> +	if (IS_A_TT() && setup_sg_tablesize >= 0)
> +		atari_scsi_template.sg_tablesize = setup_sg_tablesize;
> +
> +	if (setup_hostid >= 0) {
> +		atari_scsi_template.this_id = setup_hostid & 7;
> +	} else {
> +		/* Test if a host id is set in the NVRam */
> +		if (ATARIHW_PRESENT(TT_CLK) && nvram_check_checksum()) {
> +			unsigned char b = nvram_read_byte(14);
> +
> +			/* Arbitration enabled? (for TOS)
> +			 * If yes, use configured host ID
> +			 */
> +			if (b & 0x80)
> +				atari_scsi_template.this_id = b & 7;
> +		}
> +	}
> +
> +#ifdef SUPPORT_TAGS
> +	if (setup_use_tagged_queuing < 0)
> +		setup_use_tagged_queuing = 0;
> +#endif
> +
> +#ifdef REAL_DMA
> +	/* If running on a Falcon and if there's TT-Ram (i.e., more than one
> +	 * memory block, since there's always ST-Ram in a Falcon), then
> +	 * allocate a STRAM_BUFFER_SIZE byte dribble buffer for transfers
> +	 * from/to alternative Ram.
> +	 */
> +	if (ATARIHW_PRESENT(ST_SCSI) && !ATARIHW_PRESENT(EXTD_DMA) &&
> +	    m68k_num_memory > 1) {
> +		atari_dma_buffer = atari_stram_alloc(STRAM_BUFFER_SIZE, "SCSI");
> +		if (!atari_dma_buffer) {
> +			pr_err(PFX "can't allocate ST-RAM double buffer\n");
> +			return -ENOMEM;
> +		}
> +		atari_dma_phys_buffer = atari_stram_to_phys(atari_dma_buffer);
> +		atari_dma_orig_addr = 0;
> +	}
> +#endif
> +
> +	instance = scsi_host_alloc(&atari_scsi_template,
> +	                           sizeof(struct NCR5380_hostdata));
> +	if (!instance) {
> +		error = -ENOMEM;
> +		goto fail_alloc;
> +	}
> +	atari_scsi_host = instance;
> +
> +#ifdef CONFIG_ATARI_SCSI_RESET_BOOT
> +	atari_scsi_reset_boot();
> +#endif
> +
> +	if (IS_A_TT())
> +		instance->irq = IRQ_TT_MFP_SCSI;
> +	else
> +		instance->irq = IRQ_NONE;
> +
> +	NCR5380_init(instance, 0);
> +
> +	if (IS_A_TT()) {
> +		error = request_irq(instance->irq, scsi_tt_intr, 0,
> +		                    "NCR5380", instance);
> +		if (error) {
> +			pr_err(PFX "request irq %d failed, aborting\n",
> +			       instance->irq);
> +			goto fail_irq;
> +		}
> +		tt_mfp.active_edge |= 0x80;	/* SCSI int on L->H */
> +#ifdef REAL_DMA
> +		tt_scsi_dma.dma_ctrl = 0;
> +		atari_dma_residual = 0;
> +
> +		/* While the read overruns (described by Drew Eckhardt in
> +		 * NCR5380.c) never happened on TTs, they do in fact on the
> +		 * Medusa (This was the cause why SCSI didn't work right for
> +		 * so long there.) Since handling the overruns slows down
> +		 * a bit, I turned the #ifdef's into a runtime condition.
> +		 *
> +		 * In principle it should be sufficient to do max. 1 byte with
> +		 * PIO, but there is another problem on the Medusa with the DMA
> +		 * rest data register. So 'atari_read_overruns' is currently set
> +		 * to 4 to avoid having transfers that aren't a multiple of 4.
> +		 * If the rest data bug is fixed, this can be lowered to 1.
> +		 */
> +		if (MACH_IS_MEDUSA)
> +			atari_read_overruns = 4;
> +#endif
> +	} else {
> +		/* Nothing to do for the interrupt: the ST-DMA is initialized
> +		 * already.
> +		 */
> +#ifdef REAL_DMA
> +		atari_dma_residual = 0;
> +		atari_dma_active = 0;
> +		atari_dma_stram_mask = (ATARIHW_PRESENT(EXTD_DMA) ? 0x00000000
> +					: 0xff000000);
> +#endif
> +	}
> +
> +	error = scsi_add_host(instance, NULL);
> +	if (error)
> +		goto fail_host;
> +
> +	platform_set_drvdata(pdev, instance);
> +
> +	scsi_scan_host(instance);
> +	return 0;
> +
> +fail_host:
> +	if (instance->irq != IRQ_NONE)
> +		free_irq(instance->irq, instance);
> +fail_irq:
> +	NCR5380_exit(instance);
> +	scsi_host_put(instance);
> +fail_alloc:
> +	if (atari_dma_buffer)
> +		atari_stram_free(atari_dma_buffer);
> +	return error;
> +}
> +
> +static int __exit atari_scsi_remove(struct platform_device *pdev)
> +{
> +	struct Scsi_Host *instance = platform_get_drvdata(pdev);
> +
> +	scsi_remove_host(instance);
> +	if (instance->irq != IRQ_NONE)
> +		free_irq(instance->irq, instance);
> +	NCR5380_exit(instance);
> +	scsi_host_put(instance);
> +	if (atari_dma_buffer)
> +		atari_stram_free(atari_dma_buffer);
> +	return 0;
> +}
> +
> +static struct platform_driver atari_scsi_driver = {
> +	.remove = __exit_p(atari_scsi_remove),
> +	.driver = {
> +		.name	= DRV_MODULE_NAME,
> +		.owner	= THIS_MODULE,
> +	},
> +};
>  
> -#include "scsi_module.c"
> +module_platform_driver_probe(atari_scsi_driver, atari_scsi_probe);
>  
> +MODULE_ALIAS("platform:" DRV_MODULE_NAME);
>  MODULE_LICENSE("GPL");
> Index: linux/drivers/scsi/atari_scsi.h
> ===================================================================
> --- linux.orig/drivers/scsi/atari_scsi.h	2014-10-02 16:56:10.000000000 +1000
> +++ linux/drivers/scsi/atari_scsi.h	2014-10-02 16:56:21.000000000 +1000
> @@ -18,23 +18,6 @@
>  /* (I_HAVE_OVERRUNS stuff removed) */
>  
>  #ifndef ASM
> -/* The values for CMD_PER_LUN and CAN_QUEUE are somehow arbitrary. Higher
> - * values should work, too; try it! (but cmd_per_lun costs memory!) */
> -
> -/* But there seems to be a bug somewhere that requires CAN_QUEUE to be
> - * 2*CMD_PER_LUN. At least on a TT, no spurious timeouts seen since
> - * changed CMD_PER_LUN... */
> -
> -/* Note: The Falcon currently uses 8/1 setting due to unsolved problems with
> - * cmd_per_lun != 1 */
> -
> -#define ATARI_TT_CAN_QUEUE		16
> -#define ATARI_TT_CMD_PER_LUN		8
> -#define ATARI_TT_SG_TABLESIZE		SG_ALL
> -
> -#define ATARI_FALCON_CAN_QUEUE		8
> -#define ATARI_FALCON_CMD_PER_LUN	1
> -#define ATARI_FALCON_SG_TABLESIZE	SG_NONE
>  
>  #define	NCR5380_implementation_fields	/* none */
>  
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
