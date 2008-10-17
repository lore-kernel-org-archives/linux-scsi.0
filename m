From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG] linux-next: Tree for October 16 - softlockup detected at
	blk_invoke_request_fn
Date: Fri, 17 Oct 2008 15:54:56 +0530
Message-ID: <20081017102456.GA8115@linux.vnet.ibm.com>
References: <20081016211811.a523c8f2.sfr@canb.auug.org.au> <20081016204212.GC7534@linux.vnet.ibm.com> <20081017065558.GD19428@kernel.dk>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754800AbYJQK0l@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081017065558.GD19428@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

* Jens Axboe <jens.axboe@oracle.com> [2008-10-17 08:55:59]:

> On Fri, Oct 17 2008, Kamalesh Babulal wrote:
> > Hi Stephen,
> > 
> > 	with the next-20081016 kernel, softlockup is detected while creating ext2 
> > filesystem.
> > 
> > BUG: soft lockup - CPU#3 stuck for 61s! [mkfs.ext2:3399]
> > Modules linked in: nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 acpi_cpufreq dm_mirror dm_log dm_mod video output rfkill input_polldev sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy ide_cd_mod tg3 cdrom libphy serio_raw button i2c_i801 e752x_edac edac_core shpchp i2c_core pcspkr aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
> > Modules linked in: nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 acpi_cpufreq dm_mirror dm_log dm_mod video output rfkill input_polldev sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy ide_cd_mod tg3 cdrom libphy serio_raw button i2c_i801 e752x_edac edac_core shpchp i2c_core pcspkr aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
> > Call Trace:
> >  <IRQ>  [<ffffffff80319770>] blk_invoke_request_fn+0x69/0x109
> >  [<ffffffffa006ffe3>] scsi_run_queue+0x2b5/0x2ba [scsi_mod]
> >  [<ffffffffa00706db>] scsi_next_command+0x2d/0x39 [scsi_mod]
> >  [<ffffffffa007090f>] scsi_end_request+0x86/0x97 [scsi_mod]
> >  [<ffffffffa0071659>] scsi_io_completion+0x1b6/0x3cd [scsi_mod]
> >  [<ffffffff8031d589>] blk_done_softirq+0x5c/0x6b
> >  [<ffffffff8023cb50>] __do_softirq+0x7a/0x13d
> >  [<ffffffff8021f9bd>] ack_apic_level+0x58/0xdc
> >  [<ffffffff8020d09c>] call_softirq+0x1c/0x28
> >  [<ffffffff8020decd>] do_softirq+0x2c/0x68
> >  [<ffffffff8020e1f1>] do_IRQ+0x145/0x168
> >  [<ffffffff8020c356>] ret_from_intr+0x0/0xa
> >  <EOI>  [<ffffffff80261cd5>] audit_syscall_entry+0xb6/0x160
> >  [<ffffffff8020be94>] auditsys+0x19/0x4a
> > ..
> > ..
> > <above call trace was printed 8 times>
> > ..
> > INFO: task kjournald:578 blocked for more than 480 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >  ffff8801e50e1d30 0000000000000046 ffff8801e50e1cf8 ffffffff8031833d
> >  ffff8801e5058c58 ffff8801e7360100 ffff8801e70f3470 ffff8801e7360458
> >  00000001e596c500 00000000fffd66c8 ffffffffffffffff ffffffffffffffff
> > Call Trace:
> >  [<ffffffff8031833d>] elv_next_request+0x155/0x220
> >  [<ffffffff802b26ab>] sync_buffer+0x0/0x3f
> >  [<ffffffff8048f5ee>] io_schedule+0x5d/0x9f
> >  [<ffffffff802b26e6>] sync_buffer+0x3b/0x3f
> >  [<ffffffff8048f849>] __wait_on_bit+0x40/0x6f
> >  [<ffffffff802b26ab>] sync_buffer+0x0/0x3f
> >  [<ffffffff8048f8e4>] out_of_line_wait_on_bit+0x6c/0x78
> >  [<ffffffff80249620>] wake_bit_function+0x0/0x23
> >  [<ffffffffa003125c>] journal_commit_transaction+0x7e4/0xc64 [jbd]
> >  [<ffffffff80240857>] lock_timer_base+0x26/0x4c
> >  [<ffffffffa0033c97>] kjournald+0xc1/0x1fb [jbd]
> >  [<ffffffff802495f2>] autoremove_wake_function+0x0/0x2e
> >  [<ffffffffa0033bd6>] kjournald+0x0/0x1fb [jbd]
> >  [<ffffffff802494c4>] kthread+0x47/0x73
> >  [<ffffffff80234192>] schedule_tail+0x27/0x6e
> >  [<ffffffff8020cd39>] child_rip+0xa/0x11
> >  [<ffffffff8024947d>] kthread+0x0/0x73
> >  [<ffffffff8020cd2f>] child_rip+0x0/0x11
> > INFO: task syslogd:2650 blocked for more than 480 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >  ffff8801e1587da8 0000000000000082 0000000000000000 0000000000000000
> >  00000000003fbfc4 ffff8801e3926fe0 ffff8801e38c6f60 ffff8801e3927338
> >  0000000100000000 ffff8801e59444c0 0000000000000000 0000000000000001
> > Call Trace:
> >  [<ffffffffa0033577>] log_wait_commit+0x9f/0xed [jbd]
> >  [<ffffffff802495f2>] autoremove_wake_function+0x0/0x2e
> >  [<ffffffffa002f4f9>] journal_stop+0x165/0x18d [jbd]
> >  [<ffffffff802adf7b>] __writeback_single_inode+0x17f/0x282
> >  [<ffffffff802948d9>] do_readv_writev+0x176/0x18b
> >  [<ffffffff802ae867>] sync_inode+0x24/0x31
> >  [<ffffffffa00463ba>] ext3_sync_file+0x9e/0xb0 [ext3]
> >  [<ffffffff802b0c92>] do_fsync+0x52/0xa4
> >  [<ffffffff802b0d07>] __do_fsync+0x23/0x36
> >  [<ffffffff8020bddb>] system_call_fastpath+0x16/0x1b
> > INFO: task lamb-payload:3400 blocked for more than 480 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >  ffff8801b186daa8 0000000000000082 ffff8801b186da70 0000000000000000
> >  0000000000000000 ffff8801e3834ee0 ffffffff805ad360 ffff8801e3835238
> >  0000000000000000 00000000fffd50dd ffffffffffffffff ffffffffffffffff
> > Call Trace:
> >  [<ffffffffa002f6fd>] do_get_write_access+0x1dc/0x3c3 [jbd]
> >  [<ffffffff80249620>] wake_bit_function+0x0/0x23
> >  [<ffffffff802b1e79>] __getblk+0x25/0x211
> >  [<ffffffffa002f906>] journal_get_write_access+0x22/0x33 [jbd]
> >  [<ffffffffa0053fa9>] __ext3_journal_get_write_access+0x1e/0x47 [ext3]
> >  [<ffffffffa0047bf7>] ext3_reserve_inode_write+0x3d/0x76 [ext3]
> >  [<ffffffffa0047c51>] ext3_mark_inode_dirty+0x21/0x3c [ext3]
> >  [<ffffffffa004a74c>] ext3_dirty_inode+0x63/0x7b [ext3]
> >  [<ffffffff802ae65f>] __mark_inode_dirty+0x29/0x16b
> >  [<ffffffff802a55db>] touch_atime+0x109/0x112
> >  [<ffffffff8026cba6>] generic_file_aio_read+0x4b8/0x515
> >  [<ffffffff8029442c>] do_sync_read+0xc9/0x10c
> >  [<ffffffff802495f2>] autoremove_wake_function+0x0/0x2e
> >  [<ffffffff8027cf56>] __vma_link+0x42/0x4b
> >  [<ffffffff8032a3d4>] __up_write+0x27/0xf3
> >  [<ffffffff80294b4f>] vfs_read+0xaa/0x133
> >  [<ffffffff80297f65>] kernel_read+0x38/0x4e
> >  [<ffffffff802990a1>] do_execve+0x121/0x256
> >  [<ffffffff8020a495>] sys_execve+0x35/0x4c
> >  [<ffffffff8020c1fa>] stub_execve+0x6a/0xc0
> > INFO: task crond:3055 blocked for more than 480 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >  ffff8801d8197d08 0000000000000086 ffff8801d8197cd0 ffff8801da800700
> >  ffff8801da810a40 ffff8801e68481c0 ffff8801e70f3470 ffff8801e6848518
> >  00000001da8aeaf0 00000000fffdf3b6 ffffffffffffffff ffffffffffffffff
> > Call Trace:
> >  [<ffffffffa002f6fd>] do_get_write_access+0x1dc/0x3c3 [jbd]
> >  [<ffffffff80249620>] wake_bit_function+0x0/0x23
> >  [<ffffffff802b1e79>] __getblk+0x25/0x211
> >  [<ffffffff802a014c>] filldir+0x0/0xb1
> >  [<ffffffffa002f906>] journal_get_write_access+0x22/0x33 [jbd]
> >  [<ffffffffa0053fa9>] __ext3_journal_get_write_access+0x1e/0x47 [ext3]
> >  [<ffffffffa0047bf7>] ext3_reserve_inode_write+0x3d/0x76 [ext3]
> >  [<ffffffffa0047c51>] ext3_mark_inode_dirty+0x21/0x3c [ext3]
> >  [<ffffffffa004a74c>] ext3_dirty_inode+0x63/0x7b [ext3]
> >  [<ffffffff802ae65f>] __mark_inode_dirty+0x29/0x16b
> >  [<ffffffff802a014c>] filldir+0x0/0xb1
> >  [<ffffffff802a55db>] touch_atime+0x109/0x112
> >  [<ffffffff802a0287>] vfs_readdir+0x8a/0xa7
> >  [<ffffffff802a04f1>] sys_getdents+0x75/0xc4
> >  [<ffffffff8020bddb>] system_call_fastpath+0x16/0x1b
> > BUG: soft lockup - CPU#3 stuck for 61s! [mkfs.ext2:3399]
> > Modules linked in: nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 acpi_cpufreq dm_mirror dm_log dm_mod video output rfkill input_polldev sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy ide_cd_mod tg3 cdrom libphy serio_raw button i2c_i801 e752x_edac edac_core shpchp i2c_core pcspkr aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
> > Modules linked in: nfsd lockd nfs_acl auth_rpcgss exportfs autofs4 hidp rfcomm l2cap bluetooth sunrpc ipv6 acpi_cpufreq dm_mirror dm_log dm_mod video output rfkill input_polldev sbs sbshc battery acpi_memhotplug ac parport_pc lp parport sg floppy ide_cd_mod tg3 cdrom libphy serio_raw button i2c_i801 e752x_edac edac_core shpchp i2c_core pcspkr aic79xx scsi_transport_spi sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
> > Call Trace:
> >  <IRQ>  [<ffffffff80319770>] blk_invoke_request_fn+0x69/0x109
> >  [<ffffffffa006ffe3>] scsi_run_queue+0x2b5/0x2ba [scsi_mod]
> >  [<ffffffffa00706db>] scsi_next_command+0x2d/0x39 [scsi_mod]
> >  [<ffffffffa007090f>] scsi_end_request+0x86/0x97 [scsi_mod]
> >  [<ffffffffa0071659>] scsi_io_completion+0x1b6/0x3cd [scsi_mod]
> >  [<ffffffff8031d589>] blk_done_softirq+0x5c/0x6b
> >  [<ffffffff8023cb50>] __do_softirq+0x7a/0x13d
> >  [<ffffffff8021f9bd>] ack_apic_level+0x58/0xdc
> >  [<ffffffff8020d09c>] call_softirq+0x1c/0x28
> >  [<ffffffff8020decd>] do_softirq+0x2c/0x68
> >  [<ffffffff8020e1f1>] do_IRQ+0x145/0x168
> >  [<ffffffff8020c356>] ret_from_intr+0x0/0xa
> >  <EOI>  [<ffffffff80261cd5>] audit_syscall_entry+0xb6/0x160
> > [<ffffffff8020be94>] auditsys+0x19/0x4a
> > ..
> > ..
> > <snip>
> > 
> > 0xffffffff80319770 is in blk_invoke_request_fn (include/linux/blkdev.h:456).
> > 451     #define QUEUE_FLAG_NONROT      14       /* non-rotational device (SSD) */
> > 452
> > 453     static inline int queue_is_locked(struct request_queue *q)
> > 454     {
> > 455     #ifdef CONFIG_SMP
> > 456             spinlock_t *lock = q->queue_lock;
> > 457             return lock && spin_is_locked(lock);
> > 458     #else
> > 459             return 1;
> > 460     #endif
> > 
> > 0x4fe3 is in scsi_run_queue (drivers/scsi/scsi_lib.c:604).
> > 599			flagset = test_bit(QUEUE_FLAG_REENTER, &q->queue_flags) &&
> > 600					!test_bit(QUEUE_FLAG_REENTER,
> > 601						&sdev->request_queue->queue_flags);
> > 602			if (flagset)
> > 603				queue_flag_set(QUEUE_FLAG_REENTER, sdev->request_queue);
> > 604			__blk_run_queue(sdev->request_queue);
> > 605			if (flagset)
> > 606				queue_flag_clear(QUEUE_FLAG_REENTER, sdev->request_queue);
> > 607			spin_unlock(sdev->request_queue->queue_lock);
> > 608	
> 
> Huh, this makes very little sense to me... Can I talk you into trying
> the for-linus branch of the block tree?
> 
> git://git.kernel.dk/linux-2.6-block.git for-linus
> 
> just to see if it reproduces with that. I'm assuming 2.6-git is fine?
> 
> -- 
> Jens Axboe
> 

I applied the for-linus branch on top of 2.6.27-git7 kernel and I was not able to
reproduce with it.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
