From: Alan Stern <stern@rowland.harvard.edu>
Subject: [linux-usb-devel] Fw: [Bug 3466] New: Bug while connecting USB-HDD
 (fwd)
Date: Sun, 26 Sep 2004 17:06:00 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0409261704460.32350-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:39178 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S263795AbUIZVGD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Sep 2004 17:06:03 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, USB development list <linux-usb-devel@lists.sourceforge.net>

Andrew sent this to linus-usb-devel, but it should have gone to
linux-scsi.

---------- Forwarded message ----------
Date: Sun, 26 Sep 2004 10:31:06 -0700
From: Andrew Morton <akpm@osdl.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: [linux-usb-devel] Fw: [Bug 3466] New: Bug while connecting USB-HDD


Did this doubly-created-slab-cache bug get fixed?

Begin forwarded message:

Date: Sun, 26 Sep 2004 09:55:49 -0700
From: bugme-daemon@osdl.org
To: akpm@digeo.com
Subject: [Bug 3466] New: Bug while connecting USB-HDD


http://bugme.osdl.org/show_bug.cgi?id=3466

           Summary: Bug while connecting USB-HDD
    Kernel Version: 2.6.8.1
            Status: NEW
          Severity: normal
             Owner: akpm@digeo.com
         Submitter: bugzilla.kernel.org@craesh.net


Distribution: Debian Sarge
Hardware Environment: Athlon 1GHz, ASUS A7A266, 
Software Environment:
Problem Description: I just connected my USB-HDD (a 'TrekStor USB-Storage 2,5"')
to my USB-Hub (VIA USB-2.0 chip, ehci), and as I didn't hear the beeps from
usbmgr and couldn't detect it by scsidev I looked at dmesg and found the
following lines:

usb 5-2.4: new full speed USB device using address 14
usb 5-2.4: not running at top speed; connect to a high speed hub
kmem_cache_create: duplicate cache scsi_cmd_cache
------------[ cut here ]------------
kernel BUG at mm/slab.c:1382!
invalid operand: 0000 [#1]
PREEMPT 
Modules linked in: tun iptable_filter ip_tables sr_mod parport_pc lp parport ipv
6 vfat fat isofs dm_mod snd_virmidi snd_seq_virmidi snd_seq_midi snd_seq_oss snd
_seq_midi_event snd_seq ir_kbd_gpio ir_kbd_i2c ir_common tuner tvaudio msp3400 b
ttv video_buf i2c_algo_bit v4l2_common btcx_risc videodev loop usblp usb_storage
 mga w83781d i2c_sensor i2c_ali1535 i2c_core snd_ens1371 snd_rawmidi snd_seq_dev
ice snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd_ac97_codec sn
d soundcore gameport 8139too mii crc32 rtc
CPU:    0
EIP:    0060:[<c01428e4>]    Not tainted
EFLAGS: 00010202   (2.6.8.1) 
EIP is at kmem_cache_create+0x3e4/0x590
eax: 00000032   ebx: df7bfbd0   ecx: c050a24c   edx: c042a538
esi: c03fa8c0   edi: c03fa8c0   ebp: c1595d34   esp: c1595d00
ds: 007b   es: 007b   ss: 0068
Process khubd (pid: 24, threadinfo=c1594000 task=c1541100)
Stack: c03e1780 c03fa8b1 00000020 00002000 c1595d24 df7bfb1c ffffffff ffffffe0 
       df7bfae0 000000a0 c1575400 c047f9a0 c157540c c1595d60 c031d6f7 c03fa8b1 
       00000160 00000020 00002000 00000000 00000000 000001d8 c1575400 c15755d8 
Call Trace:
 [<c0105e2f>] show_stack+0x7f/0xa0
 [<c0105fc8>] show_registers+0x158/0x1b0
 [<c0106149>] die+0x89/0x100
 [<c0106533>] do_invalid_op+0xb3/0xc0
 [<c0105a99>] error_code+0x2d/0x38
 [<c031d6f7>] scsi_setup_command_freelist+0x87/0x120
 [<c031e794>] scsi_host_alloc+0x1b4/0x2c0
 [<e09a5949>] usb_stor_acquire_resources+0x89/0x130 [usb_storage]
 [<e09a5c71>] storage_probe+0x101/0x190 [usb_storage]
 [<c0333e74>] usb_probe_interface+0x54/0x60
 [<c02edd3d>] bus_match+0x3d/0x70
 [<c02eddb5>] device_attach+0x45/0xa0
 [<c02ee0b5>] bus_add_device+0x75/0xd0
 [<c02ecd8e>] device_add+0x9e/0x140
 [<c033b2b3>] usb_set_configuration+0x2b3/0x440
 [<c03362a9>] usb_new_device+0xa9/0x170
 [<c0336fb0>] hub_port_connect_change+0x230/0x410
 [<c033740f>] hub_events+0x27f/0x3d0
 [<c0337595>] hub_thread+0x35/0x110
 [<c01032b1>] kernel_thread_helper+0x5/0x14
Code: 0f 0b 66 05 3f 0f 3e c0 8b 0b e9 56 ff ff ff 8b 47 34 c7 04 


Steps to reproduce: Don't know, I bought the USB-HDD a just weak ago, but
connected and disconnected it a lot of times since then.

------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.


-------------------------------------------------------
This SF.Net email is sponsored by: YOU BE THE JUDGE. Be one of 170
Project Admins to receive an Apple iPod Mini FREE for your judgement on
who ports your project to Linux PPC the best. Sponsored by IBM.
Deadline: Sept. 24. Go here: http://sf.net/ppc_contest.php
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

