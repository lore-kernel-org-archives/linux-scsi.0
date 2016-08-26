From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 29/30] fcoe: filter out frames from invalid vlans
Date: Fri, 26 Aug 2016 14:01:52 +0200
Message-ID: <1472212913-39810-30-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752408AbcHZMCN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:13 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>

Any multicase address is set on all interfaces, the base interface
and any VLAN interface on top of this. So we might receive frames
which are not destined for us but in fact on another VLAN.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 8be27ea..e6557ea 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -2721,11 +2721,21 @@ static int fcoe_ctlr_vn_recv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 		struct fc_rport_priv rdata;
 		struct fcoe_rport frport;
 	} buf;
-	int rc;
+	int rc, vlan_id = 0;
 
 	fiph = (struct fip_header *)skb->data;
 	sub = fiph->fip_subcode;
 
+	if (fip->lp->vlan)
+		vlan_id = skb_vlan_tag_get_id(skb);
+
+	if (vlan_id && vlan_id != fip->lp->vlan) {
+		LIBFCOE_FIP_DBG(fip, "vn_recv drop frame sub %x vlan %d\n",
+				sub, vlan_id);
+		rc = -EAGAIN;
+		goto drop;
+	}
+
 	rc = fcoe_ctlr_vn_parse(fip, skb, &buf.rdata);
 	if (rc) {
 		LIBFCOE_FIP_DBG(fip, "vn_recv vn_parse error %d\n", rc);
-- 
1.8.5.6

