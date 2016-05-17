From: Meelis Roos <mroos@linux.ee>
Subject: UBSAN: Undefined behaviour in drivers/scsi/scsi_devinfo.c:457:21
Date: Tue, 17 May 2016 19:45:10 +0300 (EEST)
Message-ID: <alpine.LRH.2.20.1605171942390.12338@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Found another UBSAN warning on 32-bit powerpc, during pata_macio driver 
initialization. I hope it is not a false positive :)

[    2.540935] ================================================================================
[    2.547807] UBSAN: Undefined behaviour in drivers/scsi/scsi_devinfo.c:457:21
[    2.554665] index 8 is out of range for type 'char [8]'
[    2.561498] CPU: 0 PID: 9 Comm: kworker/u2:1 Not tainted 4.6.0-dirty #102
[    2.568395] Workqueue: events_unbound async_run_entry_fn
[    2.575241] Call Trace:
[    2.581953] [ef111bf0] [c0398480] ubsan_epilogue+0x18/0x4c (unreliable)
[    2.588875] [ef111c00] [c0398ba0] __ubsan_handle_out_of_bounds+0x7c/0x90
[    2.595856] [ef111c40] [c049c258] scsi_dev_info_list_find+0x294/0x2d8
[    2.602876] [ef111c80] [c049caf8] scsi_get_device_flags_keyed+0x2c/0xc0
[    2.609860] [ef111ca0] [c0495a10] scsi_probe_and_add_lun+0x398/0x113c
[    2.616837] [ef111d60] [c0496b1c] __scsi_add_device+0x12c/0x158
[    2.623720] [ef111d90] [c04c17f0] ata_scsi_scan_host+0x1a0/0x2f0
[    2.630573] [ef111de0] [c0076c68] async_run_entry_fn+0x68/0x1f8
[    2.637382] [ef111e20] [c0068e34] process_one_work+0x1e8/0x6b8
[    2.644109] [ef111e80] [c0069378] worker_thread+0x74/0x704
[    2.650764] [ef111ef0] [c00731fc] kthread+0xd8/0x134
[    2.657326] [ef111f40] [c0019394] ret_from_kernel_thread+0x5c/0x64
[    2.663877] ================================================================================

-- 
Meelis Roos (mroos@linux.ee)
