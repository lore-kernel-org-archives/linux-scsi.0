From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bug 3482] New: plugging/unplugging usb devices causes
 mm/slab.c kernel bug
Date: Wed, 29 Sep 2004 21:02:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929210241.55cf3d09.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:44497 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S268045AbUI3BMY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 21:12:24 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net


Is anyone else getting a bit bored of this bug?



Begin forwarded message:

Date: Tue, 28 Sep 2004 03:20:08 -0700
From: bugme-daemon@osdl.org
To: akpm@digeo.com
Subject: [Bug 3482] New: plugging/unplugging usb devices causes mm/slab.c kernel bug


http://bugme.osdl.org/show_bug.cgi?id=3482

           Summary: plugging/unplugging usb devices causes mm/slab.c kernel
                    bug
    Kernel Version: 2.6.8.x
            Status: NEW
          Severity: normal
             Owner: akpm@digeo.com
         Submitter: andrea@yu.net


Distribution: Linux Slackware 10
Hardware Environment: nForce2 MB, 256MB RAM, Nvidia VGA
Software Environment: X+KDE, console
Problem Description:
My external usb drive is working mostly only using ohci_hcd on usb2 controller,
using ehci crashes transfer after less than a minute.
Also, sometimes it crashes using ohci hub as well, for example when doing md5sum
of a large file on the usb disk itself.

Usually, solution is to unplug the disk, shut it down if necessary,
unload/reload usb_storage module and plug it in again, although most of the time
it crashes with a kernel bug like this:

Initializing USB Mass Storage driver...
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
ohci_hcd 0000:00:02.1: wakeup
usb 3-1: new full speed USB device using address 4
kmem_cache_create: duplicate cache scsi_cmd_cache
------------[ cut here ]------------
kernel BUG at mm/slab.c:1382!
invalid operand: 0000 [#1]
PREEMPT
Modules linked in: usb_storage nvidia snd_pcm_oss snd_mixer_oss ohci_hcd
forcedeth snd_intel8x0 snd_ac97_codec snd_pcm snd_timer snd_page_alloc
snd_mpu401_uart snd_rawmidi snd_seq_device snd evdev ntfs sd_mod scsi_mod usbcore
CPU:    0
EIP:    0060:[<c013d209>]    Tainted: P
EFLAGS: 00010202   (2.6.8)
EIP is at kmem_cache_create+0x3b9/0x550
eax: 00000032   ebx: cdd56a50   ecx: c03c4258   edx: c0303538
esi: cecb26a7   edi: cecb26a7   ebp: cdd56960   esp: cda89d30
ds: 007b   es: 007b   ss: 0068
Process khubd (pid: 318, threadinfo=cda88000 task=cda20660)
Stack: c02cb8c0 cecb2698 00000020 00002000 cda89d50 cdd5699c c0000000 ffffffe0
       000000a0 cdca9a00 cecbda00 cdca9a0c cecbda28 ceca8384 cecb2698 00000160
       00000020 00002000 00000000 00000000 000001d8 cdca9a00 cdca9bd8 cec91680
Call Trace:
 [<ceca8384>] scsi_setup_command_freelist+0x74/0x100 [scsi_mod]
 [<ceca975b>] scsi_host_alloc+0x1ab/0x2b0 [scsi_mod]
 [<cec8ca17>] usb_stor_Bulk_max_lun+0x57/0xa0 [usb_storage]
 [<cec8d9c3>] usb_stor_acquire_resources+0x73/0x120 [usb_storage]
 [<cec8dd01>] storage_probe+0x101/0x190 [usb_storage]
 [<cec6d07a>] usb_probe_interface+0x5a/0x60 [usbcore]
 [<c020404f>] bus_match+0x3f/0x70
 [<c02040c1>] device_attach+0x41/0xa0
 [<c020439b>] bus_add_device+0x5b/0xb0
 [<c0203151>] device_add+0xa1/0x130
 [<cec7453e>] usb_set_configuration+0x2de/0x460 [usbcore]
 [<cec6f424>] usb_new_device+0xb4/0x170 [usbcore]
 [<cec70112>] hub_port_connect_change+0x212/0x400 [usbcore]
 [<cec6dfd8>] clear_port_feature+0x58/0x60 [usbcore]
 [<cec70575>] hub_events+0x275/0x3c0 [usbcore]
 [<cec706f5>] hub_thread+0x35/0x110 [usbcore]
 [<c0119f20>] autoremove_wake_function+0x0/0x60
 [<c0105fde>] ret_from_fork+0x6/0x14
 [<c0119f20>] autoremove_wake_function+0x0/0x60
 [<cec706c0>] hub_thread+0x0/0x110 [usbcore]
 [<c0104291>] kernel_thread_helper+0x5/0x14
Code: 0f 0b 66 05 4e b0 2c c0 8b 0b e9 63 ff ff ff 8b 47 34 c7 04

Steps to reproduce:

It is not reproducible easy on different hardware platforms (on my home nForce2
MB it never happened, although file transfer sometimes blocks, but very rarely,
and is working with ehci root hub).
But when it happens, it is always after unplugging the disk,after the operation
fails and the disk keeps on showing activity even if it is not doing anything
(goes dumb).

------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
