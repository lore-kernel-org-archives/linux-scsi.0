From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH RFC 2/2] iop13xx: imu scsi driver
Date: Wed, 24 Jan 2007 11:24:21 -0700
Message-ID: <20070124182421.6029.68109.stgit@dwillia2-linux.ch.intel.com>
References: <20070124182245.6029.43097.stgit@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:26204 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbXAXSZ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Jan 2007 13:25:29 -0500
In-Reply-To: <20070124182245.6029.43097.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux@arm.linux.org.uk, James.Bottomley@steeleye.com
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-scsi@vger.kernel.org, dan.j.williams@intel.com, greg.b.tucker@intel.com

From: Greg Tucker <greg.b.tucker@intel.com>

Enable Linux to access the other core as if it were a scsi target.

Signed-off-by: Greg Tucker <greg.b.tucker@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 arch/arm/mach-iop13xx/imu/Kconfig |    7 
 drivers/scsi/Makefile             |    1 
 drivers/scsi/iop13xx-imu-scsi.c   |  623 +++++++++++++++++++++++++++++++++++++
 3 files changed, 631 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-iop13xx/imu/Kconfig b/arch/arm/mach-iop13xx/imu/Kconfig
index ee49b37..96d9d3a 100644
--- a/arch/arm/mach-iop13xx/imu/Kconfig
+++ b/arch/arm/mach-iop13xx/imu/Kconfig
@@ -16,4 +16,11 @@ config IOP_IMU_DEV
 	---help---
 	This is a char driver that passes messages throught the IMU.
 
+config IOP_IMU_SCSI
+	tristate "IOP IMU scsi driver"
+	depends on IOP_IMU
+	---help---
+	This is a low-level SCSI driver that passes SCSI commands
+	to core 2.
+
 endmenu
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index bd7c988..c1ccf57 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -132,6 +132,7 @@ obj-$(CONFIG_SCSI_IBMVSCSIS)	+= ibmvscsi/
 obj-$(CONFIG_SCSI_HPTIOP)	+= hptiop.o
 obj-$(CONFIG_SCSI_STEX)		+= stex.o
 
+obj-$(CONFIG_IOP_IMU_SCSI)	+= iop13xx-imu-scsi.o
 obj-$(CONFIG_ARM)		+= arm/
 
 obj-$(CONFIG_CHR_DEV_ST)	+= st.o
diff --git a/drivers/scsi/iop13xx-imu-scsi.c b/drivers/scsi/iop13xx-imu-scsi.c
new file mode 100644
index 0000000..d32097b
--- /dev/null
+++ b/drivers/scsi/iop13xx-imu-scsi.c
@@ -0,0 +1,623 @@
+/*
+ * drivers/scsi/iop13xx-imu-scsi.c
+ *
+ * SCSI low-level driver that forwards messages through the IOP342 IMU hw to other core.
+ *
+ * Copyright (C) 2005, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * Author: Greg Tucker <greg.b.tucker@intel.com>
+ *
+ */
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_dbg.h>
+#include <asm/arch/iop13xx-imu.h>
+
+#define MODULE_VERS    "1.0"
+#define MODULE_NAME    "IMUscsi"
+#define IMU_WW_NAME     (0xeeed)
+#define IMU_MAX_CMD_LEN 32
+#define Q_NUM           0
+#define Q_PHYS_BASE     (0xffe00000 + (512*1024))
+#define Q_MSG_SIZE      256
+#define Q_MSG_ITEMS     16
+//#define IMU_DEBUG
+
+/* Derived params */
+#define Q_SIZE          (Q_MSG_ITEMS*Q_MSG_SIZE)
+#define SGL_PER_CMD  ((Q_MSG_SIZE-IMU_MAX_CMD_LEN - 24)/sizeof(struct imu_sge))
+
+#ifdef IMU_DEBUG
+# define imu_debug(fmt,arg...) printk(MODULE_NAME ": " fmt,##arg)
+# define dbg_print_cmd(cmd)    scsi_print_command(cmd)
+#else
+# define imu_debug(fmt,arg...) do { } while (0)
+# define dbg_print_cmd(cmd)    do { } while (0)
+#endif
+#define imu_warn(fmt,arg...) printk(KERN_WARNING MODULE_NAME ": " fmt,##arg)
+
+struct imu_scsidata {
+	struct Scsi_Host *host;
+	u32 connection_handle;
+};
+
+struct imu_scsidata *imu_scsi;
+
+struct imu_sgl {
+	u32 len;
+	u32 addr;
+	u32 last_sge;
+};
+
+struct imu_sge {
+	//unsigned char flags;
+	//unsigned int  len : 24;
+	u32 flen;
+	u32 addr_l;
+	u32 addr_h;
+};
+
+enum fcodes {
+	IMU_FCODE_ERROR = 0,
+	IMU_FCODE_CMD,
+	IMU_FCODE_XFER,
+	IMU_FCODE_STATUS,
+	IMU_FCODE_RESP,
+	IMU_FCODE_MANAGE,
+	IMU_FCODE_CONNECT_REQ,
+	IMU_FCODE_CONNECT_RESP,
+	IMU_FCODE_DISCONNECT_REQ,
+	IMU_FCODE_DISCONNECT_RESP,
+	IMU_FCODE_CACHE_ALLOC_REQ,
+	IMU_FCODE_CACHE_ALLOC_RESP,
+	IMU_FCODE_LOG_REQ,
+	IMU_FCODE_LOG_RESP,
+};
+
+struct imu_cmd {
+	union {
+		struct {
+			unsigned short fcode;
+			unsigned char flags;
+			unsigned char reserved;
+		};
+		u32 head;
+	};
+	u64 array_context;
+	u64 app_context;
+	u32 connection_handle;
+	union {
+		union {
+			struct {
+				u64 lun;
+				u32 ctl;
+				u32 datalen;
+				unsigned char cdb[16];
+				union {
+					struct imu_sgl sgl;
+					struct imu_sge sge;
+				};
+			} cdb_cmd;
+			unsigned char cmd[IMU_MAX_CMD_LEN];
+		};		// targ_cmd;
+
+		struct {
+			u32 scsi_status;
+			u32 residual_count;
+			u32 response_code;
+			u16 reserved;
+			u16 senselen;
+			unsigned char sense_data[100];
+		} resp_cmd;
+
+		struct {
+			u64 lun;
+			u32 management_func;
+			u64 management_task;
+		} management_cmd;
+
+		struct {
+			u32 blocks;	// cache alloc command
+			u32 address[32];
+		} cache_cmd;
+
+		u32 status;	// status command, connect/disconnect response
+
+		u64 world_wide_name;	// connect request command
+	};
+};
+
+/* SGE command flags */
+#define FLAG_LAST_ELEMENT           (1<<31)
+
+/* Target Command message flags */
+#define FLAG_CMD_RECEIVER_MUST_XFER (1<<(22-16))
+#define FLAG_CMD_SGL_NOT_IN_MSG     (1<<(20-16))
+/* Data transfer command flags */
+#define FLAG_DATA_LAST_XFER         (1<<(23-16))
+#define FLAG_DATA_SGL_NOT_IN_MSG    (1<<(20-16))
+/* Command response flags */
+#define FLAG_RSP_RESIDUAL_UNDER     (1<<(22-16))
+#define FLAG_RSP_RESIDUAL_OVER      (1<<(21-16))
+#define FLAG_REP_CODE_VALID_DATA    (1<<(20-16))
+#define FLAG_REP_SENSE_VALID        (1<<(19-16))
+
+/* response msssage codes */
+enum imu_resp_codes {
+	IMU_RESP_SUCCESS = 0,
+	IMU_RESP_REJECT,
+	IMU_RESP_FAILED,
+	IMU_RESP_INVALID,
+};
+
+int imu_proc_info(struct Scsi_Host *host, char *buffer, char **start,
+		  off_t offset, int length, int in)
+{
+	int ret;
+	char *p = buffer;
+
+	if (in)
+		return 0;
+
+	p += sprintf(p, "iop13xx IMU SCSI driver ver " MODULE_VERS "\n");
+
+	*start = buffer + offset;
+	ret = p - buffer - offset;
+	if (ret > length)
+		ret = length;
+
+	return ret;
+}
+
+#if 0
+void iop_loopback_test(struct scsi_cmnd *scp)
+{
+
+	switch (scp->cmnd[0]) {
+	case READ_10:
+	case READ_6:
+	case WRITE_10:
+	case WRITE_6:
+	case MODE_SENSE_10:
+	case READ_CAPACITY:
+	case TEST_UNIT_READY:
+	default:
+		break;
+	}
+	memzero(scp->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+	scp->result = (DID_OK << 16);
+	scp->result = 0;
+	if (scp->scsi_done)
+		scp->scsi_done(scp);
+}
+#else
+# define iop_loopback_test(x)
+#endif
+
+static int imu_queuecommand(struct scsi_cmnd *scp,
+			    void (*done) (struct scsi_cmnd *))
+{
+	struct imu_cmd *msg;
+	int i, use_sg;
+	struct scatterlist *sglist;
+	struct imu_sge *sge, *sge_i;
+
+	imu_debug("imu_queuecommand for id=%d\n", scp->device->id);
+	dbg_print_cmd(scp);
+
+	if (scp->device->id != 0) {
+		scp->result = (DID_BAD_TARGET << 16);
+		done(scp);
+		return 0;
+	}
+
+	scp->scsi_done = done;
+
+	if (!imu_scsi->connection_handle) {
+		scp->result = (DID_RESET << 16) | (SUGGEST_RETRY << 24);
+		done(scp);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	msg = iop_queue_allocate(Q_NUM);
+	if (msg == NULL) {
+		imu_warn("failed to allocate imu msg\n");
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	msg->fcode = IMU_FCODE_CMD;
+	msg->flags = FLAG_CMD_RECEIVER_MUST_XFER;
+	msg->array_context = 0;
+	msg->app_context = (u32) scp;
+	msg->connection_handle = imu_scsi->connection_handle;
+	msg->cdb_cmd.lun = scp->device->lun << 8;
+	msg->cdb_cmd.ctl = 0;	// todo: fill out
+	msg->cdb_cmd.datalen = scp->request_bufflen;
+	memcpy(msg->cdb_cmd.cdb, scp->cmnd, 16);
+
+	switch (scp->cmnd[0]) {
+	case TEST_UNIT_READY:
+		break;
+	case READ_10:
+	case READ_6:
+	case WRITE_10:
+	case WRITE_6:
+	case READ_CAPACITY:
+	default:
+		if (scp->use_sg == 0) {
+			dma_addr_t buff = 0;
+			if (NULL == scp->request_buffer)
+				imu_warn("got cmd with NULL request_buffer\n");
+			else
+				buff =
+				    dma_map_single(NULL, scp->request_buffer,
+						   scp->request_bufflen,
+						   DMA_BIDIRECTIONAL);
+			if (buff == 0) {
+				imu_warn("null return from dma_map_single\n");
+				msg->flags = IMU_FCODE_STATUS;
+				msg->status = 0;	//todo: what is error status?
+				iop_queue_postmsg(Q_NUM, msg);
+				return 1;
+			}
+			sge = &(msg->cdb_cmd.sge);
+			sge->addr_l = buff;
+			sge->addr_h = 0;
+			sge->flen = scp->request_bufflen | FLAG_LAST_ELEMENT;
+
+			// This shouldn't be necessary
+			//dma_sync_single(NULL, buff, scp->request_bufflen, DMA_BIDIRECTIONAL);
+			imu_debug("cmd msg with 1 sgl entry, addr=0x%x\n",
+				  buff);
+		}
+		if (scp->use_sg > 0) {
+			sglist = (struct scatterlist *)scp->request_buffer;
+			if (NULL == sglist) {
+				imu_warn("got null scp->buffer\n");
+				use_sg = 0;
+			} else
+				use_sg =
+				    dma_map_sg(NULL, sglist, scp->use_sg,
+					       DMA_BIDIRECTIONAL);
+			if (use_sg == 0) {
+				/* Send error status message */
+				imu_warn("null return from dma_map_sg\n");
+				msg->flags = IMU_FCODE_STATUS;
+				msg->status = 0;	//todo: need to send error status
+				iop_queue_postmsg(Q_NUM, msg);
+				return 1;
+			}
+			// This shouldn't be necessary
+			//dma_sync_sg(NULL, sglist, use_sg, DMA_BIDIRECTIONAL);
+
+			sge = sge_i = &(msg->cdb_cmd.sge);
+
+			for (i = 0; i < use_sg; i++, sglist++, sge_i++) {
+				sge_i->addr_l = sg_dma_address(sglist);
+				sge_i->addr_h = 0;
+				sge_i->flen = sg_dma_len(sglist);
+			}
+			sge[use_sg - 1].flen |= FLAG_LAST_ELEMENT;
+
+			imu_debug
+			    ("cmd msg with %d sgl entries, last flen=0x%x last addr=0x%x\n",
+			     use_sg, sge[use_sg - 1].flen,
+			     sge[use_sg - 1].addr_l);
+
+		}
+
+		break;
+	}
+
+	iop_queue_postmsg(Q_NUM, msg);
+	iop_loopback_test(scp);
+
+	return 0;
+}
+
+static int imu_eh_abort(struct scsi_cmnd *cmd)
+{
+	imu_warn("Received eh command abort\n");
+	//dbg_print_cmd(cmd);
+	return SUCCESS;
+}
+
+static int imu_eh_device_reset(struct scsi_cmnd *cmd)
+{
+	int target = cmd->device->id;
+	imu_warn("Received eh device reset for target %d\n", target);
+	return SUCCESS;
+}
+
+static int imu_eh_host_reset(struct scsi_cmnd *cmd)
+{
+	imu_warn("Received eh host reset\n");
+	return SUCCESS;
+}
+
+static int imu_eh_bus_reset(struct scsi_cmnd *cmd)
+{
+	imu_warn("Received eh bus reset\n");
+	return SUCCESS;
+}
+
+static struct scsi_host_template imu_scsi_template = {
+	.module = THIS_MODULE,
+	.proc_info = imu_proc_info,
+	.name = "iop13xx IMU SCSI",
+	.queuecommand = imu_queuecommand,
+	.eh_abort_handler = imu_eh_abort,
+	.eh_device_reset_handler = imu_eh_device_reset,
+	.eh_host_reset_handler = imu_eh_host_reset,
+	.eh_bus_reset_handler = imu_eh_bus_reset,
+	.can_queue = Q_MSG_ITEMS - 2,
+	.this_id = -1,
+	.cmd_per_lun = 2,
+	.sg_tablesize = SGL_PER_CMD,	/* 1, SG_ALL, SG_NONE */
+	.use_clustering = ENABLE_CLUSTERING,
+	.proc_name = "iop13xx-imu",
+};
+
+void queue_rq_scsi_callback(int queueid)
+{
+	struct imu_cmd *msg;
+	struct scsi_cmnd *scp;
+
+	imu_debug("queue_rq_scsi_callback on queue %d\n", queueid);
+	msg = iop_queue_getmsg(queueid);
+
+	if (msg == NULL)
+		return;
+
+	switch (msg->fcode) {
+
+	case IMU_FCODE_RESP:
+
+		scp = (struct scsi_cmnd *)((u32) msg->app_context);
+		if (!scp) {
+			imu_warn("got an invalid scp pointer\n");
+			break;
+		}
+		//dbg_print_cmd(scp);
+
+		switch (msg->resp_cmd.response_code) {
+
+		case IMU_RESP_SUCCESS:
+			scp->result = (DID_OK << 16);
+			break;
+		case IMU_RESP_REJECT:
+		case IMU_RESP_FAILED:
+			scp->result = (DID_ABORT << 16);
+			break;
+		case IMU_RESP_INVALID:
+		default:
+			scp->result = (DID_ERROR << 16);
+			imu_warn("got a non success resp command:%d\n",
+				 msg->resp_cmd.scsi_status);
+			break;
+		}
+
+		if (msg->flags & FLAG_REP_SENSE_VALID) {
+			memcpy(scp->sense_buffer, msg->resp_cmd.sense_data,
+			       msg->resp_cmd.senselen < SCSI_SENSE_BUFFERSIZE ?
+			       msg->resp_cmd.senselen : SCSI_SENSE_BUFFERSIZE);
+			imu_debug("sense data in command of len %d\n",
+				  msg->resp_cmd.senselen);
+			printk("got sense data of %d bytes\n",
+			       msg->resp_cmd.senselen);
+			scsi_print_sense("IMUscsi", scp);
+		}
+
+		if (scp->scsi_done)
+			scp->scsi_done(scp);
+		else
+			imu_warn("no scsi_done set in response cmd\n");
+		break;
+
+	case IMU_FCODE_CONNECT_RESP:
+		if (!msg->status)
+			imu_scsi->connection_handle = msg->connection_handle;
+		else
+			imu_warn("rejected or failed connection request");
+
+		break;
+
+	case IMU_FCODE_DISCONNECT_RESP:
+		imu_scsi->connection_handle = 0;
+		break;
+
+	case IMU_FCODE_CMD:
+	case IMU_FCODE_XFER:
+	case IMU_FCODE_MANAGE:
+	case IMU_FCODE_CONNECT_REQ:
+	case IMU_FCODE_DISCONNECT_REQ:
+	case IMU_FCODE_CACHE_ALLOC_REQ:
+	case IMU_FCODE_CACHE_ALLOC_RESP:
+	case IMU_FCODE_LOG_REQ:
+	case IMU_FCODE_LOG_RESP:
+	case IMU_FCODE_ERROR:
+	default:
+		imu_warn("got a bad or unhandled fcode response %d\n",
+			 msg->fcode);
+		break;
+	}
+
+	iop_queue_rxfree(queueid, msg);
+	return;
+
+}
+
+/* We need to access queue structure to look for overlap */
+extern struct imu_queue_params imu_queue[];
+
+void init_scsi_callback(int queueid)
+{
+	struct imu_queue_params *queue = &imu_queue[queueid];
+	struct imu_queue *queue_hw = (struct imu_queue *)
+	    (IMU_Q0_BASE + (queueid * sizeof(struct imu_queue)));
+
+	int phy_rxbase = queue_hw->rqlbar;
+	int rq_items = queue_hw->rqcr & 0xffff;
+
+	queue->rxbase = ioremap(phy_rxbase, rq_items * Q_MSG_SIZE);
+
+	/* switch to regular callback and call */
+	iop_doorbell_reg_callback(NR_IMU_DOORBELLS - 1 +
+				  (IMU_DB_RQ0NE - IMU_DB_QUEUE_IRQ_OFF) +
+				  (queueid * 2), queue_rq_scsi_callback);
+
+	imu_debug
+	    ("init_scsi_callback registerd q=%d rxbase=0x%x rxphy=0x%x size=0x%x\n",
+	     queueid, (int)queue->rxbase, phy_rxbase, rq_items * Q_MSG_SIZE);
+	queue_rq_scsi_callback(queueid);
+}
+
+void error_scsi_callback(int queueid)
+{
+}
+
+static int imu_attach(void)
+{
+	char *queue_base;
+	int err;
+
+	imu_debug("imu_attach\n");
+
+	imu_queue[Q_NUM].rxbase = 0;
+
+	queue_base = ioremap(Q_PHYS_BASE + (Q_NUM * Q_SIZE), Q_SIZE);
+	// todo: see about changing to one of following
+	// non-shared device tex.cb = 0x010.00
+	// shared device     tex.cb = 0x001.01
+
+	if (queue_base == NULL) {
+		imu_warn("could not ioremap region\n");
+		return -1;
+	}
+
+	err = iop_queue_init(Q_NUM,
+			     (void *)Q_PHYS_BASE + (Q_NUM * Q_SIZE),
+			     queue_base,
+			     Q_MSG_SIZE,
+			     Q_MSG_ITEMS,
+			     init_scsi_callback, error_scsi_callback);
+	if (err) {
+		imu_warn("could not init queue\n");
+		iounmap(queue_base);
+		return -1;
+	}
+
+	printk(KERN_INFO MODULE_NAME ": using queue %d base:0x%x phy:0x%x\n",
+	       Q_NUM, (int)queue_base, Q_PHYS_BASE + (Q_NUM * Q_SIZE));
+
+	return 0;
+}
+
+static int imu_detach(void)
+{
+
+	iop_doorbell_disable(IMU_DB_RQ0NE + (Q_NUM * 2));
+	iop_doorbell_disable(IMU_DB_SQ0NF + (Q_NUM * 2));
+	iounmap(imu_queue[Q_NUM].txbase);
+
+	if (imu_queue[Q_NUM].rxbase) {
+		iounmap(imu_queue[Q_NUM].rxbase);
+		imu_queue[Q_NUM].rxbase = 0;
+	}
+
+	return 0;
+}
+
+static int __init imu_scsi_init(void)
+{
+	struct Scsi_Host *host;
+	struct imu_scsidata *data;
+	struct imu_cmd *msg;
+	int ret;
+
+	if (imu_attach()) {
+		imu_warn("imu queue alloc failed\n");
+		return -1;
+	}
+
+	host = scsi_host_alloc(&imu_scsi_template, sizeof(struct imu_scsidata));
+	if (!host)
+		return -ENOMEM;
+
+	data = (struct imu_scsidata *)host->hostdata;
+	imu_scsi = data;
+	data->host = host;
+	data->connection_handle = 1;	// todo:change to 0 after connect request added
+
+	/* Send connection request msg */
+	msg = iop_queue_allocate(Q_NUM);
+	if (msg == NULL) {
+		imu_warn("failed to allocate imu msg for connect\n");
+		return -1;
+	}
+	msg->fcode = IMU_FCODE_CONNECT_REQ;
+	msg->array_context = 0;
+	msg->app_context = 0;
+	msg->connection_handle = 0;
+	msg->world_wide_name = IMU_WW_NAME;
+	iop_queue_postmsg(Q_NUM, msg);
+
+	imu_debug("scsi_add_host\n");
+
+	ret = scsi_add_host(host, NULL);	// dev?
+	if (!ret) {
+		scsi_scan_host(host);
+		imu_debug("scsi_scan_host complete\n");
+	}
+
+	return ret;
+}
+
+static void __exit imu_scsi_exit(void)
+{
+	struct Scsi_Host *host = imu_scsi->host;
+
+	scsi_remove_host(host);
+	scsi_host_put(host);
+
+	/* Send disconnect request message */
+	/* Removed for debug
+	   msg = iop_queue_allocate(Q_NUM);
+	   if (msg == NULL) {
+	   imu_warn("failed to allocate imu msg for disconnect\n");
+	   }
+	   else {
+	   msg->fcode             = IMU_FCODE_DISCONNECT_REQ;
+	   msg->array_context     = 0;
+	   msg->app_context       = 0;
+	   msg->connection_handle = imu_scsi->connection_handle;;
+	   iop_queue_postmsg(Q_NUM, msg);
+	   }
+	 */
+	imu_detach();
+
+	printk(KERN_INFO MODULE_NAME ": Detached\n");
+}
+
+module_init(imu_scsi_init);
+module_exit(imu_scsi_exit);
+
+MODULE_AUTHOR("Greg Tucker");
+MODULE_DESCRIPTION("iop13xx IMU SCSI driver");
