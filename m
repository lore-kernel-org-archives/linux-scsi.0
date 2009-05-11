From: "Norman Diamond" <n0diamond@yahoo.co.jp>
Subject: Re: Adaptec driver crashes (3/3)
Date: Mon, 11 May 2009 20:24:47 +0900
Message-ID: <4470699976BE45C3A76A7A5660D35993@DIAMOND8600>
References: <507A39B029A94344AD588481FAAF019A@DIAMOND8600> <20090508120905.9624e4ad.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp08.mail.tnz.yahoo.co.jp ([203.216.226.136]:25591 "HELO
	smtp08.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752062AbZEKLZA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2009 07:25:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> Norman Diamond wrote:
>>
>> BUG: unable to handle kernel NULL pointer dereference at virtual address
>> 0000000
>> 0
>> printing eip: c04a50af *pde = 00000000
>> Oops: 0000 [#1] SMP
>> Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
>> snd_seq_
>> device snd_pcm_oss snd_mixer_oss fuse lp pcspkr snd_intel8x0
>> snd_ac97_codec ac97
>> _bus e100 snd_pcm snd_timer snd video mii iTCO_wdt soundcore serio_raw
>> iTCO_vend
>> or_support output psmouse evdev pcmcia intel_agp agpgart shpchp
>> snd_page_alloc p
>> arport_pc parport sg yenta_socket rsrc_nonstatic pcmcia_core aufs
>> squashfs sqlzm
>> a unlzma
>>
>> Pid: 3531, comm: klogs Not tainted (2.6.24.3 #1)
>> EIP: 0060:[<c04a50af>] EFLAGS: 00010046 CPU: 0
>> EIP is at ahc_handle_scsiint+0xdbf/0xef0
>> EAX: 00000000 EBX: 00000007 ECX: 00000001 EDX: 0000000d
>> ESI: ede17e00 EDI: 00000000 EBP: 00000000 ESP: ed507de4
>>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>> Process klogd (pid: 3531, ti=ed506000 task=edd6aaa0 task.ti=ed506000)
>> Stack: 00000001 00000041 00000001 ee6a6580 d662d853 41410000 000000a0
>> ead93024
>>        c01806db 00a0ee08 00000041 00000007 00000000 00000001 00000000
>> 00000000
>>        ed53b541 00000001 ede17e00 00000064 00000082 0000000b c04b20f9
>> ede0cd60
>> Call Trace:
>>  [<c01806db>] __link_path_walk+0xaab/0xe10
>>  [<c04b20f9>] ahc_linux_isr+0x1e9/0x260
>>  [<c0151025>] handle_IRQ_event+0x25/0x50
>>  [<c01529bc>] handle_level_irq+0x7c/0xf0
>>  [<c010748b>] do_IRQ+0x3b/0x70
>>  [<efbe3d90>] aufs_getattr+0x0/0xa0 [aufs]
>>  [<c01052d3>] common_interrupt+0x23/0x30
>>  [<efbe3d90>] aufs_getattr+0x0/0xa0 [aufs]
>>  [<efbe3d9e>] aufs_getattr+0xe/0xa0 [aufs]
>>  [<c017fa47>] getname+0xa7/0xc0
>>  [<c03b7acf>] security_inode_getattr+0x1f/0x30
>>  [<c017a4f8>] vfs_getattr+0x48/0x70
>>  [<c017a727>] vfs_stat_fd+0x37/0x60
>>  [<c017a82f>] sys_stat64+0xf/0x30
>>  [<c01775ee>] vfs_write+0x11e/0x140
>>  [<c0177c31>] sys_write+0x41/0x70
>>  [<c012cc1a>] sys_time+0xa/0x30
>>  [<c0104352>] syscall_call+0x7/0xb
>>  [<c0700000>] rpcb_getport_prepare+0x10/0x40
>>  =======================
>> Code: 24 2c e8 c5 95 ff ff b9 14 00 00 00 89 f0 8d 54 24 2c c7 44 24 04
>> 00 00 00
>>  00 c7 04 24 b6 d1 80 c0 e8 56 e9 ff ff e9 8d f8 ff ff <8b> 07 89 fa 0f
>> b6 58 1b
>>  0f b6 c3 89 44 24 1c 89 f0 e8 5b a5 00
>> EIP: [<c04a50af>] ahc_handle_scsiint+0xdbf/0xef0 SS:ESP 0068:ed507de4
>
> ahc_handle_scsiint() is a huge function.  It would help if we can find
> the file and line where it is crashing.  If you could do the following,
> please.
>
> - Run a more recent kernel: we might have fixed it since 2.6.24!

I experimented with a recent Knoppix distro based on a newer kernel, and
results were worse.

> - Enable CONFIG_DEBUG_INFO

Sorry, it's extra difficult to build customized kernels for Slax, and now's
not the time.  The next time I have to do it, I'll try to remember to enable
this.

> gdb vmlinux
> (gdb) l *0xc04a50af
>  (with a suitable value of c04a50af)

It looks like the devel package for this Slax version included gcc but not
gdb.  Next time I have to rebuild a customized Slax, I'll try to add gdb.
Does gdb have to be the same version as gcc, i.e. are they built together
and gdb knows details of the corresponding gcc version?  Or can I grab the
latest gdb that will be available at the time?

The file is aic_7xxx.c but I think you knew that.

My intuitive interpretation of "+0xdbf/0xef0" is that it's somewhere in the
block
  } else if ((status & BUSFREE) != 0
    && (ach_inb(ahc, SIMODE1) & ENBUSFREE) != 0) {
    [... somewhere ...]
  }

Without knowing the guts of this driver, here are a few random observed uses
of pointers.

In one place scb is used after testing "if (scb != NULL && some other stuff"
and in another place scb is used without such a test.

In one place ahc_fetch_transinfo is called and resulting pointers are used
without checking for whether it succeeded or not.

I hope it's not something as dumb as
  printf("%s: ", ahc_name(ahc));
with possibly ahc_name producing NULL due to the card having been removed
before being reinserted (or in a more recent kernel, crashing due to being
removed without even needing reinsertion). 

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
