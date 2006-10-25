From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: Re: [PATCH 1/4] aic79xx: Fixup external device reset
Date: Tue, 24 Oct 2006 19:49:05 -0700
Message-ID: <1161744545.31105.31.camel@home-desk>
References: <453CC21D.5030201@suse.de>
	 <1161733051.7104.37.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron2.pdx.net ([69.64.224.71]:36545 "EHLO iron2.pdx.net")
	by vger.kernel.org with ESMTP id S1161226AbWJYCt0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Oct 2006 22:49:26 -0400
In-Reply-To: <1161733051.7104.37.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2006-10-24 at 16:37 -0700, James Bottomley wrote:

This was in response to my reporting a fault when a LUN (either an array
or a disk) goes off-line and then is powered back on.  The error would
not occur in kernels up to 2.6.15.7 but would fail in 2.6.16 and higher.

Prior to this patch, my 29320 would lockup the box with errors like the
following:

------------[ cut here ]------------
kernel BUG at mm/slab.c:594!
invalid opcode: 0000 [#1]
SMP
Modules linked in: autofs4 hidp rfcomm l2cap bluetooth sunrpc iscsi_tcp
libiscsi scsi_transport_iscsi ipv6 video sbs i2c_ec i2c_core button
battery asus_acpi ac parport_pc lp parport snd_intel8x0 snd_ac97_codec
snd_ac97_bus sg snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm floppy snd_timer snd
soundcore snd_page_alloc serio_raw ide_cd skge cdrom pcspkr dm_snapshot
dm_zero dm_mirror dm_mod aic79xx scsi_transport_spi sd_mod scsi_mod ext3
jbd ehci_hcd ohci_hcd uhci_hcd
CPU:    0
EIP:    0060:[<c0169562>]    Not tainted VLI
EFLAGS: 00010246   (2.6.19-rc2 #1)
EIP is at kmem_cache_free+0x29/0x6d
eax: 00000000   ebx: dffae300   ecx: dff91b80   edx: c1a00000
esi: dffaaf80   edi: 00000000   ebp: d3f324c0   esp: d3fb9dd0
ds: 007b   es: 007b   ss: 0068
Process tdg_2 (pid: 2362, ti=d3fb9000 task=dfd6cd50 task.ti=d3fb9000)
Stack: dffae300 dffaaf80 00000000 c0154448 00000000 d3e09a80 dffaaf80
d3e09a80
       c018bafc 00001000 00000000 c018b822 e088efa0 00001000 00000000
0000000a
       d3fb9ef0 d43f76c8 00003000 00000000 00000001 c130cac8 00008000
00000000
Call Trace:
 [<c0154448>] mempool_free+0x66/0x6b
 [<c018bafc>] bio_free+0x25/0x30
 [<c018b822>] bio_put+0x28/0x29
 [<e088efa0>] scsi_execute_async+0x15f/0x33d [scsi_mod]
 [<e09c9913>] sg_common_write+0x704/0x772 [sg]
 [<e09c9ba6>] sg_new_write+0x225/0x248 [sg]
 [<e09cae45>] sg_write+0x106/0x33a [sg]
 [<c016dae7>] vfs_write+0xa8/0x159
 [<c016e114>] sys_write+0x41/0x67
 [<c0103dc9>] sysenter_past_esp+0x56/0x79
DWARF2 unwinder stuck at sysenter_past_esp+0x56/0x79

Leftover inexact backtrace:

 [<c031007b>] sleep_on+0x1e/0x6c
 =======================
Code: 5f c3 89 c1 8d 82 00 00 00 40 c1 e8 0c 57 89 d7 6b d0 28 03 15 00
d6 50 c0 56 53 8b 02 f6 c4 40 74 03 8b 52 0c 8b 02 84 c0 78 08 <0f> 0b
52 02 e6 6b 33 c0 39 4a 20 74 08 0f 0b ca 0d e6 6b 33 c0
EIP: [<c0169562>] kmem_cache_free+0x29/0x6d SS:ESP 0068:d3fb9dd0


You can review my comments on testing in the thread titled:
"Adaptec 29320 [aic79xx] fails on power cycle of LUN"

Hope this clarifies things.

Sean

