From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/10] fcoe: avoid getting into dev_queue_xmit with bottom
 halves disabled
Date: Fri, 09 Mar 2012 14:49:43 -0800
Message-ID: <20120309224942.6515.83069.stgit@localhost6.localdomain6>
References: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51952 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400Ab2CIWtn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Mar 2012 17:49:43 -0500
In-Reply-To: <20120309224937.6515.83801.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>

From: Neil Horman <nhorman@tuxdriver.com>

Recieved this warning recently:

WARNING: at kernel/softirq.c:143 local_bh_enable+0x7d/0xb0() (Not tainted)
Hardware name: C6100
Modules linked in: autofs4 bnx2fc cnic uio fcoe libfcoe libfc scsi_transport_fc
scsi_tgt 8021q garp stp llc sunrpc cpufreq_ondemand acpi_cpufreq freq_table
mperf ipv6 ixgbe mdio igb dcdbas microcode i2c_i801 i2c_core sg iTCO_wdt
iTCO_vendor_support ioatdma dca i7core_edac edac_core shpchp ext4 mbcache jbd2
sd_mod crc_t10dif ahci dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
scsi_wait_scan]
Pid: 4926, comm: fc_rport_eq Not tainted 2.6.32 #2
Call Trace:
 [<ffffffff81069c67>] ? warn_slowpath_common+0x87/0xc0
 [<ffffffff81069cba>] ? warn_slowpath_null+0x1a/0x20
 [<ffffffff8107216d>] ? local_bh_enable+0x7d/0xb0
 [<ffffffff81433567>] ? dev_queue_xmit+0x177/0x6c0
 [<ffffffffa0293a34>] ? vlan_dev_hwaccel_hard_start_xmit+0x84/0xb0 [8021q]
 [<ffffffff8142f46c>] ? dev_hard_start_xmit+0x2bc/0x3f0
 [<ffffffff8143392e>] ? dev_queue_xmit+0x53e/0x6c0
 [<ffffffff8142348e>] ? __skb_clone+0x2e/0x120
 [<ffffffffa02ea83d>] ? fcoe_clean_pending_queue+0xcd/0x100 [libfcoe]
 [<ffffffff810559ca>] ? find_busiest_group+0x9aa/0xb20
 [<ffffffffa02f7624>] ? fcoe_port_send+0x24/0x50 [fcoe]
 [<ffffffffa02f9568>] ? fcoe_xmit+0x228/0x3e0 [fcoe]
 [<ffffffffa02c1896>] ? fc_seq_send+0xb6/0x160 [libfc]
 [<ffffffffa02c1a76>] ? fc_exch_abort_locked+0x136/0x1c0 [libfc]
 [<ffffffffa02c1ca7>] ? fc_exch_mgr_reset+0x147/0x2a0 [libfc]
 [<ffffffff814f2c7e>] ? _spin_unlock_irq+0xe/0x20
 [<ffffffffa02c91d3>] ? fc_rport_work+0x123/0x5f0 [libfc]
 [<ffffffffa02c90b0>] ? fc_rport_work+0x0/0x5f0 [libfc]
 [<ffffffff8108b559>] ? worker_thread+0x179/0x2a0
 [<ffffffff81090ea0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8108b3e0>] ? worker_thread+0x0/0x2a0
 [<ffffffff81090b56>] ? kthread+0x96/0xa0
 [<ffffffff8100c10a>] ? child_rip+0xa/0x20
 [<ffffffff81090ac0>] ? kthread+0x0/0xa0
 [<ffffffff8100c100>] ? child_rip+0x0/0x20

fc_exch_abort_locked attempts to send an abort frame, but it does so with a
spinlock held and irqs/bh's disabled.  Because of this dev_queue_xmit issues a
warning. This patch allows the fc_exch_abort_locked to drop and re-acquire the
lock so that the warning is suppressed.

Note this isn't a great fix, given that we need to free and re-acquire the
ex_lock during the fc_exch_abort_locked operation, but any other solution is
going to be a fairly major undertaking I think.  This should work until a proper
fix can be found.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |   31 ++++++++++++++++++++++++++-----
 include/scsi/libfc.h         |    1 +
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 630291f..588060f 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -594,16 +594,23 @@ static int fc_exch_abort_locked(struct fc_exch *ep,
 	struct fc_frame *fp;
 	int error;
 
+	if (ep->in_locked_transaction == true)
+		return -EAGAIN;
+
+	ep->in_locked_transaction = true;
+
+	error = -ENXIO;
 	if (ep->esb_stat & (ESB_ST_COMPLETE | ESB_ST_ABNORMAL) ||
 	    ep->state & (FC_EX_DONE | FC_EX_RST_CLEANUP))
-		return -ENXIO;
+		goto out;
 
 	/*
 	 * Send the abort on a new sequence if possible.
 	 */
+	error = -ENOMEM;
 	sp = fc_seq_start_next_locked(&ep->seq);
 	if (!sp)
-		return -ENOMEM;
+		goto out;
 
 	ep->esb_stat |= ESB_ST_SEQ_INIT | ESB_ST_ABNORMAL;
 	if (timer_msec)
@@ -613,8 +620,9 @@ static int fc_exch_abort_locked(struct fc_exch *ep,
 	 * If not logged into the fabric, don't send ABTS but leave
 	 * sequence active until next timeout.
 	 */
+	error = 0;
 	if (!ep->sid)
-		return 0;
+		goto out;
 
 	/*
 	 * Send an abort for the sequence that timed out.
@@ -623,9 +631,13 @@ static int fc_exch_abort_locked(struct fc_exch *ep,
 	if (fp) {
 		fc_fill_fc_hdr(fp, FC_RCTL_BA_ABTS, ep->did, ep->sid,
 			       FC_TYPE_BLS, FC_FC_END_SEQ | FC_FC_SEQ_INIT, 0);
+		spin_unlock_bh(&ep->ex_lock);
 		error = fc_seq_send(ep->lp, sp, fp);
+		spin_lock_bh(&ep->ex_lock);
 	} else
 		error = -ENOBUFS;
+out:
+	ep->in_locked_transaction = false;
 	return error;
 }
 
@@ -645,9 +657,12 @@ static int fc_seq_exch_abort(const struct fc_seq *req_sp,
 	int error;
 
 	ep = fc_seq_exch(req_sp);
+retry:
 	spin_lock_bh(&ep->ex_lock);
 	error = fc_exch_abort_locked(ep, timer_msec);
 	spin_unlock_bh(&ep->ex_lock);
+	if (error == -EAGAIN)
+		goto retry;
 	return error;
 }
 
@@ -1732,10 +1747,16 @@ static void fc_exch_reset(struct fc_exch *ep)
 	struct fc_seq *sp;
 	void (*resp)(struct fc_seq *, struct fc_frame *, void *);
 	void *arg;
-	int rc = 1;
+	int rc;
 
+retry:
 	spin_lock_bh(&ep->ex_lock);
-	fc_exch_abort_locked(ep, 0);
+	rc = fc_exch_abort_locked(ep, 0);
+	if (rc == -EAGAIN) {
+		spin_unlock_bh(&ep->ex_lock);
+		goto retry;
+	}
+
 	ep->state |= FC_EX_RST_CLEANUP;
 	if (cancel_delayed_work(&ep->timeout_work))
 		atomic_dec(&ep->ex_refcnt);	/* drop hold for timer */
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 8f9dfba..0a4ceb8 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -438,6 +438,7 @@ struct fc_exch {
 	void		    (*resp)(struct fc_seq *, struct fc_frame *, void *);
 	void		    *arg;
 	void		    (*destructor)(struct fc_seq *, void *);
+	bool		    in_locked_transaction;
 	struct delayed_work timeout_work;
 } ____cacheline_aligned_in_smp;
 #define	fc_seq_exch(sp) container_of(sp, struct fc_exch, seq)

