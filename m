From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 20/24] libfc: add host number to lport link up/down messages.
Date: Fri, 18 Sep 2009 15:50:48 -0700
Message-ID: <20090918225048.5928.44796.stgit@localhost.localdomain>
References: <20090918224847.5928.52092.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57854 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758845AbZIRWuo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:50:44 -0400
In-Reply-To: <20090918224847.5928.52092.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Joe Eykholt <jeykholt@cisco.com>

The libfc link up/down messages don't indicate which port is changing.
The Port ID will often be 0.

Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_lport.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 2f0d2ab..58c145c 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -568,8 +568,8 @@ void __fc_linkup(struct fc_lport *lport)
  */
 void fc_linkup(struct fc_lport *lport)
 {
-	printk(KERN_INFO "libfc: Link up on port (%6x)\n",
-	       fc_host_port_id(lport->host));
+	printk(KERN_INFO "host%d: libfc: Link up on port (%6x)\n",
+	       lport->host->host_no, fc_host_port_id(lport->host));
 
 	mutex_lock(&lport->lp_mutex);
 	__fc_linkup(lport);
@@ -598,8 +598,8 @@ void __fc_linkdown(struct fc_lport *lport)
  */
 void fc_linkdown(struct fc_lport *lport)
 {
-	printk(KERN_INFO "libfc: Link down on port (%6x)\n",
-	       fc_host_port_id(lport->host));
+	printk(KERN_INFO "host%d: libfc: Link down on port (%6x)\n",
+	       lport->host->host_no, fc_host_port_id(lport->host));
 
 	mutex_lock(&lport->lp_mutex);
 	__fc_linkdown(lport);
@@ -699,8 +699,9 @@ void fc_lport_disc_callback(struct fc_lport *lport, enum fc_disc_event event)
 		FC_LPORT_DBG(lport, "Discovery succeeded\n");
 		break;
 	case DISC_EV_FAILED:
-		printk(KERN_ERR "libfc: Discovery failed for port (%6x)\n",
-		       fc_host_port_id(lport->host));
+		printk(KERN_ERR "host%d: libfc: "
+		       "Discovery failed for port (%6x)\n",
+		       lport->host->host_no, fc_host_port_id(lport->host));
 		mutex_lock(&lport->lp_mutex);
 		fc_lport_enter_reset(lport);
 		mutex_unlock(&lport->lp_mutex);
@@ -791,8 +792,9 @@ static void fc_lport_recv_flogi_req(struct fc_seq *sp_in,
 		goto out;
 	remote_wwpn = get_unaligned_be64(&flp->fl_wwpn);
 	if (remote_wwpn == lport->wwpn) {
-		printk(KERN_WARNING "libfc: Received FLOGI from port "
-		       "with same WWPN %llx\n", remote_wwpn);
+		printk(KERN_WARNING "host%d: libfc: Received FLOGI from port "
+		       "with same WWPN %llx\n",
+		       lport->host->host_no, remote_wwpn);
 		goto out;
 	}
 	FC_LPORT_DBG(lport, "FLOGI from port WWPN %llx\n", remote_wwpn);
@@ -1471,8 +1473,10 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 					lport->e_d_tov = e_d_tov;
 				lport->r_a_tov = 2 * e_d_tov;
 				fc_lport_set_port_id(lport, did, fp);
-				printk(KERN_INFO "libfc: Port (%6x) entered "
-				       "point to point mode\n", did);
+				printk(KERN_INFO "host%d: libfc: "
+				       "Port (%6x) entered "
+				       "point-to-point mode\n",
+				       lport->host->host_no, did);
 				fc_lport_ptp_setup(lport, ntoh24(fh->fh_s_id),
 						   get_unaligned_be64(
 							   &flp->fl_wwpn),

