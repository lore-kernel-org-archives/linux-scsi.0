From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH] zfcp: bugfixes (without kfree) for -bk
Date: Mon, 31 Jan 2005 11:48:02 +0100
Message-ID: <20050131104802.GA10449@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:41920 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S261845AbVAaKsT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 05:48:19 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id j0VAmIdt070820
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2005 10:48:18 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0VAmIGj139116
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2005 11:48:18 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j0VAmHuW004957
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2005 11:48:18 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

this one contains only bugfixes and no sysfs crap. I hope this is acceptable.

Thanks,
Heiko

From: Andreas Herrmann <aherrman@de.ibm.com>
From: Maxim Shchetynin <maxim@de.ibm.com>

zfcp changes:
 - don't call del_timer_sync() in interrupt context
 - correct residual count handling for data underruns
 - mark LUN as ACCESS_DENIED on status LUN_SHARING_VIOLATION

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

 zfcp_erp.c |    6 +++---
 zfcp_fsf.c |   37 ++++++++++++++++++-------------------
 2 files changed, 21 insertions(+), 22 deletions(-)

diff -urN a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
--- a/drivers/s390/scsi/zfcp_erp.c	2004-12-24 22:35:50.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2005-01-31 10:44:30.000000000 +0100
@@ -31,7 +31,7 @@
 
 #define ZFCP_LOG_AREA			ZFCP_LOG_AREA_ERP
 
-#define ZFCP_ERP_REVISION "$Revision: 1.85 $"
+#define ZFCP_ERP_REVISION "$Revision: 1.86 $"
 
 #include "zfcp_ext.h"
 
@@ -369,7 +369,7 @@
 		ZFCP_LOG_NORMAL("error: initiation of Send ELS failed for port "
 				"0x%08x on adapter %s\n", d_id,
 				zfcp_get_busid_by_adapter(adapter));
-		del_timer_sync(send_els->timer);
+		del_timer(send_els->timer);
 		goto freemem;
 	}
 
@@ -969,7 +969,7 @@
 		debug_event(adapter->erp_dbf, 2, &erp_action->action,
 			    sizeof (int));
 		if (!(set_mask & ZFCP_STATUS_ERP_TIMEDOUT))
-			del_timer_sync(&erp_action->timer);
+			del_timer(&erp_action->timer);
 		erp_action->status |= set_mask;
 		zfcp_erp_action_ready(erp_action);
 		retval = 0;
diff -urN a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
--- a/drivers/s390/scsi/zfcp_fsf.c	2004-12-24 22:35:23.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2005-01-31 11:00:18.000000000 +0100
@@ -30,7 +30,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#define ZFCP_FSF_C_REVISION "$Revision: 1.88 $"
+#define ZFCP_FSF_C_REVISION "$Revision: 1.92 $"
 
 #include "zfcp_ext.h"
 
@@ -3203,7 +3203,9 @@
 			      sizeof (union fsf_status_qual));
 		debug_text_event(adapter->erp_dbf, 2,
 				 "fsf_s_l_sh_vio");
-		zfcp_erp_unit_failed(unit);
+		zfcp_erp_unit_access_denied(unit);
+		atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
+		atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -4320,22 +4322,19 @@
 
 	/* check for underrun */
 	if (unlikely(fcp_rsp_iu->validity.bits.fcp_resid_under)) {
-		ZFCP_LOG_DEBUG("A data underrun was detected for a command. "
-			       "unit 0x%016Lx, port 0x%016Lx, adapter %s. "
-			       "The response data length is "
-			       "%d, the original length was %d.\n",
-			       unit->fcp_lun,
-			       unit->port->wwpn,
-			       zfcp_get_busid_by_unit(unit),
-			       fcp_rsp_iu->fcp_resid,
-			       (int) zfcp_get_fcp_dl(fcp_cmnd_iu));
-		/*
-		 * It may not have been possible to send all data and the
-		 * underrun on send may already be in scpnt->resid, so it's add
-		 * not equals in the below statement.
-		 */
-		scpnt->resid += fcp_rsp_iu->fcp_resid;
-		ZFCP_LOG_TRACE("scpnt->resid=0x%x\n", scpnt->resid);
+		ZFCP_LOG_INFO("A data underrun was detected for a command. "
+			      "unit 0x%016Lx, port 0x%016Lx, adapter %s. "
+			      "The response data length is "
+			      "%d, the original length was %d.\n",
+			      unit->fcp_lun,
+			      unit->port->wwpn,
+			      zfcp_get_busid_by_unit(unit),
+			      fcp_rsp_iu->fcp_resid,
+			      (int) zfcp_get_fcp_dl(fcp_cmnd_iu));
+
+		scpnt->resid = fcp_rsp_iu->fcp_resid;
+		if (scpnt->request_bufflen - scpnt->resid < scpnt->underflow)
+			scpnt->result |= DID_ERROR << 16;
 	}
 
  skip_fsfstatus:
@@ -5023,7 +5022,7 @@
 		 * timer might be expired (absolutely unlikely)
 		 */
 		if (timer)
-			del_timer_sync(timer);
+			del_timer(timer);
 		write_lock_irqsave(&adapter->fsf_req_list_lock, flags);
 		list_del(&fsf_req->list);
 		write_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
