From: "Adam Radford" <aradford@amcc.com>
Subject: [PATCH] 3ware 9000 driver update for 2.6.7-rc2-mm2
Date: Wed, 2 Jun 2004 15:29:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <HYPD6V00.Q4O@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hadar.amcc.com ([192.195.69.168]:16609 "EHLO hadar.amcc.com")
	by vger.kernel.org with ESMTP id S264695AbUFBWad convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jun 2004 18:30:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, james.bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


Andrew, James, 

This patch updates the 3w-9xxx driver in 2.6.7-rc2-mm1 to v2.26.02.000 to cleanup several things pointed out by Chris Hellwig / Jeff Garzik.

Changes in this release:
  - Use descriptive defines for phase numbers.
  - Remove un-needed casts for TW_Command_Full
  - Rework eh_reset(), eh_abort() spinlocks.
  - Remove all mdelays, replace w/ schedule_timeout().
  - Remove MODULE_PARAM cmds_per_lun, add sysfs device attribute 'queue_depth'.
  - Remove twa_slave_configure().
  - Remove twa_info().
  - Remove all bitfields from structures, add bitmask macros.
  - Remove twa_setup_irq() wrapper, call directly.
  - Remove un-needed prototypes.
  - Propogate return value of pci_enable_device(), pci_set_dma_mask(), ioremap().
  - Use pci_request/free_regions().
  - Add missing call to pci_disable_device() on probe failure.
  - Unregister character ioctl interface in twa_remove().
  - Make some excessively lengthy lines < 80 columns.
  - Use pci_module_init() instead of pci_register_driver().
  - Remove bogus TW_IN_INTR check, fix twa_interrupt() spinlock.
  - Rev driver branch to .02 to denote kernel version.

--
Adam Radford
Staff Software Engineer
AMCC

diff -Naur linux-2.6.7-rc2-mm1/drivers/scsi/3w-9xxx.c linux-2.6.7-rc2-mm2/drivers/scsi/3w-9xxx.c
--- linux-2.6.7-rc2-mm1/drivers/scsi/3w-9xxx.c	2004-06-02 14:58:48.000000000 -0700
+++ linux-2.6.7-rc2-mm2/drivers/scsi/3w-9xxx.c	2004-06-02 15:04:13.000000000 -0700
@@ -49,13 +49,7 @@
 
    History
    -------
-   2.26.00.005 - Initial release.
-   2.26.00.006 - Remove TW_WRITEL macro, replace with writeq().
-   2.26.00.007 - Skip lun and channel probes.
-   2.26.00.008 - Fix bug in attention/command interrupt handling.
-   2.26.00.009 - Convert driver to pci_driver format.
-                 Remove proc interface, add sysfs attributes.
-                 Return SCSI_MLQUEUE_HOST_BUSY when card status is busy.
+   2.26.02.000 - Driver cleanup for kernel submission.
 */
 
 #include <linux/module.h>
@@ -78,69 +72,45 @@
 #include "3w-9xxx.h"
 
 /* Globals */
-char *twa_driver_version="2.26.00.009";
-TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
+static const char *twa_driver_version="2.26.02.000";
+static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
 extern struct timezone sys_tz;
-static int cmds_per_lun;
 
 /* Module parameters */
 MODULE_AUTHOR ("AMCC");
 MODULE_DESCRIPTION ("3ware 9000 Storage Controller Linux Driver");
 MODULE_LICENSE("GPL");
-module_param(cmds_per_lun, int, 0);
-MODULE_PARM_DESC(cmds_per_lun, "Maximum commands per LUN");
 
 /* Function prototypes */
-static int twa_aen_complete(TW_Device_Extension *tw_dev, int request_id);
-static int twa_aen_drain_queue(TW_Device_Extension *tw_dev, int check_reset);
 static void twa_aen_queue_event(TW_Device_Extension *tw_dev, TW_Command_Apache_Header *header);
 static int twa_aen_read_queue(TW_Device_Extension *tw_dev, int request_id);
 static char *twa_aen_severity_lookup(unsigned char severity_code);
 static void twa_aen_sync_time(TW_Device_Extension *tw_dev, int request_id);
-static int twa_allocate_memory(TW_Device_Extension *tw_dev, int size, int which);
-static int twa_check_bits(u32 status_reg_value);
-static int twa_check_srl(TW_Device_Extension *tw_dev, int *flashed);
 static int twa_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
 static int twa_chrdev_open(struct inode *inode, struct file *file);
-static int twa_decode_bits(TW_Device_Extension *tw_dev, u32 status_reg_value);
-static int twa_empty_response_queue(TW_Device_Extension *tw_dev);
 static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_sense, int print_host);
-static void twa_free_device_extension(TW_Device_Extension *tw_dev);
 static void twa_free_request_id(TW_Device_Extension *tw_dev,int request_id);
-static void *twa_get_param(TW_Device_Extension *tw_dev, int request_id, int table_id, int parameter_id, int parameter_size_bytes);
 static void twa_get_request_id(TW_Device_Extension *tw_dev, int *request_id);
 static int twa_initconnection(TW_Device_Extension *tw_dev, int message_credits,
- 			      u32 set_features, unsigned short current_fw_srl,
-			      unsigned short current_fw_arch_id,
-			      unsigned short current_fw_branch,
-			      unsigned short current_fw_build,
-			      unsigned short *fw_on_ctlr_srl,
-			      unsigned short *fw_on_ctlr_arch_id,
-			      unsigned short *fw_on_ctlr_branch,
-			      unsigned short *fw_on_ctlr_build,
+ 			      u32 set_features, unsigned short current_fw_srl, 
+			      unsigned short current_fw_arch_id, 
+			      unsigned short current_fw_branch, 
+			      unsigned short current_fw_build, 
+			      unsigned short *fw_on_ctlr_srl, 
+			      unsigned short *fw_on_ctlr_arch_id, 
+			      unsigned short *fw_on_ctlr_branch, 
+			      unsigned short *fw_on_ctlr_build, 
 			      u32 *init_connect_result);
-static int twa_initialize_device_extension(TW_Device_Extension *tw_dev);
-static irqreturn_t twa_interrupt(int irq, void *dev_instance, struct pt_regs *regs);
 static void twa_load_sgl(TW_Command_Full *full_command_packet, int request_id, dma_addr_t dma_handle, int length);
-static int twa_map_scsi_sg_data(TW_Device_Extension *tw_dev, int request_id);
-static dma_addr_t twa_map_scsi_single_data(TW_Device_Extension *tw_dev, int request_id);
 static int twa_poll_response(TW_Device_Extension *tw_dev, int request_id, int seconds);
-static int twa_poll_status(TW_Device_Extension *tw_dev, u32 flag, int seconds);
 static int twa_poll_status_gone(TW_Device_Extension *tw_dev, u32 flag, int seconds);
 static int twa_post_command_packet(TW_Device_Extension *tw_dev, int request_id, char internal);
 static int twa_reset_device_extension(TW_Device_Extension *tw_dev);
 static int twa_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset);
-static int twa_scsi_biosparam(struct scsi_device *sdev, struct block_device *bdev, sector_t capacity, int geom[]);
-static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id);
-static int twa_scsi_eh_abort(struct scsi_cmnd *SCpnt);
-static int twa_scsi_eh_reset(struct scsi_cmnd *SCpnt);
-static int twa_scsi_queue(struct scsi_cmnd *cmd, void (*done) (struct scsi_cmnd *));
 static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id, char *cdb, int use_sg, TW_SG_Apache *sglistarg);
 static void twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int request_id);
-static int twa_setup_irq(TW_Device_Extension *tw_dev);
-static int twa_slave_configure(struct scsi_device *SDptr);
 static char *twa_string_lookup(twa_message_type *table, unsigned int aen_code);
 static void twa_unmap_scsi_data(TW_Device_Extension *tw_dev, int request_id);
 
@@ -166,7 +136,7 @@
 		       "Max sector count:          %4d\n"
 		       "SCSI Host Resets:          %4d\n"
 		       "SCSI Aborts/Timeouts:      %4d\n"
-		       "AEN's:                     %4d\n",
+		       "AEN's:                     %4d\n", 
 		       twa_driver_version,
 		       tw_dev->posted_request_count,
 		       tw_dev->max_posted_request_count,
@@ -183,6 +153,35 @@
 	return len;
 } /* End twa_show_stats() */
 
+/* This function will set a devices queue depth */
+static ssize_t twa_store_queue_depth(struct device *dev, const char *buf, size_t count)
+{
+	int queue_depth;
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	queue_depth = simple_strtoul(buf, NULL, 0);
+	if (queue_depth > TW_Q_LENGTH-2)
+		return -EINVAL;
+	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
+
+	return count;
+} /* End twa_store_queue_depth() */
+
+/* Create sysfs 'queue_depth' entry */
+static struct device_attribute twa_queue_depth_attr = {
+	.attr = {
+		.name =		"queue_depth",
+		.mode =		S_IRUSR | S_IWUSR,
+	},
+	.store = twa_store_queue_depth
+};
+
+/* Device attributes initializer */
+static struct device_attribute *twa_dev_attrs[] = {
+	&twa_queue_depth_attr,
+	NULL,
+};
+
 /* Create sysfs 'stats' entry */
 static struct class_device_attribute twa_host_stats_attr = {
 	.attr = {
@@ -218,11 +217,11 @@
 	header = (TW_Command_Apache_Header *)tw_dev->generic_buffer_virt[request_id];
 	tw_dev->posted_request_count--;
 	aen = header->status_block.error;
-	full_command_packet = (TW_Command_Full *)tw_dev->command_packet_virt[request_id];
+	full_command_packet = tw_dev->command_packet_virt[request_id];
 	command_packet = &full_command_packet->command.oldcommand;
 
 	/* First check for internal completion of set param for time sync */
-	if (command_packet->byte0_offset.opcode == TW_OP_SET_PARAM) {
+	if (TW_OP_OUT(command_packet->opcode__sgloffset) == TW_OP_SET_PARAM) {
 		/* Keep reading the queue in case there are more aen's */
 		if (twa_aen_read_queue(tw_dev, request_id))
 			goto out2;
@@ -277,7 +276,7 @@
 	else
 		first_reset = 1;
 
-	full_command_packet = (TW_Command_Full *)tw_dev->command_packet_virt[request_id];
+	full_command_packet = tw_dev->command_packet_virt[request_id];
 	memset(full_command_packet, 0, sizeof(TW_Command_Full));
 
 	/* Initialize cdb */
@@ -376,7 +375,7 @@
 	aen = header->status_block.error;
 	memset(event, 0, sizeof(TW_Event));
 
-	event->severity = header->status_block.substatus_block.severity;
+	event->severity = TW_SEV_OUT(header->status_block.severity__reserved);
 	do_gettimeofday(&time);
 	local_time = (u32)(time.tv_sec - (sys_tz.tz_minuteswest * 60));
 	event->time_stamp_sec = local_time;
@@ -389,7 +388,12 @@
 	event->parameter_len = strlen(header->err_specific_desc);
 	memcpy(event->parameter_data, header->err_specific_desc, event->parameter_len);
 	if (event->severity != TW_AEN_SEVERITY_DEBUG)
-		printk(KERN_WARNING "3w-9xxx:%s AEN: %s (0x%02X:0x%04X): %s:%s.\n", host, twa_aen_severity_lookup(header->status_block.substatus_block.severity), TW_MESSAGE_SOURCE_CONTROLLER_EVENT, aen, twa_string_lookup(twa_aen_table, aen), header->err_specific_desc);
+		printk(KERN_WARNING "3w-9xxx:%s AEN: %s (0x%02X:0x%04X): %s:%s.\n",
+		       host,
+		       twa_aen_severity_lookup(TW_SEV_OUT(header->status_block.severity__reserved)),
+		       TW_MESSAGE_SOURCE_CONTROLLER_EVENT, aen,
+		       twa_string_lookup(twa_aen_table, aen),
+		       header->err_specific_desc);
 	else
 		tw_dev->aen_count--;
 
@@ -406,7 +410,7 @@
 	TW_Command_Full *full_command_packet;
 	int retval = 1;
 
-	full_command_packet = (TW_Command_Full *)tw_dev->command_packet_virt[request_id];
+	full_command_packet = tw_dev->command_packet_virt[request_id];
 	memset(full_command_packet, 0, sizeof(TW_Command_Full));
 
 	/* Initialize cdb */
@@ -457,11 +461,10 @@
 	u32 local_time;
 
 	/* Fill out the command packet */
-	full_command_packet = (TW_Command_Full *)tw_dev->command_packet_virt[request_id];
+	full_command_packet = tw_dev->command_packet_virt[request_id];
 	memset(full_command_packet, 0, sizeof(TW_Command_Full));
 	command_packet = &full_command_packet->command.oldcommand;
-	command_packet->byte0_offset.opcode = TW_OP_SET_PARAM;
-	command_packet->byte0_offset.sgl_offset = 2;
+	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_SET_PARAM);
 	command_packet->request_id = request_id;
 	command_packet->byte8_offset.param.sgl[0].address = tw_dev->generic_buffer_phys[request_id];
 	command_packet->byte8_offset.param.sgl[0].length = TW_SECTOR_SIZE;
@@ -475,7 +478,7 @@
 	param->parameter_id = 0x3; /* SchedulerTime */
 	param->parameter_size_bytes = 4;
 
-	/* Convert system time in UTC to local time seconds since last
+	/* Convert system time in UTC to local time seconds since last 
            Sunday 12:00AM */
 	do_gettimeofday(&utc);
 	local_time = (u32)(utc.tv_sec - (sys_tz.tz_minuteswest * 60));
@@ -517,7 +520,7 @@
 		switch(which) {
 		case 0:
 			tw_dev->command_packet_phys[i] = dma_handle+(i*size);
-			tw_dev->command_packet_virt[i] = (unsigned long *)((unsigned char *)cpu_addr + (i*size));
+			tw_dev->command_packet_virt[i] = (TW_Command_Full *)((unsigned char *)cpu_addr + (i*size));
 			break;
 		case 1:
 			tw_dev->generic_buffer_phys[i] = dma_handle+(i*size);
@@ -553,7 +556,12 @@
 	unsigned short fw_on_ctlr_branch = 0, fw_on_ctlr_build = 0;
 	u32 init_connect_result = 0;
 
-	if (twa_initconnection(tw_dev, TW_INIT_MESSAGE_CREDITS, TW_EXTENDED_INIT_CONNECT, TW_CURRENT_FW_SRL, TW_9000_ARCH_ID, TW_CURRENT_FW_BRANCH, TW_CURRENT_FW_BUILD, &fw_on_ctlr_srl, &fw_on_ctlr_arch_id, &fw_on_ctlr_branch, &fw_on_ctlr_build, &init_connect_result)) {
+	if (twa_initconnection(tw_dev, TW_INIT_MESSAGE_CREDITS,
+			       TW_EXTENDED_INIT_CONNECT, TW_CURRENT_FW_SRL,
+			       TW_9000_ARCH_ID, TW_CURRENT_FW_BRANCH,
+			       TW_CURRENT_FW_BUILD, &fw_on_ctlr_srl,
+			       &fw_on_ctlr_arch_id, &fw_on_ctlr_branch,
+			       &fw_on_ctlr_build, &init_connect_result)) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x7, "Initconnection failed while checking SRL");
 		goto out;
 	}
@@ -564,7 +572,13 @@
 
 	/* Try base mode compatibility */
 	if (!(init_connect_result & TW_CTLR_FW_COMPATIBLE)) {
-		if (twa_initconnection(tw_dev, TW_INIT_MESSAGE_CREDITS, TW_EXTENDED_INIT_CONNECT, TW_BASE_FW_SRL, TW_9000_ARCH_ID, TW_BASE_FW_BRANCH, TW_BASE_FW_BUILD, &fw_on_ctlr_srl, &fw_on_ctlr_arch_id, &fw_on_ctlr_branch, &fw_on_ctlr_build, &init_connect_result)) {
+		if (twa_initconnection(tw_dev, TW_INIT_MESSAGE_CREDITS,
+				       TW_EXTENDED_INIT_CONNECT,
+				       TW_BASE_FW_SRL, TW_9000_ARCH_ID,
+				       TW_BASE_FW_BRANCH, TW_BASE_FW_BUILD,
+				       &fw_on_ctlr_srl, &fw_on_ctlr_arch_id,
+				       &fw_on_ctlr_branch, &fw_on_ctlr_build,
+				       &init_connect_result)) {
 			TW_PRINTK(tw_dev->host, TW_DRIVER, 0xa, "Initconnection (base mode) failed while checking SRL");
 			goto out;
 		}
@@ -672,7 +686,9 @@
 			if (timeout == TW_IOCTL_ERROR_OS_ERESTARTSYS) {
 				retval = timeout;
 			} else {
-				printk(KERN_WARNING "3w-9xxx: scsi%d: WARNING: (0x%02X:0x%04X): Character ioctl (0x%x) timed out, resetting card.\n", tw_dev->host->host_no, TW_DRIVER, 0xc, cmd);
+				printk(KERN_WARNING "3w-9xxx: scsi%d: WARNING: (0x%02X:0x%04X): Character ioctl (0x%x) timed out, resetting card.\n",
+				       tw_dev->host->host_no, TW_DRIVER, 0xc,
+				       cmd);
 				retval = TW_IOCTL_ERROR_OS_EIO;
 			}
 			spin_lock_irqsave(tw_dev->host->host_lock, flags);
@@ -686,7 +702,7 @@
 
 		/* Now copy in the command packet response */
 		memcpy(&(tw_ioctl->firmware_command), tw_dev->command_packet_virt[request_id], sizeof(TW_Command_Full));
-
+		
 		/* Now complete the io */
 		spin_lock_irqsave(tw_dev->host->host_lock, flags);
 		tw_dev->posted_request_count--;
@@ -726,7 +742,7 @@
 			if (tw_dev->aen_clobber) {
 				tw_ioctl->driver_command.status = TW_IOCTL_ERROR_STATUS_AEN_CLOBBER;
 				tw_dev->aen_clobber = 0;
-			} else
+			} else 
 				tw_ioctl->driver_command.status = 0;
 			event_index = tw_dev->error_index;
 		} else {
@@ -919,14 +935,25 @@
 	unsigned short error;
 	int retval = 1;
 
-	full_command_packet = (TW_Command_Full *)tw_dev->command_packet_virt[request_id];
+	full_command_packet = tw_dev->command_packet_virt[request_id];
 	/* Don't print error for Logical unit not supported during rollcall */
 	error = full_command_packet->header.status_block.error;
 	if ((error != TW_ERROR_LOGICAL_UNIT_NOT_SUPPORTED) && (error != TW_ERROR_UNIT_OFFLINE)) {
 		if (print_host)
-			printk(KERN_WARNING "3w-9xxx: scsi%d: ERROR: (0x%02X:0x%04X): %s:%s.\n", tw_dev->host->host_no, TW_MESSAGE_SOURCE_CONTROLLER_ERROR, full_command_packet->header.status_block.error, twa_string_lookup(twa_error_table, full_command_packet->header.status_block.error), full_command_packet->header.err_specific_desc);
+			printk(KERN_WARNING "3w-9xxx: scsi%d: ERROR: (0x%02X:0x%04X): %s:%s.\n",
+			       tw_dev->host->host_no,
+			       TW_MESSAGE_SOURCE_CONTROLLER_ERROR,
+			       full_command_packet->header.status_block.error,
+			       twa_string_lookup(twa_error_table,
+						 full_command_packet->header.status_block.error),
+			       full_command_packet->header.err_specific_desc);
 		else
-			printk(KERN_WARNING "3w-9xxx: ERROR: (0x%02X:0x%04X): %s:%s.\n", TW_MESSAGE_SOURCE_CONTROLLER_ERROR, full_command_packet->header.status_block.error, twa_string_lookup(twa_error_table, full_command_packet->header.status_block.error), full_command_packet->header.err_specific_desc);
+			printk(KERN_WARNING "3w-9xxx: ERROR: (0x%02X:0x%04X): %s:%s.\n",
+			       TW_MESSAGE_SOURCE_CONTROLLER_ERROR,
+			       full_command_packet->header.status_block.error,
+			       twa_string_lookup(twa_error_table,
+						 full_command_packet->header.status_block.error),
+			       full_command_packet->header.err_specific_desc);
 	}
 
 	if (copy_sense) {
@@ -944,10 +971,16 @@
 static void twa_free_device_extension(TW_Device_Extension *tw_dev)
 {
 	if (tw_dev->command_packet_virt[0])
-		pci_free_consistent(tw_dev->tw_pci_dev, sizeof(TW_Command_Full)*TW_Q_LENGTH, tw_dev->command_packet_virt[0], tw_dev->command_packet_phys[0]);
+		pci_free_consistent(tw_dev->tw_pci_dev,
+				    sizeof(TW_Command_Full)*TW_Q_LENGTH,
+				    tw_dev->command_packet_virt[0],
+				    tw_dev->command_packet_phys[0]);
 
 	if (tw_dev->generic_buffer_virt[0])
-		pci_free_consistent(tw_dev->tw_pci_dev, TW_SECTOR_SIZE*TW_Q_LENGTH, tw_dev->generic_buffer_virt[0], tw_dev->generic_buffer_phys[0]);
+		pci_free_consistent(tw_dev->tw_pci_dev,
+				    TW_SECTOR_SIZE*TW_Q_LENGTH,
+				    tw_dev->generic_buffer_virt[0],
+				    tw_dev->generic_buffer_phys[0]);
 
 	if (tw_dev->event_queue[0])
 		kfree(tw_dev->event_queue[0]);
@@ -971,12 +1004,11 @@
 	void *retval = NULL;
 
 	/* Setup the command packet */
-	full_command_packet = (TW_Command_Full *)tw_dev->command_packet_virt[request_id];
+	full_command_packet = tw_dev->command_packet_virt[request_id];
 	memset(full_command_packet, 0, sizeof(TW_Command_Full));
 	command_packet = &full_command_packet->command.oldcommand;
 
-	command_packet->byte0_offset.opcode      = TW_OP_GET_PARAM;
-	command_packet->byte0_offset.sgl_offset  = 2;
+	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_GET_PARAM);
 	command_packet->size              = TW_COMMAND_SIZE;
 	command_packet->request_id        = request_id;
 	command_packet->byte6_offset.block_count = 1;
@@ -1017,14 +1049,14 @@
 
 /* This function will send an initconnection command to controller */
 static int twa_initconnection(TW_Device_Extension *tw_dev, int message_credits,
- 			      u32 set_features, unsigned short current_fw_srl,
-			      unsigned short current_fw_arch_id,
-			      unsigned short current_fw_branch,
-			      unsigned short current_fw_build,
-			      unsigned short *fw_on_ctlr_srl,
-			      unsigned short *fw_on_ctlr_arch_id,
-			      unsigned short *fw_on_ctlr_branch,
-			      unsigned short *fw_on_ctlr_build,
+ 			      u32 set_features, unsigned short current_fw_srl, 
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
@@ -1032,13 +1064,12 @@
 	int request_id = 0, retval = 1;
 
 	/* Initialize InitConnection command packet */
-	full_command_packet = (TW_Command_Full *)tw_dev->command_packet_virt[request_id];
+	full_command_packet = tw_dev->command_packet_virt[request_id];
 	memset(full_command_packet, 0, sizeof(TW_Command_Full));
 	full_command_packet->header.header_desc.size_header = 128;
-
+	
 	tw_initconnect = (TW_Initconnect *)&full_command_packet->command.oldcommand;
-	tw_initconnect->opcode = TW_OP_INIT_CONNECTION;
-
+	tw_initconnect->opcode__reserved = TW_OPRES_IN(0, TW_OP_INIT_CONNECTION);
 	tw_initconnect->request_id = request_id;
 	tw_initconnect->message_credits = message_credits;
 	tw_initconnect->features = set_features;
@@ -1053,7 +1084,7 @@
 		tw_initconnect->fw_arch_id = current_fw_arch_id;
 		tw_initconnect->fw_branch = current_fw_branch;
 		tw_initconnect->fw_build = current_fw_build;
-	} else
+	} else 
 		tw_initconnect->size = TW_INIT_COMMAND_PACKET_SIZE;
 
 	/* Send command packet to the board */
@@ -1097,7 +1128,7 @@
 	}
 
 	/* Allocate event info space */
-	tw_dev->event_queue[0] = kmalloc(sizeof(TW_Event) * TW_Q_LENGTH, GFP_ATOMIC);
+	tw_dev->event_queue[0] = kmalloc(sizeof(TW_Event) * TW_Q_LENGTH, GFP_KERNEL);
 	if (!tw_dev->event_queue[0]) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x18, "Event info memory allocation failed");
 		goto out;
@@ -1132,18 +1163,13 @@
 	int request_id, error = 0;
 	u32 status_reg_value;
 	TW_Response_Queue response_que;
-	unsigned long flags = 0;
 	TW_Command_Full *full_command_packet;
 	TW_Command *command_packet;
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)dev_instance;
 	int handled = 0;
 
-	/* See if we are already running on another processor */
-	if (test_and_set_bit(TW_IN_INTR, &tw_dev->flags))
-		return IRQ_NONE;
-
 	/* Get the per adapter lock */
-	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+	spin_lock(tw_dev->host->host_lock);
 
 	/* See if the interrupt matches this instance */
 	if (tw_dev->tw_pci_dev->irq == (unsigned int)irq) {
@@ -1212,8 +1238,8 @@
 			while ((status_reg_value & TW_STATUS_RESPONSE_QUEUE_EMPTY) == 0) {
 				/* Complete the response */
 				response_que.value = readl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
-				request_id = response_que.u.response_id;
-				full_command_packet = (TW_Command_Full *)tw_dev->command_packet_virt[request_id];
+				request_id = TW_RESID_OUT(response_que.response_id);
+				full_command_packet = tw_dev->command_packet_virt[request_id];
 				error = 0;
 				command_packet = &full_command_packet->command.oldcommand;
 				/* Check for command packet errors */
@@ -1279,8 +1305,7 @@
 		}
 	}
 twa_interrupt_bail:
-	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
-	clear_bit(TW_IN_INTR, &tw_dev->flags);
+	spin_unlock(tw_dev->host->host_lock);
 	return IRQ_RETVAL(handled);
 } /* End twa_interrupt() */
 
@@ -1291,7 +1316,7 @@
 	TW_Command_Apache *newcommand;
 	TW_SG_Entry *sgl;
 
-	if (full_command_packet->command.newcommand.command.opcode == TW_OP_EXECUTE_SCSI) {
+	if (TW_OP_OUT(full_command_packet->command.newcommand.opcode__reserved) == TW_OP_EXECUTE_SCSI) {
 		newcommand = &full_command_packet->command.newcommand;
 		newcommand->request_id = request_id;
 		newcommand->sg_list[0].address = dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1;
@@ -1300,9 +1325,9 @@
 		oldcommand = &full_command_packet->command.oldcommand;
 		oldcommand->request_id = request_id;
 
-		if (oldcommand->byte0_offset.sgl_offset) {
+		if (TW_SGL_OUT(oldcommand->opcode__sgloffset)) {
 			/* Load the sg list */
-			sgl = (TW_SG_Entry *)((u32 *)oldcommand+oldcommand->byte0_offset.sgl_offset);
+			sgl = (TW_SG_Entry *)((u32 *)oldcommand+TW_SGL_OUT(oldcommand->opcode__sgloffset));
 			sgl->address = dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1;
 			sgl->length = length;
 		}
@@ -1327,7 +1352,7 @@
 		goto out;
 	}
 
-	cmd->SCp.phase = 2;
+	cmd->SCp.phase = TW_PHASE_SGLIST;
 	cmd->SCp.have_data_in = use_sg;
 	retval = use_sg;
 out:
@@ -1354,7 +1379,7 @@
 		goto out;
 	}
 
-	cmd->SCp.phase = 1;
+	cmd->SCp.phase = TW_PHASE_SINGLE;
 	cmd->SCp.have_data_in = mapping;
 	retval = mapping;
 out:
@@ -1366,16 +1391,16 @@
 {
 	int retval = 1, found = 0, response_request_id;
 	TW_Response_Queue response_queue;
-	TW_Command_Full *full_command_packet = (TW_Command_Full *)tw_dev->command_packet_virt[request_id];
+	TW_Command_Full *full_command_packet = tw_dev->command_packet_virt[request_id];
 
 	if (twa_poll_status_gone(tw_dev, TW_STATUS_RESPONSE_QUEUE_EMPTY, seconds) == 0) {
 		response_queue.value = readl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
-		response_request_id = (unsigned char)response_queue.u.response_id;
+		response_request_id = TW_RESID_OUT(response_queue.response_id);
 		if (request_id != response_request_id) {
 			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1e, "Found unexpected request id while polling for response");
 			goto out;
 		}
-		if (full_command_packet->command.newcommand.command.opcode == TW_OP_EXECUTE_SCSI) {
+		if (TW_OP_OUT(full_command_packet->command.newcommand.opcode__reserved) == TW_OP_EXECUTE_SCSI) {
 			if (full_command_packet->command.newcommand.status != 0) {
 				/* bad response */
 				twa_fill_sense(tw_dev, request_id, 0, 0);
@@ -1401,7 +1426,7 @@
 /* This function will poll the status register for a flag */
 static int twa_poll_status(TW_Device_Extension *tw_dev, u32 flag, int seconds)
 {
-	u32 status_reg_value;
+	u32 status_reg_value; 
 	unsigned long before;
 	int retval = 1;
 
@@ -1420,7 +1445,7 @@
 		if (time_after(jiffies, before + HZ * seconds))
 			goto out;
 
-		mdelay(5);
+		schedule_timeout(1);
 	}
 	retval = 0;
 out:
@@ -1448,7 +1473,7 @@
 		if (time_after(jiffies, before + HZ * seconds))
 			goto out;
 
-		mdelay(5);
+		schedule_timeout(1);
 	}
 	retval = 0;
 out:
@@ -1642,12 +1667,16 @@
 
 	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
 
+	spin_unlock_irq(tw_dev->host->host_lock);
+
 	tw_dev->num_aborts++;
 
 	/* If we find any IO's in process, we have to reset the card */
 	for (i = 0; i < TW_Q_LENGTH; i++) {
 		if ((tw_dev->state[i] != TW_S_FINISHED) && (tw_dev->state[i] != TW_S_INITIAL)) {
-			printk(KERN_WARNING "3w-9xxx: scsi%d: WARNING: (0x%02X:0x%04X): Unit #%d: Command (0x%x) timed out, resetting card.\n", tw_dev->host->host_no, TW_DRIVER, 0x2c, SCpnt->device->id, SCpnt->cmnd[0]);
+			printk(KERN_WARNING "3w-9xxx: scsi%d: WARNING: (0x%02X:0x%04X): Unit #%d: Command (0x%x) timed out, resetting card.\n",
+			       tw_dev->host->host_no, TW_DRIVER, 0x2c,
+			       SCpnt->device->id, SCpnt->cmnd[0]);
 			if (twa_reset_device_extension(tw_dev)) {
 				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2a, "Controller reset failed during scsi abort");
 				goto out;
@@ -1657,6 +1686,7 @@
 	}
 	retval = SUCCESS;
 out:
+	spin_lock_irq(tw_dev->host->host_lock);
 	return retval;
 } /* End twa_scsi_eh_abort() */
 
@@ -1668,6 +1698,8 @@
 
 	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
 
+	spin_unlock_irq(tw_dev->host->host_lock);
+
 	tw_dev->num_resets++;
 
 	printk(KERN_WARNING "3w-9xxx: scsi%d: SCSI host reset started.\n", tw_dev->host->host_no);
@@ -1680,6 +1712,7 @@
 	printk(KERN_WARNING "3w-9xxx: scsi%d: SCSI host reset succeeded.\n", tw_dev->host->host_no);
 	retval = SUCCESS;
 out:
+	spin_lock_irq(tw_dev->host->host_lock);
 	return retval;
 } /* End twa_scsi_eh_reset() */
 
@@ -1691,7 +1724,7 @@
 
 	/* Save done function into scsi_cmnd struct */
 	SCpnt->scsi_done = done;
-
+		
 	/* Get a free request id */
 	twa_get_request_id(tw_dev, &request_id);
 
@@ -1699,7 +1732,7 @@
 	tw_dev->srb[request_id] = SCpnt;
 
 	/* Initialize phase to zero */
-	SCpnt->SCp.phase = 0;
+	SCpnt->SCp.phase = TW_PHASE_INITIAL;
 
 	retval = twa_scsiop_execute_scsi(tw_dev, request_id, NULL, 0, NULL);
 	switch (retval) {
@@ -1736,14 +1769,14 @@
 	}
 
 	/* Initialize command packet */
-	full_command_packet = (TW_Command_Full *)tw_dev->command_packet_virt[request_id];
+	full_command_packet = tw_dev->command_packet_virt[request_id];
 	full_command_packet->header.header_desc.size_header = 128;
 	full_command_packet->header.status_block.error = 0;
-	full_command_packet->header.status_block.substatus_block.severity = 0;
+	full_command_packet->header.status_block.severity__reserved = 0;
 
 	command_packet = &full_command_packet->command.newcommand;
 	command_packet->status = 0;
-	command_packet->command.opcode = TW_OP_EXECUTE_SCSI;
+	command_packet->opcode__reserved = TW_OPRES_IN(0, TW_OP_EXECUTE_SCSI);
 
 	/* We forced 16 byte cdb use earlier */
 	if (!cdb)
@@ -1845,25 +1878,12 @@
 {
 	/* Copy the response if too small */
 	if ((tw_dev->srb[request_id]->request_buffer) && (tw_dev->srb[request_id]->request_bufflen < TW_MIN_SGL_LENGTH)) {
-		memcpy(tw_dev->srb[request_id]->request_buffer, tw_dev->generic_buffer_virt[request_id], tw_dev->srb[request_id]->request_bufflen);
+		memcpy(tw_dev->srb[request_id]->request_buffer,
+		       tw_dev->generic_buffer_virt[request_id],
+		       tw_dev->srb[request_id]->request_bufflen);
 	}
 } /* End twa_scsiop_execute_scsi_complete() */
 
-/* This function will setup the interrupt handler */
-static int twa_setup_irq(TW_Device_Extension *tw_dev)
-{
-	char *device = TW_DEVICE_NAME;
-	int retval = 1;
-
-	if (request_irq(tw_dev->tw_pci_dev->irq, twa_interrupt, SA_SHIRQ, device, tw_dev) < 0) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x30, "Error requesting IRQ");
-		goto out;
-	}
-	retval = 0;
-out:
-	return retval;
-} /* End twa_setup_irq() */
-
 /* This function tells the controller to shut down */
 static void __twa_shutdown(TW_Device_Extension *tw_dev)
 {
@@ -1892,23 +1912,6 @@
 	__twa_shutdown(tw_dev);
 } /* End twa_shutdown() */
 
-/* This function will configure individual target parameters */
-static int twa_slave_configure(struct scsi_device *SDptr)
-{
-	int max_cmds;
-
-	if (cmds_per_lun) {
-		max_cmds = cmds_per_lun;
-		if (max_cmds > TW_MAX_CMDS_PER_LUN)
-			max_cmds = TW_MAX_CMDS_PER_LUN;
-	} else {
-		max_cmds = TW_MAX_CMDS_PER_LUN;
-	}
-	scsi_adjust_queue_depth(SDptr, MSG_ORDERED_TAG, max_cmds);
-
-	return 0;
-} /* End twa_slave_configure */
-
 /* This function will look up a string */
 static char *twa_string_lookup(twa_message_type *table, unsigned int code)
 {
@@ -1926,35 +1929,23 @@
 	struct pci_dev *pdev = tw_dev->tw_pci_dev;
 
 	switch(cmd->SCp.phase) {
-	case 1:
+	case TW_PHASE_SINGLE:
 		pci_unmap_single(pdev, cmd->SCp.have_data_in, cmd->request_bufflen, DMA_BIDIRECTIONAL);
 		break;
-	case 2:
+	case TW_PHASE_SGLIST:
 		pci_unmap_sg(pdev, cmd->request_buffer, cmd->use_sg, DMA_BIDIRECTIONAL);
 		break;
 	}
 } /* End twa_unmap_scsi_data() */
 
-/* Get informationa bout the card/driver */
-static const char *twa_info(struct Scsi_Host *host)
-{
-	static char buffer[512];
-
-	sprintf(buffer, "3ware 9000 Storage Controller");
-
-	return buffer;
-} /* End twa_info() */
-
 /* scsi_host_template initializer */
 static struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "3ware 9000 Storage Controller",
-	.info			= twa_info,
 	.queuecommand		= twa_scsi_queue,
 	.eh_abort_handler	= twa_scsi_eh_abort,
 	.eh_host_reset_handler	= twa_scsi_eh_reset,
 	.bios_param		= twa_scsi_biosparam,
-	.slave_configure	= twa_slave_configure,
 	.can_queue		= TW_Q_LENGTH-2,
 	.this_id		= -1,
 	.sg_tablesize		= TW_APACHE_MAX_SGL_LENGTH,
@@ -1962,6 +1953,7 @@
 	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.shost_attrs		= twa_host_attrs,
+	.sdev_attrs		= twa_dev_attrs,
 	.emulated		= 1
 };
 
@@ -1970,26 +1962,28 @@
 {
 	struct Scsi_Host *host = NULL;
 	TW_Device_Extension *tw_dev;
-	u32 mem_addr, mem_len;
+	u32 mem_addr;
 	int retval = -ENODEV;
 
-	if (pci_enable_device(pdev)) {
-		TW_PRINTK(host, TW_DRIVER, 0x32, "Failed to enable pci device");
-		goto out;
+	retval = pci_enable_device(pdev);
+	if (retval) {
+		TW_PRINTK(host, TW_DRIVER, 0x34, "Failed to enable pci device");
+		goto out_disable_device;
 	}
 
 	pci_set_master(pdev);
 
-	if (pci_set_dma_mask(pdev, TW_DMA_MASK)) {
+	retval = pci_set_dma_mask(pdev, TW_DMA_MASK);
+	if (retval) {
 		TW_PRINTK(host, TW_DRIVER, 0x23, "Failed to set dma mask");
-		goto out;
+		goto out_disable_device;
 	}
 
 	host = scsi_host_alloc(&driver_template, sizeof(TW_Device_Extension));
 	if (!host) {
 		TW_PRINTK(host, TW_DRIVER, 0x24, "Failed to allocate memory for device extension");
 		retval = -ENOMEM;
-		goto out;
+		goto out_disable_device;
 	}
 	tw_dev = (TW_Device_Extension *)host->hostdata;
 
@@ -2003,21 +1997,22 @@
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x25, "Failed to initialize device extension");
 		goto out_free_device_extension;
 	}
-
-	mem_addr = pci_resource_start(pdev, 1);
-	mem_len = pci_resource_len(pdev, 1);
-
-	/* Make sure that mem region isn't already taken */
-	if (check_mem_region(mem_addr, mem_len)) {
+	
+	/* Request IO regions */
+	retval = pci_request_regions(pdev, "3w-9xxx");
+	if (retval) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x26, "Failed to get mem region");
 		goto out_free_device_extension;
 	}
 
-	/* Reserve the mem address space */
-	request_mem_region(mem_addr, mem_len, TW_DEVICE_NAME);
+	mem_addr = pci_resource_start(pdev, 1);
 
 	/* Save base address */
 	tw_dev->base_addr = ioremap(mem_addr, PAGE_SIZE);
+	if (!tw_dev->base_addr) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x35, "Failed to ioremap");
+		goto out_release_mem_region;
+	}
 
 	/* Disable interrupts on the card */
 	TW_DISABLE_INTERRUPTS(tw_dev);
@@ -2029,6 +2024,8 @@
 	/* Set host specific parameters */
 	host->max_id = TW_MAX_UNITS;
 	host->max_cmd_len = TW_MAX_CDB_LEN;
+	
+	/* Luns and channels aren't supported by adapter */
 	host->max_lun = 0;
 	host->max_channel = 0;
 
@@ -2041,12 +2038,23 @@
 
 	pci_set_drvdata(pdev, host);
 
-	printk(KERN_WARNING "3w-9xxx: scsi%d: Found a 3ware 9000 Storage Controller at 0x%x, IRQ: %d.\n", host->host_no, mem_addr, pdev->irq);
-	printk(KERN_WARNING "3w-9xxx: scsi%d: Firmware %s, BIOS %s, Ports: %d.\n", host->host_no, (char *)twa_get_param(tw_dev, 0, TW_VERSION_TABLE, TW_PARAM_FWVER, TW_PARAM_FWVER_LENGTH), (char *)twa_get_param(tw_dev, 1, TW_VERSION_TABLE, TW_PARAM_BIOSVER, TW_PARAM_BIOSVER_LENGTH), *(int *)twa_get_param(tw_dev, 2, TW_INFORMATION_TABLE, TW_PARAM_PORTCOUNT, TW_PARAM_PORTCOUNT_LENGTH));
+	printk(KERN_WARNING "3w-9xxx: scsi%d: Found a 3ware 9000 Storage Controller at 0x%x, IRQ: %d.\n",
+	       host->host_no, mem_addr, pdev->irq);
+	printk(KERN_WARNING "3w-9xxx: scsi%d: Firmware %s, BIOS %s, Ports: %d.\n", 
+	       host->host_no,
+	       (char *)twa_get_param(tw_dev, 0, TW_VERSION_TABLE,
+				     TW_PARAM_FWVER, TW_PARAM_FWVER_LENGTH),
+	       (char *)twa_get_param(tw_dev, 1, TW_VERSION_TABLE,
+				     TW_PARAM_BIOSVER, TW_PARAM_BIOSVER_LENGTH),
+	       *(int *)twa_get_param(tw_dev, 2, TW_INFORMATION_TABLE,
+				     TW_PARAM_PORTCOUNT, TW_PARAM_PORTCOUNT_LENGTH));
 
 	/* Now setup the interrupt handler */
-	if (twa_setup_irq(tw_dev))
+	retval = request_irq(pdev->irq, twa_interrupt, SA_SHIRQ, "3w-9xxx", tw_dev);
+	if (retval) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x30, "Error requesting IRQ");
 		goto out_remove_host;
+	}
 
 	twa_device_extension_list[twa_device_extension_count] = tw_dev;
 	twa_device_extension_count++;
@@ -2066,11 +2074,13 @@
 out_remove_host:
 	scsi_remove_host(host);
 out_release_mem_region:
-	release_mem_region(mem_addr, mem_len);
+	pci_release_regions(pdev);
 out_free_device_extension:
 	twa_free_device_extension(tw_dev);
 	scsi_host_put(host);
-out:
+out_disable_device:
+	pci_disable_device(pdev);
+
 	return retval;
 } /* End twa_probe() */
 
@@ -2088,11 +2098,17 @@
 	free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
 
 	/* Free up the mem region */
-	release_mem_region(pci_resource_start(tw_dev->tw_pci_dev, 1), pci_resource_len(tw_dev->tw_pci_dev, 1));
+	pci_release_regions(pdev);
 
 	/* Free up device extension resources */
 	twa_free_device_extension(tw_dev);
 
+	/* Unregister character device */
+	if (twa_major >= 0) {
+		unregister_chrdev(twa_major, "twa");
+		twa_major = -1;
+	}
+
 	scsi_host_put(tw_dev->host);
 	pci_disable_device(pdev);
 	twa_device_extension_count--;
@@ -2122,20 +2138,12 @@
 {
 	printk(KERN_WARNING "3ware 9000 Storage Controller device driver for Linux v%s.\n", twa_driver_version);
 
-	pci_register_driver(&twa_driver);
-
-	return 0;
+	return pci_module_init(&twa_driver);
 } /* End twa_init() */
 
 /* This function is called on driver exit */
 static void __exit twa_exit(void)
 {
-	/* Unregister character device */
-	if (twa_major >= 0) {
-		unregister_chrdev(twa_major, "twa");
-		twa_major = -1;
-	}
-
 	pci_unregister_driver(&twa_driver);
 } /* End twa_exit() */
 
diff -Naur linux-2.6.7-rc2-mm1/drivers/scsi/3w-9xxx.h linux-2.6.7-rc2-mm2/drivers/scsi/3w-9xxx.h
--- linux-2.6.7-rc2-mm1/drivers/scsi/3w-9xxx.h	2004-06-02 14:58:48.000000000 -0700
+++ linux-2.6.7-rc2-mm2/drivers/scsi/3w-9xxx.h	2004-06-02 15:04:15.000000000 -0700
@@ -329,6 +329,11 @@
 #define TW_CURRENT_FW_BUILD 5
 #define TW_CURRENT_FW_BRANCH 1
 
+/* Phase defines */
+#define TW_PHASE_INITIAL 0
+#define TW_PHASE_SINGLE  1
+#define TW_PHASE_SGLIST  2
+
 /* Misc defines */
 #define TW_SECTOR_SIZE                        512
 #define TW_ALIGNMENT_9000                     4  /* 4 bytes */
@@ -361,7 +366,6 @@
 #define TW_MAX_CMDS_PER_LUN		      254
 #define TW_MAX_RESPONSE_DRAIN		      256
 #define TW_MAX_AEN_DRAIN		      40
-#define TW_IN_INTR                            1
 #define TW_IN_IOCTL                           2
 #define TW_IN_CHRDEV_IOCTL                    3
 #define TW_IN_ATTENTION_LOOP		      4
@@ -427,6 +431,25 @@
 #define TW_COMMAND_SIZE			      4
 #define TW_DMA_MASK			      DMA_32BIT_MASK
 #endif
+#ifndef PCI_DEVICE_ID_3WARE_9000
+#define PCI_DEVICE_ID_3WARE_9000 0x1002
+#endif
+
+/* Bitmask macros to eliminate bitfields */
+
+/* opcode: 5, reserved: 3 */
+#define TW_OPRES_IN(x,y) ((x << 5) | (y & 0x1f))
+#define TW_OP_OUT(x) (x & 0x1f)
+
+/* opcode: 5, sgloffset: 3 */
+#define TW_OPSGL_IN(x,y) ((x << 5) | (y & 0x1f))
+#define TW_SGL_OUT(x) ((x >> 5) & 0x7)
+
+/* severity: 3, reserved: 5 */
+#define TW_SEV_OUT(x) (x & 0x7)
+
+/* reserved_1: 4, response_id: 8, reserved_2: 20 */
+#define TW_RESID_OUT(x) ((x >> 4) & 0xff)
 
 /* Macros */
 #define TW_CONTROL_REG_ADDR(x) (x->base_addr)
@@ -468,17 +491,10 @@
 
 /* Command Packet */
 typedef struct TW_Command {
-	/* First DWORD */
-	struct {
-		unsigned char opcode:5;
-		unsigned char sgl_offset:3;
-	} byte0_offset;
+	unsigned char opcode__sgloffset;
 	unsigned char size;
 	unsigned char request_id;
-	struct {
-		unsigned char unit:4;
-		unsigned char host_id:4;
-	} byte3_offset;
+	unsigned char unit__hostid;
 	/* Second DWORD */
 	unsigned char status;
 	unsigned char flags;
@@ -515,10 +531,7 @@
 
 /* Command Packet for 9000+ controllers */
 typedef struct TAG_TW_Command_Apache {
-	struct {
-		unsigned char opcode:5;
-		unsigned char reserved:3;
-	} command;
+	unsigned char opcode__reserved;
 	unsigned char unit;
 	unsigned short request_id;
 	unsigned char status;
@@ -538,10 +551,7 @@
 		char reserved[4];
 		unsigned short error;
 		unsigned char padding;
-		struct {
-			unsigned char severity:3;
-			unsigned char reserved:5;
-		} substatus_block;
+		unsigned char severity__reserved;
 	} status_block;
 	unsigned char err_specific_desc[98];
 	struct {
@@ -562,8 +572,7 @@
 
 /* Initconnection structure */
 typedef struct TAG_TW_Initconnect {
-	unsigned char opcode:5;
-	unsigned char res1:3;
+	unsigned char opcode__reserved;
 	unsigned char size;
 	unsigned char request_id;
 	unsigned char res2;
@@ -625,11 +634,7 @@
 
 /* Response queue */
 typedef union TAG_TW_Response_Queue {
-	struct {
-		u32 undefined_1: 4;
-		u32 response_id: 8;
-		u32 undefined_2: 20;
-	} u;
+	u32 response_id;
 	u32 value;
 } TW_Response_Queue;
 
@@ -649,38 +654,11 @@
 	unsigned short working_build;
 } TW_Compatibility_Info;
 
-/* Command header for ATA pass-thru */
-typedef struct TAG_TW_Passthru
-{
-	struct {
-		unsigned char opcode:5;
-		unsigned char sgloff:3;
-	} byte0;
-	unsigned char size;
-	unsigned char request_id;
-	struct {
-		unsigned char aport:4;
-		unsigned char host_id:4;
-	} byte3;
-	unsigned char status;
-	unsigned char flags;
-	unsigned short param;
-	unsigned short features;
-	unsigned short sector_count;
-	unsigned short sector_num;
-	unsigned short cylinder_lo;
-	unsigned short cylinder_hi;
-	unsigned char drive_head;
-	unsigned char command;
-	TW_SG_Entry sg_list[TW_ATA_PASS_SGL_MAX];
-	unsigned char padding[12];
-} TW_Passthru;
-
 typedef struct TAG_TW_Device_Extension {
 	u32                     *base_addr;
 	unsigned long	       	*generic_buffer_virt[TW_Q_LENGTH];
 	unsigned long	       	generic_buffer_phys[TW_Q_LENGTH];
-	unsigned long	       	*command_packet_virt[TW_Q_LENGTH];
+	TW_Command_Full	       	*command_packet_virt[TW_Q_LENGTH];
 	unsigned long		command_packet_phys[TW_Q_LENGTH];
 	struct pci_dev		*tw_pci_dev;
 	struct scsi_cmnd	*srb[TW_Q_LENGTH];

