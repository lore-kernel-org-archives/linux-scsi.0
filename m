From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v4] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Thu,  9 Jun 2016 16:26:54 -0500
Message-ID: <1465507614-29695-1-git-send-email-bryantly@linux.vnet.ibm.com>
References: <1464409675.22249.237.camel@haakon3.risingtidesystems.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33006 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752544AbcFIV0x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2016 17:26:53 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u59LNgeZ062274
	for <linux-scsi@vger.kernel.org>; Thu, 9 Jun 2016 17:26:52 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23e9m56p3w-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 09 Jun 2016 17:26:51 -0400
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
	Thu, 9 Jun 2016 15:26:49 -0600
In-Reply-To: <1464409675.22249.237.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, hch@infradead.org
Cc: mikecyr@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, joe@perches.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

This driver is a pick up of the old IBM VIO scsi Target Driver
that was started by Nick and Fujita 2-4 years ago.
http://comments.gmane.org/gmane.linux.scsi/90119

The driver provides a virtual SCSI device on IBM Power Servers.

This patch contains the fifth version for an initial merge of the
tcm ibmvscsis driver. More information on this driver and config
can be found:

https://github.com/powervm/ibmvscsis/wiki/Configuration
http://www.linux-iscsi.org/wiki/IBM_vSCSI

Signed-off-by: Steven Royer <seroyer@linux.vnet.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Signed-off-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
Version 5:
- Changed some print statements to dev_err.
-Also changed to use target_alloc_session instead of manually coding it.
- Removed scsi_cmnd and scsi_host bits removed from libsrp to completely
- Stripped out un-needed includes.
- Added pre-allocation of commands before IO starts.
- Added Support for Transport event, fast-fail support, MESSAGE_IN_CRQ format
- Changed the way queues are handled for better performance, and state mgmt.

Version 3:
- Revert old libsrp and make it clear resurrection old vscsi target driver
- Made libsrp a linked file to the ibmvscsis module

Version 2:
-Fixed comments from Bart/Joe in regards to styling and code structure

Version 1:
This initial commit contains WIP of the IBM VSCSI Target Fabric
Module. It currently supports read/writes, and I have tested
the ability to create a file backstore with the driver, install
RHEL, and then boot up the partition via filio backstore through
the driver.

 MAINTAINERS                          |   11 +
 drivers/scsi/Kconfig                 |   27 +-
 drivers/scsi/Makefile                |    2 +-
 drivers/scsi/ibmvscsi/Makefile       |    4 +
 drivers/scsi/ibmvscsi/ibmvscsi_tgt.c | 4184 ++++++++++++++++++++++++++++++++++
 drivers/scsi/ibmvscsi/ibmvscsi_tgt.h |  347 +++
 drivers/scsi/ibmvscsi/libsrp.c       |  427 ++++
 drivers/scsi/ibmvscsi/libsrp.h       |  123 +
 drivers/scsi/libsrp.c                |  447 ----
 include/scsi/libsrp.h                |   78 -
 10 files changed, 5114 insertions(+), 536 deletions(-)
 create mode 100644 drivers/scsi/ibmvscsi/ibmvscsi_tgt.c
 create mode 100644 drivers/scsi/ibmvscsi/ibmvscsi_tgt.h
 create mode 100644 drivers/scsi/ibmvscsi/libsrp.c
 create mode 100644 drivers/scsi/ibmvscsi/libsrp.h
 delete mode 100644 drivers/scsi/libsrp.c
 delete mode 100644 include/scsi/libsrp.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 66de4da..5f6610c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5683,6 +5683,17 @@ S:	Supported
 F:	drivers/scsi/ibmvscsi/ibmvscsi*
 F:	drivers/scsi/ibmvscsi/viosrp.h
 
+IBM Power Virtual SCSI Device Target Driver
+M:	Bryant G. Ly <bryantly@linux.vnet.ibm.com>
+M:	Michael Cyr <mikecyr@linux.vnet.ibm.com>
+L:	linux-scsi@vger.kernel.org
+L:	target-devel@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/ibmvscsi/ibmvscsis.c
+F:	drivers/scsi/ibmvscsi/ibmvscsis.h
+F:	drivers/scsi/ibmvscsi/libsrp.c
+F:	drivers/scsi/ibmvscsi/libsrp.h
+
 IBM Power Virtual FC Device Drivers
 M:	Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
 L:	linux-scsi@vger.kernel.org
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index d62170e..86c2d18 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -838,6 +838,23 @@ config SCSI_IBMVSCSI
 	  To compile this driver as a module, choose M here: the
 	  module will be called ibmvscsi.
 
+config SCSI_IBMVSCSIS
+	tristate "IBM Virtual SCSI Server support"
+	depends on PPC_PSERIES && TARGET_CORE && SCSI && PCI
+	help
+	  This is the IBM POWER Virtual SCSI Target Server
+	  This driver uses the SRP protocol for communication betwen servers
+	  guest and/or the host that run on the same server.
+	  More information on VSCSI protocol can be found at www.power.org
+
+	  The userspace configuration needed to initialize the driver can be
+	  be found here:
+
+	  https://github.com/powervm/ibmvscsis/wiki/Configuration
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ibmvstgt.
+
 config SCSI_IBMVFC
 	tristate "IBM Virtual FC support"
 	depends on PPC_PSERIES && SCSI
@@ -1719,16 +1736,6 @@ config SCSI_PM8001
 	  This driver supports PMC-Sierra PCIE SAS/SATA 8x6G SPC 8001 chip
 	  based host adapters.
 
-config SCSI_SRP
-	tristate "SCSI RDMA Protocol helper library"
-	depends on SCSI && PCI
-	select SCSI_TGT
-	help
-	  If you wish to use SRP target drivers, say Y.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called libsrp.
-
 config SCSI_BFA_FC
 	tristate "Brocade BFA Fibre Channel Support"
 	depends on PCI && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 0335d28..ea2030c 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -127,8 +127,8 @@ obj-$(CONFIG_SCSI_LASI700)	+= 53c700.o lasi700.o
 obj-$(CONFIG_SCSI_SNI_53C710)	+= 53c700.o sni_53c710.o
 obj-$(CONFIG_SCSI_NSP32)	+= nsp32.o
 obj-$(CONFIG_SCSI_IPR)		+= ipr.o
-obj-$(CONFIG_SCSI_SRP)		+= libsrp.o
 obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsi/
+obj-$(CONFIG_SCSI_IBMVSCSIS)	+= ibmvscsi/
 obj-$(CONFIG_SCSI_IBMVFC)	+= ibmvscsi/
 obj-$(CONFIG_SCSI_HPTIOP)	+= hptiop.o
 obj-$(CONFIG_SCSI_STEX)		+= stex.o
diff --git a/drivers/scsi/ibmvscsi/Makefile b/drivers/scsi/ibmvscsi/Makefile
index 3840c64..5e967bb 100644
--- a/drivers/scsi/ibmvscsi/Makefile
+++ b/drivers/scsi/ibmvscsi/Makefile
@@ -1,2 +1,6 @@
 obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsi.o
+obj-$(CONFIG_SCSI_IBMVSCSIS)	+= ibmvscsis.o
 obj-$(CONFIG_SCSI_IBMVFC)	+= ibmvfc.o
+
+ibmvscsis-objs := libsrp.o ibmvscsi_tgt.o
+
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi/ibmvscsi_tgt.c
new file mode 100644
index 0000000..b6e1b16
--- /dev/null
+++ b/drivers/scsi/ibmvscsi/ibmvscsi_tgt.c
@@ -0,0 +1,4184 @@
+/*******************************************************************************
+ * IBM Virtual SCSI Target Driver
+ * Copyright (C) 2003-2005 Dave Boutcher (boutcher@us.ibm.com) IBM Corp.
+ *			   Santiago Leon (santil@us.ibm.com) IBM Corp.
+ *			   Linda Xie (lxie@us.ibm.com) IBM Corp.
+ *
+ * Copyright (C) 2005-2011 FUJITA Tomonori <tomof@acm.org>
+ * Copyright (C) 2010 Nicholas A. Bellinger <nab@kernel.org>
+ * Copyright (C) 2016 Bryant G. Ly <bryantly@linux.vnet.ibm.com> IBM Corp.
+ *
+ * Authors: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
+ * Authors: Michael Cyr <mikecyr@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ ****************************************************************************/
+
+#define pr_fmt(fmt)     KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/kthread.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/string.h>
+#include <linux/version.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_fabric.h>
+#include <target/target_core_backend.h>
+
+#include <asm/hvcall.h>
+#include <asm/vio.h>
+
+#include "libsrp.h"
+#include "viosrp.h"
+#include "ibmvscsi_tgt.h"
+
+#ifndef H_GET_PARTNER_INFO
+#define H_GET_PARTNER_INFO      0x0000000000000008LL
+#endif
+
+#define IBMVSCSIS_VERSION	"v0.2"
+
+#define	INITIAL_SRP_LIMIT	800
+#define	DEFAULT_MAX_SECTORS	256
+
+static uint max_vdma_size = MAX_H_COPY_RDMA;
+
+static const char ibmvscsis_driver_name[] = "ibmvscsis";
+static const char ibmvscsis_workq_name[] = "ibmvscsis";
+static char system_id[SYS_ID_NAME_LEN] = "";
+static char partition_name[PARTITION_NAMELEN] = "UNKNOWN";
+static uint partition_number = -1;
+
+/* Adapter list and lock to control it */
+static DEFINE_SPINLOCK(ibmvscsis_dev_lock);
+static LIST_HEAD(ibmvscsis_dev_list);
+
+static void ibmvscsis_determine_resid(struct se_cmd *se_cmd,
+				      struct srp_rsp *rsp)
+{
+	u32 residual_count = se_cmd->residual_count;
+
+	if (!residual_count)
+		return;
+
+	if (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
+		if (se_cmd->data_direction == DMA_TO_DEVICE) {
+			/* residual data from an underflow write */
+			rsp->flags = SRP_RSP_FLAG_DOUNDER;
+			rsp->data_out_res_cnt = cpu_to_be32(residual_count);
+		} else if (se_cmd->data_direction == DMA_FROM_DEVICE) {
+			/* residual data from an underflow read */
+			rsp->flags = SRP_RSP_FLAG_DIUNDER;
+			rsp->data_in_res_cnt = cpu_to_be32(residual_count);
+		}
+	} else if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
+		if (se_cmd->data_direction == DMA_TO_DEVICE) {
+			/*  residual data from an overflow write */
+			rsp->flags = SRP_RSP_FLAG_DOOVER;
+			rsp->data_out_res_cnt = cpu_to_be32(residual_count);
+		} else if (se_cmd->data_direction == DMA_FROM_DEVICE) {
+			/* residual data from an overflow read */
+			rsp->flags = SRP_RSP_FLAG_DIOVER;
+			rsp->data_in_res_cnt = cpu_to_be32(residual_count);
+		}
+	}
+}
+
+static bool connection_broken(struct scsi_info *vscsi)
+{
+	struct viosrp_crq *crq;
+	u64 buffer[2] = { 0, 0 };
+	long h_return_code;
+	bool rc = false;
+
+	/* create a PING crq */
+	crq = (struct viosrp_crq *)&buffer;
+	crq->valid = VALID_CMD_RESP_EL;
+	crq->format = MESSAGE_IN_CRQ;
+	crq->status = PING;
+
+	h_return_code = h_send_crq(vscsi->dds.unit_id,
+				   cpu_to_be64(buffer[MSG_HI]),
+				   cpu_to_be64(buffer[MSG_LOW]));
+
+	pr_debug("connection_broken: rc %ld\n", h_return_code);
+
+	if (h_return_code == H_CLOSED)
+		rc = true;
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_unregister_command_q() - Helper Function-Unregister Command Queue
+ *
+ * This function calls h_free_q then frees the interrupt bit etc.
+ * It must release the lock before doing so because of the time it can take
+ * for h_free_crq in PHYP
+ * NOTE: the caller must make sure that state and or flags will prevent
+ *	 interrupt handler from scheduling work.
+ * NOTE: anyone calling this function may need to set the CRQ_CLOSED flag
+ *	 we can't do it here, because we don't have the lock
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Process level
+ */
+static long ibmvscsis_unregister_command_q(struct scsi_info *vscsi)
+{
+	long qrc;
+	long rc = ADAPT_SUCCESS;
+	int ticks = 0;
+
+	do {
+		qrc = h_free_crq(vscsi->dds.unit_id);
+		switch (qrc) {
+		case H_SUCCESS:
+			break;
+
+		case H_HARDWARE:
+		case H_PARAMETER:
+			dev_err(&vscsi->dev, "Unregister_command_q: error from h_free_crq %ld\n",
+				qrc);
+			rc = ERROR;
+			break;
+
+		case H_BUSY:
+		case H_LONG_BUSY_ORDER_1_MSEC:
+			/* msleep not good for small values */
+			usleep_range(1000, 2000);
+			ticks += 1;
+			break;
+		case H_LONG_BUSY_ORDER_10_MSEC:
+			usleep_range(10000, 20000);
+			ticks += 10;
+			break;
+		case H_LONG_BUSY_ORDER_100_MSEC:
+			msleep(100);
+			ticks += 100;
+			break;
+		case H_LONG_BUSY_ORDER_1_SEC:
+			ssleep(1);
+			ticks += 1000;
+			break;
+		case H_LONG_BUSY_ORDER_10_SEC:
+			ssleep(10);
+			ticks += 10000;
+			break;
+		case H_LONG_BUSY_ORDER_100_SEC:
+			ssleep(100);
+			ticks += 100000;
+			break;
+		default:
+			dev_err(&vscsi->dev, "Unregister_command_q: unknown error %ld from h_free_crq\n",
+				qrc);
+			rc = ERROR;
+			break;
+		}
+
+		/*
+		 * dont wait more then 300 seconds
+		 * ticks are in milliseconds more or less
+		 */
+		if (ticks > 300000 && qrc != H_SUCCESS) {
+			rc = ERROR;
+			dev_err(&vscsi->dev, "Excessive wait for h_free_crq\n");
+		}
+	} while (qrc != H_SUCCESS && rc == ADAPT_SUCCESS);
+
+	pr_debug("Freeing CRQ: phyp rc %ld, rc %ld\n", qrc, rc);
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_delete_client_info() - Helper function to Delete Client Info
+ *
+ * Deletes information specific to the client when the client goes away
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Interrupt
+ */
+static void ibmvscsis_delete_client_info(struct scsi_info *vscsi,
+					 bool client_closed)
+{
+	vscsi->client_cap = 0;
+
+	/*
+	 * Some things we don't want to clear if we're closing the queue,
+	 * because some clients don't resend the host handshake when they
+	 * get a transport event.
+	 */
+	if (client_closed)
+		vscsi->client_data.os_type = 0;
+}
+
+/**
+ * ibmvscsis_free_command_q() - Free Command Queue
+ *
+ * This function calls unregister_command_q, then clears interrupts and
+ * any pending interrupt acknowledgments associated with the command q.
+ * It also clears memory if there is no error.
+ *
+ * PHYP did not meet the PAPR architecture so that we must give up the
+ * lock. This causes a timing hole regarding state change.  To close the
+ * hole this routine does accounting on any change that occurred during
+ * the time the lock is not held.
+ * NOTE: must give up and then acquire the interrupt lock, the caller must
+ *	 make sure that state and or flags will prevent interrupt handler from
+ *	 scheduling work.
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Process level, interrupt lock is held
+ */
+static long ibmvscsis_free_command_q(struct scsi_info *vscsi)
+{
+	int bytes;
+	u32 flags_under_lock;
+	u16 state_under_lock;
+	long rc = ADAPT_SUCCESS;
+
+	if (!(vscsi->flags & CRQ_CLOSED)) {
+		vio_disable_interrupts(vscsi->dma_dev);
+
+		state_under_lock = vscsi->new_state;
+		flags_under_lock = vscsi->flags;
+		vscsi->phyp_acr_state = 0;
+		vscsi->phyp_acr_flags = 0;
+
+		spin_unlock_bh(&vscsi->intr_lock);
+		rc = ibmvscsis_unregister_command_q(vscsi);
+		spin_lock_bh(&vscsi->intr_lock);
+
+		if (state_under_lock != vscsi->new_state)
+			vscsi->phyp_acr_state = vscsi->new_state;
+
+		vscsi->phyp_acr_flags = ((~flags_under_lock) & vscsi->flags);
+
+		if (rc == ADAPT_SUCCESS) {
+			bytes = vscsi->cmd_q.size * PAGE_SIZE;
+			memset(vscsi->cmd_q.base_addr, 0, bytes);
+			vscsi->cmd_q.index = 0;
+			vscsi->flags |= CRQ_CLOSED;
+
+			ibmvscsis_delete_client_info(vscsi, false);
+		}
+
+		pr_debug("free_command_q: flags 0x%x, state 0x%hx, acr_flags 0x%x, acr_state 0x%hx\n",
+			 vscsi->flags, vscsi->state, vscsi->phyp_acr_flags,
+			 vscsi->phyp_acr_state);
+	}
+	return rc;
+}
+
+/**
+ * ibmvscsis_cmd_q_dequeue() - Get valid Command element
+ *
+ * Returns a pointer to a valid command element or NULL, if the the command
+ * queue is empty
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Interrupt environment
+ */
+static struct viosrp_crq *ibmvscsis_cmd_q_dequeue(uint mask,
+						  uint *current_index,
+						  struct viosrp_crq *base_addr)
+{
+	struct viosrp_crq *ptr;
+
+	ptr = base_addr + *current_index;
+
+	if (ptr->valid) {
+		*current_index = (*current_index + 1) & mask;
+		dma_rmb();
+	} else {
+		ptr = NULL;
+	}
+
+	return ptr;
+}
+
+/**
+ * ibmvscsis_send_init_message() -  send initialize message to the client
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Interrupt environment interrupt lock held
+ */
+static long ibmvscsis_send_init_message(struct scsi_info *vscsi, u8 format)
+{
+	struct viosrp_crq *crq;
+	u64 buffer[2] = { 0, 0 };
+	long rc;
+
+	crq = (struct viosrp_crq *)&buffer;
+	crq->valid = VALID_INIT_MSG;
+	crq->format = format;
+	rc = h_send_crq(vscsi->dds.unit_id, cpu_to_be64(buffer[MSG_HI]),
+			cpu_to_be64(buffer[MSG_LOW]));
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_check_init_msg() - Check init message valid
+ *
+ * Checks if an initialize message was queued by the initiatior
+ * after the queue was created and before the interrupt was enabled.
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Process level only
+ */
+static long ibmvscsis_check_init_msg(struct scsi_info *vscsi, uint *format)
+{
+	struct viosrp_crq *crq;
+	long rc = ADAPT_SUCCESS;
+
+	crq = ibmvscsis_cmd_q_dequeue(vscsi->cmd_q.mask, &vscsi->cmd_q.index,
+				      vscsi->cmd_q.base_addr);
+	if (!crq) {
+		*format = (uint)UNUSED_FORMAT;
+	} else if (crq->valid == VALID_INIT_MSG && crq->format == INIT_MSG) {
+		*format = (uint)INIT_MSG;
+		crq->valid = INVALIDATE_CMD_RESP_EL;
+		dma_rmb();
+
+		/*
+		 * the caller has ensured no initialize message was
+		 * sent after the queue was
+		 * created so there should be no other message on the queue.
+		 */
+		crq = ibmvscsis_cmd_q_dequeue(vscsi->cmd_q.mask,
+					      &vscsi->cmd_q.index,
+					      vscsi->cmd_q.base_addr);
+		if (crq) {
+			*format = (uint)(crq->format);
+			rc =  ERROR;
+			crq->valid = INVALIDATE_CMD_RESP_EL;
+			dma_rmb();
+		}
+	} else {
+		*format = (uint)(crq->format);
+		rc =  ERROR;
+		crq->valid = INVALIDATE_CMD_RESP_EL;
+		dma_rmb();
+	}
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_establish_new_q() - Establish new CRQ queue
+ */
+static long ibmvscsis_establish_new_q(struct scsi_info *vscsi,  uint new_state)
+{
+	long rc = ADAPT_SUCCESS;
+	uint format;
+
+	vscsi->flags &= PRESERVE_FLAG_FIELDS;
+	vscsi->rsp_q_timer.timer_pops = 0;
+	vscsi->debit = 0;
+	vscsi->credit = 0;
+	rc = vio_enable_interrupts(vscsi->dma_dev);
+	if (rc) {
+		pr_warn("reset_queue: failed to enable interrupts, rc %ld\n",
+			rc);
+	} else {
+		rc = ibmvscsis_check_init_msg(vscsi, &format);
+		if (rc) {
+			dev_err(&vscsi->dev, "reset_queue: check_init_msg failed, rc %ld\n",
+				rc);
+		} else if (format == UNUSED_FORMAT &&
+			   new_state == WAIT_CONNECTION) {
+			rc = ibmvscsis_send_init_message(vscsi, INIT_MSG);
+			switch (rc) {
+			case H_SUCCESS:
+			case H_DROPPED:
+			case H_CLOSED:
+				rc = ADAPT_SUCCESS;
+				break;
+
+			case H_PARAMETER:
+			case H_HARDWARE:
+				break;
+
+			default:
+				vscsi->state = UNDEFINED;
+				rc = H_HARDWARE;
+				break;
+			}
+		}
+	}
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_reset_queue() - Reset CRQ Queue
+ *
+ * This function calls h_free_q and then calls h_reg_q and does all
+ * of the bookkeeping to get us back to where we can communicate.
+ *
+ * Actually, we don't always call h_free_crq.  A problem was discovered
+ * where one partition would close and reopen his queue, which would
+ * cause his partner to get a transport event, which would cause him to
+ * close and reopen his queue, which would cause the original partition
+ * to get a transport event, etc., etc.  To prevent this, we don't
+ * actually close our queue if the client initiated the reset, (i.e.
+ * either we got a transport event or we have detected that the client's
+ * queue is gone)
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Process environment, called with interrupt lock held
+ */
+static void ibmvscsis_reset_queue(struct scsi_info *vscsi, uint new_state)
+{
+	int bytes;
+	long rc = ADAPT_SUCCESS;
+
+	pr_debug("reset_queue: flags 0x%x\n", vscsi->flags);
+
+	/* don't reset, the client did it for us */
+	if (vscsi->flags & (CLIENT_FAILED | TRANS_EVENT)) {
+		vscsi->flags &=  PRESERVE_FLAG_FIELDS;
+		vscsi->rsp_q_timer.timer_pops = 0;
+		vscsi->debit = 0;
+		vscsi->credit = 0;
+		vscsi->state = new_state;
+		vio_enable_interrupts(vscsi->dma_dev);
+	} else {
+		rc = ibmvscsis_free_command_q(vscsi);
+		if (rc == ADAPT_SUCCESS) {
+			vscsi->state = new_state;
+
+			bytes = vscsi->cmd_q.size * PAGE_SIZE;
+			rc = h_reg_crq(vscsi->dds.unit_id,
+				       vscsi->cmd_q.crq_token, bytes);
+			if (rc == H_CLOSED || rc == H_SUCCESS) {
+				rc = ibmvscsis_establish_new_q(vscsi,
+							       new_state);
+			}
+
+			if (rc != ADAPT_SUCCESS) {
+				pr_debug("reset_queue: reg_crq rc %ld\n", rc);
+
+				vscsi->state = ERR_DISCONNECTED;
+				vscsi->flags |=  RESPONSE_Q_DOWN;
+				ibmvscsis_free_command_q(vscsi);
+			}
+		} else {
+			vscsi->state = ERR_DISCONNECTED;
+			vscsi->flags |= RESPONSE_Q_DOWN;
+		}
+	}
+}
+
+/**
+ * ibmvscsis_free_cmd_resources() - Free command resources
+ */
+static void ibmvscsis_free_cmd_resources(struct scsi_info *vscsi,
+					 struct ibmvscsis_cmd *cmd)
+{
+	struct iu_entry *iue = cmd->iue;
+
+	switch (cmd->type) {
+	case TASK_MANAGEMENT:
+	case SCSI_CDB:
+		/*
+		 * When the queue goes down this value is cleared, so it
+		 * cannot be cleared in this general purpose function.
+		 */
+		if (vscsi->debit)
+			vscsi->debit -= 1;
+		break;
+	case ADAPTER_MAD:
+		vscsi->flags &= (~PROCESSING_MAD);
+		break;
+	case UNSET_TYPE:
+		break;
+	default:
+		dev_err(&vscsi->dev, "free_cmd_resources unknown type %d\n",
+			cmd->type);
+		break;
+	}
+
+	cmd->iue = NULL;
+	list_add_tail(&cmd->list, &vscsi->free_cmd);
+	srp_iu_put(iue);
+
+	if (list_empty(&vscsi->active_q) && list_empty(&vscsi->schedule_q) &&
+	    list_empty(&vscsi->waiting_rsp) && (vscsi->flags & WAIT_FOR_IDLE)) {
+		vscsi->flags &= ~WAIT_FOR_IDLE;
+		complete(&vscsi->wait_idle);
+	}
+}
+
+static void ibmvscsis_adapter_idle(struct scsi_info *vscsi);
+
+/**
+ * ibmvscsis_disconnect() - Helper function to disconnect
+ *
+ * An error has occurred or the driver received a Transport event,
+ * and the driver is requesting that the command queue be de-registered
+ * in a safe manner. If there is no outstanding I/O then we can stop the
+ * queue. If we are restarting the queue it will be reflected in the
+ * the state of the adapter.
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Process environment
+ */
+static void ibmvscsis_disconnect(struct work_struct *work)
+{
+	struct scsi_info *vscsi = container_of(work, struct scsi_info,
+					       proc_work);
+	u16 new_state;
+	bool wait_idle = false;
+	long rc = ADAPT_SUCCESS;
+
+	spin_lock_bh(&vscsi->intr_lock);
+	new_state = vscsi->new_state;
+	vscsi->new_state = 0;
+
+	pr_debug("disconnect: flags 0x%x, state 0x%hx\n", vscsi->flags,
+		 vscsi->state);
+
+	/*
+	 * check which state we are in and see if we
+	 * should transitition to the new state
+	 */
+	switch (vscsi->state) {
+		/*  Should never be called while in this state. */
+	case NO_QUEUE:
+		/*
+		 * Can never transition from this state;
+		 * igonore errors and logout.
+		 */
+	case UNCONFIGURING:
+		break;
+
+		/* can transition from this state to UNCONFIGURING */
+	case ERR_DISCONNECT:
+		if (new_state == UNCONFIGURING)
+			vscsi->state = new_state;
+		break;
+
+		/*
+		 * Can transition from this state to to unconfiguring
+		 * or err disconnect.
+		 */
+	case ERR_DISCONNECT_RECONNECT:
+		switch (new_state) {
+		case UNCONFIGURING:
+		case ERR_DISCONNECT:
+			vscsi->state = new_state;
+			break;
+
+		case WAIT_IDLE:
+			break;
+		default:
+			break;
+		}
+		break;
+
+		/* can transition from this state to UNCONFIGURING */
+	case ERR_DISCONNECTED:
+		if (new_state == UNCONFIGURING)
+			vscsi->state = new_state;
+		break;
+
+		/*
+		 * If this is a transition into an error state.
+		 * a client is attempting to establish a connection
+		 * and has violated the RPA protocol.
+		 * There can be nothing pending on the adapter although
+		 * there can be requests in the command queue.
+		 */
+	case WAIT_ENABLED:
+	case PART_UP_WAIT_ENAB:
+		switch (new_state) {
+		case ERR_DISCONNECT:
+			vscsi->flags |= RESPONSE_Q_DOWN;
+			vscsi->state = new_state;
+			vscsi->flags &= (~(SCHEDULE_DISCONNECT |
+					   DISCONNECT_SCHEDULED));
+			ibmvscsis_free_command_q(vscsi);
+			break;
+		case ERR_DISCONNECT_RECONNECT:
+			ibmvscsis_reset_queue(vscsi, WAIT_ENABLED);
+			break;
+
+			/* should never happen */
+		case WAIT_IDLE:
+			rc = ERROR;
+			dev_err(&vscsi->dev, "disconnect: invalid state %d for WAIT_IDLE\n",
+				vscsi->state);
+			break;
+		}
+		break;
+
+	case WAIT_IDLE:
+		switch (new_state) {
+		case ERR_DISCONNECT:
+		case ERR_DISCONNECT_RECONNECT:
+			vscsi->state = new_state;
+			break;
+		}
+		break;
+
+		/*
+		 * Initiator has not done a successful srp login
+		 * or has done a successful srp logout ( adapter was not
+		 * busy). In the first case there can be responses queued
+		 * waiting for space on the initiators response queue (MAD)
+		 * The second case the adapter is idle. Assume the worse case,
+		 * i.e. the second case.
+		 */
+	case WAIT_CONNECTION:
+	case CONNECTED:
+	case SRP_PROCESSING:
+		wait_idle = true;
+		vscsi->state = new_state;
+		break;
+
+		/* can transition from this state to UNCONFIGURING */
+	case UNDEFINED:
+		if (new_state == UNCONFIGURING)
+			vscsi->state = new_state;
+		break;
+	default:
+		break;
+	}
+
+	if (wait_idle) {
+		pr_debug("disconnect start wait, active %d, sched %d\n",
+			 (int)list_empty(&vscsi->active_q),
+			 (int)list_empty(&vscsi->schedule_q));
+		if (!list_empty(&vscsi->active_q) ||
+		    !list_empty(&vscsi->schedule_q)) {
+			vscsi->flags |= WAIT_FOR_IDLE;
+			pr_debug("disconnect flags 0x%x\n", vscsi->flags);
+			/*
+			 * This routine is can not be called with the interrupt
+			 * lock held.
+			 */
+			spin_unlock_bh(&vscsi->intr_lock);
+			wait_for_completion(&vscsi->wait_idle);
+			spin_lock_bh(&vscsi->intr_lock);
+		}
+		pr_debug("disconnect stop wait\n");
+
+		ibmvscsis_adapter_idle(vscsi);
+	}
+
+	spin_unlock_bh(&vscsi->intr_lock);
+}
+
+/**
+ * ibmvscsis_post_disconnect() - Schedule the disconnect
+ *
+ * If it's already been scheduled, then see if we need to "upgrade"
+ * the new state (if the one passed in is more "severe" than the
+ * previous one).
+ *
+ * PRECONDITION:
+ *	interrupt lock is held
+ */
+static void ibmvscsis_post_disconnect(struct scsi_info *vscsi, uint new_state,
+				      uint flag_bits)
+{
+	uint state;
+
+	/* check the validity of the new state */
+	switch (new_state) {
+	case UNCONFIGURING:
+	case ERR_DISCONNECT:
+	case ERR_DISCONNECT_RECONNECT:
+	case WAIT_IDLE:
+		break;
+
+	default:
+		dev_err(&vscsi->dev, "post_disconnect: Invalid new state %d\n",
+			new_state);
+		return;
+	}
+
+	vscsi->flags |= flag_bits;
+
+	pr_debug("post_disconnect: new_state 0x%x, flag_bits 0x%x, vscsi->flags 0x%x, state %hx\n",
+		 new_state, flag_bits, vscsi->flags, vscsi->state);
+
+	if (!(vscsi->flags & (DISCONNECT_SCHEDULED | SCHEDULE_DISCONNECT))) {
+		vscsi->flags |= SCHEDULE_DISCONNECT;
+		vscsi->new_state = new_state;
+
+		INIT_WORK(&vscsi->proc_work, ibmvscsis_disconnect);
+		(void)queue_work(vscsi->work_q, &vscsi->proc_work);
+	} else {
+		if (vscsi->new_state)
+			state = vscsi->new_state;
+		else
+			state = vscsi->state;
+
+		switch (state) {
+		case NO_QUEUE:
+		case UNCONFIGURING:
+			break;
+
+		case ERR_DISCONNECTED:
+		case ERR_DISCONNECT:
+		case UNDEFINED:
+			if (new_state == UNCONFIGURING)
+				vscsi->new_state = new_state;
+			break;
+
+		case ERR_DISCONNECT_RECONNECT:
+			switch (new_state) {
+			case UNCONFIGURING:
+			case ERR_DISCONNECT:
+				vscsi->new_state = new_state;
+				break;
+			default:
+				break;
+			}
+			break;
+
+		case WAIT_ENABLED:
+		case PART_UP_WAIT_ENAB:
+		case WAIT_IDLE:
+		case WAIT_CONNECTION:
+		case CONNECTED:
+		case SRP_PROCESSING:
+			vscsi->new_state = new_state;
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	pr_debug("Leaving post_disconnect: flags 0x%x, new_state 0x%x\n",
+		 vscsi->flags, vscsi->new_state);
+}
+
+/**
+ * ibmvscsis_trans_event() - Transport Event to close I_T Nexus
+ *
+ * This function may not behave to specification.
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Interrupt
+ */
+static long ibmvscsis_trans_event(struct scsi_info *vscsi,
+				  struct viosrp_crq *crq)
+{
+	long rc = ADAPT_SUCCESS;
+
+	pr_debug("trans_event: format %d, flags 0x%x, state 0x%hx\n",
+		 (int)crq->format, vscsi->flags, vscsi->state);
+
+	switch (crq->format) {
+	case MIGRATED:
+	case PARTNER_FAILED:
+	case PARTNER_DEREGISTER:
+		ibmvscsis_delete_client_info(vscsi, true);
+		break;
+
+	default:
+		rc = ERROR;
+		dev_err(&vscsi->dev, "trans_event: invalid format %d\n",
+			(uint)crq->format);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT,
+					  RESPONSE_Q_DOWN);
+		break;
+	}
+
+	if (rc == ADAPT_SUCCESS) {
+		switch (vscsi->state) {
+		case NO_QUEUE:
+		case ERR_DISCONNECTED:
+		case UNDEFINED:
+			break;
+
+		case UNCONFIGURING:
+			vscsi->flags |= (RESPONSE_Q_DOWN | TRANS_EVENT);
+			break;
+
+		case WAIT_ENABLED:
+			break;
+
+		case WAIT_CONNECTION:
+			break;
+
+		case CONNECTED:
+			ibmvscsis_post_disconnect(vscsi, WAIT_IDLE,
+						  (RESPONSE_Q_DOWN |
+						  TRANS_EVENT));
+			break;
+
+		case PART_UP_WAIT_ENAB:
+			vscsi->state = WAIT_ENABLED;
+			break;
+
+		case SRP_PROCESSING:
+			if ((vscsi->debit > 0) ||
+			    !list_empty(&vscsi->schedule_q) ||
+			    !list_empty(&vscsi->waiting_rsp) ||
+			    !list_empty(&vscsi->active_q)) {
+				pr_debug("debit %d, sched %d, wait %d, active %d\n",
+					 vscsi->debit,
+					 (int)list_empty(&vscsi->schedule_q),
+					 (int)list_empty(&vscsi->waiting_rsp),
+					 (int)list_empty(&vscsi->active_q));
+				pr_warn("connection lost with outstanding work\n");
+			} else {
+				pr_debug("trans_event: SRP Processing, but no outstanding work\n");
+			}
+
+			ibmvscsis_post_disconnect(vscsi, WAIT_IDLE,
+						  (RESPONSE_Q_DOWN |
+						   TRANS_EVENT));
+			break;
+
+		case ERR_DISCONNECT:
+		case ERR_DISCONNECT_RECONNECT:
+		case WAIT_IDLE:
+			vscsi->flags |= (RESPONSE_Q_DOWN | TRANS_EVENT);
+			break;
+		}
+	}
+
+	rc =  vscsi->flags & SCHEDULE_DISCONNECT;
+
+	pr_debug("Leaving trans_event: flags 0x%x, state 0x%hx, rc %ld\n",
+		 vscsi->flags, vscsi->state, rc);
+
+	return rc;
+}
+
+static long ibmvscsis_parse_command(struct scsi_info *vscsi,
+				    struct viosrp_crq *crq);
+
+/**
+ * ibmvscsis_poll_cmd_q() - Poll Command Queue
+ *
+ * Called to handle command elements that may have arrived while
+ * interrupts were disabled.
+ *
+ * EXECUTION ENVIRONMENT:
+ *	intr_lock must be held
+ */
+static void ibmvscsis_poll_cmd_q(struct scsi_info *vscsi)
+{
+	struct viosrp_crq *crq;
+	long rc;
+	bool ack = true;
+	volatile u8 valid;
+
+	pr_debug("poll_cmd_q: flags 0x%x, state 0x%hx, q index %ud\n",
+		 vscsi->flags, vscsi->state, vscsi->cmd_q.index);
+
+	rc = vscsi->flags & SCHEDULE_DISCONNECT;
+	crq = vscsi->cmd_q.base_addr + vscsi->cmd_q.index;
+	valid = crq->valid;
+	dma_rmb();
+
+	while (valid) {
+poll_work:
+		vscsi->cmd_q.index =
+			(vscsi->cmd_q.index + 1) & vscsi->cmd_q.mask;
+
+		if (!rc) {
+			rc = ibmvscsis_parse_command(vscsi, crq);
+		} else {
+			if ((uint)crq->valid == VALID_TRANS_EVENT) {
+				/*
+				 * must service the transport layer events even
+				 * in an error state, dont break out until all
+				 * the consecutive transport events have been
+				 * processed
+				 */
+				rc = ibmvscsis_trans_event(vscsi, crq);
+			} else if (vscsi->flags & TRANS_EVENT) {
+				/*
+				 * if a tranport event has occurred leave
+				 * everything but transport events on the queue
+				 */
+				pr_debug("poll_cmd_q, ignoring\n");
+
+				/*
+				 * need to decrement the queue index so we can
+				 * look at the elment again
+				 */
+				if (vscsi->cmd_q.index)
+					vscsi->cmd_q.index -= 1;
+				else
+					/*
+					 * index is at 0 it just wrapped.
+					 * have it index last element in q
+					 */
+					vscsi->cmd_q.index = vscsi->cmd_q.mask;
+				break;
+			}
+		}
+
+		crq->valid = INVALIDATE_CMD_RESP_EL;
+
+		crq = vscsi->cmd_q.base_addr + vscsi->cmd_q.index;
+		valid = crq->valid;
+		dma_rmb();
+	}
+
+	if (!rc) {
+		if (ack) {
+			vio_enable_interrupts(vscsi->dma_dev);
+			ack = false;
+			pr_debug("poll_cmd_q, reenabling interrupts\n");
+		}
+		valid = crq->valid;
+		dma_rmb();
+		if (valid)
+			goto poll_work;
+	}
+
+	pr_debug("Leaving poll_cmd_q: rc %ld\n", rc);
+}
+
+/**
+ * ibmvscsis_free_cmd_qs() - Free elements in queue
+ *
+ * Free all of the elements on all queues that are waiting for
+ * whatever reason.
+ *
+ * PRECONDITION:
+ *	Called with interrupt lock held
+ */
+static void ibmvscsis_free_cmd_qs(struct scsi_info *vscsi)
+{
+	struct ibmvscsis_cmd *cmd, *nxt;
+
+	pr_debug("free_cmd_qs: waiting_rsp empty %d, timer starter %d\n",
+		 (int)list_empty(&vscsi->waiting_rsp),
+		 vscsi->rsp_q_timer.started);
+
+	list_for_each_entry_safe(cmd, nxt, &vscsi->waiting_rsp, list) {
+		list_del(&cmd->list);
+		ibmvscsis_free_cmd_resources(vscsi, cmd);
+	}
+}
+
+/**
+ * ibmvscsis_get_free_cmd() - Get free command from list
+ */
+static struct ibmvscsis_cmd *ibmvscsis_get_free_cmd(struct scsi_info *vscsi)
+{
+	struct ibmvscsis_cmd *cmd = NULL;
+	struct iu_entry *iue;
+
+	iue = srp_iu_get(&vscsi->target);
+	if (iue) {
+		cmd = list_first_entry_or_null(&vscsi->free_cmd,
+					       struct ibmvscsis_cmd, list);
+		if (cmd) {
+			list_del(&cmd->list);
+			cmd->iue = iue;
+			cmd->type = UNSET_TYPE;
+			memset(&cmd->se_cmd, 0, sizeof(cmd->se_cmd));
+		} else {
+			srp_iu_put(iue);
+		}
+	}
+
+	return cmd;
+}
+
+/**
+ * ibmvscsis_adapter_idle() - Helper function to handle idle adapter
+ *
+ * This function is called when the adapter is idle when the driver
+ * is attempting to clear an error condition.
+ * The adapter is considered busy if any of its cmd queues
+ * are non-empty. This function can be invoked
+ * from the off level disconnect function.
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Process environment called with interrupt lock held
+ */
+static void ibmvscsis_adapter_idle(struct scsi_info *vscsi)
+{
+	int free_qs = false;
+
+	pr_debug("adapter_idle: flags 0x%x, state 0x%hx\n", vscsi->flags,
+		 vscsi->state);
+
+	/* Only need to free qs if we're disconnecting from client */
+	if (vscsi->state != WAIT_CONNECTION || vscsi->flags & TRANS_EVENT)
+		free_qs = true;
+
+	switch (vscsi->state) {
+	case ERR_DISCONNECT_RECONNECT:
+		ibmvscsis_reset_queue(vscsi, WAIT_CONNECTION);
+		pr_debug("adapter_idle, disc_rec: flags 0x%x\n", vscsi->flags);
+		break;
+
+	case ERR_DISCONNECT:
+		ibmvscsis_free_command_q(vscsi);
+		vscsi->flags &= (~DISCONNECT_SCHEDULED);
+		vscsi->flags |= RESPONSE_Q_DOWN;
+		vscsi->state = ERR_DISCONNECTED;
+		pr_debug("adapter_idle, disc: flags 0x%x, state 0x%hx\n",
+			 vscsi->flags, vscsi->state);
+		break;
+
+	case WAIT_IDLE:
+		vscsi->rsp_q_timer.timer_pops = 0;
+		vscsi->debit = 0;
+		vscsi->credit = 0;
+		if (vscsi->flags & TRANS_EVENT) {
+			vscsi->state = WAIT_CONNECTION;
+			vscsi->flags &= PRESERVE_FLAG_FIELDS;
+		} else {
+			vscsi->state = CONNECTED;
+			vscsi->flags &= ~DISCONNECT_SCHEDULED;
+		}
+
+		pr_debug("adapter_idle, wait: flags 0x%x, state 0x%hx\n",
+			 vscsi->flags, vscsi->state);
+		ibmvscsis_poll_cmd_q(vscsi);
+		break;
+
+	case ERR_DISCONNECTED:
+		vscsi->flags &= ~DISCONNECT_SCHEDULED;
+		pr_debug("adapter_idle, disconnected: flags 0x%x, state 0x%hx\n",
+			 vscsi->flags, vscsi->state);
+		break;
+
+	default:
+		dev_err(&vscsi->dev, "adapter_idle: in invalid state %d\n",
+			vscsi->state);
+		break;
+	}
+
+	if (free_qs)
+		ibmvscsis_free_cmd_qs(vscsi);
+
+	/*
+	 * There is a timing window where we could lose a disconnect request.
+	 * The known path to this window occurs during the DISCONNECT_RECONNECT
+	 * case above: reset_queue calls free_command_q, which will release the
+	 * interrupt lock.  During that time, a new post_disconnect call can be
+	 * made with a "more severe" state (DISCONNECT or UNCONFIGURING).
+	 * Because the DISCONNECT_SCHEDULED flag is already set, post_disconnect
+	 * will only set the new_state.  Now free_command_q reacquires the intr
+	 * lock and clears the DISCONNECT_SCHEDULED flag (using PRESERVE_FLAG_
+	 * FIELDS), and the disconnect is lost.  This is particularly bad when
+	 * the new disconnect was for UNCONFIGURING, since the unconfigure hangs
+	 * forever.
+	 * Fix is that free command queue sets acr state and acr flags if there
+	 * is a change under the lock
+	 * note free command queue writes to this state it clears it
+	 * before releasing the lock, different drivers call the free command
+	 * queue different times so dont initialize above
+	 */
+	if (vscsi->phyp_acr_state != 0)	{
+		/*
+		 * set any bits in flags that may have been cleared by
+		 * a call to free command queue in switch statement
+		 * or reset queue
+		 */
+		vscsi->flags |= vscsi->phyp_acr_flags;
+		ibmvscsis_post_disconnect(vscsi, vscsi->phyp_acr_state, 0);
+		vscsi->phyp_acr_state = 0;
+		vscsi->phyp_acr_flags = 0;
+
+		pr_debug("adapter_idle: flags 0x%x, state 0x%hx, acr_flags 0x%x, acr_state 0x%hx\n",
+			 vscsi->flags, vscsi->state, vscsi->phyp_acr_flags,
+			 vscsi->phyp_acr_state);
+	}
+
+	pr_debug("Leaving adapter_idle: flags 0x%x, state 0x%hx, new_state 0x%x\n",
+		 vscsi->flags, vscsi->state, vscsi->new_state);
+}
+
+/**
+ * ibmvscsis_copy_crq_packet() - Copy CRQ Packet
+ *
+ * Copy the srp information unit from the hosted
+ * partition using remote dma
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Interrupt
+ */
+static long ibmvscsis_copy_crq_packet(struct scsi_info *vscsi,
+				      struct ibmvscsis_cmd *cmd,
+				      struct viosrp_crq *crq)
+{
+	struct iu_entry *iue = cmd->iue;
+	long rc = 0;
+	u16 len;
+
+	len = be16_to_cpu(crq->IU_length);
+	if ((len > SRP_MAX_IU_LEN) || (len == 0)) {
+		dev_err(&vscsi->dev, "copy_crq: Invalid len %d passed", len);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+		return SRP_VIOLATION;
+	}
+
+	rc = h_copy_rdma(len, vscsi->dds.window[REMOTE].liobn,
+			 be64_to_cpu(crq->IU_data_ptr),
+			 vscsi->dds.window[LOCAL].liobn, iue->sbuf->dma);
+
+	switch (rc) {
+	case H_SUCCESS:
+		cmd->init_time = mftb();
+		iue->remote_token = crq->IU_data_ptr;
+		iue->iu_len = len;
+		pr_debug("copy_crq: ioba 0x%llx, init_time 0x%llx\n",
+			 be64_to_cpu(crq->IU_data_ptr), cmd->init_time);
+		break;
+	case H_PERMISSION:
+		if (connection_broken(vscsi))
+			ibmvscsis_post_disconnect(vscsi,
+						  ERR_DISCONNECT_RECONNECT,
+						  (RESPONSE_Q_DOWN |
+						   CLIENT_FAILED));
+		else
+			ibmvscsis_post_disconnect(vscsi,
+						  ERR_DISCONNECT_RECONNECT, 0);
+
+		dev_err(&vscsi->dev, "copy_crq: h_copy_rdma failed, rc %ld\n",
+			rc);
+		break;
+	case H_DEST_PARM:
+	case H_SOURCE_PARM:
+	default:
+		dev_err(&vscsi->dev, "copy_crq: h_copy_rdma failed, rc %ld\n",
+			rc);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+		break;
+	}
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_adapter_info - Store adapter info
+ */
+static long ibmvscsis_adapter_info(struct scsi_info *vscsi,
+				   struct iu_entry *iue)
+{
+	struct viosrp_adapter_info *mad = &vio_iu(iue)->mad.adapter_info;
+	struct mad_adapter_info_data *info;
+	uint flag_bits = 0;
+	dma_addr_t token;
+	long rc;
+
+	mad->common.status = cpu_to_be16(VIOSRP_MAD_SUCCESS);
+
+	if (be16_to_cpu(mad->common.length) > sizeof(*info)) {
+		mad->common.status = cpu_to_be16(VIOSRP_MAD_FAILED);
+		return 0;
+	}
+
+	info = dma_alloc_coherent(&vscsi->dma_dev->dev, sizeof(*info), &token,
+				  GFP_KERNEL);
+	if (!info) {
+		dev_err(&vscsi->dev, "bad dma_alloc_coherent %p\n",
+			iue->target);
+		mad->common.status = cpu_to_be16(VIOSRP_MAD_FAILED);
+		return 0;
+	}
+
+	/* Get remote info */
+	rc = h_copy_rdma(be16_to_cpu(mad->common.length),
+			 vscsi->dds.window[REMOTE].liobn,
+			 be64_to_cpu(mad->buffer),
+			 vscsi->dds.window[LOCAL].liobn, token);
+
+	if (rc != H_SUCCESS) {
+		if (rc == H_PERMISSION) {
+			if (connection_broken(vscsi))
+				flag_bits = (RESPONSE_Q_DOWN | CLIENT_FAILED);
+		}
+		pr_warn("adapter_info: h_copy_rdma from client failed, rc %ld\n",
+			rc);
+		pr_debug("adapter_info: ioba 0x%llx, flags 0x%x, flag_bits 0x%x\n",
+			 be64_to_cpu(mad->buffer), vscsi->flags, flag_bits);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT,
+					  flag_bits);
+		goto free_dma;
+	}
+
+	/*
+	 * Copy client info, but ignore partition number, which we
+	 * already got from phyp - unless we failed to get it from
+	 * phyp (e.g. if we're running on a p5 system).
+	 */
+	if (vscsi->client_data.partition_number == 0)
+		vscsi->client_data.partition_number =
+			be32_to_cpu(info->partition_number);
+	strncpy(vscsi->client_data.srp_version, info->srp_version,
+		sizeof(vscsi->client_data.srp_version));
+	strncpy(vscsi->client_data.partition_name, info->partition_name,
+		sizeof(vscsi->client_data.partition_name));
+	vscsi->client_data.mad_version = be32_to_cpu(info->mad_version);
+	vscsi->client_data.os_type = be32_to_cpu(info->os_type);
+
+	/* Copy our info */
+	strncpy(info->srp_version, SRP_VERSION,
+		sizeof(info->srp_version));
+	strncpy(info->partition_name, vscsi->dds.partition_name,
+		sizeof(info->partition_name));
+	info->partition_number = cpu_to_be32(vscsi->dds.partition_num);
+	info->mad_version = cpu_to_be32(MAD_VERSION_1);
+	info->os_type = cpu_to_be32(LINUX);
+	memset(&info->port_max_txu[0], 0, sizeof(info->port_max_txu));
+	info->port_max_txu[0] =
+		cpu_to_be32(SCSI_MAX_SG_SEGMENTS * PAGE_SIZE);
+
+	dma_wmb();
+	rc = h_copy_rdma(sizeof(*info), vscsi->dds.window[LOCAL].liobn,
+			 token, vscsi->dds.window[REMOTE].liobn,
+			 be64_to_cpu(mad->buffer));
+	switch (rc) {
+	case H_SUCCESS:
+		break;
+
+	case H_SOURCE_PARM:
+	case H_DEST_PARM:
+	case H_PERMISSION:
+		if (connection_broken(vscsi))
+			flag_bits = (RESPONSE_Q_DOWN | CLIENT_FAILED);
+	default:
+		dev_err(&vscsi->dev, "adapter_info: h_copy_rdma to client failed, rc %ld\n",
+			rc);
+		ibmvscsis_post_disconnect(vscsi,
+					  ERR_DISCONNECT_RECONNECT,
+					  flag_bits);
+		break;
+	}
+
+free_dma:
+	dma_free_coherent(&vscsi->dma_dev->dev, sizeof(*info), info, token);
+	pr_debug("Leaving adapter_info, rc %ld\n", rc);
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_cap_mad() - Service an Capabilities Management Data gram.
+ *
+ * NOTE: if you return an error from this routine you must be
+ * disconnecting or you will cause a hang
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Interrupt called with adapter lock held
+ */
+static int ibmvscsis_cap_mad(struct scsi_info *vscsi, struct iu_entry *iue)
+{
+	struct viosrp_capabilities *mad = &vio_iu(iue)->mad.capabilities;
+	struct capabilities *cap;
+	struct mad_capability_common *common;
+	dma_addr_t token;
+	u16 olen, len, status, min_len, cap_len;
+	u32 flag;
+	uint flag_bits = 0;
+	long rc = 0;
+
+	olen = be16_to_cpu(mad->common.length);
+	/*
+	 * struct capabilities hardcodes a couple capabilities after the
+	 * header, but the capabilities can actually be in any order.
+	 */
+	min_len = offsetof(struct capabilities, migration);
+	if ((olen < min_len) || (olen > PAGE_SIZE)) {
+		pr_warn("cap_mad: invalid len %d\n", olen);
+		mad->common.status = cpu_to_be16(VIOSRP_MAD_FAILED);
+		return 0;
+	}
+
+	cap = dma_alloc_coherent(&vscsi->dma_dev->dev, olen, &token,
+				 GFP_KERNEL);
+	if (!cap) {
+		dev_err(&vscsi->dev, "bad dma_alloc_coherent %p\n",
+			iue->target);
+		mad->common.status = cpu_to_be16(VIOSRP_MAD_FAILED);
+		return 0;
+	}
+	rc = h_copy_rdma(olen, vscsi->dds.window[REMOTE].liobn,
+			 be64_to_cpu(mad->buffer),
+			 vscsi->dds.window[LOCAL].liobn, token);
+	if (rc == H_SUCCESS) {
+		strncpy(cap->name, dev_name(&vscsi->dma_dev->dev),
+			SRP_MAX_LOC_LEN);
+
+		len = olen - min_len;
+		status = VIOSRP_MAD_SUCCESS;
+		common = (struct mad_capability_common *)&cap->migration;
+
+		while ((len > 0) && (status == VIOSRP_MAD_SUCCESS) && !rc) {
+			pr_debug("cap_mad: len left %hd, cap type %d, cap len %hd\n",
+				 len, be32_to_cpu(common->cap_type),
+				 be16_to_cpu(common->length));
+
+			cap_len = be16_to_cpu(common->length);
+			if (cap_len > len) {
+				dev_err(&vscsi->dev, "cap_mad: cap len mismatch with total len\n");
+				status = VIOSRP_MAD_FAILED;
+				break;
+			}
+
+			if (cap_len == 0) {
+				dev_err(&vscsi->dev, "cap_mad: cap len is 0\n");
+				status = VIOSRP_MAD_FAILED;
+				break;
+			}
+
+			switch (common->cap_type) {
+			default:
+				pr_debug("cap_mad: unsupported capability\n");
+				common->server_support = 0;
+				flag = cpu_to_be32((u32)CAP_LIST_SUPPORTED);
+				cap->flags &= ~flag;
+				break;
+			}
+
+			len = len - cap_len;
+			common = (struct mad_capability_common *)
+				((char *)common + cap_len);
+		}
+
+		mad->common.status = cpu_to_be16(status);
+
+		dma_wmb();
+		rc = h_copy_rdma(olen, vscsi->dds.window[LOCAL].liobn, token,
+				 vscsi->dds.window[REMOTE].liobn,
+				 be64_to_cpu(mad->buffer));
+
+		if (rc != H_SUCCESS) {
+			pr_debug("cap_mad: failed to copy to client, rc %ld\n",
+				 rc);
+
+			if (rc == H_PERMISSION) {
+				if (connection_broken(vscsi))
+					flag_bits = (RESPONSE_Q_DOWN |
+						     CLIENT_FAILED);
+			}
+
+			pr_warn("cap_mad: error copying data to client, rc %ld\n",
+				rc);
+			ibmvscsis_post_disconnect(vscsi,
+						  ERR_DISCONNECT_RECONNECT,
+						  flag_bits);
+		}
+	}
+
+	dma_free_coherent(&vscsi->dma_dev->dev, olen, cap, token);
+
+	pr_debug("Leaving cap_mad, rc %ld, client_cap 0x%x\n",
+		 rc, vscsi->client_cap);
+
+	return rc;
+}
+
+static long ibmvscsis_process_mad(struct scsi_info *vscsi, struct iu_entry *iue)
+{
+	struct mad_common *mad = (struct mad_common *)&vio_iu(iue)->mad;
+	struct viosrp_empty_iu *empty;
+	long rc = ADAPT_SUCCESS;
+
+	switch (be32_to_cpu(mad->type)) {
+	case VIOSRP_EMPTY_IU_TYPE:
+		empty = &vio_iu(iue)->mad.empty_iu;
+		vscsi->empty_iu_id = be64_to_cpu(empty->buffer);
+		vscsi->empty_iu_tag = be64_to_cpu(empty->common.tag);
+		mad->status = cpu_to_be16(VIOSRP_MAD_SUCCESS);
+		break;
+	case VIOSRP_ADAPTER_INFO_TYPE:
+		rc = ibmvscsis_adapter_info(vscsi, iue);
+		break;
+	case VIOSRP_CAPABILITIES_TYPE:
+		rc = ibmvscsis_cap_mad(vscsi, iue);
+		break;
+	case VIOSRP_ENABLE_FAST_FAIL:
+		if (vscsi->state == CONNECTED) {
+			vscsi->fast_fail = true;
+			mad->status = cpu_to_be16(VIOSRP_MAD_SUCCESS);
+		} else {
+			pr_warn("fast fail mad sent after login\n");
+			mad->status = cpu_to_be16(VIOSRP_MAD_FAILED);
+		}
+		break;
+	default:
+		mad->status = cpu_to_be16(VIOSRP_MAD_NOT_SUPPORTED);
+		break;
+	}
+
+	return rc;
+}
+
+static void srp_snd_msg_failed(struct scsi_info *vscsi, long rc)
+{
+	ktime_t kt;
+
+	pr_debug("snd_msg_failed: rc %ld\n", rc);
+	if (rc != H_DROPPED) {
+		ibmvscsis_free_cmd_qs(vscsi);
+
+		if (rc == H_CLOSED)
+			vscsi->flags |= CLIENT_FAILED;
+
+		/* don't flag the same problem multiple times */
+		if (!(vscsi->flags & RESPONSE_Q_DOWN)) {
+			vscsi->flags |= RESPONSE_Q_DOWN;
+			if (!(vscsi->state & (ERR_DISCONNECT |
+					      ERR_DISCONNECT_RECONNECT |
+					      ERR_DISCONNECTED | UNDEFINED))) {
+				dev_err(&vscsi->dev, "snd_msg_failed: setting RESPONSE_Q_DOWN, state 0x%hx, flags 0x%x, rc %ld\n",
+					vscsi->state, vscsi->flags, rc);
+			}
+			ibmvscsis_post_disconnect(vscsi,
+						  ERR_DISCONNECT_RECONNECT, 0);
+		}
+	}
+
+	/*
+	 * The response queue is full.
+	 * If the server is processing SRP requests, i.e.
+	 * the client has successfully done an
+	 * SRP_LOGIN, then it will wait forever for room in
+	 * the queue.  However if the system admin
+	 * is attempting to unconfigure the server then one
+	 * or more children will be in a state where
+	 * they are being removed. So if there is even one
+	 * child being removed then the driver assumes
+	 * the system admin is attempting to break the
+	 * connection with the client and MAX_TIMER_POPS
+	 * is honored.
+	 */
+	if ((vscsi->rsp_q_timer.timer_pops < MAX_TIMER_POPS) ||
+	    (vscsi->state == SRP_PROCESSING)) {
+		pr_debug("snd_msg_failed: response queue full, flags 0x%x, timer started %d, pops %d\n",
+			 vscsi->flags, (int)vscsi->rsp_q_timer.started,
+			 vscsi->rsp_q_timer.timer_pops);
+
+		/*
+		 * Check if the timer is running; if it
+		 * is not then start it up.
+		 */
+		if (!vscsi->rsp_q_timer.started) {
+			if (vscsi->rsp_q_timer.timer_pops <
+			    MAX_TIMER_POPS) {
+				kt = ktime_set(0, WAIT_NANO_SECONDS);
+			} else {
+				/*
+				 * slide the timeslice if the maximum
+				 * timer pops have already happened
+				 */
+				kt = ktime_set(WAIT_SECONDS, 0);
+			}
+
+			vscsi->rsp_q_timer.started = true;
+			hrtimer_start(&vscsi->rsp_q_timer.timer, kt,
+				      HRTIMER_MODE_REL);
+		}
+	} else {
+		/*
+		 * TBD: Do we need to worry about this? Need to get
+		 *      remove working.
+		 */
+		/*
+		 * waited a long time and it appears the system admin
+		 * is bring this driver down
+		 */
+		vscsi->flags |= RESPONSE_Q_DOWN;
+		ibmvscsis_free_cmd_qs(vscsi);
+		/*
+		 * if the driver is already attempting to disconnect
+		 * from the client and has already logged an error
+		 * trace this event but don't put it in the error log
+		 */
+		if (!(vscsi->state & (ERR_DISCONNECT |
+				      ERR_DISCONNECT_RECONNECT |
+				      ERR_DISCONNECTED | UNDEFINED))) {
+			dev_err(&vscsi->dev, "client crq full too long\n");
+			ibmvscsis_post_disconnect(vscsi,
+						  ERR_DISCONNECT_RECONNECT,
+						  0);
+		}
+	}
+}
+
+/**
+ * ibmvscsis_send_messages() - Send a Response
+ *
+ * Send a response, first checking the waiting queue. Responses are
+ * sent in order they are received. If the response cannot be sent,
+ * because the client queue is full, it stays on the waiting queue.
+ *
+ * PRECONDITION:
+ *	Called with interrupt lock held
+ */
+static void ibmvscsis_send_messages(struct scsi_info *vscsi)
+{
+	u64 msg_hi = 0;
+	/* note do not attmempt to access the IU_data_ptr with this pointer
+	 * it is not valid
+	 */
+	struct viosrp_crq *crq = (struct viosrp_crq *)&msg_hi;
+	struct ibmvscsis_cmd *cmd, *nxt;
+	struct iu_entry *iue;
+	long rc = ADAPT_SUCCESS;
+
+	if (!(vscsi->flags & RESPONSE_Q_DOWN)) {
+		list_for_each_entry_safe(cmd, nxt, &vscsi->waiting_rsp, list) {
+			pr_debug("send_messages cmd %p\n", cmd);
+
+			iue = cmd->iue;
+
+			crq->valid = VALID_CMD_RESP_EL;
+			crq->format = cmd->rsp.format;
+
+			if (cmd->flags & CMD_FAST_FAIL)
+				crq->status = VIOSRP_ADAPTER_FAIL;
+
+			crq->IU_length = cpu_to_be16(cmd->rsp.len);
+
+			rc = h_send_crq(vscsi->dma_dev->unit_address,
+					be64_to_cpu(msg_hi),
+					be64_to_cpu(cmd->rsp.tag));
+
+			pr_debug("send_messages: tag 0x%llx, rc %ld\n",
+				 be64_to_cpu(cmd->rsp.tag), rc);
+
+			/* if all ok free up the command element resources */
+			if (rc == H_SUCCESS) {
+				/* some movement has occurred */
+				vscsi->rsp_q_timer.timer_pops = 0;
+				list_del(&cmd->list);
+
+				ibmvscsis_free_cmd_resources(vscsi, cmd);
+			} else {
+				srp_snd_msg_failed(vscsi, rc);
+				break;
+			}
+		}
+
+		if (!rc) {
+			/*
+			 * The timer could pop with the queue empty.  If
+			 * this happens, rc will always indicate a
+			 * success; clear the pop count.
+			 */
+			vscsi->rsp_q_timer.timer_pops = 0;
+		}
+	} else {
+		ibmvscsis_free_cmd_qs(vscsi);
+	}
+}
+
+/* Called with intr lock held */
+static void ibmvscsis_send_mad_resp(struct scsi_info *vscsi,
+				    struct ibmvscsis_cmd *cmd,
+				    struct viosrp_crq *crq)
+{
+	struct iu_entry *iue = cmd->iue;
+	struct mad_common *mad = (struct mad_common *)&vio_iu(iue)->mad;
+	uint flag_bits = 0;
+	long rc;
+
+	dma_wmb();
+	rc = h_copy_rdma(sizeof(struct mad_common),
+			 vscsi->dds.window[LOCAL].liobn, iue->sbuf->dma,
+			 vscsi->dds.window[REMOTE].liobn,
+			 be64_to_cpu(crq->IU_data_ptr));
+	if (!rc) {
+		cmd->rsp.format = VIOSRP_MAD_FORMAT;
+		cmd->rsp.len = sizeof(struct mad_common);
+		cmd->rsp.tag = mad->tag;
+		list_add_tail(&cmd->list, &vscsi->waiting_rsp);
+		ibmvscsis_send_messages(vscsi);
+	} else {
+		pr_debug("Error sending mad response, rc %ld\n", rc);
+		if (rc == H_PERMISSION) {
+			if (connection_broken(vscsi))
+				flag_bits = (RESPONSE_Q_DOWN | CLIENT_FAILED);
+		}
+		dev_err(&vscsi->dev, "mad: failed to copy to client, rc %ld\n",
+			rc);
+
+		ibmvscsis_free_cmd_resources(vscsi, cmd);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT,
+					  flag_bits);
+	}
+}
+
+/**
+ * ibmvscsis_mad() - Service a Management Data gram.
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Interrupt  called with adapter lock held
+ */
+static long ibmvscsis_mad(struct scsi_info *vscsi, struct viosrp_crq *crq)
+{
+	struct iu_entry *iue;
+	struct ibmvscsis_cmd *cmd;
+	struct mad_common *mad;
+	long rc = ADAPT_SUCCESS;
+
+	switch (vscsi->state) {
+		/*
+		 * We have not exchanged Init Msgs yet, so this MAD was sent
+		 * before the last Transport Event; client will not be
+		 * expecting a response.
+		 */
+	case WAIT_CONNECTION:
+		pr_debug("mad: in Wait Connection state, ignoring MAD, flags %d\n",
+			 vscsi->flags);
+		return ADAPT_SUCCESS;
+
+	case SRP_PROCESSING:
+	case CONNECTED:
+		break;
+
+		/*
+		 * We should never get here while we're in these states.
+		 * Just log an error and get out.
+		 */
+	case UNCONFIGURING:
+	case WAIT_IDLE:
+	case ERR_DISCONNECT:
+	case ERR_DISCONNECT_RECONNECT:
+	default:
+		dev_err(&vscsi->dev, "mad: invalid adapter state %d for mad\n",
+			vscsi->state);
+		return ADAPT_SUCCESS;
+	}
+
+	cmd = ibmvscsis_get_free_cmd(vscsi);
+	if (!cmd) {
+		dev_err(&vscsi->dev, "mad: failed to get cmd, debit %d\n",
+			vscsi->debit);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+		return ERROR;
+	}
+	iue = cmd->iue;
+	cmd->type = ADAPTER_MAD;
+
+	rc = ibmvscsis_copy_crq_packet(vscsi, cmd, crq);
+	if (!rc) {
+		mad = (struct mad_common *)&vio_iu(iue)->mad;
+
+		pr_debug("mad: type %d\n", be32_to_cpu(mad->type));
+
+		if (be16_to_cpu(mad->length) < 0) {
+			dev_err(&vscsi->dev, "mad: length is < 0\n");
+			ibmvscsis_post_disconnect(vscsi,
+						  ERR_DISCONNECT_RECONNECT, 0);
+			rc = SRP_VIOLATION;
+		} else {
+			rc = ibmvscsis_process_mad(vscsi, iue);
+		}
+
+		pr_debug("mad: status %hd, rc %ld\n", be16_to_cpu(mad->status),
+			 rc);
+
+		if (!rc)
+			ibmvscsis_send_mad_resp(vscsi, cmd, crq);
+	} else {
+		ibmvscsis_free_cmd_resources(vscsi, cmd);
+	}
+
+	pr_debug("Leaving mad, rc %ld\n", rc);
+	return rc;
+}
+
+/**
+ * ibmvscsis_login_rsp() - Create/copy a login response notice to the client
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Interrupt
+ */
+static long ibmvscsis_login_rsp(struct scsi_info *vscsi,
+				struct ibmvscsis_cmd *cmd)
+{
+	struct iu_entry *iue = cmd->iue;
+	struct srp_login_rsp *rsp = &vio_iu(iue)->srp.login_rsp;
+	struct format_code *fmt;
+	uint flag_bits = 0;
+	long rc = ADAPT_SUCCESS;
+
+	memset(rsp, 0, sizeof(struct srp_login_rsp));
+
+	rsp->opcode = SRP_LOGIN_RSP;
+	rsp->req_lim_delta = cpu_to_be32(vscsi->request_limit);
+	rsp->tag = cmd->rsp.tag;
+	rsp->max_it_iu_len = cpu_to_be32(SRP_MAX_IU_LEN);
+	rsp->max_ti_iu_len = cpu_to_be32(SRP_MAX_IU_LEN);
+	fmt = (struct format_code *)&rsp->buf_fmt;
+	fmt->buffers = SUPPORTED_FORMATS;
+	vscsi->credit = 0;
+
+	cmd->rsp.len = sizeof(struct srp_login_rsp);
+
+	dma_wmb();
+	rc = h_copy_rdma(cmd->rsp.len, vscsi->dds.window[LOCAL].liobn,
+			 iue->sbuf->dma, vscsi->dds.window[REMOTE].liobn,
+			 be64_to_cpu(iue->remote_token));
+
+	switch (rc) {
+	case H_SUCCESS:
+		break;
+
+	case H_PERMISSION:
+		if (connection_broken(vscsi))
+			flag_bits = RESPONSE_Q_DOWN | CLIENT_FAILED;
+		dev_err(&vscsi->dev, "login_rsp: error copying to client, rc %ld\n",
+			rc);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT,
+					  flag_bits);
+		break;
+	case H_SOURCE_PARM:
+	case H_DEST_PARM:
+	default:
+		dev_err(&vscsi->dev, "login_rsp: error copying to client, rc %ld\n",
+			rc);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+		break;
+	}
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_srp_login_rej() - Create/copy a login rejection notice to client
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Interrupt
+ */
+static long ibmvscsis_srp_login_rej(struct scsi_info *vscsi,
+				    struct ibmvscsis_cmd *cmd, u32 reason)
+{
+	struct iu_entry *iue = cmd->iue;
+	struct srp_login_rej *rej = &vio_iu(iue)->srp.login_rej;
+	struct format_code *fmt;
+	uint flag_bits = 0;
+	long rc = ADAPT_SUCCESS;
+
+	memset(rej, 0, sizeof(*rej));
+
+	rej->opcode = SRP_LOGIN_REJ;
+	rej->reason = cpu_to_be32(reason);
+	rej->tag = cmd->rsp.tag;
+	fmt = (struct format_code *)&rej->buf_fmt;
+	fmt->buffers = SUPPORTED_FORMATS;
+
+	cmd->rsp.len = sizeof(*rej);
+
+	dma_wmb();
+	rc = h_copy_rdma(cmd->rsp.len, vscsi->dds.window[LOCAL].liobn,
+			 iue->sbuf->dma, vscsi->dds.window[REMOTE].liobn,
+			 be64_to_cpu(iue->remote_token));
+
+	switch (rc) {
+	case H_SUCCESS:
+		break;
+	case H_PERMISSION:
+		if (connection_broken(vscsi))
+			flag_bits =  RESPONSE_Q_DOWN | CLIENT_FAILED;
+		dev_err(&vscsi->dev, "login_rej: error copying to client, rc %ld\n",
+			rc);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT,
+					  flag_bits);
+		break;
+	case H_SOURCE_PARM:
+	case H_DEST_PARM:
+	default:
+		dev_err(&vscsi->dev, "login_rej: error copying to client, rc %ld\n",
+			rc);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+		break;
+	}
+
+	return rc;
+}
+
+/*TODO: Change calls in this function to target_alloc_session() */
+static int ibmvscsis_make_nexus(struct ibmvscsis_tport *tport)
+{
+	char *name = tport->tport_name;
+	struct ibmvscsis_nexus *nexus;
+	int rc;
+
+	pr_debug("make nexus\n");
+	if (tport->ibmv_nexus) {
+		pr_debug("tport->ibmv_nexus already exists\n");
+		return 0;
+	}
+
+	nexus = kzalloc(sizeof(struct ibmvscsis_nexus), GFP_KERNEL);
+	if (!nexus) {
+		pr_err("Unable to allocate struct ibmvscsis_nexus\n");
+		return -ENOMEM;
+	}
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4, 5, 7)
+	/*
+	 * Initialize the struct se_session pointer and setup tagpool
+	 * for struct ibmvscsis_cmd descriptors
+	 */
+	nexus->se_sess = transport_init_session(TARGET_PROT_NORMAL);
+	if (IS_ERR(nexus->se_sess))
+		goto transport_init_fail;
+
+	/* Since we are running in 'demo mode' this call will generate a
+	 * struct se_node_acl for the ibmvscsis struct se_portal_group with
+	 * the SCSI Initiator port name of the passed configfs group 'name'.
+	 */
+	nexus->se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
+							&tport->se_tpg,
+							(unsigned char *)name);
+	if (!nexus->se_sess->se_node_acl) {
+		pr_debug("core_tpg_check_initiaitor_node_acl() failed for %s\n",
+			 name);
+		goto transport_init_fail;
+	}
+
+	/*
+	 * Now register the TCM ibmvscsis virtual I_T Nexus as active.
+	 */
+	transport_register_session(&tport->se_tpg, nexus->se_sess->se_node_acl,
+				   nexus->se_sess, nexus);
+#endif
+	nexus->se_sess = target_alloc_session(&tport->se_tpg, 0, 0,
+					      TARGET_PROT_NORMAL, name, nexus,
+					      NULL);
+	if (IS_ERR(nexus->se_sess)) {
+		rc = PTR_ERR(nexus->se_sess);
+		goto transport_init_fail;
+	}
+
+	tport->ibmv_nexus = nexus;
+
+	return 0;
+
+transport_init_fail:
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4, 5, 7)
+	transport_free_session(nexus->se_sess);
+	kfree(nexus);
+	return -ENOMEM;
+#endif
+	kfree(nexus);
+	return rc;
+}
+
+static int ibmvscsis_drop_nexus(struct ibmvscsis_tport *tport)
+{
+	struct se_session *se_sess;
+	struct ibmvscsis_nexus *nexus;
+
+	pr_debug("drop nexus\n");
+
+	nexus = tport->ibmv_nexus;
+	if (!nexus)
+		return -ENODEV;
+
+	se_sess = nexus->se_sess;
+	if (!se_sess)
+		return -ENODEV;
+
+	/*
+	 * Release the SCSI I_T Nexus to the emulated ibmvscsis Target Port
+	 */
+	transport_deregister_session(nexus->se_sess);
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4, 5, 7)
+	transport_free_session(nexus->se_sess);
+#endif
+	tport->ibmv_nexus = NULL;
+	kfree(nexus);
+
+	return 0;
+}
+
+/**
+ * ibmvscsis_srp_login() - Process an SRP Login Request.
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Interrupt, called with interrupt lock held
+ */
+static long ibmvscsis_srp_login(struct scsi_info *vscsi,
+				struct ibmvscsis_cmd *cmd,
+				struct viosrp_crq *crq)
+{
+	struct iu_entry *iue = cmd->iue;
+	struct srp_login_req *req = &vio_iu(iue)->srp.login_req;
+	struct port_id {
+		__be64 id_extension;
+		__be64 io_guid;
+	} *iport, *tport;
+	struct format_code *fmt;
+	u32 reason = 0x0;
+	long rc = ADAPT_SUCCESS;
+
+	iport = (struct port_id *)req->initiator_port_id;
+	tport = (struct port_id *)req->target_port_id;
+	fmt = (struct format_code *)&req->req_buf_fmt;
+	if (be32_to_cpu(req->req_it_iu_len) > SRP_MAX_IU_LEN)
+		reason = SRP_LOGIN_REJ_REQ_IT_IU_LENGTH_TOO_LARGE;
+	else if (be32_to_cpu(req->req_it_iu_len) < 64)
+		reason = SRP_LOGIN_REJ_UNABLE_ESTABLISH_CHANNEL;
+	else if ((be64_to_cpu(iport->id_extension) > (MAX_NUM_PORTS - 1)) ||
+		 (be64_to_cpu(tport->id_extension) > (MAX_NUM_PORTS - 1)))
+		reason = SRP_LOGIN_REJ_UNABLE_ASSOCIATE_CHANNEL;
+	else if (req->req_flags & SRP_MULTICHAN_MULTI)
+		reason = SRP_LOGIN_REJ_MULTI_CHANNEL_UNSUPPORTED;
+	else if (fmt->buffers & (~SUPPORTED_FORMATS))
+		reason = SRP_LOGIN_REJ_UNSUPPORTED_DESCRIPTOR_FMT;
+	else if ((fmt->buffers | SUPPORTED_FORMATS) == 0)
+		reason = SRP_LOGIN_REJ_UNSUPPORTED_DESCRIPTOR_FMT;
+
+	if (vscsi->state == SRP_PROCESSING)
+		reason = SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED;
+
+	rc = ibmvscsis_make_nexus(&vscsi->tport);
+	if (rc)
+		reason = SRP_LOGIN_REJ_UNABLE_ESTABLISH_CHANNEL;
+
+	cmd->rsp.format = VIOSRP_SRP_FORMAT;
+	cmd->rsp.tag = req->tag;
+
+	pr_debug("srp_login: reason 0x%x\n", reason);
+
+	if (reason)
+		rc = ibmvscsis_srp_login_rej(vscsi, cmd, reason);
+	else
+		rc = ibmvscsis_login_rsp(vscsi, cmd);
+
+	if (!rc) {
+		if (!reason)
+			vscsi->state = SRP_PROCESSING;
+
+		list_add_tail(&cmd->list, &vscsi->waiting_rsp);
+		ibmvscsis_send_messages(vscsi);
+	} else {
+		ibmvscsis_free_cmd_resources(vscsi, cmd);
+	}
+
+	pr_debug("Leaving srp_login, rc %ld\n", rc);
+	return rc;
+}
+
+/**
+ * ibmvscsis_srp_i_logout() - Helper Function to close I_T Nexus
+ *
+ * Do the logic to close the I_T nexus.  This function may not
+ * behave to specification.
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Interrupt
+ */
+static long ibmvscsis_srp_i_logout(struct scsi_info *vscsi,
+				   struct ibmvscsis_cmd *cmd,
+				   struct viosrp_crq *crq)
+{
+	struct iu_entry *iue = cmd->iue;
+	struct srp_i_logout *log_out = &vio_iu(iue)->srp.i_logout;
+	long rc = ADAPT_SUCCESS;
+
+	if ((vscsi->debit > 0) || !list_empty(&vscsi->schedule_q) ||
+	    !list_empty(&vscsi->waiting_rsp)) {
+		dev_err(&vscsi->dev, "i_logout: outstanding work\n");
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT, 0);
+	} else {
+		cmd->rsp.format = SRP_FORMAT;
+		cmd->rsp.tag = log_out->tag;
+		cmd->rsp.len = sizeof(struct mad_common);
+		list_add_tail(&cmd->list, &vscsi->waiting_rsp);
+		ibmvscsis_send_messages(vscsi);
+
+		ibmvscsis_post_disconnect(vscsi, WAIT_IDLE, 0);
+	}
+
+	return rc;
+}
+
+/* Called with intr lock held */
+static void ibmvscsis_srp_cmd(struct scsi_info *vscsi, struct viosrp_crq *crq)
+{
+	struct ibmvscsis_cmd *cmd;
+	struct iu_entry *iue;
+	struct srp_cmd *srp;
+	struct srp_tsk_mgmt *tsk;
+	long rc;
+
+	if (vscsi->request_limit - vscsi->debit <= 0) {
+		/* Client has exceeded request limit */
+		dev_err(&vscsi->dev, "Client exceeded the request limit (%d), debit %d\n",
+			vscsi->request_limit, vscsi->debit);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+		return;
+	}
+
+	cmd = ibmvscsis_get_free_cmd(vscsi);
+	if (!cmd) {
+		dev_err(&vscsi->dev, "srp_cmd failed to get cmd, debit %d\n",
+			vscsi->debit);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+		return;
+	}
+	iue = cmd->iue;
+	srp = &vio_iu(iue)->srp.cmd;
+
+	rc = ibmvscsis_copy_crq_packet(vscsi, cmd, crq);
+	if (rc) {
+		ibmvscsis_free_cmd_resources(vscsi, cmd);
+		return;
+	}
+
+	if (vscsi->state == SRP_PROCESSING) {
+		switch (srp->opcode) {
+		case SRP_LOGIN_REQ:
+			rc = ibmvscsis_srp_login(vscsi, cmd, crq);
+			break;
+
+		case SRP_TSK_MGMT:
+			tsk = &vio_iu(iue)->srp.tsk_mgmt;
+			pr_debug("tsk_mgmt tag: %llu (0x%llx)\n", tsk->tag,
+				 tsk->tag);
+			cmd->rsp.tag = tsk->tag;
+			vscsi->debit += 1;
+			cmd->type = TASK_MANAGEMENT;
+			list_add_tail(&cmd->list, &vscsi->schedule_q);
+			queue_work(vscsi->work_q, &cmd->work);
+			break;
+
+		case SRP_CMD:
+			pr_debug("srp_cmd tag: %llu (0x%llx)\n", srp->tag,
+				 srp->tag);
+			cmd->rsp.tag = srp->tag;
+			vscsi->debit += 1;
+			cmd->type = SCSI_CDB;
+			/*
+			 * We want to keep track of work waiting for
+			 * the workqueue.
+			 */
+			list_add_tail(&cmd->list, &vscsi->schedule_q);
+			queue_work(vscsi->work_q, &cmd->work);
+			break;
+
+		case SRP_I_LOGOUT:
+			rc = ibmvscsis_srp_i_logout(vscsi, cmd, crq);
+			break;
+
+		case SRP_CRED_RSP:
+		case SRP_AER_RSP:
+		default:
+			ibmvscsis_free_cmd_resources(vscsi, cmd);
+			dev_err(&vscsi->dev, "invalid srp cmd, opcode %d\n",
+				(uint)srp->opcode);
+			ibmvscsis_post_disconnect(vscsi,
+						  ERR_DISCONNECT_RECONNECT, 0);
+			break;
+		}
+	} else if (srp->opcode == SRP_LOGIN_REQ && vscsi->state == CONNECTED) {
+		rc = ibmvscsis_srp_login(vscsi, cmd, crq);
+	} else {
+		ibmvscsis_free_cmd_resources(vscsi, cmd);
+		dev_err(&vscsi->dev, "Invalid state %d to handle srp cmd\n",
+			vscsi->state);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+	}
+}
+
+static long ibmvscsis_ping_response(struct scsi_info *vscsi)
+{
+	struct viosrp_crq *crq;
+	u64 buffer[2] = { 0, 0 };
+	long rc;
+
+	crq = (struct viosrp_crq *)&buffer;
+	crq->valid = VALID_CMD_RESP_EL;
+	crq->format = (u8)MESSAGE_IN_CRQ;
+	crq->status = PING_RESPONSE;
+
+	pr_debug("Sending ping response\n");
+
+	rc = h_send_crq(vscsi->dds.unit_id, cpu_to_be64(buffer[MSG_HI]),
+			cpu_to_be64(buffer[MSG_LOW]));
+
+	pr_debug("Ping response sent\n");
+
+	switch (rc) {
+	case H_SUCCESS:
+		break;
+	case H_CLOSED:
+		vscsi->flags |= CLIENT_FAILED;
+	case H_DROPPED:
+		vscsi->flags |= RESPONSE_Q_DOWN;
+	case H_REMOTE_PARM:
+		dev_err(&vscsi->dev, "ping_response: h_send_crq failed, rc %ld\n",
+			rc);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+		break;
+	default:
+		dev_err(&vscsi->dev, "ping_response: h_send_crq returned unknown rc %ld\n",
+			rc);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT, 0);
+		break;
+	}
+
+	return rc;
+}
+
+static long ibmvscsis_handle_init_compl_msg(struct scsi_info *vscsi)
+{
+	long rc = ADAPT_SUCCESS;
+
+	pr_debug("handle_init_compl_msg\n");
+	switch (vscsi->state) {
+	case NO_QUEUE:
+	case ERR_DISCONNECT:
+	case ERR_DISCONNECT_RECONNECT:
+	case ERR_DISCONNECTED:
+	case UNCONFIGURING:
+	case UNDEFINED:
+		rc = ERROR;
+		break;
+
+	case WAIT_CONNECTION:
+		vscsi->state = CONNECTED;
+		break;
+
+	case WAIT_IDLE:
+	case SRP_PROCESSING:
+	case CONNECTED:
+	case WAIT_ENABLED:
+	case PART_UP_WAIT_ENAB:
+	default:
+		rc = ERROR;
+		dev_err(&vscsi->dev, "init_msg: invalid state %d to get init compl msg\n",
+			vscsi->state);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+		break;
+	}
+
+	return rc;
+}
+
+static long ibmvscsis_handle_init_msg(struct scsi_info *vscsi)
+{
+	long rc = ADAPT_SUCCESS;
+
+	pr_debug("handle_init_msg\n");
+	switch (vscsi->state) {
+	case WAIT_ENABLED:
+		vscsi->state = PART_UP_WAIT_ENAB;
+		break;
+
+	case WAIT_CONNECTION:
+		rc = ibmvscsis_send_init_message(vscsi, INIT_COMPLETE_MSG);
+		switch (rc) {
+		case H_SUCCESS:
+			vscsi->state = CONNECTED;
+			break;
+
+		case H_PARAMETER:
+			dev_err(&vscsi->dev, "init_msg: failed to send, rc %ld\n",
+				rc);
+			ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT, 0);
+			break;
+
+		case H_DROPPED:
+			dev_err(&vscsi->dev, "init_msg: failed to send, rc %ld\n",
+				rc);
+			rc = ERROR;
+			ibmvscsis_post_disconnect(vscsi,
+						  ERR_DISCONNECT_RECONNECT, 0);
+			break;
+
+		case H_CLOSED:
+			pr_warn("init_msg: failed to send, rc %ld\n", rc);
+			rc = 0;
+			break;
+		}
+		break;
+
+	case UNDEFINED:
+		rc = ERROR;
+		break;
+
+	case UNCONFIGURING:
+		break;
+
+	case PART_UP_WAIT_ENAB:
+	case CONNECTED:
+	case SRP_PROCESSING:
+	case WAIT_IDLE:
+	case NO_QUEUE:
+	case ERR_DISCONNECT:
+	case ERR_DISCONNECT_RECONNECT:
+	case ERR_DISCONNECTED:
+	default:
+		rc = ERROR;
+		dev_err(&vscsi->dev, "init_msg: invalid state %d to get init msg\n",
+			vscsi->state);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+		break;
+	}
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_init_msg() - Helper Function initialize and initialization complete
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Interrupt
+ */
+static long ibmvscsis_init_msg(struct scsi_info *vscsi, struct viosrp_crq *crq)
+{
+	long rc = ADAPT_SUCCESS;
+
+	pr_debug("init_msg: state 0x%hx\n", vscsi->state);
+
+	rc = h_vioctl(vscsi->dds.unit_id, H_GET_PARTNER_INFO,
+		      (u64)vscsi->map_ioba | ((u64)PAGE_SIZE << 32), 0, 0, 0,
+		      0);
+	if (rc == H_SUCCESS) {
+		vscsi->client_data.partition_number =
+			be64_to_cpu(*(u64 *)vscsi->map_buf);
+		pr_debug("init_msg, part num %d\n",
+			 vscsi->client_data.partition_number);
+	} else {
+		pr_debug("init_msg h_vioctl rc %ld\n", rc);
+		rc = ADAPT_SUCCESS;
+	}
+
+	if (crq->format == INIT_MSG) {
+		rc = ibmvscsis_handle_init_msg(vscsi);
+	} else if (crq->format == INIT_COMPLETE_MSG) {
+		rc = ibmvscsis_handle_init_compl_msg(vscsi);
+	} else {
+		rc = ERROR;
+		dev_err(&vscsi->dev, "init_msg: invalid format %d\n",
+			(uint)crq->format);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+	}
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_parse_command() - Parse an element taken from the cmd rsp queue.
+ *
+ * Return success if the command queue element is valid, and the srp iu,
+ * or MAD request it pointed to was also valid.  That does not mean that
+ * an error was not returned to the client.
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Interrupt, intr lock held
+ */
+static long ibmvscsis_parse_command(struct scsi_info *vscsi,
+				    struct viosrp_crq *crq)
+{
+	long rc = ADAPT_SUCCESS;
+
+	switch (crq->valid) {
+	case VALID_CMD_RESP_EL:
+		switch (crq->format) {
+		case OS400_FORMAT:
+		case AIX_FORMAT:
+		case LINUX_FORMAT:
+		case MAD_FORMAT:
+			if (vscsi->flags & PROCESSING_MAD) {
+				rc = ERROR;
+				dev_err(&vscsi->dev, "parse_command: already processing mad\n");
+				ibmvscsis_post_disconnect(vscsi,
+						       ERR_DISCONNECT_RECONNECT,
+						       0);
+			} else {
+				vscsi->flags |= PROCESSING_MAD;
+				rc = ibmvscsis_mad(vscsi, crq);
+			}
+			break;
+
+		case SRP_FORMAT:
+			ibmvscsis_srp_cmd(vscsi, crq);
+			break;
+
+		case MESSAGE_IN_CRQ:
+			if (crq->status == PING)
+				ibmvscsis_ping_response(vscsi);
+			break;
+
+		default:
+			dev_err(&vscsi->dev, "parse_command: invalid format %d\n",
+			       (uint)crq->format);
+			ibmvscsis_post_disconnect(vscsi,
+						  ERR_DISCONNECT_RECONNECT, 0);
+			break;
+		}
+		break;
+
+	case VALID_TRANS_EVENT:
+		rc =  ibmvscsis_trans_event(vscsi, crq);
+		break;
+
+	case VALID_INIT_MSG:
+		rc = ibmvscsis_init_msg(vscsi, crq);
+		break;
+
+	default:
+		dev_err(&vscsi->dev, "parse_command: invalid valid field %d\n",
+			(uint)crq->valid);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+		break;
+	}
+
+	/*
+	 * Return only what the interrupt handler cares
+	 * about. Most errors we keep right on trucking.
+	 */
+	rc = vscsi->flags & SCHEDULE_DISCONNECT;
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_modify_rep_luns() - Modify Report Luns
+ *
+ * Some vscsi clients do not handle an LUA of 0 (they ignore it), so in
+ * order to work around this, we will essentially change all the LUAs to
+ * use the Flat space addressing method, which basically means setting
+ * the uppermost two bits to 01b.  This will allow us to still be
+ * compliant with the SCSI specification, but no LUA we return will be
+ * all 0s.  Note that ibmvscsis_unpack_lun will and off the address
+ * method bits.
+ */
+static void ibmvscsis_modify_rep_luns(struct se_cmd *se_cmd)
+{
+	u16 data_len;
+	s32 len = se_cmd->data_length;
+	unsigned char *buf = NULL;
+
+	if (len <= 8)
+		return;
+
+	len -= 8;
+	buf = transport_kmap_data_sg(se_cmd);
+	if (buf) {
+		data_len = be32_to_cpu(*(u32 *)buf);
+		pr_debug("modify_rep_luns: len %d data_len %hud\n", len,
+			 data_len);
+		if (data_len < len)
+			len = data_len;
+		buf += 8;
+		while (len > 0) {
+			*buf |= SCSI_LUN_ADDR_METHOD_FLAT << 6;
+			len -= 8;
+			buf += 8;
+		}
+		transport_kunmap_data_sg(se_cmd);
+	}
+}
+
+/**
+ * ibmvscsis_modify_std_inquiry() - Modify STD Inquiry
+ *
+ * This function modifies the inquiry data prior to sending to initiator
+ * so that we can support current AIX. Internally we are going to
+ * add new ODM entries to support the emulation from LIO. This function
+ * is temporary until those changes are done.
+ */
+static void ibmvscsis_modify_std_inquiry(struct se_cmd *se_cmd)
+{
+	struct se_device *dev = se_cmd->se_dev;
+	u32 cmd_len = se_cmd->data_length;
+	u32 repl_len;
+	unsigned char *buf = NULL;
+
+	if (cmd_len <= 8)
+		return;
+
+	buf = transport_kmap_data_sg(se_cmd);
+	if (buf) {
+		repl_len = 8;
+		if (cmd_len - 8 < repl_len)
+			repl_len = cmd_len - 8;
+		memcpy(&buf[8], "IBM     ", repl_len);
+
+		if (cmd_len > 16) {
+			repl_len = 16;
+			if (cmd_len - 16 < repl_len)
+				repl_len = cmd_len - 16;
+			if (dev->transport->get_device_type(dev) == TYPE_ROM)
+				memcpy(&buf[16], "VOPTA           ", repl_len);
+			else
+				memcpy(&buf[16], "3303      NVDISK", repl_len);
+		}
+		if (cmd_len > 32) {
+			repl_len = 4;
+			if (cmd_len - 32 < repl_len)
+				repl_len = cmd_len - 32;
+			memcpy(&buf[32], "0001", repl_len);
+		}
+		transport_kunmap_data_sg(se_cmd);
+	}
+}
+
+static int read_dma_window(struct scsi_info *vscsi)
+{
+	struct vio_dev *vdev = vscsi->dma_dev;
+	const __be32 *dma_window;
+	const __be32 *prop;
+
+	/* TODO Using of_parse_dma_window would be better, but it doesn't give
+	 * a way to read multiple windows without already knowing the size of
+	 * a window or the number of windows.
+	 */
+	dma_window = (const __be32 *)vio_get_attribute(vdev,
+						       "ibm,my-dma-window",
+						       NULL);
+	if (!dma_window) {
+		pr_err("Couldn't find ibm,my-dma-window property\n");
+		return -1;
+	}
+
+	vscsi->dds.window[LOCAL].liobn = be32_to_cpu(*dma_window);
+	dma_window++;
+
+	prop = (const __be32 *)vio_get_attribute(vdev, "ibm,#dma-address-cells",
+						 NULL);
+	if (!prop) {
+		pr_warn("Couldn't find ibm,#dma-address-cells property\n");
+		dma_window++;
+	} else {
+		dma_window += be32_to_cpu(*prop);
+	}
+
+	prop = (const __be32 *)vio_get_attribute(vdev, "ibm,#dma-size-cells",
+						 NULL);
+	if (!prop) {
+		pr_warn("Couldn't find ibm,#dma-size-cells property\n");
+		dma_window++;
+	} else {
+		dma_window += be32_to_cpu(*prop);
+	}
+
+	/* dma_window should point to the second window now */
+	vscsi->dds.window[REMOTE].liobn = be32_to_cpu(*dma_window);
+
+	return 0;
+}
+
+static struct ibmvscsis_tport *ibmvscsis_lookup_port(const char *name)
+{
+	struct ibmvscsis_tport *tport = NULL;
+	struct vio_dev *vdev;
+	struct scsi_info *vscsi;
+
+	spin_lock_bh(&ibmvscsis_dev_lock);
+	list_for_each_entry(vscsi, &ibmvscsis_dev_list, list) {
+		vdev = vscsi->dma_dev;
+		if (!strcmp(dev_name(&vdev->dev), name)) {
+			tport = &vscsi->tport;
+			break;
+		}
+	}
+	spin_unlock_bh(&ibmvscsis_dev_lock);
+
+	return tport;
+}
+
+static u64 ibmvscsis_unpack_lun(const u8 *lun, int len)
+{
+	int addressing_method;
+	u64 res = NO_SUCH_LUN;
+
+	if (unlikely(len < 2)) {
+		pr_err("Illegal LUN length %d, expected 2 bytes or more\n",
+		       len);
+		goto out;
+	}
+
+	switch (len) {
+	case 8:
+		if ((*((__be64 *)lun) & cpu_to_be64(0x0000FFFFFFFFFFFFLL)) != 0)
+			goto out_err;
+		break;
+	case 4:
+		if (*((__be16 *)&lun[2]) != 0)
+			goto out_err;
+		break;
+	case 6:
+		if (*((__be32 *)&lun[2]) != 0)
+			goto out_err;
+		break;
+	case 2:
+		break;
+	default:
+		goto out_err;
+	}
+
+	addressing_method = (*lun) >> 6; /* highest two bits of byte 0 */
+	switch (addressing_method) {
+	case SCSI_LUN_ADDR_METHOD_PERIPHERAL:
+	case SCSI_LUN_ADDR_METHOD_FLAT:
+	case SCSI_LUN_ADDR_METHOD_LUN:
+		res = *(lun + 1) | (((*lun) & 0x3f) << 8);
+		break;
+
+	case SCSI_LUN_ADDR_METHOD_EXTENDED_LUN:
+	default:
+		pr_debug("Unimplemented LUN addressing method %u\n",
+			 addressing_method);
+		break;
+	}
+
+out:
+	return res;
+out_err:
+	pr_debug("Support for multi-level LUNs has not yet been implemented\n");
+	goto out;
+}
+
+/**
+ * ibmvscsis_parse_cmd() - Parse SRP Command
+ *
+ * Parse the srp command; if it is valid then submit it to tcm.
+ * Note: The return code does not reflect the status of the SCSI CDB.
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Process level
+ */
+static void ibmvscsis_parse_cmd(struct scsi_info *vscsi,
+				struct ibmvscsis_cmd *cmd)
+{
+	struct iu_entry *iue = cmd->iue;
+	struct srp_cmd *srp = (struct srp_cmd *)iue->sbuf->buf;
+	struct ibmvscsis_nexus *nexus;
+	u64 data_len;
+	enum dma_data_direction dir;
+	u64 unpacked_lun = 0;
+	int attr = 0;
+	int rc = 0;
+
+	nexus = vscsi->tport.ibmv_nexus;
+	/*
+	 * additional length in bytes.  Note that the SRP spec says that
+	 * additional length is in 4-byte words, but technically the
+	 * additional length field is only the upper 6 bits of the byte.
+	 * The lower 2 bits are reserved.  If the lower 2 bits are 0 (as
+	 * all reserved fields should be), then interpreting the byte as
+	 * an int will yield the length in bytes.
+	 */
+	if (srp->add_cdb_len & 0x03) {
+		dev_err(&vscsi->dev, "parse_cmd: reserved bits set in IU\n");
+		spin_lock_bh(&vscsi->intr_lock);
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+		ibmvscsis_free_cmd_resources(vscsi, cmd);
+		spin_unlock_bh(&vscsi->intr_lock);
+		return;
+	}
+
+	if (srp_get_desc_table(srp, &dir, &data_len)) {
+		dev_err(&vscsi->dev, "0x%llx: parsing SRP descriptor table failed.\n",
+			srp->tag);
+		goto fail;
+		return;
+	}
+
+	cmd->rsp.sol_not = srp->sol_not;
+
+	unpacked_lun = ibmvscsis_unpack_lun((u8 *)&srp->lun, sizeof(srp->lun));
+
+	switch (srp->task_attr) {
+	case SRP_SIMPLE_TASK:
+		attr = TCM_SIMPLE_TAG;
+		break;
+	case SRP_ORDERED_TASK:
+		attr = TCM_ORDERED_TAG;
+		break;
+	case SRP_HEAD_TASK:
+		attr = TCM_HEAD_TAG;
+		break;
+	case SRP_ACA_TASK:
+		attr = TCM_ACA_TAG;
+		break;
+	default:
+		dev_err(&vscsi->dev, "Invalid task attribute %d\n",
+			srp->task_attr);
+		goto fail;
+	}
+
+	cmd->se_cmd.tag = be64_to_cpu(srp->tag);
+
+	spin_lock_bh(&vscsi->intr_lock);
+	list_add_tail(&cmd->list, &vscsi->active_q);
+	spin_unlock_bh(&vscsi->intr_lock);
+
+	pr_debug("calling submit_cmd, se_cmd %p, lun 0x%llx, cdb 0x%x, attr:%d\n",
+		 &cmd->se_cmd, unpacked_lun, (int)srp->cdb[0], attr);
+
+	rc = target_submit_cmd(&cmd->se_cmd, nexus->se_sess, srp->cdb,
+			       cmd->sense_buf, unpacked_lun, data_len, attr,
+			       dir, 0);
+	if (rc) {
+		dev_err(&vscsi->dev, "target_submit_cmd failed, rc %d\n", rc);
+		goto fail;
+	}
+	return;
+
+fail:
+	spin_lock_bh(&vscsi->intr_lock);
+	ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+	spin_unlock_bh(&vscsi->intr_lock);
+}
+
+/**
+ * ibmvscsis_parse_task() - Parse SRP Task Management Request
+ *
+ * Parse the srp task management request; if it is valid then submit it to tcm.
+ * Note: The return code does not reflect the status of the task management
+ * request.
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Processor level
+ */
+static void ibmvscsis_parse_task(struct scsi_info *vscsi,
+				 struct ibmvscsis_cmd *cmd)
+{
+	struct iu_entry *iue = cmd->iue;
+	struct srp_tsk_mgmt *srp_tsk = &vio_iu(iue)->srp.tsk_mgmt;
+	u64 unpacked_lun = 0;
+	int tcm_type;
+	u64 tag_to_abort = 0;
+	int rc = 0;
+	struct ibmvscsis_nexus *nexus;
+
+	nexus = vscsi->tport.ibmv_nexus;
+
+	cmd->rsp.sol_not = srp_tsk->sol_not;
+
+	unpacked_lun = ibmvscsis_unpack_lun((u8 *)&srp_tsk->lun,
+					    sizeof(srp_tsk->lun));
+
+	switch (srp_tsk->tsk_mgmt_func) {
+	case SRP_TSK_ABORT_TASK:
+		tcm_type = TMR_ABORT_TASK;
+		tag_to_abort = be64_to_cpu(srp_tsk->task_tag);
+		break;
+	case SRP_TSK_ABORT_TASK_SET:
+		tcm_type = TMR_ABORT_TASK_SET;
+		break;
+	case SRP_TSK_CLEAR_TASK_SET:
+		tcm_type = TMR_CLEAR_TASK_SET;
+		break;
+	case SRP_TSK_LUN_RESET:
+		tcm_type = TMR_LUN_RESET;
+		break;
+	case SRP_TSK_CLEAR_ACA:
+		tcm_type = TMR_CLEAR_ACA;
+		break;
+	default:
+		dev_err(&vscsi->dev, "unknown task mgmt func %d\n",
+			srp_tsk->tsk_mgmt_func);
+		cmd->se_cmd.se_tmr_req->response =
+			TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
+		rc = -1;
+		break;
+	}
+
+	if (!rc) {
+		cmd->se_cmd.tag = be64_to_cpu(srp_tsk->tag);
+
+		spin_lock_bh(&vscsi->intr_lock);
+		list_add_tail(&cmd->list, &vscsi->active_q);
+		spin_unlock_bh(&vscsi->intr_lock);
+
+		pr_debug("calling submit_tmr, func %d\n",
+			 srp_tsk->tsk_mgmt_func);
+		rc = target_submit_tmr(&cmd->se_cmd, nexus->se_sess, NULL,
+				       unpacked_lun, srp_tsk, tcm_type,
+				       GFP_KERNEL, tag_to_abort, 0);
+		if (rc) {
+			dev_err(&vscsi->dev, "target_submit_tmr failed, rc %d\n",
+				rc);
+			cmd->se_cmd.se_tmr_req->response =
+				TMR_FUNCTION_REJECTED;
+		}
+	}
+
+	if (rc)
+		transport_send_check_condition_and_sense(&cmd->se_cmd, 0, 0);
+}
+
+static void ibmvscsis_scheduler(struct work_struct *work)
+{
+	struct ibmvscsis_cmd *cmd = container_of(work, struct ibmvscsis_cmd,
+						 work);
+	struct scsi_info *vscsi = cmd->adapter;
+
+	spin_lock_bh(&vscsi->intr_lock);
+
+	/* Remove from schedule_q */
+	list_del(&cmd->list);
+
+	/* Don't submit cmd if we're disconnecting */
+	if (vscsi->flags & (SCHEDULE_DISCONNECT | DISCONNECT_SCHEDULED)) {
+		ibmvscsis_free_cmd_resources(vscsi, cmd);
+
+		/* ibmvscsis_disconnect might be waiting for us */
+		if (list_empty(&vscsi->active_q) &&
+		    list_empty(&vscsi->schedule_q) &&
+		    (vscsi->flags & WAIT_FOR_IDLE)) {
+			vscsi->flags &= ~WAIT_FOR_IDLE;
+			complete(&vscsi->wait_idle);
+		}
+
+		spin_unlock_bh(&vscsi->intr_lock);
+		return;
+	}
+
+	spin_unlock_bh(&vscsi->intr_lock);
+
+	switch (cmd->type) {
+	case SCSI_CDB:
+		ibmvscsis_parse_cmd(vscsi, cmd);
+		break;
+	case TASK_MANAGEMENT:
+		ibmvscsis_parse_task(vscsi, cmd);
+		break;
+	default:
+		dev_err(&vscsi->dev, "scheduler, invalid cmd type %d\n",
+			cmd->type);
+		spin_lock_bh(&vscsi->intr_lock);
+		ibmvscsis_free_cmd_resources(vscsi, cmd);
+		spin_unlock_bh(&vscsi->intr_lock);
+		break;
+	}
+}
+
+static int ibmvscsis_alloc_cmds(struct scsi_info *vscsi, int num)
+{
+	struct ibmvscsis_cmd *cmd;
+	int i;
+
+	INIT_LIST_HEAD(&vscsi->free_cmd);
+	vscsi->cmd_pool = kcalloc(num, sizeof(struct ibmvscsis_cmd),
+				  GFP_KERNEL);
+	if (!vscsi->cmd_pool)
+		return -ENOMEM;
+
+	for (i = 0, cmd = (struct ibmvscsis_cmd *)vscsi->cmd_pool; i < num;
+	     i++, cmd++) {
+		cmd->adapter = vscsi;
+		INIT_WORK(&cmd->work, ibmvscsis_scheduler);
+		list_add_tail(&cmd->list, &vscsi->free_cmd);
+	}
+
+	return 0;
+}
+
+static void ibmvscsis_free_cmds(struct scsi_info *vscsi)
+{
+	kfree(vscsi->cmd_pool);
+	vscsi->cmd_pool = NULL;
+	INIT_LIST_HEAD(&vscsi->free_cmd);
+}
+
+/**
+ * ibmvscsis_service_wait_q() - Service Waiting Queue
+ *
+ * This routine is called when the timer pops to service the waiting
+ * queue. Elements on the queue have completed, their responses have been
+ * copied to the client, but the client's response queue was full so
+ * the queue message could not be sent. The routine grabs the proper locks
+ * and calls send messages.
+ *
+ * EXECUTION ENVIRONMENT:
+ *	called at interrupt level
+ */
+static enum hrtimer_restart ibmvscsis_service_wait_q(struct hrtimer *timer)
+{
+	struct timer_cb *p_timer = container_of(timer, struct timer_cb, timer);
+	struct scsi_info *vscsi = container_of(p_timer, struct scsi_info,
+					       rsp_q_timer);
+
+	spin_lock_bh(&vscsi->intr_lock);
+	p_timer->timer_pops += 1;
+	p_timer->started = false;
+	ibmvscsis_send_messages(vscsi);
+	spin_unlock_bh(&vscsi->intr_lock);
+
+	return HRTIMER_NORESTART;
+}
+
+static long ibmvscsis_alloctimer(struct scsi_info *vscsi)
+{
+	struct timer_cb *p_timer;
+
+	p_timer = &vscsi->rsp_q_timer;
+	hrtimer_init(&p_timer->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+
+	p_timer->timer.function = ibmvscsis_service_wait_q;
+	p_timer->started = false;
+	p_timer->timer_pops = 0;
+
+	return ADAPT_SUCCESS;
+}
+
+static void ibmvscsis_freetimer(struct scsi_info *vscsi)
+{
+	struct timer_cb *p_timer;
+
+	p_timer = &vscsi->rsp_q_timer;
+
+	(void)hrtimer_cancel(&p_timer->timer);
+
+	p_timer->started = false;
+	p_timer->timer_pops = 0;
+}
+
+static void ibmvscsis_alloc_common_locks(struct scsi_info *vscsi)
+{
+	spin_lock_init(&vscsi->intr_lock);
+}
+
+static void ibmvscsis_free_common_locks(struct scsi_info *vscsi)
+{
+	/* Nothing to do here */
+}
+
+static irqreturn_t ibmvscsis_interrupt(int dummy, void *data)
+{
+	struct scsi_info *vscsi = data;
+
+	vio_disable_interrupts(vscsi->dma_dev);
+	tasklet_schedule(&vscsi->work_task);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * ibmvscsis_check_q() - Helper function to Check Init Message Valid
+ *
+ * Checks if a initialize message was queued by the initiatior
+ * while the timing window was open.  This function is called from
+ * probe after the CRQ is created and interrupts are enabled.
+ * It would only be used by adapters who wait for some event before
+ * completing the init handshake with the client.  For ibmvscsi, this
+ * event is waiting for the port to be enabled.
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Process level only
+ */
+static long ibmvscsis_check_q(struct scsi_info *vscsi)
+{
+	uint format;
+	long rc;
+
+	rc = ibmvscsis_check_init_msg(vscsi, &format);
+	if (rc)
+		ibmvscsis_post_disconnect(vscsi, ERR_DISCONNECT_RECONNECT, 0);
+	else if (format == UNUSED_FORMAT)
+		vscsi->state = WAIT_ENABLED;
+	else
+		vscsi->state = PART_UP_WAIT_ENAB;
+
+	return rc;
+}
+
+static long ibmvscsis_enable_change_state(struct scsi_info *vscsi)
+{
+	long rc = ADAPT_SUCCESS;
+
+handle_state_change:
+	switch (vscsi->state) {
+	case WAIT_ENABLED:
+		rc = ibmvscsis_send_init_message(vscsi, INIT_MSG);
+		switch (rc) {
+		case H_SUCCESS:
+		case H_DROPPED:
+		case H_CLOSED:
+			vscsi->state =  WAIT_CONNECTION;
+			rc = ADAPT_SUCCESS;
+			break;
+
+		case H_PARAMETER:
+			break;
+
+		case H_HARDWARE:
+			break;
+
+		default:
+			vscsi->state = UNDEFINED;
+			rc = H_HARDWARE;
+			break;
+		}
+		break;
+	case PART_UP_WAIT_ENAB:
+		rc = ibmvscsis_send_init_message(vscsi, INIT_COMPLETE_MSG);
+		switch (rc) {
+		case H_SUCCESS:
+			vscsi->state = CONNECTED;
+			rc = ADAPT_SUCCESS;
+			break;
+
+		case H_DROPPED:
+		case H_CLOSED:
+			vscsi->state = WAIT_ENABLED;
+			goto handle_state_change;
+
+		case H_PARAMETER:
+			break;
+
+		case H_HARDWARE:
+			break;
+
+		default:
+			rc = H_HARDWARE;
+			break;
+		}
+		break;
+
+	case WAIT_CONNECTION:
+	case WAIT_IDLE:
+	case SRP_PROCESSING:
+	case CONNECTED:
+		rc = ADAPT_SUCCESS;
+		break;
+		/* should not be able to get here */
+	case UNCONFIGURING:
+		rc = ERROR;
+		vscsi->state = UNDEFINED;
+		break;
+
+		/* driver should never allow this to happen */
+	case ERR_DISCONNECT:
+	case ERR_DISCONNECT_RECONNECT:
+	default:
+		dev_err(&vscsi->dev, "in invalid state %d during enable_change_state\n",
+			vscsi->state);
+		rc = ADAPT_SUCCESS;
+		break;
+	}
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_create_command_q() - Create Command Queue
+ *
+ * Allocates memory for command queue maps remote memory into an ioba
+ * initializes the command response queue
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Process level only
+ */
+static long ibmvscsis_create_command_q(struct scsi_info *vscsi, int num_cmds)
+{
+	long rc = 0;
+	int pages;
+	struct vio_dev *vdev = vscsi->dma_dev;
+
+	/* We might support multiple pages in the future, but just 1 for now */
+	pages = 1;
+
+	vscsi->cmd_q.size = pages;
+
+	vscsi->cmd_q.base_addr =
+		(struct viosrp_crq *)get_zeroed_page(GFP_KERNEL);
+	if (!vscsi->cmd_q.base_addr)
+		return -ENOMEM;
+
+	vscsi->cmd_q.mask = ((uint)pages * CRQ_PER_PAGE) - 1;
+
+	vscsi->cmd_q.crq_token = dma_map_single(&vdev->dev,
+						vscsi->cmd_q.base_addr,
+						PAGE_SIZE, DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(&vdev->dev, vscsi->cmd_q.crq_token)) {
+		free_page((unsigned long)vscsi->cmd_q.base_addr);
+		return -ENOMEM;
+	}
+
+	rc =  h_reg_crq(vscsi->dds.unit_id, vscsi->cmd_q.crq_token, PAGE_SIZE);
+	if (rc) {
+		if (rc == H_CLOSED) {
+			vscsi->state = WAIT_ENABLED;
+			rc = 0;
+		} else {
+			dma_unmap_single(&vdev->dev, vscsi->cmd_q.crq_token,
+					 PAGE_SIZE, DMA_BIDIRECTIONAL);
+			free_page((unsigned long)vscsi->cmd_q.base_addr);
+			rc = -ENODEV;
+		}
+	} else {
+		vscsi->state = WAIT_ENABLED;
+	}
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_destroy_command_q - Destroy Command Queue
+ *
+ * Releases memory for command queue and unmaps mapped remote memory
+ *
+ * EXECUTION ENVIRONMENT:
+ *	Process level only
+ */
+static void ibmvscsis_destroy_command_q(struct scsi_info *vscsi)
+{
+	dma_unmap_single(&vscsi->dma_dev->dev, vscsi->cmd_q.crq_token,
+			 PAGE_SIZE, DMA_BIDIRECTIONAL);
+	free_page((unsigned long)vscsi->cmd_q.base_addr);
+	vscsi->cmd_q.base_addr = NULL;
+	vscsi->state = NO_QUEUE;
+}
+
+static u8 ibmvscsis_fast_fail(struct scsi_info *vscsi,
+			      struct ibmvscsis_cmd *cmd)
+{
+	struct iu_entry *iue = cmd->iue;
+	struct se_cmd *se_cmd = &cmd->se_cmd;
+	struct srp_cmd *srp = (struct srp_cmd *)iue->sbuf->buf;
+	struct scsi_sense_hdr sshdr;
+	u8 rc = se_cmd->scsi_status;
+
+	if (vscsi->fast_fail && (READ_CMD(srp->cdb) || WRITE_CMD(srp->cdb)))
+		if (scsi_normalize_sense(se_cmd->sense_buffer,
+					 se_cmd->scsi_sense_length, &sshdr))
+			if (sshdr.sense_key == HARDWARE_ERROR &&
+			    (se_cmd->residual_count == 0 ||
+			     se_cmd->residual_count == se_cmd->data_length)) {
+				rc = NO_SENSE;
+				cmd->flags |= CMD_FAST_FAIL;
+			}
+
+	return rc;
+}
+
+/**
+ * srp_build_response() - Build an SRP response buffer
+ *
+ * PRECONDITION:
+ *	Called with interrupt lock held
+ */
+static long srp_build_response(struct scsi_info *vscsi,
+			       struct ibmvscsis_cmd *cmd, uint *len_p)
+{
+	struct iu_entry *iue = cmd->iue;
+	struct se_cmd *se_cmd = &cmd->se_cmd;
+	struct srp_rsp *rsp;
+	uint len;
+	u32 rsp_code;
+	char *data;
+	u32 *tsk_status;
+	long rc = ADAPT_SUCCESS;
+
+	spin_lock_bh(&vscsi->intr_lock);
+
+	rsp = &vio_iu(iue)->srp.rsp;
+	len = sizeof(*rsp);
+	memset(rsp, 0, len);
+	data = rsp->data;
+
+	rsp->opcode = SRP_RSP;
+
+	if (vscsi->credit > 0 && vscsi->state == SRP_PROCESSING)
+		rsp->req_lim_delta = cpu_to_be32(vscsi->credit);
+	else
+		rsp->req_lim_delta = cpu_to_be32(1 + vscsi->credit);
+	rsp->tag = cmd->rsp.tag;
+	rsp->flags = 0;
+
+	if (cmd->type == SCSI_CDB) {
+		rsp->status = ibmvscsis_fast_fail(vscsi, cmd);
+		if (rsp->status) {
+			pr_debug("build_resp: cmd %p, scsi status %d\n", cmd,
+				 (int)rsp->status);
+			ibmvscsis_determine_resid(se_cmd, rsp);
+			if (se_cmd->scsi_sense_length && se_cmd->sense_buffer) {
+				rsp->sense_data_len =
+					cpu_to_be32(se_cmd->scsi_sense_length);
+				rsp->flags |= SRP_RSP_FLAG_SNSVALID;
+				len += se_cmd->scsi_sense_length;
+				memcpy(data, se_cmd->sense_buffer,
+				       se_cmd->scsi_sense_length);
+			}
+			rsp->sol_not = (cmd->rsp.sol_not & UCSOLNT) >>
+				UCSOLNT_RESP_SHIFT;
+		} else if (cmd->flags & CMD_FAST_FAIL) {
+			pr_debug("build_resp: cmd %p, fast fail\n", cmd);
+			rsp->sol_not = (cmd->rsp.sol_not & UCSOLNT) >>
+				UCSOLNT_RESP_SHIFT;
+		} else {
+			rsp->sol_not = (cmd->rsp.sol_not & SCSOLNT) >>
+				SCSOLNT_RESP_SHIFT;
+		}
+	} else {
+		/* this is task management */
+		rsp->status = 0;
+		rsp->resp_data_len = cpu_to_be32(4);
+		rsp->flags |= SRP_RSP_FLAG_RSPVALID;
+
+		switch (se_cmd->se_tmr_req->response) {
+		case TMR_FUNCTION_COMPLETE:
+		case TMR_TASK_DOES_NOT_EXIST:
+			rsp_code = SRP_TASK_MANAGEMENT_FUNCTION_COMPLETE;
+			rsp->sol_not = (cmd->rsp.sol_not & SCSOLNT) >>
+				SCSOLNT_RESP_SHIFT;
+			break;
+		case TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED:
+		case TMR_LUN_DOES_NOT_EXIST:
+			rsp_code = SRP_TASK_MANAGEMENT_FUNCTION_NOT_SUPPORTED;
+			rsp->sol_not = (cmd->rsp.sol_not & UCSOLNT) >>
+				UCSOLNT_RESP_SHIFT;
+			break;
+		case TMR_FUNCTION_FAILED:
+		case TMR_FUNCTION_REJECTED:
+		default:
+			rsp_code = SRP_TASK_MANAGEMENT_FUNCTION_FAILED;
+			rsp->sol_not = (cmd->rsp.sol_not & UCSOLNT) >>
+				UCSOLNT_RESP_SHIFT;
+			break;
+		}
+
+		tsk_status = (u32 *)data;
+		*tsk_status = cpu_to_be32(rsp_code);
+		data = (char *)(tsk_status + 1);
+		len += 4;
+	}
+
+	dma_wmb();
+	rc = h_copy_rdma(len, vscsi->dds.window[LOCAL].liobn, iue->sbuf->dma,
+			 vscsi->dds.window[REMOTE].liobn,
+			 be64_to_cpu(iue->remote_token));
+
+	switch (rc) {
+	case H_SUCCESS:
+		vscsi->credit = 0;
+		*len_p = len;
+		break;
+	case H_PERMISSION:
+		if (connection_broken(vscsi))
+			vscsi->flags |= RESPONSE_Q_DOWN | CLIENT_FAILED;
+
+		dev_err(&vscsi->dev, "build_response: error copying to client, rc %ld, flags 0x%x, state 0x%hx\n",
+			rc, vscsi->flags, vscsi->state);
+		break;
+	case H_SOURCE_PARM:
+	case H_DEST_PARM:
+	default:
+		dev_err(&vscsi->dev, "build_response: error copying to client, rc %ld\n",
+			rc);
+		break;
+	}
+
+	spin_unlock_bh(&vscsi->intr_lock);
+
+	return rc;
+}
+
+static int ibmvscsis_rdma(struct ibmvscsis_cmd *cmd, struct scatterlist *sg,
+			  int nsg, struct srp_direct_buf *md, int nmd,
+			  enum dma_data_direction dir, unsigned int bytes)
+{
+	struct iu_entry *iue = cmd->iue;
+	struct srp_target *target = iue->target;
+	struct scsi_info *vscsi = target->ldata;
+	struct scatterlist *sgp;
+	dma_addr_t client_ioba, server_ioba;
+	ulong buf_len;
+	ulong client_len, server_len;
+	int md_idx;
+	long tx_len;
+	long rc = 0;
+
+	pr_debug("rdma: dir %d, bytes 0x%x\n", dir, bytes);
+
+	if (bytes == 0)
+		return 0;
+
+	sgp = sg;
+	client_len = 0;
+	server_len = 0;
+	md_idx = 0;
+	tx_len = bytes;
+
+	do {
+		if (client_len == 0) {
+			if (md_idx >= nmd) {
+				dev_err(&vscsi->dev, "rdma: ran out of client memory descriptors\n");
+				rc = -EIO;
+				break;
+			}
+			client_ioba = be64_to_cpu(md[md_idx].va);
+			client_len = be32_to_cpu(md[md_idx].len);
+		}
+		if (server_len == 0) {
+			if (!sgp) {
+				dev_err(&vscsi->dev, "rdma: ran out of scatter/gather list\n");
+				rc = -EIO;
+				break;
+			}
+			server_ioba = sg_dma_address(sgp);
+			server_len = sg_dma_len(sgp);
+		}
+
+		buf_len = tx_len;
+
+		if (buf_len > client_len)
+			buf_len = client_len;
+
+		if (buf_len > server_len)
+			buf_len = server_len;
+
+		if (buf_len > max_vdma_size)
+			buf_len = max_vdma_size;
+
+		if (dir == DMA_TO_DEVICE) {
+			/* read from client */
+			rc = h_copy_rdma(buf_len,
+					 vscsi->dds.window[REMOTE].liobn,
+					 client_ioba,
+					 vscsi->dds.window[LOCAL].liobn,
+					 server_ioba);
+		} else {
+			/* write to client */
+			struct srp_cmd *srp = (struct srp_cmd *)iue->sbuf->buf;
+
+			if (!READ_CMD(srp->cdb))
+				print_hex_dump_bytes(" data:", DUMP_PREFIX_NONE,
+						     sg_virt(sgp), buf_len);
+			/* ensure that everything is in memory */
+			isync();
+			/* ensure that memory has been made visible */
+			/* The h_copy_rdma will cause phyp, running in another
+			 * partition, to read memory, so we need to make sure
+			 * the data has been written out, hence the sync above.
+			 */
+			dma_wmb();
+			rc = h_copy_rdma(buf_len,
+					 vscsi->dds.window[LOCAL].liobn,
+					 server_ioba,
+					 vscsi->dds.window[REMOTE].liobn,
+					 client_ioba);
+		}
+		switch (rc) {
+		case H_SUCCESS:
+			break;
+		case H_PERMISSION:
+		case H_SOURCE_PARM:
+		case H_DEST_PARM:
+			if (connection_broken(vscsi)) {
+				spin_lock_bh(&vscsi->intr_lock);
+				vscsi->flags |=
+					(RESPONSE_Q_DOWN | CLIENT_FAILED);
+				spin_unlock_bh(&vscsi->intr_lock);
+			}
+			dev_err(&vscsi->dev, "rdma: h_copy_rdma failed, rc %ld\n",
+				rc);
+			break;
+
+		default:
+			dev_err(&vscsi->dev, "rdma: unknown error %ld from h_copy_rdma\n",
+				rc);
+			break;
+		}
+
+		if (!rc) {
+			tx_len -= buf_len;
+			if (tx_len) {
+				client_len -= buf_len;
+				if (client_len == 0)
+					md_idx++;
+				else
+					client_ioba += buf_len;
+
+				server_len -= buf_len;
+				if (server_len == 0)
+					sgp = sg_next(sgp);
+				else
+					server_ioba += buf_len;
+			} else {
+				break;
+			}
+		}
+	} while (!rc);
+
+	return rc;
+}
+
+/**
+ * ibmvscsis_handle_crq() - Handle CRQ
+ *
+ * Read the command elements from the command queue copy the payloads
+ * associated with the command elements to local memory and execute the
+ * SRP requests
+ *
+ * Note: this is an edge triggered interrupt. It can not be shared.
+ */
+static void ibmvscsis_handle_crq(unsigned long data)
+{
+	struct scsi_info *vscsi = (struct scsi_info *)data;
+	struct viosrp_crq *crq;
+	long rc;
+	bool ack = true;
+	volatile u8 valid;
+
+	spin_lock_bh(&vscsi->intr_lock);
+
+	pr_debug("got interrupt\n");
+
+	/*
+	 * if we are in a path where we are waiting for all pending commands
+	 * to complete because we received a transport event and anything in
+	 * the command queue is for a new connection,  do nothing
+	 */
+	if (TARGET_STOP(vscsi)) {
+		vio_enable_interrupts(vscsi->dma_dev);
+
+		pr_debug("handle_crq, don't process: flags 0x%x, state 0x%hx\n",
+			 vscsi->flags, vscsi->state);
+		spin_unlock_bh(&vscsi->intr_lock);
+		return;
+	}
+
+	rc = vscsi->flags & SCHEDULE_DISCONNECT;
+	crq = vscsi->cmd_q.base_addr + vscsi->cmd_q.index;
+	valid = crq->valid;
+	dma_rmb();
+
+	while (valid) {
+		/*
+		 * These are edege triggered interrupts. After dropping out of
+		 * the while loop, the code must check for work since an
+		 * interrupt could be lost, and an elment be left on the queue,
+		 * hence the label.
+		 */
+cmd_work:
+		vscsi->cmd_q.index =
+			(vscsi->cmd_q.index + 1) & vscsi->cmd_q.mask;
+
+		if (!rc) {
+			rc = ibmvscsis_parse_command(vscsi, crq);
+		} else {
+			if ((uint)crq->valid == VALID_TRANS_EVENT) {
+				/*
+				 * must service the transport layer events even
+				 * in an error state, dont break out until all
+				 * the consecutive transport events have been
+				 * processed
+				 */
+				rc = ibmvscsis_trans_event(vscsi, crq);
+			} else if (vscsi->flags & TRANS_EVENT) {
+				/*
+				 * if a tranport event has occurred leave
+				 * everything but transport events on the queue
+				 */
+				pr_debug("handle_crq, ignoring\n");
+
+				/*
+				 * need to decrement the queue index so we can
+				 * look at the elment again
+				 */
+				if (vscsi->cmd_q.index)
+					vscsi->cmd_q.index -= 1;
+				else
+					/*
+					 * index is at 0 it just wrapped.
+					 * have it index last element in q
+					 */
+					vscsi->cmd_q.index = vscsi->cmd_q.mask;
+				break;
+			}
+		}
+
+		crq->valid = INVALIDATE_CMD_RESP_EL;
+
+		crq = vscsi->cmd_q.base_addr + vscsi->cmd_q.index;
+		valid = crq->valid;
+		dma_rmb();
+	}
+
+	if (!rc) {
+		if (ack) {
+			vio_enable_interrupts(vscsi->dma_dev);
+			ack = false;
+			pr_debug("handle_crq, reenabling interrupts\n");
+		}
+		valid = crq->valid;
+		dma_rmb();
+		if (valid)
+			goto cmd_work;
+	} else {
+		pr_debug("handle_crq, error: flags 0x%x, state 0x%hx, crq index 0x%x\n",
+			 vscsi->flags, vscsi->state, vscsi->cmd_q.index);
+	}
+
+	pr_debug("Leaving handle_crq: schedule_q empty %d, flags 0x%x, state 0x%hx\n",
+		 (int)list_empty(&vscsi->schedule_q), vscsi->flags,
+		 vscsi->state);
+
+	spin_unlock_bh(&vscsi->intr_lock);
+}
+
+static int ibmvscsis_probe(struct vio_dev *vdev,
+			   const struct vio_device_id *id)
+{
+	struct scsi_info *vscsi;
+	int rc = 0;
+	long hrc = 0;
+	char wq_name[24];
+
+	vscsi = kzalloc(sizeof(*vscsi), GFP_KERNEL);
+	if (!vscsi) {
+		rc = -ENOMEM;
+		pr_err("probe: allocation of adapter failed\n");
+		return rc;
+	}
+
+	vscsi->dma_dev = vdev;
+	vscsi->dev = vdev->dev;
+	INIT_LIST_HEAD(&vscsi->schedule_q);
+	INIT_LIST_HEAD(&vscsi->waiting_rsp);
+	INIT_LIST_HEAD(&vscsi->active_q);
+
+	snprintf(vscsi->tport.tport_name, 256, "%s", dev_name(&vdev->dev));
+
+	pr_debug("probe tport_name: %s\n", vscsi->tport.tport_name);
+
+	rc = read_dma_window(vscsi);
+	if (rc)
+		goto free_adapter;
+	pr_debug("Probe: liobn 0x%x, riobn 0x%x\n",
+		 vscsi->dds.window[LOCAL].liobn,
+		 vscsi->dds.window[REMOTE].liobn);
+
+	strcpy(vscsi->eye, "VSCSI ");
+	strncat(vscsi->eye, vdev->name, MAX_EYE);
+
+	vscsi->dds.unit_id = vdev->unit_address;
+
+	spin_lock_bh(&ibmvscsis_dev_lock);
+	list_add_tail(&vscsi->list, &ibmvscsis_dev_list);
+	spin_unlock_bh(&ibmvscsis_dev_lock);
+
+	/*
+	 * TBD: How do we determine # of cmds to request?  Do we know how
+	 * many "children" we have?
+	 */
+	vscsi->request_limit = INITIAL_SRP_LIMIT;
+	rc = srp_target_alloc(&vscsi->target, &vdev->dev, vscsi->request_limit,
+			      SRP_MAX_IU_LEN);
+	if (rc)
+		goto rem_list;
+
+	vscsi->target.ldata = vscsi;
+
+	rc = ibmvscsis_alloc_cmds(vscsi, vscsi->request_limit);
+	if (rc) {
+		dev_err(&vscsi->dev, "alloc_cmds failed, rc %d, num %d\n",
+			rc, vscsi->request_limit);
+		goto free_target;
+	}
+
+	/*
+	 * Note: the lock is used in freeing timers, so must allocate
+	 * first so that ordering in case of error is correct.
+	 */
+	ibmvscsis_alloc_common_locks(vscsi);
+
+	rc = ibmvscsis_alloctimer(vscsi);
+	if (rc) {
+		dev_err(&vscsi->dev, "probe: alloctimer failed, rc %d\n", rc);
+		goto free_lock;
+	}
+
+	rc = ibmvscsis_create_command_q(vscsi, 256);
+	if (rc) {
+		dev_err(&vscsi->dev, "probe: create_command_q failed, rc %d\n",
+			rc);
+		goto free_timer;
+	}
+
+	vscsi->map_buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!vscsi->map_buf) {
+		rc = -ENOMEM;
+		dev_err(&vscsi->dev, "probe: allocating cmd buffer failed\n");
+		goto destroy_queue;
+	}
+
+	vscsi->map_ioba = dma_map_single(&vdev->dev, vscsi->map_buf, PAGE_SIZE,
+					 DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(&vdev->dev, vscsi->map_ioba)) {
+		dev_err(&vscsi->dev, "probe: error mapping command buffer\n");
+		goto free_cmd;
+	}
+
+	hrc = h_vioctl(vscsi->dds.unit_id, H_GET_PARTNER_INFO,
+		       (u64)vscsi->map_ioba | ((u64)PAGE_SIZE << 32), 0, 0, 0,
+		       0);
+	if (hrc == H_SUCCESS)
+		vscsi->client_data.partition_number =
+			be64_to_cpu(*(u64 *)vscsi->map_buf);
+	/*
+	 * We expect the VIOCTL to fail if we're configured as "any
+	 * client can connect" and the client isn't activated yet.
+	 * We'll make the call again when he sends an init msg.
+	 */
+	pr_debug("probe hrc %ld, client partition num %d\n",
+		 hrc, vscsi->client_data.partition_number);
+
+	tasklet_init(&vscsi->work_task, ibmvscsis_handle_crq,
+		     (unsigned long)vscsi);
+
+	init_completion(&vscsi->wait_idle);
+
+	snprintf(wq_name, 24, "ibmvscsis%s", dev_name(&vdev->dev));
+	vscsi->work_q = create_workqueue(wq_name);
+	if (!vscsi->work_q) {
+		rc = -ENOMEM;
+		dev_err(&vscsi->dev, "create_workqueue failed\n");
+		goto unmap_cmd;
+	}
+
+	rc = request_irq(vdev->irq, ibmvscsis_interrupt, 0, "ibmvscsis", vscsi);
+	if (rc) {
+		rc = -EPERM;
+		dev_err(&vscsi->dev, "probe: request_irq failed, rc %d\n", rc);
+		goto destroy_WQ;
+	}
+
+	spin_lock_bh(&vscsi->intr_lock);
+	vio_enable_interrupts(vdev);
+	if (rc) {
+		dev_err(&vscsi->dev, "enabling interrupts failed, rc %d\n", rc);
+		rc = -ENODEV;
+		spin_unlock_bh(&vscsi->intr_lock);
+		goto free_irq;
+	}
+
+	if (ibmvscsis_check_q(vscsi)) {
+		rc = ERROR;
+		dev_err(&vscsi->dev, "probe: check_q failed, rc %d\n", rc);
+		spin_unlock_bh(&vscsi->intr_lock);
+		goto disable_interrupt;
+	}
+	spin_unlock_bh(&vscsi->intr_lock);
+
+	dev_set_drvdata(&vdev->dev, vscsi);
+
+	return 0;
+
+disable_interrupt:
+	vio_disable_interrupts(vdev);
+free_irq:
+	free_irq(vdev->irq, vscsi);
+destroy_WQ:
+	destroy_workqueue(vscsi->work_q);
+unmap_cmd:
+	dma_unmap_single(&vdev->dev, vscsi->map_ioba, PAGE_SIZE,
+			 DMA_BIDIRECTIONAL);
+free_cmd:
+	kfree(vscsi->map_buf);
+destroy_queue:
+	tasklet_kill(&vscsi->work_task);
+	ibmvscsis_unregister_command_q(vscsi);
+	ibmvscsis_destroy_command_q(vscsi);
+free_timer:
+	ibmvscsis_freetimer(vscsi);
+free_lock:
+	ibmvscsis_free_common_locks(vscsi);
+	ibmvscsis_free_cmds(vscsi);
+free_target:
+	srp_target_free(&vscsi->target);
+rem_list:
+	spin_lock_bh(&ibmvscsis_dev_lock);
+	list_del(&vscsi->list);
+	spin_unlock_bh(&ibmvscsis_dev_lock);
+free_adapter:
+	kfree(vscsi);
+
+	return rc;
+}
+
+static int ibmvscsis_remove(struct vio_dev *vdev)
+{
+	struct scsi_info *vscsi = dev_get_drvdata(&vdev->dev);
+
+	pr_debug("remove (%s)\n", dev_name(&vscsi->dma_dev->dev));
+
+	/*
+	 * TBD: Need to handle if there are commands on the waiting_rsp q
+	 *      Actually, can there still be cmds outstanding to tcm?
+	 */
+
+	vio_disable_interrupts(vdev);
+	free_irq(vdev->irq, vscsi);
+	destroy_workqueue(vscsi->work_q);
+	dma_unmap_single(&vdev->dev, vscsi->map_ioba, PAGE_SIZE,
+			 DMA_BIDIRECTIONAL);
+	kfree(vscsi->map_buf);
+	tasklet_kill(&vscsi->work_task);
+	ibmvscsis_unregister_command_q(vscsi);
+	ibmvscsis_destroy_command_q(vscsi);
+	ibmvscsis_freetimer(vscsi);
+	ibmvscsis_free_common_locks(vscsi);
+	ibmvscsis_free_cmds(vscsi);
+	srp_target_free(&vscsi->target);
+	spin_lock_bh(&ibmvscsis_dev_lock);
+	list_del(&vscsi->list);
+	spin_unlock_bh(&ibmvscsis_dev_lock);
+	kfree(vscsi);
+
+	return 0;
+}
+
+static ssize_t system_id_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n", system_id);
+}
+
+static ssize_t partition_number_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%x\n", partition_number);
+}
+
+static ssize_t unit_address_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct scsi_info *vscsi = container_of(dev, struct scsi_info, dev);
+
+	return snprintf(buf, PAGE_SIZE, "%x\n", vscsi->dma_dev->unit_address);
+}
+
+static int ibmvscsis_get_system_info(void)
+{
+	struct device_node *rootdn, *vdevdn;
+	const char *id, *model, *name;
+	const uint *num;
+
+	rootdn = of_find_node_by_path("/");
+	if (!rootdn)
+		return -ENOENT;
+
+	model = of_get_property(rootdn, "model", NULL);
+	id = of_get_property(rootdn, "system-id", NULL);
+	if (model && id)
+		snprintf(system_id, sizeof(system_id), "%s-%s", model, id);
+
+	name = of_get_property(rootdn, "ibm,partition-name", NULL);
+	if (name)
+		strncpy(partition_name, name, sizeof(partition_name));
+
+	num = of_get_property(rootdn, "ibm,partition-no", NULL);
+	if (num)
+		partition_number = *num;
+
+	of_node_put(rootdn);
+
+	vdevdn = of_find_node_by_path("/vdevice");
+	if (vdevdn) {
+		const uint *mvds;
+
+		mvds = of_get_property(vdevdn, "ibm,max-virtual-dma-size",
+				       NULL);
+		if (mvds)
+			max_vdma_size = *mvds;
+		of_node_put(vdevdn);
+	}
+
+	return 0;
+}
+
+static char *ibmvscsis_get_fabric_name(void)
+{
+	return "ibmvscsis";
+}
+
+static char *ibmvscsis_get_fabric_wwn(struct se_portal_group *se_tpg)
+{
+	struct ibmvscsis_tport *tport =
+		container_of(se_tpg, struct ibmvscsis_tport, se_tpg);
+
+	return tport->tport_name;
+}
+
+static u16 ibmvscsis_get_tag(struct se_portal_group *se_tpg)
+{
+	struct ibmvscsis_tport *tport =
+		container_of(se_tpg, struct ibmvscsis_tport, se_tpg);
+
+	return tport->tport_tpgt;
+}
+
+static u32 ibmvscsis_get_default_depth(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+static int ibmvscsis_check_true(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+static int ibmvscsis_check_false(struct se_portal_group *se_tpg)
+{
+	return 0;
+}
+
+static u32 ibmvscsis_tpg_get_inst_index(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+static int ibmvscsis_check_stop_free(struct se_cmd *se_cmd)
+{
+	return target_put_sess_cmd(se_cmd);
+}
+
+static void ibmvscsis_release_cmd(struct se_cmd *se_cmd)
+{
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd, struct ibmvscsis_cmd,
+						 se_cmd);
+	struct scsi_info *vscsi = cmd->adapter;
+
+	pr_debug("release_cmd %p, flags %d\n", se_cmd, cmd->flags);
+
+	spin_lock_bh(&vscsi->intr_lock);
+	/* Remove from active_q */
+	list_del(&cmd->list);
+	list_add_tail(&cmd->list, &vscsi->waiting_rsp);
+	ibmvscsis_send_messages(vscsi);
+	spin_unlock_bh(&vscsi->intr_lock);
+}
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4, 5, 7)
+static int ibmvscsis_shutdown_session(struct se_session *se_sess)
+{
+	return 0;
+}
+
+static void ibmvscsis_close_session(struct se_session *se_sess)
+{
+}
+#endif
+
+static u32 ibmvscsis_sess_get_index(struct se_session *se_sess)
+{
+	return 0;
+}
+
+static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
+{
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd, struct ibmvscsis_cmd,
+						  se_cmd);
+	struct iu_entry *iue = cmd->iue;
+	int rc;
+
+	pr_debug("write_pending, se_cmd %p, length 0x%x\n",
+		 se_cmd, se_cmd->data_length);
+
+	rc = srp_transfer_data(cmd, &vio_iu(iue)->srp.cmd, ibmvscsis_rdma,
+			       1, 1);
+	if (rc) {
+		pr_err("srp_transfer_data() failed: %d\n", rc);
+		return -EAGAIN;
+	}
+	/*
+	 * We now tell TCM to add this WRITE CDB directly into the TCM storage
+	 * object execution queue.
+	 */
+	target_execute_cmd(se_cmd);
+	return 0;
+}
+
+static int ibmvscsis_write_pending_status(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+static void ibmvscsis_set_default_node_attrs(struct se_node_acl *nacl)
+{
+}
+
+static int ibmvscsis_get_cmd_state(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
+{
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd, struct ibmvscsis_cmd,
+						 se_cmd);
+	struct iu_entry *iue = cmd->iue;
+	struct srp_cmd *srp = (struct srp_cmd *)iue->sbuf->buf;
+	struct scsi_info *vscsi = cmd->adapter;
+	char *sd;
+	uint len = 0;
+	int rc;
+
+	pr_debug("queue_data_in, se_cmd %p, length 0x%x\n",
+		 se_cmd, se_cmd->data_length);
+
+	/* TBD: Why does flat addressing not work for the linux client? */
+	if (srp->cdb[0] == REPORT_LUNS && vscsi->client_data.os_type != LINUX)
+		ibmvscsis_modify_rep_luns(se_cmd);
+	/* This is a Standard Inquiry request */
+	else if ((srp->cdb[0] == INQUIRY) && ((srp->cdb[1] & 0x1) == 0))
+		ibmvscsis_modify_std_inquiry(se_cmd);
+
+	rc = srp_transfer_data(cmd, &vio_iu(iue)->srp.cmd, ibmvscsis_rdma, 1,
+			       1);
+	if (rc) {
+		pr_err("srp_transfer_data failed: %d\n", rc);
+		sd = se_cmd->sense_buffer;
+		se_cmd->scsi_sense_length = 18;
+		memset(se_cmd->sense_buffer, 0, se_cmd->scsi_sense_length);
+		/* Current error */
+		sd[0] = 0x70;
+		/* sense key = Medium Error */
+		sd[2] = 3;
+		/* additional length (length - 8) */
+		sd[7] = 10;
+		/* asc/ascq 0x801 = Logical Unit Communication time-out */
+		sd[12] = 8;
+		sd[13] = 1;
+	}
+
+	srp_build_response(vscsi, cmd, &len);
+	cmd->rsp.format = SRP_FORMAT;
+	cmd->rsp.len = len;
+
+	return 0;
+}
+
+static int ibmvscsis_queue_status(struct se_cmd *se_cmd)
+{
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd, struct ibmvscsis_cmd,
+						 se_cmd);
+	struct scsi_info *vscsi = cmd->adapter;
+	uint len;
+
+	pr_debug("queue_status %p\n", se_cmd);
+
+	srp_build_response(vscsi, cmd, &len);
+	cmd->rsp.format = SRP_FORMAT;
+	cmd->rsp.len = len;
+
+	return 0;
+}
+
+static void ibmvscsis_queue_tm_rsp(struct se_cmd *se_cmd)
+{
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd, struct ibmvscsis_cmd,
+						 se_cmd);
+	struct scsi_info *vscsi = cmd->adapter;
+	uint len;
+
+	pr_debug("queue_tm_rsp %p, status %d\n",
+		 se_cmd, (int)se_cmd->se_tmr_req->response);
+
+	srp_build_response(vscsi, cmd, &len);
+	cmd->rsp.format = SRP_FORMAT;
+	cmd->rsp.len = len;
+}
+
+static void ibmvscsis_aborted_task(struct se_cmd *se_cmd)
+{
+	/* TBD: What (if anything) should we do here? */
+	pr_debug("ibmvscsis_aborted_task %p\n", se_cmd);
+}
+
+static struct se_wwn *ibmvscsis_make_tport(struct target_fabric_configfs *tf,
+					   struct config_group *group,
+					   const char *name)
+{
+	struct ibmvscsis_tport *tport;
+
+	tport = ibmvscsis_lookup_port(name);
+	if (tport) {
+		tport->tport_proto_id = SCSI_PROTOCOL_SRP;
+		pr_debug("make_tport(%s), pointer:%p, tport_id:%x\n",
+			 name, tport, tport->tport_proto_id);
+		return &tport->tport_wwn;
+	}
+
+	return ERR_PTR(-EINVAL);
+}
+
+static void ibmvscsis_drop_tport(struct se_wwn *wwn)
+{
+	struct ibmvscsis_tport *tport = container_of(wwn,
+						     struct ibmvscsis_tport,
+						     tport_wwn);
+
+	kfree(tport);
+
+	pr_debug("drop_tport(%s)\n",
+		 config_item_name(&tport->tport_wwn.wwn_group.cg_item));
+}
+
+static struct se_portal_group *ibmvscsis_make_tpg(struct se_wwn *wwn,
+						  struct config_group *group,
+						  const char *name)
+{
+	struct ibmvscsis_tport *tport =
+		container_of(wwn, struct ibmvscsis_tport, tport_wwn);
+	int rc;
+
+	tport->releasing = false;
+
+	rc = core_tpg_register(&tport->tport_wwn, &tport->se_tpg,
+			       tport->tport_proto_id);
+	if (rc)
+		return ERR_PTR(rc);
+
+	return &tport->se_tpg;
+}
+
+static void ibmvscsis_drop_tpg(struct se_portal_group *se_tpg)
+{
+	struct ibmvscsis_tport *tport = container_of(se_tpg,
+						     struct ibmvscsis_tport,
+						     se_tpg);
+
+	tport->releasing = true;
+	tport->enabled = false;
+
+	/*
+	 * Release the virtual I_T Nexus for this ibmvscsis TPG
+	 */
+	ibmvscsis_drop_nexus(tport);
+	/*
+	 * Deregister the se_tpg from TCM..
+	 */
+	core_tpg_deregister(se_tpg);
+}
+
+static ssize_t ibmvscsis_wwn_version_show(struct config_item *item,
+					  char *page)
+{
+	return scnprintf(page, PAGE_SIZE, "%s\n", IBMVSCSIS_VERSION);
+}
+CONFIGFS_ATTR_RO(ibmvscsis_wwn_, version);
+
+static struct configfs_attribute *ibmvscsis_wwn_attrs[] = {
+	&ibmvscsis_wwn_attr_version,
+	NULL,
+};
+
+static ssize_t ibmvscsis_tpg_enable_show(struct config_item *item,
+					 char *page)
+{
+	struct se_portal_group *se_tpg = to_tpg(item);
+	struct ibmvscsis_tport *tport = container_of(se_tpg,
+						     struct ibmvscsis_tport,
+						     se_tpg);
+
+	return snprintf(page, PAGE_SIZE, "%d\n", (tport->enabled) ? 1 : 0);
+}
+
+static ssize_t ibmvscsis_tpg_enable_store(struct config_item *item,
+					  const char *page, size_t count)
+{
+	struct se_portal_group *se_tpg = to_tpg(item);
+	struct ibmvscsis_tport *tport = container_of(se_tpg,
+						     struct ibmvscsis_tport,
+						     se_tpg);
+	struct scsi_info *vscsi = container_of(tport, struct scsi_info, tport);
+	unsigned long tmp;
+	int rc;
+	long lrc;
+
+	rc = kstrtoul(page, 0, &tmp);
+	if (rc < 0) {
+		pr_err("Unable to extract srpt_tpg_store_enable\n");
+		return -EINVAL;
+	}
+
+	if ((tmp != 0) && (tmp != 1)) {
+		pr_err("Illegal value for srpt_tpg_store_enable\n");
+		return -EINVAL;
+	}
+
+	if (tmp) {
+		tport->enabled = true;
+		spin_lock_bh(&vscsi->intr_lock);
+		lrc = ibmvscsis_enable_change_state(vscsi);
+		if (lrc)
+			pr_err("enable_change_state failed, rc %ld state %d\n",
+			       lrc, vscsi->state);
+		spin_unlock_bh(&vscsi->intr_lock);
+	} else {
+		tport->enabled = false;
+	}
+
+	pr_debug("tpg_enable_store, state %d\n", vscsi->state);
+
+	return count;
+}
+CONFIGFS_ATTR(ibmvscsis_tpg_, enable);
+
+static struct configfs_attribute *ibmvscsis_tpg_attrs[] = {
+			&ibmvscsis_tpg_attr_enable,
+			NULL,
+};
+
+static const struct target_core_fabric_ops ibmvscsis_ops = {
+	.module				= THIS_MODULE,
+	.name				= "ibmvscsis",
+	.max_data_sg_nents		= SCSI_MAX_SG_SEGMENTS,
+	.get_fabric_name		= ibmvscsis_get_fabric_name,
+	.tpg_get_wwn			= ibmvscsis_get_fabric_wwn,
+	.tpg_get_tag			= ibmvscsis_get_tag,
+	.tpg_get_default_depth		= ibmvscsis_get_default_depth,
+	.tpg_check_demo_mode		= ibmvscsis_check_true,
+	.tpg_check_demo_mode_cache	= ibmvscsis_check_true,
+	.tpg_check_demo_mode_write_protect = ibmvscsis_check_false,
+	.tpg_check_prod_mode_write_protect = ibmvscsis_check_false,
+	.tpg_get_inst_index		= ibmvscsis_tpg_get_inst_index,
+	.check_stop_free		= ibmvscsis_check_stop_free,
+	.release_cmd			= ibmvscsis_release_cmd,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4, 5, 7)
+	.shutdown_session		= ibmvscsis_shutdown_session,
+	.close_session			= ibmvscsis_close_session,
+#endif
+	.sess_get_index			= ibmvscsis_sess_get_index,
+	.write_pending			= ibmvscsis_write_pending,
+	.write_pending_status		= ibmvscsis_write_pending_status,
+	.set_default_node_attributes	= ibmvscsis_set_default_node_attrs,
+	.get_cmd_state			= ibmvscsis_get_cmd_state,
+	.queue_data_in			= ibmvscsis_queue_data_in,
+	.queue_status			= ibmvscsis_queue_status,
+	.queue_tm_rsp			= ibmvscsis_queue_tm_rsp,
+	.aborted_task			= ibmvscsis_aborted_task,
+	/*
+	 * Setup function pointers for logic in target_core_fabric_configfs.c
+	 */
+	.fabric_make_wwn		= ibmvscsis_make_tport,
+	.fabric_drop_wwn		= ibmvscsis_drop_tport,
+	.fabric_make_tpg		= ibmvscsis_make_tpg,
+	.fabric_drop_tpg		= ibmvscsis_drop_tpg,
+
+	.tfc_wwn_attrs			= ibmvscsis_wwn_attrs,
+	.tfc_tpg_base_attrs		= ibmvscsis_tpg_attrs,
+};
+
+static void ibmvscsis_dev_release(struct device *dev) {};
+
+static struct class_attribute ibmvscsis_class_attrs[] = {
+	__ATTR_NULL,
+};
+
+static struct device_attribute dev_attr_system_id =
+	__ATTR(system_id, S_IRUGO, system_id_show, NULL);
+
+static struct device_attribute dev_attr_partition_number =
+	__ATTR(partition_number, S_IRUGO, partition_number_show, NULL);
+
+static struct device_attribute dev_attr_unit_address =
+	__ATTR(unit_address, S_IRUGO, unit_address_show, NULL);
+
+static struct attribute *ibmvscsis_dev_attrs[] = {
+	&dev_attr_system_id.attr,
+	&dev_attr_partition_number.attr,
+	&dev_attr_unit_address.attr,
+};
+ATTRIBUTE_GROUPS(ibmvscsis_dev);
+
+static struct class ibmvscsis_class = {
+	.name           = "ibmvscsis",
+	.dev_release    = ibmvscsis_dev_release,
+	.class_attrs    = ibmvscsis_class_attrs,
+	.dev_groups     = ibmvscsis_dev_groups,
+};
+
+static struct vio_device_id ibmvscsis_device_table[] = {
+	{"v-scsi-host", "IBM,v-scsi-host"},
+	{"", ""}
+};
+MODULE_DEVICE_TABLE(vio, ibmvscsis_device_table);
+
+static struct vio_driver ibmvscsis_driver = {
+	.name = ibmvscsis_driver_name,
+	.id_table = ibmvscsis_device_table,
+	.probe = ibmvscsis_probe,
+	.remove = ibmvscsis_remove,
+};
+
+/*
+ * ibmvscsis_init() - Kernel Module initialization
+ *
+ * Note: vio_register_driver() registers callback functions, and at least one
+ * of those callback functions calls TCM - Linux IO Target Subsystem, thus
+ * the SCSI Target template must be registered before vio_register_driver()
+ * is called.
+ */
+static int __init ibmvscsis_init(void)
+{
+	int rc = 0;
+
+	rc = ibmvscsis_get_system_info();
+	if (rc) {
+		pr_err("ret %d from get_system_info\n", rc);
+		goto out;
+	}
+
+	rc = class_register(&ibmvscsis_class);
+	if (rc) {
+		pr_err("failed class register\n");
+		goto out;
+	}
+
+	rc = target_register_template(&ibmvscsis_ops);
+	if (rc) {
+		pr_err("ret %d from target_register_template\n", rc);
+		goto unregister_class;
+	}
+
+	rc = vio_register_driver(&ibmvscsis_driver);
+	if (rc) {
+		pr_err("ret %d from vio_register_driver\n", rc);
+		goto unregister_target;
+	}
+
+	return 0;
+
+unregister_target:
+	target_unregister_template(&ibmvscsis_ops);
+unregister_class:
+	class_unregister(&ibmvscsis_class);
+out:
+	return rc;
+}
+
+static void __exit ibmvscsis_exit(void)
+{
+	pr_info("Unregister IBM virtual SCSI host driver\n");
+	vio_unregister_driver(&ibmvscsis_driver);
+	target_unregister_template(&ibmvscsis_ops);
+	class_unregister(&ibmvscsis_class);
+}
+
+MODULE_DESCRIPTION("IBMVSCSIS fabric driver");
+MODULE_AUTHOR("Bryant G. Ly and Michael Cyr");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(IBMVSCSIS_VERSION);
+module_init(ibmvscsis_init);
+module_exit(ibmvscsis_exit);
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi_tgt.h b/drivers/scsi/ibmvscsi/ibmvscsi_tgt.h
new file mode 100644
index 0000000..9fc7e0e
--- /dev/null
+++ b/drivers/scsi/ibmvscsi/ibmvscsi_tgt.h
@@ -0,0 +1,347 @@
+/*******************************************************************************
+ * IBM Virtual SCSI Target Driver
+ * Copyright (C) 2003-2005 Dave Boutcher (boutcher@us.ibm.com) IBM Corp.
+ *			   Santiago Leon (santil@us.ibm.com) IBM Corp.
+ *			   Linda Xie (lxie@us.ibm.com) IBM Corp.
+ *
+ * Copyright (C) 2005-2011 FUJITA Tomonori <tomof@acm.org>
+ * Copyright (C) 2010 Nicholas A. Bellinger <nab@kernel.org>
+ * Copyright (C) 2016 Bryant G. Ly <bryantly@linux.vnet.ibm.com> IBM Corp.
+ *
+ * Authors: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
+ * Authors: Michael Cyr <mikecyr@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ ****************************************************************************/
+
+#ifndef __H_IBMVSCSI_TGT
+#define __H_IBMVSCSI_TGT
+
+#define SYS_ID_NAME_LEN		64
+#define PARTITION_NAMELEN	96
+#define IBMVSCSIS_NAMELEN       32
+
+#define MSG_HI  0
+#define MSG_LOW 1
+
+#define MAX_CMD_Q_PAGES       4
+#define CRQ_PER_PAGE          (PAGE_SIZE / sizeof(struct viosrp_crq))
+/* in terms of number of elements */
+#define DEFAULT_CMD_Q_SIZE    CRQ_PER_PAGE
+#define MAX_CMD_Q_SIZE        (DEFAULT_CMD_Q_SIZE * MAX_CMD_Q_PAGES)
+
+#define SRP_VIOLATION           0x102  /* general error code */
+
+/*
+ * SRP buffer formats defined as of 16.a supported by this driver.
+ */
+#define SUPPORTED_FORMATS  ((SRP_DATA_DESC_DIRECT << 1) | \
+			    (SRP_DATA_DESC_INDIRECT << 1))
+
+#define NO_SUCH_LUN ((u64)-1LL)
+
+enum scsi_lun_addr_method {
+	SCSI_LUN_ADDR_METHOD_PERIPHERAL   = 0,
+	SCSI_LUN_ADDR_METHOD_FLAT         = 1,
+	SCSI_LUN_ADDR_METHOD_LUN          = 2,
+	SCSI_LUN_ADDR_METHOD_EXTENDED_LUN = 3,
+};
+
+struct dma_window {
+	u32 liobn;	/* Unique per vdevice */
+	u64 tce_base;	/* Physical location of the TCE table */
+	u64 tce_size;	/* Size of the TCE table in bytes */
+};
+
+struct target_dds {
+	u64 unit_id;                /* 64 bit will force alignment */
+#define NUM_DMA_WINDOWS 2
+#define LOCAL  0
+#define REMOTE 1
+	struct dma_window  window[NUM_DMA_WINDOWS];
+
+	/* root node property "ibm,partition-no" */
+	uint partition_num;
+	char partition_name[PARTITION_NAMELEN];
+};
+
+#define MAX_NUM_PORTS        1
+#define MAX_H_COPY_RDMA      (128 * 1024)
+
+#define MAX_EYE   64
+
+/* Return codes */
+#define ADAPT_SUCCESS            0L
+/* choose error codes that do not conflict with PHYP */
+#define ERROR                   -40L
+
+struct format_code {
+	u8 reserved;
+	u8 buffers;
+};
+
+struct client_info {
+#define SRP_VERSION "16.a"
+	char srp_version[8];
+	/* root node property ibm,partition-name */
+	char partition_name[PARTITION_NAMELEN];
+	/* root node property ibm,partition-no */
+	u32 partition_number;
+	/* initially 1 */
+	u32 mad_version;
+	u32 os_type;
+};
+
+/*
+ * Changing this constant changes the number of seconds to wait before
+ * considering the client will never service its queue again.
+ */
+#define SECONDS_TO_CONSIDER_FAILED 30
+/*
+ * These constants set the polling period used to determine if the client
+ * has freed at least one element in the response queue.
+ */
+#define WAIT_SECONDS 1
+#define WAIT_NANO_SECONDS 5000
+#define MAX_TIMER_POPS ((1000000 / WAIT_NANO_SECONDS) * \
+			SECONDS_TO_CONSIDER_FAILED)
+/*
+ * general purpose timer control block
+ * which can be used for multiple functions
+ */
+struct timer_cb {
+	struct hrtimer timer;
+	/*
+	 * how long has it been since the client
+	 * serviced the queue. The variable is incrmented
+	 * in the service_wait_q routine and cleared
+	 * in send messages
+	 */
+	int timer_pops;
+	/* the timer is started */
+	bool started;
+};
+
+struct cmd_queue {
+	/* kva */
+	struct viosrp_crq *base_addr;
+	dma_addr_t crq_token;
+	/* used to maintain index */
+	uint mask;
+	/* current element */
+	uint index;
+	int size;
+};
+
+#define SCSOLNT_RESP_SHIFT	1
+#define UCSOLNT_RESP_SHIFT	2
+
+#define SCSOLNT         BIT(SCSOLNT_RESP_SHIFT)
+#define UCSOLNT         BIT(UCSOLNT_RESP_SHIFT)
+
+enum cmd_type {
+	SCSI_CDB	= 0x01,
+	TASK_MANAGEMENT	= 0x02,
+	/* MAD or addressed to port 0 */
+	ADAPTER_MAD	= 0x04,
+	UNSET_TYPE	= 0x08,
+};
+
+struct iu_rsp {
+	u8 format;
+	u8 sol_not;
+	u16 len;
+	/* tag is just to help client identify cmd, so don't translate be/le */
+	u64 tag;
+};
+
+struct ibmvscsis_cmd {
+	struct list_head list;
+	/* Used for TCM Core operations */
+	struct se_cmd se_cmd;
+	struct iu_entry *iue;
+	struct iu_rsp rsp;
+	struct work_struct work;
+	struct scsi_info *adapter;
+	/* Sense buffer that will be mapped into outgoing status */
+	unsigned char sense_buf[TRANSPORT_SENSE_BUFFER];
+	u64 init_time;
+#define CMD_FAST_FAIL	BIT(0)
+	u32 flags;
+	char type;
+};
+
+struct ibmvscsis_nexus {
+	struct se_session *se_sess;
+};
+
+struct ibmvscsis_tport {
+	/* SCSI protocol the tport is providing */
+	u8 tport_proto_id;
+	/* ASCII formatted WWPN for SRP Target port */
+	char tport_name[IBMVSCSIS_NAMELEN];
+	/* Returned by ibmvscsis_make_tport() */
+	struct se_wwn tport_wwn;
+	/* Returned by ibmvscsis_make_tpg() */
+	struct se_portal_group se_tpg;
+	/* ibmvscsis port target portal group tag for TCM */
+	u16 tport_tpgt;
+	/* Pointer to TCM session for I_T Nexus */
+	struct ibmvscsis_nexus *ibmv_nexus;
+	bool enabled;
+	bool releasing;
+};
+
+struct scsi_info {
+	struct list_head list;
+	char eye[MAX_EYE];
+
+	/* commands waiting for space on repsonse queue */
+	struct list_head waiting_rsp;
+#define NO_QUEUE                    0x00
+#define WAIT_ENABLED                0X01
+	/* driver has received an initialize command */
+#define PART_UP_WAIT_ENAB           0x02
+#define WAIT_CONNECTION             0x04
+	/* have established a connection */
+#define CONNECTED                   0x08
+	/* at least one port is processing SRP IU */
+#define SRP_PROCESSING              0x10
+	/* remove request received */
+#define UNCONFIGURING               0x20
+	/* disconnect by letting adapter go idle, no error */
+#define WAIT_IDLE                   0x40
+	/* disconnecting to clear an error */
+#define ERR_DISCONNECT              0x80
+	/* disconnect to clear error state, then come back up */
+#define ERR_DISCONNECT_RECONNECT    0x100
+	/* disconnected after clearing an error */
+#define ERR_DISCONNECTED            0x200
+	/* A series of errors caused unexpected errors */
+#define UNDEFINED                   0x400
+	u16  state;
+	int fast_fail;
+	struct target_dds dds;
+	char *cmd_pool;
+	/* list of free commands */
+	struct list_head free_cmd;
+	/* command elements ready for scheduler */
+	struct list_head schedule_q;
+	/* commands sent to TCM */
+	struct list_head active_q;
+	caddr_t *map_buf;
+	/* ioba of map buffer */
+	dma_addr_t map_ioba;
+	/* allowable number of outstanding SRP requests */
+	int request_limit;
+	/* extra credit */
+	int credit;
+	/* outstanding transactions against credit limit */
+	int debit;
+
+	/* allow only one outstanding mad request */
+#define PROCESSING_MAD                0x00002
+	/* Waiting to go idle */
+#define WAIT_FOR_IDLE		      0x00004
+	/* H_REG_CRQ called */
+#define CRQ_CLOSED                    0x00010
+	/* detected that client has failed */
+#define CLIENT_FAILED                 0x00040
+	/* detected that transport event occurred */
+#define TRANS_EVENT                   0x00080
+	/* don't attempt to send anything to the client */
+#define RESPONSE_Q_DOWN               0x00100
+	/* request made to schedule disconnect handler */
+#define SCHEDULE_DISCONNECT           0x00400
+	/* disconnect handler is scheduled */
+#define DISCONNECT_SCHEDULED          0x00800
+	u32 flags;
+	/* adapter lock */
+	spinlock_t intr_lock;
+	/* information needed to manage command queue */
+	struct cmd_queue cmd_q;
+	/* used in hcall to copy response back into srp buffer */
+	u64  empty_iu_id;
+	/* used in crq, to tag what iu the response is for */
+	u64  empty_iu_tag;
+	uint new_state;
+	/* control block for the response queue timer */
+	struct timer_cb rsp_q_timer;
+	/* keep last client to enable proper accounting */
+	struct client_info client_data;
+	/* what can this client do */
+	u32 client_cap;
+	/*
+	 * The following two fields capture state and flag changes that
+	 * can occur when the lock is given up.  In the orginal design,
+	 * the lock was held during calls into phyp;
+	 * however, phyp did not meet PAPR architecture.  This is
+	 * a work around.
+	 */
+	u16  phyp_acr_state;
+	u32 phyp_acr_flags;
+
+	struct workqueue_struct *work_q;
+	struct completion wait_idle;
+	struct device dev;
+	struct vio_dev *dma_dev;
+	struct srp_target target;
+	struct ibmvscsis_tport tport;
+	struct tasklet_struct work_task;
+	struct work_struct proc_work;
+};
+
+/*
+ * Provide a constant that allows software to detect the adapter is
+ * disconnecting from the client from one of several states.
+ */
+#define IS_DISCONNECTING (UNCONFIGURING | ERR_DISCONNECT_RECONNECT | \
+			  ERR_DISCONNECT)
+
+/*
+ * Provide a constant that can be used with interrupt handling that
+ * essentially lets the interrupt handler know that all requests should
+ * be thrown out,
+ */
+#define DONT_PROCESS_STATE (IS_DISCONNECTING | UNDEFINED | \
+			    ERR_DISCONNECTED  | WAIT_IDLE)
+
+/*
+ * If any of these flag bits are set then do not allow the interrupt
+ * handler to schedule the off level handler.
+ */
+#define BLOCK (DISCONNECT_SCHEDULED)
+
+/* State and transition events that stop the interrupt handler */
+#define TARGET_STOP(VSCSI) (long)(((VSCSI)->state & DONT_PROCESS_STATE) | \
+				  ((VSCSI)->flags & BLOCK))
+
+/* flag bit that are not reset during disconnect */
+#define PRESERVE_FLAG_FIELDS 0
+
+#define vio_iu(IUE) ((union viosrp_iu *)((IUE)->sbuf->buf))
+
+#define READ_CMD(cdb)	(((cdb)[0] & 0x1F) == 8)
+#define WRITE_CMD(cdb)	(((cdb)[0] & 0x1F) == 0xA)
+
+#define h_copy_rdma(l, sa, sb, da, db) \
+		plpar_hcall_norets(H_COPY_RDMA, l, sa, sb, da, db)
+#define h_vioctl(u, o, a, u1, u2, u3, u4) \
+		plpar_hcall_norets(H_VIOCTL, u, o, a, u1, u2)
+#define h_reg_crq(ua, tok, sz) \
+		plpar_hcall_norets(H_REG_CRQ, ua, tok, sz)
+#define h_free_crq(ua) \
+		plpar_hcall_norets(H_FREE_CRQ, ua)
+#define h_send_crq(ua, d1, d2) \
+		plpar_hcall_norets(H_SEND_CRQ, ua, d1, d2)
+
+#endif
diff --git a/drivers/scsi/ibmvscsi/libsrp.c b/drivers/scsi/ibmvscsi/libsrp.c
new file mode 100644
index 0000000..5a4cc28
--- /dev/null
+++ b/drivers/scsi/ibmvscsi/libsrp.c
@@ -0,0 +1,427 @@
+/*******************************************************************************
+ * SCSI RDMA Protocol lib functions
+ *
+ * Copyright (C) 2006 FUJITA Tomonori <tomof@acm.org>
+ * Copyright (C) 2016 Bryant G. Ly <bryantly@linux.vnet.ibm.com> IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ ***********************************************************************/
+
+#define pr_fmt(fmt)	"libsrp: " fmt
+
+#include <linux/printk.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/kfifo.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include <scsi/srp.h>
+#include <target/target_core_base.h>
+#include "libsrp.h"
+#include "ibmvscsi_tgt.h"
+
+static int srp_iu_pool_alloc(struct srp_queue *q, size_t max,
+			     struct srp_buf **ring)
+{
+	struct iu_entry *iue;
+	int i;
+
+	q->pool = kcalloc(max, sizeof(struct iu_entry *), GFP_KERNEL);
+	if (!q->pool)
+		return -ENOMEM;
+	q->items = kcalloc(max, sizeof(struct iu_entry), GFP_KERNEL);
+	if (!q->items)
+		goto free_pool;
+
+	spin_lock_init(&q->lock);
+	kfifo_init(&q->queue, (void *)q->pool, max * sizeof(void *));
+
+	for (i = 0, iue = q->items; i < max; i++) {
+		kfifo_in(&q->queue, (void *)&iue, sizeof(void *));
+		iue->sbuf = ring[i];
+		iue++;
+	}
+	return 0;
+
+free_pool:
+	kfree(q->pool);
+	return -ENOMEM;
+}
+
+static void srp_iu_pool_free(struct srp_queue *q)
+{
+	kfree(q->items);
+	kfree(q->pool);
+}
+
+static struct srp_buf **srp_ring_alloc(struct device *dev,
+				       size_t max, size_t size)
+{
+	struct srp_buf **ring;
+	int i;
+
+	ring = kcalloc(max, sizeof(struct srp_buf *), GFP_KERNEL);
+	if (!ring)
+		return NULL;
+
+	for (i = 0; i < max; i++) {
+		ring[i] = kzalloc(sizeof(*ring[i]), GFP_KERNEL);
+		if (!ring[i])
+			goto out;
+		ring[i]->buf = dma_alloc_coherent(dev, size, &ring[i]->dma,
+						  GFP_KERNEL);
+		if (!ring[i]->buf)
+			goto out;
+	}
+	return ring;
+
+out:
+	for (i = 0; i < max && ring[i]; i++) {
+		if (ring[i]->buf) {
+			dma_free_coherent(dev, size, ring[i]->buf,
+					  ring[i]->dma);
+		}
+		kfree(ring[i]);
+	}
+	kfree(ring);
+
+	return NULL;
+}
+
+static void srp_ring_free(struct device *dev, struct srp_buf **ring,
+			  size_t max, size_t size)
+{
+	int i;
+
+	for (i = 0; i < max; i++) {
+		dma_free_coherent(dev, size, ring[i]->buf, ring[i]->dma);
+		kfree(ring[i]);
+	}
+	kfree(ring);
+}
+
+int srp_target_alloc(struct srp_target *target, struct device *dev,
+		     size_t nr, size_t iu_size)
+{
+	int err;
+
+	spin_lock_init(&target->lock);
+
+	target->dev = dev;
+
+	target->srp_iu_size = iu_size;
+	target->rx_ring_size = nr;
+	target->rx_ring = srp_ring_alloc(target->dev, nr, iu_size);
+	if (!target->rx_ring)
+		return -ENOMEM;
+	err = srp_iu_pool_alloc(&target->iu_queue, nr, target->rx_ring);
+	if (err)
+		goto free_ring;
+
+	dev_set_drvdata(target->dev, target);
+	return 0;
+
+free_ring:
+	srp_ring_free(target->dev, target->rx_ring, nr, iu_size);
+	return -ENOMEM;
+}
+
+void srp_target_free(struct srp_target *target)
+{
+	dev_set_drvdata(target->dev, NULL);
+	srp_ring_free(target->dev, target->rx_ring, target->rx_ring_size,
+		      target->srp_iu_size);
+	srp_iu_pool_free(&target->iu_queue);
+}
+
+struct iu_entry *srp_iu_get(struct srp_target *target)
+{
+	struct iu_entry *iue = NULL;
+
+	if (kfifo_out_locked(&target->iu_queue.queue, (void *)&iue,
+			     sizeof(void *),
+			     &target->iu_queue.lock) != sizeof(void *)) {
+		WARN_ONCE(1, "unexpected fifo state");
+		return NULL;
+	}
+	if (!iue)
+		return iue;
+	iue->target = target;
+	iue->flags = 0;
+	return iue;
+}
+
+void srp_iu_put(struct iu_entry *iue)
+{
+	kfifo_in_locked(&iue->target->iu_queue.queue, (void *)&iue,
+			sizeof(void *), &iue->target->iu_queue.lock);
+}
+
+static int srp_direct_data(struct ibmvscsis_cmd *cmd, struct srp_direct_buf *md,
+			   enum dma_data_direction dir, srp_rdma_t rdma_io,
+			   int dma_map, int ext_desc)
+{
+	struct iu_entry *iue = NULL;
+	struct scatterlist *sg = NULL;
+	int err, nsg = 0, len;
+
+	if (dma_map) {
+		iue = cmd->iue;
+		sg = cmd->se_cmd.t_data_sg;
+		nsg = dma_map_sg(iue->target->dev, sg, cmd->se_cmd.t_data_nents,
+				 DMA_BIDIRECTIONAL);
+		if (!nsg) {
+			pr_err("fail to map %p %d\n", iue,
+			       cmd->se_cmd.t_data_nents);
+			return 0;
+		}
+		len = min(cmd->se_cmd.data_length, be32_to_cpu(md->len));
+	} else {
+		len = be32_to_cpu(md->len);
+	}
+
+	err = rdma_io(cmd, sg, nsg, md, 1, dir, len);
+
+	if (dma_map)
+		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
+
+	return err;
+}
+
+static int srp_indirect_data(struct ibmvscsis_cmd *cmd, struct srp_cmd *srp_cmd,
+			     struct srp_indirect_buf *id,
+			     enum dma_data_direction dir, srp_rdma_t rdma_io,
+			     int dma_map, int ext_desc)
+{
+	struct iu_entry *iue = NULL;
+	struct srp_direct_buf *md = NULL;
+	struct scatterlist dummy, *sg = NULL;
+	dma_addr_t token = 0;
+	int err = 0;
+	int nmd, nsg = 0, len;
+
+	if (dma_map || ext_desc) {
+		iue = cmd->iue;
+		sg = cmd->se_cmd.t_data_sg;
+	}
+
+	nmd = be32_to_cpu(id->table_desc.len) / sizeof(struct srp_direct_buf);
+
+	if ((dir == DMA_FROM_DEVICE && nmd == srp_cmd->data_in_desc_cnt) ||
+	    (dir == DMA_TO_DEVICE && nmd == srp_cmd->data_out_desc_cnt)) {
+		md = &id->desc_list[0];
+		goto rdma;
+	}
+
+	if (ext_desc && dma_map) {
+		md = dma_alloc_coherent(iue->target->dev,
+					be32_to_cpu(id->table_desc.len),
+					&token, GFP_KERNEL);
+		if (!md) {
+			pr_err("Can't get dma memory %u\n",
+			       be32_to_cpu(id->table_desc.len));
+			return -ENOMEM;
+		}
+
+		sg_init_one(&dummy, md, be32_to_cpu(id->table_desc.len));
+		sg_dma_address(&dummy) = token;
+		sg_dma_len(&dummy) = be32_to_cpu(id->table_desc.len);
+		err = rdma_io(cmd, &dummy, 1, &id->table_desc, 1, DMA_TO_DEVICE,
+			      be32_to_cpu(id->table_desc.len));
+		if (err) {
+			pr_err("Error copying indirect table %d\n", err);
+			goto free_mem;
+		}
+	} else {
+		pr_err("This command uses external indirect buffer\n");
+		return -EINVAL;
+	}
+
+rdma:
+	if (dma_map) {
+		nsg = dma_map_sg(iue->target->dev, sg, cmd->se_cmd.t_data_nents,
+				 DMA_BIDIRECTIONAL);
+		if (!nsg) {
+			pr_err("fail to map %p %d\n", iue,
+			       cmd->se_cmd.t_data_nents);
+			err = -EIO;
+			goto free_mem;
+		}
+		len = min(cmd->se_cmd.data_length, be32_to_cpu(id->len));
+	} else {
+		len = be32_to_cpu(id->len);
+	}
+
+	err = rdma_io(cmd, sg, nsg, md, nmd, dir, len);
+
+	if (dma_map)
+		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
+
+free_mem:
+	if (token && dma_map) {
+		dma_free_coherent(iue->target->dev,
+				  be32_to_cpu(id->table_desc.len), md, token);
+	}
+	return err;
+}
+
+static int data_out_desc_size(struct srp_cmd *cmd)
+{
+	int size = 0;
+	u8 fmt = cmd->buf_fmt >> 4;
+
+	switch (fmt) {
+	case SRP_NO_DATA_DESC:
+		break;
+	case SRP_DATA_DESC_DIRECT:
+		size = sizeof(struct srp_direct_buf);
+		break;
+	case SRP_DATA_DESC_INDIRECT:
+		size = sizeof(struct srp_indirect_buf) +
+			sizeof(struct srp_direct_buf) * cmd->data_out_desc_cnt;
+		break;
+	default:
+		pr_err("client error. Invalid data_out_format %x\n", fmt);
+		break;
+	}
+	return size;
+}
+
+/*
+ * TODO: this can be called multiple times for a single command if it
+ * has very long data.
+ */
+int srp_transfer_data(struct ibmvscsis_cmd *cmd, struct srp_cmd *srp_cmd,
+		      srp_rdma_t rdma_io, int dma_map, int ext_desc)
+{
+	struct srp_direct_buf *md;
+	struct srp_indirect_buf *id;
+	enum dma_data_direction dir;
+	int offset, err = 0;
+	u8 format;
+
+	if (!cmd->se_cmd.t_data_nents)
+		return 0;
+
+	offset = srp_cmd->add_cdb_len & ~3;
+
+	dir = srp_cmd_direction(srp_cmd);
+	if (dir == DMA_FROM_DEVICE)
+		offset += data_out_desc_size(srp_cmd);
+
+	if (dir == DMA_TO_DEVICE)
+		format = srp_cmd->buf_fmt >> 4;
+	else
+		format = srp_cmd->buf_fmt & ((1U << 4) - 1);
+
+	switch (format) {
+	case SRP_NO_DATA_DESC:
+		break;
+	case SRP_DATA_DESC_DIRECT:
+		md = (struct srp_direct_buf *)(srp_cmd->add_data + offset);
+		err = srp_direct_data(cmd, md, dir, rdma_io, dma_map, ext_desc);
+		break;
+	case SRP_DATA_DESC_INDIRECT:
+		id = (struct srp_indirect_buf *)(srp_cmd->add_data + offset);
+		err = srp_indirect_data(cmd, srp_cmd, id, dir, rdma_io, dma_map,
+					ext_desc);
+		break;
+	default:
+		pr_err("Unknown format %d %x\n", dir, format);
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
+u64 srp_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
+{
+	struct srp_direct_buf *md;
+	struct srp_indirect_buf *id;
+	u64 len = 0;
+	uint offset = cmd->add_cdb_len & ~3;
+	u8 fmt;
+
+	if (dir == DMA_TO_DEVICE) {
+		fmt = cmd->buf_fmt >> 4;
+	} else {
+		fmt = cmd->buf_fmt & ((1U << 4) - 1);
+		offset += data_out_desc_size(cmd);
+	}
+
+	switch (fmt) {
+	case SRP_NO_DATA_DESC:
+		break;
+	case SRP_DATA_DESC_DIRECT:
+		md = (struct srp_direct_buf *)(cmd->add_data + offset);
+		len = be32_to_cpu(md->len);
+		break;
+	case SRP_DATA_DESC_INDIRECT:
+		id = (struct srp_indirect_buf *)(cmd->add_data + offset);
+		len = be32_to_cpu(id->len);
+		break;
+	default:
+		pr_err("invalid data format %x\n", fmt);
+		break;
+	}
+	return len;
+}
+
+int srp_get_desc_table(struct srp_cmd *srp_cmd, enum dma_data_direction *dir,
+		       u64 *data_len)
+{
+	struct srp_indirect_buf *idb;
+	struct srp_direct_buf *db;
+	uint add_cdb_offset;
+	int rc;
+
+	/*
+	 * The pointer computations below will only be compiled correctly
+	 * if srp_cmd::add_data is declared as s8*, u8*, s8[] or u8[], so check
+	 * whether srp_cmd::add_data has been declared as a byte pointer.
+	 */
+	BUILD_BUG_ON(!__same_type(srp_cmd->add_data[0], (s8)0)
+		     && !__same_type(srp_cmd->add_data[0], (u8)0));
+
+	BUG_ON(!dir);
+	BUG_ON(!data_len);
+
+	rc = 0;
+	*data_len = 0;
+
+	*dir = DMA_NONE;
+
+	if (srp_cmd->buf_fmt & 0xf)
+		*dir = DMA_FROM_DEVICE;
+	else if (srp_cmd->buf_fmt >> 4)
+		*dir = DMA_TO_DEVICE;
+
+	add_cdb_offset = srp_cmd->add_cdb_len & ~3;
+	if (((srp_cmd->buf_fmt & 0xf) == SRP_DATA_DESC_DIRECT) ||
+	    ((srp_cmd->buf_fmt >> 4) == SRP_DATA_DESC_DIRECT)) {
+		db = (struct srp_direct_buf *)(srp_cmd->add_data
+					       + add_cdb_offset);
+		*data_len = be32_to_cpu(db->len);
+	} else if (((srp_cmd->buf_fmt & 0xf) == SRP_DATA_DESC_INDIRECT) ||
+		   ((srp_cmd->buf_fmt >> 4) == SRP_DATA_DESC_INDIRECT)) {
+		idb = (struct srp_indirect_buf *)(srp_cmd->add_data
+						  + add_cdb_offset);
+
+		*data_len = be32_to_cpu(idb->len);
+	}
+	return rc;
+}
+
+MODULE_DESCRIPTION("SCSI RDMA Protocol lib functions");
+MODULE_AUTHOR("FUJITA Tomonori");
+MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/ibmvscsi/libsrp.h b/drivers/scsi/ibmvscsi/libsrp.h
new file mode 100644
index 0000000..4696f33
--- /dev/null
+++ b/drivers/scsi/ibmvscsi/libsrp.h
@@ -0,0 +1,123 @@
+#ifndef __LIBSRP_H__
+#define __LIBSRP_H__
+
+#include <linux/list.h>
+#include <linux/kfifo.h>
+#include <scsi/srp.h>
+
+enum srp_valid {
+	INVALIDATE_CMD_RESP_EL = 0,
+	VALID_CMD_RESP_EL = 0x80,
+	VALID_INIT_MSG = 0xC0,
+	VALID_TRANS_EVENT = 0xFF
+};
+
+enum srp_format {
+	SRP_FORMAT = 1,
+	MAD_FORMAT = 2,
+	OS400_FORMAT = 3,
+	AIX_FORMAT = 4,
+	LINUX_FORMAT = 5,
+	MESSAGE_IN_CRQ = 6
+};
+
+enum srp_init_msg {
+	INIT_MSG = 1,
+	INIT_COMPLETE_MSG = 2
+};
+
+enum srp_trans_event {
+	UNUSED_FORMAT = 0,
+	PARTNER_FAILED = 1,
+	PARTNER_DEREGISTER = 2,
+	MIGRATED = 6
+};
+
+enum srp_status {
+	HEADER_DESCRIPTOR = 0xF1,
+	PING = 0xF5,
+	PING_RESPONSE = 0xF6
+};
+
+enum srp_mad_version {
+	MAD_VERSION_1 = 1
+};
+
+enum srp_os_type {
+	OS400 = 1,
+	LINUX = 2,
+	AIX = 3,
+	OFW = 4
+};
+
+enum srp_task_attributes {
+	SRP_SIMPLE_TASK = 0,
+	SRP_HEAD_TASK = 1,
+	SRP_ORDERED_TASK = 2,
+	SRP_ACA_TASK = 4
+};
+
+enum {
+	SRP_TASK_MANAGEMENT_FUNCTION_COMPLETE           = 0,
+	SRP_REQUEST_FIELDS_INVALID                      = 2,
+	SRP_TASK_MANAGEMENT_FUNCTION_NOT_SUPPORTED      = 4,
+	SRP_TASK_MANAGEMENT_FUNCTION_FAILED             = 5
+};
+
+struct srp_buf {
+	dma_addr_t dma;
+	void *buf;
+};
+
+struct srp_queue {
+	void *pool;
+	void *items;
+	struct kfifo queue;
+	spinlock_t lock;
+};
+
+struct srp_target {
+	struct device *dev;
+
+	spinlock_t lock;
+	struct list_head cmd_queue;
+
+	size_t srp_iu_size;
+	struct srp_queue iu_queue;
+	size_t rx_ring_size;
+	struct srp_buf **rx_ring;
+
+	void *ldata;
+};
+
+struct iu_entry {
+	struct srp_target *target;
+
+	struct list_head ilist;
+	dma_addr_t remote_token;
+	unsigned long flags;
+
+	struct srp_buf *sbuf;
+	u16 iu_len;
+};
+
+struct ibmvscsis_cmd;
+
+typedef int (srp_rdma_t)(struct ibmvscsis_cmd *, struct scatterlist *, int,
+			 struct srp_direct_buf *, int,
+			 enum dma_data_direction, unsigned int);
+int srp_target_alloc(struct srp_target *, struct device *, size_t, size_t);
+void srp_target_free(struct srp_target *);
+struct iu_entry *srp_iu_get(struct srp_target *);
+void srp_iu_put(struct iu_entry *);
+int srp_transfer_data(struct ibmvscsis_cmd *, struct srp_cmd *,
+		      srp_rdma_t, int, int);
+u64 srp_data_length(struct srp_cmd *cmd, enum dma_data_direction dir);
+int srp_get_desc_table(struct srp_cmd *srp_cmd, enum dma_data_direction *dir,
+		       u64 *data_len);
+static inline int srp_cmd_direction(struct srp_cmd *cmd)
+{
+	return (cmd->buf_fmt >> 4) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+}
+
+#endif
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
deleted file mode 100644
index 0707ecd..0000000
--- a/drivers/scsi/libsrp.c
+++ /dev/null
@@ -1,447 +0,0 @@
-/*
- * SCSI RDMA Protocol lib functions
- *
- * Copyright (C) 2006 FUJITA Tomonori <tomof@acm.org>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation; either version 2 of the
- * License, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- */
-#include <linux/err.h>
-#include <linux/slab.h>
-#include <linux/kfifo.h>
-#include <linux/scatterlist.h>
-#include <linux/dma-mapping.h>
-#include <linux/module.h>
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_tcq.h>
-#include <scsi/scsi_tgt.h>
-#include <scsi/srp.h>
-#include <scsi/libsrp.h>
-
-enum srp_task_attributes {
-	SRP_SIMPLE_TASK = 0,
-	SRP_HEAD_TASK = 1,
-	SRP_ORDERED_TASK = 2,
-	SRP_ACA_TASK = 4
-};
-
-/* tmp - will replace with SCSI logging stuff */
-#define eprintk(fmt, args...)					\
-do {								\
-	printk("%s(%d) " fmt, __func__, __LINE__, ##args);	\
-} while (0)
-/* #define dprintk eprintk */
-#define dprintk(fmt, args...)
-
-static int srp_iu_pool_alloc(struct srp_queue *q, size_t max,
-			     struct srp_buf **ring)
-{
-	int i;
-	struct iu_entry *iue;
-
-	q->pool = kcalloc(max, sizeof(struct iu_entry *), GFP_KERNEL);
-	if (!q->pool)
-		return -ENOMEM;
-	q->items = kcalloc(max, sizeof(struct iu_entry), GFP_KERNEL);
-	if (!q->items)
-		goto free_pool;
-
-	spin_lock_init(&q->lock);
-	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *));
-
-	for (i = 0, iue = q->items; i < max; i++) {
-		kfifo_in(&q->queue, (void *) &iue, sizeof(void *));
-		iue->sbuf = ring[i];
-		iue++;
-	}
-	return 0;
-
-	kfree(q->items);
-free_pool:
-	kfree(q->pool);
-	return -ENOMEM;
-}
-
-static void srp_iu_pool_free(struct srp_queue *q)
-{
-	kfree(q->items);
-	kfree(q->pool);
-}
-
-static struct srp_buf **srp_ring_alloc(struct device *dev,
-				       size_t max, size_t size)
-{
-	int i;
-	struct srp_buf **ring;
-
-	ring = kcalloc(max, sizeof(struct srp_buf *), GFP_KERNEL);
-	if (!ring)
-		return NULL;
-
-	for (i = 0; i < max; i++) {
-		ring[i] = kzalloc(sizeof(struct srp_buf), GFP_KERNEL);
-		if (!ring[i])
-			goto out;
-		ring[i]->buf = dma_alloc_coherent(dev, size, &ring[i]->dma,
-						  GFP_KERNEL);
-		if (!ring[i]->buf)
-			goto out;
-	}
-	return ring;
-
-out:
-	for (i = 0; i < max && ring[i]; i++) {
-		if (ring[i]->buf)
-			dma_free_coherent(dev, size, ring[i]->buf, ring[i]->dma);
-		kfree(ring[i]);
-	}
-	kfree(ring);
-
-	return NULL;
-}
-
-static void srp_ring_free(struct device *dev, struct srp_buf **ring, size_t max,
-			  size_t size)
-{
-	int i;
-
-	for (i = 0; i < max; i++) {
-		dma_free_coherent(dev, size, ring[i]->buf, ring[i]->dma);
-		kfree(ring[i]);
-	}
-	kfree(ring);
-}
-
-int srp_target_alloc(struct srp_target *target, struct device *dev,
-		     size_t nr, size_t iu_size)
-{
-	int err;
-
-	spin_lock_init(&target->lock);
-	INIT_LIST_HEAD(&target->cmd_queue);
-
-	target->dev = dev;
-	dev_set_drvdata(target->dev, target);
-
-	target->srp_iu_size = iu_size;
-	target->rx_ring_size = nr;
-	target->rx_ring = srp_ring_alloc(target->dev, nr, iu_size);
-	if (!target->rx_ring)
-		return -ENOMEM;
-	err = srp_iu_pool_alloc(&target->iu_queue, nr, target->rx_ring);
-	if (err)
-		goto free_ring;
-
-	return 0;
-
-free_ring:
-	srp_ring_free(target->dev, target->rx_ring, nr, iu_size);
-	return -ENOMEM;
-}
-EXPORT_SYMBOL_GPL(srp_target_alloc);
-
-void srp_target_free(struct srp_target *target)
-{
-	srp_ring_free(target->dev, target->rx_ring, target->rx_ring_size,
-		      target->srp_iu_size);
-	srp_iu_pool_free(&target->iu_queue);
-}
-EXPORT_SYMBOL_GPL(srp_target_free);
-
-struct iu_entry *srp_iu_get(struct srp_target *target)
-{
-	struct iu_entry *iue = NULL;
-
-	if (kfifo_out_locked(&target->iu_queue.queue, (void *) &iue,
-		sizeof(void *), &target->iu_queue.lock) != sizeof(void *)) {
-			WARN_ONCE(1, "unexpected fifo state");
-			return NULL;
-	}
-	if (!iue)
-		return iue;
-	iue->target = target;
-	INIT_LIST_HEAD(&iue->ilist);
-	iue->flags = 0;
-	return iue;
-}
-EXPORT_SYMBOL_GPL(srp_iu_get);
-
-void srp_iu_put(struct iu_entry *iue)
-{
-	kfifo_in_locked(&iue->target->iu_queue.queue, (void *) &iue,
-			sizeof(void *), &iue->target->iu_queue.lock);
-}
-EXPORT_SYMBOL_GPL(srp_iu_put);
-
-static int srp_direct_data(struct scsi_cmnd *sc, struct srp_direct_buf *md,
-			   enum dma_data_direction dir, srp_rdma_t rdma_io,
-			   int dma_map, int ext_desc)
-{
-	struct iu_entry *iue = NULL;
-	struct scatterlist *sg = NULL;
-	int err, nsg = 0, len;
-
-	if (dma_map) {
-		iue = (struct iu_entry *) sc->SCp.ptr;
-		sg = scsi_sglist(sc);
-
-		dprintk("%p %u %u %d\n", iue, scsi_bufflen(sc),
-			md->len, scsi_sg_count(sc));
-
-		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
-				 DMA_BIDIRECTIONAL);
-		if (!nsg) {
-			printk("fail to map %p %d\n", iue, scsi_sg_count(sc));
-			return 0;
-		}
-		len = min(scsi_bufflen(sc), md->len);
-	} else
-		len = md->len;
-
-	err = rdma_io(sc, sg, nsg, md, 1, dir, len);
-
-	if (dma_map)
-		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
-
-	return err;
-}
-
-static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
-			     struct srp_indirect_buf *id,
-			     enum dma_data_direction dir, srp_rdma_t rdma_io,
-			     int dma_map, int ext_desc)
-{
-	struct iu_entry *iue = NULL;
-	struct srp_direct_buf *md = NULL;
-	struct scatterlist dummy, *sg = NULL;
-	dma_addr_t token = 0;
-	int err = 0;
-	int nmd, nsg = 0, len;
-
-	if (dma_map || ext_desc) {
-		iue = (struct iu_entry *) sc->SCp.ptr;
-		sg = scsi_sglist(sc);
-
-		dprintk("%p %u %u %d %d\n",
-			iue, scsi_bufflen(sc), id->len,
-			cmd->data_in_desc_cnt, cmd->data_out_desc_cnt);
-	}
-
-	nmd = id->table_desc.len / sizeof(struct srp_direct_buf);
-
-	if ((dir == DMA_FROM_DEVICE && nmd == cmd->data_in_desc_cnt) ||
-	    (dir == DMA_TO_DEVICE && nmd == cmd->data_out_desc_cnt)) {
-		md = &id->desc_list[0];
-		goto rdma;
-	}
-
-	if (ext_desc && dma_map) {
-		md = dma_alloc_coherent(iue->target->dev, id->table_desc.len,
-				&token, GFP_KERNEL);
-		if (!md) {
-			eprintk("Can't get dma memory %u\n", id->table_desc.len);
-			return -ENOMEM;
-		}
-
-		sg_init_one(&dummy, md, id->table_desc.len);
-		sg_dma_address(&dummy) = token;
-		sg_dma_len(&dummy) = id->table_desc.len;
-		err = rdma_io(sc, &dummy, 1, &id->table_desc, 1, DMA_TO_DEVICE,
-			      id->table_desc.len);
-		if (err) {
-			eprintk("Error copying indirect table %d\n", err);
-			goto free_mem;
-		}
-	} else {
-		eprintk("This command uses external indirect buffer\n");
-		return -EINVAL;
-	}
-
-rdma:
-	if (dma_map) {
-		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
-				 DMA_BIDIRECTIONAL);
-		if (!nsg) {
-			eprintk("fail to map %p %d\n", iue, scsi_sg_count(sc));
-			err = -EIO;
-			goto free_mem;
-		}
-		len = min(scsi_bufflen(sc), id->len);
-	} else
-		len = id->len;
-
-	err = rdma_io(sc, sg, nsg, md, nmd, dir, len);
-
-	if (dma_map)
-		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
-
-free_mem:
-	if (token && dma_map)
-		dma_free_coherent(iue->target->dev, id->table_desc.len, md, token);
-
-	return err;
-}
-
-static int data_out_desc_size(struct srp_cmd *cmd)
-{
-	int size = 0;
-	u8 fmt = cmd->buf_fmt >> 4;
-
-	switch (fmt) {
-	case SRP_NO_DATA_DESC:
-		break;
-	case SRP_DATA_DESC_DIRECT:
-		size = sizeof(struct srp_direct_buf);
-		break;
-	case SRP_DATA_DESC_INDIRECT:
-		size = sizeof(struct srp_indirect_buf) +
-			sizeof(struct srp_direct_buf) * cmd->data_out_desc_cnt;
-		break;
-	default:
-		eprintk("client error. Invalid data_out_format %x\n", fmt);
-		break;
-	}
-	return size;
-}
-
-/*
- * TODO: this can be called multiple times for a single command if it
- * has very long data.
- */
-int srp_transfer_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
-		      srp_rdma_t rdma_io, int dma_map, int ext_desc)
-{
-	struct srp_direct_buf *md;
-	struct srp_indirect_buf *id;
-	enum dma_data_direction dir;
-	int offset, err = 0;
-	u8 format;
-
-	offset = cmd->add_cdb_len & ~3;
-
-	dir = srp_cmd_direction(cmd);
-	if (dir == DMA_FROM_DEVICE)
-		offset += data_out_desc_size(cmd);
-
-	if (dir == DMA_TO_DEVICE)
-		format = cmd->buf_fmt >> 4;
-	else
-		format = cmd->buf_fmt & ((1U << 4) - 1);
-
-	switch (format) {
-	case SRP_NO_DATA_DESC:
-		break;
-	case SRP_DATA_DESC_DIRECT:
-		md = (struct srp_direct_buf *)
-			(cmd->add_data + offset);
-		err = srp_direct_data(sc, md, dir, rdma_io, dma_map, ext_desc);
-		break;
-	case SRP_DATA_DESC_INDIRECT:
-		id = (struct srp_indirect_buf *)
-			(cmd->add_data + offset);
-		err = srp_indirect_data(sc, cmd, id, dir, rdma_io, dma_map,
-					ext_desc);
-		break;
-	default:
-		eprintk("Unknown format %d %x\n", dir, format);
-		err = -EINVAL;
-	}
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(srp_transfer_data);
-
-static int vscsis_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
-{
-	struct srp_direct_buf *md;
-	struct srp_indirect_buf *id;
-	int len = 0, offset = cmd->add_cdb_len & ~3;
-	u8 fmt;
-
-	if (dir == DMA_TO_DEVICE)
-		fmt = cmd->buf_fmt >> 4;
-	else {
-		fmt = cmd->buf_fmt & ((1U << 4) - 1);
-		offset += data_out_desc_size(cmd);
-	}
-
-	switch (fmt) {
-	case SRP_NO_DATA_DESC:
-		break;
-	case SRP_DATA_DESC_DIRECT:
-		md = (struct srp_direct_buf *) (cmd->add_data + offset);
-		len = md->len;
-		break;
-	case SRP_DATA_DESC_INDIRECT:
-		id = (struct srp_indirect_buf *) (cmd->add_data + offset);
-		len = id->len;
-		break;
-	default:
-		eprintk("invalid data format %x\n", fmt);
-		break;
-	}
-	return len;
-}
-
-int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
-		  u64 itn_id, u64 addr)
-{
-	enum dma_data_direction dir;
-	struct scsi_cmnd *sc;
-	int tag, len, err;
-
-	switch (cmd->task_attr) {
-	case SRP_SIMPLE_TASK:
-		tag = MSG_SIMPLE_TAG;
-		break;
-	case SRP_ORDERED_TASK:
-		tag = MSG_ORDERED_TAG;
-		break;
-	case SRP_HEAD_TASK:
-		tag = MSG_HEAD_TAG;
-		break;
-	default:
-		eprintk("Task attribute %d not supported\n", cmd->task_attr);
-		tag = MSG_ORDERED_TAG;
-	}
-
-	dir = srp_cmd_direction(cmd);
-	len = vscsis_data_length(cmd, dir);
-
-	dprintk("%p %x %lx %d %d %d %llx\n", info, cmd->cdb[0],
-		cmd->lun, dir, len, tag, (unsigned long long) cmd->tag);
-
-	sc = scsi_host_get_command(shost, dir, GFP_KERNEL);
-	if (!sc)
-		return -ENOMEM;
-
-	sc->SCp.ptr = info;
-	memcpy(sc->cmnd, cmd->cdb, MAX_COMMAND_SIZE);
-	sc->sdb.length = len;
-	sc->sdb.table.sgl = (void *) (unsigned long) addr;
-	sc->tag = tag;
-	err = scsi_tgt_queue_command(sc, itn_id, (struct scsi_lun *)&cmd->lun,
-				     cmd->tag);
-	if (err)
-		scsi_host_put_command(shost, sc);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(srp_cmd_queue);
-
-MODULE_DESCRIPTION("SCSI RDMA Protocol lib functions");
-MODULE_AUTHOR("FUJITA Tomonori");
-MODULE_LICENSE("GPL");
diff --git a/include/scsi/libsrp.h b/include/scsi/libsrp.h
deleted file mode 100644
index f4105c9..0000000
--- a/include/scsi/libsrp.h
+++ /dev/null
@@ -1,78 +0,0 @@
-#ifndef __LIBSRP_H__
-#define __LIBSRP_H__
-
-#include <linux/list.h>
-#include <linux/kfifo.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_host.h>
-#include <scsi/srp.h>
-
-enum iue_flags {
-	V_DIOVER,
-	V_WRITE,
-	V_LINKED,
-	V_FLYING,
-};
-
-struct srp_buf {
-	dma_addr_t dma;
-	void *buf;
-};
-
-struct srp_queue {
-	void *pool;
-	void *items;
-	struct kfifo queue;
-	spinlock_t lock;
-};
-
-struct srp_target {
-	struct Scsi_Host *shost;
-	struct device *dev;
-
-	spinlock_t lock;
-	struct list_head cmd_queue;
-
-	size_t srp_iu_size;
-	struct srp_queue iu_queue;
-	size_t rx_ring_size;
-	struct srp_buf **rx_ring;
-
-	void *ldata;
-};
-
-struct iu_entry {
-	struct srp_target *target;
-
-	struct list_head ilist;
-	dma_addr_t remote_token;
-	unsigned long flags;
-
-	struct srp_buf *sbuf;
-};
-
-typedef int (srp_rdma_t)(struct scsi_cmnd *, struct scatterlist *, int,
-			 struct srp_direct_buf *, int,
-			 enum dma_data_direction, unsigned int);
-extern int srp_target_alloc(struct srp_target *, struct device *, size_t, size_t);
-extern void srp_target_free(struct srp_target *);
-
-extern struct iu_entry *srp_iu_get(struct srp_target *);
-extern void srp_iu_put(struct iu_entry *);
-
-extern int srp_cmd_queue(struct Scsi_Host *, struct srp_cmd *, void *, u64, u64);
-extern int srp_transfer_data(struct scsi_cmnd *, struct srp_cmd *,
-			     srp_rdma_t, int, int);
-
-
-static inline struct srp_target *host_to_srp_target(struct Scsi_Host *host)
-{
-	return (struct srp_target *) host->hostdata;
-}
-
-static inline int srp_cmd_direction(struct srp_cmd *cmd)
-{
-	return (cmd->buf_fmt >> 4) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
-}
-
-#endif
-- 
2.5.4 (Apple Git-61)

