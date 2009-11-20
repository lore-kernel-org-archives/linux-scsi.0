From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 6/9] libfcoe: add tracking FIP Missing Discovery Advertisement
	count
Date: Fri, 20 Nov 2009 14:55:08 -0800
Message-ID: <20091120225508.495.41031.stgit@localhost.localdomain>
References: <20091120225436.495.88600.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417AbZKTWzC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2009 17:55:02 -0500
In-Reply-To: <20091120225436.495.88600.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

Add tracking the Missing Discovery Advertisement count for FIP Fiber Channel
Forwarder (FCF) as described in FC-BB-5 Rev2.0 for LESB. The time is 1.5 times
the FKA_ADV_PERIOD of the corresponding FCF.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 34800af..9823291 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -562,14 +562,28 @@ EXPORT_SYMBOL(fcoe_ctlr_els_send);
  * times its keep-alive period including fuzz.
  *
  * In addition, determine the time when an FCF selection can occur.
+ *
+ * Also, increment the MissDiscAdvCount when no advertisement is received
+ * for the corresponding FCF for 1.5 * FKA_ADV_PERIOD (FC-BB-5 LESB).
  */
 static void fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 {
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf *next;
 	unsigned long sel_time = 0;
+	unsigned long mda_time = 0;
 
 	list_for_each_entry_safe(fcf, next, &fip->fcfs, list) {
+		mda_time = fcf->fka_period + (fcf->fka_period >> 1);
+		if ((fip->sel_fcf == fcf) &&
+		    (time_after(jiffies, fcf->time + mda_time))) {
+			mod_timer(&fip->timer, jiffies + mda_time);
+			fc_lport_get_stats(fip->lp)->MissDiscAdvCount++;
+			printk(KERN_INFO "libfcoe: host%d: Missing Discovery "
+			       "Advertisement for fab %llx count %lld\n",
+			       fip->lp->host->host_no, fcf->fabric_name,
+			       fc_lport_get_stats(fip->lp)->MissDiscAdvCount);
+		}
 		if (time_after(jiffies, fcf->time + fcf->fka_period * 3 +
 			       msecs_to_jiffies(FIP_FCF_FUZZ * 3))) {
 			if (fip->sel_fcf == fcf)

