From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 3/9] iscsi update: setup pool before using
Date: Wed, 01 Feb 2006 21:06:58 -0600
Message-ID: <1138849618.3456.36.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:29876 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423069AbWBBDHQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2006 22:07:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

>From andmike@us.ibm.com:

 Ensure that pool data is setup prior to calling mempool_create as it will
 call the the alloc function during create.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>



diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 79ca29e..448fd78 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -530,6 +530,12 @@ mempool_zone_init(unsigned max, unsigned
 	if (!zp)
 		return NULL;
 
+	zp->size = size;
+	zp->hiwat = hiwat;
+	INIT_LIST_HEAD(&zp->freequeue);
+	spin_lock_init(&zp->freelock);
+	atomic_set(&zp->allocated, 0);
+
 	zp->pool = mempool_create(max, mempool_zone_alloc_skb,
 				  mempool_zone_free_skb, zp);
 	if (!zp->pool) {
@@ -537,13 +543,6 @@ mempool_zone_init(unsigned max, unsigned
 		return NULL;
 	}
 
-	zp->size = size;
-	zp->hiwat = hiwat;
-
-	INIT_LIST_HEAD(&zp->freequeue);
-	spin_lock_init(&zp->freelock);
-	atomic_set(&zp->allocated, 0);
-
 	return zp;
 }
 


