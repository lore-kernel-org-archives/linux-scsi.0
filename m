From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 2/4] zfcp: allocate gid_pn_data objects from gid_pn_cache
Date: Wed, 8 Aug 2007 10:47:10 +0200
Message-ID: <200708081047.10872.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:1143 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757153AbXHHIpa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Aug 2007 04:45:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com

From: Heiko Carstens <heiko.carstens@de.ibm.com>

allocate gid_pn_data objects from gid_pn_cache.

Allocate gid_pn_data objects from the corresponding cache which ensures
proper alignment.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2007-08-08 10:13:39.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2007-08-08 10:14:02.000000000 +0200
@@ -1503,7 +1503,7 @@ zfcp_gid_pn_buffers_alloc(struct zfcp_gi
 			data->ct.pool = pool;
 		}
 	} else {
-		data = kmalloc(sizeof(struct zfcp_gid_pn_data), GFP_ATOMIC);
+		data = kmem_cache_alloc(zfcp_data.gid_pn_cache, GFP_ATOMIC);
 	}
 
         if (NULL == data)
@@ -1531,7 +1531,7 @@ static void zfcp_gid_pn_buffers_free(str
 	if (gid_pn->ct.pool)
 		mempool_free(gid_pn, gid_pn->ct.pool);
 	else
-		kfree(gid_pn);
+		kmem_cache_free(zfcp_data.gid_pn_cache, gid_pn);
 }
 
 /**
