From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] fix scsi process problems and clean up the target reap issues
Date: Tue, 28 Feb 2006 11:17:33 -0800
Message-ID: <20060228191733.GA4913@us.ibm.com>
References: <1140726438.2809.18.camel@localhost.localdomain> <20060228172436.GA1456@us.ibm.com> <1141148345.3258.24.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58015 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932442AbWB1TSJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 14:18:09 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1SJI8IP007630
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 14:18:08 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k1SJI8DB130018
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 14:18:08 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k1SJI7TG022948
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 14:18:08 -0500
Content-Disposition: inline
In-Reply-To: <1141148345.3258.24.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Tue, 2006-02-28 at 09:24 -0800, Mike Anderson wrote:
> > The patch was tried on the aic7xxx ahc_linux_target_alloc issue I
> > previously mentioned and it did not change the result of a BUG_ON.
> 
> Hmm ... could you repost the panic ... I also put in Brian King's check
> for device_add failure, which should have picked this up ... it sounds
> like there's something else going on.

Posted below. This problem is showing up when a sequence of a delete
followed by a scan is executed using the sysfs interface. The device
at SCSI Id 1 is a IBM 3580Gen3 LTO Tape device.

> 
> > Is there some reason we cannot do the list_del_init(&starget->siblings) in
> > scsi_target_dev_release post calling target_destroy? It would appear with
> > the check for STARGET_DEL that being on the list longer should not be a
> > problem.
> 
> No, it shouldn't ... it just potentially delays the allocation to wait
> for everything to finish using the old target ... we might have to put a
> reschedule in the retry loop in alloc to avoid a busy wait.
> 
> Does that fix your aic problem?

I believe being on the list longer would solve the aic problem, but I have
not tried to a patch to do this. I am trying to get access to the system now.

-andmike
--
Michael Anderson
andmike@us.ibm.com

Feb 27 13:16:22 system1 kernel:   Vendor: IBM       Model: ULTRIUM-TD3     
 Rev: 59D2
Feb 27 13:16:22 system1 kernel:   Type:   Sequential-Access                
 ANSI SCSI revision: 03
Feb 27 13:16:22 system1 kernel:  target0:0:1: Beginning Domain
Validation
Feb 27 13:16:22 system1 kernel:  target0:0:1: wide asynchronous
Feb 27 13:16:23 system1 kernel:  target0:0:1: FAST-20 WIDE SCSI 40.0
MB/s ST
(50 ns, offset 127)
Feb 27 13:16:23 system1 kernel:  target0:0:1: Domain Validation
skipping
write tests
Feb 27 13:16:23 system1 kernel:  target0:0:1: Ending Domain Validation
Feb 27 13:16:23 system1 kernel: st: Version 20050830, fixed bufsize
32768,
s/g segs 256
Feb 27 13:16:23 system1 kernel: st 0:0:1:0: Attached scsi tape
st0<4>st0:
try direct i/o: yes (alignment 512 B)
Feb 27 13:16:23 system1 kernel: st 0:0:1:0: Attached scsi generic sg0
type 1
Feb 27 13:16:33 system1 kernel:   Vendor: IBM       Model: ULTRIUM-TD3     
 Rev: 59D2
Feb 27 13:16:33 system1 kernel:   Type:   Sequential-Access                
 ANSI SCSI revision: 03
Feb 27 13:16:33 system1 kernel:  target0:0:1: Beginning Domain
Validation
Feb 27 13:16:33 system1 kernel:  target0:0:1: wide asynchronous
Feb 27 13:16:33 system1 kernel:  target0:0:1: FAST-20 WIDE SCSI 40.0
MB/s ST
(50 ns, offset 127)
Feb 27 13:16:33 system1 kernel:  target0:0:1: Domain Validation
skipping
write tests
Feb 27 13:16:33 system1 kernel:  target0:0:1: Ending Domain Validation
Feb 27 13:16:33 system1 kernel: st 0:0:1:0: Attached scsi tape
st0<4>st0:
try direct i/o: yes (alignment 512 B)
Feb 27 13:16:33 system1 kernel: st 0:0:1:0: Attached scsi generic sg0
type 1
Feb 27 13:16:48 system1 kernel: ------------[ cut here ]------------
Feb 27 13:16:48 system1 kernel: kernel BUG at
drivers/scsi/aic7xxx/aic7xxx_osm.c:534!
Feb 27 13:16:48 system1 kernel: invalid opcode: 0000 [#1]
Feb 27 13:16:48 system1 kernel: last sysfs file:
/class/scsi_host/host0/scan
Feb 27 13:16:48 system1 kernel: Modules linked in: sg st ip6t_LOG
xt_tcpudp
xt_pkttype ipt_LOG xt_limit snd_pcm_oss snd_mixer_oss snd_seq af_packet
edd
button battery ac ip6t_REJECT ipt_REJECT xt_state iptable_mangle
iptable_nat
ip_nat iptable_filter ip6table_mangle ip_conntrack nfnetlink ip_tables
ip6table_filter ip6_tables x_tables ipv6 loop dm_mod gl620a usbnet generic
i2c_viapro i2c_core ns558 ide_cd cdrom parport_pc parport shpchp via_ircc
uhci_hcd pci_hotplug irda via_agp usbcore snd_via82xx gameport crc_ccitt
agpgart
snd_ac97_codec snd_ac97_bus snd_pcm snd_timer snd_page_alloc
snd_mpu401_uart
snd_rawmidi snd_seq_device snd soundcore e100 mii reiserfs fan thermal
processor
via82cxxx aic7xxx scsi_transport_spi sd_mod scsi_mod ide_disk ide_core
Feb 27 13:16:48 system1 kernel: CPU:    0
Feb 27 13:16:48 system1 kernel: EIP:    0060:[<d0e81e7d>]
Feb 27 13:16:48 system1 kernel: EFLAGS: 00010086  
(2.6.16-rc3-git3-2-default #1) 
Feb 27 13:16:48 system1 kernel: EIP is at
ahc_linux_target_alloc+0x123/0x244
[aic7xxx]
Feb 27 13:16:48 system1 kernel: eax: 00000282   ebx: 00000001   ecx:
c776d16c   edx: ffffffff
Feb 27 13:16:48 system1 kernel: esi: cf41fa6c   edi: 00000048   ebp:
cf6ab98c   esp: c724dddc
Feb 27 13:16:48 system1 kernel: ds: 007b   es: 007b   ss: 0068
Feb 27 13:16:48 system1 kernel: Process kill_rescan.sh (pid: 5278,
threadinfo=c724c000 task=c5952030)
Feb 27 13:16:48 system1 kernel: Stack: <0>c776d16c c776d338 cf7209d0
00000282 4160f64c 00000007 d082c299 cf60f5f8 
Feb 27 13:16:48 system1 kernel:        c776d170 c020d343 cf60f63c
cf60f64c
00000000 cf60e1bc c776d170 cf60e1c0 
Feb 27 13:16:48 system1 kernel:        c776d16c d0e26a4a 00000001
00000000
cf60e2cc c776d16c c776d25c cf60e1bc 
Feb 27 13:16:48 system1 kernel: Call Trace:
Feb 27 13:16:48 system1 kernel:  [<d082c299>] spi_host_match+0xd/0x54
[scsi_transport_spi]
Feb 27 13:16:48 system1 kernel:  [<c020d343>]
attribute_container_device_trigger+0x3a/0xa1
Feb 27 13:16:48 system1 kernel:  [<d0e26a4a>]
scsi_alloc_target+0x1b4/0x2ab
[scsi_mod]
Feb 27 13:16:48 system1 kernel:  [<d0e26bfa>]
__scsi_scan_target+0x4b/0x59b
[scsi_mod]
Feb 27 13:16:48 system1 kernel:  [<c01656ad>]
notify_change+0x2db/0x2e9
Feb 27 13:16:48 system1 kernel:  [<c01627f6>] __d_path+0x118/0x156
Feb 27 13:16:48 system1 kernel:  [<c01ad446>] vsscanf+0xd4/0x3ef
Feb 27 13:16:48 system1 kernel:  [<d0e2727d>]
scsi_scan_host_selected+0xc5/0xdc [scsi_mod]
Feb 27 13:16:48 system1 kernel:  [<d0e2797b>] store_scan+0x96/0xae
[scsi_mod]
Feb 27 13:16:48 system1 kernel:  [<d0e278e5>] store_scan+0x0/0xae
[scsi_mod]
Feb 27 13:16:48 system1 kernel:  [<c020bd64>]
class_device_attr_store+0x1b/0x1f
Feb 27 13:16:48 system1 kernel:  [<c0182a43>]
sysfs_write_file+0x9b/0xc1
Feb 27 13:16:48 system1 kernel:  [<c01829a8>]
sysfs_write_file+0x0/0xc1
Feb 27 13:16:48 system1 kernel:  [<c014fa1e>] vfs_write+0xa1/0x146
Feb 27 13:16:48 system1 kernel:  [<c014ff34>] sys_write+0x3c/0x63
Feb 27 13:16:48 system1 kernel:  [<c0102ab9>] syscall_call+0x7/0xb
Feb 27 13:16:48 system1 kernel: Code: c0 e9 34 ff ff ff 0f b6 8d 33 01
00 00
83 c3 08 89 4c 24 14 8b 85 a8 00 00 00 83 c0 40 e8 e7 f9 3f ef 89 44 24 0c
83 3e
00 74 08 <0f> 0b 16 02 dc a4 e8 d0 8b 04 24 b9 43 00 00 00 89 06 31 c0 03 
Feb 27 13:16:48 system1 kernel:  <3>Debug: sleeping function called
from
invalid context at include/linux/rwsem.h:43
Feb 27 13:16:48 system1 kernel: in_atomic():0, irqs_disabled():1
Feb 27 13:16:48 system1 kernel:  [<c0119174>]
profile_task_exit+0x18/0x3e
Feb 27 13:16:48 system1 kernel:  [<c011a98b>] do_exit+0x1c/0x6b0
Feb 27 13:16:48 system1 kernel:  [<c0118922>] printk+0x14/0x18
Feb 27 13:16:48 system1 kernel:  [<c010442a>] show_stack+0x0/0xa
Feb 27 13:16:48 system1 kernel:  [<c0104979>] do_invalid_op+0x0/0x9d
Feb 27 13:16:48 system1 kernel:  [<c0104a0a>] do_invalid_op+0x91/0x9d
Feb 27 13:16:48 system1 kernel:  [<d0e81e7d>]
ahc_linux_target_alloc+0x123/0x244 [aic7xxx]
Feb 27 13:16:48 system1 kernel:  [<c0114a93>] __wake_up+0x2a/0x3d
Feb 27 13:16:48 system1 kernel:  [<c014c79e>]
cache_alloc_refill+0x1f8/0x527
Feb 27 13:16:48 system1 kernel:  [<c01ab8e7>]
kobject_uevent+0x36b/0x390
Feb 27 13:16:48 system1 kernel:  [<c014bfa9>]
cache_alloc_debugcheck_after+0xb8/0xea
Feb 27 13:16:48 system1 kernel:  [<c0103c3f>] error_code+0x4f/0x60
Feb 27 13:16:48 system1 kernel:  [<d0e81e7d>]
ahc_linux_target_alloc+0x123/0x244 [aic7xxx]
Feb 27 13:16:48 system1 kernel:  [<d082c299>] spi_host_match+0xd/0x54
[scsi_transport_spi]
Feb 27 13:16:48 system1 kernel:  [<c020d343>]
attribute_container_device_trigger+0x3a/0xa1
Feb 27 13:16:48 system1 kernel:  [<d0e26a4a>]
scsi_alloc_target+0x1b4/0x2ab
[scsi_mod]
Feb 27 13:16:48 system1 kernel:  [<d0e26bfa>]
__scsi_scan_target+0x4b/0x59b
[scsi_mod]
Feb 27 13:16:48 system1 kernel:  [<c01656ad>]
notify_change+0x2db/0x2e9
Feb 27 13:16:48 system1 kernel:  [<c01627f6>] __d_path+0x118/0x156
Feb 27 13:16:48 system1 kernel:  [<c01ad446>] vsscanf+0xd4/0x3ef
Feb 27 13:16:48 system1 kernel:  [<d0e2727d>]
scsi_scan_host_selected+0xc5/0xdc [scsi_mod]
Feb 27 13:16:48 system1 kernel:  [<d0e2797b>] store_scan+0x96/0xae
[scsi_mod]
Feb 27 13:16:48 system1 kernel:  [<d0e278e5>] store_scan+0x0/0xae
[scsi_mod]
Feb 27 13:16:48 system1 kernel:  [<c020bd64>]
class_device_attr_store+0x1b/0x1f
Feb 27 13:16:48 system1 kernel:  [<c0182a43>]
sysfs_write_file+0x9b/0xc1
Feb 27 13:16:48 system1 kernel:  [<c01829a8>]
sysfs_write_file+0x0/0xc1
Feb 27 13:16:48 system1 kernel:  [<c014fa1e>] vfs_write+0xa1/0x146
Feb 27 13:16:48 system1 kernel:  [<c014ff34>] sys_write+0x3c/0x63
Feb 27 13:16:48 system1 kernel:  [<c0102ab9>] syscall_call+0x7/0xb
