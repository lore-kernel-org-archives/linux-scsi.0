From: adam radford <aradford@gmail.com>
Subject: [PATCH] Add new driver for LSI 3ware 9750
Date: Tue, 20 Oct 2009 17:22:15 -0700
Message-ID: <b1bc6a000910201722v28d895cbv25e4959473ff215d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=000e0cd6b3ae8ae505047666f875
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:51213 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbZJUAWL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2009 20:22:11 -0400
Received: by ywh40 with SMTP id 40so4058864ywh.33
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2009 17:22:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

--000e0cd6b3ae8ae505047666f875
Content-Type: text/plain; charset=ISO-8859-1

James, linux-scsi,

This patch adds a new driver '3w-sas' for the LSI 3ware 9750 6Gb/s
SAS/SATA-RAID controllers.

- I have tested this code to work on 32-bit, 64-bit, PAE, PPC-64.
- This code contains a legacy interface that works with open-source
smartmontools software at
  http://sourceforge.net/projects/smartmontools.

Signed-off-by: Adam Radford <aradford@gmail.com>

-Adam

Note: This patch is included in-line below and also as an attachment
(in case vger truncates the 2363 line
patch).

diff -Naur linux-2.6.32-rc5-git1/drivers/scsi/3w-sas.c
linux-2.6.32-rc5-git1.new/drivers/scsi/3w-sas.c
--- linux-2.6.32-rc5-git1/drivers/scsi/3w-sas.c	1969-12-31
16:00:00.000000000 -0800
+++ linux-2.6.32-rc5-git1.new/drivers/scsi/3w-sas.c	2009-10-19
17:07:42.000000000 -0700
@@ -0,0 +1,1927 @@
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
+static int use_msi = 0;
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
+		newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle +
sizeof(TW_Ioctl_Buf_Apache) - 1);
+		newcommand->sg_list[0].length = TW_CPU_TO_SGL(length);
+		newcommand->sgl_entries__lunh =
+			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->sgl_entries__lunh), 1));
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
+	int heads, sectors, cylinders;
+	TW_Device_Extension *tw_dev;
+
+	tw_dev = (TW_Device_Extension *)sdev->host->hostdata;
+
+	if (capacity >= 0x200000) {
+		heads = 255;
+		sectors = 63;
+		cylinders = sector_div(capacity, heads * sectors);
+	} else {
+		heads = 64;
+		sectors = 32;
+		cylinders = sector_div(capacity, heads * sectors);
+	}
+
+	geom[0] = heads;
+	geom[1] = sectors;
+	geom[2] = cylinders;
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
+	resource_size_t mem_addr, mem_len;
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
+	tw_dev = (TW_Device_Extension *)host->hostdata;
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
+	/* Use region 1 */
+	mem_addr = pci_resource_start(pdev, 1);
+	mem_len = pci_resource_len(pdev, 1);
+
+	/* Save base address */
+	tw_dev->base_addr = ioremap(mem_addr, mem_len);
+
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
+	       (u64)mem_addr, pdev->irq);
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
+	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9750,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
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
+	printk(KERN_WARNING "LSI 3ware SAS/SATA-RAID Controller device
driver for Linux v%s.\n", TW_DRIVER_VERSION);
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
+++ linux-2.6.32-rc5-git1.new/drivers/scsi/3w-sas.h	2009-10-19
17:07:44.000000000 -0700
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
+	"None", "ERROR", "WARNING", "INFO", "DEBUG", (char*) 0
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
+++ linux-2.6.32-rc5-git1.new/drivers/scsi/Kconfig	2009-10-19
17:13:59.000000000 -0700
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
+++ linux-2.6.32-rc5-git1.new/drivers/scsi/Makefile	2009-10-19
17:08:30.000000000 -0700
@@ -113,6 +113,7 @@
 obj-$(CONFIG_SCSI_MAC53C94)	+= mac53c94.o
 obj-$(CONFIG_BLK_DEV_3W_XXXX_RAID) += 3w-xxxx.o
 obj-$(CONFIG_SCSI_3W_9XXX)	+= 3w-9xxx.o
+obj-$(CONFIG_SCSI_3W_SAS)	+= 3w-sas.o
 obj-$(CONFIG_SCSI_PPA)		+= ppa.o
 obj-$(CONFIG_SCSI_IMM)		+= imm.o
 obj-$(CONFIG_JAZZ_ESP)		+= esp_scsi.o	jazz_esp.o

--000e0cd6b3ae8ae505047666f875
Content-Type: application/octet-stream;
	name="3ware_linux_2.6.32-rc5-git1.patch"
Content-Disposition: attachment;
	filename="3ware_linux_2.6.32-rc5-git1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g11c67qt0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzItcmM1LWdpdDEvZHJpdmVycy9zY3NpLzN3LXNhcy5jIGxp
bnV4LTIuNi4zMi1yYzUtZ2l0MS5uZXcvZHJpdmVycy9zY3NpLzN3LXNhcy5jCi0tLSBsaW51eC0y
LjYuMzItcmM1LWdpdDEvZHJpdmVycy9zY3NpLzN3LXNhcy5jCTE5NjktMTItMzEgMTY6MDA6MDAu
MDAwMDAwMDAwIC0wODAwCisrKyBsaW51eC0yLjYuMzItcmM1LWdpdDEubmV3L2RyaXZlcnMvc2Nz
aS8zdy1zYXMuYwkyMDA5LTEwLTE5IDE3OjA3OjQyLjAwMDAwMDAwMCAtMDcwMApAQCAtMCwwICsx
LDE5MjcgQEAKKy8qCisgICAzdy1zYXMuYyAtLSBMU0kgM3dhcmUgU0FTL1NBVEEtUkFJRCBDb250
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
dGF0aWMgaW50IHVzZV9tc2kgPSAwOworbW9kdWxlX3BhcmFtKHVzZV9tc2ksIGludCwgU19JUlVH
Tyk7CitNT0RVTEVfUEFSTV9ERVNDKHVzZV9tc2ksICJVc2UgTWVzc2FnZSBTaWduYWxlZCBJbnRl
cnJ1cHRzLiBEZWZhdWx0OiAwIik7CisKKy8qIEZ1bmN0aW9uIHByb3RvdHlwZXMgKi8KK3N0YXRp
YyBpbnQgdHdsX3Jlc2V0X2RldmljZV9leHRlbnNpb24oVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdf
ZGV2LCBpbnQgaW9jdGxfcmVzZXQpOworCisvKiBGdW5jdGlvbnMgKi8KKworLyogVGhpcyBmdW5j
dGlvbiByZXR1cm5zIEFFTnMgdGhyb3VnaCBzeXNmcyAqLworc3RhdGljIHNzaXplX3QgdHdsX3N5
c2ZzX2Flbl9yZWFkKHN0cnVjdCBrb2JqZWN0ICprb2JqLAorCQkJCSAgc3RydWN0IGJpbl9hdHRy
aWJ1dGUgKmJpbl9hdHRyLAorCQkJCSAgY2hhciAqb3V0YnVmLCBsb2ZmX3Qgb2Zmc2V0LCBzaXpl
X3QgY291bnQpCit7CisJc3RydWN0IGRldmljZSAqZGV2ID0gY29udGFpbmVyX29mKGtvYmosIHN0
cnVjdCBkZXZpY2UsIGtvYmopOworCXN0cnVjdCBTY3NpX0hvc3QgKnNob3N0ID0gY2xhc3NfdG9f
c2hvc3QoZGV2KTsKKwlUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYgPSAoVFdfRGV2aWNlX0V4
dGVuc2lvbiAqKXNob3N0LT5ob3N0ZGF0YTsKKwl1bnNpZ25lZCBsb25nIGZsYWdzID0gMDsKKwlz
c2l6ZV90IHJldDsKKworCWlmICghY2FwYWJsZShDQVBfU1lTX0FETUlOKSkKKwkJcmV0dXJuIC1F
QUNDRVM7CisKKwlzcGluX2xvY2tfaXJxc2F2ZSh0d19kZXYtPmhvc3QtPmhvc3RfbG9jaywgZmxh
Z3MpOworCXJldCA9IG1lbW9yeV9yZWFkX2Zyb21fYnVmZmVyKG91dGJ1ZiwgY291bnQsICZvZmZz
ZXQsIHR3X2Rldi0+ZXZlbnRfcXVldWVbMF0sIHNpemVvZihUV19FdmVudCkgKiBUV19RX0xFTkdU
SCk7CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSh0d19kZXYtPmhvc3QtPmhvc3RfbG9jaywgZmxh
Z3MpOworCisJcmV0dXJuIHJldDsKK30gLyogRW5kIHR3bF9zeXNmc19hZW5fcmVhZCgpICovCisK
Ky8qIGFlbl9yZWFkIHN5c2ZzIGF0dHJpYnV0ZSBpbml0aWFsaXplciAqLworc3RhdGljIHN0cnVj
dCBiaW5fYXR0cmlidXRlIHR3bF9zeXNmc19hZW5fcmVhZF9hdHRyID0geworCS5hdHRyID0gewor
CQkubmFtZSA9ICIzd2FyZV9hZW5fcmVhZCIsCisJCS5tb2RlID0gU19JUlVTUiwKKwl9LCAKKwku
c2l6ZSA9IDAsCisJLnJlYWQgPSB0d2xfc3lzZnNfYWVuX3JlYWQKK307CisKKy8qIFRoaXMgZnVu
Y3Rpb24gcmV0dXJucyBkcml2ZXIgY29tcGF0aWJpbGl0eSBpbmZvIHRocm91Z2ggc3lzZnMgKi8K
K3N0YXRpYyBzc2l6ZV90IHR3bF9zeXNmc19jb21wYXRfaW5mbyhzdHJ1Y3Qga29iamVjdCAqa29i
aiwKKwkJCQkgICAgIHN0cnVjdCBiaW5fYXR0cmlidXRlICpiaW5fYXR0ciwKKwkJCQkgICAgIGNo
YXIgKm91dGJ1ZiwgbG9mZl90IG9mZnNldCwgc2l6ZV90IGNvdW50KQoreworCXN0cnVjdCBkZXZp
Y2UgKmRldiA9IGNvbnRhaW5lcl9vZihrb2JqLCBzdHJ1Y3QgZGV2aWNlLCBrb2JqKTsKKwlzdHJ1
Y3QgU2NzaV9Ib3N0ICpzaG9zdCA9IGNsYXNzX3RvX3Nob3N0KGRldik7CisJVFdfRGV2aWNlX0V4
dGVuc2lvbiAqdHdfZGV2ID0gKFRXX0RldmljZV9FeHRlbnNpb24gKilzaG9zdC0+aG9zdGRhdGE7
CisJdW5zaWduZWQgbG9uZyBmbGFncyA9IDA7CisJc3NpemVfdCByZXQ7CisKKwlpZiAoIWNhcGFi
bGUoQ0FQX1NZU19BRE1JTikpCisJCXJldHVybiAtRUFDQ0VTOworCisJc3Bpbl9sb2NrX2lycXNh
dmUodHdfZGV2LT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKKwlyZXQgPSBtZW1vcnlfcmVhZF9m
cm9tX2J1ZmZlcihvdXRidWYsIGNvdW50LCAmb2Zmc2V0LCAmdHdfZGV2LT50d19jb21wYXRfaW5m
bywgc2l6ZW9mKFRXX0NvbXBhdGliaWxpdHlfSW5mbykpOworCXNwaW5fdW5sb2NrX2lycXJlc3Rv
cmUodHdfZGV2LT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKKworCXJldHVybiByZXQ7Cit9IC8q
IEVuZCB0d2xfc3lzZnNfY29tcGF0X2luZm8oKSAqLworCisvKiBjb21wYXRfaW5mbyBzeXNmcyBh
dHRyaWJ1dGUgaW5pdGlhbGl6ZXIgKi8KK3N0YXRpYyBzdHJ1Y3QgYmluX2F0dHJpYnV0ZSB0d2xf
c3lzZnNfY29tcGF0X2luZm9fYXR0ciA9IHsKKwkuYXR0ciA9IHsKKwkJLm5hbWUgPSAiM3dhcmVf
Y29tcGF0X2luZm8iLAorCQkubW9kZSA9IFNfSVJVU1IsCisJfSwgCisJLnNpemUgPSAwLAorCS5y
ZWFkID0gdHdsX3N5c2ZzX2NvbXBhdF9pbmZvCit9OworCisvKiBTaG93IHNvbWUgc3RhdGlzdGlj
cyBhYm91dCB0aGUgY2FyZCAqLworc3RhdGljIHNzaXplX3QgdHdsX3Nob3dfc3RhdHMoc3RydWN0
IGRldmljZSAqZGV2LAorCQkJICAgICAgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsIGNo
YXIgKmJ1ZikKK3sKKwlzdHJ1Y3QgU2NzaV9Ib3N0ICpob3N0ID0gY2xhc3NfdG9fc2hvc3QoZGV2
KTsKKwlUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYgPSAoVFdfRGV2aWNlX0V4dGVuc2lvbiAq
KWhvc3QtPmhvc3RkYXRhOworCXVuc2lnbmVkIGxvbmcgZmxhZ3MgPSAwOworCXNzaXplX3QgbGVu
OworCisJc3Bpbl9sb2NrX2lycXNhdmUodHdfZGV2LT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsK
KwlsZW4gPSBzbnByaW50ZihidWYsIFBBR0VfU0laRSwgIjN3LXNhcyBEcml2ZXIgdmVyc2lvbjog
JXNcbiIKKwkJICAgICAgICJDdXJyZW50IGNvbW1hbmRzIHBvc3RlZDogICAlNGRcbiIKKwkJICAg
ICAgICJNYXggY29tbWFuZHMgcG9zdGVkOiAgICAgICAlNGRcbiIKKwkJICAgICAgICJMYXN0IHNn
bCBsZW5ndGg6ICAgICAgICAgICAlNGRcbiIKKwkJICAgICAgICJNYXggc2dsIGxlbmd0aDogICAg
ICAgICAgICAlNGRcbiIKKwkJICAgICAgICJMYXN0IHNlY3RvciBjb3VudDogICAgICAgICAlNGRc
biIKKwkJICAgICAgICJNYXggc2VjdG9yIGNvdW50OiAgICAgICAgICAlNGRcbiIKKwkJICAgICAg
ICJTQ1NJIEhvc3QgUmVzZXRzOiAgICAgICAgICAlNGRcbiIKKwkJICAgICAgICJBRU4nczogICAg
ICAgICAgICAgICAgICAgICAlNGRcbiIsIAorCQkgICAgICAgVFdfRFJJVkVSX1ZFUlNJT04sCisJ
CSAgICAgICB0d19kZXYtPnBvc3RlZF9yZXF1ZXN0X2NvdW50LAorCQkgICAgICAgdHdfZGV2LT5t
YXhfcG9zdGVkX3JlcXVlc3RfY291bnQsCisJCSAgICAgICB0d19kZXYtPnNnbF9lbnRyaWVzLAor
CQkgICAgICAgdHdfZGV2LT5tYXhfc2dsX2VudHJpZXMsCisJCSAgICAgICB0d19kZXYtPnNlY3Rv
cl9jb3VudCwKKwkJICAgICAgIHR3X2Rldi0+bWF4X3NlY3Rvcl9jb3VudCwKKwkJICAgICAgIHR3
X2Rldi0+bnVtX3Jlc2V0cywKKwkJICAgICAgIHR3X2Rldi0+YWVuX2NvdW50KTsKKwlzcGluX3Vu
bG9ja19pcnFyZXN0b3JlKHR3X2Rldi0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7CisJcmV0dXJu
IGxlbjsKK30gLyogRW5kIHR3bF9zaG93X3N0YXRzKCkgKi8KKworLyogVGhpcyBmdW5jdGlvbiB3
aWxsIHNldCBhIGRldmljZXMgcXVldWUgZGVwdGggKi8KK3N0YXRpYyBpbnQgdHdsX2NoYW5nZV9x
dWV1ZV9kZXB0aChzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYsIGludCBxdWV1ZV9kZXB0aCkKK3sK
KwlpZiAocXVldWVfZGVwdGggPiBUV19RX0xFTkdUSC0yKQorCQlxdWV1ZV9kZXB0aCA9IFRXX1Ff
TEVOR1RILTI7CisJc2NzaV9hZGp1c3RfcXVldWVfZGVwdGgoc2RldiwgTVNHX09SREVSRURfVEFH
LCBxdWV1ZV9kZXB0aCk7CisJcmV0dXJuIHF1ZXVlX2RlcHRoOworfSAvKiBFbmQgdHdsX2NoYW5n
ZV9xdWV1ZV9kZXB0aCgpICovCisKKy8qIHN0YXRzIHN5c2ZzIGF0dHJpYnV0ZSBpbml0aWFsaXpl
ciAqLworc3RhdGljIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlIHR3bF9ob3N0X3N0YXRzX2F0dHIg
PSB7CisJLmF0dHIgPSB7CisJCS5uYW1lID0gCSIzd2FyZV9zdGF0cyIsCisJCS5tb2RlID0JCVNf
SVJVR08sCisJfSwKKwkuc2hvdyA9IHR3bF9zaG93X3N0YXRzCit9OworCisvKiBIb3N0IGF0dHJp
YnV0ZXMgaW5pdGlhbGl6ZXIgKi8KK3N0YXRpYyBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqdHds
X2hvc3RfYXR0cnNbXSA9IHsKKwkmdHdsX2hvc3Rfc3RhdHNfYXR0ciwKKwlOVUxMLAorfTsKKwor
LyogVGhpcyBmdW5jdGlvbiB3aWxsIGxvb2sgdXAgYW4gQUVOIHNldmVyaXR5IHN0cmluZyAqLwor
c3RhdGljIGNoYXIgKnR3bF9hZW5fc2V2ZXJpdHlfbG9va3VwKHVuc2lnbmVkIGNoYXIgc2V2ZXJp
dHlfY29kZSkKK3sKKwljaGFyICpyZXR2YWwgPSBOVUxMOworCisJaWYgKChzZXZlcml0eV9jb2Rl
IDwgKHVuc2lnbmVkIGNoYXIpIFRXX0FFTl9TRVZFUklUWV9FUlJPUikgfHwKKwkgICAgKHNldmVy
aXR5X2NvZGUgPiAodW5zaWduZWQgY2hhcikgVFdfQUVOX1NFVkVSSVRZX0RFQlVHKSkKKwkJZ290
byBvdXQ7CisKKwlyZXR2YWwgPSB0d2xfYWVuX3NldmVyaXR5X3RhYmxlW3NldmVyaXR5X2NvZGVd
Oworb3V0OgorCXJldHVybiByZXR2YWw7Cit9IC8qIEVuZCB0d2xfYWVuX3NldmVyaXR5X2xvb2t1
cCgpICovCisKKy8qIFRoaXMgZnVuY3Rpb24gd2lsbCBxdWV1ZSBhbiBldmVudCAqLworc3RhdGlj
IHZvaWQgdHdsX2Flbl9xdWV1ZV9ldmVudChUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYsIFRX
X0NvbW1hbmRfQXBhY2hlX0hlYWRlciAqaGVhZGVyKQoreworCXUzMiBsb2NhbF90aW1lOworCXN0
cnVjdCB0aW1ldmFsIHRpbWU7CisJVFdfRXZlbnQgKmV2ZW50OworCXVuc2lnbmVkIHNob3J0IGFl
bjsKKwljaGFyIGhvc3RbMTZdOworCWNoYXIgKmVycm9yX3N0cjsKKworCXR3X2Rldi0+YWVuX2Nv
dW50Kys7CisKKwkvKiBGaWxsIG91dCBldmVudCBpbmZvICovCisJZXZlbnQgPSB0d19kZXYtPmV2
ZW50X3F1ZXVlW3R3X2Rldi0+ZXJyb3JfaW5kZXhdOworCisJaG9zdFswXSA9ICdcMCc7CisJaWYg
KHR3X2Rldi0+aG9zdCkKKwkJc3ByaW50Zihob3N0LCAiIHNjc2klZDoiLCB0d19kZXYtPmhvc3Qt
Pmhvc3Rfbm8pOworCisJYWVuID0gbGUxNl90b19jcHUoaGVhZGVyLT5zdGF0dXNfYmxvY2suZXJy
b3IpOworCW1lbXNldChldmVudCwgMCwgc2l6ZW9mKFRXX0V2ZW50KSk7CisKKwlldmVudC0+c2V2
ZXJpdHkgPSBUV19TRVZfT1VUKGhlYWRlci0+c3RhdHVzX2Jsb2NrLnNldmVyaXR5X19yZXNlcnZl
ZCk7CisJZG9fZ2V0dGltZW9mZGF5KCZ0aW1lKTsKKwlsb2NhbF90aW1lID0gKHUzMikodGltZS50
dl9zZWMgLSAoc3lzX3R6LnR6X21pbnV0ZXN3ZXN0ICogNjApKTsKKwlldmVudC0+dGltZV9zdGFt
cF9zZWMgPSBsb2NhbF90aW1lOworCWV2ZW50LT5hZW5fY29kZSA9IGFlbjsKKwlldmVudC0+cmV0
cmlldmVkID0gVFdfQUVOX05PVF9SRVRSSUVWRUQ7CisJZXZlbnQtPnNlcXVlbmNlX2lkID0gdHdf
ZGV2LT5lcnJvcl9zZXF1ZW5jZV9pZDsKKwl0d19kZXYtPmVycm9yX3NlcXVlbmNlX2lkKys7CisK
KwkvKiBDaGVjayBmb3IgZW1iZWRkZWQgZXJyb3Igc3RyaW5nICovCisJZXJyb3Jfc3RyID0gJiho
ZWFkZXItPmVycl9zcGVjaWZpY19kZXNjW3N0cmxlbihoZWFkZXItPmVycl9zcGVjaWZpY19kZXNj
KSsxXSk7CisKKwloZWFkZXItPmVycl9zcGVjaWZpY19kZXNjW3NpemVvZihoZWFkZXItPmVycl9z
cGVjaWZpY19kZXNjKSAtIDFdID0gJ1wwJzsKKwlldmVudC0+cGFyYW1ldGVyX2xlbiA9IHN0cmxl
bihoZWFkZXItPmVycl9zcGVjaWZpY19kZXNjKTsKKwltZW1jcHkoZXZlbnQtPnBhcmFtZXRlcl9k
YXRhLCBoZWFkZXItPmVycl9zcGVjaWZpY19kZXNjLCBldmVudC0+cGFyYW1ldGVyX2xlbiArIDEg
KyBzdHJsZW4oZXJyb3Jfc3RyKSk7CisJaWYgKGV2ZW50LT5zZXZlcml0eSAhPSBUV19BRU5fU0VW
RVJJVFlfREVCVUcpCisJCXByaW50ayhLRVJOX1dBUk5JTkcgIjN3LXNhczolcyBBRU46ICVzICgw
eCUwMlg6MHglMDRYKTogJXM6JXMuXG4iLAorCQkgICAgICAgaG9zdCwKKwkJICAgICAgIHR3bF9h
ZW5fc2V2ZXJpdHlfbG9va3VwKFRXX1NFVl9PVVQoaGVhZGVyLT5zdGF0dXNfYmxvY2suc2V2ZXJp
dHlfX3Jlc2VydmVkKSksCisJCSAgICAgICBUV19NRVNTQUdFX1NPVVJDRV9DT05UUk9MTEVSX0VW
RU5ULCBhZW4sIGVycm9yX3N0ciwKKwkJICAgICAgIGhlYWRlci0+ZXJyX3NwZWNpZmljX2Rlc2Mp
OworCWVsc2UKKwkJdHdfZGV2LT5hZW5fY291bnQtLTsKKworCXR3X2Rldi0+ZXJyb3JfaW5kZXgg
PSAodHdfZGV2LT5lcnJvcl9pbmRleCArIDEgKSAlIFRXX1FfTEVOR1RIOworfSAvKiBFbmQgdHds
X2Flbl9xdWV1ZV9ldmVudCgpICovCisKKy8qIFRoaXMgZnVuY3Rpb24gd2lsbCBhdHRlbXB0IHRv
IHBvc3QgYSBjb21tYW5kIHBhY2tldCB0byB0aGUgYm9hcmQgKi8KK3N0YXRpYyBpbnQgdHdsX3Bv
c3RfY29tbWFuZF9wYWNrZXQoVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2LCBpbnQgcmVxdWVz
dF9pZCkKK3sKKwlkbWFfYWRkcl90IGNvbW1hbmRfcXVlX3ZhbHVlOworCisJY29tbWFuZF9xdWVf
dmFsdWUgPSB0d19kZXYtPmNvbW1hbmRfcGFja2V0X3BoeXNbcmVxdWVzdF9pZF07CisJY29tbWFu
ZF9xdWVfdmFsdWUgKz0gVFdfQ09NTUFORF9PRkZTRVQ7CisKKwkvKiBGaXJzdCB3cml0ZSB1cHBl
ciA0IGJ5dGVzICovCisJd3JpdGVsKCh1MzIpKCh1NjQpY29tbWFuZF9xdWVfdmFsdWUgPj4gMzIp
LCBUV0xfSElCUVBIX1JFR19BRERSKHR3X2RldikpOworCS8qIFRoZW4gdGhlIGxvd2VyIDQgYnl0
ZXMgKi8KKwl3cml0ZWwoKHUzMikoY29tbWFuZF9xdWVfdmFsdWUgfCBUV0xfUFVMTF9NT0RFKSwg
VFdMX0hJQlFQTF9SRUdfQUREUih0d19kZXYpKTsKKworCXR3X2Rldi0+c3RhdGVbcmVxdWVzdF9p
ZF0gPSBUV19TX1BPU1RFRDsKKwl0d19kZXYtPnBvc3RlZF9yZXF1ZXN0X2NvdW50Kys7CisJaWYg
KHR3X2Rldi0+cG9zdGVkX3JlcXVlc3RfY291bnQgPiB0d19kZXYtPm1heF9wb3N0ZWRfcmVxdWVz
dF9jb3VudCkKKwkJdHdfZGV2LT5tYXhfcG9zdGVkX3JlcXVlc3RfY291bnQgPSB0d19kZXYtPnBv
c3RlZF9yZXF1ZXN0X2NvdW50OworCisJcmV0dXJuIDA7Cit9IC8qIEVuZCB0d2xfcG9zdF9jb21t
YW5kX3BhY2tldCgpICovCisKKy8qIFRoaXMgZnVuY3Rpb24gd2lsbCBwZXJmb3JtIGEgcGNpLWRt
YSBtYXBwaW5nIGZvciBhIHNjYXR0ZXIgZ2F0aGVyIGxpc3QgKi8KK3N0YXRpYyBpbnQgdHdsX21h
cF9zY3NpX3NnX2RhdGEoVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2LCBpbnQgcmVxdWVzdF9p
ZCkKK3sKKwlpbnQgdXNlX3NnOworCXN0cnVjdCBzY3NpX2NtbmQgKmNtZCA9IHR3X2Rldi0+c3Ji
W3JlcXVlc3RfaWRdOworCisJdXNlX3NnID0gc2NzaV9kbWFfbWFwKGNtZCk7CisJaWYgKCF1c2Vf
c2cpCisJCXJldHVybiAwOworCWVsc2UgaWYgKHVzZV9zZyA8IDApIHsKKwkJVFdfUFJJTlRLKHR3
X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAweDEsICJGYWlsZWQgdG8gbWFwIHNjYXR0ZXIgZ2F0aGVy
IGxpc3QiKTsKKwkJcmV0dXJuIDA7CisJfQorCisJY21kLT5TQ3AucGhhc2UgPSBUV19QSEFTRV9T
R0xJU1Q7CisJY21kLT5TQ3AuaGF2ZV9kYXRhX2luID0gdXNlX3NnOworCisJcmV0dXJuIHVzZV9z
ZzsKK30gLyogRW5kIHR3bF9tYXBfc2NzaV9zZ19kYXRhKCkgKi8KKworLyogVGhpcyBmdW5jdGlv
biBoYW5kcyBzY3NpIGNkYidzIHRvIHRoZSBmaXJtd2FyZSAqLworc3RhdGljIGludCB0d2xfc2Nz
aW9wX2V4ZWN1dGVfc2NzaShUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYsIGludCByZXF1ZXN0
X2lkLCBjaGFyICpjZGIsIGludCB1c2Vfc2csIFRXX1NHX0VudHJ5X0lTTyAqc2dsaXN0YXJnKQor
eworCVRXX0NvbW1hbmRfRnVsbCAqZnVsbF9jb21tYW5kX3BhY2tldDsKKwlUV19Db21tYW5kX0Fw
YWNoZSAqY29tbWFuZF9wYWNrZXQ7CisJaW50IGksIHNnX2NvdW50OworCXN0cnVjdCBzY3NpX2Nt
bmQgKnNyYiA9IE5VTEw7CisJc3RydWN0IHNjYXR0ZXJsaXN0ICpzZ2xpc3QgPSBOVUxMLCAqc2c7
CisJaW50IHJldHZhbCA9IDE7CisKKwlpZiAodHdfZGV2LT5zcmJbcmVxdWVzdF9pZF0pIHsKKwkJ
c3JiID0gdHdfZGV2LT5zcmJbcmVxdWVzdF9pZF07CisJCWlmIChzY3NpX3NnbGlzdChzcmIpKQor
CQkJc2dsaXN0ID0gc2NzaV9zZ2xpc3Qoc3JiKTsKKwl9CisKKwkvKiBJbml0aWFsaXplIGNvbW1h
bmQgcGFja2V0ICovCisJZnVsbF9jb21tYW5kX3BhY2tldCA9IHR3X2Rldi0+Y29tbWFuZF9wYWNr
ZXRfdmlydFtyZXF1ZXN0X2lkXTsKKwlmdWxsX2NvbW1hbmRfcGFja2V0LT5oZWFkZXIuaGVhZGVy
X2Rlc2Muc2l6ZV9oZWFkZXIgPSAxMjg7CisJZnVsbF9jb21tYW5kX3BhY2tldC0+aGVhZGVyLnN0
YXR1c19ibG9jay5lcnJvciA9IDA7CisJZnVsbF9jb21tYW5kX3BhY2tldC0+aGVhZGVyLnN0YXR1
c19ibG9jay5zZXZlcml0eV9fcmVzZXJ2ZWQgPSAwOworCisJY29tbWFuZF9wYWNrZXQgPSAmZnVs
bF9jb21tYW5kX3BhY2tldC0+Y29tbWFuZC5uZXdjb21tYW5kOworCWNvbW1hbmRfcGFja2V0LT5z
dGF0dXMgPSAwOworCWNvbW1hbmRfcGFja2V0LT5vcGNvZGVfX3Jlc2VydmVkID0gVFdfT1BSRVNf
SU4oMCwgVFdfT1BfRVhFQ1VURV9TQ1NJKTsKKworCS8qIFdlIGZvcmNlZCAxNiBieXRlIGNkYiB1
c2UgZWFybGllciAqLworCWlmICghY2RiKQorCQltZW1jcHkoY29tbWFuZF9wYWNrZXQtPmNkYiwg
c3JiLT5jbW5kLCBUV19NQVhfQ0RCX0xFTik7CisJZWxzZQorCQltZW1jcHkoY29tbWFuZF9wYWNr
ZXQtPmNkYiwgY2RiLCBUV19NQVhfQ0RCX0xFTik7CisKKwlpZiAoc3JiKSB7CisJCWNvbW1hbmRf
cGFja2V0LT51bml0ID0gc3JiLT5kZXZpY2UtPmlkOworCQljb21tYW5kX3BhY2tldC0+cmVxdWVz
dF9pZF9fbHVubCA9CisJCQljcHVfdG9fbGUxNihUV19SRVFfTFVOX0lOKHNyYi0+ZGV2aWNlLT5s
dW4sIHJlcXVlc3RfaWQpKTsKKwl9IGVsc2UgeworCQljb21tYW5kX3BhY2tldC0+cmVxdWVzdF9p
ZF9fbHVubCA9CisJCQljcHVfdG9fbGUxNihUV19SRVFfTFVOX0lOKDAsIHJlcXVlc3RfaWQpKTsK
KwkJY29tbWFuZF9wYWNrZXQtPnVuaXQgPSAwOworCX0KKworCWNvbW1hbmRfcGFja2V0LT5zZ2xf
b2Zmc2V0ID0gMTY7CisKKwlpZiAoIXNnbGlzdGFyZykgeworCQkvKiBNYXAgc2dsaXN0IGZyb20g
c2NzaSBsYXllciB0byBjbWQgcGFja2V0ICovCisJCWlmIChzY3NpX3NnX2NvdW50KHNyYikpIHsK
KwkJCXNnX2NvdW50ID0gdHdsX21hcF9zY3NpX3NnX2RhdGEodHdfZGV2LCByZXF1ZXN0X2lkKTsK
KwkJCWlmIChzZ19jb3VudCA9PSAwKQorCQkJCWdvdG8gb3V0OworCisJCQlzY3NpX2Zvcl9lYWNo
X3NnKHNyYiwgc2csIHNnX2NvdW50LCBpKSB7CisJCQkJY29tbWFuZF9wYWNrZXQtPnNnX2xpc3Rb
aV0uYWRkcmVzcyA9IFRXX0NQVV9UT19TR0woc2dfZG1hX2FkZHJlc3Moc2cpKTsKKwkJCQljb21t
YW5kX3BhY2tldC0+c2dfbGlzdFtpXS5sZW5ndGggPSBUV19DUFVfVE9fU0dMKHNnX2RtYV9sZW4o
c2cpKTsKKwkJCX0KKwkJCWNvbW1hbmRfcGFja2V0LT5zZ2xfZW50cmllc19fbHVuaCA9IGNwdV90
b19sZTE2KFRXX1JFUV9MVU5fSU4oKHNyYi0+ZGV2aWNlLT5sdW4gPj4gNCksIHNjc2lfc2dfY291
bnQodHdfZGV2LT5zcmJbcmVxdWVzdF9pZF0pKSk7CisJCX0KKwl9IGVsc2UgeworCQkvKiBJbnRl
cm5hbCBjZGIgcG9zdCAqLworCQlmb3IgKGkgPSAwOyBpIDwgdXNlX3NnOyBpKyspIHsKKwkJCWNv
bW1hbmRfcGFja2V0LT5zZ19saXN0W2ldLmFkZHJlc3MgPSBUV19DUFVfVE9fU0dMKHNnbGlzdGFy
Z1tpXS5hZGRyZXNzKTsKKwkJCWNvbW1hbmRfcGFja2V0LT5zZ19saXN0W2ldLmxlbmd0aCA9IFRX
X0NQVV9UT19TR0woc2dsaXN0YXJnW2ldLmxlbmd0aCk7CisJCX0KKwkJY29tbWFuZF9wYWNrZXQt
PnNnbF9lbnRyaWVzX19sdW5oID0gY3B1X3RvX2xlMTYoVFdfUkVRX0xVTl9JTigwLCB1c2Vfc2cp
KTsKKwl9CisKKwkvKiBVcGRhdGUgc29tZSBzdGF0cyAqLworCWlmIChzcmIpIHsKKwkJdHdfZGV2
LT5zZWN0b3JfY291bnQgPSBzY3NpX2J1ZmZsZW4oc3JiKSAvIDUxMjsKKwkJaWYgKHR3X2Rldi0+
c2VjdG9yX2NvdW50ID4gdHdfZGV2LT5tYXhfc2VjdG9yX2NvdW50KQorCQkJdHdfZGV2LT5tYXhf
c2VjdG9yX2NvdW50ID0gdHdfZGV2LT5zZWN0b3JfY291bnQ7CisJCXR3X2Rldi0+c2dsX2VudHJp
ZXMgPSBzY3NpX3NnX2NvdW50KHNyYik7CisJCWlmICh0d19kZXYtPnNnbF9lbnRyaWVzID4gdHdf
ZGV2LT5tYXhfc2dsX2VudHJpZXMpCisJCQl0d19kZXYtPm1heF9zZ2xfZW50cmllcyA9IHR3X2Rl
di0+c2dsX2VudHJpZXM7CisJfQorCisJLyogTm93IHBvc3QgdGhlIGNvbW1hbmQgdG8gdGhlIGJv
YXJkICovCisJcmV0dmFsID0gdHdsX3Bvc3RfY29tbWFuZF9wYWNrZXQodHdfZGV2LCByZXF1ZXN0
X2lkKTsKKworb3V0OgorCXJldHVybiByZXR2YWw7Cit9IC8qIEVuZCB0d2xfc2NzaW9wX2V4ZWN1
dGVfc2NzaSgpICovCisKKy8qIFRoaXMgZnVuY3Rpb24gd2lsbCByZWFkIHRoZSBhZW4gcXVldWUg
ZnJvbSB0aGUgaXNyICovCitzdGF0aWMgaW50IHR3bF9hZW5fcmVhZF9xdWV1ZShUV19EZXZpY2Vf
RXh0ZW5zaW9uICp0d19kZXYsIGludCByZXF1ZXN0X2lkKQoreworCWNoYXIgY2RiW1RXX01BWF9D
REJfTEVOXTsKKwlUV19TR19FbnRyeV9JU08gc2dsaXN0WzFdOworCVRXX0NvbW1hbmRfRnVsbCAq
ZnVsbF9jb21tYW5kX3BhY2tldDsKKwlpbnQgcmV0dmFsID0gMTsKKworCWZ1bGxfY29tbWFuZF9w
YWNrZXQgPSB0d19kZXYtPmNvbW1hbmRfcGFja2V0X3ZpcnRbcmVxdWVzdF9pZF07CisJbWVtc2V0
KGZ1bGxfY29tbWFuZF9wYWNrZXQsIDAsIHNpemVvZihUV19Db21tYW5kX0Z1bGwpKTsKKworCS8q
IEluaXRpYWxpemUgY2RiICovCisJbWVtc2V0KCZjZGIsIDAsIFRXX01BWF9DREJfTEVOKTsKKwlj
ZGJbMF0gPSBSRVFVRVNUX1NFTlNFOyAvKiBvcGNvZGUgKi8KKwljZGJbNF0gPSBUV19BTExPQ0FU
SU9OX0xFTkdUSDsgLyogYWxsb2NhdGlvbiBsZW5ndGggKi8KKworCS8qIEluaXRpYWxpemUgc2ds
aXN0ICovCisJbWVtc2V0KCZzZ2xpc3QsIDAsIHNpemVvZihUV19TR19FbnRyeV9JU08pKTsKKwlz
Z2xpc3RbMF0ubGVuZ3RoID0gVFdfU0VDVE9SX1NJWkU7CisJc2dsaXN0WzBdLmFkZHJlc3MgPSB0
d19kZXYtPmdlbmVyaWNfYnVmZmVyX3BoeXNbcmVxdWVzdF9pZF07CisKKwkvKiBNYXJrIGludGVy
bmFsIGNvbW1hbmQgKi8KKwl0d19kZXYtPnNyYltyZXF1ZXN0X2lkXSA9IE5VTEw7CisKKwkvKiBO
b3cgcG9zdCB0aGUgY29tbWFuZCBwYWNrZXQgKi8KKwlpZiAodHdsX3Njc2lvcF9leGVjdXRlX3Nj
c2kodHdfZGV2LCByZXF1ZXN0X2lkLCBjZGIsIDEsIHNnbGlzdCkpIHsKKwkJVFdfUFJJTlRLKHR3
X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAweDIsICJQb3N0IGZhaWxlZCB3aGlsZSByZWFkaW5nIEFF
TiBxdWV1ZSIpOworCQlnb3RvIG91dDsKKwl9CisJcmV0dmFsID0gMDsKK291dDoKKwlyZXR1cm4g
cmV0dmFsOworfSAvKiBFbmQgdHdsX2Flbl9yZWFkX3F1ZXVlKCkgKi8KKworLyogVGhpcyBmdW5j
dGlvbiB3aWxsIHN5bmMgZmlybXdhcmUgdGltZSB3aXRoIHRoZSBob3N0IHRpbWUgKi8KK3N0YXRp
YyB2b2lkIHR3bF9hZW5fc3luY190aW1lKFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldiwgaW50
IHJlcXVlc3RfaWQpCit7CisJdTMyIHNjaGVkdWxlcnRpbWU7CisJc3RydWN0IHRpbWV2YWwgdXRj
OworCVRXX0NvbW1hbmRfRnVsbCAqZnVsbF9jb21tYW5kX3BhY2tldDsKKwlUV19Db21tYW5kICpj
b21tYW5kX3BhY2tldDsKKwlUV19QYXJhbV9BcGFjaGUgKnBhcmFtOworCXUzMiBsb2NhbF90aW1l
OworCisJLyogRmlsbCBvdXQgdGhlIGNvbW1hbmQgcGFja2V0ICovCisJZnVsbF9jb21tYW5kX3Bh
Y2tldCA9IHR3X2Rldi0+Y29tbWFuZF9wYWNrZXRfdmlydFtyZXF1ZXN0X2lkXTsKKwltZW1zZXQo
ZnVsbF9jb21tYW5kX3BhY2tldCwgMCwgc2l6ZW9mKFRXX0NvbW1hbmRfRnVsbCkpOworCWNvbW1h
bmRfcGFja2V0ID0gJmZ1bGxfY29tbWFuZF9wYWNrZXQtPmNvbW1hbmQub2xkY29tbWFuZDsKKwlj
b21tYW5kX3BhY2tldC0+b3Bjb2RlX19zZ2xvZmZzZXQgPSBUV19PUFNHTF9JTigyLCBUV19PUF9T
RVRfUEFSQU0pOworCWNvbW1hbmRfcGFja2V0LT5yZXF1ZXN0X2lkID0gcmVxdWVzdF9pZDsKKwlj
b21tYW5kX3BhY2tldC0+Ynl0ZThfb2Zmc2V0LnBhcmFtLnNnbFswXS5hZGRyZXNzID0gVFdfQ1BV
X1RPX1NHTCh0d19kZXYtPmdlbmVyaWNfYnVmZmVyX3BoeXNbcmVxdWVzdF9pZF0pOworCWNvbW1h
bmRfcGFja2V0LT5ieXRlOF9vZmZzZXQucGFyYW0uc2dsWzBdLmxlbmd0aCA9IFRXX0NQVV9UT19T
R0woVFdfU0VDVE9SX1NJWkUpOworCWNvbW1hbmRfcGFja2V0LT5zaXplID0gVFdfQ09NTUFORF9T
SVpFOworCWNvbW1hbmRfcGFja2V0LT5ieXRlNl9vZmZzZXQucGFyYW1ldGVyX2NvdW50ID0gY3B1
X3RvX2xlMTYoMSk7CisKKwkvKiBTZXR1cCB0aGUgcGFyYW0gKi8KKwlwYXJhbSA9IChUV19QYXJh
bV9BcGFjaGUgKil0d19kZXYtPmdlbmVyaWNfYnVmZmVyX3ZpcnRbcmVxdWVzdF9pZF07CisJbWVt
c2V0KHBhcmFtLCAwLCBUV19TRUNUT1JfU0laRSk7CisJcGFyYW0tPnRhYmxlX2lkID0gY3B1X3Rv
X2xlMTYoVFdfVElNRUtFRVBfVEFCTEUgfCAweDgwMDApOyAvKiBDb250cm9sbGVyIHRpbWUga2Vl
cCB0YWJsZSAqLworCXBhcmFtLT5wYXJhbWV0ZXJfaWQgPSBjcHVfdG9fbGUxNigweDMpOyAvKiBT
Y2hlZHVsZXJUaW1lICovCisJcGFyYW0tPnBhcmFtZXRlcl9zaXplX2J5dGVzID0gY3B1X3RvX2xl
MTYoNCk7CisKKwkvKiBDb252ZXJ0IHN5c3RlbSB0aW1lIGluIFVUQyB0byBsb2NhbCB0aW1lIHNl
Y29uZHMgc2luY2UgbGFzdCAKKyAgICAgICAgICAgU3VuZGF5IDEyOjAwQU0gKi8KKwlkb19nZXR0
aW1lb2ZkYXkoJnV0Yyk7CisJbG9jYWxfdGltZSA9ICh1MzIpKHV0Yy50dl9zZWMgLSAoc3lzX3R6
LnR6X21pbnV0ZXN3ZXN0ICogNjApKTsKKwlzY2hlZHVsZXJ0aW1lID0gbG9jYWxfdGltZSAtICgz
ICogODY0MDApOworCXNjaGVkdWxlcnRpbWUgPSBjcHVfdG9fbGUzMihzY2hlZHVsZXJ0aW1lICUg
NjA0ODAwKTsKKworCW1lbWNweShwYXJhbS0+ZGF0YSwgJnNjaGVkdWxlcnRpbWUsIHNpemVvZih1
MzIpKTsKKworCS8qIE1hcmsgaW50ZXJuYWwgY29tbWFuZCAqLworCXR3X2Rldi0+c3JiW3JlcXVl
c3RfaWRdID0gTlVMTDsKKworCS8qIE5vdyBwb3N0IHRoZSBjb21tYW5kICovCisJdHdsX3Bvc3Rf
Y29tbWFuZF9wYWNrZXQodHdfZGV2LCByZXF1ZXN0X2lkKTsKK30gLyogRW5kIHR3bF9hZW5fc3lu
Y190aW1lKCkgKi8KKworLyogVGhpcyBmdW5jdGlvbiB3aWxsIGFzc2lnbiBhbiBhdmFpbGFibGUg
cmVxdWVzdCBpZCAqLworc3RhdGljIHZvaWQgdHdsX2dldF9yZXF1ZXN0X2lkKFRXX0RldmljZV9F
eHRlbnNpb24gKnR3X2RldiwgaW50ICpyZXF1ZXN0X2lkKQoreworCSpyZXF1ZXN0X2lkID0gdHdf
ZGV2LT5mcmVlX3F1ZXVlW3R3X2Rldi0+ZnJlZV9oZWFkXTsKKwl0d19kZXYtPmZyZWVfaGVhZCA9
ICh0d19kZXYtPmZyZWVfaGVhZCArIDEpICUgVFdfUV9MRU5HVEg7CisJdHdfZGV2LT5zdGF0ZVsq
cmVxdWVzdF9pZF0gPSBUV19TX1NUQVJURUQ7Cit9IC8qIEVuZCB0d2xfZ2V0X3JlcXVlc3RfaWQo
KSAqLworCisvKiBUaGlzIGZ1bmN0aW9uIHdpbGwgZnJlZSBhIHJlcXVlc3QgaWQgKi8KK3N0YXRp
YyB2b2lkIHR3bF9mcmVlX3JlcXVlc3RfaWQoVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2LCBp
bnQgcmVxdWVzdF9pZCkKK3sKKwl0d19kZXYtPmZyZWVfcXVldWVbdHdfZGV2LT5mcmVlX3RhaWxd
ID0gcmVxdWVzdF9pZDsKKwl0d19kZXYtPnN0YXRlW3JlcXVlc3RfaWRdID0gVFdfU19GSU5JU0hF
RDsKKwl0d19kZXYtPmZyZWVfdGFpbCA9ICh0d19kZXYtPmZyZWVfdGFpbCArIDEpICUgVFdfUV9M
RU5HVEg7Cit9IC8qIEVuZCB0d2xfZnJlZV9yZXF1ZXN0X2lkKCkgKi8KKworLyogVGhpcyBmdW5j
dGlvbiB3aWxsIGNvbXBsZXRlIGFuIGFlbiByZXF1ZXN0IGZyb20gdGhlIGlzciAqLworc3RhdGlj
IGludCB0d2xfYWVuX2NvbXBsZXRlKFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldiwgaW50IHJl
cXVlc3RfaWQpCit7CisJVFdfQ29tbWFuZF9GdWxsICpmdWxsX2NvbW1hbmRfcGFja2V0OworCVRX
X0NvbW1hbmQgKmNvbW1hbmRfcGFja2V0OworCVRXX0NvbW1hbmRfQXBhY2hlX0hlYWRlciAqaGVh
ZGVyOworCXVuc2lnbmVkIHNob3J0IGFlbjsKKwlpbnQgcmV0dmFsID0gMTsKKworCWhlYWRlciA9
IChUV19Db21tYW5kX0FwYWNoZV9IZWFkZXIgKil0d19kZXYtPmdlbmVyaWNfYnVmZmVyX3ZpcnRb
cmVxdWVzdF9pZF07CisJdHdfZGV2LT5wb3N0ZWRfcmVxdWVzdF9jb3VudC0tOworCWFlbiA9IGxl
MTZfdG9fY3B1KGhlYWRlci0+c3RhdHVzX2Jsb2NrLmVycm9yKTsKKwlmdWxsX2NvbW1hbmRfcGFj
a2V0ID0gdHdfZGV2LT5jb21tYW5kX3BhY2tldF92aXJ0W3JlcXVlc3RfaWRdOworCWNvbW1hbmRf
cGFja2V0ID0gJmZ1bGxfY29tbWFuZF9wYWNrZXQtPmNvbW1hbmQub2xkY29tbWFuZDsKKworCS8q
IEZpcnN0IGNoZWNrIGZvciBpbnRlcm5hbCBjb21wbGV0aW9uIG9mIHNldCBwYXJhbSBmb3IgdGlt
ZSBzeW5jICovCisJaWYgKFRXX09QX09VVChjb21tYW5kX3BhY2tldC0+b3Bjb2RlX19zZ2xvZmZz
ZXQpID09IFRXX09QX1NFVF9QQVJBTSkgeworCQkvKiBLZWVwIHJlYWRpbmcgdGhlIHF1ZXVlIGlu
IGNhc2UgdGhlcmUgYXJlIG1vcmUgYWVuJ3MgKi8KKwkJaWYgKHR3bF9hZW5fcmVhZF9xdWV1ZSh0
d19kZXYsIHJlcXVlc3RfaWQpKQorCQkJZ290byBvdXQyOworCSAgICAgICAgZWxzZSB7CisJCQly
ZXR2YWwgPSAwOworCQkJZ290byBvdXQ7CisJCX0KKwl9CisKKwlzd2l0Y2ggKGFlbikgeworCWNh
c2UgVFdfQUVOX1FVRVVFX0VNUFRZOgorCQkvKiBRdWl0IHJlYWRpbmcgdGhlIHF1ZXVlIGlmIHRo
aXMgaXMgdGhlIGxhc3Qgb25lICovCisJCWJyZWFrOworCWNhc2UgVFdfQUVOX1NZTkNfVElNRV9X
SVRIX0hPU1Q6CisJCXR3bF9hZW5fc3luY190aW1lKHR3X2RldiwgcmVxdWVzdF9pZCk7CisJCXJl
dHZhbCA9IDA7CisJCWdvdG8gb3V0OworCWRlZmF1bHQ6CisJCXR3bF9hZW5fcXVldWVfZXZlbnQo
dHdfZGV2LCBoZWFkZXIpOworCisJCS8qIElmIHRoZXJlIGFyZSBtb3JlIGFlbidzLCBrZWVwIHJl
YWRpbmcgdGhlIHF1ZXVlICovCisJCWlmICh0d2xfYWVuX3JlYWRfcXVldWUodHdfZGV2LCByZXF1
ZXN0X2lkKSkKKwkJCWdvdG8gb3V0MjsKKwkJZWxzZSB7CisJCQlyZXR2YWwgPSAwOworCQkJZ290
byBvdXQ7CisJCX0KKwl9CisJcmV0dmFsID0gMDsKK291dDI6CisJdHdfZGV2LT5zdGF0ZVtyZXF1
ZXN0X2lkXSA9IFRXX1NfQ09NUExFVEVEOworCXR3bF9mcmVlX3JlcXVlc3RfaWQodHdfZGV2LCBy
ZXF1ZXN0X2lkKTsKKwljbGVhcl9iaXQoVFdfSU5fQVRURU5USU9OX0xPT1AsICZ0d19kZXYtPmZs
YWdzKTsKK291dDoKKwlyZXR1cm4gcmV0dmFsOworfSAvKiBFbmQgdHdsX2Flbl9jb21wbGV0ZSgp
ICovCisKKy8qIFRoaXMgZnVuY3Rpb24gd2lsbCBwb2xsIGZvciBhIHJlc3BvbnNlICovCitzdGF0
aWMgaW50IHR3bF9wb2xsX3Jlc3BvbnNlKFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldiwgaW50
IHJlcXVlc3RfaWQsIGludCBzZWNvbmRzKQoreworCXVuc2lnbmVkIGxvbmcgYmVmb3JlOworCWRt
YV9hZGRyX3QgbWZhOworCXUzMiByZWdoLCByZWdsOworCXUzMiByZXNwb25zZTsKKwlpbnQgcmV0
dmFsID0gMTsKKwlpbnQgZm91bmQgPSAwOworCisJYmVmb3JlID0gamlmZmllczsKKworCXdoaWxl
ICghZm91bmQpIHsKKwkJaWYgKHNpemVvZihkbWFfYWRkcl90KSA+IDQpIHsKKwkJCXJlZ2ggPSBy
ZWFkbChUV0xfSE9CUVBIX1JFR19BRERSKHR3X2RldikpOworCQkJcmVnbCA9IHJlYWRsKFRXTF9I
T0JRUExfUkVHX0FERFIodHdfZGV2KSk7CisJCQltZmEgPSAoKHU2NClyZWdoIDw8IDMyKSB8IHJl
Z2w7CisJCX0gZWxzZQorCQkJbWZhID0gcmVhZGwoVFdMX0hPQlFQTF9SRUdfQUREUih0d19kZXYp
KTsKKworCQlyZXNwb25zZSA9ICh1MzIpbWZhOworCisJCWlmIChUV19SRVNJRF9PVVQocmVzcG9u
c2UpID09IHJlcXVlc3RfaWQpCisJCQlmb3VuZCA9IDE7CisKKwkJaWYgKHRpbWVfYWZ0ZXIoamlm
ZmllcywgYmVmb3JlICsgSFogKiBzZWNvbmRzKSkKKwkJCWdvdG8gb3V0OworCisJCW1zbGVlcCg1
MCk7CisJfQorCXJldHZhbCA9IDA7CitvdXQ6IAorCXJldHVybiByZXR2YWw7Cit9IC8qIEVuZCB0
d2xfcG9sbF9yZXNwb25zZSgpICovCisKKy8qIFRoaXMgZnVuY3Rpb24gd2lsbCBkcmFpbiB0aGUg
YWVuIHF1ZXVlICovCitzdGF0aWMgaW50IHR3bF9hZW5fZHJhaW5fcXVldWUoVFdfRGV2aWNlX0V4
dGVuc2lvbiAqdHdfZGV2LCBpbnQgbm9fY2hlY2tfcmVzZXQpCit7CisJaW50IHJlcXVlc3RfaWQg
PSAwOworCWNoYXIgY2RiW1RXX01BWF9DREJfTEVOXTsKKwlUV19TR19FbnRyeV9JU08gc2dsaXN0
WzFdOworCWludCBmaW5pc2hlZCA9IDAsIGNvdW50ID0gMDsKKwlUV19Db21tYW5kX0Z1bGwgKmZ1
bGxfY29tbWFuZF9wYWNrZXQ7CisJVFdfQ29tbWFuZF9BcGFjaGVfSGVhZGVyICpoZWFkZXI7CisJ
dW5zaWduZWQgc2hvcnQgYWVuOworCWludCBmaXJzdF9yZXNldCA9IDAsIHF1ZXVlID0gMCwgcmV0
dmFsID0gMTsKKworCWlmIChub19jaGVja19yZXNldCkKKwkJZmlyc3RfcmVzZXQgPSAwOworCWVs
c2UKKwkJZmlyc3RfcmVzZXQgPSAxOworCisJZnVsbF9jb21tYW5kX3BhY2tldCA9IHR3X2Rldi0+
Y29tbWFuZF9wYWNrZXRfdmlydFtyZXF1ZXN0X2lkXTsKKwltZW1zZXQoZnVsbF9jb21tYW5kX3Bh
Y2tldCwgMCwgc2l6ZW9mKFRXX0NvbW1hbmRfRnVsbCkpOworCisJLyogSW5pdGlhbGl6ZSBjZGIg
Ki8KKwltZW1zZXQoJmNkYiwgMCwgVFdfTUFYX0NEQl9MRU4pOworCWNkYlswXSA9IFJFUVVFU1Rf
U0VOU0U7IC8qIG9wY29kZSAqLworCWNkYls0XSA9IFRXX0FMTE9DQVRJT05fTEVOR1RIOyAvKiBh
bGxvY2F0aW9uIGxlbmd0aCAqLworCisJLyogSW5pdGlhbGl6ZSBzZ2xpc3QgKi8KKwltZW1zZXQo
JnNnbGlzdCwgMCwgc2l6ZW9mKFRXX1NHX0VudHJ5X0lTTykpOworCXNnbGlzdFswXS5sZW5ndGgg
PSBUV19TRUNUT1JfU0laRTsKKwlzZ2xpc3RbMF0uYWRkcmVzcyA9IHR3X2Rldi0+Z2VuZXJpY19i
dWZmZXJfcGh5c1tyZXF1ZXN0X2lkXTsKKworCS8qIE1hcmsgaW50ZXJuYWwgY29tbWFuZCAqLwor
CXR3X2Rldi0+c3JiW3JlcXVlc3RfaWRdID0gTlVMTDsKKworCWRvIHsKKwkJLyogU2VuZCBjb21t
YW5kIHRvIHRoZSBib2FyZCAqLworCQlpZiAodHdsX3Njc2lvcF9leGVjdXRlX3Njc2kodHdfZGV2
LCByZXF1ZXN0X2lkLCBjZGIsIDEsIHNnbGlzdCkpIHsKKwkJCVRXX1BSSU5USyh0d19kZXYtPmhv
c3QsIFRXX0RSSVZFUiwgMHgzLCAiRXJyb3IgcG9zdGluZyByZXF1ZXN0IHNlbnNlIik7CisJCQln
b3RvIG91dDsKKwkJfQorCisJCS8qIE5vdyBwb2xsIGZvciBjb21wbGV0aW9uICovCisJCWlmICh0
d2xfcG9sbF9yZXNwb25zZSh0d19kZXYsIHJlcXVlc3RfaWQsIDMwKSkgeworCQkJVFdfUFJJTlRL
KHR3X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAweDQsICJObyB2YWxpZCByZXNwb25zZSB3aGlsZSBk
cmFpbmluZyBBRU4gcXVldWUiKTsKKwkJCXR3X2Rldi0+cG9zdGVkX3JlcXVlc3RfY291bnQtLTsK
KwkJCWdvdG8gb3V0OworCQl9CisKKwkJdHdfZGV2LT5wb3N0ZWRfcmVxdWVzdF9jb3VudC0tOwor
CQloZWFkZXIgPSAoVFdfQ29tbWFuZF9BcGFjaGVfSGVhZGVyICopdHdfZGV2LT5nZW5lcmljX2J1
ZmZlcl92aXJ0W3JlcXVlc3RfaWRdOworCQlhZW4gPSBsZTE2X3RvX2NwdShoZWFkZXItPnN0YXR1
c19ibG9jay5lcnJvcik7CisJCXF1ZXVlID0gMDsKKwkJY291bnQrKzsKKworCQlzd2l0Y2ggKGFl
bikgeworCQljYXNlIFRXX0FFTl9RVUVVRV9FTVBUWToKKwkJCWlmIChmaXJzdF9yZXNldCAhPSAx
KQorCQkJCWdvdG8gb3V0OworCQkJZWxzZQorCQkJCWZpbmlzaGVkID0gMTsKKwkJCWJyZWFrOwor
CQljYXNlIFRXX0FFTl9TT0ZUX1JFU0VUOgorCQkJaWYgKGZpcnN0X3Jlc2V0ID09IDApCisJCQkJ
Zmlyc3RfcmVzZXQgPSAxOworCQkJZWxzZQorCQkJCXF1ZXVlID0gMTsKKwkJCWJyZWFrOworCQlj
YXNlIFRXX0FFTl9TWU5DX1RJTUVfV0lUSF9IT1NUOgorCQkJYnJlYWs7CisJCWRlZmF1bHQ6CisJ
CQlxdWV1ZSA9IDE7CisJCX0KKworCQkvKiBOb3cgcXVldWUgYW4gZXZlbnQgaW5mbyAqLworCQlp
ZiAocXVldWUpCisJCQl0d2xfYWVuX3F1ZXVlX2V2ZW50KHR3X2RldiwgaGVhZGVyKTsKKwl9IHdo
aWxlICgoZmluaXNoZWQgPT0gMCkgJiYgKGNvdW50IDwgVFdfTUFYX0FFTl9EUkFJTikpOworCisJ
aWYgKGNvdW50ID09IFRXX01BWF9BRU5fRFJBSU4pCisJCWdvdG8gb3V0OworCisJcmV0dmFsID0g
MDsKK291dDoKKwl0d19kZXYtPnN0YXRlW3JlcXVlc3RfaWRdID0gVFdfU19JTklUSUFMOworCXJl
dHVybiByZXR2YWw7Cit9IC8qIEVuZCB0d2xfYWVuX2RyYWluX3F1ZXVlKCkgKi8KKworLyogVGhp
cyBmdW5jdGlvbiB3aWxsIGFsbG9jYXRlIG1lbW9yeSBhbmQgY2hlY2sgaWYgaXQgaXMgY29ycmVj
dGx5IGFsaWduZWQgKi8KK3N0YXRpYyBpbnQgdHdsX2FsbG9jYXRlX21lbW9yeShUV19EZXZpY2Vf
RXh0ZW5zaW9uICp0d19kZXYsIGludCBzaXplLCBpbnQgd2hpY2gpCit7CisJaW50IGk7CisJZG1h
X2FkZHJfdCBkbWFfaGFuZGxlOworCXVuc2lnbmVkIGxvbmcgKmNwdV9hZGRyOworCWludCByZXR2
YWwgPSAxOworCisJY3B1X2FkZHIgPSBwY2lfYWxsb2NfY29uc2lzdGVudCh0d19kZXYtPnR3X3Bj
aV9kZXYsIHNpemUqVFdfUV9MRU5HVEgsICZkbWFfaGFuZGxlKTsKKwlpZiAoIWNwdV9hZGRyKSB7
CisJCVRXX1BSSU5USyh0d19kZXYtPmhvc3QsIFRXX0RSSVZFUiwgMHg1LCAiTWVtb3J5IGFsbG9j
YXRpb24gZmFpbGVkIik7CisJCWdvdG8gb3V0OworCX0KKworCW1lbXNldChjcHVfYWRkciwgMCwg
c2l6ZSpUV19RX0xFTkdUSCk7CisKKwlmb3IgKGkgPSAwOyBpIDwgVFdfUV9MRU5HVEg7IGkrKykg
eworCQlzd2l0Y2god2hpY2gpIHsKKwkJY2FzZSAwOgorCQkJdHdfZGV2LT5jb21tYW5kX3BhY2tl
dF9waHlzW2ldID0gZG1hX2hhbmRsZSsoaSpzaXplKTsKKwkJCXR3X2Rldi0+Y29tbWFuZF9wYWNr
ZXRfdmlydFtpXSA9IChUV19Db21tYW5kX0Z1bGwgKikoKHVuc2lnbmVkIGNoYXIgKiljcHVfYWRk
ciArIChpKnNpemUpKTsKKwkJCWJyZWFrOworCQljYXNlIDE6CisJCQl0d19kZXYtPmdlbmVyaWNf
YnVmZmVyX3BoeXNbaV0gPSBkbWFfaGFuZGxlKyhpKnNpemUpOworCQkJdHdfZGV2LT5nZW5lcmlj
X2J1ZmZlcl92aXJ0W2ldID0gKHVuc2lnbmVkIGxvbmcgKikoKHVuc2lnbmVkIGNoYXIgKiljcHVf
YWRkciArIChpKnNpemUpKTsKKwkJCWJyZWFrOworCQljYXNlIDI6CisJCQl0d19kZXYtPnNlbnNl
X2J1ZmZlcl9waHlzW2ldID0gZG1hX2hhbmRsZSsoaSpzaXplKTsKKwkJCXR3X2Rldi0+c2Vuc2Vf
YnVmZmVyX3ZpcnRbaV0gPSAoVFdfQ29tbWFuZF9BcGFjaGVfSGVhZGVyICopKCh1bnNpZ25lZCBj
aGFyICopY3B1X2FkZHIgKyAoaSpzaXplKSk7CisJCQlicmVhazsKKwkJfQorCX0KKwlyZXR2YWwg
PSAwOworb3V0OgorCXJldHVybiByZXR2YWw7Cit9IC8qIEVuZCB0d2xfYWxsb2NhdGVfbWVtb3J5
KCkgKi8KKworLyogVGhpcyBmdW5jdGlvbiB3aWxsIGxvYWQgdGhlIHJlcXVlc3QgaWQgYW5kIHZh
cmlvdXMgc2dscyBmb3IgaW9jdGxzICovCitzdGF0aWMgdm9pZCB0d2xfbG9hZF9zZ2woVFdfRGV2
aWNlX0V4dGVuc2lvbiAqdHdfZGV2LCBUV19Db21tYW5kX0Z1bGwgKmZ1bGxfY29tbWFuZF9wYWNr
ZXQsIGludCByZXF1ZXN0X2lkLCBkbWFfYWRkcl90IGRtYV9oYW5kbGUsIGludCBsZW5ndGgpCit7
CisJVFdfQ29tbWFuZCAqb2xkY29tbWFuZDsKKwlUV19Db21tYW5kX0FwYWNoZSAqbmV3Y29tbWFu
ZDsKKwlUV19TR19FbnRyeV9JU08gKnNnbDsKKwl1bnNpZ25lZCBpbnQgcGFlID0gMDsKKworCWlm
ICgoc2l6ZW9mKGxvbmcpIDwgOCkgJiYgKHNpemVvZihkbWFfYWRkcl90KSA+IDQpKQorCQlwYWUg
PSAxOworCisJaWYgKFRXX09QX09VVChmdWxsX2NvbW1hbmRfcGFja2V0LT5jb21tYW5kLm5ld2Nv
bW1hbmQub3Bjb2RlX19yZXNlcnZlZCkgPT0gVFdfT1BfRVhFQ1VURV9TQ1NJKSB7CisJCW5ld2Nv
bW1hbmQgPSAmZnVsbF9jb21tYW5kX3BhY2tldC0+Y29tbWFuZC5uZXdjb21tYW5kOworCQluZXdj
b21tYW5kLT5yZXF1ZXN0X2lkX19sdW5sID0KKwkJCWNwdV90b19sZTE2KFRXX1JFUV9MVU5fSU4o
VFdfTFVOX09VVChuZXdjb21tYW5kLT5yZXF1ZXN0X2lkX19sdW5sKSwgcmVxdWVzdF9pZCkpOwor
CQluZXdjb21tYW5kLT5zZ19saXN0WzBdLmFkZHJlc3MgPSBUV19DUFVfVE9fU0dMKGRtYV9oYW5k
bGUgKyBzaXplb2YoVFdfSW9jdGxfQnVmX0FwYWNoZSkgLSAxKTsKKwkJbmV3Y29tbWFuZC0+c2df
bGlzdFswXS5sZW5ndGggPSBUV19DUFVfVE9fU0dMKGxlbmd0aCk7CisJCW5ld2NvbW1hbmQtPnNn
bF9lbnRyaWVzX19sdW5oID0KKwkJCWNwdV90b19sZTE2KFRXX1JFUV9MVU5fSU4oVFdfTFVOX09V
VChuZXdjb21tYW5kLT5zZ2xfZW50cmllc19fbHVuaCksIDEpKTsKKwl9IGVsc2UgeworCQlvbGRj
b21tYW5kID0gJmZ1bGxfY29tbWFuZF9wYWNrZXQtPmNvbW1hbmQub2xkY29tbWFuZDsKKwkJb2xk
Y29tbWFuZC0+cmVxdWVzdF9pZCA9IHJlcXVlc3RfaWQ7CisKKwkJaWYgKFRXX1NHTF9PVVQob2xk
Y29tbWFuZC0+b3Bjb2RlX19zZ2xvZmZzZXQpKSB7CisJCQkvKiBMb2FkIHRoZSBzZyBsaXN0ICov
CisJCQlzZ2wgPSAoVFdfU0dfRW50cnlfSVNPICopKCh1MzIgKilvbGRjb21tYW5kK29sZGNvbW1h
bmQtPnNpemUgLSAoc2l6ZW9mKFRXX1NHX0VudHJ5X0lTTykvNCkgKyBwYWUgKyAoc2l6ZW9mKGRt
YV9hZGRyX3QpID4gNCA/IDEgOiAwKSk7CisJCQlzZ2wtPmFkZHJlc3MgPSBUV19DUFVfVE9fU0dM
KGRtYV9oYW5kbGUgKyBzaXplb2YoVFdfSW9jdGxfQnVmX0FwYWNoZSkgLSAxKTsKKwkJCXNnbC0+
bGVuZ3RoID0gVFdfQ1BVX1RPX1NHTChsZW5ndGgpOworCQkJb2xkY29tbWFuZC0+c2l6ZSArPSBw
YWU7CisJCQlvbGRjb21tYW5kLT5zaXplICs9IHNpemVvZihkbWFfYWRkcl90KSA+IDQgPyAxIDog
MDsKKwkJfQorCX0KK30gLyogRW5kIHR3bF9sb2FkX3NnbCgpICovCisKKy8qIFRoaXMgZnVuY3Rp
b24gaGFuZGxlcyBpb2N0bCBmb3IgdGhlIGNoYXJhY3RlciBkZXZpY2UKKyAgIFRoaXMgaW50ZXJm
YWNlIGlzIHVzZWQgYnkgc21hcnRtb250b29scyBvcGVuIHNvdXJjZSBzb2Z0d2FyZSAqLworc3Rh
dGljIGludCB0d2xfY2hyZGV2X2lvY3RsKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVjdCBmaWxl
ICpmaWxlLCB1bnNpZ25lZCBpbnQgY21kLCB1bnNpZ25lZCBsb25nIGFyZykKK3sKKwlsb25nIHRp
bWVvdXQ7CisJdW5zaWduZWQgbG9uZyAqY3B1X2FkZHIsIGRhdGFfYnVmZmVyX2xlbmd0aF9hZGp1
c3RlZCA9IDAsIGZsYWdzID0gMDsKKwlkbWFfYWRkcl90IGRtYV9oYW5kbGU7CisJaW50IHJlcXVl
c3RfaWQgPSAwOworCVRXX0lvY3RsX0RyaXZlcl9Db21tYW5kIGRyaXZlcl9jb21tYW5kOworCVRX
X0lvY3RsX0J1Zl9BcGFjaGUgKnR3X2lvY3RsOworCVRXX0NvbW1hbmRfRnVsbCAqZnVsbF9jb21t
YW5kX3BhY2tldDsKKwlUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYgPSB0d2xfZGV2aWNlX2V4
dGVuc2lvbl9saXN0W2ltaW5vcihpbm9kZSldOworCWludCByZXR2YWwgPSAtRUZBVUxUOworCXZv
aWQgX191c2VyICphcmdwID0gKHZvaWQgX191c2VyICopYXJnOworCisJLyogT25seSBsZXQgb25l
IG9mIHRoZXNlIHRocm91Z2ggYXQgYSB0aW1lICovCisJaWYgKG11dGV4X2xvY2tfaW50ZXJydXB0
aWJsZSgmdHdfZGV2LT5pb2N0bF9sb2NrKSkgeworCQlyZXR2YWwgPSAtRUlOVFI7CisJCWdvdG8g
b3V0OworCX0KKworCS8qIEZpcnN0IGNvcHkgZG93biB0aGUgZHJpdmVyIGNvbW1hbmQgKi8KKwlp
ZiAoY29weV9mcm9tX3VzZXIoJmRyaXZlcl9jb21tYW5kLCBhcmdwLCBzaXplb2YoVFdfSW9jdGxf
RHJpdmVyX0NvbW1hbmQpKSkKKwkJZ290byBvdXQyOworCisJLyogQ2hlY2sgZGF0YSBidWZmZXIg
c2l6ZSAqLworCWlmIChkcml2ZXJfY29tbWFuZC5idWZmZXJfbGVuZ3RoID4gVFdfTUFYX1NFQ1RP
UlMgKiAyMDQ4KSB7CisJCXJldHZhbCA9IC1FSU5WQUw7CisJCWdvdG8gb3V0MjsKKwl9CisKKwkv
KiBIYXJkd2FyZSBjYW4gb25seSBkbyBtdWx0aXBsZSBvZiA1MTIgYnl0ZSB0cmFuc2ZlcnMgKi8K
KwlkYXRhX2J1ZmZlcl9sZW5ndGhfYWRqdXN0ZWQgPSAoZHJpdmVyX2NvbW1hbmQuYnVmZmVyX2xl
bmd0aCArIDUxMSkgJiB+NTExOworCisJLyogTm93IGFsbG9jYXRlIGlvY3RsIGJ1ZiBtZW1vcnkg
Ki8KKwljcHVfYWRkciA9IGRtYV9hbGxvY19jb2hlcmVudCgmdHdfZGV2LT50d19wY2lfZGV2LT5k
ZXYsIGRhdGFfYnVmZmVyX2xlbmd0aF9hZGp1c3RlZCtzaXplb2YoVFdfSW9jdGxfQnVmX0FwYWNo
ZSkgLSAxLCAmZG1hX2hhbmRsZSwgR0ZQX0tFUk5FTCk7CisJaWYgKCFjcHVfYWRkcikgeworCQly
ZXR2YWwgPSAtRU5PTUVNOworCQlnb3RvIG91dDI7CisJfQorCisJdHdfaW9jdGwgPSAoVFdfSW9j
dGxfQnVmX0FwYWNoZSAqKWNwdV9hZGRyOworCisJLyogTm93IGNvcHkgZG93biB0aGUgZW50aXJl
IGlvY3RsICovCisJaWYgKGNvcHlfZnJvbV91c2VyKHR3X2lvY3RsLCBhcmdwLCBkcml2ZXJfY29t
bWFuZC5idWZmZXJfbGVuZ3RoICsgc2l6ZW9mKFRXX0lvY3RsX0J1Zl9BcGFjaGUpIC0gMSkpCisJ
CWdvdG8gb3V0MzsKKworCS8qIFNlZSB3aGljaCBpb2N0bCB3ZSBhcmUgZG9pbmcgKi8KKwlzd2l0
Y2ggKGNtZCkgeworCWNhc2UgVFdfSU9DVExfRklSTVdBUkVfUEFTU19USFJPVUdIOgorCQlzcGlu
X2xvY2tfaXJxc2F2ZSh0d19kZXYtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOworCQl0d2xfZ2V0
X3JlcXVlc3RfaWQodHdfZGV2LCAmcmVxdWVzdF9pZCk7CisKKwkJLyogRmxhZyBpbnRlcm5hbCBj
b21tYW5kICovCisJCXR3X2Rldi0+c3JiW3JlcXVlc3RfaWRdID0gTlVMTDsKKworCQkvKiBGbGFn
IGNocmRldiBpb2N0bCAqLworCQl0d19kZXYtPmNocmRldl9yZXF1ZXN0X2lkID0gcmVxdWVzdF9p
ZDsKKworCQlmdWxsX2NvbW1hbmRfcGFja2V0ID0gKFRXX0NvbW1hbmRfRnVsbCAqKSZ0d19pb2N0
bC0+ZmlybXdhcmVfY29tbWFuZDsKKworCQkvKiBMb2FkIHJlcXVlc3QgaWQgYW5kIHNnbGlzdCBm
b3IgYm90aCBjb21tYW5kIHR5cGVzICovCisJCXR3bF9sb2FkX3NnbCh0d19kZXYsIGZ1bGxfY29t
bWFuZF9wYWNrZXQsIHJlcXVlc3RfaWQsIGRtYV9oYW5kbGUsIGRhdGFfYnVmZmVyX2xlbmd0aF9h
ZGp1c3RlZCk7CisKKwkJbWVtY3B5KHR3X2Rldi0+Y29tbWFuZF9wYWNrZXRfdmlydFtyZXF1ZXN0
X2lkXSwgJih0d19pb2N0bC0+ZmlybXdhcmVfY29tbWFuZCksIHNpemVvZihUV19Db21tYW5kX0Z1
bGwpKTsKKworCQkvKiBOb3cgcG9zdCB0aGUgY29tbWFuZCBwYWNrZXQgdG8gdGhlIGNvbnRyb2xs
ZXIgKi8KKwkJdHdsX3Bvc3RfY29tbWFuZF9wYWNrZXQodHdfZGV2LCByZXF1ZXN0X2lkKTsKKwkJ
c3Bpbl91bmxvY2tfaXJxcmVzdG9yZSh0d19kZXYtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOwor
CisJCXRpbWVvdXQgPSBUV19JT0NUTF9DSFJERVZfVElNRU9VVCpIWjsKKworCQkvKiBOb3cgd2Fp
dCBmb3IgY29tbWFuZCB0byBjb21wbGV0ZSAqLworCQl0aW1lb3V0ID0gd2FpdF9ldmVudF90aW1l
b3V0KHR3X2Rldi0+aW9jdGxfd3F1ZXVlLCB0d19kZXYtPmNocmRldl9yZXF1ZXN0X2lkID09IFRX
X0lPQ1RMX0NIUkRFVl9GUkVFLCB0aW1lb3V0KTsKKworCQkvKiBXZSB0aW1lZCBvdXQsIGFuZCBk
aWRuJ3QgZ2V0IGFuIGludGVycnVwdCAqLworCQlpZiAodHdfZGV2LT5jaHJkZXZfcmVxdWVzdF9p
ZCAhPSBUV19JT0NUTF9DSFJERVZfRlJFRSkgeworCQkJLyogTm93IHdlIG5lZWQgdG8gcmVzZXQg
dGhlIGJvYXJkICovCisJCQlwcmludGsoS0VSTl9XQVJOSU5HICIzdy1zYXM6IHNjc2klZDogV0FS
TklORzogKDB4JTAyWDoweCUwNFgpOiBDaGFyYWN0ZXIgaW9jdGwgKDB4JXgpIHRpbWVkIG91dCwg
cmVzZXR0aW5nIGNhcmQuXG4iLAorCQkJICAgICAgIHR3X2Rldi0+aG9zdC0+aG9zdF9ubywgVFdf
RFJJVkVSLCAweDYsCisJCQkgICAgICAgY21kKTsKKwkJCXJldHZhbCA9IC1FSU87CisJCQl0d2xf
cmVzZXRfZGV2aWNlX2V4dGVuc2lvbih0d19kZXYsIDEpOworCQkJZ290byBvdXQzOworCQl9CisK
KwkJLyogTm93IGNvcHkgaW4gdGhlIGNvbW1hbmQgcGFja2V0IHJlc3BvbnNlICovCisJCW1lbWNw
eSgmKHR3X2lvY3RsLT5maXJtd2FyZV9jb21tYW5kKSwgdHdfZGV2LT5jb21tYW5kX3BhY2tldF92
aXJ0W3JlcXVlc3RfaWRdLCBzaXplb2YoVFdfQ29tbWFuZF9GdWxsKSk7CisJCQorCQkvKiBOb3cg
Y29tcGxldGUgdGhlIGlvICovCisJCXNwaW5fbG9ja19pcnFzYXZlKHR3X2Rldi0+aG9zdC0+aG9z
dF9sb2NrLCBmbGFncyk7CisJCXR3X2Rldi0+cG9zdGVkX3JlcXVlc3RfY291bnQtLTsKKwkJdHdf
ZGV2LT5zdGF0ZVtyZXF1ZXN0X2lkXSA9IFRXX1NfQ09NUExFVEVEOworCQl0d2xfZnJlZV9yZXF1
ZXN0X2lkKHR3X2RldiwgcmVxdWVzdF9pZCk7CisJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUodHdf
ZGV2LT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKKwkJYnJlYWs7CisJZGVmYXVsdDoKKwkJcmV0
dmFsID0gLUVOT1RUWTsKKwkJZ290byBvdXQzOworCX0KKworCS8qIE5vdyBjb3B5IHRoZSBlbnRp
cmUgcmVzcG9uc2UgdG8gdXNlcnNwYWNlICovCisJaWYgKGNvcHlfdG9fdXNlcihhcmdwLCB0d19p
b2N0bCwgc2l6ZW9mKFRXX0lvY3RsX0J1Zl9BcGFjaGUpICsgZHJpdmVyX2NvbW1hbmQuYnVmZmVy
X2xlbmd0aCAtIDEpID09IDApCisJCXJldHZhbCA9IDA7CitvdXQzOgorCS8qIE5vdyBmcmVlIGlv
Y3RsIGJ1ZiBtZW1vcnkgKi8KKwlkbWFfZnJlZV9jb2hlcmVudCgmdHdfZGV2LT50d19wY2lfZGV2
LT5kZXYsIGRhdGFfYnVmZmVyX2xlbmd0aF9hZGp1c3RlZCtzaXplb2YoVFdfSW9jdGxfQnVmX0Fw
YWNoZSkgLSAxLCBjcHVfYWRkciwgZG1hX2hhbmRsZSk7CitvdXQyOgorCW11dGV4X3VubG9jaygm
dHdfZGV2LT5pb2N0bF9sb2NrKTsKK291dDoKKwlyZXR1cm4gcmV0dmFsOworfSAvKiBFbmQgdHds
X2NocmRldl9pb2N0bCgpICovCisKKy8qIFRoaXMgZnVuY3Rpb24gaGFuZGxlcyBvcGVuIGZvciB0
aGUgY2hhcmFjdGVyIGRldmljZSAqLworc3RhdGljIGludCB0d2xfY2hyZGV2X29wZW4oc3RydWN0
IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCit7CisJdW5zaWduZWQgaW50IG1pbm9y
X251bWJlcjsKKwlpbnQgcmV0dmFsID0gLUVOT0RFVjsKKworCWlmICghY2FwYWJsZShDQVBfU1lT
X0FETUlOKSkgeworCQlyZXR2YWwgPSAtRUFDQ0VTOworCQlnb3RvIG91dDsKKwl9CisKKwljeWNs
ZV9rZXJuZWxfbG9jaygpOworCW1pbm9yX251bWJlciA9IGltaW5vcihpbm9kZSk7CisJaWYgKG1p
bm9yX251bWJlciA+PSB0d2xfZGV2aWNlX2V4dGVuc2lvbl9jb3VudCkKKwkJZ290byBvdXQ7CisJ
cmV0dmFsID0gMDsKK291dDoKKwlyZXR1cm4gcmV0dmFsOworfSAvKiBFbmQgdHdsX2NocmRldl9v
cGVuKCkgKi8KKworLyogRmlsZSBvcGVyYXRpb25zIHN0cnVjdCBmb3IgY2hhcmFjdGVyIGRldmlj
ZSAqLworc3RhdGljIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgdHdsX2ZvcHMgPSB7CisJ
Lm93bmVyCQk9IFRISVNfTU9EVUxFLAorCS5pb2N0bAkJPSB0d2xfY2hyZGV2X2lvY3RsLAorCS5v
cGVuCQk9IHR3bF9jaHJkZXZfb3BlbiwKKwkucmVsZWFzZQk9IE5VTEwKK307CisKKy8qIFRoaXMg
ZnVuY3Rpb24gcGFzc2VzIHNlbnNlIGRhdGEgZnJvbSBmaXJtd2FyZSB0byBzY3NpIGxheWVyICov
CitzdGF0aWMgaW50IHR3bF9maWxsX3NlbnNlKFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2Rldiwg
aW50IGksIGludCByZXF1ZXN0X2lkLCBpbnQgY29weV9zZW5zZSwgaW50IHByaW50X2hvc3QpCit7
CisJVFdfQ29tbWFuZF9BcGFjaGVfSGVhZGVyICpoZWFkZXI7CisJVFdfQ29tbWFuZF9GdWxsICpm
dWxsX2NvbW1hbmRfcGFja2V0OworCXVuc2lnbmVkIHNob3J0IGVycm9yOworCWNoYXIgKmVycm9y
X3N0cjsKKwlpbnQgcmV0dmFsID0gMTsKKworCWhlYWRlciA9IHR3X2Rldi0+c2Vuc2VfYnVmZmVy
X3ZpcnRbaV07CisJZnVsbF9jb21tYW5kX3BhY2tldCA9IHR3X2Rldi0+Y29tbWFuZF9wYWNrZXRf
dmlydFtyZXF1ZXN0X2lkXTsKKworCS8qIEdldCBlbWJlZGRlZCBmaXJtd2FyZSBlcnJvciBzdHJp
bmcgKi8KKwllcnJvcl9zdHIgPSAmKGhlYWRlci0+ZXJyX3NwZWNpZmljX2Rlc2Nbc3RybGVuKGhl
YWRlci0+ZXJyX3NwZWNpZmljX2Rlc2MpICsgMV0pOworCisJLyogRG9uJ3QgcHJpbnQgZXJyb3Ig
Zm9yIExvZ2ljYWwgdW5pdCBub3Qgc3VwcG9ydGVkIGR1cmluZyByb2xsY2FsbCAqLworCWVycm9y
ID0gbGUxNl90b19jcHUoaGVhZGVyLT5zdGF0dXNfYmxvY2suZXJyb3IpOworCWlmICgoZXJyb3Ig
IT0gVFdfRVJST1JfTE9HSUNBTF9VTklUX05PVF9TVVBQT1JURUQpICYmIChlcnJvciAhPSBUV19F
UlJPUl9VTklUX09GRkxJTkUpICYmIChlcnJvciAhPSBUV19FUlJPUl9JTlZBTElEX0ZJRUxEX0lO
X0NEQikpIHsKKwkJaWYgKHByaW50X2hvc3QpCisJCQlwcmludGsoS0VSTl9XQVJOSU5HICIzdy1z
YXM6IHNjc2klZDogRVJST1I6ICgweCUwMlg6MHglMDRYKTogJXM6JXMuXG4iLAorCQkJICAgICAg
IHR3X2Rldi0+aG9zdC0+aG9zdF9ubywKKwkJCSAgICAgICBUV19NRVNTQUdFX1NPVVJDRV9DT05U
Uk9MTEVSX0VSUk9SLAorCQkJICAgICAgIGhlYWRlci0+c3RhdHVzX2Jsb2NrLmVycm9yLAorCQkJ
ICAgICAgIGVycm9yX3N0ciwgCisJCQkgICAgICAgaGVhZGVyLT5lcnJfc3BlY2lmaWNfZGVzYyk7
CisJCWVsc2UKKwkJCXByaW50ayhLRVJOX1dBUk5JTkcgIjN3LXNhczogRVJST1I6ICgweCUwMlg6
MHglMDRYKTogJXM6JXMuXG4iLAorCQkJICAgICAgIFRXX01FU1NBR0VfU09VUkNFX0NPTlRST0xM
RVJfRVJST1IsCisJCQkgICAgICAgaGVhZGVyLT5zdGF0dXNfYmxvY2suZXJyb3IsCisJCQkgICAg
ICAgZXJyb3Jfc3RyLAorCQkJICAgICAgIGhlYWRlci0+ZXJyX3NwZWNpZmljX2Rlc2MpOworCX0K
KworCWlmIChjb3B5X3NlbnNlKSB7CisJCW1lbWNweSh0d19kZXYtPnNyYltyZXF1ZXN0X2lkXS0+
c2Vuc2VfYnVmZmVyLCBoZWFkZXItPnNlbnNlX2RhdGEsIFRXX1NFTlNFX0RBVEFfTEVOR1RIKTsK
KwkJdHdfZGV2LT5zcmJbcmVxdWVzdF9pZF0tPnJlc3VsdCA9IChmdWxsX2NvbW1hbmRfcGFja2V0
LT5jb21tYW5kLm5ld2NvbW1hbmQuc3RhdHVzIDw8IDEpOworCQlnb3RvIG91dDsKKwl9CitvdXQ6
CisJcmV0dXJuIHJldHZhbDsKK30gLyogRW5kIHR3bF9maWxsX3NlbnNlKCkgKi8KKworLyogVGhp
cyBmdW5jdGlvbiB3aWxsIGZyZWUgdXAgZGV2aWNlIGV4dGVuc2lvbiByZXNvdXJjZXMgKi8KK3N0
YXRpYyB2b2lkIHR3bF9mcmVlX2RldmljZV9leHRlbnNpb24oVFdfRGV2aWNlX0V4dGVuc2lvbiAq
dHdfZGV2KQoreworCWlmICh0d19kZXYtPmNvbW1hbmRfcGFja2V0X3ZpcnRbMF0pCisJCXBjaV9m
cmVlX2NvbnNpc3RlbnQodHdfZGV2LT50d19wY2lfZGV2LAorCQkJCSAgICBzaXplb2YoVFdfQ29t
bWFuZF9GdWxsKSpUV19RX0xFTkdUSCwKKwkJCQkgICAgdHdfZGV2LT5jb21tYW5kX3BhY2tldF92
aXJ0WzBdLAorCQkJCSAgICB0d19kZXYtPmNvbW1hbmRfcGFja2V0X3BoeXNbMF0pOworCisJaWYg
KHR3X2Rldi0+Z2VuZXJpY19idWZmZXJfdmlydFswXSkKKwkJcGNpX2ZyZWVfY29uc2lzdGVudCh0
d19kZXYtPnR3X3BjaV9kZXYsCisJCQkJICAgIFRXX1NFQ1RPUl9TSVpFKlRXX1FfTEVOR1RILAor
CQkJCSAgICB0d19kZXYtPmdlbmVyaWNfYnVmZmVyX3ZpcnRbMF0sCisJCQkJICAgIHR3X2Rldi0+
Z2VuZXJpY19idWZmZXJfcGh5c1swXSk7CisKKwlpZiAodHdfZGV2LT5zZW5zZV9idWZmZXJfdmly
dFswXSkKKwkJcGNpX2ZyZWVfY29uc2lzdGVudCh0d19kZXYtPnR3X3BjaV9kZXYsCisJCQkJICAg
IHNpemVvZihUV19Db21tYW5kX0FwYWNoZV9IZWFkZXIpKgorCQkJCSAgICBUV19RX0xFTkdUSCwK
KwkJCQkgICAgdHdfZGV2LT5zZW5zZV9idWZmZXJfdmlydFswXSwKKwkJCQkgICAgdHdfZGV2LT5z
ZW5zZV9idWZmZXJfcGh5c1swXSk7CisKKwlrZnJlZSh0d19kZXYtPmV2ZW50X3F1ZXVlWzBdKTsK
K30gLyogRW5kIHR3bF9mcmVlX2RldmljZV9leHRlbnNpb24oKSAqLworCisvKiBUaGlzIGZ1bmN0
aW9uIHdpbGwgZ2V0IHBhcmFtZXRlciB0YWJsZSBlbnRyaWVzIGZyb20gdGhlIGZpcm13YXJlICov
CitzdGF0aWMgdm9pZCAqdHdsX2dldF9wYXJhbShUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYs
IGludCByZXF1ZXN0X2lkLCBpbnQgdGFibGVfaWQsIGludCBwYXJhbWV0ZXJfaWQsIGludCBwYXJh
bWV0ZXJfc2l6ZV9ieXRlcykKK3sKKwlUV19Db21tYW5kX0Z1bGwgKmZ1bGxfY29tbWFuZF9wYWNr
ZXQ7CisJVFdfQ29tbWFuZCAqY29tbWFuZF9wYWNrZXQ7CisJVFdfUGFyYW1fQXBhY2hlICpwYXJh
bTsKKwl2b2lkICpyZXR2YWwgPSBOVUxMOworCisJLyogU2V0dXAgdGhlIGNvbW1hbmQgcGFja2V0
ICovCisJZnVsbF9jb21tYW5kX3BhY2tldCA9IHR3X2Rldi0+Y29tbWFuZF9wYWNrZXRfdmlydFty
ZXF1ZXN0X2lkXTsKKwltZW1zZXQoZnVsbF9jb21tYW5kX3BhY2tldCwgMCwgc2l6ZW9mKFRXX0Nv
bW1hbmRfRnVsbCkpOworCWNvbW1hbmRfcGFja2V0ID0gJmZ1bGxfY29tbWFuZF9wYWNrZXQtPmNv
bW1hbmQub2xkY29tbWFuZDsKKworCWNvbW1hbmRfcGFja2V0LT5vcGNvZGVfX3NnbG9mZnNldCA9
IFRXX09QU0dMX0lOKDIsIFRXX09QX0dFVF9QQVJBTSk7CisJY29tbWFuZF9wYWNrZXQtPnNpemUg
ICAgICAgICAgICAgID0gVFdfQ09NTUFORF9TSVpFOworCWNvbW1hbmRfcGFja2V0LT5yZXF1ZXN0
X2lkICAgICAgICA9IHJlcXVlc3RfaWQ7CisJY29tbWFuZF9wYWNrZXQtPmJ5dGU2X29mZnNldC5i
bG9ja19jb3VudCA9IGNwdV90b19sZTE2KDEpOworCisJLyogTm93IHNldHVwIHRoZSBwYXJhbSAq
LworCXBhcmFtID0gKFRXX1BhcmFtX0FwYWNoZSAqKXR3X2Rldi0+Z2VuZXJpY19idWZmZXJfdmly
dFtyZXF1ZXN0X2lkXTsKKwltZW1zZXQocGFyYW0sIDAsIFRXX1NFQ1RPUl9TSVpFKTsKKwlwYXJh
bS0+dGFibGVfaWQgPSBjcHVfdG9fbGUxNih0YWJsZV9pZCB8IDB4ODAwMCk7CisJcGFyYW0tPnBh
cmFtZXRlcl9pZCA9IGNwdV90b19sZTE2KHBhcmFtZXRlcl9pZCk7CisJcGFyYW0tPnBhcmFtZXRl
cl9zaXplX2J5dGVzID0gY3B1X3RvX2xlMTYocGFyYW1ldGVyX3NpemVfYnl0ZXMpOworCisJY29t
bWFuZF9wYWNrZXQtPmJ5dGU4X29mZnNldC5wYXJhbS5zZ2xbMF0uYWRkcmVzcyA9IFRXX0NQVV9U
T19TR0wodHdfZGV2LT5nZW5lcmljX2J1ZmZlcl9waHlzW3JlcXVlc3RfaWRdKTsKKwljb21tYW5k
X3BhY2tldC0+Ynl0ZThfb2Zmc2V0LnBhcmFtLnNnbFswXS5sZW5ndGggPSBUV19DUFVfVE9fU0dM
KFRXX1NFQ1RPUl9TSVpFKTsKKworCS8qIFBvc3QgdGhlIGNvbW1hbmQgcGFja2V0IHRvIHRoZSBi
b2FyZCAqLworCXR3bF9wb3N0X2NvbW1hbmRfcGFja2V0KHR3X2RldiwgcmVxdWVzdF9pZCk7CisK
KwkvKiBQb2xsIGZvciBjb21wbGV0aW9uICovCisJaWYgKHR3bF9wb2xsX3Jlc3BvbnNlKHR3X2Rl
diwgcmVxdWVzdF9pZCwgMzApKQorCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIs
IDB4NywgIk5vIHZhbGlkIHJlc3BvbnNlIGR1cmluZyBnZXQgcGFyYW0iKQorCWVsc2UKKwkJcmV0
dmFsID0gKHZvaWQgKikmKHBhcmFtLT5kYXRhWzBdKTsKKworCXR3X2Rldi0+cG9zdGVkX3JlcXVl
c3RfY291bnQtLTsKKwl0d19kZXYtPnN0YXRlW3JlcXVlc3RfaWRdID0gVFdfU19JTklUSUFMOwor
CisJcmV0dXJuIHJldHZhbDsKK30gLyogRW5kIHR3bF9nZXRfcGFyYW0oKSAqLworCisvKiBUaGlz
IGZ1bmN0aW9uIHdpbGwgc2VuZCBhbiBpbml0Y29ubmVjdGlvbiBjb21tYW5kIHRvIGNvbnRyb2xs
ZXIgKi8KK3N0YXRpYyBpbnQgdHdsX2luaXRjb25uZWN0aW9uKFRXX0RldmljZV9FeHRlbnNpb24g
KnR3X2RldiwgaW50IG1lc3NhZ2VfY3JlZGl0cywKKyAJCQkgICAgICB1MzIgc2V0X2ZlYXR1cmVz
LCB1bnNpZ25lZCBzaG9ydCBjdXJyZW50X2Z3X3NybCwgCisJCQkgICAgICB1bnNpZ25lZCBzaG9y
dCBjdXJyZW50X2Z3X2FyY2hfaWQsIAorCQkJICAgICAgdW5zaWduZWQgc2hvcnQgY3VycmVudF9m
d19icmFuY2gsIAorCQkJICAgICAgdW5zaWduZWQgc2hvcnQgY3VycmVudF9md19idWlsZCwgCisJ
CQkgICAgICB1bnNpZ25lZCBzaG9ydCAqZndfb25fY3Rscl9zcmwsIAorCQkJICAgICAgdW5zaWdu
ZWQgc2hvcnQgKmZ3X29uX2N0bHJfYXJjaF9pZCwgCisJCQkgICAgICB1bnNpZ25lZCBzaG9ydCAq
Zndfb25fY3Rscl9icmFuY2gsIAorCQkJICAgICAgdW5zaWduZWQgc2hvcnQgKmZ3X29uX2N0bHJf
YnVpbGQsIAorCQkJICAgICAgdTMyICppbml0X2Nvbm5lY3RfcmVzdWx0KQoreworCVRXX0NvbW1h
bmRfRnVsbCAqZnVsbF9jb21tYW5kX3BhY2tldDsKKwlUV19Jbml0Y29ubmVjdCAqdHdfaW5pdGNv
bm5lY3Q7CisJaW50IHJlcXVlc3RfaWQgPSAwLCByZXR2YWwgPSAxOworCisJLyogSW5pdGlhbGl6
ZSBJbml0Q29ubmVjdGlvbiBjb21tYW5kIHBhY2tldCAqLworCWZ1bGxfY29tbWFuZF9wYWNrZXQg
PSB0d19kZXYtPmNvbW1hbmRfcGFja2V0X3ZpcnRbcmVxdWVzdF9pZF07CisJbWVtc2V0KGZ1bGxf
Y29tbWFuZF9wYWNrZXQsIDAsIHNpemVvZihUV19Db21tYW5kX0Z1bGwpKTsKKwlmdWxsX2NvbW1h
bmRfcGFja2V0LT5oZWFkZXIuaGVhZGVyX2Rlc2Muc2l6ZV9oZWFkZXIgPSAxMjg7CisJCisJdHdf
aW5pdGNvbm5lY3QgPSAoVFdfSW5pdGNvbm5lY3QgKikmZnVsbF9jb21tYW5kX3BhY2tldC0+Y29t
bWFuZC5vbGRjb21tYW5kOworCXR3X2luaXRjb25uZWN0LT5vcGNvZGVfX3Jlc2VydmVkID0gVFdf
T1BSRVNfSU4oMCwgVFdfT1BfSU5JVF9DT05ORUNUSU9OKTsKKwl0d19pbml0Y29ubmVjdC0+cmVx
dWVzdF9pZCA9IHJlcXVlc3RfaWQ7CisJdHdfaW5pdGNvbm5lY3QtPm1lc3NhZ2VfY3JlZGl0cyA9
IGNwdV90b19sZTE2KG1lc3NhZ2VfY3JlZGl0cyk7CisJdHdfaW5pdGNvbm5lY3QtPmZlYXR1cmVz
ID0gc2V0X2ZlYXR1cmVzOworCisJLyogVHVybiBvbiA2NC1iaXQgc2dsIHN1cHBvcnQgaWYgd2Ug
bmVlZCB0byAqLworCXR3X2luaXRjb25uZWN0LT5mZWF0dXJlcyB8PSBzaXplb2YoZG1hX2FkZHJf
dCkgPiA0ID8gMSA6IDA7CisKKwl0d19pbml0Y29ubmVjdC0+ZmVhdHVyZXMgPSBjcHVfdG9fbGUz
Mih0d19pbml0Y29ubmVjdC0+ZmVhdHVyZXMpOworCisJaWYgKHNldF9mZWF0dXJlcyAmIFRXX0VY
VEVOREVEX0lOSVRfQ09OTkVDVCkgeworCQl0d19pbml0Y29ubmVjdC0+c2l6ZSA9IFRXX0lOSVRf
Q09NTUFORF9QQUNLRVRfU0laRV9FWFRFTkRFRDsKKwkJdHdfaW5pdGNvbm5lY3QtPmZ3X3NybCA9
IGNwdV90b19sZTE2KGN1cnJlbnRfZndfc3JsKTsKKwkJdHdfaW5pdGNvbm5lY3QtPmZ3X2FyY2hf
aWQgPSBjcHVfdG9fbGUxNihjdXJyZW50X2Z3X2FyY2hfaWQpOworCQl0d19pbml0Y29ubmVjdC0+
ZndfYnJhbmNoID0gY3B1X3RvX2xlMTYoY3VycmVudF9md19icmFuY2gpOworCQl0d19pbml0Y29u
bmVjdC0+ZndfYnVpbGQgPSBjcHVfdG9fbGUxNihjdXJyZW50X2Z3X2J1aWxkKTsKKwl9IGVsc2Ug
CisJCXR3X2luaXRjb25uZWN0LT5zaXplID0gVFdfSU5JVF9DT01NQU5EX1BBQ0tFVF9TSVpFOwor
CisJLyogU2VuZCBjb21tYW5kIHBhY2tldCB0byB0aGUgYm9hcmQgKi8KKwl0d2xfcG9zdF9jb21t
YW5kX3BhY2tldCh0d19kZXYsIHJlcXVlc3RfaWQpOworCisJLyogUG9sbCBmb3IgY29tcGxldGlv
biAqLworCWlmICh0d2xfcG9sbF9yZXNwb25zZSh0d19kZXYsIHJlcXVlc3RfaWQsIDMwKSkgewor
CQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIsIDB4OCwgIk5vIHZhbGlkIHJlc3Bv
bnNlIGR1cmluZyBpbml0IGNvbm5lY3Rpb24iKTsKKwl9IGVsc2UgeworCQlpZiAoc2V0X2ZlYXR1
cmVzICYgVFdfRVhURU5ERURfSU5JVF9DT05ORUNUKSB7CisJCQkqZndfb25fY3Rscl9zcmwgPSBs
ZTE2X3RvX2NwdSh0d19pbml0Y29ubmVjdC0+Zndfc3JsKTsKKwkJCSpmd19vbl9jdGxyX2FyY2hf
aWQgPSBsZTE2X3RvX2NwdSh0d19pbml0Y29ubmVjdC0+ZndfYXJjaF9pZCk7CisJCQkqZndfb25f
Y3Rscl9icmFuY2ggPSBsZTE2X3RvX2NwdSh0d19pbml0Y29ubmVjdC0+ZndfYnJhbmNoKTsKKwkJ
CSpmd19vbl9jdGxyX2J1aWxkID0gbGUxNl90b19jcHUodHdfaW5pdGNvbm5lY3QtPmZ3X2J1aWxk
KTsKKwkJCSppbml0X2Nvbm5lY3RfcmVzdWx0ID0gbGUzMl90b19jcHUodHdfaW5pdGNvbm5lY3Qt
PnJlc3VsdCk7CisJCX0KKwkJcmV0dmFsID0gMDsKKwl9CisKKwl0d19kZXYtPnBvc3RlZF9yZXF1
ZXN0X2NvdW50LS07CisJdHdfZGV2LT5zdGF0ZVtyZXF1ZXN0X2lkXSA9IFRXX1NfSU5JVElBTDsK
KworCXJldHVybiByZXR2YWw7Cit9IC8qIEVuZCB0d2xfaW5pdGNvbm5lY3Rpb24oKSAqLworCisv
KiBUaGlzIGZ1bmN0aW9uIHdpbGwgaW5pdGlhbGl6ZSB0aGUgZmllbGRzIG9mIGEgZGV2aWNlIGV4
dGVuc2lvbiAqLworc3RhdGljIGludCB0d2xfaW5pdGlhbGl6ZV9kZXZpY2VfZXh0ZW5zaW9uKFRX
X0RldmljZV9FeHRlbnNpb24gKnR3X2RldikKK3sKKwlpbnQgaSwgcmV0dmFsID0gMTsKKworCS8q
IEluaXRpYWxpemUgY29tbWFuZCBwYWNrZXQgYnVmZmVycyAqLworCWlmICh0d2xfYWxsb2NhdGVf
bWVtb3J5KHR3X2Rldiwgc2l6ZW9mKFRXX0NvbW1hbmRfRnVsbCksIDApKSB7CisJCVRXX1BSSU5U
Syh0d19kZXYtPmhvc3QsIFRXX0RSSVZFUiwgMHg5LCAiQ29tbWFuZCBwYWNrZXQgbWVtb3J5IGFs
bG9jYXRpb24gZmFpbGVkIik7CisJCWdvdG8gb3V0OworCX0KKworCS8qIEluaXRpYWxpemUgZ2Vu
ZXJpYyBidWZmZXIgKi8KKwlpZiAodHdsX2FsbG9jYXRlX21lbW9yeSh0d19kZXYsIFRXX1NFQ1RP
Ul9TSVpFLCAxKSkgeworCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIsIDB4YSwg
IkdlbmVyaWMgbWVtb3J5IGFsbG9jYXRpb24gZmFpbGVkIik7CisJCWdvdG8gb3V0OworCX0KKwor
CS8qIEFsbG9jYXRlIHNlbnNlIGJ1ZmZlcnMgKi8KKwlpZiAodHdsX2FsbG9jYXRlX21lbW9yeSh0
d19kZXYsIHNpemVvZihUV19Db21tYW5kX0FwYWNoZV9IZWFkZXIpLCAyKSkgeworCQlUV19QUklO
VEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIsIDB4YiwgIlNlbnNlIGJ1ZmZlciBhbGxvY2F0aW9u
IGZhaWxlZCIpOworCQlnb3RvIG91dDsKKwl9CisKKwkvKiBBbGxvY2F0ZSBldmVudCBpbmZvIHNw
YWNlICovCisJdHdfZGV2LT5ldmVudF9xdWV1ZVswXSA9IGtjYWxsb2MoVFdfUV9MRU5HVEgsIHNp
emVvZihUV19FdmVudCksIEdGUF9LRVJORUwpOworCWlmICghdHdfZGV2LT5ldmVudF9xdWV1ZVsw
XSkgeworCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIsIDB4YywgIkV2ZW50IGlu
Zm8gbWVtb3J5IGFsbG9jYXRpb24gZmFpbGVkIik7CisJCWdvdG8gb3V0OworCX0KKworCWZvciAo
aSA9IDA7IGkgPCBUV19RX0xFTkdUSDsgaSsrKSB7CisJCXR3X2Rldi0+ZXZlbnRfcXVldWVbaV0g
PSAoVFdfRXZlbnQgKikoKHVuc2lnbmVkIGNoYXIgKil0d19kZXYtPmV2ZW50X3F1ZXVlWzBdICsg
KGkgKiBzaXplb2YoVFdfRXZlbnQpKSk7CisJCXR3X2Rldi0+ZnJlZV9xdWV1ZVtpXSA9IGk7CisJ
CXR3X2Rldi0+c3RhdGVbaV0gPSBUV19TX0lOSVRJQUw7CisJfQorCisJdHdfZGV2LT5mcmVlX2hl
YWQgPSBUV19RX1NUQVJUOworCXR3X2Rldi0+ZnJlZV90YWlsID0gVFdfUV9TVEFSVDsKKwl0d19k
ZXYtPmVycm9yX3NlcXVlbmNlX2lkID0gMTsKKwl0d19kZXYtPmNocmRldl9yZXF1ZXN0X2lkID0g
VFdfSU9DVExfQ0hSREVWX0ZSRUU7CisKKwltdXRleF9pbml0KCZ0d19kZXYtPmlvY3RsX2xvY2sp
OworCWluaXRfd2FpdHF1ZXVlX2hlYWQoJnR3X2Rldi0+aW9jdGxfd3F1ZXVlKTsKKworCXJldHZh
bCA9IDA7CitvdXQ6CisJcmV0dXJuIHJldHZhbDsKK30gLyogRW5kIHR3bF9pbml0aWFsaXplX2Rl
dmljZV9leHRlbnNpb24oKSAqLworCisvKiBUaGlzIGZ1bmN0aW9uIHdpbGwgcGVyZm9ybSBhIHBj
aS1kbWEgdW5tYXAgKi8KK3N0YXRpYyB2b2lkIHR3bF91bm1hcF9zY3NpX2RhdGEoVFdfRGV2aWNl
X0V4dGVuc2lvbiAqdHdfZGV2LCBpbnQgcmVxdWVzdF9pZCkKK3sKKwlzdHJ1Y3Qgc2NzaV9jbW5k
ICpjbWQgPSB0d19kZXYtPnNyYltyZXF1ZXN0X2lkXTsKKworCWlmIChjbWQtPlNDcC5waGFzZSA9
PSBUV19QSEFTRV9TR0xJU1QpCisJCXNjc2lfZG1hX3VubWFwKGNtZCk7Cit9IC8qIEVuZCB0d2xf
dW5tYXBfc2NzaV9kYXRhKCkgKi8KKworLyogVGhpcyBmdW5jdGlvbiB3aWxsIGhhbmRsZSBhdHRl
bnRpb24gaW50ZXJydXB0cyAqLworc3RhdGljIGludCB0d2xfaGFuZGxlX2F0dGVudGlvbl9pbnRl
cnJ1cHQoVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2KQoreworCWludCByZXR2YWwgPSAxOwor
CXUzMiByZXF1ZXN0X2lkLCBkb29yYmVsbDsKKworCS8qIFJlYWQgZG9vcmJlbGwgc3RhdHVzICov
CisJZG9vcmJlbGwgPSByZWFkbChUV0xfSE9CREJfUkVHX0FERFIodHdfZGV2KSk7CisKKwkvKiBD
aGVjayBmb3IgY29udHJvbGxlciBlcnJvcnMgKi8KKwlpZiAoZG9vcmJlbGwgJiBUV0xfRE9PUkJF
TExfQ09OVFJPTExFUl9FUlJPUikgeworCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklW
RVIsIDB4ZCwgIk1pY3JvY29udHJvbGxlciBFcnJvcjogY2xlYXJpbmciKTsKKwkJZ290byBvdXQ7
CisJfQorCisJLyogQ2hlY2sgaWYgd2UgbmVlZCB0byBwZXJmb3JtIGFuIEFFTiBkcmFpbiAqLwor
CWlmIChkb29yYmVsbCAmIFRXTF9ET09SQkVMTF9BVFRFTlRJT05fSU5URVJSVVBUKSB7CisJCWlm
ICghKHRlc3RfYW5kX3NldF9iaXQoVFdfSU5fQVRURU5USU9OX0xPT1AsICZ0d19kZXYtPmZsYWdz
KSkpIHsKKwkJCXR3bF9nZXRfcmVxdWVzdF9pZCh0d19kZXYsICZyZXF1ZXN0X2lkKTsKKwkJCWlm
ICh0d2xfYWVuX3JlYWRfcXVldWUodHdfZGV2LCByZXF1ZXN0X2lkKSkgeworCQkJCXR3X2Rldi0+
c3RhdGVbcmVxdWVzdF9pZF0gPSBUV19TX0NPTVBMRVRFRDsKKwkJCQl0d2xfZnJlZV9yZXF1ZXN0
X2lkKHR3X2RldiwgcmVxdWVzdF9pZCk7CisJCQkJY2xlYXJfYml0KFRXX0lOX0FUVEVOVElPTl9M
T09QLCAmdHdfZGV2LT5mbGFncyk7CisJCQl9CisJCX0KKwl9CisKKwlyZXR2YWwgPSAwOworb3V0
OgorCS8qIENsZWFyIGRvb3JiZWxsIGludGVycnVwdCAqLworCVRXTF9DTEVBUl9EQl9JTlRFUlJV
UFQodHdfZGV2KTsKKworCS8qIE1ha2Ugc3VyZSB0aGUgY2xlYXIgd2FzIGZsdXNoZWQgYnkgcmVh
ZGluZyBpdCBiYWNrICovCisJcmVhZGwoVFdMX0hPQkRCQ19SRUdfQUREUih0d19kZXYpKTsKKwor
CXJldHVybiByZXR2YWw7Cit9IC8qIEVuZCB0d2xfaGFuZGxlX2F0dGVudGlvbl9pbnRlcnJ1cHQo
KSAqLworCisvKiBJbnRlcnJ1cHQgc2VydmljZSByb3V0aW5lICovCitzdGF0aWMgaXJxcmV0dXJu
X3QgdHdsX2ludGVycnVwdChpbnQgaXJxLCB2b2lkICpkZXZfaW5zdGFuY2UpCit7CisJVFdfRGV2
aWNlX0V4dGVuc2lvbiAqdHdfZGV2ID0gKFRXX0RldmljZV9FeHRlbnNpb24gKilkZXZfaW5zdGFu
Y2U7CisJaW50IGksIGhhbmRsZWQgPSAwLCBlcnJvciA9IDA7CisJZG1hX2FkZHJfdCBtZmEgPSAw
OworCXUzMiByZWcsIHJlZ2wsIHJlZ2gsIHJlc3BvbnNlLCByZXF1ZXN0X2lkID0gMDsKKwlzdHJ1
Y3Qgc2NzaV9jbW5kICpjbWQ7CisJVFdfQ29tbWFuZF9GdWxsICpmdWxsX2NvbW1hbmRfcGFja2V0
OworCisJc3Bpbl9sb2NrKHR3X2Rldi0+aG9zdC0+aG9zdF9sb2NrKTsKKworCS8qIFJlYWQgaG9z
dCBpbnRlcnJ1cHQgc3RhdHVzICovCisJcmVnID0gcmVhZGwoVFdMX0hJU1RBVF9SRUdfQUREUih0
d19kZXYpKTsKKworCS8qIENoZWNrIGlmIHRoaXMgaXMgb3VyIGludGVycnVwdCwgb3RoZXJ3aXNl
IGJhaWwgKi8KKwlpZiAoIShyZWcgJiBUV0xfSElTVEFUVVNfVkFMSURfSU5URVJSVVBUKSkKKwkJ
Z290byB0d2xfaW50ZXJydXB0X2JhaWw7CisKKwloYW5kbGVkID0gMTsKKworCS8qIElmIHdlIGFy
ZSByZXNldHRpbmcsIGJhaWwgKi8KKwlpZiAodGVzdF9iaXQoVFdfSU5fUkVTRVQsICZ0d19kZXYt
PmZsYWdzKSkKKwkJZ290byB0d2xfaW50ZXJydXB0X2JhaWw7CisKKwkvKiBBdHRlbnRpb24gaW50
ZXJydXB0ICovCisJaWYgKHJlZyAmIFRXTF9ISVNUQVRVU19BVFRFTlRJT05fSU5URVJSVVBUKSB7
CisJCWlmICh0d2xfaGFuZGxlX2F0dGVudGlvbl9pbnRlcnJ1cHQodHdfZGV2KSkgeworCQkJVFdM
X01BU0tfSU5URVJSVVBUUyh0d19kZXYpOworCQkJZ290byB0d2xfaW50ZXJydXB0X2JhaWw7CisJ
CX0KKwl9CisKKwkvKiBSZXNwb25zZSBpbnRlcnJ1cHQgKi8KKwl3aGlsZSAocmVnICYgVFdMX0hJ
U1RBVFVTX1JFU1BPTlNFX0lOVEVSUlVQVCkgeworCQlpZiAoc2l6ZW9mKGRtYV9hZGRyX3QpID4g
NCkgeworCQkJcmVnaCA9IHJlYWRsKFRXTF9IT0JRUEhfUkVHX0FERFIodHdfZGV2KSk7CisJCQly
ZWdsID0gcmVhZGwoVFdMX0hPQlFQTF9SRUdfQUREUih0d19kZXYpKTsKKwkJCW1mYSA9ICgodTY0
KXJlZ2ggPDwgMzIpIHwgcmVnbDsKKwkJfSBlbHNlCisJCQltZmEgPSByZWFkbChUV0xfSE9CUVBM
X1JFR19BRERSKHR3X2RldikpOworCisJCWVycm9yID0gMDsKKwkJcmVzcG9uc2UgPSAodTMyKW1m
YTsKKworCQkvKiBDaGVjayBmb3IgY29tbWFuZCBwYWNrZXQgZXJyb3IgKi8KKwkJaWYgKCFUV19O
T1RNRkFfT1VUKHJlc3BvbnNlKSkgeworCQkJZm9yIChpPTA7aTxUV19RX0xFTkdUSDtpKyspIHsK
KwkJCQlpZiAodHdfZGV2LT5zZW5zZV9idWZmZXJfcGh5c1tpXSA9PSBtZmEpIHsKKwkJCQkJcmVx
dWVzdF9pZCA9IGxlMTZfdG9fY3B1KHR3X2Rldi0+c2Vuc2VfYnVmZmVyX3ZpcnRbaV0tPmhlYWRl
cl9kZXNjLnJlcXVlc3RfaWQpOworCQkJCQlpZiAodHdfZGV2LT5zcmJbcmVxdWVzdF9pZF0gIT0g
TlVMTCkKKwkJCQkJCWVycm9yID0gdHdsX2ZpbGxfc2Vuc2UodHdfZGV2LCBpLCByZXF1ZXN0X2lk
LCAxLCAxKTsKKwkJCQkJZWxzZSB7CisJCQkJCQkvKiBTa2lwIGlvY3RsIGVycm9yIHByaW50cyAq
LworCQkJCQkJaWYgKHJlcXVlc3RfaWQgIT0gdHdfZGV2LT5jaHJkZXZfcmVxdWVzdF9pZCkKKwkJ
CQkJCQllcnJvciA9IHR3bF9maWxsX3NlbnNlKHR3X2RldiwgaSwgcmVxdWVzdF9pZCwgMCwgMSk7
CisJCQkJCQllbHNlCisJCQkJCQkJbWVtY3B5KHR3X2Rldi0+Y29tbWFuZF9wYWNrZXRfdmlydFty
ZXF1ZXN0X2lkXSwgdHdfZGV2LT5zZW5zZV9idWZmZXJfdmlydFtpXSwgc2l6ZW9mKFRXX0NvbW1h
bmRfQXBhY2hlX0hlYWRlcikpOworCQkJCQl9CisKKwkJCQkJLyogTm93IHJlLXBvc3QgdGhlIHNl
bnNlIGJ1ZmZlciAqLworCQkJCQl3cml0ZWwoKHUzMikoKHU2NCl0d19kZXYtPnNlbnNlX2J1ZmZl
cl9waHlzW2ldID4+IDMyKSwgVFdMX0hPQlFQSF9SRUdfQUREUih0d19kZXYpKTsKKwkJCQkJd3Jp
dGVsKCh1MzIpdHdfZGV2LT5zZW5zZV9idWZmZXJfcGh5c1tpXSwgVFdMX0hPQlFQTF9SRUdfQURE
Uih0d19kZXYpKTsKKwkJCQkJYnJlYWs7CisJCQkJfQorCQkJfQorCQl9IGVsc2UKKwkJCXJlcXVl
c3RfaWQgPSBUV19SRVNJRF9PVVQocmVzcG9uc2UpOworCisJCWZ1bGxfY29tbWFuZF9wYWNrZXQg
PSB0d19kZXYtPmNvbW1hbmRfcGFja2V0X3ZpcnRbcmVxdWVzdF9pZF07CisKKwkJLyogQ2hlY2sg
Zm9yIGNvcnJlY3Qgc3RhdGUgKi8KKwkJaWYgKHR3X2Rldi0+c3RhdGVbcmVxdWVzdF9pZF0gIT0g
VFdfU19QT1NURUQpIHsKKwkJCWlmICh0d19kZXYtPnNyYltyZXF1ZXN0X2lkXSAhPSBOVUxMKSB7
CisJCQkJVFdfUFJJTlRLKHR3X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAweGUsICJSZWNlaXZlZCBh
IHJlcXVlc3QgaWQgdGhhdCB3YXNuJ3QgcG9zdGVkIik7CisJCQkJVFdMX01BU0tfSU5URVJSVVBU
Uyh0d19kZXYpOworCQkJCWdvdG8gdHdsX2ludGVycnVwdF9iYWlsOworCQkJfQorCQl9CisKKwkJ
LyogQ2hlY2sgZm9yIGludGVybmFsIGNvbW1hbmQgY29tcGxldGlvbiAqLworCQlpZiAodHdfZGV2
LT5zcmJbcmVxdWVzdF9pZF0gPT0gTlVMTCkgeworCQkJaWYgKHJlcXVlc3RfaWQgIT0gdHdfZGV2
LT5jaHJkZXZfcmVxdWVzdF9pZCkgeworCQkJCWlmICh0d2xfYWVuX2NvbXBsZXRlKHR3X2Rldiwg
cmVxdWVzdF9pZCkpCisJCQkJCVRXX1BSSU5USyh0d19kZXYtPmhvc3QsIFRXX0RSSVZFUiwgMHhm
LCAiRXJyb3IgY29tcGxldGluZyBBRU4gZHVyaW5nIGF0dGVudGlvbiBpbnRlcnJ1cHQiKTsKKwkJ
CX0gZWxzZSB7CisJCQkJdHdfZGV2LT5jaHJkZXZfcmVxdWVzdF9pZCA9IFRXX0lPQ1RMX0NIUkRF
Vl9GUkVFOworCQkJCXdha2VfdXAoJnR3X2Rldi0+aW9jdGxfd3F1ZXVlKTsKKwkJCX0KKwkJfSBl
bHNlIHsKKwkJCWNtZCA9IHR3X2Rldi0+c3JiW3JlcXVlc3RfaWRdOworCisJCQlpZiAoIWVycm9y
KQorCQkJCWNtZC0+cmVzdWx0ID0gKERJRF9PSyA8PCAxNik7CisJCQkKKwkJCS8qIFJlcG9ydCBy
ZXNpZHVhbCBieXRlcyBmb3Igc2luZ2xlIHNnbCAqLworCQkJaWYgKChzY3NpX3NnX2NvdW50KGNt
ZCkgPD0gMSkgJiYgKGZ1bGxfY29tbWFuZF9wYWNrZXQtPmNvbW1hbmQubmV3Y29tbWFuZC5zdGF0
dXMgPT0gMCkpIHsKKwkJCQlpZiAoZnVsbF9jb21tYW5kX3BhY2tldC0+Y29tbWFuZC5uZXdjb21t
YW5kLnNnX2xpc3RbMF0ubGVuZ3RoIDwgc2NzaV9idWZmbGVuKHR3X2Rldi0+c3JiW3JlcXVlc3Rf
aWRdKSkKKwkJCQkJc2NzaV9zZXRfcmVzaWQoY21kLCBzY3NpX2J1ZmZsZW4oY21kKSAtIGZ1bGxf
Y29tbWFuZF9wYWNrZXQtPmNvbW1hbmQubmV3Y29tbWFuZC5zZ19saXN0WzBdLmxlbmd0aCk7CisJ
CQl9CisKKwkJCS8qIE5vdyBjb21wbGV0ZSB0aGUgaW8gKi8KKwkJCXR3X2Rldi0+c3RhdGVbcmVx
dWVzdF9pZF0gPSBUV19TX0NPTVBMRVRFRDsKKwkJCXR3bF9mcmVlX3JlcXVlc3RfaWQodHdfZGV2
LCByZXF1ZXN0X2lkKTsKKwkJCXR3X2Rldi0+cG9zdGVkX3JlcXVlc3RfY291bnQtLTsKKwkJCXR3
X2Rldi0+c3JiW3JlcXVlc3RfaWRdLT5zY3NpX2RvbmUodHdfZGV2LT5zcmJbcmVxdWVzdF9pZF0p
OworCQkJdHdsX3VubWFwX3Njc2lfZGF0YSh0d19kZXYsIHJlcXVlc3RfaWQpOworCQl9CisKKwkJ
LyogQ2hlY2sgZm9yIGFub3RoZXIgcmVzcG9uc2UgaW50ZXJydXB0ICovCisJCXJlZyA9IHJlYWRs
KFRXTF9ISVNUQVRfUkVHX0FERFIodHdfZGV2KSk7CisJfQorCit0d2xfaW50ZXJydXB0X2JhaWw6
CisJc3Bpbl91bmxvY2sodHdfZGV2LT5ob3N0LT5ob3N0X2xvY2spOworCXJldHVybiBJUlFfUkVU
VkFMKGhhbmRsZWQpOworfSAvKiBFbmQgdHdsX2ludGVycnVwdCgpICovCisKKy8qIFRoaXMgZnVu
Y3Rpb24gd2lsbCBwb2xsIGZvciBhIHJlZ2lzdGVyIGNoYW5nZSAqLworc3RhdGljIGludCB0d2xf
cG9sbF9yZWdpc3RlcihUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYsIHZvaWQgKnJlZywgdTMy
IHZhbHVlLCB1MzIgcmVzdWx0LCBpbnQgc2Vjb25kcykKK3sKKwl1bnNpZ25lZCBsb25nIGJlZm9y
ZTsKKwlpbnQgcmV0dmFsID0gMTsKKwl1MzIgcmVnX3ZhbHVlOworCisJcmVnX3ZhbHVlID0gcmVh
ZGwocmVnKTsKKwliZWZvcmUgPSBqaWZmaWVzOworCisgICAgICAgIHdoaWxlICgocmVnX3ZhbHVl
ICYgdmFsdWUpICE9IHJlc3VsdCkgeworCQlyZWdfdmFsdWUgPSByZWFkbChyZWcpOworCQlpZiAo
dGltZV9hZnRlcihqaWZmaWVzLCBiZWZvcmUgKyBIWiAqIHNlY29uZHMpKQorCQkJZ290byBvdXQ7
CisJCW1zbGVlcCg1MCk7CisJfQorCXJldHZhbCA9IDA7CitvdXQ6CisJcmV0dXJuIHJldHZhbDsK
K30gLyogRW5kIHR3bF9wb2xsX3JlZ2lzdGVyKCkgKi8KKworLyogVGhpcyBmdW5jdGlvbiB3aWxs
IHJlc2V0IGEgY29udHJvbGxlciAqLworc3RhdGljIGludCB0d2xfcmVzZXRfc2VxdWVuY2UoVFdf
RGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2LCBpbnQgc29mdF9yZXNldCkKK3sKKwlpbnQgcmV0dmFs
ID0gMTsKKwlpbnQgaSA9IDA7CisJdTMyIHN0YXR1cyA9IDA7CisJdW5zaWduZWQgc2hvcnQgZndf
b25fY3Rscl9zcmwgPSAwLCBmd19vbl9jdGxyX2FyY2hfaWQgPSAwOworCXVuc2lnbmVkIHNob3J0
IGZ3X29uX2N0bHJfYnJhbmNoID0gMCwgZndfb25fY3Rscl9idWlsZCA9IDA7CisJdTMyIGluaXRf
Y29ubmVjdF9yZXN1bHQgPSAwOworCWludCB0cmllcyA9IDA7CisJaW50IGRvX3NvZnRfcmVzZXQg
PSBzb2Z0X3Jlc2V0OworCisJd2hpbGUgKHRyaWVzIDwgVFdfTUFYX1JFU0VUX1RSSUVTKSB7CisJ
CS8qIERvIGEgc29mdCByZXNldCBpZiBvbmUgaXMgbmVlZGVkICovCisJCWlmIChkb19zb2Z0X3Jl
c2V0KSB7CisJCQlUV0xfU09GVF9SRVNFVCh0d19kZXYpOworCisJCQkvKiBNYWtlIHN1cmUgY29u
dHJvbGxlciBpcyBpbiBhIGdvb2Qgc3RhdGUgKi8KKwkJCWlmICh0d2xfcG9sbF9yZWdpc3Rlcih0
d19kZXYsIFRXTF9TQ1JQRDNfUkVHX0FERFIodHdfZGV2KSwgVFdMX0NPTlRST0xMRVJfUkVBRFks
IDB4MCwgMzApKSB7CisJCQkJVFdfUFJJTlRLKHR3X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAweDEw
LCAiQ29udHJvbGxlciBuZXZlciB3ZW50IG5vbi1yZWFkeSBkdXJpbmcgcmVzZXQgc2VxdWVuY2Ui
KTsKKwkJCQl0cmllcysrOworCQkJCWNvbnRpbnVlOworCQkJfQorCQkJaWYgKHR3bF9wb2xsX3Jl
Z2lzdGVyKHR3X2RldiwgVFdMX1NDUlBEM19SRUdfQUREUih0d19kZXYpLCBUV0xfQ09OVFJPTExF
Ul9SRUFEWSwgVFdMX0NPTlRST0xMRVJfUkVBRFksIDYwKSkgeworCQkJCVRXX1BSSU5USyh0d19k
ZXYtPmhvc3QsIFRXX0RSSVZFUiwgMHgxMSwgIkNvbnRyb2xsZXIgbm90IHJlYWR5IGR1cmluZyBy
ZXNldCBzZXF1ZW5jZSIpOworCQkJCXRyaWVzKys7CisJCQkJY29udGludWU7CisJCQl9CisJCX0K
KworCQkvKiBJbml0Y29ubmVjdCAqLworCQlpZiAodHdsX2luaXRjb25uZWN0aW9uKHR3X2Rldiwg
VFdfSU5JVF9NRVNTQUdFX0NSRURJVFMsCisJCQkJICAgICAgIFRXX0VYVEVOREVEX0lOSVRfQ09O
TkVDVCwgVFdfQ1VSUkVOVF9EUklWRVJfU1JMLAorCQkJCSAgICAgICBUV185NzUwX0FSQ0hfSUQs
IFRXX0NVUlJFTlRfRFJJVkVSX0JSQU5DSCwKKwkJCQkgICAgICAgVFdfQ1VSUkVOVF9EUklWRVJf
QlVJTEQsICZmd19vbl9jdGxyX3NybCwKKwkJCQkgICAgICAgJmZ3X29uX2N0bHJfYXJjaF9pZCwg
JmZ3X29uX2N0bHJfYnJhbmNoLAorCQkJCSAgICAgICAmZndfb25fY3Rscl9idWlsZCwgJmluaXRf
Y29ubmVjdF9yZXN1bHQpKSB7CisJCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIs
IDB4MTIsICJJbml0Y29ubmVjdGlvbiBmYWlsZWQgd2hpbGUgY2hlY2tpbmcgU1JMIik7CisJCQlk
b19zb2Z0X3Jlc2V0ID0gMTsKKwkJCXRyaWVzKys7CisJCQljb250aW51ZTsKKwkJfQorCisJCS8q
IExvYWQgc2Vuc2UgYnVmZmVycyAqLworCQl3aGlsZSAoaSA8IFRXX1FfTEVOR1RIKSB7CisJCQl3
cml0ZWwoKHUzMikoKHU2NCl0d19kZXYtPnNlbnNlX2J1ZmZlcl9waHlzW2ldID4+IDMyKSwgVFdM
X0hPQlFQSF9SRUdfQUREUih0d19kZXYpKTsKKwkJCXdyaXRlbCgodTMyKXR3X2Rldi0+c2Vuc2Vf
YnVmZmVyX3BoeXNbaV0sIFRXTF9IT0JRUExfUkVHX0FERFIodHdfZGV2KSk7CisKKwkJCS8qIENo
ZWNrIHN0YXR1cyBmb3Igb3Zlci1ydW4gYWZ0ZXIgZWFjaCB3cml0ZSAqLworCQkJc3RhdHVzID0g
cmVhZGwoVFdMX1NUQVRVU19SRUdfQUREUih0d19kZXYpKTsKKwkJCWlmICghKHN0YXR1cyAmIFRX
TF9TVEFUVVNfT1ZFUlJVTl9TVUJNSVQpKQorCQkJICAgIGkrKzsKKwkJfQorCisJCS8qIE5vdyBj
aGVjayBzdGF0dXMgKi8KKwkJc3RhdHVzID0gcmVhZGwoVFdMX1NUQVRVU19SRUdfQUREUih0d19k
ZXYpKTsKKwkJaWYgKHN0YXR1cykgeworCQkJVFdfUFJJTlRLKHR3X2Rldi0+aG9zdCwgVFdfRFJJ
VkVSLCAweDEzLCAiQmFkIGNvbnRyb2xsZXIgc3RhdHVzIGFmdGVyIGxvYWRpbmcgc2Vuc2UgYnVm
ZmVycyIpOworCQkJZG9fc29mdF9yZXNldCA9IDE7CisJCQl0cmllcysrOworCQkJY29udGludWU7
CisJCX0KKworCQkvKiBEcmFpbiB0aGUgQUVOIHF1ZXVlICovCisJCWlmICh0d2xfYWVuX2RyYWlu
X3F1ZXVlKHR3X2Rldiwgc29mdF9yZXNldCkpIHsKKwkJCVRXX1BSSU5USyh0d19kZXYtPmhvc3Qs
IFRXX0RSSVZFUiwgMHgxNCwgIkFFTiBkcmFpbiBmYWlsZWQgZHVyaW5nIHJlc2V0IHNlcXVlbmNl
Iik7CisJCQlkb19zb2Z0X3Jlc2V0ID0gMTsKKwkJCXRyaWVzKys7CisJCQljb250aW51ZTsKKwkJ
fQorCisJCS8qIExvYWQgcmVzdCBvZiBjb21wYXRpYmlsaXR5IHN0cnVjdCAqLworCQlzdHJuY3B5
KHR3X2Rldi0+dHdfY29tcGF0X2luZm8uZHJpdmVyX3ZlcnNpb24sIFRXX0RSSVZFUl9WRVJTSU9O
LCBzdHJsZW4oVFdfRFJJVkVSX1ZFUlNJT04pKTsKKwkJdHdfZGV2LT50d19jb21wYXRfaW5mby5k
cml2ZXJfc3JsX2hpZ2ggPSBUV19DVVJSRU5UX0RSSVZFUl9TUkw7CisJCXR3X2Rldi0+dHdfY29t
cGF0X2luZm8uZHJpdmVyX2JyYW5jaF9oaWdoID0gVFdfQ1VSUkVOVF9EUklWRVJfQlJBTkNIOwor
CQl0d19kZXYtPnR3X2NvbXBhdF9pbmZvLmRyaXZlcl9idWlsZF9oaWdoID0gVFdfQ1VSUkVOVF9E
UklWRVJfQlVJTEQ7CisJCXR3X2Rldi0+dHdfY29tcGF0X2luZm8uZHJpdmVyX3NybF9sb3cgPSBU
V19CQVNFX0ZXX1NSTDsKKwkJdHdfZGV2LT50d19jb21wYXRfaW5mby5kcml2ZXJfYnJhbmNoX2xv
dyA9IFRXX0JBU0VfRldfQlJBTkNIOworCQl0d19kZXYtPnR3X2NvbXBhdF9pbmZvLmRyaXZlcl9i
dWlsZF9sb3cgPSBUV19CQVNFX0ZXX0JVSUxEOworCQl0d19kZXYtPnR3X2NvbXBhdF9pbmZvLmZ3
X29uX2N0bHJfc3JsID0gZndfb25fY3Rscl9zcmw7CisJCXR3X2Rldi0+dHdfY29tcGF0X2luZm8u
Zndfb25fY3Rscl9icmFuY2ggPSBmd19vbl9jdGxyX2JyYW5jaDsKKwkJdHdfZGV2LT50d19jb21w
YXRfaW5mby5md19vbl9jdGxyX2J1aWxkID0gZndfb25fY3Rscl9idWlsZDsKKworCQkvKiBJZiB3
ZSBnb3QgaGVyZSwgY29udHJvbGxlciBpcyBpbiBhIGdvb2Qgc3RhdGUgKi8KKwkJcmV0dmFsID0g
MDsKKwkJZ290byBvdXQ7CisJfQorb3V0OgorCXJldHVybiByZXR2YWw7Cit9IC8qIEVuZCB0d2xf
cmVzZXRfc2VxdWVuY2UoKSAqLworCisvKiBUaGlzIGZ1bmN0aW9uIHdpbGwgcmVzZXQgYSBkZXZp
Y2UgZXh0ZW5zaW9uICovCitzdGF0aWMgaW50IHR3bF9yZXNldF9kZXZpY2VfZXh0ZW5zaW9uKFRX
X0RldmljZV9FeHRlbnNpb24gKnR3X2RldiwgaW50IGlvY3RsX3Jlc2V0KQoreworCWludCBpID0g
MCwgcmV0dmFsID0gMTsKKwl1bnNpZ25lZCBsb25nIGZsYWdzID0gMDsKKworCS8qIEJsb2NrIFND
U0kgcmVxdWVzdHMgd2hpbGUgd2UgYXJlIHJlc2V0dGluZyAqLworCWlmIChpb2N0bF9yZXNldCkK
KwkJc2NzaV9ibG9ja19yZXF1ZXN0cyh0d19kZXYtPmhvc3QpOworCisJc2V0X2JpdChUV19JTl9S
RVNFVCwgJnR3X2Rldi0+ZmxhZ3MpOworCVRXTF9NQVNLX0lOVEVSUlVQVFModHdfZGV2KTsKKwlU
V0xfQ0xFQVJfREJfSU5URVJSVVBUKHR3X2Rldik7CisKKwlzcGluX2xvY2tfaXJxc2F2ZSh0d19k
ZXYtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOworCisJLyogQWJvcnQgYWxsIHJlcXVlc3RzIHRo
YXQgYXJlIGluIHByb2dyZXNzICovCisJZm9yIChpID0gMDsgaSA8IFRXX1FfTEVOR1RIOyBpKysp
IHsKKwkJaWYgKCh0d19kZXYtPnN0YXRlW2ldICE9IFRXX1NfRklOSVNIRUQpICYmCisJCSAgICAo
dHdfZGV2LT5zdGF0ZVtpXSAhPSBUV19TX0lOSVRJQUwpICYmCisJCSAgICAodHdfZGV2LT5zdGF0
ZVtpXSAhPSBUV19TX0NPTVBMRVRFRCkpIHsKKwkJCWlmICh0d19kZXYtPnNyYltpXSkgeworCQkJ
CXR3X2Rldi0+c3JiW2ldLT5yZXN1bHQgPSAoRElEX1JFU0VUIDw8IDE2KTsKKwkJCQl0d19kZXYt
PnNyYltpXS0+c2NzaV9kb25lKHR3X2Rldi0+c3JiW2ldKTsKKwkJCQl0d2xfdW5tYXBfc2NzaV9k
YXRhKHR3X2RldiwgaSk7CisJCQl9CisJCX0KKwl9CisKKwkvKiBSZXNldCBxdWV1ZXMgYW5kIGNv
dW50cyAqLworCWZvciAoaSA9IDA7IGkgPCBUV19RX0xFTkdUSDsgaSsrKSB7CisJCXR3X2Rldi0+
ZnJlZV9xdWV1ZVtpXSA9IGk7CisJCXR3X2Rldi0+c3RhdGVbaV0gPSBUV19TX0lOSVRJQUw7CisJ
fQorCXR3X2Rldi0+ZnJlZV9oZWFkID0gVFdfUV9TVEFSVDsKKwl0d19kZXYtPmZyZWVfdGFpbCA9
IFRXX1FfU1RBUlQ7CisJdHdfZGV2LT5wb3N0ZWRfcmVxdWVzdF9jb3VudCA9IDA7CisKKwlzcGlu
X3VubG9ja19pcnFyZXN0b3JlKHR3X2Rldi0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7CisKKwlp
ZiAodHdsX3Jlc2V0X3NlcXVlbmNlKHR3X2RldiwgMSkpCisJCWdvdG8gb3V0OworCisJVFdMX1VO
TUFTS19JTlRFUlJVUFRTKHR3X2Rldik7CisKKwljbGVhcl9iaXQoVFdfSU5fUkVTRVQsICZ0d19k
ZXYtPmZsYWdzKTsKKwl0d19kZXYtPmNocmRldl9yZXF1ZXN0X2lkID0gVFdfSU9DVExfQ0hSREVW
X0ZSRUU7CisKKwlyZXR2YWwgPSAwOworb3V0OgorCWlmIChpb2N0bF9yZXNldCkKKwkJc2NzaV91
bmJsb2NrX3JlcXVlc3RzKHR3X2Rldi0+aG9zdCk7CisJcmV0dXJuIHJldHZhbDsKK30gLyogRW5k
IHR3bF9yZXNldF9kZXZpY2VfZXh0ZW5zaW9uKCkgKi8KKworLyogVGhpcyBmdW5jaXRvbiByZXR1
cm5zIHVuaXQgZ2VvbWV0cnkgaW4gY3lsaW5kZXJzL2hlYWRzL3NlY3RvcnMgKi8KK3N0YXRpYyBp
bnQgdHdsX3Njc2lfYmlvc3BhcmFtKHN0cnVjdCBzY3NpX2RldmljZSAqc2Rldiwgc3RydWN0IGJs
b2NrX2RldmljZSAqYmRldiwgc2VjdG9yX3QgY2FwYWNpdHksIGludCBnZW9tW10pCit7CisJaW50
IGhlYWRzLCBzZWN0b3JzLCBjeWxpbmRlcnM7CisJVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2
OworCisJdHdfZGV2ID0gKFRXX0RldmljZV9FeHRlbnNpb24gKilzZGV2LT5ob3N0LT5ob3N0ZGF0
YTsKKworCWlmIChjYXBhY2l0eSA+PSAweDIwMDAwMCkgeworCQloZWFkcyA9IDI1NTsKKwkJc2Vj
dG9ycyA9IDYzOworCQljeWxpbmRlcnMgPSBzZWN0b3JfZGl2KGNhcGFjaXR5LCBoZWFkcyAqIHNl
Y3RvcnMpOworCX0gZWxzZSB7CisJCWhlYWRzID0gNjQ7CisJCXNlY3RvcnMgPSAzMjsKKwkJY3ls
aW5kZXJzID0gc2VjdG9yX2RpdihjYXBhY2l0eSwgaGVhZHMgKiBzZWN0b3JzKTsKKwl9CisKKwln
ZW9tWzBdID0gaGVhZHM7CisJZ2VvbVsxXSA9IHNlY3RvcnM7CisJZ2VvbVsyXSA9IGN5bGluZGVy
czsKKworCXJldHVybiAwOworfSAvKiBFbmQgdHdsX3Njc2lfYmlvc3BhcmFtKCkgKi8KKworLyog
VGhpcyBpcyB0aGUgbmV3IHNjc2kgZWggcmVzZXQgZnVuY3Rpb24gKi8KK3N0YXRpYyBpbnQgdHds
X3Njc2lfZWhfcmVzZXQoc3RydWN0IHNjc2lfY21uZCAqU0NwbnQpCit7CisJVFdfRGV2aWNlX0V4
dGVuc2lvbiAqdHdfZGV2ID0gTlVMTDsKKwlpbnQgcmV0dmFsID0gRkFJTEVEOworCisJdHdfZGV2
ID0gKFRXX0RldmljZV9FeHRlbnNpb24gKilTQ3BudC0+ZGV2aWNlLT5ob3N0LT5ob3N0ZGF0YTsK
KworCXR3X2Rldi0+bnVtX3Jlc2V0cysrOworCisJc2Rldl9wcmludGsoS0VSTl9XQVJOSU5HLCBT
Q3BudC0+ZGV2aWNlLAorCQkiV0FSTklORzogKDB4JTAyWDoweCUwNFgpOiBDb21tYW5kICgweCV4
KSB0aW1lZCBvdXQsIHJlc2V0dGluZyBjYXJkLlxuIiwKKwkJVFdfRFJJVkVSLCAweDJjLCBTQ3Bu
dC0+Y21uZFswXSk7CisKKwkvKiBNYWtlIHN1cmUgd2UgYXJlIG5vdCBpc3N1aW5nIGFuIGlvY3Rs
IG9yIHJlc2V0dGluZyBmcm9tIGlvY3RsICovCisJbXV0ZXhfbG9jaygmdHdfZGV2LT5pb2N0bF9s
b2NrKTsKKworCS8qIE5vdyByZXNldCB0aGUgY2FyZCBhbmQgc29tZSBvZiB0aGUgZGV2aWNlIGV4
dGVuc2lvbiBkYXRhICovCisJaWYgKHR3bF9yZXNldF9kZXZpY2VfZXh0ZW5zaW9uKHR3X2Rldiwg
MCkpIHsKKwkJVFdfUFJJTlRLKHR3X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAweDE1LCAiQ29udHJv
bGxlciByZXNldCBmYWlsZWQgZHVyaW5nIHNjc2kgaG9zdCByZXNldCIpOworCQlnb3RvIG91dDsK
Kwl9CisKKwlyZXR2YWwgPSBTVUNDRVNTOworb3V0OgorCW11dGV4X3VubG9jaygmdHdfZGV2LT5p
b2N0bF9sb2NrKTsKKwlyZXR1cm4gcmV0dmFsOworfSAvKiBFbmQgdHdsX3Njc2lfZWhfcmVzZXQo
KSAqLworCisvKiBUaGlzIGlzIHRoZSBtYWluIHNjc2kgcXVldWUgZnVuY3Rpb24gdG8gaGFuZGxl
IHNjc2kgb3Bjb2RlcyAqLworc3RhdGljIGludCB0d2xfc2NzaV9xdWV1ZShzdHJ1Y3Qgc2NzaV9j
bW5kICpTQ3BudCwgdm9pZCAoKmRvbmUpKHN0cnVjdCBzY3NpX2NtbmQgKikpCit7CisJaW50IHJl
cXVlc3RfaWQsIHJldHZhbDsKKwlUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYgPSAoVFdfRGV2
aWNlX0V4dGVuc2lvbiAqKVNDcG50LT5kZXZpY2UtPmhvc3QtPmhvc3RkYXRhOworCisJLyogSWYg
d2UgYXJlIHJlc2V0dGluZyBkdWUgdG8gdGltZWQgb3V0IGlvY3RsLCByZXBvcnQgYXMgYnVzeSAq
LworCWlmICh0ZXN0X2JpdChUV19JTl9SRVNFVCwgJnR3X2Rldi0+ZmxhZ3MpKSB7CisJCXJldHZh
bCA9IFNDU0lfTUxRVUVVRV9IT1NUX0JVU1k7CisJCWdvdG8gb3V0OworCX0KKworCS8qIFNhdmUg
ZG9uZSBmdW5jdGlvbiBpbnRvIHNjc2lfY21uZCBzdHJ1Y3QgKi8KKwlTQ3BudC0+c2NzaV9kb25l
ID0gZG9uZTsKKwkJCisJLyogR2V0IGEgZnJlZSByZXF1ZXN0IGlkICovCisJdHdsX2dldF9yZXF1
ZXN0X2lkKHR3X2RldiwgJnJlcXVlc3RfaWQpOworCisJLyogU2F2ZSB0aGUgc2NzaSBjb21tYW5k
IGZvciB1c2UgYnkgdGhlIElTUiAqLworCXR3X2Rldi0+c3JiW3JlcXVlc3RfaWRdID0gU0NwbnQ7
CisKKwkvKiBJbml0aWFsaXplIHBoYXNlIHRvIHplcm8gKi8KKwlTQ3BudC0+U0NwLnBoYXNlID0g
VFdfUEhBU0VfSU5JVElBTDsKKworCXJldHZhbCA9IHR3bF9zY3Npb3BfZXhlY3V0ZV9zY3NpKHR3
X2RldiwgcmVxdWVzdF9pZCwgTlVMTCwgMCwgTlVMTCk7CisJaWYgKHJldHZhbCkgeworCQl0d19k
ZXYtPnN0YXRlW3JlcXVlc3RfaWRdID0gVFdfU19DT01QTEVURUQ7CisJCXR3bF9mcmVlX3JlcXVl
c3RfaWQodHdfZGV2LCByZXF1ZXN0X2lkKTsKKwkJU0NwbnQtPnJlc3VsdCA9IChESURfRVJST1Ig
PDwgMTYpOworCQlkb25lKFNDcG50KTsKKwkJcmV0dmFsID0gMDsKKwl9CitvdXQ6CisJcmV0dXJu
IHJldHZhbDsKK30gLyogRW5kIHR3bF9zY3NpX3F1ZXVlKCkgKi8KKworLyogVGhpcyBmdW5jdGlv
biB0ZWxscyB0aGUgY29udHJvbGxlciB0byBzaHV0IGRvd24gKi8KK3N0YXRpYyB2b2lkIF9fdHds
X3NodXRkb3duKFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldikKK3sKKwkvKiBEaXNhYmxlIGlu
dGVycnVwdHMgKi8KKwlUV0xfTUFTS19JTlRFUlJVUFRTKHR3X2Rldik7CisKKwkvKiBGcmVlIHVw
IHRoZSBJUlEgKi8KKwlmcmVlX2lycSh0d19kZXYtPnR3X3BjaV9kZXYtPmlycSwgdHdfZGV2KTsK
KworCXByaW50ayhLRVJOX1dBUk5JTkcgIjN3LXNhczogU2h1dHRpbmcgZG93biBob3N0ICVkLlxu
IiwgdHdfZGV2LT5ob3N0LT5ob3N0X25vKTsKKworCS8qIFRlbGwgdGhlIGNhcmQgd2UgYXJlIHNo
dXR0aW5nIGRvd24gKi8KKwlpZiAodHdsX2luaXRjb25uZWN0aW9uKHR3X2RldiwgMSwgMCwgMCwg
MCwgMCwgMCwgTlVMTCwgTlVMTCwgTlVMTCwgTlVMTCwgTlVMTCkpIHsKKwkJVFdfUFJJTlRLKHR3
X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAweDE2LCAiQ29ubmVjdGlvbiBzaHV0ZG93biBmYWlsZWQi
KTsKKwl9IGVsc2UgeworCQlwcmludGsoS0VSTl9XQVJOSU5HICIzdy1zYXM6IFNodXRkb3duIGNv
bXBsZXRlLlxuIik7CisJfQorCisJLyogQ2xlYXIgZG9vcmJlbGwgaW50ZXJydXB0IGp1c3QgYmVm
b3JlIGV4aXQgKi8KKwlUV0xfQ0xFQVJfREJfSU5URVJSVVBUKHR3X2Rldik7Cit9IC8qIEVuZCBf
X3R3bF9zaHV0ZG93bigpICovCisKKy8qIFdyYXBwZXIgZm9yIF9fdHdsX3NodXRkb3duICovCitz
dGF0aWMgdm9pZCB0d2xfc2h1dGRvd24oc3RydWN0IHBjaV9kZXYgKnBkZXYpCit7CisJc3RydWN0
IFNjc2lfSG9zdCAqaG9zdCA9IHBjaV9nZXRfZHJ2ZGF0YShwZGV2KTsKKwlUV19EZXZpY2VfRXh0
ZW5zaW9uICp0d19kZXY7CisKKwlpZiAoIWhvc3QpCisJCXJldHVybjsKKworCXR3X2RldiA9IChU
V19EZXZpY2VfRXh0ZW5zaW9uICopaG9zdC0+aG9zdGRhdGE7CisKKwlpZiAodHdfZGV2LT5vbmxp
bmUpIAorCQlfX3R3bF9zaHV0ZG93bih0d19kZXYpOworfSAvKiBFbmQgdHdsX3NodXRkb3duKCkg
Ki8KKworLyogVGhpcyBmdW5jdGlvbiBjb25maWd1cmVzIHVuaXQgc2V0dGluZ3Mgd2hlbiBhIHVu
aXQgaXMgY29taW5nIG9uLWxpbmUgKi8KK3N0YXRpYyBpbnQgdHdsX3NsYXZlX2NvbmZpZ3VyZShz
dHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYpCit7CisJLyogRm9yY2UgNjAgc2Vjb25kIHRpbWVvdXQg
Ki8KKwlibGtfcXVldWVfcnFfdGltZW91dChzZGV2LT5yZXF1ZXN0X3F1ZXVlLCA2MCAqIEhaKTsK
KworCXJldHVybiAwOworfSAvKiBFbmQgdHdsX3NsYXZlX2NvbmZpZ3VyZSgpICovCisKKy8qIHNj
c2lfaG9zdF90ZW1wbGF0ZSBpbml0aWFsaXplciAqLworc3RhdGljIHN0cnVjdCBzY3NpX2hvc3Rf
dGVtcGxhdGUgZHJpdmVyX3RlbXBsYXRlID0geworCS5tb2R1bGUJCQk9IFRISVNfTU9EVUxFLAor
CS5uYW1lCQkJPSAiM3ctc2FzIiwKKwkucXVldWVjb21tYW5kCQk9IHR3bF9zY3NpX3F1ZXVlLAor
CS5laF9ob3N0X3Jlc2V0X2hhbmRsZXIJPSB0d2xfc2NzaV9laF9yZXNldCwKKwkuYmlvc19wYXJh
bQkJPSB0d2xfc2NzaV9iaW9zcGFyYW0sCisJLmNoYW5nZV9xdWV1ZV9kZXB0aAk9IHR3bF9jaGFu
Z2VfcXVldWVfZGVwdGgsCisJLmNhbl9xdWV1ZQkJPSBUV19RX0xFTkdUSC0yLAorCS5zbGF2ZV9j
b25maWd1cmUJPSB0d2xfc2xhdmVfY29uZmlndXJlLAorCS50aGlzX2lkCQk9IC0xLAorCS5zZ190
YWJsZXNpemUJCT0gVFdfTElCRVJBVE9SX01BWF9TR0xfTEVOR1RILAorCS5tYXhfc2VjdG9ycwkJ
PSBUV19NQVhfU0VDVE9SUywKKwkuY21kX3Blcl9sdW4JCT0gVFdfTUFYX0NNRFNfUEVSX0xVTiwK
KwkudXNlX2NsdXN0ZXJpbmcJCT0gRU5BQkxFX0NMVVNURVJJTkcsCisJLnNob3N0X2F0dHJzCQk9
IHR3bF9ob3N0X2F0dHJzLAorCS5lbXVsYXRlZAkJPSAxCit9OworCisvKiBUaGlzIGZ1bmN0aW9u
IHdpbGwgcHJvYmUgYW5kIGluaXRpYWxpemUgYSBjYXJkICovCitzdGF0aWMgaW50IF9fZGV2aW5p
dCB0d2xfcHJvYmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNl
X2lkICpkZXZfaWQpCit7CisJc3RydWN0IFNjc2lfSG9zdCAqaG9zdCA9IE5VTEw7CisJVFdfRGV2
aWNlX0V4dGVuc2lvbiAqdHdfZGV2OworCXJlc291cmNlX3NpemVfdCBtZW1fYWRkciwgbWVtX2xl
bjsKKwlpbnQgcmV0dmFsID0gLUVOT0RFVjsKKwlpbnQgKnB0cl9waHljb3VudCwgcGh5Y291bnQ9
MDsKKworCXJldHZhbCA9IHBjaV9lbmFibGVfZGV2aWNlKHBkZXYpOworCWlmIChyZXR2YWwpIHsK
KwkJVFdfUFJJTlRLKGhvc3QsIFRXX0RSSVZFUiwgMHgxNywgIkZhaWxlZCB0byBlbmFibGUgcGNp
IGRldmljZSIpOworCQlnb3RvIG91dF9kaXNhYmxlX2RldmljZTsKKwl9CisKKwlwY2lfc2V0X21h
c3RlcihwZGV2KTsKKwlwY2lfdHJ5X3NldF9td2kocGRldik7CisKKwlpZiAocGNpX3NldF9kbWFf
bWFzayhwZGV2LCBETUFfQklUX01BU0soNjQpKQorCSAgICB8fCBwY2lfc2V0X2NvbnNpc3RlbnRf
ZG1hX21hc2socGRldiwgRE1BX0JJVF9NQVNLKDY0KSkpCisJCWlmIChwY2lfc2V0X2RtYV9tYXNr
KHBkZXYsIERNQV9CSVRfTUFTSygzMikpCisJCSAgICB8fCBwY2lfc2V0X2NvbnNpc3RlbnRfZG1h
X21hc2socGRldiwgRE1BX0JJVF9NQVNLKDMyKSkpIHsKKwkJCVRXX1BSSU5USyhob3N0LCBUV19E
UklWRVIsIDB4MTgsICJGYWlsZWQgdG8gc2V0IGRtYSBtYXNrIik7CisJCQlyZXR2YWwgPSAtRU5P
REVWOworCQkJZ290byBvdXRfZGlzYWJsZV9kZXZpY2U7CisJCX0KKworCWhvc3QgPSBzY3NpX2hv
c3RfYWxsb2MoJmRyaXZlcl90ZW1wbGF0ZSwgc2l6ZW9mKFRXX0RldmljZV9FeHRlbnNpb24pKTsK
KwlpZiAoIWhvc3QpIHsKKwkJVFdfUFJJTlRLKGhvc3QsIFRXX0RSSVZFUiwgMHgxOSwgIkZhaWxl
ZCB0byBhbGxvY2F0ZSBtZW1vcnkgZm9yIGRldmljZSBleHRlbnNpb24iKTsKKwkJcmV0dmFsID0g
LUVOT01FTTsKKwkJZ290byBvdXRfZGlzYWJsZV9kZXZpY2U7CisJfQorCXR3X2RldiA9IChUV19E
ZXZpY2VfRXh0ZW5zaW9uICopaG9zdC0+aG9zdGRhdGE7CisKKwkvKiBTYXZlIHZhbHVlcyB0byBk
ZXZpY2UgZXh0ZW5zaW9uICovCisJdHdfZGV2LT5ob3N0ID0gaG9zdDsKKwl0d19kZXYtPnR3X3Bj
aV9kZXYgPSBwZGV2OworCisJaWYgKHR3bF9pbml0aWFsaXplX2RldmljZV9leHRlbnNpb24odHdf
ZGV2KSkgeworCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIsIDB4MWEsICJGYWls
ZWQgdG8gaW5pdGlhbGl6ZSBkZXZpY2UgZXh0ZW5zaW9uIik7CisJCWdvdG8gb3V0X2ZyZWVfZGV2
aWNlX2V4dGVuc2lvbjsKKwl9CisKKwkvKiBSZXF1ZXN0IElPIHJlZ2lvbnMgKi8KKwlyZXR2YWwg
PSBwY2lfcmVxdWVzdF9yZWdpb25zKHBkZXYsICIzdy1zYXMiKTsKKwlpZiAocmV0dmFsKSB7CisJ
CVRXX1BSSU5USyh0d19kZXYtPmhvc3QsIFRXX0RSSVZFUiwgMHgxYiwgIkZhaWxlZCB0byBnZXQg
bWVtIHJlZ2lvbiIpOworCQlnb3RvIG91dF9mcmVlX2RldmljZV9leHRlbnNpb247CisJfQorCisJ
LyogVXNlIHJlZ2lvbiAxICovCisJbWVtX2FkZHIgPSBwY2lfcmVzb3VyY2Vfc3RhcnQocGRldiwg
MSk7CisJbWVtX2xlbiA9IHBjaV9yZXNvdXJjZV9sZW4ocGRldiwgMSk7CisKKwkvKiBTYXZlIGJh
c2UgYWRkcmVzcyAqLworCXR3X2Rldi0+YmFzZV9hZGRyID0gaW9yZW1hcChtZW1fYWRkciwgbWVt
X2xlbik7CisKKwlpZiAoIXR3X2Rldi0+YmFzZV9hZGRyKSB7CisJCVRXX1BSSU5USyh0d19kZXYt
Pmhvc3QsIFRXX0RSSVZFUiwgMHgxYywgIkZhaWxlZCB0byBpb3JlbWFwIik7CisJCWdvdG8gb3V0
X3JlbGVhc2VfbWVtX3JlZ2lvbjsKKwl9CisKKwkvKiBEaXNhYmxlIGludGVycnVwdHMgb24gdGhl
IGNhcmQgKi8KKwlUV0xfTUFTS19JTlRFUlJVUFRTKHR3X2Rldik7CisKKwkvKiBJbml0aWFsaXpl
IHRoZSBjYXJkICovCisJaWYgKHR3bF9yZXNldF9zZXF1ZW5jZSh0d19kZXYsIDApKSB7CisJCVRX
X1BSSU5USyh0d19kZXYtPmhvc3QsIFRXX0RSSVZFUiwgMHgxZCwgIkNvbnRyb2xsZXIgcmVzZXQg
ZmFpbGVkIGR1cmluZyBwcm9iZSIpOworCQlnb3RvIG91dF9pb3VubWFwOworCX0KKworCS8qIFNl
dCBob3N0IHNwZWNpZmljIHBhcmFtZXRlcnMgKi8KKwlob3N0LT5tYXhfaWQgPSBUV19NQVhfVU5J
VFM7CisJaG9zdC0+bWF4X2NtZF9sZW4gPSBUV19NQVhfQ0RCX0xFTjsKKwlob3N0LT5tYXhfbHVu
ID0gVFdfTUFYX0xVTlM7CisJaG9zdC0+bWF4X2NoYW5uZWwgPSAwOworCisJLyogUmVnaXN0ZXIg
dGhlIGNhcmQgd2l0aCB0aGUga2VybmVsIFNDU0kgbGF5ZXIgKi8KKwlyZXR2YWwgPSBzY3NpX2Fk
ZF9ob3N0KGhvc3QsICZwZGV2LT5kZXYpOworCWlmIChyZXR2YWwpIHsKKwkJVFdfUFJJTlRLKHR3
X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAweDFlLCAic2NzaSBhZGQgaG9zdCBmYWlsZWQiKTsKKwkJ
Z290byBvdXRfaW91bm1hcDsKKwl9CisKKwlwY2lfc2V0X2RydmRhdGEocGRldiwgaG9zdCk7CisK
KwlwcmludGsoS0VSTl9XQVJOSU5HICIzdy1zYXM6IHNjc2klZDogRm91bmQgYW4gTFNJIDN3YXJl
ICVzIENvbnRyb2xsZXIgYXQgMHglbGx4LCBJUlE6ICVkLlxuIiwKKwkgICAgICAgaG9zdC0+aG9z
dF9ubywKKwkgICAgICAgKGNoYXIgKil0d2xfZ2V0X3BhcmFtKHR3X2RldiwgMSwgVFdfVkVSU0lP
Tl9UQUJMRSwKKwkJCQkgICAgIFRXX1BBUkFNX01PREVMLCBUV19QQVJBTV9NT0RFTF9MRU5HVEgp
LAorCSAgICAgICAodTY0KW1lbV9hZGRyLCBwZGV2LT5pcnEpOworCisJcHRyX3BoeWNvdW50ID0g
dHdsX2dldF9wYXJhbSh0d19kZXYsIDIsIFRXX1BBUkFNX1BIWV9TVU1NQVJZX1RBQkxFLAorCQkJ
CSAgICAgVFdfUEFSQU1fUEhZQ09VTlQsIFRXX1BBUkFNX1BIWUNPVU5UX0xFTkdUSCk7CisJaWYg
KHB0cl9waHljb3VudCkKKwkJcGh5Y291bnQgPSBsZTMyX3RvX2NwdSgqKGludCAqKXB0cl9waHlj
b3VudCk7CisKKwlwcmludGsoS0VSTl9XQVJOSU5HICIzdy1zYXM6IHNjc2klZDogRmlybXdhcmUg
JXMsIEJJT1MgJXMsIFBoeXM6ICVkLlxuIiwKKwkgICAgICAgaG9zdC0+aG9zdF9ubywKKwkgICAg
ICAgKGNoYXIgKil0d2xfZ2V0X3BhcmFtKHR3X2RldiwgMSwgVFdfVkVSU0lPTl9UQUJMRSwKKwkJ
CQkgICAgIFRXX1BBUkFNX0ZXVkVSLCBUV19QQVJBTV9GV1ZFUl9MRU5HVEgpLAorCSAgICAgICAo
Y2hhciAqKXR3bF9nZXRfcGFyYW0odHdfZGV2LCAyLCBUV19WRVJTSU9OX1RBQkxFLAorCQkJCSAg
ICAgVFdfUEFSQU1fQklPU1ZFUiwgVFdfUEFSQU1fQklPU1ZFUl9MRU5HVEgpLAorCSAgICAgICBw
aHljb3VudCk7CisKKwkvKiBUcnkgdG8gZW5hYmxlIE1TSSAqLworCWlmICh1c2VfbXNpICYmICFw
Y2lfZW5hYmxlX21zaShwZGV2KSkKKwkJc2V0X2JpdChUV19VU0lOR19NU0ksICZ0d19kZXYtPmZs
YWdzKTsKKworCS8qIE5vdyBzZXR1cCB0aGUgaW50ZXJydXB0IGhhbmRsZXIgKi8KKwlyZXR2YWwg
PSByZXF1ZXN0X2lycShwZGV2LT5pcnEsIHR3bF9pbnRlcnJ1cHQsIElSUUZfU0hBUkVELCAiM3ct
c2FzIiwgdHdfZGV2KTsKKwlpZiAocmV0dmFsKSB7CisJCVRXX1BSSU5USyh0d19kZXYtPmhvc3Qs
IFRXX0RSSVZFUiwgMHgxZiwgIkVycm9yIHJlcXVlc3RpbmcgSVJRIik7CisJCWdvdG8gb3V0X3Jl
bW92ZV9ob3N0OworCX0KKworCXR3bF9kZXZpY2VfZXh0ZW5zaW9uX2xpc3RbdHdsX2RldmljZV9l
eHRlbnNpb25fY291bnRdID0gdHdfZGV2OworCXR3bF9kZXZpY2VfZXh0ZW5zaW9uX2NvdW50Kys7
CisKKwkvKiBSZS1lbmFibGUgaW50ZXJydXB0cyBvbiB0aGUgY2FyZCAqLworCVRXTF9VTk1BU0tf
SU5URVJSVVBUUyh0d19kZXYpOworCQorCS8qIEZpbmFsbHksIHNjYW4gdGhlIGhvc3QgKi8KKwlz
Y3NpX3NjYW5faG9zdChob3N0KTsKKworCS8qIEFkZCBzeXNmcyBiaW5hcnkgZmlsZXMgKi8KKwlp
ZiAoc3lzZnNfY3JlYXRlX2Jpbl9maWxlKCZob3N0LT5zaG9zdF9kZXYua29iaiwgJnR3bF9zeXNm
c19hZW5fcmVhZF9hdHRyKSkKKwkJVFdfUFJJTlRLKHR3X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAw
eDIwLCAiRmFpbGVkIHRvIGNyZWF0ZSBzeXNmcyBiaW5hcnkgZmlsZTogM3dhcmVfYWVuX3JlYWQi
KTsKKwlpZiAoc3lzZnNfY3JlYXRlX2Jpbl9maWxlKCZob3N0LT5zaG9zdF9kZXYua29iaiwgJnR3
bF9zeXNmc19jb21wYXRfaW5mb19hdHRyKSkKKwkJVFdfUFJJTlRLKHR3X2Rldi0+aG9zdCwgVFdf
RFJJVkVSLCAweDIxLCAiRmFpbGVkIHRvIGNyZWF0ZSBzeXNmcyBiaW5hcnkgZmlsZTogM3dhcmVf
Y29tcGF0X2luZm8iKTsKKworCWlmICh0d2xfbWFqb3IgPT0gLTEpIHsKKwkJaWYgKCh0d2xfbWFq
b3IgPSByZWdpc3Rlcl9jaHJkZXYgKDAsICJ0d2wiLCAmdHdsX2ZvcHMpKSA8IDApCisJCQlUV19Q
UklOVEsoaG9zdCwgVFdfRFJJVkVSLCAweDIyLCAiRmFpbGVkIHRvIHJlZ2lzdGVyIGNoYXJhY3Rl
ciBkZXZpY2UiKTsKKwl9CisJdHdfZGV2LT5vbmxpbmUgPSAxOworCXJldHVybiAwOworCitvdXRf
cmVtb3ZlX2hvc3Q6CisJaWYgKHRlc3RfYml0KFRXX1VTSU5HX01TSSwgJnR3X2Rldi0+ZmxhZ3Mp
KQorCQlwY2lfZGlzYWJsZV9tc2kocGRldik7CisJc2NzaV9yZW1vdmVfaG9zdChob3N0KTsKK291
dF9pb3VubWFwOgorCWlvdW5tYXAodHdfZGV2LT5iYXNlX2FkZHIpOworb3V0X3JlbGVhc2VfbWVt
X3JlZ2lvbjoKKwlwY2lfcmVsZWFzZV9yZWdpb25zKHBkZXYpOworb3V0X2ZyZWVfZGV2aWNlX2V4
dGVuc2lvbjoKKwl0d2xfZnJlZV9kZXZpY2VfZXh0ZW5zaW9uKHR3X2Rldik7CisJc2NzaV9ob3N0
X3B1dChob3N0KTsKK291dF9kaXNhYmxlX2RldmljZToKKwlwY2lfZGlzYWJsZV9kZXZpY2UocGRl
dik7CisKKwlyZXR1cm4gcmV0dmFsOworfSAvKiBFbmQgdHdsX3Byb2JlKCkgKi8KKworLyogVGhp
cyBmdW5jdGlvbiBpcyBjYWxsZWQgdG8gcmVtb3ZlIGEgZGV2aWNlICovCitzdGF0aWMgdm9pZCB0
d2xfcmVtb3ZlKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQoreworCXN0cnVjdCBTY3NpX0hvc3QgKmhv
c3QgPSBwY2lfZ2V0X2RydmRhdGEocGRldik7CisJVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2
OworCisJaWYgKCFob3N0KQorCQlyZXR1cm47CisKKwl0d19kZXYgPSAoVFdfRGV2aWNlX0V4dGVu
c2lvbiAqKWhvc3QtPmhvc3RkYXRhOworCisJaWYgKCF0d19kZXYtPm9ubGluZSkKKwkJcmV0dXJu
OworCisJLyogUmVtb3ZlIHN5c2ZzIGJpbmFyeSBmaWxlcyAqLworCXN5c2ZzX3JlbW92ZV9iaW5f
ZmlsZSgmaG9zdC0+c2hvc3RfZGV2LmtvYmosICZ0d2xfc3lzZnNfYWVuX3JlYWRfYXR0cik7CisJ
c3lzZnNfcmVtb3ZlX2Jpbl9maWxlKCZob3N0LT5zaG9zdF9kZXYua29iaiwgJnR3bF9zeXNmc19j
b21wYXRfaW5mb19hdHRyKTsKKworCXNjc2lfcmVtb3ZlX2hvc3QodHdfZGV2LT5ob3N0KTsKKwor
CS8qIFVucmVnaXN0ZXIgY2hhcmFjdGVyIGRldmljZSAqLworCWlmICh0d2xfbWFqb3IgPj0gMCkg
eworCQl1bnJlZ2lzdGVyX2NocmRldih0d2xfbWFqb3IsICJ0d2wiKTsKKwkJdHdsX21ham9yID0g
LTE7CisJfQorCisJLyogU2h1dGRvd24gdGhlIGNhcmQgKi8KKwlfX3R3bF9zaHV0ZG93bih0d19k
ZXYpOworCisJLyogRGlzYWJsZSBNU0kgaWYgZW5hYmxlZCAqLworCWlmICh0ZXN0X2JpdChUV19V
U0lOR19NU0ksICZ0d19kZXYtPmZsYWdzKSkKKwkJcGNpX2Rpc2FibGVfbXNpKHBkZXYpOworCisJ
LyogRnJlZSBJTyByZW1hcHBpbmcgKi8KKwlpb3VubWFwKHR3X2Rldi0+YmFzZV9hZGRyKTsKKwor
CS8qIEZyZWUgdXAgdGhlIG1lbSByZWdpb24gKi8KKwlwY2lfcmVsZWFzZV9yZWdpb25zKHBkZXYp
OworCisJLyogRnJlZSB1cCBkZXZpY2UgZXh0ZW5zaW9uIHJlc291cmNlcyAqLworCXR3bF9mcmVl
X2RldmljZV9leHRlbnNpb24odHdfZGV2KTsKKworCXNjc2lfaG9zdF9wdXQodHdfZGV2LT5ob3N0
KTsKKwlwY2lfZGlzYWJsZV9kZXZpY2UocGRldik7CisJdHdsX2RldmljZV9leHRlbnNpb25fY291
bnQtLTsKK30gLyogRW5kIHR3bF9yZW1vdmUoKSAqLworCisjaWZkZWYgQ09ORklHX1BNCisvKiBU
aGlzIGZ1bmN0aW9uIGlzIGNhbGxlZCBvbiBQQ0kgc3VzcGVuZCAqLworc3RhdGljIGludCB0d2xf
c3VzcGVuZChzdHJ1Y3QgcGNpX2RldiAqcGRldiwgcG1fbWVzc2FnZV90IHN0YXRlKQoreworCXN0
cnVjdCBTY3NpX0hvc3QgKmhvc3QgPSBwY2lfZ2V0X2RydmRhdGEocGRldik7CisJVFdfRGV2aWNl
X0V4dGVuc2lvbiAqdHdfZGV2ID0gKFRXX0RldmljZV9FeHRlbnNpb24gKilob3N0LT5ob3N0ZGF0
YTsKKworCXByaW50ayhLRVJOX1dBUk5JTkcgIjN3LXNhczogU3VzcGVuZGluZyBob3N0ICVkLlxu
IiwgdHdfZGV2LT5ob3N0LT5ob3N0X25vKTsKKwkvKiBEaXNhYmxlIGludGVycnVwdHMgKi8KKwlU
V0xfTUFTS19JTlRFUlJVUFRTKHR3X2Rldik7CisKKwlmcmVlX2lycSh0d19kZXYtPnR3X3BjaV9k
ZXYtPmlycSwgdHdfZGV2KTsKKworCS8qIFRlbGwgdGhlIGNhcmQgd2UgYXJlIHNodXR0aW5nIGRv
d24gKi8KKwlpZiAodHdsX2luaXRjb25uZWN0aW9uKHR3X2RldiwgMSwgMCwgMCwgMCwgMCwgMCwg
TlVMTCwgTlVMTCwgTlVMTCwgTlVMTCwgTlVMTCkpIHsKKwkJVFdfUFJJTlRLKHR3X2Rldi0+aG9z
dCwgVFdfRFJJVkVSLCAweDIzLCAiQ29ubmVjdGlvbiBzaHV0ZG93biBmYWlsZWQgZHVyaW5nIHN1
c3BlbmQiKTsKKwl9IGVsc2UgeworCQlwcmludGsoS0VSTl9XQVJOSU5HICIzdy1zYXM6IFN1c3Bl
bmQgY29tcGxldGUuXG4iKTsKKwl9CisKKwkvKiBDbGVhciBkb29yYmVsbCBpbnRlcnJ1cHQgKi8K
KwlUV0xfQ0xFQVJfREJfSU5URVJSVVBUKHR3X2Rldik7CisKKwlwY2lfc2F2ZV9zdGF0ZShwZGV2
KTsKKwlwY2lfZGlzYWJsZV9kZXZpY2UocGRldik7CisJcGNpX3NldF9wb3dlcl9zdGF0ZShwZGV2
LCBwY2lfY2hvb3NlX3N0YXRlKHBkZXYsIHN0YXRlKSk7CisKKwlyZXR1cm4gMDsKK30gLyogRW5k
IHR3bF9zdXNwZW5kKCkgKi8KKworLyogVGhpcyBmdW5jdGlvbiBpcyBjYWxsZWQgb24gUENJIHJl
c3VtZSAqLworc3RhdGljIGludCB0d2xfcmVzdW1lKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQorewor
CWludCByZXR2YWwgPSAwOworCXN0cnVjdCBTY3NpX0hvc3QgKmhvc3QgPSBwY2lfZ2V0X2RydmRh
dGEocGRldik7CisJVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2ID0gKFRXX0RldmljZV9FeHRl
bnNpb24gKilob3N0LT5ob3N0ZGF0YTsKKworCXByaW50ayhLRVJOX1dBUk5JTkcgIjN3LXNhczog
UmVzdW1pbmcgaG9zdCAlZC5cbiIsIHR3X2Rldi0+aG9zdC0+aG9zdF9ubyk7CisJcGNpX3NldF9w
b3dlcl9zdGF0ZShwZGV2LCBQQ0lfRDApOworCXBjaV9lbmFibGVfd2FrZShwZGV2LCBQQ0lfRDAs
IDApOworCXBjaV9yZXN0b3JlX3N0YXRlKHBkZXYpOworCisJcmV0dmFsID0gcGNpX2VuYWJsZV9k
ZXZpY2UocGRldik7CisJaWYgKHJldHZhbCkgeworCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBU
V19EUklWRVIsIDB4MjQsICJFbmFibGUgZGV2aWNlIGZhaWxlZCBkdXJpbmcgcmVzdW1lIik7CisJ
CXJldHVybiByZXR2YWw7CisJfQorCisJcGNpX3NldF9tYXN0ZXIocGRldik7CisJcGNpX3RyeV9z
ZXRfbXdpKHBkZXYpOworCisJaWYgKHBjaV9zZXRfZG1hX21hc2socGRldiwgRE1BX0JJVF9NQVNL
KDY0KSkKKwkgICAgfHwgcGNpX3NldF9jb25zaXN0ZW50X2RtYV9tYXNrKHBkZXYsIERNQV9CSVRf
TUFTSyg2NCkpKQorCQlpZiAocGNpX3NldF9kbWFfbWFzayhwZGV2LCBETUFfQklUX01BU0soMzIp
KQorCQkgICAgfHwgcGNpX3NldF9jb25zaXN0ZW50X2RtYV9tYXNrKHBkZXYsIERNQV9CSVRfTUFT
SygzMikpKSB7CisJCQlUV19QUklOVEsoaG9zdCwgVFdfRFJJVkVSLCAweDI1LCAiRmFpbGVkIHRv
IHNldCBkbWEgbWFzayBkdXJpbmcgcmVzdW1lIik7CisJCQlyZXR2YWwgPSAtRU5PREVWOworCQkJ
Z290byBvdXRfZGlzYWJsZV9kZXZpY2U7CisJCX0KKworCS8qIEluaXRpYWxpemUgdGhlIGNhcmQg
Ki8KKwlpZiAodHdsX3Jlc2V0X3NlcXVlbmNlKHR3X2RldiwgMCkpIHsKKwkJcmV0dmFsID0gLUVO
T0RFVjsKKwkJZ290byBvdXRfZGlzYWJsZV9kZXZpY2U7CisJfQorCisJLyogTm93IHNldHVwIHRo
ZSBpbnRlcnJ1cHQgaGFuZGxlciAqLworCXJldHZhbCA9IHJlcXVlc3RfaXJxKHBkZXYtPmlycSwg
dHdsX2ludGVycnVwdCwgSVJRRl9TSEFSRUQsICIzdy1zYXMiLCB0d19kZXYpOworCWlmIChyZXR2
YWwpIHsKKwkJVFdfUFJJTlRLKHR3X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAweDI2LCAiRXJyb3Ig
cmVxdWVzdGluZyBJUlEgZHVyaW5nIHJlc3VtZSIpOworCQlyZXR2YWwgPSAtRU5PREVWOworCQln
b3RvIG91dF9kaXNhYmxlX2RldmljZTsKKwl9CisKKwkvKiBOb3cgZW5hYmxlIE1TSSBpZiBlbmFi
bGVkICovCisJaWYgKHRlc3RfYml0KFRXX1VTSU5HX01TSSwgJnR3X2Rldi0+ZmxhZ3MpKQorCQlw
Y2lfZW5hYmxlX21zaShwZGV2KTsKKworCS8qIFJlLWVuYWJsZSBpbnRlcnJ1cHRzIG9uIHRoZSBj
YXJkICovCisJVFdMX1VOTUFTS19JTlRFUlJVUFRTKHR3X2Rldik7CisKKwlwcmludGsoS0VSTl9X
QVJOSU5HICIzdy1zYXM6IFJlc3VtZSBjb21wbGV0ZS5cbiIpOworCXJldHVybiAwOworCitvdXRf
ZGlzYWJsZV9kZXZpY2U6CisJc2NzaV9yZW1vdmVfaG9zdChob3N0KTsKKwlwY2lfZGlzYWJsZV9k
ZXZpY2UocGRldik7CisKKwlyZXR1cm4gcmV0dmFsOworfSAvKiBFbmQgdHdsX3Jlc3VtZSgpICov
CisjZW5kaWYKKworLyogUENJIERldmljZXMgc3VwcG9ydGVkIGJ5IHRoaXMgZHJpdmVyICovCitz
dGF0aWMgc3RydWN0IHBjaV9kZXZpY2VfaWQgdHdsX3BjaV90YmxbXSBfX2RldmluaXRkYXRhID0g
eworCXsgUENJX1ZFTkRPUl9JRF8zV0FSRSwgUENJX0RFVklDRV9JRF8zV0FSRV85NzUwLAorCSAg
UENJX0FOWV9JRCwgUENJX0FOWV9JRCwgMCwgMCwgMH0sCisJeyB9Cit9OworTU9EVUxFX0RFVklD
RV9UQUJMRShwY2ksIHR3bF9wY2lfdGJsKTsKKworLyogcGNpX2RyaXZlciBpbml0aWFsaXplciAq
Lworc3RhdGljIHN0cnVjdCBwY2lfZHJpdmVyIHR3bF9kcml2ZXIgPSB7CisJLm5hbWUJCT0gIjN3
LXNhcyIsCisJLmlkX3RhYmxlCT0gdHdsX3BjaV90YmwsCisJLnByb2JlCQk9IHR3bF9wcm9iZSwK
KwkucmVtb3ZlCQk9IHR3bF9yZW1vdmUsCisjaWZkZWYgQ09ORklHX1BNCisJLnN1c3BlbmQJPSB0
d2xfc3VzcGVuZCwKKwkucmVzdW1lCQk9IHR3bF9yZXN1bWUsCisjZW5kaWYKKwkuc2h1dGRvd24J
PSB0d2xfc2h1dGRvd24KK307CisKKy8qIFRoaXMgZnVuY3Rpb24gaXMgY2FsbGVkIG9uIGRyaXZl
ciBpbml0aWFsaXphdGlvbiAqLworc3RhdGljIGludCBfX2luaXQgdHdsX2luaXQodm9pZCkKK3sK
KwlwcmludGsoS0VSTl9XQVJOSU5HICJMU0kgM3dhcmUgU0FTL1NBVEEtUkFJRCBDb250cm9sbGVy
IGRldmljZSBkcml2ZXIgZm9yIExpbnV4IHYlcy5cbiIsIFRXX0RSSVZFUl9WRVJTSU9OKTsKKwor
CXJldHVybiBwY2lfcmVnaXN0ZXJfZHJpdmVyKCZ0d2xfZHJpdmVyKTsKK30gLyogRW5kIHR3bF9p
bml0KCkgKi8KKworLyogVGhpcyBmdW5jdGlvbiBpcyBjYWxsZWQgb24gZHJpdmVyIGV4aXQgKi8K
K3N0YXRpYyB2b2lkIF9fZXhpdCB0d2xfZXhpdCh2b2lkKQoreworCXBjaV91bnJlZ2lzdGVyX2Ry
aXZlcigmdHdsX2RyaXZlcik7Cit9IC8qIEVuZCB0d2xfZXhpdCgpICovCisKK21vZHVsZV9pbml0
KHR3bF9pbml0KTsKK21vZHVsZV9leGl0KHR3bF9leGl0KTsKKwpkaWZmIC1OYXVyIGxpbnV4LTIu
Ni4zMi1yYzUtZ2l0MS9kcml2ZXJzL3Njc2kvM3ctc2FzLmggbGludXgtMi42LjMyLXJjNS1naXQx
Lm5ldy9kcml2ZXJzL3Njc2kvM3ctc2FzLmgKLS0tIGxpbnV4LTIuNi4zMi1yYzUtZ2l0MS9kcml2
ZXJzL3Njc2kvM3ctc2FzLmgJMTk2OS0xMi0zMSAxNjowMDowMC4wMDAwMDAwMDAgLTA4MDAKKysr
IGxpbnV4LTIuNi4zMi1yYzUtZ2l0MS5uZXcvZHJpdmVycy9zY3NpLzN3LXNhcy5oCTIwMDktMTAt
MTkgMTc6MDc6NDQuMDAwMDAwMDAwIC0wNzAwCkBAIC0wLDAgKzEsMzk2IEBACisvKgorICAgM3ct
c2FzLmggLS0gTFNJIDN3YXJlIFNBUy9TQVRBLVJBSUQgQ29udHJvbGxlciBkZXZpY2UgZHJpdmVy
IGZvciBMaW51eC4KKworICAgV3JpdHRlbiBCeTogQWRhbSBSYWRmb3JkIDxsaW51eHJhaWRAbHNp
LmNvbT4KKworICAgQ29weXJpZ2h0IChDKSAyMDA5IExTSSBDb3Jwb3JhdGlvbi4KKworICAgVGhp
cyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9v
ciBtb2RpZnkKKyAgIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGlj
IExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5CisgICB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9u
OyB2ZXJzaW9uIDIgb2YgdGhlIExpY2Vuc2UuCisKKyAgIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmli
dXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLAorICAgYnV0IFdJVEhPVVQg
QU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YKKyAgIE1F
UkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0
aGUKKyAgIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvciBtb3JlIGRldGFpbHMuCisKKyAg
IE5PIFdBUlJBTlRZCisgICBUSEUgUFJPR1JBTSBJUyBQUk9WSURFRCBPTiBBTiAiQVMgSVMiIEJB
U0lTLCBXSVRIT1VUIFdBUlJBTlRJRVMgT1IKKyAgIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIEVJ
VEhFUiBFWFBSRVNTIE9SIElNUExJRUQgSU5DTFVESU5HLCBXSVRIT1VUCisgICBMSU1JVEFUSU9O
LCBBTlkgV0FSUkFOVElFUyBPUiBDT05ESVRJT05TIE9GIFRJVExFLCBOT04tSU5GUklOR0VNRU5U
LAorICAgTUVSQ0hBTlRBQklMSVRZIE9SIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NF
LiBFYWNoIFJlY2lwaWVudCBpcworICAgc29sZWx5IHJlc3BvbnNpYmxlIGZvciBkZXRlcm1pbmlu
ZyB0aGUgYXBwcm9wcmlhdGVuZXNzIG9mIHVzaW5nIGFuZAorICAgZGlzdHJpYnV0aW5nIHRoZSBQ
cm9ncmFtIGFuZCBhc3N1bWVzIGFsbCByaXNrcyBhc3NvY2lhdGVkIHdpdGggaXRzCisgICBleGVy
Y2lzZSBvZiByaWdodHMgdW5kZXIgdGhpcyBBZ3JlZW1lbnQsIGluY2x1ZGluZyBidXQgbm90IGxp
bWl0ZWQgdG8KKyAgIHRoZSByaXNrcyBhbmQgY29zdHMgb2YgcHJvZ3JhbSBlcnJvcnMsIGRhbWFn
ZSB0byBvciBsb3NzIG9mIGRhdGEsCisgICBwcm9ncmFtcyBvciBlcXVpcG1lbnQsIGFuZCB1bmF2
YWlsYWJpbGl0eSBvciBpbnRlcnJ1cHRpb24gb2Ygb3BlcmF0aW9ucy4KKworICAgRElTQ0xBSU1F
UiBPRiBMSUFCSUxJVFkKKyAgIE5FSVRIRVIgUkVDSVBJRU5UIE5PUiBBTlkgQ09OVFJJQlVUT1JT
IFNIQUxMIEhBVkUgQU5ZIExJQUJJTElUWSBGT1IgQU5ZCisgICBESVJFQ1QsIElORElSRUNULCBJ
TkNJREVOVEFMLCBTUEVDSUFMLCBFWEVNUExBUlksIE9SIENPTlNFUVVFTlRJQUwKKyAgIERBTUFH
RVMgKElOQ0xVRElORyBXSVRIT1VUIExJTUlUQVRJT04gTE9TVCBQUk9GSVRTKSwgSE9XRVZFUiBD
QVVTRUQgQU5ECisgICBPTiBBTlkgVEhFT1JZIE9GIExJQUJJTElUWSwgV0hFVEhFUiBJTiBDT05U
UkFDVCwgU1RSSUNUIExJQUJJTElUWSwgT1IKKyAgIFRPUlQgKElOQ0xVRElORyBORUdMSUdFTkNF
IE9SIE9USEVSV0lTRSkgQVJJU0lORyBJTiBBTlkgV0FZIE9VVCBPRiBUSEUKKyAgIFVTRSBPUiBE
SVNUUklCVVRJT04gT0YgVEhFIFBST0dSQU0gT1IgVEhFIEVYRVJDSVNFIE9GIEFOWSBSSUdIVFMg
R1JBTlRFRAorICAgSEVSRVVOREVSLCBFVkVOIElGIEFEVklTRUQgT0YgVEhFIFBPU1NJQklMSVRZ
IE9GIFNVQ0ggREFNQUdFUworCisgICBZb3Ugc2hvdWxkIGhhdmUgcmVjZWl2ZWQgYSBjb3B5IG9m
IHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZQorICAgYWxvbmcgd2l0aCB0aGlzIHByb2dy
YW07IGlmIG5vdCwgd3JpdGUgdG8gdGhlIEZyZWUgU29mdHdhcmUKKyAgIEZvdW5kYXRpb24sIElu
Yy4sIDU5IFRlbXBsZSBQbGFjZSwgU3VpdGUgMzMwLCBCb3N0b24sIE1BICAwMjExMS0xMzA3ICBV
U0EKKworICAgQnVncy9Db21tZW50cy9TdWdnZXN0aW9ucyBzaG91bGQgYmUgbWFpbGVkIHRvOgor
ICAgbGludXhyYWlkQGxzaS5jb20KKworICAgRm9yIG1vcmUgaW5mb3JtYXRpb24sIGdvdG86Cisg
ICBodHRwOi8vd3d3LmxzaS5jb20KKyovCisKKyNpZm5kZWYgXzNXX1NBU19ICisjZGVmaW5lIF8z
V19TQVNfSAorCisvKiBBRU4gc2V2ZXJpdHkgdGFibGUgKi8KK3N0YXRpYyBjaGFyICp0d2xfYWVu
X3NldmVyaXR5X3RhYmxlW10gPQoreworCSJOb25lIiwgIkVSUk9SIiwgIldBUk5JTkciLCAiSU5G
TyIsICJERUJVRyIsIChjaGFyKikgMAorfTsKKworLyogTGliZXJhdG9yIHJlZ2lzdGVyIG9mZnNl
dHMgKi8KKyNkZWZpbmUgVFdMX1NUQVRVUyAgICAgICAgICAgICAgICAgICAgICAgICAweDAgIC8q
IFN0YXR1cyAqLworI2RlZmluZSBUV0xfSElCREIgICAgICAgICAgICAgICAgICAgICAgICAgIDB4
MjAgLyogSW5ib3VuZCBkb29yYmVsbCAqLworI2RlZmluZSBUV0xfSElTVEFUICAgICAgICAgICAg
ICAgICAgICAgICAgIDB4MzAgLyogSG9zdCBpbnRlcnJ1cHQgc3RhdHVzICovCisjZGVmaW5lIFRX
TF9ISU1BU0sgICAgICAgICAgICAgICAgICAgICAgICAgMHgzNCAvKiBIb3N0IGludGVycnVwdCBt
YXNrICovCisjZGVmaW5lIFRXTF9IT0JEQgkJCSAgIDB4OUMgLyogT3V0Ym91bmQgZG9vcmJlbGwg
Ki8KKyNkZWZpbmUgVFdMX0hPQkRCQyAgICAgICAgICAgICAgICAgICAgICAgICAweEEwIC8qIE91
dGJvdW5kIGRvb3JiZWxsIGNsZWFyICovCisjZGVmaW5lIFRXTF9TQ1JQRDMgICAgICAgICAgICAg
ICAgICAgICAgICAgMHhCQyAvKiBTY3JhdGNocGFkICovCisjZGVmaW5lIFRXTF9ISUJRUEwgICAg
ICAgICAgICAgICAgICAgICAgICAgMHhDMCAvKiBIb3N0IGluYm91bmQgUSBsb3cgKi8KKyNkZWZp
bmUgVFdMX0hJQlFQSCAgICAgICAgICAgICAgICAgICAgICAgICAweEM0IC8qIEhvc3QgaW5ib3Vu
ZCBRIGhpZ2ggKi8KKyNkZWZpbmUgVFdMX0hPQlFQTCAgICAgICAgICAgICAgICAgICAgICAgICAw
eEM4IC8qIEhvc3Qgb3V0Ym91bmQgUSBsb3cgKi8KKyNkZWZpbmUgVFdMX0hPQlFQSCAgICAgICAg
ICAgICAgICAgICAgICAgICAweENDIC8qIEhvc3Qgb3V0Ym91bmQgUSBoaWdoICovCisjZGVmaW5l
IFRXTF9ISVNUQVRVU19WQUxJRF9JTlRFUlJVUFQJICAgMHhDCisjZGVmaW5lIFRXTF9ISVNUQVRV
U19BVFRFTlRJT05fSU5URVJSVVBUICAgMHg0CisjZGVmaW5lIFRXTF9ISVNUQVRVU19SRVNQT05T
RV9JTlRFUlJVUFQJICAgMHg4CisjZGVmaW5lIFRXTF9TVEFUVVNfT1ZFUlJVTl9TVUJNSVQJICAg
MHgyMDAwCisjZGVmaW5lIFRXTF9JU1NVRV9TT0ZUX1JFU0VUCQkgICAweDEwMAorI2RlZmluZSBU
V0xfQ09OVFJPTExFUl9SRUFEWQkJICAgMHgyMDAwCisjZGVmaW5lIFRXTF9ET09SQkVMTF9DT05U
Uk9MTEVSX0VSUk9SCSAgIDB4MjAwMDAwCisjZGVmaW5lIFRXTF9ET09SQkVMTF9BVFRFTlRJT05f
SU5URVJSVVBUICAgMHg0MDAwMAorI2RlZmluZSBUV0xfUFVMTF9NT0RFCQkJICAgMHgxCisKKy8q
IENvbW1hbmQgcGFja2V0IG9wY29kZXMgdXNlZCBieSB0aGUgZHJpdmVyICovCisjZGVmaW5lIFRX
X09QX0lOSVRfQ09OTkVDVElPTiAweDEKKyNkZWZpbmUgVFdfT1BfR0VUX1BBUkFNCSAgICAgIDB4
MTIKKyNkZWZpbmUgVFdfT1BfU0VUX1BBUkFNCSAgICAgIDB4MTMKKyNkZWZpbmUgVFdfT1BfRVhF
Q1VURV9TQ1NJICAgIDB4MTAKKworLyogQXN5bmNocm9ub3VzIEV2ZW50IE5vdGlmaWNhdGlvbiAo
QUVOKSBjb2RlcyB1c2VkIGJ5IHRoZSBkcml2ZXIgKi8KKyNkZWZpbmUgVFdfQUVOX1FVRVVFX0VN
UFRZICAgICAgIDB4MDAwMAorI2RlZmluZSBUV19BRU5fU09GVF9SRVNFVCAgICAgICAgMHgwMDAx
CisjZGVmaW5lIFRXX0FFTl9TWU5DX1RJTUVfV0lUSF9IT1NUIDB4MDMxCisjZGVmaW5lIFRXX0FF
Tl9TRVZFUklUWV9FUlJPUiAgICAweDEKKyNkZWZpbmUgVFdfQUVOX1NFVkVSSVRZX0RFQlVHICAg
IDB4NAorI2RlZmluZSBUV19BRU5fTk9UX1JFVFJJRVZFRCAweDEKKworLyogQ29tbWFuZCBzdGF0
ZSBkZWZpbmVzICovCisjZGVmaW5lIFRXX1NfSU5JVElBTCAgIDB4MSAgLyogSW5pdGlhbCBzdGF0
ZSAqLworI2RlZmluZSBUV19TX1NUQVJURUQgICAweDIgIC8qIElkIGluIHVzZSAqLworI2RlZmlu
ZSBUV19TX1BPU1RFRCAgICAweDQgIC8qIFBvc3RlZCB0byB0aGUgY29udHJvbGxlciAqLworI2Rl
ZmluZSBUV19TX0NPTVBMRVRFRCAweDggIC8qIENvbXBsZXRlZCBieSBpc3IgKi8KKyNkZWZpbmUg
VFdfU19GSU5JU0hFRCAgMHgxMCAvKiBJL08gY29tcGxldGVseSBkb25lICovCisKKy8qIENvbXBh
dGliaWxpdHkgZGVmaW5lcyAqLworI2RlZmluZSBUV185NzUwX0FSQ0hfSUQgMTAKKyNkZWZpbmUg
VFdfQ1VSUkVOVF9EUklWRVJfU1JMIDQwCisjZGVmaW5lIFRXX0NVUlJFTlRfRFJJVkVSX0JVSUxE
IDAKKyNkZWZpbmUgVFdfQ1VSUkVOVF9EUklWRVJfQlJBTkNIIDAKKworLyogUGhhc2UgZGVmaW5l
cyAqLworI2RlZmluZSBUV19QSEFTRV9JTklUSUFMIDAKKyNkZWZpbmUgVFdfUEhBU0VfU0dMSVNU
ICAyCisKKy8qIE1pc2MgZGVmaW5lcyAqLworI2RlZmluZSBUV19TRUNUT1JfU0laRSAgICAgICAg
ICAgICAgICAgICAgICAgIDUxMgorI2RlZmluZSBUV19NQVhfVU5JVFMJCQkgICAgICAzMgorI2Rl
ZmluZSBUV19JTklUX01FU1NBR0VfQ1JFRElUUwkJICAgICAgMHgxMDAKKyNkZWZpbmUgVFdfSU5J
VF9DT01NQU5EX1BBQ0tFVF9TSVpFCSAgICAgIDB4MworI2RlZmluZSBUV19JTklUX0NPTU1BTkRf
UEFDS0VUX1NJWkVfRVhURU5ERUQgIDB4NgorI2RlZmluZSBUV19FWFRFTkRFRF9JTklUX0NPTk5F
Q1QJICAgICAgMHgyCisjZGVmaW5lIFRXX0JBU0VfRldfU1JMCQkJICAgICAgMjQKKyNkZWZpbmUg
VFdfQkFTRV9GV19CUkFOQ0gJCSAgICAgIDAKKyNkZWZpbmUgVFdfQkFTRV9GV19CVUlMRAkJICAg
ICAgMQorI2RlZmluZSBUV19RX0xFTkdUSAkJCSAgICAgIDI1NgorI2RlZmluZSBUV19RX1NUQVJU
CQkJICAgICAgMAorI2RlZmluZSBUV19NQVhfU0xPVAkJCSAgICAgIDMyCisjZGVmaW5lIFRXX01B
WF9SRVNFVF9UUklFUwkJICAgICAgMgorI2RlZmluZSBUV19NQVhfQ01EU19QRVJfTFVOCQkgICAg
ICAyNTQKKyNkZWZpbmUgVFdfTUFYX0FFTl9EUkFJTgkJICAgICAgMjU1CisjZGVmaW5lIFRXX0lO
X1JFU0VUICAgICAgICAgICAgICAgICAgICAgICAgICAgMgorI2RlZmluZSBUV19VU0lOR19NU0kJ
CQkgICAgICAzCisjZGVmaW5lIFRXX0lOX0FUVEVOVElPTl9MT09QCQkgICAgICA0CisjZGVmaW5l
IFRXX01BWF9TRUNUT1JTICAgICAgICAgICAgICAgICAgICAgICAgMjU2CisjZGVmaW5lIFRXX01B
WF9DREJfTEVOICAgICAgICAgICAgICAgICAgICAgICAgMTYKKyNkZWZpbmUgVFdfSU9DVExfQ0hS
REVWX1RJTUVPVVQgICAgICAgICAgICAgICA2MCAvKiA2MCBzZWNvbmRzICovCisjZGVmaW5lIFRX
X0lPQ1RMX0NIUkRFVl9GUkVFICAgICAgICAgICAgICAgICAgLTEKKyNkZWZpbmUgVFdfQ09NTUFO
RF9PRkZTRVQgICAgICAgICAgICAgICAgICAgICAxMjggLyogMTI4IGJ5dGVzICovCisjZGVmaW5l
IFRXX1ZFUlNJT05fVEFCTEUgICAgICAgICAgICAgICAgICAgICAgMHgwNDAyCisjZGVmaW5lIFRX
X1RJTUVLRUVQX1RBQkxFCQkgICAgICAweDA0MEEKKyNkZWZpbmUgVFdfSU5GT1JNQVRJT05fVEFC
TEUJCSAgICAgIDB4MDQwMworI2RlZmluZSBUV19QQVJBTV9GV1ZFUgkJCSAgICAgIDMKKyNkZWZp
bmUgVFdfUEFSQU1fRldWRVJfTEVOR1RICQkgICAgICAxNgorI2RlZmluZSBUV19QQVJBTV9CSU9T
VkVSCQkgICAgICA0CisjZGVmaW5lIFRXX1BBUkFNX0JJT1NWRVJfTEVOR1RICQkgICAgICAxNgor
I2RlZmluZSBUV19QQVJBTV9NT0RFTAkJCSAgICAgIDgKKyNkZWZpbmUgVFdfUEFSQU1fTU9ERUxf
TEVOR1RICQkgICAgICAxNgorI2RlZmluZSBUV19QQVJBTV9QSFlfU1VNTUFSWV9UQUJMRQkgICAg
ICAxCisjZGVmaW5lIFRXX1BBUkFNX1BIWUNPVU5UCQkgICAgICAyCisjZGVmaW5lIFRXX1BBUkFN
X1BIWUNPVU5UX0xFTkdUSAkgICAgICAxCisjZGVmaW5lIFRXX0lPQ1RMX0ZJUk1XQVJFX1BBU1Nf
VEhST1VHSCAgICAgICAgMHgxMDggIC8vIFVzZWQgYnkgc21hcnRtb250b29scworI2RlZmluZSBU
V19BTExPQ0FUSU9OX0xFTkdUSAkJICAgICAgMTI4CisjZGVmaW5lIFRXX1NFTlNFX0RBVEFfTEVO
R1RICQkgICAgICAxOAorI2RlZmluZSBUV19FUlJPUl9MT0dJQ0FMX1VOSVRfTk9UX1NVUFBPUlRF
RCAgIDB4MTBhCisjZGVmaW5lIFRXX0VSUk9SX0lOVkFMSURfRklFTERfSU5fQ0RCCSAgICAgIDB4
MTBkCisjZGVmaW5lIFRXX0VSUk9SX1VOSVRfT0ZGTElORSAgICAgICAgICAgICAgICAgMHgxMjgK
KyNkZWZpbmUgVFdfTUVTU0FHRV9TT1VSQ0VfQ09OVFJPTExFUl9FUlJPUiAgICAzCisjZGVmaW5l
IFRXX01FU1NBR0VfU09VUkNFX0NPTlRST0xMRVJfRVZFTlQgICAgNAorI2RlZmluZSBUV19EUklW
RVIgCQkJICAgICAgNgorI2lmbmRlZiBQQ0lfREVWSUNFX0lEXzNXQVJFXzk3NTAKKyNkZWZpbmUg
UENJX0RFVklDRV9JRF8zV0FSRV85NzUwIDB4MTAxMAorI2VuZGlmCisKKy8qIEJpdG1hc2sgbWFj
cm9zIHRvIGVsaW1pbmF0ZSBiaXRmaWVsZHMgKi8KKworLyogb3Bjb2RlOiA1LCByZXNlcnZlZDog
MyAqLworI2RlZmluZSBUV19PUFJFU19JTih4LHkpICgoeCA8PCA1KSB8ICh5ICYgMHgxZikpCisj
ZGVmaW5lIFRXX09QX09VVCh4KSAoeCAmIDB4MWYpCisKKy8qIG9wY29kZTogNSwgc2dsb2Zmc2V0
OiAzICovCisjZGVmaW5lIFRXX09QU0dMX0lOKHgseSkgKCh4IDw8IDUpIHwgKHkgJiAweDFmKSkK
KyNkZWZpbmUgVFdfU0dMX09VVCh4KSAoKHggPj4gNSkgJiAweDcpCisKKy8qIHNldmVyaXR5OiAz
LCByZXNlcnZlZDogNSAqLworI2RlZmluZSBUV19TRVZfT1VUKHgpICh4ICYgMHg3KQorCisvKiBu
b3RfbWZhOiAxLCByZXNlcnZlZDogNywgc3RhdHVzOiA4LCByZXF1ZXN0X2lkOiAxNiAqLworI2Rl
ZmluZSBUV19SRVNJRF9PVVQoeCkgKCh4ID4+IDE2KSAmIDB4ZmZmZikKKyNkZWZpbmUgVFdfTk9U
TUZBX09VVCh4KSAoeCAmIDB4MSkKKworLyogcmVxdWVzdF9pZDogMTIsIGx1bjogNCAqLworI2Rl
ZmluZSBUV19SRVFfTFVOX0lOKGx1biwgcmVxdWVzdF9pZCkgKCgobHVuIDw8IDEyKSAmIDB4ZjAw
MCkgfCAocmVxdWVzdF9pZCAmIDB4ZmZmKSkKKyNkZWZpbmUgVFdfTFVOX09VVChsdW4pICgobHVu
ID4+IDEyKSAmIDB4ZikKKworLyogUmVnaXN0ZXIgYWNjZXNzIG1hY3JvcyAqLworI2RlZmluZSBU
V0xfU1RBVFVTX1JFR19BRERSKHgpICgodW5zaWduZWQgY2hhciBfX2lvbWVtICopeC0+YmFzZV9h
ZGRyICsgVFdMX1NUQVRVUykKKyNkZWZpbmUgVFdMX0hPQlFQTF9SRUdfQUREUih4KSAoKHVuc2ln
bmVkIGNoYXIgX19pb21lbSAqKXgtPmJhc2VfYWRkciArIFRXTF9IT0JRUEwpCisjZGVmaW5lIFRX
TF9IT0JRUEhfUkVHX0FERFIoeCkgKCh1bnNpZ25lZCBjaGFyIF9faW9tZW0gKil4LT5iYXNlX2Fk
ZHIgKyBUV0xfSE9CUVBIKQorI2RlZmluZSBUV0xfSE9CREJfUkVHX0FERFIoeCkgKCh1bnNpZ25l
ZCBjaGFyIF9faW9tZW0gKil4LT5iYXNlX2FkZHIgKyBUV0xfSE9CREIpCisjZGVmaW5lIFRXTF9I
T0JEQkNfUkVHX0FERFIoeCkgKCh1bnNpZ25lZCBjaGFyIF9faW9tZW0gKil4LT5iYXNlX2FkZHIg
KyBUV0xfSE9CREJDKQorI2RlZmluZSBUV0xfSElNQVNLX1JFR19BRERSKHgpICgodW5zaWduZWQg
Y2hhciBfX2lvbWVtICopeC0+YmFzZV9hZGRyICsgVFdMX0hJTUFTSykKKyNkZWZpbmUgVFdMX0hJ
U1RBVF9SRUdfQUREUih4KSAoKHVuc2lnbmVkIGNoYXIgX19pb21lbSAqKXgtPmJhc2VfYWRkciAr
IFRXTF9ISVNUQVQpCisjZGVmaW5lIFRXTF9ISUJRUEhfUkVHX0FERFIoeCkgKCh1bnNpZ25lZCBj
aGFyIF9faW9tZW0gKil4LT5iYXNlX2FkZHIgKyBUV0xfSElCUVBIKQorI2RlZmluZSBUV0xfSElC
UVBMX1JFR19BRERSKHgpICgodW5zaWduZWQgY2hhciBfX2lvbWVtICopeC0+YmFzZV9hZGRyICsg
VFdMX0hJQlFQTCkKKyNkZWZpbmUgVFdMX0hJQkRCX1JFR19BRERSKHgpICgodW5zaWduZWQgY2hh
ciBfX2lvbWVtICopeC0+YmFzZV9hZGRyICsgVFdMX0hJQkRCKQorI2RlZmluZSBUV0xfU0NSUEQz
X1JFR19BRERSKHgpICgodW5zaWduZWQgY2hhciBfX2lvbWVtICopeC0+YmFzZV9hZGRyICsgVFdM
X1NDUlBEMykKKyNkZWZpbmUgVFdMX01BU0tfSU5URVJSVVBUUyh4KSAod3JpdGVsKH4wLCBUV0xf
SElNQVNLX1JFR19BRERSKHR3X2RldikpKQorI2RlZmluZSBUV0xfVU5NQVNLX0lOVEVSUlVQVFMo
eCkgKHdyaXRlbCh+VFdMX0hJU1RBVFVTX1ZBTElEX0lOVEVSUlVQVCwgVFdMX0hJTUFTS19SRUdf
QUREUih0d19kZXYpKSkKKyNkZWZpbmUgVFdMX0NMRUFSX0RCX0lOVEVSUlVQVCh4KSAod3JpdGVs
KH4wLCBUV0xfSE9CREJDX1JFR19BRERSKHR3X2RldikpKQorI2RlZmluZSBUV0xfU09GVF9SRVNF
VCh4KSAod3JpdGVsKFRXTF9JU1NVRV9TT0ZUX1JFU0VULCBUV0xfSElCREJfUkVHX0FERFIodHdf
ZGV2KSkpCisKKy8qIE1hY3JvcyAqLworI2RlZmluZSBUV19QUklOVEsoaCxhLGIsYykgeyBcCitp
ZiAoaCkgXAorcHJpbnRrKEtFUk5fV0FSTklORyAiM3ctc2FzOiBzY3NpJWQ6IEVSUk9SOiAoMHgl
MDJYOjB4JTA0WCk6ICVzLlxuIixoLT5ob3N0X25vLGEsYixjKTsgXAorZWxzZSBcCitwcmludGso
S0VSTl9XQVJOSU5HICIzdy1zYXM6IEVSUk9SOiAoMHglMDJYOjB4JTA0WCk6ICVzLlxuIixhLGIs
Yyk7IFwKK30KKyNkZWZpbmUgVFdfTUFYX0xVTlMgMTYKKyNkZWZpbmUgVFdfQ09NTUFORF9TSVpF
IChzaXplb2YoZG1hX2FkZHJfdCkgPiA0ID8gNiA6IDQpCisjZGVmaW5lIFRXX0xJQkVSQVRPUl9N
QVhfU0dMX0xFTkdUSCAoc2l6ZW9mKGRtYV9hZGRyX3QpID4gNCA/IDQ2IDogOTIpCisjZGVmaW5l
IFRXX0xJQkVSQVRPUl9NQVhfU0dMX0xFTkdUSF9PTEQgKHNpemVvZihkbWFfYWRkcl90KSA+IDQg
PyA0NyA6IDk0KQorI2RlZmluZSBUV19QQURESU5HX0xFTkdUSF9MSUJFUkFUT1IgMTM2CisjZGVm
aW5lIFRXX1BBRERJTkdfTEVOR1RIX0xJQkVSQVRPUl9PTEQgMTMyCisjZGVmaW5lIFRXX0NQVV9U
T19TR0woeCkgKHNpemVvZihkbWFfYWRkcl90KSA+IDQgPyBjcHVfdG9fbGU2NCh4KSA6IGNwdV90
b19sZTMyKHgpKQorCisjcHJhZ21hIHBhY2soMSkKKworLyogU0dMIGVudHJ5ICovCit0eXBlZGVm
IHN0cnVjdCBUQUdfVFdfU0dfRW50cnlfSVNPIHsKKwlkbWFfYWRkcl90IGFkZHJlc3M7CisJZG1h
X2FkZHJfdCBsZW5ndGg7Cit9IFRXX1NHX0VudHJ5X0lTTzsKKworLyogT2xkIENvbW1hbmQgUGFj
a2V0IHdpdGggSVNPIFNHTCAqLwordHlwZWRlZiBzdHJ1Y3QgVFdfQ29tbWFuZCB7CisJdW5zaWdu
ZWQgY2hhciBvcGNvZGVfX3NnbG9mZnNldDsKKwl1bnNpZ25lZCBjaGFyIHNpemU7CisJdW5zaWdu
ZWQgY2hhciByZXF1ZXN0X2lkOworCXVuc2lnbmVkIGNoYXIgdW5pdF9faG9zdGlkOworCS8qIFNl
Y29uZCBEV09SRCAqLworCXVuc2lnbmVkIGNoYXIgc3RhdHVzOworCXVuc2lnbmVkIGNoYXIgZmxh
Z3M7CisJdW5pb24geworCQl1bnNpZ25lZCBzaG9ydCBibG9ja19jb3VudDsKKwkJdW5zaWduZWQg
c2hvcnQgcGFyYW1ldGVyX2NvdW50OworCX0gYnl0ZTZfb2Zmc2V0OworCXVuaW9uIHsKKwkJc3Ry
dWN0IHsKKwkJCXUzMiBsYmE7CisJCQlUV19TR19FbnRyeV9JU08gc2dsW1RXX0xJQkVSQVRPUl9N
QVhfU0dMX0xFTkdUSF9PTERdOworCQkJdW5zaWduZWQgY2hhciBwYWRkaW5nW1RXX1BBRERJTkdf
TEVOR1RIX0xJQkVSQVRPUl9PTERdOworCQl9IGlvOworCQlzdHJ1Y3QgeworCQkJVFdfU0dfRW50
cnlfSVNPIHNnbFtUV19MSUJFUkFUT1JfTUFYX1NHTF9MRU5HVEhfT0xEXTsKKwkJCXUzMiBwYWRk
aW5nOworCQkJdW5zaWduZWQgY2hhciBwYWRkaW5nMltUV19QQURESU5HX0xFTkdUSF9MSUJFUkFU
T1JfT0xEXTsKKwkJfSBwYXJhbTsKKwl9IGJ5dGU4X29mZnNldDsKK30gVFdfQ29tbWFuZDsKKwor
LyogTmV3IENvbW1hbmQgUGFja2V0IHdpdGggSVNPIFNHTCAqLwordHlwZWRlZiBzdHJ1Y3QgVEFH
X1RXX0NvbW1hbmRfQXBhY2hlIHsKKwl1bnNpZ25lZCBjaGFyIG9wY29kZV9fcmVzZXJ2ZWQ7CisJ
dW5zaWduZWQgY2hhciB1bml0OworCXVuc2lnbmVkIHNob3J0IHJlcXVlc3RfaWRfX2x1bmw7CisJ
dW5zaWduZWQgY2hhciBzdGF0dXM7CisJdW5zaWduZWQgY2hhciBzZ2xfb2Zmc2V0OworCXVuc2ln
bmVkIHNob3J0IHNnbF9lbnRyaWVzX19sdW5oOworCXVuc2lnbmVkIGNoYXIgY2RiWzE2XTsKKwlU
V19TR19FbnRyeV9JU08gc2dfbGlzdFtUV19MSUJFUkFUT1JfTUFYX1NHTF9MRU5HVEhdOworCXVu
c2lnbmVkIGNoYXIgcGFkZGluZ1tUV19QQURESU5HX0xFTkdUSF9MSUJFUkFUT1JdOworfSBUV19D
b21tYW5kX0FwYWNoZTsKKworLyogTmV3IGNvbW1hbmQgcGFja2V0IGhlYWRlciAqLwordHlwZWRl
ZiBzdHJ1Y3QgVEFHX1RXX0NvbW1hbmRfQXBhY2hlX0hlYWRlciB7CisJdW5zaWduZWQgY2hhciBz
ZW5zZV9kYXRhW1RXX1NFTlNFX0RBVEFfTEVOR1RIXTsKKwlzdHJ1Y3QgeworCQljaGFyIHJlc2Vy
dmVkWzRdOworCQl1bnNpZ25lZCBzaG9ydCBlcnJvcjsKKwkJdW5zaWduZWQgY2hhciBwYWRkaW5n
OworCQl1bnNpZ25lZCBjaGFyIHNldmVyaXR5X19yZXNlcnZlZDsKKwl9IHN0YXR1c19ibG9jazsK
Kwl1bnNpZ25lZCBjaGFyIGVycl9zcGVjaWZpY19kZXNjWzk4XTsKKwlzdHJ1Y3QgeworCQl1bnNp
Z25lZCBjaGFyIHNpemVfaGVhZGVyOworCQl1bnNpZ25lZCBzaG9ydCByZXF1ZXN0X2lkOworCQl1
bnNpZ25lZCBjaGFyIHNpemVfc2Vuc2U7CisJfSBoZWFkZXJfZGVzYzsKK30gVFdfQ29tbWFuZF9B
cGFjaGVfSGVhZGVyOworCisvKiBUaGlzIHN0cnVjdCBpcyBhIHVuaW9uIG9mIHRoZSAyIGNvbW1h
bmQgcGFja2V0cyAqLwordHlwZWRlZiBzdHJ1Y3QgVEFHX1RXX0NvbW1hbmRfRnVsbCB7CisJVFdf
Q29tbWFuZF9BcGFjaGVfSGVhZGVyIGhlYWRlcjsKKwl1bmlvbiB7CisJCVRXX0NvbW1hbmQgb2xk
Y29tbWFuZDsKKwkJVFdfQ29tbWFuZF9BcGFjaGUgbmV3Y29tbWFuZDsKKwl9IGNvbW1hbmQ7Cit9
IFRXX0NvbW1hbmRfRnVsbDsKKworLyogSW5pdGNvbm5lY3Rpb24gc3RydWN0dXJlICovCit0eXBl
ZGVmIHN0cnVjdCBUQUdfVFdfSW5pdGNvbm5lY3QgeworCXVuc2lnbmVkIGNoYXIgb3Bjb2RlX19y
ZXNlcnZlZDsKKwl1bnNpZ25lZCBjaGFyIHNpemU7CisJdW5zaWduZWQgY2hhciByZXF1ZXN0X2lk
OworCXVuc2lnbmVkIGNoYXIgcmVzMjsKKwl1bnNpZ25lZCBjaGFyIHN0YXR1czsKKwl1bnNpZ25l
ZCBjaGFyIGZsYWdzOworCXVuc2lnbmVkIHNob3J0IG1lc3NhZ2VfY3JlZGl0czsKKwl1MzIgZmVh
dHVyZXM7CisJdW5zaWduZWQgc2hvcnQgZndfc3JsOworCXVuc2lnbmVkIHNob3J0IGZ3X2FyY2hf
aWQ7CisJdW5zaWduZWQgc2hvcnQgZndfYnJhbmNoOworCXVuc2lnbmVkIHNob3J0IGZ3X2J1aWxk
OworCXUzMiByZXN1bHQ7Cit9IFRXX0luaXRjb25uZWN0OworCisvKiBFdmVudCBpbmZvIHN0cnVj
dHVyZSAqLwordHlwZWRlZiBzdHJ1Y3QgVEFHX1RXX0V2ZW50Cit7CisJdW5zaWduZWQgaW50IHNl
cXVlbmNlX2lkOworCXVuc2lnbmVkIGludCB0aW1lX3N0YW1wX3NlYzsKKwl1bnNpZ25lZCBzaG9y
dCBhZW5fY29kZTsKKwl1bnNpZ25lZCBjaGFyIHNldmVyaXR5OworCXVuc2lnbmVkIGNoYXIgcmV0
cmlldmVkOworCXVuc2lnbmVkIGNoYXIgcmVwZWF0X2NvdW50OworCXVuc2lnbmVkIGNoYXIgcGFy
YW1ldGVyX2xlbjsKKwl1bnNpZ25lZCBjaGFyIHBhcmFtZXRlcl9kYXRhWzk4XTsKK30gVFdfRXZl
bnQ7CisKK3R5cGVkZWYgc3RydWN0IFRBR19UV19Jb2N0bF9Ecml2ZXJfQ29tbWFuZCB7CisJdW5z
aWduZWQgaW50IGNvbnRyb2xfY29kZTsKKwl1bnNpZ25lZCBpbnQgc3RhdHVzOworCXVuc2lnbmVk
IGludCB1bmlxdWVfaWQ7CisJdW5zaWduZWQgaW50IHNlcXVlbmNlX2lkOworCXVuc2lnbmVkIGlu
dCBvc19zcGVjaWZpYzsKKwl1bnNpZ25lZCBpbnQgYnVmZmVyX2xlbmd0aDsKK30gVFdfSW9jdGxf
RHJpdmVyX0NvbW1hbmQ7CisKK3R5cGVkZWYgc3RydWN0IFRBR19UV19Jb2N0bF9BcGFjaGUgewor
CVRXX0lvY3RsX0RyaXZlcl9Db21tYW5kIGRyaXZlcl9jb21tYW5kOworICAgICAgICBjaGFyIHBh
ZGRpbmdbNDg4XTsKKwlUV19Db21tYW5kX0Z1bGwgZmlybXdhcmVfY29tbWFuZDsKKwljaGFyIGRh
dGFfYnVmZmVyWzFdOworfSBUV19Jb2N0bF9CdWZfQXBhY2hlOworCisvKiBHZXRQYXJhbSBkZXNj
cmlwdG9yICovCit0eXBlZGVmIHN0cnVjdCB7CisJdW5zaWduZWQgc2hvcnQJdGFibGVfaWQ7CisJ
dW5zaWduZWQgc2hvcnQJcGFyYW1ldGVyX2lkOworCXVuc2lnbmVkIHNob3J0CXBhcmFtZXRlcl9z
aXplX2J5dGVzOworCXVuc2lnbmVkIHNob3J0ICBhY3R1YWxfcGFyYW1ldGVyX3NpemVfYnl0ZXM7
CisJdW5zaWduZWQgY2hhcglkYXRhWzFdOworfSBUV19QYXJhbV9BcGFjaGU7CisKKy8qIENvbXBh
dGliaWxpdHkgaW5mb3JtYXRpb24gc3RydWN0dXJlICovCit0eXBlZGVmIHN0cnVjdCBUQUdfVFdf
Q29tcGF0aWJpbGl0eV9JbmZvCit7CisJY2hhciBkcml2ZXJfdmVyc2lvblszMl07CisJdW5zaWdu
ZWQgc2hvcnQgd29ya2luZ19zcmw7CisJdW5zaWduZWQgc2hvcnQgd29ya2luZ19icmFuY2g7CisJ
dW5zaWduZWQgc2hvcnQgd29ya2luZ19idWlsZDsKKwl1bnNpZ25lZCBzaG9ydCBkcml2ZXJfc3Js
X2hpZ2g7CisJdW5zaWduZWQgc2hvcnQgZHJpdmVyX2JyYW5jaF9oaWdoOworCXVuc2lnbmVkIHNo
b3J0IGRyaXZlcl9idWlsZF9oaWdoOworCXVuc2lnbmVkIHNob3J0IGRyaXZlcl9zcmxfbG93Owor
CXVuc2lnbmVkIHNob3J0IGRyaXZlcl9icmFuY2hfbG93OworCXVuc2lnbmVkIHNob3J0IGRyaXZl
cl9idWlsZF9sb3c7CisJdW5zaWduZWQgc2hvcnQgZndfb25fY3Rscl9zcmw7CisJdW5zaWduZWQg
c2hvcnQgZndfb25fY3Rscl9icmFuY2g7CisJdW5zaWduZWQgc2hvcnQgZndfb25fY3Rscl9idWls
ZDsKK30gVFdfQ29tcGF0aWJpbGl0eV9JbmZvOworCisjcHJhZ21hIHBhY2soKQorCit0eXBlZGVm
IHN0cnVjdCBUQUdfVFdfRGV2aWNlX0V4dGVuc2lvbiB7CisJdm9pZCAgICAgICAgICAgICAgICAg
ICAgIF9faW9tZW0gKmJhc2VfYWRkcjsKKwl1bnNpZ25lZCBsb25nCSAgICAgICAJKmdlbmVyaWNf
YnVmZmVyX3ZpcnRbVFdfUV9MRU5HVEhdOworCWRtYV9hZGRyX3QJICAgICAgIAlnZW5lcmljX2J1
ZmZlcl9waHlzW1RXX1FfTEVOR1RIXTsKKwlUV19Db21tYW5kX0Z1bGwJICAgICAgIAkqY29tbWFu
ZF9wYWNrZXRfdmlydFtUV19RX0xFTkdUSF07CisJZG1hX2FkZHJfdAkJY29tbWFuZF9wYWNrZXRf
cGh5c1tUV19RX0xFTkdUSF07CisJVFdfQ29tbWFuZF9BcGFjaGVfSGVhZGVyICpzZW5zZV9idWZm
ZXJfdmlydFtUV19RX0xFTkdUSF07CisJZG1hX2FkZHJfdAkJc2Vuc2VfYnVmZmVyX3BoeXNbVFdf
UV9MRU5HVEhdOworCXN0cnVjdCBwY2lfZGV2CQkqdHdfcGNpX2RldjsKKwlzdHJ1Y3Qgc2NzaV9j
bW5kCSpzcmJbVFdfUV9MRU5HVEhdOworCXVuc2lnbmVkIGNoYXIJCWZyZWVfcXVldWVbVFdfUV9M
RU5HVEhdOworCXVuc2lnbmVkIGNoYXIJCWZyZWVfaGVhZDsKKwl1bnNpZ25lZCBjaGFyCQlmcmVl
X3RhaWw7CisJaW50ICAgICAJCXN0YXRlW1RXX1FfTEVOR1RIXTsKKwl1bnNpZ25lZCBpbnQJCXBv
c3RlZF9yZXF1ZXN0X2NvdW50OworCXVuc2lnbmVkIGludAkJbWF4X3Bvc3RlZF9yZXF1ZXN0X2Nv
dW50OworCXVuc2lnbmVkIGludAkJbWF4X3NnbF9lbnRyaWVzOworCXVuc2lnbmVkIGludAkJc2ds
X2VudHJpZXM7CisJdW5zaWduZWQgaW50CQludW1fcmVzZXRzOworCXVuc2lnbmVkIGludAkJc2Vj
dG9yX2NvdW50OworCXVuc2lnbmVkIGludAkJbWF4X3NlY3Rvcl9jb3VudDsKKwl1bnNpZ25lZCBp
bnQJCWFlbl9jb3VudDsKKwlzdHJ1Y3QgU2NzaV9Ib3N0CSpob3N0OworCWxvbmcJCQlmbGFnczsK
KwlUV19FdmVudCAgICAgICAgICAgICAgICAqZXZlbnRfcXVldWVbVFdfUV9MRU5HVEhdOworCXVu
c2lnbmVkIGNoYXIgICAgICAgICAgIGVycm9yX2luZGV4OworCXVuc2lnbmVkIGludCAgICAgICAg
ICAgIGVycm9yX3NlcXVlbmNlX2lkOworCWludAkJCWNocmRldl9yZXF1ZXN0X2lkOworCXdhaXRf
cXVldWVfaGVhZF90CWlvY3RsX3dxdWV1ZTsKKwlzdHJ1Y3QgbXV0ZXgJCWlvY3RsX2xvY2s7CisJ
VFdfQ29tcGF0aWJpbGl0eV9JbmZvCXR3X2NvbXBhdF9pbmZvOworCWNoYXIJCQlvbmxpbmU7Cit9
IFRXX0RldmljZV9FeHRlbnNpb247CisKKyNlbmRpZiAvKiBfM1dfU0FTX0ggKi8KKwpkaWZmIC1O
YXVyIGxpbnV4LTIuNi4zMi1yYzUtZ2l0MS9kcml2ZXJzL3Njc2kvS2NvbmZpZyBsaW51eC0yLjYu
MzItcmM1LWdpdDEubmV3L2RyaXZlcnMvc2NzaS9LY29uZmlnCi0tLSBsaW51eC0yLjYuMzItcmM1
LWdpdDEvZHJpdmVycy9zY3NpL0tjb25maWcJMjAwOS0xMC0xNSAxNzo0MTo1MC4wMDAwMDAwMDAg
LTA3MDAKKysrIGxpbnV4LTIuNi4zMi1yYzUtZ2l0MS5uZXcvZHJpdmVycy9zY3NpL0tjb25maWcJ
MjAwOS0xMC0xOSAxNzoxMzo1OS4wMDAwMDAwMDAgLTA3MDAKQEAgLTM5OSw2ICszOTksMTcgQEAK
IAkgIFBsZWFzZSByZWFkIHRoZSBjb21tZW50cyBhdCB0aGUgdG9wIG9mCiAJICA8ZmlsZTpkcml2
ZXJzL3Njc2kvM3ctOXh4eC5jPi4KIAorY29uZmlnIFNDU0lfM1dfU0FTCisJdHJpc3RhdGUgIjN3
YXJlIDk3eHggU0FTL1NBVEEtUkFJRCBzdXBwb3J0IgorCWRlcGVuZHMgb24gUENJICYmIFNDU0kK
KwloZWxwCisJICBUaGlzIGRyaXZlciBzdXBwb3J0cyB0aGUgTFNJIDN3YXJlIDk3NTAgNkdiL3Mg
U0FTL1NBVEEtUkFJRCBjYXJkcy4KKworCSAgPGh0dHA6Ly93d3cubHNpLmNvbT4KKworCSAgUGxl
YXNlIHJlYWQgdGhlIGNvbW1lbnRzIGF0IHRoZSB0b3Agb2YKKwkgIDxmaWxlOmRyaXZlcnMvc2Nz
aS8zdy1zYXMuYz4uCisKIGNvbmZpZyBTQ1NJXzcwMDBGQVNTVAogCXRyaXN0YXRlICI3MDAwRkFT
U1QgU0NTSSBzdXBwb3J0IgogCWRlcGVuZHMgb24gSVNBICYmIFNDU0kgJiYgSVNBX0RNQV9BUEkK
ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzItcmM1LWdpdDEvZHJpdmVycy9zY3NpL01ha2VmaWxlIGxp
bnV4LTIuNi4zMi1yYzUtZ2l0MS5uZXcvZHJpdmVycy9zY3NpL01ha2VmaWxlCi0tLSBsaW51eC0y
LjYuMzItcmM1LWdpdDEvZHJpdmVycy9zY3NpL01ha2VmaWxlCTIwMDktMTAtMTUgMTc6NDE6NTAu
MDAwMDAwMDAwIC0wNzAwCisrKyBsaW51eC0yLjYuMzItcmM1LWdpdDEubmV3L2RyaXZlcnMvc2Nz
aS9NYWtlZmlsZQkyMDA5LTEwLTE5IDE3OjA4OjMwLjAwMDAwMDAwMCAtMDcwMApAQCAtMTEzLDYg
KzExMyw3IEBACiBvYmotJChDT05GSUdfU0NTSV9NQUM1M0M5NCkJKz0gbWFjNTNjOTQubwogb2Jq
LSQoQ09ORklHX0JMS19ERVZfM1dfWFhYWF9SQUlEKSArPSAzdy14eHh4Lm8KIG9iai0kKENPTkZJ
R19TQ1NJXzNXXzlYWFgpCSs9IDN3LTl4eHgubworb2JqLSQoQ09ORklHX1NDU0lfM1dfU0FTKQkr
PSAzdy1zYXMubwogb2JqLSQoQ09ORklHX1NDU0lfUFBBKQkJKz0gcHBhLm8KIG9iai0kKENPTkZJ
R19TQ1NJX0lNTSkJCSs9IGltbS5vCiBvYmotJChDT05GSUdfSkFaWl9FU1ApCQkrPSBlc3Bfc2Nz
aS5vCWphenpfZXNwLm8K
--000e0cd6b3ae8ae505047666f875--
