From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/21] fcoe: add support to the get_netdev() for fcoe_interface
Date: Tue, 19 Feb 2013 11:31:26 -0800
Message-ID: <20130219193126.10192.45497.stgit@fritz>
References: <20130219193031.10192.33777.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4578 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933402Ab3BSTb1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2013 14:31:27 -0500
In-Reply-To: <20130219193031.10192.33777.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>, Marcus Dennis <marcusx.e.dennis@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

Adds support to fcoe_port's newly added get_netdev fucntion pointer.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Tested-by: Marcus Dennis <marcusx.e.dennis@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |    1 +
 include/scsi/libfcoe.h   |   12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 21927f7..4cec9dd 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1118,6 +1118,7 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 	port = lport_priv(lport);
 	port->lport = lport;
 	port->priv = fcoe;
+	port->get_netdev = fcoe_netdev;
 	port->max_queue_depth = FCOE_MAX_QUEUE_DEPTH;
 	port->min_queue_depth = FCOE_MIN_QUEUE_DEPTH;
 	INIT_WORK(&port->destroy_work, fcoe_destroy_work);
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index 52bba71..746bc58 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -353,6 +353,18 @@ struct fcoe_port {
 	u8		      data_src_addr[ETH_ALEN];
 	struct net_device * (*get_netdev)(const struct fc_lport *lport);
 };
+
+/**
+ * fcoe_get_netdev() - Return the net device associated with a local port
+ * @lport: The local port to get the net device from
+ */
+static inline struct net_device *fcoe_get_netdev(const struct fc_lport *lport)
+{
+	struct fcoe_port *port = ((struct fcoe_port *)lport_priv(lport));
+
+	return (port->get_netdev) ? port->get_netdev(lport) : NULL;
+}
+
 void fcoe_clean_pending_queue(struct fc_lport *);
 void fcoe_check_wait_queue(struct fc_lport *lport, struct sk_buff *skb);
 void fcoe_queue_timer(ulong lport);

