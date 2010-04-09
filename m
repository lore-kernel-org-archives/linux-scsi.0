From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/12] fcoe: removes unused shost in fcoe_shost_config
Date: Fri, 09 Apr 2010 14:22:54 -0700
Message-ID: <20100409212254.1968.69406.stgit@localhost.localdomain>
References: <20100409212212.1968.59251.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65199 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757653Ab0DIVWz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 17:22:55 -0400
In-Reply-To: <20100409212212.1968.59251.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Robert Love <robert.w.love@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index d16dd12..4d46b71 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -655,15 +655,13 @@ static int fcoe_netdev_config(struct fc_lport *lport, struct net_device *netdev)
 /**
  * fcoe_shost_config() - Set up the SCSI host associated with a local port
  * @lport: The local port
- * @shost: The SCSI host to associate with the local port
  * @dev:   The device associated with the SCSI host
  *
  * Must be called after fcoe_lport_config() and fcoe_netdev_config()
  *
  * Returns: 0 for success
  */
-static int fcoe_shost_config(struct fc_lport *lport, struct Scsi_Host *shost,
-			     struct device *dev)
+static int fcoe_shost_config(struct fc_lport *lport, struct device *dev)
 {
 	int rc = 0;
 
@@ -899,7 +897,6 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 	struct net_device *netdev = fcoe->netdev;
 	struct fc_lport *lport = NULL;
 	struct fcoe_port *port;
-	struct Scsi_Host *shost;
 	int rc;
 	/*
 	 * parent is only a vport if npiv is 1,
@@ -921,7 +918,6 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 		rc = -ENOMEM;
 		goto out;
 	}
-	shost = lport->host;
 	port = lport_priv(lport);
 	port->lport = lport;
 	port->fcoe = fcoe;
@@ -951,7 +947,7 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 	}
 
 	/* configure lport scsi host properties */
-	rc = fcoe_shost_config(lport, shost, parent);
+	rc = fcoe_shost_config(lport, parent);
 	if (rc) {
 		FCOE_NETDEV_DBG(netdev, "Could not configure shost for the "
 				"interface\n");

