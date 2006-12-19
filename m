From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] scsi: raise error when sg slab/mempool cannot be initialized
Date: Tue, 19 Dec 2006 17:36:40 +0900
Message-ID: <20061219083640.GB4025@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:53773 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671AbWLSIhd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Dec 2006 03:37:33 -0500
Received: by an-out-0708.google.com with SMTP id b33so496991ana
        for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2006 00:37:32 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>

This patch raises error when sg slab or mempool cannot be initialized.
It is better than crash after initialization.

Cc: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/scsi/scsi_lib.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: 2.6-mm/drivers/scsi/scsi_lib.c
===================================================================
--- 2.6-mm.orig/drivers/scsi/scsi_lib.c
+++ 2.6-mm/drivers/scsi/scsi_lib.c
@@ -1682,6 +1682,7 @@ int __init scsi_init_queue(void)
 		if (!sgp->slab) {
 			printk(KERN_ERR "SCSI: can't init sg slab %s\n",
 					sgp->name);
+			goto out;
 		}
 
 		sgp->pool = mempool_create_slab_pool(SG_MEMPOOL_SIZE,
@@ -1689,10 +1690,23 @@ int __init scsi_init_queue(void)
 		if (!sgp->pool) {
 			printk(KERN_ERR "SCSI: can't init sg mempool %s\n",
 					sgp->name);
+			goto out;
 		}
 	}
 
 	return 0;
+out:
+	for (i = 0; i < SG_MEMPOOL_NR; i++) {
+		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
+		if (sgp->pool)
+			mempool_destroy(sgp->pool);
+		if (sgp->slab)
+			kmem_cache_destroy(sgp->slab);
+	}
+
+	kmem_cache_destroy(scsi_io_context_cache);
+
+	return -ENOMEM;
 }
 
 void scsi_exit_queue(void)
