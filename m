From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 19/22] zfcp: Update FSF error reporting
Date: Tue, 24 Nov 2009 16:54:15 +0100
Message-ID: <20091124160138.788299000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:39612 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933409AbZKXQCS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:02:18 -0500
Content-Disposition: inline; filename=718-zfcp-fsf-errors.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The SCSI midlayer retries commands based on the remote port state and
the command status reported by the driver. Returning
DID_TRANSPORT_DISRUPTED is a better approach, use this for reporting
FSF errors back to the SCSI midlayer.  See
http://marc.info/?l=linux-scsi&m=125668044215051&w=2 as reference.

There is also no need in special treatment of ABORTED commands, so
remove the ZFCP_STATUS_FSFREQ_ABORTED, the commands are then returned
with DID_TRANSPORT_DISRUPTED.

Also remove the ZFCP_STATUS_FSFREQ_RETRY: It is useless, no retry is
happening in the FSF layer and nobody checks the state of this flag.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_def.h |    2 --
 drivers/s390/scsi/zfcp_fsf.c |   38 +++++++++++---------------------------
 2 files changed, 11 insertions(+), 29 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2009-11-23 09:59:45.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2009-11-23 09:59:45.000000000 +0100
@@ -110,10 +110,8 @@
 #define ZFCP_STATUS_FSFREQ_CLEANUP		0x00000010
 #define ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED	0x00000040
 #define ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED       0x00000080
-#define ZFCP_STATUS_FSFREQ_ABORTED              0x00000100
 #define ZFCP_STATUS_FSFREQ_TMFUNCFAILED         0x00000200
 #define ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP        0x00000400
-#define ZFCP_STATUS_FSFREQ_RETRY                0x00000800
 #define ZFCP_STATUS_FSFREQ_DISMISSED            0x00001000
 
 /************************* STRUCTURE DEFINITIONS *****************************/
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-11-23 09:59:45.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-11-23 09:59:45.000000000 +0100
@@ -315,7 +315,6 @@ static void zfcp_fsf_fsfstatus_qual_eval
 	case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 		return;
 	case FSF_SQ_COMMAND_ABORTED:
-		req->status |= ZFCP_STATUS_FSFREQ_ABORTED;
 		break;
 	case FSF_SQ_NO_RECOM:
 		dev_err(&req->adapter->ccw_device->dev,
@@ -356,8 +355,7 @@ static void zfcp_fsf_protstatus_eval(str
 	zfcp_dbf_hba_fsf_response(req);
 
 	if (req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			ZFCP_STATUS_FSFREQ_RETRY; /* only for SCSI cmnds. */
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		return;
 	}
 
@@ -375,7 +373,7 @@ static void zfcp_fsf_protstatus_eval(str
 	case FSF_PROT_ERROR_STATE:
 	case FSF_PROT_SEQ_NUMB_ERROR:
 		zfcp_erp_adapter_reopen(adapter, 0, "fspse_2", req);
-		req->status |= ZFCP_STATUS_FSFREQ_RETRY;
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_PROT_UNSUPP_QTCB_TYPE:
 		dev_err(&adapter->ccw_device->dev,
@@ -884,13 +882,11 @@ static void zfcp_fsf_abort_fcp_command_h
 		break;
 	case FSF_PORT_BOXED:
 		zfcp_erp_port_boxed(unit->port, "fsafch3", req);
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			       ZFCP_STATUS_FSFREQ_RETRY;
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_BOXED:
 		zfcp_erp_unit_boxed(unit, "fsafch4", req);
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			       ZFCP_STATUS_FSFREQ_RETRY;
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
                 break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (fsq->word[0]) {
@@ -988,8 +984,7 @@ static void zfcp_fsf_send_ct_handler(str
 	case FSF_ACCESS_DENIED:
 		break;
         case FSF_PORT_BOXED:
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			       ZFCP_STATUS_FSFREQ_RETRY;
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_PORT_HANDLE_NOT_VALID:
 		zfcp_erp_adapter_reopen(adapter, 0, "fsscth1", req);
@@ -1761,9 +1756,7 @@ static void zfcp_fsf_close_physical_port
 					  &unit->status);
 		read_unlock(&port->unit_list_lock);
 		zfcp_erp_port_boxed(port, "fscpph2", req);
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			       ZFCP_STATUS_FSFREQ_RETRY;
-
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]) {
@@ -1867,8 +1860,7 @@ static void zfcp_fsf_open_unit_handler(s
 		break;
 	case FSF_PORT_BOXED:
 		zfcp_erp_port_boxed(unit->port, "fsouh_2", req);
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			       ZFCP_STATUS_FSFREQ_RETRY;
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_SHARING_VIOLATION:
 		if (header->fsf_status_qual.word[0])
@@ -2030,8 +2022,7 @@ static void zfcp_fsf_close_unit_handler(
 		break;
 	case FSF_PORT_BOXED:
 		zfcp_erp_port_boxed(unit->port, "fscuh_3", req);
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			       ZFCP_STATUS_FSFREQ_RETRY;
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (req->qtcb->header.fsf_status_qual.word[0]) {
@@ -2164,13 +2155,8 @@ static void zfcp_fsf_send_fcp_command_ta
 		return;
 	}
 
-	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ABORTED)) {
-		set_host_byte(scpnt, DID_SOFT_ERROR);
-		goto skip_fsfstatus;
-	}
-
 	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
-		set_host_byte(scpnt, DID_ERROR);
+		set_host_byte(scpnt, DID_TRANSPORT_DISRUPTED);
 		goto skip_fsfstatus;
 	}
 
@@ -2266,13 +2252,11 @@ static void zfcp_fsf_send_fcp_command_ha
 		break;
 	case FSF_PORT_BOXED:
 		zfcp_erp_port_boxed(unit->port, "fssfch5", req);
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			       ZFCP_STATUS_FSFREQ_RETRY;
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_BOXED:
 		zfcp_erp_unit_boxed(unit, "fssfch6", req);
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			       ZFCP_STATUS_FSFREQ_RETRY;
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		if (header->fsf_status_qual.word[0] ==

