From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] IB/srp: Process REQ_PREEMPT requests correctly
Date: Fri, 30 Jan 2015 15:34:24 +0100
Message-ID: <54CB9670.6080108@sandisk.com>
References: <54CA2F48.605@sandisk.com> <54CA8C4C.1080508@cs.wisc.edu>
 <54CAE71C.6020002@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0087.outbound.protection.outlook.com ([65.55.169.87]:38602
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750852AbbA3Oeg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2015 09:34:36 -0500
In-Reply-To: <54CAE71C.6020002@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Roland Dreier <roland@purestorage.com>, Max Gurtuvoy <maxg@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/30/15 03:06, Mike Christie wrote:
> I think I figured this out. I think we want to change the
> scsi_prep_state_check check instead of each driver/class.
> 
> It looks like for the SDEV_QUIESCE state we want to allow REQ_PREEMPT
> commands. James would know best, but I think SPI needs that ability.
> 
> For SDEV_BLOCK/SDEV_CREATED_BLOCK, it looks like drivers/classes that
> use that state do not want any commands to be queued at that time,
> because the transport is normally down.

Hello Mike,

Is something like the patch below what you had in mind ?

Bart.

[PATCH] Defer processing of REQ_PREEMPT requests for blocked devices

SCSI transport drivers and SCSI LLDs block a SCSI device if the
transport layer is not operational. This means that in this state
no requests should be processed, even if the REQ_PREEMPT flag has
been set. This patch avoids that a rescan shortly after a cable
pull sporadically triggers the following kernel oops:

BUG: unable to handle kernel paging request at ffffc9001a6bc084
IP: [<ffffffffa04e08f2>] mlx4_ib_post_send+0xd2/0xb30 [mlx4_ib]
Process rescan-scsi-bus (pid: 9241, threadinfo ffff88053484a000, task ffff880534aae100)
Call Trace:
 [<ffffffffa0718135>] srp_post_send+0x65/0x70 [ib_srp]
 [<ffffffffa071b9df>] srp_queuecommand+0x1cf/0x3e0 [ib_srp]
 [<ffffffffa0001ff1>] scsi_dispatch_cmd+0x101/0x280 [scsi_mod]
 [<ffffffffa0009ad1>] scsi_request_fn+0x411/0x4d0 [scsi_mod]
 [<ffffffff81223b37>] __blk_run_queue+0x27/0x30
 [<ffffffff8122a8d2>] blk_execute_rq_nowait+0x82/0x110
 [<ffffffff8122a9c2>] blk_execute_rq+0x62/0xf0
 [<ffffffffa000b0e8>] scsi_execute+0xe8/0x190 [scsi_mod]
 [<ffffffffa000b2f3>] scsi_execute_req+0xa3/0x130 [scsi_mod]
 [<ffffffffa000c1aa>] scsi_probe_lun+0x17a/0x450 [scsi_mod]
 [<ffffffffa000ce86>] scsi_probe_and_add_lun+0x156/0x480 [scsi_mod]
 [<ffffffffa000dc2f>] __scsi_scan_target+0xdf/0x1f0 [scsi_mod]
 [<ffffffffa000dfa3>] scsi_scan_host_selected+0x183/0x1c0 [scsi_mod]
 [<ffffffffa000edfb>] scsi_scan+0xdb/0xe0 [scsi_mod]
 [<ffffffffa000ee13>] store_scan+0x13/0x20 [scsi_mod]
 [<ffffffff811c8d9b>] sysfs_write_file+0xcb/0x160
 [<ffffffff811589de>] vfs_write+0xce/0x140
 [<ffffffff81158b53>] sys_write+0x53/0xa0
 [<ffffffff81464592>] system_call_fastpath+0x16/0x1b
 [<00007f611c9d9300>] 0x7f611c9d92ff

---
 drivers/scsi/scsi_lib.c   | 4 +++-
 include/linux/blk_types.h | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 17bb541..7129701 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1311,9 +1311,11 @@ scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 				    "rejecting I/O to dead device\n");
 			ret = BLKPREP_KILL;
 			break;
-		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
 		case SDEV_CREATED_BLOCK:
+			ret = BLKPREP_DEFER;
+			break;
+		case SDEV_QUIESCE:
 			/*
 			 * If the devices is blocked we defer normal commands.
 			 */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index c294e3e..a1b25e3 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -181,7 +181,9 @@ enum rq_flag_bits {
 	__REQ_ELVPRIV,		/* elevator private data attached */
 	__REQ_FAILED,		/* set if the request failed */
 	__REQ_QUIET,		/* don't worry about errors */
-	__REQ_PREEMPT,		/* set for "ide_preempt" requests */
+	__REQ_PREEMPT,		/* set for "ide_preempt" requests and also
+				   for requests for which the SCSI "quiesce"
+				   state must be ignored. */
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_COPY_USER,	/* contains copies of user pages */
 	__REQ_FLUSH_SEQ,	/* request for flush sequence */
-- 
2.1.4


