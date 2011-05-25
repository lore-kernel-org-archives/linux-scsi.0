From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: __elv_add_request OOPS
Date: Wed, 25 May 2011 15:26:10 -0500
Message-ID: <1306355170.1641.57.camel@mulgrave.site>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar>
	 <4DDB8BF6.2000304@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DDB8BF6.2000304@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Parag Warudkar <parag.lkml@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2011-05-24 at 12:44 +0200, Jens Axboe wrote:
> On 2011-05-24 06:29, Parag Warudkar wrote:
> > 
> > External DVD drive - connected when suspended, removed before resume.
> > Results in NULL pointer dereference in __blk_add_request on resume.
> > 
> > *ffffffff811d6503:      48 89 58 08             mov    %rbx,0x8(%rax) |
> > %ebx = ffff880131559020 <--- faulting instruction
> > 
> > 48 89 58 08 appears only in list_add :
> > 
> > static inline void list_add(struct list_head *new, struct list_head *head)
> > {
> >         __list_add(new, head, head->next);
> > ffffffff81ac012c:       49 8b 04 24             mov    (%r12),%rax
> > #ifndef CONFIG_DEBUG_LIST
> > static inline void __list_add(struct list_head *new,
> >                               struct list_head *prev,
> >                               struct list_head *next)
> > {
> >         next->prev = new;
> > ffffffff81ac0130:       48 89 58 08             mov    %rbx,0x8(%rax)
> > 
> > AFAICS list_add is only called from one place in __elv_add_request :
> > 
> >        switch (where) {
> >         case ELEVATOR_INSERT_REQUEUE:
> >         case ELEVATOR_INSERT_FRONT:
> >                 rq->cmd_flags |= REQ_SOFTBARRIER;
> >               **  list_add(&rq->queuelist, &q->queue_head);
> >                 break;
> > 
> > Now, where is the patch? :)
> 
> You forgot to attach it?
> 
> This is clearly q == NULL, CC'ing James/linux-scsi. Oops left below.

Something strange is going on here.  the q can't have been NULL when we
called blk_get_request() in scsi_execute() otherwise we'd have oopsed on
q->queue_lock, so it's not as simple as sdev->request_queue being NULL.

James


> > [18682.256362] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> > [18682.256535] IP: [<ffffffff811d6503>] __elv_add_request+0x1e3/0x270
> > [18682.256603] PGD 0
> > [18682.256632] Oops: 0002 [#1] SMP
> > [18682.256686] CPU 2
> > [18682.256714] Modules linked in: nls_utf8 udf crc_itu_t usb_storage cryptd aes_x86_64 aes_generic fuse parport_pc ppdev dm_crypt kvm_intel joydev kvm binfmt_misc snd_hda_codec_hdmi snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec iwlagn snd_hwdep snd_pcm mac80211 snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd cfg80211 soundcore btusb uvcvideo snd_page_alloc bluetooth videodev v4l2_compat_ioctl32 psmouse ideapad_laptop serio_raw sparse_keymap lp intel_ips mac_hid parport ext4 mbcache jbd2 i915 ahci libahci libata drm_kms_helper drm i2c_algo_bit cfbcopyarea video cfbimgblt cfbfillrect atl1c
> > [18682.257659]
> > [18682.257685] Pid: 14069, comm: xdg-screensaver Not tainted 2.6.39+ #4 LENOVO 0876                            /Base Board Product Name
> > [18682.257845] RIP: 0010:[<ffffffff811d6503>]  [<ffffffff811d6503>] __elv_add_request+0x1e3/0x270
> > [18682.257964] RSP: 0018:ffff88009b3a19e8  EFLAGS: 00010006
> > [18682.258056] RAX: 0000000000000000 RBX: ffff880131559020 RCX: 0000000000000001
> > [18682.258152] RDX: 0000000000000001 RSI: ffff880131559020 RDI: ffff8801315f77d0
> > [18682.258248] RBP: ffff88009b3a1a08 R08: ffffffff811e1000 R09: ffff8801315f77d0
> > [18682.258343] R10: ffff8800b5085e40 R11: ffff8800b5085e40 R12: ffff8801315f77d0
> > [18682.258437] R13: 0000000000000001 R14: 0000000000000001 R15: ffff8800b5085e40
> > [18682.258529] FS:  0000000000000000(0000) GS:ffff880137c80000(0000) knlGS:0000000000000000
> > [18682.258636] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [18682.258712] CR2: 0000000000000008 CR3: 0000000001a03000 CR4: 00000000000006e0
> > [18682.258807] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [18682.258898] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [18682.258994] Process xdg-screensaver (pid: 14069, threadinfo ffff88009b3a0000, task ffff8800aff096b0)
> > [18682.259112] Stack:
> > [18682.259140]  ffff8801315f77d0 ffff880131559020 0000000000000001 ffff88009b3a1c48
> > [18682.259249]  ffff88009b3a1a38 ffffffff811e10a0 0000000000000000 ffff88009b3a1a48
> > [18682.259354]  ffff880131559020 0000000000000000 ffff88009b3a1af8 ffffffff811e118e
> > [18682.259460] Call Trace:
> > [18682.259504]  [<ffffffff811e10a0>] blk_execute_rq_nowait+0x60/0xc0
> > [18682.259587]  [<ffffffff811e118e>] blk_execute_rq+0x8e/0x130
> > [18682.259668]  [<ffffffff812db5bc>] scsi_execute+0xfc/0x160
> > [18682.259742]  [<ffffffff812dc18f>] scsi_execute_req+0xbf/0x130
> > [18682.259821]  [<ffffffff812d5c71>] ioctl_internal_command.clone.4+0x61/0x1b0
> > [18682.259914]  [<ffffffff812d5e3e>] scsi_set_medium_removal+0x7e/0xb0
> > [18682.260000]  [<ffffffff812ecfa0>] sr_lock_door+0x20/0x30
> > [18682.260075]  [<ffffffff812f9da7>] cdrom_release+0x147/0x270
> > [18682.260153]  [<ffffffff812ebac8>] sr_block_release+0x38/0x60
> > [18682.260233]  [<ffffffff811730ac>] __blkdev_put+0x16c/0x1b0
> > [18682.260308]  [<ffffffff81173129>] blkdev_put+0x39/0x150
> > [18682.260379]  [<ffffffff81173264>] blkdev_close+0x24/0x30
> > [18682.260455]  [<ffffffff81140fba>] fput+0xea/0x220
> > [18682.260521]  [<ffffffff8113d396>] filp_close+0x66/0x90
> > [18682.260592]  [<ffffffff8105c117>] put_files_struct+0x87/0xf0
> > [18682.260668]  [<ffffffff8105c244>] exit_files+0x54/0x70
> > [18682.264275]  [<ffffffff8105c72b>] do_exit+0x16b/0x860
> > [18682.267802]  [<ffffffff811f6c2a>] ? trace_hardirqs_off_thunk+0x3a/0x6c
> > [18682.271512]  [<ffffffff8105d0e8>] do_group_exit+0x58/0xd0
> > [18682.276948]  [<ffffffff8105d177>] sys_exit_group+0x17/0x20
> > [18682.281121]  [<ffffffff81485d42>] system_call_fastpath+0x16/0x1b
> > [18682.284603] Code: ff ff e9 90 fe ff ff 90 81 4b 40 00 08 00 00 48 89 df e8 c1 93 00 00 eb c1 0f 1f 80 00 00 00 00 81 4b 40 00 08 00 00 49 8b 04 24
> > [18682.284903]  89 58 08 48 89 03 4c 89 63 08 49 89 1c 24 eb 9e 0f 1f 40 00
> > [18682.290727] RIP  [<ffffffff811d6503>] __elv_add_request+0x1e3/0x270
> > [18682.293189]  RSP <ffff88009b3a19e8>
> > [18682.296075] CR2: 0000000000000008
> > [18682.358582] ---[ end trace 82dd699fdeb50b72 ]---
> 
