From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH] zfcp: Replace kmalloc/memset with kzalloc
Date: Thu, 14 Jun 2007 12:15:26 +0200
Message-ID: <200706141215.26997.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:25896 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbXFNKMB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 06:12:01 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

From: Swen Schillig <swen@vnet.ibm.com>

Memory allocated with kmalloc is always initialzed to 0 with memset.
Replace the two calls with kzalloc, that already does both steps.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2007-06-14 10:32:45.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2007-06-14 10:33:29.000000000 +0200
@@ -1626,7 +1626,7 @@ zfcp_erp_schedule_work(struct zfcp_unit 
 {
 	struct zfcp_erp_add_work *p;
 
-	p = kmalloc(sizeof(*p), GFP_KERNEL);
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p) {
 		ZFCP_LOG_NORMAL("error: Out of resources. Could not register "
 				"the FCP-LUN 0x%Lx connected to "
@@ -1639,7 +1639,6 @@ zfcp_erp_schedule_work(struct zfcp_unit 
 	}
 
 	zfcp_unit_get(unit);
-	memset(p, 0, sizeof(*p));
 	atomic_set_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
 	INIT_WORK(&p->work, zfcp_erp_scsi_scan);
 	p->unit = unit;
