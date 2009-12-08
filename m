From: Jan Kara <jack@suse.cz>
Subject: Re: Possible irq lock inversion dependency detected in JBD
Date: Tue, 8 Dec 2009 17:52:42 +0100
Message-ID: <20091208165241.GD4095@quack.suse.de>
References: <4B0BD960.5040105@vlnb.net>
 <20091208151332.GA3141@atrey.karlin.mff.cuni.cz>
 <4B1E7233.1040904@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42939 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756025AbZLHQwl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2009 11:52:41 -0500
Content-Disposition: inline
In-Reply-To: <4B1E7233.1040904@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue 08-12-09 18:35:15, Vladislav Bolkhovitin wrote:
> Jan Kara, on 12/08/2009 06:13 PM wrote:
> >   Hello,
> > 
> >> During testing I had the below trace from lockdep. After some googling seems
> >> it wasn't reported. The complete trace attached, it's almost 800K uncompressed.
> >>
> >> =========================================================
> >> [ INFO: possible irq lock inversion dependency detected ]
> >> 2.6.31-scst-dbg #3
> >> ---------------------------------------------------------
> >> kswapd0/290 just changed the state of lock:
> >>  (jbd_handle){+.+.-.}, at: [<7826a6fa>] journal_start+0xd4/0x13a
> >> but this lock took another, RECLAIM_FS-unsafe lock in the past:
> >>  (&type->s_lock_key){+.+.+.}
> >>
> >> and interrupts could create inverse lock ordering between them.
> >>
> >>
> >> other info that might help us debug this:
> >> no locks held by kswapd0/290.
> >   Thanks for the report. If I'm reading the lockdep messages right, it
> > complains that page reclaim can be run with sb->s_lock held but we also
> > start a transaction in the page reclaim path and we take sb->s_lock after
> > starting a transaction in some paths.
> >   The warning seems to be false positive to me since we don't really
> > acquire sb->s_lock in the reclaim path. It would be nice if we could
> > get this sorted out but I don't see an easy way out of this...
> 
> In my experience lockdep has never complained about acquiring a lock, where
> it had never been acquired, so I would rather take the complaint seriously.
> However, a false possitive can be if the same lock acquired for another object.
> I have swap as a file on a different ext3 partition.
  Well, I take lockdep warning seriously. It's just that lockdep
establishes following lock dependencies:
1) transaction start -> lock_super
  - happens only during unlink, truncate, filesystem resize, sys_write
2) lock_super -> page reclaim
  - happens during mount / remount
3) page reclaim -> transaction start

  and reports a possible problem. But it follows from the above that
lock_super actually does not happen from the page reclaim path because
there we just start a transaction to write inode or allocate blocks to a
file. So I agree the locking is kind of convoluted but I see no real
problem there...
  
> From other side, during further tests I yesterday had the following lockup.
> It seems to be somehow related. 2.6.29 works just fine.
  Looks like a bug in the scsi stack... adding linux-scsi to CC.

									Honza

> [ 8298.566616] BUG: spinlock lockup on CPU#0, xfsbufd/2726, f6b52e58
> [ 8298.566632] NMI backtrace for cpu 1
> [ 8298.566632] ------------[ cut here ]------------
> [ 8298.566632] WARNING: at kernel/sched.c:5175 add_preempt_count+0x82/0xdd()
> [ 8298.566632] Hardware name: X5DPA
> [ 8298.566632] Modules linked in: iscsi_scst scst_user scst_disk scst_vdisk scst libcrc32c cryptomgr aead pcompress crypto_blkcipher crc32c crypto_hash crypto_algapi tcp_highspeed scsi_debug w83627hf hwmon_vid adm1021 binfmt_misc xfs exportfs dm_mirror dm_region_hash dm_log dm_mod pci_slot floppy uhci_hcd sg e1000 ata_generic pcspkr i2c_i801 libata i2c_core e7xxx_edac parport_pc parport [last unloaded: scst]
> [ 8298.566632] Pid: 14244, comm: vdisk_fileid2_7 Not tainted 2.6.31-scst-dbg #3
> [ 8298.566632] Call Trace:
> [ 8298.566632]  [<78497768>] ? printk+0x28/0x40
> [ 8298.566632]  [<7849e2a5>] ? add_preempt_count+0x82/0xdd
> [ 8298.566632]  [<78140225>] warn_slowpath_common+0x7e/0xda
> [ 8298.566632]  [<7849e2a5>] ? add_preempt_count+0x82/0xdd
> [ 8298.566632]  [<781402a7>] warn_slowpath_null+0x26/0x3c
> [ 8298.566632]  [<7849e2a5>] add_preempt_count+0x82/0xdd
> [ 8298.566632]  [<7849ae42>] _spin_lock_irqsave+0x2d/0x9a
> [ 8298.566632]  [<78160551>] down_trylock+0x21/0x54
> [ 8298.566632]  [<781407f5>] try_acquire_console_sem+0x20/0x6e
> [ 8298.566632]  [<78140fe1>] vprintk+0x114/0x427
> [ 8298.566632]  [<78497768>] printk+0x28/0x40
> [ 8298.566632]  [<7849cef8>] nmi_watchdog_tick+0x1e3/0x20b
> [ 8298.566632]  [<7849c03d>] do_nmi+0x18e/0x33a
> [ 8298.566632]  [<7849bcc4>] nmi_stack_correct+0x2f/0x34
> [ 8298.566632]  [<781700e0>] ? check_irq_usage+0x31/0xda
> [ 8298.566632]  [<781586c6>] ? __kernel_text_address+0x21/0x80
> [ 8298.566632]  [<781070c3>] print_context_stack+0x82/0x13f
> [ 8298.566632]  [<78105e75>] dump_trace+0xa1/0xfb
> [ 8298.566632]  [<7810e0e2>] save_stack_trace+0x3b/0x68
> [ 8298.566632]  [<782c1fb9>] dma_entry_alloc+0x79/0xb7
> [ 8298.566632]  [<782c33bb>] debug_dma_map_sg+0x4a/0x167
> [ 8298.566632]  [<78357de5>] scsi_dma_map+0xc9/0x104
> [ 8298.566632]  [<78372c98>] ahd_linux_queue+0x48/0x39a
> [ 8298.566632]  [<7849ae94>] ? _spin_lock_irqsave+0x7f/0x9a
> [ 8298.566632]  [<7834f218>] ? scsi_dispatch_cmd+0x106/0x275
> [ 8298.566632]  [<7834f25d>] scsi_dispatch_cmd+0x14b/0x275
> [ 8298.566632]  [<7849e1ea>] ? sub_preempt_count+0x9a/0xd3
> [ 8298.566632]  [<78355e0a>] scsi_request_fn+0x398/0x4de
> [ 8298.566632]  [<7828acc0>] __generic_unplug_device+0x3e/0x5b
> [ 8298.566632]  [<7828343d>] elv_insert+0x208/0x272
> [ 8298.566632]  [<781928b4>] ? __rcu_read_unlock+0x9b/0xac
> [ 8298.566632]  [<78283520>] __elv_add_request+0x79/0xc7
> [ 8298.566632]  [<7828f242>] __make_request+0x12d/0x412
> [ 8298.566632]  [<7828e116>] generic_make_request+0x42c/0x5f8
> [ 8298.566632]  [<7849e1ea>] ? sub_preempt_count+0x9a/0xd3
> [ 8298.566632]  [<78170b60>] ? trace_hardirqs_on+0x19/0x2e
> [ 8298.566632]  [<781c3db7>] ? mempool_alloc_slab+0x22/0x38
> [ 8298.566632]  [<781c3db7>] ? mempool_alloc_slab+0x22/0x38
> [ 8298.566632]  [<781c3db7>] ? mempool_alloc_slab+0x22/0x38
> [ 8298.566632]  [<7828f9c6>] submit_bio+0x9b/0x155
> [ 8298.566632]  [<78219f94>] submit_bh+0x106/0x14a
> [ 8298.566632]  [<7821c0d8>] __block_write_full_page+0x222/0x394
> [ 8298.566632]  [<7821c73d>] ? end_buffer_async_write+0x0/0x238
> [ 8298.566632]  [<7821ce27>] block_write_full_page_endio+0x133/0x13d
> [ 8298.566632]  [<7821c73d>] ? end_buffer_async_write+0x0/0x238
> [ 8298.566632]  [<7821c73d>] ? end_buffer_async_write+0x0/0x238
> [ 8298.566632]  [<7821ce55>] block_write_full_page+0x24/0x3c
> [ 8298.566632]  [<7821c73d>] ? end_buffer_async_write+0x0/0x238
> [ 8298.566632]  [<78257228>] ext3_writeback_writepage+0x109/0x13f
> [ 8298.566632]  [<782565c6>] ? buffer_unmapped+0x0/0x34
> [ 8298.566632]  [<781ce157>] shrink_page_list+0x64a/0x7cb
> [ 8298.566632]  [<7849780b>] ? io_schedule_timeout+0x8b/0xc0
> [ 8298.566632]  [<781d7d49>] ? congestion_wait+0x72/0x8d
> [ 8298.566632]  [<781ced02>] shrink_zone+0xa2a/0xa6f
> [ 8298.566632]  [<781cd56e>] ? shrink_slab+0x171/0x1b8
> [ 8298.566632]  [<7815fe6f>] ? up_read+0x29/0x5a
> [ 8298.566632]  [<781cf57e>] try_to_free_pages+0x212/0x364
> [ 8298.566632]  [<781cc7ed>] ? isolate_pages_global+0x0/0x1fa
> [ 8298.566632]  [<781c7acd>] __alloc_pages_nodemask+0x3bb/0x5db
> [ 8298.566632]  [<781707fb>] ? mark_held_locks+0x6a/0x9a
> [ 8298.566632]  [<781ee2c6>] __slab_alloc+0x1b9/0x5d3
> [ 8298.566632]  [<783d6db9>] ? __alloc_skb+0x39/0x13b
> [ 8298.566632]  [<781ee873>] kmem_cache_alloc+0x193/0x19f
> [ 8298.566632]  [<783d6db9>] ? __alloc_skb+0x39/0x13b
> [ 8298.566632]  [<783d6db9>] ? __alloc_skb+0x39/0x13b
> [ 8298.566632]  [<783d6db9>] __alloc_skb+0x39/0x13b
> [ 8298.566632]  [<783d2ec7>] ? lock_sock_nested+0xd5/0xee
> [ 8298.566632]  [<784144d1>] sk_stream_alloc_skb+0x3f/0xf0
> [ 8298.566632]  [<78417007>] tcp_sendmsg+0x402/0x99b
> [ 8298.566632]  [<781099cf>] ? sched_clock+0x1e/0x80
> [ 8298.566632]  [<7840dfef>] ? ip_finish_output+0x14c/0x310
> [ 8298.566632]  [<783cf1f8>] sock_aio_write+0x10f/0x129
> [ 8298.566632]  [<781099cf>] ? sched_clock+0x1e/0x80
> [ 8298.566632]  [<783cf0e9>] ? sock_aio_write+0x0/0x129
> [ 8298.566632]  [<781f46d8>] do_sync_readv_writev+0xdb/0x125
> [ 8298.566632]  [<7815b03d>] ? autoremove_wake_function+0x0/0x5b
> [ 8298.566632]  [<781f44ee>] ? rw_copy_check_uvector+0x80/0x12f
> [ 8298.566632]  [<781f5692>] do_readv_writev+0xb8/0x229
> [ 8298.566632]  [<783cf0e9>] ? sock_aio_write+0x0/0x129
> [ 8298.566632]  [<7814811a>] ? local_bh_enable_ip+0x75/0xfb
> [ 8298.566632]  [<78170af9>] ? trace_hardirqs_on_caller+0x13a/0x188
> [ 8298.566632]  [<ffde4a78>] ? write_data+0xce/0xabf [iscsi_scst]
> [ 8298.566632]  [<781f5862>] vfs_writev+0x5f/0x77
> [ 8298.566632]  [<ffde4b48>] write_data+0x19e/0xabf [iscsi_scst]
> [ 8298.566632]  [<7816ee05>] ? put_lock_stats+0x18/0x45
> [ 8298.566632]  [<78170313>] ? lock_release_holdtime+0xaa/0x175
> [ 8298.566632]  [<ffddd309>] ? cmnd_set_sn+0x6f/0xa6 [iscsi_scst]
> [ 8298.566632]  [<ffde5b3f>] iscsi_do_send+0x2a/0x63 [iscsi_scst]
> [ 8298.566632]  [<ffde5f2e>] iscsi_send+0x1ca/0x359 [iscsi_scst]
> [ 8298.566632]  [<7814811a>] ? local_bh_enable_ip+0x75/0xfb
> [ 8298.566632]  [<ffddd542>] iscsi_try_local_processing+0x15c/0x1bd [iscsi_scst]
> [ 8298.566632]  [<ffde133f>] iscsi_xmit_response+0x197/0x328 [iscsi_scst]
> [ 8298.566632]  [<7816ee05>] ? put_lock_stats+0x18/0x45
> [ 8298.566632]  [<78170313>] ? lock_release_holdtime+0xaa/0x175
> [ 8298.566632]  [<f90ef48c>] scst_xmit_response+0x139/0x4ab [scst]
> [ 8298.566632]  [<f90f12e5>] ? scst_pre_xmit_response+0xb0/0x274 [scst]
> [ 8298.566632]  [<78170b60>] ? trace_hardirqs_on+0x19/0x2e
> [ 8298.566632]  [<f90f356a>] scst_process_active_cmd+0x176/0x536 [scst]
> [ 8298.566632]  [<f90ed88d>] ? scst_cmd_atomic+0x62/0xa3 [scst]
> [ 8298.566632]  [<f90f3fc5>] scst_process_redirect_cmd+0x1b0/0x298 [scst]
> [ 8298.566632]  [<f90f42b8>] scst_cmd_done_local+0xff/0x257 [scst]
> [ 8298.566632]  [<f8e3447e>] vdisk_do_job+0x1f9/0xae2 [scst_vdisk]
> [ 8298.566632]  [<78133a93>] ? finish_task_switch+0x69/0x105
> [ 8298.566632]  [<f90ed88d>] ? scst_cmd_atomic+0x62/0xa3 [scst]
> [ 8298.566632]  [<f90f2a73>] scst_do_real_exec+0xbb/0x3fa [scst]
> [ 8298.566632]  [<f90f2781>] ? scst_do_local_exec+0x143/0x23a [scst]
> [ 8298.566632]  [<f90f2e82>] scst_exec+0xd0/0x25e [scst]
> [ 8298.566632]  [<ffddd3a5>] ? scst_cmd_atomic+0x65/0xa6 [iscsi_scst]
> [ 8298.566632]  [<f90f3150>] scst_send_for_exec+0x140/0x2a5 [scst]
> [ 8298.566632]  [<f90ed67c>] ? scst_tgt_pre_exec+0x77/0x226 [scst]
> [ 8298.566632]  [<f90f37a9>] scst_process_active_cmd+0x3b5/0x536 [scst]
> [ 8298.566632]  [<7849e1ea>] ? sub_preempt_count+0x9a/0xd3
> [ 8298.566632]  [<f90f39ba>] scst_do_job_active+0x90/0x158 [scst]
> [ 8298.566632]  [<f90f3c22>] scst_cmd_thread+0xc1/0x279 [scst]
> [ 8298.566632]  [<7849b855>] ? _spin_unlock_irqrestore+0x8b/0x90
> [ 8298.566632]  [<7813b430>] ? default_wake_function+0x0/0x3d
> [ 8298.566632]  [<f90f3b61>] ? scst_cmd_thread+0x0/0x279 [scst]
> [ 8298.566632]  [<7815ac79>] kthread+0x84/0x8d
> [ 8298.566632]  [<7815abf5>] ? kthread+0x0/0x8d
> [ 8298.566632]  [<78103f57>] kernel_thread_helper+0x7/0x10
> 
> Thanks,
> Vlad
> 
