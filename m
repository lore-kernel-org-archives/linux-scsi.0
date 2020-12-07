Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A95BC1B0D8
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E040123405
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgLGMtP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 07:49:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:42034 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbgLGMtO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 07:49:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 744A9AD09;
        Mon,  7 Dec 2020 12:48:31 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/35] 3w-sas: Whitespace cleanup
Date:   Mon,  7 Dec 2020 13:47:48 +0100
Message-Id: <20201207124819.95822-5-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201207124819.95822-1-hare@suse.de>
References: <20201207124819.95822-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/3w-sas.c |  52 +++++++++++-----------
 drivers/scsi/3w-sas.h | 118 ++++++++++++++++++++++++++++----------------------
 2 files changed, 93 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index dda6fa857709..a07e7e7e8b54 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -120,7 +120,7 @@ static struct bin_attribute twl_sysfs_aen_read_attr = {
 	.attr = {
 		.name = "3ware_aen_read",
 		.mode = S_IRUSR,
-	}, 
+	},
 	.size = 0,
 	.read = twl_sysfs_aen_read
 };
@@ -151,7 +151,7 @@ static struct bin_attribute twl_sysfs_compat_info_attr = {
 	.attr = {
 		.name = "3ware_compat_info",
 		.mode = S_IRUSR,
-	}, 
+	},
 	.size = 0,
 	.read = twl_sysfs_compat_info
 };
@@ -174,7 +174,7 @@ static ssize_t twl_show_stats(struct device *dev,
 		       "Last sector count:         %4d\n"
 		       "Max sector count:          %4d\n"
 		       "SCSI Host Resets:          %4d\n"
-		       "AEN's:                     %4d\n", 
+		       "AEN's:                     %4d\n",
 		       TW_DRIVER_VERSION,
 		       tw_dev->posted_request_count,
 		       tw_dev->max_posted_request_count,
@@ -191,7 +191,7 @@ static ssize_t twl_show_stats(struct device *dev,
 /* stats sysfs attribute initializer */
 static struct device_attribute twl_host_stats_attr = {
 	.attr = {
-		.name = 	"3ware_stats",
+		.name =		"3ware_stats",
 		.mode =		S_IRUGO,
 	},
 	.show = twl_show_stats
@@ -432,7 +432,7 @@ static void twl_aen_sync_time(TW_Device_Extension *tw_dev, int request_id)
 	param->parameter_id = cpu_to_le16(0x3); /* SchedulerTime */
 	param->parameter_size_bytes = cpu_to_le16(4);
 
-	/* Convert system time in UTC to local time seconds since last 
+	/* Convert system time in UTC to local time seconds since last
            Sunday 12:00AM */
 	local_time = (ktime_get_real_seconds() - (sys_tz.tz_minuteswest * 60));
 	div_u64_rem(local_time - (3 * 86400), 604800, &schedulertime);
@@ -483,7 +483,7 @@ static int twl_aen_complete(TW_Device_Extension *tw_dev, int request_id)
 		/* Keep reading the queue in case there are more aen's */
 		if (twl_aen_read_queue(tw_dev, request_id))
 			goto out2;
-	        else {
+		else {
 			retval = 0;
 			goto out;
 		}
@@ -548,7 +548,7 @@ static int twl_poll_response(TW_Device_Extension *tw_dev, int request_id, int se
 		msleep(50);
 	}
 	retval = 0;
-out: 
+out:
 	return retval;
 } /* End twl_poll_response() */
 
@@ -802,7 +802,7 @@ static long twl_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 
 		/* Now copy in the command packet response */
 		memcpy(&(tw_ioctl->firmware_command), tw_dev->command_packet_virt[request_id], sizeof(TW_Command_Full));
-		
+
 		/* Now complete the io */
 		spin_lock_irqsave(tw_dev->host->host_lock, flags);
 		tw_dev->posted_request_count--;
@@ -879,7 +879,7 @@ static int twl_fill_sense(TW_Device_Extension *tw_dev, int i, int request_id, in
 			       tw_dev->host->host_no,
 			       TW_MESSAGE_SOURCE_CONTROLLER_ERROR,
 			       header->status_block.error,
-			       error_str, 
+			       error_str,
 			       header->err_specific_desc);
 		else
 			printk(KERN_WARNING "3w-sas: ERROR: (0x%02X:0x%04X): %s:%s.\n",
@@ -937,8 +937,8 @@ static void *twl_get_param(TW_Device_Extension *tw_dev, int request_id, int tabl
 	command_packet = &full_command_packet->command.oldcommand;
 
 	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_GET_PARAM);
-	command_packet->size              = TW_COMMAND_SIZE;
-	command_packet->request_id        = request_id;
+	command_packet->size		  = TW_COMMAND_SIZE;
+	command_packet->request_id	  = request_id;
 	command_packet->byte6_offset.block_count = cpu_to_le16(1);
 
 	/* Now setup the param */
@@ -968,14 +968,14 @@ static void *twl_get_param(TW_Device_Extension *tw_dev, int request_id, int tabl
 
 /* This function will send an initconnection command to controller */
 static int twl_initconnection(TW_Device_Extension *tw_dev, int message_credits,
- 			      u32 set_features, unsigned short current_fw_srl, 
-			      unsigned short current_fw_arch_id, 
-			      unsigned short current_fw_branch, 
-			      unsigned short current_fw_build, 
-			      unsigned short *fw_on_ctlr_srl, 
-			      unsigned short *fw_on_ctlr_arch_id, 
-			      unsigned short *fw_on_ctlr_branch, 
-			      unsigned short *fw_on_ctlr_build, 
+			      u32 set_features, unsigned short current_fw_srl,
+			      unsigned short current_fw_arch_id,
+			      unsigned short current_fw_branch,
+			      unsigned short current_fw_build,
+			      unsigned short *fw_on_ctlr_srl,
+			      unsigned short *fw_on_ctlr_arch_id,
+			      unsigned short *fw_on_ctlr_branch,
+			      unsigned short *fw_on_ctlr_build,
 			      u32 *init_connect_result)
 {
 	TW_Command_Full *full_command_packet;
@@ -986,7 +986,7 @@ static int twl_initconnection(TW_Device_Extension *tw_dev, int message_credits,
 	full_command_packet = tw_dev->command_packet_virt[request_id];
 	memset(full_command_packet, 0, sizeof(TW_Command_Full));
 	full_command_packet->header.header_desc.size_header = 128;
-	
+
 	tw_initconnect = (TW_Initconnect *)&full_command_packet->command.oldcommand;
 	tw_initconnect->opcode__reserved = TW_OPRES_IN(0, TW_OP_INIT_CONNECTION);
 	tw_initconnect->request_id = request_id;
@@ -1004,7 +1004,7 @@ static int twl_initconnection(TW_Device_Extension *tw_dev, int message_credits,
 		tw_initconnect->fw_arch_id = cpu_to_le16(current_fw_arch_id);
 		tw_initconnect->fw_branch = cpu_to_le16(current_fw_branch);
 		tw_initconnect->fw_build = cpu_to_le16(current_fw_build);
-	} else 
+	} else
 		tw_initconnect->size = TW_INIT_COMMAND_PACKET_SIZE;
 
 	/* Send command packet to the board */
@@ -1211,7 +1211,7 @@ static irqreturn_t twl_interrupt(int irq, void *dev_instance)
 
 			if (!error)
 				cmd->result = (DID_OK << 16);
-			
+
 			/* Report residual bytes for single sgl */
 			if ((scsi_sg_count(cmd) <= 1) && (full_command_packet->command.newcommand.status == 0)) {
 				if (full_command_packet->command.newcommand.sg_list[0].length < scsi_bufflen(tw_dev->srb[request_id]))
@@ -1245,7 +1245,7 @@ static int twl_poll_register(TW_Device_Extension *tw_dev, void *reg, u32 value,
 	reg_value = readl(reg);
 	before = jiffies;
 
-        while ((reg_value & value) != result) {
+	while ((reg_value & value) != result) {
 		reg_value = readl(reg);
 		if (time_after(jiffies, before + HZ * seconds))
 			goto out;
@@ -1470,7 +1470,7 @@ static int twl_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 
 	/* Save done function into scsi_cmnd struct */
 	SCpnt->scsi_done = done;
-		
+
 	/* Get a free request id */
 	twl_get_request_id(tw_dev, &request_id);
 
@@ -1524,7 +1524,7 @@ static void twl_shutdown(struct pci_dev *pdev)
 
 	tw_dev = (TW_Device_Extension *)host->hostdata;
 
-	if (tw_dev->online) 
+	if (tw_dev->online)
 		__twl_shutdown(tw_dev);
 } /* End twl_shutdown() */
 
@@ -1675,7 +1675,7 @@ static int twl_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 
 	/* Re-enable interrupts on the card */
 	TWL_UNMASK_INTERRUPTS(tw_dev);
-	
+
 	/* Finally, scan the host */
 	scsi_scan_host(host);
 
diff --git a/drivers/scsi/3w-sas.h b/drivers/scsi/3w-sas.h
index 05e77d84c16d..b0508039a280 100644
--- a/drivers/scsi/3w-sas.h
+++ b/drivers/scsi/3w-sas.h
@@ -52,17 +52,17 @@ static char *twl_aen_severity_table[] =
 };
 
 /* Liberator register offsets */
-#define TWL_STATUS                         0x0  /* Status */
-#define TWL_HIBDB                          0x20 /* Inbound doorbell */
-#define TWL_HISTAT                         0x30 /* Host interrupt status */
-#define TWL_HIMASK                         0x34 /* Host interrupt mask */
+#define TWL_STATUS			   0x0  /* Status */
+#define TWL_HIBDB			   0x20 /* Inbound doorbell */
+#define TWL_HISTAT			   0x30 /* Host interrupt status */
+#define TWL_HIMASK			   0x34 /* Host interrupt mask */
 #define TWL_HOBDB			   0x9C /* Outbound doorbell */
-#define TWL_HOBDBC                         0xA0 /* Outbound doorbell clear */
-#define TWL_SCRPD3                         0xBC /* Scratchpad */
-#define TWL_HIBQPL                         0xC0 /* Host inbound Q low */
-#define TWL_HIBQPH                         0xC4 /* Host inbound Q high */
-#define TWL_HOBQPL                         0xC8 /* Host outbound Q low */
-#define TWL_HOBQPH                         0xCC /* Host outbound Q high */
+#define TWL_HOBDBC			   0xA0 /* Outbound doorbell clear */
+#define TWL_SCRPD3			   0xBC /* Scratchpad */
+#define TWL_HIBQPL			   0xC0 /* Host inbound Q low */
+#define TWL_HIBQPH			   0xC4 /* Host inbound Q high */
+#define TWL_HOBQPL			   0xC8 /* Host outbound Q low */
+#define TWL_HOBQPH			   0xCC /* Host outbound Q high */
 #define TWL_HISTATUS_VALID_INTERRUPT	   0xC
 #define TWL_HISTATUS_ATTENTION_INTERRUPT   0x4
 #define TWL_HISTATUS_RESPONSE_INTERRUPT	   0x8
@@ -80,12 +80,12 @@ static char *twl_aen_severity_table[] =
 #define TW_OP_EXECUTE_SCSI    0x10
 
 /* Asynchronous Event Notification (AEN) codes used by the driver */
-#define TW_AEN_QUEUE_EMPTY       0x0000
-#define TW_AEN_SOFT_RESET        0x0001
+#define TW_AEN_QUEUE_EMPTY	 0x0000
+#define TW_AEN_SOFT_RESET	 0x0001
 #define TW_AEN_SYNC_TIME_WITH_HOST 0x031
-#define TW_AEN_SEVERITY_ERROR    0x1
-#define TW_AEN_SEVERITY_DEBUG    0x4
-#define TW_AEN_NOT_RETRIEVED 0x1
+#define TW_AEN_SEVERITY_ERROR	 0x1
+#define TW_AEN_SEVERITY_DEBUG	 0x4
+#define TW_AEN_NOT_RETRIEVED	 0x1
 
 /* Command state defines */
 #define TW_S_INITIAL   0x1  /* Initial state */
@@ -101,7 +101,7 @@ static char *twl_aen_severity_table[] =
 #define TW_CURRENT_DRIVER_BRANCH 0
 
 /* Misc defines */
-#define TW_SECTOR_SIZE                        512
+#define TW_SECTOR_SIZE			      512
 #define TW_MAX_UNITS			      32
 #define TW_INIT_MESSAGE_CREDITS		      0x100
 #define TW_INIT_COMMAND_PACKET_SIZE	      0x3
@@ -116,15 +116,15 @@ static char *twl_aen_severity_table[] =
 #define TW_MAX_RESET_TRIES		      2
 #define TW_MAX_CMDS_PER_LUN		      254
 #define TW_MAX_AEN_DRAIN		      255
-#define TW_IN_RESET                           2
+#define TW_IN_RESET			      2
 #define TW_USING_MSI			      3
 #define TW_IN_ATTENTION_LOOP		      4
-#define TW_MAX_SECTORS                        256
-#define TW_MAX_CDB_LEN                        16
-#define TW_IOCTL_CHRDEV_TIMEOUT               60 /* 60 seconds */
-#define TW_IOCTL_CHRDEV_FREE                  -1
-#define TW_COMMAND_OFFSET                     128 /* 128 bytes */
-#define TW_VERSION_TABLE                      0x0402
+#define TW_MAX_SECTORS			      256
+#define TW_MAX_CDB_LEN			      16
+#define TW_IOCTL_CHRDEV_TIMEOUT		      60 /* 60 seconds */
+#define TW_IOCTL_CHRDEV_FREE		      -1
+#define TW_COMMAND_OFFSET		      128 /* 128 bytes */
+#define TW_VERSION_TABLE		      0x0402
 #define TW_TIMEKEEP_TABLE		      0x040A
 #define TW_INFORMATION_TABLE		      0x0403
 #define TW_PARAM_FWVER			      3
@@ -136,15 +136,15 @@ static char *twl_aen_severity_table[] =
 #define TW_PARAM_PHY_SUMMARY_TABLE	      1
 #define TW_PARAM_PHYCOUNT		      2
 #define TW_PARAM_PHYCOUNT_LENGTH	      1
-#define TW_IOCTL_FIRMWARE_PASS_THROUGH        0x108  // Used by smartmontools
+#define TW_IOCTL_FIRMWARE_PASS_THROUGH	      0x108  // Used by smartmontools
 #define TW_ALLOCATION_LENGTH		      128
 #define TW_SENSE_DATA_LENGTH		      18
 #define TW_ERROR_LOGICAL_UNIT_NOT_SUPPORTED   0x10a
 #define TW_ERROR_INVALID_FIELD_IN_CDB	      0x10d
-#define TW_ERROR_UNIT_OFFLINE                 0x128
+#define TW_ERROR_UNIT_OFFLINE		      0x128
 #define TW_MESSAGE_SOURCE_CONTROLLER_ERROR    3
 #define TW_MESSAGE_SOURCE_CONTROLLER_EVENT    4
-#define TW_DRIVER 			      6
+#define TW_DRIVER			      6
 #ifndef PCI_DEVICE_ID_3WARE_9750
 #define PCI_DEVICE_ID_3WARE_9750 0x1010
 #endif
@@ -167,25 +167,41 @@ static char *twl_aen_severity_table[] =
 #define TW_NOTMFA_OUT(x) (x & 0x1)
 
 /* request_id: 12, lun: 4 */
-#define TW_REQ_LUN_IN(lun, request_id) (((lun << 12) & 0xf000) | (request_id & 0xfff))
+#define TW_REQ_LUN_IN(lun, request_id)			\
+	(((lun << 12) & 0xf000) | (request_id & 0xfff))
 #define TW_LUN_OUT(lun) ((lun >> 12) & 0xf)
 
 /* Register access macros */
-#define TWL_STATUS_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + TWL_STATUS)
-#define TWL_HOBQPL_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + TWL_HOBQPL)
-#define TWL_HOBQPH_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + TWL_HOBQPH)
-#define TWL_HOBDB_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + TWL_HOBDB)
-#define TWL_HOBDBC_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + TWL_HOBDBC)
-#define TWL_HIMASK_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + TWL_HIMASK)
-#define TWL_HISTAT_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + TWL_HISTAT)
-#define TWL_HIBQPH_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + TWL_HIBQPH)
-#define TWL_HIBQPL_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + TWL_HIBQPL)
-#define TWL_HIBDB_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + TWL_HIBDB)
-#define TWL_SCRPD3_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + TWL_SCRPD3)
-#define TWL_MASK_INTERRUPTS(x) (writel(~0, TWL_HIMASK_REG_ADDR(tw_dev)))
-#define TWL_UNMASK_INTERRUPTS(x) (writel(~TWL_HISTATUS_VALID_INTERRUPT, TWL_HIMASK_REG_ADDR(tw_dev)))
-#define TWL_CLEAR_DB_INTERRUPT(x) (writel(~0, TWL_HOBDBC_REG_ADDR(tw_dev)))
-#define TWL_SOFT_RESET(x) (writel(TWL_ISSUE_SOFT_RESET, TWL_HIBDB_REG_ADDR(tw_dev)))
+#define TWL_STATUS_REG_ADDR(x)					\
+	((unsigned char __iomem *)x->base_addr + TWL_STATUS)
+#define TWL_HOBQPL_REG_ADDR(x)					\
+	((unsigned char __iomem *)x->base_addr + TWL_HOBQPL)
+#define TWL_HOBQPH_REG_ADDR(x)					\
+	((unsigned char __iomem *)x->base_addr + TWL_HOBQPH)
+#define TWL_HOBDB_REG_ADDR(x)					\
+	((unsigned char __iomem *)x->base_addr + TWL_HOBDB)
+#define TWL_HOBDBC_REG_ADDR(x)					\
+	((unsigned char __iomem *)x->base_addr + TWL_HOBDBC)
+#define TWL_HIMASK_REG_ADDR(x)					\
+	((unsigned char __iomem *)x->base_addr + TWL_HIMASK)
+#define TWL_HISTAT_REG_ADDR(x)					\
+	((unsigned char __iomem *)x->base_addr + TWL_HISTAT)
+#define TWL_HIBQPH_REG_ADDR(x)					\
+	((unsigned char __iomem *)x->base_addr + TWL_HIBQPH)
+#define TWL_HIBQPL_REG_ADDR(x)					\
+	((unsigned char __iomem *)x->base_addr + TWL_HIBQPL)
+#define TWL_HIBDB_REG_ADDR(x)					\
+	((unsigned char __iomem *)x->base_addr + TWL_HIBDB)
+#define TWL_SCRPD3_REG_ADDR(x)					\
+	((unsigned char __iomem *)x->base_addr + TWL_SCRPD3)
+#define TWL_MASK_INTERRUPTS(x)					\
+	(writel(~0, TWL_HIMASK_REG_ADDR(tw_dev)))
+#define TWL_UNMASK_INTERRUPTS(x)				\
+	(writel(~TWL_HISTATUS_VALID_INTERRUPT, TWL_HIMASK_REG_ADDR(tw_dev)))
+#define TWL_CLEAR_DB_INTERRUPT(x)				\
+	(writel(~0, TWL_HOBDBC_REG_ADDR(tw_dev)))
+#define TWL_SOFT_RESET(x)					\
+	(writel(TWL_ISSUE_SOFT_RESET, TWL_HIBDB_REG_ADDR(tw_dev)))
 
 /* Macros */
 #define TW_PRINTK(h,a,b,c) { \
@@ -317,7 +333,7 @@ typedef struct TAG_TW_Ioctl_Driver_Command {
 
 typedef struct TAG_TW_Ioctl_Apache {
 	TW_Ioctl_Driver_Command driver_command;
-        char padding[488];
+	char padding[488];
 	TW_Command_Full firmware_command;
 	char data_buffer[1];
 } TW_Ioctl_Buf_Apache;
@@ -352,10 +368,10 @@ typedef struct TAG_TW_Compatibility_Info
 #pragma pack()
 
 typedef struct TAG_TW_Device_Extension {
-	void                     __iomem *base_addr;
-	unsigned long	       	*generic_buffer_virt[TW_Q_LENGTH];
-	dma_addr_t	       	generic_buffer_phys[TW_Q_LENGTH];
-	TW_Command_Full	       	*command_packet_virt[TW_Q_LENGTH];
+	void			__iomem *base_addr;
+	unsigned long		*generic_buffer_virt[TW_Q_LENGTH];
+	dma_addr_t		generic_buffer_phys[TW_Q_LENGTH];
+	TW_Command_Full		*command_packet_virt[TW_Q_LENGTH];
 	dma_addr_t		command_packet_phys[TW_Q_LENGTH];
 	TW_Command_Apache_Header *sense_buffer_virt[TW_Q_LENGTH];
 	dma_addr_t		sense_buffer_phys[TW_Q_LENGTH];
@@ -364,7 +380,7 @@ typedef struct TAG_TW_Device_Extension {
 	unsigned char		free_queue[TW_Q_LENGTH];
 	unsigned char		free_head;
 	unsigned char		free_tail;
-	int     		state[TW_Q_LENGTH];
+	int			state[TW_Q_LENGTH];
 	unsigned int		posted_request_count;
 	unsigned int		max_posted_request_count;
 	unsigned int		max_sgl_entries;
@@ -375,9 +391,9 @@ typedef struct TAG_TW_Device_Extension {
 	unsigned int		aen_count;
 	struct Scsi_Host	*host;
 	long			flags;
-	TW_Event                *event_queue[TW_Q_LENGTH];
-	unsigned char           error_index;
-	unsigned int            error_sequence_id;
+	TW_Event		*event_queue[TW_Q_LENGTH];
+	unsigned char		error_index;
+	unsigned int		error_sequence_id;
 	int			chrdev_request_id;
 	wait_queue_head_t	ioctl_wqueue;
 	struct mutex		ioctl_lock;
-- 
2.16.4

