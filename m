From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 7667] New: BUG at drivers/scsi/scsi_lib.c:1118
 caused by "pktsetup dvd /dev/sr0"
Date: Mon, 11 Dec 2006 14:10:29 -0800
Message-ID: <20061211141029.9a0b0376.akpm@osdl.org>
References: <200612112159.kBBLxmep005850@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:42227 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763140AbWLKWOC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Dec 2006 17:14:02 -0500
In-Reply-To: <200612112159.kBBLxmep005850@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Peter Osterlund <petero2@telia.com>
Cc: linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, laurent.riffard@free.fr, Adrian Bunk <bunk@stusta.de>

On Mon, 11 Dec 2006 13:59:48 -0800
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7667
> 
>            Summary: BUG at drivers/scsi/scsi_lib.c:1118 caused by "pktsetup
>                     dvd /dev/sr0"
>     Kernel Version: 2.6.19-rc6-mm2, 2.6.19-git*
>             Status: NEW
>           Severity: normal
>              Owner: scsi_drivers-other@kernel-bugs.osdl.org
>          Submitter: laurent.riffard@free.fr
> 
> 
> Most recent kernel where this bug did *NOT* occur: 2.6.19
> 
> Distribution: Mandriva Linux release 2007.0 (Official) for i586
> 
> Hardware Environment: Desktop
>   Motherboard: Asus A7V133-C,
>   Processor: AMD Athlon XP 1600+,
>   IDE DVD-burner: HL-DT-ST DVDRAM GSA-4165B 
> 
> Software Environment:
>   Relevant kernel modules: pata_via, scsi_mod, sr_mod, sd_mod, libata, pktcdvd
>   Userspace tools: udftools-1.0.0-0.b3.10mdv2007.0 
> 
> Problem Description: The kernel BUGs when I issue "pktsetup dvd /dev/sr0"
> 
> pktcdvd: writer pktcdvd0 mapped to sr0
> ------------[ cut here ]------------
> kernel BUG at drivers/scsi/scsi_lib.c:1118!
> invalid opcode: 0000 [#1]
> Modules linked in: pktcdvd snd_seq_oss snd_seq_midi_event snd_seq bonding
> snd_pcm_oss snd_mixer_oss af_packet snd_ens1371 gameport snd_rawmidi snd_seq_device
>  snd_ac97_codec snd_ac97_bus snd_pcm via686a snd_timer snd_page_alloc w83781d
> snd soundcore hwmon_vid i2c_isa i2c_viapro binfmt_misc loop nls_iso8859_15 nls_
> cp850 vfat fat reiserfs via_agp agpgart lp parport_pc parport 8250 serial_core
> pcspkr rtc ohci1394 ieee1394 uhci_hcd usbcore sr_mod cdrom dm_mirror dm_mod sd
> _mod pata_via libata scsi_mod
> CPU:    0
> EIP:    0060:[<e0833017>]    Not tainted VLI
> EFLAGS: 00010002   (2.6.19-gaf1713e0 #5)
> EIP is at scsi_prep_fn+0x10b/0x24f [scsi_mod]
> eax: c15f9c34   ebx: dfc00be4   ecx: dfc39628   edx: c15f9c34
> esi: dfc39598   edi: c15f7448   ebp: c156daf0   esp: c156dad0
> ds: 007b   es: 007b   ss: 0068
> Process vol_id (pid: 2099, ti=c156c000 task=dff6a570 task.ti=c156c000)
> Stack: 00011200 c1479de0 00000833 c15f9c34 c15f7448 c15f9c34 c15f7448 c15f7448 
>        c156db14 c019ed65 dfc23d28 dfc39690 c156db0c c15f9c34 dfc39598 dfc34000 
>        c15f7448 c156db44 e08335db 00000082 00000082 c15f7448 dfc39628 c01a1465 
> Call Trace:
>  [<c0103a92>] show_trace_log_lvl+0x1a/0x2f
>  [<c0103b42>] show_stack_log_lvl+0x9b/0xa3
>  [<c0103cdc>] show_registers+0x192/0x268
>  [<c0103e9c>] die+0xea/0x1bd
>  [<c0103fe8>] do_trap+0x79/0x91
>  [<c01047c6>] do_invalid_op+0x97/0xa1
>  [<c027fac4>] error_code+0x74/0x7c
>  [<c019ed65>] elv_next_request+0x6b/0x116
>  [<e08335db>] scsi_request_fn+0x5e/0x26d [scsi_mod]
>  [<c019ee6a>] elv_insert+0x5a/0x134
>  [<c019efc1>] __elv_add_request+0x7d/0x82
>  [<c019f0ab>] elv_add_request+0x16/0x1d
>  [<e0e8d2ed>] pkt_generic_packet+0x107/0x133 [pktcdvd]
>  [<e0e8d772>] pkt_get_disc_info+0x42/0x7b [pktcdvd]
>  [<e0e8eae3>] pkt_open+0xbf/0xc56 [pktcdvd]
>  [<c0168078>] do_open+0x7e/0x246
>  [<c01683df>] blkdev_open+0x28/0x51
>  [<c014a057>] __dentry_open+0xb5/0x160
>  [<c014a183>] nameidata_to_filp+0x27/0x37
>  [<c014a1c6>] do_filp_open+0x33/0x3b
>  [<c014a211>] do_sys_open+0x43/0xc7
>  [<c014a2cd>] sys_open+0x1c/0x1e
>  [<c0102b82>] sysenter_past_esp+0x5f/0x85
>  =======================
> Code: 74 1d 66 83 78 60 00 75 04 0f 0b eb fe 89 d8 e8 3d fe ff ff 85 c0 89 c7 74
> 43 e9 00 01 00 00 8b 55 ec 83 ba 90 00 00 00 00 74 04 <0f> 0b eb fe 8b 45 ec
>  83 b8 98 00 00 00 00 74 04 0f 0b eb fe c7 
> EIP: [<e0833017>] scsi_prep_fn+0x10b/0x24f [scsi_mod] SS:ESP 0068:c156dad0
> 
> 
> Steps to reproduce:
> - load an UDF-formatted DVD-RW
> - issue "modprobe pktcdvd"
> - issue "pktsetup dvd /dev/sr0"
> 
> Notes:
> 
> I did a git-bisect, which gave this result:
>   commit b00315799d78f76531b71435fbc2643cd71ae4c
> (http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3b00315799d78f76531b71435fbc2643cd71ae4c)
>   Author: Christoph Hellwig <hch@lst.de>
>   Date:   Sat Nov 4 20:10:55 2006 +0100
>   [SCSI] untangle scsi_prep_fn
> 

