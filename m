From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 15/19] fcoe: Add missing newlines in debug messages
Date: Mon, 21 Oct 2013 11:01:50 -0700
Message-ID: <20131021180150.31563.82919.stgit@fritz>
References: <20131021180024.31563.89632.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31785 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab3JUSBv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Oct 2013 14:01:51 -0400
In-Reply-To: <20131021180024.31563.89632.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Neil Horman <nhorman@tuxdriver.com>

From: Bart Van Assche <bvanassche@acm.org>

FCoE debug statements must end in a newline. Add one where it is missing.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c       |   12 ++++++------
 drivers/scsi/fcoe/fcoe_sysfs.c |   12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 134ca3b..dff40b2 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1440,14 +1440,14 @@ static int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 	ctlr = fcoe_to_ctlr(fcoe);
 	lport = ctlr->lp;
 	if (unlikely(!lport)) {
-		FCOE_NETDEV_DBG(netdev, "Cannot find hba structure");
+		FCOE_NETDEV_DBG(netdev, "Cannot find hba structure\n");
 		goto err2;
 	}
 	if (!lport->link_up)
 		goto err2;
 
-	FCOE_NETDEV_DBG(netdev, "skb_info: len:%d data_len:%d head:%p "
-			"data:%p tail:%p end:%p sum:%d dev:%s",
+	FCOE_NETDEV_DBG(netdev,
+			"skb_info: len:%d data_len:%d head:%p data:%p tail:%p end:%p sum:%d dev:%s\n",
 			skb->len, skb->data_len, skb->head, skb->data,
 			skb_tail_pointer(skb), skb_end_pointer(skb),
 			skb->csum, skb->dev ? skb->dev->name : "<NULL>");
@@ -1794,13 +1794,13 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 	lport = fr->fr_dev;
 	if (unlikely(!lport)) {
 		if (skb->destructor != fcoe_percpu_flush_done)
-			FCOE_NETDEV_DBG(skb->dev, "NULL lport in skb");
+			FCOE_NETDEV_DBG(skb->dev, "NULL lport in skb\n");
 		kfree_skb(skb);
 		return;
 	}
 
-	FCOE_NETDEV_DBG(skb->dev, "skb_info: len:%d data_len:%d "
-			"head:%p data:%p tail:%p end:%p sum:%d dev:%s",
+	FCOE_NETDEV_DBG(skb->dev,
+			"skb_info: len:%d data_len:%d head:%p data:%p tail:%p end:%p sum:%d dev:%s\n",
 			skb->len, skb->data_len,
 			skb->head, skb->data, skb_tail_pointer(skb),
 			skb_end_pointer(skb), skb->csum,
diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index c9382d6..922c9de 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -300,29 +300,29 @@ static ssize_t store_ctlr_mode(struct device *dev,
 
 	switch (ctlr->enabled) {
 	case FCOE_CTLR_ENABLED:
-		LIBFCOE_SYSFS_DBG(ctlr, "Cannot change mode when enabled.");
+		LIBFCOE_SYSFS_DBG(ctlr, "Cannot change mode when enabled.\n");
 		return -EBUSY;
 	case FCOE_CTLR_DISABLED:
 		if (!ctlr->f->set_fcoe_ctlr_mode) {
 			LIBFCOE_SYSFS_DBG(ctlr,
-					  "Mode change not supported by LLD.");
+					  "Mode change not supported by LLD.\n");
 			return -ENOTSUPP;
 		}
 
 		ctlr->mode = fcoe_parse_mode(mode);
 		if (ctlr->mode == FIP_CONN_TYPE_UNKNOWN) {
-			LIBFCOE_SYSFS_DBG(ctlr,
-					  "Unknown mode %s provided.", buf);
+			LIBFCOE_SYSFS_DBG(ctlr, "Unknown mode %s provided.\n",
+					  buf);
 			return -EINVAL;
 		}
 
 		ctlr->f->set_fcoe_ctlr_mode(ctlr);
-		LIBFCOE_SYSFS_DBG(ctlr, "Mode changed to %s.", buf);
+		LIBFCOE_SYSFS_DBG(ctlr, "Mode changed to %s.\n", buf);
 
 		return count;
 	case FCOE_CTLR_UNUSED:
 	default:
-		LIBFCOE_SYSFS_DBG(ctlr, "Mode change not supported.");
+		LIBFCOE_SYSFS_DBG(ctlr, "Mode change not supported.\n");
 		return -ENOTSUPP;
 	};
 }

