From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] [4/8] zfcp: fix: mark fsf request failed when receiving unknown status qualifier
Date: Mon, 13 Jun 2005 13:17:44 +0200
Message-ID: <20050613111744.GD8998@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:59272 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S261499AbVFMLRn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 07:17:43 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id j5DBHhew123196
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 11:17:43 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5DBHg2H174560
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 13:17:42 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j5DBHgHI026852
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 13:17:42 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Maxim Shchetynin <maxim@de.ibm.com>

This is patch 4 of 8 in a series of zfcp bug fixes.  Patches are based
on 2.6.12-rc6 plus "remove flags_dump feature"-patch from June, 10th.

This one corrects a bug in zfcp_fsf_send_fcp_command_handler.
An fsf request was not marked as failed if an unknown status qualifier
was returned. 


Regards,

Andreas


From: Maxim Shchetynin <maxim@de.ibm.com>
 
zfcp: fix: mark fsf request failed when receiving unknown status qualifier

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_fsf.c linux-2.6.12-rc6/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_fsf.c	2005-06-13 09:51:09.000000000 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_fsf.c	2005-06-13 09:51:22.000000000 +0200
@@ -3931,19 +3931,16 @@
 			debug_text_event(fsf_req->adapter->erp_dbf, 1,
 					 "fsf_sq_ltest");
  			zfcp_test_link(unit->port);
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			/* FIXME(hw) need proper specs for proper action */
 			/* let scsi stack deal with retries and escalation */
 			debug_text_event(fsf_req->adapter->erp_dbf, 1,
 					 "fsf_sq_ulp");
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		default:
-			/* FIXME: shall we consider this a successful transfer? */
 			ZFCP_LOG_NORMAL
-			    ("bug: Wrong status qualifier 0x%x arrived.\n",
+ 			    ("Unknown status qualifier 0x%x arrived.\n",
 			     header->fsf_status_qual.word[0]);
 			debug_text_event(fsf_req->adapter->erp_dbf, 0,
 					 "fsf_sq_inval:");
@@ -3952,6 +3949,7 @@
 					sizeof(u32));
 			break;
 		}
+		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_GOOD:

