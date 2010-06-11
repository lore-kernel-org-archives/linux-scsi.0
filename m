From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 12/17] libfcoe: Host doesnt handle CVL to NPIV ports
Date: Fri, 11 Jun 2010 16:44:31 -0700
Message-ID: <20100611234431.4616.65022.stgit@localhost.localdomain>
References: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:50212 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759952Ab0FKXom (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:44:42 -0400
In-Reply-To: <20100611234328.4616.95199.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Clear virtual link for NPIV ports is now handled by resetting
the matching vnport.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |   42 +++++++++++++++++++++++++++++++++---------
 1 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index db7185c..ce651ca 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -989,7 +989,9 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 	size_t dlen;
 	struct fcoe_fcf *fcf = fip->sel_fcf;
 	struct fc_lport *lport = fip->lp;
-	u32	desc_mask;
+	struct fc_lport *vn_port = NULL;
+	u32 desc_mask;
+	int is_vn_port = 0;
 
 	LIBFCOE_FIP_DBG(fip, "Clear Virtual Link received\n");
 
@@ -1038,8 +1040,26 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 			if (compare_ether_addr(vp->fd_mac,
 					       fip->get_src_addr(lport)) == 0 &&
 			    get_unaligned_be64(&vp->fd_wwpn) == lport->wwpn &&
-			    ntoh24(vp->fd_fc_id) == lport->port_id)
+			    ntoh24(vp->fd_fc_id) == lport->port_id) {
 				desc_mask &= ~BIT(FIP_DT_VN_ID);
+				break;
+			}
+			/* check if clr_vlink is for NPIV port */
+			mutex_lock(&lport->lp_mutex);
+			list_for_each_entry(vn_port, &lport->vports, list) {
+				if (compare_ether_addr(vp->fd_mac,
+				    fip->get_src_addr(vn_port)) == 0 &&
+				    (get_unaligned_be64(&vp->fd_wwpn)
+							== vn_port->wwpn) &&
+				    (ntoh24(vp->fd_fc_id) ==
+					    fc_host_port_id(vn_port->host))) {
+					desc_mask &= ~BIT(FIP_DT_VN_ID);
+					is_vn_port = 1;
+					break;
+				}
+			}
+			mutex_unlock(&lport->lp_mutex);
+
 			break;
 		default:
 			/* standard says ignore unknown descriptors >= 128 */
@@ -1060,14 +1080,18 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 	} else {
 		LIBFCOE_FIP_DBG(fip, "performing Clear Virtual Link\n");
 
-		spin_lock_bh(&fip->lock);
-		per_cpu_ptr(lport->dev_stats,
-			    smp_processor_id())->VLinkFailureCount++;
-		fcoe_ctlr_reset(fip);
-		spin_unlock_bh(&fip->lock);
+		if (is_vn_port)
+			fc_lport_reset(vn_port);
+		else {
+			spin_lock_bh(&fip->lock);
+			per_cpu_ptr(lport->dev_stats,
+				    smp_processor_id())->VLinkFailureCount++;
+			fcoe_ctlr_reset(fip);
+			spin_unlock_bh(&fip->lock);
 
-		fc_lport_reset(fip->lp);
-		fcoe_ctlr_solicit(fip, NULL);
+			fc_lport_reset(fip->lp);
+			fcoe_ctlr_solicit(fip, NULL);
+		}
 	}
 }
 

