From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v2 08/10] fcoe: Use fabric attributes
Date: Mon, 22 Aug 2011 15:49:03 -0700
Message-ID: <20110822224903.1854.62693.stgit@localhost6.localdomain6>
References: <20110822224822.1854.81079.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:8269 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab1HVWtE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2011 18:49:04 -0400
In-Reply-To: <20110822224822.1854.81079.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch has the fcoe protocol stack select to display
the previously added fabric attributes. The patch adds
some helper routines in libfcoe to get information from
the internal 'struct fcoe_fcf', which is private to the
FC Transport's 'struct fc_fabric'.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c      |   14 +++++++++++++
 drivers/scsi/fcoe/fcoe_ctlr.c |   45 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/libfc/fc_lport.c |    1 +
 include/scsi/libfc.h          |    1 +
 include/scsi/libfcoe.h        |    6 +++++
 5 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index fb8a504..4825c0a 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -176,7 +176,21 @@ struct fc_function_template fcoe_nport_fc_functions = {
 
 	.dd_fcfabric_size = sizeof(struct fcoe_fcf),
 	.fabric_match = fcoe_fabric_match,
+	.get_fabric_pri = fcoe_get_fabric_pri,
+	.get_fabric_r_a_tov = fcoe_get_fabric_ra_tov,
+	.get_fabric_e_d_tov = fcoe_get_fabric_ed_tov,
+	.get_fabric_selected = fcoe_get_fabric_selected,
 	.show_fabric_fabric_name = 1,
+	.show_fabric_switch_name = 1,
+	.show_fabric_fc_map = 1,
+	.show_fabric_vfid = 1,
+	.show_fabric_mac = 1,
+	.show_fabric_pri = 1,
+	.show_fabric_fka_period = 1,
+	.show_fabric_r_a_tov = 1,
+	.show_fabric_e_d_tov = 1,
+	.show_fabric_csp_flags = 1,
+	.show_fabric_selected = 1,
 
 	.fabric_create = fcoe_fabric_create,
 	.fabric_destroy = fcoe_fabric_destroy,
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 3cabc08..d731ca9 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -325,6 +325,15 @@ static void fcoe_fcf_work(struct work_struct *work)
 		list_add(&fcf->list, &fip->fcfs);
 
 		fcoe_ctlr_process_fcf(fip, fcf, first);
+
+		/* Setup fabric attributes for sysfs */
+		fabric->fabric_name = fcf->fabric_name;
+		fabric->switch_name = fcf->switch_name;
+		fabric->fc_map = fcf->fc_map;
+		fabric->vfid = fcf->vfid;
+		memcpy(fabric->mac, fcf->fcf_mac, ETH_ALEN);
+		fabric->fka_period = fcf->fka_period;
+
 		fcf->event = FCF_EV_NONE;
 		kfree(temp);
 		kfree(new);
@@ -949,6 +958,7 @@ static int fcoe_ctlr_parse_adv(struct fcoe_ctlr *fip,
 		case FIP_DT_PRI:
 			if (dlen != sizeof(struct fip_pri_desc))
 				goto len_err;
+
 			fcf->pri = ((struct fip_pri_desc *)desc)->fd_pri;
 			desc_mask &= ~BIT(FIP_DT_PRI);
 			break;
@@ -1027,6 +1037,41 @@ len_err:
 	return -EINVAL;
 }
 
+void fcoe_get_fabric_pri(struct fc_fabric *fabric)
+{
+	struct fcoe_fcf *fcf = fc_fabric_priv(fabric);
+	fabric->pri = fcf->pri;
+}
+EXPORT_SYMBOL(fcoe_get_fabric_pri);
+
+void fcoe_get_fabric_ed_tov(struct fc_fabric *fabric)
+{
+	struct fcoe_fcf *fcf = fc_fabric_priv(fabric);
+	fabric->e_d_tov = fcf->fip->lp->e_d_tov;
+}
+EXPORT_SYMBOL(fcoe_get_fabric_ed_tov);
+
+void fcoe_get_fabric_ra_tov(struct fc_fabric *fabric)
+{
+	struct fcoe_fcf *fcf = fc_fabric_priv(fabric);
+	fabric->r_a_tov = fcf->fip->lp->r_a_tov;
+}
+EXPORT_SYMBOL(fcoe_get_fabric_ra_tov);
+
+void fcoe_get_fabric_csp_flags(struct fc_fabric *fabric)
+{
+	struct fcoe_fcf *fcf = fc_fabric_priv(fabric);
+	fabric->csp_flags = fcf->fip->lp->fabric_csp_flags;
+}
+EXPORT_SYMBOL(fcoe_get_fabric_csp_flags);
+
+void fcoe_get_fabric_selected(struct fc_fabric *fabric)
+{
+	struct fcoe_fcf *fcf = fc_fabric_priv(fabric);
+	fabric->selected = (fcf == fcf->fip->sel_fcf) ? 1 : 0;
+}
+EXPORT_SYMBOL(fcoe_get_fabric_selected);
+
 /**
  * fcoe_ctlr_process_fcf() - Process a new FCF
  * @fip:   The controller that discovered the new FCF
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 6be4a8f..d85a326 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1542,6 +1542,7 @@ void fc_lport_flogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 			} else {
 				lport->e_d_tov = e_d_tov;
 				lport->r_a_tov = r_a_tov;
+				lport->fabric_csp_flags = csp_flags;
 				fc_host_fabric_name(lport->host) =
 					get_unaligned_be64(&flp->fl_wwnn);
 				fc_lport_set_port_id(lport, did, fp);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 7d96829..17b080a 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -877,6 +877,7 @@ struct fc_lport {
 	unsigned int		       service_params;
 	unsigned int		       e_d_tov;
 	unsigned int		       r_a_tov;
+	u16                            fabric_csp_flags;
 	struct fc_els_rnid_gen	       rnid_gen;
 
 	/* Capabilities */
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 2c03c6c..bc5ff13 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -364,6 +364,12 @@ struct fcoe_netdev_mapping {
 	struct fcoe_transport *ft;
 };
 
+/* Helpers for fc_function_template get_* routines */
+void fcoe_get_fabric_pri(struct fc_fabric *);
+void fcoe_get_fabric_ed_tov(struct fc_fabric *);
+void fcoe_get_fabric_ra_tov(struct fc_fabric *);
+void fcoe_get_fabric_selected(struct fc_fabric *);
+
 /* fcoe transports registration and deregistration */
 int fcoe_transport_attach(struct fcoe_transport *ft);
 int fcoe_transport_detach(struct fcoe_transport *ft);

