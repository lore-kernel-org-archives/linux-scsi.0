From: adam radford <aradford@gmail.com>
Subject: [PATCH] Updated: Add new driver for LSI 3ware 9750
Date: Fri, 23 Oct 2009 14:52:33 -0700
Message-ID: <b1bc6a000910231452x27581ef0qeeea8f1bb30cbd8f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=000e0cd66c88ae1e7f0476a13a1e
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:57673 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbZJWVw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2009 17:52:29 -0400
Received: by yxe17 with SMTP id 17so8354496yxe.33
        for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2009 14:52:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

--000e0cd66c88ae1e7f0476a13a1e
Content-Type: text/plain; charset=ISO-8859-1

James, linux-scsi,

This updated patch addresses some of Rolf Eike Beer's suggestions
for the new 3w-sas driver, including:

- Don't initialize static variable use_msi.
- Don't duplicate cylinders = sector_div function in biosparam().
- Use shost_priv().
- Use PCI_VDEVICE().
- Replace pci_resource_start()/pci_resource_len()/ioremap() with pci_iomap().
- Replace some (char *)0 instances with NULL.

Signed-off-by: Adam Radford <aradford@gmail.com>

-Adam

Note: This patch is included in-line below and also as an attachment.

diff -Naur linux-2.6.32-rc5-git1/drivers/scsi/3w-sas.c
linux-2.6.32-rc5-git1.new/drivers/scsi/3w-sas.c
--- linux-2.6.32-rc5-git1/drivers/scsi/3w-sas.c	1969-12-31
16:00:00.000000000 -0800
+++ linux-2.6.32-rc5-git1.new/drivers/scsi/3w-sas.c	2009-10-23
14:27:38.000000000 -0700
@@ -0,0 +1,1920 @@
+/*
+   3w-sas.c -- LSI 3ware SAS/SATA-RAID Controller device driver for Linux.
+
+   Written By: Adam Radford <linuxraid@lsi.com>
+
+   Copyright (C) 2009 LSI Corporation.
+
+   This program is free software; you can redistribute it and/or modify
+   it under the terms of the GNU General Public License as published by
+   the Free Software Foundation; version 2 of the License.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   NO WARRANTY
+   THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
+   CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
+   LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
+   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
+   solely responsible for determining the appropriateness of using and
+   distributing the Program and assumes all risks associated with its
+   exercise of rights under this Agreement, including but not limited to
+   the risks and costs of program errors, damage to or loss of data,
+   programs or equipment, and unavailability or interruption of operations.
+
+   DISCLAIMER OF LIABILITY
+   NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
+   DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+   DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
+   ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+   TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+   USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
+   HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+   Controllers supported by this driver:
+
+   LSI 3ware 9750 6Gb/s SAS/SATA-RAID
+
+   Bugs/Comments/Suggestions should be mailed to:
+   linuxraid@lsi.com
+
+   For more information, goto:
+   http://www.lsi.com
+
+   History
+   -------
+   3.26.02.000 - Initial driver release.
+*/
+
+#include <linux/module.h>
+#include <linux/reboot.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/moduleparam.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/time.h>
+#include <linux/mutex.h>
+#include <linux/smp_lock.h>
+#include <asm/io.h>
+#include <asm/irq.h>
+#include <asm/uaccess.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_cmnd.h>
+#include "3w-sas.h"
+
+/* Globals */
+#define TW_DRIVER_VERSION "3.26.02.000"
+static TW_Device_Extension *twl_device_extension_list[TW_MAX_SLOT];
+static unsigned int twl_device_extension_count;
+static int twl_major = -1;
+extern struct timezone sys_tz;
+
+/* Module parameters */
+MODULE_AUTHOR ("LSI");
+MODULE_DESCRIPTION ("LSI 3ware SAS/SATA-RAID Linux Driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(TW_DRIVER_VERSION);
+
+static int use_msi;
+module_param(use_msi, int, S_IRUGO);
+MODULE_PARM_DESC(use_msi, "Use Message Signaled Interrupts. Default: 0");
+
+/* Function prototypes */
+static int twl_reset_device_extension(TW_Device_Extension *tw_dev,
int ioctl_reset);
+
+/* Functions */
+
+/* This function returns AENs through sysfs */
+static ssize_t twl_sysfs_aen_read(struct kobject *kobj,
+				  struct bin_attribute *bin_attr,
+				  char *outbuf, loff_t offset, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct Scsi_Host *shost = class_to_shost(dev);
+	TW_Device_Extension *tw_dev = (TW_Device_Extension *)shost->hostdata;
+	unsigned long flags = 0;
+	ssize_t ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+	ret = memory_read_from_buffer(outbuf, count, &offset,
tw_dev->event_queue[0], sizeof(TW_Event) * TW_Q_LENGTH);
+	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+
+	return ret;
+} /* End twl_sysfs_aen_read() */
+
+/* aen_read sysfs attribute initializer */
+static struct bin_attribute twl_sysfs_aen_read_attr = {
+	.attr = {
+		.name = "3ware_aen_read",
+		.mode = S_IRUSR,
+	},
+	.size = 0,
+	.read = twl_sysfs_aen_read
+};
+
+/* This function returns driver compatibility info through sysfs */
+static ssize_t twl_sysfs_compat_info(struct kobject *kobj,
+				     struct bin_attribute *bin_attr,
+				     char *outbuf, loff_t offset, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct Scsi_Host *shost = class_to_shost(dev);
+	TW_Device_Extension *tw_dev = (TW_Device_Extension *)shost->hostdata;
+	unsigned long flags = 0;
+	ssize_t ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+	ret = memory_read_from_buffer(outbuf, count, &offset,
&tw_dev->tw_compat_info, sizeof(TW_Compatibility_Info));
+	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+
+	return ret;
+} /* End twl_sysfs_compat_info() */
+
+/* compat_info sysfs attribute initializer */
+static struct bin_attribute twl_sysfs_compat_info_attr = {
+	.attr = {
+		.name = "3ware_compat_info",
+		.mode = S_IRUSR,
+	},
+	.size = 0,
+	.read = twl_sysfs_compat_info
+};
+
+/* Show some statistics about the card */
+static ssize_t twl_show_stats(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *host = class_to_shost(dev);
+	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
+	unsigned long flags = 0;
+	ssize_t len;
+
+	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+	len = snprintf(buf, PAGE_SIZE, "3w-sas Driver version: %s\n"
+		       "Current commands posted:   %4d\n"
+		       "Max commands posted:       %4d\n"
+		       "Last sgl length:           %4d\n"
+		       "Max sgl length:            %4d\n"
+		       "Last sector count:         %4d\n"
+		       "Max sector count:          %4d\n"
+		       "SCSI Host Resets:          %4d\n"
+		       "AEN's:                     %4d\n",
+		       TW_DRIVER_VERSION,
+		       tw_dev->posted_request_count,
+		       tw_dev->max_posted_request_count,
+		       tw_dev->sgl_entries,
+		       tw_dev->max_sgl_entries,
+		       tw_dev->sector_count,
+		       tw_dev->max_sector_count,
+		       tw_dev->num_resets,
+		       tw_dev->aen_count);
+	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+	return len;
+} /* End twl_show_stats() */
+
+/* This function will set a devices queue depth */
+static int twl_change_queue_depth(struct scsi_device *sdev, int queue_depth)
+{
+	if (queue_depth > TW_Q_LENGTH-2)
+		queue_depth = TW_Q_LENGTH-2;
+	scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, queue_depth);
+	return queue_depth;
+} /* End twl_change_queue_depth() */
+
+/* stats sysfs attribute initializer */
+static struct device_attribute twl_host_stats_attr = {
+	.attr = {
+		.name = 	"3ware_stats",
+		.mode =		S_IRUGO,
+	},
+	.show = twl_show_stats
+};
+
+/* Host attributes initializer */
+static struct device_attribute *twl_host_attrs[] = {
+	&twl_host_stats_attr,
+	NULL,
+};
+
+/* This function will look up an AEN severity string */
+static char *twl_aen_severity_lookup(unsigned char severity_code)
+{
+	char *retval = NULL;
+
+	if ((severity_code < (unsigned char) TW_AEN_SEVERITY_ERROR) ||
+	    (severity_code > (unsigned char) TW_AEN_SEVERITY_DEBUG))
+		goto out;
+
+	retval = twl_aen_severity_table[severity_code];
+out:
+	return retval;
+} /* End twl_aen_severity_lookup() */
+
+/* This function will queue an event */
+static void twl_aen_queue_event(TW_Device_Extension *tw_dev,
TW_Command_Apache_Header *header)
+{
+	u32 local_time;
+	struct timeval time;
+	TW_Event *event;
+	unsigned short aen;
+	char host[16];
+	char *error_str;
+
+	tw_dev->aen_count++;
+
+	/* Fill out event info */
+	event = tw_dev->event_queue[tw_dev->error_index];
+
+	host[0] = '\0';
+	if (tw_dev->host)
+		sprintf(host, " scsi%d:", tw_dev->host->host_no);
+
+	aen = le16_to_cpu(header->status_block.error);
+	memset(event, 0, sizeof(TW_Event));
+
+	event->severity = TW_SEV_OUT(header->status_block.severity__reserved);
+	do_gettimeofday(&time);
+	local_time = (u32)(time.tv_sec - (sys_tz.tz_minuteswest * 60));
+	event->time_stamp_sec = local_time;
+	event->aen_code = aen;
+	event->retrieved = TW_AEN_NOT_RETRIEVED;
+	event->sequence_id = tw_dev->error_sequence_id;
+	tw_dev->error_sequence_id++;
+
+	/* Check for embedded error string */
+	error_str = &(header->err_specific_desc[strlen(header->err_specific_desc)+1]);
+
+	header->err_specific_desc[sizeof(header->err_specific_desc) - 1] = '\0';
+	event->parameter_len = strlen(header->err_specific_desc);
+	memcpy(event->parameter_data, header->err_specific_desc,
event->parameter_len + 1 + strlen(error_str));
+	if (event->severity != TW_AEN_SEVERITY_DEBUG)
+		printk(KERN_WARNING "3w-sas:%s AEN: %s (0x%02X:0x%04X): %s:%s.\n",
+		       host,
+		       twl_aen_severity_lookup(TW_SEV_OUT(header->status_block.severity__reserved)),
+		       TW_MESSAGE_SOURCE_CONTROLLER_EVENT, aen, error_str,
+		       header->err_specific_desc);
+	else
+		tw_dev->aen_count--;
+
+	tw_dev->error_index = (tw_dev->error_index + 1 ) % TW_Q_LENGTH;
+} /* End twl_aen_queue_event() */
+
+/* This function will attempt to post a command packet to the board */
+static int twl_post_command_packet(TW_Device_Extension *tw_dev, int request_id)
+{
+	dma_addr_t command_que_value;
+
+	command_que_value = tw_dev->command_packet_phys[request_id];
+	command_que_value += TW_COMMAND_OFFSET;
+
+	/* First write upper 4 bytes */
+	writel((u32)((u64)command_que_value >> 32), TWL_HIBQPH_REG_ADDR(tw_dev));
+	/* Then the lower 4 bytes */
+	writel((u32)(command_que_value | TWL_PULL_MODE), TWL_HIBQPL_REG_ADDR(tw_dev));
+
+	tw_dev->state[request_id] = TW_S_POSTED;
+	tw_dev->posted_request_count++;
+	if (tw_dev->posted_request_count > tw_dev->max_posted_request_count)
+		tw_dev->max_posted_request_count = tw_dev->posted_request_count;
+
+	return 0;
+} /* End twl_post_command_packet() */
+
+/* This function will perform a pci-dma mapping for a scatter gather list */
+static int twl_map_scsi_sg_data(TW_Device_Extension *tw_dev, int request_id)
+{
+	int use_sg;
+	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
+
+	use_sg = scsi_dma_map(cmd);
+	if (!use_sg)
+		return 0;
+	else if (use_sg < 0) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1, "Failed to map scatter gather list");
+		return 0;
+	}
+
+	cmd->SCp.phase = TW_PHASE_SGLIST;
+	cmd->SCp.have_data_in = use_sg;
+
+	return use_sg;
+} /* End twl_map_scsi_sg_data() */
+
+/* This function hands scsi cdb's to the firmware */
+static int twl_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int
request_id, char *cdb, int use_sg, TW_SG_Entry_ISO *sglistarg)
+{
+	TW_Command_Full *full_command_packet;
+	TW_Command_Apache *command_packet;
+	int i, sg_count;
+	struct scsi_cmnd *srb = NULL;
+	struct scatterlist *sglist = NULL, *sg;
+	int retval = 1;
+
+	if (tw_dev->srb[request_id]) {
+		srb = tw_dev->srb[request_id];
+		if (scsi_sglist(srb))
+			sglist = scsi_sglist(srb);
+	}
+
+	/* Initialize command packet */
+	full_command_packet = tw_dev->command_packet_virt[request_id];
+	full_command_packet->header.header_desc.size_header = 128;
+	full_command_packet->header.status_block.error = 0;
+	full_command_packet->header.status_block.severity__reserved = 0;
+
+	command_packet = &full_command_packet->command.newcommand;
+	command_packet->status = 0;
+	command_packet->opcode__reserved = TW_OPRES_IN(0, TW_OP_EXECUTE_SCSI);
+
+	/* We forced 16 byte cdb use earlier */
+	if (!cdb)
+		memcpy(command_packet->cdb, srb->cmnd, TW_MAX_CDB_LEN);
+	else
+		memcpy(command_packet->cdb, cdb, TW_MAX_CDB_LEN);
+
+	if (srb) {
+		command_packet->unit = srb->device->id;
+		command_packet->request_id__lunl =
+			cpu_to_le16(TW_REQ_LUN_IN(srb->device->lun, request_id));
+	} else {
+		command_packet->request_id__lunl =
+			cpu_to_le16(TW_REQ_LUN_IN(0, request_id));
+		command_packet->unit = 0;
+	}
+
+	command_packet->sgl_offset = 16;
+
+	if (!sglistarg) {
+		/* Map sglist from scsi layer to cmd packet */
+		if (scsi_sg_count(srb)) {
+			sg_count = twl_map_scsi_sg_data(tw_dev, request_id);
+			if (sg_count == 0)
+				goto out;
+
+			scsi_for_each_sg(srb, sg, sg_count, i) {
+				command_packet->sg_list[i].address = TW_CPU_TO_SGL(sg_dma_address(sg));
+				command_packet->sg_list[i].length = TW_CPU_TO_SGL(sg_dma_len(sg));
+			}
+			command_packet->sgl_entries__lunh =
cpu_to_le16(TW_REQ_LUN_IN((srb->device->lun >> 4),
scsi_sg_count(tw_dev->srb[request_id])));
+		}
+	} else {
+		/* Internal cdb post */
+		for (i = 0; i < use_sg; i++) {
+			command_packet->sg_list[i].address = TW_CPU_TO_SGL(sglistarg[i].address);
+			command_packet->sg_list[i].length = TW_CPU_TO_SGL(sglistarg[i].length);
+		}
+		command_packet->sgl_entries__lunh = cpu_to_le16(TW_REQ_LUN_IN(0, use_sg));
+	}
+
+	/* Update some stats */
+	if (srb) {
+		tw_dev->sector_count = scsi_bufflen(srb) / 512;
+		if (tw_dev->sector_count > tw_dev->max_sector_count)
+			tw_dev->max_sector_count = tw_dev->sector_count;
+		tw_dev->sgl_entries = scsi_sg_count(srb);
+		if (tw_dev->sgl_entries > tw_dev->max_sgl_entries)
+			tw_dev->max_sgl_entries = tw_dev->sgl_entries;
+	}
+
+	/* Now post the command to the board */
+	retval = twl_post_command_packet(tw_dev, request_id);
+
+out:
+	return retval;
+} /* End twl_scsiop_execute_scsi() */
+
+/* This function will read the aen queue from the isr */
+static int twl_aen_read_queue(TW_Device_Extension *tw_dev, int request_id)
+{
+	char cdb[TW_MAX_CDB_LEN];
+	TW_SG_Entry_ISO sglist[1];
+	TW_Command_Full *full_command_packet;
+	int retval = 1;
+
+	full_command_packet = tw_dev->command_packet_virt[request_id];
+	memset(full_command_packet, 0, sizeof(TW_Command_Full));
+
+	/* Initialize cdb */
+	memset(&cdb, 0, TW_MAX_CDB_LEN);
+	cdb[0] = REQUEST_SENSE; /* opcode */
+	cdb[4] = TW_ALLOCATION_LENGTH; /* allocation length */
+
+	/* Initialize sglist */
+	memset(&sglist, 0, sizeof(TW_SG_Entry_ISO));
+	sglist[0].length = TW_SECTOR_SIZE;
+	sglist[0].address = tw_dev->generic_buffer_phys[request_id];
+
+	/* Mark internal command */
+	tw_dev->srb[request_id] = NULL;
+
+	/* Now post the command packet */
+	if (twl_scsiop_execute_scsi(tw_dev, request_id, cdb, 1, sglist)) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2, "Post failed while reading
AEN queue");
+		goto out;
+	}
+	retval = 0;
+out:
+	return retval;
+} /* End twl_aen_read_queue() */
+
+/* This function will sync firmware time with the host time */
+static void twl_aen_sync_time(TW_Device_Extension *tw_dev, int request_id)
+{
+	u32 schedulertime;
+	struct timeval utc;
+	TW_Command_Full *full_command_packet;
+	TW_Command *command_packet;
+	TW_Param_Apache *param;
+	u32 local_time;
+
+	/* Fill out the command packet */
+	full_command_packet = tw_dev->command_packet_virt[request_id];
+	memset(full_command_packet, 0, sizeof(TW_Command_Full));
+	command_packet = &full_command_packet->command.oldcommand;
+	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_SET_PARAM);
+	command_packet->request_id = request_id;
+	command_packet->byte8_offset.param.sgl[0].address =
TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
+	command_packet->byte8_offset.param.sgl[0].length =
TW_CPU_TO_SGL(TW_SECTOR_SIZE);
+	command_packet->size = TW_COMMAND_SIZE;
+	command_packet->byte6_offset.parameter_count = cpu_to_le16(1);
+
+	/* Setup the param */
+	param = (TW_Param_Apache *)tw_dev->generic_buffer_virt[request_id];
+	memset(param, 0, TW_SECTOR_SIZE);
+	param->table_id = cpu_to_le16(TW_TIMEKEEP_TABLE | 0x8000); /*
Controller time keep table */
+	param->parameter_id = cpu_to_le16(0x3); /* SchedulerTime */
+	param->parameter_size_bytes = cpu_to_le16(4);
+
+	/* Convert system time in UTC to local time seconds since last
+           Sunday 12:00AM */
+	do_gettimeofday(&utc);
+	local_time = (u32)(utc.tv_sec - (sys_tz.tz_minuteswest * 60));
+	schedulertime = local_time - (3 * 86400);
+	schedulertime = cpu_to_le32(schedulertime % 604800);
+
+	memcpy(param->data, &schedulertime, sizeof(u32));
+
+	/* Mark internal command */
+	tw_dev->srb[request_id] = NULL;
+
+	/* Now post the command */
+	twl_post_command_packet(tw_dev, request_id);
+} /* End twl_aen_sync_time() */
+
+/* This function will assign an available request id */
+static void twl_get_request_id(TW_Device_Extension *tw_dev, int *request_id)
+{
+	*request_id = tw_dev->free_queue[tw_dev->free_head];
+	tw_dev->free_head = (tw_dev->free_head + 1) % TW_Q_LENGTH;
+	tw_dev->state[*request_id] = TW_S_STARTED;
+} /* End twl_get_request_id() */
+
+/* This function will free a request id */
+static void twl_free_request_id(TW_Device_Extension *tw_dev, int request_id)
+{
+	tw_dev->free_queue[tw_dev->free_tail] = request_id;
+	tw_dev->state[request_id] = TW_S_FINISHED;
+	tw_dev->free_tail = (tw_dev->free_tail + 1) % TW_Q_LENGTH;
+} /* End twl_free_request_id() */
+
+/* This function will complete an aen request from the isr */
+static int twl_aen_complete(TW_Device_Extension *tw_dev, int request_id)
+{
+	TW_Command_Full *full_command_packet;
+	TW_Command *command_packet;
+	TW_Command_Apache_Header *header;
+	unsigned short aen;
+	int retval = 1;
+
+	header = (TW_Command_Apache_Header *)tw_dev->generic_buffer_virt[request_id];
+	tw_dev->posted_request_count--;
+	aen = le16_to_cpu(header->status_block.error);
+	full_command_packet = tw_dev->command_packet_virt[request_id];
+	command_packet = &full_command_packet->command.oldcommand;
+
+	/* First check for internal completion of set param for time sync */
+	if (TW_OP_OUT(command_packet->opcode__sgloffset) == TW_OP_SET_PARAM) {
+		/* Keep reading the queue in case there are more aen's */
+		if (twl_aen_read_queue(tw_dev, request_id))
+			goto out2;
+	        else {
+			retval = 0;
+			goto out;
+		}
+	}
+
+	switch (aen) {
+	case TW_AEN_QUEUE_EMPTY:
+		/* Quit reading the queue if this is the last one */
+		break;
+	case TW_AEN_SYNC_TIME_WITH_HOST:
+		twl_aen_sync_time(tw_dev, request_id);
+		retval = 0;
+		goto out;
+	default:
+		twl_aen_queue_event(tw_dev, header);
+
+		/* If there are more aen's, keep reading the queue */
+		if (twl_aen_read_queue(tw_dev, request_id))
+			goto out2;
+		else {
+			retval = 0;
+			goto out;
+		}
+	}
+	retval = 0;
+out2:
+	tw_dev->state[request_id] = TW_S_COMPLETED;
+	twl_free_request_id(tw_dev, request_id);
+	clear_bit(TW_IN_ATTENTION_LOOP, &tw_dev->flags);
+out:
+	return retval;
+} /* End twl_aen_complete() */
+
+/* This function will poll for a response */
+static int twl_poll_response(TW_Device_Extension *tw_dev, int
request_id, int seconds)
+{
+	unsigned long before;
+	dma_addr_t mfa;
+	u32 regh, regl;
+	u32 response;
+	int retval = 1;
+	int found = 0;
+
+	before = jiffies;
+
+	while (!found) {
+		if (sizeof(dma_addr_t) > 4) {
+			regh = readl(TWL_HOBQPH_REG_ADDR(tw_dev));
+			regl = readl(TWL_HOBQPL_REG_ADDR(tw_dev));
+			mfa = ((u64)regh << 32) | regl;
+		} else
+			mfa = readl(TWL_HOBQPL_REG_ADDR(tw_dev));
+
+		response = (u32)mfa;
+
+		if (TW_RESID_OUT(response) == request_id)
+			found = 1;
+
+		if (time_after(jiffies, before + HZ * seconds))
+			goto out;
+
+		msleep(50);
+	}
+	retval = 0;
+out:
+	return retval;
+} /* End twl_poll_response() */
+
+/* This function will drain the aen queue */
+static int twl_aen_drain_queue(TW_Device_Extension *tw_dev, int no_check_reset)
+{
+	int request_id = 0;
+	char cdb[TW_MAX_CDB_LEN];
+	TW_SG_Entry_ISO sglist[1];
+	int finished = 0, count = 0;
+	TW_Command_Full *full_command_packet;
+	TW_Command_Apache_Header *header;
+	unsigned short aen;
+	int first_reset = 0, queue = 0, retval = 1;
+
+	if (no_check_reset)
+		first_reset = 0;
+	else
+		first_reset = 1;
+
+	full_command_packet = tw_dev->command_packet_virt[request_id];
+	memset(full_command_packet, 0, sizeof(TW_Command_Full));
+
+	/* Initialize cdb */
+	memset(&cdb, 0, TW_MAX_CDB_LEN);
+	cdb[0] = REQUEST_SENSE; /* opcode */
+	cdb[4] = TW_ALLOCATION_LENGTH; /* allocation length */
+
+	/* Initialize sglist */
+	memset(&sglist, 0, sizeof(TW_SG_Entry_ISO));
+	sglist[0].length = TW_SECTOR_SIZE;
+	sglist[0].address = tw_dev->generic_buffer_phys[request_id];
+
+	/* Mark internal command */
+	tw_dev->srb[request_id] = NULL;
+
+	do {
+		/* Send command to the board */
+		if (twl_scsiop_execute_scsi(tw_dev, request_id, cdb, 1, sglist)) {
+			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x3, "Error posting request sense");
+			goto out;
+		}
+
+		/* Now poll for completion */
+		if (twl_poll_response(tw_dev, request_id, 30)) {
+			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x4, "No valid response while
draining AEN queue");
+			tw_dev->posted_request_count--;
+			goto out;
+		}
+
+		tw_dev->posted_request_count--;
+		header = (TW_Command_Apache_Header *)tw_dev->generic_buffer_virt[request_id];
+		aen = le16_to_cpu(header->status_block.error);
+		queue = 0;
+		count++;
+
+		switch (aen) {
+		case TW_AEN_QUEUE_EMPTY:
+			if (first_reset != 1)
+				goto out;
+			else
+				finished = 1;
+			break;
+		case TW_AEN_SOFT_RESET:
+			if (first_reset == 0)
+				first_reset = 1;
+			else
+				queue = 1;
+			break;
+		case TW_AEN_SYNC_TIME_WITH_HOST:
+			break;
+		default:
+			queue = 1;
+		}
+
+		/* Now queue an event info */
+		if (queue)
+			twl_aen_queue_event(tw_dev, header);
+	} while ((finished == 0) && (count < TW_MAX_AEN_DRAIN));
+
+	if (count == TW_MAX_AEN_DRAIN)
+		goto out;
+
+	retval = 0;
+out:
+	tw_dev->state[request_id] = TW_S_INITIAL;
+	return retval;
+} /* End twl_aen_drain_queue() */
+
+/* This function will allocate memory and check if it is correctly aligned */
+static int twl_allocate_memory(TW_Device_Extension *tw_dev, int size,
int which)
+{
+	int i;
+	dma_addr_t dma_handle;
+	unsigned long *cpu_addr;
+	int retval = 1;
+
+	cpu_addr = pci_alloc_consistent(tw_dev->tw_pci_dev,
size*TW_Q_LENGTH, &dma_handle);
+	if (!cpu_addr) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x5, "Memory allocation failed");
+		goto out;
+	}
+
+	memset(cpu_addr, 0, size*TW_Q_LENGTH);
+
+	for (i = 0; i < TW_Q_LENGTH; i++) {
+		switch(which) {
+		case 0:
+			tw_dev->command_packet_phys[i] = dma_handle+(i*size);
+			tw_dev->command_packet_virt[i] = (TW_Command_Full *)((unsigned
char *)cpu_addr + (i*size));
+			break;
+		case 1:
+			tw_dev->generic_buffer_phys[i] = dma_handle+(i*size);
+			tw_dev->generic_buffer_virt[i] = (unsigned long *)((unsigned char
*)cpu_addr + (i*size));
+			break;
+		case 2:
+			tw_dev->sense_buffer_phys[i] = dma_handle+(i*size);
+			tw_dev->sense_buffer_virt[i] = (TW_Command_Apache_Header
*)((unsigned char *)cpu_addr + (i*size));
+			break;
+		}
+	}
+	retval = 0;
+out:
+	return retval;
+} /* End twl_allocate_memory() */
+
+/* This function will load the request id and various sgls for ioctls */
+static void twl_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full
*full_command_packet, int request_id, dma_addr_t dma_handle, int
length)
+{
+	TW_Command *oldcommand;
+	TW_Command_Apache *newcommand;
+	TW_SG_Entry_ISO *sgl;
+	unsigned int pae = 0;
+
+	if ((sizeof(long) < 8) && (sizeof(dma_addr_t) > 4))
+		pae = 1;
+
+	if (TW_OP_OUT(full_command_packet->command.newcommand.opcode__reserved)
== TW_OP_EXECUTE_SCSI) {
+		newcommand = &full_command_packet->command.newcommand;
+		newcommand->request_id__lunl =
+			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->request_id__lunl),
request_id));
+		if (length) {
+			newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle +
sizeof(TW_Ioctl_Buf_Apache) - 1);
+			newcommand->sg_list[0].length = TW_CPU_TO_SGL(length);
+		}
+		newcommand->sgl_entries__lunh =
+			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->sgl_entries__lunh),
length ? 1 : 0));
+	} else {
+		oldcommand = &full_command_packet->command.oldcommand;
+		oldcommand->request_id = request_id;
+
+		if (TW_SGL_OUT(oldcommand->opcode__sgloffset)) {
+			/* Load the sg list */
+			sgl = (TW_SG_Entry_ISO *)((u32 *)oldcommand+oldcommand->size -
(sizeof(TW_SG_Entry_ISO)/4) + pae + (sizeof(dma_addr_t) > 4 ? 1 : 0));
+			sgl->address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1);
+			sgl->length = TW_CPU_TO_SGL(length);
+			oldcommand->size += pae;
+			oldcommand->size += sizeof(dma_addr_t) > 4 ? 1 : 0;
+		}
+	}
+} /* End twl_load_sgl() */
+
+/* This function handles ioctl for the character device
+   This interface is used by smartmontools open source software */
+static int twl_chrdev_ioctl(struct inode *inode, struct file *file,
unsigned int cmd, unsigned long arg)
+{
+	long timeout;
+	unsigned long *cpu_addr, data_buffer_length_adjusted = 0, flags = 0;
+	dma_addr_t dma_handle;
+	int request_id = 0;
+	TW_Ioctl_Driver_Command driver_command;
+	TW_Ioctl_Buf_Apache *tw_ioctl;
+	TW_Command_Full *full_command_packet;
+	TW_Device_Extension *tw_dev = twl_device_extension_list[iminor(inode)];
+	int retval = -EFAULT;
+	void __user *argp = (void __user *)arg;
+
+	/* Only let one of these through at a time */
+	if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
+		retval = -EINTR;
+		goto out;
+	}
+
+	/* First copy down the driver command */
+	if (copy_from_user(&driver_command, argp, sizeof(TW_Ioctl_Driver_Command)))
+		goto out2;
+
+	/* Check data buffer size */
+	if (driver_command.buffer_length > TW_MAX_SECTORS * 2048) {
+		retval = -EINVAL;
+		goto out2;
+	}
+
+	/* Hardware can only do multiple of 512 byte transfers */
+	data_buffer_length_adjusted = (driver_command.buffer_length + 511) & ~511;
+
+	/* Now allocate ioctl buf memory */
+	cpu_addr = dma_alloc_coherent(&tw_dev->tw_pci_dev->dev,
data_buffer_length_adjusted+sizeof(TW_Ioctl_Buf_Apache) - 1,
&dma_handle, GFP_KERNEL);
+	if (!cpu_addr) {
+		retval = -ENOMEM;
+		goto out2;
+	}
+
+	tw_ioctl = (TW_Ioctl_Buf_Apache *)cpu_addr;
+
+	/* Now copy down the entire ioctl */
+	if (copy_from_user(tw_ioctl, argp, driver_command.buffer_length +
sizeof(TW_Ioctl_Buf_Apache) - 1))
+		goto out3;
+
+	/* See which ioctl we are doing */
+	switch (cmd) {
+	case TW_IOCTL_FIRMWARE_PASS_THROUGH:
+		spin_lock_irqsave(tw_dev->host->host_lock, flags);
+		twl_get_request_id(tw_dev, &request_id);
+
+		/* Flag internal command */
+		tw_dev->srb[request_id] = NULL;
+
+		/* Flag chrdev ioctl */
+		tw_dev->chrdev_request_id = request_id;
+
+		full_command_packet = (TW_Command_Full *)&tw_ioctl->firmware_command;
+
+		/* Load request id and sglist for both command types */
+		twl_load_sgl(tw_dev, full_command_packet, request_id, dma_handle,
data_buffer_length_adjusted);
+
+		memcpy(tw_dev->command_packet_virt[request_id],
&(tw_ioctl->firmware_command), sizeof(TW_Command_Full));
+
+		/* Now post the command packet to the controller */
+		twl_post_command_packet(tw_dev, request_id);
+		spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+
+		timeout = TW_IOCTL_CHRDEV_TIMEOUT*HZ;
+
+		/* Now wait for command to complete */
+		timeout = wait_event_timeout(tw_dev->ioctl_wqueue,
tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE, timeout);
+
+		/* We timed out, and didn't get an interrupt */
+		if (tw_dev->chrdev_request_id != TW_IOCTL_CHRDEV_FREE) {
+			/* Now we need to reset the board */
+			printk(KERN_WARNING "3w-sas: scsi%d: WARNING: (0x%02X:0x%04X):
Character ioctl (0x%x) timed out, resetting card.\n",
+			       tw_dev->host->host_no, TW_DRIVER, 0x6,
+			       cmd);
+			retval = -EIO;
+			twl_reset_device_extension(tw_dev, 1);
+			goto out3;
+		}
+
+		/* Now copy in the command packet response */
+		memcpy(&(tw_ioctl->firmware_command),
tw_dev->command_packet_virt[request_id], sizeof(TW_Command_Full));
+		
+		/* Now complete the io */
+		spin_lock_irqsave(tw_dev->host->host_lock, flags);
+		tw_dev->posted_request_count--;
+		tw_dev->state[request_id] = TW_S_COMPLETED;
+		twl_free_request_id(tw_dev, request_id);
+		spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+		break;
+	default:
+		retval = -ENOTTY;
+		goto out3;
+	}
+
+	/* Now copy the entire response to userspace */
+	if (copy_to_user(argp, tw_ioctl, sizeof(TW_Ioctl_Buf_Apache) +
driver_command.buffer_length - 1) == 0)
+		retval = 0;
+out3:
+	/* Now free ioctl buf memory */
+	dma_free_coherent(&tw_dev->tw_pci_dev->dev,
data_buffer_length_adjusted+sizeof(TW_Ioctl_Buf_Apache) - 1, cpu_addr,
dma_handle);
+out2:
+	mutex_unlock(&tw_dev->ioctl_lock);
+out:
+	return retval;
+} /* End twl_chrdev_ioctl() */
+
+/* This function handles open for the character device */
+static int twl_chrdev_open(struct inode *inode, struct file *file)
+{
+	unsigned int minor_number;
+	int retval = -ENODEV;
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		retval = -EACCES;
+		goto out;
+	}
+
+	cycle_kernel_lock();
+	minor_number = iminor(inode);
+	if (minor_number >= twl_device_extension_count)
+		goto out;
+	retval = 0;
+out:
+	return retval;
+} /* End twl_chrdev_open() */
+
+/* File operations struct for character device */
+static const struct file_operations twl_fops = {
+	.owner		= THIS_MODULE,
+	.ioctl		= twl_chrdev_ioctl,
+	.open		= twl_chrdev_open,
+	.release	= NULL
+};
+
+/* This function passes sense data from firmware to scsi layer */
+static int twl_fill_sense(TW_Device_Extension *tw_dev, int i, int
request_id, int copy_sense, int print_host)
+{
+	TW_Command_Apache_Header *header;
+	TW_Command_Full *full_command_packet;
+	unsigned short error;
+	char *error_str;
+	int retval = 1;
+
+	header = tw_dev->sense_buffer_virt[i];
+	full_command_packet = tw_dev->command_packet_virt[request_id];
+
+	/* Get embedded firmware error string */
+	error_str = &(header->err_specific_desc[strlen(header->err_specific_desc)
+ 1]);
+
+	/* Don't print error for Logical unit not supported during rollcall */
+	error = le16_to_cpu(header->status_block.error);
+	if ((error != TW_ERROR_LOGICAL_UNIT_NOT_SUPPORTED) && (error !=
TW_ERROR_UNIT_OFFLINE) && (error != TW_ERROR_INVALID_FIELD_IN_CDB)) {
+		if (print_host)
+			printk(KERN_WARNING "3w-sas: scsi%d: ERROR: (0x%02X:0x%04X): %s:%s.\n",
+			       tw_dev->host->host_no,
+			       TW_MESSAGE_SOURCE_CONTROLLER_ERROR,
+			       header->status_block.error,
+			       error_str,
+			       header->err_specific_desc);
+		else
+			printk(KERN_WARNING "3w-sas: ERROR: (0x%02X:0x%04X): %s:%s.\n",
+			       TW_MESSAGE_SOURCE_CONTROLLER_ERROR,
+			       header->status_block.error,
+			       error_str,
+			       header->err_specific_desc);
+	}
+
+	if (copy_sense) {
+		memcpy(tw_dev->srb[request_id]->sense_buffer, header->sense_data,
TW_SENSE_DATA_LENGTH);
+		tw_dev->srb[request_id]->result =
(full_command_packet->command.newcommand.status << 1);
+		goto out;
+	}
+out:
+	return retval;
+} /* End twl_fill_sense() */
+
+/* This function will free up device extension resources */
+static void twl_free_device_extension(TW_Device_Extension *tw_dev)
+{
+	if (tw_dev->command_packet_virt[0])
+		pci_free_consistent(tw_dev->tw_pci_dev,
+				    sizeof(TW_Command_Full)*TW_Q_LENGTH,
+				    tw_dev->command_packet_virt[0],
+				    tw_dev->command_packet_phys[0]);
+
+	if (tw_dev->generic_buffer_virt[0])
+		pci_free_consistent(tw_dev->tw_pci_dev,
+				    TW_SECTOR_SIZE*TW_Q_LENGTH,
+				    tw_dev->generic_buffer_virt[0],
+				    tw_dev->generic_buffer_phys[0]);
+
+	if (tw_dev->sense_buffer_virt[0])
+		pci_free_consistent(tw_dev->tw_pci_dev,
+				    sizeof(TW_Command_Apache_Header)*
+				    TW_Q_LENGTH,
+				    tw_dev->sense_buffer_virt[0],
+				    tw_dev->sense_buffer_phys[0]);
+
+	kfree(tw_dev->event_queue[0]);
+} /* End twl_free_device_extension() */
+
+/* This function will get parameter table entries from the firmware */
+static void *twl_get_param(TW_Device_Extension *tw_dev, int
request_id, int table_id, int parameter_id, int parameter_size_bytes)
+{
+	TW_Command_Full *full_command_packet;
+	TW_Command *command_packet;
+	TW_Param_Apache *param;
+	void *retval = NULL;
+
+	/* Setup the command packet */
+	full_command_packet = tw_dev->command_packet_virt[request_id];
+	memset(full_command_packet, 0, sizeof(TW_Command_Full));
+	command_packet = &full_command_packet->command.oldcommand;
+
+	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_GET_PARAM);
+	command_packet->size              = TW_COMMAND_SIZE;
+	command_packet->request_id        = request_id;
+	command_packet->byte6_offset.block_count = cpu_to_le16(1);
+
+	/* Now setup the param */
+	param = (TW_Param_Apache *)tw_dev->generic_buffer_virt[request_id];
+	memset(param, 0, TW_SECTOR_SIZE);
+	param->table_id = cpu_to_le16(table_id | 0x8000);
+	param->parameter_id = cpu_to_le16(parameter_id);
+	param->parameter_size_bytes = cpu_to_le16(parameter_size_bytes);
+
+	command_packet->byte8_offset.param.sgl[0].address =
TW_CPU_TO_SGL(tw_dev->generic_buffer_phys[request_id]);
+	command_packet->byte8_offset.param.sgl[0].length =
TW_CPU_TO_SGL(TW_SECTOR_SIZE);
+
+	/* Post the command packet to the board */
+	twl_post_command_packet(tw_dev, request_id);
+
+	/* Poll for completion */
+	if (twl_poll_response(tw_dev, request_id, 30))
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x7, "No valid response during get param")
+	else
+		retval = (void *)&(param->data[0]);
+
+	tw_dev->posted_request_count--;
+	tw_dev->state[request_id] = TW_S_INITIAL;
+
+	return retval;
+} /* End twl_get_param() */
+
+/* This function will send an initconnection command to controller */
+static int twl_initconnection(TW_Device_Extension *tw_dev, int message_credits,
+ 			      u32 set_features, unsigned short current_fw_srl,
+			      unsigned short current_fw_arch_id,
+			      unsigned short current_fw_branch,
+			      unsigned short current_fw_build,
+			      unsigned short *fw_on_ctlr_srl,
+			      unsigned short *fw_on_ctlr_arch_id,
+			      unsigned short *fw_on_ctlr_branch,
+			      unsigned short *fw_on_ctlr_build,
+			      u32 *init_connect_result)
+{
+	TW_Command_Full *full_command_packet;
+	TW_Initconnect *tw_initconnect;
+	int request_id = 0, retval = 1;
+
+	/* Initialize InitConnection command packet */
+	full_command_packet = tw_dev->command_packet_virt[request_id];
+	memset(full_command_packet, 0, sizeof(TW_Command_Full));
+	full_command_packet->header.header_desc.size_header = 128;
+	
+	tw_initconnect = (TW_Initconnect *)&full_command_packet->command.oldcommand;
+	tw_initconnect->opcode__reserved = TW_OPRES_IN(0, TW_OP_INIT_CONNECTION);
+	tw_initconnect->request_id = request_id;
+	tw_initconnect->message_credits = cpu_to_le16(message_credits);
+	tw_initconnect->features = set_features;
+
+	/* Turn on 64-bit sgl support if we need to */
+	tw_initconnect->features |= sizeof(dma_addr_t) > 4 ? 1 : 0;
+
+	tw_initconnect->features = cpu_to_le32(tw_initconnect->features);
+
+	if (set_features & TW_EXTENDED_INIT_CONNECT) {
+		tw_initconnect->size = TW_INIT_COMMAND_PACKET_SIZE_EXTENDED;
+		tw_initconnect->fw_srl = cpu_to_le16(current_fw_srl);
+		tw_initconnect->fw_arch_id = cpu_to_le16(current_fw_arch_id);
+		tw_initconnect->fw_branch = cpu_to_le16(current_fw_branch);
+		tw_initconnect->fw_build = cpu_to_le16(current_fw_build);
+	} else
+		tw_initconnect->size = TW_INIT_COMMAND_PACKET_SIZE;
+
+	/* Send command packet to the board */
+	twl_post_command_packet(tw_dev, request_id);
+
+	/* Poll for completion */
+	if (twl_poll_response(tw_dev, request_id, 30)) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x8, "No valid response during
init connection");
+	} else {
+		if (set_features & TW_EXTENDED_INIT_CONNECT) {
+			*fw_on_ctlr_srl = le16_to_cpu(tw_initconnect->fw_srl);
+			*fw_on_ctlr_arch_id = le16_to_cpu(tw_initconnect->fw_arch_id);
+			*fw_on_ctlr_branch = le16_to_cpu(tw_initconnect->fw_branch);
+			*fw_on_ctlr_build = le16_to_cpu(tw_initconnect->fw_build);
+			*init_connect_result = le32_to_cpu(tw_initconnect->result);
+		}
+		retval = 0;
+	}
+
+	tw_dev->posted_request_count--;
+	tw_dev->state[request_id] = TW_S_INITIAL;
+
+	return retval;
+} /* End twl_initconnection() */
+
+/* This function will initialize the fields of a device extension */
+static int twl_initialize_device_extension(TW_Device_Extension *tw_dev)
+{
+	int i, retval = 1;
+
+	/* Initialize command packet buffers */
+	if (twl_allocate_memory(tw_dev, sizeof(TW_Command_Full), 0)) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x9, "Command packet memory
allocation failed");
+		goto out;
+	}
+
+	/* Initialize generic buffer */
+	if (twl_allocate_memory(tw_dev, TW_SECTOR_SIZE, 1)) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0xa, "Generic memory allocation failed");
+		goto out;
+	}
+
+	/* Allocate sense buffers */
+	if (twl_allocate_memory(tw_dev, sizeof(TW_Command_Apache_Header), 2)) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0xb, "Sense buffer allocation failed");
+		goto out;
+	}
+
+	/* Allocate event info space */
+	tw_dev->event_queue[0] = kcalloc(TW_Q_LENGTH, sizeof(TW_Event), GFP_KERNEL);
+	if (!tw_dev->event_queue[0]) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0xc, "Event info memory
allocation failed");
+		goto out;
+	}
+
+	for (i = 0; i < TW_Q_LENGTH; i++) {
+		tw_dev->event_queue[i] = (TW_Event *)((unsigned char
*)tw_dev->event_queue[0] + (i * sizeof(TW_Event)));
+		tw_dev->free_queue[i] = i;
+		tw_dev->state[i] = TW_S_INITIAL;
+	}
+
+	tw_dev->free_head = TW_Q_START;
+	tw_dev->free_tail = TW_Q_START;
+	tw_dev->error_sequence_id = 1;
+	tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
+
+	mutex_init(&tw_dev->ioctl_lock);
+	init_waitqueue_head(&tw_dev->ioctl_wqueue);
+
+	retval = 0;
+out:
+	return retval;
+} /* End twl_initialize_device_extension() */
+
+/* This function will perform a pci-dma unmap */
+static void twl_unmap_scsi_data(TW_Device_Extension *tw_dev, int request_id)
+{
+	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
+
+	if (cmd->SCp.phase == TW_PHASE_SGLIST)
+		scsi_dma_unmap(cmd);
+} /* End twl_unmap_scsi_data() */
+
+/* This function will handle attention interrupts */
+static int twl_handle_attention_interrupt(TW_Device_Extension *tw_dev)
+{
+	int retval = 1;
+	u32 request_id, doorbell;
+
+	/* Read doorbell status */
+	doorbell = readl(TWL_HOBDB_REG_ADDR(tw_dev));
+
+	/* Check for controller errors */
+	if (doorbell & TWL_DOORBELL_CONTROLLER_ERROR) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0xd, "Microcontroller Error: clearing");
+		goto out;
+	}
+
+	/* Check if we need to perform an AEN drain */
+	if (doorbell & TWL_DOORBELL_ATTENTION_INTERRUPT) {
+		if (!(test_and_set_bit(TW_IN_ATTENTION_LOOP, &tw_dev->flags))) {
+			twl_get_request_id(tw_dev, &request_id);
+			if (twl_aen_read_queue(tw_dev, request_id)) {
+				tw_dev->state[request_id] = TW_S_COMPLETED;
+				twl_free_request_id(tw_dev, request_id);
+				clear_bit(TW_IN_ATTENTION_LOOP, &tw_dev->flags);
+			}
+		}
+	}
+
+	retval = 0;
+out:
+	/* Clear doorbell interrupt */
+	TWL_CLEAR_DB_INTERRUPT(tw_dev);
+
+	/* Make sure the clear was flushed by reading it back */
+	readl(TWL_HOBDBC_REG_ADDR(tw_dev));
+
+	return retval;
+} /* End twl_handle_attention_interrupt() */
+
+/* Interrupt service routine */
+static irqreturn_t twl_interrupt(int irq, void *dev_instance)
+{
+	TW_Device_Extension *tw_dev = (TW_Device_Extension *)dev_instance;
+	int i, handled = 0, error = 0;
+	dma_addr_t mfa = 0;
+	u32 reg, regl, regh, response, request_id = 0;
+	struct scsi_cmnd *cmd;
+	TW_Command_Full *full_command_packet;
+
+	spin_lock(tw_dev->host->host_lock);
+
+	/* Read host interrupt status */
+	reg = readl(TWL_HISTAT_REG_ADDR(tw_dev));
+
+	/* Check if this is our interrupt, otherwise bail */
+	if (!(reg & TWL_HISTATUS_VALID_INTERRUPT))
+		goto twl_interrupt_bail;
+
+	handled = 1;
+
+	/* If we are resetting, bail */
+	if (test_bit(TW_IN_RESET, &tw_dev->flags))
+		goto twl_interrupt_bail;
+
+	/* Attention interrupt */
+	if (reg & TWL_HISTATUS_ATTENTION_INTERRUPT) {
+		if (twl_handle_attention_interrupt(tw_dev)) {
+			TWL_MASK_INTERRUPTS(tw_dev);
+			goto twl_interrupt_bail;
+		}
+	}
+
+	/* Response interrupt */
+	while (reg & TWL_HISTATUS_RESPONSE_INTERRUPT) {
+		if (sizeof(dma_addr_t) > 4) {
+			regh = readl(TWL_HOBQPH_REG_ADDR(tw_dev));
+			regl = readl(TWL_HOBQPL_REG_ADDR(tw_dev));
+			mfa = ((u64)regh << 32) | regl;
+		} else
+			mfa = readl(TWL_HOBQPL_REG_ADDR(tw_dev));
+
+		error = 0;
+		response = (u32)mfa;
+
+		/* Check for command packet error */
+		if (!TW_NOTMFA_OUT(response)) {
+			for (i=0;i<TW_Q_LENGTH;i++) {
+				if (tw_dev->sense_buffer_phys[i] == mfa) {
+					request_id =
le16_to_cpu(tw_dev->sense_buffer_virt[i]->header_desc.request_id);
+					if (tw_dev->srb[request_id] != NULL)
+						error = twl_fill_sense(tw_dev, i, request_id, 1, 1);
+					else {
+						/* Skip ioctl error prints */
+						if (request_id != tw_dev->chrdev_request_id)
+							error = twl_fill_sense(tw_dev, i, request_id, 0, 1);
+						else
+							memcpy(tw_dev->command_packet_virt[request_id],
tw_dev->sense_buffer_virt[i], sizeof(TW_Command_Apache_Header));
+					}
+
+					/* Now re-post the sense buffer */
+					writel((u32)((u64)tw_dev->sense_buffer_phys[i] >> 32),
TWL_HOBQPH_REG_ADDR(tw_dev));
+					writel((u32)tw_dev->sense_buffer_phys[i], TWL_HOBQPL_REG_ADDR(tw_dev));
+					break;
+				}
+			}
+		} else
+			request_id = TW_RESID_OUT(response);
+
+		full_command_packet = tw_dev->command_packet_virt[request_id];
+
+		/* Check for correct state */
+		if (tw_dev->state[request_id] != TW_S_POSTED) {
+			if (tw_dev->srb[request_id] != NULL) {
+				TW_PRINTK(tw_dev->host, TW_DRIVER, 0xe, "Received a request id
that wasn't posted");
+				TWL_MASK_INTERRUPTS(tw_dev);
+				goto twl_interrupt_bail;
+			}
+		}
+
+		/* Check for internal command completion */
+		if (tw_dev->srb[request_id] == NULL) {
+			if (request_id != tw_dev->chrdev_request_id) {
+				if (twl_aen_complete(tw_dev, request_id))
+					TW_PRINTK(tw_dev->host, TW_DRIVER, 0xf, "Error completing AEN
during attention interrupt");
+			} else {
+				tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
+				wake_up(&tw_dev->ioctl_wqueue);
+			}
+		} else {
+			cmd = tw_dev->srb[request_id];
+
+			if (!error)
+				cmd->result = (DID_OK << 16);
+			
+			/* Report residual bytes for single sgl */
+			if ((scsi_sg_count(cmd) <= 1) &&
(full_command_packet->command.newcommand.status == 0)) {
+				if (full_command_packet->command.newcommand.sg_list[0].length <
scsi_bufflen(tw_dev->srb[request_id]))
+					scsi_set_resid(cmd, scsi_bufflen(cmd) -
full_command_packet->command.newcommand.sg_list[0].length);
+			}
+
+			/* Now complete the io */
+			tw_dev->state[request_id] = TW_S_COMPLETED;
+			twl_free_request_id(tw_dev, request_id);
+			tw_dev->posted_request_count--;
+			tw_dev->srb[request_id]->scsi_done(tw_dev->srb[request_id]);
+			twl_unmap_scsi_data(tw_dev, request_id);
+		}
+
+		/* Check for another response interrupt */
+		reg = readl(TWL_HISTAT_REG_ADDR(tw_dev));
+	}
+
+twl_interrupt_bail:
+	spin_unlock(tw_dev->host->host_lock);
+	return IRQ_RETVAL(handled);
+} /* End twl_interrupt() */
+
+/* This function will poll for a register change */
+static int twl_poll_register(TW_Device_Extension *tw_dev, void *reg,
u32 value, u32 result, int seconds)
+{
+	unsigned long before;
+	int retval = 1;
+	u32 reg_value;
+
+	reg_value = readl(reg);
+	before = jiffies;
+
+        while ((reg_value & value) != result) {
+		reg_value = readl(reg);
+		if (time_after(jiffies, before + HZ * seconds))
+			goto out;
+		msleep(50);
+	}
+	retval = 0;
+out:
+	return retval;
+} /* End twl_poll_register() */
+
+/* This function will reset a controller */
+static int twl_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset)
+{
+	int retval = 1;
+	int i = 0;
+	u32 status = 0;
+	unsigned short fw_on_ctlr_srl = 0, fw_on_ctlr_arch_id = 0;
+	unsigned short fw_on_ctlr_branch = 0, fw_on_ctlr_build = 0;
+	u32 init_connect_result = 0;
+	int tries = 0;
+	int do_soft_reset = soft_reset;
+
+	while (tries < TW_MAX_RESET_TRIES) {
+		/* Do a soft reset if one is needed */
+		if (do_soft_reset) {
+			TWL_SOFT_RESET(tw_dev);
+
+			/* Make sure controller is in a good state */
+			if (twl_poll_register(tw_dev, TWL_SCRPD3_REG_ADDR(tw_dev),
TWL_CONTROLLER_READY, 0x0, 30)) {
+				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x10, "Controller never went
non-ready during reset sequence");
+				tries++;
+				continue;
+			}
+			if (twl_poll_register(tw_dev, TWL_SCRPD3_REG_ADDR(tw_dev),
TWL_CONTROLLER_READY, TWL_CONTROLLER_READY, 60)) {
+				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x11, "Controller not ready
during reset sequence");
+				tries++;
+				continue;
+			}
+		}
+
+		/* Initconnect */
+		if (twl_initconnection(tw_dev, TW_INIT_MESSAGE_CREDITS,
+				       TW_EXTENDED_INIT_CONNECT, TW_CURRENT_DRIVER_SRL,
+				       TW_9750_ARCH_ID, TW_CURRENT_DRIVER_BRANCH,
+				       TW_CURRENT_DRIVER_BUILD, &fw_on_ctlr_srl,
+				       &fw_on_ctlr_arch_id, &fw_on_ctlr_branch,
+				       &fw_on_ctlr_build, &init_connect_result)) {
+			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x12, "Initconnection failed
while checking SRL");
+			do_soft_reset = 1;
+			tries++;
+			continue;
+		}
+
+		/* Load sense buffers */
+		while (i < TW_Q_LENGTH) {
+			writel((u32)((u64)tw_dev->sense_buffer_phys[i] >> 32),
TWL_HOBQPH_REG_ADDR(tw_dev));
+			writel((u32)tw_dev->sense_buffer_phys[i], TWL_HOBQPL_REG_ADDR(tw_dev));
+
+			/* Check status for over-run after each write */
+			status = readl(TWL_STATUS_REG_ADDR(tw_dev));
+			if (!(status & TWL_STATUS_OVERRUN_SUBMIT))
+			    i++;
+		}
+
+		/* Now check status */
+		status = readl(TWL_STATUS_REG_ADDR(tw_dev));
+		if (status) {
+			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x13, "Bad controller status
after loading sense buffers");
+			do_soft_reset = 1;
+			tries++;
+			continue;
+		}
+
+		/* Drain the AEN queue */
+		if (twl_aen_drain_queue(tw_dev, soft_reset)) {
+			TW_PRINTK(tw_dev->host, TW_DRIVER, 0x14, "AEN drain failed during
reset sequence");
+			do_soft_reset = 1;
+			tries++;
+			continue;
+		}
+
+		/* Load rest of compatibility struct */
+		strncpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION,
strlen(TW_DRIVER_VERSION));
+		tw_dev->tw_compat_info.driver_srl_high = TW_CURRENT_DRIVER_SRL;
+		tw_dev->tw_compat_info.driver_branch_high = TW_CURRENT_DRIVER_BRANCH;
+		tw_dev->tw_compat_info.driver_build_high = TW_CURRENT_DRIVER_BUILD;
+		tw_dev->tw_compat_info.driver_srl_low = TW_BASE_FW_SRL;
+		tw_dev->tw_compat_info.driver_branch_low = TW_BASE_FW_BRANCH;
+		tw_dev->tw_compat_info.driver_build_low = TW_BASE_FW_BUILD;
+		tw_dev->tw_compat_info.fw_on_ctlr_srl = fw_on_ctlr_srl;
+		tw_dev->tw_compat_info.fw_on_ctlr_branch = fw_on_ctlr_branch;
+		tw_dev->tw_compat_info.fw_on_ctlr_build = fw_on_ctlr_build;
+
+		/* If we got here, controller is in a good state */
+		retval = 0;
+		goto out;
+	}
+out:
+	return retval;
+} /* End twl_reset_sequence() */
+
+/* This function will reset a device extension */
+static int twl_reset_device_extension(TW_Device_Extension *tw_dev,
int ioctl_reset)
+{
+	int i = 0, retval = 1;
+	unsigned long flags = 0;
+
+	/* Block SCSI requests while we are resetting */
+	if (ioctl_reset)
+		scsi_block_requests(tw_dev->host);
+
+	set_bit(TW_IN_RESET, &tw_dev->flags);
+	TWL_MASK_INTERRUPTS(tw_dev);
+	TWL_CLEAR_DB_INTERRUPT(tw_dev);
+
+	spin_lock_irqsave(tw_dev->host->host_lock, flags);
+
+	/* Abort all requests that are in progress */
+	for (i = 0; i < TW_Q_LENGTH; i++) {
+		if ((tw_dev->state[i] != TW_S_FINISHED) &&
+		    (tw_dev->state[i] != TW_S_INITIAL) &&
+		    (tw_dev->state[i] != TW_S_COMPLETED)) {
+			if (tw_dev->srb[i]) {
+				tw_dev->srb[i]->result = (DID_RESET << 16);
+				tw_dev->srb[i]->scsi_done(tw_dev->srb[i]);
+				twl_unmap_scsi_data(tw_dev, i);
+			}
+		}
+	}
+
+	/* Reset queues and counts */
+	for (i = 0; i < TW_Q_LENGTH; i++) {
+		tw_dev->free_queue[i] = i;
+		tw_dev->state[i] = TW_S_INITIAL;
+	}
+	tw_dev->free_head = TW_Q_START;
+	tw_dev->free_tail = TW_Q_START;
+	tw_dev->posted_request_count = 0;
+
+	spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+
+	if (twl_reset_sequence(tw_dev, 1))
+		goto out;
+
+	TWL_UNMASK_INTERRUPTS(tw_dev);
+
+	clear_bit(TW_IN_RESET, &tw_dev->flags);
+	tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
+
+	retval = 0;
+out:
+	if (ioctl_reset)
+		scsi_unblock_requests(tw_dev->host);
+	return retval;
+} /* End twl_reset_device_extension() */
+
+/* This funciton returns unit geometry in cylinders/heads/sectors */
+static int twl_scsi_biosparam(struct scsi_device *sdev, struct
block_device *bdev, sector_t capacity, int geom[])
+{
+	int heads, sectors;
+	TW_Device_Extension *tw_dev;
+
+	tw_dev = (TW_Device_Extension *)sdev->host->hostdata;
+
+	if (capacity >= 0x200000) {
+		heads = 255;
+		sectors = 63;
+	} else {
+		heads = 64;
+		sectors = 32;
+	}
+
+	geom[0] = heads;
+	geom[1] = sectors;
+	geom[2] = sector_div(capacity, heads * sectors); /* cylinders */
+
+	return 0;
+} /* End twl_scsi_biosparam() */
+
+/* This is the new scsi eh reset function */
+static int twl_scsi_eh_reset(struct scsi_cmnd *SCpnt)
+{
+	TW_Device_Extension *tw_dev = NULL;
+	int retval = FAILED;
+
+	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
+
+	tw_dev->num_resets++;
+
+	sdev_printk(KERN_WARNING, SCpnt->device,
+		"WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card.\n",
+		TW_DRIVER, 0x2c, SCpnt->cmnd[0]);
+
+	/* Make sure we are not issuing an ioctl or resetting from ioctl */
+	mutex_lock(&tw_dev->ioctl_lock);
+
+	/* Now reset the card and some of the device extension data */
+	if (twl_reset_device_extension(tw_dev, 0)) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x15, "Controller reset failed
during scsi host reset");
+		goto out;
+	}
+
+	retval = SUCCESS;
+out:
+	mutex_unlock(&tw_dev->ioctl_lock);
+	return retval;
+} /* End twl_scsi_eh_reset() */
+
+/* This is the main scsi queue function to handle scsi opcodes */
+static int twl_scsi_queue(struct scsi_cmnd *SCpnt, void
(*done)(struct scsi_cmnd *))
+{
+	int request_id, retval;
+	TW_Device_Extension *tw_dev = (TW_Device_Extension
*)SCpnt->device->host->hostdata;
+
+	/* If we are resetting due to timed out ioctl, report as busy */
+	if (test_bit(TW_IN_RESET, &tw_dev->flags)) {
+		retval = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	}
+
+	/* Save done function into scsi_cmnd struct */
+	SCpnt->scsi_done = done;
+		
+	/* Get a free request id */
+	twl_get_request_id(tw_dev, &request_id);
+
+	/* Save the scsi command for use by the ISR */
+	tw_dev->srb[request_id] = SCpnt;
+
+	/* Initialize phase to zero */
+	SCpnt->SCp.phase = TW_PHASE_INITIAL;
+
+	retval = twl_scsiop_execute_scsi(tw_dev, request_id, NULL, 0, NULL);
+	if (retval) {
+		tw_dev->state[request_id] = TW_S_COMPLETED;
+		twl_free_request_id(tw_dev, request_id);
+		SCpnt->result = (DID_ERROR << 16);
+		done(SCpnt);
+		retval = 0;
+	}
+out:
+	return retval;
+} /* End twl_scsi_queue() */
+
+/* This function tells the controller to shut down */
+static void __twl_shutdown(TW_Device_Extension *tw_dev)
+{
+	/* Disable interrupts */
+	TWL_MASK_INTERRUPTS(tw_dev);
+
+	/* Free up the IRQ */
+	free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
+
+	printk(KERN_WARNING "3w-sas: Shutting down host %d.\n",
tw_dev->host->host_no);
+
+	/* Tell the card we are shutting down */
+	if (twl_initconnection(tw_dev, 1, 0, 0, 0, 0, 0, NULL, NULL, NULL,
NULL, NULL)) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x16, "Connection shutdown failed");
+	} else {
+		printk(KERN_WARNING "3w-sas: Shutdown complete.\n");
+	}
+
+	/* Clear doorbell interrupt just before exit */
+	TWL_CLEAR_DB_INTERRUPT(tw_dev);
+} /* End __twl_shutdown() */
+
+/* Wrapper for __twl_shutdown */
+static void twl_shutdown(struct pci_dev *pdev)
+{
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	TW_Device_Extension *tw_dev;
+
+	if (!host)
+		return;
+
+	tw_dev = (TW_Device_Extension *)host->hostdata;
+
+	if (tw_dev->online)
+		__twl_shutdown(tw_dev);
+} /* End twl_shutdown() */
+
+/* This function configures unit settings when a unit is coming on-line */
+static int twl_slave_configure(struct scsi_device *sdev)
+{
+	/* Force 60 second timeout */
+	blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
+
+	return 0;
+} /* End twl_slave_configure() */
+
+/* scsi_host_template initializer */
+static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
+	.name			= "3w-sas",
+	.queuecommand		= twl_scsi_queue,
+	.eh_host_reset_handler	= twl_scsi_eh_reset,
+	.bios_param		= twl_scsi_biosparam,
+	.change_queue_depth	= twl_change_queue_depth,
+	.can_queue		= TW_Q_LENGTH-2,
+	.slave_configure	= twl_slave_configure,
+	.this_id		= -1,
+	.sg_tablesize		= TW_LIBERATOR_MAX_SGL_LENGTH,
+	.max_sectors		= TW_MAX_SECTORS,
+	.cmd_per_lun		= TW_MAX_CMDS_PER_LUN,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.shost_attrs		= twl_host_attrs,
+	.emulated		= 1
+};
+
+/* This function will probe and initialize a card */
+static int __devinit twl_probe(struct pci_dev *pdev, const struct
pci_device_id *dev_id)
+{
+	struct Scsi_Host *host = NULL;
+	TW_Device_Extension *tw_dev;
+	int retval = -ENODEV;
+	int *ptr_phycount, phycount=0;
+
+	retval = pci_enable_device(pdev);
+	if (retval) {
+		TW_PRINTK(host, TW_DRIVER, 0x17, "Failed to enable pci device");
+		goto out_disable_device;
+	}
+
+	pci_set_master(pdev);
+	pci_try_set_mwi(pdev);
+
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
+	    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
+		    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
+			TW_PRINTK(host, TW_DRIVER, 0x18, "Failed to set dma mask");
+			retval = -ENODEV;
+			goto out_disable_device;
+		}
+
+	host = scsi_host_alloc(&driver_template, sizeof(TW_Device_Extension));
+	if (!host) {
+		TW_PRINTK(host, TW_DRIVER, 0x19, "Failed to allocate memory for
device extension");
+		retval = -ENOMEM;
+		goto out_disable_device;
+	}
+	tw_dev = shost_priv(host);
+
+	/* Save values to device extension */
+	tw_dev->host = host;
+	tw_dev->tw_pci_dev = pdev;
+
+	if (twl_initialize_device_extension(tw_dev)) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1a, "Failed to initialize
device extension");
+		goto out_free_device_extension;
+	}
+
+	/* Request IO regions */
+	retval = pci_request_regions(pdev, "3w-sas");
+	if (retval) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1b, "Failed to get mem region");
+		goto out_free_device_extension;
+	}
+
+	/* Save base address, use region 1 */
+	tw_dev->base_addr = pci_iomap(pdev, 1, 0);
+	if (!tw_dev->base_addr) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1c, "Failed to ioremap");
+		goto out_release_mem_region;
+	}
+
+	/* Disable interrupts on the card */
+	TWL_MASK_INTERRUPTS(tw_dev);
+
+	/* Initialize the card */
+	if (twl_reset_sequence(tw_dev, 0)) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1d, "Controller reset failed
during probe");
+		goto out_iounmap;
+	}
+
+	/* Set host specific parameters */
+	host->max_id = TW_MAX_UNITS;
+	host->max_cmd_len = TW_MAX_CDB_LEN;
+	host->max_lun = TW_MAX_LUNS;
+	host->max_channel = 0;
+
+	/* Register the card with the kernel SCSI layer */
+	retval = scsi_add_host(host, &pdev->dev);
+	if (retval) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1e, "scsi add host failed");
+		goto out_iounmap;
+	}
+
+	pci_set_drvdata(pdev, host);
+
+	printk(KERN_WARNING "3w-sas: scsi%d: Found an LSI 3ware %s
Controller at 0x%llx, IRQ: %d.\n",
+	       host->host_no,
+	       (char *)twl_get_param(tw_dev, 1, TW_VERSION_TABLE,
+				     TW_PARAM_MODEL, TW_PARAM_MODEL_LENGTH),
+	       (u64)pci_resource_start(pdev, 1), pdev->irq);
+
+	ptr_phycount = twl_get_param(tw_dev, 2, TW_PARAM_PHY_SUMMARY_TABLE,
+				     TW_PARAM_PHYCOUNT, TW_PARAM_PHYCOUNT_LENGTH);
+	if (ptr_phycount)
+		phycount = le32_to_cpu(*(int *)ptr_phycount);
+
+	printk(KERN_WARNING "3w-sas: scsi%d: Firmware %s, BIOS %s, Phys: %d.\n",
+	       host->host_no,
+	       (char *)twl_get_param(tw_dev, 1, TW_VERSION_TABLE,
+				     TW_PARAM_FWVER, TW_PARAM_FWVER_LENGTH),
+	       (char *)twl_get_param(tw_dev, 2, TW_VERSION_TABLE,
+				     TW_PARAM_BIOSVER, TW_PARAM_BIOSVER_LENGTH),
+	       phycount);
+
+	/* Try to enable MSI */
+	if (use_msi && !pci_enable_msi(pdev))
+		set_bit(TW_USING_MSI, &tw_dev->flags);
+
+	/* Now setup the interrupt handler */
+	retval = request_irq(pdev->irq, twl_interrupt, IRQF_SHARED, "3w-sas", tw_dev);
+	if (retval) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1f, "Error requesting IRQ");
+		goto out_remove_host;
+	}
+
+	twl_device_extension_list[twl_device_extension_count] = tw_dev;
+	twl_device_extension_count++;
+
+	/* Re-enable interrupts on the card */
+	TWL_UNMASK_INTERRUPTS(tw_dev);
+	
+	/* Finally, scan the host */
+	scsi_scan_host(host);
+
+	/* Add sysfs binary files */
+	if (sysfs_create_bin_file(&host->shost_dev.kobj, &twl_sysfs_aen_read_attr))
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x20, "Failed to create sysfs
binary file: 3ware_aen_read");
+	if (sysfs_create_bin_file(&host->shost_dev.kobj, &twl_sysfs_compat_info_attr))
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x21, "Failed to create sysfs
binary file: 3ware_compat_info");
+
+	if (twl_major == -1) {
+		if ((twl_major = register_chrdev (0, "twl", &twl_fops)) < 0)
+			TW_PRINTK(host, TW_DRIVER, 0x22, "Failed to register character device");
+	}
+	tw_dev->online = 1;
+	return 0;
+
+out_remove_host:
+	if (test_bit(TW_USING_MSI, &tw_dev->flags))
+		pci_disable_msi(pdev);
+	scsi_remove_host(host);
+out_iounmap:
+	iounmap(tw_dev->base_addr);
+out_release_mem_region:
+	pci_release_regions(pdev);
+out_free_device_extension:
+	twl_free_device_extension(tw_dev);
+	scsi_host_put(host);
+out_disable_device:
+	pci_disable_device(pdev);
+
+	return retval;
+} /* End twl_probe() */
+
+/* This function is called to remove a device */
+static void twl_remove(struct pci_dev *pdev)
+{
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	TW_Device_Extension *tw_dev;
+
+	if (!host)
+		return;
+
+	tw_dev = (TW_Device_Extension *)host->hostdata;
+
+	if (!tw_dev->online)
+		return;
+
+	/* Remove sysfs binary files */
+	sysfs_remove_bin_file(&host->shost_dev.kobj, &twl_sysfs_aen_read_attr);
+	sysfs_remove_bin_file(&host->shost_dev.kobj, &twl_sysfs_compat_info_attr);
+
+	scsi_remove_host(tw_dev->host);
+
+	/* Unregister character device */
+	if (twl_major >= 0) {
+		unregister_chrdev(twl_major, "twl");
+		twl_major = -1;
+	}
+
+	/* Shutdown the card */
+	__twl_shutdown(tw_dev);
+
+	/* Disable MSI if enabled */
+	if (test_bit(TW_USING_MSI, &tw_dev->flags))
+		pci_disable_msi(pdev);
+
+	/* Free IO remapping */
+	iounmap(tw_dev->base_addr);
+
+	/* Free up the mem region */
+	pci_release_regions(pdev);
+
+	/* Free up device extension resources */
+	twl_free_device_extension(tw_dev);
+
+	scsi_host_put(tw_dev->host);
+	pci_disable_device(pdev);
+	twl_device_extension_count--;
+} /* End twl_remove() */
+
+#ifdef CONFIG_PM
+/* This function is called on PCI suspend */
+static int twl_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
+
+	printk(KERN_WARNING "3w-sas: Suspending host %d.\n", tw_dev->host->host_no);
+	/* Disable interrupts */
+	TWL_MASK_INTERRUPTS(tw_dev);
+
+	free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
+
+	/* Tell the card we are shutting down */
+	if (twl_initconnection(tw_dev, 1, 0, 0, 0, 0, 0, NULL, NULL, NULL,
NULL, NULL)) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x23, "Connection shutdown
failed during suspend");
+	} else {
+		printk(KERN_WARNING "3w-sas: Suspend complete.\n");
+	}
+
+	/* Clear doorbell interrupt */
+	TWL_CLEAR_DB_INTERRUPT(tw_dev);
+
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+	return 0;
+} /* End twl_suspend() */
+
+/* This function is called on PCI resume */
+static int twl_resume(struct pci_dev *pdev)
+{
+	int retval = 0;
+	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	TW_Device_Extension *tw_dev = (TW_Device_Extension *)host->hostdata;
+
+	printk(KERN_WARNING "3w-sas: Resuming host %d.\n", tw_dev->host->host_no);
+	pci_set_power_state(pdev, PCI_D0);
+	pci_enable_wake(pdev, PCI_D0, 0);
+	pci_restore_state(pdev);
+
+	retval = pci_enable_device(pdev);
+	if (retval) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x24, "Enable device failed
during resume");
+		return retval;
+	}
+
+	pci_set_master(pdev);
+	pci_try_set_mwi(pdev);
+
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
+	    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)))
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
+		    || pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32))) {
+			TW_PRINTK(host, TW_DRIVER, 0x25, "Failed to set dma mask during resume");
+			retval = -ENODEV;
+			goto out_disable_device;
+		}
+
+	/* Initialize the card */
+	if (twl_reset_sequence(tw_dev, 0)) {
+		retval = -ENODEV;
+		goto out_disable_device;
+	}
+
+	/* Now setup the interrupt handler */
+	retval = request_irq(pdev->irq, twl_interrupt, IRQF_SHARED, "3w-sas", tw_dev);
+	if (retval) {
+		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x26, "Error requesting IRQ
during resume");
+		retval = -ENODEV;
+		goto out_disable_device;
+	}
+
+	/* Now enable MSI if enabled */
+	if (test_bit(TW_USING_MSI, &tw_dev->flags))
+		pci_enable_msi(pdev);
+
+	/* Re-enable interrupts on the card */
+	TWL_UNMASK_INTERRUPTS(tw_dev);
+
+	printk(KERN_WARNING "3w-sas: Resume complete.\n");
+	return 0;
+
+out_disable_device:
+	scsi_remove_host(host);
+	pci_disable_device(pdev);
+
+	return retval;
+} /* End twl_resume() */
+#endif
+
+/* PCI Devices supported by this driver */
+static struct pci_device_id twl_pci_tbl[] __devinitdata = {
+	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9750) },
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, twl_pci_tbl);
+
+/* pci_driver initializer */
+static struct pci_driver twl_driver = {
+	.name		= "3w-sas",
+	.id_table	= twl_pci_tbl,
+	.probe		= twl_probe,
+	.remove		= twl_remove,
+#ifdef CONFIG_PM
+	.suspend	= twl_suspend,
+	.resume		= twl_resume,
+#endif
+	.shutdown	= twl_shutdown
+};
+
+/* This function is called on driver initialization */
+static int __init twl_init(void)
+{
+	printk(KERN_INFO "LSI 3ware SAS/SATA-RAID Controller device driver
for Linux v%s.\n", TW_DRIVER_VERSION);
+
+	return pci_register_driver(&twl_driver);
+} /* End twl_init() */
+
+/* This function is called on driver exit */
+static void __exit twl_exit(void)
+{
+	pci_unregister_driver(&twl_driver);
+} /* End twl_exit() */
+
+module_init(twl_init);
+module_exit(twl_exit);
+
diff -Naur linux-2.6.32-rc5-git1/drivers/scsi/3w-sas.h
linux-2.6.32-rc5-git1.new/drivers/scsi/3w-sas.h
--- linux-2.6.32-rc5-git1/drivers/scsi/3w-sas.h	1969-12-31
16:00:00.000000000 -0800
+++ linux-2.6.32-rc5-git1.new/drivers/scsi/3w-sas.h	2009-10-23
14:27:43.000000000 -0700
@@ -0,0 +1,396 @@
+/*
+   3w-sas.h -- LSI 3ware SAS/SATA-RAID Controller device driver for Linux.
+
+   Written By: Adam Radford <linuxraid@lsi.com>
+
+   Copyright (C) 2009 LSI Corporation.
+
+   This program is free software; you can redistribute it and/or modify
+   it under the terms of the GNU General Public License as published by
+   the Free Software Foundation; version 2 of the License.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   NO WARRANTY
+   THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
+   CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
+   LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
+   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
+   solely responsible for determining the appropriateness of using and
+   distributing the Program and assumes all risks associated with its
+   exercise of rights under this Agreement, including but not limited to
+   the risks and costs of program errors, damage to or loss of data,
+   programs or equipment, and unavailability or interruption of operations.
+
+   DISCLAIMER OF LIABILITY
+   NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
+   DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+   DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
+   ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
+   TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
+   USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS GRANTED
+   HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
+
+   You should have received a copy of the GNU General Public License
+   along with this program; if not, write to the Free Software
+   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+   Bugs/Comments/Suggestions should be mailed to:
+   linuxraid@lsi.com
+
+   For more information, goto:
+   http://www.lsi.com
+*/
+
+#ifndef _3W_SAS_H
+#define _3W_SAS_H
+
+/* AEN severity table */
+static char *twl_aen_severity_table[] =
+{
+	"None", "ERROR", "WARNING", "INFO", "DEBUG", NULL
+};
+
+/* Liberator register offsets */
+#define TWL_STATUS                         0x0  /* Status */
+#define TWL_HIBDB                          0x20 /* Inbound doorbell */
+#define TWL_HISTAT                         0x30 /* Host interrupt status */
+#define TWL_HIMASK                         0x34 /* Host interrupt mask */
+#define TWL_HOBDB			   0x9C /* Outbound doorbell */
+#define TWL_HOBDBC                         0xA0 /* Outbound doorbell clear */
+#define TWL_SCRPD3                         0xBC /* Scratchpad */
+#define TWL_HIBQPL                         0xC0 /* Host inbound Q low */
+#define TWL_HIBQPH                         0xC4 /* Host inbound Q high */
+#define TWL_HOBQPL                         0xC8 /* Host outbound Q low */
+#define TWL_HOBQPH                         0xCC /* Host outbound Q high */
+#define TWL_HISTATUS_VALID_INTERRUPT	   0xC
+#define TWL_HISTATUS_ATTENTION_INTERRUPT   0x4
+#define TWL_HISTATUS_RESPONSE_INTERRUPT	   0x8
+#define TWL_STATUS_OVERRUN_SUBMIT	   0x2000
+#define TWL_ISSUE_SOFT_RESET		   0x100
+#define TWL_CONTROLLER_READY		   0x2000
+#define TWL_DOORBELL_CONTROLLER_ERROR	   0x200000
+#define TWL_DOORBELL_ATTENTION_INTERRUPT   0x40000
+#define TWL_PULL_MODE			   0x1
+
+/* Command packet opcodes used by the driver */
+#define TW_OP_INIT_CONNECTION 0x1
+#define TW_OP_GET_PARAM	      0x12
+#define TW_OP_SET_PARAM	      0x13
+#define TW_OP_EXECUTE_SCSI    0x10
+
+/* Asynchronous Event Notification (AEN) codes used by the driver */
+#define TW_AEN_QUEUE_EMPTY       0x0000
+#define TW_AEN_SOFT_RESET        0x0001
+#define TW_AEN_SYNC_TIME_WITH_HOST 0x031
+#define TW_AEN_SEVERITY_ERROR    0x1
+#define TW_AEN_SEVERITY_DEBUG    0x4
+#define TW_AEN_NOT_RETRIEVED 0x1
+
+/* Command state defines */
+#define TW_S_INITIAL   0x1  /* Initial state */
+#define TW_S_STARTED   0x2  /* Id in use */
+#define TW_S_POSTED    0x4  /* Posted to the controller */
+#define TW_S_COMPLETED 0x8  /* Completed by isr */
+#define TW_S_FINISHED  0x10 /* I/O completely done */
+
+/* Compatibility defines */
+#define TW_9750_ARCH_ID 10
+#define TW_CURRENT_DRIVER_SRL 40
+#define TW_CURRENT_DRIVER_BUILD 0
+#define TW_CURRENT_DRIVER_BRANCH 0
+
+/* Phase defines */
+#define TW_PHASE_INITIAL 0
+#define TW_PHASE_SGLIST  2
+
+/* Misc defines */
+#define TW_SECTOR_SIZE                        512
+#define TW_MAX_UNITS			      32
+#define TW_INIT_MESSAGE_CREDITS		      0x100
+#define TW_INIT_COMMAND_PACKET_SIZE	      0x3
+#define TW_INIT_COMMAND_PACKET_SIZE_EXTENDED  0x6
+#define TW_EXTENDED_INIT_CONNECT	      0x2
+#define TW_BASE_FW_SRL			      24
+#define TW_BASE_FW_BRANCH		      0
+#define TW_BASE_FW_BUILD		      1
+#define TW_Q_LENGTH			      256
+#define TW_Q_START			      0
+#define TW_MAX_SLOT			      32
+#define TW_MAX_RESET_TRIES		      2
+#define TW_MAX_CMDS_PER_LUN		      254
+#define TW_MAX_AEN_DRAIN		      255
+#define TW_IN_RESET                           2
+#define TW_USING_MSI			      3
+#define TW_IN_ATTENTION_LOOP		      4
+#define TW_MAX_SECTORS                        256
+#define TW_MAX_CDB_LEN                        16
+#define TW_IOCTL_CHRDEV_TIMEOUT               60 /* 60 seconds */
+#define TW_IOCTL_CHRDEV_FREE                  -1
+#define TW_COMMAND_OFFSET                     128 /* 128 bytes */
+#define TW_VERSION_TABLE                      0x0402
+#define TW_TIMEKEEP_TABLE		      0x040A
+#define TW_INFORMATION_TABLE		      0x0403
+#define TW_PARAM_FWVER			      3
+#define TW_PARAM_FWVER_LENGTH		      16
+#define TW_PARAM_BIOSVER		      4
+#define TW_PARAM_BIOSVER_LENGTH		      16
+#define TW_PARAM_MODEL			      8
+#define TW_PARAM_MODEL_LENGTH		      16
+#define TW_PARAM_PHY_SUMMARY_TABLE	      1
+#define TW_PARAM_PHYCOUNT		      2
+#define TW_PARAM_PHYCOUNT_LENGTH	      1
+#define TW_IOCTL_FIRMWARE_PASS_THROUGH        0x108  // Used by smartmontools
+#define TW_ALLOCATION_LENGTH		      128
+#define TW_SENSE_DATA_LENGTH		      18
+#define TW_ERROR_LOGICAL_UNIT_NOT_SUPPORTED   0x10a
+#define TW_ERROR_INVALID_FIELD_IN_CDB	      0x10d
+#define TW_ERROR_UNIT_OFFLINE                 0x128
+#define TW_MESSAGE_SOURCE_CONTROLLER_ERROR    3
+#define TW_MESSAGE_SOURCE_CONTROLLER_EVENT    4
+#define TW_DRIVER 			      6
+#ifndef PCI_DEVICE_ID_3WARE_9750
+#define PCI_DEVICE_ID_3WARE_9750 0x1010
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
+/* not_mfa: 1, reserved: 7, status: 8, request_id: 16 */
+#define TW_RESID_OUT(x) ((x >> 16) & 0xffff)
+#define TW_NOTMFA_OUT(x) (x & 0x1)
+
+/* request_id: 12, lun: 4 */
+#define TW_REQ_LUN_IN(lun, request_id) (((lun << 12) & 0xf000) |
(request_id & 0xfff))
+#define TW_LUN_OUT(lun) ((lun >> 12) & 0xf)
+
+/* Register access macros */
+#define TWL_STATUS_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
+ TWL_STATUS)
+#define TWL_HOBQPL_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
+ TWL_HOBQPL)
+#define TWL_HOBQPH_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
+ TWL_HOBQPH)
+#define TWL_HOBDB_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
+ TWL_HOBDB)
+#define TWL_HOBDBC_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
+ TWL_HOBDBC)
+#define TWL_HIMASK_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
+ TWL_HIMASK)
+#define TWL_HISTAT_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
+ TWL_HISTAT)
+#define TWL_HIBQPH_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
+ TWL_HIBQPH)
+#define TWL_HIBQPL_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
+ TWL_HIBQPL)
+#define TWL_HIBDB_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
+ TWL_HIBDB)
+#define TWL_SCRPD3_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr
+ TWL_SCRPD3)
+#define TWL_MASK_INTERRUPTS(x) (writel(~0, TWL_HIMASK_REG_ADDR(tw_dev)))
+#define TWL_UNMASK_INTERRUPTS(x)
(writel(~TWL_HISTATUS_VALID_INTERRUPT, TWL_HIMASK_REG_ADDR(tw_dev)))
+#define TWL_CLEAR_DB_INTERRUPT(x) (writel(~0, TWL_HOBDBC_REG_ADDR(tw_dev)))
+#define TWL_SOFT_RESET(x) (writel(TWL_ISSUE_SOFT_RESET,
TWL_HIBDB_REG_ADDR(tw_dev)))
+
+/* Macros */
+#define TW_PRINTK(h,a,b,c) { \
+if (h) \
+printk(KERN_WARNING "3w-sas: scsi%d: ERROR: (0x%02X:0x%04X):
%s.\n",h->host_no,a,b,c); \
+else \
+printk(KERN_WARNING "3w-sas: ERROR: (0x%02X:0x%04X): %s.\n",a,b,c); \
+}
+#define TW_MAX_LUNS 16
+#define TW_COMMAND_SIZE (sizeof(dma_addr_t) > 4 ? 6 : 4)
+#define TW_LIBERATOR_MAX_SGL_LENGTH (sizeof(dma_addr_t) > 4 ? 46 : 92)
+#define TW_LIBERATOR_MAX_SGL_LENGTH_OLD (sizeof(dma_addr_t) > 4 ? 47 : 94)
+#define TW_PADDING_LENGTH_LIBERATOR 136
+#define TW_PADDING_LENGTH_LIBERATOR_OLD 132
+#define TW_CPU_TO_SGL(x) (sizeof(dma_addr_t) > 4 ? cpu_to_le64(x) :
cpu_to_le32(x))
+
+#pragma pack(1)
+
+/* SGL entry */
+typedef struct TAG_TW_SG_Entry_ISO {
+	dma_addr_t address;
+	dma_addr_t length;
+} TW_SG_Entry_ISO;
+
+/* Old Command Packet with ISO SGL */
+typedef struct TW_Command {
+	unsigned char opcode__sgloffset;
+	unsigned char size;
+	unsigned char request_id;
+	unsigned char unit__hostid;
+	/* Second DWORD */
+	unsigned char status;
+	unsigned char flags;
+	union {
+		unsigned short block_count;
+		unsigned short parameter_count;
+	} byte6_offset;
+	union {
+		struct {
+			u32 lba;
+			TW_SG_Entry_ISO sgl[TW_LIBERATOR_MAX_SGL_LENGTH_OLD];
+			unsigned char padding[TW_PADDING_LENGTH_LIBERATOR_OLD];
+		} io;
+		struct {
+			TW_SG_Entry_ISO sgl[TW_LIBERATOR_MAX_SGL_LENGTH_OLD];
+			u32 padding;
+			unsigned char padding2[TW_PADDING_LENGTH_LIBERATOR_OLD];
+		} param;
+	} byte8_offset;
+} TW_Command;
+
+/* New Command Packet with ISO SGL */
+typedef struct TAG_TW_Command_Apache {
+	unsigned char opcode__reserved;
+	unsigned char unit;
+	unsigned short request_id__lunl;
+	unsigned char status;
+	unsigned char sgl_offset;
+	unsigned short sgl_entries__lunh;
+	unsigned char cdb[16];
+	TW_SG_Entry_ISO sg_list[TW_LIBERATOR_MAX_SGL_LENGTH];
+	unsigned char padding[TW_PADDING_LENGTH_LIBERATOR];
+} TW_Command_Apache;
+
+/* New command packet header */
+typedef struct TAG_TW_Command_Apache_Header {
+	unsigned char sense_data[TW_SENSE_DATA_LENGTH];
+	struct {
+		char reserved[4];
+		unsigned short error;
+		unsigned char padding;
+		unsigned char severity__reserved;
+	} status_block;
+	unsigned char err_specific_desc[98];
+	struct {
+		unsigned char size_header;
+		unsigned short request_id;
+		unsigned char size_sense;
+	} header_desc;
+} TW_Command_Apache_Header;
+
+/* This struct is a union of the 2 command packets */
+typedef struct TAG_TW_Command_Full {
+	TW_Command_Apache_Header header;
+	union {
+		TW_Command oldcommand;
+		TW_Command_Apache newcommand;
+	} command;
+} TW_Command_Full;
+
+/* Initconnection structure */
+typedef struct TAG_TW_Initconnect {
+	unsigned char opcode__reserved;
+	unsigned char size;
+	unsigned char request_id;
+	unsigned char res2;
+	unsigned char status;
+	unsigned char flags;
+	unsigned short message_credits;
+	u32 features;
+	unsigned short fw_srl;
+	unsigned short fw_arch_id;
+	unsigned short fw_branch;
+	unsigned short fw_build;
+	u32 result;
+} TW_Initconnect;
+
+/* Event info structure */
+typedef struct TAG_TW_Event
+{
+	unsigned int sequence_id;
+	unsigned int time_stamp_sec;
+	unsigned short aen_code;
+	unsigned char severity;
+	unsigned char retrieved;
+	unsigned char repeat_count;
+	unsigned char parameter_len;
+	unsigned char parameter_data[98];
+} TW_Event;
+
+typedef struct TAG_TW_Ioctl_Driver_Command {
+	unsigned int control_code;
+	unsigned int status;
+	unsigned int unique_id;
+	unsigned int sequence_id;
+	unsigned int os_specific;
+	unsigned int buffer_length;
+} TW_Ioctl_Driver_Command;
+
+typedef struct TAG_TW_Ioctl_Apache {
+	TW_Ioctl_Driver_Command driver_command;
+        char padding[488];
+	TW_Command_Full firmware_command;
+	char data_buffer[1];
+} TW_Ioctl_Buf_Apache;
+
+/* GetParam descriptor */
+typedef struct {
+	unsigned short	table_id;
+	unsigned short	parameter_id;
+	unsigned short	parameter_size_bytes;
+	unsigned short  actual_parameter_size_bytes;
+	unsigned char	data[1];
+} TW_Param_Apache;
+
+/* Compatibility information structure */
+typedef struct TAG_TW_Compatibility_Info
+{
+	char driver_version[32];
+	unsigned short working_srl;
+	unsigned short working_branch;
+	unsigned short working_build;
+	unsigned short driver_srl_high;
+	unsigned short driver_branch_high;
+	unsigned short driver_build_high;
+	unsigned short driver_srl_low;
+	unsigned short driver_branch_low;
+	unsigned short driver_build_low;
+	unsigned short fw_on_ctlr_srl;
+	unsigned short fw_on_ctlr_branch;
+	unsigned short fw_on_ctlr_build;
+} TW_Compatibility_Info;
+
+#pragma pack()
+
+typedef struct TAG_TW_Device_Extension {
+	void                     __iomem *base_addr;
+	unsigned long	       	*generic_buffer_virt[TW_Q_LENGTH];
+	dma_addr_t	       	generic_buffer_phys[TW_Q_LENGTH];
+	TW_Command_Full	       	*command_packet_virt[TW_Q_LENGTH];
+	dma_addr_t		command_packet_phys[TW_Q_LENGTH];
+	TW_Command_Apache_Header *sense_buffer_virt[TW_Q_LENGTH];
+	dma_addr_t		sense_buffer_phys[TW_Q_LENGTH];
+	struct pci_dev		*tw_pci_dev;
+	struct scsi_cmnd	*srb[TW_Q_LENGTH];
+	unsigned char		free_queue[TW_Q_LENGTH];
+	unsigned char		free_head;
+	unsigned char		free_tail;
+	int     		state[TW_Q_LENGTH];
+	unsigned int		posted_request_count;
+	unsigned int		max_posted_request_count;
+	unsigned int		max_sgl_entries;
+	unsigned int		sgl_entries;
+	unsigned int		num_resets;
+	unsigned int		sector_count;
+	unsigned int		max_sector_count;
+	unsigned int		aen_count;
+	struct Scsi_Host	*host;
+	long			flags;
+	TW_Event                *event_queue[TW_Q_LENGTH];
+	unsigned char           error_index;
+	unsigned int            error_sequence_id;
+	int			chrdev_request_id;
+	wait_queue_head_t	ioctl_wqueue;
+	struct mutex		ioctl_lock;
+	TW_Compatibility_Info	tw_compat_info;
+	char			online;
+} TW_Device_Extension;
+
+#endif /* _3W_SAS_H */
+
diff -Naur linux-2.6.32-rc5-git1/drivers/scsi/Kconfig
linux-2.6.32-rc5-git1.new/drivers/scsi/Kconfig
--- linux-2.6.32-rc5-git1/drivers/scsi/Kconfig	2009-10-15
17:41:50.000000000 -0700
+++ linux-2.6.32-rc5-git1.new/drivers/scsi/Kconfig	2009-10-23
14:27:31.000000000 -0700
@@ -399,6 +399,17 @@
 	  Please read the comments at the top of
 	  <file:drivers/scsi/3w-9xxx.c>.

+config SCSI_3W_SAS
+	tristate "3ware 97xx SAS/SATA-RAID support"
+	depends on PCI && SCSI
+	help
+	  This driver supports the LSI 3ware 9750 6Gb/s SAS/SATA-RAID cards.
+
+	  <http://www.lsi.com>
+
+	  Please read the comments at the top of
+	  <file:drivers/scsi/3w-sas.c>.
+
 config SCSI_7000FASST
 	tristate "7000FASST SCSI support"
 	depends on ISA && SCSI && ISA_DMA_API
diff -Naur linux-2.6.32-rc5-git1/drivers/scsi/Makefile
linux-2.6.32-rc5-git1.new/drivers/scsi/Makefile
--- linux-2.6.32-rc5-git1/drivers/scsi/Makefile	2009-10-15
17:41:50.000000000 -0700
+++ linux-2.6.32-rc5-git1.new/drivers/scsi/Makefile	2009-10-23
14:27:25.000000000 -0700
@@ -113,6 +113,7 @@
 obj-$(CONFIG_SCSI_MAC53C94)	+= mac53c94.o
 obj-$(CONFIG_BLK_DEV_3W_XXXX_RAID) += 3w-xxxx.o
 obj-$(CONFIG_SCSI_3W_9XXX)	+= 3w-9xxx.o
+obj-$(CONFIG_SCSI_3W_SAS)	+= 3w-sas.o
 obj-$(CONFIG_SCSI_PPA)		+= ppa.o
 obj-$(CONFIG_SCSI_IMM)		+= imm.o
 obj-$(CONFIG_JAZZ_ESP)		+= esp_scsi.o	jazz_esp.o

--000e0cd66c88ae1e7f0476a13a1e
Content-Type: application/octet-stream;
	name="3ware_linux_2.6.32-rc5-git1.patch2"
Content-Disposition: attachment;
	filename="3ware_linux_2.6.32-rc5-git1.patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g15h0dlk0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzItcmM1LWdpdDEvZHJpdmVycy9zY3NpLzN3LXNhcy5jIGxp
bnV4LTIuNi4zMi1yYzUtZ2l0MS5uZXcvZHJpdmVycy9zY3NpLzN3LXNhcy5jCi0tLSBsaW51eC0y
LjYuMzItcmM1LWdpdDEvZHJpdmVycy9zY3NpLzN3LXNhcy5jCTE5NjktMTItMzEgMTY6MDA6MDAu
MDAwMDAwMDAwIC0wODAwCisrKyBsaW51eC0yLjYuMzItcmM1LWdpdDEubmV3L2RyaXZlcnMvc2Nz
aS8zdy1zYXMuYwkyMDA5LTEwLTIzIDE0OjI3OjM4LjAwMDAwMDAwMCAtMDcwMApAQCAtMCwwICsx
LDE5MjAgQEAKKy8qCisgICAzdy1zYXMuYyAtLSBMU0kgM3dhcmUgU0FTL1NBVEEtUkFJRCBDb250
cm9sbGVyIGRldmljZSBkcml2ZXIgZm9yIExpbnV4LgorCisgICBXcml0dGVuIEJ5OiBBZGFtIFJh
ZGZvcmQgPGxpbnV4cmFpZEBsc2kuY29tPgorCisgICBDb3B5cmlnaHQgKEMpIDIwMDkgTFNJIENv
cnBvcmF0aW9uLgorCisgICBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiBy
ZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQorICAgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRo
ZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQgYnkKKyAgIHRoZSBGcmVl
IFNvZnR3YXJlIEZvdW5kYXRpb247IHZlcnNpb24gMiBvZiB0aGUgTGljZW5zZS4KKworICAgVGhp
cyBwcm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIHRoYXQgaXQgd2lsbCBiZSB1c2Vm
dWwsCisgICBidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGll
ZCB3YXJyYW50eSBvZgorICAgTUVSQ0hBTlRBQklMSVRZIG9yIEZJVE5FU1MgRk9SIEEgUEFSVElD
VUxBUiBQVVJQT1NFLiAgU2VlIHRoZQorICAgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9y
IG1vcmUgZGV0YWlscy4KKworICAgTk8gV0FSUkFOVFkKKyAgIFRIRSBQUk9HUkFNIElTIFBST1ZJ
REVEIE9OIEFOICJBUyBJUyIgQkFTSVMsIFdJVEhPVVQgV0FSUkFOVElFUyBPUgorICAgQ09ORElU
SU9OUyBPRiBBTlkgS0lORCwgRUlUSEVSIEVYUFJFU1MgT1IgSU1QTElFRCBJTkNMVURJTkcsIFdJ
VEhPVVQKKyAgIExJTUlUQVRJT04sIEFOWSBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgVElU
TEUsIE5PTi1JTkZSSU5HRU1FTlQsCisgICBNRVJDSEFOVEFCSUxJVFkgT1IgRklUTkVTUyBGT1Ig
QSBQQVJUSUNVTEFSIFBVUlBPU0UuIEVhY2ggUmVjaXBpZW50IGlzCisgICBzb2xlbHkgcmVzcG9u
c2libGUgZm9yIGRldGVybWluaW5nIHRoZSBhcHByb3ByaWF0ZW5lc3Mgb2YgdXNpbmcgYW5kCisg
ICBkaXN0cmlidXRpbmcgdGhlIFByb2dyYW0gYW5kIGFzc3VtZXMgYWxsIHJpc2tzIGFzc29jaWF0
ZWQgd2l0aCBpdHMKKyAgIGV4ZXJjaXNlIG9mIHJpZ2h0cyB1bmRlciB0aGlzIEFncmVlbWVudCwg
aW5jbHVkaW5nIGJ1dCBub3QgbGltaXRlZCB0bworICAgdGhlIHJpc2tzIGFuZCBjb3N0cyBvZiBw
cm9ncmFtIGVycm9ycywgZGFtYWdlIHRvIG9yIGxvc3Mgb2YgZGF0YSwKKyAgIHByb2dyYW1zIG9y
IGVxdWlwbWVudCwgYW5kIHVuYXZhaWxhYmlsaXR5IG9yIGludGVycnVwdGlvbiBvZiBvcGVyYXRp
b25zLgorCisgICBESVNDTEFJTUVSIE9GIExJQUJJTElUWQorICAgTkVJVEhFUiBSRUNJUElFTlQg
Tk9SIEFOWSBDT05UUklCVVRPUlMgU0hBTEwgSEFWRSBBTlkgTElBQklMSVRZIEZPUiBBTlkKKyAg
IERJUkVDVCwgSU5ESVJFQ1QsIElOQ0lERU5UQUwsIFNQRUNJQUwsIEVYRU1QTEFSWSwgT1IgQ09O
U0VRVUVOVElBTAorICAgREFNQUdFUyAoSU5DTFVESU5HIFdJVEhPVVQgTElNSVRBVElPTiBMT1NU
IFBST0ZJVFMpLCBIT1dFVkVSIENBVVNFRCBBTkQKKyAgIE9OIEFOWSBUSEVPUlkgT0YgTElBQklM
SVRZLCBXSEVUSEVSIElOIENPTlRSQUNULCBTVFJJQ1QgTElBQklMSVRZLCBPUgorICAgVE9SVCAo
SU5DTFVESU5HIE5FR0xJR0VOQ0UgT1IgT1RIRVJXSVNFKSBBUklTSU5HIElOIEFOWSBXQVkgT1VU
IE9GIFRIRQorICAgVVNFIE9SIERJU1RSSUJVVElPTiBPRiBUSEUgUFJPR1JBTSBPUiBUSEUgRVhF
UkNJU0UgT0YgQU5ZIFJJR0hUUyBHUkFOVEVECisgICBIRVJFVU5ERVIsIEVWRU4gSUYgQURWSVNF
RCBPRiBUSEUgUE9TU0lCSUxJVFkgT0YgU1VDSCBEQU1BR0VTCisKKyAgIFlvdSBzaG91bGQgaGF2
ZSByZWNlaXZlZCBhIGNvcHkgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlCisgICBh
bG9uZyB3aXRoIHRoaXMgcHJvZ3JhbTsgaWYgbm90LCB3cml0ZSB0byB0aGUgRnJlZSBTb2Z0d2Fy
ZQorICAgRm91bmRhdGlvbiwgSW5jLiwgNTkgVGVtcGxlIFBsYWNlLCBTdWl0ZSAzMzAsIEJvc3Rv
biwgTUEgIDAyMTExLTEzMDcgIFVTQQorCisgICBDb250cm9sbGVycyBzdXBwb3J0ZWQgYnkgdGhp
cyBkcml2ZXI6CisKKyAgIExTSSAzd2FyZSA5NzUwIDZHYi9zIFNBUy9TQVRBLVJBSUQKKworICAg
QnVncy9Db21tZW50cy9TdWdnZXN0aW9ucyBzaG91bGQgYmUgbWFpbGVkIHRvOgorICAgbGludXhy
YWlkQGxzaS5jb20KKworICAgRm9yIG1vcmUgaW5mb3JtYXRpb24sIGdvdG86CisgICBodHRwOi8v
d3d3LmxzaS5jb20KKworICAgSGlzdG9yeQorICAgLS0tLS0tLQorICAgMy4yNi4wMi4wMDAgLSBJ
bml0aWFsIGRyaXZlciByZWxlYXNlLgorKi8KKworI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgor
I2luY2x1ZGUgPGxpbnV4L3JlYm9vdC5oPgorI2luY2x1ZGUgPGxpbnV4L3NwaW5sb2NrLmg+Cisj
aW5jbHVkZSA8bGludXgvaW50ZXJydXB0Lmg+CisjaW5jbHVkZSA8bGludXgvbW9kdWxlcGFyYW0u
aD4KKyNpbmNsdWRlIDxsaW51eC9lcnJuby5oPgorI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+Cisj
aW5jbHVkZSA8bGludXgvZGVsYXkuaD4KKyNpbmNsdWRlIDxsaW51eC9wY2kuaD4KKyNpbmNsdWRl
IDxsaW51eC90aW1lLmg+CisjaW5jbHVkZSA8bGludXgvbXV0ZXguaD4KKyNpbmNsdWRlIDxsaW51
eC9zbXBfbG9jay5oPgorI2luY2x1ZGUgPGFzbS9pby5oPgorI2luY2x1ZGUgPGFzbS9pcnEuaD4K
KyNpbmNsdWRlIDxhc20vdWFjY2Vzcy5oPgorI2luY2x1ZGUgPHNjc2kvc2NzaS5oPgorI2luY2x1
ZGUgPHNjc2kvc2NzaV9ob3N0Lmg+CisjaW5jbHVkZSA8c2NzaS9zY3NpX3RjcS5oPgorI2luY2x1
ZGUgPHNjc2kvc2NzaV9jbW5kLmg+CisjaW5jbHVkZSAiM3ctc2FzLmgiCisKKy8qIEdsb2JhbHMg
Ki8KKyNkZWZpbmUgVFdfRFJJVkVSX1ZFUlNJT04gIjMuMjYuMDIuMDAwIgorc3RhdGljIFRXX0Rl
dmljZV9FeHRlbnNpb24gKnR3bF9kZXZpY2VfZXh0ZW5zaW9uX2xpc3RbVFdfTUFYX1NMT1RdOwor
c3RhdGljIHVuc2lnbmVkIGludCB0d2xfZGV2aWNlX2V4dGVuc2lvbl9jb3VudDsKK3N0YXRpYyBp
bnQgdHdsX21ham9yID0gLTE7CitleHRlcm4gc3RydWN0IHRpbWV6b25lIHN5c190ejsKKworLyog
TW9kdWxlIHBhcmFtZXRlcnMgKi8KK01PRFVMRV9BVVRIT1IgKCJMU0kiKTsKK01PRFVMRV9ERVND
UklQVElPTiAoIkxTSSAzd2FyZSBTQVMvU0FUQS1SQUlEIExpbnV4IERyaXZlciIpOworTU9EVUxF
X0xJQ0VOU0UoIkdQTCIpOworTU9EVUxFX1ZFUlNJT04oVFdfRFJJVkVSX1ZFUlNJT04pOworCitz
dGF0aWMgaW50IHVzZV9tc2k7Cittb2R1bGVfcGFyYW0odXNlX21zaSwgaW50LCBTX0lSVUdPKTsK
K01PRFVMRV9QQVJNX0RFU0ModXNlX21zaSwgIlVzZSBNZXNzYWdlIFNpZ25hbGVkIEludGVycnVw
dHMuIERlZmF1bHQ6IDAiKTsKKworLyogRnVuY3Rpb24gcHJvdG90eXBlcyAqLworc3RhdGljIGlu
dCB0d2xfcmVzZXRfZGV2aWNlX2V4dGVuc2lvbihUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYs
IGludCBpb2N0bF9yZXNldCk7CisKKy8qIEZ1bmN0aW9ucyAqLworCisvKiBUaGlzIGZ1bmN0aW9u
IHJldHVybnMgQUVOcyB0aHJvdWdoIHN5c2ZzICovCitzdGF0aWMgc3NpemVfdCB0d2xfc3lzZnNf
YWVuX3JlYWQoc3RydWN0IGtvYmplY3QgKmtvYmosCisJCQkJICBzdHJ1Y3QgYmluX2F0dHJpYnV0
ZSAqYmluX2F0dHIsCisJCQkJICBjaGFyICpvdXRidWYsIGxvZmZfdCBvZmZzZXQsIHNpemVfdCBj
b3VudCkKK3sKKwlzdHJ1Y3QgZGV2aWNlICpkZXYgPSBjb250YWluZXJfb2Yoa29iaiwgc3RydWN0
IGRldmljZSwga29iaik7CisJc3RydWN0IFNjc2lfSG9zdCAqc2hvc3QgPSBjbGFzc190b19zaG9z
dChkZXYpOworCVRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldiA9IChUV19EZXZpY2VfRXh0ZW5z
aW9uICopc2hvc3QtPmhvc3RkYXRhOworCXVuc2lnbmVkIGxvbmcgZmxhZ3MgPSAwOworCXNzaXpl
X3QgcmV0OworCisJaWYgKCFjYXBhYmxlKENBUF9TWVNfQURNSU4pKQorCQlyZXR1cm4gLUVBQ0NF
UzsKKworCXNwaW5fbG9ja19pcnFzYXZlKHR3X2Rldi0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7
CisJcmV0ID0gbWVtb3J5X3JlYWRfZnJvbV9idWZmZXIob3V0YnVmLCBjb3VudCwgJm9mZnNldCwg
dHdfZGV2LT5ldmVudF9xdWV1ZVswXSwgc2l6ZW9mKFRXX0V2ZW50KSAqIFRXX1FfTEVOR1RIKTsK
KwlzcGluX3VubG9ja19pcnFyZXN0b3JlKHR3X2Rldi0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7
CisKKwlyZXR1cm4gcmV0OworfSAvKiBFbmQgdHdsX3N5c2ZzX2Flbl9yZWFkKCkgKi8KKworLyog
YWVuX3JlYWQgc3lzZnMgYXR0cmlidXRlIGluaXRpYWxpemVyICovCitzdGF0aWMgc3RydWN0IGJp
bl9hdHRyaWJ1dGUgdHdsX3N5c2ZzX2Flbl9yZWFkX2F0dHIgPSB7CisJLmF0dHIgPSB7CisJCS5u
YW1lID0gIjN3YXJlX2Flbl9yZWFkIiwKKwkJLm1vZGUgPSBTX0lSVVNSLAorCX0sIAorCS5zaXpl
ID0gMCwKKwkucmVhZCA9IHR3bF9zeXNmc19hZW5fcmVhZAorfTsKKworLyogVGhpcyBmdW5jdGlv
biByZXR1cm5zIGRyaXZlciBjb21wYXRpYmlsaXR5IGluZm8gdGhyb3VnaCBzeXNmcyAqLworc3Rh
dGljIHNzaXplX3QgdHdsX3N5c2ZzX2NvbXBhdF9pbmZvKHN0cnVjdCBrb2JqZWN0ICprb2JqLAor
CQkJCSAgICAgc3RydWN0IGJpbl9hdHRyaWJ1dGUgKmJpbl9hdHRyLAorCQkJCSAgICAgY2hhciAq
b3V0YnVmLCBsb2ZmX3Qgb2Zmc2V0LCBzaXplX3QgY291bnQpCit7CisJc3RydWN0IGRldmljZSAq
ZGV2ID0gY29udGFpbmVyX29mKGtvYmosIHN0cnVjdCBkZXZpY2UsIGtvYmopOworCXN0cnVjdCBT
Y3NpX0hvc3QgKnNob3N0ID0gY2xhc3NfdG9fc2hvc3QoZGV2KTsKKwlUV19EZXZpY2VfRXh0ZW5z
aW9uICp0d19kZXYgPSAoVFdfRGV2aWNlX0V4dGVuc2lvbiAqKXNob3N0LT5ob3N0ZGF0YTsKKwl1
bnNpZ25lZCBsb25nIGZsYWdzID0gMDsKKwlzc2l6ZV90IHJldDsKKworCWlmICghY2FwYWJsZShD
QVBfU1lTX0FETUlOKSkKKwkJcmV0dXJuIC1FQUNDRVM7CisKKwlzcGluX2xvY2tfaXJxc2F2ZSh0
d19kZXYtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOworCXJldCA9IG1lbW9yeV9yZWFkX2Zyb21f
YnVmZmVyKG91dGJ1ZiwgY291bnQsICZvZmZzZXQsICZ0d19kZXYtPnR3X2NvbXBhdF9pbmZvLCBz
aXplb2YoVFdfQ29tcGF0aWJpbGl0eV9JbmZvKSk7CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSh0
d19kZXYtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOworCisJcmV0dXJuIHJldDsKK30gLyogRW5k
IHR3bF9zeXNmc19jb21wYXRfaW5mbygpICovCisKKy8qIGNvbXBhdF9pbmZvIHN5c2ZzIGF0dHJp
YnV0ZSBpbml0aWFsaXplciAqLworc3RhdGljIHN0cnVjdCBiaW5fYXR0cmlidXRlIHR3bF9zeXNm
c19jb21wYXRfaW5mb19hdHRyID0geworCS5hdHRyID0geworCQkubmFtZSA9ICIzd2FyZV9jb21w
YXRfaW5mbyIsCisJCS5tb2RlID0gU19JUlVTUiwKKwl9LCAKKwkuc2l6ZSA9IDAsCisJLnJlYWQg
PSB0d2xfc3lzZnNfY29tcGF0X2luZm8KK307CisKKy8qIFNob3cgc29tZSBzdGF0aXN0aWNzIGFi
b3V0IHRoZSBjYXJkICovCitzdGF0aWMgc3NpemVfdCB0d2xfc2hvd19zdGF0cyhzdHJ1Y3QgZGV2
aWNlICpkZXYsCisJCQkgICAgICBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAq
YnVmKQoreworCXN0cnVjdCBTY3NpX0hvc3QgKmhvc3QgPSBjbGFzc190b19zaG9zdChkZXYpOwor
CVRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldiA9IChUV19EZXZpY2VfRXh0ZW5zaW9uICopaG9z
dC0+aG9zdGRhdGE7CisJdW5zaWduZWQgbG9uZyBmbGFncyA9IDA7CisJc3NpemVfdCBsZW47CisK
KwlzcGluX2xvY2tfaXJxc2F2ZSh0d19kZXYtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOworCWxl
biA9IHNucHJpbnRmKGJ1ZiwgUEFHRV9TSVpFLCAiM3ctc2FzIERyaXZlciB2ZXJzaW9uOiAlc1xu
IgorCQkgICAgICAgIkN1cnJlbnQgY29tbWFuZHMgcG9zdGVkOiAgICU0ZFxuIgorCQkgICAgICAg
Ik1heCBjb21tYW5kcyBwb3N0ZWQ6ICAgICAgICU0ZFxuIgorCQkgICAgICAgIkxhc3Qgc2dsIGxl
bmd0aDogICAgICAgICAgICU0ZFxuIgorCQkgICAgICAgIk1heCBzZ2wgbGVuZ3RoOiAgICAgICAg
ICAgICU0ZFxuIgorCQkgICAgICAgIkxhc3Qgc2VjdG9yIGNvdW50OiAgICAgICAgICU0ZFxuIgor
CQkgICAgICAgIk1heCBzZWN0b3IgY291bnQ6ICAgICAgICAgICU0ZFxuIgorCQkgICAgICAgIlND
U0kgSG9zdCBSZXNldHM6ICAgICAgICAgICU0ZFxuIgorCQkgICAgICAgIkFFTidzOiAgICAgICAg
ICAgICAgICAgICAgICU0ZFxuIiwgCisJCSAgICAgICBUV19EUklWRVJfVkVSU0lPTiwKKwkJICAg
ICAgIHR3X2Rldi0+cG9zdGVkX3JlcXVlc3RfY291bnQsCisJCSAgICAgICB0d19kZXYtPm1heF9w
b3N0ZWRfcmVxdWVzdF9jb3VudCwKKwkJICAgICAgIHR3X2Rldi0+c2dsX2VudHJpZXMsCisJCSAg
ICAgICB0d19kZXYtPm1heF9zZ2xfZW50cmllcywKKwkJICAgICAgIHR3X2Rldi0+c2VjdG9yX2Nv
dW50LAorCQkgICAgICAgdHdfZGV2LT5tYXhfc2VjdG9yX2NvdW50LAorCQkgICAgICAgdHdfZGV2
LT5udW1fcmVzZXRzLAorCQkgICAgICAgdHdfZGV2LT5hZW5fY291bnQpOworCXNwaW5fdW5sb2Nr
X2lycXJlc3RvcmUodHdfZGV2LT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKKwlyZXR1cm4gbGVu
OworfSAvKiBFbmQgdHdsX3Nob3dfc3RhdHMoKSAqLworCisvKiBUaGlzIGZ1bmN0aW9uIHdpbGwg
c2V0IGEgZGV2aWNlcyBxdWV1ZSBkZXB0aCAqLworc3RhdGljIGludCB0d2xfY2hhbmdlX3F1ZXVl
X2RlcHRoKHN0cnVjdCBzY3NpX2RldmljZSAqc2RldiwgaW50IHF1ZXVlX2RlcHRoKQoreworCWlm
IChxdWV1ZV9kZXB0aCA+IFRXX1FfTEVOR1RILTIpCisJCXF1ZXVlX2RlcHRoID0gVFdfUV9MRU5H
VEgtMjsKKwlzY3NpX2FkanVzdF9xdWV1ZV9kZXB0aChzZGV2LCBNU0dfT1JERVJFRF9UQUcsIHF1
ZXVlX2RlcHRoKTsKKwlyZXR1cm4gcXVldWVfZGVwdGg7Cit9IC8qIEVuZCB0d2xfY2hhbmdlX3F1
ZXVlX2RlcHRoKCkgKi8KKworLyogc3RhdHMgc3lzZnMgYXR0cmlidXRlIGluaXRpYWxpemVyICov
CitzdGF0aWMgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgdHdsX2hvc3Rfc3RhdHNfYXR0ciA9IHsK
KwkuYXR0ciA9IHsKKwkJLm5hbWUgPSAJIjN3YXJlX3N0YXRzIiwKKwkJLm1vZGUgPQkJU19JUlVH
TywKKwl9LAorCS5zaG93ID0gdHdsX3Nob3dfc3RhdHMKK307CisKKy8qIEhvc3QgYXR0cmlidXRl
cyBpbml0aWFsaXplciAqLworc3RhdGljIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICp0d2xfaG9z
dF9hdHRyc1tdID0geworCSZ0d2xfaG9zdF9zdGF0c19hdHRyLAorCU5VTEwsCit9OworCisvKiBU
aGlzIGZ1bmN0aW9uIHdpbGwgbG9vayB1cCBhbiBBRU4gc2V2ZXJpdHkgc3RyaW5nICovCitzdGF0
aWMgY2hhciAqdHdsX2Flbl9zZXZlcml0eV9sb29rdXAodW5zaWduZWQgY2hhciBzZXZlcml0eV9j
b2RlKQoreworCWNoYXIgKnJldHZhbCA9IE5VTEw7CisKKwlpZiAoKHNldmVyaXR5X2NvZGUgPCAo
dW5zaWduZWQgY2hhcikgVFdfQUVOX1NFVkVSSVRZX0VSUk9SKSB8fAorCSAgICAoc2V2ZXJpdHlf
Y29kZSA+ICh1bnNpZ25lZCBjaGFyKSBUV19BRU5fU0VWRVJJVFlfREVCVUcpKQorCQlnb3RvIG91
dDsKKworCXJldHZhbCA9IHR3bF9hZW5fc2V2ZXJpdHlfdGFibGVbc2V2ZXJpdHlfY29kZV07Citv
dXQ6CisJcmV0dXJuIHJldHZhbDsKK30gLyogRW5kIHR3bF9hZW5fc2V2ZXJpdHlfbG9va3VwKCkg
Ki8KKworLyogVGhpcyBmdW5jdGlvbiB3aWxsIHF1ZXVlIGFuIGV2ZW50ICovCitzdGF0aWMgdm9p
ZCB0d2xfYWVuX3F1ZXVlX2V2ZW50KFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldiwgVFdfQ29t
bWFuZF9BcGFjaGVfSGVhZGVyICpoZWFkZXIpCit7CisJdTMyIGxvY2FsX3RpbWU7CisJc3RydWN0
IHRpbWV2YWwgdGltZTsKKwlUV19FdmVudCAqZXZlbnQ7CisJdW5zaWduZWQgc2hvcnQgYWVuOwor
CWNoYXIgaG9zdFsxNl07CisJY2hhciAqZXJyb3Jfc3RyOworCisJdHdfZGV2LT5hZW5fY291bnQr
KzsKKworCS8qIEZpbGwgb3V0IGV2ZW50IGluZm8gKi8KKwlldmVudCA9IHR3X2Rldi0+ZXZlbnRf
cXVldWVbdHdfZGV2LT5lcnJvcl9pbmRleF07CisKKwlob3N0WzBdID0gJ1wwJzsKKwlpZiAodHdf
ZGV2LT5ob3N0KQorCQlzcHJpbnRmKGhvc3QsICIgc2NzaSVkOiIsIHR3X2Rldi0+aG9zdC0+aG9z
dF9ubyk7CisKKwlhZW4gPSBsZTE2X3RvX2NwdShoZWFkZXItPnN0YXR1c19ibG9jay5lcnJvcik7
CisJbWVtc2V0KGV2ZW50LCAwLCBzaXplb2YoVFdfRXZlbnQpKTsKKworCWV2ZW50LT5zZXZlcml0
eSA9IFRXX1NFVl9PVVQoaGVhZGVyLT5zdGF0dXNfYmxvY2suc2V2ZXJpdHlfX3Jlc2VydmVkKTsK
Kwlkb19nZXR0aW1lb2ZkYXkoJnRpbWUpOworCWxvY2FsX3RpbWUgPSAodTMyKSh0aW1lLnR2X3Nl
YyAtIChzeXNfdHoudHpfbWludXRlc3dlc3QgKiA2MCkpOworCWV2ZW50LT50aW1lX3N0YW1wX3Nl
YyA9IGxvY2FsX3RpbWU7CisJZXZlbnQtPmFlbl9jb2RlID0gYWVuOworCWV2ZW50LT5yZXRyaWV2
ZWQgPSBUV19BRU5fTk9UX1JFVFJJRVZFRDsKKwlldmVudC0+c2VxdWVuY2VfaWQgPSB0d19kZXYt
PmVycm9yX3NlcXVlbmNlX2lkOworCXR3X2Rldi0+ZXJyb3Jfc2VxdWVuY2VfaWQrKzsKKworCS8q
IENoZWNrIGZvciBlbWJlZGRlZCBlcnJvciBzdHJpbmcgKi8KKwllcnJvcl9zdHIgPSAmKGhlYWRl
ci0+ZXJyX3NwZWNpZmljX2Rlc2Nbc3RybGVuKGhlYWRlci0+ZXJyX3NwZWNpZmljX2Rlc2MpKzFd
KTsKKworCWhlYWRlci0+ZXJyX3NwZWNpZmljX2Rlc2Nbc2l6ZW9mKGhlYWRlci0+ZXJyX3NwZWNp
ZmljX2Rlc2MpIC0gMV0gPSAnXDAnOworCWV2ZW50LT5wYXJhbWV0ZXJfbGVuID0gc3RybGVuKGhl
YWRlci0+ZXJyX3NwZWNpZmljX2Rlc2MpOworCW1lbWNweShldmVudC0+cGFyYW1ldGVyX2RhdGEs
IGhlYWRlci0+ZXJyX3NwZWNpZmljX2Rlc2MsIGV2ZW50LT5wYXJhbWV0ZXJfbGVuICsgMSArIHN0
cmxlbihlcnJvcl9zdHIpKTsKKwlpZiAoZXZlbnQtPnNldmVyaXR5ICE9IFRXX0FFTl9TRVZFUklU
WV9ERUJVRykKKwkJcHJpbnRrKEtFUk5fV0FSTklORyAiM3ctc2FzOiVzIEFFTjogJXMgKDB4JTAy
WDoweCUwNFgpOiAlczolcy5cbiIsCisJCSAgICAgICBob3N0LAorCQkgICAgICAgdHdsX2Flbl9z
ZXZlcml0eV9sb29rdXAoVFdfU0VWX09VVChoZWFkZXItPnN0YXR1c19ibG9jay5zZXZlcml0eV9f
cmVzZXJ2ZWQpKSwKKwkJICAgICAgIFRXX01FU1NBR0VfU09VUkNFX0NPTlRST0xMRVJfRVZFTlQs
IGFlbiwgZXJyb3Jfc3RyLAorCQkgICAgICAgaGVhZGVyLT5lcnJfc3BlY2lmaWNfZGVzYyk7CisJ
ZWxzZQorCQl0d19kZXYtPmFlbl9jb3VudC0tOworCisJdHdfZGV2LT5lcnJvcl9pbmRleCA9ICh0
d19kZXYtPmVycm9yX2luZGV4ICsgMSApICUgVFdfUV9MRU5HVEg7Cit9IC8qIEVuZCB0d2xfYWVu
X3F1ZXVlX2V2ZW50KCkgKi8KKworLyogVGhpcyBmdW5jdGlvbiB3aWxsIGF0dGVtcHQgdG8gcG9z
dCBhIGNvbW1hbmQgcGFja2V0IHRvIHRoZSBib2FyZCAqLworc3RhdGljIGludCB0d2xfcG9zdF9j
b21tYW5kX3BhY2tldChUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYsIGludCByZXF1ZXN0X2lk
KQoreworCWRtYV9hZGRyX3QgY29tbWFuZF9xdWVfdmFsdWU7CisKKwljb21tYW5kX3F1ZV92YWx1
ZSA9IHR3X2Rldi0+Y29tbWFuZF9wYWNrZXRfcGh5c1tyZXF1ZXN0X2lkXTsKKwljb21tYW5kX3F1
ZV92YWx1ZSArPSBUV19DT01NQU5EX09GRlNFVDsKKworCS8qIEZpcnN0IHdyaXRlIHVwcGVyIDQg
Ynl0ZXMgKi8KKwl3cml0ZWwoKHUzMikoKHU2NCljb21tYW5kX3F1ZV92YWx1ZSA+PiAzMiksIFRX
TF9ISUJRUEhfUkVHX0FERFIodHdfZGV2KSk7CisJLyogVGhlbiB0aGUgbG93ZXIgNCBieXRlcyAq
LworCXdyaXRlbCgodTMyKShjb21tYW5kX3F1ZV92YWx1ZSB8IFRXTF9QVUxMX01PREUpLCBUV0xf
SElCUVBMX1JFR19BRERSKHR3X2RldikpOworCisJdHdfZGV2LT5zdGF0ZVtyZXF1ZXN0X2lkXSA9
IFRXX1NfUE9TVEVEOworCXR3X2Rldi0+cG9zdGVkX3JlcXVlc3RfY291bnQrKzsKKwlpZiAodHdf
ZGV2LT5wb3N0ZWRfcmVxdWVzdF9jb3VudCA+IHR3X2Rldi0+bWF4X3Bvc3RlZF9yZXF1ZXN0X2Nv
dW50KQorCQl0d19kZXYtPm1heF9wb3N0ZWRfcmVxdWVzdF9jb3VudCA9IHR3X2Rldi0+cG9zdGVk
X3JlcXVlc3RfY291bnQ7CisKKwlyZXR1cm4gMDsKK30gLyogRW5kIHR3bF9wb3N0X2NvbW1hbmRf
cGFja2V0KCkgKi8KKworLyogVGhpcyBmdW5jdGlvbiB3aWxsIHBlcmZvcm0gYSBwY2ktZG1hIG1h
cHBpbmcgZm9yIGEgc2NhdHRlciBnYXRoZXIgbGlzdCAqLworc3RhdGljIGludCB0d2xfbWFwX3Nj
c2lfc2dfZGF0YShUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYsIGludCByZXF1ZXN0X2lkKQor
eworCWludCB1c2Vfc2c7CisJc3RydWN0IHNjc2lfY21uZCAqY21kID0gdHdfZGV2LT5zcmJbcmVx
dWVzdF9pZF07CisKKwl1c2Vfc2cgPSBzY3NpX2RtYV9tYXAoY21kKTsKKwlpZiAoIXVzZV9zZykK
KwkJcmV0dXJuIDA7CisJZWxzZSBpZiAodXNlX3NnIDwgMCkgeworCQlUV19QUklOVEsodHdfZGV2
LT5ob3N0LCBUV19EUklWRVIsIDB4MSwgIkZhaWxlZCB0byBtYXAgc2NhdHRlciBnYXRoZXIgbGlz
dCIpOworCQlyZXR1cm4gMDsKKwl9CisKKwljbWQtPlNDcC5waGFzZSA9IFRXX1BIQVNFX1NHTElT
VDsKKwljbWQtPlNDcC5oYXZlX2RhdGFfaW4gPSB1c2Vfc2c7CisKKwlyZXR1cm4gdXNlX3NnOwor
fSAvKiBFbmQgdHdsX21hcF9zY3NpX3NnX2RhdGEoKSAqLworCisvKiBUaGlzIGZ1bmN0aW9uIGhh
bmRzIHNjc2kgY2RiJ3MgdG8gdGhlIGZpcm13YXJlICovCitzdGF0aWMgaW50IHR3bF9zY3Npb3Bf
ZXhlY3V0ZV9zY3NpKFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldiwgaW50IHJlcXVlc3RfaWQs
IGNoYXIgKmNkYiwgaW50IHVzZV9zZywgVFdfU0dfRW50cnlfSVNPICpzZ2xpc3RhcmcpCit7CisJ
VFdfQ29tbWFuZF9GdWxsICpmdWxsX2NvbW1hbmRfcGFja2V0OworCVRXX0NvbW1hbmRfQXBhY2hl
ICpjb21tYW5kX3BhY2tldDsKKwlpbnQgaSwgc2dfY291bnQ7CisJc3RydWN0IHNjc2lfY21uZCAq
c3JiID0gTlVMTDsKKwlzdHJ1Y3Qgc2NhdHRlcmxpc3QgKnNnbGlzdCA9IE5VTEwsICpzZzsKKwlp
bnQgcmV0dmFsID0gMTsKKworCWlmICh0d19kZXYtPnNyYltyZXF1ZXN0X2lkXSkgeworCQlzcmIg
PSB0d19kZXYtPnNyYltyZXF1ZXN0X2lkXTsKKwkJaWYgKHNjc2lfc2dsaXN0KHNyYikpCisJCQlz
Z2xpc3QgPSBzY3NpX3NnbGlzdChzcmIpOworCX0KKworCS8qIEluaXRpYWxpemUgY29tbWFuZCBw
YWNrZXQgKi8KKwlmdWxsX2NvbW1hbmRfcGFja2V0ID0gdHdfZGV2LT5jb21tYW5kX3BhY2tldF92
aXJ0W3JlcXVlc3RfaWRdOworCWZ1bGxfY29tbWFuZF9wYWNrZXQtPmhlYWRlci5oZWFkZXJfZGVz
Yy5zaXplX2hlYWRlciA9IDEyODsKKwlmdWxsX2NvbW1hbmRfcGFja2V0LT5oZWFkZXIuc3RhdHVz
X2Jsb2NrLmVycm9yID0gMDsKKwlmdWxsX2NvbW1hbmRfcGFja2V0LT5oZWFkZXIuc3RhdHVzX2Js
b2NrLnNldmVyaXR5X19yZXNlcnZlZCA9IDA7CisKKwljb21tYW5kX3BhY2tldCA9ICZmdWxsX2Nv
bW1hbmRfcGFja2V0LT5jb21tYW5kLm5ld2NvbW1hbmQ7CisJY29tbWFuZF9wYWNrZXQtPnN0YXR1
cyA9IDA7CisJY29tbWFuZF9wYWNrZXQtPm9wY29kZV9fcmVzZXJ2ZWQgPSBUV19PUFJFU19JTigw
LCBUV19PUF9FWEVDVVRFX1NDU0kpOworCisJLyogV2UgZm9yY2VkIDE2IGJ5dGUgY2RiIHVzZSBl
YXJsaWVyICovCisJaWYgKCFjZGIpCisJCW1lbWNweShjb21tYW5kX3BhY2tldC0+Y2RiLCBzcmIt
PmNtbmQsIFRXX01BWF9DREJfTEVOKTsKKwllbHNlCisJCW1lbWNweShjb21tYW5kX3BhY2tldC0+
Y2RiLCBjZGIsIFRXX01BWF9DREJfTEVOKTsKKworCWlmIChzcmIpIHsKKwkJY29tbWFuZF9wYWNr
ZXQtPnVuaXQgPSBzcmItPmRldmljZS0+aWQ7CisJCWNvbW1hbmRfcGFja2V0LT5yZXF1ZXN0X2lk
X19sdW5sID0KKwkJCWNwdV90b19sZTE2KFRXX1JFUV9MVU5fSU4oc3JiLT5kZXZpY2UtPmx1biwg
cmVxdWVzdF9pZCkpOworCX0gZWxzZSB7CisJCWNvbW1hbmRfcGFja2V0LT5yZXF1ZXN0X2lkX19s
dW5sID0KKwkJCWNwdV90b19sZTE2KFRXX1JFUV9MVU5fSU4oMCwgcmVxdWVzdF9pZCkpOworCQlj
b21tYW5kX3BhY2tldC0+dW5pdCA9IDA7CisJfQorCisJY29tbWFuZF9wYWNrZXQtPnNnbF9vZmZz
ZXQgPSAxNjsKKworCWlmICghc2dsaXN0YXJnKSB7CisJCS8qIE1hcCBzZ2xpc3QgZnJvbSBzY3Np
IGxheWVyIHRvIGNtZCBwYWNrZXQgKi8KKwkJaWYgKHNjc2lfc2dfY291bnQoc3JiKSkgeworCQkJ
c2dfY291bnQgPSB0d2xfbWFwX3Njc2lfc2dfZGF0YSh0d19kZXYsIHJlcXVlc3RfaWQpOworCQkJ
aWYgKHNnX2NvdW50ID09IDApCisJCQkJZ290byBvdXQ7CisKKwkJCXNjc2lfZm9yX2VhY2hfc2co
c3JiLCBzZywgc2dfY291bnQsIGkpIHsKKwkJCQljb21tYW5kX3BhY2tldC0+c2dfbGlzdFtpXS5h
ZGRyZXNzID0gVFdfQ1BVX1RPX1NHTChzZ19kbWFfYWRkcmVzcyhzZykpOworCQkJCWNvbW1hbmRf
cGFja2V0LT5zZ19saXN0W2ldLmxlbmd0aCA9IFRXX0NQVV9UT19TR0woc2dfZG1hX2xlbihzZykp
OworCQkJfQorCQkJY29tbWFuZF9wYWNrZXQtPnNnbF9lbnRyaWVzX19sdW5oID0gY3B1X3RvX2xl
MTYoVFdfUkVRX0xVTl9JTigoc3JiLT5kZXZpY2UtPmx1biA+PiA0KSwgc2NzaV9zZ19jb3VudCh0
d19kZXYtPnNyYltyZXF1ZXN0X2lkXSkpKTsKKwkJfQorCX0gZWxzZSB7CisJCS8qIEludGVybmFs
IGNkYiBwb3N0ICovCisJCWZvciAoaSA9IDA7IGkgPCB1c2Vfc2c7IGkrKykgeworCQkJY29tbWFu
ZF9wYWNrZXQtPnNnX2xpc3RbaV0uYWRkcmVzcyA9IFRXX0NQVV9UT19TR0woc2dsaXN0YXJnW2ld
LmFkZHJlc3MpOworCQkJY29tbWFuZF9wYWNrZXQtPnNnX2xpc3RbaV0ubGVuZ3RoID0gVFdfQ1BV
X1RPX1NHTChzZ2xpc3RhcmdbaV0ubGVuZ3RoKTsKKwkJfQorCQljb21tYW5kX3BhY2tldC0+c2ds
X2VudHJpZXNfX2x1bmggPSBjcHVfdG9fbGUxNihUV19SRVFfTFVOX0lOKDAsIHVzZV9zZykpOwor
CX0KKworCS8qIFVwZGF0ZSBzb21lIHN0YXRzICovCisJaWYgKHNyYikgeworCQl0d19kZXYtPnNl
Y3Rvcl9jb3VudCA9IHNjc2lfYnVmZmxlbihzcmIpIC8gNTEyOworCQlpZiAodHdfZGV2LT5zZWN0
b3JfY291bnQgPiB0d19kZXYtPm1heF9zZWN0b3JfY291bnQpCisJCQl0d19kZXYtPm1heF9zZWN0
b3JfY291bnQgPSB0d19kZXYtPnNlY3Rvcl9jb3VudDsKKwkJdHdfZGV2LT5zZ2xfZW50cmllcyA9
IHNjc2lfc2dfY291bnQoc3JiKTsKKwkJaWYgKHR3X2Rldi0+c2dsX2VudHJpZXMgPiB0d19kZXYt
Pm1heF9zZ2xfZW50cmllcykKKwkJCXR3X2Rldi0+bWF4X3NnbF9lbnRyaWVzID0gdHdfZGV2LT5z
Z2xfZW50cmllczsKKwl9CisKKwkvKiBOb3cgcG9zdCB0aGUgY29tbWFuZCB0byB0aGUgYm9hcmQg
Ki8KKwlyZXR2YWwgPSB0d2xfcG9zdF9jb21tYW5kX3BhY2tldCh0d19kZXYsIHJlcXVlc3RfaWQp
OworCitvdXQ6CisJcmV0dXJuIHJldHZhbDsKK30gLyogRW5kIHR3bF9zY3Npb3BfZXhlY3V0ZV9z
Y3NpKCkgKi8KKworLyogVGhpcyBmdW5jdGlvbiB3aWxsIHJlYWQgdGhlIGFlbiBxdWV1ZSBmcm9t
IHRoZSBpc3IgKi8KK3N0YXRpYyBpbnQgdHdsX2Flbl9yZWFkX3F1ZXVlKFRXX0RldmljZV9FeHRl
bnNpb24gKnR3X2RldiwgaW50IHJlcXVlc3RfaWQpCit7CisJY2hhciBjZGJbVFdfTUFYX0NEQl9M
RU5dOworCVRXX1NHX0VudHJ5X0lTTyBzZ2xpc3RbMV07CisJVFdfQ29tbWFuZF9GdWxsICpmdWxs
X2NvbW1hbmRfcGFja2V0OworCWludCByZXR2YWwgPSAxOworCisJZnVsbF9jb21tYW5kX3BhY2tl
dCA9IHR3X2Rldi0+Y29tbWFuZF9wYWNrZXRfdmlydFtyZXF1ZXN0X2lkXTsKKwltZW1zZXQoZnVs
bF9jb21tYW5kX3BhY2tldCwgMCwgc2l6ZW9mKFRXX0NvbW1hbmRfRnVsbCkpOworCisJLyogSW5p
dGlhbGl6ZSBjZGIgKi8KKwltZW1zZXQoJmNkYiwgMCwgVFdfTUFYX0NEQl9MRU4pOworCWNkYlsw
XSA9IFJFUVVFU1RfU0VOU0U7IC8qIG9wY29kZSAqLworCWNkYls0XSA9IFRXX0FMTE9DQVRJT05f
TEVOR1RIOyAvKiBhbGxvY2F0aW9uIGxlbmd0aCAqLworCisJLyogSW5pdGlhbGl6ZSBzZ2xpc3Qg
Ki8KKwltZW1zZXQoJnNnbGlzdCwgMCwgc2l6ZW9mKFRXX1NHX0VudHJ5X0lTTykpOworCXNnbGlz
dFswXS5sZW5ndGggPSBUV19TRUNUT1JfU0laRTsKKwlzZ2xpc3RbMF0uYWRkcmVzcyA9IHR3X2Rl
di0+Z2VuZXJpY19idWZmZXJfcGh5c1tyZXF1ZXN0X2lkXTsKKworCS8qIE1hcmsgaW50ZXJuYWwg
Y29tbWFuZCAqLworCXR3X2Rldi0+c3JiW3JlcXVlc3RfaWRdID0gTlVMTDsKKworCS8qIE5vdyBw
b3N0IHRoZSBjb21tYW5kIHBhY2tldCAqLworCWlmICh0d2xfc2NzaW9wX2V4ZWN1dGVfc2NzaSh0
d19kZXYsIHJlcXVlc3RfaWQsIGNkYiwgMSwgc2dsaXN0KSkgeworCQlUV19QUklOVEsodHdfZGV2
LT5ob3N0LCBUV19EUklWRVIsIDB4MiwgIlBvc3QgZmFpbGVkIHdoaWxlIHJlYWRpbmcgQUVOIHF1
ZXVlIik7CisJCWdvdG8gb3V0OworCX0KKwlyZXR2YWwgPSAwOworb3V0OgorCXJldHVybiByZXR2
YWw7Cit9IC8qIEVuZCB0d2xfYWVuX3JlYWRfcXVldWUoKSAqLworCisvKiBUaGlzIGZ1bmN0aW9u
IHdpbGwgc3luYyBmaXJtd2FyZSB0aW1lIHdpdGggdGhlIGhvc3QgdGltZSAqLworc3RhdGljIHZv
aWQgdHdsX2Flbl9zeW5jX3RpbWUoVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2LCBpbnQgcmVx
dWVzdF9pZCkKK3sKKwl1MzIgc2NoZWR1bGVydGltZTsKKwlzdHJ1Y3QgdGltZXZhbCB1dGM7CisJ
VFdfQ29tbWFuZF9GdWxsICpmdWxsX2NvbW1hbmRfcGFja2V0OworCVRXX0NvbW1hbmQgKmNvbW1h
bmRfcGFja2V0OworCVRXX1BhcmFtX0FwYWNoZSAqcGFyYW07CisJdTMyIGxvY2FsX3RpbWU7CisK
KwkvKiBGaWxsIG91dCB0aGUgY29tbWFuZCBwYWNrZXQgKi8KKwlmdWxsX2NvbW1hbmRfcGFja2V0
ID0gdHdfZGV2LT5jb21tYW5kX3BhY2tldF92aXJ0W3JlcXVlc3RfaWRdOworCW1lbXNldChmdWxs
X2NvbW1hbmRfcGFja2V0LCAwLCBzaXplb2YoVFdfQ29tbWFuZF9GdWxsKSk7CisJY29tbWFuZF9w
YWNrZXQgPSAmZnVsbF9jb21tYW5kX3BhY2tldC0+Y29tbWFuZC5vbGRjb21tYW5kOworCWNvbW1h
bmRfcGFja2V0LT5vcGNvZGVfX3NnbG9mZnNldCA9IFRXX09QU0dMX0lOKDIsIFRXX09QX1NFVF9Q
QVJBTSk7CisJY29tbWFuZF9wYWNrZXQtPnJlcXVlc3RfaWQgPSByZXF1ZXN0X2lkOworCWNvbW1h
bmRfcGFja2V0LT5ieXRlOF9vZmZzZXQucGFyYW0uc2dsWzBdLmFkZHJlc3MgPSBUV19DUFVfVE9f
U0dMKHR3X2Rldi0+Z2VuZXJpY19idWZmZXJfcGh5c1tyZXF1ZXN0X2lkXSk7CisJY29tbWFuZF9w
YWNrZXQtPmJ5dGU4X29mZnNldC5wYXJhbS5zZ2xbMF0ubGVuZ3RoID0gVFdfQ1BVX1RPX1NHTChU
V19TRUNUT1JfU0laRSk7CisJY29tbWFuZF9wYWNrZXQtPnNpemUgPSBUV19DT01NQU5EX1NJWkU7
CisJY29tbWFuZF9wYWNrZXQtPmJ5dGU2X29mZnNldC5wYXJhbWV0ZXJfY291bnQgPSBjcHVfdG9f
bGUxNigxKTsKKworCS8qIFNldHVwIHRoZSBwYXJhbSAqLworCXBhcmFtID0gKFRXX1BhcmFtX0Fw
YWNoZSAqKXR3X2Rldi0+Z2VuZXJpY19idWZmZXJfdmlydFtyZXF1ZXN0X2lkXTsKKwltZW1zZXQo
cGFyYW0sIDAsIFRXX1NFQ1RPUl9TSVpFKTsKKwlwYXJhbS0+dGFibGVfaWQgPSBjcHVfdG9fbGUx
NihUV19USU1FS0VFUF9UQUJMRSB8IDB4ODAwMCk7IC8qIENvbnRyb2xsZXIgdGltZSBrZWVwIHRh
YmxlICovCisJcGFyYW0tPnBhcmFtZXRlcl9pZCA9IGNwdV90b19sZTE2KDB4Myk7IC8qIFNjaGVk
dWxlclRpbWUgKi8KKwlwYXJhbS0+cGFyYW1ldGVyX3NpemVfYnl0ZXMgPSBjcHVfdG9fbGUxNig0
KTsKKworCS8qIENvbnZlcnQgc3lzdGVtIHRpbWUgaW4gVVRDIHRvIGxvY2FsIHRpbWUgc2Vjb25k
cyBzaW5jZSBsYXN0IAorICAgICAgICAgICBTdW5kYXkgMTI6MDBBTSAqLworCWRvX2dldHRpbWVv
ZmRheSgmdXRjKTsKKwlsb2NhbF90aW1lID0gKHUzMikodXRjLnR2X3NlYyAtIChzeXNfdHoudHpf
bWludXRlc3dlc3QgKiA2MCkpOworCXNjaGVkdWxlcnRpbWUgPSBsb2NhbF90aW1lIC0gKDMgKiA4
NjQwMCk7CisJc2NoZWR1bGVydGltZSA9IGNwdV90b19sZTMyKHNjaGVkdWxlcnRpbWUgJSA2MDQ4
MDApOworCisJbWVtY3B5KHBhcmFtLT5kYXRhLCAmc2NoZWR1bGVydGltZSwgc2l6ZW9mKHUzMikp
OworCisJLyogTWFyayBpbnRlcm5hbCBjb21tYW5kICovCisJdHdfZGV2LT5zcmJbcmVxdWVzdF9p
ZF0gPSBOVUxMOworCisJLyogTm93IHBvc3QgdGhlIGNvbW1hbmQgKi8KKwl0d2xfcG9zdF9jb21t
YW5kX3BhY2tldCh0d19kZXYsIHJlcXVlc3RfaWQpOworfSAvKiBFbmQgdHdsX2Flbl9zeW5jX3Rp
bWUoKSAqLworCisvKiBUaGlzIGZ1bmN0aW9uIHdpbGwgYXNzaWduIGFuIGF2YWlsYWJsZSByZXF1
ZXN0IGlkICovCitzdGF0aWMgdm9pZCB0d2xfZ2V0X3JlcXVlc3RfaWQoVFdfRGV2aWNlX0V4dGVu
c2lvbiAqdHdfZGV2LCBpbnQgKnJlcXVlc3RfaWQpCit7CisJKnJlcXVlc3RfaWQgPSB0d19kZXYt
PmZyZWVfcXVldWVbdHdfZGV2LT5mcmVlX2hlYWRdOworCXR3X2Rldi0+ZnJlZV9oZWFkID0gKHR3
X2Rldi0+ZnJlZV9oZWFkICsgMSkgJSBUV19RX0xFTkdUSDsKKwl0d19kZXYtPnN0YXRlWypyZXF1
ZXN0X2lkXSA9IFRXX1NfU1RBUlRFRDsKK30gLyogRW5kIHR3bF9nZXRfcmVxdWVzdF9pZCgpICov
CisKKy8qIFRoaXMgZnVuY3Rpb24gd2lsbCBmcmVlIGEgcmVxdWVzdCBpZCAqLworc3RhdGljIHZv
aWQgdHdsX2ZyZWVfcmVxdWVzdF9pZChUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYsIGludCBy
ZXF1ZXN0X2lkKQoreworCXR3X2Rldi0+ZnJlZV9xdWV1ZVt0d19kZXYtPmZyZWVfdGFpbF0gPSBy
ZXF1ZXN0X2lkOworCXR3X2Rldi0+c3RhdGVbcmVxdWVzdF9pZF0gPSBUV19TX0ZJTklTSEVEOwor
CXR3X2Rldi0+ZnJlZV90YWlsID0gKHR3X2Rldi0+ZnJlZV90YWlsICsgMSkgJSBUV19RX0xFTkdU
SDsKK30gLyogRW5kIHR3bF9mcmVlX3JlcXVlc3RfaWQoKSAqLworCisvKiBUaGlzIGZ1bmN0aW9u
IHdpbGwgY29tcGxldGUgYW4gYWVuIHJlcXVlc3QgZnJvbSB0aGUgaXNyICovCitzdGF0aWMgaW50
IHR3bF9hZW5fY29tcGxldGUoVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2LCBpbnQgcmVxdWVz
dF9pZCkKK3sKKwlUV19Db21tYW5kX0Z1bGwgKmZ1bGxfY29tbWFuZF9wYWNrZXQ7CisJVFdfQ29t
bWFuZCAqY29tbWFuZF9wYWNrZXQ7CisJVFdfQ29tbWFuZF9BcGFjaGVfSGVhZGVyICpoZWFkZXI7
CisJdW5zaWduZWQgc2hvcnQgYWVuOworCWludCByZXR2YWwgPSAxOworCisJaGVhZGVyID0gKFRX
X0NvbW1hbmRfQXBhY2hlX0hlYWRlciAqKXR3X2Rldi0+Z2VuZXJpY19idWZmZXJfdmlydFtyZXF1
ZXN0X2lkXTsKKwl0d19kZXYtPnBvc3RlZF9yZXF1ZXN0X2NvdW50LS07CisJYWVuID0gbGUxNl90
b19jcHUoaGVhZGVyLT5zdGF0dXNfYmxvY2suZXJyb3IpOworCWZ1bGxfY29tbWFuZF9wYWNrZXQg
PSB0d19kZXYtPmNvbW1hbmRfcGFja2V0X3ZpcnRbcmVxdWVzdF9pZF07CisJY29tbWFuZF9wYWNr
ZXQgPSAmZnVsbF9jb21tYW5kX3BhY2tldC0+Y29tbWFuZC5vbGRjb21tYW5kOworCisJLyogRmly
c3QgY2hlY2sgZm9yIGludGVybmFsIGNvbXBsZXRpb24gb2Ygc2V0IHBhcmFtIGZvciB0aW1lIHN5
bmMgKi8KKwlpZiAoVFdfT1BfT1VUKGNvbW1hbmRfcGFja2V0LT5vcGNvZGVfX3NnbG9mZnNldCkg
PT0gVFdfT1BfU0VUX1BBUkFNKSB7CisJCS8qIEtlZXAgcmVhZGluZyB0aGUgcXVldWUgaW4gY2Fz
ZSB0aGVyZSBhcmUgbW9yZSBhZW4ncyAqLworCQlpZiAodHdsX2Flbl9yZWFkX3F1ZXVlKHR3X2Rl
diwgcmVxdWVzdF9pZCkpCisJCQlnb3RvIG91dDI7CisJICAgICAgICBlbHNlIHsKKwkJCXJldHZh
bCA9IDA7CisJCQlnb3RvIG91dDsKKwkJfQorCX0KKworCXN3aXRjaCAoYWVuKSB7CisJY2FzZSBU
V19BRU5fUVVFVUVfRU1QVFk6CisJCS8qIFF1aXQgcmVhZGluZyB0aGUgcXVldWUgaWYgdGhpcyBp
cyB0aGUgbGFzdCBvbmUgKi8KKwkJYnJlYWs7CisJY2FzZSBUV19BRU5fU1lOQ19USU1FX1dJVEhf
SE9TVDoKKwkJdHdsX2Flbl9zeW5jX3RpbWUodHdfZGV2LCByZXF1ZXN0X2lkKTsKKwkJcmV0dmFs
ID0gMDsKKwkJZ290byBvdXQ7CisJZGVmYXVsdDoKKwkJdHdsX2Flbl9xdWV1ZV9ldmVudCh0d19k
ZXYsIGhlYWRlcik7CisKKwkJLyogSWYgdGhlcmUgYXJlIG1vcmUgYWVuJ3MsIGtlZXAgcmVhZGlu
ZyB0aGUgcXVldWUgKi8KKwkJaWYgKHR3bF9hZW5fcmVhZF9xdWV1ZSh0d19kZXYsIHJlcXVlc3Rf
aWQpKQorCQkJZ290byBvdXQyOworCQllbHNlIHsKKwkJCXJldHZhbCA9IDA7CisJCQlnb3RvIG91
dDsKKwkJfQorCX0KKwlyZXR2YWwgPSAwOworb3V0MjoKKwl0d19kZXYtPnN0YXRlW3JlcXVlc3Rf
aWRdID0gVFdfU19DT01QTEVURUQ7CisJdHdsX2ZyZWVfcmVxdWVzdF9pZCh0d19kZXYsIHJlcXVl
c3RfaWQpOworCWNsZWFyX2JpdChUV19JTl9BVFRFTlRJT05fTE9PUCwgJnR3X2Rldi0+ZmxhZ3Mp
Oworb3V0OgorCXJldHVybiByZXR2YWw7Cit9IC8qIEVuZCB0d2xfYWVuX2NvbXBsZXRlKCkgKi8K
KworLyogVGhpcyBmdW5jdGlvbiB3aWxsIHBvbGwgZm9yIGEgcmVzcG9uc2UgKi8KK3N0YXRpYyBp
bnQgdHdsX3BvbGxfcmVzcG9uc2UoVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2LCBpbnQgcmVx
dWVzdF9pZCwgaW50IHNlY29uZHMpCit7CisJdW5zaWduZWQgbG9uZyBiZWZvcmU7CisJZG1hX2Fk
ZHJfdCBtZmE7CisJdTMyIHJlZ2gsIHJlZ2w7CisJdTMyIHJlc3BvbnNlOworCWludCByZXR2YWwg
PSAxOworCWludCBmb3VuZCA9IDA7CisKKwliZWZvcmUgPSBqaWZmaWVzOworCisJd2hpbGUgKCFm
b3VuZCkgeworCQlpZiAoc2l6ZW9mKGRtYV9hZGRyX3QpID4gNCkgeworCQkJcmVnaCA9IHJlYWRs
KFRXTF9IT0JRUEhfUkVHX0FERFIodHdfZGV2KSk7CisJCQlyZWdsID0gcmVhZGwoVFdMX0hPQlFQ
TF9SRUdfQUREUih0d19kZXYpKTsKKwkJCW1mYSA9ICgodTY0KXJlZ2ggPDwgMzIpIHwgcmVnbDsK
KwkJfSBlbHNlCisJCQltZmEgPSByZWFkbChUV0xfSE9CUVBMX1JFR19BRERSKHR3X2RldikpOwor
CisJCXJlc3BvbnNlID0gKHUzMiltZmE7CisKKwkJaWYgKFRXX1JFU0lEX09VVChyZXNwb25zZSkg
PT0gcmVxdWVzdF9pZCkKKwkJCWZvdW5kID0gMTsKKworCQlpZiAodGltZV9hZnRlcihqaWZmaWVz
LCBiZWZvcmUgKyBIWiAqIHNlY29uZHMpKQorCQkJZ290byBvdXQ7CisKKwkJbXNsZWVwKDUwKTsK
Kwl9CisJcmV0dmFsID0gMDsKK291dDogCisJcmV0dXJuIHJldHZhbDsKK30gLyogRW5kIHR3bF9w
b2xsX3Jlc3BvbnNlKCkgKi8KKworLyogVGhpcyBmdW5jdGlvbiB3aWxsIGRyYWluIHRoZSBhZW4g
cXVldWUgKi8KK3N0YXRpYyBpbnQgdHdsX2Flbl9kcmFpbl9xdWV1ZShUV19EZXZpY2VfRXh0ZW5z
aW9uICp0d19kZXYsIGludCBub19jaGVja19yZXNldCkKK3sKKwlpbnQgcmVxdWVzdF9pZCA9IDA7
CisJY2hhciBjZGJbVFdfTUFYX0NEQl9MRU5dOworCVRXX1NHX0VudHJ5X0lTTyBzZ2xpc3RbMV07
CisJaW50IGZpbmlzaGVkID0gMCwgY291bnQgPSAwOworCVRXX0NvbW1hbmRfRnVsbCAqZnVsbF9j
b21tYW5kX3BhY2tldDsKKwlUV19Db21tYW5kX0FwYWNoZV9IZWFkZXIgKmhlYWRlcjsKKwl1bnNp
Z25lZCBzaG9ydCBhZW47CisJaW50IGZpcnN0X3Jlc2V0ID0gMCwgcXVldWUgPSAwLCByZXR2YWwg
PSAxOworCisJaWYgKG5vX2NoZWNrX3Jlc2V0KQorCQlmaXJzdF9yZXNldCA9IDA7CisJZWxzZQor
CQlmaXJzdF9yZXNldCA9IDE7CisKKwlmdWxsX2NvbW1hbmRfcGFja2V0ID0gdHdfZGV2LT5jb21t
YW5kX3BhY2tldF92aXJ0W3JlcXVlc3RfaWRdOworCW1lbXNldChmdWxsX2NvbW1hbmRfcGFja2V0
LCAwLCBzaXplb2YoVFdfQ29tbWFuZF9GdWxsKSk7CisKKwkvKiBJbml0aWFsaXplIGNkYiAqLwor
CW1lbXNldCgmY2RiLCAwLCBUV19NQVhfQ0RCX0xFTik7CisJY2RiWzBdID0gUkVRVUVTVF9TRU5T
RTsgLyogb3Bjb2RlICovCisJY2RiWzRdID0gVFdfQUxMT0NBVElPTl9MRU5HVEg7IC8qIGFsbG9j
YXRpb24gbGVuZ3RoICovCisKKwkvKiBJbml0aWFsaXplIHNnbGlzdCAqLworCW1lbXNldCgmc2ds
aXN0LCAwLCBzaXplb2YoVFdfU0dfRW50cnlfSVNPKSk7CisJc2dsaXN0WzBdLmxlbmd0aCA9IFRX
X1NFQ1RPUl9TSVpFOworCXNnbGlzdFswXS5hZGRyZXNzID0gdHdfZGV2LT5nZW5lcmljX2J1ZmZl
cl9waHlzW3JlcXVlc3RfaWRdOworCisJLyogTWFyayBpbnRlcm5hbCBjb21tYW5kICovCisJdHdf
ZGV2LT5zcmJbcmVxdWVzdF9pZF0gPSBOVUxMOworCisJZG8geworCQkvKiBTZW5kIGNvbW1hbmQg
dG8gdGhlIGJvYXJkICovCisJCWlmICh0d2xfc2NzaW9wX2V4ZWN1dGVfc2NzaSh0d19kZXYsIHJl
cXVlc3RfaWQsIGNkYiwgMSwgc2dsaXN0KSkgeworCQkJVFdfUFJJTlRLKHR3X2Rldi0+aG9zdCwg
VFdfRFJJVkVSLCAweDMsICJFcnJvciBwb3N0aW5nIHJlcXVlc3Qgc2Vuc2UiKTsKKwkJCWdvdG8g
b3V0OworCQl9CisKKwkJLyogTm93IHBvbGwgZm9yIGNvbXBsZXRpb24gKi8KKwkJaWYgKHR3bF9w
b2xsX3Jlc3BvbnNlKHR3X2RldiwgcmVxdWVzdF9pZCwgMzApKSB7CisJCQlUV19QUklOVEsodHdf
ZGV2LT5ob3N0LCBUV19EUklWRVIsIDB4NCwgIk5vIHZhbGlkIHJlc3BvbnNlIHdoaWxlIGRyYWlu
aW5nIEFFTiBxdWV1ZSIpOworCQkJdHdfZGV2LT5wb3N0ZWRfcmVxdWVzdF9jb3VudC0tOworCQkJ
Z290byBvdXQ7CisJCX0KKworCQl0d19kZXYtPnBvc3RlZF9yZXF1ZXN0X2NvdW50LS07CisJCWhl
YWRlciA9IChUV19Db21tYW5kX0FwYWNoZV9IZWFkZXIgKil0d19kZXYtPmdlbmVyaWNfYnVmZmVy
X3ZpcnRbcmVxdWVzdF9pZF07CisJCWFlbiA9IGxlMTZfdG9fY3B1KGhlYWRlci0+c3RhdHVzX2Js
b2NrLmVycm9yKTsKKwkJcXVldWUgPSAwOworCQljb3VudCsrOworCisJCXN3aXRjaCAoYWVuKSB7
CisJCWNhc2UgVFdfQUVOX1FVRVVFX0VNUFRZOgorCQkJaWYgKGZpcnN0X3Jlc2V0ICE9IDEpCisJ
CQkJZ290byBvdXQ7CisJCQllbHNlCisJCQkJZmluaXNoZWQgPSAxOworCQkJYnJlYWs7CisJCWNh
c2UgVFdfQUVOX1NPRlRfUkVTRVQ6CisJCQlpZiAoZmlyc3RfcmVzZXQgPT0gMCkKKwkJCQlmaXJz
dF9yZXNldCA9IDE7CisJCQllbHNlCisJCQkJcXVldWUgPSAxOworCQkJYnJlYWs7CisJCWNhc2Ug
VFdfQUVOX1NZTkNfVElNRV9XSVRIX0hPU1Q6CisJCQlicmVhazsKKwkJZGVmYXVsdDoKKwkJCXF1
ZXVlID0gMTsKKwkJfQorCisJCS8qIE5vdyBxdWV1ZSBhbiBldmVudCBpbmZvICovCisJCWlmIChx
dWV1ZSkKKwkJCXR3bF9hZW5fcXVldWVfZXZlbnQodHdfZGV2LCBoZWFkZXIpOworCX0gd2hpbGUg
KChmaW5pc2hlZCA9PSAwKSAmJiAoY291bnQgPCBUV19NQVhfQUVOX0RSQUlOKSk7CisKKwlpZiAo
Y291bnQgPT0gVFdfTUFYX0FFTl9EUkFJTikKKwkJZ290byBvdXQ7CisKKwlyZXR2YWwgPSAwOwor
b3V0OgorCXR3X2Rldi0+c3RhdGVbcmVxdWVzdF9pZF0gPSBUV19TX0lOSVRJQUw7CisJcmV0dXJu
IHJldHZhbDsKK30gLyogRW5kIHR3bF9hZW5fZHJhaW5fcXVldWUoKSAqLworCisvKiBUaGlzIGZ1
bmN0aW9uIHdpbGwgYWxsb2NhdGUgbWVtb3J5IGFuZCBjaGVjayBpZiBpdCBpcyBjb3JyZWN0bHkg
YWxpZ25lZCAqLworc3RhdGljIGludCB0d2xfYWxsb2NhdGVfbWVtb3J5KFRXX0RldmljZV9FeHRl
bnNpb24gKnR3X2RldiwgaW50IHNpemUsIGludCB3aGljaCkKK3sKKwlpbnQgaTsKKwlkbWFfYWRk
cl90IGRtYV9oYW5kbGU7CisJdW5zaWduZWQgbG9uZyAqY3B1X2FkZHI7CisJaW50IHJldHZhbCA9
IDE7CisKKwljcHVfYWRkciA9IHBjaV9hbGxvY19jb25zaXN0ZW50KHR3X2Rldi0+dHdfcGNpX2Rl
diwgc2l6ZSpUV19RX0xFTkdUSCwgJmRtYV9oYW5kbGUpOworCWlmICghY3B1X2FkZHIpIHsKKwkJ
VFdfUFJJTlRLKHR3X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAweDUsICJNZW1vcnkgYWxsb2NhdGlv
biBmYWlsZWQiKTsKKwkJZ290byBvdXQ7CisJfQorCisJbWVtc2V0KGNwdV9hZGRyLCAwLCBzaXpl
KlRXX1FfTEVOR1RIKTsKKworCWZvciAoaSA9IDA7IGkgPCBUV19RX0xFTkdUSDsgaSsrKSB7CisJ
CXN3aXRjaCh3aGljaCkgeworCQljYXNlIDA6CisJCQl0d19kZXYtPmNvbW1hbmRfcGFja2V0X3Bo
eXNbaV0gPSBkbWFfaGFuZGxlKyhpKnNpemUpOworCQkJdHdfZGV2LT5jb21tYW5kX3BhY2tldF92
aXJ0W2ldID0gKFRXX0NvbW1hbmRfRnVsbCAqKSgodW5zaWduZWQgY2hhciAqKWNwdV9hZGRyICsg
KGkqc2l6ZSkpOworCQkJYnJlYWs7CisJCWNhc2UgMToKKwkJCXR3X2Rldi0+Z2VuZXJpY19idWZm
ZXJfcGh5c1tpXSA9IGRtYV9oYW5kbGUrKGkqc2l6ZSk7CisJCQl0d19kZXYtPmdlbmVyaWNfYnVm
ZmVyX3ZpcnRbaV0gPSAodW5zaWduZWQgbG9uZyAqKSgodW5zaWduZWQgY2hhciAqKWNwdV9hZGRy
ICsgKGkqc2l6ZSkpOworCQkJYnJlYWs7CisJCWNhc2UgMjoKKwkJCXR3X2Rldi0+c2Vuc2VfYnVm
ZmVyX3BoeXNbaV0gPSBkbWFfaGFuZGxlKyhpKnNpemUpOworCQkJdHdfZGV2LT5zZW5zZV9idWZm
ZXJfdmlydFtpXSA9IChUV19Db21tYW5kX0FwYWNoZV9IZWFkZXIgKikoKHVuc2lnbmVkIGNoYXIg
KiljcHVfYWRkciArIChpKnNpemUpKTsKKwkJCWJyZWFrOworCQl9CisJfQorCXJldHZhbCA9IDA7
CitvdXQ6CisJcmV0dXJuIHJldHZhbDsKK30gLyogRW5kIHR3bF9hbGxvY2F0ZV9tZW1vcnkoKSAq
LworCisvKiBUaGlzIGZ1bmN0aW9uIHdpbGwgbG9hZCB0aGUgcmVxdWVzdCBpZCBhbmQgdmFyaW91
cyBzZ2xzIGZvciBpb2N0bHMgKi8KK3N0YXRpYyB2b2lkIHR3bF9sb2FkX3NnbChUV19EZXZpY2Vf
RXh0ZW5zaW9uICp0d19kZXYsIFRXX0NvbW1hbmRfRnVsbCAqZnVsbF9jb21tYW5kX3BhY2tldCwg
aW50IHJlcXVlc3RfaWQsIGRtYV9hZGRyX3QgZG1hX2hhbmRsZSwgaW50IGxlbmd0aCkKK3sKKwlU
V19Db21tYW5kICpvbGRjb21tYW5kOworCVRXX0NvbW1hbmRfQXBhY2hlICpuZXdjb21tYW5kOwor
CVRXX1NHX0VudHJ5X0lTTyAqc2dsOworCXVuc2lnbmVkIGludCBwYWUgPSAwOworCisJaWYgKChz
aXplb2YobG9uZykgPCA4KSAmJiAoc2l6ZW9mKGRtYV9hZGRyX3QpID4gNCkpCisJCXBhZSA9IDE7
CisKKwlpZiAoVFdfT1BfT1VUKGZ1bGxfY29tbWFuZF9wYWNrZXQtPmNvbW1hbmQubmV3Y29tbWFu
ZC5vcGNvZGVfX3Jlc2VydmVkKSA9PSBUV19PUF9FWEVDVVRFX1NDU0kpIHsKKwkJbmV3Y29tbWFu
ZCA9ICZmdWxsX2NvbW1hbmRfcGFja2V0LT5jb21tYW5kLm5ld2NvbW1hbmQ7CisJCW5ld2NvbW1h
bmQtPnJlcXVlc3RfaWRfX2x1bmwgPQorCQkJY3B1X3RvX2xlMTYoVFdfUkVRX0xVTl9JTihUV19M
VU5fT1VUKG5ld2NvbW1hbmQtPnJlcXVlc3RfaWRfX2x1bmwpLCByZXF1ZXN0X2lkKSk7CisJCWlm
IChsZW5ndGgpIHsKKwkJCW5ld2NvbW1hbmQtPnNnX2xpc3RbMF0uYWRkcmVzcyA9IFRXX0NQVV9U
T19TR0woZG1hX2hhbmRsZSArIHNpemVvZihUV19Jb2N0bF9CdWZfQXBhY2hlKSAtIDEpOworCQkJ
bmV3Y29tbWFuZC0+c2dfbGlzdFswXS5sZW5ndGggPSBUV19DUFVfVE9fU0dMKGxlbmd0aCk7CisJ
CX0KKwkJbmV3Y29tbWFuZC0+c2dsX2VudHJpZXNfX2x1bmggPQorCQkJY3B1X3RvX2xlMTYoVFdf
UkVRX0xVTl9JTihUV19MVU5fT1VUKG5ld2NvbW1hbmQtPnNnbF9lbnRyaWVzX19sdW5oKSwgbGVu
Z3RoID8gMSA6IDApKTsKKwl9IGVsc2UgeworCQlvbGRjb21tYW5kID0gJmZ1bGxfY29tbWFuZF9w
YWNrZXQtPmNvbW1hbmQub2xkY29tbWFuZDsKKwkJb2xkY29tbWFuZC0+cmVxdWVzdF9pZCA9IHJl
cXVlc3RfaWQ7CisKKwkJaWYgKFRXX1NHTF9PVVQob2xkY29tbWFuZC0+b3Bjb2RlX19zZ2xvZmZz
ZXQpKSB7CisJCQkvKiBMb2FkIHRoZSBzZyBsaXN0ICovCisJCQlzZ2wgPSAoVFdfU0dfRW50cnlf
SVNPICopKCh1MzIgKilvbGRjb21tYW5kK29sZGNvbW1hbmQtPnNpemUgLSAoc2l6ZW9mKFRXX1NH
X0VudHJ5X0lTTykvNCkgKyBwYWUgKyAoc2l6ZW9mKGRtYV9hZGRyX3QpID4gNCA/IDEgOiAwKSk7
CisJCQlzZ2wtPmFkZHJlc3MgPSBUV19DUFVfVE9fU0dMKGRtYV9oYW5kbGUgKyBzaXplb2YoVFdf
SW9jdGxfQnVmX0FwYWNoZSkgLSAxKTsKKwkJCXNnbC0+bGVuZ3RoID0gVFdfQ1BVX1RPX1NHTChs
ZW5ndGgpOworCQkJb2xkY29tbWFuZC0+c2l6ZSArPSBwYWU7CisJCQlvbGRjb21tYW5kLT5zaXpl
ICs9IHNpemVvZihkbWFfYWRkcl90KSA+IDQgPyAxIDogMDsKKwkJfQorCX0KK30gLyogRW5kIHR3
bF9sb2FkX3NnbCgpICovCisKKy8qIFRoaXMgZnVuY3Rpb24gaGFuZGxlcyBpb2N0bCBmb3IgdGhl
IGNoYXJhY3RlciBkZXZpY2UKKyAgIFRoaXMgaW50ZXJmYWNlIGlzIHVzZWQgYnkgc21hcnRtb250
b29scyBvcGVuIHNvdXJjZSBzb2Z0d2FyZSAqLworc3RhdGljIGludCB0d2xfY2hyZGV2X2lvY3Rs
KHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxlICpmaWxlLCB1bnNpZ25lZCBpbnQgY21k
LCB1bnNpZ25lZCBsb25nIGFyZykKK3sKKwlsb25nIHRpbWVvdXQ7CisJdW5zaWduZWQgbG9uZyAq
Y3B1X2FkZHIsIGRhdGFfYnVmZmVyX2xlbmd0aF9hZGp1c3RlZCA9IDAsIGZsYWdzID0gMDsKKwlk
bWFfYWRkcl90IGRtYV9oYW5kbGU7CisJaW50IHJlcXVlc3RfaWQgPSAwOworCVRXX0lvY3RsX0Ry
aXZlcl9Db21tYW5kIGRyaXZlcl9jb21tYW5kOworCVRXX0lvY3RsX0J1Zl9BcGFjaGUgKnR3X2lv
Y3RsOworCVRXX0NvbW1hbmRfRnVsbCAqZnVsbF9jb21tYW5kX3BhY2tldDsKKwlUV19EZXZpY2Vf
RXh0ZW5zaW9uICp0d19kZXYgPSB0d2xfZGV2aWNlX2V4dGVuc2lvbl9saXN0W2ltaW5vcihpbm9k
ZSldOworCWludCByZXR2YWwgPSAtRUZBVUxUOworCXZvaWQgX191c2VyICphcmdwID0gKHZvaWQg
X191c2VyICopYXJnOworCisJLyogT25seSBsZXQgb25lIG9mIHRoZXNlIHRocm91Z2ggYXQgYSB0
aW1lICovCisJaWYgKG11dGV4X2xvY2tfaW50ZXJydXB0aWJsZSgmdHdfZGV2LT5pb2N0bF9sb2Nr
KSkgeworCQlyZXR2YWwgPSAtRUlOVFI7CisJCWdvdG8gb3V0OworCX0KKworCS8qIEZpcnN0IGNv
cHkgZG93biB0aGUgZHJpdmVyIGNvbW1hbmQgKi8KKwlpZiAoY29weV9mcm9tX3VzZXIoJmRyaXZl
cl9jb21tYW5kLCBhcmdwLCBzaXplb2YoVFdfSW9jdGxfRHJpdmVyX0NvbW1hbmQpKSkKKwkJZ290
byBvdXQyOworCisJLyogQ2hlY2sgZGF0YSBidWZmZXIgc2l6ZSAqLworCWlmIChkcml2ZXJfY29t
bWFuZC5idWZmZXJfbGVuZ3RoID4gVFdfTUFYX1NFQ1RPUlMgKiAyMDQ4KSB7CisJCXJldHZhbCA9
IC1FSU5WQUw7CisJCWdvdG8gb3V0MjsKKwl9CisKKwkvKiBIYXJkd2FyZSBjYW4gb25seSBkbyBt
dWx0aXBsZSBvZiA1MTIgYnl0ZSB0cmFuc2ZlcnMgKi8KKwlkYXRhX2J1ZmZlcl9sZW5ndGhfYWRq
dXN0ZWQgPSAoZHJpdmVyX2NvbW1hbmQuYnVmZmVyX2xlbmd0aCArIDUxMSkgJiB+NTExOworCisJ
LyogTm93IGFsbG9jYXRlIGlvY3RsIGJ1ZiBtZW1vcnkgKi8KKwljcHVfYWRkciA9IGRtYV9hbGxv
Y19jb2hlcmVudCgmdHdfZGV2LT50d19wY2lfZGV2LT5kZXYsIGRhdGFfYnVmZmVyX2xlbmd0aF9h
ZGp1c3RlZCtzaXplb2YoVFdfSW9jdGxfQnVmX0FwYWNoZSkgLSAxLCAmZG1hX2hhbmRsZSwgR0ZQ
X0tFUk5FTCk7CisJaWYgKCFjcHVfYWRkcikgeworCQlyZXR2YWwgPSAtRU5PTUVNOworCQlnb3Rv
IG91dDI7CisJfQorCisJdHdfaW9jdGwgPSAoVFdfSW9jdGxfQnVmX0FwYWNoZSAqKWNwdV9hZGRy
OworCisJLyogTm93IGNvcHkgZG93biB0aGUgZW50aXJlIGlvY3RsICovCisJaWYgKGNvcHlfZnJv
bV91c2VyKHR3X2lvY3RsLCBhcmdwLCBkcml2ZXJfY29tbWFuZC5idWZmZXJfbGVuZ3RoICsgc2l6
ZW9mKFRXX0lvY3RsX0J1Zl9BcGFjaGUpIC0gMSkpCisJCWdvdG8gb3V0MzsKKworCS8qIFNlZSB3
aGljaCBpb2N0bCB3ZSBhcmUgZG9pbmcgKi8KKwlzd2l0Y2ggKGNtZCkgeworCWNhc2UgVFdfSU9D
VExfRklSTVdBUkVfUEFTU19USFJPVUdIOgorCQlzcGluX2xvY2tfaXJxc2F2ZSh0d19kZXYtPmhv
c3QtPmhvc3RfbG9jaywgZmxhZ3MpOworCQl0d2xfZ2V0X3JlcXVlc3RfaWQodHdfZGV2LCAmcmVx
dWVzdF9pZCk7CisKKwkJLyogRmxhZyBpbnRlcm5hbCBjb21tYW5kICovCisJCXR3X2Rldi0+c3Ji
W3JlcXVlc3RfaWRdID0gTlVMTDsKKworCQkvKiBGbGFnIGNocmRldiBpb2N0bCAqLworCQl0d19k
ZXYtPmNocmRldl9yZXF1ZXN0X2lkID0gcmVxdWVzdF9pZDsKKworCQlmdWxsX2NvbW1hbmRfcGFj
a2V0ID0gKFRXX0NvbW1hbmRfRnVsbCAqKSZ0d19pb2N0bC0+ZmlybXdhcmVfY29tbWFuZDsKKwor
CQkvKiBMb2FkIHJlcXVlc3QgaWQgYW5kIHNnbGlzdCBmb3IgYm90aCBjb21tYW5kIHR5cGVzICov
CisJCXR3bF9sb2FkX3NnbCh0d19kZXYsIGZ1bGxfY29tbWFuZF9wYWNrZXQsIHJlcXVlc3RfaWQs
IGRtYV9oYW5kbGUsIGRhdGFfYnVmZmVyX2xlbmd0aF9hZGp1c3RlZCk7CisKKwkJbWVtY3B5KHR3
X2Rldi0+Y29tbWFuZF9wYWNrZXRfdmlydFtyZXF1ZXN0X2lkXSwgJih0d19pb2N0bC0+ZmlybXdh
cmVfY29tbWFuZCksIHNpemVvZihUV19Db21tYW5kX0Z1bGwpKTsKKworCQkvKiBOb3cgcG9zdCB0
aGUgY29tbWFuZCBwYWNrZXQgdG8gdGhlIGNvbnRyb2xsZXIgKi8KKwkJdHdsX3Bvc3RfY29tbWFu
ZF9wYWNrZXQodHdfZGV2LCByZXF1ZXN0X2lkKTsKKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSh0
d19kZXYtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOworCisJCXRpbWVvdXQgPSBUV19JT0NUTF9D
SFJERVZfVElNRU9VVCpIWjsKKworCQkvKiBOb3cgd2FpdCBmb3IgY29tbWFuZCB0byBjb21wbGV0
ZSAqLworCQl0aW1lb3V0ID0gd2FpdF9ldmVudF90aW1lb3V0KHR3X2Rldi0+aW9jdGxfd3F1ZXVl
LCB0d19kZXYtPmNocmRldl9yZXF1ZXN0X2lkID09IFRXX0lPQ1RMX0NIUkRFVl9GUkVFLCB0aW1l
b3V0KTsKKworCQkvKiBXZSB0aW1lZCBvdXQsIGFuZCBkaWRuJ3QgZ2V0IGFuIGludGVycnVwdCAq
LworCQlpZiAodHdfZGV2LT5jaHJkZXZfcmVxdWVzdF9pZCAhPSBUV19JT0NUTF9DSFJERVZfRlJF
RSkgeworCQkJLyogTm93IHdlIG5lZWQgdG8gcmVzZXQgdGhlIGJvYXJkICovCisJCQlwcmludGso
S0VSTl9XQVJOSU5HICIzdy1zYXM6IHNjc2klZDogV0FSTklORzogKDB4JTAyWDoweCUwNFgpOiBD
aGFyYWN0ZXIgaW9jdGwgKDB4JXgpIHRpbWVkIG91dCwgcmVzZXR0aW5nIGNhcmQuXG4iLAorCQkJ
ICAgICAgIHR3X2Rldi0+aG9zdC0+aG9zdF9ubywgVFdfRFJJVkVSLCAweDYsCisJCQkgICAgICAg
Y21kKTsKKwkJCXJldHZhbCA9IC1FSU87CisJCQl0d2xfcmVzZXRfZGV2aWNlX2V4dGVuc2lvbih0
d19kZXYsIDEpOworCQkJZ290byBvdXQzOworCQl9CisKKwkJLyogTm93IGNvcHkgaW4gdGhlIGNv
bW1hbmQgcGFja2V0IHJlc3BvbnNlICovCisJCW1lbWNweSgmKHR3X2lvY3RsLT5maXJtd2FyZV9j
b21tYW5kKSwgdHdfZGV2LT5jb21tYW5kX3BhY2tldF92aXJ0W3JlcXVlc3RfaWRdLCBzaXplb2Yo
VFdfQ29tbWFuZF9GdWxsKSk7CisJCQorCQkvKiBOb3cgY29tcGxldGUgdGhlIGlvICovCisJCXNw
aW5fbG9ja19pcnFzYXZlKHR3X2Rldi0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7CisJCXR3X2Rl
di0+cG9zdGVkX3JlcXVlc3RfY291bnQtLTsKKwkJdHdfZGV2LT5zdGF0ZVtyZXF1ZXN0X2lkXSA9
IFRXX1NfQ09NUExFVEVEOworCQl0d2xfZnJlZV9yZXF1ZXN0X2lkKHR3X2RldiwgcmVxdWVzdF9p
ZCk7CisJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUodHdfZGV2LT5ob3N0LT5ob3N0X2xvY2ssIGZs
YWdzKTsKKwkJYnJlYWs7CisJZGVmYXVsdDoKKwkJcmV0dmFsID0gLUVOT1RUWTsKKwkJZ290byBv
dXQzOworCX0KKworCS8qIE5vdyBjb3B5IHRoZSBlbnRpcmUgcmVzcG9uc2UgdG8gdXNlcnNwYWNl
ICovCisJaWYgKGNvcHlfdG9fdXNlcihhcmdwLCB0d19pb2N0bCwgc2l6ZW9mKFRXX0lvY3RsX0J1
Zl9BcGFjaGUpICsgZHJpdmVyX2NvbW1hbmQuYnVmZmVyX2xlbmd0aCAtIDEpID09IDApCisJCXJl
dHZhbCA9IDA7CitvdXQzOgorCS8qIE5vdyBmcmVlIGlvY3RsIGJ1ZiBtZW1vcnkgKi8KKwlkbWFf
ZnJlZV9jb2hlcmVudCgmdHdfZGV2LT50d19wY2lfZGV2LT5kZXYsIGRhdGFfYnVmZmVyX2xlbmd0
aF9hZGp1c3RlZCtzaXplb2YoVFdfSW9jdGxfQnVmX0FwYWNoZSkgLSAxLCBjcHVfYWRkciwgZG1h
X2hhbmRsZSk7CitvdXQyOgorCW11dGV4X3VubG9jaygmdHdfZGV2LT5pb2N0bF9sb2NrKTsKK291
dDoKKwlyZXR1cm4gcmV0dmFsOworfSAvKiBFbmQgdHdsX2NocmRldl9pb2N0bCgpICovCisKKy8q
IFRoaXMgZnVuY3Rpb24gaGFuZGxlcyBvcGVuIGZvciB0aGUgY2hhcmFjdGVyIGRldmljZSAqLwor
c3RhdGljIGludCB0d2xfY2hyZGV2X29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZp
bGUgKmZpbGUpCit7CisJdW5zaWduZWQgaW50IG1pbm9yX251bWJlcjsKKwlpbnQgcmV0dmFsID0g
LUVOT0RFVjsKKworCWlmICghY2FwYWJsZShDQVBfU1lTX0FETUlOKSkgeworCQlyZXR2YWwgPSAt
RUFDQ0VTOworCQlnb3RvIG91dDsKKwl9CisKKwljeWNsZV9rZXJuZWxfbG9jaygpOworCW1pbm9y
X251bWJlciA9IGltaW5vcihpbm9kZSk7CisJaWYgKG1pbm9yX251bWJlciA+PSB0d2xfZGV2aWNl
X2V4dGVuc2lvbl9jb3VudCkKKwkJZ290byBvdXQ7CisJcmV0dmFsID0gMDsKK291dDoKKwlyZXR1
cm4gcmV0dmFsOworfSAvKiBFbmQgdHdsX2NocmRldl9vcGVuKCkgKi8KKworLyogRmlsZSBvcGVy
YXRpb25zIHN0cnVjdCBmb3IgY2hhcmFjdGVyIGRldmljZSAqLworc3RhdGljIGNvbnN0IHN0cnVj
dCBmaWxlX29wZXJhdGlvbnMgdHdsX2ZvcHMgPSB7CisJLm93bmVyCQk9IFRISVNfTU9EVUxFLAor
CS5pb2N0bAkJPSB0d2xfY2hyZGV2X2lvY3RsLAorCS5vcGVuCQk9IHR3bF9jaHJkZXZfb3BlbiwK
KwkucmVsZWFzZQk9IE5VTEwKK307CisKKy8qIFRoaXMgZnVuY3Rpb24gcGFzc2VzIHNlbnNlIGRh
dGEgZnJvbSBmaXJtd2FyZSB0byBzY3NpIGxheWVyICovCitzdGF0aWMgaW50IHR3bF9maWxsX3Nl
bnNlKFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldiwgaW50IGksIGludCByZXF1ZXN0X2lkLCBp
bnQgY29weV9zZW5zZSwgaW50IHByaW50X2hvc3QpCit7CisJVFdfQ29tbWFuZF9BcGFjaGVfSGVh
ZGVyICpoZWFkZXI7CisJVFdfQ29tbWFuZF9GdWxsICpmdWxsX2NvbW1hbmRfcGFja2V0OworCXVu
c2lnbmVkIHNob3J0IGVycm9yOworCWNoYXIgKmVycm9yX3N0cjsKKwlpbnQgcmV0dmFsID0gMTsK
KworCWhlYWRlciA9IHR3X2Rldi0+c2Vuc2VfYnVmZmVyX3ZpcnRbaV07CisJZnVsbF9jb21tYW5k
X3BhY2tldCA9IHR3X2Rldi0+Y29tbWFuZF9wYWNrZXRfdmlydFtyZXF1ZXN0X2lkXTsKKworCS8q
IEdldCBlbWJlZGRlZCBmaXJtd2FyZSBlcnJvciBzdHJpbmcgKi8KKwllcnJvcl9zdHIgPSAmKGhl
YWRlci0+ZXJyX3NwZWNpZmljX2Rlc2Nbc3RybGVuKGhlYWRlci0+ZXJyX3NwZWNpZmljX2Rlc2Mp
ICsgMV0pOworCisJLyogRG9uJ3QgcHJpbnQgZXJyb3IgZm9yIExvZ2ljYWwgdW5pdCBub3Qgc3Vw
cG9ydGVkIGR1cmluZyByb2xsY2FsbCAqLworCWVycm9yID0gbGUxNl90b19jcHUoaGVhZGVyLT5z
dGF0dXNfYmxvY2suZXJyb3IpOworCWlmICgoZXJyb3IgIT0gVFdfRVJST1JfTE9HSUNBTF9VTklU
X05PVF9TVVBQT1JURUQpICYmIChlcnJvciAhPSBUV19FUlJPUl9VTklUX09GRkxJTkUpICYmIChl
cnJvciAhPSBUV19FUlJPUl9JTlZBTElEX0ZJRUxEX0lOX0NEQikpIHsKKwkJaWYgKHByaW50X2hv
c3QpCisJCQlwcmludGsoS0VSTl9XQVJOSU5HICIzdy1zYXM6IHNjc2klZDogRVJST1I6ICgweCUw
Mlg6MHglMDRYKTogJXM6JXMuXG4iLAorCQkJICAgICAgIHR3X2Rldi0+aG9zdC0+aG9zdF9ubywK
KwkJCSAgICAgICBUV19NRVNTQUdFX1NPVVJDRV9DT05UUk9MTEVSX0VSUk9SLAorCQkJICAgICAg
IGhlYWRlci0+c3RhdHVzX2Jsb2NrLmVycm9yLAorCQkJICAgICAgIGVycm9yX3N0ciwgCisJCQkg
ICAgICAgaGVhZGVyLT5lcnJfc3BlY2lmaWNfZGVzYyk7CisJCWVsc2UKKwkJCXByaW50ayhLRVJO
X1dBUk5JTkcgIjN3LXNhczogRVJST1I6ICgweCUwMlg6MHglMDRYKTogJXM6JXMuXG4iLAorCQkJ
ICAgICAgIFRXX01FU1NBR0VfU09VUkNFX0NPTlRST0xMRVJfRVJST1IsCisJCQkgICAgICAgaGVh
ZGVyLT5zdGF0dXNfYmxvY2suZXJyb3IsCisJCQkgICAgICAgZXJyb3Jfc3RyLAorCQkJICAgICAg
IGhlYWRlci0+ZXJyX3NwZWNpZmljX2Rlc2MpOworCX0KKworCWlmIChjb3B5X3NlbnNlKSB7CisJ
CW1lbWNweSh0d19kZXYtPnNyYltyZXF1ZXN0X2lkXS0+c2Vuc2VfYnVmZmVyLCBoZWFkZXItPnNl
bnNlX2RhdGEsIFRXX1NFTlNFX0RBVEFfTEVOR1RIKTsKKwkJdHdfZGV2LT5zcmJbcmVxdWVzdF9p
ZF0tPnJlc3VsdCA9IChmdWxsX2NvbW1hbmRfcGFja2V0LT5jb21tYW5kLm5ld2NvbW1hbmQuc3Rh
dHVzIDw8IDEpOworCQlnb3RvIG91dDsKKwl9CitvdXQ6CisJcmV0dXJuIHJldHZhbDsKK30gLyog
RW5kIHR3bF9maWxsX3NlbnNlKCkgKi8KKworLyogVGhpcyBmdW5jdGlvbiB3aWxsIGZyZWUgdXAg
ZGV2aWNlIGV4dGVuc2lvbiByZXNvdXJjZXMgKi8KK3N0YXRpYyB2b2lkIHR3bF9mcmVlX2Rldmlj
ZV9leHRlbnNpb24oVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2KQoreworCWlmICh0d19kZXYt
PmNvbW1hbmRfcGFja2V0X3ZpcnRbMF0pCisJCXBjaV9mcmVlX2NvbnNpc3RlbnQodHdfZGV2LT50
d19wY2lfZGV2LAorCQkJCSAgICBzaXplb2YoVFdfQ29tbWFuZF9GdWxsKSpUV19RX0xFTkdUSCwK
KwkJCQkgICAgdHdfZGV2LT5jb21tYW5kX3BhY2tldF92aXJ0WzBdLAorCQkJCSAgICB0d19kZXYt
PmNvbW1hbmRfcGFja2V0X3BoeXNbMF0pOworCisJaWYgKHR3X2Rldi0+Z2VuZXJpY19idWZmZXJf
dmlydFswXSkKKwkJcGNpX2ZyZWVfY29uc2lzdGVudCh0d19kZXYtPnR3X3BjaV9kZXYsCisJCQkJ
ICAgIFRXX1NFQ1RPUl9TSVpFKlRXX1FfTEVOR1RILAorCQkJCSAgICB0d19kZXYtPmdlbmVyaWNf
YnVmZmVyX3ZpcnRbMF0sCisJCQkJICAgIHR3X2Rldi0+Z2VuZXJpY19idWZmZXJfcGh5c1swXSk7
CisKKwlpZiAodHdfZGV2LT5zZW5zZV9idWZmZXJfdmlydFswXSkKKwkJcGNpX2ZyZWVfY29uc2lz
dGVudCh0d19kZXYtPnR3X3BjaV9kZXYsCisJCQkJICAgIHNpemVvZihUV19Db21tYW5kX0FwYWNo
ZV9IZWFkZXIpKgorCQkJCSAgICBUV19RX0xFTkdUSCwKKwkJCQkgICAgdHdfZGV2LT5zZW5zZV9i
dWZmZXJfdmlydFswXSwKKwkJCQkgICAgdHdfZGV2LT5zZW5zZV9idWZmZXJfcGh5c1swXSk7CisK
KwlrZnJlZSh0d19kZXYtPmV2ZW50X3F1ZXVlWzBdKTsKK30gLyogRW5kIHR3bF9mcmVlX2Rldmlj
ZV9leHRlbnNpb24oKSAqLworCisvKiBUaGlzIGZ1bmN0aW9uIHdpbGwgZ2V0IHBhcmFtZXRlciB0
YWJsZSBlbnRyaWVzIGZyb20gdGhlIGZpcm13YXJlICovCitzdGF0aWMgdm9pZCAqdHdsX2dldF9w
YXJhbShUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYsIGludCByZXF1ZXN0X2lkLCBpbnQgdGFi
bGVfaWQsIGludCBwYXJhbWV0ZXJfaWQsIGludCBwYXJhbWV0ZXJfc2l6ZV9ieXRlcykKK3sKKwlU
V19Db21tYW5kX0Z1bGwgKmZ1bGxfY29tbWFuZF9wYWNrZXQ7CisJVFdfQ29tbWFuZCAqY29tbWFu
ZF9wYWNrZXQ7CisJVFdfUGFyYW1fQXBhY2hlICpwYXJhbTsKKwl2b2lkICpyZXR2YWwgPSBOVUxM
OworCisJLyogU2V0dXAgdGhlIGNvbW1hbmQgcGFja2V0ICovCisJZnVsbF9jb21tYW5kX3BhY2tl
dCA9IHR3X2Rldi0+Y29tbWFuZF9wYWNrZXRfdmlydFtyZXF1ZXN0X2lkXTsKKwltZW1zZXQoZnVs
bF9jb21tYW5kX3BhY2tldCwgMCwgc2l6ZW9mKFRXX0NvbW1hbmRfRnVsbCkpOworCWNvbW1hbmRf
cGFja2V0ID0gJmZ1bGxfY29tbWFuZF9wYWNrZXQtPmNvbW1hbmQub2xkY29tbWFuZDsKKworCWNv
bW1hbmRfcGFja2V0LT5vcGNvZGVfX3NnbG9mZnNldCA9IFRXX09QU0dMX0lOKDIsIFRXX09QX0dF
VF9QQVJBTSk7CisJY29tbWFuZF9wYWNrZXQtPnNpemUgICAgICAgICAgICAgID0gVFdfQ09NTUFO
RF9TSVpFOworCWNvbW1hbmRfcGFja2V0LT5yZXF1ZXN0X2lkICAgICAgICA9IHJlcXVlc3RfaWQ7
CisJY29tbWFuZF9wYWNrZXQtPmJ5dGU2X29mZnNldC5ibG9ja19jb3VudCA9IGNwdV90b19sZTE2
KDEpOworCisJLyogTm93IHNldHVwIHRoZSBwYXJhbSAqLworCXBhcmFtID0gKFRXX1BhcmFtX0Fw
YWNoZSAqKXR3X2Rldi0+Z2VuZXJpY19idWZmZXJfdmlydFtyZXF1ZXN0X2lkXTsKKwltZW1zZXQo
cGFyYW0sIDAsIFRXX1NFQ1RPUl9TSVpFKTsKKwlwYXJhbS0+dGFibGVfaWQgPSBjcHVfdG9fbGUx
Nih0YWJsZV9pZCB8IDB4ODAwMCk7CisJcGFyYW0tPnBhcmFtZXRlcl9pZCA9IGNwdV90b19sZTE2
KHBhcmFtZXRlcl9pZCk7CisJcGFyYW0tPnBhcmFtZXRlcl9zaXplX2J5dGVzID0gY3B1X3RvX2xl
MTYocGFyYW1ldGVyX3NpemVfYnl0ZXMpOworCisJY29tbWFuZF9wYWNrZXQtPmJ5dGU4X29mZnNl
dC5wYXJhbS5zZ2xbMF0uYWRkcmVzcyA9IFRXX0NQVV9UT19TR0wodHdfZGV2LT5nZW5lcmljX2J1
ZmZlcl9waHlzW3JlcXVlc3RfaWRdKTsKKwljb21tYW5kX3BhY2tldC0+Ynl0ZThfb2Zmc2V0LnBh
cmFtLnNnbFswXS5sZW5ndGggPSBUV19DUFVfVE9fU0dMKFRXX1NFQ1RPUl9TSVpFKTsKKworCS8q
IFBvc3QgdGhlIGNvbW1hbmQgcGFja2V0IHRvIHRoZSBib2FyZCAqLworCXR3bF9wb3N0X2NvbW1h
bmRfcGFja2V0KHR3X2RldiwgcmVxdWVzdF9pZCk7CisKKwkvKiBQb2xsIGZvciBjb21wbGV0aW9u
ICovCisJaWYgKHR3bF9wb2xsX3Jlc3BvbnNlKHR3X2RldiwgcmVxdWVzdF9pZCwgMzApKQorCQlU
V19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIsIDB4NywgIk5vIHZhbGlkIHJlc3BvbnNl
IGR1cmluZyBnZXQgcGFyYW0iKQorCWVsc2UKKwkJcmV0dmFsID0gKHZvaWQgKikmKHBhcmFtLT5k
YXRhWzBdKTsKKworCXR3X2Rldi0+cG9zdGVkX3JlcXVlc3RfY291bnQtLTsKKwl0d19kZXYtPnN0
YXRlW3JlcXVlc3RfaWRdID0gVFdfU19JTklUSUFMOworCisJcmV0dXJuIHJldHZhbDsKK30gLyog
RW5kIHR3bF9nZXRfcGFyYW0oKSAqLworCisvKiBUaGlzIGZ1bmN0aW9uIHdpbGwgc2VuZCBhbiBp
bml0Y29ubmVjdGlvbiBjb21tYW5kIHRvIGNvbnRyb2xsZXIgKi8KK3N0YXRpYyBpbnQgdHdsX2lu
aXRjb25uZWN0aW9uKFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldiwgaW50IG1lc3NhZ2VfY3Jl
ZGl0cywKKyAJCQkgICAgICB1MzIgc2V0X2ZlYXR1cmVzLCB1bnNpZ25lZCBzaG9ydCBjdXJyZW50
X2Z3X3NybCwgCisJCQkgICAgICB1bnNpZ25lZCBzaG9ydCBjdXJyZW50X2Z3X2FyY2hfaWQsIAor
CQkJICAgICAgdW5zaWduZWQgc2hvcnQgY3VycmVudF9md19icmFuY2gsIAorCQkJICAgICAgdW5z
aWduZWQgc2hvcnQgY3VycmVudF9md19idWlsZCwgCisJCQkgICAgICB1bnNpZ25lZCBzaG9ydCAq
Zndfb25fY3Rscl9zcmwsIAorCQkJICAgICAgdW5zaWduZWQgc2hvcnQgKmZ3X29uX2N0bHJfYXJj
aF9pZCwgCisJCQkgICAgICB1bnNpZ25lZCBzaG9ydCAqZndfb25fY3Rscl9icmFuY2gsIAorCQkJ
ICAgICAgdW5zaWduZWQgc2hvcnQgKmZ3X29uX2N0bHJfYnVpbGQsIAorCQkJICAgICAgdTMyICpp
bml0X2Nvbm5lY3RfcmVzdWx0KQoreworCVRXX0NvbW1hbmRfRnVsbCAqZnVsbF9jb21tYW5kX3Bh
Y2tldDsKKwlUV19Jbml0Y29ubmVjdCAqdHdfaW5pdGNvbm5lY3Q7CisJaW50IHJlcXVlc3RfaWQg
PSAwLCByZXR2YWwgPSAxOworCisJLyogSW5pdGlhbGl6ZSBJbml0Q29ubmVjdGlvbiBjb21tYW5k
IHBhY2tldCAqLworCWZ1bGxfY29tbWFuZF9wYWNrZXQgPSB0d19kZXYtPmNvbW1hbmRfcGFja2V0
X3ZpcnRbcmVxdWVzdF9pZF07CisJbWVtc2V0KGZ1bGxfY29tbWFuZF9wYWNrZXQsIDAsIHNpemVv
ZihUV19Db21tYW5kX0Z1bGwpKTsKKwlmdWxsX2NvbW1hbmRfcGFja2V0LT5oZWFkZXIuaGVhZGVy
X2Rlc2Muc2l6ZV9oZWFkZXIgPSAxMjg7CisJCisJdHdfaW5pdGNvbm5lY3QgPSAoVFdfSW5pdGNv
bm5lY3QgKikmZnVsbF9jb21tYW5kX3BhY2tldC0+Y29tbWFuZC5vbGRjb21tYW5kOworCXR3X2lu
aXRjb25uZWN0LT5vcGNvZGVfX3Jlc2VydmVkID0gVFdfT1BSRVNfSU4oMCwgVFdfT1BfSU5JVF9D
T05ORUNUSU9OKTsKKwl0d19pbml0Y29ubmVjdC0+cmVxdWVzdF9pZCA9IHJlcXVlc3RfaWQ7CisJ
dHdfaW5pdGNvbm5lY3QtPm1lc3NhZ2VfY3JlZGl0cyA9IGNwdV90b19sZTE2KG1lc3NhZ2VfY3Jl
ZGl0cyk7CisJdHdfaW5pdGNvbm5lY3QtPmZlYXR1cmVzID0gc2V0X2ZlYXR1cmVzOworCisJLyog
VHVybiBvbiA2NC1iaXQgc2dsIHN1cHBvcnQgaWYgd2UgbmVlZCB0byAqLworCXR3X2luaXRjb25u
ZWN0LT5mZWF0dXJlcyB8PSBzaXplb2YoZG1hX2FkZHJfdCkgPiA0ID8gMSA6IDA7CisKKwl0d19p
bml0Y29ubmVjdC0+ZmVhdHVyZXMgPSBjcHVfdG9fbGUzMih0d19pbml0Y29ubmVjdC0+ZmVhdHVy
ZXMpOworCisJaWYgKHNldF9mZWF0dXJlcyAmIFRXX0VYVEVOREVEX0lOSVRfQ09OTkVDVCkgewor
CQl0d19pbml0Y29ubmVjdC0+c2l6ZSA9IFRXX0lOSVRfQ09NTUFORF9QQUNLRVRfU0laRV9FWFRF
TkRFRDsKKwkJdHdfaW5pdGNvbm5lY3QtPmZ3X3NybCA9IGNwdV90b19sZTE2KGN1cnJlbnRfZndf
c3JsKTsKKwkJdHdfaW5pdGNvbm5lY3QtPmZ3X2FyY2hfaWQgPSBjcHVfdG9fbGUxNihjdXJyZW50
X2Z3X2FyY2hfaWQpOworCQl0d19pbml0Y29ubmVjdC0+ZndfYnJhbmNoID0gY3B1X3RvX2xlMTYo
Y3VycmVudF9md19icmFuY2gpOworCQl0d19pbml0Y29ubmVjdC0+ZndfYnVpbGQgPSBjcHVfdG9f
bGUxNihjdXJyZW50X2Z3X2J1aWxkKTsKKwl9IGVsc2UgCisJCXR3X2luaXRjb25uZWN0LT5zaXpl
ID0gVFdfSU5JVF9DT01NQU5EX1BBQ0tFVF9TSVpFOworCisJLyogU2VuZCBjb21tYW5kIHBhY2tl
dCB0byB0aGUgYm9hcmQgKi8KKwl0d2xfcG9zdF9jb21tYW5kX3BhY2tldCh0d19kZXYsIHJlcXVl
c3RfaWQpOworCisJLyogUG9sbCBmb3IgY29tcGxldGlvbiAqLworCWlmICh0d2xfcG9sbF9yZXNw
b25zZSh0d19kZXYsIHJlcXVlc3RfaWQsIDMwKSkgeworCQlUV19QUklOVEsodHdfZGV2LT5ob3N0
LCBUV19EUklWRVIsIDB4OCwgIk5vIHZhbGlkIHJlc3BvbnNlIGR1cmluZyBpbml0IGNvbm5lY3Rp
b24iKTsKKwl9IGVsc2UgeworCQlpZiAoc2V0X2ZlYXR1cmVzICYgVFdfRVhURU5ERURfSU5JVF9D
T05ORUNUKSB7CisJCQkqZndfb25fY3Rscl9zcmwgPSBsZTE2X3RvX2NwdSh0d19pbml0Y29ubmVj
dC0+Zndfc3JsKTsKKwkJCSpmd19vbl9jdGxyX2FyY2hfaWQgPSBsZTE2X3RvX2NwdSh0d19pbml0
Y29ubmVjdC0+ZndfYXJjaF9pZCk7CisJCQkqZndfb25fY3Rscl9icmFuY2ggPSBsZTE2X3RvX2Nw
dSh0d19pbml0Y29ubmVjdC0+ZndfYnJhbmNoKTsKKwkJCSpmd19vbl9jdGxyX2J1aWxkID0gbGUx
Nl90b19jcHUodHdfaW5pdGNvbm5lY3QtPmZ3X2J1aWxkKTsKKwkJCSppbml0X2Nvbm5lY3RfcmVz
dWx0ID0gbGUzMl90b19jcHUodHdfaW5pdGNvbm5lY3QtPnJlc3VsdCk7CisJCX0KKwkJcmV0dmFs
ID0gMDsKKwl9CisKKwl0d19kZXYtPnBvc3RlZF9yZXF1ZXN0X2NvdW50LS07CisJdHdfZGV2LT5z
dGF0ZVtyZXF1ZXN0X2lkXSA9IFRXX1NfSU5JVElBTDsKKworCXJldHVybiByZXR2YWw7Cit9IC8q
IEVuZCB0d2xfaW5pdGNvbm5lY3Rpb24oKSAqLworCisvKiBUaGlzIGZ1bmN0aW9uIHdpbGwgaW5p
dGlhbGl6ZSB0aGUgZmllbGRzIG9mIGEgZGV2aWNlIGV4dGVuc2lvbiAqLworc3RhdGljIGludCB0
d2xfaW5pdGlhbGl6ZV9kZXZpY2VfZXh0ZW5zaW9uKFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2Rl
dikKK3sKKwlpbnQgaSwgcmV0dmFsID0gMTsKKworCS8qIEluaXRpYWxpemUgY29tbWFuZCBwYWNr
ZXQgYnVmZmVycyAqLworCWlmICh0d2xfYWxsb2NhdGVfbWVtb3J5KHR3X2Rldiwgc2l6ZW9mKFRX
X0NvbW1hbmRfRnVsbCksIDApKSB7CisJCVRXX1BSSU5USyh0d19kZXYtPmhvc3QsIFRXX0RSSVZF
UiwgMHg5LCAiQ29tbWFuZCBwYWNrZXQgbWVtb3J5IGFsbG9jYXRpb24gZmFpbGVkIik7CisJCWdv
dG8gb3V0OworCX0KKworCS8qIEluaXRpYWxpemUgZ2VuZXJpYyBidWZmZXIgKi8KKwlpZiAodHds
X2FsbG9jYXRlX21lbW9yeSh0d19kZXYsIFRXX1NFQ1RPUl9TSVpFLCAxKSkgeworCQlUV19QUklO
VEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIsIDB4YSwgIkdlbmVyaWMgbWVtb3J5IGFsbG9jYXRp
b24gZmFpbGVkIik7CisJCWdvdG8gb3V0OworCX0KKworCS8qIEFsbG9jYXRlIHNlbnNlIGJ1ZmZl
cnMgKi8KKwlpZiAodHdsX2FsbG9jYXRlX21lbW9yeSh0d19kZXYsIHNpemVvZihUV19Db21tYW5k
X0FwYWNoZV9IZWFkZXIpLCAyKSkgeworCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklW
RVIsIDB4YiwgIlNlbnNlIGJ1ZmZlciBhbGxvY2F0aW9uIGZhaWxlZCIpOworCQlnb3RvIG91dDsK
Kwl9CisKKwkvKiBBbGxvY2F0ZSBldmVudCBpbmZvIHNwYWNlICovCisJdHdfZGV2LT5ldmVudF9x
dWV1ZVswXSA9IGtjYWxsb2MoVFdfUV9MRU5HVEgsIHNpemVvZihUV19FdmVudCksIEdGUF9LRVJO
RUwpOworCWlmICghdHdfZGV2LT5ldmVudF9xdWV1ZVswXSkgeworCQlUV19QUklOVEsodHdfZGV2
LT5ob3N0LCBUV19EUklWRVIsIDB4YywgIkV2ZW50IGluZm8gbWVtb3J5IGFsbG9jYXRpb24gZmFp
bGVkIik7CisJCWdvdG8gb3V0OworCX0KKworCWZvciAoaSA9IDA7IGkgPCBUV19RX0xFTkdUSDsg
aSsrKSB7CisJCXR3X2Rldi0+ZXZlbnRfcXVldWVbaV0gPSAoVFdfRXZlbnQgKikoKHVuc2lnbmVk
IGNoYXIgKil0d19kZXYtPmV2ZW50X3F1ZXVlWzBdICsgKGkgKiBzaXplb2YoVFdfRXZlbnQpKSk7
CisJCXR3X2Rldi0+ZnJlZV9xdWV1ZVtpXSA9IGk7CisJCXR3X2Rldi0+c3RhdGVbaV0gPSBUV19T
X0lOSVRJQUw7CisJfQorCisJdHdfZGV2LT5mcmVlX2hlYWQgPSBUV19RX1NUQVJUOworCXR3X2Rl
di0+ZnJlZV90YWlsID0gVFdfUV9TVEFSVDsKKwl0d19kZXYtPmVycm9yX3NlcXVlbmNlX2lkID0g
MTsKKwl0d19kZXYtPmNocmRldl9yZXF1ZXN0X2lkID0gVFdfSU9DVExfQ0hSREVWX0ZSRUU7CisK
KwltdXRleF9pbml0KCZ0d19kZXYtPmlvY3RsX2xvY2spOworCWluaXRfd2FpdHF1ZXVlX2hlYWQo
JnR3X2Rldi0+aW9jdGxfd3F1ZXVlKTsKKworCXJldHZhbCA9IDA7CitvdXQ6CisJcmV0dXJuIHJl
dHZhbDsKK30gLyogRW5kIHR3bF9pbml0aWFsaXplX2RldmljZV9leHRlbnNpb24oKSAqLworCisv
KiBUaGlzIGZ1bmN0aW9uIHdpbGwgcGVyZm9ybSBhIHBjaS1kbWEgdW5tYXAgKi8KK3N0YXRpYyB2
b2lkIHR3bF91bm1hcF9zY3NpX2RhdGEoVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2LCBpbnQg
cmVxdWVzdF9pZCkKK3sKKwlzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQgPSB0d19kZXYtPnNyYltyZXF1
ZXN0X2lkXTsKKworCWlmIChjbWQtPlNDcC5waGFzZSA9PSBUV19QSEFTRV9TR0xJU1QpCisJCXNj
c2lfZG1hX3VubWFwKGNtZCk7Cit9IC8qIEVuZCB0d2xfdW5tYXBfc2NzaV9kYXRhKCkgKi8KKwor
LyogVGhpcyBmdW5jdGlvbiB3aWxsIGhhbmRsZSBhdHRlbnRpb24gaW50ZXJydXB0cyAqLworc3Rh
dGljIGludCB0d2xfaGFuZGxlX2F0dGVudGlvbl9pbnRlcnJ1cHQoVFdfRGV2aWNlX0V4dGVuc2lv
biAqdHdfZGV2KQoreworCWludCByZXR2YWwgPSAxOworCXUzMiByZXF1ZXN0X2lkLCBkb29yYmVs
bDsKKworCS8qIFJlYWQgZG9vcmJlbGwgc3RhdHVzICovCisJZG9vcmJlbGwgPSByZWFkbChUV0xf
SE9CREJfUkVHX0FERFIodHdfZGV2KSk7CisKKwkvKiBDaGVjayBmb3IgY29udHJvbGxlciBlcnJv
cnMgKi8KKwlpZiAoZG9vcmJlbGwgJiBUV0xfRE9PUkJFTExfQ09OVFJPTExFUl9FUlJPUikgewor
CQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIsIDB4ZCwgIk1pY3JvY29udHJvbGxl
ciBFcnJvcjogY2xlYXJpbmciKTsKKwkJZ290byBvdXQ7CisJfQorCisJLyogQ2hlY2sgaWYgd2Ug
bmVlZCB0byBwZXJmb3JtIGFuIEFFTiBkcmFpbiAqLworCWlmIChkb29yYmVsbCAmIFRXTF9ET09S
QkVMTF9BVFRFTlRJT05fSU5URVJSVVBUKSB7CisJCWlmICghKHRlc3RfYW5kX3NldF9iaXQoVFdf
SU5fQVRURU5USU9OX0xPT1AsICZ0d19kZXYtPmZsYWdzKSkpIHsKKwkJCXR3bF9nZXRfcmVxdWVz
dF9pZCh0d19kZXYsICZyZXF1ZXN0X2lkKTsKKwkJCWlmICh0d2xfYWVuX3JlYWRfcXVldWUodHdf
ZGV2LCByZXF1ZXN0X2lkKSkgeworCQkJCXR3X2Rldi0+c3RhdGVbcmVxdWVzdF9pZF0gPSBUV19T
X0NPTVBMRVRFRDsKKwkJCQl0d2xfZnJlZV9yZXF1ZXN0X2lkKHR3X2RldiwgcmVxdWVzdF9pZCk7
CisJCQkJY2xlYXJfYml0KFRXX0lOX0FUVEVOVElPTl9MT09QLCAmdHdfZGV2LT5mbGFncyk7CisJ
CQl9CisJCX0KKwl9CisKKwlyZXR2YWwgPSAwOworb3V0OgorCS8qIENsZWFyIGRvb3JiZWxsIGlu
dGVycnVwdCAqLworCVRXTF9DTEVBUl9EQl9JTlRFUlJVUFQodHdfZGV2KTsKKworCS8qIE1ha2Ug
c3VyZSB0aGUgY2xlYXIgd2FzIGZsdXNoZWQgYnkgcmVhZGluZyBpdCBiYWNrICovCisJcmVhZGwo
VFdMX0hPQkRCQ19SRUdfQUREUih0d19kZXYpKTsKKworCXJldHVybiByZXR2YWw7Cit9IC8qIEVu
ZCB0d2xfaGFuZGxlX2F0dGVudGlvbl9pbnRlcnJ1cHQoKSAqLworCisvKiBJbnRlcnJ1cHQgc2Vy
dmljZSByb3V0aW5lICovCitzdGF0aWMgaXJxcmV0dXJuX3QgdHdsX2ludGVycnVwdChpbnQgaXJx
LCB2b2lkICpkZXZfaW5zdGFuY2UpCit7CisJVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2ID0g
KFRXX0RldmljZV9FeHRlbnNpb24gKilkZXZfaW5zdGFuY2U7CisJaW50IGksIGhhbmRsZWQgPSAw
LCBlcnJvciA9IDA7CisJZG1hX2FkZHJfdCBtZmEgPSAwOworCXUzMiByZWcsIHJlZ2wsIHJlZ2gs
IHJlc3BvbnNlLCByZXF1ZXN0X2lkID0gMDsKKwlzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQ7CisJVFdf
Q29tbWFuZF9GdWxsICpmdWxsX2NvbW1hbmRfcGFja2V0OworCisJc3Bpbl9sb2NrKHR3X2Rldi0+
aG9zdC0+aG9zdF9sb2NrKTsKKworCS8qIFJlYWQgaG9zdCBpbnRlcnJ1cHQgc3RhdHVzICovCisJ
cmVnID0gcmVhZGwoVFdMX0hJU1RBVF9SRUdfQUREUih0d19kZXYpKTsKKworCS8qIENoZWNrIGlm
IHRoaXMgaXMgb3VyIGludGVycnVwdCwgb3RoZXJ3aXNlIGJhaWwgKi8KKwlpZiAoIShyZWcgJiBU
V0xfSElTVEFUVVNfVkFMSURfSU5URVJSVVBUKSkKKwkJZ290byB0d2xfaW50ZXJydXB0X2JhaWw7
CisKKwloYW5kbGVkID0gMTsKKworCS8qIElmIHdlIGFyZSByZXNldHRpbmcsIGJhaWwgKi8KKwlp
ZiAodGVzdF9iaXQoVFdfSU5fUkVTRVQsICZ0d19kZXYtPmZsYWdzKSkKKwkJZ290byB0d2xfaW50
ZXJydXB0X2JhaWw7CisKKwkvKiBBdHRlbnRpb24gaW50ZXJydXB0ICovCisJaWYgKHJlZyAmIFRX
TF9ISVNUQVRVU19BVFRFTlRJT05fSU5URVJSVVBUKSB7CisJCWlmICh0d2xfaGFuZGxlX2F0dGVu
dGlvbl9pbnRlcnJ1cHQodHdfZGV2KSkgeworCQkJVFdMX01BU0tfSU5URVJSVVBUUyh0d19kZXYp
OworCQkJZ290byB0d2xfaW50ZXJydXB0X2JhaWw7CisJCX0KKwl9CisKKwkvKiBSZXNwb25zZSBp
bnRlcnJ1cHQgKi8KKwl3aGlsZSAocmVnICYgVFdMX0hJU1RBVFVTX1JFU1BPTlNFX0lOVEVSUlVQ
VCkgeworCQlpZiAoc2l6ZW9mKGRtYV9hZGRyX3QpID4gNCkgeworCQkJcmVnaCA9IHJlYWRsKFRX
TF9IT0JRUEhfUkVHX0FERFIodHdfZGV2KSk7CisJCQlyZWdsID0gcmVhZGwoVFdMX0hPQlFQTF9S
RUdfQUREUih0d19kZXYpKTsKKwkJCW1mYSA9ICgodTY0KXJlZ2ggPDwgMzIpIHwgcmVnbDsKKwkJ
fSBlbHNlCisJCQltZmEgPSByZWFkbChUV0xfSE9CUVBMX1JFR19BRERSKHR3X2RldikpOworCisJ
CWVycm9yID0gMDsKKwkJcmVzcG9uc2UgPSAodTMyKW1mYTsKKworCQkvKiBDaGVjayBmb3IgY29t
bWFuZCBwYWNrZXQgZXJyb3IgKi8KKwkJaWYgKCFUV19OT1RNRkFfT1VUKHJlc3BvbnNlKSkgewor
CQkJZm9yIChpPTA7aTxUV19RX0xFTkdUSDtpKyspIHsKKwkJCQlpZiAodHdfZGV2LT5zZW5zZV9i
dWZmZXJfcGh5c1tpXSA9PSBtZmEpIHsKKwkJCQkJcmVxdWVzdF9pZCA9IGxlMTZfdG9fY3B1KHR3
X2Rldi0+c2Vuc2VfYnVmZmVyX3ZpcnRbaV0tPmhlYWRlcl9kZXNjLnJlcXVlc3RfaWQpOworCQkJ
CQlpZiAodHdfZGV2LT5zcmJbcmVxdWVzdF9pZF0gIT0gTlVMTCkKKwkJCQkJCWVycm9yID0gdHds
X2ZpbGxfc2Vuc2UodHdfZGV2LCBpLCByZXF1ZXN0X2lkLCAxLCAxKTsKKwkJCQkJZWxzZSB7CisJ
CQkJCQkvKiBTa2lwIGlvY3RsIGVycm9yIHByaW50cyAqLworCQkJCQkJaWYgKHJlcXVlc3RfaWQg
IT0gdHdfZGV2LT5jaHJkZXZfcmVxdWVzdF9pZCkKKwkJCQkJCQllcnJvciA9IHR3bF9maWxsX3Nl
bnNlKHR3X2RldiwgaSwgcmVxdWVzdF9pZCwgMCwgMSk7CisJCQkJCQllbHNlCisJCQkJCQkJbWVt
Y3B5KHR3X2Rldi0+Y29tbWFuZF9wYWNrZXRfdmlydFtyZXF1ZXN0X2lkXSwgdHdfZGV2LT5zZW5z
ZV9idWZmZXJfdmlydFtpXSwgc2l6ZW9mKFRXX0NvbW1hbmRfQXBhY2hlX0hlYWRlcikpOworCQkJ
CQl9CisKKwkJCQkJLyogTm93IHJlLXBvc3QgdGhlIHNlbnNlIGJ1ZmZlciAqLworCQkJCQl3cml0
ZWwoKHUzMikoKHU2NCl0d19kZXYtPnNlbnNlX2J1ZmZlcl9waHlzW2ldID4+IDMyKSwgVFdMX0hP
QlFQSF9SRUdfQUREUih0d19kZXYpKTsKKwkJCQkJd3JpdGVsKCh1MzIpdHdfZGV2LT5zZW5zZV9i
dWZmZXJfcGh5c1tpXSwgVFdMX0hPQlFQTF9SRUdfQUREUih0d19kZXYpKTsKKwkJCQkJYnJlYWs7
CisJCQkJfQorCQkJfQorCQl9IGVsc2UKKwkJCXJlcXVlc3RfaWQgPSBUV19SRVNJRF9PVVQocmVz
cG9uc2UpOworCisJCWZ1bGxfY29tbWFuZF9wYWNrZXQgPSB0d19kZXYtPmNvbW1hbmRfcGFja2V0
X3ZpcnRbcmVxdWVzdF9pZF07CisKKwkJLyogQ2hlY2sgZm9yIGNvcnJlY3Qgc3RhdGUgKi8KKwkJ
aWYgKHR3X2Rldi0+c3RhdGVbcmVxdWVzdF9pZF0gIT0gVFdfU19QT1NURUQpIHsKKwkJCWlmICh0
d19kZXYtPnNyYltyZXF1ZXN0X2lkXSAhPSBOVUxMKSB7CisJCQkJVFdfUFJJTlRLKHR3X2Rldi0+
aG9zdCwgVFdfRFJJVkVSLCAweGUsICJSZWNlaXZlZCBhIHJlcXVlc3QgaWQgdGhhdCB3YXNuJ3Qg
cG9zdGVkIik7CisJCQkJVFdMX01BU0tfSU5URVJSVVBUUyh0d19kZXYpOworCQkJCWdvdG8gdHds
X2ludGVycnVwdF9iYWlsOworCQkJfQorCQl9CisKKwkJLyogQ2hlY2sgZm9yIGludGVybmFsIGNv
bW1hbmQgY29tcGxldGlvbiAqLworCQlpZiAodHdfZGV2LT5zcmJbcmVxdWVzdF9pZF0gPT0gTlVM
TCkgeworCQkJaWYgKHJlcXVlc3RfaWQgIT0gdHdfZGV2LT5jaHJkZXZfcmVxdWVzdF9pZCkgewor
CQkJCWlmICh0d2xfYWVuX2NvbXBsZXRlKHR3X2RldiwgcmVxdWVzdF9pZCkpCisJCQkJCVRXX1BS
SU5USyh0d19kZXYtPmhvc3QsIFRXX0RSSVZFUiwgMHhmLCAiRXJyb3IgY29tcGxldGluZyBBRU4g
ZHVyaW5nIGF0dGVudGlvbiBpbnRlcnJ1cHQiKTsKKwkJCX0gZWxzZSB7CisJCQkJdHdfZGV2LT5j
aHJkZXZfcmVxdWVzdF9pZCA9IFRXX0lPQ1RMX0NIUkRFVl9GUkVFOworCQkJCXdha2VfdXAoJnR3
X2Rldi0+aW9jdGxfd3F1ZXVlKTsKKwkJCX0KKwkJfSBlbHNlIHsKKwkJCWNtZCA9IHR3X2Rldi0+
c3JiW3JlcXVlc3RfaWRdOworCisJCQlpZiAoIWVycm9yKQorCQkJCWNtZC0+cmVzdWx0ID0gKERJ
RF9PSyA8PCAxNik7CisJCQkKKwkJCS8qIFJlcG9ydCByZXNpZHVhbCBieXRlcyBmb3Igc2luZ2xl
IHNnbCAqLworCQkJaWYgKChzY3NpX3NnX2NvdW50KGNtZCkgPD0gMSkgJiYgKGZ1bGxfY29tbWFu
ZF9wYWNrZXQtPmNvbW1hbmQubmV3Y29tbWFuZC5zdGF0dXMgPT0gMCkpIHsKKwkJCQlpZiAoZnVs
bF9jb21tYW5kX3BhY2tldC0+Y29tbWFuZC5uZXdjb21tYW5kLnNnX2xpc3RbMF0ubGVuZ3RoIDwg
c2NzaV9idWZmbGVuKHR3X2Rldi0+c3JiW3JlcXVlc3RfaWRdKSkKKwkJCQkJc2NzaV9zZXRfcmVz
aWQoY21kLCBzY3NpX2J1ZmZsZW4oY21kKSAtIGZ1bGxfY29tbWFuZF9wYWNrZXQtPmNvbW1hbmQu
bmV3Y29tbWFuZC5zZ19saXN0WzBdLmxlbmd0aCk7CisJCQl9CisKKwkJCS8qIE5vdyBjb21wbGV0
ZSB0aGUgaW8gKi8KKwkJCXR3X2Rldi0+c3RhdGVbcmVxdWVzdF9pZF0gPSBUV19TX0NPTVBMRVRF
RDsKKwkJCXR3bF9mcmVlX3JlcXVlc3RfaWQodHdfZGV2LCByZXF1ZXN0X2lkKTsKKwkJCXR3X2Rl
di0+cG9zdGVkX3JlcXVlc3RfY291bnQtLTsKKwkJCXR3X2Rldi0+c3JiW3JlcXVlc3RfaWRdLT5z
Y3NpX2RvbmUodHdfZGV2LT5zcmJbcmVxdWVzdF9pZF0pOworCQkJdHdsX3VubWFwX3Njc2lfZGF0
YSh0d19kZXYsIHJlcXVlc3RfaWQpOworCQl9CisKKwkJLyogQ2hlY2sgZm9yIGFub3RoZXIgcmVz
cG9uc2UgaW50ZXJydXB0ICovCisJCXJlZyA9IHJlYWRsKFRXTF9ISVNUQVRfUkVHX0FERFIodHdf
ZGV2KSk7CisJfQorCit0d2xfaW50ZXJydXB0X2JhaWw6CisJc3Bpbl91bmxvY2sodHdfZGV2LT5o
b3N0LT5ob3N0X2xvY2spOworCXJldHVybiBJUlFfUkVUVkFMKGhhbmRsZWQpOworfSAvKiBFbmQg
dHdsX2ludGVycnVwdCgpICovCisKKy8qIFRoaXMgZnVuY3Rpb24gd2lsbCBwb2xsIGZvciBhIHJl
Z2lzdGVyIGNoYW5nZSAqLworc3RhdGljIGludCB0d2xfcG9sbF9yZWdpc3RlcihUV19EZXZpY2Vf
RXh0ZW5zaW9uICp0d19kZXYsIHZvaWQgKnJlZywgdTMyIHZhbHVlLCB1MzIgcmVzdWx0LCBpbnQg
c2Vjb25kcykKK3sKKwl1bnNpZ25lZCBsb25nIGJlZm9yZTsKKwlpbnQgcmV0dmFsID0gMTsKKwl1
MzIgcmVnX3ZhbHVlOworCisJcmVnX3ZhbHVlID0gcmVhZGwocmVnKTsKKwliZWZvcmUgPSBqaWZm
aWVzOworCisgICAgICAgIHdoaWxlICgocmVnX3ZhbHVlICYgdmFsdWUpICE9IHJlc3VsdCkgewor
CQlyZWdfdmFsdWUgPSByZWFkbChyZWcpOworCQlpZiAodGltZV9hZnRlcihqaWZmaWVzLCBiZWZv
cmUgKyBIWiAqIHNlY29uZHMpKQorCQkJZ290byBvdXQ7CisJCW1zbGVlcCg1MCk7CisJfQorCXJl
dHZhbCA9IDA7CitvdXQ6CisJcmV0dXJuIHJldHZhbDsKK30gLyogRW5kIHR3bF9wb2xsX3JlZ2lz
dGVyKCkgKi8KKworLyogVGhpcyBmdW5jdGlvbiB3aWxsIHJlc2V0IGEgY29udHJvbGxlciAqLwor
c3RhdGljIGludCB0d2xfcmVzZXRfc2VxdWVuY2UoVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2
LCBpbnQgc29mdF9yZXNldCkKK3sKKwlpbnQgcmV0dmFsID0gMTsKKwlpbnQgaSA9IDA7CisJdTMy
IHN0YXR1cyA9IDA7CisJdW5zaWduZWQgc2hvcnQgZndfb25fY3Rscl9zcmwgPSAwLCBmd19vbl9j
dGxyX2FyY2hfaWQgPSAwOworCXVuc2lnbmVkIHNob3J0IGZ3X29uX2N0bHJfYnJhbmNoID0gMCwg
Zndfb25fY3Rscl9idWlsZCA9IDA7CisJdTMyIGluaXRfY29ubmVjdF9yZXN1bHQgPSAwOworCWlu
dCB0cmllcyA9IDA7CisJaW50IGRvX3NvZnRfcmVzZXQgPSBzb2Z0X3Jlc2V0OworCisJd2hpbGUg
KHRyaWVzIDwgVFdfTUFYX1JFU0VUX1RSSUVTKSB7CisJCS8qIERvIGEgc29mdCByZXNldCBpZiBv
bmUgaXMgbmVlZGVkICovCisJCWlmIChkb19zb2Z0X3Jlc2V0KSB7CisJCQlUV0xfU09GVF9SRVNF
VCh0d19kZXYpOworCisJCQkvKiBNYWtlIHN1cmUgY29udHJvbGxlciBpcyBpbiBhIGdvb2Qgc3Rh
dGUgKi8KKwkJCWlmICh0d2xfcG9sbF9yZWdpc3Rlcih0d19kZXYsIFRXTF9TQ1JQRDNfUkVHX0FE
RFIodHdfZGV2KSwgVFdMX0NPTlRST0xMRVJfUkVBRFksIDB4MCwgMzApKSB7CisJCQkJVFdfUFJJ
TlRLKHR3X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAweDEwLCAiQ29udHJvbGxlciBuZXZlciB3ZW50
IG5vbi1yZWFkeSBkdXJpbmcgcmVzZXQgc2VxdWVuY2UiKTsKKwkJCQl0cmllcysrOworCQkJCWNv
bnRpbnVlOworCQkJfQorCQkJaWYgKHR3bF9wb2xsX3JlZ2lzdGVyKHR3X2RldiwgVFdMX1NDUlBE
M19SRUdfQUREUih0d19kZXYpLCBUV0xfQ09OVFJPTExFUl9SRUFEWSwgVFdMX0NPTlRST0xMRVJf
UkVBRFksIDYwKSkgeworCQkJCVRXX1BSSU5USyh0d19kZXYtPmhvc3QsIFRXX0RSSVZFUiwgMHgx
MSwgIkNvbnRyb2xsZXIgbm90IHJlYWR5IGR1cmluZyByZXNldCBzZXF1ZW5jZSIpOworCQkJCXRy
aWVzKys7CisJCQkJY29udGludWU7CisJCQl9CisJCX0KKworCQkvKiBJbml0Y29ubmVjdCAqLwor
CQlpZiAodHdsX2luaXRjb25uZWN0aW9uKHR3X2RldiwgVFdfSU5JVF9NRVNTQUdFX0NSRURJVFMs
CisJCQkJICAgICAgIFRXX0VYVEVOREVEX0lOSVRfQ09OTkVDVCwgVFdfQ1VSUkVOVF9EUklWRVJf
U1JMLAorCQkJCSAgICAgICBUV185NzUwX0FSQ0hfSUQsIFRXX0NVUlJFTlRfRFJJVkVSX0JSQU5D
SCwKKwkJCQkgICAgICAgVFdfQ1VSUkVOVF9EUklWRVJfQlVJTEQsICZmd19vbl9jdGxyX3NybCwK
KwkJCQkgICAgICAgJmZ3X29uX2N0bHJfYXJjaF9pZCwgJmZ3X29uX2N0bHJfYnJhbmNoLAorCQkJ
CSAgICAgICAmZndfb25fY3Rscl9idWlsZCwgJmluaXRfY29ubmVjdF9yZXN1bHQpKSB7CisJCQlU
V19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIsIDB4MTIsICJJbml0Y29ubmVjdGlvbiBm
YWlsZWQgd2hpbGUgY2hlY2tpbmcgU1JMIik7CisJCQlkb19zb2Z0X3Jlc2V0ID0gMTsKKwkJCXRy
aWVzKys7CisJCQljb250aW51ZTsKKwkJfQorCisJCS8qIExvYWQgc2Vuc2UgYnVmZmVycyAqLwor
CQl3aGlsZSAoaSA8IFRXX1FfTEVOR1RIKSB7CisJCQl3cml0ZWwoKHUzMikoKHU2NCl0d19kZXYt
PnNlbnNlX2J1ZmZlcl9waHlzW2ldID4+IDMyKSwgVFdMX0hPQlFQSF9SRUdfQUREUih0d19kZXYp
KTsKKwkJCXdyaXRlbCgodTMyKXR3X2Rldi0+c2Vuc2VfYnVmZmVyX3BoeXNbaV0sIFRXTF9IT0JR
UExfUkVHX0FERFIodHdfZGV2KSk7CisKKwkJCS8qIENoZWNrIHN0YXR1cyBmb3Igb3Zlci1ydW4g
YWZ0ZXIgZWFjaCB3cml0ZSAqLworCQkJc3RhdHVzID0gcmVhZGwoVFdMX1NUQVRVU19SRUdfQURE
Uih0d19kZXYpKTsKKwkJCWlmICghKHN0YXR1cyAmIFRXTF9TVEFUVVNfT1ZFUlJVTl9TVUJNSVQp
KQorCQkJICAgIGkrKzsKKwkJfQorCisJCS8qIE5vdyBjaGVjayBzdGF0dXMgKi8KKwkJc3RhdHVz
ID0gcmVhZGwoVFdMX1NUQVRVU19SRUdfQUREUih0d19kZXYpKTsKKwkJaWYgKHN0YXR1cykgewor
CQkJVFdfUFJJTlRLKHR3X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAweDEzLCAiQmFkIGNvbnRyb2xs
ZXIgc3RhdHVzIGFmdGVyIGxvYWRpbmcgc2Vuc2UgYnVmZmVycyIpOworCQkJZG9fc29mdF9yZXNl
dCA9IDE7CisJCQl0cmllcysrOworCQkJY29udGludWU7CisJCX0KKworCQkvKiBEcmFpbiB0aGUg
QUVOIHF1ZXVlICovCisJCWlmICh0d2xfYWVuX2RyYWluX3F1ZXVlKHR3X2Rldiwgc29mdF9yZXNl
dCkpIHsKKwkJCVRXX1BSSU5USyh0d19kZXYtPmhvc3QsIFRXX0RSSVZFUiwgMHgxNCwgIkFFTiBk
cmFpbiBmYWlsZWQgZHVyaW5nIHJlc2V0IHNlcXVlbmNlIik7CisJCQlkb19zb2Z0X3Jlc2V0ID0g
MTsKKwkJCXRyaWVzKys7CisJCQljb250aW51ZTsKKwkJfQorCisJCS8qIExvYWQgcmVzdCBvZiBj
b21wYXRpYmlsaXR5IHN0cnVjdCAqLworCQlzdHJuY3B5KHR3X2Rldi0+dHdfY29tcGF0X2luZm8u
ZHJpdmVyX3ZlcnNpb24sIFRXX0RSSVZFUl9WRVJTSU9OLCBzdHJsZW4oVFdfRFJJVkVSX1ZFUlNJ
T04pKTsKKwkJdHdfZGV2LT50d19jb21wYXRfaW5mby5kcml2ZXJfc3JsX2hpZ2ggPSBUV19DVVJS
RU5UX0RSSVZFUl9TUkw7CisJCXR3X2Rldi0+dHdfY29tcGF0X2luZm8uZHJpdmVyX2JyYW5jaF9o
aWdoID0gVFdfQ1VSUkVOVF9EUklWRVJfQlJBTkNIOworCQl0d19kZXYtPnR3X2NvbXBhdF9pbmZv
LmRyaXZlcl9idWlsZF9oaWdoID0gVFdfQ1VSUkVOVF9EUklWRVJfQlVJTEQ7CisJCXR3X2Rldi0+
dHdfY29tcGF0X2luZm8uZHJpdmVyX3NybF9sb3cgPSBUV19CQVNFX0ZXX1NSTDsKKwkJdHdfZGV2
LT50d19jb21wYXRfaW5mby5kcml2ZXJfYnJhbmNoX2xvdyA9IFRXX0JBU0VfRldfQlJBTkNIOwor
CQl0d19kZXYtPnR3X2NvbXBhdF9pbmZvLmRyaXZlcl9idWlsZF9sb3cgPSBUV19CQVNFX0ZXX0JV
SUxEOworCQl0d19kZXYtPnR3X2NvbXBhdF9pbmZvLmZ3X29uX2N0bHJfc3JsID0gZndfb25fY3Rs
cl9zcmw7CisJCXR3X2Rldi0+dHdfY29tcGF0X2luZm8uZndfb25fY3Rscl9icmFuY2ggPSBmd19v
bl9jdGxyX2JyYW5jaDsKKwkJdHdfZGV2LT50d19jb21wYXRfaW5mby5md19vbl9jdGxyX2J1aWxk
ID0gZndfb25fY3Rscl9idWlsZDsKKworCQkvKiBJZiB3ZSBnb3QgaGVyZSwgY29udHJvbGxlciBp
cyBpbiBhIGdvb2Qgc3RhdGUgKi8KKwkJcmV0dmFsID0gMDsKKwkJZ290byBvdXQ7CisJfQorb3V0
OgorCXJldHVybiByZXR2YWw7Cit9IC8qIEVuZCB0d2xfcmVzZXRfc2VxdWVuY2UoKSAqLworCisv
KiBUaGlzIGZ1bmN0aW9uIHdpbGwgcmVzZXQgYSBkZXZpY2UgZXh0ZW5zaW9uICovCitzdGF0aWMg
aW50IHR3bF9yZXNldF9kZXZpY2VfZXh0ZW5zaW9uKFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2Rl
diwgaW50IGlvY3RsX3Jlc2V0KQoreworCWludCBpID0gMCwgcmV0dmFsID0gMTsKKwl1bnNpZ25l
ZCBsb25nIGZsYWdzID0gMDsKKworCS8qIEJsb2NrIFNDU0kgcmVxdWVzdHMgd2hpbGUgd2UgYXJl
IHJlc2V0dGluZyAqLworCWlmIChpb2N0bF9yZXNldCkKKwkJc2NzaV9ibG9ja19yZXF1ZXN0cyh0
d19kZXYtPmhvc3QpOworCisJc2V0X2JpdChUV19JTl9SRVNFVCwgJnR3X2Rldi0+ZmxhZ3MpOwor
CVRXTF9NQVNLX0lOVEVSUlVQVFModHdfZGV2KTsKKwlUV0xfQ0xFQVJfREJfSU5URVJSVVBUKHR3
X2Rldik7CisKKwlzcGluX2xvY2tfaXJxc2F2ZSh0d19kZXYtPmhvc3QtPmhvc3RfbG9jaywgZmxh
Z3MpOworCisJLyogQWJvcnQgYWxsIHJlcXVlc3RzIHRoYXQgYXJlIGluIHByb2dyZXNzICovCisJ
Zm9yIChpID0gMDsgaSA8IFRXX1FfTEVOR1RIOyBpKyspIHsKKwkJaWYgKCh0d19kZXYtPnN0YXRl
W2ldICE9IFRXX1NfRklOSVNIRUQpICYmCisJCSAgICAodHdfZGV2LT5zdGF0ZVtpXSAhPSBUV19T
X0lOSVRJQUwpICYmCisJCSAgICAodHdfZGV2LT5zdGF0ZVtpXSAhPSBUV19TX0NPTVBMRVRFRCkp
IHsKKwkJCWlmICh0d19kZXYtPnNyYltpXSkgeworCQkJCXR3X2Rldi0+c3JiW2ldLT5yZXN1bHQg
PSAoRElEX1JFU0VUIDw8IDE2KTsKKwkJCQl0d19kZXYtPnNyYltpXS0+c2NzaV9kb25lKHR3X2Rl
di0+c3JiW2ldKTsKKwkJCQl0d2xfdW5tYXBfc2NzaV9kYXRhKHR3X2RldiwgaSk7CisJCQl9CisJ
CX0KKwl9CisKKwkvKiBSZXNldCBxdWV1ZXMgYW5kIGNvdW50cyAqLworCWZvciAoaSA9IDA7IGkg
PCBUV19RX0xFTkdUSDsgaSsrKSB7CisJCXR3X2Rldi0+ZnJlZV9xdWV1ZVtpXSA9IGk7CisJCXR3
X2Rldi0+c3RhdGVbaV0gPSBUV19TX0lOSVRJQUw7CisJfQorCXR3X2Rldi0+ZnJlZV9oZWFkID0g
VFdfUV9TVEFSVDsKKwl0d19kZXYtPmZyZWVfdGFpbCA9IFRXX1FfU1RBUlQ7CisJdHdfZGV2LT5w
b3N0ZWRfcmVxdWVzdF9jb3VudCA9IDA7CisKKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKHR3X2Rl
di0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7CisKKwlpZiAodHdsX3Jlc2V0X3NlcXVlbmNlKHR3
X2RldiwgMSkpCisJCWdvdG8gb3V0OworCisJVFdMX1VOTUFTS19JTlRFUlJVUFRTKHR3X2Rldik7
CisKKwljbGVhcl9iaXQoVFdfSU5fUkVTRVQsICZ0d19kZXYtPmZsYWdzKTsKKwl0d19kZXYtPmNo
cmRldl9yZXF1ZXN0X2lkID0gVFdfSU9DVExfQ0hSREVWX0ZSRUU7CisKKwlyZXR2YWwgPSAwOwor
b3V0OgorCWlmIChpb2N0bF9yZXNldCkKKwkJc2NzaV91bmJsb2NrX3JlcXVlc3RzKHR3X2Rldi0+
aG9zdCk7CisJcmV0dXJuIHJldHZhbDsKK30gLyogRW5kIHR3bF9yZXNldF9kZXZpY2VfZXh0ZW5z
aW9uKCkgKi8KKworLyogVGhpcyBmdW5jaXRvbiByZXR1cm5zIHVuaXQgZ2VvbWV0cnkgaW4gY3ls
aW5kZXJzL2hlYWRzL3NlY3RvcnMgKi8KK3N0YXRpYyBpbnQgdHdsX3Njc2lfYmlvc3BhcmFtKHN0
cnVjdCBzY3NpX2RldmljZSAqc2Rldiwgc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgc2VjdG9y
X3QgY2FwYWNpdHksIGludCBnZW9tW10pCit7CisJaW50IGhlYWRzLCBzZWN0b3JzOworCVRXX0Rl
dmljZV9FeHRlbnNpb24gKnR3X2RldjsKKworCXR3X2RldiA9IChUV19EZXZpY2VfRXh0ZW5zaW9u
ICopc2Rldi0+aG9zdC0+aG9zdGRhdGE7CisKKwlpZiAoY2FwYWNpdHkgPj0gMHgyMDAwMDApIHsK
KwkJaGVhZHMgPSAyNTU7CisJCXNlY3RvcnMgPSA2MzsKKwl9IGVsc2UgeworCQloZWFkcyA9IDY0
OworCQlzZWN0b3JzID0gMzI7CisJfQorCisJZ2VvbVswXSA9IGhlYWRzOworCWdlb21bMV0gPSBz
ZWN0b3JzOworCWdlb21bMl0gPSBzZWN0b3JfZGl2KGNhcGFjaXR5LCBoZWFkcyAqIHNlY3RvcnMp
OyAvKiBjeWxpbmRlcnMgKi8KKworCXJldHVybiAwOworfSAvKiBFbmQgdHdsX3Njc2lfYmlvc3Bh
cmFtKCkgKi8KKworLyogVGhpcyBpcyB0aGUgbmV3IHNjc2kgZWggcmVzZXQgZnVuY3Rpb24gKi8K
K3N0YXRpYyBpbnQgdHdsX3Njc2lfZWhfcmVzZXQoc3RydWN0IHNjc2lfY21uZCAqU0NwbnQpCit7
CisJVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2ID0gTlVMTDsKKwlpbnQgcmV0dmFsID0gRkFJ
TEVEOworCisJdHdfZGV2ID0gKFRXX0RldmljZV9FeHRlbnNpb24gKilTQ3BudC0+ZGV2aWNlLT5o
b3N0LT5ob3N0ZGF0YTsKKworCXR3X2Rldi0+bnVtX3Jlc2V0cysrOworCisJc2Rldl9wcmludGso
S0VSTl9XQVJOSU5HLCBTQ3BudC0+ZGV2aWNlLAorCQkiV0FSTklORzogKDB4JTAyWDoweCUwNFgp
OiBDb21tYW5kICgweCV4KSB0aW1lZCBvdXQsIHJlc2V0dGluZyBjYXJkLlxuIiwKKwkJVFdfRFJJ
VkVSLCAweDJjLCBTQ3BudC0+Y21uZFswXSk7CisKKwkvKiBNYWtlIHN1cmUgd2UgYXJlIG5vdCBp
c3N1aW5nIGFuIGlvY3RsIG9yIHJlc2V0dGluZyBmcm9tIGlvY3RsICovCisJbXV0ZXhfbG9jaygm
dHdfZGV2LT5pb2N0bF9sb2NrKTsKKworCS8qIE5vdyByZXNldCB0aGUgY2FyZCBhbmQgc29tZSBv
ZiB0aGUgZGV2aWNlIGV4dGVuc2lvbiBkYXRhICovCisJaWYgKHR3bF9yZXNldF9kZXZpY2VfZXh0
ZW5zaW9uKHR3X2RldiwgMCkpIHsKKwkJVFdfUFJJTlRLKHR3X2Rldi0+aG9zdCwgVFdfRFJJVkVS
LCAweDE1LCAiQ29udHJvbGxlciByZXNldCBmYWlsZWQgZHVyaW5nIHNjc2kgaG9zdCByZXNldCIp
OworCQlnb3RvIG91dDsKKwl9CisKKwlyZXR2YWwgPSBTVUNDRVNTOworb3V0OgorCW11dGV4X3Vu
bG9jaygmdHdfZGV2LT5pb2N0bF9sb2NrKTsKKwlyZXR1cm4gcmV0dmFsOworfSAvKiBFbmQgdHds
X3Njc2lfZWhfcmVzZXQoKSAqLworCisvKiBUaGlzIGlzIHRoZSBtYWluIHNjc2kgcXVldWUgZnVu
Y3Rpb24gdG8gaGFuZGxlIHNjc2kgb3Bjb2RlcyAqLworc3RhdGljIGludCB0d2xfc2NzaV9xdWV1
ZShzdHJ1Y3Qgc2NzaV9jbW5kICpTQ3BudCwgdm9pZCAoKmRvbmUpKHN0cnVjdCBzY3NpX2NtbmQg
KikpCit7CisJaW50IHJlcXVlc3RfaWQsIHJldHZhbDsKKwlUV19EZXZpY2VfRXh0ZW5zaW9uICp0
d19kZXYgPSAoVFdfRGV2aWNlX0V4dGVuc2lvbiAqKVNDcG50LT5kZXZpY2UtPmhvc3QtPmhvc3Rk
YXRhOworCisJLyogSWYgd2UgYXJlIHJlc2V0dGluZyBkdWUgdG8gdGltZWQgb3V0IGlvY3RsLCBy
ZXBvcnQgYXMgYnVzeSAqLworCWlmICh0ZXN0X2JpdChUV19JTl9SRVNFVCwgJnR3X2Rldi0+Zmxh
Z3MpKSB7CisJCXJldHZhbCA9IFNDU0lfTUxRVUVVRV9IT1NUX0JVU1k7CisJCWdvdG8gb3V0Owor
CX0KKworCS8qIFNhdmUgZG9uZSBmdW5jdGlvbiBpbnRvIHNjc2lfY21uZCBzdHJ1Y3QgKi8KKwlT
Q3BudC0+c2NzaV9kb25lID0gZG9uZTsKKwkJCisJLyogR2V0IGEgZnJlZSByZXF1ZXN0IGlkICov
CisJdHdsX2dldF9yZXF1ZXN0X2lkKHR3X2RldiwgJnJlcXVlc3RfaWQpOworCisJLyogU2F2ZSB0
aGUgc2NzaSBjb21tYW5kIGZvciB1c2UgYnkgdGhlIElTUiAqLworCXR3X2Rldi0+c3JiW3JlcXVl
c3RfaWRdID0gU0NwbnQ7CisKKwkvKiBJbml0aWFsaXplIHBoYXNlIHRvIHplcm8gKi8KKwlTQ3Bu
dC0+U0NwLnBoYXNlID0gVFdfUEhBU0VfSU5JVElBTDsKKworCXJldHZhbCA9IHR3bF9zY3Npb3Bf
ZXhlY3V0ZV9zY3NpKHR3X2RldiwgcmVxdWVzdF9pZCwgTlVMTCwgMCwgTlVMTCk7CisJaWYgKHJl
dHZhbCkgeworCQl0d19kZXYtPnN0YXRlW3JlcXVlc3RfaWRdID0gVFdfU19DT01QTEVURUQ7CisJ
CXR3bF9mcmVlX3JlcXVlc3RfaWQodHdfZGV2LCByZXF1ZXN0X2lkKTsKKwkJU0NwbnQtPnJlc3Vs
dCA9IChESURfRVJST1IgPDwgMTYpOworCQlkb25lKFNDcG50KTsKKwkJcmV0dmFsID0gMDsKKwl9
CitvdXQ6CisJcmV0dXJuIHJldHZhbDsKK30gLyogRW5kIHR3bF9zY3NpX3F1ZXVlKCkgKi8KKwor
LyogVGhpcyBmdW5jdGlvbiB0ZWxscyB0aGUgY29udHJvbGxlciB0byBzaHV0IGRvd24gKi8KK3N0
YXRpYyB2b2lkIF9fdHdsX3NodXRkb3duKFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldikKK3sK
KwkvKiBEaXNhYmxlIGludGVycnVwdHMgKi8KKwlUV0xfTUFTS19JTlRFUlJVUFRTKHR3X2Rldik7
CisKKwkvKiBGcmVlIHVwIHRoZSBJUlEgKi8KKwlmcmVlX2lycSh0d19kZXYtPnR3X3BjaV9kZXYt
PmlycSwgdHdfZGV2KTsKKworCXByaW50ayhLRVJOX1dBUk5JTkcgIjN3LXNhczogU2h1dHRpbmcg
ZG93biBob3N0ICVkLlxuIiwgdHdfZGV2LT5ob3N0LT5ob3N0X25vKTsKKworCS8qIFRlbGwgdGhl
IGNhcmQgd2UgYXJlIHNodXR0aW5nIGRvd24gKi8KKwlpZiAodHdsX2luaXRjb25uZWN0aW9uKHR3
X2RldiwgMSwgMCwgMCwgMCwgMCwgMCwgTlVMTCwgTlVMTCwgTlVMTCwgTlVMTCwgTlVMTCkpIHsK
KwkJVFdfUFJJTlRLKHR3X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAweDE2LCAiQ29ubmVjdGlvbiBz
aHV0ZG93biBmYWlsZWQiKTsKKwl9IGVsc2UgeworCQlwcmludGsoS0VSTl9XQVJOSU5HICIzdy1z
YXM6IFNodXRkb3duIGNvbXBsZXRlLlxuIik7CisJfQorCisJLyogQ2xlYXIgZG9vcmJlbGwgaW50
ZXJydXB0IGp1c3QgYmVmb3JlIGV4aXQgKi8KKwlUV0xfQ0xFQVJfREJfSU5URVJSVVBUKHR3X2Rl
dik7Cit9IC8qIEVuZCBfX3R3bF9zaHV0ZG93bigpICovCisKKy8qIFdyYXBwZXIgZm9yIF9fdHds
X3NodXRkb3duICovCitzdGF0aWMgdm9pZCB0d2xfc2h1dGRvd24oc3RydWN0IHBjaV9kZXYgKnBk
ZXYpCit7CisJc3RydWN0IFNjc2lfSG9zdCAqaG9zdCA9IHBjaV9nZXRfZHJ2ZGF0YShwZGV2KTsK
KwlUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXY7CisKKwlpZiAoIWhvc3QpCisJCXJldHVybjsK
KworCXR3X2RldiA9IChUV19EZXZpY2VfRXh0ZW5zaW9uICopaG9zdC0+aG9zdGRhdGE7CisKKwlp
ZiAodHdfZGV2LT5vbmxpbmUpIAorCQlfX3R3bF9zaHV0ZG93bih0d19kZXYpOworfSAvKiBFbmQg
dHdsX3NodXRkb3duKCkgKi8KKworLyogVGhpcyBmdW5jdGlvbiBjb25maWd1cmVzIHVuaXQgc2V0
dGluZ3Mgd2hlbiBhIHVuaXQgaXMgY29taW5nIG9uLWxpbmUgKi8KK3N0YXRpYyBpbnQgdHdsX3Ns
YXZlX2NvbmZpZ3VyZShzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYpCit7CisJLyogRm9yY2UgNjAg
c2Vjb25kIHRpbWVvdXQgKi8KKwlibGtfcXVldWVfcnFfdGltZW91dChzZGV2LT5yZXF1ZXN0X3F1
ZXVlLCA2MCAqIEhaKTsKKworCXJldHVybiAwOworfSAvKiBFbmQgdHdsX3NsYXZlX2NvbmZpZ3Vy
ZSgpICovCisKKy8qIHNjc2lfaG9zdF90ZW1wbGF0ZSBpbml0aWFsaXplciAqLworc3RhdGljIHN0
cnVjdCBzY3NpX2hvc3RfdGVtcGxhdGUgZHJpdmVyX3RlbXBsYXRlID0geworCS5tb2R1bGUJCQk9
IFRISVNfTU9EVUxFLAorCS5uYW1lCQkJPSAiM3ctc2FzIiwKKwkucXVldWVjb21tYW5kCQk9IHR3
bF9zY3NpX3F1ZXVlLAorCS5laF9ob3N0X3Jlc2V0X2hhbmRsZXIJPSB0d2xfc2NzaV9laF9yZXNl
dCwKKwkuYmlvc19wYXJhbQkJPSB0d2xfc2NzaV9iaW9zcGFyYW0sCisJLmNoYW5nZV9xdWV1ZV9k
ZXB0aAk9IHR3bF9jaGFuZ2VfcXVldWVfZGVwdGgsCisJLmNhbl9xdWV1ZQkJPSBUV19RX0xFTkdU
SC0yLAorCS5zbGF2ZV9jb25maWd1cmUJPSB0d2xfc2xhdmVfY29uZmlndXJlLAorCS50aGlzX2lk
CQk9IC0xLAorCS5zZ190YWJsZXNpemUJCT0gVFdfTElCRVJBVE9SX01BWF9TR0xfTEVOR1RILAor
CS5tYXhfc2VjdG9ycwkJPSBUV19NQVhfU0VDVE9SUywKKwkuY21kX3Blcl9sdW4JCT0gVFdfTUFY
X0NNRFNfUEVSX0xVTiwKKwkudXNlX2NsdXN0ZXJpbmcJCT0gRU5BQkxFX0NMVVNURVJJTkcsCisJ
LnNob3N0X2F0dHJzCQk9IHR3bF9ob3N0X2F0dHJzLAorCS5lbXVsYXRlZAkJPSAxCit9OworCisv
KiBUaGlzIGZ1bmN0aW9uIHdpbGwgcHJvYmUgYW5kIGluaXRpYWxpemUgYSBjYXJkICovCitzdGF0
aWMgaW50IF9fZGV2aW5pdCB0d2xfcHJvYmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGNvbnN0IHN0
cnVjdCBwY2lfZGV2aWNlX2lkICpkZXZfaWQpCit7CisJc3RydWN0IFNjc2lfSG9zdCAqaG9zdCA9
IE5VTEw7CisJVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2OworCWludCByZXR2YWwgPSAtRU5P
REVWOworCWludCAqcHRyX3BoeWNvdW50LCBwaHljb3VudD0wOworCisJcmV0dmFsID0gcGNpX2Vu
YWJsZV9kZXZpY2UocGRldik7CisJaWYgKHJldHZhbCkgeworCQlUV19QUklOVEsoaG9zdCwgVFdf
RFJJVkVSLCAweDE3LCAiRmFpbGVkIHRvIGVuYWJsZSBwY2kgZGV2aWNlIik7CisJCWdvdG8gb3V0
X2Rpc2FibGVfZGV2aWNlOworCX0KKworCXBjaV9zZXRfbWFzdGVyKHBkZXYpOworCXBjaV90cnlf
c2V0X213aShwZGV2KTsKKworCWlmIChwY2lfc2V0X2RtYV9tYXNrKHBkZXYsIERNQV9CSVRfTUFT
Syg2NCkpCisJICAgIHx8IHBjaV9zZXRfY29uc2lzdGVudF9kbWFfbWFzayhwZGV2LCBETUFfQklU
X01BU0soNjQpKSkKKwkJaWYgKHBjaV9zZXRfZG1hX21hc2socGRldiwgRE1BX0JJVF9NQVNLKDMy
KSkKKwkJICAgIHx8IHBjaV9zZXRfY29uc2lzdGVudF9kbWFfbWFzayhwZGV2LCBETUFfQklUX01B
U0soMzIpKSkgeworCQkJVFdfUFJJTlRLKGhvc3QsIFRXX0RSSVZFUiwgMHgxOCwgIkZhaWxlZCB0
byBzZXQgZG1hIG1hc2siKTsKKwkJCXJldHZhbCA9IC1FTk9ERVY7CisJCQlnb3RvIG91dF9kaXNh
YmxlX2RldmljZTsKKwkJfQorCisJaG9zdCA9IHNjc2lfaG9zdF9hbGxvYygmZHJpdmVyX3RlbXBs
YXRlLCBzaXplb2YoVFdfRGV2aWNlX0V4dGVuc2lvbikpOworCWlmICghaG9zdCkgeworCQlUV19Q
UklOVEsoaG9zdCwgVFdfRFJJVkVSLCAweDE5LCAiRmFpbGVkIHRvIGFsbG9jYXRlIG1lbW9yeSBm
b3IgZGV2aWNlIGV4dGVuc2lvbiIpOworCQlyZXR2YWwgPSAtRU5PTUVNOworCQlnb3RvIG91dF9k
aXNhYmxlX2RldmljZTsKKwl9CisJdHdfZGV2ID0gc2hvc3RfcHJpdihob3N0KTsKKworCS8qIFNh
dmUgdmFsdWVzIHRvIGRldmljZSBleHRlbnNpb24gKi8KKwl0d19kZXYtPmhvc3QgPSBob3N0Owor
CXR3X2Rldi0+dHdfcGNpX2RldiA9IHBkZXY7CisKKwlpZiAodHdsX2luaXRpYWxpemVfZGV2aWNl
X2V4dGVuc2lvbih0d19kZXYpKSB7CisJCVRXX1BSSU5USyh0d19kZXYtPmhvc3QsIFRXX0RSSVZF
UiwgMHgxYSwgIkZhaWxlZCB0byBpbml0aWFsaXplIGRldmljZSBleHRlbnNpb24iKTsKKwkJZ290
byBvdXRfZnJlZV9kZXZpY2VfZXh0ZW5zaW9uOworCX0KKworCS8qIFJlcXVlc3QgSU8gcmVnaW9u
cyAqLworCXJldHZhbCA9IHBjaV9yZXF1ZXN0X3JlZ2lvbnMocGRldiwgIjN3LXNhcyIpOworCWlm
IChyZXR2YWwpIHsKKwkJVFdfUFJJTlRLKHR3X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAweDFiLCAi
RmFpbGVkIHRvIGdldCBtZW0gcmVnaW9uIik7CisJCWdvdG8gb3V0X2ZyZWVfZGV2aWNlX2V4dGVu
c2lvbjsKKwl9CisKKwkvKiBTYXZlIGJhc2UgYWRkcmVzcywgdXNlIHJlZ2lvbiAxICovCisJdHdf
ZGV2LT5iYXNlX2FkZHIgPSBwY2lfaW9tYXAocGRldiwgMSwgMCk7CisJaWYgKCF0d19kZXYtPmJh
c2VfYWRkcikgeworCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIsIDB4MWMsICJG
YWlsZWQgdG8gaW9yZW1hcCIpOworCQlnb3RvIG91dF9yZWxlYXNlX21lbV9yZWdpb247CisJfQor
CisJLyogRGlzYWJsZSBpbnRlcnJ1cHRzIG9uIHRoZSBjYXJkICovCisJVFdMX01BU0tfSU5URVJS
VVBUUyh0d19kZXYpOworCisJLyogSW5pdGlhbGl6ZSB0aGUgY2FyZCAqLworCWlmICh0d2xfcmVz
ZXRfc2VxdWVuY2UodHdfZGV2LCAwKSkgeworCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19E
UklWRVIsIDB4MWQsICJDb250cm9sbGVyIHJlc2V0IGZhaWxlZCBkdXJpbmcgcHJvYmUiKTsKKwkJ
Z290byBvdXRfaW91bm1hcDsKKwl9CisKKwkvKiBTZXQgaG9zdCBzcGVjaWZpYyBwYXJhbWV0ZXJz
ICovCisJaG9zdC0+bWF4X2lkID0gVFdfTUFYX1VOSVRTOworCWhvc3QtPm1heF9jbWRfbGVuID0g
VFdfTUFYX0NEQl9MRU47CisJaG9zdC0+bWF4X2x1biA9IFRXX01BWF9MVU5TOworCWhvc3QtPm1h
eF9jaGFubmVsID0gMDsKKworCS8qIFJlZ2lzdGVyIHRoZSBjYXJkIHdpdGggdGhlIGtlcm5lbCBT
Q1NJIGxheWVyICovCisJcmV0dmFsID0gc2NzaV9hZGRfaG9zdChob3N0LCAmcGRldi0+ZGV2KTsK
KwlpZiAocmV0dmFsKSB7CisJCVRXX1BSSU5USyh0d19kZXYtPmhvc3QsIFRXX0RSSVZFUiwgMHgx
ZSwgInNjc2kgYWRkIGhvc3QgZmFpbGVkIik7CisJCWdvdG8gb3V0X2lvdW5tYXA7CisJfQorCisJ
cGNpX3NldF9kcnZkYXRhKHBkZXYsIGhvc3QpOworCisJcHJpbnRrKEtFUk5fV0FSTklORyAiM3ct
c2FzOiBzY3NpJWQ6IEZvdW5kIGFuIExTSSAzd2FyZSAlcyBDb250cm9sbGVyIGF0IDB4JWxseCwg
SVJROiAlZC5cbiIsCisJICAgICAgIGhvc3QtPmhvc3Rfbm8sCisJICAgICAgIChjaGFyICopdHds
X2dldF9wYXJhbSh0d19kZXYsIDEsIFRXX1ZFUlNJT05fVEFCTEUsCisJCQkJICAgICBUV19QQVJB
TV9NT0RFTCwgVFdfUEFSQU1fTU9ERUxfTEVOR1RIKSwKKwkgICAgICAgKHU2NClwY2lfcmVzb3Vy
Y2Vfc3RhcnQocGRldiwgMSksIHBkZXYtPmlycSk7CisKKwlwdHJfcGh5Y291bnQgPSB0d2xfZ2V0
X3BhcmFtKHR3X2RldiwgMiwgVFdfUEFSQU1fUEhZX1NVTU1BUllfVEFCTEUsCisJCQkJICAgICBU
V19QQVJBTV9QSFlDT1VOVCwgVFdfUEFSQU1fUEhZQ09VTlRfTEVOR1RIKTsKKwlpZiAocHRyX3Bo
eWNvdW50KQorCQlwaHljb3VudCA9IGxlMzJfdG9fY3B1KCooaW50ICopcHRyX3BoeWNvdW50KTsK
KworCXByaW50ayhLRVJOX1dBUk5JTkcgIjN3LXNhczogc2NzaSVkOiBGaXJtd2FyZSAlcywgQklP
UyAlcywgUGh5czogJWQuXG4iLAorCSAgICAgICBob3N0LT5ob3N0X25vLAorCSAgICAgICAoY2hh
ciAqKXR3bF9nZXRfcGFyYW0odHdfZGV2LCAxLCBUV19WRVJTSU9OX1RBQkxFLAorCQkJCSAgICAg
VFdfUEFSQU1fRldWRVIsIFRXX1BBUkFNX0ZXVkVSX0xFTkdUSCksCisJICAgICAgIChjaGFyICop
dHdsX2dldF9wYXJhbSh0d19kZXYsIDIsIFRXX1ZFUlNJT05fVEFCTEUsCisJCQkJICAgICBUV19Q
QVJBTV9CSU9TVkVSLCBUV19QQVJBTV9CSU9TVkVSX0xFTkdUSCksCisJICAgICAgIHBoeWNvdW50
KTsKKworCS8qIFRyeSB0byBlbmFibGUgTVNJICovCisJaWYgKHVzZV9tc2kgJiYgIXBjaV9lbmFi
bGVfbXNpKHBkZXYpKQorCQlzZXRfYml0KFRXX1VTSU5HX01TSSwgJnR3X2Rldi0+ZmxhZ3MpOwor
CisJLyogTm93IHNldHVwIHRoZSBpbnRlcnJ1cHQgaGFuZGxlciAqLworCXJldHZhbCA9IHJlcXVl
c3RfaXJxKHBkZXYtPmlycSwgdHdsX2ludGVycnVwdCwgSVJRRl9TSEFSRUQsICIzdy1zYXMiLCB0
d19kZXYpOworCWlmIChyZXR2YWwpIHsKKwkJVFdfUFJJTlRLKHR3X2Rldi0+aG9zdCwgVFdfRFJJ
VkVSLCAweDFmLCAiRXJyb3IgcmVxdWVzdGluZyBJUlEiKTsKKwkJZ290byBvdXRfcmVtb3ZlX2hv
c3Q7CisJfQorCisJdHdsX2RldmljZV9leHRlbnNpb25fbGlzdFt0d2xfZGV2aWNlX2V4dGVuc2lv
bl9jb3VudF0gPSB0d19kZXY7CisJdHdsX2RldmljZV9leHRlbnNpb25fY291bnQrKzsKKworCS8q
IFJlLWVuYWJsZSBpbnRlcnJ1cHRzIG9uIHRoZSBjYXJkICovCisJVFdMX1VOTUFTS19JTlRFUlJV
UFRTKHR3X2Rldik7CisJCisJLyogRmluYWxseSwgc2NhbiB0aGUgaG9zdCAqLworCXNjc2lfc2Nh
bl9ob3N0KGhvc3QpOworCisJLyogQWRkIHN5c2ZzIGJpbmFyeSBmaWxlcyAqLworCWlmIChzeXNm
c19jcmVhdGVfYmluX2ZpbGUoJmhvc3QtPnNob3N0X2Rldi5rb2JqLCAmdHdsX3N5c2ZzX2Flbl9y
ZWFkX2F0dHIpKQorCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIsIDB4MjAsICJG
YWlsZWQgdG8gY3JlYXRlIHN5c2ZzIGJpbmFyeSBmaWxlOiAzd2FyZV9hZW5fcmVhZCIpOworCWlm
IChzeXNmc19jcmVhdGVfYmluX2ZpbGUoJmhvc3QtPnNob3N0X2Rldi5rb2JqLCAmdHdsX3N5c2Zz
X2NvbXBhdF9pbmZvX2F0dHIpKQorCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIs
IDB4MjEsICJGYWlsZWQgdG8gY3JlYXRlIHN5c2ZzIGJpbmFyeSBmaWxlOiAzd2FyZV9jb21wYXRf
aW5mbyIpOworCisJaWYgKHR3bF9tYWpvciA9PSAtMSkgeworCQlpZiAoKHR3bF9tYWpvciA9IHJl
Z2lzdGVyX2NocmRldiAoMCwgInR3bCIsICZ0d2xfZm9wcykpIDwgMCkKKwkJCVRXX1BSSU5USyho
b3N0LCBUV19EUklWRVIsIDB4MjIsICJGYWlsZWQgdG8gcmVnaXN0ZXIgY2hhcmFjdGVyIGRldmlj
ZSIpOworCX0KKwl0d19kZXYtPm9ubGluZSA9IDE7CisJcmV0dXJuIDA7CisKK291dF9yZW1vdmVf
aG9zdDoKKwlpZiAodGVzdF9iaXQoVFdfVVNJTkdfTVNJLCAmdHdfZGV2LT5mbGFncykpCisJCXBj
aV9kaXNhYmxlX21zaShwZGV2KTsKKwlzY3NpX3JlbW92ZV9ob3N0KGhvc3QpOworb3V0X2lvdW5t
YXA6CisJaW91bm1hcCh0d19kZXYtPmJhc2VfYWRkcik7CitvdXRfcmVsZWFzZV9tZW1fcmVnaW9u
OgorCXBjaV9yZWxlYXNlX3JlZ2lvbnMocGRldik7CitvdXRfZnJlZV9kZXZpY2VfZXh0ZW5zaW9u
OgorCXR3bF9mcmVlX2RldmljZV9leHRlbnNpb24odHdfZGV2KTsKKwlzY3NpX2hvc3RfcHV0KGhv
c3QpOworb3V0X2Rpc2FibGVfZGV2aWNlOgorCXBjaV9kaXNhYmxlX2RldmljZShwZGV2KTsKKwor
CXJldHVybiByZXR2YWw7Cit9IC8qIEVuZCB0d2xfcHJvYmUoKSAqLworCisvKiBUaGlzIGZ1bmN0
aW9uIGlzIGNhbGxlZCB0byByZW1vdmUgYSBkZXZpY2UgKi8KK3N0YXRpYyB2b2lkIHR3bF9yZW1v
dmUoc3RydWN0IHBjaV9kZXYgKnBkZXYpCit7CisJc3RydWN0IFNjc2lfSG9zdCAqaG9zdCA9IHBj
aV9nZXRfZHJ2ZGF0YShwZGV2KTsKKwlUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXY7CisKKwlp
ZiAoIWhvc3QpCisJCXJldHVybjsKKworCXR3X2RldiA9IChUV19EZXZpY2VfRXh0ZW5zaW9uICop
aG9zdC0+aG9zdGRhdGE7CisKKwlpZiAoIXR3X2Rldi0+b25saW5lKQorCQlyZXR1cm47CisKKwkv
KiBSZW1vdmUgc3lzZnMgYmluYXJ5IGZpbGVzICovCisJc3lzZnNfcmVtb3ZlX2Jpbl9maWxlKCZo
b3N0LT5zaG9zdF9kZXYua29iaiwgJnR3bF9zeXNmc19hZW5fcmVhZF9hdHRyKTsKKwlzeXNmc19y
ZW1vdmVfYmluX2ZpbGUoJmhvc3QtPnNob3N0X2Rldi5rb2JqLCAmdHdsX3N5c2ZzX2NvbXBhdF9p
bmZvX2F0dHIpOworCisJc2NzaV9yZW1vdmVfaG9zdCh0d19kZXYtPmhvc3QpOworCisJLyogVW5y
ZWdpc3RlciBjaGFyYWN0ZXIgZGV2aWNlICovCisJaWYgKHR3bF9tYWpvciA+PSAwKSB7CisJCXVu
cmVnaXN0ZXJfY2hyZGV2KHR3bF9tYWpvciwgInR3bCIpOworCQl0d2xfbWFqb3IgPSAtMTsKKwl9
CisKKwkvKiBTaHV0ZG93biB0aGUgY2FyZCAqLworCV9fdHdsX3NodXRkb3duKHR3X2Rldik7CisK
KwkvKiBEaXNhYmxlIE1TSSBpZiBlbmFibGVkICovCisJaWYgKHRlc3RfYml0KFRXX1VTSU5HX01T
SSwgJnR3X2Rldi0+ZmxhZ3MpKQorCQlwY2lfZGlzYWJsZV9tc2kocGRldik7CisKKwkvKiBGcmVl
IElPIHJlbWFwcGluZyAqLworCWlvdW5tYXAodHdfZGV2LT5iYXNlX2FkZHIpOworCisJLyogRnJl
ZSB1cCB0aGUgbWVtIHJlZ2lvbiAqLworCXBjaV9yZWxlYXNlX3JlZ2lvbnMocGRldik7CisKKwkv
KiBGcmVlIHVwIGRldmljZSBleHRlbnNpb24gcmVzb3VyY2VzICovCisJdHdsX2ZyZWVfZGV2aWNl
X2V4dGVuc2lvbih0d19kZXYpOworCisJc2NzaV9ob3N0X3B1dCh0d19kZXYtPmhvc3QpOworCXBj
aV9kaXNhYmxlX2RldmljZShwZGV2KTsKKwl0d2xfZGV2aWNlX2V4dGVuc2lvbl9jb3VudC0tOwor
fSAvKiBFbmQgdHdsX3JlbW92ZSgpICovCisKKyNpZmRlZiBDT05GSUdfUE0KKy8qIFRoaXMgZnVu
Y3Rpb24gaXMgY2FsbGVkIG9uIFBDSSBzdXNwZW5kICovCitzdGF0aWMgaW50IHR3bF9zdXNwZW5k
KHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBwbV9tZXNzYWdlX3Qgc3RhdGUpCit7CisJc3RydWN0IFNj
c2lfSG9zdCAqaG9zdCA9IHBjaV9nZXRfZHJ2ZGF0YShwZGV2KTsKKwlUV19EZXZpY2VfRXh0ZW5z
aW9uICp0d19kZXYgPSAoVFdfRGV2aWNlX0V4dGVuc2lvbiAqKWhvc3QtPmhvc3RkYXRhOworCisJ
cHJpbnRrKEtFUk5fV0FSTklORyAiM3ctc2FzOiBTdXNwZW5kaW5nIGhvc3QgJWQuXG4iLCB0d19k
ZXYtPmhvc3QtPmhvc3Rfbm8pOworCS8qIERpc2FibGUgaW50ZXJydXB0cyAqLworCVRXTF9NQVNL
X0lOVEVSUlVQVFModHdfZGV2KTsKKworCWZyZWVfaXJxKHR3X2Rldi0+dHdfcGNpX2Rldi0+aXJx
LCB0d19kZXYpOworCisJLyogVGVsbCB0aGUgY2FyZCB3ZSBhcmUgc2h1dHRpbmcgZG93biAqLwor
CWlmICh0d2xfaW5pdGNvbm5lY3Rpb24odHdfZGV2LCAxLCAwLCAwLCAwLCAwLCAwLCBOVUxMLCBO
VUxMLCBOVUxMLCBOVUxMLCBOVUxMKSkgeworCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19E
UklWRVIsIDB4MjMsICJDb25uZWN0aW9uIHNodXRkb3duIGZhaWxlZCBkdXJpbmcgc3VzcGVuZCIp
OworCX0gZWxzZSB7CisJCXByaW50ayhLRVJOX1dBUk5JTkcgIjN3LXNhczogU3VzcGVuZCBjb21w
bGV0ZS5cbiIpOworCX0KKworCS8qIENsZWFyIGRvb3JiZWxsIGludGVycnVwdCAqLworCVRXTF9D
TEVBUl9EQl9JTlRFUlJVUFQodHdfZGV2KTsKKworCXBjaV9zYXZlX3N0YXRlKHBkZXYpOworCXBj
aV9kaXNhYmxlX2RldmljZShwZGV2KTsKKwlwY2lfc2V0X3Bvd2VyX3N0YXRlKHBkZXYsIHBjaV9j
aG9vc2Vfc3RhdGUocGRldiwgc3RhdGUpKTsKKworCXJldHVybiAwOworfSAvKiBFbmQgdHdsX3N1
c3BlbmQoKSAqLworCisvKiBUaGlzIGZ1bmN0aW9uIGlzIGNhbGxlZCBvbiBQQ0kgcmVzdW1lICov
CitzdGF0aWMgaW50IHR3bF9yZXN1bWUoc3RydWN0IHBjaV9kZXYgKnBkZXYpCit7CisJaW50IHJl
dHZhbCA9IDA7CisJc3RydWN0IFNjc2lfSG9zdCAqaG9zdCA9IHBjaV9nZXRfZHJ2ZGF0YShwZGV2
KTsKKwlUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYgPSAoVFdfRGV2aWNlX0V4dGVuc2lvbiAq
KWhvc3QtPmhvc3RkYXRhOworCisJcHJpbnRrKEtFUk5fV0FSTklORyAiM3ctc2FzOiBSZXN1bWlu
ZyBob3N0ICVkLlxuIiwgdHdfZGV2LT5ob3N0LT5ob3N0X25vKTsKKwlwY2lfc2V0X3Bvd2VyX3N0
YXRlKHBkZXYsIFBDSV9EMCk7CisJcGNpX2VuYWJsZV93YWtlKHBkZXYsIFBDSV9EMCwgMCk7CisJ
cGNpX3Jlc3RvcmVfc3RhdGUocGRldik7CisKKwlyZXR2YWwgPSBwY2lfZW5hYmxlX2RldmljZShw
ZGV2KTsKKwlpZiAocmV0dmFsKSB7CisJCVRXX1BSSU5USyh0d19kZXYtPmhvc3QsIFRXX0RSSVZF
UiwgMHgyNCwgIkVuYWJsZSBkZXZpY2UgZmFpbGVkIGR1cmluZyByZXN1bWUiKTsKKwkJcmV0dXJu
IHJldHZhbDsKKwl9CisKKwlwY2lfc2V0X21hc3RlcihwZGV2KTsKKwlwY2lfdHJ5X3NldF9td2ko
cGRldik7CisKKwlpZiAocGNpX3NldF9kbWFfbWFzayhwZGV2LCBETUFfQklUX01BU0soNjQpKQor
CSAgICB8fCBwY2lfc2V0X2NvbnNpc3RlbnRfZG1hX21hc2socGRldiwgRE1BX0JJVF9NQVNLKDY0
KSkpCisJCWlmIChwY2lfc2V0X2RtYV9tYXNrKHBkZXYsIERNQV9CSVRfTUFTSygzMikpCisJCSAg
ICB8fCBwY2lfc2V0X2NvbnNpc3RlbnRfZG1hX21hc2socGRldiwgRE1BX0JJVF9NQVNLKDMyKSkp
IHsKKwkJCVRXX1BSSU5USyhob3N0LCBUV19EUklWRVIsIDB4MjUsICJGYWlsZWQgdG8gc2V0IGRt
YSBtYXNrIGR1cmluZyByZXN1bWUiKTsKKwkJCXJldHZhbCA9IC1FTk9ERVY7CisJCQlnb3RvIG91
dF9kaXNhYmxlX2RldmljZTsKKwkJfQorCisJLyogSW5pdGlhbGl6ZSB0aGUgY2FyZCAqLworCWlm
ICh0d2xfcmVzZXRfc2VxdWVuY2UodHdfZGV2LCAwKSkgeworCQlyZXR2YWwgPSAtRU5PREVWOwor
CQlnb3RvIG91dF9kaXNhYmxlX2RldmljZTsKKwl9CisKKwkvKiBOb3cgc2V0dXAgdGhlIGludGVy
cnVwdCBoYW5kbGVyICovCisJcmV0dmFsID0gcmVxdWVzdF9pcnEocGRldi0+aXJxLCB0d2xfaW50
ZXJydXB0LCBJUlFGX1NIQVJFRCwgIjN3LXNhcyIsIHR3X2Rldik7CisJaWYgKHJldHZhbCkgewor
CQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIsIDB4MjYsICJFcnJvciByZXF1ZXN0
aW5nIElSUSBkdXJpbmcgcmVzdW1lIik7CisJCXJldHZhbCA9IC1FTk9ERVY7CisJCWdvdG8gb3V0
X2Rpc2FibGVfZGV2aWNlOworCX0KKworCS8qIE5vdyBlbmFibGUgTVNJIGlmIGVuYWJsZWQgKi8K
KwlpZiAodGVzdF9iaXQoVFdfVVNJTkdfTVNJLCAmdHdfZGV2LT5mbGFncykpCisJCXBjaV9lbmFi
bGVfbXNpKHBkZXYpOworCisJLyogUmUtZW5hYmxlIGludGVycnVwdHMgb24gdGhlIGNhcmQgKi8K
KwlUV0xfVU5NQVNLX0lOVEVSUlVQVFModHdfZGV2KTsKKworCXByaW50ayhLRVJOX1dBUk5JTkcg
IjN3LXNhczogUmVzdW1lIGNvbXBsZXRlLlxuIik7CisJcmV0dXJuIDA7CisKK291dF9kaXNhYmxl
X2RldmljZToKKwlzY3NpX3JlbW92ZV9ob3N0KGhvc3QpOworCXBjaV9kaXNhYmxlX2RldmljZShw
ZGV2KTsKKworCXJldHVybiByZXR2YWw7Cit9IC8qIEVuZCB0d2xfcmVzdW1lKCkgKi8KKyNlbmRp
ZgorCisvKiBQQ0kgRGV2aWNlcyBzdXBwb3J0ZWQgYnkgdGhpcyBkcml2ZXIgKi8KK3N0YXRpYyBz
dHJ1Y3QgcGNpX2RldmljZV9pZCB0d2xfcGNpX3RibFtdIF9fZGV2aW5pdGRhdGEgPSB7CisJeyBQ
Q0lfVkRFVklDRSgzV0FSRSwgUENJX0RFVklDRV9JRF8zV0FSRV85NzUwKSB9LAorCXsgfQorfTsK
K01PRFVMRV9ERVZJQ0VfVEFCTEUocGNpLCB0d2xfcGNpX3RibCk7CisKKy8qIHBjaV9kcml2ZXIg
aW5pdGlhbGl6ZXIgKi8KK3N0YXRpYyBzdHJ1Y3QgcGNpX2RyaXZlciB0d2xfZHJpdmVyID0gewor
CS5uYW1lCQk9ICIzdy1zYXMiLAorCS5pZF90YWJsZQk9IHR3bF9wY2lfdGJsLAorCS5wcm9iZQkJ
PSB0d2xfcHJvYmUsCisJLnJlbW92ZQkJPSB0d2xfcmVtb3ZlLAorI2lmZGVmIENPTkZJR19QTQor
CS5zdXNwZW5kCT0gdHdsX3N1c3BlbmQsCisJLnJlc3VtZQkJPSB0d2xfcmVzdW1lLAorI2VuZGlm
CisJLnNodXRkb3duCT0gdHdsX3NodXRkb3duCit9OworCisvKiBUaGlzIGZ1bmN0aW9uIGlzIGNh
bGxlZCBvbiBkcml2ZXIgaW5pdGlhbGl6YXRpb24gKi8KK3N0YXRpYyBpbnQgX19pbml0IHR3bF9p
bml0KHZvaWQpCit7CisJcHJpbnRrKEtFUk5fSU5GTyAiTFNJIDN3YXJlIFNBUy9TQVRBLVJBSUQg
Q29udHJvbGxlciBkZXZpY2UgZHJpdmVyIGZvciBMaW51eCB2JXMuXG4iLCBUV19EUklWRVJfVkVS
U0lPTik7CisKKwlyZXR1cm4gcGNpX3JlZ2lzdGVyX2RyaXZlcigmdHdsX2RyaXZlcik7Cit9IC8q
IEVuZCB0d2xfaW5pdCgpICovCisKKy8qIFRoaXMgZnVuY3Rpb24gaXMgY2FsbGVkIG9uIGRyaXZl
ciBleGl0ICovCitzdGF0aWMgdm9pZCBfX2V4aXQgdHdsX2V4aXQodm9pZCkKK3sKKwlwY2lfdW5y
ZWdpc3Rlcl9kcml2ZXIoJnR3bF9kcml2ZXIpOworfSAvKiBFbmQgdHdsX2V4aXQoKSAqLworCitt
b2R1bGVfaW5pdCh0d2xfaW5pdCk7Cittb2R1bGVfZXhpdCh0d2xfZXhpdCk7CisKZGlmZiAtTmF1
ciBsaW51eC0yLjYuMzItcmM1LWdpdDEvZHJpdmVycy9zY3NpLzN3LXNhcy5oIGxpbnV4LTIuNi4z
Mi1yYzUtZ2l0MS5uZXcvZHJpdmVycy9zY3NpLzN3LXNhcy5oCi0tLSBsaW51eC0yLjYuMzItcmM1
LWdpdDEvZHJpdmVycy9zY3NpLzN3LXNhcy5oCTE5NjktMTItMzEgMTY6MDA6MDAuMDAwMDAwMDAw
IC0wODAwCisrKyBsaW51eC0yLjYuMzItcmM1LWdpdDEubmV3L2RyaXZlcnMvc2NzaS8zdy1zYXMu
aAkyMDA5LTEwLTIzIDE0OjI3OjQzLjAwMDAwMDAwMCAtMDcwMApAQCAtMCwwICsxLDM5NiBAQAor
LyoKKyAgIDN3LXNhcy5oIC0tIExTSSAzd2FyZSBTQVMvU0FUQS1SQUlEIENvbnRyb2xsZXIgZGV2
aWNlIGRyaXZlciBmb3IgTGludXguCisKKyAgIFdyaXR0ZW4gQnk6IEFkYW0gUmFkZm9yZCA8bGlu
dXhyYWlkQGxzaS5jb20+CisKKyAgIENvcHlyaWdodCAoQykgMjAwOSBMU0kgQ29ycG9yYXRpb24u
CisKKyAgIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0
ZSBpdCBhbmQvb3IgbW9kaWZ5CisgICBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5l
cmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxpc2hlZCBieQorICAgdGhlIEZyZWUgU29mdHdhcmUg
Rm91bmRhdGlvbjsgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLgorCisgICBUaGlzIHByb2dyYW0g
aXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwKKyAgIGJ1
dCBXSVRIT1VUIEFOWSBXQVJSQU5UWTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5
IG9mCisgICBNRVJDSEFOVEFCSUxJVFkgb3IgRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBP
U0UuICBTZWUgdGhlCisgICBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRh
aWxzLgorCisgICBOTyBXQVJSQU5UWQorICAgVEhFIFBST0dSQU0gSVMgUFJPVklERUQgT04gQU4g
IkFTIElTIiBCQVNJUywgV0lUSE9VVCBXQVJSQU5USUVTIE9SCisgICBDT05ESVRJT05TIE9GIEFO
WSBLSU5ELCBFSVRIRVIgRVhQUkVTUyBPUiBJTVBMSUVEIElOQ0xVRElORywgV0lUSE9VVAorICAg
TElNSVRBVElPTiwgQU5ZIFdBUlJBTlRJRVMgT1IgQ09ORElUSU9OUyBPRiBUSVRMRSwgTk9OLUlO
RlJJTkdFTUVOVCwKKyAgIE1FUkNIQU5UQUJJTElUWSBPUiBGSVRORVNTIEZPUiBBIFBBUlRJQ1VM
QVIgUFVSUE9TRS4gRWFjaCBSZWNpcGllbnQgaXMKKyAgIHNvbGVseSByZXNwb25zaWJsZSBmb3Ig
ZGV0ZXJtaW5pbmcgdGhlIGFwcHJvcHJpYXRlbmVzcyBvZiB1c2luZyBhbmQKKyAgIGRpc3RyaWJ1
dGluZyB0aGUgUHJvZ3JhbSBhbmQgYXNzdW1lcyBhbGwgcmlza3MgYXNzb2NpYXRlZCB3aXRoIGl0
cworICAgZXhlcmNpc2Ugb2YgcmlnaHRzIHVuZGVyIHRoaXMgQWdyZWVtZW50LCBpbmNsdWRpbmcg
YnV0IG5vdCBsaW1pdGVkIHRvCisgICB0aGUgcmlza3MgYW5kIGNvc3RzIG9mIHByb2dyYW0gZXJy
b3JzLCBkYW1hZ2UgdG8gb3IgbG9zcyBvZiBkYXRhLAorICAgcHJvZ3JhbXMgb3IgZXF1aXBtZW50
LCBhbmQgdW5hdmFpbGFiaWxpdHkgb3IgaW50ZXJydXB0aW9uIG9mIG9wZXJhdGlvbnMuCisKKyAg
IERJU0NMQUlNRVIgT0YgTElBQklMSVRZCisgICBORUlUSEVSIFJFQ0lQSUVOVCBOT1IgQU5ZIENP
TlRSSUJVVE9SUyBTSEFMTCBIQVZFIEFOWSBMSUFCSUxJVFkgRk9SIEFOWQorICAgRElSRUNULCBJ
TkRJUkVDVCwgSU5DSURFTlRBTCwgU1BFQ0lBTCwgRVhFTVBMQVJZLCBPUiBDT05TRVFVRU5USUFM
CisgICBEQU1BR0VTIChJTkNMVURJTkcgV0lUSE9VVCBMSU1JVEFUSU9OIExPU1QgUFJPRklUUyks
IEhPV0VWRVIgQ0FVU0VEIEFORAorICAgT04gQU5ZIFRIRU9SWSBPRiBMSUFCSUxJVFksIFdIRVRI
RVIgSU4gQ09OVFJBQ1QsIFNUUklDVCBMSUFCSUxJVFksIE9SCisgICBUT1JUIChJTkNMVURJTkcg
TkVHTElHRU5DRSBPUiBPVEhFUldJU0UpIEFSSVNJTkcgSU4gQU5ZIFdBWSBPVVQgT0YgVEhFCisg
ICBVU0UgT1IgRElTVFJJQlVUSU9OIE9GIFRIRSBQUk9HUkFNIE9SIFRIRSBFWEVSQ0lTRSBPRiBB
TlkgUklHSFRTIEdSQU5URUQKKyAgIEhFUkVVTkRFUiwgRVZFTiBJRiBBRFZJU0VEIE9GIFRIRSBQ
T1NTSUJJTElUWSBPRiBTVUNIIERBTUFHRVMKKworICAgWW91IHNob3VsZCBoYXZlIHJlY2VpdmVk
IGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UKKyAgIGFsb25nIHdpdGgg
dGhpcyBwcm9ncmFtOyBpZiBub3QsIHdyaXRlIHRvIHRoZSBGcmVlIFNvZnR3YXJlCisgICBGb3Vu
ZGF0aW9uLCBJbmMuLCA1OSBUZW1wbGUgUGxhY2UsIFN1aXRlIDMzMCwgQm9zdG9uLCBNQSAgMDIx
MTEtMTMwNyAgVVNBCisKKyAgIEJ1Z3MvQ29tbWVudHMvU3VnZ2VzdGlvbnMgc2hvdWxkIGJlIG1h
aWxlZCB0bzoKKyAgIGxpbnV4cmFpZEBsc2kuY29tCisKKyAgIEZvciBtb3JlIGluZm9ybWF0aW9u
LCBnb3RvOgorICAgaHR0cDovL3d3dy5sc2kuY29tCisqLworCisjaWZuZGVmIF8zV19TQVNfSAor
I2RlZmluZSBfM1dfU0FTX0gKKworLyogQUVOIHNldmVyaXR5IHRhYmxlICovCitzdGF0aWMgY2hh
ciAqdHdsX2Flbl9zZXZlcml0eV90YWJsZVtdID0KK3sKKwkiTm9uZSIsICJFUlJPUiIsICJXQVJO
SU5HIiwgIklORk8iLCAiREVCVUciLCBOVUxMCit9OworCisvKiBMaWJlcmF0b3IgcmVnaXN0ZXIg
b2Zmc2V0cyAqLworI2RlZmluZSBUV0xfU1RBVFVTICAgICAgICAgICAgICAgICAgICAgICAgIDB4
MCAgLyogU3RhdHVzICovCisjZGVmaW5lIFRXTF9ISUJEQiAgICAgICAgICAgICAgICAgICAgICAg
ICAgMHgyMCAvKiBJbmJvdW5kIGRvb3JiZWxsICovCisjZGVmaW5lIFRXTF9ISVNUQVQgICAgICAg
ICAgICAgICAgICAgICAgICAgMHgzMCAvKiBIb3N0IGludGVycnVwdCBzdGF0dXMgKi8KKyNkZWZp
bmUgVFdMX0hJTUFTSyAgICAgICAgICAgICAgICAgICAgICAgICAweDM0IC8qIEhvc3QgaW50ZXJy
dXB0IG1hc2sgKi8KKyNkZWZpbmUgVFdMX0hPQkRCCQkJICAgMHg5QyAvKiBPdXRib3VuZCBkb29y
YmVsbCAqLworI2RlZmluZSBUV0xfSE9CREJDICAgICAgICAgICAgICAgICAgICAgICAgIDB4QTAg
LyogT3V0Ym91bmQgZG9vcmJlbGwgY2xlYXIgKi8KKyNkZWZpbmUgVFdMX1NDUlBEMyAgICAgICAg
ICAgICAgICAgICAgICAgICAweEJDIC8qIFNjcmF0Y2hwYWQgKi8KKyNkZWZpbmUgVFdMX0hJQlFQ
TCAgICAgICAgICAgICAgICAgICAgICAgICAweEMwIC8qIEhvc3QgaW5ib3VuZCBRIGxvdyAqLwor
I2RlZmluZSBUV0xfSElCUVBIICAgICAgICAgICAgICAgICAgICAgICAgIDB4QzQgLyogSG9zdCBp
bmJvdW5kIFEgaGlnaCAqLworI2RlZmluZSBUV0xfSE9CUVBMICAgICAgICAgICAgICAgICAgICAg
ICAgIDB4QzggLyogSG9zdCBvdXRib3VuZCBRIGxvdyAqLworI2RlZmluZSBUV0xfSE9CUVBIICAg
ICAgICAgICAgICAgICAgICAgICAgIDB4Q0MgLyogSG9zdCBvdXRib3VuZCBRIGhpZ2ggKi8KKyNk
ZWZpbmUgVFdMX0hJU1RBVFVTX1ZBTElEX0lOVEVSUlVQVAkgICAweEMKKyNkZWZpbmUgVFdMX0hJ
U1RBVFVTX0FUVEVOVElPTl9JTlRFUlJVUFQgICAweDQKKyNkZWZpbmUgVFdMX0hJU1RBVFVTX1JF
U1BPTlNFX0lOVEVSUlVQVAkgICAweDgKKyNkZWZpbmUgVFdMX1NUQVRVU19PVkVSUlVOX1NVQk1J
VAkgICAweDIwMDAKKyNkZWZpbmUgVFdMX0lTU1VFX1NPRlRfUkVTRVQJCSAgIDB4MTAwCisjZGVm
aW5lIFRXTF9DT05UUk9MTEVSX1JFQURZCQkgICAweDIwMDAKKyNkZWZpbmUgVFdMX0RPT1JCRUxM
X0NPTlRST0xMRVJfRVJST1IJICAgMHgyMDAwMDAKKyNkZWZpbmUgVFdMX0RPT1JCRUxMX0FUVEVO
VElPTl9JTlRFUlJVUFQgICAweDQwMDAwCisjZGVmaW5lIFRXTF9QVUxMX01PREUJCQkgICAweDEK
KworLyogQ29tbWFuZCBwYWNrZXQgb3Bjb2RlcyB1c2VkIGJ5IHRoZSBkcml2ZXIgKi8KKyNkZWZp
bmUgVFdfT1BfSU5JVF9DT05ORUNUSU9OIDB4MQorI2RlZmluZSBUV19PUF9HRVRfUEFSQU0JICAg
ICAgMHgxMgorI2RlZmluZSBUV19PUF9TRVRfUEFSQU0JICAgICAgMHgxMworI2RlZmluZSBUV19P
UF9FWEVDVVRFX1NDU0kgICAgMHgxMAorCisvKiBBc3luY2hyb25vdXMgRXZlbnQgTm90aWZpY2F0
aW9uIChBRU4pIGNvZGVzIHVzZWQgYnkgdGhlIGRyaXZlciAqLworI2RlZmluZSBUV19BRU5fUVVF
VUVfRU1QVFkgICAgICAgMHgwMDAwCisjZGVmaW5lIFRXX0FFTl9TT0ZUX1JFU0VUICAgICAgICAw
eDAwMDEKKyNkZWZpbmUgVFdfQUVOX1NZTkNfVElNRV9XSVRIX0hPU1QgMHgwMzEKKyNkZWZpbmUg
VFdfQUVOX1NFVkVSSVRZX0VSUk9SICAgIDB4MQorI2RlZmluZSBUV19BRU5fU0VWRVJJVFlfREVC
VUcgICAgMHg0CisjZGVmaW5lIFRXX0FFTl9OT1RfUkVUUklFVkVEIDB4MQorCisvKiBDb21tYW5k
IHN0YXRlIGRlZmluZXMgKi8KKyNkZWZpbmUgVFdfU19JTklUSUFMICAgMHgxICAvKiBJbml0aWFs
IHN0YXRlICovCisjZGVmaW5lIFRXX1NfU1RBUlRFRCAgIDB4MiAgLyogSWQgaW4gdXNlICovCisj
ZGVmaW5lIFRXX1NfUE9TVEVEICAgIDB4NCAgLyogUG9zdGVkIHRvIHRoZSBjb250cm9sbGVyICov
CisjZGVmaW5lIFRXX1NfQ09NUExFVEVEIDB4OCAgLyogQ29tcGxldGVkIGJ5IGlzciAqLworI2Rl
ZmluZSBUV19TX0ZJTklTSEVEICAweDEwIC8qIEkvTyBjb21wbGV0ZWx5IGRvbmUgKi8KKworLyog
Q29tcGF0aWJpbGl0eSBkZWZpbmVzICovCisjZGVmaW5lIFRXXzk3NTBfQVJDSF9JRCAxMAorI2Rl
ZmluZSBUV19DVVJSRU5UX0RSSVZFUl9TUkwgNDAKKyNkZWZpbmUgVFdfQ1VSUkVOVF9EUklWRVJf
QlVJTEQgMAorI2RlZmluZSBUV19DVVJSRU5UX0RSSVZFUl9CUkFOQ0ggMAorCisvKiBQaGFzZSBk
ZWZpbmVzICovCisjZGVmaW5lIFRXX1BIQVNFX0lOSVRJQUwgMAorI2RlZmluZSBUV19QSEFTRV9T
R0xJU1QgIDIKKworLyogTWlzYyBkZWZpbmVzICovCisjZGVmaW5lIFRXX1NFQ1RPUl9TSVpFICAg
ICAgICAgICAgICAgICAgICAgICAgNTEyCisjZGVmaW5lIFRXX01BWF9VTklUUwkJCSAgICAgIDMy
CisjZGVmaW5lIFRXX0lOSVRfTUVTU0FHRV9DUkVESVRTCQkgICAgICAweDEwMAorI2RlZmluZSBU
V19JTklUX0NPTU1BTkRfUEFDS0VUX1NJWkUJICAgICAgMHgzCisjZGVmaW5lIFRXX0lOSVRfQ09N
TUFORF9QQUNLRVRfU0laRV9FWFRFTkRFRCAgMHg2CisjZGVmaW5lIFRXX0VYVEVOREVEX0lOSVRf
Q09OTkVDVAkgICAgICAweDIKKyNkZWZpbmUgVFdfQkFTRV9GV19TUkwJCQkgICAgICAyNAorI2Rl
ZmluZSBUV19CQVNFX0ZXX0JSQU5DSAkJICAgICAgMAorI2RlZmluZSBUV19CQVNFX0ZXX0JVSUxE
CQkgICAgICAxCisjZGVmaW5lIFRXX1FfTEVOR1RICQkJICAgICAgMjU2CisjZGVmaW5lIFRXX1Ff
U1RBUlQJCQkgICAgICAwCisjZGVmaW5lIFRXX01BWF9TTE9UCQkJICAgICAgMzIKKyNkZWZpbmUg
VFdfTUFYX1JFU0VUX1RSSUVTCQkgICAgICAyCisjZGVmaW5lIFRXX01BWF9DTURTX1BFUl9MVU4J
CSAgICAgIDI1NAorI2RlZmluZSBUV19NQVhfQUVOX0RSQUlOCQkgICAgICAyNTUKKyNkZWZpbmUg
VFdfSU5fUkVTRVQgICAgICAgICAgICAgICAgICAgICAgICAgICAyCisjZGVmaW5lIFRXX1VTSU5H
X01TSQkJCSAgICAgIDMKKyNkZWZpbmUgVFdfSU5fQVRURU5USU9OX0xPT1AJCSAgICAgIDQKKyNk
ZWZpbmUgVFdfTUFYX1NFQ1RPUlMgICAgICAgICAgICAgICAgICAgICAgICAyNTYKKyNkZWZpbmUg
VFdfTUFYX0NEQl9MRU4gICAgICAgICAgICAgICAgICAgICAgICAxNgorI2RlZmluZSBUV19JT0NU
TF9DSFJERVZfVElNRU9VVCAgICAgICAgICAgICAgIDYwIC8qIDYwIHNlY29uZHMgKi8KKyNkZWZp
bmUgVFdfSU9DVExfQ0hSREVWX0ZSRUUgICAgICAgICAgICAgICAgICAtMQorI2RlZmluZSBUV19D
T01NQU5EX09GRlNFVCAgICAgICAgICAgICAgICAgICAgIDEyOCAvKiAxMjggYnl0ZXMgKi8KKyNk
ZWZpbmUgVFdfVkVSU0lPTl9UQUJMRSAgICAgICAgICAgICAgICAgICAgICAweDA0MDIKKyNkZWZp
bmUgVFdfVElNRUtFRVBfVEFCTEUJCSAgICAgIDB4MDQwQQorI2RlZmluZSBUV19JTkZPUk1BVElP
Tl9UQUJMRQkJICAgICAgMHgwNDAzCisjZGVmaW5lIFRXX1BBUkFNX0ZXVkVSCQkJICAgICAgMwor
I2RlZmluZSBUV19QQVJBTV9GV1ZFUl9MRU5HVEgJCSAgICAgIDE2CisjZGVmaW5lIFRXX1BBUkFN
X0JJT1NWRVIJCSAgICAgIDQKKyNkZWZpbmUgVFdfUEFSQU1fQklPU1ZFUl9MRU5HVEgJCSAgICAg
IDE2CisjZGVmaW5lIFRXX1BBUkFNX01PREVMCQkJICAgICAgOAorI2RlZmluZSBUV19QQVJBTV9N
T0RFTF9MRU5HVEgJCSAgICAgIDE2CisjZGVmaW5lIFRXX1BBUkFNX1BIWV9TVU1NQVJZX1RBQkxF
CSAgICAgIDEKKyNkZWZpbmUgVFdfUEFSQU1fUEhZQ09VTlQJCSAgICAgIDIKKyNkZWZpbmUgVFdf
UEFSQU1fUEhZQ09VTlRfTEVOR1RICSAgICAgIDEKKyNkZWZpbmUgVFdfSU9DVExfRklSTVdBUkVf
UEFTU19USFJPVUdIICAgICAgICAweDEwOCAgLy8gVXNlZCBieSBzbWFydG1vbnRvb2xzCisjZGVm
aW5lIFRXX0FMTE9DQVRJT05fTEVOR1RICQkgICAgICAxMjgKKyNkZWZpbmUgVFdfU0VOU0VfREFU
QV9MRU5HVEgJCSAgICAgIDE4CisjZGVmaW5lIFRXX0VSUk9SX0xPR0lDQUxfVU5JVF9OT1RfU1VQ
UE9SVEVEICAgMHgxMGEKKyNkZWZpbmUgVFdfRVJST1JfSU5WQUxJRF9GSUVMRF9JTl9DREIJICAg
ICAgMHgxMGQKKyNkZWZpbmUgVFdfRVJST1JfVU5JVF9PRkZMSU5FICAgICAgICAgICAgICAgICAw
eDEyOAorI2RlZmluZSBUV19NRVNTQUdFX1NPVVJDRV9DT05UUk9MTEVSX0VSUk9SICAgIDMKKyNk
ZWZpbmUgVFdfTUVTU0FHRV9TT1VSQ0VfQ09OVFJPTExFUl9FVkVOVCAgICA0CisjZGVmaW5lIFRX
X0RSSVZFUiAJCQkgICAgICA2CisjaWZuZGVmIFBDSV9ERVZJQ0VfSURfM1dBUkVfOTc1MAorI2Rl
ZmluZSBQQ0lfREVWSUNFX0lEXzNXQVJFXzk3NTAgMHgxMDEwCisjZW5kaWYKKworLyogQml0bWFz
ayBtYWNyb3MgdG8gZWxpbWluYXRlIGJpdGZpZWxkcyAqLworCisvKiBvcGNvZGU6IDUsIHJlc2Vy
dmVkOiAzICovCisjZGVmaW5lIFRXX09QUkVTX0lOKHgseSkgKCh4IDw8IDUpIHwgKHkgJiAweDFm
KSkKKyNkZWZpbmUgVFdfT1BfT1VUKHgpICh4ICYgMHgxZikKKworLyogb3Bjb2RlOiA1LCBzZ2xv
ZmZzZXQ6IDMgKi8KKyNkZWZpbmUgVFdfT1BTR0xfSU4oeCx5KSAoKHggPDwgNSkgfCAoeSAmIDB4
MWYpKQorI2RlZmluZSBUV19TR0xfT1VUKHgpICgoeCA+PiA1KSAmIDB4NykKKworLyogc2V2ZXJp
dHk6IDMsIHJlc2VydmVkOiA1ICovCisjZGVmaW5lIFRXX1NFVl9PVVQoeCkgKHggJiAweDcpCisK
Ky8qIG5vdF9tZmE6IDEsIHJlc2VydmVkOiA3LCBzdGF0dXM6IDgsIHJlcXVlc3RfaWQ6IDE2ICov
CisjZGVmaW5lIFRXX1JFU0lEX09VVCh4KSAoKHggPj4gMTYpICYgMHhmZmZmKQorI2RlZmluZSBU
V19OT1RNRkFfT1VUKHgpICh4ICYgMHgxKQorCisvKiByZXF1ZXN0X2lkOiAxMiwgbHVuOiA0ICov
CisjZGVmaW5lIFRXX1JFUV9MVU5fSU4obHVuLCByZXF1ZXN0X2lkKSAoKChsdW4gPDwgMTIpICYg
MHhmMDAwKSB8IChyZXF1ZXN0X2lkICYgMHhmZmYpKQorI2RlZmluZSBUV19MVU5fT1VUKGx1bikg
KChsdW4gPj4gMTIpICYgMHhmKQorCisvKiBSZWdpc3RlciBhY2Nlc3MgbWFjcm9zICovCisjZGVm
aW5lIFRXTF9TVEFUVVNfUkVHX0FERFIoeCkgKCh1bnNpZ25lZCBjaGFyIF9faW9tZW0gKil4LT5i
YXNlX2FkZHIgKyBUV0xfU1RBVFVTKQorI2RlZmluZSBUV0xfSE9CUVBMX1JFR19BRERSKHgpICgo
dW5zaWduZWQgY2hhciBfX2lvbWVtICopeC0+YmFzZV9hZGRyICsgVFdMX0hPQlFQTCkKKyNkZWZp
bmUgVFdMX0hPQlFQSF9SRUdfQUREUih4KSAoKHVuc2lnbmVkIGNoYXIgX19pb21lbSAqKXgtPmJh
c2VfYWRkciArIFRXTF9IT0JRUEgpCisjZGVmaW5lIFRXTF9IT0JEQl9SRUdfQUREUih4KSAoKHVu
c2lnbmVkIGNoYXIgX19pb21lbSAqKXgtPmJhc2VfYWRkciArIFRXTF9IT0JEQikKKyNkZWZpbmUg
VFdMX0hPQkRCQ19SRUdfQUREUih4KSAoKHVuc2lnbmVkIGNoYXIgX19pb21lbSAqKXgtPmJhc2Vf
YWRkciArIFRXTF9IT0JEQkMpCisjZGVmaW5lIFRXTF9ISU1BU0tfUkVHX0FERFIoeCkgKCh1bnNp
Z25lZCBjaGFyIF9faW9tZW0gKil4LT5iYXNlX2FkZHIgKyBUV0xfSElNQVNLKQorI2RlZmluZSBU
V0xfSElTVEFUX1JFR19BRERSKHgpICgodW5zaWduZWQgY2hhciBfX2lvbWVtICopeC0+YmFzZV9h
ZGRyICsgVFdMX0hJU1RBVCkKKyNkZWZpbmUgVFdMX0hJQlFQSF9SRUdfQUREUih4KSAoKHVuc2ln
bmVkIGNoYXIgX19pb21lbSAqKXgtPmJhc2VfYWRkciArIFRXTF9ISUJRUEgpCisjZGVmaW5lIFRX
TF9ISUJRUExfUkVHX0FERFIoeCkgKCh1bnNpZ25lZCBjaGFyIF9faW9tZW0gKil4LT5iYXNlX2Fk
ZHIgKyBUV0xfSElCUVBMKQorI2RlZmluZSBUV0xfSElCREJfUkVHX0FERFIoeCkgKCh1bnNpZ25l
ZCBjaGFyIF9faW9tZW0gKil4LT5iYXNlX2FkZHIgKyBUV0xfSElCREIpCisjZGVmaW5lIFRXTF9T
Q1JQRDNfUkVHX0FERFIoeCkgKCh1bnNpZ25lZCBjaGFyIF9faW9tZW0gKil4LT5iYXNlX2FkZHIg
KyBUV0xfU0NSUEQzKQorI2RlZmluZSBUV0xfTUFTS19JTlRFUlJVUFRTKHgpICh3cml0ZWwofjAs
IFRXTF9ISU1BU0tfUkVHX0FERFIodHdfZGV2KSkpCisjZGVmaW5lIFRXTF9VTk1BU0tfSU5URVJS
VVBUUyh4KSAod3JpdGVsKH5UV0xfSElTVEFUVVNfVkFMSURfSU5URVJSVVBULCBUV0xfSElNQVNL
X1JFR19BRERSKHR3X2RldikpKQorI2RlZmluZSBUV0xfQ0xFQVJfREJfSU5URVJSVVBUKHgpICh3
cml0ZWwofjAsIFRXTF9IT0JEQkNfUkVHX0FERFIodHdfZGV2KSkpCisjZGVmaW5lIFRXTF9TT0ZU
X1JFU0VUKHgpICh3cml0ZWwoVFdMX0lTU1VFX1NPRlRfUkVTRVQsIFRXTF9ISUJEQl9SRUdfQURE
Uih0d19kZXYpKSkKKworLyogTWFjcm9zICovCisjZGVmaW5lIFRXX1BSSU5USyhoLGEsYixjKSB7
IFwKK2lmIChoKSBcCitwcmludGsoS0VSTl9XQVJOSU5HICIzdy1zYXM6IHNjc2klZDogRVJST1I6
ICgweCUwMlg6MHglMDRYKTogJXMuXG4iLGgtPmhvc3Rfbm8sYSxiLGMpOyBcCitlbHNlIFwKK3By
aW50ayhLRVJOX1dBUk5JTkcgIjN3LXNhczogRVJST1I6ICgweCUwMlg6MHglMDRYKTogJXMuXG4i
LGEsYixjKTsgXAorfQorI2RlZmluZSBUV19NQVhfTFVOUyAxNgorI2RlZmluZSBUV19DT01NQU5E
X1NJWkUgKHNpemVvZihkbWFfYWRkcl90KSA+IDQgPyA2IDogNCkKKyNkZWZpbmUgVFdfTElCRVJB
VE9SX01BWF9TR0xfTEVOR1RIIChzaXplb2YoZG1hX2FkZHJfdCkgPiA0ID8gNDYgOiA5MikKKyNk
ZWZpbmUgVFdfTElCRVJBVE9SX01BWF9TR0xfTEVOR1RIX09MRCAoc2l6ZW9mKGRtYV9hZGRyX3Qp
ID4gNCA/IDQ3IDogOTQpCisjZGVmaW5lIFRXX1BBRERJTkdfTEVOR1RIX0xJQkVSQVRPUiAxMzYK
KyNkZWZpbmUgVFdfUEFERElOR19MRU5HVEhfTElCRVJBVE9SX09MRCAxMzIKKyNkZWZpbmUgVFdf
Q1BVX1RPX1NHTCh4KSAoc2l6ZW9mKGRtYV9hZGRyX3QpID4gNCA/IGNwdV90b19sZTY0KHgpIDog
Y3B1X3RvX2xlMzIoeCkpCisKKyNwcmFnbWEgcGFjaygxKQorCisvKiBTR0wgZW50cnkgKi8KK3R5
cGVkZWYgc3RydWN0IFRBR19UV19TR19FbnRyeV9JU08geworCWRtYV9hZGRyX3QgYWRkcmVzczsK
KwlkbWFfYWRkcl90IGxlbmd0aDsKK30gVFdfU0dfRW50cnlfSVNPOworCisvKiBPbGQgQ29tbWFu
ZCBQYWNrZXQgd2l0aCBJU08gU0dMICovCit0eXBlZGVmIHN0cnVjdCBUV19Db21tYW5kIHsKKwl1
bnNpZ25lZCBjaGFyIG9wY29kZV9fc2dsb2Zmc2V0OworCXVuc2lnbmVkIGNoYXIgc2l6ZTsKKwl1
bnNpZ25lZCBjaGFyIHJlcXVlc3RfaWQ7CisJdW5zaWduZWQgY2hhciB1bml0X19ob3N0aWQ7CisJ
LyogU2Vjb25kIERXT1JEICovCisJdW5zaWduZWQgY2hhciBzdGF0dXM7CisJdW5zaWduZWQgY2hh
ciBmbGFnczsKKwl1bmlvbiB7CisJCXVuc2lnbmVkIHNob3J0IGJsb2NrX2NvdW50OworCQl1bnNp
Z25lZCBzaG9ydCBwYXJhbWV0ZXJfY291bnQ7CisJfSBieXRlNl9vZmZzZXQ7CisJdW5pb24gewor
CQlzdHJ1Y3QgeworCQkJdTMyIGxiYTsKKwkJCVRXX1NHX0VudHJ5X0lTTyBzZ2xbVFdfTElCRVJB
VE9SX01BWF9TR0xfTEVOR1RIX09MRF07CisJCQl1bnNpZ25lZCBjaGFyIHBhZGRpbmdbVFdfUEFE
RElOR19MRU5HVEhfTElCRVJBVE9SX09MRF07CisJCX0gaW87CisJCXN0cnVjdCB7CisJCQlUV19T
R19FbnRyeV9JU08gc2dsW1RXX0xJQkVSQVRPUl9NQVhfU0dMX0xFTkdUSF9PTERdOworCQkJdTMy
IHBhZGRpbmc7CisJCQl1bnNpZ25lZCBjaGFyIHBhZGRpbmcyW1RXX1BBRERJTkdfTEVOR1RIX0xJ
QkVSQVRPUl9PTERdOworCQl9IHBhcmFtOworCX0gYnl0ZThfb2Zmc2V0OworfSBUV19Db21tYW5k
OworCisvKiBOZXcgQ29tbWFuZCBQYWNrZXQgd2l0aCBJU08gU0dMICovCit0eXBlZGVmIHN0cnVj
dCBUQUdfVFdfQ29tbWFuZF9BcGFjaGUgeworCXVuc2lnbmVkIGNoYXIgb3Bjb2RlX19yZXNlcnZl
ZDsKKwl1bnNpZ25lZCBjaGFyIHVuaXQ7CisJdW5zaWduZWQgc2hvcnQgcmVxdWVzdF9pZF9fbHVu
bDsKKwl1bnNpZ25lZCBjaGFyIHN0YXR1czsKKwl1bnNpZ25lZCBjaGFyIHNnbF9vZmZzZXQ7CisJ
dW5zaWduZWQgc2hvcnQgc2dsX2VudHJpZXNfX2x1bmg7CisJdW5zaWduZWQgY2hhciBjZGJbMTZd
OworCVRXX1NHX0VudHJ5X0lTTyBzZ19saXN0W1RXX0xJQkVSQVRPUl9NQVhfU0dMX0xFTkdUSF07
CisJdW5zaWduZWQgY2hhciBwYWRkaW5nW1RXX1BBRERJTkdfTEVOR1RIX0xJQkVSQVRPUl07Cit9
IFRXX0NvbW1hbmRfQXBhY2hlOworCisvKiBOZXcgY29tbWFuZCBwYWNrZXQgaGVhZGVyICovCit0
eXBlZGVmIHN0cnVjdCBUQUdfVFdfQ29tbWFuZF9BcGFjaGVfSGVhZGVyIHsKKwl1bnNpZ25lZCBj
aGFyIHNlbnNlX2RhdGFbVFdfU0VOU0VfREFUQV9MRU5HVEhdOworCXN0cnVjdCB7CisJCWNoYXIg
cmVzZXJ2ZWRbNF07CisJCXVuc2lnbmVkIHNob3J0IGVycm9yOworCQl1bnNpZ25lZCBjaGFyIHBh
ZGRpbmc7CisJCXVuc2lnbmVkIGNoYXIgc2V2ZXJpdHlfX3Jlc2VydmVkOworCX0gc3RhdHVzX2Js
b2NrOworCXVuc2lnbmVkIGNoYXIgZXJyX3NwZWNpZmljX2Rlc2NbOThdOworCXN0cnVjdCB7CisJ
CXVuc2lnbmVkIGNoYXIgc2l6ZV9oZWFkZXI7CisJCXVuc2lnbmVkIHNob3J0IHJlcXVlc3RfaWQ7
CisJCXVuc2lnbmVkIGNoYXIgc2l6ZV9zZW5zZTsKKwl9IGhlYWRlcl9kZXNjOworfSBUV19Db21t
YW5kX0FwYWNoZV9IZWFkZXI7CisKKy8qIFRoaXMgc3RydWN0IGlzIGEgdW5pb24gb2YgdGhlIDIg
Y29tbWFuZCBwYWNrZXRzICovCit0eXBlZGVmIHN0cnVjdCBUQUdfVFdfQ29tbWFuZF9GdWxsIHsK
KwlUV19Db21tYW5kX0FwYWNoZV9IZWFkZXIgaGVhZGVyOworCXVuaW9uIHsKKwkJVFdfQ29tbWFu
ZCBvbGRjb21tYW5kOworCQlUV19Db21tYW5kX0FwYWNoZSBuZXdjb21tYW5kOworCX0gY29tbWFu
ZDsKK30gVFdfQ29tbWFuZF9GdWxsOworCisvKiBJbml0Y29ubmVjdGlvbiBzdHJ1Y3R1cmUgKi8K
K3R5cGVkZWYgc3RydWN0IFRBR19UV19Jbml0Y29ubmVjdCB7CisJdW5zaWduZWQgY2hhciBvcGNv
ZGVfX3Jlc2VydmVkOworCXVuc2lnbmVkIGNoYXIgc2l6ZTsKKwl1bnNpZ25lZCBjaGFyIHJlcXVl
c3RfaWQ7CisJdW5zaWduZWQgY2hhciByZXMyOworCXVuc2lnbmVkIGNoYXIgc3RhdHVzOworCXVu
c2lnbmVkIGNoYXIgZmxhZ3M7CisJdW5zaWduZWQgc2hvcnQgbWVzc2FnZV9jcmVkaXRzOworCXUz
MiBmZWF0dXJlczsKKwl1bnNpZ25lZCBzaG9ydCBmd19zcmw7CisJdW5zaWduZWQgc2hvcnQgZndf
YXJjaF9pZDsKKwl1bnNpZ25lZCBzaG9ydCBmd19icmFuY2g7CisJdW5zaWduZWQgc2hvcnQgZndf
YnVpbGQ7CisJdTMyIHJlc3VsdDsKK30gVFdfSW5pdGNvbm5lY3Q7CisKKy8qIEV2ZW50IGluZm8g
c3RydWN0dXJlICovCit0eXBlZGVmIHN0cnVjdCBUQUdfVFdfRXZlbnQKK3sKKwl1bnNpZ25lZCBp
bnQgc2VxdWVuY2VfaWQ7CisJdW5zaWduZWQgaW50IHRpbWVfc3RhbXBfc2VjOworCXVuc2lnbmVk
IHNob3J0IGFlbl9jb2RlOworCXVuc2lnbmVkIGNoYXIgc2V2ZXJpdHk7CisJdW5zaWduZWQgY2hh
ciByZXRyaWV2ZWQ7CisJdW5zaWduZWQgY2hhciByZXBlYXRfY291bnQ7CisJdW5zaWduZWQgY2hh
ciBwYXJhbWV0ZXJfbGVuOworCXVuc2lnbmVkIGNoYXIgcGFyYW1ldGVyX2RhdGFbOThdOworfSBU
V19FdmVudDsKKwordHlwZWRlZiBzdHJ1Y3QgVEFHX1RXX0lvY3RsX0RyaXZlcl9Db21tYW5kIHsK
Kwl1bnNpZ25lZCBpbnQgY29udHJvbF9jb2RlOworCXVuc2lnbmVkIGludCBzdGF0dXM7CisJdW5z
aWduZWQgaW50IHVuaXF1ZV9pZDsKKwl1bnNpZ25lZCBpbnQgc2VxdWVuY2VfaWQ7CisJdW5zaWdu
ZWQgaW50IG9zX3NwZWNpZmljOworCXVuc2lnbmVkIGludCBidWZmZXJfbGVuZ3RoOworfSBUV19J
b2N0bF9Ecml2ZXJfQ29tbWFuZDsKKwordHlwZWRlZiBzdHJ1Y3QgVEFHX1RXX0lvY3RsX0FwYWNo
ZSB7CisJVFdfSW9jdGxfRHJpdmVyX0NvbW1hbmQgZHJpdmVyX2NvbW1hbmQ7CisgICAgICAgIGNo
YXIgcGFkZGluZ1s0ODhdOworCVRXX0NvbW1hbmRfRnVsbCBmaXJtd2FyZV9jb21tYW5kOworCWNo
YXIgZGF0YV9idWZmZXJbMV07Cit9IFRXX0lvY3RsX0J1Zl9BcGFjaGU7CisKKy8qIEdldFBhcmFt
IGRlc2NyaXB0b3IgKi8KK3R5cGVkZWYgc3RydWN0IHsKKwl1bnNpZ25lZCBzaG9ydAl0YWJsZV9p
ZDsKKwl1bnNpZ25lZCBzaG9ydAlwYXJhbWV0ZXJfaWQ7CisJdW5zaWduZWQgc2hvcnQJcGFyYW1l
dGVyX3NpemVfYnl0ZXM7CisJdW5zaWduZWQgc2hvcnQgIGFjdHVhbF9wYXJhbWV0ZXJfc2l6ZV9i
eXRlczsKKwl1bnNpZ25lZCBjaGFyCWRhdGFbMV07Cit9IFRXX1BhcmFtX0FwYWNoZTsKKworLyog
Q29tcGF0aWJpbGl0eSBpbmZvcm1hdGlvbiBzdHJ1Y3R1cmUgKi8KK3R5cGVkZWYgc3RydWN0IFRB
R19UV19Db21wYXRpYmlsaXR5X0luZm8KK3sKKwljaGFyIGRyaXZlcl92ZXJzaW9uWzMyXTsKKwl1
bnNpZ25lZCBzaG9ydCB3b3JraW5nX3NybDsKKwl1bnNpZ25lZCBzaG9ydCB3b3JraW5nX2JyYW5j
aDsKKwl1bnNpZ25lZCBzaG9ydCB3b3JraW5nX2J1aWxkOworCXVuc2lnbmVkIHNob3J0IGRyaXZl
cl9zcmxfaGlnaDsKKwl1bnNpZ25lZCBzaG9ydCBkcml2ZXJfYnJhbmNoX2hpZ2g7CisJdW5zaWdu
ZWQgc2hvcnQgZHJpdmVyX2J1aWxkX2hpZ2g7CisJdW5zaWduZWQgc2hvcnQgZHJpdmVyX3NybF9s
b3c7CisJdW5zaWduZWQgc2hvcnQgZHJpdmVyX2JyYW5jaF9sb3c7CisJdW5zaWduZWQgc2hvcnQg
ZHJpdmVyX2J1aWxkX2xvdzsKKwl1bnNpZ25lZCBzaG9ydCBmd19vbl9jdGxyX3NybDsKKwl1bnNp
Z25lZCBzaG9ydCBmd19vbl9jdGxyX2JyYW5jaDsKKwl1bnNpZ25lZCBzaG9ydCBmd19vbl9jdGxy
X2J1aWxkOworfSBUV19Db21wYXRpYmlsaXR5X0luZm87CisKKyNwcmFnbWEgcGFjaygpCisKK3R5
cGVkZWYgc3RydWN0IFRBR19UV19EZXZpY2VfRXh0ZW5zaW9uIHsKKwl2b2lkICAgICAgICAgICAg
ICAgICAgICAgX19pb21lbSAqYmFzZV9hZGRyOworCXVuc2lnbmVkIGxvbmcJICAgICAgIAkqZ2Vu
ZXJpY19idWZmZXJfdmlydFtUV19RX0xFTkdUSF07CisJZG1hX2FkZHJfdAkgICAgICAgCWdlbmVy
aWNfYnVmZmVyX3BoeXNbVFdfUV9MRU5HVEhdOworCVRXX0NvbW1hbmRfRnVsbAkgICAgICAgCSpj
b21tYW5kX3BhY2tldF92aXJ0W1RXX1FfTEVOR1RIXTsKKwlkbWFfYWRkcl90CQljb21tYW5kX3Bh
Y2tldF9waHlzW1RXX1FfTEVOR1RIXTsKKwlUV19Db21tYW5kX0FwYWNoZV9IZWFkZXIgKnNlbnNl
X2J1ZmZlcl92aXJ0W1RXX1FfTEVOR1RIXTsKKwlkbWFfYWRkcl90CQlzZW5zZV9idWZmZXJfcGh5
c1tUV19RX0xFTkdUSF07CisJc3RydWN0IHBjaV9kZXYJCSp0d19wY2lfZGV2OworCXN0cnVjdCBz
Y3NpX2NtbmQJKnNyYltUV19RX0xFTkdUSF07CisJdW5zaWduZWQgY2hhcgkJZnJlZV9xdWV1ZVtU
V19RX0xFTkdUSF07CisJdW5zaWduZWQgY2hhcgkJZnJlZV9oZWFkOworCXVuc2lnbmVkIGNoYXIJ
CWZyZWVfdGFpbDsKKwlpbnQgICAgIAkJc3RhdGVbVFdfUV9MRU5HVEhdOworCXVuc2lnbmVkIGlu
dAkJcG9zdGVkX3JlcXVlc3RfY291bnQ7CisJdW5zaWduZWQgaW50CQltYXhfcG9zdGVkX3JlcXVl
c3RfY291bnQ7CisJdW5zaWduZWQgaW50CQltYXhfc2dsX2VudHJpZXM7CisJdW5zaWduZWQgaW50
CQlzZ2xfZW50cmllczsKKwl1bnNpZ25lZCBpbnQJCW51bV9yZXNldHM7CisJdW5zaWduZWQgaW50
CQlzZWN0b3JfY291bnQ7CisJdW5zaWduZWQgaW50CQltYXhfc2VjdG9yX2NvdW50OworCXVuc2ln
bmVkIGludAkJYWVuX2NvdW50OworCXN0cnVjdCBTY3NpX0hvc3QJKmhvc3Q7CisJbG9uZwkJCWZs
YWdzOworCVRXX0V2ZW50ICAgICAgICAgICAgICAgICpldmVudF9xdWV1ZVtUV19RX0xFTkdUSF07
CisJdW5zaWduZWQgY2hhciAgICAgICAgICAgZXJyb3JfaW5kZXg7CisJdW5zaWduZWQgaW50ICAg
ICAgICAgICAgZXJyb3Jfc2VxdWVuY2VfaWQ7CisJaW50CQkJY2hyZGV2X3JlcXVlc3RfaWQ7CisJ
d2FpdF9xdWV1ZV9oZWFkX3QJaW9jdGxfd3F1ZXVlOworCXN0cnVjdCBtdXRleAkJaW9jdGxfbG9j
azsKKwlUV19Db21wYXRpYmlsaXR5X0luZm8JdHdfY29tcGF0X2luZm87CisJY2hhcgkJCW9ubGlu
ZTsKK30gVFdfRGV2aWNlX0V4dGVuc2lvbjsKKworI2VuZGlmIC8qIF8zV19TQVNfSCAqLworCmRp
ZmYgLU5hdXIgbGludXgtMi42LjMyLXJjNS1naXQxL2RyaXZlcnMvc2NzaS9LY29uZmlnIGxpbnV4
LTIuNi4zMi1yYzUtZ2l0MS5uZXcvZHJpdmVycy9zY3NpL0tjb25maWcKLS0tIGxpbnV4LTIuNi4z
Mi1yYzUtZ2l0MS9kcml2ZXJzL3Njc2kvS2NvbmZpZwkyMDA5LTEwLTE1IDE3OjQxOjUwLjAwMDAw
MDAwMCAtMDcwMAorKysgbGludXgtMi42LjMyLXJjNS1naXQxLm5ldy9kcml2ZXJzL3Njc2kvS2Nv
bmZpZwkyMDA5LTEwLTIzIDE0OjI3OjMxLjAwMDAwMDAwMCAtMDcwMApAQCAtMzk5LDYgKzM5OSwx
NyBAQAogCSAgUGxlYXNlIHJlYWQgdGhlIGNvbW1lbnRzIGF0IHRoZSB0b3Agb2YKIAkgIDxmaWxl
OmRyaXZlcnMvc2NzaS8zdy05eHh4LmM+LgogCitjb25maWcgU0NTSV8zV19TQVMKKwl0cmlzdGF0
ZSAiM3dhcmUgOTd4eCBTQVMvU0FUQS1SQUlEIHN1cHBvcnQiCisJZGVwZW5kcyBvbiBQQ0kgJiYg
U0NTSQorCWhlbHAKKwkgIFRoaXMgZHJpdmVyIHN1cHBvcnRzIHRoZSBMU0kgM3dhcmUgOTc1MCA2
R2IvcyBTQVMvU0FUQS1SQUlEIGNhcmRzLgorCisJICA8aHR0cDovL3d3dy5sc2kuY29tPgorCisJ
ICBQbGVhc2UgcmVhZCB0aGUgY29tbWVudHMgYXQgdGhlIHRvcCBvZgorCSAgPGZpbGU6ZHJpdmVy
cy9zY3NpLzN3LXNhcy5jPi4KKwogY29uZmlnIFNDU0lfNzAwMEZBU1NUCiAJdHJpc3RhdGUgIjcw
MDBGQVNTVCBTQ1NJIHN1cHBvcnQiCiAJZGVwZW5kcyBvbiBJU0EgJiYgU0NTSSAmJiBJU0FfRE1B
X0FQSQpkaWZmIC1OYXVyIGxpbnV4LTIuNi4zMi1yYzUtZ2l0MS9kcml2ZXJzL3Njc2kvTWFrZWZp
bGUgbGludXgtMi42LjMyLXJjNS1naXQxLm5ldy9kcml2ZXJzL3Njc2kvTWFrZWZpbGUKLS0tIGxp
bnV4LTIuNi4zMi1yYzUtZ2l0MS9kcml2ZXJzL3Njc2kvTWFrZWZpbGUJMjAwOS0xMC0xNSAxNzo0
MTo1MC4wMDAwMDAwMDAgLTA3MDAKKysrIGxpbnV4LTIuNi4zMi1yYzUtZ2l0MS5uZXcvZHJpdmVy
cy9zY3NpL01ha2VmaWxlCTIwMDktMTAtMjMgMTQ6Mjc6MjUuMDAwMDAwMDAwIC0wNzAwCkBAIC0x
MTMsNiArMTEzLDcgQEAKIG9iai0kKENPTkZJR19TQ1NJX01BQzUzQzk0KQkrPSBtYWM1M2M5NC5v
CiBvYmotJChDT05GSUdfQkxLX0RFVl8zV19YWFhYX1JBSUQpICs9IDN3LXh4eHgubwogb2JqLSQo
Q09ORklHX1NDU0lfM1dfOVhYWCkJKz0gM3ctOXh4eC5vCitvYmotJChDT05GSUdfU0NTSV8zV19T
QVMpCSs9IDN3LXNhcy5vCiBvYmotJChDT05GSUdfU0NTSV9QUEEpCQkrPSBwcGEubwogb2JqLSQo
Q09ORklHX1NDU0lfSU1NKQkJKz0gaW1tLm8KIG9iai0kKENPTkZJR19KQVpaX0VTUCkJCSs9IGVz
cF9zY3NpLm8JamF6el9lc3Aubwo=
--000e0cd66c88ae1e7f0476a13a1e--
