From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] imm driver needs scsi_unregister()
Date: Tue, 19 Aug 2003 21:31:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030819213107.515016f6.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:18632 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261625AbTHTEcv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Aug 2003 00:32:51 -0400
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


Same as the ppa driver, keeping them in sync.

Please apply.

--
~Randy


patch_name:	scsi_imm_unreg.patch
patch_version:	2003-08-19.21:14:54
author:		Randy.Dunlap <rddunlap@osdl.org>
description:	scsi imm driver needs to call scsi_unregister();
product:	Linux
product_versions: 260-test3
diffstat:	=
 drivers/scsi/imm.c |    1 +
 1 files changed, 1 insertion(+)


diff -Naur ./drivers/scsi/imm.c~unreg ./drivers/scsi/imm.c
--- ./drivers/scsi/imm.c~unreg	2003-08-08 21:42:20.000000000 -0700
+++ ./drivers/scsi/imm.c	2003-08-19 21:07:35.000000000 -0700
@@ -86,6 +86,7 @@
     int host_no = host->unique_id;
 
     printk("Releasing imm%i\n", host_no);
+    scsi_unregister(host);
     parport_unregister_device(imm_hosts[host_no].dev);
     return 0;
 }
