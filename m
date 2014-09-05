From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
Date: Fri, 5 Sep 2014 10:14:46 +0100
Message-ID: <20140905091446.GA31771@sucs.org>
References: <1409701396-20226-1-git-send-email-kys@microsoft.com>
 <20140905054014.GA11595@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20140905054014.GA11595@infradead.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jbottomley@parallels.com, ohering@suse.com, Hannes Reinecke <hare@suse.de>, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 04, 2014 at 10:40:14PM -0700, Christoph Hellwig wrote:
> Looks good to me.
> 
> Olaf, Hannes - can I get another review for this (and the older hyperv
> scanning patch set)?

I agree this looks useful because on a
59753a805499f1ffbca4ac0a24b3dff67bf00001 3.17rc2 kernel with

92578ea Drivers: net: hyperv: Cleanup select queue
7e1ea8c Add documentation for HV_STATUS_INVALID_ALIGNMENT.
cecd44d BUG: unable to handle kernel paging request at ffff8801f5bc7cbb
(netvsc_select_queue)
9c6196f Drivers: hv: vmbus: Properly protect calls to smp_processor_id()
2590142 Drivers: hv: vmbus: Cleanup hv_post_message()
cd97ae9 Drivers: hv: vmbus: Cleanup vmbus_close_internal()
ff08f61 Drivers: hv: vmbus: Fix a bug in vmbus_open()
2f8915e Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
6940bd6 Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
b022b1b Drivers: hv: vmbus: Cleanup vmbus_post_msg()

but without this particular patch applied it is possible for a lot of
hv_storvsc vmbus_0_5 messages to be produced while running a command
like
fio --filename /dev/sdg --ioengine=libaio --iodepth=8 --name=go --rw=randwrite --bs=4k --runtime=10m --time_based=1  --direct=1
and repeatedly removing/re-adding/changing the VHDX backing /dev/sdg
from the Linux Hyper-V guest:

Sep 05 07:09:57 a kernel: scsi 1:0:1:0: scsi scan: INQUIRY result too short (5), using 36
Sep 05 07:09:57 a kernel: scsi 1:0:1:1: scsi scan: INQUIRY result too short (5), using 36
Sep 05 07:09:57 a kernel: sd 1:0:0:0: [sdf] Synchronizing SCSI cache
Sep 05 07:09:57 a kernel: hv_storvsc vmbus_0_5: cmd 0x35 scsi status 0x0 srb status 0x20
Sep 05 07:09:58 a kernel: scsi 1:0:0:0: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 4
Sep 05 07:09:58 a kernel: sd 1:0:0:0: [sdf] 2097152 512-byte logical blocks: (1.07 GB/1.00 GiB)
Sep 05 07:09:58 a kernel: sd 1:0:0:0: Attached scsi generic sg5 type 0
Sep 05 07:09:58 a kernel: scsi 1:0:1:0: scsi scan: INQUIRY result too short (5), using 36
Sep 05 07:09:58 a kernel: sd 1:0:0:0: [sdf] Write Protect is off
Sep 05 07:09:58 a kernel: sd 1:0:0:0: [sdf] Mode Sense: 0f 00 00 00
Sep 05 07:09:58 a kernel: sd 1:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep 05 07:09:58 a kernel:  sdf: unknown partition table
Sep 05 07:09:58 a kernel: scsi 1:0:1:1: scsi scan: INQUIRY result too short (5), using 36
Sep 05 07:09:58 a kernel: sd 1:0:0:0: [sdf] Attached SCSI disk
Sep 05 07:09:58 a kernel: md: bind<sdf>
Sep 05 07:09:58 a kernel: md126: detected capacity change from 0 to 1069547520
Sep 05 07:09:58 a kernel:  md126: unknown partition table
Sep 05 07:09:58 a systemd[1]: Starting LVM2 PV scan on device 9:126...
Sep 05 07:09:58 a pvscan[788]: 0 logical volume(s) in volume group "PoolDelete" now active
Sep 05 07:09:58 a systemd[1]: Started LVM2 PV scan on device 9:126.
Sep 05 07:10:01 a systemd[1]: Starting Session 2 of user root.
Sep 05 07:10:01 a systemd[1]: Started Session 2 of user root.
Sep 05 07:10:01 a CROND[793]: (root) CMD (/usr/lib64/sa/sa1 1 1)
Sep 05 07:10:02 a systemd[673]: Time has been changed
Sep 05 07:10:02 a systemd[1]: Time has been changed
Sep 05 07:10:07 a systemd[1]: Time has been changed
Sep 05 07:10:07 a systemd[673]: Time has been changed
Sep 05 07:10:12 a systemd[673]: Time has been changed
Sep 05 07:10:12 a systemd[1]: Time has been changed
Sep 05 07:10:16 a kernel: scsi 1:0:1:0: scsi scan: INQUIRY result too short (5), using 36
Sep 05 07:10:16 a kernel: scsi 1:0:1:1: scsi scan: INQUIRY result too short (5), using 36
Sep 05 07:10:17 a kernel: scsi 1:0:1:0: scsi scan: INQUIRY result too short (5), using 36
Sep 05 07:10:17 a kernel: scsi 1:0:1:1: scsi scan: INQUIRY result too short (5), using 36
Sep 05 07:10:17 a systemd[1]: Time has been changed
Sep 05 07:10:17 a systemd[673]: Time has been changed
Sep 05 07:10:22 a systemd[673]: Time has been changed
Sep 05 07:10:22 a systemd[1]: Time has been changed
Sep 05 07:10:27 a systemd[1]: Time has been changed
Sep 05 07:10:27 a systemd[673]: Time has been changed
Sep 05 07:10:32 a systemd[673]: Time has been changed
Sep 05 07:10:32 a systemd[1]: Time has been changed
Sep 05 07:10:37 a systemd[1]: Time has been changed
Sep 05 07:10:37 a systemd[673]: Time has been changed
Sep 05 07:10:42 a systemd[673]: Time has been changed
Sep 05 07:10:42 a systemd[1]: Time has been changed
Sep 05 07:10:47 a systemd[1]: Time has been changed
Sep 05 07:10:47 a systemd[673]: Time has been changed
Sep 05 07:10:51 a kernel: scsi 1:0:1:0: scsi scan: INQUIRY result too short (5), using 36
Sep 05 07:10:53 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:53 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:53 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
[Message is repeated]
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: scsi 1:0:1:1: scsi scan: INQUIRY result too short (5), using 36
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:10:57 a kernel: sd 1:0:0:0: [sdf] Synchronizing SCSI cache
Sep 05 07:10:57 a kernel: ------------[ cut here ]------------
Sep 05 07:10:57 a kernel: WARNING: CPU: 0 PID: 808 at fs/fs-writeback.c:1200 __mark_inode_dirty+0x197/0x2c0()
Sep 05 07:10:57 a kernel: bdi-block not registered
Sep 05 07:10:57 a kernel: CPU: 0 PID: 808 Comm: fio Not tainted 3.17.0-rc2.x86_64-00099-g92578ea #142
Sep 05 07:10:57 a kernel: Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
Sep 05 07:10:57 a kernel:  0000000000000009 ffff8800efdfbaa8 ffffffff816b2f53 ffff8800efdfbaf0
Sep 05 07:10:57 a kernel:  ffff8800efdfbae0 ffffffff81071348 ffff8801fdc1b0f0 ffff8800efd139a0
Sep 05 07:10:57 a kernel:  ffff8800efd13618 ffff8801fe028948 0000000000000000 ffff8800efdfbb40
Sep 05 07:10:57 a kernel: Call Trace:
Sep 05 07:10:57 a kernel:  [<ffffffff816b2f53>] dump_stack+0x4d/0x66
Sep 05 07:10:57 a kernel:  [<ffffffff81071348>] warn_slowpath_common+0x78/0xa0
Sep 05 07:10:57 a kernel:  [<ffffffff810713dc>] warn_slowpath_fmt+0x4c/0x50
Sep 05 07:10:57 a kernel:  [<ffffffff811eeef7>] __mark_inode_dirty+0x197/0x2c0
Sep 05 07:10:57 a kernel:  [<ffffffff811f4c73>] __set_page_dirty+0x93/0xb0
Sep 05 07:10:57 a kernel:  [<ffffffff811f5c73>] mark_buffer_dirty+0xb3/0xe0
Sep 05 07:10:57 a kernel:  [<ffffffff811f5dd2>] __block_commit_write.isra.14+0x82/0xc0
Sep 05 07:10:57 a kernel:  [<ffffffff811f662e>] block_write_end+0x5e/0x70
Sep 05 07:10:57 a kernel:  [<ffffffff811f7896>] ? block_write_begin+0x46/0x90
Sep 05 07:10:57 a kernel:  [<ffffffff811f9a90>] blkdev_write_end+0x20/0x40
Sep 05 07:10:57 a kernel:  [<ffffffff811df08c>] ? file_update_time+0xac/0xd0
Sep 05 07:10:57 a kernel:  [<ffffffff81157da7>] generic_perform_write+0x107/0x1d0
Sep 05 07:10:57 a kernel:  [<ffffffff811df08c>] ? file_update_time+0xac/0xd0
Sep 05 07:10:57 a kernel:  [<ffffffff811df08c>] ? file_update_time+0xac/0xd0
Sep 05 07:10:57 a kernel:  [<ffffffff811580f8>] __generic_file_write_iter+0x288/0x340
Sep 05 07:10:57 a kernel:  [<ffffffff811f9c92>] blkdev_write_iter+0x32/0xa0
Sep 05 07:10:57 a kernel:  [<ffffffff811c1fee>] ? rw_verify_area+0x7e/0xf0
Sep 05 07:10:57 a kernel:  [<ffffffff811f9c60>] ? bdev_inode_switch_bdi+0x140/0x140
Sep 05 07:10:57 a kernel:  [<ffffffff8120b94b>] aio_run_iocb.isra.9+0x1bb/0x380
Sep 05 07:10:57 a kernel:  [<ffffffff8118542a>] ? might_fault+0x5a/0xb0
Sep 05 07:10:57 a kernel:  [<ffffffff8120c910>] do_io_submit+0x3c0/0x590
Sep 05 07:10:57 a kernel:  [<ffffffff8120c7e0>] ? do_io_submit+0x290/0x590
Sep 05 07:10:57 a kernel:  [<ffffffff8120caf0>] SyS_io_submit+0x10/0x20
Sep 05 07:10:57 a kernel:  [<ffffffff816bbae9>] system_call_fastpath+0x16/0x1b
Sep 05 07:10:57 a kernel: ---[ end trace 5f4fc2692d8c0736 ]---
Sep 05 07:10:57 a kernel: hv_storvsc vmbus_0_5: cmd 0x35 scsi status 0x0 srb status 0x20
Sep 05 07:10:52 a systemd[673]: Time has been changed
Sep 05 07:10:52 a systemd[1]: Time has been changed
Sep 05 07:10:57 a systemd[1]: Time has been changed
Sep 05 07:10:57 a systemd[673]: Time has been changed
Sep 05 07:11:02 a systemd[673]: Time has been changed
Sep 05 07:11:02 a systemd[1]: Time has been changed
Sep 05 07:11:07 a systemd[1]: Time has been changed
Sep 05 07:11:07 a systemd[673]: Time has been changed
Sep 05 07:11:12 a systemd[673]: Time has been changed
Sep 05 07:11:12 a systemd[1]: Time has been changed
Sep 05 07:11:17 a systemd[1]: Time has been changed
Sep 05 07:11:17 a systemd[673]: Time has been changed
Sep 05 07:11:22 a systemd[673]: Time has been changed
Sep 05 07:11:22 a systemd[1]: Time has been changed
Sep 05 07:11:26 a kernel: scsi 1:0:0:0: Direct-Access     Msft     Virtual Disk     1.0  PQ: 0 ANSI: 4
Sep 05 07:11:26 a kernel: sd 1:0:0:0: [sdg] 16777216 512-byte logical blocks: (8.58 GB/8.00 GiB)
Sep 05 07:11:26 a kernel: sd 1:0:0:0: Attached scsi generic sg5 type 0
Sep 05 07:11:26 a kernel: scsi 1:0:1:0: scsi scan: INQUIRY result too short (5), using 36
Sep 05 07:11:26 a kernel: sd 1:0:0:0: [sdg] Write Protect is off
Sep 05 07:11:26 a kernel: sd 1:0:0:0: [sdg] Mode Sense: 0f 00 00 00
Sep 05 07:11:26 a kernel: sd 1:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep 05 07:11:26 a kernel: scsi 1:0:1:1: scsi scan: INQUIRY result too short (5), using 36
Sep 05 07:11:26 a kernel:  sdg: unknown partition table
Sep 05 07:11:26 a kernel: sd 1:0:0:0: [sdg] Attached SCSI disk
Sep 05 07:11:27 a systemd[1]: Time has been changed
Sep 05 07:11:27 a systemd[673]: Time has been changed
Sep 05 07:11:32 a systemd[673]: Time has been changed
Sep 05 07:11:32 a systemd[1]: Time has been changed
Sep 05 07:11:37 a systemd[1]: Time has been changed
Sep 05 07:11:37 a systemd[673]: Time has been changed
Sep 05 07:11:42 a systemd[673]: Time has been changed
Sep 05 07:11:42 a systemd[1]: Time has been changed
Sep 05 07:12:07 a kernel: scsi 1:0:1:0: scsi scan: INQUIRY result too short (5), using 36
Sep 05 07:12:07 a kernel: scsi 1:0:1:1: scsi scan: INQUIRY result too short (5), using 36
Sep 05 07:12:07 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:12:07 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:12:07 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
[Messages are repeated]
Sep 05 07:12:13 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:12:13 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:12:13 a kernel: hv_storvsc vmbus_0_5: cmd 0x2a scsi status 0x0 srb status 0x20
Sep 05 07:12:13 a kernel: hv_storvsc vmbus_0_5: cmd 0x0 scsi status 0x0 srb status 0x20
Sep 05 07:12:13 a kernel: hv_storvsc vmbus_0_5: cmd 0x0 scsi status 0x0 srb status 0x20
Sep 05 07:12:13 a kernel: hv_storvsc vmbus_0_5: cmd 0x0 scsi status 0x0 srb status 0x20
Sep 05 07:12:13 a kernel: hv_storvsc vmbus_0_5: cmd 0x28 scsi status 0x0 srb status 0x20
Sep 05 07:12:13 a kernel: hv_storvsc vmbus_0_5: cmd 0x28 scsi status 0x0 srb status 0x20
Sep 05 07:12:13 a kernel: hv_storvsc vmbus_0_5: cmd 0x28 scsi status 0x0 srb status 0x20
Sep 05 07:12:13 a kernel: hv_storvsc vmbus_0_5: cmd 0x28 scsi status 0x0 srb status 0x20
Sep 05 07:12:13 a kernel: hv_storvsc vmbus_0_5: cmd 0x28 scsi status 0x0 srb status 0x20
Sep 05 07:12:13 a kernel: hv_storvsc vmbus_0_5: cmd 0x28 scsi status 0x0 srb status 0x20
Sep 05 07:12:13 a kernel: hv_storvsc vmbus_0_5: cmd 0x0 scsi status 0x0 srb status 0x20
[Messages are repeated]
Sep 05 07:12:19 a kernel: hv_storvsc vmbus_0_5: cmd 0x0 scsi status 0x0 srb status 0x20
Sep 05 07:12:19 a kernel: hv_storvsc vmbus_0_5: cmd 0x0 scsi status 0x0 srb status 0x20
Sep 05 07:12:19 a kernel: hv_storvsc vmbus_0_5: cmd 0x28 scsi status 0x0 srb status 0x20
Sep 05 07:12:19 a kernel: hv_storvsc vmbus_0_5: cmd 0x28 scsi status 0x0 srb status 0x20
Sep 05 07:12:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x28 scsi status 0x0 srb status 0x20
Sep 05 07:12:54 a kernel: hv_storvsc vmbus_0_5: cmd 0x0 scsi status 0x0 srb status 0x20

At the end even though the VHDX was not attached the node /dev/sdg was
never removed even after fio had been killed off.

It is also possible to temporarily lock up the system (seemingly until
the dd has filled the disk and exits with out of space) by doing a dd to
a Hyper-V VHDX with a large (e.g. 1M) block size and then pulling out
the VHDX being dd'd to.

-- 
Sitsofe | http://sucs.org/~sits/
