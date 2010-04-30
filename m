From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 5/5] zfcp: Zero memory for gpn_ft and adisc requests
Date: Fri, 30 Apr 2010 18:09:37 +0200
Message-ID: <20100430161020.583247000@de.ibm.com>
References: <20100430160932.658896000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:56754 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab0D3Tfj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 15:35:39 -0400
Content-Disposition: inline; filename=zalloc.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

With debug kernels, the memory allocated with kmem_cache_alloc might
be initialized with the poison values 6b and a5. Use kmem_cache_zalloc
instead of kmem_cache_alloc to get zeroed memory and not send invalid
requests.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_fc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_fc.c	2010-04-30 16:00:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2010-04-30 16:00:54.000000000 +0200
@@ -400,7 +400,7 @@ static int zfcp_fc_adisc(struct zfcp_por
 	struct zfcp_adapter *adapter = port->adapter;
 	int ret;
 
-	adisc = kmem_cache_alloc(zfcp_data.adisc_cache, GFP_ATOMIC);
+	adisc = kmem_cache_zalloc(zfcp_data.adisc_cache, GFP_ATOMIC);
 	if (!adisc)
 		return -ENOMEM;
 
@@ -493,7 +493,7 @@ static struct zfcp_fc_gpn_ft *zfcp_alloc
 	if (!gpn_ft)
 		return NULL;
 
-	req = kmem_cache_alloc(zfcp_data.gpn_ft_cache, GFP_KERNEL);
+	req = kmem_cache_zalloc(zfcp_data.gpn_ft_cache, GFP_KERNEL);
 	if (!req) {
 		kfree(gpn_ft);
 		gpn_ft = NULL;

