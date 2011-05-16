From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 1/8] libfcoe: Incorrect CVL handling for NPIV ports
Date: Mon, 16 May 2011 16:45:24 -0700
Message-ID: <20110516234524.24502.8936.stgit@localhost6.localdomain6>
References: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61983 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab1EPXpZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2011 19:45:25 -0400
In-Reply-To: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Host doesnt handle CVL to NPIV instantiated ports correctly.
- As per FC-BB-5 Rev 2 CVLs with no VN_Port descriptors shall be treated as
  implicit logout of ALL vn_ports.
- CVL for NPIV ports should be handled before physical port even if descriptor
  for physical port appears before NPIV ports

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c |  133 ++++++++++++++++++++++++++++-------------
 1 files changed, 90 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 229e4af..c74c4b8 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1173,7 +1173,9 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 	struct fc_lport *lport = fip->lp;
 	struct fc_lport *vn_port = NULL;
 	u32 desc_mask;
-	int is_vn_port = 0;
+	int num_vlink_desc;
+	int reset_phys_port = 0;
+	struct fip_vn_desc **vlink_desc_arr = NULL;
 
 	LIBFCOE_FIP_DBG(fip, "Clear Virtual Link received\n");
 
@@ -1183,70 +1185,73 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 	/*
 	 * mask of required descriptors.  Validating each one clears its bit.
 	 */
-	desc_mask = BIT(FIP_DT_MAC) | BIT(FIP_DT_NAME) | BIT(FIP_DT_VN_ID);
+	desc_mask = BIT(FIP_DT_MAC) | BIT(FIP_DT_NAME);
 
 	rlen = ntohs(fh->fip_dl_len) * FIP_BPW;
 	desc = (struct fip_desc *)(fh + 1);
+
+	/*
+	 * Actually need to subtract 'sizeof(*mp) - sizeof(*wp)' from 'rlen'
+	 * before determining max Vx_Port descriptor but a buggy FCF could have
+	 * omited either or both MAC Address and Name Identifier descriptors
+	 */
+	num_vlink_desc = rlen / sizeof(*vp);
+	if (num_vlink_desc)
+		vlink_desc_arr = kmalloc(sizeof(vp) * num_vlink_desc,
+					 GFP_ATOMIC);
+	if (!vlink_desc_arr)
+		return;
+	num_vlink_desc = 0;
+
 	while (rlen >= sizeof(*desc)) {
 		dlen = desc->fip_dlen * FIP_BPW;
 		if (dlen > rlen)
-			return;
+			goto err;
 		/* Drop CVL if there are duplicate critical descriptors */
 		if ((desc->fip_dtype < 32) &&
+		    (desc->fip_dtype != FIP_DT_VN_ID) &&
 		    !(desc_mask & 1U << desc->fip_dtype)) {
 			LIBFCOE_FIP_DBG(fip, "Duplicate Critical "
 					"Descriptors in FIP CVL\n");
-			return;
+			goto err;
 		}
 		switch (desc->fip_dtype) {
 		case FIP_DT_MAC:
 			mp = (struct fip_mac_desc *)desc;
 			if (dlen < sizeof(*mp))
-				return;
+				goto err;
 			if (compare_ether_addr(mp->fd_mac, fcf->fcf_mac))
-				return;
+				goto err;
 			desc_mask &= ~BIT(FIP_DT_MAC);
 			break;
 		case FIP_DT_NAME:
 			wp = (struct fip_wwn_desc *)desc;
 			if (dlen < sizeof(*wp))
-				return;
+				goto err;
 			if (get_unaligned_be64(&wp->fd_wwn) != fcf->switch_name)
-				return;
+				goto err;
 			desc_mask &= ~BIT(FIP_DT_NAME);
 			break;
 		case FIP_DT_VN_ID:
 			vp = (struct fip_vn_desc *)desc;
 			if (dlen < sizeof(*vp))
-				return;
-			if (compare_ether_addr(vp->fd_mac,
-					       fip->get_src_addr(lport)) == 0 &&
-			    get_unaligned_be64(&vp->fd_wwpn) == lport->wwpn &&
-			    ntoh24(vp->fd_fc_id) == lport->port_id) {
-				desc_mask &= ~BIT(FIP_DT_VN_ID);
-				break;
+				goto err;
+			vlink_desc_arr[num_vlink_desc++] = vp;
+			vn_port = fc_vport_id_lookup(lport,
+						      ntoh24(vp->fd_fc_id));
+			if (vn_port && (vn_port == lport)) {
+				mutex_lock(&fip->ctlr_mutex);
+				per_cpu_ptr(lport->dev_stats,
+					    get_cpu())->VLinkFailureCount++;
+				put_cpu();
+				fcoe_ctlr_reset(fip);
+				mutex_unlock(&fip->ctlr_mutex);
 			}
-			/* check if clr_vlink is for NPIV port */
-			mutex_lock(&lport->lp_mutex);
-			list_for_each_entry(vn_port, &lport->vports, list) {
-				if (compare_ether_addr(vp->fd_mac,
-				    fip->get_src_addr(vn_port)) == 0 &&
-				    (get_unaligned_be64(&vp->fd_wwpn)
-							== vn_port->wwpn) &&
-				    (ntoh24(vp->fd_fc_id) ==
-					    fc_host_port_id(vn_port->host))) {
-					desc_mask &= ~BIT(FIP_DT_VN_ID);
-					is_vn_port = 1;
-					break;
-				}
-			}
-			mutex_unlock(&lport->lp_mutex);
-
 			break;
 		default:
 			/* standard says ignore unknown descriptors >= 128 */
 			if (desc->fip_dtype < FIP_DT_VENDOR_BASE)
-				return;
+				goto err;
 			break;
 		}
 		desc = (struct fip_desc *)((char *)desc + dlen);
@@ -1256,26 +1261,68 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 	/*
 	 * reset only if all required descriptors were present and valid.
 	 */
-	if (desc_mask) {
+	if (desc_mask)
 		LIBFCOE_FIP_DBG(fip, "missing descriptors mask %x\n",
 				desc_mask);
+	else if (!num_vlink_desc) {
+		LIBFCOE_FIP_DBG(fip, "CVL: no Vx_Port descriptor found\n");
+		/*
+		 * No Vx_Port description. Clear all NPIV ports,
+		 * followed by physical port
+		 */
+		mutex_lock(&lport->lp_mutex);
+		list_for_each_entry(vn_port, &lport->vports, list)
+			fc_lport_reset(vn_port);
+		mutex_unlock(&lport->lp_mutex);
+
+		mutex_lock(&fip->ctlr_mutex);
+		per_cpu_ptr(lport->dev_stats,
+			    get_cpu())->VLinkFailureCount++;
+		put_cpu();
+		fcoe_ctlr_reset(fip);
+		mutex_unlock(&fip->ctlr_mutex);
+
+		fc_lport_reset(fip->lp);
+		fcoe_ctlr_solicit(fip, NULL);
 	} else {
-		LIBFCOE_FIP_DBG(fip, "performing Clear Virtual Link\n");
+		int i;
 
-		if (is_vn_port)
-			fc_lport_reset(vn_port);
-		else {
-			mutex_lock(&fip->ctlr_mutex);
-			per_cpu_ptr(lport->dev_stats,
-				    get_cpu())->VLinkFailureCount++;
-			put_cpu();
-			fcoe_ctlr_reset(fip);
-			mutex_unlock(&fip->ctlr_mutex);
+		LIBFCOE_FIP_DBG(fip, "performing Clear Virtual Link\n");
+		for (i = 0; i < num_vlink_desc; i++) {
+			vp = vlink_desc_arr[i];
+			vn_port = fc_vport_id_lookup(lport,
+						     ntoh24(vp->fd_fc_id));
+			if (!vn_port)
+				continue;
+
+			/*
+			 * 'port_id' is already validated, check MAC address and
+			 * wwpn
+			 */
+			if (compare_ether_addr(fip->get_src_addr(vn_port),
+						vp->fd_mac) != 0 ||
+				get_unaligned_be64(&vp->fd_wwpn) !=
+							vn_port->wwpn)
+				continue;
+
+			if (vn_port == lport)
+				/*
+				 * Physical port, defer processing till all
+				 * listed NPIV ports are cleared
+				 */
+				reset_phys_port = 1;
+			else    /* NPIV port */
+				fc_lport_reset(vn_port);
+		}
 
+		if (reset_phys_port) {
 			fc_lport_reset(fip->lp);
 			fcoe_ctlr_solicit(fip, NULL);
 		}
 	}
+
+err:
+	kfree(vlink_desc_arr);
 }
 
 /**

