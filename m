From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: [PATCH] aacraid: Add Power Management support
Date: Wed, 30 Apr 2008 16:03:42 -0400
Message-ID: <7D06DAD1-983B-457F-8A9B-76C4FA95D57B@adaptec.com>
References: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com> <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com> <86802c440804211742g1fe25aadjeaffce49722e7c46@mail.gmail.com> <BCC76E6D-9A0F-4DC1-822A-50EE44A52890@adaptec.com> <1E278B55-6C77-42FA-8B15-16A0939203FB@adaptec.com> <1FB85EE8-0F95-4CF8-AD36-9E0E6542BB59@adaptec.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-59--649611334
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:48828 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758362AbYD3UDp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Apr 2008 16:03:45 -0400
Received: from Macintosh.adaptec.com (unknown [10.5.3.1])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 3F26F216190
	for <linux-scsi@vger.kernel.org>; Wed, 30 Apr 2008 13:03:43 -0700 (PDT)
In-Reply-To: <1FB85EE8-0F95-4CF8-AD36-9E0E6542BB59@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-Scsi <linux-scsi@vger.kernel.org>


--Apple-Mail-59--649611334
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

For firmware that supports the feature(s), add the ability to start or  
stop an array using the associated SCSI commands, to automatically  
manage the spin-up of an array on new I/O reporting back the  
appropriate check conditions and actions in cooperation with the  
normal timeout mechanisms and enable the blackout period management in  
the Firmware associated with the background spin-down of the arrays  
when the Firmware times out and deems the arrays as idle.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's  
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

  drivers/scsi/aacraid/aachba.c   |  133 ++++++++++++++++++++++++++++++ 
+++++++---
  drivers/scsi/aacraid/aacraid.h  |   24 ++++++-
  drivers/scsi/aacraid/comminit.c |    2
  drivers/scsi/aacraid/linit.c    |    6 +
  4 files changed, 154 insertions(+), 11 deletions(-)

Sincerely - Mark Salyzyn

--Apple-Mail-59--649611334
Content-Disposition: attachment;
	filename=aacraid_pm.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="aacraid_pm.patch"
Content-Transfer-Encoding: 7bit

diff -ru a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c	2008-04-30 15:47:53.564749004 -0400
+++ b/drivers/scsi/aacraid/aachba.c	2008-04-30 15:54:57.827962317 -0400
@@ -498,6 +498,11 @@
 		    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
 		    (le32_to_cpu(dresp->mnt[0].state) != FSCS_HIDDEN)) {
 			fsa_dev_ptr->valid = 1;
+			/* sense_key holds the current state of the spin-up */
+			if (dresp->mnt[0].state & cpu_to_le32(FSCS_NOT_READY))
+				fsa_dev_ptr->sense_data.sense_key = NOT_READY;
+			else if (fsa_dev_ptr->sense_data.sense_key == NOT_READY)
+				fsa_dev_ptr->sense_data.sense_key = NO_SENSE;
 			fsa_dev_ptr->type = le32_to_cpu(dresp->mnt[0].vol);
 			fsa_dev_ptr->size
 			  = ((u64)le32_to_cpu(dresp->mnt[0].capacity)) +
@@ -1509,20 +1514,35 @@
 	scsi_dma_unmap(scsicmd);
 
 	readreply = (struct aac_read_reply *)fib_data(fibptr);
-	if (le32_to_cpu(readreply->status) == ST_OK)
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-	else {
+	switch (le32_to_cpu(readreply->status)) {
+	case ST_OK:
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+			SAM_STAT_GOOD;
+		dev->fsa_dev[cid].sense_data.sense_key = NO_SENSE;
+		break;
+	case ST_NOT_READY:
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+			SAM_STAT_CHECK_CONDITION;
+		set_sense(&dev->fsa_dev[cid].sense_data, NOT_READY,
+		  SENCODE_BECOMING_READY, ASENCODE_BECOMING_READY, 0, 0);
+		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
+		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
+			     SCSI_SENSE_BUFFERSIZE));
+		break;
+	default:
 #ifdef AAC_DETAILED_STATUS_INFO
 		printk(KERN_WARNING "io_callback: io failed, status = %d\n",
 		  le32_to_cpu(readreply->status));
 #endif
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+			SAM_STAT_CHECK_CONDITION;
 		set_sense(&dev->fsa_dev[cid].sense_data,
 		  HARDWARE_ERROR, SENCODE_INTERNAL_TARGET_FAILURE,
 		  ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0);
 		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
 		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
 			     SCSI_SENSE_BUFFERSIZE));
+		break;
 	}
 	aac_fib_complete(fibptr);
 	aac_fib_free(fibptr);
@@ -1863,6 +1883,84 @@
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
+static void aac_start_stop_callback(void *context, struct fib *fibptr)
+{
+	struct scsi_cmnd *scsicmd = context;
+
+	if (!aac_valid_context(scsicmd, fibptr))
+		return;
+
+	BUG_ON(fibptr == NULL);
+
+	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+
+	aac_fib_complete(fibptr);
+	aac_fib_free(fibptr);
+	scsicmd->scsi_done(scsicmd);
+}
+
+static int aac_start_stop(struct scsi_cmnd *scsicmd)
+{
+	int status;
+	struct fib *cmd_fibcontext;
+	struct aac_power_management *pmcmd;
+	struct scsi_device *sdev = scsicmd->device;
+	struct aac_dev *aac = (struct aac_dev *)sdev->host->hostdata;
+
+	if (!(aac->supplement_adapter_info.SupportedOptions2 &
+	      AAC_OPTION_POWER_MANAGEMENT)) {
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+				  SAM_STAT_GOOD;
+		scsicmd->scsi_done(scsicmd);
+		return 0;
+	}
+
+	if (aac->in_reset)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
+	/*
+	 *	Allocate and initialize a Fib
+	 */
+	cmd_fibcontext = aac_fib_alloc(aac);
+	if (!cmd_fibcontext)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
+	aac_fib_init(cmd_fibcontext);
+
+	pmcmd = fib_data(cmd_fibcontext);
+	pmcmd->command = cpu_to_le32(VM_ContainerConfig);
+	pmcmd->type = cpu_to_le32(CT_POWER_MANAGEMENT);
+	/* Eject bit ignored, not relevant */
+	pmcmd->sub = (scsicmd->cmnd[4] & 1) ?
+		cpu_to_le32(CT_PM_START_UNIT) : cpu_to_le32(CT_PM_STOP_UNIT);
+	pmcmd->cid = cpu_to_le32(sdev_id(sdev));
+	pmcmd->parm = (scsicmd->cmnd[1] & 1) ?
+		cpu_to_le32(CT_PM_UNIT_IMMEDIATE) : 0;
+
+	/*
+	 *	Now send the Fib to the adapter
+	 */
+	status = aac_fib_send(ContainerCommand,
+		  cmd_fibcontext,
+		  sizeof(struct aac_power_management),
+		  FsaNormal,
+		  0, 1,
+		  (fib_callback)aac_start_stop_callback,
+		  (void *)scsicmd);
+
+	/*
+	 *	Check that the command queued to the controller
+	 */
+	if (status == -EINPROGRESS) {
+		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
+		return 0;
+	}
+
+	aac_fib_complete(cmd_fibcontext);
+	aac_fib_free(cmd_fibcontext);
+	return SCSI_MLQUEUE_HOST_BUSY;
+}
+
 /**
  *	aac_scsi_cmd()		-	Process SCSI command
  *	@scsicmd:		SCSI command block
@@ -1899,7 +1997,9 @@
 			 *	If the target container doesn't exist, it may have
 			 *	been newly created
 			 */
-			if ((fsa_dev_ptr[cid].valid & 1) == 0) {
+			if (((fsa_dev_ptr[cid].valid & 1) == 0) ||
+			  (fsa_dev_ptr[cid].sense_data.sense_key ==
+			   NOT_READY)) {
 				switch (scsicmd->cmnd[0]) {
 				case SERVICE_ACTION_IN:
 					if (!(dev->raw_io_interface) ||
@@ -2091,8 +2191,8 @@
 		scsi_sg_copy_from_buffer(scsicmd, cp, sizeof(cp));
 		/* Do not cache partition table for arrays */
 		scsicmd->device->removable = 1;
-
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+		  SAM_STAT_GOOD;
 		scsicmd->scsi_done(scsicmd);
 
 		return 0;
@@ -2187,15 +2287,32 @@
 	 *	These commands are all No-Ops
 	 */
 	case TEST_UNIT_READY:
+		if (fsa_dev_ptr[cid].sense_data.sense_key == NOT_READY) {
+			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+				SAM_STAT_CHECK_CONDITION;
+			set_sense(&dev->fsa_dev[cid].sense_data,
+				  NOT_READY, SENCODE_BECOMING_READY,
+				  ASENCODE_BECOMING_READY, 0, 0);
+			memcpy(scsicmd->sense_buffer,
+			       &dev->fsa_dev[cid].sense_data,
+			       min_t(size_t,
+				     sizeof(dev->fsa_dev[cid].sense_data),
+				     SCSI_SENSE_BUFFERSIZE));
+			scsicmd->scsi_done(scsicmd);
+			return 0;
+		}
+		/* FALLTHRU */
 	case RESERVE:
 	case RELEASE:
 	case REZERO_UNIT:
 	case REASSIGN_BLOCKS:
 	case SEEK_10:
-	case START_STOP:
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		scsicmd->scsi_done(scsicmd);
 		return 0;
+
+	case START_STOP:
+		return aac_start_stop(scsicmd);
 	}
 
 	switch (scsicmd->cmnd[0])
diff -ru a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h	2008-04-30 15:47:53.564749004 -0400
+++ b/drivers/scsi/aacraid/aacraid.h	2008-04-30 15:51:33.165908147 -0400
@@ -12,7 +12,7 @@
  *----------------------------------------------------------------------------*/
 
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 2455
+# define AAC_DRIVER_BUILD 2456
 # define AAC_DRIVER_BRANCH "-ms"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
@@ -424,6 +424,8 @@
 	 */
 	__le32	InitFlags;	/* flags for supported features */
 #define INITFLAGS_NEW_COMM_SUPPORTED	0x00000001
+#define INITFLAGS_DRIVER_USES_UTC_TIME	0x00000010
+#define INITFLAGS_DRIVER_SUPPORTS_PM	0x00000020
 	__le32	MaxIoCommands;	/* max outstanding commands */
 	__le32	MaxIoSize;	/* largest I/O command */
 	__le32	MaxFibSize;	/* largest FIB to adapter */
@@ -867,8 +869,10 @@
 };
 #define AAC_FEATURE_FALCON	cpu_to_le32(0x00000010)
 #define AAC_FEATURE_JBOD	cpu_to_le32(0x08000000)
-#define AAC_OPTION_MU_RESET	cpu_to_le32(0x00000001)
-#define AAC_OPTION_IGNORE_RESET	cpu_to_le32(0x00000002)
+/* SupportedOptions2 */
+#define AAC_OPTION_MU_RESET		cpu_to_le32(0x00000001)
+#define AAC_OPTION_IGNORE_RESET		cpu_to_le32(0x00000002)
+#define AAC_OPTION_POWER_MANAGEMENT	cpu_to_le32(0x00000004)
 #define AAC_SIS_VERSION_V3	3
 #define AAC_SIS_SLOT_UNKNOWN	0xFF
 
@@ -1148,6 +1152,7 @@
 #define		ST_DQUOT	69
 #define		ST_STALE	70
 #define		ST_REMOTE	71
+#define		ST_NOT_READY	72
 #define		ST_BADHANDLE	10001
 #define		ST_NOT_SYNC	10002
 #define		ST_BAD_COOKIE	10003
@@ -1269,6 +1274,18 @@
 	u8		data[16];
 };
 
+#define CT_POWER_MANAGEMENT	245
+#define CT_PM_START_UNIT	2
+#define CT_PM_STOP_UNIT		3
+#define CT_PM_UNIT_IMMEDIATE	1
+struct aac_power_management {
+	__le32		command;	/* VM_ContainerConfig */
+	__le32		type;		/* CT_POWER_MANAGEMENT */
+	__le32		sub;		/* CT_PM_* */
+	__le32		cid;
+	__le32		parm;		/* CT_PM_sub_* */
+};
+
 #define CT_PAUSE_IO    65
 #define CT_RELEASE_IO  66
 struct aac_pause {
@@ -1536,6 +1553,7 @@
 #define FSCS_NOTCLEAN	0x0001  /* fsck is necessary before mounting */
 #define FSCS_READONLY	0x0002	/* possible result of broken mirror */
 #define FSCS_HIDDEN	0x0004	/* should be ignored - set during a clear */
+#define FSCS_NOT_READY	0x0008	/* Array spinning up to fulfil request */
 
 struct aac_query_mount {
 	__le32		command;
diff -ru a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
--- a/drivers/scsi/aacraid/comminit.c	2008-04-30 15:47:53.565748877 -0400
+++ b/drivers/scsi/aacraid/comminit.c	2008-04-30 15:51:33.166908020 -0400
@@ -97,6 +97,8 @@
 		init->InitFlags = cpu_to_le32(INITFLAGS_NEW_COMM_SUPPORTED);
 		dprintk((KERN_WARNING"aacraid: New Comm Interface enabled\n"));
 	}
+	init->InitFlags |= cpu_to_le32(INITFLAGS_DRIVER_USES_UTC_TIME |
+				       INITFLAGS_DRIVER_SUPPORTS_PM);
 	init->MaxIoCommands = cpu_to_le32(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB);
 	init->MaxIoSize = cpu_to_le32(dev->scsi_host_ptr->max_sectors << 9);
 	init->MaxFibSize = cpu_to_le32(dev->max_fib_size);
diff -ru a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c	2008-04-30 15:47:53.566748750 -0400
+++ b/drivers/scsi/aacraid/linit.c	2008-04-30 15:54:14.672433234 -0400
@@ -811,6 +811,12 @@
 				"SAI_READ_CAPACITY_16\n");
 	if (dev->jbod)
 		len += snprintf(buf + len, PAGE_SIZE - len, "SUPPORTED_JBOD\n");
+	if (dev->supplement_adapter_info.SupportedOptions2 &
+		AAC_OPTION_POWER_MANAGEMENT)
+		len += snprintf(buf + len, PAGE_SIZE - len,
+				"SUPPORTED_POWER_MANAGEMENT\n");
+	if (dev->msi)
+		len += snprintf(buf + len, PAGE_SIZE - len, "PCI_HAS_MSI\n");
 	return len;
 }
 

--Apple-Mail-59--649611334
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit



--Apple-Mail-59--649611334--
