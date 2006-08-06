From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH] qla4xxx: cleanup all allocations on failed allocations in module_init()
Date: Sun, 06 Aug 2006 00:09:03 -0500
Message-ID: <20060806050903.19417.44444.stgit@bebe.enoyolf.org>
References: <20060805221937.3349.73409.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:38058 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S932288AbWHFFLW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Aug 2006 01:11:22 -0400
In-Reply-To: <20060805221937.3349.73409.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Doug Maxey <dwm@enoyolf.org>

Fix allocation leaks in qla4xxx_module_init() noticed by Ram Pai.

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_os.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 5e10f30..fdba30a 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1805,7 +1805,8 @@ static int __init qla4xxx_module_init(vo
 		printk(KERN_ERR
 		       "%s: Unable to allocate SRB cache..."
 		       "Failing load!\n", DRIVER_NAME);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto no_srp_cache;
 	}
 
 	/* Derive version string. */
@@ -1815,16 +1816,23 @@ static int __init qla4xxx_module_init(vo
 
 	qla4xxx_scsi_transport =
 		iscsi_register_transport(&qla4xxx_iscsi_transport);
-	if (!qla4xxx_scsi_transport)
-		return -ENODEV;
+	if (!qla4xxx_scsi_transport) {
+		ret = -ENODEV;
+		goto release_srb_cache;
+	}
 
 	printk(KERN_INFO "QLogic iSCSI HBA Driver\n");
 	ret = pci_module_init(&qla4xxx_pci_driver);
-	if (ret) {
-		kmem_cache_destroy(srb_cachep);
-		iscsi_unregister_transport(&qla4xxx_iscsi_transport);
-	}
+	if (ret)
+		goto unregister_transport;
+
+	return 0;
 
+unregister_transport:
+	iscsi_unregister_transport(&qla4xxx_iscsi_transport);
+release_srb_cache:
+	kmem_cache_destroy(srb_cachep);
+no_srp_cache:
 	return ret;
 }
 
