From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 3/3] libfc: Fix fc_fcp_cleanup_each_cmd()
Date: Fri, 05 Jun 2015 14:20:51 -0700
Message-ID: <20150605212051.6054.20713.stgit@lin-nd1-054.jf.intel.com>
References: <20150605212003.6054.15351.stgit@lin-nd1-054.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20150605212003.6054.15351.stgit@lin-nd1-054.jf.intel.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: fcoe-devel@open-fcoe.org, target-devel <target-devel@vger.kernel.org>, Bart Van Assche <bart.vanassche@sandisk.com>, stable <stable@vger.kernel.org>, Vasu Dev <vasu.dev@intel.com>
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bart.vanassche@sandisk.com>

Since fc_fcp_cleanup_cmd() can sleep this function must not
be called while holding a spinlock. This patch avoids that
fc_fcp_cleanup_each_cmd() triggers the following bug:

BUG: scheduling while atomic: sg_reset/1512/0x00000202
1 lock held by sg_reset/1512:
 #0:  (&(&fsp->scsi_pkt_lock)->rlock){+.-...}, at: [<ffffffffc0225cd5>] fc_fcp_cleanup_each_cmd.isra.21+0xa5/0x150 [libfc]
Preemption disabled at:[<ffffffffc0225cd5>] fc_fcp_cleanup_each_cmd.isra.21+0xa5/0x150 [libfc]
Call Trace:
 [<ffffffff816c612c>] dump_stack+0x4f/0x7b
 [<ffffffff810828bc>] __schedule_bug+0x6c/0xd0
 [<ffffffff816c87aa>] __schedule+0x71a/0xa10
 [<ffffffff816c8ad2>] schedule+0x32/0x80
 [<ffffffffc0217eac>] fc_seq_set_resp+0xac/0x100 [libfc]
 [<ffffffffc0218b11>] fc_exch_done+0x41/0x60 [libfc]
 [<ffffffffc0225cff>] fc_fcp_cleanup_each_cmd.isra.21+0xcf/0x150 [libfc]
 [<ffffffffc0225f43>] fc_eh_device_reset+0x1c3/0x270 [libfc]
 [<ffffffff814a2cc9>] scsi_try_bus_device_reset+0x29/0x60
 [<ffffffff814a3908>] scsi_ioctl_reset+0x258/0x2d0
 [<ffffffff814a2650>] scsi_ioctl+0x150/0x440
 [<ffffffff814b3a9d>] sd_ioctl+0xad/0x120
 [<ffffffff8132f266>] blkdev_ioctl+0x1b6/0x810
 [<ffffffff811da608>] block_ioctl+0x38/0x40
 [<ffffffff811b4e08>] do_vfs_ioctl+0x2f8/0x530
 [<ffffffff811b50c1>] SyS_ioctl+0x81/0xa0
 [<ffffffff816cf8b2>] system_call_fastpath+0x16/0x7a

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: stable <stable@vger.kernel.org>

[ Added TODO notes to fix by removing entire schedule() code flow
  as discussed here at:
  http://lists.open-fcoe.org/pipermail/fcoe-devel/2015-May/012471.html ]

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 4cd49d4..5121272 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1039,11 +1039,26 @@ restart:
 		fc_fcp_pkt_hold(fsp);
 		spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
 
-		if (!fc_fcp_lock_pkt(fsp)) {
+		spin_lock_bh(&fsp->scsi_pkt_lock);
+		if (!(fsp->state & FC_SRB_COMPL)) {
+			fsp->state |= FC_SRB_COMPL;
+			/*
+			 * TODO: dropping scsi_pkt_lock and then reacquiring
+			 * again around fc_fcp_cleanup_cmd() is required,
+			 * since fc_fcp_cleanup_cmd() calls into
+			 * fc_seq_set_resp() and that func preempts cpu using
+			 * schedule. May be schedule and related code should be
+			 * removed instead of unlocking here to avoid scheduling
+			 * while atomic bug.
+			 */
+			spin_unlock_bh(&fsp->scsi_pkt_lock);
+
 			fc_fcp_cleanup_cmd(fsp, error);
+
+			spin_lock_bh(&fsp->scsi_pkt_lock);
 			fc_io_compl(fsp);
-			fc_fcp_unlock_pkt(fsp);
 		}
+		spin_unlock_bh(&fsp->scsi_pkt_lock);
 
 		fc_fcp_pkt_release(fsp);
 		spin_lock_irqsave(&si->scsi_queue_lock, flags);
