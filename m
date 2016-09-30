From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 7/7] fcoe: Harden CVL handling when we have not logged into the fabric.
Date: Fri, 30 Sep 2016 11:01:20 +0200
Message-ID: <1475226080-60365-8-git-send-email-hare@suse.de>
References: <1475226080-60365-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34038 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753023AbcI3JBb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Sep 2016 05:01:31 -0400
In-Reply-To: <1475226080-60365-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Chad Dupuis <chad.dupuis@cavium.com>, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@cavium.com>

If we haven't logged into the fabric yet we want to be a little more nuanced
with our CVL handling than what we've been:

- If the FCF has been selected, check the source MAC to make sure the frame is
from the FCF we've selected.
- If a FCF is selected and the CVL is from the FCF but we have not logged in
yet, then reset everything and go back to solicitation.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Acked-by: Johannes Thumshirn <jth@kernel.org>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index b9a6fd2..25bb1d1 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1316,7 +1316,7 @@ drop:
  * The overall length has already been checked.
  */
 static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
-				     struct fip_header *fh)
+				     struct sk_buff *skb)
 {
 	struct fip_desc *desc;
 	struct fip_mac_desc *mp;
@@ -1331,14 +1331,18 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 	int num_vlink_desc;
 	int reset_phys_port = 0;
 	struct fip_vn_desc **vlink_desc_arr = NULL;
+	struct fip_header *fh = (struct fip_header *)skb->data;
+	struct ethhdr *eh = eth_hdr(skb);
 
 	LIBFCOE_FIP_DBG(fip, "Clear Virtual Link received\n");
 
-	if (!fcf || !lport->port_id) {
+	if (!fcf) {
 		/*
 		 * We are yet to select best FCF, but we got CVL in the
 		 * meantime. reset the ctlr and let it rediscover the FCF
 		 */
+		LIBFCOE_FIP_DBG(fip, "Resetting fcoe_ctlr as FCF has not been "
+		    "selected yet\n");
 		mutex_lock(&fip->ctlr_mutex);
 		fcoe_ctlr_reset(fip);
 		mutex_unlock(&fip->ctlr_mutex);
@@ -1346,6 +1350,31 @@ static void fcoe_ctlr_recv_clr_vlink(struct fcoe_ctlr *fip,
 	}
 
 	/*
+	 * If we've selected an FCF check that the CVL is from there to avoid
+	 * processing CVLs from an unexpected source.  If it is from an
+	 * unexpected source drop it on the floor.
+	 */
+	if (!ether_addr_equal(eh->h_source, fcf->fcf_mac)) {
+		LIBFCOE_FIP_DBG(fip, "Dropping CVL due to source address "
+		    "mismatch with FCF src=%pM\n", eh->h_source);
+		return;
+	}
+
+	/*
+	 * If we haven't logged into the fabric but receive a CVL we should
+	 * reset everything and go back to solicitation.
+	 */
+	if (!lport->port_id) {
+		LIBFCOE_FIP_DBG(fip, "lport not logged in, resoliciting\n");
+		mutex_lock(&fip->ctlr_mutex);
+		fcoe_ctlr_reset(fip);
+		mutex_unlock(&fip->ctlr_mutex);
+		fc_lport_reset(fip->lp);
+		fcoe_ctlr_solicit(fip, NULL);
+		return;
+	}
+
+	/*
 	 * mask of required descriptors.  Validating each one clears its bit.
 	 */
 	desc_mask = BIT(FIP_DT_MAC) | BIT(FIP_DT_NAME);
@@ -1576,7 +1605,7 @@ static int fcoe_ctlr_recv_handler(struct fcoe_ctlr *fip, struct sk_buff *skb)
 	if (op == FIP_OP_DISC && sub == FIP_SC_ADV)
 		fcoe_ctlr_recv_adv(fip, skb);
 	else if (op == FIP_OP_CTRL && sub == FIP_SC_CLR_VLINK)
-		fcoe_ctlr_recv_clr_vlink(fip, fiph);
+		fcoe_ctlr_recv_clr_vlink(fip, skb);
 	kfree_skb(skb);
 	return 0;
 drop:
-- 
1.8.5.6

