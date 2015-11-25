From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380 drivers
Date: Thu, 26 Nov 2015 00:01:20 +0100
Message-ID: <201511260001.21123.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <alpine.LNX.2.00.1511251246130.24439@nippy.intranet> <201511251004.10449.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <201511251004.10449.linux@rainbow-software.org>
Content-Disposition: inline
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 25 November 2015 10:04:10 Ondrej Zary wrote:
> I think that PDMA should work with 53C400A too but seems that the driver was
> never able to do it.
> 
> Although there is code for port-mapped transfer in NCR5380_pread(),
> NCR53C400_register_offset is defined to 0 in the port-mapped case. The C400_
> register offsets are thus defined with negative offset:
> 
> #define C400_CONTROL_STATUS_REG NCR53C400_register_offset-8
> #define C400_BLOCK_COUNTER_REG   NCR53C400_register_offset-7
> #define C400_RESUME_TRANSFER_REG NCR53C400_register_offset-6
> #define C400_HOST_BUFFER         NCR53C400_register_offset-4
> 
> This is probably OK for a port-mapped 53C400 (such card must have some glue
> decoding logic as the 53C400 chip itself can do memory-mapping only) because:
> 
>                 /*
>                  * On NCR53C400 boards, NCR5380 registers are mapped 8 past
>                  * the base address.
>                  */
>                 if (overrides[current_override].board == BOARD_NCR53C400)
>                         instance->io_port += 8;
> 
> This means that on a 53C400, first 5380 register will be at base+8 and first
> C400_ register at base.
> 
> But on a 53C400A, the 5380 registers are mapped on the base address so the
> C400_ registers would be below the base, which is obviously wrong. I hope that
> PDMA will work if I fix the C400_ registers mapping.

A quick hack (breaks other chips, needs more work for proper mapping on all
chips):

--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -163,7 +163,7 @@
 /* Write any value to this register to start an ini mode DMA receive */
 #define START_DMA_INITIATOR_RECEIVE_REG 7      /* wo */

-#define C400_CONTROL_STATUS_REG NCR53C400_register_offset-8    /* rw */
+#define C400_CONTROL_STATUS_REG 9      /* rw */

 #define CSR_RESET              0x80    /* wo  Resets 53c400 */
 #define CSR_53C80_REG          0x80    /* ro  5380 registers busy */
@@ -182,13 +182,13 @@
 #endif

 /* Number of 128-byte blocks to be transferred */
-#define C400_BLOCK_COUNTER_REG   NCR53C400_register_offset-7   /* rw */
+#define C400_BLOCK_COUNTER_REG   10    /* rw */

 /* Resume transfer after disconnect */
-#define C400_RESUME_TRANSFER_REG NCR53C400_register_offset-6   /* wo */
+#define C400_RESUME_TRANSFER_REG 11    /* wo */

 /* Access to host buffer stack */
-#define C400_HOST_BUFFER         NCR53C400_register_offset-4   /* rw */
+#define C400_HOST_BUFFER         8     /* rw */


 /* Note : PHASE_* macros are based on the values of the STATUS register */
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -323,7 +323,10 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 #endif
                        break;
                case BOARD_NCR53C400A:
+                       flags = FLAG_NO_DMA_FIXUP;
+#ifndef PSEUDO_DMA
                        flags = FLAG_NO_PSEUDO_DMA;
+#endif
                        ports = ncr_53c400a_ports;
                        break;
                case BOARD_DTC3181E:
@@ -414,7 +417,8 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
                if (NCR5380_init(instance, flags))
                        goto out_unregister;

-               if (overrides[current_override].board == BOARD_NCR53C400)
+               if (overrides[current_override].board == BOARD_NCR53C400 ||
+                   overrides[current_override].board == BOARD_NCR53C400A)
                        NCR5380_write(C400_CONTROL_STATUS_REG, CSR_BASE);

                NCR5380_maybe_reset_bus(instance);


And PDMA works on I/O mapped 53C400A (HP C2502)!

# modprobe g_NCR5380 ncr_irq=7 ncr_addr=0x280 ncr_53c400a=1
[ 1799.939856] scsi host4: Generic NCR5380/NCR53C400 SCSI, io_port 0x280, n_io_port 16, base 0x0, irq 0, can_queue 16, cmd_per_lun 2, sg_tablesize 128, this_id 7, flags { NO_DMA_FIXUP }, options { AUTOPROBE_IRQ PSEUDO_DMA }
[ 1816.277018] scsi 4:0:1:0: Direct-Access     QUANTUM  LP240S GM240S01X 4.6  PQ: 0 ANSI: 2 CCS
[ 1897.899648] sd 4:0:1:0: Attached scsi generic sg1 type 0
[ 1897.917842] sd 4:0:1:0: [sdb] 479350 512-byte logical blocks: (245 MB/234 MiB)
[ 1897.920872] sd 4:0:1:0: [sdb] Write Protect is off
[ 1897.924744] sd 4:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[ 1897.967857]  sdb: sdb1
[ 1897.993822] sd 4:0:1:0: [sdb] Attached SCSI disk


Nice performance improvement (although it's slower than the memory-mapped
53C400):
# hdparm -t --direct /dev/sdb

/dev/sdb:
 Timing O_DIRECT disk reads:   2 MB in  3.99 seconds = 513.57 kB/sec


And it even fixed the IRQ:
# head /proc/interrupts
           CPU0
  0:     151228    XT-PIC  timer
  1:          9    XT-PIC  i8042
  2:          0    XT-PIC  cascade
  7:        115    XT-PIC  NCR5380
  8:          1    XT-PIC  rtc0
  9:          0    XT-PIC  uhci_hcd:usb1, uhci_hcd:usb2
 10:       3256    XT-PIC  eth0
 12:        136    XT-PIC  i8042
 14:       3833    XT-PIC  pata_via


-- 
Ondrej Zary
