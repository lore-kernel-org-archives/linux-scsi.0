From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 07/10] zfcp: Prevent access on uninitialized memory.
Date: Fri, 16 Jul 2010 15:37:40 +0200
Message-ID: <20100716134300.705808000@de.ibm.com>
References: <20100716133733.621672000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:48032 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965619Ab0GPNnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2010 09:43:04 -0400
Content-Disposition: inline; filename=716-zfcp-kzalloc.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Initialize allocated memory to zero to prevent access on error. This
prevents a possible error in the error handling path.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.c linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.c	2010-05-16 23:17:36.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c	2010-07-15 12:22:24.000000000 +0200
@@ -1005,7 +1005,7 @@ int zfcp_dbf_adapter_register(struct zfc
 	char dbf_name[DEBUG_MAX_NAME_LEN];
 	struct zfcp_dbf *dbf;
 
-	dbf = kmalloc(sizeof(struct zfcp_dbf), GFP_KERNEL);
+	dbf = kzalloc(sizeof(struct zfcp_dbf), GFP_KERNEL);
 	if (!dbf)
 		return -ENOMEM;
 

