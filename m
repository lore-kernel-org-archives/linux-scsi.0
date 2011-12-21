From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v4 1/3] qla2xxx: Add LLD internal target-mode support
Date: Wed, 21 Dec 2011 13:48:52 -0800
Message-ID: <1324504132.22016.21.camel@haakon2.linux-iscsi.org>
References: <1324173746-14361-1-git-send-email-nab@linux-iscsi.org>
	 <1324173746-14361-2-git-send-email-nab@linux-iscsi.org>
	 <CAL1RGDXPmRfLsRgVYyYVNo-3iE-oKHANAB-3Zy6_GNgVONCiQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDXPmRfLsRgVYyYVNo-3iE-oKHANAB-3Zy6_GNgVONCiQw@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@parallels.com>, Joern Engel <joern@logfs.org>, Madhuranath Iyengar <mni@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-12-19 at 14:59 -0800, Roland Dreier wrote:
> Hi Nick,
> 

Hi Roland,

> > +/* ha->hardware_lock supposed to be held on entry */
> > +static void qla_tgt_undelete_sess(struct qla_tgt_sess *sess)
> > +{
> > +       BUG_ON(!sess->deleted);
> > +
> > +       list_del(&sess->del_list_entry);
> > +       sess->deleted = 0;
> > +}
> 
> Running with basically this code, we hit the crash below (the BUG is
> the one above).

So AFAICT the BUG_ON() being triggered below is not actually from
qla_tgt_undelete_sess(), as this is never called from the main release
path from tcm_qla2xxx_release_cmd() in the backtrace below.

>   The way to hit this was described as having the target
> be artificially slow (slower than the initiator SCSI timeout) responding
> to reads, and having the initiator keep resending the read commands after
> it aborts them:
> 

<nod>

> [  465.935351] scsi(10): resetting (session ffff880614858060 from port
> 50:01:43:80:16:7c:80:7a, mcmd fffd, loop_id 129)
> [  465.935496] qla_target(0): Unknown task mgmt fn 0xfffd
> [  466.016688] scsi(10): resetting (session ffff880614858060 from port
> 50:01:43:80:16:7c:80:7a, mcmd fffd, loop_id 129)
> [  466.016824] qla_target(0): Unknown task mgmt fn 0xfffd
> [  466.017102] scsi(10): resetting (session ffff880614858060 from port
> 50:01:43:80:16:7c:80:7a, mcmd fffd, loop_id 129)
> [  466.017236] qla_target(0): Unknown task mgmt fn 0xfffd
> [  488.064324] qla_target(0): tgt_ops->handle_tmr() failed: -22
> [  488.064422] qla_target(0): Unable to send command to target,
> sending BUSY status
> [  495.587058] ------------[ cut here ]------------
> [  495.587161] kernel BUG at drivers/scsi/qla2xxx/qla_target.c:2591!

So looking at qla_tgt-3.3, qla_target.c:2591 lines up with the
following:

void qla_tgt_free_cmd(struct qla_tgt_cmd *cmd)
{
        BUG_ON(cmd->sg_mapped);

        if (unlikely(cmd->free_sg))
                kfree(cmd->sg);
        kmem_cache_free(qla_tgt_cmd_cachep, cmd);
}

I'm not sure at what point the call to qla_tgt_unmap_sg() is being
ignored here, but I think it's likely related to the fact that
qla_target.c is now using target_submit_cmd() to dispatching backend I/O
directly from workqueue context, and not from processing context in
transport_processing_thread().

core_tmr_lun_reset() is currently making some assumptions about this
when it comes to walking the active I/O lists to abort commands, so I'm
thinking this will also need to change to take into account that I/O's
may still be being dispatched from seperate workqueue process context.

In any event, please verify the BUG_ON() you're observing, and I'll take
a look at this over the holidays.

Thanks,

--nab

> [  495.587281] invalid opcode: 0000 [#1] SMP
> [  495.587553] last sysfs file:
> /sys/devices/pci0000:00/0000:00:07.0/0000:09:00.0/host11/port-11:1/expander-11:1/port-11:1:9/end_device-11:1:9/target11:0:34/11:0:34:0/state
> [  495.587756] Dumping ftrace buffer:
> [  495.587891]    (ftrace buffer empty)
> [  495.588002] CPU 10
> [  495.588050] Modules linked in: netconsole vfat msdos fat
> target_core_pscsi target_core_file target_core_iblock tcm_qla2xxx
> target_core_mod configfs ps_bdrv ipmi_devintf ipmi_si ipmi_msghandler
> serio_raw ioatdma i7core_edac dca edac_core ses enclosure rdma_ucm
> rdma_cm mlx4_ib usb_storage usbhid ahci mpt2sas qla2xxx uas e1000e hid
> iw_cm libahci scsi_transport_sas scsi_transport_fc mlx4_core ib_uverbs
> raid_class scsi_tgt ib_umad ib_ipoib ib_cm ib_sa ib_mad ib_core
> ib_addr
> [  495.591092]
> [  495.591167] Pid: 5276, comm: LIO_iblock Tainted: G        W
> 2.6.39.4-dbg+ #14435 Xyratex Storage Server        /HS-1235T-ATX
> [  495.591432] RIP: 0010:[<ffffffffa01e4bed>]  [<ffffffffa01e4bed>]
> qla_tgt_free_cmd+0x2d/0x50 [qla2xxx]
> [  495.591614] RSP: 0018:ffff8805d5b25bb0  EFLAGS: 00010202
> [  495.591700] RAX: 000000000000000a RBX: ffff8805b1c50040 RCX: 0000000000000000
> [  495.591793] RDX: 0000000000000000 RSI: ffff8805b1c50000 RDI: ffff8805b1c50000
> [  495.591886] RBP: ffff8805d5b25bc0 R08: 0000000000000001 R09: 0000000000000000
> [  495.591979] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88062314f1a8
> [  495.592072] R13: ffff8805b1c50168 R14: ffff88062314f140 R15: 0000000000000286
> [  495.592166] FS:  0000000000000000(0000) GS:ffff880c3ea00000(0000)
> knlGS:0000000000000000
> [  495.592290] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  495.592387] CR2: 00007f59d60a0330 CR3: 0000000001a03000 CR4: 00000000000006e0
> [  495.592486] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  495.592583] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  495.592682] Process LIO_iblock (pid: 5276, threadinfo
> ffff8805d5b24000, task ffff8805d5a6c4e0)
> [  495.592809] Stack:
> [  495.592907]  ffff8805d5b25bd0 0000000000000286 ffff8805d5b25bd0
> ffffffffa0144891
> [  495.593244]  ffff8805d5b25c10 ffffffffa030a40e 0000000a00000002
> ffff8805b1c50168
> [  495.593533]  ffffffffa030a390 0000000000000286 0000000000000002
> 0000000000000000
> [  495.593819] Call Trace:
> [  495.593901]  [<ffffffffa0144891>] tcm_qla2xxx_release_cmd+0x21/0x30
> [tcm_qla2xxx]
> [  495.594037]  [<ffffffffa030a40e>] target_release_cmd_kref+0x7e/0xe0
> [target_core_mod]
> [  495.594169]  [<ffffffffa030a390>] ?
> target_splice_sess_cmd_list+0xd0/0xd0 [target_core_mod]
> [  495.594300]  [<ffffffff8129ba67>] kref_put+0x37/0x70
> [  495.594395]  [<ffffffffa030a48c>] target_put_sess_cmd+0x1c/0x20
> [target_core_mod]
> [  495.594520]  [<ffffffffa014485f>]
> tcm_qla2xxx_check_stop_free+0x4f/0x60 [tcm_qla2xxx]
> [  495.594651]  [<ffffffffa0309867>]
> transport_cmd_check_stop+0x157/0x210 [target_core_mod]
> [  495.594784]  [<ffffffffa0309935>]
> transport_cmd_check_stop_to_fabric+0x15/0x20 [target_core_mod]
> [  495.594919]  [<ffffffffa030ea2e>]
> transport_cmd_finish_abort+0x2e/0x70 [target_core_mod]
> [  495.595052]  [<ffffffffa0307185>]
> core_tmr_handle_tas_abort+0x35/0x70 [target_core_mod]
> [  495.595185]  [<ffffffffa030768c>] core_tmr_lun_reset+0x3dc/0x950
> [target_core_mod]
> [  495.595313]  [<ffffffff81088469>] ? trace_hardirqs_off_caller+0x29/0xc0
> [  495.595407]  [<ffffffff8108850d>] ? trace_hardirqs_off+0xd/0x10
> [  495.595509]  [<ffffffff81557810>] ? _raw_spin_unlock_irqrestore+0x40/0x80
> [  495.595611]  [<ffffffffa0310a2c>]
> transport_generic_do_tmr+0x9c/0xc0 [target_core_mod]
> [  495.595743]  [<ffffffffa0310cb8>]
> transport_processing_thread+0x268/0x460 [target_core_mod]
> [  495.595872]  [<ffffffff810742f0>] ? wake_up_bit+0x40/0x40
> [  495.595970]  [<ffffffffa0310a50>] ?
> transport_generic_do_tmr+0xc0/0xc0 [target_core_mod]
> [  495.596095]  [<ffffffff81073d4e>] kthread+0xbe/0xd0
> [  495.596195]  [<ffffffff81557dd4>] ? retint_restore_args+0x13/0x13
> [  495.596292]  [<ffffffff8108e51d>] ? trace_hardirqs_on_caller+0x14d/0x190
> [  495.596391]  [<ffffffff815611a4>] kernel_thread_helper+0x4/0x10
> [  495.596488]  [<ffffffff81557dd4>] ? retint_restore_args+0x13/0x13
> [  495.596586]  [<ffffffff81073c90>] ? __init_kthread_worker+0x70/0x70
> [  495.596683]  [<ffffffff815611a0>] ? gs_change+0x13/0x13
> [  495.596781] Code: 89 e5 48 83 ec 10 0f 1f 44 00 00 0f b6 87 40 05
> 00 00 48 89 fe a8 02 75 12 a8 04 75 10 48 8b 3d fa 3b 02 00 e8 75 0e
> f6 e0 c9 c3 <0f> 0b 48 8b bf 48 05 00 00 48 89 75 f8 e8 81 0c f6 e0 48
> 8b 75
> [  495.599869] RIP  [<ffffffffa01e4bed>] qla_tgt_free_cmd+0x2d/0x50 [qla2xxx]
> [  495.600011]  RSP <ffff8805d5b25bb0>
> [  495.600316] ---[ end trace 71e099d8f1a84ca8 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
