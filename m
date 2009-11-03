From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 36/54] fcoe: add check to fail gracefully in bonding mode
Date: Tue, 03 Nov 2009 11:48:44 -0800
Message-ID: <20091103194844.4085.99598.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51840 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069AbZKCTsj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:48:39 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: John Fastabend <john.r.fastabend@intel.com>, Robert Love <robert.w.love@intel.com>

From: john fastabend <john.r.fastabend@intel.com>

This patch adds a check to fail gracefully when the netdevice
is bonded.  Previously, the error was detected but the stack
would continue to load.  This resulted in a partially enabled
fcoe intance and errors when the fcoe instance was destroy.

Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 17ce2ef..b15ec99 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -266,6 +266,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 	if ((netdev->priv_flags & IFF_MASTER_ALB) ||
 	    (netdev->priv_flags & IFF_SLAVE_INACTIVE) ||
 	    (netdev->priv_flags & IFF_MASTER_8023AD)) {
+		FCOE_NETDEV_DBG(netdev, "Bonded interfaces not supported\n");
 		return -EOPNOTSUPP;
 	}
 
@@ -323,6 +324,7 @@ static int fcoe_interface_setup(struct fcoe_interface *fcoe,
 static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev)
 {
 	struct fcoe_interface *fcoe;
+	int err;
 
 	fcoe = kzalloc(sizeof(*fcoe), GFP_KERNEL);
 	if (!fcoe) {
@@ -341,7 +343,13 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev)
 	fcoe->ctlr.update_mac = fcoe_update_src_mac;
 	fcoe->ctlr.get_src_addr = fcoe_get_src_mac;
 
-	fcoe_interface_setup(fcoe, netdev);
+	err = fcoe_interface_setup(fcoe, netdev);
+	if (err) {
+		fcoe_ctlr_destroy(&fcoe->ctlr);
+		kfree(fcoe);
+		dev_put(netdev);
+		return NULL;
+	}
 
 	return fcoe;
 }

