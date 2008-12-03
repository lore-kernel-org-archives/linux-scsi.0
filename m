From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ibmvfc: Delay NPIV login retry and add retries
Date: Wed, 03 Dec 2008 11:02:54 -0600
Message-ID: <200812031703.mB3H3cMT027696@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:52546 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYLCRDs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 12:03:48 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mB3H2Nb1028605
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2008 10:02:23 -0700
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mB3H3eFV156238
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2008 10:03:43 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mB3H3dkD027798
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2008 10:03:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Adds a delay prior to retrying a failed NPIV login. This fixes
a scenario if the backing fibre channel adapter is getting reset
due to an EEH event, NPIV login will fail. Currently, ibmvfc
retries three times very quickly, resets the CRQ and tries one
more time. If the adapter is getting reset due to EEH, this isn't
enough time. This adds a delay prior to retrying a failed NPIV
login and also increments the number of retries.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   17 ++++++++++++-----
 drivers/scsi/ibmvscsi/ibmvfc.h |    4 +++-
 2 files changed, 15 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_host_init_delay drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_host_init_delay	2008-11-25 08:15:17.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-11-26 15:04:21.000000000 -0600
@@ -561,7 +561,7 @@ static void ibmvfc_init_host(struct ibmv
 	struct ibmvfc_target *tgt;
 
 	if (vhost->action == IBMVFC_HOST_ACTION_INIT_WAIT) {
-		if (++vhost->init_retries > IBMVFC_MAX_INIT_RETRIES) {
+		if (++vhost->init_retries > IBMVFC_MAX_HOST_INIT_RETRIES) {
 			dev_err(vhost->dev,
 				"Host initialization retries exceeded. Taking adapter offline\n");
 			ibmvfc_link_down(vhost, IBMVFC_HOST_OFFLINE);
@@ -845,11 +845,12 @@ static void ibmvfc_reset_host(struct ibm
 static void ibmvfc_retry_host_init(struct ibmvfc_host *vhost)
 {
 	if (vhost->action == IBMVFC_HOST_ACTION_INIT_WAIT) {
-		if (++vhost->init_retries > IBMVFC_MAX_INIT_RETRIES) {
+		vhost->delay_init = 1;
+		if (++vhost->init_retries > IBMVFC_MAX_HOST_INIT_RETRIES) {
 			dev_err(vhost->dev,
 				"Host initialization retries exceeded. Taking adapter offline\n");
 			ibmvfc_link_down(vhost, IBMVFC_HOST_OFFLINE);
-		} else if (vhost->init_retries == IBMVFC_MAX_INIT_RETRIES)
+		} else if (vhost->init_retries == IBMVFC_MAX_HOST_INIT_RETRIES)
 			__ibmvfc_reset_host(vhost);
 		else
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT);
@@ -2756,7 +2757,7 @@ static void ibmvfc_init_tgt(struct ibmvf
 static void ibmvfc_retry_tgt_init(struct ibmvfc_target *tgt,
 				  void (*job_step) (struct ibmvfc_target *))
 {
-	if (++tgt->init_retries > IBMVFC_MAX_INIT_RETRIES) {
+	if (++tgt->init_retries > IBMVFC_MAX_TGT_INIT_RETRIES) {
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DEL_RPORT);
 		wake_up(&tgt->vhost->work_wait_q);
 	} else
@@ -3613,7 +3614,13 @@ static void ibmvfc_do_work(struct ibmvfc
 		break;
 	case IBMVFC_HOST_ACTION_INIT:
 		BUG_ON(vhost->state != IBMVFC_INITIALIZING);
-		vhost->job_step(vhost);
+		if (vhost->delay_init) {
+			vhost->delay_init = 0;
+			spin_unlock_irqrestore(vhost->host->host_lock, flags);
+			ssleep(5);
+			return;
+		} else
+			vhost->job_step(vhost);
 		break;
 	case IBMVFC_HOST_ACTION_QUERY:
 		list_for_each_entry(tgt, &vhost->targets, queue)
diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_host_init_delay drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_host_init_delay	2008-11-25 08:15:17.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2008-11-26 15:04:21.000000000 -0600
@@ -43,7 +43,8 @@
 #define IBMVFC_MAX_DISC_THREADS	4
 #define IBMVFC_TGT_MEMPOOL_SZ		64
 #define IBMVFC_MAX_CMDS_PER_LUN	64
-#define IBMVFC_MAX_INIT_RETRIES	3
+#define IBMVFC_MAX_HOST_INIT_RETRIES	6
+#define IBMVFC_MAX_TGT_INIT_RETRIES		3
 #define IBMVFC_DEV_LOSS_TMO		(5 * 60)
 #define IBMVFC_DEFAULT_LOG_LEVEL	2
 #define IBMVFC_MAX_CDB_LEN		16
@@ -673,6 +674,7 @@ struct ibmvfc_host {
 	int discovery_threads;
 	int client_migrated;
 	int reinit;
+	int delay_init;
 	int events_to_log;
 #define IBMVFC_AE_LINKUP	0x0001
 #define IBMVFC_AE_LINKDOWN	0x0002
_
