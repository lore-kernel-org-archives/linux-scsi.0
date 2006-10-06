From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH] qla4xxx: fix double printk on load
Date: Thu, 05 Oct 2006 23:50:07 -0500
Message-ID: <20061006045007.28839.717.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:32933 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S1751786AbWJFExG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Oct 2006 00:53:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org


There is a dup printk at the tail of qla4xxx_module_init().  Remove the
first instance as it's before the complete success of the function.
---

 drivers/scsi/qla4xxx/ql4_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 178fcdd..4fa0153 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1724,13 +1724,13 @@ static int __init qla4xxx_module_init(vo
 		goto release_srb_cache;
 	}
 
-	printk(KERN_INFO "QLogic iSCSI HBA Driver\n");
 	ret = pci_register_driver(&qla4xxx_pci_driver);
 	if (ret)
 		goto unregister_transport;
 
 	printk(KERN_INFO "QLogic iSCSI HBA Driver\n");
 	return 0;
+
 unregister_transport:
 	iscsi_unregister_transport(&qla4xxx_iscsi_transport);
 release_srb_cache:
