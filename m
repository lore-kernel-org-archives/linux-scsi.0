From: Andrew Morton <akpm@osdl.org>
Subject: Fw: using usb storage
Date: Sat, 31 Jul 2004 19:31:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040731193121.1082160f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:6617 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264860AbUHACcx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 31 Jul 2004 22:32:53 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-usb-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org


Is this now fixed?  usb-storage in 2.6.7 is trying to create the
scsi_cmd_cache slab cache,  but it already exists.


Begin forwarded message:

Date: Sat, 31 Jul 2004 22:30:39 +0200
From: willy discart <willy.discart@skynet.be>
To: linux-kernel@vger.kernel.org
Subject: using usb storage




Ran into the following problem :


Using rsync to copy files to usb storage:

usr/X11R6/
usr/X11R6/ATI.2.TIMESTAMP
usr/X11R6/README.ati.2
usr/X11R6/bin/
usr/X11R6/bin/X
usr/X11R6/bin/XFree86
rsync: writefd_unbuffered failed to write 4 bytes: phase "unknown": 
Broken pipe
rsync error: error in rsync protocol data stream (code 12) at io.c(839)
rsync: writefd_unbuffered failed to write 69 bytes: phase "unknown": 
Broken pipe
rsync error: error in rsync protocol data stream (code 12) at io.c(839)


umount /disk
rmmod -v -f usb_storage
rmmod usb_storage, wait=no force

disconnect the usb storage, reconnect again :

usb 1-2.1: adding 1-2.1:1.0 (config #1, interface 0)
usb 1-2.1:1.0: hotplug
Initializing USB Mass Storage driver...
usb-storage 1-2.1:1.0: usb_probe_interface
usb-storage 1-2.1:1.0: usb_probe_interface - got id
kmem_cache_create: duplicate cache scsi_cmd_cache
------------[ cut here ]------------
kernel BUG at mm/slab.c:1392!
invalid operand: 0000 [#1]
PREEMPT
Modules linked in: usb_storage ds binfmt_misc thermal fan button 
processor ac        pro100 usbhid uhci_hcd usbcore yenta_socket 
pcmcia_core sd_mod battery snd_int       8x0 snd_ac97_codec snd_pcm_oss 
snd_mixer_oss snd_pcm snd_timer snd_page_alloc        d_mpu401_uart 
snd_rawmidi snd_seq_device snd
CPU:    0
EIP:    0060:[<c0135124>]    Not tainted
EFLAGS: 00010202   (2.6.7)
EIP is at kmem_cache_create+0x3f4/0x5a0
eax: 00000032   ebx: c13bea50   ecx: c03c0d8c   edx: c031e838
esi: c02f5437   edi: c02f5437   ebp: c466de0c   esp: c466ddd8
ds: 007b   es: 007b   ss: 0068
Process modprobe (pid: 2423, threadinfo=c466c000 task=c95948d0)
Stack: c02e7e40 c02f5428 00000020 00002000 c466ddfc c13be99c c0000000 
ffffffe0
       c13be960 000000a0 cfe0e600 c0364440 cfe0e60c c466de38 c024e863 
c02f5428
       00000160 00000020 00002000 00000000 00000000 000001d8 cfe0e600 
d08bd820
Call Trace:
 [<c01047ef>] show_stack+0x7f/0xa0
 [<c0104996>] show_registers+0x156/0x1b0
 [<c0104b39>] die+0x89/0x100
 [<c0104f25>] do_invalid_op+0xb5/0xc0
 [<c0104475>] error_code+0x2d/0x38
 [<c024e863>] scsi_setup_command_freelist+0x83/0x110
 [<c024f934>] scsi_host_alloc+0x1b4/0x2c0
 [<d08ba957>] usb_stor_acquire_resources+0xc7/0x130 [usb_storage]
 [<d08bac71>] storage_probe+0xf1/0x190 [usb_storage]
 [<d08f20db>] usb_probe_interface+0xbb/0xc0 [usbcore]
 [<c021e9fd>] bus_match+0x3d/0x70
 [<c021eb3c>] driver_attach+0x5c/0xa0
 [<c021ee55>] bus_add_driver+0xa5/0xc0
 [<c021f301>] driver_register+0x31/0x40
 [<d08f219f>] usb_register+0x3f/0xa0 [usbcore]
 [<d0924021>] usb_stor_init+0x21/0x3c [usb_storage]
 [<c012aa05>] sys_init_module+0x135/0x280
 [<c01042cb>] syscall_call+0x7/0xb

Code: 0f 0b 70 05 8c 76 2e c0 8b 0b e9 56 ff ff ff 8b 47 34 c7 04

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
