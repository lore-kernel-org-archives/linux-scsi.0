From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 4/5] fcoe: removed kzalloc from fcoe_ctlr_parse_adv (v3)
Date: Wed, 04 Mar 2009 10:53:58 -0800
Message-ID: <20090304185358.22010.75646.stgit@vi2.jf.intel.com>
References: <20090304185025.22010.45242.stgit@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19082 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbZCDSyA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Mar 2009 13:54:00 -0500
In-Reply-To: <20090304185025.22010.45242.stgit@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch eliminates fcoe_fcf memory allocation in fcoe_ctlr_parse_adv
for each incoming advertisement by having fcoe_ctlr_parse_adv caller provide
the fcoe_fcf pointer for parsing. The only current caller fcoe_ctlr_recv_adv
allocates fcoe_fcf memory only when a new FCF needs to be added to the FCFs
list.

	Modified fcoe_ctlr_parse_adv ret value to int and fcoe_ctlr_recv_adv call
flow accordingly around fcoe_ctlr_parse_adv calling.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/libfcoe/fcoe_ctlr.c |   67 +++++++++++++++++++-------------------
 1 files changed, 33 insertions(+), 34 deletions(-)


diff --git a/drivers/scsi/libfcoe/fcoe_ctlr.c b/drivers/scsi/libfcoe/fcoe_ctlr.c
index 42a67e0..d5a411b 100644
--- a/drivers/scsi/libfcoe/fcoe_ctlr.c
+++ b/drivers/scsi/libfcoe/fcoe_ctlr.c
@@ -558,11 +558,13 @@ static void fcoe_ctlr_age_fcfs(struct fcoe_ctlr *fip)
 
 /*
  * Decode a FIP advertisement into a new FCF entry.
+ *
+ * Returns zero on a valid parsed advertisement,
+ * otherwise returns non zero value.
  */
-static struct fcoe_fcf *fcoe_ctlr_parse_adv(struct sk_buff *skb)
+static int fcoe_ctlr_parse_adv(struct sk_buff *skb, struct fcoe_fcf *fcf)
 {
 	struct fip_header *fiph;
-	struct fcoe_fcf *fcf;
 	struct fip_desc *desc = NULL;
 	struct fip_wwn_desc *wwn;
 	struct fip_fab_desc *fab;
@@ -571,9 +573,7 @@ static struct fcoe_fcf *fcoe_ctlr_parse_adv(struct sk_buff *skb)
 	size_t rlen;
 	size_t dlen;
 
-	fcf = kzalloc(sizeof(*fcf), GFP_ATOMIC);
-	if (!fcf)
-		return fcf;
+	memset(fcf, 0, sizeof(*fcf));
 	fcf->fka_period = msecs_to_jiffies(FCOE_CTLR_DEF_FKA);
 
 	fiph = (struct fip_header *)skb->data;
@@ -581,13 +581,13 @@ static struct fcoe_fcf *fcoe_ctlr_parse_adv(struct sk_buff *skb)
 
 	rlen = ntohs(fiph->fip_dl_len) * 4;
 	if (rlen + sizeof(*fiph) > skb->len)
-		goto bad_adv;
+		return -EINVAL;
 
 	desc = (struct fip_desc *)(fiph + 1);
 	while (rlen > 0) {
 		dlen = desc->fip_dlen * FIP_BPW;
 		if (dlen < sizeof(*desc) || dlen > rlen)
-			goto bad_adv;
+			return -EINVAL;
 		switch (desc->fip_dtype) {
 		case FIP_DT_PRI:
 			if (dlen != sizeof(struct fip_pri_desc))
@@ -602,7 +602,7 @@ static struct fcoe_fcf *fcoe_ctlr_parse_adv(struct sk_buff *skb)
 			       ETH_ALEN);
 			if (!is_valid_ether_addr(fcf->fcf_mac)) {
 				FIP_DBG("invalid MAC addr in FIP adv\n");
-				goto bad_adv;
+				return -EINVAL;
 			}
 			break;
 		case FIP_DT_NAME:
@@ -638,24 +638,22 @@ static struct fcoe_fcf *fcoe_ctlr_parse_adv(struct sk_buff *skb)
 				  desc->fip_dtype);
 			/* standard says ignore unknown descriptors >= 128 */
 			if (desc->fip_dtype < FIP_DT_VENDOR_BASE)
-				goto bad_adv;
+				return -EINVAL;
 			continue;
 		}
 		desc = (struct fip_desc *)((char *)desc + dlen);
 		rlen -= dlen;
 	}
 	if (!fcf->fc_map || (fcf->fc_map & 0x10000))
-		goto bad_adv;
+		return -EINVAL;
 	if (!fcf->switch_name || !fcf->fabric_name)
-		goto bad_adv;
-	return fcf;
+		return -EINVAL;
+	return 0;
 
 len_err:
 	FIP_DBG("FIP length error in descriptor type %x len %zu\n",
 		  desc->fip_dtype, dlen);
-bad_adv:
-	kfree(fcf);
-	return NULL;
+	return -EINVAL;
 }
 
 /*
@@ -664,54 +662,54 @@ bad_adv:
 static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
 	struct fcoe_fcf *fcf;
-	struct fcoe_fcf *new;
+	struct fcoe_fcf new;
 	struct fcoe_fcf *found;
 	unsigned long sol_tov = msecs_to_jiffies(FCOE_CTRL_SOL_TOV);
 	int first = 0;
 	int mtu_valid;
 
-	new = fcoe_ctlr_parse_adv(skb);
-	if (!new)
+	if (fcoe_ctlr_parse_adv(skb, &new))
 		return;
 
 	spin_lock_bh(&fip->lock);
 	first = list_empty(&fip->fcfs);
 	found = NULL;
 	list_for_each_entry(fcf, &fip->fcfs, list) {
-		if (fcf->switch_name == new->switch_name &&
-		    fcf->fabric_name == new->fabric_name &&
-		    fcf->fc_map == new->fc_map &&
-		    compare_ether_addr(fcf->fcf_mac, new->fcf_mac) == 0) {
+		if (fcf->switch_name == new.switch_name &&
+		    fcf->fabric_name == new.fabric_name &&
+		    fcf->fc_map == new.fc_map &&
+		    compare_ether_addr(fcf->fcf_mac, new.fcf_mac) == 0) {
 			found = fcf;
 			break;
 		}
 	}
 	if (!found) {
-		if (fip->fcf_count >= FCOE_CTLR_FCF_LIMIT) {
-			spin_unlock_bh(&fip->lock);
-			kfree(new);
-			return;
-		}
+		if (fip->fcf_count >= FCOE_CTLR_FCF_LIMIT)
+			goto out;
+
+		fcf = kmalloc(sizeof(*fcf), GFP_ATOMIC);
+		if (!fcf)
+			goto out;
+
 		fip->fcf_count++;
-		fcf = new;
+		memcpy(fcf, &new, sizeof(new));
 		list_add(&fcf->list, &fip->fcfs);
 	} else {
 		/*
 		 * Once we've received a solicited advertisement, we should
 		 * ignore the flags from multicast advertisments.
 		 */
-		if ((new->flags & FIP_FL_SOL) || !(fcf->flags & FIP_FL_SOL))
-			fcf->flags = new->flags;
+		if ((new.flags & FIP_FL_SOL) || !(fcf->flags & FIP_FL_SOL))
+			fcf->flags = new.flags;
 
 		if (fcf == fip->sel_fcf) {
 			fip->ctlr_ka_time -= fcf->fka_period;
-			fip->ctlr_ka_time += new->fka_period;
+			fip->ctlr_ka_time += new.fka_period;
 			if (time_before(fip->ctlr_ka_time, fip->timer.expires))
 				mod_timer(&fip->timer, fip->ctlr_ka_time);
 		}
-		fcf->fka_period = new->fka_period;
-		memcpy(fcf->fcf_mac, new->fcf_mac, ETH_ALEN);
-		kfree(new);
+		fcf->fka_period = new.fka_period;
+		memcpy(fcf->fcf_mac, new.fcf_mac, ETH_ALEN);
 	}
 	mtu_valid = fcoe_ctlr_mtu_valid(fcf);
 	fcf->time = jiffies;
@@ -746,6 +744,7 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		    time_before(fip->sel_time, fip->timer.expires))
 			mod_timer(&fip->timer, fip->sel_time);
 	}
+out:
 	spin_unlock_bh(&fip->lock);
 }
 

