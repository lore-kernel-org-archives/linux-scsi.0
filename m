From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Adaptec 29320 [aic79xx] fails on power cycle of LUN
Date: Thu, 19 Oct 2006 01:52:01 -0400
Message-ID: <1161237121.15090.9.camel@max>
References: <1161210246.3204.17.camel@home-desk>
	 <1161210748.3204.22.camel@home-desk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:22236 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1161315AbWJSGwI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 02:52:08 -0400
In-Reply-To: <1161210748.3204.22.camel@home-desk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sean Bruno <sean.bruno@dsl-only.net>
Cc: linux-scsi@vger.kernel.org

On Wed, 2006-10-18 at 15:32 -0700, Sean Bruno wrote:
> On Wed, 2006-10-18 at 15:24 -0700, Sean Bruno wrote:
> > I have had a tough time tracking this one down, however I can say for
> > certain that the 29320 is really having trouble if a LUN is power
> > cycled.
> > 
> > I don't have access to a BUS analyzer right now, but here is my
> > regression.
> > 
> > 1.  Hook an external SCSI array/disk to a 29320.
> > 2.  Power up SCSI array/disk
> > 3.  Power up PC with 29320.
> > 4.  When PC has booted, login and test device by creating a file
> >     system, eg. mkfs /dev/sda (or whatever disk the array is called on
> >     ur machine).
> > 5.  Power cycle array/disk
> > 6.  Retest device with another 'mkfs /dev/sda' ... panic/crash/lock-up
> > ensues.
> > 
> > 
> > 
> > This did not happen in 2.6.15.7 but did appear in 2.6.16 and higher.
> > 
> >From 2.6.19-rc2 I at least get something from a crash without the entire
> box locking up on me.  
> 
> The process tdg_2 is a 'test data generator' basically it writes data to
> the scsi disk in a testable pattern that is later validated.
> 
> ------------[ cut here ]------------
> kernel BUG at mm/slab.c:594!
> invalid opcode: 0000 [#1]
> SMP
> Modules linked in: autofs4 hidp rfcomm l2cap bluetooth sunrpc iscsi_tcp
> libiscsi scsi_transport_iscsi ipv6 video sbs i2c_ec i2c_core button
> battery asus_acpi ac parport_pc lp parport snd_intel8x0 snd_ac97_codec
> snd_ac97_bus sg snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
> snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm floppy snd_timer snd
> soundcore snd_page_alloc serio_raw ide_cd skge cdrom pcspkr dm_snapshot
> dm_zero dm_mirror dm_mod aic79xx scsi_transport_spi sd_mod scsi_mod ext3
> jbd ehci_hcd ohci_hcd uhci_hcd
> CPU:    0
> EIP:    0060:[<c0169562>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.19-rc2 #1)
> EIP is at kmem_cache_free+0x29/0x6d
> eax: 00000000   ebx: dffae300   ecx: dff91b80   edx: c1a00000
> esi: dffaaf80   edi: 00000000   ebp: d3f324c0   esp: d3fb9dd0
> ds: 007b   es: 007b   ss: 0068
> Process tdg_2 (pid: 2362, ti=d3fb9000 task=dfd6cd50 task.ti=d3fb9000)
> Stack: dffae300 dffaaf80 00000000 c0154448 00000000 d3e09a80 dffaaf80
> d3e09a80
>        c018bafc 00001000 00000000 c018b822 e088efa0 00001000 00000000
> 0000000a
>        d3fb9ef0 d43f76c8 00003000 00000000 00000001 c130cac8 00008000
> 00000000
> Call Trace:
>  [<c0154448>] mempool_free+0x66/0x6b
>  [<c018bafc>] bio_free+0x25/0x30
>  [<c018b822>] bio_put+0x28/0x29
>  [<e088efa0>] scsi_execute_async+0x15f/0x33d [scsi_mod]
>  [<e09c9913>] sg_common_write+0x704/0x772 [sg]
>  [<e09c9ba6>] sg_new_write+0x225/0x248 [sg]
>  [<e09cae45>] sg_write+0x106/0x33a [sg]
>  [<c016dae7>] vfs_write+0xa8/0x159
>  [<c016e114>] sys_write+0x41/0x67
>  [<c0103dc9>] sysenter_past_esp+0x56/0x79
> DWARF2 unwinder stuck at sysenter_past_esp+0x56/0x79
> 
> Leftover inexact backtrace:
> 
>  [<c031007b>] sleep_on+0x1e/0x6c
>  =======================
> Code: 5f c3 89 c1 8d 82 00 00 00 40 c1 e8 0c 57 89 d7 6b d0 28 03 15 00
> d6 50 c0 56 53 8b 02 f6 c4 40 74 03 8b 52 0c 8b 02 84 c0 78 08 <0f> 0b
> 52 02 e6 6b 33 c0 39 4a 20 74 08 0f 0b ca 0d e6 6b 33 c0
> EIP: [<c0169562>] kmem_cache_free+0x29/0x6d SS:ESP 0068:d3fb9dd0


Does this only occur with sg or is that the only way you got a trace? In
the original bug report you mentioned it occurring with mkfs, but the
bug oops is from a sg request. Is tdg_2 run while the mkfs is running?

