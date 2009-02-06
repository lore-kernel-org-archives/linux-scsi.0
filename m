From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 16/17] fcoe: Correct fcoe_transports initialization vs.
	registration
Date: Fri, 06 Feb 2009 10:57:15 -0800
Message-ID: <20090206185715.26188.71187.stgit@fritz>
References: <20090206185548.26188.51580.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17033 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038AbZBFS5P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:57:15 -0500
In-Reply-To: <20090206185548.26188.51580.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

The registration function shouldn't initialize the mutex or
list head. The fcoe SW transport should initialize itself
before registering.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fc_transport_fcoe.c |    3 ---
 drivers/scsi/fcoe/fcoe_sw.c           |    5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fc_transport_fcoe.c b/drivers/scsi/fcoe/fc_transport_fcoe.c
index c9f75b4..058baea 100644
--- a/drivers/scsi/fcoe/fc_transport_fcoe.c
+++ b/drivers/scsi/fcoe/fc_transport_fcoe.c
@@ -256,9 +256,6 @@ int fcoe_transport_register(struct fcoe_transport *t)
 	list_add_tail(&t->list, &fcoe_transports);
 	mutex_unlock(&fcoe_transports_lock);
 
-	mutex_init(&t->devlock);
-	INIT_LIST_HEAD(&t->devlist);
-
 	printk(KERN_INFO "fcoe: Transport %s has been registered\n", t->name);
 
 	return 0;
diff --git a/drivers/scsi/fcoe/fcoe_sw.c b/drivers/scsi/fcoe/fcoe_sw.c
index 91bae90..b41462c 100644
--- a/drivers/scsi/fcoe/fcoe_sw.c
+++ b/drivers/scsi/fcoe/fcoe_sw.c
@@ -468,10 +468,15 @@ int __init fcoe_sw_init(void)
 	/* attach to scsi transport */
 	scsi_transport_fcoe_sw =
 		fc_attach_transport(&fcoe_sw_transport_function);
+
 	if (!scsi_transport_fcoe_sw) {
 		FCOE_DBG("fcoe_sw_init:fc_attach_transport() failed\n");
 		return -ENODEV;
 	}
+
+	mutex_init(&fcoe_sw_transport.devlock);
+	INIT_LIST_HEAD(&fcoe_sw_transport.devlist);
+
 	/* register sw transport */
 	fcoe_transport_register(&fcoe_sw_transport);
 	return 0;

