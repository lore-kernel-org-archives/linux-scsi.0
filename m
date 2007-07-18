From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 1/3] zfcp: Replace kmalloc/memset with kzalloc
Date: Wed, 18 Jul 2007 10:55:08 +0200
Message-ID: <200707181055.08526.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:44143 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbXGRIyY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 04:54:24 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.13.8/8.13.8) with ESMTP id l6I8sNd6049342
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 08:54:23 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6I8sM6O2785424
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 09:54:22 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6I8sG9S024251
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 09:54:16 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Subject: [PATCH] zfcp: Replace kmalloc/memset with kzalloc

From: Swen Schillig <swen@vnet.ibm.com>

Memory allocated with kmalloc is always initialzed to 0 with memset.
Replace the two calls with kzalloc, that already does both steps.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2007-07-18 10:27:48.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2007-07-18 10:28:23.000000000 +0200
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
