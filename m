From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Slow boot in QEMU with virtio-scsi disks
Date: Sat, 11 Aug 2018 11:47:46 +0200
Message-ID: <f40092b20856d07bd7f870abf5ea939e@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Omar Sandoval <osandov@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kurz <groug@kaod.org>, qemu-discuss@nongnu.org, qemu-devel@nongnu.org
List-Id: linux-scsi@vger.kernel.org

Hi.

I'd like to resurrect previous discussion [1] regarding slow kernel boot 
inside QEMU with virtio-scsi disks attached and blk_mq enabled.

Symptom:

[    2.830857] ata1: SATA max UDMA/133 abar m4096@0x98002000 port 
0x98002100 irq 36
[    2.834559] ata2: SATA max UDMA/133 abar m4096@0x98002000 port 
0x98002180 irq 36
[    2.837746] ata3: SATA max UDMA/133 abar m4096@0x98002000 port 
0x98002200 irq 36
[    2.841861] ata4: SATA max UDMA/133 abar m4096@0x98002000 port 
0x98002280 irq 36
[    2.847899] ata5: SATA max UDMA/133 abar m4096@0x98002000 port 
0x98002300 irq 36
[    2.853229] ata6: SATA max UDMA/133 abar m4096@0x98002000 port 
0x98002380 irq 36
[    3.172159] ata1: SATA link down (SStatus 0 SControl 300)
[    3.183552] ata5: SATA link down (SStatus 0 SControl 300)
[    3.189925] ata3: SATA link down (SStatus 0 SControl 300)
[    3.196156] ata6: SATA link down (SStatus 0 SControl 300)
[    3.201136] ata2: SATA link down (SStatus 0 SControl 300)
[    3.208559] ata4: SATA link down (SStatus 0 SControl 300)
[   16.480972] sd 0:0:1:0: Power-on or device reset occurred
[   16.481591] sd 0:0:0:0: [sda] 16777216 512-byte logical blocks: (8.59 
GB/8.00 GiB)
[   16.481671] sd 0:0:0:0: [sda] Write Protect is off
[   16.481815] sd 0:0:0:0: [sda] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
[   16.491325]  sda: sda1 sda2
[   16.517532] sd 0:0:1:0: [sdb] 16777216 512-byte logical blocks: (8.59 
GB/8.00 GiB)
[   16.525131] sr 0:0:2:0: Power-on or device reset occurred
[   16.525974] sd 0:0:1:0: [sdb] Write Protect is off
[   16.530946] sr 0:0:2:0: [sr0] scsi3-mmc drive: 16x/50x cd/rw xa/form2 
cdda tray
[   16.543592] cdrom: Uniform CD-ROM driver Revision: 3.20
[   16.549815] sd 0:0:1:0: [sdb] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
[   16.549833] sd 0:0:0:0: [sda] Attached SCSI disk
[   16.572055]  sdb: sdb1 sdb2
[   16.580463] sd 0:0:1:0: [sdb] Attached SCSI disk

(note the hang that lasts for 13 seconds)

The disks are attached to the VM in the following manner:

-device virtio-scsi,id=scsi -device scsi-hd,drive=hd1 -drive 
if=none,media=disk,id=hd1,file=sda.img,format=raw

What I've tested so far:

* 4.14.62  + virtio-scsi +    blk_mq == slow boot
* 4.14.62  + virtio-scsi + no blk_mq == fast boot
* 4.17.13  + virtio-scsi +    blk_mq == slow boot
* 4.18-rc8 + virtio-scsi +    blk_mq == slow boot

QEMU is of v2.12.1, runs with "-machine q35,accel=kvm -cpu host". Also, 
if virtio-scsi disks are replaced with SATA disks, the hang does not 
occur (although, QEMU has other issues with SATA, but that's another 
story [3]).

Apparently, the commit that was mentioned in [2], 
b5b6e8c8d3b4cbeb447a0f10c7d5de3caa573299, forces blk_mq for virtio_scsi, 
so it cannot be disabled for new kernels.

Any hint on how to avoid this hang while still having virtio-scsi disks 
and blk_mq enabled please?

Thanks.

-- 
   Oleksandr Natalenko (post-factum)

[1] 
https://lists.gnu.org/archive/html/qemu-discuss/2018-07/msg00022.html
[2] 
https://lists.gnu.org/archive/html/qemu-discuss/2018-07/msg00037.html
[3] 
https://lists.nongnu.org/archive/html/qemu-devel/2018-05/msg06942.html
