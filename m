From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 7/8] fcoe: Stop fc_rport_priv structure leak
Date: Tue, 09 Jul 2013 12:47:42 -0700
Message-ID: <20130709194742.10724.43159.stgit@fritz>
References: <20130709194705.10724.64013.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:20501 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab3GITsI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jul 2013 15:48:08 -0400
In-Reply-To: <20130709194705.10724.64013.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Morgan <jack.morgan@intel.com>, Mark Rustad <mark.d.rustad@intel.com>

From: Mark Rustad <mark.d.rustad@intel.com>

When repeatedly doing rmmod and modprobe on the ixgbe
driver while FCoE is active in a VN2VN configuration,
memory leaks would be discovered by kmemleak with the
following backtrace:

unreferenced object 0xffff88003d076000 (size 1024):
  comm "kworker/0:3", pid 2998, jiffies 4295436448 (age 1015.332s)
  hex dump (first 32 bytes):
    48 8a fe 6f 00 88 ff ff 00 00 00 00 00 00 00 00  H..o............
    01 00 00 00 02 00 00 00 7b ac 87 21 1b 00 00 10  ........{..!....
  backtrace:
    [<ffffffff814b308b>] kmemleak_alloc+0x5b/0xc0
    [<ffffffff8115c6e8>] __kmalloc+0xd8/0x1b0
    [<ffffffffa0216638>] fc_rport_create+0x48/0x1f0 [libfc]
    [<ffffffffa023cd86>] fcoe_ctlr_vn_add.isra.10+0x56/0x1a0 [libfcoe]
    [<ffffffffa023f440>] fcoe_ctlr_vn_recv+0x8b0/0xab0 [libfcoe]
    [<ffffffffa023fb06>] fcoe_ctlr_recv_work+0x4c6/0xf60 [libfcoe]
    [<ffffffff81067404>] process_one_work+0x1e4/0x4d0
    [<ffffffff81068def>] worker_thread+0x10f/0x380
    [<ffffffff8107019a>] kthread+0xea/0xf0
    [<ffffffff814d32ec>] ret_from_fork+0x7c/0xb0
    [<ffffffffffffffff>] 0xffffffffffffffff

This patch stops the leak of the fc_rport_priv structure.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Tested-by: Jack Morgan <jack.morgan@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 795843d..203415e 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2090,7 +2090,11 @@ static struct fc_rport_operations fcoe_ctlr_vn_rport_ops = {
  */
 static void fcoe_ctlr_disc_stop_locked(struct fc_lport *lport)
 {
+	struct fc_rport_priv *rdata;
+
 	mutex_lock(&lport->disc.disc_mutex);
+	list_for_each_entry_rcu(rdata, &lport->disc.rports, peers)
+		lport->tt.rport_logoff(rdata);
 	lport->disc.disc_callback = NULL;
 	mutex_unlock(&lport->disc.disc_mutex);
 }

