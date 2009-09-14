From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 6/9] mpt2sas: Call init_completion on a per request basis.
Date: Mon, 14 Sep 2009 11:05:24 +0530
Message-ID: <20090914053515.GH31450@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:50758 "EHLO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZINF6Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2009 01:58:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Now driver call init_completion on a per request basis.  At some
point the wait_for_completion_timeout is not waiting for the timeout,
instead returning immediately, thus going into diag reset.  This fix will
address all request using the wait_for_completion_timeout API. The previous
implimentation was only calling init_completion at driver
load time.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index a9c7176..f679bff 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2614,6 +2614,7 @@ mpt2sas_base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc,
 	    mpi_request->Operation == MPI2_SAS_OP_PHY_LINK_RESET)
 		ioc->ioc_link_reset_in_progress = 1;
 	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->base_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done,
 	    msecs_to_jiffies(10000));
 	if ((mpi_request->Operation == MPI2_SAS_OP_PHY_HARD_RESET ||
@@ -2715,6 +2716,7 @@ mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
 	ioc->base_cmds.smid = smid;
 	memcpy(request, mpi_request, sizeof(Mpi2SepReply_t));
 	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->base_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done,
 	    msecs_to_jiffies(10000));
 	if (!(ioc->base_cmds.status & MPT2_CMD_COMPLETE)) {
@@ -2991,6 +2993,7 @@ _base_send_port_enable(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	mpi_request->VP_ID = 0;
 
 	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->base_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done,
 	    300*HZ);
 	if (!(ioc->base_cmds.status & MPT2_CMD_COMPLETE)) {
@@ -3090,6 +3093,7 @@ _base_event_notification(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 		mpi_request->EventMasks[i] =
 		    le32_to_cpu(ioc->event_masks[i]);
 	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->base_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done, 30*HZ);
 	if (!(ioc->base_cmds.status & MPT2_CMD_COMPLETE)) {
 		printk(MPT2SAS_ERR_FMT "%s: timeout\n",
@@ -3486,7 +3490,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 
 	/* base internal command bits */
 	mutex_init(&ioc->base_cmds.mutex);
-	init_completion(&ioc->base_cmds.done);
 	ioc->base_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
 	ioc->base_cmds.status = MPT2_CMD_NOT_USED;
 
@@ -3494,7 +3497,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	ioc->transport_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
 	ioc->transport_cmds.status = MPT2_CMD_NOT_USED;
 	mutex_init(&ioc->transport_cmds.mutex);
-	init_completion(&ioc->transport_cmds.done);
 
 	/* task management internal command bits */
 	ioc->tm_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
@@ -3510,7 +3512,6 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	ioc->ctl_cmds.reply = kzalloc(ioc->reply_sz, GFP_KERNEL);
 	ioc->ctl_cmds.status = MPT2_CMD_NOT_USED;
 	mutex_init(&ioc->ctl_cmds.mutex);
-	init_completion(&ioc->ctl_cmds.done);
 
 	for (i = 0; i < MPI2_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
 		ioc->event_masks[i] = -1;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 33463ac..57d7246 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -812,6 +812,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		timeout = MPT2_IOCTL_DEFAULT_TIMEOUT;
 	else
 		timeout = karg.timeout;
+	init_completion(&ioc->ctl_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    timeout*HZ);
 	if (mpi_request->Function == MPI2_FUNCTION_SCSI_TASK_MGMT) {
@@ -1388,6 +1389,7 @@ _ctl_diag_register(void __user *arg, enum block_state state)
 			cpu_to_le32(ioc->product_specific[buffer_type][i]);
 
 	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->ctl_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT2_IOCTL_DEFAULT_TIMEOUT*HZ);
 
@@ -1654,6 +1656,7 @@ _ctl_send_release(struct MPT2SAS_ADAPTER *ioc, u8 buffer_type, u8 *issue_reset)
 	mpi_request->VP_ID = 0;
 
 	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->ctl_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT2_IOCTL_DEFAULT_TIMEOUT*HZ);
 
@@ -1915,6 +1918,7 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 	mpi_request->VP_ID = 0;
 
 	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->ctl_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT2_IOCTL_DEFAULT_TIMEOUT*HZ);
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 8bc57e3..eb98188 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -401,6 +401,7 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 	    "send to sas_addr(0x%016llx)\n", ioc->name,
 	    (unsigned long long)sas_address));
 	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->transport_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->transport_cmds.done,
 	    10*HZ);
 
@@ -1154,6 +1155,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	    "sending smp request\n", ioc->name, __func__));
 
 	mpt2sas_base_put_smid_default(ioc, smid);
+	init_completion(&ioc->transport_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->transport_cmds.done,
 	    10*HZ);
 
