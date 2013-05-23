From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] block,scsi: verify return pointer from blk_get_request
Date: Fri, 24 May 2013 00:40:11 +0400
Message-ID: <1369341611.2374.11.camel@dabdike>
References: <alpine.DEB.2.02.1303171328250.1736@jlaw-desktop.mno.stratus.com>
	 <20130317224416.GA7421@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36926 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757883Ab3EWUkS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 May 2013 16:40:18 -0400
In-Reply-To: <20130317224416.GA7421@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Joe Lawrence <Joe.Lawrence@stratus.com>, linux-scsi@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>

On Sun, 2013-03-17 at 16:44 -0600, Jens Axboe wrote:
> On Sun, Mar 17 2013, Joe Lawrence wrote:
> > Hello James / Jiri / Jens,
> > 
> > Stratus hit a NULL ptr deference bug when removing a USB CD-ROM while
> > burning a DVD.  The stack trace below was produced on a RHEL 6.4-GA
> > kernel, however it looks like the bug still exists in 3.9.0-rc2: not all
> > callers of blk_get_request bother to verify the return pointer value
> > before using it. 
> > 
> > There are other unsafe blk_get_request callers in the kernel, but they
> > live in the obsolete drivers/ide directory.  Patches from the Linux
> > Driver Verification to harden those calls were rejected in Aug 2012 [1],
> > so I'll let them be.
> > 
> > [1] https://lkml.org/lkml/2012/8/9/561
> > 
> > Stack trace and notes:
> > 
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000044
> > usb 3-1.6: USB disconnect, device number 4
> > usb 3-1.6.1: USB disconnect, device number 5
> > IP: [<ffffffff8126687b>] blk_send_start_stop+0x3b/0xa0
> > PGD 4034327067 PUD 4041356067 PMD 0
> > Oops: 0002 [#1] SMP
> > last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/class
> > CPU 0
> > Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl nls_utf8 fuse autofs4 sunrpc configfs bonding 8021q garp stp llc vhost_net macvtap macvlan tun uinput ipmi_devintf ftmod(P)(U) sg matroxfb(U) fosil(U) ext4 mbcache jbd2 sr_mod cdrom raid1 ixgbe(U) usb_storage mpt2sas(U) scsi_hbas(U) sd_mod(U) crc_t10dif scsi_transport_sas raid_class igb(U) dca ptp pps_core dm_mirror dm_region_hash dm_log dm_mod ipv6 cxgb4 cxgb3 mdio libiscsi_tcp libiscsi scsi_transport_iscsi [last unloaded: scsi_wait_scan]
> > 
> > Pid: 13461, comm: k3b Tainted: P           ---------------    2.6.32-358.el6.x86_64 #1 Stratus ftServer 4700/G7LAY
> > RIP: 0010:[<ffffffff8126687b>]  [<ffffffff8126687b>] blk_send_start_stop+0x3b/0xa0
> > RSP: 0018:ffff884050545b98  EFLAGS: 00010282
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88204e64c0f8
> > RBP: ffff884050545bb8 R08: 000000000297a798 R09: 0000000000000000
> > R10: 00000000000007e4 R11: 0000000000000001 R12: ffff88204e64c0f8
> > R13: ffff88204d1a3800 R14: 0000000000000002 R15: 000000000000005d
> > FS:  00007f480bfff700(0000) GS:ffff880040200000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000044 CR3: 00000040414ca000 CR4: 00000000000407f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Process k3b (pid: 13461, threadinfo ffff884050544000, task ffff884046de1500)
> > Stack:
> >  ffff88204e64c0f8 00000000fffffffa ffff88204d1a3800 000000000297a798
> > <d> ffff884050545cb8 ffffffff8126726a ffff880040236798 ffff880040236700
> > <d> ffff884050f7b538 ffff8840504ca0b8 ffff884050f7b500 0000000000000000
> > Call Trace:
> >  [<ffffffff8126726a>] scsi_cmd_ioctl+0x18a/0x470
> >  [<ffffffff8103392e>] ? physflat_send_IPI_mask+0xe/0x10
> >  [<ffffffff8102dd89>] ? native_smp_send_reschedule+0x49/0x60
> >  [<ffffffff81052258>] ? resched_task+0x68/0x80
> >  [<ffffffff810570e0>] ? check_preempt_wakeup+0x1c0/0x260
> >  [<ffffffff81054f13>] ? ftrace_raw_event_id_sched_wakeup_template+0xe3/0xf0
> >  [<ffffffff812675a1>] scsi_cmd_blk_ioctl+0x51/0x70
> >  [<ffffffffa01c1a1d>] cdrom_ioctl+0x4d/0xe60 [cdrom]
> >  [<ffffffff812231f1>] ? avc_has_perm+0x71/0x90
> >  [<ffffffffa0082440>] sr_block_ioctl+0x60/0xb0 [sr_mod]
> >  [<ffffffff812642f7>] __blkdev_driver_ioctl+0x67/0x80
> >  [<ffffffff8126477d>] blkdev_ioctl+0x1ed/0x6e0
> >  [<ffffffff811bb76c>] block_ioctl+0x3c/0x40
> >  [<ffffffff81194ed2>] vfs_ioctl+0x22/0xa0
> >  [<ffffffff81195074>] do_vfs_ioctl+0x84/0x580
> >  [<ffffffff811955f1>] sys_ioctl+0x81/0xa0
> >  [<ffffffff8100b288>] tracesys+0xd9/0xde
> > Code: 08 4c 89 6c 24 10 4c 89 74 24 18 0f 1f 44 00 00 49 89 f5 41 89 d6 be 01 00 00 00 ba 10 00 00 00 49 89 fc e8 b8 82 ff ff 48 89 c3 <c7> 40 44 02 00 00 00 c7 80 38 01 00 00 60 ea 00 00 48 8b 80 00
> > RIP  [<ffffffff8126687b>] blk_send_start_stop+0x3b/0xa0
> >  RSP <ffff884050545b98>
> > CR2: 0000000000000044
> > 
> > What is blk_send_start_stop (inline __blk_send_generic) doing?
> > 
> > block/scsi_ioctl.c: 783
> >   <blk_send_start_stop+0x33>:  callq  0xffffffff8125eb30 <blk_get_request>
> >   <blk_send_start_stop+0x38>:  mov    %rax,%rbx
> > block/scsi_ioctl.c: 784
> >   <blk_send_start_stop+0x3b>:  movl   $0x2,0x44(%rax)
> > 
> > Where RAX: 0000000000000000
> > 
> > block/scsi_ioctl.c: 
> > 
> > 776 /* Send basic block requests */
> > 777 static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_di
> > 778                               int cmd, int data)
> > 779 {
> > 780         struct request *rq;
> > 781         int err;
> > 782
> > 783         rq = blk_get_request(q, WRITE, __GFP_WAIT);
> > 784         rq->cmd_type = REQ_TYPE_BLOCK_PC;                        <<
> > 785         rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
> > 786         rq->cmd[0] = cmd;
> > 787         rq->cmd[4] = data;
> > 788         rq->cmd_len = 6;
> > 789         err = blk_execute_rq(q, bd_disk, rq, 0);
> > 790         blk_put_request(rq);
> > 791
> > 792         return err;
> > 793 }
> > 
> > A quick verify of offset from "movl   $0x2,0x44(%rax)":
> > 
> > crash> struct -o request | grep 0x44
> >    [0x44] enum rq_cmd_type_bits cmd_type;
> > 
> > So blk_get_request returned a NULL struct request pointer, but
> > __blk_send_generic continued on without checking it first.
> 
> The reason why the above code does not check for NULL return, is because
> __GFP_WAIT is set. But since queue dead checks were added, we can
> trigger this now. So with that in mind, ENOMEM is not the right error
> code for this, as it has nothing to do with running out of memory.
> 
> Would probably be best to return the correct error pointer from
> blk_get_request(), as you would otherwise have to assume this knowledge
> in the callers.

Now that we see the size of the patch diff between fixing the bug and
doing proper error returns, I'm really not convinced this should be done
as a single bug fix patch.  The modify all error returns is big and if
we missed one, it will cause problems that will manifest as an oops, so
it makes a fairly compact fix a big error prone patch.

What about two patches: one to fix the actual bug (this patch), which
could go now and one to change the return type, which would go in the
normal merge window.

James


