From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/6] ibmvfc: Reduce unnecessary log noise
Date: Mon, 14 Jul 2008 14:36:29 -0500
Message-ID: <200807141936.m6EJafjQ016516@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38866 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482AbYGNTgr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 15:36:47 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6EJakQG031151
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 15:36:47 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6EJajUq1916960
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 15:36:46 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6EJafgF016584
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 13:36:42 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Reduces some unnecessary log noise by removing a printk during
host port state query and increasing the log level required to
log received async events.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_port_state_fix drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_port_state_fix	2008-07-14 09:01:59.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-07-14 10:13:03.000000000 -0500
@@ -963,6 +963,9 @@ static void ibmvfc_get_host_port_state(s
 	case IBMVFC_HALTED:
 		fc_host_port_state(shost) = FC_PORTSTATE_BLOCKED;
 		break;
+	case IBMVFC_NO_CRQ:
+		fc_host_port_state(shost) = FC_PORTSTATE_UNKNOWN;
+		break;
 	default:
 		ibmvfc_log(vhost, 3, "Unknown port state: %d\n", vhost->state);
 		fc_host_port_state(shost) = FC_PORTSTATE_UNKNOWN;
@@ -1404,7 +1407,7 @@ static void ibmvfc_log_error(struct ibmv
 		err = cmd_status[index].name;
 	}
 
-	if (!logerr && (vhost->log_level <= IBMVFC_DEFAULT_LOG_LEVEL))
+	if (!logerr && (vhost->log_level <= (IBMVFC_DEFAULT_LOG_LEVEL + 1)))
 		return;
 
 	if (rsp->flags & FCP_RSP_LEN_VALID)
@@ -2054,7 +2057,7 @@ static void ibmvfc_handle_async(struct i
 {
 	const char *desc = ibmvfc_get_ae_desc(crq->event);
 
-	ibmvfc_log(vhost, 2, "%s event received\n", desc);
+	ibmvfc_log(vhost, 3, "%s event received\n", desc);
 
 	switch (crq->event) {
 	case IBMVFC_AE_LINK_UP:
_
