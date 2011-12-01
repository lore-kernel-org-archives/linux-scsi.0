From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 06/07] [SCSI] mpt2sas : Rearrange the the code so that the completion queues are initialized prior to sending the request to controller firmware
Date: Thu, 1 Dec 2011 07:43:58 +0530
Message-ID: <201112010920.pB19KQI1018414@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:52111 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab1LAJUb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 04:20:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Rearrange the the code so that the completion queues are initialized prior
to sending the request to controller firmware.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index d0a36c9..e78733f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3200,8 +3200,8 @@ mpt2sas_base_sas_iounit_control(struct MPT2SAS_ADAPTER *ioc,
 	if (mpi_request->Operation == MPI2_SAS_OP_PHY_HARD_RESET ||
 	    mpi_request->Operation == MPI2_SAS_OP_PHY_LINK_RESET)
 		ioc->ioc_link_reset_in_progress = 1;
-	mpt2sas_base_put_smid_default(ioc, smid);
 	init_completion(&ioc->base_cmds.done);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done,
 	    msecs_to_jiffies(10000));
 	if ((mpi_request->Operation == MPI2_SAS_OP_PHY_HARD_RESET ||
@@ -3302,8 +3302,8 @@ mpt2sas_base_scsi_enclosure_processor(struct MPT2SAS_ADAPTER *ioc,
 	request = mpt2sas_base_get_msg_frame(ioc, smid);
 	ioc->base_cmds.smid = smid;
 	memcpy(request, mpi_request, sizeof(Mpi2SepReply_t));
-	mpt2sas_base_put_smid_default(ioc, smid);
 	init_completion(&ioc->base_cmds.done);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done,
 	    msecs_to_jiffies(10000));
 	if (!(ioc->base_cmds.status & MPT2_CMD_COMPLETE)) {
@@ -3810,8 +3810,8 @@ _base_event_notification(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	for (i = 0; i < MPI2_EVENT_NOTIFY_EVENTMASK_WORDS; i++)
 		mpi_request->EventMasks[i] =
 		    cpu_to_le32(ioc->event_masks[i]);
-	mpt2sas_base_put_smid_default(ioc, smid);
 	init_completion(&ioc->base_cmds.done);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->base_cmds.done, 30*HZ);
 	if (!(ioc->base_cmds.status & MPT2_CMD_COMPLETE)) {
 		printk(MPT2SAS_ERR_FMT "%s: timeout\n",
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index cffed28..cb8290b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -819,6 +819,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 	_ctl_display_some_debug(ioc, smid, "ctl_request", NULL);
 #endif
 
+	init_completion(&ioc->ctl_cmds.done);
 	switch (mpi_request->Function) {
 	case MPI2_FUNCTION_SCSI_IO_REQUEST:
 	case MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH:
@@ -904,7 +905,6 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		timeout = MPT2_IOCTL_DEFAULT_TIMEOUT;
 	else
 		timeout = karg.timeout;
-	init_completion(&ioc->ctl_cmds.done);
 	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    timeout*HZ);
 	if (mpi_request->Function == MPI2_FUNCTION_SCSI_TASK_MGMT) {
@@ -1478,8 +1478,8 @@ _ctl_diag_register_2(struct MPT2SAS_ADAPTER *ioc,
 		mpi_request->ProductSpecific[i] =
 			cpu_to_le32(ioc->product_specific[buffer_type][i]);
 
-	mpt2sas_base_put_smid_default(ioc, smid);
 	init_completion(&ioc->ctl_cmds.done);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT2_IOCTL_DEFAULT_TIMEOUT*HZ);
 
@@ -1822,8 +1822,8 @@ _ctl_send_release(struct MPT2SAS_ADAPTER *ioc, u8 buffer_type, u8 *issue_reset)
 	mpi_request->VF_ID = 0; /* TODO */
 	mpi_request->VP_ID = 0;
 
-	mpt2sas_base_put_smid_default(ioc, smid);
 	init_completion(&ioc->ctl_cmds.done);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT2_IOCTL_DEFAULT_TIMEOUT*HZ);
 
@@ -2096,8 +2096,8 @@ _ctl_diag_read_buffer(void __user *arg, enum block_state state)
 	mpi_request->VF_ID = 0; /* TODO */
 	mpi_request->VP_ID = 0;
 
-	mpt2sas_base_put_smid_default(ioc, smid);
 	init_completion(&ioc->ctl_cmds.done);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->ctl_cmds.done,
 	    MPT2_IOCTL_DEFAULT_TIMEOUT*HZ);
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 322285c..d0750eb 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -398,8 +398,8 @@ _transport_expander_report_manufacture(struct MPT2SAS_ADAPTER *ioc,
 	dtransportprintk(ioc, printk(MPT2SAS_INFO_FMT "report_manufacture - "
 	    "send to sas_addr(0x%016llx)\n", ioc->name,
 	    (unsigned long long)sas_address));
-	mpt2sas_base_put_smid_default(ioc, smid);
 	init_completion(&ioc->transport_cmds.done);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->transport_cmds.done,
 	    10*HZ);
 
@@ -1186,8 +1186,8 @@ _transport_get_expander_phy_error_log(struct MPT2SAS_ADAPTER *ioc,
 	dtransportprintk(ioc, printk(MPT2SAS_INFO_FMT "phy_error_log - "
 	    "send to sas_addr(0x%016llx), phy(%d)\n", ioc->name,
 	    (unsigned long long)phy->identify.sas_address, phy->number));
-	mpt2sas_base_put_smid_default(ioc, smid);
 	init_completion(&ioc->transport_cmds.done);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->transport_cmds.done,
 	    10*HZ);
 
@@ -1511,8 +1511,9 @@ _transport_expander_phy_control(struct MPT2SAS_ADAPTER *ioc,
 	    "send to sas_addr(0x%016llx), phy(%d), opcode(%d)\n", ioc->name,
 	    (unsigned long long)phy->identify.sas_address, phy->number,
 	    phy_operation));
-	mpt2sas_base_put_smid_default(ioc, smid);
+
 	init_completion(&ioc->transport_cmds.done);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->transport_cmds.done,
 	    10*HZ);
 
@@ -1951,8 +1952,8 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	dtransportprintk(ioc, printk(MPT2SAS_INFO_FMT "%s - "
 	    "sending smp request\n", ioc->name, __func__));
 
-	mpt2sas_base_put_smid_default(ioc, smid);
 	init_completion(&ioc->transport_cmds.done);
+	mpt2sas_base_put_smid_default(ioc, smid);
 	timeleft = wait_for_completion_timeout(&ioc->transport_cmds.done,
 	    10*HZ);
 
