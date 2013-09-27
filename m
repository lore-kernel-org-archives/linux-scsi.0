From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 07/10] hpsa: hide logical drives with format in progress from linux
Date: Fri, 27 Sep 2013 14:11:05 -0500
Message-ID: <20130927191105.GF31476@beardog.cce.hp.com>
References: <20130923183128.19995.7669.stgit@beardog.cce.hp.com> <20130923183401.19995.99662.stgit@beardog.cce.hp.com> <5245868B.4080900@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:12755 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab3I0TLH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Sep 2013 15:11:07 -0400
Content-Disposition: inline
In-Reply-To: <5245868B.4080900@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: james.bottomley@hansenpartnership.com, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com, scameron@beardog.cce.hp.com

On Fri, Sep 27, 2013 at 03:22:19PM +0200, Tomas Henzl wrote:
> On 09/23/2013 08:34 PM, Stephen M. Cameron wrote:
> > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> >
> > SCSI mid layer doesn't seem to handle logical drives undergoing format
> > very well.  scsi_add_device on such devices seems to result in hitting
> > those devices with a TUR at a rate of 3Hz for awhile, transitioning
> > to hitting them with a READ(10) at a much higher rate indefinitely,
> > and at boot time, this prevents the system from coming up.  If we
> > do not expose such devices to the kernel, it isn't bothered by them.
> 
> Is the result of this patch that the drive is no more visible for the user
> and he can't follow the formatting progress? 
> I think a better option is to fix the kernel to handle formatting devices better
> or harden the hpsa so it can cope with TURs or reads (ignore) from a formatting device.

So here is the behavior I see with linux-3.12-rc2 when create a logical
drive with rapid parity initialization enabled and then reboot
before the drive finishes.  Note that scsi 0:0:0:1 is
the device that's in this state.  Interspersed are some notes from
me, prefixed "smc> "

Summary: First you see sd (I think) printing dots very slowly.
Then you see udev get angry.  Then a couple stack traces one
from modprobe and one from dmraid, and the system doesn't
boot up.  20-something minutes have elapsed at this point. It
may eventually boot when the RPI finally finishes, but at this
point, I don't care, because 20 minutes is too long to be holding
things up.


HP HPSA Driver (v 3.4.0-1)                                                      
hpsa 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control             
hpsa 0000:02:00.0: MSIX                                                         
hpsa 0000:02:00.0: hpsa0: <0x323b> at IRQ 64 using DAC                          
scsi0 : hpsa                                                                    
hpsa 0000:02:00.0: RAID              device c0b3t0l0 added.                     
hpsa 0000:02:00.0: Direct-Access     device c0b0t0l0 added.                     
hpsa 0000:02:00.0: Direct-Access     device c0b0t0l1 added.                     
hpsa 0000:02:00.0: Direct-Access     device c0b0t0l2 added.                     
usb 1-1.3: new low-speed USB device number 3 using ehci-pci                     
scsi 0:3:0:0: RAID              HP       P420i            5.19 PQ: 0 ANSI: 5    
scsi 0:0:0:0: Direct-Access     HP       LOGICAL VOLUME   5.19 PQ: 0 ANSI: 5    
scsi 0:0:0:1: Direct-Access     HP       LOGICAL VOLUME   5.19 PQ: 0 ANSI: 5    
scsi 0:0:0:2: Direct-Access     HP       LOGICAL VOLUME   5.19 PQ: 0 ANSI: 5    
ata_piix 0000:00:1f.2: MAP [                                                    
 P0 P2 P1 P3 ]                                                                  
usb 1-1.3: New USB device found, idVendor=0624, idProduct=0341                  
usb 1-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0             
usb 1-1.3: Product: HP 336047-B21                                               
usb 1-1.3: Manufacturer: Avocent                                                
input: Avocent HP 336047-B21 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.31
hid-generic 0003:0624:0341.0001: input,hidraw0: USB HID v1.10 Keyboard [Avocent0
scsi1 : ata_piix                                                                
scsi2 : ata_piix                                                                
ata1: SATA max UDMA/133 cmd 0x4000 ctl 0x4008 bmdma 0x4020 irq 17               
ata2: SATA max UDMA/133 cmd 0x4010 ctl 0x4018 bmdma 0x4028 irq 17               
input: Avocent HP 336047-B21 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.32
hid-generic 0003:0624:0341.0002: input,hidraw1: USB HID v1.10 Mouse [Avocent HP1
sd 0:0:0:0: [sda] 2344160432 512-byte logical blocks: (1.20 TB/1.09 TiB)        
sd 0:0:0:1: [sdb] Spinning up disk...                                           
usb 2-1.3: new high-speed USB device number 3 using ehci-pci                    
sd 0:0:0:2: [sdc] 390651840 512-byte logical blocks: (200 GB/186 GiB)           
sd 0:0:0:0: [sda] Write Protect is off                                          
sd 0:0:0:2: [sdc] Write Protect is off                                          
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DA
sd 0:0:0:2: [sdc] Write cache: disabled, read cache: enabled, doesn't support DA
 sdc: unknown partition table                                                   
sd 0:0:0:2: [sdc] Attached SCSI disk                                            
 sda: sda1 sda2 sda3                                                            
sd 0:0:0:0: [sda] Attached SCSI disk                                            
usb 2-1.3: New USB device found, idVendor=0424, idProduct=2660                  
usb 2-1.3: New USB device strings: Mfr=0, Product=0, SerialNumber=0             
hub 2-1.3:1.0: USB hub found                                                    
hub 2-1.3:1.0: 2 ports detected                                                 
Switched to clocksource tsc                                                     
.ata2.01: failed to resume link (SControl 0)                                    
ata2.00: SATA link down (SStatus 0 SControl 300)                                
ata2.01: SATA link down (SStatus 4 SControl 0)                                  
ata1.01: failed to resume link (SControl 0)                                     
ata1.00: SATA link down (SStatus 0 SControl 300)                                
ata1.01: SATA link down (SStatus 4 SControl 0)                                  
................................................................................
sd 0:0:0:1: [sdb] 1757614684 512-byte logical blocks: (899 GB/838 GiB)          
sd 0:0:0:1: [sdb] 4096-byte physical blocks                                     
sd 0:0:0:1: [sdb] Write Protect is off                                          
sd 0:0:0:1: [sdb] Write cache: disabled, read cache: enabled, doesn't support DA
sd 0:0:0:1: [sdb] Spinning up disk...                                           
............................................................................... 


smc> there is a loooooong pause while it prints those dots above.
smc> below, udev starts getting angry...

 
udevadm settle - timeout of 180 seconds reached, the event queue contains:      
  /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:35/PNP0A06:00/PNP0501:00)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:3:0/0:3:0:0 ()
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:3:0/0:3:0:0/s)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:3:0/0:3:0:0/b)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:0 ()
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:0/s)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:0/b)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:1 ()
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:1/s)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:1/b)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:2 ()
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:2/s)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:2/b)
  /sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input1 (2)
  /sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input1/ev)
  /sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.1/input/input2 (2)
  /sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.1/input/input2/mo)
  /sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.1/input/input2/ev)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:0/s)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:1/s)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:2/s)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:2/b)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:0/b)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:0/b)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:0/b)
  /sys/devices/pci0000:00/0000:00:02.2/0000:02:00.0/host0/target0:0:0/0:0:0:0/b)
udevd[130]: worker [175] unexpectedly returned with status 0x0100               
                                                                                
udevd[130]: worker [175] failed while handling '/devices/pci0000:00/0000:00:02.'
                                                                                
udevd[130]: worker [176] unexpectedly returned with status 0x0100               
                                                                                
udevd[130]: worker [176] failed while handling '/devices/pci0000:00/0000:00:02.'
                                                                                
udevd[130]: worker [178] unexpectedly returned with status 0x0100               
                                                                                
udevd[130]: worker [178] failed while handling '/devices/pci0000:00/0000:00:02.'
                                                                                
udevd[130]: worker [179] unexpectedly returned with status 0x0100               
                                                                                
udevd[130]: worker [179] failed while handling '/devices/pci0000:00/0000:00:02.'
                                                                                
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)         
dracut: Mounted root filesystem /dev/sda2                                       
.SELinux:  Disabled at runtime.                                                 
type=1404 audit(1380289585.871:2): selinux=0 auid=4294967295 ses=4294967295     
dracut:                                                                         
dracut: Switching root                                                          
                Welcome to Red Hatreadahead: starting                           
 Enterprise Linux Server                                                        
.Starting udev: udev: starting version 147                                      
WARNING! power/level is deprecated; use power/control instead                   
.G.pps_core: LinuxPPS API ver. 1 registered                                     
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@>
PTP clock support registered                                                    
tg3.c:v3.133 (Jul 29, 2013)                                                     
tg3 0000:03:00.0 eth0: Tigon3 [partno(629133-001) rev 5719001] (PCI Express) MA0
tg3 0000:03:00.0 eth0: attached PHY is 5719C (10/100/1000Base-T Ethernet) (Wire)
tg3 0000:03:00.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[1]       
tg3 0000:03:00.0 eth0: dma_rwctrl[00000001] dma_mask[64-bit]                    
tg3 0000:03:00.1 eth1: Tigon3 [partno(629133-001) rev 5719001] (PCI Express) MA1
tg3 0000:03:00.1 eth1: attached PHY is 5719C (10/100/1000Base-T Ethernet) (Wire)
tg3 0000:03:00.1 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[1]       
tg3 0000:03:00.1 eth1: dma_rwctrl[00000001] dma_mask[64-bit]                    
tg3 0000:03:00.2 eth2: Tigon3 [partno(629133-001) rev 5719001] (PCI Express) MA2
tg3 0000:03:00.2 eth2: attached PHY is 5719C (10/100/1000Base-T Ethernet) (Wire)
tg3 0000:03:00.2 eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[1]       
tg3 0000:03:00.2 eth2: dma_rwctrl[00000001] dma_mask[64-bit]                    
tg3 0000:03:00.3 eth3: Tigon3 [partno(629133-001) rev 5719001] (PCI Express) MA3
tg3 0000:03:00.3 eth3: attached PHY is 5719C (10/100/1000Base-T Ethernet) (Wire)
tg3 0000:03:00.3 eth3: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[1]       
tg3 0000:03:00.3 eth3: dma_rwctrl[00000001] dma_mask[64-bit]                    
dca service started, version 1.12.1                                             
ioatdma: Intel(R) QuickData Technology Driver 4.00                              
ioatdma 0000:00:04.0: can't derive routing for PCI INT A                        
ioatdma 0000:00:04.0: PCI INT A: no GSI - using ISA IRQ 5                       
ioatdma 0000:00:04.1: can't derive routing for PCI INT B                        
ioatdma 0000:00:04.1: PCI INT B: no GSI - using ISA IRQ 7                       
ioatdma 0000:00:04.2: can't derive routing for PCI INT C                        
ioatdma 0000:00:04.2: PCI INT C: no GSI - using ISA IRQ 10                      
ioatdma 0000:00:04.3: can't derive routing for PCI INT D                        
ioatdma 0000:00:04.3: PCI INT D: no GSI - using ISA IRQ 10                      
ioatdma 0000:00:04.4: can't derive routing for PCI INT A                        
ioatdma 0000:00:04.4: PCI INT A: no GSI - using ISA IRQ 5                       
ioatdma 0000:00:04.5: can't derive routing for PCI INT B                        
ioatdma 0000:00:04.5: PCI INT B: no GSI - using ISA IRQ 7                       
ioatdma 0000:00:04.6: can't derive routing for PCI INT C                        
ioatdma 0000:00:04.6: PCI INT C: no GSI - using ISA IRQ 10                      
ioatdma 0000:00:04.7: can't derive routing for PCI INT D                        
ioatdma 0000:00:04.7: PCI INT D: no GSI - using ISA IRQ 10                      
.hpwdt 0000:01:00.0: HP Watchdog Timer Driver: NMI decoding initialized, allow )
hpwdt 0000:01:00.0: HP Watchdog Timer Driver: 1.3.2, timer margin: 30 seconds (.
                                                                                
ACPI Warning: 0x0000000000000928-0x000000000000092f SystemIO conflicts with Reg)
ACPI: If an ACPI driver is available for this device, you should use it insteadr
lpc_ich: Resource conflict(s) found affecting gpio_ich                          
EDAC MC: Ver: 3.0.0                                                             
EDAC sbridge: Seeking for: dev 0e.0 PCI ID 8086:3ca0                            
EDAC sbridge: Seeking for: dev 0e.0 PCI ID 8086:3ca0                            
EDAC sbridge: Seeking for: dev 0f.0 PCI ID 8086:3ca8                            
EDAC sbridge: Seeking for: dev 0f.0 PCI ID 8086:3ca8                            
EDAC sbridge: Seeking for: dev 0f.1 PCI ID 8086:3c71                            
EDAC sbridge: Seeking for: dev 0f.1 PCI ID 8086:3c71                            
EDAC sbridge: Seeking for: dev 0f.2 PCI ID 8086:3caa                            
EDAC sbridge: Seeking for: dev 0f.2 PCI ID 8086:3caa                            
EDAC sbridge: Seeking for: dev 0f.3 PCI ID 8086:3cab                            
EDAC sbridge: Seeking for: dev 0f.3 PCI ID 8086:3cab                            
EDAC sbridge: Seeking for: dev 0f.4 PCI ID 8086:3cac                            
EDAC sbridge: Seeking for: dev 0f.4 PCI ID 8086:3cac                            
EDAC sbridge: Seeking for: dev 0f.5 PCI ID 8086:3cad                            
EDAC sbridge: Seeking for: dev 0f.5 PCI ID 8086:3cad                            
EDAC sbridge: Seeking for: dev 11.0 PCI ID 8086:3cb8                            
EDAC sbridge: Seeking for: dev 11.0 PCI ID 8086:3cb8                            
EDAC sbridge: Seeking for: dev 0c.6 PCI ID 8086:3cf4                            
EDAC sbridge: Seeking for: dev 0c.6 PCI ID 8086:3cf4                            
EDAC sbridge: Seeking for: dev 0c.7 PCI ID 8086:3cf6                            
EDAC sbridge: Seeking for: dev 0c.7 PCI ID 8086:3cf6                            
EDAC sbridge: Seeking for: dev 0d.6 PCI ID 8086:3cf5                            
EDAC sbridge: Seeking for: dev 0d.6 PCI ID 8086:3cf5                            
EDAC MC0: Giving out device to 'sbridge_edac.c' 'Sandy Bridge Socket#0': DEV 000
EDAC sbridge: Driver loaded.                                                    
scsi 0:3:0:0: Attached scsi generic sg0 type 12                                 
sd 0:0:0:0: Attached scsi generic sg1 type 0                                    
sd 0:0:0:1: Attached scsi generic sg2 type 0                                    
sd 0:0:0:2: Attached scsi generic sg3 type 0                                    
input: PC Speaker as /devices/platform/pcspkr/input/input3                      
microcode: CPU0 sig=0x206d7, pf=0x1, revision=0x70d                             
microcode: CPU1 sig=0x206d7, pf=0x1, revision=0x70d                             
microcode: CPU2 sig=0x206d7, pf=0x1, revision=0x70d                             
microcode: CPU3 sig=0x206d7, pf=0x1, revision=0x70d                             
microcode: CPU4 sig=0x206d7, pf=0x1, revision=0x70d                             
microcode: CPU5 sig=0x206d7, pf=0x1, revision=0x70d                             
microcode: CPU6 sig=0x206d7, pf=0x1, revision=0x70d                             
microcode: CPU7 sig=0x206d7, pf=0x1, revision=0x70d                             
microcode: CPU8 sig=0x206d7, pf=0x1, revision=0x70d                             
microcode: CPU9 sig=0x206d7, pf=0x1, revision=0x70d                             
microcode: CPU10 sig=0x206d7, pf=0x1, revision=0x70d                            
microcode: CPU11 sig=0x206d7, pf=0x1, revision=0x70d                            
microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter a
ipmi message handler version 39.2                                               
IPMI System Interface driver.                                                   
ipmi_si: probing via ACPI                                                       
ipmi_si 00:02: [io  0x0ca2-0x0ca3] regsize 1 spacing 1 irq 0                    
ipmi_si: Adding ACPI-specified kcs state machine                                
ipmi_si: probing via SMBIOS                                                     
ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0                             
ipmi_si: Adding SMBIOS-specified kcs state machine duplicate interface          
ipmi_si: probing via SPMI                                                       
ipmi_si: SPMI: io 0xca2 regsize 2 spacing 2 irq 0                               
ipmi_si: Adding SPMI-specified kcs state machine duplicate interface            
ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, slave ad0
ipmi_si 00:02: Found new BMC (man_id: 0x00000b, prod_id: 0x2000, dev_id: 0x13)  
ipmi_si 00:02: IPMI kcs interface initialized                                   
iTCO_vendor_support: vendor-support=0                                           
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10                                 
iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS      
[  O.K  ]                                                                       
tun: Universal TUN/TAP device driver, 1.6                                       
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>                          
Setting hostname localhost.localdomain:  [  OK  ]                               
device-mapper: uevent: version 1.0.3                                            
device-mapper: ioctl: 4.26.0-ioctl (2013-08-15) initialised: dm-devel@redhat.com
...............not responding...                                                
INFO: task modprobe:487 blocked for more than 120 seconds.                      
      Not tainted 3.12.0-rc2+ #1                                                
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.       
modprobe        D 0000000000000000     0   487      1 0x00000000                
 ffff880c0bc6bdc8 0000000000000046 ffffffff8107af7d ffff880c0bc6a000            
 ffff880c0bc6bfd8 ffff880c0bc6a000 ffff880c0bc6a010 ffff880c0bc6a000            
 ffff880c0bc6bfd8 ffff880c0bc6a000 ffff880c09a16440 ffff880c0ee6a540            
Call Trace:                                                                     
 [<ffffffff8107af7d>] ? lowest_in_progress+0x4d/0x60                            
 [<ffffffff81592109>] schedule+0x29/0x70                                        
 [<ffffffff8107b005>] async_synchronize_cookie_domain+0x75/0x120                
 [<ffffffff81073c20>] ? wake_up_bit+0x40/0x40                                   
 [<ffffffff8107b0e8>] async_synchronize_full_domain+0x18/0x20                   
 [<ffffffff8107b100>] async_synchronize_full+0x10/0x20                          
 [<ffffffff810c7c65>] do_init_module+0x135/0x1b0                                
 [<ffffffff810c9932>] load_module+0x502/0x620                                   
 [<ffffffff810c7170>] ? __unlink_module+0x30/0x30                               
 [<ffffffff810c6760>] ? module_sect_show+0x30/0x30                              
 [<ffffffff810c9bd6>] SyS_init_module+0x96/0xc0                                 
 [<ffffffff8159d1d2>] system_call_fastpath+0x16/0x1b                            
no locks held by modprobe/487.     
INFO: task dmraid:6718 blocked for more than 120 seconds.                       
      Not tainted 3.12.0-rc2+ #1                                                
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.       
dmraid          D 0000000000000000     0  6718    553 0x00000000                
 ffff8800b9a51ae8 0000000000000046 ffff880c0a42d200 ffff8800b9a50000            
 ffff8800b9a51fd8 ffff8800b9a50000 ffff8800b9a50010 ffff8800b9a50000            
 ffff8800b9a51fd8 ffff8800b9a50000 ffff880c0a42c940 ffffffff81a104c0            
Call Trace:                                                                     
 [<ffffffff81592109>] schedule+0x29/0x70                                        
 [<ffffffff81592467>] schedule_preempt_disabled+0x27/0x40                       
 [<ffffffff8158f84a>] mutex_lock_nested+0x13a/0x340                             
 [<ffffffff811cc21e>] ? __blkdev_get+0x6e/0x490                                 
 [<ffffffff811cc21e>] __blkdev_get+0x6e/0x490                                   
 [<ffffffff811cb6a9>] ? bd_acquire+0x99/0xf0                                    
 [<ffffffff811cc69c>] blkdev_get+0x5c/0x210                                     
 [<ffffffff8159446b>] ? _raw_spin_unlock+0x2b/0x50                              
 [<ffffffff811cc850>] ? blkdev_get+0x210/0x210                                  
 [<ffffffff811cc8b2>] blkdev_open+0x62/0x80                                     
 [<ffffffff8118d46e>] do_dentry_open+0x24e/0x2e0                                
 [<ffffffff8118d615>] finish_open+0x35/0x50                                     
 [<ffffffff811a0ab6>] do_last+0x436/0x7e0                                       
 [<ffffffff811a0f24>] path_openat+0xc4/0x490                                    
 [<ffffffff811a142a>] do_filp_open+0x4a/0xa0                                    
 [<ffffffff811ae2c1>] ? __alloc_fd+0xb1/0x160                                   
 [<ffffffff8115f01f>] ? vm_munmap+0x5f/0x80                                     
 [<ffffffff8118e91a>] do_sys_open+0x11a/0x230                                   
 [<ffffffff81078223>] ? up_write+0x23/0x40                                      
 [<ffffffff81296909>] ? lockdep_sys_exit_thunk+0x35/0x67                        
 [<ffffffff8118ea6e>] SyS_open+0x1e/0x20                                        
 [<ffffffff8159d1d2>] system_call_fastpath+0x16/0x1b                            
1 lock held by dmraid/6718:                                                     
 #0:  (&bdev->bd_mutex){......}, at: [<ffffffff811cc21e>] __blkdev_get+0x6e/0x40

smc> and it's been 20-something minutes at this point, and the system is
still not up, still cannot login..

If anyone wants to try it themself, make a RAID5 volume on a smart array
with rapid parity init enabled and then reboot.

Userland is RHEL6u3, I think (might be RHEL6u4, I don't think it makes
a difference.).

-- steve


> 
> Also maybe a cmd_special_free is missing - see below
> 
> Cheers, Tomas
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/scsi/hpsa.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  drivers/scsi/hpsa.h |    1 +
>  2 files changed, 49 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index b7f405f..38e3af4 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1010,6 +1010,20 @@ static void adjust_hpsa_scsi_table(struct ctlr_info *h, int hostno,
>  	for (i = 0; i < nsds; i++) {
>  		if (!sd[i]) /* if already added above. */
>  			continue;
> +
> +		/* Don't add devices which are NOT READY, FORMAT IN PROGRESS
> +		 * as the SCSI mid-layer does not handle such devices well.
> +		 * It relentlessly loops sending TUR at 3Hz, then READ(10)
> +		 * at 160Hz, and prevents the system from coming up.
> +		 */
> +		if (sd[i]->format_in_progress) {
> +			dev_info(&h->pdev->dev,
> +				"Logical drive format in progress, device c%db%dt%dl%d offline.\n",
> +				h->scsi_host->host_no,
> +				sd[i]->bus, sd[i]->target, sd[i]->lun);
> +			continue;
> +		}
> +
>  		device_change = hpsa_scsi_find_entry(sd[i], h->dev,
>  					h->ndevices, &entry);
>  		if (device_change == DEVICE_NOT_FOUND) {
> @@ -1715,6 +1729,34 @@ static inline void hpsa_set_bus_target_lun(struct hpsa_scsi_dev_t *device,
>  	device->lun = lun;
>  }
>  
> +static unsigned char hpsa_format_in_progress(struct ctlr_info *h,
> +		unsigned char scsi3addr[])
> +{
> +	struct CommandList *c;
> +	unsigned char *sense, sense_key, asc, ascq;
> +#define ASC_LUN_NOT_READY 0x04
> +#define ASCQ_LUN_NOT_READY_FORMAT_IN_PROGRESS 0x04
> +
> +
> +	c = cmd_special_alloc(h);
> +	if (!c)
> +		return 0;
> +	fill_cmd(c, TEST_UNIT_READY, h, NULL, 0, 0, scsi3addr, TYPE_CMD);
> +	hpsa_scsi_do_simple_cmd_core(h, c);
> +	sense = c->err_info->SenseInfo;
> +	sense_key = sense[2];
> +	asc = sense[12];
> +	ascq = sense[13];
> +	if (c->err_info->CommandStatus == CMD_TARGET_STATUS &&
> +		c->err_info->ScsiStatus == SAM_STAT_CHECK_CONDITION &&
> +		sense_key == NOT_READY &&
> +		asc == ASC_LUN_NOT_READY &&
> +		ascq == ASCQ_LUN_NOT_READY_FORMAT_IN_PROGRESS)
> +		return 1;
> return^ without cmd_special_free
> 
> +	cmd_special_free(h, c);
> +	return 0;
> +}
> +
>  static int hpsa_update_device_info(struct ctlr_info *h,
>  	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device,
>  	unsigned char *is_OBDR_device)
> @@ -1753,10 +1795,14 @@ static int hpsa_update_device_info(struct ctlr_info *h,
>  		sizeof(this_device->device_id));
>  
>  	if (this_device->devtype == TYPE_DISK &&
> -		is_logical_dev_addr_mode(scsi3addr))
> +		is_logical_dev_addr_mode(scsi3addr)) {
>  		hpsa_get_raid_level(h, scsi3addr, &this_device->raid_level);
> -	else
> +		this_device->format_in_progress =
> +			hpsa_format_in_progress(h, scsi3addr);
> +	} else {
>  		this_device->raid_level = RAID_UNKNOWN;
> +		this_device->format_in_progress = 0;
> +	}
>  
>  	if (is_OBDR_device) {
>  		/* See if this is a One-Button-Disaster-Recovery device
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index bc85e72..4fd0d45 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -46,6 +46,7 @@ struct hpsa_scsi_dev_t {
>  	unsigned char vendor[8];        /* bytes 8-15 of inquiry data */
>  	unsigned char model[16];        /* bytes 16-31 of inquiry data */
>  	unsigned char raid_level;	/* from inquiry page 0xC1 */
> +	unsigned char format_in_progress;
>  };
>  
>  struct reply_pool {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
