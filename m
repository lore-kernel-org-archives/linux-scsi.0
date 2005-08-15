From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: [patch] ibmvscsi eh locking
Date: Mon, 15 Aug 2005 16:52:58 -0500
Message-ID: <20050815215258.GA26240@cs.umn.edu>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.36.202]:59123 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S964997AbVHOVxB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 17:53:01 -0400
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id 3408D5C59B
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2005 16:53:01 -0500 (CDT)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (mail.cs.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 24930-01 for <linux-scsi@vger.kernel.org>;
 Mon, 15 Aug 2005 16:52:59 -0500 (CDT)
Received: from tera.cs.umn.edu (tera.cs.umn.edu [128.101.35.163])
	by mail.cs.umn.edu (Postfix) with ESMTP id 0B4C25C59D
	for <linux-scsi@vger.kernel.org>; Mon, 15 Aug 2005 16:52:59 -0500 (CDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Sorry, been asleep at the wheel for a while.  With the removal
of the spinlocking around eh calls, we need to add a little
more locking back in, otherwise we do some naked list
manipulation.

Signed-off-by: Dave Boutcher <boutcher@us.ibm.com>

-- 

--- linux-2.6.13-rc6/drivers/scsi/ibmvscsi/ibmvscsi.c	2005-08-10 10:51:00.000000000 -0500
+++ linux-2.6.13-rc6-ibmvscsis/drivers/scsi/ibmvscsi/ibmvscsi.c	2005-08-15 16:44:12.068554673 -0500
@@ -826,11 +826,13 @@
 	struct srp_event_struct *tmp_evt, *found_evt;
 	union viosrp_iu srp_rsp;
 	int rsp_rc;
+	unsigned long flags;
 	u16 lun = lun_from_dev(cmd->device);
 
 	/* First, find this command in our sent list so we can figure
 	 * out the correct tag
 	 */
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	found_evt = NULL;
 	list_for_each_entry(tmp_evt, &hostdata->sent, list) {
 		if (tmp_evt->cmnd == cmd) {
@@ -839,11 +841,14 @@
 		}
 	}
 
-	if (!found_evt) 
+	if (!found_evt) {
+		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 		return FAILED;
+	}
 
 	evt = get_event_struct(&hostdata->pool);
 	if (evt == NULL) {
+		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 		printk(KERN_ERR "ibmvscsi: failed to allocate abort event\n");
 		return FAILED;
 	}
@@ -867,7 +872,9 @@
 
 	evt->sync_srp = &srp_rsp;
 	init_completion(&evt->comp);
-	if (ibmvscsi_send_srp_event(evt, hostdata) != 0) {
+	rsp_rc = ibmvscsi_send_srp_event(evt, hostdata);
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	if (rsp_rc != 0) {
 		printk(KERN_ERR "ibmvscsi: failed to send abort() event\n");
 		return FAILED;
 	}
@@ -901,6 +908,7 @@
 	 * The event is no longer in our list.  Make sure it didn't
 	 * complete while we were aborting
 	 */
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	found_evt = NULL;
 	list_for_each_entry(tmp_evt, &hostdata->sent, list) {
 		if (tmp_evt->cmnd == cmd) {
@@ -910,6 +918,7 @@
 	}
 
 	if (found_evt == NULL) {
+		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 		printk(KERN_INFO
 		       "ibmvscsi: aborted task tag 0x%lx completed\n",
 		       tsk_mgmt->managed_task_tag);
@@ -924,6 +933,7 @@
 	list_del(&found_evt->list);
 	unmap_cmd_data(&found_evt->iu.srp.cmd, found_evt->hostdata->dev);
 	free_event_struct(&found_evt->hostdata->pool, found_evt);
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 	atomic_inc(&hostdata->request_limit);
 	return SUCCESS;
 }
@@ -943,10 +953,13 @@
 	struct srp_event_struct *tmp_evt, *pos;
 	union viosrp_iu srp_rsp;
 	int rsp_rc;
+	unsigned long flags;
 	u16 lun = lun_from_dev(cmd->device);
 
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	evt = get_event_struct(&hostdata->pool);
 	if (evt == NULL) {
+		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 		printk(KERN_ERR "ibmvscsi: failed to allocate reset event\n");
 		return FAILED;
 	}
@@ -969,7 +982,9 @@
 
 	evt->sync_srp = &srp_rsp;
 	init_completion(&evt->comp);
-	if (ibmvscsi_send_srp_event(evt, hostdata) != 0) {
+	rsp_rc = ibmvscsi_send_srp_event(evt, hostdata);
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+	if (rsp_rc != 0) {
 		printk(KERN_ERR "ibmvscsi: failed to send reset event\n");
 		return FAILED;
 	}
@@ -1002,6 +1017,7 @@
 	/* We need to find all commands for this LUN that have not yet been
 	 * responded to, and fail them with DID_RESET
 	 */
+	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	list_for_each_entry_safe(tmp_evt, pos, &hostdata->sent, list) {
 		if ((tmp_evt->cmnd) && (tmp_evt->cmnd->device == cmd->device)) {
 			if (tmp_evt->cmnd)
@@ -1017,6 +1033,7 @@
 				tmp_evt->done(tmp_evt);
 		}
 	}
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 	return SUCCESS;
 }
 
