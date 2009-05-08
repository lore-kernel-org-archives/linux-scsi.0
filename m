From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Adaptec driver crashes (3/3)
Date: Fri, 8 May 2009 12:09:05 -0700
Message-ID: <20090508120905.9624e4ad.akpm@linux-foundation.org>
References: <507A39B029A94344AD588481FAAF019A@DIAMOND8600>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764310AbZEHTL4@vger.kernel.org>
In-Reply-To: <507A39B029A94344AD588481FAAF019A@DIAMOND8600>
Sender: linux-kernel-owner@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 6 May 2009 16:13:53 +0900
"Norman Diamond" <n0diamond@yahoo.co.jp> wrote:

> A tougher non-100%-reproducible way to crash a Linux system is as follows.
> 
> I don't remember exactly what I did, but for some reason I guessed it might 
> happen a second time, so I set the console to a text mode terminal before it 
> happened the second time (since Linux doesn't give Blue Screens of Death 
> otherwise).  This is with an Adaptec 1480 card, AIC7xxx driver.
> 
> I wish I had a wooden table so I wouldn't have to read and type this stuff 
> back in by hand.  (In case anyone here doesn't read thedailywtf, ignore the 
> part about the wooden table.  I still wish I wouldn't have to read and type 
> this stuff back in by hand.) 
> 
> BUG: unable to handle kernel NULL pointer dereference at virtual address 0000000
> 0
> printing eip: c04a50af *pde = 00000000
> Oops: 0000 [#1] SMP
> Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_
> device snd_pcm_oss snd_mixer_oss fuse lp pcspkr snd_intel8x0 snd_ac97_codec ac97
> _bus e100 snd_pcm snd_timer snd video mii iTCO_wdt soundcore serio_raw iTCO_vend
> or_support output psmouse evdev pcmcia intel_agp agpgart shpchp snd_page_alloc p
> arport_pc parport sg yenta_socket rsrc_nonstatic pcmcia_core aufs squashfs sqlzm
> a unlzma
> 
> Pid: 3531, comm: klogs Not tainted (2.6.24.3 #1)
> EIP: 0060:[<c04a50af>] EFLAGS: 00010046 CPU: 0
> EIP is at ahc_handle_scsiint+0xdbf/0xef0
> EAX: 00000000 EBX: 00000007 ECX: 00000001 EDX: 0000000d
> ESI: ede17e00 EDI: 00000000 EBP: 00000000 ESP: ed507de4
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process klogd (pid: 3531, ti=ed506000 task=edd6aaa0 task.ti=ed506000)
> Stack: 00000001 00000041 00000001 ee6a6580 d662d853 41410000 000000a0 ead93024
>        c01806db 00a0ee08 00000041 00000007 00000000 00000001 00000000 00000000
>        ed53b541 00000001 ede17e00 00000064 00000082 0000000b c04b20f9 ede0cd60
> Call Trace:
>  [<c01806db>] __link_path_walk+0xaab/0xe10
>  [<c04b20f9>] ahc_linux_isr+0x1e9/0x260
>  [<c0151025>] handle_IRQ_event+0x25/0x50
>  [<c01529bc>] handle_level_irq+0x7c/0xf0
>  [<c010748b>] do_IRQ+0x3b/0x70
>  [<efbe3d90>] aufs_getattr+0x0/0xa0 [aufs]
>  [<c01052d3>] common_interrupt+0x23/0x30
>  [<efbe3d90>] aufs_getattr+0x0/0xa0 [aufs]
>  [<efbe3d9e>] aufs_getattr+0xe/0xa0 [aufs]
>  [<c017fa47>] getname+0xa7/0xc0
>  [<c03b7acf>] security_inode_getattr+0x1f/0x30
>  [<c017a4f8>] vfs_getattr+0x48/0x70
>  [<c017a727>] vfs_stat_fd+0x37/0x60
>  [<c017a82f>] sys_stat64+0xf/0x30
>  [<c01775ee>] vfs_write+0x11e/0x140
>  [<c0177c31>] sys_write+0x41/0x70
>  [<c012cc1a>] sys_time+0xa/0x30
>  [<c0104352>] syscall_call+0x7/0xb
>  [<c0700000>] rpcb_getport_prepare+0x10/0x40
>  =======================
> Code: 24 2c e8 c5 95 ff ff b9 14 00 00 00 89 f0 8d 54 24 2c c7 44 24 04 00 00 00
>  00 c7 04 24 b6 d1 80 c0 e8 56 e9 ff ff e9 8d f8 ff ff <8b> 07 89 fa 0f b6 58 1b
>  0f b6 c3 89 44 24 1c 89 f0 e8 5b a5 00
> EIP: [<c04a50af>] ahc_handle_scsiint+0xdbf/0xef0 SS:ESP 0068:ed507de4

ahc_handle_scsiint() is a huge function.  It would help if we can find
the file and line where it is crashing.  If you could do the following,
please.

- Run a more recent kernel: we might have fixed it since 2.6.24!

- Enable CONFIG_DEBUG_INFO

- Reproduce the crash and note the EIP address (c04a50af in this example).

- In your kernel build source directory, do

gdb vmlinux
(gdb) l *0xc04a50af

  (with a suitable value of c04a50af)

Alternatively, try doing this with your current 2.6.24 setup.

Alternatively, see if you can get the poorly-documented
scripts/markup_oops.pl to work.
