From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 18/24] fcoe: Correct fcoe_transports initialization vs.
	registration
Date: Fri, 27 Feb 2009 10:56:06 -0800
Message-ID: <20090227185606.25509.39207.stgit@fritz>
References: <20090227185430.25509.34309.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31749 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753AbZB0S4I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 13:56:08 -0500
In-Reply-To: <20090227185430.25509.34309.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

The registration function shouldn't initialize the mutex or
list head. The fcoe SW transport should initialize itself
before registering.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fc_transport_fcoe.c |    3 ---
 drivers/scsi/fcoe/fcoe_sw.c           |    5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/fc_transport_fcoe.c b/drivers/scsi/fcoe/fc_transport_fcoe.c
index 847453a..8862758 100644
--- a/drivers/scsi/fcoe/fc_transport_fcoe.c
+++ b/drivers/scsi/fcoe/fc_transport_fcoe.c
@@ -258,9 +258,6 @@ int fcoe_transport_register(struct fcoe_transport *t)
 	list_add_tail(&t->list, &fcoe_transports);
 	mutex_unlock(&fcoe_transports_lock);
 
-	mutex_init(&t->devlock);
-	INIT_LIST_HEAD(&t->devlist);
-
 	printk(KERN_DEBUG "fcoe_transport_register:%s\n", t->name);
 
 	return 0;
diff --git a/drivers/scsi/fcoe/fcoe_sw.c b/drivers/scsi/fcoe/fcoe_sw.c
index f667dce..37d359d 100644
--- a/drivers/scsi/fcoe/fcoe_sw.c
+++ b/drivers/scsi/fcoe/fcoe_sw.c
@@ -467,10 +467,15 @@ int __init fcoe_sw_init(void)
 	/* attach to scsi transport */
 	scsi_transport_fcoe_sw =
 		fc_attach_transport(&fcoe_sw_transport_function);
+
 	if (!scsi_transport_fcoe_sw) {
 		printk(KERN_ERR "fcoe_sw_init:fc_attach_transport() failed\n");
 		return -ENODEV;
 	}
+
+	mutex_init(&fcoe_sw_transport.devlock);
+	INIT_LIST_HEAD(&fcoe_sw_transport.devlist);
+
 	/* register sw transport */
 	fcoe_transport_register(&fcoe_sw_transport);
 	return 0;

