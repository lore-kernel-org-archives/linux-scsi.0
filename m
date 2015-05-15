From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 1/1] cxlflash: Base support for IBM CXL Flash Adapter
Date: Fri, 15 May 2015 16:10:32 -0500
Message-ID: <1431724232-29321-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:36560 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422755AbbEOVLg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2015 17:11:36 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 15 May 2015 17:11:35 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id CB624C9003C
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2015 17:02:39 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4FLBVJu56164454
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2015 21:11:31 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4FLBUfG009839
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2015 17:11:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org
Cc: mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

SCSI device driver to support filesystem access on the IBM CXL Flash adapter.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/Kconfig            |    1 +
 drivers/scsi/Makefile           |    1 +
 drivers/scsi/cxlflash/Kconfig   |   11 +
 drivers/scsi/cxlflash/Makefile  |    2 +
 drivers/scsi/cxlflash/common.h  |  250 +++++
 drivers/scsi/cxlflash/main.c    | 2224 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/cxlflash/main.h    |  111 ++
 drivers/scsi/cxlflash/sislite.h |  413 ++++++++
 8 files changed, 3013 insertions(+)
 create mode 100644 drivers/scsi/cxlflash/Kconfig
 create mode 100644 drivers/scsi/cxlflash/Makefile
 create mode 100644 drivers/scsi/cxlflash/common.h
 create mode 100644 drivers/scsi/cxlflash/main.c
 create mode 100644 drivers/scsi/cxlflash/main.h
 create mode 100755 drivers/scsi/cxlflash/sislite.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index b021bcb..ebb12a7 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -345,6 +345,7 @@ source "drivers/scsi/cxgbi/Kconfig"
 source "drivers/scsi/bnx2i/Kconfig"
 source "drivers/scsi/bnx2fc/Kconfig"
 source "drivers/scsi/be2iscsi/Kconfig"
+source "drivers/scsi/cxlflash/Kconfig"
 
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index dee160a..619f8fb 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -101,6 +101,7 @@ obj-$(CONFIG_SCSI_7000FASST)	+= wd7000.o
 obj-$(CONFIG_SCSI_EATA)		+= eata.o
 obj-$(CONFIG_SCSI_DC395x)	+= dc395x.o
 obj-$(CONFIG_SCSI_AM53C974)	+= esp_scsi.o	am53c974.o
+obj-$(CONFIG_CXLFLASH)		+= cxlflash/
 obj-$(CONFIG_MEGARAID_LEGACY)	+= megaraid.o
 obj-$(CONFIG_MEGARAID_NEWGEN)	+= megaraid/
 obj-$(CONFIG_MEGARAID_SAS)	+= megaraid/
diff --git a/drivers/scsi/cxlflash/Kconfig b/drivers/scsi/cxlflash/Kconfig
new file mode 100644
index 0000000..e98c3f6
--- /dev/null
+++ b/drivers/scsi/cxlflash/Kconfig
@@ -0,0 +1,11 @@
+#
+# IBM CXL-attached Flash Accelerator SCSI Driver
+#
+
+config CXLFLASH
+	tristate "Support for IBM CAPI Flash"
+	depends on CXL
+	default m
+	help
+	  Allows CAPI Accelerated IO to Flash
+	  If unsure, say N.
diff --git a/drivers/scsi/cxlflash/Makefile b/drivers/scsi/cxlflash/Makefile
new file mode 100644
index 0000000..dc95e20
--- /dev/null
+++ b/drivers/scsi/cxlflash/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_CXLFLASH) += cxlflash.o
+cxlflash-y += main.o
diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
new file mode 100644
index 0000000..fab3f6e
--- /dev/null
+++ b/drivers/scsi/cxlflash/common.h
@@ -0,0 +1,250 @@
+/*
+ * CXL Flash Device Driver
+ *
+ * Written by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>, IBM Corporation
+ *             Matthew R. Ochs <mrochs@linux.vnet.ibm.com>, IBM Corporation
+ *
+ * Copyright (C) 2015 IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _CXLFLASH_COMMON_H
+#define _CXLFLASH_COMMON_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+
+
+#define MAX_CONTEXT  CXLFLASH_MAX_CONTEXT       /* num contexts per afu */
+
+#define CXLFLASH_BLOCK_SIZE	4096	/* 4K blocks */
+#define CXLFLASH_MAX_XFER_SIZE	16777216	/* 16MB transfer */
+#define CXLFLASH_MAX_SECTORS	(CXLFLASH_MAX_XFER_SIZE/CXLFLASH_BLOCK_SIZE)
+
+#define NUM_RRQ_ENTRY    16     /* for master issued cmds */
+#define MAX_RHT_PER_CONTEXT (PAGE_SIZE / sizeof(struct sisl_rht_entry))
+
+/* AFU command retry limit */
+#define MC_RETRY_CNT         5	/* sufficient for SCSI check and
+				   certain AFU errors */
+
+/* Command management definitions */
+#define CXLFLASH_NUM_CMDS	(2 * CXLFLASH_MAX_CMDS)	/* Must be a pow2 for
+							   alignment and more
+							   efficient array
+							   index derivation
+							 */
+
+#define CXLFLASH_MAX_CMDS               16
+#define CXLFLASH_MAX_CMDS_PER_LUN       CXLFLASH_MAX_CMDS
+
+#define NOT_POW2(_x) ((_x) & ((_x) & ((_x) - 1)))
+#if NOT_POW2(CXLFLASH_NUM_CMDS)
+#error "CXLFLASH_NUM_CMDS is not a power of 2!"
+#endif
+
+#define CMD_BUFSIZE     PAGE_SIZE_4K
+
+/* flags in IOA status area for host use */
+#define B_DONE       0x01
+#define B_ERROR      0x02	/* set with B_DONE */
+#define B_TIMEOUT    0x04	/* set with B_DONE & B_ERROR */
+
+/*
+ * Error logging macros
+ *
+ * These wrappers around pr|dev_* add the function name and newline character
+ * automatically, avoiding the need to include them inline with each trace
+ * statement and saving line width.
+ *
+ * The parameters must be split into the format string and variable list of
+ * parameters in order to support concatenation of the function format
+ * specifier and newline character. The CONFN macro is a helper to simplify
+ * the contactenation and make it easier to change the desired format. Lastly,
+ * the variable list is passed with a dummy concatenation. This trick is used
+ * to support the case where no parameters are passed and the user simply
+ * desires a single string trace.
+ */
+#define CONFN(_s) "%s: "_s"\n"
+#define cxlflash_err(_s,   ...)	pr_err(CONFN(_s),   __func__, ##__VA_ARGS__)
+#define cxlflash_warn(_s,  ...)	pr_warn(CONFN(_s),  __func__, ##__VA_ARGS__)
+#define cxlflash_info(_s,  ...)	pr_info(CONFN(_s),  __func__, ##__VA_ARGS__)
+#define cxlflash_dbg(_s, ...)	pr_debug(CONFN(_s), __func__, ##__VA_ARGS__)
+
+#define cxlflash_dev_err(_d, _s, ...)	\
+	dev_err(_d, CONFN(_s), __func__, ##__VA_ARGS__)
+#define cxlflash_dev_warn(_d, _s, ...)	\
+	dev_warn(_d, CONFN(_s), __func__, ##__VA_ARGS__)
+#define cxlflash_dev_info(_d, _s, ...)	\
+	dev_info(_d, CONFN(_s), __func__, ##__VA_ARGS__)
+#define cxlflash_dev_dbg(_d, _s, ...)	\
+	dev_dbg(_d, CONFN(_s), __func__, ##__VA_ARGS__)
+
+enum cxlflash_lr_state {
+	LINK_RESET_INVALID,
+	LINK_RESET_REQUIRED,
+	LINK_RESET_COMPLETE
+};
+
+enum cxlflash_init_state {
+	INIT_STATE_NONE,
+	INIT_STATE_AFU,
+	INIT_STATE_PCI,
+	INIT_STATE_SCSI
+};
+
+/*
+ * Each context has its own set of resource handles that is visible
+ * only from that context.
+ */
+
+/* Single AFU context can be pointed to by multiple client connections.
+ * The client can create multiple endpoints (mc_hndl_t) to the same
+ * (context + AFU).
+ */
+struct ctx_info {
+	volatile struct sisl_ctrl_map *ctrl_map; /* initialized at startup */
+	struct sisl_rht_entry *rht_start; /* 1 page (req'd for alignment),
+					     alloc/free on attach/detach */
+	u32 rht_out;		/* Number of checked out RHT entries */
+	u32 rht_perms;		/* User-defined permissions for RHT entries */
+	struct lun_info **rht_lun; /* Mapping of RHT entries to LUNs */
+
+	struct cxl_ioctl_start_work work;
+	int ctxid;
+	int lfd;
+	pid_t pid;
+	u32 padding;
+	struct cxl_context *ctx;
+	struct list_head luns;	/* LUNs attached to this context */
+};
+
+struct cxlflash {
+	struct afu *afu;
+	struct cxl_context *mcctx;
+
+	struct pci_dev *dev;
+	struct pci_device_id *dev_id;
+	struct Scsi_Host *host;
+
+	unsigned long cxlflash_regs_pci;
+
+	wait_queue_head_t reset_wait_q;
+	wait_queue_head_t msi_wait_q;
+	wait_queue_head_t eeh_wait_q;
+
+	struct work_struct work_q;
+	enum cxlflash_init_state init_state;
+	enum cxlflash_lr_state lr_state;
+	int lr_port;
+
+	struct cxl_afu *cxl_afu;
+	timer_t timer_hb;
+	timer_t timer_fc;
+
+	struct pci_pool *cxlflash_cmd_pool;
+	struct pci_dev *parent_dev;
+
+	int num_user_contexts;
+	struct ctx_info *ctx_info[MAX_CONTEXT];
+	struct file_operations cxl_fops;
+
+	int last_lun_index;
+
+	wait_queue_head_t tmf_wait_q;
+	wait_queue_head_t sync_wait_q;
+	u8 context_reset_active:1;
+	u8 tmf_active:1;
+	u8 sync_active:1;
+};
+
+struct afu_cmd {
+	struct sisl_ioarcb rcb;	/* IOARCB (cache line aligned) */
+	struct sisl_ioasa sa;	/* IOASA must follow IOARCB */
+	spinlock_t slock;
+	struct timer_list timer;
+	char *buf;		/* per command buffer */
+	struct afu *back;
+	int slot;
+	atomic_t free;
+	u8 special:1;
+	u8 internal:1;
+	u8 sync:1;
+
+} __aligned(cache_line_size());
+
+struct afu {
+	/* Stuff requiring alignment go first. */
+
+	u64 rrq_entry[NUM_RRQ_ENTRY];	/* 128B RRQ (page aligned) */
+	/*
+	 * Command & data for AFU commands.
+	 */
+	struct afu_cmd cmd[CXLFLASH_NUM_CMDS];
+
+	/* Housekeeping data */
+	struct mutex afu_mutex;	/* for anything that needs serialization
+				   e. g. to access afu */
+	struct mutex err_mutex;	/* for signalling error thread */
+	wait_queue_head_t err_cv;
+	int err_flag;
+#define E_SYNC_INTR   0x1	/* synchronous error interrupt */
+#define E_ASYNC_INTR  0x2	/* asynchronous error interrupt */
+
+	/* Beware of alignment till here. Preferably introduce new
+	 * fields after this point
+	 */
+
+	/* AFU HW */
+	int afu_fd;
+	struct cxl_ioctl_start_work work;
+	volatile struct cxlflash_afu_map *afu_map;	/* entire MMIO map */
+	volatile struct sisl_host_map *host_map;	/* MC host map */
+	volatile struct sisl_ctrl_map *ctrl_map;	/* MC control map */
+
+	ctx_hndl_t ctx_hndl;	/* master's context handle */
+	u64 *hrrq_start;
+	u64 *hrrq_end;
+	volatile u64 *hrrq_curr;
+	unsigned int toggle;
+	u64 room;
+	u64 hb;
+	u32 cmd_couts;		/* Number of command checkouts */
+	u32 internal_lun;	/* User-desired LUN mode for this AFU */
+
+	char version[8];
+	u64 interface_version;
+
+	struct cxlflash *back;	/* Pointer back to parent cxlflash */
+
+} __aligned(PAGE_SIZE_4K);
+
+static inline u64 lun_to_lunid(u64 lun)
+{
+	u64 lun_id;
+
+	int_to_scsilun(lun, (struct scsi_lun *)&lun_id);
+	return swab64(lun_id);
+}
+
+int cxlflash_send_cmd(struct afu *, struct afu_cmd *);
+void cxlflash_wait_resp(struct afu *, struct afu_cmd *);
+int cxlflash_afu_reset(struct cxlflash *);
+struct afu_cmd *cxlflash_cmd_checkout(struct afu *);
+void cxlflash_cmd_checkin(struct afu_cmd *);
+int cxlflash_afu_sync(struct afu *, ctx_hndl_t, res_hndl_t, u8);
+int cxlflash_alloc_lun(struct scsi_device *);
+void cxlflash_init_lun(struct scsi_device *);
+void cxlflash_list_init(void);
+void cxlflash_list_terminate(void);
+int cxlflash_slave_alloc(struct scsi_device *);
+int cxlflash_slave_configure(struct scsi_device *);
+void cxlflash_slave_destroy(struct scsi_device *);
+#endif /* ifndef _CXLFLASH_COMMON_H */
+
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
new file mode 100644
index 0000000..1e06a25
--- /dev/null
+++ b/drivers/scsi/cxlflash/main.c
@@ -0,0 +1,2224 @@
+/*
+ * CXL Flash Device Driver
+ *
+ * Written by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>, IBM Corporation
+ *             Matthew R. Ochs <mrochs@linux.vnet.ibm.com>, IBM Corporation
+ *
+ * Copyright (C) 2015 IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/delay.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include <asm/unaligned.h>
+
+#include <misc/cxl.h>
+
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_host.h>
+
+#include "main.h"
+#include "sislite.h"
+#include "common.h"
+
+MODULE_DESCRIPTION(CXLFLASH_ADAPTER_NAME);
+MODULE_AUTHOR("Manoj N. Kumar <manoj@linux.vnet.ibm.com>");
+MODULE_AUTHOR("Matthew R. Ochs <mrochs@linux.vnet.ibm.com>");
+MODULE_LICENSE("GPL");
+
+
+/**
+ * cxlflash_cmd_checkout() - checks out an AFU command
+ * @afu:	AFU to checkout from.
+ *
+ * Commands are checked out in a round-robin fashion. The buffer and
+ * CDB within the command are initialized (zeroed) prior to returning.
+ *
+ * Return: The checked out command or NULL when command pool is empty.
+ */
+struct afu_cmd *cxlflash_cmd_checkout(struct afu *afu)
+{
+	int k, dec = CXLFLASH_NUM_CMDS;
+	struct afu_cmd *cmd;
+
+	while (dec--) {
+		k = (afu->cmd_couts++ & (CXLFLASH_NUM_CMDS - 1));
+
+		cmd = &afu->cmd[k];
+
+		if (!atomic_dec_if_positive(&cmd->free)) {
+			cxlflash_dbg("returning found index=%d", cmd->slot);
+			memset(cmd->buf, 0, CMD_BUFSIZE);
+			memset(cmd->rcb.cdb, 0, sizeof(cmd->rcb.cdb));
+			return cmd;
+		}
+	}
+
+	return NULL;
+}
+
+/**
+ * cxlflash_cmd_checkin() - checks in an AFU command
+ * @cmd:	AFU command to checkin.
+ *
+ * Safe to pass commands that have already been checked in. Several
+ * internal tracking fields are reset as part of the checkin.
+ */
+void cxlflash_cmd_checkin(struct afu_cmd *cmd)
+{
+	if (unlikely(atomic_inc_return(&cmd->free) != 1)) {
+		cxlflash_err("Freeing cmd (%d) that is not in use!", cmd->slot);
+		return;
+	}
+
+	cmd->special = 0;
+	cmd->internal = false;
+	cmd->sync = false;
+	cmd->rcb.timeout = 0;
+
+	cxlflash_dbg("releasing cmd index=%d", cmd->slot);
+}
+
+/**
+ * process_cmd_err() - command error handler
+ * @cmd:	AFU command that experienced the error.
+ * @scp:	SCSI command associated with the AFU command in error.
+ *
+ * Translates error bits from AFU command to SCSI command results.
+ */
+static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
+{
+	struct sisl_ioarcb *ioarcb;
+	struct sisl_ioasa *ioasa;
+
+	if (unlikely(!cmd))
+		return;
+
+	ioarcb = &(cmd->rcb);
+	ioasa = &(cmd->sa);
+
+	if (ioasa->rc.flags & SISL_RC_FLAGS_UNDERRUN) {
+		cxlflash_dbg("cmd underrun cmd = %p scp = %p", cmd, scp);
+		scp->result = (DID_ERROR << 16);
+	}
+
+	if (ioasa->rc.flags & SISL_RC_FLAGS_OVERRUN) {
+		cxlflash_dbg("cmd underrun cmd = %p scp = %p", cmd, scp);
+		scp->result = (DID_ERROR << 16);
+	}
+
+	cxlflash_dbg("cmd failed afu_rc=%d scsi_rc=%d fc_rc=%d "
+		     "afu_extra=0x%x, scsi_entra=0x%x, fc_extra=0x%x",
+		     ioasa->rc.afu_rc, ioasa->rc.scsi_rc, ioasa->rc.fc_rc,
+		     ioasa->afu_extra, ioasa->scsi_extra, ioasa->fc_extra);
+
+	if (ioasa->rc.scsi_rc) {
+		/* We have a SCSI status */
+		if (ioasa->rc.flags & SISL_RC_FLAGS_SENSE_VALID)
+			memcpy(scp->sense_buffer, ioasa->sense_data,
+			       SISL_SENSE_DATA_LEN);
+		scp->result = ioasa->rc.scsi_rc | (DID_ERROR << 16);
+	}
+
+	/*
+	 * We encountered an error. Set scp->result based on nature
+	 * of error.
+	 */
+	if (ioasa->rc.fc_rc) {
+		/* We have an FC status */
+		switch (ioasa->rc.fc_rc) {
+		case SISL_FC_RC_RESIDERR:
+			/* Resid mismatch between adapter and device */
+		case SISL_FC_RC_TGTABORT:
+		case SISL_FC_RC_ABORTOK:
+		case SISL_FC_RC_ABORTFAIL:
+		case SISL_FC_RC_LINKDOWN:
+		case SISL_FC_RC_NOLOGI:
+		case SISL_FC_RC_ABORTPEND:
+			scp->result = (DID_IMM_RETRY << 16);
+			break;
+		case SISL_FC_RC_RESID:
+			/* This indicates an FCP resid underrun */
+			if (!(ioasa->rc.flags & SISL_RC_FLAGS_OVERRUN)) {
+				/* If the SISL_RC_FLAGS_OVERRUN flag was set,
+				 * then we will handle this error else where.
+				 * If not then we must handle it here.
+				 * This is probably an AFU bug. We will
+				 * attempt a retry to see if that resolves it.
+				 */
+				scp->result = (DID_IMM_RETRY << 16);
+			}
+			break;
+		case SISL_FC_RC_WRABORTPEND:
+		case SISL_FC_RC_NOEXP:
+		case SISL_FC_RC_INUSE:
+			scp->result = (DID_ERROR << 16);
+			break;
+		}
+	}
+
+	if (ioasa->rc.afu_rc) {
+		/* We have an AFU error */
+		switch (ioasa->rc.afu_rc) {
+		case SISL_AFU_RC_NO_CHANNELS:
+			scp->result = (DID_MEDIUM_ERROR << 16);
+			break;
+		case SISL_AFU_RC_DATA_DMA_ERR:
+			switch (ioasa->afu_extra) {
+			case SISL_AFU_DMA_ERR_PAGE_IN:
+				/* Retry */
+				scp->result = (DID_IMM_RETRY << 16);
+				break;
+			case SISL_AFU_DMA_ERR_INVALID_EA:
+			default:
+				scp->result = (DID_ERROR << 16);
+			}
+			break;
+		case SISL_AFU_RC_OUT_OF_DATA_BUFS:
+			/* Retry */
+			scp->result = (DID_ALLOC_FAILURE << 16);
+			break;
+		default:
+			scp->result = (DID_ERROR << 16);
+		}
+	}
+}
+
+/**
+ * cmd_complete() - command completion handler
+ * @cmd:	AFU command that has completed.
+ *
+ * Prepares and submits command that has either completed or timed out to
+ * the SCSI stack. Checks AFU command back into command pool.
+ */
+static void cmd_complete(struct afu_cmd *cmd)
+{
+	unsigned long lock_flags = 0UL;
+	struct scsi_cmnd *scp;
+	struct afu *afu = cmd->back;
+	struct cxlflash *cxlflash = afu->back;
+
+	spin_lock_irqsave(&cmd->slock, lock_flags);
+	cmd->sa.host_use_b[0] |= B_DONE;
+	spin_unlock_irqrestore(&cmd->slock, lock_flags);
+
+	/* already stopped if timer fired */
+	del_timer(&cmd->timer);
+
+	if (cmd->rcb.scp) {
+		scp = cmd->rcb.scp;
+		if (cmd->sa.rc.afu_rc || cmd->sa.rc.scsi_rc ||
+		    cmd->sa.rc.fc_rc)
+			process_cmd_err(cmd, scp);
+		else
+			scp->result = (DID_OK << 16);
+
+		cxlflash_dbg("calling scsi_set_resid, scp=%p "
+			     "result=%x resid=%d",
+			     cmd->rcb.scp, scp->result, cmd->sa.resid);
+
+		scsi_set_resid(scp, cmd->sa.resid);
+		scsi_dma_unmap(scp);
+		scp->scsi_done(scp);
+		cmd->rcb.scp = NULL;
+		if (cmd->special) {
+			cxlflash->tmf_active = false;
+			wake_up_all(&cxlflash->tmf_wait_q);
+		}
+	}
+	if (cmd->sync) {
+		cxlflash->sync_active = false;
+		wake_up_all(&cxlflash->sync_wait_q);
+	}
+
+	/* Done with command */
+	cxlflash_cmd_checkin(cmd);
+}
+
+/**
+ * cxlflash_send_tmf() - sends a Task Management Function (TMF)
+ * @afu:	AFU to checkout from.
+ * @scp:	SCSI command from stack.
+ * @tmfcmd:	TMF command to send.
+ *
+ * Return:
+ *	0 on success
+ *	SCSI_MLQUEUE_HOST_BUSY when host is busy
+ */
+int cxlflash_send_tmf(struct afu *afu, struct scsi_cmnd *scp, u64 tmfcmd)
+{
+	struct afu_cmd *cmd;
+
+	u32 port_sel = scp->device->channel + 1;
+	short lflag = 0;
+	struct Scsi_Host *host = scp->device->host;
+	struct cxlflash *cxlflash = (struct cxlflash *)host->hostdata;
+	int rc = 0;
+
+	while (cxlflash->tmf_active)
+		wait_event(cxlflash->tmf_wait_q, !cxlflash->tmf_active);
+
+	cmd = cxlflash_cmd_checkout(afu);
+	if (unlikely(!cmd)) {
+		cxlflash_err("could not get a free command");
+		rc = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	}
+
+	cmd->rcb.ctx_id = afu->ctx_hndl;
+	cmd->rcb.port_sel = port_sel;
+	cmd->rcb.lun_id = lun_to_lunid(scp->device->lun);
+
+	lflag = SISL_REQ_FLAGS_TMF_CMD;
+
+	cmd->rcb.req_flags = (SISL_REQ_FLAGS_PORT_LUN_ID |
+				SISL_REQ_FLAGS_SUP_UNDERRUN | lflag);
+
+	/* Stash the scp in the reserved field, for reuse during interrupt */
+	cmd->rcb.scp = scp;
+	cmd->special = 0x1;
+	cxlflash->tmf_active = true;
+
+	cmd->sa.host_use_b[1] = 0;	/* reset retry cnt */
+
+	/* Copy the CDB from the cmd passed in */
+	memcpy(cmd->rcb.cdb, &tmfcmd, sizeof(tmfcmd));
+
+	/* Send the command */
+	rc = cxlflash_send_cmd(afu, cmd);
+	if (!rc)
+		wait_event(cxlflash->tmf_wait_q, !cxlflash->tmf_active);
+out:
+	return rc;
+
+}
+
+/**
+ * cxlflash_driver_info() - information handler for this host driver
+ * @host:	SCSI host associated with device.
+ *
+ * Return: A string describing the device.
+ */
+static const char *cxlflash_driver_info(struct Scsi_Host *host)
+{
+	return CXLFLASH_ADAPTER_NAME;
+}
+
+/**
+ * cxlflash_queuecommand() - sends a mid-layer request
+ * @host:	SCSI host associated with device.
+ * @scp:	SCSI command to send.
+ *
+ * Return:
+ *	0 on success
+ *	SCSI_MLQUEUE_DEVICE_BUSY when device is busy
+ *	SCSI_MLQUEUE_HOST_BUSY when host is busy
+ */
+static int cxlflash_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scp)
+{
+	struct cxlflash *cxlflash = (struct cxlflash *)host->hostdata;
+	struct afu *afu = cxlflash->afu;
+	struct pci_dev *pdev = cxlflash->dev;
+	struct afu_cmd *cmd;
+	u32 port_sel = scp->device->channel + 1;
+	int nseg, i, ncount;
+	struct scatterlist *sg;
+	short lflag = 0;
+	int rc = 0;
+
+	cxlflash_dbg("(scp=%p) %d/%d/%d/%llu cdb=(%08x-%08x-%08x-%08x)",
+		     scp, host->host_no, scp->device->channel,
+		     scp->device->id, scp->device->lun,
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
+
+	while (cxlflash->tmf_active)
+		wait_event(cxlflash->tmf_wait_q, !cxlflash->tmf_active);
+
+	cmd = cxlflash_cmd_checkout(afu);
+	if (unlikely(!cmd)) {
+		cxlflash_err("could not get a free command");
+		rc = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	}
+
+	cmd->rcb.ctx_id = afu->ctx_hndl;
+	cmd->rcb.port_sel = port_sel;
+	cmd->rcb.lun_id = lun_to_lunid(scp->device->lun);
+
+	if (scp->sc_data_direction == DMA_TO_DEVICE)
+		lflag = SISL_REQ_FLAGS_HOST_WRITE;
+	else
+		lflag = SISL_REQ_FLAGS_HOST_READ;
+
+	cmd->rcb.req_flags = (SISL_REQ_FLAGS_PORT_LUN_ID |
+				SISL_REQ_FLAGS_SUP_UNDERRUN | lflag);
+
+	/* Stash the scp in the reserved field, for reuse during interrupt */
+	cmd->rcb.scp = scp;
+
+	cmd->sa.host_use_b[1] = 0;	/* reset retry cnt */
+
+	nseg = scsi_dma_map(scp);
+	if (unlikely(nseg < 0)) {
+		cxlflash_dev_err(&pdev->dev, "Fail DMA map! nseg=%d", nseg);
+		rc = SCSI_MLQUEUE_DEVICE_BUSY;
+		goto out;
+	}
+
+	ncount = scsi_sg_count(scp);
+	scsi_for_each_sg(scp, sg, ncount, i) {
+		cmd->rcb.data_len = (sg_dma_len(sg));
+		cmd->rcb.data_ea = (sg_dma_address(sg));
+	}
+
+	/* Copy the CDB from the scsi_cmnd passed in */
+	memcpy(cmd->rcb.cdb, scp->cmnd, sizeof(cmd->rcb.cdb));
+
+	/* Send the command */
+	rc = cxlflash_send_cmd(afu, cmd);
+
+out:
+	return rc;
+}
+
+/**
+ * cxlflash_eh_device_reset_handler() - reset a single LUN
+ * @scp:	SCSI command to send.
+ *
+ * Return:
+ *	SUCCESS as defined in scsi/scsi.h
+ *	FAILED as defined in scsi/scsi.h
+ */
+static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
+{
+	int rc = SUCCESS;
+	struct Scsi_Host *host = scp->device->host;
+	struct cxlflash *cxlflash = (struct cxlflash *)host->hostdata;
+	struct afu *afu = cxlflash->afu;
+
+	cxlflash_dbg("(scp=%p) %d/%d/%d/%llu "
+		     "cdb=(%08x-%08x-%08x-%08x)", scp,
+		     host->host_no, scp->device->channel,
+		     scp->device->id, scp->device->lun,
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
+
+	scp->result = (DID_OK << 16);
+	cxlflash_send_tmf(afu, scp, TMF_LUN_RESET);
+
+	cxlflash_info("returning rc=%d", rc);
+	return rc;
+}
+
+/**
+ * cxlflash_eh_host_reset_handler() - reset the host adapter
+ * @scp:	SCSI command from stack identifying host.
+ *
+ * Return:
+ *	SUCCESS as defined in scsi/scsi.h
+ *	FAILED as defined in scsi/scsi.h
+ */
+static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
+{
+	int rc = SUCCESS;
+	int rcr = 0;
+	struct Scsi_Host *host = scp->device->host;
+	struct cxlflash *cxlflash = (struct cxlflash *)host->hostdata;
+
+	cxlflash_dbg("(scp=%p) %d/%d/%d/%llu "
+		     "cdb=(%08x-%08x-%08x-%08x)", scp,
+		     host->host_no, scp->device->channel,
+		     scp->device->id, scp->device->lun,
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
+		     get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
+
+	scp->result = (DID_OK << 16);
+	rcr = cxlflash_afu_reset(cxlflash);
+	if (rcr == 0)
+		rc = SUCCESS;
+	else
+		rc = FAILED;
+
+	cxlflash_info("returning rc=%d", rc);
+	return rc;
+}
+
+/**
+ * cxlflash_change_queue_depth() - change the queue depth for the device
+ * @sdev:	SCSI device destined for queue depth change.
+ * @qdepth:	Requested queue depth value to set.
+ *
+ * The requested queue depth is capped to the maximum supported value.
+ *
+ * Return: The actual queue depth set.
+ */
+static int cxlflash_change_queue_depth(struct scsi_device *sdev, int qdepth)
+{
+
+	if (qdepth > CXLFLASH_MAX_CMDS_PER_LUN)
+		qdepth = CXLFLASH_MAX_CMDS_PER_LUN;
+
+	scsi_change_queue_depth(sdev, qdepth);
+	return sdev->queue_depth;
+}
+
+/**
+ * cxlflash_show_port_status() - queries and presents the current port status
+ * @dev:	Generic device associated with the host owning the port.
+ * @attr:	Device attribute representing the port.
+ * @buf:	Buffer of length PAGE_SIZE to report back port status in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t cxlflash_show_port_status(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash *cxlflash = (struct cxlflash *)shost->hostdata;
+	struct afu *afu = cxlflash->afu;
+
+	char *disp_status;
+	int rc;
+	u32 port;
+	u64 status;
+	volatile u64 *fc_regs;
+
+	rc = kstrtouint((attr->attr.name + 4), 10, &port);
+	if (rc || (port > NUM_FC_PORTS))
+		return 0;
+
+	fc_regs = &afu->afu_map->global.fc_regs[port][0];
+	status =
+	    (readq_be(&fc_regs[FC_MTIP_STATUS / 8]) & FC_MTIP_STATUS_MASK);
+
+	if (status == FC_MTIP_STATUS_ONLINE)
+		disp_status = "online";
+	else if (status == FC_MTIP_STATUS_OFFLINE)
+		disp_status = "offline";
+	else
+		disp_status = "unknown";
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", disp_status);
+}
+
+/**
+ * cxlflash_show_lun_mode() - presents the current LUN mode of the host
+ * @dev:	Generic device associated with the host.
+ * @attr:	Device attribute representing the lun mode.
+ * @buf:	Buffer of length PAGE_SIZE to report back the LUN mode in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t cxlflash_show_lun_mode(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash *cxlflash = (struct cxlflash *)shost->hostdata;
+	struct afu *afu = cxlflash->afu;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", afu->internal_lun);
+}
+
+/**
+ * cxlflash_store_lun_mode() - sets the LUN mode of the host
+ * @dev:	Generic device associated with the host.
+ * @attr:	Device attribute representing the lun mode.
+ * @buf:	Buffer of length PAGE_SIZE containing the LUN mode in ASCII.
+ * @count:	Length of data resizing in @buf.
+ *
+ * The CXL Flash AFU supports a dummy LUN mode where the external
+ * links and storage are not required. Space on the FPGA is used
+ * to create 1 or 2 small LUNs which are presented to the system
+ * as if they were a normal storage device. This feature is useful
+ * during development and also provides manufacturing with a way
+ * to test the AFU without an actual device.
+ *
+ * 0 = external LUN[s] (default)
+ * 1 = internal LUN (1 x 64K, 512B blocks, id 0)
+ * 2 = internal LUN (1 x 64K, 4K blocks, id 0)
+ * 3 = internal LUN (2 x 32K, 512B blocks, ids 0,1)
+ * 4 = internal LUN (2 x 32K, 4K blocks, ids 0,1)
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t cxlflash_store_lun_mode(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct cxlflash *cxlflash = (struct cxlflash *)shost->hostdata;
+	struct afu *afu = cxlflash->afu;
+	int rc;
+	u32 lun_mode;
+
+	rc = kstrtouint(buf, 10, &lun_mode);
+	if (!rc && (lun_mode < 5) && (lun_mode != afu->internal_lun)) {
+		afu->internal_lun = lun_mode;
+		cxlflash_afu_reset(cxlflash);
+		scsi_scan_host(cxlflash->host);
+	}
+
+	return count;
+}
+
+/**
+ * cxlflash_show_dev_mode() - presents the current mode of the device
+ * @dev:	Generic device associated with the device.
+ * @attr:	Device attribute representing the device mode.
+ * @buf:	Buffer of length PAGE_SIZE to report back the dev mode in ASCII.
+ *
+ * Return: The size of the ASCII string returned in @buf.
+ */
+static ssize_t cxlflash_show_dev_mode(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	void *lun_info = (void *)sdev->hostdata;
+	char *legacy = "legacy",
+	     *superpipe = "superpipe";
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", lun_info ? superpipe : legacy);
+}
+
+/**
+ * cxlflash_wait_for_pci_err_recovery() - wait for error recovery during probe
+ * @cxlflash:	Internal structure associated with the host.
+ */
+static void cxlflash_wait_for_pci_err_recovery(struct cxlflash *cxlflash)
+{
+	struct pci_dev *pdev = cxlflash->dev;
+
+	if (pci_channel_offline(pdev))
+		wait_event_timeout(cxlflash->eeh_wait_q,
+				   !pci_channel_offline(pdev),
+				   CXLFLASH_PCI_ERROR_RECOVERY_TIMEOUT);
+}
+
+/*
+ * Host attributes
+ */
+static DEVICE_ATTR(port0, S_IRUGO, cxlflash_show_port_status, NULL);
+static DEVICE_ATTR(port1, S_IRUGO, cxlflash_show_port_status, NULL);
+static DEVICE_ATTR(lun_mode, S_IRUGO | S_IWUSR, cxlflash_show_lun_mode,
+		   cxlflash_store_lun_mode);
+
+static struct device_attribute *cxlflash_host_attrs[] = {
+	&dev_attr_port0,
+	&dev_attr_port1,
+	&dev_attr_lun_mode,
+	NULL
+};
+
+/*
+ * Device attributes
+ */
+static DEVICE_ATTR(mode, S_IRUGO, cxlflash_show_dev_mode, NULL);
+
+static struct device_attribute *cxlflash_dev_attrs[] = {
+	&dev_attr_mode,
+	NULL
+};
+
+/*
+ * Host template
+ */
+static struct scsi_host_template driver_template = {
+	.module = THIS_MODULE,
+	.name = CXLFLASH_ADAPTER_NAME,
+	.info = cxlflash_driver_info,
+	.proc_name = CXLFLASH_NAME,
+	.queuecommand = cxlflash_queuecommand,
+	.eh_device_reset_handler = cxlflash_eh_device_reset_handler,
+	.eh_host_reset_handler = cxlflash_eh_host_reset_handler,
+	.change_queue_depth = cxlflash_change_queue_depth,
+	.cmd_per_lun = 16,
+	.can_queue = CXLFLASH_MAX_CMDS,
+	.this_id = -1,
+	.sg_tablesize = SG_NONE,	/* No scatter gather support. */
+	.max_sectors = CXLFLASH_MAX_SECTORS,
+	.use_clustering = ENABLE_CLUSTERING,
+	.shost_attrs = cxlflash_host_attrs,
+	.sdev_attrs = cxlflash_dev_attrs,
+};
+
+/*
+ * Device dependent values
+ */
+static struct dev_dependent_vals dev_corsa_vals = { CXLFLASH_MAX_SECTORS };
+
+/*
+ * PCI device binding table
+ */
+static struct pci_device_id cxlflash_pci_table[] = {
+	{PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CORSA,
+	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, (kernel_ulong_t)&dev_corsa_vals},
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, cxlflash_pci_table);
+
+/**
+ * cxlflash_free_mem() - free memory associated with the AFU
+ * @cxlflash:	Internal structure associated with the host.
+ *
+ * As part of draining the AFU command pool, the timers of each
+ * command are ensured to be stopped.
+ */
+static void cxlflash_free_mem(struct cxlflash *cxlflash)
+{
+	int i;
+	char *buf = NULL;
+	struct afu *afu = cxlflash->afu;
+
+	if (cxlflash->afu) {
+		for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
+			if (afu->cmd[i].timer.function)
+				del_timer_sync(&afu->cmd[i].timer);
+			buf = afu->cmd[i].buf;
+			if (!((u64)buf & (PAGE_SIZE - 1)))
+				free_page((unsigned long)buf);
+		}
+
+		free_pages((unsigned long)afu,
+			   get_order(sizeof(struct afu)));
+		cxlflash->afu = NULL;
+	}
+}
+
+/**
+ * cxlflash_stop_afu() - stops the AFU command timers and unmaps the MMIO space
+ * @cxlflash:	Internal structure associated with the host.
+ *
+ * Safe to call with AFU in a partially allocated/initialized state.
+ */
+static void cxlflash_stop_afu(struct cxlflash *cxlflash)
+{
+	int i;
+	struct afu *afu = cxlflash->afu;
+
+	if (!afu) {
+		cxlflash_info("returning because afu is NULl");
+		return;
+	}
+
+	/* Need to stop timers before unmapping */
+	for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
+		if (afu->cmd[i].timer.function)
+			del_timer_sync(&afu->cmd[i].timer);
+	}
+
+	if (afu->afu_map) {
+		cxl_psa_unmap((void *)afu->afu_map);
+		afu->afu_map = NULL;
+	}
+}
+
+/**
+ * cxlflash_term_mc() - terminates the master context
+ * @cxlflash:	Internal structure associated with the host.
+ * @level:	Depth of allocation, where to begin waterfall tear down.
+ *
+ * Safe to call with AFU/MC in partially allocated/initialized state.
+ */
+void cxlflash_term_mc(struct cxlflash *cxlflash, enum undo_level level)
+{
+	struct afu *afu = cxlflash->afu;
+
+	if (!afu || !cxlflash->mcctx) {
+		cxlflash_err("returning from term_mc with NULL afu or MC");
+		return;
+	}
+
+	switch (level) {
+	case UNDO_START:
+		cxl_stop_context(cxlflash->mcctx);
+	case UNMAP_THREE:
+		cxlflash_dbg("before unmap 3");
+		cxl_unmap_afu_irq(cxlflash->mcctx, 3, afu);
+	case UNMAP_TWO:
+		cxlflash_dbg("before unmap 2");
+		cxl_unmap_afu_irq(cxlflash->mcctx, 2, afu);
+	case UNMAP_ONE:
+		cxlflash_dbg("before unmap 1");
+		cxl_unmap_afu_irq(cxlflash->mcctx, 1, afu);
+	case FREE_IRQ:
+		cxlflash_dbg("before cxl_free_afu_irqs");
+		cxl_free_afu_irqs(cxlflash->mcctx);
+		cxlflash_dbg("before cxl_release_context");
+	case RELEASE_CONTEXT:
+		cxl_release_context(cxlflash->mcctx);
+		cxlflash->mcctx = NULL;
+	}
+}
+
+/**
+ * cxlflash_term_afu() - terminates the AFU
+ * @cxlflash:	Internal structure associated with the host.
+ *
+ * Safe to call with AFU/MC in partially allocated/initialized state.
+ */
+static void cxlflash_term_afu(struct cxlflash *cxlflash)
+{
+	cxlflash_term_mc(cxlflash, UNDO_START);
+
+	/* Need to stop timers before unmapping */
+	if (cxlflash->afu)
+		cxlflash_stop_afu(cxlflash);
+
+	cxlflash_dbg("returning");
+}
+
+/**
+ * cxlflash_remove() - PCI entry point to tear down host
+ * @pdev:	PCI device associated with the host.
+ *
+ * Safe to use as a cleanup in partially allocated/initialized state.
+ */
+static void cxlflash_remove(struct pci_dev *pdev)
+{
+	struct cxlflash *cxlflash = pci_get_drvdata(pdev);
+
+	cxlflash_dev_dbg(&pdev->dev, "enter cxlflash_remove!");
+
+	while (cxlflash->tmf_active)
+		wait_event(cxlflash->tmf_wait_q, !cxlflash->tmf_active);
+
+	switch (cxlflash->init_state) {
+	case INIT_STATE_SCSI:
+		scsi_remove_host(cxlflash->host);
+		cxlflash_dev_dbg(&pdev->dev, "after scsi_remove_host!");
+		scsi_host_put(cxlflash->host);
+		cxlflash_dev_dbg(&pdev->dev, "after scsi_host_put!");
+		/* Fall through */
+	case INIT_STATE_PCI:
+		pci_release_regions(cxlflash->dev);
+		pci_disable_device(pdev);
+	case INIT_STATE_AFU:
+		cxlflash_term_afu(cxlflash);
+		cxlflash_dev_dbg(&pdev->dev, "after struct cxlflash_term_afu!");
+	case INIT_STATE_NONE:
+		flush_work(&cxlflash->work_q);
+		cxlflash_free_mem(cxlflash);
+		break;
+	}
+
+	cxlflash_info("returning");
+}
+
+/**
+ * cxlflash_gb_alloc() - allocates the AFU and its command pool
+ * @cxlflash:	Internal structure associated with the host.
+ *
+ * A partially allocated state remains on failure.
+ *
+ * Return:
+ *	0 on success
+ *	-ENOMEM on failure to allocate memory
+ */
+static int cxlflash_gb_alloc(struct cxlflash *cxlflash)
+{
+	int rc = 0;
+	int i;
+	char *buf = NULL;
+
+	cxlflash->afu = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+						 get_order(sizeof(struct afu)));
+	if (unlikely(!cxlflash->afu)) {
+		cxlflash_err("cannot get %d free pages",
+			     get_order(sizeof(struct afu)));
+		rc = -ENOMEM;
+		goto out;
+	}
+	cxlflash->afu->back = cxlflash;
+	cxlflash->afu->afu_map = NULL;
+
+	for (i = 0; i < CXLFLASH_NUM_CMDS; buf += CMD_BUFSIZE, i++) {
+		if (!((u64)buf & (PAGE_SIZE - 1))) {
+			buf = (void *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+			if (unlikely(!buf)) {
+				cxlflash_err("Allocate command buffers fail!");
+				rc = -ENOMEM;
+				cxlflash_free_mem(cxlflash);
+				goto out;
+			}
+		}
+
+		cxlflash->afu->cmd[i].buf = buf;
+		atomic_set(&cxlflash->afu->cmd[i].free, 1);
+		cxlflash->afu->cmd[i].slot = i;
+		cxlflash->afu->cmd[i].special = 0;
+	}
+
+out:
+	return rc;
+}
+
+/**
+ * cxlflash_init_pci() - initializes the host as a PCI device
+ * @cxlflash:	Internal structure associated with the host.
+ *
+ * Return:
+ *	0 on success
+ *	-EIO on unable to communicate with device
+ *	A return code from the PCI sub-routines
+ */
+static int cxlflash_init_pci(struct cxlflash *cxlflash)
+{
+	struct pci_dev *pdev = cxlflash->dev;
+	int rc = 0;
+
+	cxlflash->cxlflash_regs_pci = pci_resource_start(pdev, 0);
+	rc = pci_request_regions(pdev, CXLFLASH_NAME);
+	if (rc < 0) {
+		cxlflash_dev_err(&pdev->dev,
+				 "Couldn't register memory range of registers");
+		goto out;
+	}
+
+	rc = pci_enable_device(pdev);
+	if (rc || pci_channel_offline(pdev)) {
+		if (pci_channel_offline(pdev)) {
+			cxlflash_wait_for_pci_err_recovery(cxlflash);
+			rc = pci_enable_device(pdev);
+		}
+
+		if (rc) {
+			cxlflash_dev_err(&pdev->dev, "Cannot enable adapter");
+			cxlflash_wait_for_pci_err_recovery(cxlflash);
+			goto out_release_regions;
+		}
+	}
+
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (rc < 0) {
+		cxlflash_dev_dbg(&pdev->dev,
+				 "Failed to set 64 bit PCI DMA mask");
+		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	}
+
+	if (rc < 0) {
+		cxlflash_dev_err(&pdev->dev, "Failed to set PCI DMA mask");
+		goto out_disable;
+	}
+
+	pci_set_master(pdev);
+
+	if (pci_channel_offline(pdev)) {
+		cxlflash_wait_for_pci_err_recovery(cxlflash);
+		if (pci_channel_offline(pdev)) {
+			rc = -EIO;
+			goto out_msi_disable;
+		}
+	}
+
+	rc = pci_save_state(pdev);
+
+	if (rc != PCIBIOS_SUCCESSFUL) {
+		cxlflash_dev_err(&pdev->dev, "Failed to save PCI config space");
+		rc = -EIO;
+		goto cleanup_nolog;
+	}
+
+out:
+	cxlflash_dbg("returning rc=%d", rc);
+	return rc;
+
+cleanup_nolog:
+out_msi_disable:
+	cxlflash_wait_for_pci_err_recovery(cxlflash);
+out_disable:
+	pci_disable_device(pdev);
+out_release_regions:
+	pci_release_regions(pdev);
+	goto out;
+
+}
+
+/**
+ * cxlflash_init_scsi() - adds the host to the SCSI stack and kicks off host scan
+ * @cxlflash:	Internal structure associated with the host.
+ *
+ * Return:
+ *	0 on success
+ *	A return code from adding the host
+ */
+static int cxlflash_init_scsi(struct cxlflash *cxlflash)
+{
+	struct pci_dev *pdev = cxlflash->dev;
+	int rc = 0;
+
+	cxlflash_dev_dbg(&pdev->dev, "before scsi_add_host");
+	rc = scsi_add_host(cxlflash->host, &pdev->dev);
+	if (rc) {
+		cxlflash_dev_err(&pdev->dev, "scsi_add_host failed (rc=%d)",
+				 rc);
+		goto out;
+	}
+
+	cxlflash_dev_dbg(&pdev->dev, "before scsi_scan_host");
+	scsi_scan_host(cxlflash->host);
+
+out:
+	cxlflash_dbg("returning rc=%d", rc);
+	return rc;
+}
+
+/**
+ * set_port_online() - transitions the specified host FC port to online state
+ * @fc_regs:	Top of MMIO region defined for specified port.
+ *
+ * The provided MMIO region must be mapped prior to call. Online state means
+ * that the FC link layer has synced, completed the handshaking process, and
+ * is ready for login to start.
+ */
+static void set_port_online(volatile u64 *fc_regs)
+{
+	u64 cmdcfg;
+
+	cmdcfg = readq_be(&fc_regs[FC_MTIP_CMDCONFIG / 8]);
+	cmdcfg &= (~FC_MTIP_CMDCONFIG_OFFLINE);	/* clear OFF_LINE */
+	cmdcfg |= (FC_MTIP_CMDCONFIG_ONLINE);	/* set ON_LINE */
+	writeq_be(cmdcfg, &fc_regs[FC_MTIP_CMDCONFIG / 8]);
+}
+
+/**
+ * set_port_offline() - transitions the specified host FC port to offline state
+ * @fc_regs:	Top of MMIO region defined for specified port.
+ *
+ * The provided MMIO region must be mapped prior to call.
+ */
+static void set_port_offline(volatile u64 *fc_regs)
+{
+	u64 cmdcfg;
+
+	cmdcfg = readq_be(&fc_regs[FC_MTIP_CMDCONFIG / 8]);
+	cmdcfg &= (~FC_MTIP_CMDCONFIG_ONLINE);	/* clear ON_LINE */
+	cmdcfg |= (FC_MTIP_CMDCONFIG_OFFLINE);	/* set OFF_LINE */
+	writeq_be(cmdcfg, &fc_regs[FC_MTIP_CMDCONFIG / 8]);
+}
+
+/**
+ * wait_port_online() - waits for the specified host FC port come online
+ * @fc_regs:	Top of MMIO region defined for specified port.
+ * @delay_us:	Number of microseconds to delay between reading port status.
+ * @nretry:	Number of cycles to retry reading port status.
+ *
+ * The provided MMIO region must be mapped prior to call. This will timeout
+ * when the cable is not plugged in.
+ *
+ * Return:
+ *	TRUE (1) when the specified port is online
+ *	FALSE (0) when the specified port fails to come online after timeout
+ *	-EINVAL when @delay_us is less than 1000
+ */
+static int wait_port_online(volatile u64 *fc_regs,
+			    useconds_t delay_us, unsigned int nretry)
+{
+	u64 status;
+
+	if (delay_us < 1000) {
+		cxlflash_err("invalid delay specified %d", delay_us);
+		return -EINVAL;
+	}
+
+	do {
+		msleep(delay_us / 1000);
+		status = readq_be(&fc_regs[FC_MTIP_STATUS / 8]);
+	} while ((status & FC_MTIP_STATUS_MASK) != FC_MTIP_STATUS_ONLINE &&
+		 nretry--);
+
+	return ((status & FC_MTIP_STATUS_MASK) == FC_MTIP_STATUS_ONLINE);
+}
+
+/**
+ * wait_port_offline() - waits for the specified host FC port go offline
+ * @fc_regs:	Top of MMIO region defined for specified port.
+ * @delay_us:	Number of microseconds to delay between reading port status.
+ * @nretry:	Number of cycles to retry reading port status.
+ *
+ * The provided MMIO region must be mapped prior to call.
+ *
+ * Return:
+ *	TRUE (1) when the specified port is offline
+ *	FALSE (0) when the specified port fails to go offline after timeout
+ *	-EINVAL when @delay_us is less than 1000
+ */
+static int wait_port_offline(volatile u64 *fc_regs,
+			     useconds_t delay_us, unsigned int nretry)
+{
+	u64 status;
+
+	if (delay_us < 1000) {
+		cxlflash_err("invalid delay specified %d", delay_us);
+		return -EINVAL;
+	}
+
+	do {
+		msleep(delay_us / 1000);
+		status = readq_be(&fc_regs[FC_MTIP_STATUS / 8]);
+	} while ((status & FC_MTIP_STATUS_MASK) != FC_MTIP_STATUS_OFFLINE &&
+		 nretry--);
+
+	return ((status & FC_MTIP_STATUS_MASK) == FC_MTIP_STATUS_OFFLINE);
+}
+
+/**
+ * afu_set_wwpn() - configures the WWPN for the specified host FC port
+ * @afu:	AFU associated with the host that owns the specified FC port.
+ * @port:	Port number being configured.
+ * @fc_regs:	Top of MMIO region defined for specified port.
+ * @wwpn:	The world-wide-port-number previously discovered for port.
+ *
+ * The provided MMIO region must be mapped prior to call. As part of the
+ * sequence to configure the WWPN, the port is toggled offline and then back
+ * online. This toggling action can cause this routine to delay up to a few
+ * seconds. When configured to use the internal LUN feature of the AFU, a
+ * failure to come online is overridden.
+ *
+ * Return:
+ *	0 when the WWPN is successfully written and the port comes back online
+ *	-1 when the port fails to go offline or come back up online
+ */
+static int afu_set_wwpn(struct afu *afu, int port,
+			volatile u64 *fc_regs, u64 wwpn)
+{
+	int ret = 0;
+
+	set_port_offline(fc_regs);
+
+	if (!wait_port_offline(fc_regs, FC_PORT_STATUS_RETRY_INTERVAL_US,
+			       FC_PORT_STATUS_RETRY_CNT)) {
+		cxlflash_dbg("wait on port %d to go offline timed out", port);
+		ret = -1; /* but continue on to leave the port back online */
+	}
+
+	if (ret == 0)
+		writeq_be(wwpn, &fc_regs[FC_PNAME / 8]);
+
+	set_port_online(fc_regs);
+
+	if (!wait_port_online(fc_regs, FC_PORT_STATUS_RETRY_INTERVAL_US,
+			      FC_PORT_STATUS_RETRY_CNT)) {
+		cxlflash_dbg("wait on port %d to go online timed out", port);
+		ret = -1;
+
+		/*
+		 * Override for internal lun!!!
+		 */
+		if (afu->internal_lun) {
+			cxlflash_info("Overriding port %d online timeout!!!",
+				      port);
+			ret = 0;
+		}
+	}
+
+	cxlflash_dbg("returning rc=%d", ret);
+
+	return ret;
+}
+
+/**
+ * afu_link_reset() - resets the specified host FC port
+ * @afu:	AFU associated with the host that owns the specified FC port.
+ * @port:	Port number being configured.
+ * @fc_regs:	Top of MMIO region defined for specified port.
+ *
+ * The provided MMIO region must be mapped prior to call. The sequence to
+ * reset the port involves toggling it offline and then back online. This
+ * action can cause this routine to delay up to a few seconds. An effort
+ * is made to maintain link with the device by switching to host to use
+ * the alternate port exclusively while the reset takes place.
+ * failure to come online is overridden.
+ */
+static void afu_link_reset(struct afu *afu, int port, volatile u64 *fc_regs)
+{
+	u64 port_sel;
+
+	/* first switch the AFU to the other links, if any */
+	port_sel = readq_be(&afu->afu_map->global.regs.afu_port_sel);
+	port_sel &= ~(1 << port);
+	writeq_be(port_sel, &afu->afu_map->global.regs.afu_port_sel);
+	cxlflash_afu_sync(afu, 0, 0, AFU_GSYNC);
+
+	set_port_offline(fc_regs);
+	if (!wait_port_offline(fc_regs, FC_PORT_STATUS_RETRY_INTERVAL_US,
+			       FC_PORT_STATUS_RETRY_CNT))
+		cxlflash_err("wait on port %d to go offline timed out", port);
+
+	set_port_online(fc_regs);
+	if (!wait_port_online(fc_regs, FC_PORT_STATUS_RETRY_INTERVAL_US,
+			      FC_PORT_STATUS_RETRY_CNT))
+		cxlflash_err("wait on port %d to go online timed out", port);
+
+	/* switch back to include this port */
+	port_sel |= (1 << port);
+	writeq_be(port_sel, &afu->afu_map->global.regs.afu_port_sel);
+	cxlflash_afu_sync(afu, 0, 0, AFU_GSYNC);
+
+	cxlflash_info("returning port_sel=%lld", port_sel);
+}
+
+/*
+ * Asynchronous interrupt information table
+ */
+static const struct asyc_intr_info ainfo[] = {
+	{SISL_ASTATUS_FC0_OTHER, "fc 0: other error", 0,
+		CLR_FC_ERROR | LINK_RESET},
+	{SISL_ASTATUS_FC0_LOGO, "fc 0: target initiated LOGO", 0, 0},
+	{SISL_ASTATUS_FC0_CRC_T, "fc 0: CRC threshold exceeded", 0, LINK_RESET},
+	{SISL_ASTATUS_FC0_LOGI_R, "fc 0: login timed out, retrying", 0, 0},
+	{SISL_ASTATUS_FC0_LOGI_F, "fc 0: login failed", 0, CLR_FC_ERROR},
+	{SISL_ASTATUS_FC0_LOGI_S, "fc 0: login succeeded", 0, 0},
+	{SISL_ASTATUS_FC0_LINK_DN, "fc 0: link down", 0, 0},
+	{SISL_ASTATUS_FC0_LINK_UP, "fc 0: link up", 0, 0},
+
+	{SISL_ASTATUS_FC1_OTHER, "fc 1: other error", 1,
+	 CLR_FC_ERROR | LINK_RESET},
+	{SISL_ASTATUS_FC1_LOGO, "fc 1: target initiated LOGO", 1, 0},
+	{SISL_ASTATUS_FC1_CRC_T, "fc 1: CRC threshold exceeded", 1, LINK_RESET},
+	{SISL_ASTATUS_FC1_LOGI_R, "fc 1: login timed out, retrying", 1, 0},
+	{SISL_ASTATUS_FC1_LOGI_F, "fc 1: login failed", 1, CLR_FC_ERROR},
+	{SISL_ASTATUS_FC1_LOGI_S, "fc 1: login succeeded", 1, 0},
+	{SISL_ASTATUS_FC1_LINK_DN, "fc 1: link down", 1, 0},
+	{SISL_ASTATUS_FC1_LINK_UP, "fc 1: link up", 1, 0},
+	{0x0, "", 0, 0}		/* terminator */
+};
+
+/**
+ * find_ainfo() - locates and returns asynchronous interrupt information
+ * @status:	Status code set by AFU on error.
+ *
+ * Return: The located information or NULL when the status code is invalid.
+ */
+static const struct asyc_intr_info *find_ainfo(u64 status)
+{
+	const struct asyc_intr_info *info;
+
+	for (info = &ainfo[0]; info->status; info++)
+		if (info->status == status)
+			return info;
+
+	return NULL;
+}
+
+/**
+ * afu_err_intr_init() - clears and initializes the AFU for error interrupts
+ * @afu:	AFU associated with the host.
+ */
+static void afu_err_intr_init(struct afu *afu)
+{
+	int i;
+	volatile u64 reg;
+
+	/* global async interrupts: AFU clears afu_ctrl on context exit
+	 * if async interrupts were sent to that context. This prevents
+	 * the AFU form sending further async interrupts when
+	 * there is
+	 * nobody to receive them.
+	 */
+
+	/* mask all */
+	writeq_be(-1ULL, &afu->afu_map->global.regs.aintr_mask);
+	/* set LISN# to send and point to master context */
+	reg = ((u64) (((afu->ctx_hndl << 8) | SISL_MSI_ASYNC_ERROR)) << 40);
+
+	if (afu->internal_lun)
+		reg |= 1;	/* Bit 63 indicates local lun */
+	writeq_be(reg, &afu->afu_map->global.regs.afu_ctrl);
+	/* clear all */
+	writeq_be(-1ULL, &afu->afu_map->global.regs.aintr_clear);
+	/* unmask bits that are of interest */
+	/* note: afu can send an interrupt after this step */
+	writeq_be(SISL_ASTATUS_MASK, &afu->afu_map->global.regs.aintr_mask);
+	/* clear again in case a bit came on after previous clear but before */
+	/* unmask */
+	writeq_be(-1ULL, &afu->afu_map->global.regs.aintr_clear);
+
+	/* Clear/Set internal lun bits */
+	reg = readq_be(&afu->afu_map->global.fc_regs[0][FC_CONFIG2 / 8]);
+	cxlflash_dbg("ilun p0 = %016llX", reg);
+	reg &= SISL_FC_INTERNAL_MASK;
+	if (afu->internal_lun)
+		reg |= ((u64)(afu->internal_lun - 1) << SISL_FC_INTERNAL_SHIFT);
+	cxlflash_dbg("ilun p0 = %016llX", reg);
+	writeq_be(reg, &afu->afu_map->global.fc_regs[0][FC_CONFIG2 / 8]);
+
+	/* now clear FC errors */
+	for (i = 0; i < NUM_FC_PORTS; i++) {
+		writeq_be(0xFFFFFFFFU,
+			  &afu->afu_map->global.fc_regs[i][FC_ERROR / 8]);
+		writeq_be(0, &afu->afu_map->global.fc_regs[i][FC_ERRCAP / 8]);
+	}
+
+	/* sync interrupts for master's IOARRIN write */
+	/* note that unlike asyncs, there can be no pending sync interrupts */
+	/* at this time (this is a fresh context and master has not written */
+	/* IOARRIN yet), so there is nothing to clear. */
+
+	/* set LISN#, it is always sent to the context that wrote IOARRIN */
+	writeq_be(SISL_MSI_SYNC_ERROR, &afu->host_map->ctx_ctrl);
+	writeq_be(SISL_ISTATUS_MASK, &afu->host_map->intr_mask);
+}
+
+/**
+ * cxlflash_sync_err_irq() - interrupt handler for synchronous errors
+ * @irq:	Interrupt number.
+ * @data:	Private data provided at interrupt registration, the AFU.
+ *
+ * Return: Always return IRQ_HANDLED.
+ */
+static irqreturn_t cxlflash_sync_err_irq(int irq, void *data)
+{
+	struct afu *afu = (struct afu *)data;
+	u64 reg;
+	u64 reg_unmasked;
+
+	reg = readq_be(&afu->host_map->intr_status);
+	reg_unmasked = (reg & SISL_ISTATUS_UNMASK);
+
+	if (reg_unmasked == 0UL) {
+		cxlflash_err("%llX: spurious interrupt, intr_status %016llX",
+			     (u64) afu, reg);
+		goto cxlflash_sync_err_irq_exit;
+	}
+
+	cxlflash_err("%llX: unexpected interrupt, intr_status %016llX",
+		     (u64) afu, reg);
+
+	writeq_be(reg_unmasked, &afu->host_map->intr_clear);
+
+cxlflash_sync_err_irq_exit:
+	cxlflash_info("returning rc=%d", IRQ_HANDLED);
+	return IRQ_HANDLED;
+}
+
+/**
+ * cxlflash_rrq_irq() - interrupt handler for read-response queue (normal path)
+ * @irq:	Interrupt number.
+ * @data:	Private data provided at interrupt registration, the AFU.
+ *
+ * Return: Always return IRQ_HANDLED.
+ */
+static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
+{
+	struct afu *afu = (struct afu *)data;
+	struct afu_cmd *cmd;
+	u32 toggle = afu->toggle;
+	u64 entry;
+	u64 *hrrq_start = afu->hrrq_start,
+	    *hrrq_end = afu->hrrq_end;
+	volatile u64 *hrrq_curr = afu->hrrq_curr;
+
+	/* Process however many RRQ entries that are ready */
+	while (true) {
+		entry = *hrrq_curr;
+
+		if ((entry & SISL_RESP_HANDLE_T_BIT) != toggle)
+			break;
+
+		cmd = (struct afu_cmd *)(entry & ~SISL_RESP_HANDLE_T_BIT);
+		cmd_complete(cmd);
+
+		/* Advance to next entry or wrap and flip the toggle bit */
+		if (hrrq_curr < hrrq_end)
+			hrrq_curr++;
+		else {
+			hrrq_curr = hrrq_start;
+			toggle ^= SISL_RESP_HANDLE_T_BIT;
+		}
+	}
+
+	afu->hrrq_curr = hrrq_curr;
+	afu->toggle = toggle;
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * cxlflash_async_err_irq() - interrupt handler for asynchronous errors
+ * @irq:	Interrupt number.
+ * @data:	Private data provided at interrupt registration, the AFU.
+ *
+ * Return: Always return IRQ_HANDLED.
+ */
+static irqreturn_t cxlflash_async_err_irq(int irq, void *data)
+{
+	struct afu *afu = (struct afu *)data;
+	struct cxlflash *cxlflash;
+	u64 reg_unmasked;
+	const struct asyc_intr_info *info;
+	volatile struct sisl_global_map *global = &afu->afu_map->global;
+	u64 reg;
+	int i;
+
+	cxlflash = afu->back;
+
+	reg = readq_be(&global->regs.aintr_status);
+	reg_unmasked = (reg & SISL_ASTATUS_UNMASK);
+
+	if (reg_unmasked == 0) {
+		cxlflash_err("spurious interrupt, aintr_status 0x%016llx", reg);
+		goto out;
+	}
+
+	/* it is OK to clear AFU status before FC_ERROR */
+	writeq_be(reg_unmasked, &global->regs.aintr_clear);
+
+	/* check each bit that is on */
+	for (i = 0; reg_unmasked; i++, reg_unmasked = (reg_unmasked >> 1)) {
+		info = find_ainfo(1ULL << i);
+		if ((reg_unmasked & 0x1) || !info)
+			continue;
+
+		cxlflash_err("%s, fc_status 0x%08llx", info->desc,
+			     readq_be(&global->fc_regs
+				      [info->port][FC_STATUS / 8]));
+
+		/*
+		 * do link reset first, some OTHER errors will set FC_ERROR
+		 * again if cleared before or w/o a reset
+		 */
+		if (info->action & LINK_RESET) {
+			cxlflash_err("fc %d: resetting link", info->port);
+			cxlflash->lr_state = LINK_RESET_REQUIRED;
+			cxlflash->lr_port = info->port;
+			schedule_work(&cxlflash->work_q);
+		}
+
+		if (info->action & CLR_FC_ERROR) {
+			reg = readq_be(&global->fc_regs[info->port]
+				       [FC_ERROR / 8]);
+
+			/*
+			 * since all errors are unmasked, FC_ERROR and FC_ERRCAP
+			 * should be the same and tracing one is sufficient.
+			 */
+
+			cxlflash_err("fc %d: clearing fc_error 0x%08llx",
+				     info->port, reg);
+
+			writeq_be(reg,
+				  &global->fc_regs[info->port][FC_ERROR /
+								   8]);
+			writeq_be(0,
+				  &global->fc_regs[info->port][FC_ERRCAP /
+								   8]);
+		}
+	}
+
+out:
+	cxlflash_info("returning rc=%d, afu=%p", IRQ_HANDLED, afu);
+	return IRQ_HANDLED;
+}
+
+/**
+ * cxlflash_start_context() - starts the master context
+ * @cxlflash:	Internal structure associated with the host.
+ *
+ * Return: A success or failure value from CXL services.
+ */
+int cxlflash_start_context(struct cxlflash *cxlflash)
+{
+	int rc = 0;
+
+	rc = cxl_start_context(cxlflash->mcctx,
+			       cxlflash->afu->work.work_element_descriptor,
+			       NULL);
+
+	cxlflash_dbg("returning rc=%d", rc);
+	return rc;
+}
+
+/**
+ * cxlflash_read_vpd() - obtains the WWPNs from VPD
+ * @cxlflash:	Internal structure associated with the host.
+ * @wwpn:	Array of size NUM_FC_PORTS to pass back WWPNs
+ *
+ * Return:
+ *	0 on success
+ *	-ENODEV when VPD or WWPN keywords not found
+ */
+int cxlflash_read_vpd(struct cxlflash *cxlflash, u64 wwpn[])
+{
+	struct pci_dev *dev = cxlflash->parent_dev;
+	int rc = 0;
+	int ro_start, ro_size, i, j, k;
+	ssize_t vpd_size;
+	char vpd_data[CXLFLASH_VPD_LEN];
+	char tmp_buf[WWPN_BUF_LEN] = { 0 };
+	char *wwpn_vpd_tags[NUM_FC_PORTS] = { "V5", "V6" };
+
+	/* Get the VPD data from the device */
+	vpd_size = pci_read_vpd(dev, 0, sizeof(vpd_data), vpd_data);
+	if (unlikely(vpd_size <= 0)) {
+		cxlflash_err("Unable to read VPD (size = %ld)", vpd_size);
+		rc = -ENODEV;
+		goto out;
+	}
+
+	/* Get the read only section offset */
+	ro_start = pci_vpd_find_tag(vpd_data, 0, vpd_size,
+				    PCI_VPD_LRDT_RO_DATA);
+	if (unlikely(ro_start < 0)) {
+		cxlflash_err("VPD Read-only not found");
+		rc = -ENODEV;
+		goto out;
+	}
+
+	/* Get the read only section size, cap when extends beyond read VPD */
+	ro_size = pci_vpd_lrdt_size(&vpd_data[ro_start]);
+	j = ro_size;
+	i = ro_start + PCI_VPD_LRDT_TAG_SIZE;
+	if (unlikely((i + j) > vpd_size)) {
+		cxlflash_warn("Might need to read more VPD (%d > %ld)",
+			      (i + j), vpd_size);
+		ro_size = vpd_size - i;
+	}
+
+	/*
+	 * Find the offset of the WWPN tag within the read only
+	 * VPD data and validate the found field (partials are
+	 * no good to us). Convert the ASCII data to an integer
+	 * value. Note that we must copy to a temporary buffer
+	 * because the conversion service requires that the ASCII
+	 * string be terminated.
+	 */
+	for (k = 0; k < NUM_FC_PORTS; k++) {
+		j = ro_size;
+		i = ro_start + PCI_VPD_LRDT_TAG_SIZE;
+
+		i = pci_vpd_find_info_keyword(vpd_data, i, j, wwpn_vpd_tags[k]);
+		if (unlikely(i < 0)) {
+			cxlflash_err("Port %d WWPN not found in VPD", k);
+			rc = -ENODEV;
+			goto out;
+		}
+
+		j = pci_vpd_info_field_size(&vpd_data[i]);
+		i += PCI_VPD_INFO_FLD_HDR_SIZE;
+		if (unlikely((i + j > vpd_size) || (j != WWPN_LEN))) {
+			cxlflash_err("Port %d WWPN incomplete or VPD corrupt",
+				     k);
+			rc = -ENODEV;
+			goto out;
+		}
+
+		memcpy(tmp_buf, &vpd_data[i], WWPN_LEN);
+		rc = kstrtoul(tmp_buf, WWPN_LEN, (unsigned long *)&wwpn[k]);
+		if (unlikely(rc)) {
+			cxlflash_err
+			    ("Unable to convert port 0 WWPN to integer");
+			rc = -ENODEV;
+			goto out;
+		}
+	}
+
+out:
+	cxlflash_dbg("returning rc=%d", rc);
+	return rc;
+}
+
+/**
+ * cxlflash_context_reset() - timeout handler for AFU commands
+ * @cmd:	AFU command that timed out.
+ *
+ * Sends a reset to the AFU.
+ */
+void cxlflash_context_reset(struct afu_cmd *cmd)
+{
+	int nretry = 0;
+	u64 rrin = 0x1;
+	struct afu *afu = cmd->back;
+
+	cxlflash_info("cmd=%p", cmd);
+
+	/* First process completion of the command that timed out */
+	cmd_complete(cmd);
+
+	if (afu->room == 0) {
+		do {
+			afu->room = readq_be(&afu->host_map->cmd_room);
+			udelay(nretry);
+		} while ((afu->room == 0) && (nretry++ < MC_ROOM_RETRY_CNT));
+	}
+
+	if (afu->room) {
+		writeq_be((u64) rrin, &afu->host_map->ioarrin);
+		do {
+			rrin = readq_be(&afu->host_map->ioarrin);
+			/* Double delay each time */
+			udelay(2 ^ nretry);
+		} while ((rrin == 0x1) && (nretry++ < MC_ROOM_RETRY_CNT));
+	} else
+		cxlflash_err("no cmd_room to send reset");
+}
+
+/**
+ * init_pcr() - initialize the provisioning and control registers
+ * @cxlflash:	Internal structure associated with the host.
+ *
+ * Also sets up fast access to the mapped registers and initializes AFU
+ * command fields that never change.
+ */
+void init_pcr(struct cxlflash *cxlflash)
+{
+	struct afu *afu = cxlflash->afu;
+	volatile struct sisl_ctrl_map *ctrl_map;
+	int i;
+
+	for (i = 0; i < MAX_CONTEXT; i++) {
+		ctrl_map = &afu->afu_map->ctrls[i].ctrl;
+		/* disrupt any clients that could be running */
+		/* e. g. clients that survived a master restart */
+		writeq_be(0, &ctrl_map->rht_start);
+		writeq_be(0, &ctrl_map->rht_cnt_id);
+		writeq_be(0, &ctrl_map->ctx_cap);
+	}
+
+	/* copy frequently used fields into afu */
+	afu->ctx_hndl = (u16) cxl_process_element(cxlflash->mcctx);
+	/* ctx_hndl is 16 bits in CAIA */
+	afu->host_map = &afu->afu_map->hosts[afu->ctx_hndl].host;
+	afu->ctrl_map = &afu->afu_map->ctrls[afu->ctx_hndl].ctrl;
+
+	/* initialize cmd fields that never change */
+	for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
+		afu->cmd[i].rcb.ctx_id = afu->ctx_hndl;
+		afu->cmd[i].rcb.msi = SISL_MSI_RRQ_UPDATED;
+		afu->cmd[i].rcb.rrq = 0x0;
+	}
+
+}
+
+/**
+ * init_global() - initialize AFU global registers
+ * @cxlflash:	Internal structure associated with the host.
+ */
+int init_global(struct cxlflash *cxlflash)
+{
+	struct afu *afu = cxlflash->afu;
+	u64 wwpn[NUM_FC_PORTS];	/* wwpn of AFU ports */
+	int i = 0, num_ports = 0;
+	int rc = 0;
+	u64 reg;
+
+	rc = cxlflash_read_vpd(cxlflash, &wwpn[0]);
+	if (rc) {
+		cxlflash_err("could not read vpd rc=%d", rc);
+		goto out;
+	}
+	cxlflash_info("wwpn0=0x%llx wwpn1=0x%llx", wwpn[0], wwpn[1]);
+
+	/* set up RRQ in AFU for master issued cmds */
+	writeq_be((u64) afu->hrrq_start, &afu->host_map->rrq_start);
+	writeq_be((u64) afu->hrrq_end, &afu->host_map->rrq_end);
+
+	/* AFU configuration */
+	reg = readq_be(&afu->afu_map->global.regs.afu_config);
+	reg |= 0x7F20;		/* enable all auto retry options and LE */
+	/* leave others at default: */
+	/* CTX_CAP write protected, mbox_r does not clear on read and */
+	/* checker on if dual afu */
+	writeq_be(reg, &afu->afu_map->global.regs.afu_config);
+
+	/* global port select: select either port */
+	if (afu->internal_lun) {
+		/* only use port 0 */
+		writeq_be(0x1, &afu->afu_map->global.regs.afu_port_sel);
+		num_ports = NUM_FC_PORTS - 1;
+	} else {
+		writeq_be(0x3, &afu->afu_map->global.regs.afu_port_sel);
+		num_ports = NUM_FC_PORTS;
+	}
+
+	for (i = 0; i < num_ports; i++) {
+		/* unmask all errors (but they are still masked at AFU) */
+		writeq_be(0, &afu->afu_map->global.fc_regs[i][FC_ERRMSK / 8]);
+		/* clear CRC error cnt & set a threshold */
+		(void)readq_be(&afu->afu_map->global.
+			       fc_regs[i][FC_CNT_CRCERR / 8]);
+		writeq_be(MC_CRC_THRESH, &afu->afu_map->global.fc_regs[i]
+			  [FC_CRC_THRESH / 8]);
+
+		/* set WWPNs. If already programmed, wwpn[i] is 0 */
+		if (wwpn[i] != 0 &&
+		    afu_set_wwpn(afu, i,
+				 &afu->afu_map->global.fc_regs[i][0],
+				 wwpn[i])) {
+			cxlflash_dbg("failed to set WWPN on port %d", i);
+			rc = -EIO;
+			goto out;
+		}
+		/* Programming WWPN back to back causes additional
+		 * offline/online transitions and a PLOGI
+		 */
+		msleep(100);
+
+	}
+
+	/* set up master's own CTX_CAP to allow real mode, host translation */
+	/* tbls, afu cmds and read/write GSCSI cmds. */
+	/* First, unlock ctx_cap write by reading mbox */
+	(void)readq_be(&afu->ctrl_map->mbox_r);	/* unlock ctx_cap */
+	writeq_be((SISL_CTX_CAP_REAL_MODE | SISL_CTX_CAP_HOST_XLATE |
+		   SISL_CTX_CAP_READ_CMD | SISL_CTX_CAP_WRITE_CMD |
+		   SISL_CTX_CAP_AFU_CMD | SISL_CTX_CAP_GSCSI_CMD),
+		  &afu->ctrl_map->ctx_cap);
+	/* init heartbeat */
+	afu->hb = readq_be(&afu->afu_map->global.regs.afu_hb);
+
+out:
+	return rc;
+}
+
+/**
+ * cxlflash_start_afu() - initializes and starts the AFU
+ * @cxlflash:	Internal structure associated with the host.
+ */
+int cxlflash_start_afu(struct cxlflash *cxlflash)
+{
+	struct afu *afu = cxlflash->afu;
+
+	int i = 0;
+	int rc = 0;
+
+	for (i = 0; i < CXLFLASH_NUM_CMDS; i++) {
+		struct timer_list *timer = &afu->cmd[i].timer;
+
+		init_timer(timer);
+		timer->data = (unsigned long)&afu->cmd[i];
+		timer->function = (void (*)(unsigned long))
+		    cxlflash_context_reset;
+
+		spin_lock_init(&afu->cmd[i].slock);
+		afu->cmd[i].back = afu;
+	}
+	init_pcr(cxlflash);
+
+	/* initialize RRQ pointers */
+	afu->hrrq_start = &afu->rrq_entry[0];
+	afu->hrrq_end = &afu->rrq_entry[NUM_RRQ_ENTRY - 1];
+	afu->hrrq_curr = afu->hrrq_start;
+	afu->toggle = 1;
+
+	rc = init_global(cxlflash);
+
+	cxlflash_dbg("returning rc=%d", rc);
+	return rc;
+}
+
+/**
+ * cxlflash_init_mc() - create and register as the master context
+ * @cxlflash:	Internal structure associated with the host.
+ *
+ * Return:
+ *	0 on success
+ *	-ENOMEM when unable to obtain a context from CXL services
+ *	A failure value from CXL services.
+ */
+int cxlflash_init_mc(struct cxlflash *cxlflash)
+{
+	struct cxl_context *ctx;
+	struct device *dev = &cxlflash->dev->dev;
+	struct afu *afu = cxlflash->afu;
+	int rc = 0;
+	enum undo_level level;
+
+	ctx = cxl_dev_context_init(cxlflash->dev);
+	if (!ctx)
+		return -ENOMEM;
+	cxlflash->mcctx = ctx;
+
+	/* Set it up as a master with the CXL */
+	cxl_set_master(ctx);
+
+	/* During initialization reset the AFU to start from a clean slate */
+	rc = cxl_afu_reset(cxlflash->mcctx);
+	if (rc) {
+		cxlflash_dev_err(dev, "initial AFU reset failed rc=%d", rc);
+		level = RELEASE_CONTEXT;
+		goto out;
+	}
+
+	/* Allocate AFU generated interrupt handler */
+	rc = cxl_allocate_afu_irqs(ctx, 3);
+	if (rc) {
+		cxlflash_dev_err(dev, "call to allocate_afu_irqs failed rc=%d!",
+				 rc);
+		level = RELEASE_CONTEXT;
+		goto out;
+	}
+
+	/* Register AFU interrupt 1 (SISL_MSI_SYNC_ERROR) */
+	rc = cxl_map_afu_irq(ctx, 1, cxlflash_sync_err_irq, afu,
+			     "SISL_MSI_SYNC_ERROR");
+	if (!rc) {
+		cxlflash_dev_err(dev,
+				 "IRQ 1 (SISL_MSI_SYNC_ERROR) map failed!");
+		level = FREE_IRQ;
+		goto out;
+	}
+	/* Register AFU interrupt 2 (SISL_MSI_RRQ_UPDATED) */
+	rc = cxl_map_afu_irq(ctx, 2, cxlflash_rrq_irq, afu,
+			     "SISL_MSI_RRQ_UPDATED");
+	if (!rc) {
+		cxlflash_dev_err(dev,
+				 "IRQ 2 (SISL_MSI_RRQ_UPDATED) map failed!");
+		level = UNMAP_ONE;
+		goto out;
+	}
+	/* Register AFU interrupt 3 (SISL_MSI_ASYNC_ERROR) */
+	rc = cxl_map_afu_irq(ctx, 3, cxlflash_async_err_irq, afu,
+			     "SISL_MSI_ASYNC_ERROR");
+	if (!rc) {
+		cxlflash_dev_err(dev,
+				 "IRQ 3 (SISL_MSI_ASYNC_ERROR) map failed!");
+		level = UNMAP_TWO;
+		goto out;
+	}
+
+	rc = 0;
+
+	/* This performs the equivalent of the CXL_IOCTL_START_WORK.
+	 * The CXL_IOCTL_GET_PROCESS_ELEMENT is implicit in the process
+	 * element (pe) that is embedded in the context (ctx)
+	 */
+	rc = cxlflash_start_context(cxlflash);
+	if (rc) {
+		cxlflash_dev_err(dev, "start context failed rc=%d", rc);
+		level = UNMAP_THREE;
+		goto out;
+	}
+ret:
+	cxlflash_dbg("returning rc=%d", rc);
+	return rc;
+out:
+	cxlflash_term_mc(cxlflash, level);
+	goto ret;
+}
+
+/**
+ * cxlflash_init_afu() - setup as master context and start AFU
+ * @cxlflash:	Internal structure associated with the host.
+ *
+ * This routine is a higher level of control for configuring the
+ * AFU on probe and reset paths.
+ *
+ * Return:
+ *	0 on success
+ *	-ENOMEM when unable to map the AFU MMIO space
+ *	A failure value from internal services.
+ */
+static int cxlflash_init_afu(struct cxlflash *cxlflash)
+{
+	u64 reg;
+	int rc = 0;
+	struct afu *afu = cxlflash->afu;
+	struct device *dev = &cxlflash->dev->dev;
+
+
+	rc = cxlflash_init_mc(cxlflash);
+	if (rc) {
+		cxlflash_dev_err(dev, "call to init_mc failed, rc=%d!", rc);
+		goto err1;
+	}
+
+	/* Map the entire MMIO space of the AFU.
+	 */
+	afu->afu_map = cxl_psa_map(cxlflash->mcctx);
+	if (!afu->afu_map) {
+		rc = -ENOMEM;
+		cxlflash_term_mc(cxlflash, UNDO_START);
+		cxlflash_dev_err(dev, "call to cxl_psa_map failed!");
+		goto err1;
+	}
+
+	/* don't byte reverse on reading afu_version, else the string form */
+	/*     will be backwards */
+	reg = afu->afu_map->global.regs.afu_version;
+	memcpy(afu->version, &reg, 8);
+	afu->interface_version =
+	    readq_be(&afu->afu_map->global.regs.interface_version);
+	cxlflash_info("afu version %s, interface version 0x%llx",
+		      afu->version, afu->interface_version);
+
+	rc = cxlflash_start_afu(cxlflash);
+	if (rc) {
+		cxlflash_dev_err(dev, "call to start_afu failed, rc=%d!", rc);
+		cxlflash_term_mc(cxlflash, UNDO_START);
+		cxl_psa_unmap((void *)afu->afu_map);
+		afu->afu_map = NULL;
+	}
+
+	afu_err_intr_init(cxlflash->afu);
+
+err1:
+	cxlflash_dbg("returning rc=%d", rc);
+	return rc;
+}
+
+/**
+ * cxlflash_send_cmd() - sends an AFU command
+ * @afu:	AFU associated with the host.
+ * @cmd:	AFU command to send.
+ *
+ * Return:
+ *	0 on success
+ *	-1 on failure
+ */
+int cxlflash_send_cmd(struct afu *afu, struct afu_cmd *cmd)
+{
+	int nretry = 0;
+	int rc = 0;
+
+	if (afu->room == 0)
+		do {
+			afu->room = readq_be(&afu->host_map->cmd_room);
+			udelay(nretry);
+		} while ((afu->room == 0) && (nretry++ < MC_ROOM_RETRY_CNT));
+
+	cmd->sa.host_use_b[0] = 0;	/* 0 means active */
+	cmd->sa.ioasc = 0;
+
+	/* make memory updates visible to AFU before MMIO */
+	smp_wmb();
+
+	/* Only kick off the timer for internal commands */
+	if (cmd->internal) {
+		cmd->timer.expires = (jiffies +
+					(cmd->rcb.timeout * 2 * HZ));
+		add_timer(&cmd->timer);
+	} else if (cmd->rcb.timeout)
+		cxlflash_err("timer not started %d", cmd->rcb.timeout);
+
+	/* Write IOARRIN */
+	if (afu->room)
+		writeq_be((u64)&cmd->rcb, &afu->host_map->ioarrin);
+	else {
+		cxlflash_err("no cmd_room to send 0x%X", cmd->rcb.cdb[0]);
+		rc = -1;
+	}
+
+	cxlflash_dbg("cmd=%p len=%d ea=%p rc=%d", cmd, cmd->rcb.data_len,
+		     (void *)cmd->rcb.data_ea, rc);
+
+	/* Let timer fire to complete the response... */
+	return rc;
+}
+
+/**
+ * cxlflash_wait_resp() - polls for a response or timeout to a sent AFU command
+ * @afu:	AFU associated with the host.
+ * @cmd:	AFU command that was sent.
+ */
+void cxlflash_wait_resp(struct afu *afu, struct afu_cmd *cmd)
+{
+	unsigned long lock_flags = 0;
+
+	spin_lock_irqsave(&cmd->slock, lock_flags);
+	while (!(cmd->sa.host_use_b[0] & B_DONE)) {
+		spin_unlock_irqrestore(&cmd->slock, lock_flags);
+		udelay(10);
+		spin_lock_irqsave(&cmd->slock, lock_flags);
+	}
+	spin_unlock_irqrestore(&cmd->slock, lock_flags);
+
+	del_timer(&cmd->timer);	/* already stopped if timer fired */
+
+	if (cmd->sa.ioasc != 0)
+		cxlflash_err("CMD 0x%x failed, IOASC: flags 0x%x, afu_rc 0x%x, "
+			     "scsi_rc 0x%x, fc_rc 0x%x",
+			     cmd->rcb.cdb[0],
+			     cmd->sa.rc.flags,
+			     cmd->sa.rc.afu_rc,
+			     cmd->sa.rc.scsi_rc, cmd->sa.rc.fc_rc);
+}
+
+/**
+ * cxlflash_afu_sync() - builds and sends an AFU sync command
+ * @afu:	AFU associated with the host.
+ * @ctx_hndl_u:	Identifies context requesting sync.
+ * @res_hndl_u:	Identifies resource requesting sync.
+ * @mode:	Type of sync to issue (lightweight, heavyweight, global).
+ *
+ * The AFU can only take 1 sync command at a time. This routine can be
+ * called from both interrupt and process context. The caller is responsible
+ * for any serialization.
+ *
+ * Return:
+ *	0 on success
+ *	-1 on failure
+ */
+int cxlflash_afu_sync(struct afu *afu, ctx_hndl_t ctx_hndl_u,
+		      res_hndl_t res_hndl_u, u8 mode)
+{
+	struct cxlflash *cxlflash = afu->back;
+	struct afu_cmd *cmd;
+	int rc = 0;
+	int retry_cnt = 0;
+
+	while (cxlflash->sync_active) {
+		cxlflash_dbg("sync issued while one is active");
+		wait_event(cxlflash->sync_wait_q, !cxlflash->sync_active);
+	}
+
+retry:
+	cmd = cxlflash_cmd_checkout(afu);
+	if (unlikely(!cmd)) {
+		retry_cnt++;
+		cxlflash_dbg("could not get command on attempt %d", retry_cnt);
+		udelay(1000*retry_cnt);
+		if (retry_cnt < MC_RETRY_CNT)
+			goto retry;
+		cxlflash_err("could not get a free command");
+		rc = -1;
+		goto out;
+	}
+
+	cxlflash_dbg("afu=%p cmd=%p %d", afu, cmd, ctx_hndl_u);
+
+	memset(cmd->rcb.cdb, 0, sizeof(cmd->rcb.cdb));
+
+	cmd->rcb.req_flags = SISL_REQ_FLAGS_AFU_CMD;
+	cmd->rcb.port_sel = 0x0;	/* NA */
+	cmd->rcb.lun_id = 0x0;	/* NA */
+	cmd->rcb.data_len = 0x0;
+	cmd->rcb.data_ea = 0x0;
+	cmd->internal = true;
+	cmd->sync = true;
+	cmd->rcb.timeout = MC_AFU_SYNC_TIMEOUT;
+
+	cmd->rcb.cdb[0] = 0xC0;	/* AFU Sync */
+	cmd->rcb.cdb[1] = mode;
+
+	cxlflash->sync_active = true;
+
+	/* The cdb is aligned, no unaligned accessors required */
+	*((u16 *)&cmd->rcb.cdb[2]) = swab16(ctx_hndl_u);
+	*((u32 *)&cmd->rcb.cdb[4]) = swab32(res_hndl_u);
+
+	rc = cxlflash_send_cmd(afu, cmd);
+	if (!rc)
+		cxlflash_wait_resp(afu, cmd);
+
+	if ((cmd->sa.ioasc != 0) || (cmd->sa.host_use_b[0] & B_ERROR)) {
+		rc = -1;
+		/* B_ERROR is set on timeout */
+	}
+
+out:
+	cxlflash_dbg("returning rc=%d", rc);
+	return rc;
+}
+
+/**
+ * cxlflash_afu_reset() - resets the AFU
+ * @cxlflash:	Internal structure associated with the host.
+ *
+ * Return:
+ *	0 on success
+ *	A failure value from internal services.
+ */
+int cxlflash_afu_reset(struct cxlflash *cxlflash)
+{
+	int rc = 0;
+	/* Stop the context before the reset. Since the context is
+	 * no longer available restart it after the reset is complete
+	 */
+
+	cxlflash_term_afu(cxlflash);
+
+	rc = cxlflash_init_afu(cxlflash);
+
+	cxlflash_info("returning rc=%d", rc);
+	return rc;
+}
+
+/**
+ * cxlflash_worker_thread() - work thread handler for the AFU
+ * @work:	Work structure contained within cxlflash associated with host.
+ *
+ * Handles link reset which cannot be performed on interrupt context due to
+ * blocking up to a few seconds.
+ */
+static void cxlflash_worker_thread(struct work_struct *work)
+{
+	struct cxlflash *cxlflash =
+	    container_of(work, struct cxlflash, work_q);
+	struct afu *afu = cxlflash->afu;
+	int port;
+	unsigned long lock_flags;
+
+	spin_lock_irqsave(cxlflash->host->host_lock, lock_flags);
+
+	if (cxlflash->lr_state == LINK_RESET_REQUIRED) {
+		port = cxlflash->lr_port;
+		if (port < 0)
+			cxlflash_err("invalid port index %d", port);
+		else
+			afu_link_reset(afu, port,
+				       &afu->afu_map->
+				       global.fc_regs[port][0]);
+		cxlflash->lr_state = LINK_RESET_COMPLETE;
+	}
+
+	spin_unlock_irqrestore(cxlflash->host->host_lock, lock_flags);
+}
+
+/**
+ * cxlflash_probe() - PCI entry point to add host
+ * @pdev:	PCI device associated with the host.
+ * @dev_id:	PCI device id associated with device.
+ *
+ * Return: 0 on success / non-zero on failure
+ */
+static int cxlflash_probe(struct pci_dev *pdev,
+			  const struct pci_device_id *dev_id)
+{
+	struct Scsi_Host *host;
+	struct cxlflash *cxlflash = NULL;
+	struct device *phys_dev;
+	struct dev_dependent_vals *ddv;
+	int rc = 0;
+
+	cxlflash_dev_dbg(&pdev->dev, "Found CXLFLASH with IRQ: %d", pdev->irq);
+
+	ddv = (struct dev_dependent_vals *)dev_id->driver_data;
+	driver_template.max_sectors = ddv->max_sectors;
+
+	host = scsi_host_alloc(&driver_template, sizeof(struct cxlflash));
+	if (!host) {
+		cxlflash_dev_err(&pdev->dev, "call to scsi_host_alloc failed!");
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	host->max_id = CXLFLASH_MAX_NUM_TARGETS_PER_BUS;
+	host->max_lun = CXLFLASH_MAX_NUM_LUNS_PER_TARGET;
+	host->max_channel = NUM_FC_PORTS - 1;
+	host->unique_id = host->host_no;
+	host->max_cmd_len = CXLFLASH_MAX_CDB_LEN;
+
+	cxlflash = (struct cxlflash *)host->hostdata;
+	cxlflash->host = host;
+	rc = cxlflash_gb_alloc(cxlflash);
+	if (rc) {
+		cxlflash_dev_err(&pdev->dev, "call to scsi_host_alloc failed!");
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	cxlflash->init_state = INIT_STATE_NONE;
+	cxlflash->dev = pdev;
+	cxlflash->last_lun_index = 0;
+	cxlflash->dev_id = (struct pci_device_id *)dev_id;
+	cxlflash->tmf_active = 0;
+	cxlflash->mcctx = NULL;
+	cxlflash->context_reset_active = 0;
+	cxlflash->num_user_contexts = 0;
+
+	init_waitqueue_head(&cxlflash->tmf_wait_q);
+	init_waitqueue_head(&cxlflash->eeh_wait_q);
+	init_waitqueue_head(&cxlflash->sync_wait_q);
+
+	INIT_WORK(&cxlflash->work_q, cxlflash_worker_thread);
+	cxlflash->lr_state = LINK_RESET_INVALID;
+	cxlflash->lr_port = -1;
+
+	pci_set_drvdata(pdev, cxlflash);
+
+	/* Use the special service provided to look up the physical
+	 * PCI device, since we are called on the probe of the virtual
+	 * PCI host bus (vphb)
+	 */
+	phys_dev = cxl_get_phys_dev(pdev);
+	if (!dev_is_pci(phys_dev)) {	/* make sure it's pci */
+		cxlflash_err("not a pci dev");
+		rc = ENODEV;
+		goto out_remove;
+	}
+	cxlflash->parent_dev = to_pci_dev(phys_dev);
+
+	cxlflash->cxl_afu = cxl_pci_to_afu(pdev, NULL);
+	rc = cxlflash_init_afu(cxlflash);
+	if (rc) {
+		cxlflash_dev_err(&pdev->dev,
+				 "call to cxlflash_init_afu failed rc=%d!", rc);
+		goto out_remove;
+	}
+	cxlflash->init_state = INIT_STATE_AFU;
+
+	rc = cxlflash_init_pci(cxlflash);
+	if (rc) {
+		cxlflash_dev_err(&pdev->dev,
+				 "call to cxlflash_init_pci failed rc=%d!", rc);
+		goto out_remove;
+	}
+	cxlflash->init_state = INIT_STATE_PCI;
+
+	rc = cxlflash_init_scsi(cxlflash);
+	if (rc) {
+		cxlflash_dev_err(&pdev->dev,
+				 "call to cxlflash_init_scsi failed rc=%d!",
+				 rc);
+		goto out_remove;
+	}
+	cxlflash->init_state = INIT_STATE_SCSI;
+
+out:
+	cxlflash_dbg("returning rc=%d", rc);
+	return rc;
+
+out_remove:
+	cxlflash_remove(pdev);
+	goto out;
+}
+
+/*
+ * PCI device structure
+ */
+static struct pci_driver cxlflash_driver = {
+	.name = CXLFLASH_NAME,
+	.id_table = cxlflash_pci_table,
+	.probe = cxlflash_probe,
+	.remove = cxlflash_remove,
+};
+
+/**
+ * init_cxlflash() - module entry point
+ *
+ * Return: 0 on success / non-zero on failure
+ */
+static int __init init_cxlflash(void)
+{
+	cxlflash_info("IBM Power CXL Flash Adapter: %s",
+		      CXLFLASH_DRIVER_DATE);
+
+	return pci_register_driver(&cxlflash_driver);
+}
+
+/**
+ * exit_cxlflash() - module exit point
+ */
+static void __exit exit_cxlflash(void)
+{
+	pci_unregister_driver(&cxlflash_driver);
+}
+
+module_init(init_cxlflash);
+module_exit(exit_cxlflash);
diff --git a/drivers/scsi/cxlflash/main.h b/drivers/scsi/cxlflash/main.h
new file mode 100644
index 0000000..014ecb8
--- /dev/null
+++ b/drivers/scsi/cxlflash/main.h
@@ -0,0 +1,111 @@
+/*
+ * CXL Flash Device Driver
+ *
+ * Written by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>, IBM Corporation
+ *             Matthew R. Ochs <mrochs@linux.vnet.ibm.com>, IBM Corporation
+ *
+ * Copyright (C) 2015 IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _CXLFLASH_MAIN_H
+#define _CXLFLASH_MAIN_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+
+typedef unsigned int useconds_t;        /* time in microseconds */
+
+#define CXLFLASH_NAME                      "cxlflash"
+#define CXLFLASH_ADAPTER_NAME              "IBM POWER CXL Flash Adapter"
+#define CXLFLASH_DRIVER_DATE              "(May 15, 2015)"
+
+#define PCI_DEVICE_ID_IBM_CORSA		0x04F0
+#define CXLFLASH_SUBS_DEV_ID		0x04F0
+
+/* Since there is only one target, make it 0 */
+#define CXLFLASH_TARGET                   0x0
+#define CXLFLASH_MAX_CDB_LEN		16
+
+/* Really only one target per bus since the Texan is directly attached */
+#define CXLFLASH_MAX_NUM_TARGETS_PER_BUS                     1
+#define CXLFLASH_MAX_NUM_LUNS_PER_TARGET                     65536
+
+#define CXLFLASH_PCI_ERROR_RECOVERY_TIMEOUT  (120 * HZ)
+
+#define NUM_FC_PORTS     CXLFLASH_NUM_FC_PORTS  /* ports per AFU */
+
+/* FC defines */
+#define FC_MTIP_CMDCONFIG 0x010
+#define FC_MTIP_STATUS 0x018
+
+#define FC_PNAME 0x300
+#define FC_CONFIG 0x320
+#define FC_CONFIG2 0x328
+#define FC_STATUS 0x330
+#define FC_ERROR 0x380
+#define FC_ERRCAP 0x388
+#define FC_ERRMSK 0x390
+#define FC_CNT_CRCERR 0x538
+#define FC_CRC_THRESH 0x580
+
+#define FC_MTIP_CMDCONFIG_ONLINE    0x20ull
+#define FC_MTIP_CMDCONFIG_OFFLINE   0x40ull
+
+#define FC_MTIP_STATUS_MASK         0x30ull
+#define FC_MTIP_STATUS_ONLINE       0x20ull
+#define FC_MTIP_STATUS_OFFLINE      0x10ull
+
+/* TIMEOUT and RETRY definitions */
+
+/* AFU command timeout values */
+#define MC_AFU_SYNC_TIMEOUT  5	/* 5 secs */
+
+/* AFU command room retry limit */
+#define MC_ROOM_RETRY_CNT    10
+
+/* FC CRC clear periodic timer */
+#define MC_CRC_THRESH 100	/* threshold in 5 mins */
+
+#define FC_PORT_STATUS_RETRY_CNT 100	/* 100 100ms retries = 10 seconds */
+#define FC_PORT_STATUS_RETRY_INTERVAL_US 100000	/* microseconds */
+
+/* VPD defines */
+#define CXLFLASH_VPD_LEN	256
+#define WWPN_LEN	16
+#define WWPN_BUF_LEN	(WWPN_LEN + 1)
+
+enum undo_level {
+	RELEASE_CONTEXT = 0,
+	FREE_IRQ,
+	UNMAP_ONE,
+	UNMAP_TWO,
+	UNMAP_THREE,
+	UNDO_START
+};
+
+struct dev_dependent_vals {
+	u64 max_sectors;
+};
+
+struct asyc_intr_info {
+	u64 status;
+	char *desc;
+	u8 port;
+	u8 action;
+#define CLR_FC_ERROR   0x01
+#define LINK_RESET     0x02
+};
+
+/*
+ * Externs and Prototypes
+ */
+int cxlflash_ioctl(struct scsi_device *, int, void __user *);
+
+#endif /* _CXLFLASH_MAIN_H */
diff --git a/drivers/scsi/cxlflash/sislite.h b/drivers/scsi/cxlflash/sislite.h
new file mode 100755
index 0000000..90e7528
--- /dev/null
+++ b/drivers/scsi/cxlflash/sislite.h
@@ -0,0 +1,413 @@
+/*
+ * CXL Flash Device Driver
+ *
+ * Written by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>, IBM Corporation
+ *             Matthew R. Ochs <mrochs@linux.vnet.ibm.com>, IBM Corporation
+ *
+ * Copyright (C) 2015 IBM Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _SISLITE_H
+#define _SISLITE_H
+
+#include <linux/types.h>
+
+typedef u16 ctx_hndl_t;
+typedef u32 res_hndl_t;
+
+#define PAGE_SIZE_4K	4096
+#define PAGE_SIZE_64K	65536
+
+/*
+ * IOARCB: 64 bytes, min 16 byte alignment required, host native endianness
+ * except for SCSI CDB which remains big endian per SCSI standards.
+ */
+struct sisl_ioarcb {
+	u16 ctx_id;		/* ctx_hndl_t */
+	u16 req_flags;
+#define SISL_REQ_FLAGS_RES_HNDL       0x8000u	/* bit 0 (MSB) */
+#define SISL_REQ_FLAGS_PORT_LUN_ID    0x0000u
+
+#define SISL_REQ_FLAGS_SUP_UNDERRUN   0x4000u	/* bit 1 */
+
+#define SISL_REQ_FLAGS_TIMEOUT_SECS   0x0000u	/* bits 8,9 */
+#define SISL_REQ_FLAGS_TIMEOUT_MSECS  0x0040u
+#define SISL_REQ_FLAGS_TIMEOUT_USECS  0x0080u
+#define SISL_REQ_FLAGS_TIMEOUT_CYCLES 0x00C0u
+
+#define SISL_REQ_FLAGS_TMF_CMD        0x0004u	/* bit 13 */
+
+#define SISL_REQ_FLAGS_AFU_CMD        0x0002u	/* bit 14 */
+
+#define SISL_REQ_FLAGS_HOST_WRITE     0x0001u	/* bit 15 (LSB) */
+#define SISL_REQ_FLAGS_HOST_READ      0x0000u
+
+	union {
+		u32 res_hndl;	/* res_hndl_t */
+		u32 port_sel;	/* this is a selection mask:
+				 * 0x1 -> port#0 can be selected,
+				 * 0x2 -> port#1 can be selected.
+				 * Can be bitwise ORed.
+				 */
+	};
+	u64 lun_id;
+	u32 data_len;		/* 4K for read/write */
+	u32 ioadl_len;
+	union {
+		u64 data_ea;	/* min 16 byte aligned */
+		u64 ioadl_ea;
+	};
+	u8 msi;			/* LISN to send on RRQ write */
+#define SISL_MSI_CXL_PFAULT        0	/* reserved for CXL page faults */
+#define SISL_MSI_SYNC_ERROR        1	/* recommended for AFU sync error */
+#define SISL_MSI_RRQ_UPDATED       2	/* recommended for IO completion */
+#define SISL_MSI_ASYNC_ERROR       3	/* master only - for AFU async error */
+
+	u8 rrq;			/* 0 for a single RRQ */
+	u16 timeout;		/* in units specified by req_flags */
+	u32 rsvd1;
+	u8 cdb[16];		/* must be in big endian */
+	struct scsi_cmnd *scp;
+};
+
+struct sisl_rc {
+	u8 flags;
+#define SISL_RC_FLAGS_SENSE_VALID         0x80u
+#define SISL_RC_FLAGS_FCP_RSP_CODE_VALID  0x40u
+#define SISL_RC_FLAGS_OVERRUN             0x20u
+#define SISL_RC_FLAGS_UNDERRUN            0x10u
+
+	u8 afu_rc;
+#define SISL_AFU_RC_RHT_INVALID           0x01u	/* user error */
+#define SISL_AFU_RC_RHT_UNALIGNED         0x02u	/* should never happen */
+#define SISL_AFU_RC_RHT_OUT_OF_BOUNDS     0x03u	/* user error */
+#define SISL_AFU_RC_RHT_DMA_ERR           0x04u	/* see afu_extra
+						   may retry if afu_retry is off
+						   possible on master exit
+						 */
+#define SISL_AFU_RC_RHT_RW_PERM           0x05u	/* no RW perms, user error */
+#define SISL_AFU_RC_LXT_UNALIGNED         0x12u	/* should never happen */
+#define SISL_AFU_RC_LXT_OUT_OF_BOUNDS     0x13u	/* user error */
+#define SISL_AFU_RC_LXT_DMA_ERR           0x14u	/* see afu_extra
+						   may retry if afu_retry is off
+						   possible on master exit
+						 */
+#define SISL_AFU_RC_LXT_RW_PERM           0x15u	/* no RW perms, user error */
+
+#define SISL_AFU_RC_NOT_XLATE_HOST        0x1au	/* possible if master exited */
+
+	/* NO_CHANNELS means the FC ports selected by dest_port in
+	 * IOARCB or in the LXT entry are down when the AFU tried to select
+	 * a FC port. If the port went down on an active IO, it will set
+	 * fc_rc to =0x54(NOLOGI) or 0x57(LINKDOWN) instead.
+	 */
+#define SISL_AFU_RC_NO_CHANNELS           0x20u	/* see afu_extra, may retry */
+#define SISL_AFU_RC_CAP_VIOLATION         0x21u	/* either user error or
+						   afu reset/master restart
+						 */
+#define SISL_AFU_RC_OUT_OF_DATA_BUFS      0x30u	/* always retry */
+#define SISL_AFU_RC_DATA_DMA_ERR          0x31u	/* see afu_extra
+						   may retry if afu_retry is off
+						 */
+
+	u8 scsi_rc;		/* SCSI status byte, retry as appropriate */
+#define SISL_SCSI_RC_CHECK                0x02u
+#define SISL_SCSI_RC_BUSY                 0x08u
+
+	u8 fc_rc;		/* retry */
+	/*
+	 * We should only see fc_rc=0x57 (LINKDOWN) or 0x54(NOLOGI) for
+	 * commands that are in flight when a link goes down or is logged out.
+	 * If the link is down or logged out before AFU selects the port, either
+	 * it will choose the other port or we will get afu_rc=0x20 (no_channel)
+	 * if there is no valid port to use.
+	 *
+	 * ABORTPEND/ABORTOK/ABORTFAIL/TGTABORT can be retried, typically these
+	 * would happen if a frame is dropped and something times out.
+	 * NOLOGI or LINKDOWN can be retried if the other port is up.
+	 * RESIDERR can be retried as well.
+	 *
+	 * ABORTFAIL might indicate that lots of frames are getting CRC errors.
+	 * So it maybe retried once and reset the link if it happens again.
+	 * The link can also be reset on the CRC error threshold interrupt.
+	 */
+#define SISL_FC_RC_ABORTPEND	0x52	/* exchange timeout or abort request */
+#define SISL_FC_RC_WRABORTPEND	0x53	/* due to write XFER_RDY invalid */
+#define SISL_FC_RC_NOLOGI	0x54	/* port not logged in, in-flight cmds */
+#define SISL_FC_RC_NOEXP	0x55	/* FC protocol error or HW bug */
+#define SISL_FC_RC_INUSE	0x56	/* tag already in use, HW bug */
+#define SISL_FC_RC_LINKDOWN	0x57	/* link down, in-flight cmds */
+#define SISL_FC_RC_ABORTOK	0x58	/* pending abort completed w/success */
+#define SISL_FC_RC_ABORTFAIL	0x59	/* pending abort completed w/fail */
+#define SISL_FC_RC_RESID	0x5A	/* ioasa underrun/overrun flags set */
+#define SISL_FC_RC_RESIDERR	0x5B	/* actual data len does not match SCSI
+					   reported len, possbly due to dropped
+					   frames */
+#define SISL_FC_RC_TGTABORT	0x5C	/* command aborted by target */
+};
+
+#define SISL_SENSE_DATA_LEN     20	/* Sense data length         */
+
+/*
+ * IOASA: 64 bytes & must follow IOARCB, min 16 byte alignment required,
+ * host native endianness
+ */
+struct sisl_ioasa {
+	union {
+		struct sisl_rc rc;
+		u32 ioasc;
+#define SISL_IOASC_GOOD_COMPLETION        0x00000000u
+	};
+	u32 resid;
+	u8 port;
+	u8 afu_extra;
+	/* when afu_rc=0x04, 0x14, 0x31 (_xxx_DMA_ERR):
+	 * afu_exta contains PSL response code. Useful codes are:
+	 */
+#define SISL_AFU_DMA_ERR_PAGE_IN	0x0A	/* AFU_retry_on_pagein Action
+						 *  Enabled            N/A
+						 *  Disabled           retry
+						 */
+#define SISL_AFU_DMA_ERR_INVALID_EA	0x0B	/* this is a hard error
+						 * afu_rc	Implies
+						 * 0x04, 0x14	master exit.
+						 * 0x31         user error.
+						 */
+	/* when afu rc=0x20 (no channels):
+	 * afu_extra bits [4:5]: available portmask,  [6:7]: requested portmask.
+	 */
+#define SISL_AFU_NO_CLANNELS_AMASK(afu_extra) (((afu_extra) & 0x0C) >> 2)
+#define SISL_AFU_NO_CLANNELS_RMASK(afu_extra) ((afu_extra) & 0x03)
+
+	u8 scsi_extra;
+	u8 fc_extra;
+	u8 sense_data[SISL_SENSE_DATA_LEN];
+
+	union {
+		u64 host_use[4];
+		u8 host_use_b[32];
+	};
+};
+
+#define SISL_RESP_HANDLE_T_BIT        0x1ull	/* Toggle bit */
+
+/* MMIO space is required to support only 64-bit access */
+
+/* per context host transport MMIO  */
+struct sisl_host_map {
+	__be64 endian_ctrl;
+	__be64 intr_status;	/* this sends LISN# programmed in ctx_ctrl.
+				 * Only recovery in a PERM_ERR is a context
+				 * exit since there is no way to tell which
+				 * command caused the error.
+				 */
+#define SISL_ISTATUS_PERM_ERR_CMDROOM    0x0010ull	/* b59, user error */
+#define SISL_ISTATUS_PERM_ERR_RCB_READ   0x0008ull	/* b60, user error */
+#define SISL_ISTATUS_PERM_ERR_SA_WRITE   0x0004ull	/* b61, user error */
+#define SISL_ISTATUS_PERM_ERR_RRQ_WRITE  0x0002ull	/* b62, user error */
+	/* Page in wait accessing RCB/IOASA/RRQ is reported in b63.
+	 * Same error in data/LXT/RHT access is reported via IOASA.
+	 */
+#define SISL_ISTATUS_TEMP_ERR_PAGEIN     0x0001ull	/* b63, can be generated
+							 * only when AFU auto
+							 * retry is disabled.
+							 * If user can determine
+							 * the command that
+							 * caused the error, it
+							 * can be retried.
+							 */
+#define SISL_ISTATUS_UNMASK  (0x001Full)	/* 1 means unmasked */
+#define SISL_ISTATUS_MASK    ~(SISL_ISTATUS_UNMASK)	/* 1 means masked */
+
+	__be64 intr_clear;
+	__be64 intr_mask;
+	__be64 ioarrin;		/* only write what cmd_room permits */
+	__be64 rrq_start;	/* start & end are both inclusive */
+	__be64 rrq_end;		/* write sequence: start followed by end */
+	__be64 cmd_room;
+	__be64 ctx_ctrl;	/* least signiifcant byte or b56:63 is LISN# */
+	__be64 mbox_w;		/* restricted use */
+};
+
+/* per context provisioning & control MMIO */
+struct sisl_ctrl_map {
+	__be64 rht_start;
+	__be64 rht_cnt_id;
+	/* both cnt & ctx_id args must be ull */
+#define SISL_RHT_CNT_ID(cnt, ctx_id)  (((cnt) << 48) | ((ctx_id) << 32))
+
+	__be64 ctx_cap;	/* afu_rc below is when the capability is violated */
+#define SISL_CTX_CAP_PROXY_ISSUE       0x8000000000000000ull /* afu_rc 0x21 */
+#define SISL_CTX_CAP_REAL_MODE         0x4000000000000000ull /* afu_rc 0x21 */
+#define SISL_CTX_CAP_HOST_XLATE        0x2000000000000000ull /* afu_rc 0x1a */
+#define SISL_CTX_CAP_PROXY_TARGET      0x1000000000000000ull /* afu_rc 0x21 */
+#define SISL_CTX_CAP_AFU_CMD           0x0000000000000008ull /* afu_rc 0x21 */
+#define SISL_CTX_CAP_GSCSI_CMD         0x0000000000000004ull /* afu_rc 0x21 */
+#define SISL_CTX_CAP_WRITE_CMD         0x0000000000000002ull /* afu_rc 0x21 */
+#define SISL_CTX_CAP_READ_CMD          0x0000000000000001ull /* afu_rc 0x21 */
+	__be64 mbox_r;
+};
+
+/* single copy global regs */
+struct sisl_global_regs {
+	__be64 aintr_status;
+	/* In cxlflash, each FC port/link gets a byte of status */
+#define SISL_ASTATUS_FC0_OTHER	 0x8000ull /* b48, other err,
+					      FC_ERRCAP[31:20] */
+#define SISL_ASTATUS_FC0_LOGO    0x4000ull /* b49, target sent FLOGI/PLOGI/LOGO
+						   while logged in */
+#define SISL_ASTATUS_FC0_CRC_T   0x2000ull /* b50, CRC threshold exceeded */
+#define SISL_ASTATUS_FC0_LOGI_R  0x1000ull /* b51, login state mechine timed out
+						   and retrying */
+#define SISL_ASTATUS_FC0_LOGI_F  0x0800ull /* b52, login failed,
+					      FC_ERROR[19:0] */
+#define SISL_ASTATUS_FC0_LOGI_S  0x0400ull /* b53, login succeeded */
+#define SISL_ASTATUS_FC0_LINK_DN 0x0200ull /* b54, link online to offline */
+#define SISL_ASTATUS_FC0_LINK_UP 0x0100ull /* b55, link offline to online */
+
+#define SISL_ASTATUS_FC1_OTHER   0x0080ull /* b56 */
+#define SISL_ASTATUS_FC1_LOGO    0x0040ull /* b57 */
+#define SISL_ASTATUS_FC1_CRC_T   0x0020ull /* b58 */
+#define SISL_ASTATUS_FC1_LOGI_R  0x0010ull /* b59 */
+#define SISL_ASTATUS_FC1_LOGI_F  0x0008ull /* b60 */
+#define SISL_ASTATUS_FC1_LOGI_S  0x0004ull /* b61 */
+#define SISL_ASTATUS_FC1_LINK_DN 0x0002ull /* b62 */
+#define SISL_ASTATUS_FC1_LINK_UP 0x0001ull /* b63 */
+
+#define SISL_FC_INTERNAL_UNMASK	0x0000000300000000ull	/* 1 means unmasked */
+#define SISL_FC_INTERNAL_MASK	~(SISL_FC_INTERNAL_UNMASK)
+#define SISL_FC_INTERNAL_SHIFT	32
+
+#define SISL_ASTATUS_UNMASK	0xFFFFull		/* 1 means unmasked */
+#define SISL_ASTATUS_MASK	~(SISL_ASTATUS_UNMASK)	/* 1 means masked */
+
+	__be64 aintr_clear;
+	__be64 aintr_mask;
+	__be64 afu_ctrl;
+	__be64 afu_hb;
+	__be64 afu_scratch_pad;
+	__be64 afu_port_sel;
+	__be64 afu_config;
+	__be64 rsvd[0xf8];
+	__be64 afu_version;
+	__be64 interface_version;
+};
+
+#define CXLFLASH_NUM_FC_PORTS   2
+#define CXLFLASH_MAX_CONTEXT  512	/* how many contexts per afu */
+#define CXLFLASH_NUM_VLUNS    512
+
+struct sisl_global_map {
+	union {
+		struct sisl_global_regs regs;
+		char page0[PAGE_SIZE_4K];	/* page 0 */
+	};
+
+	char page1[PAGE_SIZE_4K];	/* page 1 */
+
+	/* pages 2 & 3 */
+	__be64 fc_regs[CXLFLASH_NUM_FC_PORTS][CXLFLASH_NUM_VLUNS];
+
+	/* pages 4 & 5 (lun tbl) */
+	__be64 fc_port[CXLFLASH_NUM_FC_PORTS][CXLFLASH_NUM_VLUNS];
+
+};
+
+/*
+ * CXL Flash Memory Map
+ *
+ *	+-------------------------------+
+ *	|    512 * 64 KB User MMIO      |
+ *	|        (per context)          |
+ *	|       User Accessible         |
+ *	+-------------------------------+
+ *	|    512 * 128 B per context    |
+ *	|    Provisioning and Control   |
+ *	|   Trusted Process accessible  |
+ *	+-------------------------------+
+ *	|         64 KB Global          |
+ *	|   Trusted Process accessible  |
+ *	+-------------------------------+
+*/
+struct cxlflash_afu_map {
+	union {
+		struct sisl_host_map host;
+		char harea[PAGE_SIZE_64K];	/* 64KB each */
+	} hosts[CXLFLASH_MAX_CONTEXT];
+
+	union {
+		struct sisl_ctrl_map ctrl;
+		char carea[cache_line_size()];	/* 128B each */
+	} ctrls[CXLFLASH_MAX_CONTEXT];
+
+	union {
+		struct sisl_global_map global;
+		char garea[PAGE_SIZE_64K];	/* 64KB single block */
+	};
+};
+
+/* LBA translation control blocks */
+
+struct sisl_lxt_entry {
+	__be64 rlba_base;	/* bits 0:47 is base
+				 * b48:55 is lun index
+				 * b58:59 is write & read perms
+				 * (if no perm, afu_rc=0x15)
+				 * b60:63 is port_sel mask
+				 */
+
+};
+
+struct sisl_rht_entry {
+	struct sisl_lxt_entry *lxt_start;
+	__be32 lxt_cnt;
+	__be16 rsvd;
+	u8 fp;			/* format & perm nibbles.
+				 * (if no perm, afu_rc=0x05)
+				 */
+	u8 nmask;
+} __aligned(16);
+
+struct sisl_rht_entry_f1 {
+	__be64 lun_id;
+	union {
+		struct {
+			u8 valid;
+			u8 rsvd[5];
+			u8 fp;
+			u8 port_sel;
+		};
+
+		__be64 dw;
+	};
+} __aligned(16);
+
+/* make the fp byte */
+#define SISL_RHT_FP(fmt, perm) (((fmt) << 4) | (perm))
+
+/* make the fp byte for a clone from a source fp and clone flags
+ * flags must be only 2 LSB bits.
+ */
+#define SISL_RHT_FP_CLONE(src_fp, cln_flags) ((src_fp) & (0xFC | (cln_flags)))
+
+/* extract the perm bits from a fp */
+#define SISL_RHT_PERM(fp) ((fp) & 0x3)
+
+#define RHT_PERM_READ  0x01u
+#define RHT_PERM_WRITE 0x02u
+
+/* AFU Sync Mode byte */
+#define AFU_LW_SYNC 0x0u
+#define AFU_HW_SYNC 0x1u
+#define AFU_GSYNC   0x2u
+
+/* Special Task Management Function CDB */
+#define TMF_LUN_RESET  0x1u
+#define TMF_CLEAR_ACA  0x2u
+
+#endif /* _SISLITE_H */
-- 
2.1.0

