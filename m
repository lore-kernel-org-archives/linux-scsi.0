From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH] aacraid: Fix command send race condition
Date: Tue, 29 Aug 2017 10:00:29 -0500
Message-ID: <a765104e-3574-08f4-2667-78b59c8da27c@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45808 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751974AbdH2PAf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Aug 2017 11:00:35 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v7TF0KZE045293
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2017 11:00:35 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2cna461bfa-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2017 11:00:34 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
        Tue, 29 Aug 2017 11:00:33 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@microsemi.com, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Miller <dougmill@linux.vnet.ibm.com>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>, RaghavaAditya.Renukunta@microsemi.com, stable@kernel.org

This fixes a potential race condition observed on Power systems.
Several places throughout the aacraid driver call aac_fib_send
or similar to send a command to the aacraid adapter, then check
the return code to determine if the command was actually sent
to the adapter, then update the phase field in the scsi command
scratch pad area to track that the firmware now owns this command.
However, there is nothing that ensures that by the time the aac_fib_send
function returns and we go to write to the scsi command, that the
command hasn't already completed and the scsi command has been freed.
This was causing random crashes in the TCP stack which was tracked
down to be caused by memory that had been a struct request + scsi_cmnd
being now used for an skbuff. Memory poisoning was enabled in the
kernel to debug this which showed that the last owner of the memory
that had been freed was aacraid and that it was a struct request.
The memory that was corrupted was the exact data pattern of
AAC_OWNER_FIRMWARE and it was at the same offset that aacraid
writes, which is scsicmd->SCp.phase. The patch below resolves this issue.

Cc: stable<stable@vger.kernel.org>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

Index: linux.git/drivers/scsi/aacraid/aachba.c
===================================================================
--- linux.git.orig/drivers/scsi/aacraid/aachba.c
+++ linux.git/drivers/scsi/aacraid/aachba.c
@@ -594,6 +594,7 @@ static int aac_get_container_name(struct
 
 	aac_fib_init(cmd_fibcontext);
 	dinfo = (struct aac_get_name *) fib_data(cmd_fibcontext);
+	scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 
 	dinfo->command = cpu_to_le32(VM_ContainerConfig);
 	dinfo->type = cpu_to_le32(CT_READ_NAME);
@@ -611,10 +612,8 @@ static int aac_get_container_name(struct
 	/*
 	 *	Check that the command queued to the controller
 	 */
-	if (status == -EINPROGRESS) {
-		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
+	if (status == -EINPROGRESS)
 		return 0;
-	}
 
 	printk(KERN_WARNING "aac_get_container_name: aac_fib_send failed with status: %d.\n", status);
 	aac_fib_complete(cmd_fibcontext);
@@ -725,6 +724,7 @@ static void _aac_probe_container1(void *
 
 	dinfo->count = cpu_to_le32(scmd_id(scsicmd));
 	dinfo->type = cpu_to_le32(FT_FILESYS);
+	scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 
 	status = aac_fib_send(ContainerCommand,
 			  fibptr,
@@ -736,9 +736,7 @@ static void _aac_probe_container1(void *
 	/*
 	 *	Check that the command queued to the controller
 	 */
-	if (status == -EINPROGRESS)
-		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
-	else if (status < 0) {
+	if (status < 0 && status != -EINPROGRESS) {
 		/* Inherit results from VM_NameServe, if any */
 		dresp->status = cpu_to_le32(ST_OK);
 		_aac_probe_container2(context, fibptr);
@@ -766,6 +764,7 @@ static int _aac_probe_container(struct s
 		dinfo->count = cpu_to_le32(scmd_id(scsicmd));
 		dinfo->type = cpu_to_le32(FT_FILESYS);
 		scsicmd->SCp.ptr = (char *)callback;
+		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 
 		status = aac_fib_send(ContainerCommand,
 			  fibptr,
@@ -777,10 +776,9 @@ static int _aac_probe_container(struct s
 		/*
 		 *	Check that the command queued to the controller
 		 */
-		if (status == -EINPROGRESS) {
-			scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
+		if (status == -EINPROGRESS)
 			return 0;
-		}
+
 		if (status < 0) {
 			scsicmd->SCp.ptr = NULL;
 			aac_fib_complete(fibptr);
@@ -1126,6 +1124,7 @@ static int aac_get_container_serial(stru
 	dinfo->command = cpu_to_le32(VM_ContainerConfig);
 	dinfo->type = cpu_to_le32(CT_CID_TO_32BITS_UID);
 	dinfo->cid = cpu_to_le32(scmd_id(scsicmd));
+	scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 
 	status = aac_fib_send(ContainerCommand,
 		  cmd_fibcontext,
@@ -1138,10 +1137,8 @@ static int aac_get_container_serial(stru
 	/*
 	 *	Check that the command queued to the controller
 	 */
-	if (status == -EINPROGRESS) {
-		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
+	if (status == -EINPROGRESS)
 		return 0;
-	}
 
 	printk(KERN_WARNING "aac_get_container_serial: aac_fib_send failed with status: %d.\n", status);
 	aac_fib_complete(cmd_fibcontext);
@@ -2335,16 +2332,14 @@ static int aac_read(struct scsi_cmnd * s
 	 *	Alocate and initialize a Fib
 	 */
 	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
-
+	scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 	status = aac_adapter_read(cmd_fibcontext, scsicmd, lba, count);
 
 	/*
 	 *	Check that the command queued to the controller
 	 */
-	if (status == -EINPROGRESS) {
-		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
+	if (status == -EINPROGRESS)
 		return 0;
-	}
 
 	printk(KERN_WARNING "aac_read: aac_fib_send failed with status: %d.\n", status);
 	/*
@@ -2429,16 +2424,14 @@ static int aac_write(struct scsi_cmnd *
 	 *	Allocate and initialize a Fib then setup a BlockWrite command
 	 */
 	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
-
+	scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 	status = aac_adapter_write(cmd_fibcontext, scsicmd, lba, count, fua);
 
 	/*
 	 *	Check that the command queued to the controller
 	 */
-	if (status == -EINPROGRESS) {
-		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
+	if (status == -EINPROGRESS)
 		return 0;
-	}
 
 	printk(KERN_WARNING "aac_write: aac_fib_send failed with status: %d\n", status);
 	/*
@@ -2588,6 +2581,7 @@ static int aac_synchronize(struct scsi_c
 	synchronizecmd->cid = cpu_to_le32(scmd_id(scsicmd));
 	synchronizecmd->count =
 	     cpu_to_le32(sizeof(((struct aac_synchronize_reply *)NULL)->data));
+	scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 
 	/*
 	 *	Now send the Fib to the adapter
@@ -2603,10 +2597,8 @@ static int aac_synchronize(struct scsi_c
 	/*
 	 *	Check that the command queued to the controller
 	 */
-	if (status == -EINPROGRESS) {
-		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
+	if (status == -EINPROGRESS)
 		return 0;
-	}
 
 	printk(KERN_WARNING
 		"aac_synchronize: aac_fib_send failed with status: %d.\n", status);
@@ -2666,6 +2658,7 @@ static int aac_start_stop(struct scsi_cm
 	pmcmd->cid = cpu_to_le32(sdev_id(sdev));
 	pmcmd->parm = (scsicmd->cmnd[1] & 1) ?
 		cpu_to_le32(CT_PM_UNIT_IMMEDIATE) : 0;
+	scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 
 	/*
 	 *	Now send the Fib to the adapter
@@ -2681,10 +2674,8 @@ static int aac_start_stop(struct scsi_cm
 	/*
 	 *	Check that the command queued to the controller
 	 */
-	if (status == -EINPROGRESS) {
-		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
+	if (status == -EINPROGRESS)
 		return 0;
-	}
 
 	aac_fib_complete(cmd_fibcontext);
 	aac_fib_free(cmd_fibcontext);
@@ -3692,16 +3683,14 @@ static int aac_send_srb_fib(struct scsi_
 	 *	Allocate and initialize a Fib then setup a BlockWrite command
 	 */
 	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
-
+	scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 	status = aac_adapter_scsi(cmd_fibcontext, scsicmd);
 
 	/*
 	 *	Check that the command queued to the controller
 	 */
-	if (status == -EINPROGRESS) {
-		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
+	if (status == -EINPROGRESS)
 		return 0;
-	}
 
 	printk(KERN_WARNING "aac_srb: aac_fib_send failed with status: %d\n", status);
 	aac_fib_complete(cmd_fibcontext);
@@ -3739,15 +3728,14 @@ static int aac_send_hba_fib(struct scsi_
 	if (!cmd_fibcontext)
 		return -1;
 
+	scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 	status = aac_adapter_hba(cmd_fibcontext, scsicmd);
 
 	/*
 	 *	Check that the command queued to the controller
 	 */
-	if (status == -EINPROGRESS) {
-		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
+	if (status == -EINPROGRESS)
 		return 0;
-	}
 
 	pr_warn("aac_hba_cmd_req: aac_fib_send failed with status: %d\n",
 		status);
