From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 4/5] zfcp: Prevent usage w/o holding a reference
Date: Wed, 17 Nov 2010 14:23:43 +0100
Message-ID: <20101117132656.285936114@de.ibm.com>
References: <20101117132339.429099463@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:49134 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab0KQN06 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 08:26:58 -0500
Content-Disposition: inline; filename=709-zfcp-usage-reference.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The ERP got values assigned for which no reference was taken.  This
can lead to an unpredictable race condition.  Fix this by only
assigning the values which are required and for which a reference was
pulled or is held implicitly.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2010-11-17 10:04:27.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2010-11-17 10:04:27.000000000 +0100
@@ -190,6 +190,9 @@ static struct zfcp_erp_action *zfcp_erp_
 		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
 				&zfcp_sdev->status);
 		erp_action = &zfcp_sdev->erp_action;
+		memset(erp_action, 0, sizeof(struct zfcp_erp_action));
+		erp_action->port = port;
+		erp_action->sdev = sdev;
 		if (!(atomic_read(&zfcp_sdev->status) &
 		      ZFCP_STATUS_COMMON_RUNNING))
 			act_status |= ZFCP_STATUS_ERP_CLOSE_ONLY;
@@ -202,6 +205,8 @@ static struct zfcp_erp_action *zfcp_erp_
 		zfcp_erp_action_dismiss_port(port);
 		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &port->status);
 		erp_action = &port->erp_action;
+		memset(erp_action, 0, sizeof(struct zfcp_erp_action));
+		erp_action->port = port;
 		if (!(atomic_read(&port->status) & ZFCP_STATUS_COMMON_RUNNING))
 			act_status |= ZFCP_STATUS_ERP_CLOSE_ONLY;
 		break;
@@ -211,6 +216,7 @@ static struct zfcp_erp_action *zfcp_erp_
 		zfcp_erp_action_dismiss_adapter(adapter);
 		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &adapter->status);
 		erp_action = &adapter->erp_action;
+		memset(erp_action, 0, sizeof(struct zfcp_erp_action));
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING))
 			act_status |= ZFCP_STATUS_ERP_CLOSE_ONLY;
@@ -220,10 +226,7 @@ static struct zfcp_erp_action *zfcp_erp_
 		return NULL;
 	}
 
-	memset(erp_action, 0, sizeof(struct zfcp_erp_action));
 	erp_action->adapter = adapter;
-	erp_action->port = port;
-	erp_action->sdev = sdev;
 	erp_action->action = need;
 	erp_action->status = act_status;
 

