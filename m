From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 5/9] zfcp: Add comments to switch/case fallthroughs
Date: Fri, 15 May 2009 13:18:18 +0200
Message-ID: <20090515112221.902442000@de.ibm.com>
References: <20090515111813.314177000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:62795 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651AbZEOLWW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 07:22:22 -0400
Content-Disposition: inline; filename=704-zfcp-comments.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Add comments where there is a deliberate fall through in switch/case
statements. This makes some code checkers happy and makes it clear
that there is no missing break statement.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    1 +
 drivers/s390/scsi/zfcp_fsf.c |    5 +++++
 2 files changed, 6 insertions(+)

--- a/drivers/s390/scsi/zfcp_erp.c	2009-05-15 12:56:02.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-05-15 12:56:17.000000000 +0200
@@ -880,6 +880,7 @@ static int zfcp_erp_port_strategy_open_c
 				zfcp_port_put(port);
 			return ZFCP_ERP_CONTINUES;
 		}
+		/* fall through */
 	case ZFCP_ERP_STEP_NAMESERVER_LOOKUP:
 		if (!port->d_id)
 			return ZFCP_ERP_FAILED;
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-05-15 12:56:15.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-05-15 12:56:17.000000000 +0200
@@ -526,6 +526,7 @@ static int zfcp_fsf_exchange_config_eval
 		break;
 	case FSF_TOPO_AL:
 		fc_host_port_type(shost) = FC_PORTTYPE_NLPORT;
+		/* fall through */
 	default:
 		dev_err(&adapter->ccw_device->dev,
 			"Unknown or unsupported arbitrated loop "
@@ -897,6 +898,7 @@ static void zfcp_fsf_abort_fcp_command_h
 		switch (fsq->word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
 			zfcp_test_link(unit->port);
+			/* fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
@@ -993,6 +995,7 @@ static void zfcp_fsf_send_ct_handler(str
 		break;
 	case FSF_PORT_HANDLE_NOT_VALID:
 		zfcp_erp_adapter_reopen(adapter, 0, "fsscth1", req);
+		/* fall through */
 	case FSF_GENERIC_COMMAND_REJECTED:
 	case FSF_PAYLOAD_SIZE_MISMATCH:
 	case FSF_REQUEST_SIZE_TOO_LARGE:
@@ -1590,8 +1593,10 @@ static void zfcp_fsf_open_wka_port_handl
 	case FSF_MAXIMUM_NUMBER_OF_PORTS_EXCEEDED:
 		dev_warn(&req->adapter->ccw_device->dev,
 			 "Opening WKA port 0x%x failed\n", wka_port->d_id);
+		/* fall through */
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		/* fall through */
 	case FSF_ACCESS_DENIED:
 		wka_port->status = ZFCP_WKA_PORT_OFFLINE;
 		break;

