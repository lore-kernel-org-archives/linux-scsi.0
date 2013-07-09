From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 6/8] libfcoe: Fix meaningless log statement
Date: Tue, 09 Jul 2013 12:47:37 -0700
Message-ID: <20130709194736.10724.92012.stgit@fritz>
References: <20130709194705.10724.64013.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48901 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab3GITrz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jul 2013 15:47:55 -0400
In-Reply-To: <20130709194705.10724.64013.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Morgan <jack.morgan@intel.com>, Neil Horman <nhorman@tuxdriver.com>

ctlr_dev was initialized to NULL, and never re-assigned. This
caused the log statement to always report failure. This patch
removes the unused variable and fixes the log statement to always
report 'success', as that is what should be logged if the code
reaches this point.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Jack Morgan <jack.morgan@intel.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 drivers/scsi/fcoe/fcoe_transport.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index bedd422..f1ae5ed 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -707,7 +707,6 @@ ssize_t fcoe_ctlr_create_store(struct bus_type *bus,
 {
 	struct net_device *netdev = NULL;
 	struct fcoe_transport *ft = NULL;
-	struct fcoe_ctlr_device *ctlr_dev = NULL;
 	int rc = 0;
 	int err;
 
@@ -754,9 +753,8 @@ ssize_t fcoe_ctlr_create_store(struct bus_type *bus,
 		goto out_putdev;
 	}
 
-	LIBFCOE_TRANSPORT_DBG("transport %s %s to create fcoe on %s.\n",
-			      ft->name, (ctlr_dev) ? "succeeded" : "failed",
-			      netdev->name);
+	LIBFCOE_TRANSPORT_DBG("transport %s succeeded to create fcoe on %s.\n",
+			      ft->name, netdev->name);
 
 out_putdev:
 	dev_put(netdev);

