From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 02/11] zfcp: Fix mempool pointer for GID_PN request allocation
Date: Mon, 19 May 2008 12:17:38 +0200
Message-ID: <20080519101827.011544000@de.ibm.com>
References: <20080519101736.590943000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:35948 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbYESKS3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 06:18:29 -0400
Content-Disposition: inline; filename=800-zfcp-mempool.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When allocating memory for GID_PN nameserver requests, the allocation
function stores the pointer to the mempool, but then overwrites the
pointer via memset. Later, the wrong function to free the memory will
be called, since this is based on the stored pointer.

Fix this by first initializing the struct and then storing the pointer.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-05-19 11:28:32.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-05-19 11:30:27.000000000 +0200
@@ -1533,19 +1533,16 @@ zfcp_gid_pn_buffers_alloc(struct zfcp_gi
 {
 	struct zfcp_gid_pn_data *data;
 
-	if (pool != NULL) {
+	if (pool)
 		data = mempool_alloc(pool, GFP_ATOMIC);
-		if (likely(data != NULL)) {
-			data->ct.pool = pool;
-		}
-	} else {
+	else
 		data = kmem_cache_alloc(zfcp_data.gid_pn_cache, GFP_ATOMIC);
-	}
 
         if (NULL == data)
                 return -ENOMEM;
 
 	memset(data, 0, sizeof(*data));
+	data->ct.pool = pool;
 	sg_init_table(&data->req , 1);
 	sg_init_table(&data->resp , 1);
         data->ct.req = &data->req;

-- 
