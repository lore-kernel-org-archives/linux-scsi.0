From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Checkin 7404ad3b6d04efbd918e9e2e776bf560fbedf47d breaks boot
 on KVM
Date: Tue, 14 Oct 2008 09:00:55 -0700
Message-ID: <48F4C237.2060103@zytor.com>
References: <48F3E1C9.6030007@zytor.com> <1223990609.12440.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:55135 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbYJNQBB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Oct 2008 12:01:01 -0400
In-Reply-To: <1223990609.12440.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jejb@steeleye.com>

James Bottomley wrote:
>> 
> Actually, it is surprising.  That patch takes the default arithmetic for
> calculating the disk size out of sd and uses a routine to do it more
> efficiently in lib/string_helpers.c
> 
> So there are two problems:  Why does it panic on revert (could you post
> the oops) and what does kvm object to in string_get_size ... it's a
> fairly innocuous routine as I read it ... your symptoms sound like the
> for loop isn't terminating.
> 

Here is the oops.  Note that it does get well past the hang point before 
it crashes.  It is 100% reproducible.

console [netcon0] enabled 

netconsole: network logging started 

Uniform Multi-Platform E-IDE driver 

ide-floppy driver 1.00 

Driver 'sd' needs updating - please use bus_type methods 

scsi0 : ata_piix 

scsi1 : ata_piix 

ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14 

ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15 

ata1.00: ATA-7: QEMU HARDDISK, 0.9.1, max UDMA/100 

ata1.00: 16777216 sectors, multi 16: LBA48 

ata1.00: configured for MWDMA2 

ata2.00: ATAPI: QEMU DVD-ROM, 0.9.1, max UDMA/100 

ata2.00: configured for MWDMA2 

scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0.9. PQ: 0 
ANSI: 5
sd 0:0:0:0: [sda] 16777216 512-byte hardware sectors (8590 MB) 

sd 0:0:0:0: [sda] Write Protect is off 

sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:0:0: [sda] 16777216 512-byte hardware sectors (8590 MB) 

sd 0:0:0:0: [sda] Write Protect is off 

sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
  sda: sda1 

sd 0:0:0:0: [sda] Attached SCSI disk 

scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     0.9. PQ: 0 
ANSI: 5
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12 

serio: i8042 KBD port at 0x60,0x64 irq 1 

serio: i8042 AUX port at 0x60,0x64 irq 12 

mice: PS/2 mouse device common for all mice 

input: AT Translated Set 2 keyboard as /class/input/input0 

md: linear personality registered for level -1 

md: raid0 personality registered for level 0 

md: raid1 personality registered for level 1 

md: raid10 personality registered for level 10 

raid6: int32x1    972 MB/s 

raid6: int32x2   1032 MB/s 

raid6: int32x4    763 MB/s
raid6: int32x8    729 MB/s
raid6: mmxx1     2572 MB/s
raid6: mmxx2     3154 MB/s
raid6: sse1x1    2036 MB/s
raid6: sse1x2    2430 MB/s
raid6: sse2x1    3506 MB/s
raid6: sse2x2    3428 MB/s
raid6: using algorithm sse2x1 (3506 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
EDAC MC: Ver: 2.1.0 Oct 13 2008
input: ImExPS/2 Generic Explorer Mouse as /class/input/input1
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Using IPI Shortcut mode
registered taskstats version 1
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 304k freed
Write protecting the kernel text: 3692k
Write protecting the kernel read-only data: 1556k
BUG: spinlock bad magic on CPU#0, swapper/1
  lock: c0b75418, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
Pid: 1, comm: swapper Not tainted 2.6.27 #17
Call Trace:
  [<c0597388>] ? printk+0xf/0x17
  [<c03ac8ae>] spin_bug+0x75/0x80
  [<c03ac97c>] _raw_spin_lock+0x1e/0xe4
  [<c0412a3f>] ? serial8250_startup+0x33e/0x4e5
  [<c0599821>] _spin_lock_irq+0x32/0x3a
  [<c0412a3f>] ? serial8250_startup+0x33e/0x4e5
  [<c0412a3f>] serial8250_startup+0x33e/0x4e5
  [<c040f5fb>] uart_startup+0x84/0x143
  [<c0410309>] uart_open+0x14b/0x381
  [<c05996ba>] ? _spin_unlock+0x27/0x3c
  [<c03f483f>] ? check_tty_count+0x3b/0x8a
  [<c03f70b9>] tty_open+0x263/0x366
  [<c0271b2a>] chrdev_open+0x168/0x180
  [<c026df19>] __dentry_open+0x146/0x234
  [<c026e08e>] nameidata_to_filp+0x1f/0x33
  [<c02719c2>] ? chrdev_open+0x0/0x180
  [<c0278ed1>] do_filp_open+0x342/0x659
  [<c023651c>] ? trace_hardirqs_off+0xb/0xd
  [<c05996ba>] ? _spin_unlock+0x27/0x3c
  [<c026dcff>] do_sys_open+0x42/0xb7
  [<c026ddb6>] sys_open+0x1e/0x26
  [<c0201216>] init_post+0x2a/0x13c
  [<c0203d53>] ? kernel_thread_helper+0x7/0x10
