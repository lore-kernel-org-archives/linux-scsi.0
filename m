From: "Adam Radford" <aradford@amcc.com>
Subject: [PATCH 1/3] 3ware 5/6/7/8000 driver v1.26.02.000
Date: Thu, 9 Sep 2004 14:02:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <I3SL5203.OKL@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hadar.amcc.com ([192.195.69.168]:52416 "EHLO hadar.amcc.com")
	by vger.kernel.org with ESMTP id S266836AbUIIVDA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Sep 2004 17:03:00 -0400
Received: from mailhost02.amcc.com ([192.195.69.49]) by
          hadar.amcc.com (Netscape Messaging Server 4.15) with SMTP id
          I3SL5203.OKL for <linux-scsi@vger.kernel.org>; Thu, 9 Sep 2004
          14:03:02 -0700
Received: (from ving-pc [10.66.6.122])
 by mailhost02.amcc.com (SMSSMTP 4.0.0.59) with SMTP id M2004090914035120562
 for <linux-scsi@vger.kernel.org>; Thu, 09 Sep 2004 14:03:51 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here is a large driver update for the 3ware 5/6/7/8000 series controllers
for 2.6.9-rc1-bk16.

Changes in this release are the following:

- Remove deprecated SCSI_IOCTL_SEND_COMMAND interface.
- Remove deprecated /proc/scsi/3w-xxxx interface.
- Convert entire driver to pci_driver format.
- Remove all mdelays, replace w/msleep to fix possible watchdog
  timer issues.
- Make all register accesses macros.
- Remove all prototypes from header file, reorder functions to
  eliminate all prototypes but one.
- Add sysfs 'queue_depth' setting attribute.
- Add sysfs 'stats' attribute.
- Fix spinlocks everywhere, remove tw_lock spinlock.
- Remove all bitfields, add bitmask access macros.
- Remove un-needed scsi_eh_abort entrypoint.  Controller does not
  support aborting invididual IO's, scsi_eh_reset sufficient.

The patch is rather lengthy due to the function reordering. 

--
Adam Radford
Staff Software Engineer
AMCC

diff -Naur linux-2.6.9-rc1-bk15/drivers/scsi/3w-xxxx.c linux-2.6.9-rc1-bk16/drivers/scsi/3w-xxxx.c
--- linux-2.6.9-rc1-bk15/drivers/scsi/3w-xxxx.c	2004-08-14 03:56:22.000000000 -0700
+++ linux-2.6.9-rc1-bk16/drivers/scsi/3w-xxxx.c	2004-09-08 17:41:45.000000000 -0700
@@ -184,327 +184,385 @@
    1.26.00.039 - Fix bug in tw_chrdev_ioctl() polling code.
                  Fix data_buffer_length usage in tw_chrdev_ioctl().
                  Update contact information.
+   1.26.02.000 - Convert driver to pci_driver format.
 */
 
 #include <linux/module.h>
-
-MODULE_AUTHOR ("3ware Inc.");
-#ifdef CONFIG_SMP
-MODULE_DESCRIPTION ("3ware Storage Controller Linux Driver (SMP)");
-#else
-MODULE_DESCRIPTION ("3ware Storage Controller Linux Driver");
-#endif
-MODULE_LICENSE("GPL");
-
-#include <linux/kernel.h>
-#include <linux/pci.h>
-#include <linux/time.h>
-#include <linux/proc_fs.h>
-#include <linux/sched.h>
-#include <linux/ioport.h>
-#include <linux/blkdev.h>
-#include <linux/hdreg.h>
-#include <linux/string.h>
-#include <linux/delay.h>
-#include <linux/smp.h>
 #include <linux/reboot.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
-
-#include <asm/errno.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/time.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
-
-#define __3W_C			/* let 3w-xxxx.h know it is use */
-
-#include "scsi.h"
+#include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
-
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_cmnd.h>
 #include "3w-xxxx.h"
 
-static int tw_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
-static int tw_chrdev_open(struct inode *inode, struct file *file);
-static int tw_chrdev_release(struct inode *inode, struct file *file);
-static int tw_copy_info(TW_Info *info, char *fmt, ...);
-static void tw_copy_mem_info(TW_Info *info, char *data, int len);
-static int tw_halt(struct notifier_block *nb, ulong event, void *buf);
-static int tw_map_scsi_sg_data(struct pci_dev *pdev, Scsi_Cmnd *cmd);
-static u32 tw_map_scsi_single_data(struct pci_dev *pdev, Scsi_Cmnd *cmd);
-static void tw_unmap_scsi_data(struct pci_dev *pdev, Scsi_Cmnd *cmd);
-
-/* Notifier block to get a notify on system shutdown/halt/reboot */
-static struct notifier_block tw_notifier = {
-	tw_halt, NULL, 0
-};
-
-/* File operations struct for character device */
-static struct file_operations tw_fops = {
-	.owner		= THIS_MODULE,
-	.ioctl		= tw_chrdev_ioctl,
-	.open		= tw_chrdev_open,
-	.release	= tw_chrdev_release
-};
-
 /* Globals */
-char *tw_driver_version="1.26.00.039";
-TW_Device_Extension *tw_device_extension_list[TW_MAX_SLOT];
-int tw_device_extension_count = 0;
+static const char *tw_driver_version="1.26.02.000";
+static TW_Device_Extension *tw_device_extension_list[TW_MAX_SLOT];
+static int tw_device_extension_count = 0;
 static int twe_major = -1;
-static int cmds_per_lun;
 
 /* Module parameters */
-module_param(cmds_per_lun, int, 0);
-MODULE_PARM_DESC(cmds_per_lun, "Maximum commands per LUN");
+MODULE_AUTHOR("AMCC");
+MODULE_DESCRIPTION("3ware Storage Controller Linux Driver");
+MODULE_LICENSE("GPL");
+
+/* Function prototypes */
+static int tw_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_reset);
 
 /* Functions */
 
-/* This function will complete an aen request from the isr */
-int tw_aen_complete(TW_Device_Extension *tw_dev, int request_id) 
+/* This function will check the status register for unexpected bits */
+int tw_check_bits(u32 status_reg_value)
 {
-	TW_Param *param;
-	unsigned short aen;
-	int error = 0, table_max = 0;
-
-	dprintk(KERN_WARNING "3w-xxxx: tw_aen_complete()\n");
-	if (tw_dev->alignment_virtual_address[request_id] == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_aen_complete(): Bad alignment virtual address.\n");
+	if ((status_reg_value & TW_STATUS_EXPECTED_BITS) != TW_STATUS_EXPECTED_BITS) {  
+		dprintk(KERN_WARNING "3w-xxxx: tw_check_bits(): No expected bits (0x%x).\n", status_reg_value);
+		return 1;
+	}
+	if ((status_reg_value & TW_STATUS_UNEXPECTED_BITS) != 0) {
+		dprintk(KERN_WARNING "3w-xxxx: tw_check_bits(): Found unexpected bits (0x%x).\n", status_reg_value);
 		return 1;
 	}
-	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
-	aen = *(unsigned short *)(param->data);
-	dprintk(KERN_NOTICE "3w-xxxx: tw_aen_complete(): Queue'd code 0x%x\n", aen);
 
-	/* Print some useful info when certain aen codes come out */
-	if (aen == 0x0ff) {
-		printk(KERN_WARNING "3w-xxxx: scsi%d: AEN: INFO: AEN queue overflow.\n", tw_dev->host->host_no);
-	} else {
-		table_max = sizeof(tw_aen_string)/sizeof(char *);
-		if ((aen & 0x0ff) < table_max) {
-			if ((tw_aen_string[aen & 0xff][strlen(tw_aen_string[aen & 0xff])-1]) == '#') {
-				printk(KERN_WARNING "3w-xxxx: scsi%d: AEN: %s%d.\n", tw_dev->host->host_no, tw_aen_string[aen & 0xff], aen >> 8);
-			} else {
-				if (aen != 0x0) 
-					printk(KERN_WARNING "3w-xxxx: scsi%d: AEN: %s.\n", tw_dev->host->host_no, tw_aen_string[aen & 0xff]);
-			}
-		} else {
-			printk(KERN_WARNING "3w-xxxx: scsi%d: Received AEN %d.\n", tw_dev->host->host_no, aen);
-		}
+	return 0;
+} /* End tw_check_bits() */
+
+/* This function will print readable messages from status register errors */
+static int tw_decode_bits(TW_Device_Extension *tw_dev, u32 status_reg_value, int print_host)
+{
+	char host[16];
+
+	dprintk(KERN_WARNING "3w-xxxx: tw_decode_bits()\n");
+
+	if (print_host)
+		sprintf(host, " scsi%d:", tw_dev->host->host_no);
+	else
+		host[0] = '\0';
+
+	if (status_reg_value & TW_STATUS_PCI_PARITY_ERROR) {
+		printk(KERN_WARNING "3w-xxxx:%s PCI Parity Error: clearing.\n", host);
+		outl(TW_CONTROL_CLEAR_PARITY_ERROR, TW_CONTROL_REG_ADDR(tw_dev));
 	}
-	if (aen != TW_AEN_QUEUE_EMPTY) {
-		tw_dev->aen_count++;
 
-		/* Now queue the code */
-		tw_dev->aen_queue[tw_dev->aen_tail] = aen;
-		if (tw_dev->aen_tail == TW_Q_LENGTH - 1) {
-			tw_dev->aen_tail = TW_Q_START;
-		} else {
-			tw_dev->aen_tail = tw_dev->aen_tail + 1;
-		}
-		if (tw_dev->aen_head == tw_dev->aen_tail) {
-			if (tw_dev->aen_head == TW_Q_LENGTH - 1) {
-				tw_dev->aen_head = TW_Q_START;
-			} else {
-				tw_dev->aen_head = tw_dev->aen_head + 1;
-			}
-		}
+	if (status_reg_value & TW_STATUS_PCI_ABORT) {
+		printk(KERN_WARNING "3w-xxxx:%s PCI Abort: clearing.\n", host);
+		outl(TW_CONTROL_CLEAR_PCI_ABORT, TW_CONTROL_REG_ADDR(tw_dev));
+		pci_write_config_word(tw_dev->tw_pci_dev, PCI_STATUS, TW_PCI_CLEAR_PCI_ABORT);
+	}
 
-		error = tw_aen_read_queue(tw_dev, request_id);
-		if (error) {
-			printk(KERN_WARNING "3w-xxxx: scsi%d: Error completing AEN.\n", tw_dev->host->host_no);
-			tw_dev->state[request_id] = TW_S_COMPLETED;
-			tw_state_request_finish(tw_dev, request_id);
-		}
-	} else {
-		tw_dev->state[request_id] = TW_S_COMPLETED;
-		tw_state_request_finish(tw_dev, request_id);
+	if (status_reg_value & TW_STATUS_QUEUE_ERROR) {
+		printk(KERN_WARNING "3w-xxxx:%s Controller Queue Error: clearing.\n", host);
+		outl(TW_CONTROL_CLEAR_QUEUE_ERROR, TW_CONTROL_REG_ADDR(tw_dev));
+	}
+
+	if (status_reg_value & TW_STATUS_SBUF_WRITE_ERROR) {
+		printk(KERN_WARNING "3w-xxxx:%s SBUF Write Error: clearing.\n", host);
+		outl(TW_CONTROL_CLEAR_SBUF_WRITE_ERROR, TW_CONTROL_REG_ADDR(tw_dev));
 	}
 
+	if (status_reg_value & TW_STATUS_MICROCONTROLLER_ERROR) {
+		if (tw_dev->reset_print == 0) {
+			printk(KERN_WARNING "3w-xxxx:%s Microcontroller Error: clearing.\n", host);
+			tw_dev->reset_print = 1;
+		}
+		return 1;
+	}
+	
 	return 0;
-} /* End tw_aen_complete() */
+} /* End tw_decode_bits() */
 
-/* This function will drain the aen queue after a soft reset */
-int tw_aen_drain_queue(TW_Device_Extension *tw_dev)
+/* This function will poll the status register for a flag */
+static int tw_poll_status(TW_Device_Extension *tw_dev, u32 flag, int seconds)
 {
-	TW_Command *command_packet;
-	TW_Param *param;
-	int request_id = 0;
-	u32 command_que_addr;
-	unsigned long command_que_value;
-	unsigned long param_value;
-	TW_Response_Queue response_queue;
-	u32 response_que_addr;
-	unsigned short aen;
-	unsigned short aen_code;
-	int finished = 0;
-	int first_reset = 0;
-	int queue = 0;
-	int found = 0, table_max = 0;
+	u32 status_reg_value;
+	unsigned long before;
+	int retval = 1;
 
-	dprintk(KERN_NOTICE "3w-xxxx: tw_aen_drain_queue()\n");
+	status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
+	before = jiffies;
+
+	if (tw_check_bits(status_reg_value))
+		tw_decode_bits(tw_dev, status_reg_value, 0);
 
-	command_que_addr = tw_dev->registers.command_que_addr;
-	response_que_addr = tw_dev->registers.response_que_addr;
+	while ((status_reg_value & flag) != flag) {
+		status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
 
-	if (tw_poll_status(tw_dev, TW_STATUS_ATTENTION_INTERRUPT | TW_STATUS_MICROCONTROLLER_READY, 30)) {
-		dprintk(KERN_WARNING "3w-xxxx: tw_aen_drain_queue(): No attention interrupt for card %d.\n", tw_device_extension_count);
-		return 1;
+		if (tw_check_bits(status_reg_value))
+			tw_decode_bits(tw_dev, status_reg_value, 0);
+
+		if (time_after(jiffies, before + HZ * seconds))
+			goto out;
+
+		msleep(50);
 	}
-	tw_clear_attention_interrupt(tw_dev);
+	retval = 0;
+out:
+	return retval;
+} /* End tw_poll_status() */
 
-	/* Empty response queue */
-	tw_empty_response_que(tw_dev);
+/* This function will poll the status register for disappearance of a flag */
+static int tw_poll_status_gone(TW_Device_Extension *tw_dev, u32 flag, int seconds)
+{
+	u32 status_reg_value;
+	unsigned long before;
+	int retval = 1;
 
-	/* Initialize command packet */
-	if (tw_dev->command_packet_virtual_address[request_id] == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_aen_drain_queue(): Bad command packet virtual address.\n");
-		return 1;
+	status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
+	before = jiffies;
+
+	if (tw_check_bits(status_reg_value))
+		tw_decode_bits(tw_dev, status_reg_value, 0);
+
+	while ((status_reg_value & flag) != 0) {
+		status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
+
+		if (tw_check_bits(status_reg_value))
+			tw_decode_bits(tw_dev, status_reg_value, 0);
+
+		if (time_after(jiffies, before + HZ * seconds))
+			goto out;
+
+		msleep(50);
 	}
-	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
-	memset(command_packet, 0, sizeof(TW_Sector));
-	command_packet->byte0.opcode = TW_OP_GET_PARAM;
-	command_packet->byte0.sgl_offset = 2;
-	command_packet->size = 4;
-	command_packet->request_id = request_id;
-	command_packet->byte3.unit = 0;
-	command_packet->byte3.host_id = 0;
-	command_packet->status = 0;
-	command_packet->flags = 0;
-	command_packet->byte6.parameter_count = 1;
+	retval = 0;
+out:
+	return retval;
+} /* End tw_poll_status_gone() */
+
+/* This function will attempt to post a command packet to the board */
+static int tw_post_command_packet(TW_Device_Extension *tw_dev, int request_id)
+{
+	u32 status_reg_value;
+	unsigned long command_que_value;
+
+	dprintk(KERN_NOTICE "3w-xxxx: tw_post_command_packet()\n");
 	command_que_value = tw_dev->command_packet_physical_address[request_id];
-	if (command_que_value == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_aen_drain_queue(): Bad command packet physical address.\n");
-		return 1;
-	}
+	status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
 
-	/* Now setup the param */
-	if (tw_dev->alignment_virtual_address[request_id] == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_aen_drain_queue(): Bad alignment virtual address.\n");
-		return 1;
+	if (tw_check_bits(status_reg_value)) {
+		dprintk(KERN_WARNING "3w-xxxx: tw_post_command_packet(): Unexpected bits.\n");
+		tw_decode_bits(tw_dev, status_reg_value, 1);
 	}
-	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
-	memset(param, 0, sizeof(TW_Sector));
-	param->table_id = 0x401; /* AEN table */
-	param->parameter_id = 2; /* Unit code */
-	param->parameter_size_bytes = 2;
-	param_value = tw_dev->alignment_physical_address[request_id];
-	if (param_value == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_aen_drain_queue(): Bad alignment physical address.\n");
+
+	if ((status_reg_value & TW_STATUS_COMMAND_QUEUE_FULL) == 0) {
+		/* We successfully posted the command packet */
+		outl(command_que_value, TW_COMMAND_QUEUE_REG_ADDR(tw_dev));
+		tw_dev->state[request_id] = TW_S_POSTED;
+		tw_dev->posted_request_count++;
+		if (tw_dev->posted_request_count > tw_dev->max_posted_request_count) {
+			tw_dev->max_posted_request_count = tw_dev->posted_request_count;
+		}
+	} else {
+		/* Couldn't post the command packet, so we do it in the isr */
+		if (tw_dev->state[request_id] != TW_S_PENDING) {
+			tw_dev->state[request_id] = TW_S_PENDING;
+			tw_dev->pending_request_count++;
+			if (tw_dev->pending_request_count > tw_dev->max_pending_request_count) {
+				tw_dev->max_pending_request_count = tw_dev->pending_request_count;
+			}
+			tw_dev->pending_queue[tw_dev->pending_tail] = request_id;
+			if (tw_dev->pending_tail == TW_Q_LENGTH-1) {
+				tw_dev->pending_tail = TW_Q_START;
+			} else {
+				tw_dev->pending_tail = tw_dev->pending_tail + 1;
+			}
+		} 
+		TW_UNMASK_COMMAND_INTERRUPT(tw_dev);
 		return 1;
 	}
-	command_packet->byte8.param.sgl[0].address = param_value;
-	command_packet->byte8.param.sgl[0].length = sizeof(TW_Sector);
+	return 0;
+} /* End tw_post_command_packet() */
 
-	/* Now drain the controller's aen queue */
-	do {
-		/* Post command packet */
-		outl(command_que_value, command_que_addr);
+/* This function will return valid sense buffer information for failed cmds */
+static int tw_decode_sense(TW_Device_Extension *tw_dev, int request_id, int fill_sense)
+{
+	int i;
+	TW_Command *command;
 
-		/* Now poll for completion */
-		if (tw_poll_status_gone(tw_dev, TW_STATUS_RESPONSE_QUEUE_EMPTY, 30) == 0) {
-			response_queue.value = inl(response_que_addr);
-			request_id = (unsigned char)response_queue.u.response_id;
+        dprintk(KERN_WARNING "3w-xxxx: tw_decode_sense()\n");
+	command = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
 
-			if (request_id != 0) {
-				/* Unexpected request id */
-				printk(KERN_WARNING "3w-xxxx: tw_aen_drain_queue(): Unexpected request id.\n");
-				return 1;
-			}
-			
-			if (command_packet->status != 0) {
-				if (command_packet->flags != TW_AEN_TABLE_UNDEFINED) {
-					/* Bad response */
-					tw_decode_sense(tw_dev, request_id, 0);
-					return 1;
-				} else {
-					/* We know this is a 3w-1x00, and doesn't support aen's */
-					return 0;
-				}
-			}
+	printk(KERN_WARNING "3w-xxxx: scsi%d: Command failed: status = 0x%x, flags = 0x%x, unit #%d.\n", tw_dev->host->host_no, command->status, command->flags, TW_UNIT_OUT(command->unit__hostid));
 
-			/* Now check the aen */
-			aen = *(unsigned short *)(param->data);
-			aen_code = (aen & 0x0ff);
-			queue = 0;
-			switch (aen_code) {
-				case TW_AEN_QUEUE_EMPTY:
-					dprintk(KERN_WARNING "3w-xxxx: AEN: %s.\n", tw_aen_string[aen & 0xff]);
-					if (first_reset != 1) {
-						return 1;
-					} else {
-						finished = 1;
-					}
-					break;
-				case TW_AEN_SOFT_RESET:
-					if (first_reset == 0) {
-						first_reset = 1;
-					} else {
-						printk(KERN_WARNING "3w-xxxx: AEN: %s.\n", tw_aen_string[aen & 0xff]);
-						tw_dev->aen_count++;
-						queue = 1;
-					}
-					break;
-				default:
-					if (aen == 0x0ff) {
-						printk(KERN_WARNING "3w-xxxx: AEN: INFO: AEN queue overflow.\n");
-					} else {
-						table_max = sizeof(tw_aen_string)/sizeof(char *);
-						if ((aen & 0x0ff) < table_max) {
-							if ((tw_aen_string[aen & 0xff][strlen(tw_aen_string[aen & 0xff])-1]) == '#') {
-								printk(KERN_WARNING "3w-xxxx: AEN: %s%d.\n", tw_aen_string[aen & 0xff], aen >> 8);
-							} else {
-								printk(KERN_WARNING "3w-xxxx: AEN: %s.\n", tw_aen_string[aen & 0xff]);
-							}
-						} else
-							printk(KERN_WARNING "3w-xxxx: Received AEN %d.\n", aen);
-					}
-					tw_dev->aen_count++;
-					queue = 1;
-			}
+	/* Attempt to return intelligent sense information */
+	if (fill_sense) {
+		if ((command->status == 0xc7) || (command->status == 0xcb)) {
+			for (i=0;i<(sizeof(tw_sense_table)/sizeof(tw_sense_table[0]));i++) {
+				if (command->flags == tw_sense_table[i][0]) {
 
-			/* Now put the aen on the aen_queue */
-			if (queue == 1) {
-				tw_dev->aen_queue[tw_dev->aen_tail] = aen;
-				if (tw_dev->aen_tail == TW_Q_LENGTH - 1) {
-					tw_dev->aen_tail = TW_Q_START;
-				} else {
-					tw_dev->aen_tail = tw_dev->aen_tail + 1;
-				}
-				if (tw_dev->aen_head == tw_dev->aen_tail) {
-					if (tw_dev->aen_head == TW_Q_LENGTH - 1) {
-						tw_dev->aen_head = TW_Q_START;
-					} else {
-						tw_dev->aen_head = tw_dev->aen_head + 1;
-					}
+					/* Valid bit and 'current errors' */
+					tw_dev->srb[request_id]->sense_buffer[0] = (0x1 << 7 | 0x70);
+
+					/* Sense key */
+					tw_dev->srb[request_id]->sense_buffer[2] = tw_sense_table[i][1];
+
+					/* Additional sense length */
+					tw_dev->srb[request_id]->sense_buffer[7] = 0xa; /* 10 bytes */
+
+					/* Additional sense code */
+					tw_dev->srb[request_id]->sense_buffer[12] = tw_sense_table[i][2];
+
+					/* Additional sense code qualifier */
+					tw_dev->srb[request_id]->sense_buffer[13] = tw_sense_table[i][3];
+
+					tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
+					return TW_ISR_DONT_RESULT; /* Special case for isr to not over-write result */
 				}
 			}
-			found = 1;
-		}
-		if (found == 0) {
-			printk(KERN_WARNING "3w-xxxx: tw_aen_drain_queue(): Response never received.\n");
-			return 1;
 		}
-	} while (finished == 0);
+
+		/* If no table match, error so we get a reset */
+		return 1;
+	}
 
 	return 0;
-} /* End tw_aen_drain_queue() */
+} /* End tw_decode_sense() */
+
+/* This function will report controller error status */
+static int tw_check_errors(TW_Device_Extension *tw_dev) 
+{
+	u32 status_reg_value;
+  
+	status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
+
+	if (TW_STATUS_ERRORS(status_reg_value) || tw_check_bits(status_reg_value)) {
+		tw_decode_bits(tw_dev, status_reg_value, 0);
+		return 1;
+	}
+
+	return 0;
+} /* End tw_check_errors() */
+
+/* This function will empty the response que */
+static void tw_empty_response_que(TW_Device_Extension *tw_dev) 
+{
+	u32 status_reg_value, response_que_value;
+
+	status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
+
+	while ((status_reg_value & TW_STATUS_RESPONSE_QUEUE_EMPTY) == 0) {
+		response_que_value = inl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
+		status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
+	}
+} /* End tw_empty_response_que() */
+
+/* This function will free a request_id */
+static void tw_state_request_finish(TW_Device_Extension *tw_dev, int request_id)
+{
+	tw_dev->free_queue[tw_dev->free_tail] = request_id;
+	tw_dev->state[request_id] = TW_S_FINISHED;
+	tw_dev->free_tail = (tw_dev->free_tail + 1) % TW_Q_LENGTH;
+} /* End tw_state_request_finish() */
+
+/* This function will assign an available request_id */
+static void tw_state_request_start(TW_Device_Extension *tw_dev, int *request_id)
+{
+	*request_id = tw_dev->free_queue[tw_dev->free_head];
+	tw_dev->free_head = (tw_dev->free_head + 1) % TW_Q_LENGTH;
+	tw_dev->state[*request_id] = TW_S_STARTED;
+} /* End tw_state_request_start() */
+
+/* Show some statistics about the card */
+static ssize_t tw_show_stats(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(class_dev);
+	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
+	unsigned long flags = 0;
+	ssize_t len;
+
+	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+	len = snprintf(buf, PAGE_SIZE, "3w-xxxx Driver version: %s\n"
+		       "Current commands posted:   %4d\n"
+		       "Max commands posted:       %4d\n"
+		       "Current pending commands:  %4d\n"
+		       "Max pending commands:      %4d\n"
+		       "Last sgl length:           %4d\n"
+		       "Max sgl length:            %4d\n"
+		       "Last sector count:         %4d\n"
+		       "Max sector count:          %4d\n"
+		       "SCSI Host Resets:          %4d\n"
+		       "AEN's:                     %4d\n", 
+		       tw_driver_version,
+		       tw_dev->posted_request_count,
+		       tw_dev->max_posted_request_count,
+		       tw_dev->pending_request_count,
+		       tw_dev->max_pending_request_count,
+		       tw_dev->sgl_entries,
+		       tw_dev->max_sgl_entries,
+		       tw_dev->sector_count,
+		       tw_dev->max_sector_count,
+		       tw_dev->num_resets,
+		       tw_dev->aen_count);
+	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+	return len;
+} /* End tw_show_stats() */
+
+/* This function will set a devices queue depth */
+static ssize_t tw_store_queue_depth(struct device *dev, const char *buf, size_t count)
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
+} /* End tw_store_queue_depth() */
+
+/* Create sysfs 'queue_depth' entry */
+static struct device_attribute tw_queue_depth_attr = {
+	.attr = {
+		.name =		"queue_depth",
+		.mode =		S_IRUSR | S_IWUSR,
+	},
+	.store = tw_store_queue_depth
+};
+
+/* Device attributes initializer */
+static struct device_attribute *tw_dev_attrs[] = {
+	&tw_queue_depth_attr,
+	NULL,
+};
+
+/* Create sysfs 'stats' entry */
+static struct class_device_attribute tw_host_stats_attr = {
+	.attr = {
+		.name = 	"stats",
+		.mode =		S_IRUGO,
+	},
+	.show = tw_show_stats
+};
+
+/* Host attributes initializer */
+static struct class_device_attribute *tw_host_attrs[] = {
+	&tw_host_stats_attr,
+	NULL,
+};
 
 /* This function will read the aen queue from the isr */
-int tw_aen_read_queue(TW_Device_Extension *tw_dev, int request_id) 
+static int tw_aen_read_queue(TW_Device_Extension *tw_dev, int request_id) 
 {
 	TW_Command *command_packet;
 	TW_Param *param;
-	u32 command_que_addr;
 	unsigned long command_que_value;
-	u32 status_reg_value = 0, status_reg_addr;
+	u32 status_reg_value;
 	unsigned long param_value = 0;
 
 	dprintk(KERN_NOTICE "3w-xxxx: tw_aen_read_queue()\n");
-	command_que_addr = tw_dev->registers.command_que_addr;
-	status_reg_addr = tw_dev->registers.status_reg_addr;
 
-	status_reg_value = inl(status_reg_addr);
+	status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
 	if (tw_check_bits(status_reg_value)) {
 		dprintk(KERN_WARNING "3w-xxxx: tw_aen_read_queue(): Unexpected bits.\n");
 		tw_decode_bits(tw_dev, status_reg_value, 1);
@@ -516,12 +574,9 @@
 	}
 	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
 	memset(command_packet, 0, sizeof(TW_Sector));
-	command_packet->byte0.opcode = TW_OP_GET_PARAM;
-	command_packet->byte0.sgl_offset = 2;
+	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_GET_PARAM);
 	command_packet->size = 4;
 	command_packet->request_id = request_id;
-	command_packet->byte3.unit = 0;
-	command_packet->byte3.host_id = 0;
 	command_packet->status = 0;
 	command_packet->flags = 0;
 	command_packet->byte6.parameter_count = 1;
@@ -553,7 +608,7 @@
 		dprintk(KERN_WARNING "3w-xxxx: tw_aen_read_queue(): Post succeeded.\n");
 		tw_dev->srb[request_id] = 0; /* Flag internal command */
 		tw_dev->state[request_id] = TW_S_POSTED;
-		outl(command_que_value, command_que_addr);
+		outl(command_que_value, TW_COMMAND_QUEUE_REG_ADDR(tw_dev));
 	} else {
 		printk(KERN_WARNING "3w-xxxx: tw_aen_read_queue(): Post failed, will retry.\n");
 		return 1;
@@ -562,85 +617,276 @@
 	return 0;
 } /* End tw_aen_read_queue() */
 
-/* This function will allocate memory */
-int tw_allocate_memory(TW_Device_Extension *tw_dev, int size, int which)
+/* This function will complete an aen request from the isr */
+static int tw_aen_complete(TW_Device_Extension *tw_dev, int request_id) 
 {
-	int i;
-	dma_addr_t dma_handle;
-	unsigned long *cpu_addr = NULL;
-
-	dprintk(KERN_NOTICE "3w-xxxx: tw_allocate_memory()\n");
+	TW_Param *param;
+	unsigned short aen;
+	int error = 0, table_max = 0;
 
-	cpu_addr = pci_alloc_consistent(tw_dev->tw_pci_dev, size*TW_Q_LENGTH, &dma_handle);
-	if (cpu_addr == NULL) {
-		printk(KERN_WARNING "3w-xxxx: pci_alloc_consistent() failed.\n");
+	dprintk(KERN_WARNING "3w-xxxx: tw_aen_complete()\n");
+	if (tw_dev->alignment_virtual_address[request_id] == NULL) {
+		printk(KERN_WARNING "3w-xxxx: tw_aen_complete(): Bad alignment virtual address.\n");
 		return 1;
 	}
+	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
+	aen = *(unsigned short *)(param->data);
+	dprintk(KERN_NOTICE "3w-xxxx: tw_aen_complete(): Queue'd code 0x%x\n", aen);
 
-	if ((unsigned long)cpu_addr % (tw_dev->tw_pci_dev->device == TW_DEVICE_ID ? TW_ALIGNMENT_6000 : TW_ALIGNMENT_7000)) {
-		printk(KERN_WARNING "3w-xxxx: Couldn't allocate correctly aligned memory.\n");
-		pci_free_consistent(tw_dev->tw_pci_dev, size*TW_Q_LENGTH, cpu_addr, dma_handle);
-		return 1;
+	/* Print some useful info when certain aen codes come out */
+	if (aen == 0x0ff) {
+		printk(KERN_WARNING "3w-xxxx: scsi%d: AEN: INFO: AEN queue overflow.\n", tw_dev->host->host_no);
+	} else {
+		table_max = sizeof(tw_aen_string)/sizeof(char *);
+		if ((aen & 0x0ff) < table_max) {
+			if ((tw_aen_string[aen & 0xff][strlen(tw_aen_string[aen & 0xff])-1]) == '#') {
+				printk(KERN_WARNING "3w-xxxx: scsi%d: AEN: %s%d.\n", tw_dev->host->host_no, tw_aen_string[aen & 0xff], aen >> 8);
+			} else {
+				if (aen != 0x0) 
+					printk(KERN_WARNING "3w-xxxx: scsi%d: AEN: %s.\n", tw_dev->host->host_no, tw_aen_string[aen & 0xff]);
+			}
+		} else {
+			printk(KERN_WARNING "3w-xxxx: scsi%d: Received AEN %d.\n", tw_dev->host->host_no, aen);
+		}
 	}
+	if (aen != TW_AEN_QUEUE_EMPTY) {
+		tw_dev->aen_count++;
 
-	memset(cpu_addr, 0, size*TW_Q_LENGTH);
+		/* Now queue the code */
+		tw_dev->aen_queue[tw_dev->aen_tail] = aen;
+		if (tw_dev->aen_tail == TW_Q_LENGTH - 1) {
+			tw_dev->aen_tail = TW_Q_START;
+		} else {
+			tw_dev->aen_tail = tw_dev->aen_tail + 1;
+		}
+		if (tw_dev->aen_head == tw_dev->aen_tail) {
+			if (tw_dev->aen_head == TW_Q_LENGTH - 1) {
+				tw_dev->aen_head = TW_Q_START;
+			} else {
+				tw_dev->aen_head = tw_dev->aen_head + 1;
+			}
+		}
 
-	for (i=0;i<TW_Q_LENGTH;i++) {
-		switch(which) {
-		case 0:
-			tw_dev->command_packet_physical_address[i] = dma_handle+(i*size);
-			tw_dev->command_packet_virtual_address[i] = (unsigned long *)((unsigned char *)cpu_addr + (i*size));
-			break;
-		case 1:
-			tw_dev->alignment_physical_address[i] = dma_handle+(i*size);
-			tw_dev->alignment_virtual_address[i] = (unsigned long *)((unsigned char *)cpu_addr + (i*size));
-			break;
-		default:
-			printk(KERN_WARNING "3w-xxxx: tw_allocate_memory(): case slip in tw_allocate_memory()\n");
-			return 1;
+		error = tw_aen_read_queue(tw_dev, request_id);
+		if (error) {
+			printk(KERN_WARNING "3w-xxxx: scsi%d: Error completing AEN.\n", tw_dev->host->host_no);
+			tw_dev->state[request_id] = TW_S_COMPLETED;
+			tw_state_request_finish(tw_dev, request_id);
 		}
+	} else {
+		tw_dev->state[request_id] = TW_S_COMPLETED;
+		tw_state_request_finish(tw_dev, request_id);
 	}
 
 	return 0;
-} /* End tw_allocate_memory() */
+} /* End tw_aen_complete() */
 
-/* This function will check the status register for unexpected bits */
-int tw_check_bits(u32 status_reg_value)
+/* This function will drain the aen queue after a soft reset */
+static int tw_aen_drain_queue(TW_Device_Extension *tw_dev)
 {
-	if ((status_reg_value & TW_STATUS_EXPECTED_BITS) != TW_STATUS_EXPECTED_BITS) {  
-		dprintk(KERN_WARNING "3w-xxxx: tw_check_bits(): No expected bits (0x%x).\n", status_reg_value);
-		return 1;
-	}
-	if ((status_reg_value & TW_STATUS_UNEXPECTED_BITS) != 0) {
-		dprintk(KERN_WARNING "3w-xxxx: tw_check_bits(): Found unexpected bits (0x%x).\n", status_reg_value);
-		return 1;
-	}
-
-	return 0;
-} /* End tw_check_bits() */
+	TW_Command *command_packet;
+	TW_Param *param;
+	int request_id = 0;
+	unsigned long command_que_value;
+	unsigned long param_value;
+	TW_Response_Queue response_queue;
+	unsigned short aen;
+	unsigned short aen_code;
+	int finished = 0;
+	int first_reset = 0;
+	int queue = 0;
+	int found = 0, table_max = 0;
 
-/* This function will report controller error status */
-int tw_check_errors(TW_Device_Extension *tw_dev) 
-{
-	u32 status_reg_addr, status_reg_value;
-  
-	status_reg_addr = tw_dev->registers.status_reg_addr;
-	status_reg_value = inl(status_reg_addr);
+	dprintk(KERN_NOTICE "3w-xxxx: tw_aen_drain_queue()\n");
 
-	if (TW_STATUS_ERRORS(status_reg_value) || tw_check_bits(status_reg_value)) {
-		tw_decode_bits(tw_dev, status_reg_value, 0);
+	if (tw_poll_status(tw_dev, TW_STATUS_ATTENTION_INTERRUPT | TW_STATUS_MICROCONTROLLER_READY, 30)) {
+		dprintk(KERN_WARNING "3w-xxxx: tw_aen_drain_queue(): No attention interrupt for card %d.\n", tw_device_extension_count);
 		return 1;
 	}
+	TW_CLEAR_ATTENTION_INTERRUPT(tw_dev);
 
-	return 0;
-} /* End tw_check_errors() */
+	/* Empty response queue */
+	tw_empty_response_que(tw_dev);
 
-/* This function handles ioctl for the character device */
-static int tw_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
-{
-	int error, request_id;
-	dma_addr_t dma_handle;
-	unsigned short tw_aen_code;
+	/* Initialize command packet */
+	if (tw_dev->command_packet_virtual_address[request_id] == NULL) {
+		printk(KERN_WARNING "3w-xxxx: tw_aen_drain_queue(): Bad command packet virtual address.\n");
+		return 1;
+	}
+	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
+	memset(command_packet, 0, sizeof(TW_Sector));
+	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_GET_PARAM);
+	command_packet->size = 4;
+	command_packet->request_id = request_id;
+	command_packet->status = 0;
+	command_packet->flags = 0;
+	command_packet->byte6.parameter_count = 1;
+	command_que_value = tw_dev->command_packet_physical_address[request_id];
+	if (command_que_value == 0) {
+		printk(KERN_WARNING "3w-xxxx: tw_aen_drain_queue(): Bad command packet physical address.\n");
+		return 1;
+	}
+
+	/* Now setup the param */
+	if (tw_dev->alignment_virtual_address[request_id] == NULL) {
+		printk(KERN_WARNING "3w-xxxx: tw_aen_drain_queue(): Bad alignment virtual address.\n");
+		return 1;
+	}
+	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
+	memset(param, 0, sizeof(TW_Sector));
+	param->table_id = 0x401; /* AEN table */
+	param->parameter_id = 2; /* Unit code */
+	param->parameter_size_bytes = 2;
+	param_value = tw_dev->alignment_physical_address[request_id];
+	if (param_value == 0) {
+		printk(KERN_WARNING "3w-xxxx: tw_aen_drain_queue(): Bad alignment physical address.\n");
+		return 1;
+	}
+	command_packet->byte8.param.sgl[0].address = param_value;
+	command_packet->byte8.param.sgl[0].length = sizeof(TW_Sector);
+
+	/* Now drain the controller's aen queue */
+	do {
+		/* Post command packet */
+		outl(command_que_value, TW_COMMAND_QUEUE_REG_ADDR(tw_dev));
+
+		/* Now poll for completion */
+		if (tw_poll_status_gone(tw_dev, TW_STATUS_RESPONSE_QUEUE_EMPTY, 30) == 0) {
+			response_queue.value = inl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
+			request_id = TW_RESID_OUT(response_queue.response_id);
+
+			if (request_id != 0) {
+				/* Unexpected request id */
+				printk(KERN_WARNING "3w-xxxx: tw_aen_drain_queue(): Unexpected request id.\n");
+				return 1;
+			}
+			
+			if (command_packet->status != 0) {
+				if (command_packet->flags != TW_AEN_TABLE_UNDEFINED) {
+					/* Bad response */
+					tw_decode_sense(tw_dev, request_id, 0);
+					return 1;
+				} else {
+					/* We know this is a 3w-1x00, and doesn't support aen's */
+					return 0;
+				}
+			}
+
+			/* Now check the aen */
+			aen = *(unsigned short *)(param->data);
+			aen_code = (aen & 0x0ff);
+			queue = 0;
+			switch (aen_code) {
+				case TW_AEN_QUEUE_EMPTY:
+					dprintk(KERN_WARNING "3w-xxxx: AEN: %s.\n", tw_aen_string[aen & 0xff]);
+					if (first_reset != 1) {
+						return 1;
+					} else {
+						finished = 1;
+					}
+					break;
+				case TW_AEN_SOFT_RESET:
+					if (first_reset == 0) {
+						first_reset = 1;
+					} else {
+						printk(KERN_WARNING "3w-xxxx: AEN: %s.\n", tw_aen_string[aen & 0xff]);
+						tw_dev->aen_count++;
+						queue = 1;
+					}
+					break;
+				default:
+					if (aen == 0x0ff) {
+						printk(KERN_WARNING "3w-xxxx: AEN: INFO: AEN queue overflow.\n");
+					} else {
+						table_max = sizeof(tw_aen_string)/sizeof(char *);
+						if ((aen & 0x0ff) < table_max) {
+							if ((tw_aen_string[aen & 0xff][strlen(tw_aen_string[aen & 0xff])-1]) == '#') {
+								printk(KERN_WARNING "3w-xxxx: AEN: %s%d.\n", tw_aen_string[aen & 0xff], aen >> 8);
+							} else {
+								printk(KERN_WARNING "3w-xxxx: AEN: %s.\n", tw_aen_string[aen & 0xff]);
+							}
+						} else
+							printk(KERN_WARNING "3w-xxxx: Received AEN %d.\n", aen);
+					}
+					tw_dev->aen_count++;
+					queue = 1;
+			}
+
+			/* Now put the aen on the aen_queue */
+			if (queue == 1) {
+				tw_dev->aen_queue[tw_dev->aen_tail] = aen;
+				if (tw_dev->aen_tail == TW_Q_LENGTH - 1) {
+					tw_dev->aen_tail = TW_Q_START;
+				} else {
+					tw_dev->aen_tail = tw_dev->aen_tail + 1;
+				}
+				if (tw_dev->aen_head == tw_dev->aen_tail) {
+					if (tw_dev->aen_head == TW_Q_LENGTH - 1) {
+						tw_dev->aen_head = TW_Q_START;
+					} else {
+						tw_dev->aen_head = tw_dev->aen_head + 1;
+					}
+				}
+			}
+			found = 1;
+		}
+		if (found == 0) {
+			printk(KERN_WARNING "3w-xxxx: tw_aen_drain_queue(): Response never received.\n");
+			return 1;
+		}
+	} while (finished == 0);
+
+	return 0;
+} /* End tw_aen_drain_queue() */
+
+/* This function will allocate memory */
+static int tw_allocate_memory(TW_Device_Extension *tw_dev, int size, int which)
+{
+	int i;
+	dma_addr_t dma_handle;
+	unsigned long *cpu_addr = NULL;
+
+	dprintk(KERN_NOTICE "3w-xxxx: tw_allocate_memory()\n");
+
+	cpu_addr = pci_alloc_consistent(tw_dev->tw_pci_dev, size*TW_Q_LENGTH, &dma_handle);
+	if (cpu_addr == NULL) {
+		printk(KERN_WARNING "3w-xxxx: pci_alloc_consistent() failed.\n");
+		return 1;
+	}
+
+	if ((unsigned long)cpu_addr % (tw_dev->tw_pci_dev->device == TW_DEVICE_ID ? TW_ALIGNMENT_6000 : TW_ALIGNMENT_7000)) {
+		printk(KERN_WARNING "3w-xxxx: Couldn't allocate correctly aligned memory.\n");
+		pci_free_consistent(tw_dev->tw_pci_dev, size*TW_Q_LENGTH, cpu_addr, dma_handle);
+		return 1;
+	}
+
+	memset(cpu_addr, 0, size*TW_Q_LENGTH);
+
+	for (i=0;i<TW_Q_LENGTH;i++) {
+		switch(which) {
+		case 0:
+			tw_dev->command_packet_physical_address[i] = dma_handle+(i*size);
+			tw_dev->command_packet_virtual_address[i] = (unsigned long *)((unsigned char *)cpu_addr + (i*size));
+			break;
+		case 1:
+			tw_dev->alignment_physical_address[i] = dma_handle+(i*size);
+			tw_dev->alignment_virtual_address[i] = (unsigned long *)((unsigned char *)cpu_addr + (i*size));
+			break;
+		default:
+			printk(KERN_WARNING "3w-xxxx: tw_allocate_memory(): case slip in tw_allocate_memory()\n");
+			return 1;
+		}
+	}
+
+	return 0;
+} /* End tw_allocate_memory() */
+
+/* This function handles ioctl for the character device */
+static int tw_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int error, request_id;
+	dma_addr_t dma_handle;
+	unsigned short tw_aen_code;
 	unsigned long flags;
 	unsigned int data_buffer_length = 0;
 	unsigned long data_buffer_length_adjusted = 0;
@@ -713,7 +959,7 @@
 			break;
 		case TW_CMD_PACKET_WITH_DATA:
 			dprintk(KERN_WARNING "3w-xxxx: tw_chrdev_ioctl(): caught TW_CMD_PACKET_WITH_DATA.\n");
-			spin_lock_irqsave(&tw_dev->tw_lock, flags);
+			spin_lock_irqsave(tw_dev->host->host_lock, flags);
 
 			tw_state_request_start(tw_dev, &request_id);
 
@@ -726,7 +972,7 @@
 			tw_ioctl->firmware_command.request_id = request_id;
 
 			/* Load the sg list */
-			switch (tw_ioctl->firmware_command.byte0.sgl_offset) {
+			switch (TW_SGL_OUT(tw_ioctl->firmware_command.opcode__sgloffset)) {
 			case 2:
 				tw_ioctl->firmware_command.byte8.param.sgl[0].address = dma_handle + sizeof(TW_New_Ioctl) - 1;
 				tw_ioctl->firmware_command.byte8.param.sgl[0].length = data_buffer_length_adjusted;
@@ -745,13 +991,20 @@
 
 			/* Now post the command packet to the controller */
 			tw_post_command_packet(tw_dev, request_id);
-			spin_unlock_irqrestore(&tw_dev->tw_lock, flags);
+			spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
 
 			timeout = TW_IOCTL_CHRDEV_TIMEOUT*HZ;
 
 			/* Now wait for the command to complete */
 			timeout = wait_event_interruptible_timeout(tw_dev->ioctl_wqueue, tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE, timeout);
 
+			/* See if we reset while waiting for the ioctl to complete */
+			if (test_bit(TW_IN_RESET, &tw_dev->flags)) {
+				clear_bit(TW_IN_RESET, &tw_dev->flags);
+				retval = -ERESTARTSYS;
+				goto out2;
+			}
+
 			/* Check if we timed out, got a signal, or didn't get
 			   an interrupt */
 			if ((timeout <= 0) && (tw_dev->chrdev_request_id != TW_IOCTL_CHRDEV_FREE)) {
@@ -762,14 +1015,14 @@
 					printk(KERN_WARNING "3w-xxxx: scsi%d: Character ioctl (0x%x) timed out, resetting card.\n", tw_dev->host->host_no, cmd);
 					retval = -EIO;
 				}
-				spin_lock_irqsave(&tw_dev->tw_lock, flags);
+				spin_lock_irqsave(tw_dev->host->host_lock, flags);
 				tw_dev->state[request_id] = TW_S_COMPLETED;
 				tw_state_request_finish(tw_dev, request_id);
 				tw_dev->posted_request_count--;
-				if (tw_reset_device_extension(tw_dev)) {
+				spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+				if (tw_reset_device_extension(tw_dev, 1)) {
 					printk(KERN_WARNING "3w-xxxx: tw_chrdev_ioctl(): Reset failed for card %d.\n", tw_dev->host->host_no);
 				}
-				spin_unlock_irqrestore(&tw_dev->tw_lock, flags);
 				goto out2;
 			}
 
@@ -777,11 +1030,11 @@
 			memcpy(&(tw_ioctl->firmware_command), tw_dev->command_packet_virtual_address[request_id], sizeof(TW_Command));
 
 			/* Now complete the io */
-			spin_lock_irqsave(&tw_dev->tw_lock, flags);
+			spin_lock_irqsave(tw_dev->host->host_lock, flags);
 			tw_dev->posted_request_count--;
 			tw_dev->state[request_id] = TW_S_COMPLETED;
 			tw_state_request_finish(tw_dev, request_id);
-			spin_unlock_irqrestore(&tw_dev->tw_lock, flags);
+			spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
 			break;
 		default:
 			retval = -ENOTTY;
@@ -814,522 +1067,139 @@
 	return 0;
 } /* End tw_chrdev_open() */
 
-/* This function handles close for the character device */
-static int tw_chrdev_release(struct inode *inode, struct file *file)
-{
-	dprintk(KERN_WARNING "3w-xxxx: tw_ioctl_release()\n");
-
-	return 0;
-} /* End tw_chrdev_release() */
-
-/* This function will clear all interrupts on the controller */
-void tw_clear_all_interrupts(TW_Device_Extension *tw_dev)
-{
-	u32 control_reg_addr, control_reg_value;
-
-	control_reg_addr = tw_dev->registers.control_reg_addr;
-	control_reg_value = TW_STATUS_VALID_INTERRUPT;
-	outl(control_reg_value, control_reg_addr);
-} /* End tw_clear_all_interrupts() */
+/* File operations struct for character device */
+static struct file_operations tw_fops = {
+	.owner		= THIS_MODULE,
+	.ioctl		= tw_chrdev_ioctl,
+	.open		= tw_chrdev_open,
+	.release	= NULL
+};
 
-/* This function will clear the attention interrupt */
-void tw_clear_attention_interrupt(TW_Device_Extension *tw_dev)
+/* This function will free up device extension resources */
+static void tw_free_device_extension(TW_Device_Extension *tw_dev)
 {
-	u32 control_reg_addr, control_reg_value;
-  
-	control_reg_addr = tw_dev->registers.control_reg_addr;
-	control_reg_value = TW_CONTROL_CLEAR_ATTENTION_INTERRUPT;
-	outl(control_reg_value, control_reg_addr);
-} /* End tw_clear_attention_interrupt() */
-
-/* This function will clear the host interrupt */
-void tw_clear_host_interrupt(TW_Device_Extension *tw_dev)
-{
-	u32 control_reg_addr, control_reg_value;
-
-	control_reg_addr = tw_dev->registers.control_reg_addr;
-	control_reg_value = TW_CONTROL_CLEAR_HOST_INTERRUPT;
-	outl(control_reg_value, control_reg_addr);
-} /* End tw_clear_host_interrupt() */
-
-/* This function is called by tw_scsi_proc_info */
-static int tw_copy_info(TW_Info *info, char *fmt, ...) 
-{
-	va_list args;
-	char buf[81];
-	int len;
-  
-	va_start(args, fmt);
-	len = vsprintf(buf, fmt, args);
-	va_end(args);
-	tw_copy_mem_info(info, buf, len);
-	return len;
-} /* End tw_copy_info() */
+	dprintk(KERN_NOTICE "3w-xxxx: tw_free_device_extension()\n");
 
-/* This function is called by tw_scsi_proc_info */
-static void tw_copy_mem_info(TW_Info *info, char *data, int len)
-{
-	if (info->position + len > info->length)
-		len = info->length - info->position;
+	/* Free command packet and generic buffer memory */
+	if (tw_dev->command_packet_virtual_address[0])
+		pci_free_consistent(tw_dev->tw_pci_dev, sizeof(TW_Command)*TW_Q_LENGTH, tw_dev->command_packet_virtual_address[0], tw_dev->command_packet_physical_address[0]);
 
-	if (info->position + len < info->offset) {
-		info->position += len;
-		return;
-	}
-	if (info->position < info->offset) {
-		data += (info->offset - info->position);
-		len  -= (info->offset - info->position);
-	}
-	if (len > 0) {
-		memcpy(info->buffer + info->position, data, len);
-		info->position += len;
-	}
-} /* End tw_copy_mem_info() */
+	if (tw_dev->alignment_virtual_address[0])
+		pci_free_consistent(tw_dev->tw_pci_dev, sizeof(TW_Sector)*TW_Q_LENGTH, tw_dev->alignment_virtual_address[0], tw_dev->alignment_physical_address[0]);
+} /* End tw_free_device_extension() */
 
-/* This function will print readable messages from status register errors */
-int tw_decode_bits(TW_Device_Extension *tw_dev, u32 status_reg_value, int print_host)
+/* This function will send an initconnection command to controller */
+static int tw_initconnection(TW_Device_Extension *tw_dev, int message_credits) 
 {
-	char host[16];
-
-	dprintk(KERN_WARNING "3w-xxxx: tw_decode_bits()\n");
-
-	if (print_host)
-		sprintf(host, " scsi%d:", tw_dev->host->host_no);
-	else
-		host[0] = '\0';
-
-	if (status_reg_value & TW_STATUS_PCI_PARITY_ERROR) {
-		printk(KERN_WARNING "3w-xxxx:%s PCI Parity Error: clearing.\n", host);
-		outl(TW_CONTROL_CLEAR_PARITY_ERROR, tw_dev->registers.control_reg_addr);
-	}
+	unsigned long command_que_value;
+	TW_Command  *command_packet;
+	TW_Response_Queue response_queue;
+	int request_id = 0;
 
-	if (status_reg_value & TW_STATUS_PCI_ABORT) {
-		printk(KERN_WARNING "3w-xxxx:%s PCI Abort: clearing.\n", host);
-		outl(TW_CONTROL_CLEAR_PCI_ABORT, tw_dev->registers.control_reg_addr);
-		pci_write_config_word(tw_dev->tw_pci_dev, PCI_STATUS, TW_PCI_CLEAR_PCI_ABORT);
-	}
+	dprintk(KERN_NOTICE "3w-xxxx: tw_initconnection()\n");
 
-	if (status_reg_value & TW_STATUS_QUEUE_ERROR) {
-		printk(KERN_WARNING "3w-xxxx:%s Controller Queue Error: clearing.\n", host);
-		outl(TW_CONTROL_CLEAR_QUEUE_ERROR, tw_dev->registers.control_reg_addr);
+	/* Initialize InitConnection command packet */
+	if (tw_dev->command_packet_virtual_address[request_id] == NULL) {
+		printk(KERN_WARNING "3w-xxxx: tw_initconnection(): Bad command packet virtual address.\n");
+		return 1;
 	}
 
-	if (status_reg_value & TW_STATUS_SBUF_WRITE_ERROR) {
-		printk(KERN_WARNING "3w-xxxx:%s SBUF Write Error: clearing.\n", host);
-		outl(TW_CONTROL_CLEAR_SBUF_WRITE_ERROR, tw_dev->registers.control_reg_addr);
-	}
+	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
+	memset(command_packet, 0, sizeof(TW_Sector));
+	command_packet->opcode__sgloffset = TW_OPSGL_IN(0, TW_OP_INIT_CONNECTION);
+	command_packet->size = TW_INIT_COMMAND_PACKET_SIZE;
+	command_packet->request_id = request_id;
+	command_packet->status = 0x0;
+	command_packet->flags = 0x0;
+	command_packet->byte6.message_credits = message_credits; 
+	command_packet->byte8.init_connection.response_queue_pointer = 0x0;
+	command_que_value = tw_dev->command_packet_physical_address[request_id];
 
-	if (status_reg_value & TW_STATUS_MICROCONTROLLER_ERROR) {
-		if (tw_dev->reset_print == 0) {
-			printk(KERN_WARNING "3w-xxxx:%s Microcontroller Error: clearing.\n", host);
-			tw_dev->reset_print = 1;
-		}
+	if (command_que_value == 0) {
+		printk(KERN_WARNING "3w-xxxx: tw_initconnection(): Bad command packet physical address.\n");
 		return 1;
 	}
-	
-	return 0;
-} /* End tw_decode_bits() */
-
-/* This function will return valid sense buffer information for failed cmds */
-int tw_decode_sense(TW_Device_Extension *tw_dev, int request_id, int fill_sense)
-{
-	int i;
-	TW_Command *command;
-
-        dprintk(KERN_WARNING "3w-xxxx: tw_decode_sense()\n");
-	command = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
-
-	printk(KERN_WARNING "3w-xxxx: scsi%d: Command failed: status = 0x%x, flags = 0x%x, unit #%d.\n", tw_dev->host->host_no, command->status, command->flags, command->byte3.unit);
-
-	/* Attempt to return intelligent sense information */
-	if (fill_sense) {
-		if ((command->status == 0xc7) || (command->status == 0xcb)) {
-			for (i=0;i<(sizeof(tw_sense_table)/sizeof(tw_sense_table[0]));i++) {
-				if (command->flags == tw_sense_table[i][0]) {
-
-					/* Valid bit and 'current errors' */
-					tw_dev->srb[request_id]->sense_buffer[0] = (0x1 << 7 | 0x70);
-
-					/* Sense key */
-					tw_dev->srb[request_id]->sense_buffer[2] = tw_sense_table[i][1];
-
-					/* Additional sense length */
-					tw_dev->srb[request_id]->sense_buffer[7] = 0xa; /* 10 bytes */
-
-					/* Additional sense code */
-					tw_dev->srb[request_id]->sense_buffer[12] = tw_sense_table[i][2];
-
-					/* Additional sense code qualifier */
-					tw_dev->srb[request_id]->sense_buffer[13] = tw_sense_table[i][3];
-
-					tw_dev->srb[request_id]->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
-					return TW_ISR_DONT_RESULT; /* Special case for isr to not over-write result */
-				}
-			}
-		}
-
-		/* If no table match, error so we get a reset */
-		return 1;
-	}
-
-	return 0;
-} /* End tw_decode_sense() */
-
-/* This function will disable interrupts on the controller */  
-void tw_disable_interrupts(TW_Device_Extension *tw_dev) 
-{
-	u32 control_reg_value, control_reg_addr;
-
-	control_reg_addr = tw_dev->registers.control_reg_addr;
-	control_reg_value = TW_CONTROL_DISABLE_INTERRUPTS;
-	outl(control_reg_value, control_reg_addr);
-} /* End tw_disable_interrupts() */
-
-/* This function will empty the response que */
-void tw_empty_response_que(TW_Device_Extension *tw_dev) 
-{
-	u32 status_reg_addr, status_reg_value;
-	u32 response_que_addr, response_que_value;
-
-	status_reg_addr = tw_dev->registers.status_reg_addr;
-	response_que_addr = tw_dev->registers.response_que_addr;
   
-	status_reg_value = inl(status_reg_addr);
-
-	while ((status_reg_value & TW_STATUS_RESPONSE_QUEUE_EMPTY) == 0) {
-		response_que_value = inl(response_que_addr);
-		status_reg_value = inl(status_reg_addr);
-	}
-} /* End tw_empty_response_que() */
-
-/* This function will enable interrupts on the controller */
-void tw_enable_interrupts(TW_Device_Extension *tw_dev)
-{
-	u32 control_reg_value, control_reg_addr;
-
-	control_reg_addr = tw_dev->registers.control_reg_addr;
-	control_reg_value = (TW_CONTROL_ENABLE_INTERRUPTS |
-			     TW_CONTROL_UNMASK_RESPONSE_INTERRUPT);
-	outl(control_reg_value, control_reg_addr);
-} /* End tw_enable_interrupts() */
-
-/* This function will enable interrupts on the controller */
-void tw_enable_and_clear_interrupts(TW_Device_Extension *tw_dev)
-{
-	u32 control_reg_value, control_reg_addr;
-
-	control_reg_addr = tw_dev->registers.control_reg_addr;
-	control_reg_value = (TW_CONTROL_CLEAR_ATTENTION_INTERRUPT |
-			     TW_CONTROL_UNMASK_RESPONSE_INTERRUPT |
-			     TW_CONTROL_ENABLE_INTERRUPTS);
-	outl(control_reg_value, control_reg_addr);
-} /* End tw_enable_and_clear_interrupts() */
-
-/* This function will find and initialize all cards */
-int tw_findcards(Scsi_Host_Template *tw_host) 
-{
-	int numcards = 0, tries = 0, error = 0;
-	struct Scsi_Host *host;
-	TW_Device_Extension *tw_dev;
-	TW_Device_Extension *tw_dev2;
-	struct pci_dev *tw_pci_dev = NULL;
-	u32 status_reg_value;
-	unsigned char c = 1;
-	int i, j = -1;
-	u16 device[TW_NUMDEVICES] = { TW_DEVICE_ID, TW_DEVICE_ID2 };
-
-	dprintk(KERN_NOTICE "3w-xxxx: tw_findcards()\n");
-
-	for (i=0;i<TW_NUMDEVICES;i++) {
-		while ((tw_pci_dev = pci_find_device(TW_VENDOR_ID, device[i], tw_pci_dev))) {
-			j++;
-			if (pci_enable_device(tw_pci_dev))
-				continue;
-
-			/* We only need 32-bit addressing for 5,6,7xxx cards */
-			if (pci_set_dma_mask(tw_pci_dev, 0xffffffff)) {
-				printk(KERN_WARNING "3w-xxxx: No suitable DMA available.\n");
-				continue;
-			}
-
-			/* Prepare temporary device extension */
-			tw_dev=(TW_Device_Extension *)kmalloc(sizeof(TW_Device_Extension), GFP_ATOMIC);
-			if (tw_dev == NULL) {
-				printk(KERN_WARNING "3w-xxxx: tw_findcards(): kmalloc() failed for card %d.\n", j);
-				continue;
-			}
-			memset(tw_dev, 0, sizeof(TW_Device_Extension));
-			
-			/* Save pci_dev struct to device extension */
-			tw_dev->tw_pci_dev = tw_pci_dev;
-
-			error = tw_initialize_device_extension(tw_dev);
-			if (error) {
-				printk(KERN_WARNING "3w-xxxx: tw_findcards(): Couldn't initialize device extension for card %d.\n", j);
-				tw_free_device_extension(tw_dev);
-				kfree(tw_dev);
-				continue;
-			}
-
-			/* Calculate the cards register addresses */
-			tw_dev->registers.base_addr = pci_resource_start(tw_pci_dev, 0);
-			tw_dev->registers.control_reg_addr = pci_resource_start(tw_pci_dev, 0);
-			tw_dev->registers.status_reg_addr = pci_resource_start(tw_pci_dev, 0) + 0x4;
-			tw_dev->registers.command_que_addr = pci_resource_start(tw_pci_dev, 0) + 0x8;
-			tw_dev->registers.response_que_addr = pci_resource_start(tw_pci_dev, 0) + 0xC;
-
-			/* Check for errors and clear them */
-			status_reg_value = inl(tw_dev->registers.status_reg_addr);
-			if (TW_STATUS_ERRORS(status_reg_value))
-				tw_decode_bits(tw_dev, status_reg_value, 0);
-			
-			/* Poll status register for 60 secs for 'Controller Ready' flag */
-			if (tw_poll_status(tw_dev, TW_STATUS_MICROCONTROLLER_READY, 60)) {
-				printk(KERN_WARNING "3w-xxxx: tw_findcards(): Microcontroller not ready for card %d.\n", j);
-				tw_free_device_extension(tw_dev);
-				kfree(tw_dev);
-				continue;
-			}
-
-			/* Disable interrupts on the card */
-			tw_disable_interrupts(tw_dev);
-
-			tries = 0;
-
-			while (tries < TW_MAX_RESET_TRIES) {
-				/* Do soft reset */
-				tw_soft_reset(tw_dev);
-			  
-				error = tw_aen_drain_queue(tw_dev);
-				if (error) {
-					printk(KERN_WARNING "3w-xxxx: AEN drain failed for card %d.\n", j);
-					tries++;
-					continue;
-				}
-
-				/* Check for controller errors */
-				if (tw_check_errors(tw_dev)) {
-					printk(KERN_WARNING "3w-xxxx: Controller errors found, retrying for card %d.\n", j);
-					tries++;
-					continue;
-				}
-
-				/* Now the controller is in a good state */
-				break;
-			}
-
-			if (tries >= TW_MAX_RESET_TRIES) {
-				printk(KERN_WARNING "3w-xxxx: Controller errors, card not responding, check all cabling for card %d.\n", j);
-				tw_free_device_extension(tw_dev);
-				kfree(tw_dev);
-				continue;
-			}
-
-			/* Reserve the io address space */
-			if (!request_region((tw_dev->tw_pci_dev->resource[0].start), TW_IO_ADDRESS_RANGE, TW_DEVICE_NAME)) {
-				printk(KERN_WARNING "3w-xxxx: tw_findcards(): Couldn't get io range 0x%lx-0x%lx for card %d.\n", 
-				       (tw_dev->tw_pci_dev->resource[0].start), 
-				       (tw_dev->tw_pci_dev->resource[0].start) + 
-				       TW_IO_ADDRESS_RANGE, j);
-				tw_free_device_extension(tw_dev);
-				kfree(tw_dev);
-				continue;
-			}
-
-			error = tw_initialize_units(tw_dev);
-			if (error) {
-				printk(KERN_WARNING "3w-xxxx: No valid units for for card %d.\n", j);
-			}
-
-			error = tw_initconnection(tw_dev, TW_INIT_MESSAGE_CREDITS);
-			if (error) {
-				printk(KERN_WARNING "3w-xxxx: Connection initialization failed for card %d.\n", j);
-				release_region((tw_dev->tw_pci_dev->resource[0].start), TW_IO_ADDRESS_RANGE);
-				tw_free_device_extension(tw_dev);
-				kfree(tw_dev);
-				continue;
-			}
-
-			/* Set card status as online */
-			tw_dev->online = 1;
-
-			tw_dev->free_head = TW_Q_START;
-			tw_dev->free_tail = TW_Q_START;
-			tw_dev->free_wrap = TW_Q_LENGTH - 1;
-
-			/* Register the card with the kernel SCSI layer */
-			host = scsi_register(tw_host, sizeof(TW_Device_Extension));
-			if (host == NULL) {
-				printk(KERN_WARNING "3w-xxxx: tw_findcards(): scsi_register() failed for card %d.\n", j);
-				release_region((tw_dev->tw_pci_dev->resource[0].start), TW_IO_ADDRESS_RANGE);
-				tw_free_device_extension(tw_dev);
-				kfree(tw_dev);
-				continue;
-			}
-
-			/* Set max target id's */
-			host->max_id = TW_MAX_UNITS;
-
-			/* Set max cdb size in bytes */
-			host->max_cmd_len = 16;
-
-			/* Set max sectors per io */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,7)
-			host->max_sectors = TW_MAX_SECTORS;
-#endif
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
-			scsi_set_device(host, &tw_pci_dev->dev);
-#elif LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,4)
-			scsi_set_pci_device(host, tw_pci_dev);
-#endif
-
-			status_reg_value = inl(tw_dev->registers.status_reg_addr);
-
-			printk(KERN_NOTICE "scsi%d : Found a 3ware Storage Controller at 0x%x, IRQ: %d, P-chip: %d.%d\n", host->host_no,
-				(u32)(tw_pci_dev->resource[0].start), tw_pci_dev->irq, 
-				(status_reg_value & TW_STATUS_MAJOR_VERSION_MASK) >> 28, 
-				(status_reg_value & TW_STATUS_MINOR_VERSION_MASK) >> 24);
-
-			if (host->hostdata) {
-				tw_dev2 = (TW_Device_Extension *)host->hostdata;
-				memcpy(tw_dev2, tw_dev, sizeof(TW_Device_Extension));
-				/* Need to init the sem/wqueue after the copy */
-				init_MUTEX(&tw_dev2->ioctl_sem);
-				init_waitqueue_head(&tw_dev2->ioctl_wqueue);
-
-				tw_device_extension_list[tw_device_extension_count] = tw_dev2;
-				numcards++;
-				tw_device_extension_count = numcards;
-				tw_dev2->host = host;
-			} else { 
-				printk(KERN_WARNING "3w-xxxx: tw_findcards(): Bad scsi host data for card %d.\n", j);
-				scsi_unregister(host);
-				release_region((tw_dev->tw_pci_dev->resource[0].start), TW_IO_ADDRESS_RANGE);
-				tw_free_device_extension(tw_dev);
-				kfree(tw_dev);
-				continue;
-			}
-
-			/* Tell the firmware we support shutdown notification*/
-			error = tw_setfeature(tw_dev2, 2, 1, &c);
-			if (error) {
-				printk(KERN_WARNING "3w-xxxx: Unable to set features for card %d, old firmware or card.\n", j);
-			}
-
-			/* Now setup the interrupt handler */
-			error = tw_setup_irq(tw_dev2);
-			if (error) {
-				printk(KERN_WARNING "3w-xxxx: tw_findcards(): Error requesting irq for card %d.\n", j);
-				scsi_unregister(host);
-				release_region((tw_dev->tw_pci_dev->resource[0].start), TW_IO_ADDRESS_RANGE);
-
-				tw_free_device_extension(tw_dev);
-				kfree(tw_dev);
-				numcards--;
-				continue;
-			}
-
-			/* Re-enable interrupts on the card */
-			tw_enable_interrupts(tw_dev2);
-
-			/* Free the temporary device extension */
-			if (tw_dev)
-				kfree(tw_dev);
-		}
-	}
+	/* Send command packet to the board */
+	outl(command_que_value, TW_COMMAND_QUEUE_REG_ADDR(tw_dev));
+    
+	/* Poll for completion */
+	if (tw_poll_status_gone(tw_dev, TW_STATUS_RESPONSE_QUEUE_EMPTY, 30) == 0) {
+		response_queue.value = inl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
+		request_id = TW_RESID_OUT(response_queue.response_id);
 
-	if (numcards == 0) {
-		printk(KERN_WARNING "3w-xxxx: No cards found.\n");
-	} else {
-		register_reboot_notifier(&tw_notifier);
-		if ((twe_major = register_chrdev (0, "twe", &tw_fops)) < 0) {
-			printk(KERN_WARNING "3w-xxxx: Unable to register \"twe\" character device, error = %d.\n", twe_major);
+		if (request_id != 0) {
+			/* unexpected request id */
+			printk(KERN_WARNING "3w-xxxx: tw_initconnection(): Unexpected request id.\n");
+			return 1;
 		}
-	}
-
-	return numcards;
-} /* End tw_findcards() */
-
-/* This function will free up device extension resources */
-void tw_free_device_extension(TW_Device_Extension *tw_dev)
-{
-	dprintk(KERN_NOTICE "3w-xxxx: tw_free_device_extension()\n");
-
-	/* Free command packet and generic buffer memory */
-	if (tw_dev->command_packet_virtual_address[0])
-		pci_free_consistent(tw_dev->tw_pci_dev, sizeof(TW_Command)*TW_Q_LENGTH, tw_dev->command_packet_virtual_address[0], tw_dev->command_packet_physical_address[0]);
-
-	if (tw_dev->alignment_virtual_address[0])
-		pci_free_consistent(tw_dev->tw_pci_dev, sizeof(TW_Sector)*TW_Q_LENGTH, tw_dev->alignment_virtual_address[0], tw_dev->alignment_physical_address[0]);
-} /* End tw_free_device_extension() */
-
-/* Clean shutdown routine */
-static int tw_halt(struct notifier_block *nb, ulong event, void *buf)
-{
-	int i;
-
-	for (i=0;i<tw_device_extension_count;i++) {
-		if (tw_device_extension_list[i]->online == 1) {
-			printk(KERN_NOTICE "3w-xxxx: Shutting down card %d.\n", i);
-			tw_shutdown_device(tw_device_extension_list[i]);
-			tw_device_extension_list[i]->online = 0;
+		if (command_packet->status != 0) {
+			/* bad response */
+			tw_decode_sense(tw_dev, request_id, 0);
+			return 1;
 		}
 	}
-	unregister_reboot_notifier(&tw_notifier);
-
-	return NOTIFY_OK;
-} /* End tw_halt() */
+	return 0;
+} /* End tw_initconnection() */
 
-/* This function will send an initconnection command to controller */
-int tw_initconnection(TW_Device_Extension *tw_dev, int message_credits) 
+/* Set a value in the features table */
+static int tw_setfeature(TW_Device_Extension *tw_dev, int parm, int param_size,
+                  unsigned char *val)
 {
-	unsigned long command_que_value;
-	u32 command_que_addr;
-	u32 response_que_addr;
+	TW_Param *param;
 	TW_Command  *command_packet;
 	TW_Response_Queue response_queue;
 	int request_id = 0;
+	unsigned long command_que_value;
+	unsigned long param_value;
 
-	dprintk(KERN_NOTICE "3w-xxxx: tw_initconnection()\n");
-	command_que_addr = tw_dev->registers.command_que_addr;
-	response_que_addr = tw_dev->registers.response_que_addr;
-
-	/* Initialize InitConnection command packet */
+  	/* Initialize SetParam command packet */
 	if (tw_dev->command_packet_virtual_address[request_id] == NULL) {
-		printk(KERN_WARNING "3w-xxxx: tw_initconnection(): Bad command packet virtual address.\n");
+		printk(KERN_WARNING "3w-xxxx: tw_setfeature(): Bad command packet virtual address.\n");
 		return 1;
 	}
-
 	command_packet = (TW_Command *)tw_dev->command_packet_virtual_address[request_id];
 	memset(command_packet, 0, sizeof(TW_Sector));
-	command_packet->byte0.opcode = TW_OP_INIT_CONNECTION;
-	command_packet->byte0.sgl_offset = 0x0;
-	command_packet->size = TW_INIT_COMMAND_PACKET_SIZE;
+	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
+
+	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_SET_PARAM);
+	param->table_id = 0x404;  /* Features table */
+	param->parameter_id = parm;
+	param->parameter_size_bytes = param_size;
+	memcpy(param->data, val, param_size);
+
+	param_value = tw_dev->alignment_physical_address[request_id];
+	if (param_value == 0) {
+		printk(KERN_WARNING "3w-xxxx: tw_setfeature(): Bad alignment physical address.\n");
+		tw_dev->state[request_id] = TW_S_COMPLETED;
+		tw_state_request_finish(tw_dev, request_id);
+		tw_dev->srb[request_id]->result = (DID_OK << 16);
+		tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
+	}
+	command_packet->byte8.param.sgl[0].address = param_value;
+	command_packet->byte8.param.sgl[0].length = sizeof(TW_Sector);
+
+	command_packet->size = 4;
 	command_packet->request_id = request_id;
-	command_packet->byte3.unit = 0x0;
-	command_packet->byte3.host_id = 0x0;
-	command_packet->status = 0x0;
-	command_packet->flags = 0x0;
-	command_packet->byte6.message_credits = message_credits; 
-	command_packet->byte8.init_connection.response_queue_pointer = 0x0;
-	command_que_value = tw_dev->command_packet_physical_address[request_id];
+	command_packet->byte6.parameter_count = 1;
 
+  	command_que_value = tw_dev->command_packet_physical_address[request_id];
 	if (command_que_value == 0) {
-		printk(KERN_WARNING "3w-xxxx: tw_initconnection(): Bad command packet physical address.\n");
-		return 1;
+		printk(KERN_WARNING "3w-xxxx: tw_setfeature(): Bad command packet physical address.\n");
+	return 1;
 	}
-  
+
 	/* Send command packet to the board */
-	outl(command_que_value, command_que_addr);
-    
+	outl(command_que_value, TW_COMMAND_QUEUE_REG_ADDR(tw_dev));
+
 	/* Poll for completion */
 	if (tw_poll_status_gone(tw_dev, TW_STATUS_RESPONSE_QUEUE_EMPTY, 30) == 0) {
-		response_queue.value = inl(response_que_addr);
-		request_id = (unsigned char)response_queue.u.response_id;
+		response_queue.value = inl(TW_RESPONSE_QUEUE_REG_ADDR(tw_dev));
+		request_id = TW_RESID_OUT(response_queue.response_id);
+
 		if (request_id != 0) {
 			/* unexpected request id */
-			printk(KERN_WARNING "3w-xxxx: tw_initconnection(): Unexpected request id.\n");
+			printk(KERN_WARNING "3w-xxxx: tw_setfeature(): Unexpected request id.\n");
 			return 1;
 		}
 		if (command_packet->status != 0) {
@@ -1338,11 +1208,60 @@
 			return 1;
 		}
 	}
+
 	return 0;
-} /* End tw_initconnection() */
+} /* End tw_setfeature() */
+
+/* This function will reset a controller */
+static int tw_reset_sequence(TW_Device_Extension *tw_dev) 
+{
+	int error = 0;
+	int tries = 0;
+	unsigned char c = 1;
+
+	/* Reset the board */
+	while (tries < TW_MAX_RESET_TRIES) {
+		TW_SOFT_RESET(tw_dev);
+
+		error = tw_aen_drain_queue(tw_dev);
+		if (error) {
+			printk(KERN_WARNING "3w-xxxx: scsi%d: AEN drain failed, retrying.\n", tw_dev->host->host_no);
+			tries++;
+			continue;
+		}
+
+		/* Check for controller errors */
+		if (tw_check_errors(tw_dev)) {
+			printk(KERN_WARNING "3w-xxxx: scsi%d: Controller errors found, retrying.\n", tw_dev->host->host_no);
+			tries++;
+			continue;
+		}
+
+		/* Now the controller is in a good state */
+		break;
+	}
+
+	if (tries >= TW_MAX_RESET_TRIES) {
+		printk(KERN_WARNING "3w-xxxx: scsi%d: Controller errors, card not responding, check all cabling.\n", tw_dev->host->host_no);
+		return 1;
+	}
+
+	error = tw_initconnection(tw_dev, TW_INIT_MESSAGE_CREDITS);
+	if (error) {
+		printk(KERN_WARNING "3w-xxxx: scsi%d: Connection initialization failed.\n", tw_dev->host->host_no);
+		return 1;
+	}
+
+	error = tw_setfeature(tw_dev, 2, 1, &c);
+	if (error) {
+		printk(KERN_WARNING "3w-xxxx: Unable to set features for card, probable old firmware or card.\n");
+	}
+
+	return 0;
+} /* End tw_reset_sequence() */
 
 /* This function will initialize the fields of a device extension */
-int tw_initialize_device_extension(TW_Device_Extension *tw_dev)
+static int tw_initialize_device_extension(TW_Device_Extension *tw_dev)
 {
 	int i, error=0;


