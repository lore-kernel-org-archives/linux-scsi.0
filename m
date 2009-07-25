From: Joe Eykholt <jeykholt-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: 3-way deadlock during fc_remove_host
Date: Sat, 25 Jul 2009 15:26:42 -0700
Message-ID: <4A6B86A2.6040604@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

I could use some insight about this problem.  I have a hang involving
three threads.

The first is in fc_remove_host() doing flush_cpu_workqueue().
It cannot proceed because of the second:

A worker thread PID 7624 is trying to remove an fc_rport and doing
async_synchronize_full(), which waits until all posted async events
are complete.  One such event that keeps it from completing is:

The third thread which is in sd_probe_async() waiting on I/O completion.

I think that last one won't finish because the HBA is being removed,
but it could be for another HBA instead.  Actually, all I/O for the
HBA being removed should have been canceled (via fc_rport_terminate_io()
doing a exch_mgr_reset) and no new I/O started.

This is with the current fcoe-next.git tree plus local fixes,
but it may apply to other trees.

Here are the stacks I got from /proc/*/stack:

7635
Name:   fcoeadm
State:  D (disk sleep)
cmd:    /sbin/fcoeadm -d eth4
wchan:  flush_cpu_workqueue
         --- assume waiting for work queue
         --- waiting for 7519 probably

[<ffffffff810532e1>] flush_cpu_workqueue+0x7b/0x87
[<ffffffff81053357>] cleanup_workqueue_thread+0x6a/0xb8
[<ffffffff8105343c>] destroy_workqueue+0x63/0x9e
[<ffffffffa004a5a7>] fc_remove_host+0x148/0x171 [scsi_transport_fc]
[<ffffffffa00b612c>] fcoe_if_destroy+0x123/0x15b [fcoe]
[<ffffffffa00b620c>] fcoe_destroy+0x72/0xa0 [fcoe]
[<ffffffff81055558>] param_attr_store+0x25/0x35
[<ffffffff810555ad>] module_attr_store+0x21/0x25
[<ffffffff81126c5a>] sysfs_write_file+0xe4/0x119
[<ffffffff810d76b4>] vfs_write+0xab/0x105
[<ffffffff810d77d2>] sys_write+0x47/0x6e
[<ffffffff8100baeb>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff


7519
Name:   fc_wq_5
State:  D (disk sleep)
cmd:
wchan:  async_synchronize_cookie_domain
         --- waiting for async 7624?/

[<ffffffff8105cdca>] async_synchronize_cookie_domain+0xb4/0x110
[<ffffffff8105ce36>] async_synchronize_cookie+0x10/0x12
[<ffffffff8105ce48>] async_synchronize_full+0x10/0x2c
[<ffffffff812aa7a7>] sd_remove+0x15/0x8a
[<ffffffff81291b76>] __device_release_driver+0x80/0xc9
[<ffffffff81291c8a>] device_release_driver+0x1e/0x2b
[<ffffffff8129122f>] bus_remove_device+0xa8/0xc9
[<ffffffff8128f92e>] device_del+0x138/0x1a1
[<ffffffff812a502c>] __scsi_remove_device+0x44/0x81
[<ffffffff812a508f>] scsi_remove_device+0x26/0x33
[<ffffffff812a5141>] __scsi_remove_target+0x93/0xd7
[<ffffffff812a51eb>] __remove_child+0x1e/0x25
[<ffffffff8128f18a>] device_for_each_child+0x38/0x6f
[<ffffffff812a51c0>] scsi_remove_target+0x3b/0x48
[<ffffffffa0049db7>] fc_starget_delete+0x21/0x25 [scsi_transport_fc]
[<ffffffffa0049eb1>] fc_rport_final_delete+0xf6/0x188 [scsi_transport_fc]
[<ffffffff81052d10>] worker_thread+0x1fa/0x30a
[<ffffffff81057151>] kthread+0x88/0x90
[<ffffffff8100cbfa>] child_rip+0xa/0x20
[<ffffffffffffffff>] 0xffffffffffffffff

7624
Name:   async/1
State:  D (disk sleep)
cmd:
wchan:  blk_execute_rq
         --- waiting for completion of i/o
         --- since this is an async thread, presumably  7519 is waiting for it

[<ffffffff811c5b51>] blk_execute_rq+0xb6/0xd9
[<ffffffff812a1b9f>] scsi_execute+0xe0/0x132
[<ffffffff812a1c71>] scsi_execute_req+0x80/0xb2
[<ffffffff812aa912>] read_capacity_10+0x7d/0x1a0
[<ffffffff812ac80f>] sd_revalidate_disk+0x14c2/0x1561
[<ffffffff811242db>] rescan_partitions+0x8c/0x3a3
[<ffffffff810fb991>] __blkdev_get+0x264/0x333
[<ffffffff810fba6b>] blkdev_get+0xb/0xd
[<ffffffff81123971>] register_disk+0xe2/0x144
[<ffffffff811c7f80>] add_disk+0xc0/0x11e
[<ffffffff812ac9ca>] sd_probe_async+0x11c/0x1cd
[<ffffffff8105cbbc>] async_thread+0x114/0x205
[<ffffffff81057151>] kthread+0x88/0x90
[<ffffffff8100cbfa>] child_rip+0xa/0x20
[<ffffffffffffffff>] 0xffffffffffffffff

If you've seen a hang like this or might know what's going on,
please let me know.

	Thanks,
	Joe
