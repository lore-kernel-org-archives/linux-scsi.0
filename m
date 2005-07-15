From: Daniel Drake <dsd@gentoo.org>
Subject: scsi/libata bootup sysfs oops with 2.6.12 + 2.6.13-rc3
Date: Fri, 15 Jul 2005 19:33:45 +0100
Message-ID: <42D80189.5080805@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc: edinatux@gmail.com, greg@kroah.com
List-Id: linux-scsi@vger.kernel.org

Hi,

After upgrading kernel, Edward (on CC) is having trouble booting up.

The kernel hangs after reporting it can't mount root on /dev/sda3, which is 
supposed to be a partition on a SATA disk, connected to a sata_nv controller.

As serial console is not available, we stripped down the kernel in hope that 
the SATA disk detection would appear on the same screen so that it could be 
caught on camera :)

After removing the more verbose parts of the kernel (USB, ACPI, etc) in 
attempt to get disk detection messages on the same screen, we ran into another 
issue. The kernel oops's on boot up, and tries to kill init. So its not even 
getting as far this time (last time, it got all the way to trying to mount root).

This problem did not exist in 2.6.10 which can still be booted right now. It 
is reprocable on both 2.6.12 and 2.6.13-rc3.

Under 2.6.10, these messages appear during disk detection:

ata1: SATA max UDMA/133 cmd 0x9F0 ctl 0xBF2 bmdma 0xF200 irq 23
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xB72 bmdma 0xF208 irq 23
ata1: dev 0 cfg 49:2f00 82:7c6b 83:7b09 84:4003 85:7c69 86:3a01 87:4003 88:407f
ata1: dev 0 ATA, max UDMA/133, 240121728 sectors:
nv_sata: Primary device added
nv_sata: Primary device removed
nv_sata: Secondary device removed
ata1: dev 0 configured for UDMA/133
scsi0 : sata_nv
ata2: no device found (phy stat 00000000)
scsi1 : sata_nv
   Vendor: ATA       Model: Maxtor 6Y120M0    Rev: YAR5
   Type:   Direct-Access                      ANSI SCSI revision: 05
st: Version 20041025, fixed bufsize 32768, s/g segs 256
SCSI device sda: 240121728 512-byte hdwr sectors (122942 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 240121728 512-byte hdwr sectors (122942 MB)
SCSI device sda: drive cache: write back
  /dev/scsi/host0/bus0/target0/lun0: p1 p2 p3
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0,  type 0


Under a minimal 2.6.13-rc3, this happens instead:

ata1: SATA max UDMA/133 cmd 0x9F0 ctl 0xBF2 bmdma 0xF200 irq 0
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xB72 bmdma 0xF208 irq 0
Unable to handle kernel NULL pointer dereference at <...> RIP: 
sysfs_hash_and_remove+16

PGD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in:
Pid 1, comm: swapper Not tainted 2.6.13-rc3
RIP: sysfs_hash_and_remove+16

Call trace:
class_device_del   class_device_unregister
scsi_remove_host   setup_irq
request_irq   ata_host_remove
ata_device_add   pci_conf1_write
pcibios_set_master   nv_init_one
pci_device_probe   driver_probe_device
__driver_attach   __driver_attach
__driver_attach   bus_for_each_dev
bus_add_driver   pci_register_driver
init   child_rip
init   child_rip

I can provide a full jpeg if required.


It looks like dir->d_inode is null, although I don't have much idea where the 
real bug exists.

(gdb) list *sysfs_hash_and_remove+16
0x5b0 is in sysfs_hash_and_remove (semaphore.h:107).
102      * This is ugly, but we want the default case to fall through.
103      * "__down_failed" is a special asm handler that calls the C
104      * routine that actually waits. See arch/x86_64/kernel/semaphore.c
105      */
106     static inline void down(struct semaphore * sem)
107     {
108             might_sleep();
109
110             __asm__ __volatile__(
111                     "# atomic down operation\n\t"


Any ideas or suggestions?

Thanks,
Daniel
