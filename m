From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Linux-usb-users] Major problems with USB Mass-Storage
Date: Thu, 19 Aug 2004 16:38:00 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0408191630110.2106-100000@ida.rowland.org>
References: <4124EDBA.7010608@verizon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:30980 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S267382AbUHSUiB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 16:38:01 -0400
In-Reply-To: <4124EDBA.7010608@verizon.net>
List-Id: linux-scsi@vger.kernel.org
To: "Mike R." <turbanator1@verizon.net>
Cc: USB users list <linux-usb-users@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 19 Aug 2004, Mike R. wrote:

> I also saw this just now. The device mounted, then when I tried to ls 
> and then umount:

So you were able to mount it!  Before you said that you got the same old 
errors when you tried to mount the drive.

> sr0: CDROM (ioctl) error, command: 0x5a 00 2c 00 00 00 00 00 10 00
> sr: sense =  0  0
> Non-extended sense class 0 code 0x0
> Raw sense data:0x00 0x00 0x00 0x00
> ISO 9660 Extensions: RRIP_1991A
> SCSI error : <0 0 0 0> return code = 0x70000
> end_request: I/O error, dev sr0, sector 96

> usb 1-2: USB disconnect, address 2
> usb 1-2: usb_disable_device nuking all URBs
> usb 1-2: unregistering interface 1-2:2.0
> usb 1-2: unregistering device

> scsi0 (0:0): rejecting I/O to dead device
> scsi0 (0:0): rejecting I/O to dead device
> scsi0 (0:0): rejecting I/O to dead device
> scsi0 (0:0): rejecting I/O to dead device
> scsi0 (0:0): rejecting I/O to dead device
> scsi0 (0:0): rejecting I/O to dead device
> scsi0 (0:0): rejecting I/O to dead device
> scsi0 (0:0): rejecting I/O to dead device
> scsi0 (0:0): rejecting I/O to dead device
> SCSI error: host 0 id 0 lun 0 return code = 4000000
>          Sense class 0, sense error 0, extended sense 0
> Unable to handle kernel paging request at virtual address 6e697463
>   printing eip:
> c01f509f
> *pde = 00000000
> Oops: 0000 [#1]
> PREEMPT
> Modules linked in: snd_pcm_oss snd_mixer_oss snd_emu10k1 snd_rawmidi 
> snd_pcm snd_timer snd_seq_device snd_ac97_codec snd_page_alloc 
> snd_util_mem snd_hwdep snd nvidia
> CPU:    0
> EIP:    0060:[<c01f509f>]    Tainted: P
> EFLAGS: 00210047   (2.6.8.1)
> EIP is at as_insert_request+0x8f/0x180
> eax: 6e697463   ebx: d7c122c0   ecx: 00000001   edx: 00000000
> esi: d7c89cb0   edi: 00000000   ebp: 00000000   esp: c9a94d5c
> ds: 007b   es: 007b   ss: 0068
> Process umount (pid: 1399, threadinfo=c9a94000 task=cb82a170)
> Stack: 00200082 c9a94d88 00200082 c0316818 d7c4102c d7c89cb0 00000001 
> 00200202
>         c01ec955 d7c4102c d7c89cb0 00000001 d7c89cb0 00000001 d7c4102c 
> c01ef147
>         d7c4102c d7c89cb0 00000001 00000000 c9a94df4 d7c89c00 c0327fa0 
> c9a94eb4
> Call Trace:
>   [<c01ec955>] __elv_add_request+0x45/0xb0
>   [<c01ef147>] blk_insert_request+0x77/0xe0
>   [<c0222398>] scsi_insert_special_req+0x38/0x40
>   [<c0222608>] scsi_wait_req+0x68/0xa0
>   [<c0222510>] scsi_wait_done+0x0/0x90
>   [<c022a152>] sr_do_ioctl+0x92/0x2a0
>   [<c0229e45>] sr_packet+0x25/0x40
>   [<c022fa85>] cdrom_get_disc_info+0x65/0xc0
>   [<c022b98b>] cdrom_mrw_exit+0x1b/0x70
>   [<c022b574>] unregister_cdrom+0x94/0xe0
>   [<c0229ea2>] sr_kref_release+0x42/0x70
>   [<c01ca9a8>] kref_put+0x18/0x20
>   [<c02293c9>] sr_block_release+0x69/0x80
>   [<c015326a>] blkdev_put+0x17a/0x1a0
>   [<c0150d3b>] deactivate_super+0x5b/0x90
>   [<c016755f>] sys_umount+0x3f/0xa0
>   [<c013f066>] do_munmap+0x146/0x190
>   [<c01675d5>] sys_oldumount+0x15/0x20
>   [<c010405b>] syscall_call+0x7/0xb
> Code: 8b 10 89 72 04 89 16 89 46 04 89 30 90 8d 74 26 00 89 74 24
>   <6>note: umount[1399] exited with preempt_count 2
> bad: scheduling while atomic!
>   [<c02cbd95>] schedule+0x4c5/0x4d0
>   [<c013afa3>] unmap_page_range+0x53/0x80
>   [<c013b186>] unmap_vmas+0x1b6/0x1d0
>   [<c013f3ed>] exit_mmap+0x7d/0x160
>   [<c0112dd5>] mmput+0x65/0x90
>   [<c0116ff2>] do_exit+0x152/0x410
>   [<c010fc30>] do_page_fault+0x0/0x56d
>   [<c0104929>] die+0xf9/0x100
>   [<c010fe0e>] do_page_fault+0x1de/0x56d
>   [<c014bba3>] wake_up_buffer+0x13/0x40
>   [<c019021d>] do_get_write_access+0x26d/0x610

Maybe some people on the SCSI development list can look into this problem.

Alan Stern

