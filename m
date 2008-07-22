From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/6] ibmvfc: Reduce unnecessary log noise
Date: Tue, 22 Jul 2008 08:31:39 -0500
Message-ID: <200807221332.m6MDW1pU021705@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:40920 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbYGVNcL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jul 2008 09:32:11 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6MDWARJ000593
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2008 09:32:10 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6MDW5mP171452
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2008 07:32:06 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6MDW4bf021937
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2008 07:32:05 -0600
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
