From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v3] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Fri, 27 May 2016 09:32:24 -0500
Message-ID: <1464359544-85969-1-git-send-email-bryantly@linux.vnet.ibm.com>
References: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:40726 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbcE0Ocj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2016 10:32:39 -0400
Received: from localhost
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
	Fri, 27 May 2016 08:32:36 -0600
In-Reply-To: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, James.Bottomley@HansenPartnership.com, bart.vanassche@sandisk.com
Cc: martin.petersen@oracle.com, tyreld@linux.vnet.ibm.com, akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

Version 1:
This initial commit contains WIP of the IBM VSCSI Target Fabric
Module. It currently supports read/writes, and I have tested
the ability to create a file backstore with the driver, install
RHEL, and then boot up the partition via filio backstore through
the driver.

This driver is a pick up of the old IBM VIO scsi Target Driver
that was started by Nick and Fujita 2-4 years ago.
http://comments.gmane.org/gmane.linux.scsi/90119
and http://marc.info/?t=129734085600004&r=1&w=2

The driver provides a virtual SCSI device on IBM Power Servers.

When reviving the old libsrp, I stripped out all that utilized
scsi to submit commands to the target. Hence there is no more
scsi_tgt_if_*, and scsi_transport_* files and fully utilizes
LIO instead. This driver does however use the SRP protocol
for communication between guests/and or hosts, but its all
synchronous data transfers due to the utilization of
H_COPY_RDMA, a VIO mechanism which means that others like
ib_srp, ib_srpt which are asynchronous can't use this driver.
This was also the reason for moving libsrp out of the
drivers/scsi/. and into the ibmvscsi folder.

Signed-off-by: Steven Royer <seroyer@linux.vnet.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 MAINTAINERS                          |   10 +
 drivers/scsi/Kconfig                 |   27 +-
 drivers/scsi/Makefile                |    2 +-
 drivers/scsi/ibmvscsi/Makefile       |    4 +
 drivers/scsi/ibmvscsi/ibmvscsi_tgt.c | 1932 ++++++++++++++++++++++++++++++++++
 drivers/scsi/ibmvscsi/ibmvscsi_tgt.h |  169 +++
 drivers/scsi/ibmvscsi/libsrp.c       |  386 +++++++
 drivers/scsi/ibmvscsi/libsrp.h       |   91 ++
 drivers/scsi/libsrp.c                |  447 --------
 include/scsi/libsrp.h                |   78 --
 10 files changed, 2610 insertions(+), 536 deletions(-)
 create mode 100644 drivers/scsi/ibmvscsi/ibmvscsi_tgt.c
 create mode 100644 drivers/scsi/ibmvscsi/ibmvscsi_tgt.h
 create mode 100644 drivers/scsi/ibmvscsi/libsrp.c
 create mode 100644 drivers/scsi/ibmvscsi/libsrp.h
 delete mode 100644 drivers/scsi/libsrp.c
 delete mode 100644 include/scsi/libsrp.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 9c567a4..0f412d4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5451,6 +5451,16 @@ S:	Supported
 F:	drivers/scsi/ibmvscsi/ibmvscsi*
 F:	drivers/scsi/ibmvscsi/viosrp.h
 
+IBM Power Virtual SCSI Device Target Driver
+M:	Bryant G. Ly <bryantly@linux.vnet.ibm.com>
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
index c5883a5..0f8a1de 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -848,6 +848,23 @@ config SCSI_IBMVSCSI
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
@@ -1729,16 +1746,6 @@ config SCSI_PM8001
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
index 0000000..292d129
--- /dev/null
+++ b/drivers/scsi/ibmvscsi/ibmvscsi_tgt.c
@@ -0,0 +1,1932 @@
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
+#include <linux/ctype.h>
+#include <linux/utsname.h>
+#include <asm/unaligned.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_tcq.h>
+
+#include <target/target_core_base.h>
+#include <target/target_core_fabric.h>
+#include <target/target_core_backend.h>
+
+#include <asm/hvcall.h>
+#include <asm/iommu.h>
+#include <asm/prom.h>
+#include <asm/vio.h>
+
+#include "ibmvscsi_tgt.h"
+#include "viosrp.h"
+#include "libsrp.h"
+
+#define IBMVSCSIS_VERSION	"v0.1"
+
+#define	INITIAL_SRP_LIMIT	15
+#define	DEFAULT_MAX_SECTORS	256
+
+#define MAX_H_COPY_RDMA		(128 * 1024)
+
+#define SRP_RSP_SENSE_DATA_LEN	18
+
+static const char ibmvscsis_driver_name[] = "ibmvscsis";
+static char system_id[SYS_ID_NAME_LEN] = "";
+static char partition_name[PARTITION_NAMELEN] = "UNKNOWN";
+static uint partition_number = -1;
+
+static struct workqueue_struct *vtgtd;
+static unsigned max_vdma_size = MAX_H_COPY_RDMA;
+
+static DEFINE_SPINLOCK(ibmvscsis_dev_lock);
+static LIST_HEAD(ibmvscsis_dev_list);
+
+static inline long h_copy_rdma(s64 length, u64 sliobn, u64 slioba,
+			       u64 dliobn, u64 dlioba)
+{
+	long rc = 0;
+
+	/* Ensure all writes to source memory are visible before hcall */
+	mb();
+
+	rc = plpar_hcall_norets(H_COPY_RDMA, length, sliobn, slioba,
+				dliobn, dlioba);
+	return rc;
+}
+
+static inline void h_free_crq(u32 unit_address)
+{
+	long rc = 0;
+
+	do {
+		if (H_IS_LONG_BUSY(rc))
+			msleep(get_longbusy_msecs(rc));
+
+		rc = plpar_hcall_norets(H_FREE_CRQ, unit_address);
+	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
+}
+
+static inline long h_send_crq(struct ibmvscsis_adapter *adapter,
+			      u64 word1, u64 word2)
+{
+	struct vio_dev *vdev = adapter->dma_dev;
+	long rc;
+
+	pr_debug("ibmvscsis_send_crq(0x%x, 0x%016llx, 0x%016llx)\n",
+		 vdev->unit_address, word1, word2);
+
+	/*
+	 * Ensure the command buffer is flushed to memory before handing it
+	 * over to the other side to prevent it from fetching any stale data.
+	 */
+	mb();
+	rc = plpar_hcall_norets(H_SEND_CRQ, vdev->unit_address, word1, word2);
+	pr_debug("ibmvcsis_send_crq rc = 0x%lx\n", rc);
+
+	return rc;
+}
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
+		} else if (se_cmd->data_direction ==
+			   DMA_FROM_DEVICE) {
+			/* residual data from an overflow read */
+			rsp->flags = SRP_RSP_FLAG_DIOVER;
+			rsp->data_in_res_cnt = cpu_to_be32(residual_count);
+		}
+	}
+}
+
+static bool connection_broken(struct ibmvscsis_adapter *adapter)
+{
+	struct viosrp_crq *crq;
+	u64 buffer[2];
+	long h_return_code;
+	bool rc = false;
+
+	/* create a PING crq */
+	crq = (struct viosrp_crq *)&buffer;
+	buffer[0] = 0;
+	buffer[1] = 0;
+	crq->valid = 0x80;
+	crq->format = 6;
+	crq->status = 0xF5;
+
+	h_return_code = h_send_crq(adapter,
+				   cpu_to_be64(buffer[0]),
+				   cpu_to_be64(buffer[1]));
+
+	pr_debug("connection_broken: rc %ld\n", h_return_code);
+
+	if (h_return_code == H_CLOSED)
+		rc = true;
+
+	return rc;
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
+		pr_err("Unimplemented LUN addressing method %u\n",
+		       addressing_method);
+		break;
+	}
+
+out:
+	return res;
+out_err:
+	pr_err("Support for multi-level LUNs has not yet been implemented\n");
+	goto out;
+}
+
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
+		pr_debug("modify_rep_luns: len %d data_len %hud\n",
+			 len, data_len);
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
+/*
+ * This function modifies the inquiry data prior to sending to initiator
+ * so that we can make support current AIX. Internally we are going to
+ * add new ODM entries to support the emulation from LIO. This function
+ * is temporary until those changes are done.
+ */
+static void ibmvscsis_modify_std_inquiry(struct se_cmd *se_cmd)
+{
+	struct se_device *dev = se_cmd->se_dev;
+	u32 cmd_len = se_cmd->data_length;
+	unsigned char *buf = NULL;
+
+	if (cmd_len <= INQ_DATA_OFFSET)
+		return;
+
+	buf = transport_kmap_data_sg(se_cmd);
+	if (buf) {
+		memcpy(&buf[8], "IBM	     ", 8);
+		if (dev->transport->get_device_type(dev) == TYPE_ROM)
+			memcpy(&buf[16], "VOPTA           ", 16);
+		else
+			memcpy(&buf[16], "3303      NVDISK", 16);
+		memcpy(&buf[32], "0001", 4);
+		transport_kunmap_data_sg(se_cmd);
+	}
+}
+
+static int read_dma_window(struct ibmvscsis_adapter *adapter)
+{
+	struct vio_dev *vdev = adapter->dma_dev;
+	const __be32 *dma_window;
+	const __be32 *prop;
+
+	/* TODO Using of_parse_dma_window would be better, but it doesn't give
+	 * a way to read multiple windows without already knowing the size of
+	 * a window or the number of windows
+	 */
+	dma_window = (const __be32 *)vio_get_attribute(vdev,
+						       "ibm,my-dma-window",
+						       NULL);
+	if (!dma_window) {
+		pr_err("Couldn't find ibm, my-dma-window property\n");
+		return -1;
+	}
+
+	adapter->dds.window[LOCAL].liobn = be32_to_cpu(*dma_window);
+	dma_window++;
+
+	prop = (const __be32 *)vio_get_attribute(vdev, "ibm,#dma-address-cells",
+						 NULL);
+	if (!prop) {
+		pr_warn("Couldn't find ibm, #dma-address-cells property\n");
+		dma_window++;
+	} else {
+		dma_window += be32_to_cpu(*prop);
+	}
+
+	prop = (const __be32 *)vio_get_attribute(vdev, "ibm,#dma-size-cells",
+						 NULL);
+	if (!prop) {
+		pr_warn("Couldn't find ibm, #dma-size-cells property\n");
+		dma_window++;
+	} else {
+		dma_window += be32_to_cpu(*prop);
+	}
+
+	/* dma_window should point to the second window now */
+	adapter->dds.window[REMOTE].liobn = be32_to_cpu(*dma_window);
+
+	return 0;
+}
+
+static struct ibmvscsis_tport *ibmvscsis_lookup_port(const char *name)
+{
+	struct ibmvscsis_tport *tport;
+	struct vio_dev *vdev;
+	struct ibmvscsis_adapter *adapter;
+	int ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ibmvscsis_dev_lock, flags);
+	list_for_each_entry(adapter, &ibmvscsis_dev_list, list) {
+		vdev = adapter->dma_dev;
+		ret = strcmp(dev_name(&vdev->dev), name);
+		if (ret == 0)
+			tport = &adapter->tport;
+		if (tport)
+			goto found;
+	}
+	spin_unlock_irqrestore(&ibmvscsis_dev_lock, flags);
+	return NULL;
+found:
+	spin_unlock_irqrestore(&ibmvscsis_dev_lock, flags);
+	return tport;
+}
+
+static irqreturn_t ibmvscsis_interrupt(int dummy, void *data)
+{
+	struct ibmvscsis_adapter *adapter = data;
+
+	vio_disable_interrupts(adapter->dma_dev);
+	queue_work(vtgtd, &adapter->crq_work);
+
+	return IRQ_HANDLED;
+}
+
+static int send_iu(struct iu_entry *iue, u64 length, u8 format)
+{
+	struct srp_target *target = iue->target;
+	struct ibmvscsis_adapter *adapter = target->ldata;
+	struct ibmvscsis_crq_msg crq_msg;
+	struct srp_rsp *rsp;
+	__be64 *crq_as_u64 = (__be64 *)&crq_msg;
+	long rc, rc1;
+
+	rsp = &vio_iu(iue)->srp.rsp;
+
+	/* First copy the SRP */
+	rc = h_copy_rdma(length, adapter->dds.window[LOCAL].liobn,
+			 iue->sbuf->dma, adapter->dds.window[REMOTE].liobn,
+			 be64_to_cpu(iue->remote_token));
+
+	switch (rc) {
+	case H_SUCCESS:
+		break;
+	case H_PERMISSION:
+	case H_SOURCE_PARM:
+	case H_DEST_PARM:
+		if (connection_broken(adapter)) {
+			pr_debug("rdma connection broken\n");
+			goto end;
+		}
+		break;
+	default:
+		pr_err("Error %ld transferring data\n", rc);
+		length = 0;
+		break;
+	}
+
+	pr_debug("crq pre cooked: 0x%x, 0x%llx, 0x%llx\n",
+		 format, length, vio_iu(iue)->srp.rsp.tag);
+
+	crq_msg.valid = 0x80;
+	crq_msg.format = format;
+	crq_msg.rsvd = 0;
+	if (rc == 0)
+		crq_msg.status = 0x99;
+	else
+		crq_msg.status = rsp->status;
+	crq_msg.rsvd1 = 0;
+	crq_msg.IU_length = cpu_to_be16(length);
+	crq_msg.IU_data_ptr = vio_iu(iue)->srp.rsp.tag;
+
+	pr_debug("send crq: 0x%x, 0x%llx, 0x%llx\n",
+		 adapter->dma_dev->unit_address,
+		 be64_to_cpu(crq_as_u64[0]),
+		 be64_to_cpu(crq_as_u64[1]));
+
+	srp_iu_put(iue);
+
+	rc1 = h_send_crq(adapter, be64_to_cpu(crq_as_u64[0]),
+			 be64_to_cpu(crq_as_u64[1]));
+
+	if (rc1) {
+		pr_err("%ld sending response\n", rc1);
+		return rc1;
+	}
+	return rc;
+end:
+	return rc;
+}
+
+static int ibmvscsis_reset_crq_queue(struct ibmvscsis_adapter *adapter)
+{
+	struct vio_dev *vdev = adapter->dma_dev;
+	struct crq_queue *queue = &adapter->crq_queue;
+	int rc = 0;
+
+	/* Close the CRQ */
+	h_free_crq(vdev->unit_address);
+
+	/* Clean out the queue */
+	memset(queue->msgs, 0x00, PAGE_SIZE);
+	queue->cur = 0;
+
+	/* And re-open it again */
+	rc = h_reg_crq(vdev->unit_address, queue->msg_token, PAGE_SIZE);
+	if (rc == 2)
+		/* Adapter is good, but other end is not ready */
+		pr_warn("Partner adapter not ready\n");
+	else if (rc != 0)
+		pr_err("Couldn't register crq--rc 0x%x\n", rc);
+
+	return rc;
+}
+
+static int send_adapter_info(struct iu_entry *iue,
+			     dma_addr_t remote_buffer, u16 length)
+{
+	struct srp_target *target = iue->target;
+	struct ibmvscsis_adapter *adapter = target->ldata;
+	struct viosrp_adapter_info *mad = &vio_iu(iue)->mad.adapter_info;
+	struct mad_adapter_info_data *info;
+	dma_addr_t data_token;
+	int err;
+	int rc = 0;
+
+	mad->common.status = cpu_to_be16(VIOSRP_MAD_SUCCESS);
+
+	if (be16_to_cpu(mad->common.length) > sizeof(*info)) {
+		mad->common.status = cpu_to_be16(VIOSRP_MAD_FAILED);
+		return 0;
+	}
+
+	info = dma_alloc_coherent(&adapter->dma_dev->dev, sizeof(*info),
+				  &data_token, GFP_KERNEL);
+	if (!info) {
+		pr_err("bad dma_alloc_coherent %p\n", target);
+		mad->common.status = cpu_to_be16(VIOSRP_MAD_FAILED);
+		return 1;
+	}
+
+	/* Get remote info */
+	err = h_copy_rdma(sizeof(*info), adapter->dds.window[REMOTE].liobn,
+			  be64_to_cpu(remote_buffer),
+			  adapter->dds.window[LOCAL].liobn, data_token);
+
+	if (err != H_SUCCESS) {
+		pr_err("Error sending adapter info %d\n", err);
+		rc = 1;
+		goto free_dma;
+	}
+
+	pr_err("Client connect: %s (%d)\n",
+	       info->partition_name, info->partition_number);
+
+	if (adapter->client_data.partition_number == 0)
+		adapter->client_data.partition_number =
+			be32_to_cpu(info->partition_number);
+	strncpy(adapter->client_data.srp_version, info->srp_version,
+		sizeof(adapter->client_data.srp_version));
+	strncpy(adapter->client_data.partition_name,
+		info->partition_name,
+		sizeof(adapter->client_data.partition_name));
+	adapter->client_data.mad_version =
+					be32_to_cpu(info->mad_version);
+	adapter->client_data.os_type = be32_to_cpu(info->os_type);
+	pr_debug("adapter info client adapter %u\n",
+		 adapter->client_data.os_type);
+
+	strncpy(info->srp_version, SRP_VERSION, sizeof(info->srp_version));
+	strncpy(info->partition_name, adapter->dds.partition_name,
+		sizeof(info->partition_name));
+
+	info->partition_number = cpu_to_be32(adapter->dds.partition_num);
+	info->mad_version = cpu_to_be32(1);
+	info->os_type = cpu_to_be32(2);
+	memset(&info->port_max_txu[0], 0, sizeof(info->port_max_txu));
+	info->port_max_txu[0] = cpu_to_be32(SCSI_MAX_SG_SEGMENTS *
+					    PAGE_SIZE);
+
+	dma_rmb();
+	/* Send our info to remote */
+	err = h_copy_rdma(sizeof(*info), adapter->dds.window[LOCAL].liobn,
+			  data_token, adapter->dds.window[REMOTE].liobn,
+			  be64_to_cpu(remote_buffer));
+
+	switch (err) {
+	case H_SUCCESS:
+		break;
+	case H_PERMISSION:
+	case H_SOURCE_PARM:
+	case H_DEST_PARM:
+		if (connection_broken(adapter))
+			pr_debug("rdma connection broken\n");
+	default:
+		pr_err("Error sending adapter info %d\n",
+		       err);
+		rc = -EIO;
+	}
+
+free_dma:
+	dma_free_coherent(&adapter->dma_dev->dev, sizeof(*info), info,
+			  data_token);
+
+	return rc;
+}
+
+static int process_mad_iu(struct iu_entry *iue)
+{
+	union viosrp_iu *iu = vio_iu(iue);
+	struct viosrp_adapter_info *info;
+	struct viosrp_host_config *conf;
+
+	switch (be32_to_cpu(iu->mad.empty_iu.common.type)) {
+	case VIOSRP_EMPTY_IU_TYPE:
+		pr_err("%s\n", "Unsupported EMPTY MAD IU");
+		break;
+	case VIOSRP_ERROR_LOG_TYPE:
+		pr_err("%s\n", "Unsupported ERROR LOG MAD IU");
+		iu->mad.error_log.common.status = 1;
+		send_iu(iue, sizeof(iu->mad.error_log),	VIOSRP_MAD_FORMAT);
+		break;
+	case VIOSRP_ADAPTER_INFO_TYPE:
+		info = &iu->mad.adapter_info;
+		info->common.status = send_adapter_info(iue, info->buffer,
+							info->common.length);
+		send_iu(iue, sizeof(*info), VIOSRP_MAD_FORMAT);
+		break;
+	case VIOSRP_HOST_CONFIG_TYPE:
+		conf = &iu->mad.host_config;
+		conf->common.status = 1;
+		send_iu(iue, sizeof(*conf), VIOSRP_MAD_FORMAT);
+		break;
+	default:
+		pr_err("Unknown type %u\n", iu->srp.rsp.opcode);
+		iu->mad.empty_iu.common.status =
+					cpu_to_be16(VIOSRP_MAD_NOT_SUPPORTED);
+		send_iu(iue, sizeof(iu->mad), VIOSRP_MAD_FORMAT);
+		break;
+	}
+
+	return 1;
+}
+
+static struct se_portal_group *ibmvscsis_make_nexus(struct ibmvscsis_tport
+						    *tport,
+						    const char *name)
+{
+	struct se_node_acl *acl;
+
+	if (tport->se_sess) {
+		pr_debug("tport->se_sess already exists\n");
+		return &tport->se_tpg;
+	}
+
+	/*
+	 *  Initialize the struct se_session pointer and setup tagpool
+	 *  for struct ibmvscsis_cmd descriptors
+	 */
+	tport->se_sess = transport_init_session(TARGET_PROT_NORMAL);
+	if (IS_ERR(tport->se_sess))
+		goto transport_init_fail;
+
+	/*
+	 * Since we are running in 'demo mode' this call will generate a
+	 * struct se_node_acl for the ibmvscsis struct se_portal_group with
+	 * the SCSI Initiator port name of the passed configfs group 'name'.
+	 */
+
+	acl = core_tpg_check_initiator_node_acl(&tport->se_tpg,
+						(unsigned char *)name);
+	if (!acl) {
+		pr_debug("core_tpg_check_initiator_node_acl() failed for %s\n",
+			 name);
+		goto acl_failed;
+	}
+	tport->se_sess->se_node_acl = acl;
+
+	/*
+	 * Now register the TCM ibmvscsis virtual I_T Nexus as active.
+	 */
+	transport_register_session(&tport->se_tpg,
+				   tport->se_sess->se_node_acl,
+				   tport->se_sess, tport);
+
+	tport->se_sess->se_tpg = &tport->se_tpg;
+
+	return &tport->se_tpg;
+
+acl_failed:
+	transport_free_session(tport->se_sess);
+transport_init_fail:
+	kfree(tport);
+	return ERR_PTR(-ENOMEM);
+}
+
+static int ibmvscsis_drop_nexus(struct ibmvscsis_tport *tport)
+{
+	struct se_session *se_sess;
+
+	se_sess = tport->se_sess;
+	if (!se_sess)
+		return -ENODEV;
+
+	transport_deregister_session(tport->se_sess);
+	transport_free_session(tport->se_sess);
+	return 0;
+}
+
+static void process_login(struct iu_entry *iue)
+{
+	union viosrp_iu *iu = vio_iu(iue);
+	struct srp_login_rsp *rsp = &iu->srp.login_rsp;
+	struct srp_login_rej *rej = &iu->srp.login_rej;
+	struct srp_target *target = iue->target;
+	struct ibmvscsis_adapter *adapter = target->ldata;
+	struct vio_dev *vdev = adapter->dma_dev;
+	struct se_portal_group *se_tpg;
+	char name[16];
+	u64 tag = iu->srp.rsp.tag;
+
+	/*
+	 * TODO handle case that requested size is wrong and buffer
+	 * format is wrong
+	 */
+	memset(iu, 0, max(sizeof(*rsp), sizeof(*rej)));
+
+	snprintf(name, sizeof(name), "%x", vdev->unit_address);
+
+	if (!adapter->tport.enabled) {
+		rej->reason = cpu_to_be32(SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
+		pr_err("Rejected SRP_LOGIN_REQ because target %s has not yet been enabled",
+		       name);
+		goto reject;
+	}
+
+	se_tpg = ibmvscsis_make_nexus(&adapter->tport,
+				      &adapter->tport.tport_name[0]);
+	if (!se_tpg) {
+		pr_debug("login make nexus fail se_tpg(%p)\n", se_tpg);
+		goto reject;
+	}
+
+	rsp->opcode = SRP_LOGIN_RSP;
+
+	rsp->req_lim_delta = cpu_to_be32(INITIAL_SRP_LIMIT);
+
+	pr_debug("process_login, tag:%llu\n", tag);
+
+	rsp->tag = tag;
+	rsp->max_it_iu_len = cpu_to_be32(sizeof(union srp_iu));
+	rsp->max_ti_iu_len = cpu_to_be32(sizeof(union srp_iu));
+	/* direct and indirect */
+	rsp->buf_fmt = cpu_to_be16(SRP_BUF_FORMAT_DIRECT |
+				   SRP_BUF_FORMAT_INDIRECT);
+
+	send_iu(iue, sizeof(*rsp), VIOSRP_SRP_FORMAT);
+	return;
+
+reject:
+	rej->opcode = SRP_LOGIN_REJ;
+	rej->tag = tag;
+	rej->buf_fmt = cpu_to_be16(SRP_BUF_FORMAT_DIRECT |
+				   SRP_BUF_FORMAT_INDIRECT);
+
+	send_iu(iue, sizeof(*rej), VIOSRP_SRP_FORMAT);
+}
+
+static void process_tsk_mgmt(struct ibmvscsis_adapter *adapter,
+			     struct iu_entry *iue)
+{
+	struct srp_tsk_mgmt *srp_tsk = &vio_iu(iue)->srp.tsk_mgmt;
+	struct ibmvscsis_cmd *cmd = adapter->cmd;
+	struct srp_rsp *rsp;
+	u64 unpacked_lun = 0;
+	u64 tag_to_abort = 0;
+	int tcm_type;
+	int rc = 0;
+
+	rsp = &vio_iu(iue)->srp.rsp;
+	unpacked_lun = ibmvscsis_unpack_lun((u8 *)&srp_tsk->lun,
+					    sizeof(srp_tsk->lun));
+
+	switch (srp_tsk->tsk_mgmt_func) {
+	case SRP_TSK_ABORT_TASK:
+		tcm_type = TMR_ABORT_TASK;
+		tag_to_abort = be64_to_cpu(srp_tsk->task_tag);
+		srp_iu_put(iue);
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
+		pr_err("unknown task mgmt func %d\n", srp_tsk->tsk_mgmt_func);
+		cmd->se_cmd.se_tmr_req->response =
+					TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED;
+		goto fail;
+	}
+
+	cmd->se_cmd.tag = be64_to_cpu(srp_tsk->tag);
+
+	pr_debug("calling submit_tmr, func %d\n",
+		 srp_tsk->tsk_mgmt_func);
+	rc = target_submit_tmr(&cmd->se_cmd,
+			       adapter->tport.se_sess, NULL,
+			       unpacked_lun, srp_tsk, tcm_type,
+			       GFP_KERNEL, tag_to_abort,
+			       TARGET_SCF_ACK_KREF);
+	if (rc != 0) {
+		pr_err("target_submit_tmr failed, rc %d\n", rc);
+		cmd->se_cmd.se_tmr_req->response = TMR_FUNCTION_REJECTED;
+		goto fail;
+	}
+
+fail:
+	if (rc)
+		transport_send_check_condition_and_sense(&cmd->se_cmd, 0, 0);
+}
+
+static int tcm_queuecommand(struct ibmvscsis_adapter *adapter,
+			    struct ibmvscsis_cmd *vsc,
+			    struct srp_cmd *scmd)
+{
+	struct se_cmd *se_cmd;
+	u64 data_len;
+	u64 unpacked_lun;
+	int ret;
+	int attr;
+
+	switch (scmd->task_attr) {
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
+		pr_err("Task attribute %d not supported\n", scmd->task_attr);
+		attr = TCM_SIMPLE_TAG;
+	}
+
+	pr_debug("srp_data_length: %llx, srp_direction:%x\n",
+		 srp_data_length(scmd, srp_cmd_direction(scmd)),
+		 srp_cmd_direction(scmd));
+	data_len = srp_data_length(scmd, srp_cmd_direction(scmd));
+
+	vsc->se_cmd.tag = scmd->tag;
+	se_cmd = &vsc->se_cmd;
+
+	pr_debug("size of lun:%lx, lun:%s\n", sizeof(scmd->lun),
+		 &scmd->lun.scsi_lun[0]);
+
+	unpacked_lun = ibmvscsis_unpack_lun((u8 *)&scmd->lun,
+					    sizeof(scmd->lun));
+
+	ret = target_submit_cmd(se_cmd, adapter->tport.se_sess,
+				&scmd->cdb[0], &vsc->sense_buf[0], unpacked_lun,
+				data_len, attr, srp_cmd_direction(scmd),
+				TARGET_SCF_ACK_KREF);
+	if (ret != 0) {
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		pr_debug("tcm_queuecommand fail submit_cmd\n");
+		goto send_sense;
+	}
+	return 0;
+
+send_sense:
+	transport_send_check_condition_and_sense(&vsc->se_cmd, ret, 0);
+	transport_generic_free_cmd(&vsc->se_cmd, 0);
+	return -1;
+}
+
+static int ibmvscsis_queuecommand(struct ibmvscsis_adapter *adapter,
+				  struct iu_entry *iue)
+{
+	struct srp_cmd *cmd = iue->sbuf->buf;
+	struct scsi_cmnd *sc;
+	struct ibmvscsis_cmd *vsc;
+	int ret;
+
+	vsc = kzalloc(sizeof(*vsc), GFP_KERNEL);
+	adapter->cmd = vsc;
+	sc = &vsc->sc;
+	sc->sense_buffer = vsc->se_cmd.sense_buffer;
+	sc->cmnd = cmd->cdb;
+	sc->SCp.ptr = (char *)iue;
+
+	ret = tcm_queuecommand(adapter, vsc, cmd);
+
+	return ret;
+}
+
+static void ibmvscsis_srp_i_logout(struct iu_entry *iue)
+{
+	union viosrp_iu *iu = vio_iu(iue);
+	struct srp_i_logout *log_out = &vio_iu(iue)->srp.i_logout;
+	u64 tag = iu->srp.rsp.tag;
+
+	log_out->opcode = SRP_I_LOGOUT;
+	log_out->tag = tag;
+	send_iu(iue, sizeof(*log_out), VIOSRP_SRP_FORMAT);
+}
+
+static int process_srp_iu(struct iu_entry *iue)
+{
+	union viosrp_iu *iu = vio_iu(iue);
+	struct srp_target *target = iue->target;
+	struct ibmvscsis_adapter *adapter = target->ldata;
+	u8 opcode = iu->srp.rsp.opcode;
+	unsigned long flags;
+	int err = 1;
+
+	spin_lock_irqsave(&target->lock, flags);
+	if (adapter->tport.releasing) {
+		pr_err("process_srp_iu error, tport is released:%x\n",
+		       adapter->tport.releasing);
+		goto done;
+	}
+	if (!adapter->tport.enabled) {
+		pr_err("process_srp_iu, tport not enabled:%x\n",
+		       adapter->tport.enabled);
+		goto done;
+	}
+	spin_unlock_irqrestore(&target->lock, flags);
+
+	switch (opcode) {
+	case SRP_LOGIN_REQ:
+		process_login(iue);
+		break;
+	case SRP_TSK_MGMT:
+		process_tsk_mgmt(adapter, iue);
+		break;
+	case SRP_CMD:
+		err = ibmvscsis_queuecommand(adapter, iue);
+		if (err) {
+			srp_iu_put(iue);
+			pr_err("can't queue cmd\n");
+		}
+		break;
+	case SRP_LOGIN_RSP:
+	case SRP_I_LOGOUT:
+		ibmvscsis_srp_i_logout(iue);
+		break;
+	case SRP_T_LOGOUT:
+	case SRP_RSP:
+	case SRP_CRED_REQ:
+	case SRP_CRED_RSP:
+	case SRP_AER_REQ:
+	case SRP_AER_RSP:
+		pr_err("Unsupported type %u\n", opcode);
+		break;
+	default:
+		pr_err("Unknown type %u\n", opcode);
+	}
+	return err;
+
+done:
+	spin_unlock_irqrestore(&target->lock, flags);
+	srp_iu_put(iue);
+	return err;
+}
+
+static void process_iu(struct viosrp_crq *crq,
+		       struct ibmvscsis_adapter *adapter)
+{
+	struct iu_entry *iue;
+	long err;
+
+	iue = srp_iu_get(adapter->target);
+	if (!iue) {
+		pr_err("Error getting IU from pool %p\n", iue);
+		return;
+	}
+
+	iue->remote_token = crq->IU_data_ptr;
+
+	err = h_copy_rdma(be16_to_cpu(crq->IU_length),
+			  adapter->dds.window[REMOTE].liobn,
+			  be64_to_cpu(crq->IU_data_ptr),
+			  adapter->dds.window[LOCAL].liobn, iue->sbuf->dma);
+
+	switch (err) {
+	case H_SUCCESS:
+		break;
+	case H_PERMISSION:
+	case H_SOURCE_PARM:
+	case H_DEST_PARM:
+		if (connection_broken(adapter))
+			pr_debug("rdma connection broken\n");
+	default:
+		pr_err("process iu error\n");
+		break;
+	}
+
+	if (crq->format == VIOSRP_MAD_FORMAT) {
+		process_mad_iu(iue);
+	} else {
+		pr_debug("process srpiu");
+		process_srp_iu(iue);
+	}
+}
+
+static void process_crq(struct viosrp_crq *crq,
+			struct ibmvscsis_adapter *adapter)
+{
+	switch (crq->valid) {
+	case 0xC0:
+		/* initialization */
+		switch (crq->format) {
+		case 0x01:
+			h_send_crq(adapter, 0xC002000000000000, 0);
+			break;
+		case 0x02:
+			break;
+		default:
+			pr_err("Unknown format %u\n", crq->format);
+		}
+		break;
+	case 0xFF:
+		/* transport event */
+		switch (crq->format) {
+		case MIGRATED:
+		case PARTNER_FAILED:
+		case PARTNER_DEREGISTER:
+			adapter->client_data.os_type = 0;
+			pr_debug("trans_event:good format %d\n",
+				 (uint)crq->format);
+			break;
+		default:
+			pr_err("trans_event:invalid format %d\n",
+			       (uint)crq->format);
+		}
+		break;
+	case 0x80:
+		/* real payload */
+		switch (crq->format) {
+		case VIOSRP_SRP_FORMAT:
+		case VIOSRP_MAD_FORMAT:
+			process_iu(crq, adapter);
+			break;
+		case VIOSRP_OS400_FORMAT:
+		case VIOSRP_AIX_FORMAT:
+		case VIOSRP_LINUX_FORMAT:
+		case VIOSRP_INLINE_FORMAT:
+			pr_err("Unsupported format %u\n", crq->format);
+			break;
+		default:
+			pr_err("Unknown format %u\n", crq->format);
+		}
+		break;
+	default:
+		pr_err("Unknown message type 0x%02x!?\n", crq->valid);
+	}
+}
+
+static inline struct viosrp_crq *next_crq(struct crq_queue *queue)
+{
+	struct viosrp_crq *crq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->lock, flags);
+	crq = &queue->msgs[queue->cur];
+	if (crq->valid & 0x80 || crq->valid & 0xFF) {
+		if (++queue->cur == queue->size)
+			queue->cur = 0;
+
+		/* Ensure the read of the valid bit occurs before reading any
+		 * other bits of the CRQ entry
+		 */
+		rmb();
+	} else {
+		crq = NULL;
+	}
+	spin_unlock_irqrestore(&queue->lock, flags);
+
+	return crq;
+}
+
+static void handle_crq(struct work_struct *work)
+{
+	struct ibmvscsis_adapter *adapter =
+			container_of(work, struct ibmvscsis_adapter, crq_work);
+	struct viosrp_crq *crq;
+	int done = 0;
+
+	while (!done) {
+		while ((crq = next_crq(&adapter->crq_queue)) != NULL) {
+			process_crq(crq, adapter);
+			crq->valid = 0x00;
+		}
+
+		vio_enable_interrupts(adapter->dma_dev);
+
+		crq = next_crq(&adapter->crq_queue);
+		if (crq) {
+			vio_disable_interrupts(adapter->dma_dev);
+			process_crq(crq, adapter);
+			crq->valid = 0x00;
+		} else {
+			done = 1;
+		}
+	}
+}
+
+static int crq_queue_create(struct crq_queue *queue,
+			    struct ibmvscsis_adapter *adapter)
+{
+	struct vio_dev *vdev = adapter->dma_dev;
+	int retrc;
+	int err;
+
+	queue->msgs = (struct viosrp_crq *)get_zeroed_page(GFP_KERNEL);
+
+	if (!queue->msgs)
+		goto malloc_failed;
+
+	queue->size = PAGE_SIZE / sizeof(*queue->msgs);
+
+	queue->msg_token = dma_map_single(&vdev->dev, queue->msgs,
+					  queue->size * sizeof(*queue->msgs),
+					  DMA_BIDIRECTIONAL);
+
+	if (dma_mapping_error(&vdev->dev, queue->msg_token))
+		goto map_failed;
+
+	err = h_reg_crq(vdev->unit_address, queue->msg_token,
+			PAGE_SIZE);
+	retrc = err;
+
+	/* If the adapter was left active for some reason (like kexec)
+	 * try freeing and re-registering
+	 */
+	if (err == H_RESOURCE)
+		err = ibmvscsis_reset_crq_queue(adapter);
+	if (err == 2) {
+		pr_warn("Partner adapter not ready\n");
+		retrc = 0;
+	} else if (err != 0) {
+		pr_err("Error 0x%x opening virtual adapter\n", err);
+		goto reg_crq_failed;
+	}
+
+	queue->cur = 0;
+	spin_lock_init(&queue->lock);
+
+	INIT_WORK(&adapter->crq_work, handle_crq);
+
+	err = request_irq(vdev->irq, &ibmvscsis_interrupt,
+			  0, "ibmvscsis", adapter);
+	if (err) {
+		pr_err("Error 0x%x h_send_crq\n", err);
+		goto req_irq_failed;
+	}
+
+	err = vio_enable_interrupts(vdev);
+	if (err != 0) {
+		pr_err("Error %d enabling interrupts!!!\n", err);
+		goto req_irq_failed;
+	}
+
+	return retrc;
+
+req_irq_failed:
+	h_free_crq(vdev->unit_address);
+reg_crq_failed:
+	dma_unmap_single(&vdev->dev, queue->msg_token,
+			 queue->size * sizeof(*queue->msgs), DMA_BIDIRECTIONAL);
+map_failed:
+	free_page((unsigned long)queue->msgs);
+malloc_failed:
+	return -1;
+}
+
+static void crq_queue_destroy(struct ibmvscsis_adapter *adapter)
+{
+	struct vio_dev *vdev = adapter->dma_dev;
+	struct crq_queue *queue = &adapter->crq_queue;
+
+	free_irq(vdev->irq, (void *)adapter);
+	flush_work(&adapter->crq_work);
+	h_free_crq(vdev->unit_address);
+	dma_unmap_single(&adapter->dma_dev->dev, queue->msg_token,
+			 queue->size * sizeof(*queue->msgs),
+			 DMA_BIDIRECTIONAL);
+
+	free_page((unsigned long)queue->msgs);
+}
+
+static int ibmvscsis_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
+			  struct srp_direct_buf *md, int nmd,
+			  enum dma_data_direction dir, unsigned int rest)
+{
+	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
+	struct srp_target *target = iue->target;
+	struct ibmvscsis_adapter *adapter = target->ldata;
+	struct target_dds *dds = adapter->dds;
+	dma_addr_t token;
+	long err;
+	unsigned int done = 0;
+	int i, sidx, soff;
+
+	sidx = 0;
+	soff = 0;
+	token = sg_dma_address(sg + sidx);
+
+	for (i = 0; i < nmd && rest; i++) {
+		unsigned int mdone, mlen;
+
+		mlen = min(rest, be32_to_cpu(md[i].len));
+		for (mdone = 0; mlen;) {
+			int slen = min(sg_dma_len(sg + sidx) - soff, mlen);
+
+			if (dir == DMA_TO_DEVICE)
+				err = h_copy_rdma(slen,
+						  dds.window[REMOTE].liobn,
+						  be64_to_cpu(md[i].va) + mdone,
+						  dds.window[LOCAL].liobn,
+						  token + soff);
+			else
+				err = h_copy_rdma(slen,
+						  dds.window[LOCAL].liobn,
+						  token + soff,
+						  dds.window[REMOTE].liobn,
+						  be64_to_cpu(md[i].va) +
+						  mdone);
+			switch (err) {
+			case H_SUCCESS:
+				break;
+			case H_PERMISSION:
+			case H_SOURCE_PARM:
+			case H_DEST_PARM:
+				if (connection_broken(adapter))
+					pr_debug("rdma connection broken\n");
+			default:
+				pr_err("rdma error %d %d %ld\n",
+				       dir, slen, err);
+				return -EIO;
+			}
+
+			mlen -= slen;
+			mdone += slen;
+			soff += slen;
+			done += slen;
+
+			if (soff == sg_dma_len(sg + sidx)) {
+				sidx++;
+				soff = 0;
+				token = sg_dma_address(sg + sidx);
+
+				if (sidx > nsg) {
+					pr_err("out of sg %p %d %d\n",
+					       iue, sidx, nsg);
+					return -EIO;
+				}
+			}
+		}
+		rest -= mlen;
+	}
+	return 0;
+}
+
+static int ibmvscsis_probe(struct vio_dev *vdev, const struct vio_device_id *id)
+{
+	struct ibmvscsis_adapter *adapter;
+	struct srp_target *target;
+	struct ibmvscsis_tport *tport;
+	unsigned long flags;
+	int ret = -ENOMEM;
+
+	pr_debug("Probe for UA 0x%x\n", vdev->unit_address);
+
+	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
+	if (!adapter)
+		return ret;
+	target = kzalloc(sizeof(*target), GFP_KERNEL);
+	if (!target)
+		goto free_adapter;
+
+	adapter->dma_dev = vdev;
+	adapter->target = target;
+	tport = &adapter->tport;
+
+	tport->enabled = false;
+	snprintf(&adapter->tport.tport_name[0], 256, "%s",
+		 dev_name(&vdev->dev));
+
+	ret = read_dma_window(adapter);
+	if (ret)
+		goto free_target;
+
+	adapter->dds.unit_id = vdev->unit_address;
+	adapter->dds.partition_num = partition_number;
+	strncpy(adapter->dds.partition_name, partition_name,
+		sizeof(adapter->dds.partition_name));
+
+	spin_lock_irqsave(&ibmvscsis_dev_lock, flags);
+	list_add_tail(&adapter->list, &ibmvscsis_dev_list);
+	spin_unlock_irqrestore(&ibmvscsis_dev_lock, flags);
+
+	ret = srp_target_alloc(target, &vdev->dev,
+			       INITIAL_SRP_LIMIT,
+			       SRP_MAX_IU_LEN);
+
+	adapter->target->ldata = adapter;
+
+	if (ret) {
+		pr_err("failed target alloc ret: %d\n", ret);
+		goto free_srp_target;
+	}
+
+	ret = crq_queue_create(&adapter->crq_queue, adapter);
+	if (ret != 0 && ret != H_RESOURCE) {
+		pr_err("failed crq_queue_create ret: %d\n", ret);
+		ret = -1;
+	}
+
+	if (h_send_crq(adapter, 0xC001000000000000LL, 0) != 0 &&
+	    ret != H_RESOURCE) {
+		pr_warn("Failed to send CRQ message\n");
+		ret = 0;
+	}
+
+	dev_set_drvdata(&vdev->dev, adapter);
+
+	return 0;
+
+free_srp_target:
+	srp_target_free(target);
+free_target:
+	kfree(target);
+free_adapter:
+	kfree(adapter);
+	return ret;
+}
+
+static int ibmvscsis_remove(struct vio_dev *dev)
+{
+	struct ibmvscsis_adapter *adapter = dev_get_drvdata(&dev->dev);
+	struct srp_target *target;
+	unsigned long flags;
+
+	target = adapter->target;
+
+	spin_lock_irqsave(&ibmvscsis_dev_lock, flags);
+	list_del(&adapter->list);
+	spin_unlock_irqrestore(&ibmvscsis_dev_lock, flags);
+
+	crq_queue_destroy(adapter);
+	srp_target_free(target);
+
+	kfree(target);
+	kfree(adapter);
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
+	struct ibmvscsis_adapter *adapter =
+			container_of(dev, struct ibmvscsis_adapter, dev);
+
+	return snprintf(buf, PAGE_SIZE, "%x\n", adapter->dma_dev->unit_address);
+}
+
+static int get_system_info(void)
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
+		partition_number = of_read_number(num, 1);
+
+	of_node_put(rootdn);
+
+	vdevdn = of_find_node_by_path("/vdevice");
+	vdevdn = of_find_node_by_path("/vdevice");
+	if (vdevdn) {
+		const unsigned *mvds;
+
+		mvds = of_get_property(vdevdn, "ibm,max-virtual-dma-size",
+				       NULL);
+		if (mvds)
+			max_vdma_size = *mvds;
+		of_node_put(vdevdn);
+	}
+
+	return 0;
+};
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
+	return &tport->tport_name[0];
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
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd,
+						  struct ibmvscsis_cmd,
+						  se_cmd);
+
+	return target_put_sess_cmd(&cmd->se_cmd);
+}
+
+static void ibmvscsis_release_cmd(struct se_cmd *se_cmd)
+{
+	struct ibmvscsis_cmd *cmd =
+		container_of(se_cmd, struct ibmvscsis_cmd, se_cmd);
+
+	kfree(cmd);
+}
+
+static int ibmvscsis_shutdown_session(struct se_session *se_sess)
+{
+	return 0;
+}
+
+static void ibmvscsis_close_session(struct se_session *se_sess)
+{
+}
+
+static u32 ibmvscsis_sess_get_index(struct se_session *se_sess)
+{
+	return 0;
+}
+
+static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
+{
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd,
+						  struct ibmvscsis_cmd,
+						  se_cmd);
+	struct scsi_cmnd *sc = &cmd->sc;
+	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
+	int ret;
+
+	sc->sdb.length = se_cmd->data_length;
+	sc->sdb.table.nents = se_cmd->t_data_nents;
+	sc->sdb.table.sgl = se_cmd->t_data_sg;
+
+	ret = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd,
+				ibmvscsis_rdma, 1, 1);
+	if (ret) {
+		pr_err("srp_transfer_data() failed: %d\n", ret);
+		return -EAGAIN;
+	}
+	/*
+	 * We now tell TCM to add this WRITE CDB directly into the TCM storage
+	 * object execution queue.
+	 */
+	target_execute_cmd(&cmd->se_cmd);
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
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd,
+						  struct ibmvscsis_cmd,
+						  se_cmd);
+	struct scsi_cmnd *sc = &cmd->sc;
+	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
+	struct srp_cmd *srp = (struct srp_cmd *)iue->sbuf->buf;
+	struct srp_rsp *rsp;
+	char *sd;
+	char *data;
+	int ret;
+	uint len;
+
+	struct srp_target *target = iue->target;
+	struct ibmvscsis_adapter *adapter = target->ldata;
+
+	/*
+	 * Check for overflow residual count
+	 */
+
+	if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT)
+		scsi_set_resid(sc, se_cmd->residual_count);
+
+	sc->sdb.length = se_cmd->data_length;
+	sc->sdb.table.nents = se_cmd->t_data_nents;
+	sc->sdb.table.sgl = se_cmd->t_data_sg;
+
+	if (scsi_sg_count(sc)) {
+		if (srp->cdb[0] == REPORT_LUNS &&
+		    adapter->client_data.os_type != LINUX)
+			ibmvscsis_modify_rep_luns(se_cmd);
+		if ((srp->cdb[0] == INQUIRY) && ((srp->cdb[1] & 0x1) == 0))
+			ibmvscsis_modify_std_inquiry(se_cmd);
+		ret = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd,
+					ibmvscsis_rdma, 1, 1);
+		if (ret) {
+			pr_err("srp_transfer_data failed: %d\n", ret);
+			sd = cmd->se_cmd.sense_buffer;
+			cmd->se_cmd.scsi_sense_length = 18;
+			memset(cmd->se_cmd.sense_buffer, 0,
+			       cmd->se_cmd.scsi_sense_length);
+			sd[0] = 0x70;
+			sd[2] = 3;
+			sd[7] = 10;
+			sd[12] = 8;
+			sd[13] = 1;
+		}
+	}
+
+	rsp = &vio_iu(iue)->srp.rsp;
+	len = sizeof(*rsp);
+	memset(rsp, 0, len);
+	data = rsp->data;
+
+	rsp->tag = se_cmd->tag;
+	rsp->req_lim_delta = cpu_to_be32(1);
+	rsp->opcode = SRP_RSP;
+
+	ibmvscsis_determine_resid(se_cmd, rsp);
+	rsp->status = se_cmd->scsi_status;
+
+	if (se_cmd->scsi_sense_length && se_cmd->sense_buffer) {
+		rsp->sense_data_len = cpu_to_be32(se_cmd->scsi_sense_length);
+		rsp->flags |= SRP_RSP_FLAG_SNSVALID;
+		len += se_cmd->scsi_sense_length;
+		memcpy(data, se_cmd->sense_buffer, se_cmd->scsi_sense_length);
+	}
+
+	send_iu(iue, len, VIOSRP_SRP_FORMAT);
+	return 0;
+}
+
+static int ibmvscsis_queue_status(struct se_cmd *se_cmd)
+{
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd,
+						  struct ibmvscsis_cmd,
+						  se_cmd);
+	struct scsi_cmnd *sc = &cmd->sc;
+	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
+	struct srp_rsp *rsp;
+	uint len;
+	char *data;
+
+	rsp = &vio_iu(iue)->srp.rsp;
+	len = sizeof(*rsp);
+	memset(rsp, 0, len);
+	data = rsp->data;
+
+	rsp->tag = se_cmd->tag;
+	rsp->req_lim_delta = cpu_to_be32(1);
+	rsp->opcode = SRP_RSP;
+
+	ibmvscsis_determine_resid(se_cmd, rsp);
+	rsp->status = se_cmd->scsi_status;
+
+	if (se_cmd->scsi_sense_length && se_cmd->sense_buffer) {
+		rsp->sense_data_len = cpu_to_be32(se_cmd->scsi_sense_length);
+		rsp->flags |= SRP_RSP_FLAG_SNSVALID;
+		len += se_cmd->scsi_sense_length;
+		memcpy(data, se_cmd->sense_buffer, se_cmd->scsi_sense_length);
+	}
+	send_iu(iue, len, VIOSRP_SRP_FORMAT);
+	return 0;
+}
+
+static void ibmvscsis_queue_tm_rsp(struct se_cmd *se_cmd)
+{
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd,
+						  struct ibmvscsis_cmd,
+						  se_cmd);
+	struct scsi_cmnd *sc = &cmd->sc;
+	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
+	struct srp_target *target = iue->target;
+	struct ibmvscsis_adapter *adapter = target->ldata;
+	struct srp_rsp *rsp;
+	uint len;
+	char *data;
+	u32 *tsk_status;
+	u32 rsp_code;
+
+	rsp = &vio_iu(iue)->srp.rsp;
+
+	if (transport_check_aborted_status(se_cmd, false) != 0) {
+		pr_debug("queue_tm_rsp aborted\n");
+		atomic_inc(&adapter->req_lim_delta);
+		srp_iu_put(iue);
+	} else {
+		rsp->req_lim_delta = cpu_to_be32(1 +
+						 atomic_xchg(&adapter->
+							     req_lim_delta, 0));
+	}
+
+	len = sizeof(*rsp);
+	memset(rsp, 0, len);
+	data = rsp->data;
+
+	rsp->opcode = SRP_RSP;
+	rsp->tag = se_cmd->se_tmr_req->ref_task_tag;
+	rsp->status = 0;
+	rsp->resp_data_len = cpu_to_be32(4);
+	rsp->flags |= SRP_RSP_FLAG_RSPVALID;
+	rsp->req_lim_delta = cpu_to_be32(1);
+
+	switch (se_cmd->se_tmr_req->response) {
+	case TMR_FUNCTION_COMPLETE:
+	case TMR_TASK_DOES_NOT_EXIST:
+		rsp_code = SRP_TASK_MANAGEMENT_FUNCTION_COMPLETE;
+		break;
+	case TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED:
+	case TMR_LUN_DOES_NOT_EXIST:
+		rsp_code = SRP_TASK_MANAGEMENT_FUNCTION_NOT_SUPPORTED;
+		break;
+	case TMR_FUNCTION_FAILED:
+	case TMR_FUNCTION_REJECTED:
+	default:
+		rsp_code = SRP_TASK_MANAGEMENT_FUNCTION_FAILED;
+		break;
+	}
+
+	tsk_status = (u32 *)data;
+	*tsk_status = cpu_to_be32(rsp_code);
+	data = (char *)(tsk_status + 1);
+	len += 4;
+
+	send_iu(iue, len, VIOSRP_SRP_FORMAT);
+}
+
+static void ibmvscsis_aborted_task(struct se_cmd *se_cmd)
+{
+}
+
+static struct se_wwn *ibmvscsis_make_tport(struct target_fabric_configfs *tf,
+					   struct config_group *group,
+					   const char *name)
+{
+	struct ibmvscsis_tport *tport;
+	int ret;
+
+	tport = ibmvscsis_lookup_port(name);
+	ret = -EINVAL;
+
+	if (!tport)
+		goto err;
+
+	tport->tport_proto_id = SCSI_PROTOCOL_SRP;
+	pr_debug("make_tport(%s), pointer:%p tport_id:%x\n", name, tport,
+		 tport->tport_proto_id);
+
+	return &tport->tport_wwn;
+err:
+	return ERR_PTR(ret);
+}
+
+static void ibmvscsis_drop_tport(struct se_wwn *wwn)
+{
+	struct ibmvscsis_tport *tport = container_of(wwn,
+						     struct ibmvscsis_tport,
+						     tport_wwn);
+
+	pr_debug("drop_tport(%s\n",
+		 config_item_name(&tport->tport_wwn.wwn_group.cg_item));
+}
+
+static struct se_portal_group *ibmvscsis_make_tpg(struct se_wwn *wwn,
+						  struct config_group *group,
+						  const char *name)
+{
+	struct ibmvscsis_tport *tport =
+		container_of(wwn, struct ibmvscsis_tport, tport_wwn);
+	int ret;
+
+	tport->releasing = false;
+
+	ret = core_tpg_register(&tport->tport_wwn,
+				&tport->se_tpg,
+				tport->tport_proto_id);
+	if (ret)
+		return ERR_PTR(ret);
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
+	unsigned long tmp;
+	int ret;
+
+	ret = kstrtoul(page, 0, &tmp);
+	if (ret < 0) {
+		pr_err("Unable to extract ibmvscsis_tpg_store_enable\n");
+		return -EINVAL;
+	}
+
+	if ((tmp != 0) && (tmp != 1)) {
+		pr_err("Illegal value for ibmvscsis_tpg_store_enable: %lu\n",
+		       tmp);
+		return -EINVAL;
+	}
+
+	if (tmp == 1)
+		tport->enabled = true;
+	else
+		tport->enabled = false;
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
+	.shutdown_session		= ibmvscsis_shutdown_session,
+	.close_session			= ibmvscsis_close_session,
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
+	 * Setup function pointers for logic in target_cor_fabric_configfs.c
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
+ * Note: vio_register_driver() registers callback functions, and atleast one
+ * of those call back functions calls TCM - Linux IO Target Subsystem, thus
+ * the SCSI Target template must be registered before vio_register_driver()
+ * is called.
+ */
+static int __init ibmvscsis_init(void)
+{
+	int ret = -ENOMEM;
+
+	ret = get_system_info();
+	if (ret) {
+		pr_err("ret %d from get_system_info\n", ret);
+		goto out;
+	}
+
+	ret = class_register(&ibmvscsis_class);
+	if (ret) {
+		pr_err("failed class register\n");
+		goto out;
+	}
+
+	ret = target_register_template(&ibmvscsis_ops);
+	if (ret) {
+		pr_err("ret %d from target_register_template\n", ret);
+		goto unregister_class;
+	}
+
+	vtgtd = create_workqueue("ibmvscsis");
+	if (!vtgtd)
+		goto unregister_target;
+
+	ret = vio_register_driver(&ibmvscsis_driver);
+	if (ret) {
+		pr_err("ret %d from vio_register_driver\n", ret);
+		goto destroy_wq;
+	}
+
+	return 0;
+
+destroy_wq:
+	destroy_workqueue(vtgtd);
+unregister_target:
+	target_unregister_template(&ibmvscsis_ops);
+unregister_class:
+	class_unregister(&ibmvscsis_class);
+out:
+	return ret;
+};
+
+static void __exit ibmvscsis_exit(void)
+{
+	pr_info("Unregister IBM virtual SCSI driver\n");
+	vio_unregister_driver(&ibmvscsis_driver);
+	destroy_workqueue(vtgtd);
+	target_unregister_template(&ibmvscsis_ops);
+	class_unregister(&ibmvscsis_class);
+};
+
+MODULE_DESCRIPTION("IBMVSCSIS fabric driver");
+MODULE_AUTHOR("Bryant G. Ly");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(IBMVSCSIS_VERSION);
+module_init(ibmvscsis_init);
+module_exit(ibmvscsis_exit);
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi_tgt.h b/drivers/scsi/ibmvscsi/ibmvscsi_tgt.h
new file mode 100644
index 0000000..23e9449
--- /dev/null
+++ b/drivers/scsi/ibmvscsi/ibmvscsi_tgt.h
@@ -0,0 +1,169 @@
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
+#define SCSOLNT_RESP_SHIFT      1
+#define UCSOLNT_RESP_SHIFT      2
+
+#define SCSOLNT		BIT(SCSOLNT_RESP_SHIFT)
+#define UCSOLNT		BIT(UCSOLNT_RESP_SHIFT)
+
+#define INQ_DATA_OFFSET 8
+#define NO_SUCH_LUN ((u64)-1LL)
+
+struct dma_window {
+	u32 liobn;	/* Unique per vdevice			*/
+	u64 tce_base;	/* Physical location of the TCE table	*/
+	u64 tce_size;	/* Size of the TCE table in bytes      */
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
+struct crq_queue {
+	struct viosrp_crq *msgs;
+	int size, cur;
+	dma_addr_t msg_token;
+	spinlock_t lock;
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
+struct ibmvscsis_cmd {
+	/* Used for libsrp processing callbacks */
+	struct scsi_cmnd sc;
+	/* Used for TCM Core operations */
+	struct se_cmd se_cmd;
+	/* Sense buffer that will be mapped into outgoing status */
+	unsigned char sense_buf[TRANSPORT_SENSE_BUFFER];
+	u32 lun;
+};
+
+struct ibmvscsis_crq_msg {
+	u8 valid;
+	u8 format;
+	u8 rsvd;
+	u8 status;
+	u16 rsvd1;
+	__be16 IU_length;
+	__be64 IU_data_ptr;
+};
+
+struct ibmvscsis_tport {
+	/* SCSI protocol the tport is providing */
+	u8 tport_proto_id;
+	/* ASCII formatted WWPN for SRP Target port */
+	char tport_name[IBMVSCSIS_NAMELEN];
+	/* Returned by ibmvscsis_make_tport() */
+	struct se_wwn tport_wwn;
+	int lun_count;
+	/* Returned by ibmvscsis_make_tpg() */
+	struct se_portal_group se_tpg;
+	/* ibmvscsis port target portal group tag for TCM */
+	u16 tport_tpgt;
+	/* Pointer to TCM session for I_T Nexus */
+	struct se_session *se_sess;
+	struct ibmvscsis_cmd *cmd;
+	bool enabled;
+	bool releasing;
+};
+
+struct ibmvscsis_adapter {
+	struct target_dds dds;
+	struct device dev;
+	struct vio_dev *dma_dev;
+	struct list_head siblings;
+
+	struct crq_queue crq_queue;
+	struct work_struct crq_work;
+
+	atomic_t req_lim_delta;
+	u32 liobn;
+	u32 riobn;
+
+	struct srp_target *target;
+
+	struct list_head list;
+	struct ibmvscsis_tport tport;
+	struct ibmvscsis_cmd *cmd;
+	struct client_info client_data;
+};
+
+struct ibmvscsis_nacl {
+	/* Returned by ibmvscsis_make_nexus */
+	struct se_node_acl se_node_acl;
+};
+
+enum srp_trans_event {
+	UNUSED_FORMAT = 0,
+	PARTNER_FAILED = 1,
+	PARTNER_DEREGISTER = 2,
+	MIGRATED = 6
+};
+
+enum scsi_lun_addr_method {
+	SCSI_LUN_ADDR_METHOD_PERIPHERAL   = 0,
+	SCSI_LUN_ADDR_METHOD_FLAT         = 1,
+	SCSI_LUN_ADDR_METHOD_LUN          = 2,
+	SCSI_LUN_ADDR_METHOD_EXTENDED_LUN = 3,
+};
+
+enum srp_os_type {
+	OS400 = 1,
+	LINUX = 2,
+	AIX = 3,
+	OFW = 4
+};
+
+#define vio_iu(IUE) ((union viosrp_iu *)((IUE)->sbuf->buf))
+
+#define h_reg_crq(ua, tok, sz)\
+			plpar_hcall_norets(H_REG_CRQ, ua, tok, sz)
+
+#endif
diff --git a/drivers/scsi/ibmvscsi/libsrp.c b/drivers/scsi/ibmvscsi/libsrp.c
new file mode 100644
index 0000000..32351382
--- /dev/null
+++ b/drivers/scsi/ibmvscsi/libsrp.c
@@ -0,0 +1,386 @@
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
+#define pr_fmt(fmt)     KBUILD_MODNAME ": " fmt
+
+#include <linux/printk.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/kfifo.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include <linux/module.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/srp.h>
+#include <target/target_core_base.h>
+
+#include "libsrp.h"
+
+static int srp_iu_pool_alloc(struct srp_queue *q, size_t max,
+			     struct srp_buf **ring)
+{
+	int i;
+	struct iu_entry *iue;
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
+EXPORT_SYMBOL_GPL(srp_target_alloc);
+
+void srp_target_free(struct srp_target *target)
+{
+	dev_set_drvdata(target->dev, NULL);
+	srp_ring_free(target->dev, target->rx_ring, target->rx_ring_size,
+		      target->srp_iu_size);
+	srp_iu_pool_free(&target->iu_queue);
+}
+EXPORT_SYMBOL_GPL(srp_target_free);
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
+EXPORT_SYMBOL_GPL(srp_iu_get);
+
+void srp_iu_put(struct iu_entry *iue)
+{
+	kfifo_in_locked(&iue->target->iu_queue.queue, (void *)&iue,
+			sizeof(void *), &iue->target->iu_queue.lock);
+}
+EXPORT_SYMBOL_GPL(srp_iu_put);
+
+static int srp_direct_data(struct scsi_cmnd *sc, struct srp_direct_buf *md,
+			   enum dma_data_direction dir, srp_rdma_t rdma_io,
+			   int dma_map, int ext_desc)
+{
+	struct iu_entry *iue = NULL;
+	struct scatterlist *sg = NULL;
+	int err, nsg = 0, len;
+
+	if (dma_map) {
+		iue = (struct iu_entry *)sc->SCp.ptr;
+		sg = scsi_sglist(sc);
+		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
+				 DMA_BIDIRECTIONAL);
+		if (!nsg) {
+			pr_err("fail to map %p %d\n", iue, scsi_sg_count(sc));
+			return 0;
+		}
+		len = min(scsi_bufflen(sc), be32_to_cpu(md->len));
+	} else {
+		len = be32_to_cpu(md->len);
+	}
+
+	err = rdma_io(sc, sg, nsg, md, 1, dir, len);
+
+	if (dma_map)
+		dma_unmap_sg(iue->target->dev, sg, nsg, DMA_BIDIRECTIONAL);
+
+	return err;
+}
+
+static int srp_indirect_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
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
+		iue = (struct iu_entry *)sc->SCp.ptr;
+		sg = scsi_sglist(sc);
+	}
+
+	nmd = be32_to_cpu(id->table_desc.len) / sizeof(struct srp_direct_buf);
+
+	if ((dir == DMA_FROM_DEVICE && nmd == cmd->data_in_desc_cnt) ||
+	    (dir == DMA_TO_DEVICE && nmd == cmd->data_out_desc_cnt)) {
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
+		err = rdma_io(sc, &dummy, 1, &id->table_desc, 1, DMA_TO_DEVICE,
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
+		nsg = dma_map_sg(iue->target->dev, sg, scsi_sg_count(sc),
+				 DMA_BIDIRECTIONAL);
+		if (!nsg) {
+			pr_err("fail to map %p %d\n", iue, scsi_sg_count(sc));
+			err = -EIO;
+			goto free_mem;
+		}
+		len = min(scsi_bufflen(sc), be32_to_cpu(id->len));
+	} else {
+		len = be32_to_cpu(id->len);
+	}
+
+	err = rdma_io(sc, sg, nsg, md, nmd, dir, len);
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
+int srp_transfer_data(struct scsi_cmnd *sc, struct srp_cmd *cmd,
+		      srp_rdma_t rdma_io, int dma_map, int ext_desc)
+{
+	struct srp_direct_buf *md;
+	struct srp_indirect_buf *id;
+	enum dma_data_direction dir;
+	int offset, err = 0;
+	u8 format;
+
+	offset = cmd->add_cdb_len & ~3;
+
+	dir = srp_cmd_direction(cmd);
+	if (dir == DMA_FROM_DEVICE)
+		offset += data_out_desc_size(cmd);
+
+	if (dir == DMA_TO_DEVICE)
+		format = cmd->buf_fmt >> 4;
+	else
+		format = cmd->buf_fmt & ((1U << 4) - 1);
+
+	switch (format) {
+	case SRP_NO_DATA_DESC:
+		break;
+	case SRP_DATA_DESC_DIRECT:
+		md = (struct srp_direct_buf *)(cmd->add_data + offset);
+		err = srp_direct_data(sc, md, dir, rdma_io, dma_map, ext_desc);
+		break;
+	case SRP_DATA_DESC_INDIRECT:
+		id = (struct srp_indirect_buf *)(cmd->add_data + offset);
+		err = srp_indirect_data(sc, cmd, id, dir, rdma_io, dma_map,
+					ext_desc);
+		break;
+	default:
+		pr_err("Unknown format %d %x\n", dir, format);
+		err = -EINVAL;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(srp_transfer_data);
+
+u64 srp_data_length(struct srp_cmd *cmd, enum dma_data_direction dir)
+{
+	struct srp_direct_buf *md;
+	struct srp_indirect_buf *id;
+	u64 len = 0;
+	unsigned offset = cmd->add_cdb_len & ~3;
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
+EXPORT_SYMBOL_GPL(srp_data_length);
+
+MODULE_DESCRIPTION("SCSI RDMA Protocol lib functions");
+MODULE_AUTHOR("FUJITA Tomonori");
+MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/ibmvscsi/libsrp.h b/drivers/scsi/ibmvscsi/libsrp.h
new file mode 100644
index 0000000..bf9e30b
--- /dev/null
+++ b/drivers/scsi/ibmvscsi/libsrp.h
@@ -0,0 +1,91 @@
+#ifndef __LIBSRP_H__
+#define __LIBSRP_H__
+
+#include <linux/list.h>
+#include <linux/kfifo.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+#include <scsi/srp.h>
+#include <target/target_core_base.h>
+
+enum srp_task_attributes {
+	SRP_SIMPLE_TASK = 0,
+	SRP_HEAD_TASK = 1,
+	SRP_ORDERED_TASK = 2,
+	SRP_ACA_TASK = 4
+};
+
+enum iue_flags {
+	V_DIOVER,
+	V_WRITE,
+	V_LINKED,
+	V_FLYING,
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
+	struct Scsi_Host *shost;
+	struct se_device *tgt;
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
+};
+
+typedef int (srp_rdma_t)(struct scsi_cmnd *, struct scatterlist *, int,
+			 struct srp_direct_buf *, int,
+			 enum dma_data_direction, unsigned int);
+extern int srp_target_alloc(struct srp_target *, struct device *,
+			    size_t, size_t);
+extern void srp_target_free(struct srp_target *);
+extern struct iu_entry *srp_iu_get(struct srp_target *);
+extern void srp_iu_put(struct iu_entry *);
+extern int srp_transfer_data(struct scsi_cmnd *, struct srp_cmd *, srp_rdma_t,
+			     int, int);
+extern u64 srp_data_length(struct srp_cmd *cmd, enum dma_data_direction dir);
+static inline struct srp_target *host_to_srp_target(struct Scsi_Host *host)
+{
+	return (struct srp_target *)host->hostdata;
+}
+
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

V2
Addressed comments from Bart/Joe in regards to styling and code structure

V3
Addressed James Bottomley's comments in regards to having the old libsrp
reverted to make it clear that we are resurrecting the old vscsi target
driver and making changes to it to utilize LIO. I also made libsrp a linked
file to the ibmvscsi module per Jame's comments.

2.5.4 (Apple Git-61)

