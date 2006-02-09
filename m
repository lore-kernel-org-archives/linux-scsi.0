From: Sumant Patro <sumantp@lsil.com>
Subject: [PATCH] megaraid_sas : block physical disk access
Date: Thu, 09 Feb 2006 15:47:27 -0800
Message-ID: <1139528847.4628.26.camel@dhcp80-31.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-YTAR6V1bDhuKh2TEWPQe"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:22690 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750835AbWBIXov (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2006 18:44:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de, mark_salyzyn@adaptec.com
Cc: sreenib@lsil.com, Neela.kolli@lsil.com, Bo.Yang@lsil.com, linux-scsi@vger.kernel.org, Chandra_Nelogal@Dell.com


--=-YTAR6V1bDhuKh2TEWPQe
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Here is the patch for review that implements slave_alloc to block direct 
access to the Physical Disks.
By using no_uld_attach and clearing the scsi device writeable flag the disks will be 
still accessible even if it belongs to a RAID volume.
I would prefer to hide the Physical Disks to block any kind of access.

I will send a separate patch to monitor drive insertion/removal to update internally 
the physical disk list.

Thanks,

Sumant Patro

Signed-off-by: Sumant Patro <Sumant.Patro@lsil.com>

diff -uprN linux2.6.orig/drivers/scsi/megaraid/megaraid_sas.c linux2.6/drivers/scsi/megaraid/megaraid_sas.c
--- linux2.6.orig/drivers/scsi/megaraid/megaraid_sas.c	2006-02-09 13:37:50.000000000 -0800
+++ linux2.6/drivers/scsi/megaraid/megaraid_sas.c	2006-02-09 15:24:44.000000000 -0800
@@ -707,6 +707,50 @@ megasas_queue_command(struct scsi_cmnd *
 	return 0;
 }
 
+static struct megasas_instance *megasas_lookup_instance(u16 host_no)
+{
+	int i;
+
+	for (i = 0; i < megasas_mgmt_info.max_index; i++) {
+
+		if ((megasas_mgmt_info.instance[i]) &&
+		    (megasas_mgmt_info.instance[i]->host->host_no == host_no))
+			return megasas_mgmt_info.instance[i];
+	}
+
+	return NULL;
+}
+
+static int megasas_slave_alloc(struct scsi_device *sdev){
+	struct megasas_instance *instance ; 
+	u32 id;
+	instance = megasas_lookup_instance(sdev->host->host_no);
+	/*
+        * Don't export physical disk devices
+        */
+	if(sdev->channel < MEGASAS_MAX_PD_CHANNELS)
+	{
+		id = MEGASAS_MAX_DEV_PER_CHANNEL * sdev->channel + sdev->id;
+		/*
+		* Check if the bit is set for id in our physical device bitmap
+		* If the bit is set in phys_dev then a Disk is present for the id
+		*/
+		if (instance->phys_dev[id/8] /*Finds index of phys_dev this id
+						 belongs to*/
+				& (1 << id%8) /*Finds bit number for the id */
+				)
+			return -ENXIO;
+	}	
+	return 0;
+}
+
+static int megasas_slave_configure(struct scsi_device *sdev){
+	/*
+		This will be used to set sdev timeout
+	*/
+       return 0;
+}
+
 /**
  * megasas_wait_for_outstanding -	Wait for all outstanding cmds
  * @instance:				Adapter soft state
@@ -857,6 +901,8 @@ static struct scsi_host_template megasas
 	.module = THIS_MODULE,
 	.name = "LSI Logic SAS based MegaRAID driver",
 	.proc_name = "megaraid_sas",
+	.slave_alloc = megasas_slave_alloc,
+	.slave_configure = megasas_slave_configure,
 	.queuecommand = megasas_queue_command,
 	.eh_device_reset_handler = megasas_reset_device,
 	.eh_bus_reset_handler = megasas_reset_bus_host,
@@ -985,20 +1031,6 @@ megasas_complete_cmd(struct megasas_inst
 			break;
 		}
 
-		/*
-		 * Don't export physical disk devices to mid-layer.
-		 */
-		if (!MEGASAS_IS_LOGICAL(cmd->scmd) &&
-		    (hdr->cmd_status == MFI_STAT_OK) &&
-		    (cmd->scmd->cmnd[0] == INQUIRY)) {
-
-			if (((*(u8 *) cmd->scmd->request_buffer) & 0x1F) ==
-			    TYPE_DISK) {
-				cmd->scmd->result = DID_BAD_TARGET << 16;
-				exception = 1;
-			}
-		}
-
 	case MFI_CMD_LD_READ:
 	case MFI_CMD_LD_WRITE:
 
@@ -1502,6 +1534,70 @@ static int megasas_alloc_cmds(struct meg
 	return 0;
 }
 
+
+/**
+ * megasas_get_pd_list -		Returns FW's controller structure
+ * @instance:				Adapter soft state
+ * @pd_list:				Physical drive list structure
+ *
+ * Issues an internal command (DCMD) to get the list of Physical Dirive's structure.
+ * This information is used to block export of Disks to the Upper layer drivers.
+ */
+static int
+megasas_get_pd_list(struct megasas_instance *instance,
+		      struct megasas_pd_list *pd_list)
+{
+	int ret = 0;
+	struct megasas_cmd *cmd;
+	struct megasas_dcmd_frame *dcmd;
+	struct megasas_pd_list *pdlist;
+	dma_addr_t pdlist_h = 0;
+
+	cmd = megasas_get_cmd(instance);
+
+	if (!cmd) {
+		printk(KERN_DEBUG "megasas: Failed to get a free cmd\n");
+		return -ENOMEM;
+	}
+
+	dcmd = &cmd->frame->dcmd;
+
+	pdlist = pci_alloc_consistent(instance->pdev,
+				  sizeof(struct megasas_pd_list), &pdlist_h);
+
+	if (!pdlist) {
+		printk(KERN_DEBUG "Failed to alloc mem for pd list\n");
+		megasas_return_cmd(instance, cmd);
+		return -ENOMEM;
+	}
+
+	memset(pdlist, 0, sizeof(*pdlist));
+	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+	dcmd->cmd = MFI_CMD_DCMD;
+	dcmd->cmd_status = 0xFF;
+	dcmd->sge_count = 1;
+	dcmd->flags = MFI_FRAME_DIR_READ;
+	dcmd->timeout = 0;
+	dcmd->data_xfer_len = sizeof(struct megasas_pd_list);
+	dcmd->opcode = MR_DCMD_PD_GET_LIST;
+	dcmd->sgl.sge32[0].phys_addr = pdlist_h;
+	dcmd->sgl.sge32[0].length = sizeof(struct megasas_pd_list);
+
+	if (!megasas_issue_polled(instance, cmd)) {
+		ret = 0;
+		memcpy(pd_list, pdlist, sizeof(struct megasas_pd_list));
+	} else {
+		ret = -1;
+	}
+
+	pci_free_consistent(instance->pdev, sizeof(struct megasas_pd_list),
+			    pdlist, pdlist_h);
+
+	megasas_return_cmd(instance, cmd);
+	return ret;
+}
+
 /**
  * megasas_get_controller_info -	Returns FW's controller structure
  * @instance:				Adapter soft state
@@ -1588,6 +1684,8 @@ static int megasas_init_mfi(struct megas
 	dma_addr_t init_frame_h;
 	dma_addr_t initq_info_h;
 
+	struct megasas_pd_list *pd_list;
+	int i;
 	/*
 	 * Map the message registers
 	 */
@@ -1714,12 +1812,35 @@ static int megasas_init_mfi(struct megas
 		    PAGE_SIZE / 512;
 
 	kfree(ctrl_info);
+	
+	pd_list = kmalloc(sizeof(struct megasas_pd_list), GFP_KERNEL);
+
+	for(i=0;i<32;i++)
+		instance->phys_dev[i]=0;
 
+	if(megasas_get_pd_list(instance,pd_list)){
+		kfree(pd_list);
+		goto fail_pd_list;
+	}
+
+	for(i=0; i<pd_list->count; i++){
+		/*
+		* Set the bit if disk is present for the deviceid 
+		* in the phys_dev bitmap
+		*/
+		if(pd_list->addr[i].scsi_dev_type==TYPE_DISK)
+			instance->phys_dev[pd_list->addr[i].deviceid/8] 
+				|= (1 << (pd_list->addr[i].deviceid % 8));
+	}
+
+	kfree(pd_list);
+		
 	return 0;
 
       fail_fw_init:
 	megasas_return_cmd(instance, cmd);
 
+      fail_pd_list:
 	pci_free_consistent(instance->pdev, reply_q_sz,
 			    instance->reply_queue, instance->reply_queue_h);
       fail_reply_queue:
@@ -2532,20 +2653,6 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	return error;
 }
 
-static struct megasas_instance *megasas_lookup_instance(u16 host_no)
-{
-	int i;
-
-	for (i = 0; i < megasas_mgmt_info.max_index; i++) {
-
-		if ((megasas_mgmt_info.instance[i]) &&
-		    (megasas_mgmt_info.instance[i]->host->host_no == host_no))
-			return megasas_mgmt_info.instance[i];
-	}
-
-	return NULL;
-}
-
 static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 {
 	struct megasas_iocpacket __user *user_ioc =
diff -uprN linux2.6.orig/drivers/scsi/megaraid/megaraid_sas.h linux2.6/drivers/scsi/megaraid/megaraid_sas.h
--- linux2.6.orig/drivers/scsi/megaraid/megaraid_sas.h	2006-02-09 13:37:50.000000000 -0800
+++ linux2.6/drivers/scsi/megaraid/megaraid_sas.h	2006-02-09 13:45:15.000000000 -0800
@@ -110,6 +110,8 @@
 #define MR_DCMD_CTRL_EVENT_WAIT			0x01040500
 #define MR_DCMD_LD_GET_PROPERTIES		0x03030000
 
+#define MR_DCMD_PD_GET_LIST			0x02010000
+
 #define MR_DCMD_CLUSTER				0x08000000
 #define MR_DCMD_CLUSTER_RESET_ALL		0x08010100
 #define MR_DCMD_CLUSTER_RESET_LD		0x08010200
@@ -509,6 +511,22 @@ struct megasas_ctrl_info {
 
 } __attribute__ ((packed));
 
+struct megasas_pd_address {
+	u16 deviceid;
+	u16 encl_deviceid;
+	u8 encl_index;
+	u8 slot_number;
+	u8 scsi_dev_type;
+	u8 reserved;	
+	u64 sas_addr[2];
+} __attribute__ ((packed));
+
+struct megasas_pd_list {
+	u32 size;
+	u32 count;
+	struct megasas_pd_address addr[256];
+} __attribute__ ((packed));
+
 /*
  * ===============================
  * MegaRAID SAS driver definitions
@@ -1067,6 +1085,8 @@ struct megasas_instance {
 	spinlock_t instance_lock;
 
 	struct megasas_instance_template *instancet;
+
+	u8 phys_dev[32]; /*bitmap to represent presence of disks. Max 256*/
 };
 
 #define MEGASAS_IS_LOGICAL(scp)						\


--=-YTAR6V1bDhuKh2TEWPQe
Content-Disposition: attachment; filename=slavealloc.patch
Content-Type: text/x-patch; name=slavealloc.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -uprN linux2.6.orig/drivers/scsi/megaraid/megaraid_sas.c linux2.6/drivers/scsi/megaraid/megaraid_sas.c
--- linux2.6.orig/drivers/scsi/megaraid/megaraid_sas.c	2006-02-09 13:37:50.000000000 -0800
+++ linux2.6/drivers/scsi/megaraid/megaraid_sas.c	2006-02-09 15:24:44.000000000 -0800
@@ -707,6 +707,50 @@ megasas_queue_command(struct scsi_cmnd *
 	return 0;
 }
 
+static struct megasas_instance *megasas_lookup_instance(u16 host_no)
+{
+	int i;
+
+	for (i = 0; i < megasas_mgmt_info.max_index; i++) {
+
+		if ((megasas_mgmt_info.instance[i]) &&
+		    (megasas_mgmt_info.instance[i]->host->host_no == host_no))
+			return megasas_mgmt_info.instance[i];
+	}
+
+	return NULL;
+}
+
+static int megasas_slave_alloc(struct scsi_device *sdev){
+	struct megasas_instance *instance ; 
+	u32 id;
+	instance = megasas_lookup_instance(sdev->host->host_no);
+	/*
+        * Don't export physical disk devices
+        */
+	if(sdev->channel < MEGASAS_MAX_PD_CHANNELS)
+	{
+		id = MEGASAS_MAX_DEV_PER_CHANNEL * sdev->channel + sdev->id;
+		/*
+		* Check if the bit is set for id in our physical device bitmap
+		* If the bit is set in phys_dev then a Disk is present for the id
+		*/
+		if (instance->phys_dev[id/8] /*Finds index of phys_dev this id
+						 belongs to*/
+				& (1 << id%8) /*Finds bit number for the id */
+				)
+			return -ENXIO;
+	}	
+	return 0;
+}
+
+static int megasas_slave_configure(struct scsi_device *sdev){
+	/*
+		This will be used to set sdev timeout
+	*/
+       return 0;
+}
+
 /**
  * megasas_wait_for_outstanding -	Wait for all outstanding cmds
  * @instance:				Adapter soft state
@@ -857,6 +901,8 @@ static struct scsi_host_template megasas
 	.module = THIS_MODULE,
 	.name = "LSI Logic SAS based MegaRAID driver",
 	.proc_name = "megaraid_sas",
+	.slave_alloc = megasas_slave_alloc,
+	.slave_configure = megasas_slave_configure,
 	.queuecommand = megasas_queue_command,
 	.eh_device_reset_handler = megasas_reset_device,
 	.eh_bus_reset_handler = megasas_reset_bus_host,
@@ -985,20 +1031,6 @@ megasas_complete_cmd(struct megasas_inst
 			break;
 		}
 
-		/*
-		 * Don't export physical disk devices to mid-layer.
-		 */
-		if (!MEGASAS_IS_LOGICAL(cmd->scmd) &&
-		    (hdr->cmd_status == MFI_STAT_OK) &&
-		    (cmd->scmd->cmnd[0] == INQUIRY)) {
-
-			if (((*(u8 *) cmd->scmd->request_buffer) & 0x1F) ==
-			    TYPE_DISK) {
-				cmd->scmd->result = DID_BAD_TARGET << 16;
-				exception = 1;
-			}
-		}
-
 	case MFI_CMD_LD_READ:
 	case MFI_CMD_LD_WRITE:
 
@@ -1502,6 +1534,70 @@ static int megasas_alloc_cmds(struct meg
 	return 0;
 }
 
+
+/**
+ * megasas_get_pd_list -		Returns FW's controller structure
+ * @instance:				Adapter soft state
+ * @pd_list:				Physical drive list structure
+ *
+ * Issues an internal command (DCMD) to get the list of Physical Dirive's structure.
+ * This information is used to block export of Disks to the Upper layer drivers.
+ */
+static int
+megasas_get_pd_list(struct megasas_instance *instance,
+		      struct megasas_pd_list *pd_list)
+{
+	int ret = 0;
+	struct megasas_cmd *cmd;
+	struct megasas_dcmd_frame *dcmd;
+	struct megasas_pd_list *pdlist;
+	dma_addr_t pdlist_h = 0;
+
+	cmd = megasas_get_cmd(instance);
+
+	if (!cmd) {
+		printk(KERN_DEBUG "megasas: Failed to get a free cmd\n");
+		return -ENOMEM;
+	}
+
+	dcmd = &cmd->frame->dcmd;
+
+	pdlist = pci_alloc_consistent(instance->pdev,
+				  sizeof(struct megasas_pd_list), &pdlist_h);
+
+	if (!pdlist) {
+		printk(KERN_DEBUG "Failed to alloc mem for pd list\n");
+		megasas_return_cmd(instance, cmd);
+		return -ENOMEM;
+	}
+
+	memset(pdlist, 0, sizeof(*pdlist));
+	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+	dcmd->cmd = MFI_CMD_DCMD;
+	dcmd->cmd_status = 0xFF;
+	dcmd->sge_count = 1;
+	dcmd->flags = MFI_FRAME_DIR_READ;
+	dcmd->timeout = 0;
+	dcmd->data_xfer_len = sizeof(struct megasas_pd_list);
+	dcmd->opcode = MR_DCMD_PD_GET_LIST;
+	dcmd->sgl.sge32[0].phys_addr = pdlist_h;
+	dcmd->sgl.sge32[0].length = sizeof(struct megasas_pd_list);
+
+	if (!megasas_issue_polled(instance, cmd)) {
+		ret = 0;
+		memcpy(pd_list, pdlist, sizeof(struct megasas_pd_list));
+	} else {
+		ret = -1;
+	}
+
+	pci_free_consistent(instance->pdev, sizeof(struct megasas_pd_list),
+			    pdlist, pdlist_h);
+
+	megasas_return_cmd(instance, cmd);
+	return ret;
+}
+
 /**
  * megasas_get_controller_info -	Returns FW's controller structure
  * @instance:				Adapter soft state
@@ -1588,6 +1684,8 @@ static int megasas_init_mfi(struct megas
 	dma_addr_t init_frame_h;
 	dma_addr_t initq_info_h;
 
+	struct megasas_pd_list *pd_list;
+	int i;
 	/*
 	 * Map the message registers
 	 */
@@ -1714,12 +1812,35 @@ static int megasas_init_mfi(struct megas
 		    PAGE_SIZE / 512;
 
 	kfree(ctrl_info);
+	
+	pd_list = kmalloc(sizeof(struct megasas_pd_list), GFP_KERNEL);
+
+	for(i=0;i<32;i++)
+		instance->phys_dev[i]=0;
 
+	if(megasas_get_pd_list(instance,pd_list)){
+		kfree(pd_list);
+		goto fail_pd_list;
+	}
+
+	for(i=0; i<pd_list->count; i++){
+		/*
+		* Set the bit if disk is present for the deviceid 
+		* in the phys_dev bitmap
+		*/
+		if(pd_list->addr[i].scsi_dev_type==TYPE_DISK)
+			instance->phys_dev[pd_list->addr[i].deviceid/8] 
+				|= (1 << (pd_list->addr[i].deviceid % 8));
+	}
+
+	kfree(pd_list);
+		
 	return 0;
 
       fail_fw_init:
 	megasas_return_cmd(instance, cmd);
 
+      fail_pd_list:
 	pci_free_consistent(instance->pdev, reply_q_sz,
 			    instance->reply_queue, instance->reply_queue_h);
       fail_reply_queue:
@@ -2532,20 +2653,6 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	return error;
 }
 
-static struct megasas_instance *megasas_lookup_instance(u16 host_no)
-{
-	int i;
-
-	for (i = 0; i < megasas_mgmt_info.max_index; i++) {
-
-		if ((megasas_mgmt_info.instance[i]) &&
-		    (megasas_mgmt_info.instance[i]->host->host_no == host_no))
-			return megasas_mgmt_info.instance[i];
-	}
-
-	return NULL;
-}
-
 static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 {
 	struct megasas_iocpacket __user *user_ioc =
diff -uprN linux2.6.orig/drivers/scsi/megaraid/megaraid_sas.h linux2.6/drivers/scsi/megaraid/megaraid_sas.h
--- linux2.6.orig/drivers/scsi/megaraid/megaraid_sas.h	2006-02-09 13:37:50.000000000 -0800
+++ linux2.6/drivers/scsi/megaraid/megaraid_sas.h	2006-02-09 13:45:15.000000000 -0800
@@ -110,6 +110,8 @@
 #define MR_DCMD_CTRL_EVENT_WAIT			0x01040500
 #define MR_DCMD_LD_GET_PROPERTIES		0x03030000
 
+#define MR_DCMD_PD_GET_LIST			0x02010000
+
 #define MR_DCMD_CLUSTER				0x08000000
 #define MR_DCMD_CLUSTER_RESET_ALL		0x08010100
 #define MR_DCMD_CLUSTER_RESET_LD		0x08010200
@@ -509,6 +511,22 @@ struct megasas_ctrl_info {
 
 } __attribute__ ((packed));
 
+struct megasas_pd_address {
+	u16 deviceid;
+	u16 encl_deviceid;
+	u8 encl_index;
+	u8 slot_number;
+	u8 scsi_dev_type;
+	u8 reserved;	
+	u64 sas_addr[2];
+} __attribute__ ((packed));
+
+struct megasas_pd_list {
+	u32 size;
+	u32 count;
+	struct megasas_pd_address addr[256];
+} __attribute__ ((packed));
+
 /*
  * ===============================
  * MegaRAID SAS driver definitions
@@ -1067,6 +1085,8 @@ struct megasas_instance {
 	spinlock_t instance_lock;
 
 	struct megasas_instance_template *instancet;
+
+	u8 phys_dev[32]; /*bitmap to represent presence of disks. Max 256*/
 };
 
 #define MEGASAS_IS_LOGICAL(scp)						\

--=-YTAR6V1bDhuKh2TEWPQe--

