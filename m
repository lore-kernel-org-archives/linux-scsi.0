From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: [patch] ibmvscsi.c: fix error/abort paths
Date: Tue, 21 Dec 2004 16:38:34 -0600
Message-ID: <20041221223834.GB2736@cs.umn.edu>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.33.102]:62658 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S261886AbULUWih (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2004 17:38:37 -0500
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id 5D87F5C355
	for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2004 16:38:37 -0600 (CST)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (augustus [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 13691-01 for <linux-scsi@vger.kernel.org>;
 Tue, 21 Dec 2004 16:38:35 -0600 (CST)
Received: from tera.cs.umn.edu (tera.cs.umn.edu [128.101.35.163])
	by mail.cs.umn.edu (Postfix) with ESMTP id 657865C374
	for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2004 16:38:34 -0600 (CST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Description: Fix error paths to handle SCSI targets 
that reject SCSI aborts and resets and subsequently
complete SCSI commands.  There are targets in the field
that currently exhibit this behaviour, particularly in
the case of bad media (a CD drive got stuck for a LOOONG
time on a read op.)  We previously ignore the status
on aborts and resets under the mistaken belief that
whether they worked or not, the command response was
never going to show up.

Signed-off-by: Dave Boutcher <boutcher@us.ibm.com>
---

 ibmvscsi.c |   83 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 ibmvscsi.h |    1 
 2 files changed, 80 insertions(+), 4 deletions(-)

Index: linux-2.6.10-rc3/drivers/scsi/ibmvscsi/ibmvscsi.c
===================================================================
--- linux-2.6.10-rc3.orig/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-21 14:33:14.000000000 -0600
+++ linux-2.6.10-rc3/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-21 14:47:43.000000000 -0600
@@ -88,7 +88,7 @@
 static int max_requests = 50;
 static int max_sectors = 32 * 8; /* default max I/O 32 pages */
 
-#define IBMVSCSI_VERSION "1.5.4"
+#define IBMVSCSI_VERSION "1.5.5"
 
 MODULE_DESCRIPTION("IBM Virtual SCSI");
 MODULE_AUTHOR("Dave Boutcher");
@@ -257,6 +257,7 @@
 {
 	evt_struct->cmnd = NULL;
 	evt_struct->cmnd_done = NULL;
+	evt_struct->sync_srp = NULL;
 	evt_struct->crq.format = format;
 	evt_struct->crq.timeout = timeout;
 	evt_struct->done = done;
@@ -537,6 +538,13 @@
 	struct srp_rsp *rsp = &evt_struct->xfer_iu->srp.rsp;
 	struct scsi_cmnd *cmnd = evt_struct->cmnd;
 
+	if (unlikely(rsp->type != SRP_RSP_TYPE)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING 
+			       "ibmvscsi: bad SRP RSP type %d\n",
+			       rsp->type);
+	}
+	
 	if (cmnd) {
 		cmnd->result = rsp->status;
 		if (((cmnd->result >> 1) & 0x1f) == CHECK_CONDITION)
@@ -801,6 +809,10 @@
  */
 static void sync_completion(struct srp_event_struct *evt_struct)
 {
+	/* copy the response back */
+	if (evt_struct->sync_srp)
+		*evt_struct->sync_srp = *evt_struct->xfer_iu;
+	
 	complete(&evt_struct->comp);
 }
 
@@ -815,6 +827,8 @@
 	struct srp_tsk_mgmt *tsk_mgmt;
 	struct srp_event_struct *evt;
 	struct srp_event_struct *tmp_evt, *found_evt;
+	union viosrp_iu srp_rsp;
+	int rsp_rc;
 	u16 lun = lun_from_dev(cmd->device);
 
 	/* First, find this command in our sent list so we can figure
@@ -854,6 +868,7 @@
 	printk(KERN_INFO "ibmvscsi: aborting command. lun 0x%lx, tag 0x%lx\n",
 	       tsk_mgmt->lun, tsk_mgmt->managed_task_tag);
 
+	evt->sync_srp = &srp_rsp;
 	init_completion(&evt->comp);
 	if (ibmvscsi_send_srp_event(evt, hostdata) != 0) {
 		printk(KERN_ERR "ibmvscsi: failed to send abort() event\n");
@@ -864,6 +879,29 @@
 	wait_for_completion(&evt->comp);
 	spin_lock_irq(hostdata->host->host_lock);
 
+	/* make sure we got a good response */
+	if (unlikely(srp_rsp.srp.generic.type != SRP_RSP_TYPE)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING 
+			       "ibmvscsi: abort bad SRP RSP type %d\n",
+			       srp_rsp.srp.generic.type);
+		return FAILED;
+	}
+
+	if (srp_rsp.srp.rsp.rspvalid)
+		rsp_rc = *((int *)srp_rsp.srp.rsp.sense_and_response_data);
+	else
+		rsp_rc = srp_rsp.srp.rsp.status;
+
+	if (rsp_rc) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING 
+		       "ibmvscsi: abort code %d for task tag 0x%lx\n",
+			       rsp_rc,
+			       tsk_mgmt->managed_task_tag);
+		return FAILED;
+	}
+
 	/* Because we dropped the spinlock above, it's possible
 	 * The event is no longer in our list.  Make sure it didn't
 	 * complete while we were aborting
@@ -876,13 +914,17 @@
 		}
 	}
 
+	if (found_evt == NULL) {
+		printk(KERN_INFO
+		       "ibmvscsi: aborted task tag 0x%lx completed\n",
+		       tsk_mgmt->managed_task_tag);
+		return SUCCESS;
+	}
+
 	printk(KERN_INFO
 	       "ibmvscsi: successfully aborted task tag 0x%lx\n",
 	       tsk_mgmt->managed_task_tag);
 
-	if (found_evt == NULL)
-		return SUCCESS;
-
 	cmd->result = (DID_ABORT << 16);
 	list_del(&found_evt->list);
 	unmap_cmd_data(&found_evt->iu.srp.cmd, found_evt->hostdata->dev);
@@ -904,6 +946,8 @@
 	struct srp_tsk_mgmt *tsk_mgmt;
 	struct srp_event_struct *evt;
 	struct srp_event_struct *tmp_evt, *pos;
+	union viosrp_iu srp_rsp;
+	int rsp_rc;
 	u16 lun = lun_from_dev(cmd->device);
 
 	evt = get_event_struct(&hostdata->pool);
@@ -928,6 +972,7 @@
 	printk(KERN_INFO "ibmvscsi: resetting device. lun 0x%lx\n",
 	       tsk_mgmt->lun);
 
+	evt->sync_srp = &srp_rsp;
 	init_completion(&evt->comp);
 	if (ibmvscsi_send_srp_event(evt, hostdata) != 0) {
 		printk(KERN_ERR "ibmvscsi: failed to send reset event\n");
@@ -938,6 +983,29 @@
 	wait_for_completion(&evt->comp);
 	spin_lock_irq(hostdata->host->host_lock);
 
+	/* make sure we got a good response */
+	if (unlikely(srp_rsp.srp.generic.type != SRP_RSP_TYPE)) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING 
+			       "ibmvscsi: reset bad SRP RSP type %d\n",
+			       srp_rsp.srp.generic.type);
+		return FAILED;
+	}
+
+	if (srp_rsp.srp.rsp.rspvalid)
+		rsp_rc = *((int *)srp_rsp.srp.rsp.sense_and_response_data);
+	else
+		rsp_rc = srp_rsp.srp.rsp.status;
+
+	if (rsp_rc) {
+		if (printk_ratelimit())
+			printk(KERN_WARNING 
+			       "ibmvscsi: reset code %d for task tag 0x%lx\n",
+		       rsp_rc,
+			       tsk_mgmt->managed_task_tag);
+		return FAILED;
+	}
+
 	/* We need to find all commands for this LUN that have not yet been
 	 * responded to, and fail them with DID_RESET
 	 */
@@ -1053,6 +1121,13 @@
 		return;
 	}
 
+	if (atomic_read(&evt_struct->free)) {
+		printk(KERN_ERR
+		       "ibmvscsi: received duplicate  correlation_token 0x%p!\n",
+		       (void *)crq->IU_data_ptr);
+		return;
+	}
+
 	if (crq->format == VIOSRP_SRP_FORMAT)
 		atomic_add(evt_struct->xfer_iu->srp.rsp.request_limit_delta,
 			   &hostdata->request_limit);
Index: linux-2.6.10-rc3/drivers/scsi/ibmvscsi/ibmvscsi.h
===================================================================
--- linux-2.6.10-rc3.orig/drivers/scsi/ibmvscsi/ibmvscsi.h	2004-12-21 14:34:25.000000000 -0600
+++ linux-2.6.10-rc3/drivers/scsi/ibmvscsi/ibmvscsi.h	2004-12-21 14:47:44.000000000 -0600
@@ -67,6 +67,7 @@
 	union viosrp_iu iu;
 	void (*cmnd_done) (struct scsi_cmnd *);
 	struct completion comp;
+	union viosrp_iu *sync_srp;
 };
 
 /* a pool of event structs for use */
-- 
Dave Boutcher
