From: Murthy Bhat <Murthy.Bhat@pmcs.com>
Subject: RE: [PATCH 5/7] aacraid: vpd page code 0x83 support
Date: Tue, 17 Mar 2015 07:06:49 +0000
Message-ID: <13272BDD18A5F44CB23C497D29A37252A648A038@BBYEXM01.pmc-sierra.internal>
References: <1425458313-1956-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1425458313-1956-6-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:35470 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751908AbbCQHeM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2015 03:34:12 -0400
In-Reply-To: <1425458313-1956-6-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>

Reviewed-by: Murthy Bhat <Murthy.Bhat@pmcs.com>

-----Original Message-----
From: Mahesh Rajashekhara 
Sent: Wednesday, March 04, 2015 2:09 PM
To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Achim Leubner; Rajinikanth Pandurangan; Rich Bono; Mahesh Rajashekhara
Subject: [PATCH 5/7] aacraid: vpd page code 0x83 support

Add vpd page code 0x83 support

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aachba.c   |  154 ++++++++++++++++++++++++++++++++++++---
 drivers/scsi/aacraid/aacraid.h  |    4 +
 drivers/scsi/aacraid/comminit.c |    8 ++-
 drivers/scsi/aacraid/commsup.c  |   12 +---
 drivers/scsi/aacraid/linit.c    |   20 +----
 drivers/scsi/aacraid/src.c      |   34 +++++++--
 6 files changed, 185 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index eb524e6..3e4e0c8 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -163,6 +163,45 @@ struct inquiry_data {
 	u8 inqd_prl[4];	/* Product Revision Level */
 };
 
+/* Added for VPD 0x83 */
+typedef struct {
+	u8 CodeSet:4;	/* VPD_CODE_SET */
+	u8 Reserved:4;
+	u8 IdentifierType:4;	/* VPD_IDENTIFIER_TYPE */
+	u8 Reserved2:4;
+	u8 Reserved3;
+	u8 IdentifierLength;
+	u8 VendId[8];
+	u8 ProductId[16];
+	u8 SerialNumber[8];	/* SN in ASCII */
+} TVPD_ID_Descriptor_Type_1;
+
+typedef struct {
+	u8 CodeSet:4;	/* VPD_CODE_SET */
+	u8 Reserved:4;
+	u8 IdentifierType:4;	/* VPD_IDENTIFIER_TYPE */
+	u8 Reserved2:4;
+	u8 Reserved3;
+	u8 IdentifierLength;
+	struct TEU64Id {
+		u32 Serial;
+		 /* The serial number supposed to be 40 bits,
+		  * bit we only support 32, so make the last byte zero. */
+		u8 Reserved;
+		u8 VendId[3];
+	} EU64Id;
+} TVPD_ID_Descriptor_Type_2;
+
+typedef struct {
+	u8 DeviceType:5;
+	u8 DeviceTypeQualifier:3;
+	u8 PageCode;
+	u8 Reserved;
+	u8 PageLength;
+	TVPD_ID_Descriptor_Type_1 IdDescriptorType1;
+	TVPD_ID_Descriptor_Type_2 IdDescriptorType2;
+} TVPD_Page83;
+
 /*
  *              M O D U L E   G L O B A L S
  */
@@ -420,6 +459,9 @@ int aac_get_containers(struct aac_dev *dev)
 	if (status >= 0) {
 		dresp = (struct aac_get_container_count_resp *)fib_data(fibptr);
 		maximum_num_containers = le32_to_cpu(dresp->ContainerSwitchEntries);
+		if (fibptr->dev->supplement_adapter_info.SupportedOptions2 &
+		    AAC_OPTION_SUPPORTED_240_VOLUMES)
+			maximum_num_containers = le32_to_cpu(dresp->MaxSimpleVolumes);
 		aac_fib_complete(fibptr);
 	}
 	/* FIB should be freed only after getting the response from the F/W */
@@ -889,14 +931,81 @@ static void get_container_serial_callback(void *context, struct fib * fibptr)
 	get_serial_reply = (struct aac_get_serial_resp *) fib_data(fibptr);
 	/* Failure is irrelevant, using default value instead */
 	if (le32_to_cpu(get_serial_reply->status) == CT_OK) {
-		char sp[13];
-		/* EVPD bit set */
-		sp[0] = INQD_PDT_DA;
-		sp[1] = scsicmd->cmnd[2];
-		sp[2] = 0;
-		sp[3] = snprintf(sp+4, sizeof(sp)-4, "%08X",
-		  le32_to_cpu(get_serial_reply->uid));
-		scsi_sg_copy_from_buffer(scsicmd, sp, sizeof(sp));
+		/*Check to see if it's for VPD 0x83 or 0x80 */
+		if (scsicmd->cmnd[2] == 0x83) {
+			/* vpd page 0x83 - Device Identification Page */
+			int i;
+			TVPD_Page83 VPDPage83Data;
+
+			memset(((u8 *)&VPDPage83Data), 0,
+			       sizeof(VPDPage83Data));
+
+			/* DIRECT_ACCESS_DEVIC */
+			VPDPage83Data.DeviceType = 0;
+			/* DEVICE_CONNECTED */
+			VPDPage83Data.DeviceTypeQualifier = 0;
+			/* VPD_DEVICE_IDENTIFIERS */
+			VPDPage83Data.PageCode = 0x83;
+			VPDPage83Data.Reserved = 0;
+			VPDPage83Data.PageLength = sizeof(VPDPage83Data.IdDescriptorType1) +
+				sizeof(VPDPage83Data.IdDescriptorType2);
+
+			/* T10 Vendor Identifier Field Format */
+			/* VpdCodeSetAscii */
+			VPDPage83Data.IdDescriptorType1.CodeSet = 2;
+			/* VpdIdentifierTypeVendorId */
+			VPDPage83Data.IdDescriptorType1.IdentifierType = 1;
+			VPDPage83Data.IdDescriptorType1.IdentifierLength = sizeof(VPDPage83Data.IdDescriptorType1) - 4;
+
+			/* "ADAPTEC " for adaptec */
+			memcpy(VPDPage83Data.IdDescriptorType1.VendId, "ADAPTEC ",
+				sizeof(VPDPage83Data.IdDescriptorType1.VendId));
+			memcpy(VPDPage83Data.IdDescriptorType1.ProductId, "ARRAY           ",
+				sizeof(VPDPage83Data.IdDescriptorType1.ProductId));
+
+			/* Convert to ascii based serial number.
+			 * The LSB is the the end.
+			 */
+			for (i = 0; i < 8; i++) {
+				u8 temp = (u8)((get_serial_reply->uid >> ((7 - i) * 4)) & 0xF);
+				if (temp  > 0x9) {
+					VPDPage83Data.IdDescriptorType1.SerialNumber[i] = 'A' + (temp - 0xA);
+				} else {
+					VPDPage83Data.IdDescriptorType1.SerialNumber[i] = '0' + temp;
+				}
+			}
+
+			/* EUI-64 Vendor Identifier Field Format,
+			 * 24 bits for VendId and 40 bits for SN.
+			 */
+			/* VpdCodeSetBinary */
+			VPDPage83Data.IdDescriptorType2.CodeSet = 1;
+			/* VpdIdentifierTypeEUI64 */
+			VPDPage83Data.IdDescriptorType2.IdentifierType = 2;
+			VPDPage83Data.IdDescriptorType2.IdentifierLength = sizeof(VPDPage83Data.IdDescriptorType2) - 4;
+
+			/* 0x0000055 for IBM, 0x0000D0 for Adaptec */
+			VPDPage83Data.IdDescriptorType2.EU64Id.VendId[0] = 0xD0;
+			VPDPage83Data.IdDescriptorType2.EU64Id.VendId[1] = 0;
+			VPDPage83Data.IdDescriptorType2.EU64Id.VendId[2] = 0;
+
+			VPDPage83Data.IdDescriptorType2.EU64Id.Serial = get_serial_reply->uid;
+			VPDPage83Data.IdDescriptorType2.EU64Id.Reserved = 0;
+
+			/* Move the inquiry data to the response buffer. */
+			scsi_sg_copy_from_buffer(scsicmd, &VPDPage83Data,
+						 sizeof(VPDPage83Data));
+		} else {
+			/* It must be for VPD 0x80 */
+			char sp[13];
+			/* EVPD bit set */
+			sp[0] = INQD_PDT_DA;
+			sp[1] = scsicmd->cmnd[2];
+			sp[2] = 0;
+			sp[3] = snprintf(sp+4, sizeof(sp)-4, "%08X",
+				le32_to_cpu(get_serial_reply->uid));
+			scsi_sg_copy_from_buffer(scsicmd, sp, sizeof(sp));
+		}
 	}
 
 	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
@@ -2302,9 +2411,10 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			  INQD_PDT_PROC : INQD_PDT_DA;
 			if (scsicmd->cmnd[2] == 0) {
 				/* supported vital product data pages */
-				arr[3] = 2;
+				arr[3] = 3;
 				arr[4] = 0x0;
 				arr[5] = 0x80;
+				arr[6] = 0x83;
 				arr[1] = scsicmd->cmnd[2];
 				scsi_sg_copy_from_buffer(scsicmd, &inq_data,
 							 sizeof(inq_data));
@@ -2323,6 +2433,16 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				/* SLES 10 SP1 special */
 				scsicmd->result = DID_OK << 16 |
 				  COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+			} else if (scsicmd->cmnd[2] == 0x83) {
+				/* vpd page 0x83 - Device Identification Page */
+				char *sno = (char *)&inq_data;
+				sno[3] = setinqserial(dev, &sno[4],
+						      scmd_id(scsicmd));
+				if (aac_wwn != 2)
+					return aac_get_container_serial(
+						scsicmd);
+				scsicmd->result = DID_OK << 16 |
+				  COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 			} else {
 				/* vpd page not implemented */
 				scsicmd->result = DID_OK << 16 |
@@ -2468,6 +2588,15 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			mpd.bd.block_length[0] = (fsa_dev_ptr[cid].block_size >> 16) & 0xff;
 			mpd.bd.block_length[1] = (fsa_dev_ptr[cid].block_size >> 8) &  0xff;
 			mpd.bd.block_length[2] = fsa_dev_ptr[cid].block_size  & 0xff;
+
+			mpd.mpc_buf[0] = scsicmd->cmnd[2];
+			if (scsicmd->cmnd[2] == 0x1C) {
+				mpd.mpc_buf[1] = 0xa;	/* page length */
+				mpd.hd.data_length = 23;	/* Mode data length */
+			} else {
+				mpd.hd.data_length = 15;	/* Mode data length */
+			}
+
 			if (capacity > 0xffffff) {
 				mpd.bd.block_count[0] = 0xff;
 				mpd.bd.block_count[1] = 0xff;
@@ -2486,9 +2615,12 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			mpd.mpc_buf[2] = ((aac_cache & 6) == 2)
 				? 0 : 0x04; /* WCE */
 			mode_buf_length = sizeof(mpd);
-			if (mode_buf_length > scsicmd->cmnd[4])
-				mode_buf_length = scsicmd->cmnd[4];
 		}
+
+		if (mode_buf_length > scsicmd->cmnd[4])
+			mode_buf_length = scsicmd->cmnd[4];
+		else
+			mode_buf_length = sizeof(mpd);
 		scsi_sg_copy_from_buffer(scsicmd, (char *)&mpd, mode_buf_length);
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		scsicmd->scsi_done(scsicmd);
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index c162a65..a37762e 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1015,6 +1015,7 @@ struct aac_supplement_adapter_info
 #define AAC_OPTION_POWER_MANAGEMENT	cpu_to_le32(0x00000004)
 #define AAC_OPTION_DOORBELL_RESET	cpu_to_le32(0x00004000)
 #define AAC_OPTION_VARIABLE_BLOCK_SIZE	cpu_to_le32(0x00040000) /* 4KB sector size */
+#define AAC_OPTION_SUPPORTED_240_VOLUMES	cpu_to_le32(0x10000000)
 #define AAC_SIS_VERSION_V3	3
 #define AAC_SIS_SLOT_UNKNOWN	0xFF
 
@@ -1212,11 +1213,13 @@ struct aac_dev
 	int			sync_mode;
 	struct fib		*sync_fib;
 	struct list_head	sync_fib_list;
+	u32			doorbell_mask;	/* from GET_ADAPTER_PROP */
 	u32			max_msix;	/* max. MSI-X vectors */
 	u32			vector_cap;	/* MSI-X vector capab.*/
 	int			msi_enabled;	/* MSI/MSI-X enabled */
 	struct msix_entry	msixentry[AAC_MAX_MSIX];
 	struct aac_msix_ctx	aac_msix[AAC_MAX_MSIX]; /* context */
+	u8			adapter_shutdown;
 };
 
 #define aac_adapter_interrupt(dev) \
@@ -1749,6 +1752,7 @@ struct aac_get_container_count_resp {
 	__le32		MaxContainers;
 	__le32		ContainerSwitchEntries;
 	__le32		MaxPartitions;
+	__le32		MaxSimpleVolumes;
 };
 
 
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 29c35c8..c3e13ae 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -53,7 +53,7 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 {
 	unsigned char *base;
 	unsigned long size, align;
-	const unsigned long fibsize = 4096;
+	const unsigned long fibsize = dev->max_fib_size;
 	const unsigned long printfbufsiz = 256;
 	unsigned long host_rrq_size = 0;
 	struct aac_init *init;
@@ -230,6 +230,7 @@ int aac_send_shutdown(struct aac_dev * dev)
 	/* FIB should be freed only after getting the response from the F/W */
 	if (status != -ERESTARTSYS)
 		aac_fib_free(fibctx);
+	dev->adapter_shutdown = 1;
 	if ((dev->pdev->device == PMC_DEVICE_S7 ||
 	     dev->pdev->device == PMC_DEVICE_S8 ||
 	     dev->pdev->device == PMC_DEVICE_S9) &&
@@ -357,8 +358,9 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	dev->raw_io_interface = dev->raw_io_64 = 0;
 
 	if ((!aac_adapter_sync_cmd(dev, GET_ADAPTER_PROPERTIES,
-		0, 0, 0, 0, 0, 0, status+0, status+1, status+2, NULL, NULL)) &&
+		0, 0, 0, 0, 0, 0, status+0, status+1, status+2, status+3, NULL)) &&
 	 		(status[0] == 0x00000001)) {
+		dev->doorbell_mask = status[3];
 		if (status[1] & le32_to_cpu(AAC_OPT_NEW_COMM_64))
 			dev->raw_io_64 = 1;
 		dev->sync_mode = aac_sync_mode;
@@ -397,6 +399,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	}
 	dev->max_msix = 0;
 	dev->msi_enabled = 0;
+	dev->adapter_shutdown = 0;
 	if ((!aac_adapter_sync_cmd(dev, GET_COMM_PREFERRED_SETTINGS,
 	  0, 0, 0, 0, 0, 0,
 	  status+0, status+1, status+2, status+3, status+4))
@@ -508,6 +511,7 @@ static void aac_define_int_mode(struct aac_dev *dev)
 
 	int i, msi_count;
 
+	msi_count = i = 0;
 	/* max. vectors from GET_COMM_PREFERRED_SETTINGS */
 	if (dev->max_msix == 0 ||
 	    dev->pdev->device == PMC_DEVICE_S6 ||
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 83c5d3f..2bed445 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -208,14 +208,11 @@ struct fib *aac_fib_alloc(struct aac_dev *dev)
 
 void aac_fib_free(struct fib *fibptr)
 {
-	unsigned long flags, flagsv;
+	unsigned long flags;
 
-	spin_lock_irqsave(&fibptr->event_lock, flagsv);
 	if (fibptr->done == 2) {
-		spin_unlock_irqrestore(&fibptr->event_lock, flagsv);
 		return;
 	}
-	spin_unlock_irqrestore(&fibptr->event_lock, flagsv);
 
 	spin_lock_irqsave(&fibptr->dev->fib_lock, flags);
 	if (unlikely(fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT))
@@ -775,7 +772,6 @@ int aac_fib_adapter_complete(struct fib *fibptr, unsigned short size)
 
 int aac_fib_complete(struct fib *fibptr)
 {
-	unsigned long flags;
 	struct hw_fib * hw_fib = fibptr->hw_fib_va;
 
 	/*
@@ -798,12 +794,6 @@ int aac_fib_complete(struct fib *fibptr)
 	 *	command is complete that we had sent to the adapter and this
 	 *	cdb could be reused.
 	 */
-	spin_lock_irqsave(&fibptr->event_lock, flags);
-	if (fibptr->done == 2) {
-		spin_unlock_irqrestore(&fibptr->event_lock, flags);
-		return 0;
-	}
-	spin_unlock_irqrestore(&fibptr->event_lock, flags);
 
 	if((hw_fib->header.XferState & cpu_to_le32(SentFromHost)) &&
 		(hw_fib->header.XferState & cpu_to_le32(AdapterProcessed)))
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 7813a9b..4c5ba9e 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -56,7 +56,7 @@
 
 #include "aacraid.h"
 
-#define AAC_DRIVER_VERSION		"1.2-0"
+#define AAC_DRIVER_VERSION		"1.2-1"
 #ifndef AAC_DRIVER_BRANCH
 #define AAC_DRIVER_BRANCH		""
 #endif
@@ -65,7 +65,7 @@
 #ifdef AAC_DRIVER_BUILD
 #define _str(x) #x
 #define str(x) _str(x)
-#define AAC_DRIVER_FULL_VERSION	AAC_DRIVER_VERSION "[" str(AAC_DRIVER_BUILD) "]" AAC_DRIVER_BRANCH
+#define AAC_DRIVER_FULL_VERSION	AAC_DRIVER_VERSION "." str(AAC_DRIVER_BUILD) "" AAC_DRIVER_BRANCH
 #else
 #define AAC_DRIVER_FULL_VERSION	AAC_DRIVER_VERSION AAC_DRIVER_BRANCH
 #endif
@@ -253,19 +253,7 @@ static struct aac_driver_ident aac_drivers[] = {
 
 static int aac_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
-	struct Scsi_Host *host = cmd->device->host;
-	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
-	u32 count = 0;
 	cmd->scsi_done = done;
-	for (; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
-		struct fib * fib = &dev->fibs[count];
-		struct scsi_cmnd * command;
-		if (fib->hw_fib_va->header.XferState &&
-		    ((command = fib->callback_data)) &&
-		    (command == cmd) &&
-		    (cmd->SCp.phase == AAC_OWNER_FIRMWARE))
-			return 0; /* Already owned by Adapter */
-	}
 	cmd->SCp.phase = AAC_OWNER_LOWLEVEL;
 	return (aac_scsi_cmd(cmd) ? FAILED : 0);
 }
@@ -713,7 +701,9 @@ static long aac_cfg_ioctl(struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
 	int ret;
-	if (!capable(CAP_SYS_RAWIO))
+	struct aac_dev *aac;
+	aac = (struct aac_dev *)file->private_data;
+	if (!capable(CAP_SYS_RAWIO) || aac->adapter_shutdown)
 		return -EPERM;
 	mutex_lock(&aac_mutex);
 	ret = aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index c010248..82ff025 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -200,6 +200,7 @@ static int src_sync_cmd(struct aac_dev *dev, u32 command,
 	u32 *status, u32 * r1, u32 * r2, u32 * r3, u32 * r4)
 {
 	unsigned long start;
+	unsigned long delay;
 	int ok;
 
 	/*
@@ -240,10 +241,15 @@ static int src_sync_cmd(struct aac_dev *dev, u32 command,
 		ok = 0;
 		start = jiffies;
 
-		/*
-		 *	Wait up to 5 minutes
-		 */
-		while (time_before(jiffies, start+300*HZ)) {
+		if (command == IOP_RESET_ALWAYS) {
+			/* Wait up to 10 sec */
+			delay = 10*HZ;
+		} else {
+			/* Wait up to 5 minutes */
+			delay = 300*HZ;
+		}
+		while (time_before(jiffies, start+delay)) {
+
 			udelay(5);	/* Delay 5 microseconds to let Mon960 get info. */
 			/*
 			 *	Mon960 will set doorbell0 bit when it has completed the command.
@@ -562,10 +568,16 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled)
 		if (bled)
 			printk(KERN_ERR "%s%d: adapter kernel panic'd %x.\n",
 				dev->name, dev->id, bled);
+		dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
 		bled = aac_adapter_sync_cmd(dev, IOP_RESET_ALWAYS,
 			0, 0, 0, 0, 0, 0, &var, &reset_mask, NULL, NULL, NULL);
-			if (bled || (var != 0x00000001))
+			if ((bled || (var != 0x00000001)) && !dev->doorbell_mask)
 				return -EINVAL;
+			else if (dev->doorbell_mask) {
+				reset_mask = dev->doorbell_mask;
+				bled = 0;
+				var = 0x00000001;
+			}
 
 		if ((dev->pdev->device == PMC_DEVICE_S7 ||
 		    dev->pdev->device == PMC_DEVICE_S8 ||
@@ -575,10 +587,13 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled)
 			msleep(5000); /* Delay 5 seconds */
 		}
 
-		if (dev->supplement_adapter_info.SupportedOptions2 &
-			AAC_OPTION_DOORBELL_RESET) {
+		if (!bled && (dev->supplement_adapter_info.SupportedOptions2 &
+			AAC_OPTION_DOORBELL_RESET)) {
 			src_writel(dev, MUnit.IDR, reset_mask);
 			ssleep(45);
+		} else {
+			src_writel(dev, MUnit.IDR, 0x100);
+			ssleep(45);
 		}
 	}
 
@@ -600,7 +615,6 @@ int aac_src_select_comm(struct aac_dev *dev, int comm)
 {
 	switch (comm) {
 	case AAC_COMM_MESSAGE:
-		dev->a_ops.adapter_enable_int = aac_src_enable_interrupt_message;
 		dev->a_ops.adapter_intr = aac_src_intr_message;
 		dev->a_ops.adapter_deliver = aac_src_deliver_message;
 		break;
@@ -698,6 +712,7 @@ int aac_src_init(struct aac_dev *dev)
 	 */
 	dev->a_ops.adapter_interrupt = aac_src_interrupt_adapter;
 	dev->a_ops.adapter_disable_int = aac_src_disable_interrupt;
+	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
 	dev->a_ops.adapter_notify = aac_src_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_src_check_health;
@@ -735,6 +750,7 @@ int aac_src_init(struct aac_dev *dev)
 	dev->dbg_base = pci_resource_start(dev->pdev, 2);
 	dev->dbg_base_mapped = dev->regs.src.bar1;
 	dev->dbg_size = AAC_MIN_SRC_BAR1_SIZE;
+	dev->a_ops.adapter_enable_int = aac_src_enable_interrupt_message;
 
 	aac_adapter_enable_int(dev);
 
@@ -861,6 +877,7 @@ int aac_srcv_init(struct aac_dev *dev)
 	 */
 	dev->a_ops.adapter_interrupt = aac_src_interrupt_adapter;
 	dev->a_ops.adapter_disable_int = aac_src_disable_interrupt;
+	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
 	dev->a_ops.adapter_notify = aac_src_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_src_check_health;
@@ -913,6 +930,7 @@ int aac_srcv_init(struct aac_dev *dev)
 	dev->dbg_base = dev->base_start;
 	dev->dbg_base_mapped = dev->base;
 	dev->dbg_size = dev->base_size;
+	dev->a_ops.adapter_enable_int = aac_src_enable_interrupt_message;
 
 	aac_adapter_enable_int(dev);
 
-- 
1.7.7.3

