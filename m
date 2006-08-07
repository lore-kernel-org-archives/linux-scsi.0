From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH 01/10] qla4xxx: use pci_register_driver
Date: Mon, 07 Aug 2006 10:36:53 -0500
Message-ID: <20060807153652.31019.2518.stgit@bebe.enoyolf.org>
References: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:31650 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S932162AbWHGPjW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 11:39:22 -0400
In-Reply-To: <20060807153640.31019.50863.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Doug Maxey <dwm@enoyolf.org>

- use the current pci_register_driver().

- change order of calls in module_exit().

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_os.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index fdba30a..087944a 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1821,11 +1821,11 @@ static int __init qla4xxx_module_init(vo
 		goto release_srb_cache;
 	}
 
-	printk(KERN_INFO "QLogic iSCSI HBA Driver\n");
-	ret = pci_module_init(&qla4xxx_pci_driver);
+	ret = pci_register_driver(&qla4xxx_pci_driver);
 	if (ret)
 		goto unregister_transport;
 
+	printk(KERN_INFO "QLogic iSCSI HBA Driver\n");
 	return 0;
 
 unregister_transport:
@@ -1839,8 +1839,8 @@ no_srp_cache:
 static void __exit qla4xxx_module_exit(void)
 {
 	pci_unregister_driver(&qla4xxx_pci_driver);
-	kmem_cache_destroy(srb_cachep);
 	iscsi_unregister_transport(&qla4xxx_iscsi_transport);
+	kmem_cache_destroy(srb_cachep);
 }
 
 module_init(qla4xxx_module_init);
