From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] [3/8] zfcp: fix: reopen port only if link-test fails
Date: Mon, 13 Jun 2005 13:16:27 +0200
Message-ID: <20050613111627.GC8998@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:6587 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S261489AbVFMLQb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 07:16:31 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id j5DBGQFu084812
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 11:16:26 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5DBGQ2H178696
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 13:16:26 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j5DBGPe8025392
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 13:16:26 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Maxim Shchetynin <maxim@de.ibm.com>

This is patch 3 of 8 in a series of zfcp bug fixes.  Patches are based
on 2.6.12-rc6 plus "remove flags_dump feature"-patch from June, 10th.

This one is to reopen a remote port only if the link-test fails. This
avoids that a port is unnecessarily reopened.


Regards,

Andreas


From: Maxim Shchetynin <maxim@de.ibm.com>
 
zfcp: fix: reopen port only if link-test fails

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_fsf.c linux-2.6.12-rc6/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_fsf.c	2005-06-13 09:37:47.000000000 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_fsf.c	2005-06-13 09:34:08.000000000 +0200
@@ -1267,8 +1267,7 @@
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
 			debug_text_event(new_fsf_req->adapter->erp_dbf, 1,
 					 "fsf_sq_ltest");
-			/* reopening link to port */
-			zfcp_erp_port_reopen(unit->port, 0);
+			zfcp_test_link(unit->port);
 			new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
@@ -3125,7 +3124,7 @@
 			/* Re-establish link to port */
 			debug_text_event(adapter->erp_dbf, 1,
 					 "fsf_sq_ltest");
-			zfcp_erp_port_reopen(unit->port, 0);
+			zfcp_test_link(unit->port);
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
@@ -3368,7 +3367,7 @@
 			/* re-establish link to port */
 			debug_text_event(fsf_req->adapter->erp_dbf, 1,
 					 "fsf_sq_ltest");
-			zfcp_erp_port_reopen(unit->port, 0);
+			zfcp_test_link(unit->port);
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
@@ -3931,12 +3930,7 @@
 			/* re-establish link to port */
 			debug_text_event(fsf_req->adapter->erp_dbf, 1,
 					 "fsf_sq_ltest");
-			zfcp_erp_port_reopen(unit->port, 0);
-			zfcp_cmd_dbf_event_fsf(
-				"sqltest",
-				fsf_req,
-				&header->fsf_status_qual,
-				sizeof (union fsf_status_qual));
+ 			zfcp_test_link(unit->port);
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
@@ -3944,11 +3938,6 @@
 			/* let scsi stack deal with retries and escalation */
 			debug_text_event(fsf_req->adapter->erp_dbf, 1,
 					 "fsf_sq_ulp");
-			zfcp_cmd_dbf_event_fsf(
-				"sqdeperp",
-				fsf_req,
-				&header->fsf_status_qual,
-				sizeof (union fsf_status_qual));
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		default:

