From: adam radford <aradford@gmail.com>
Subject: [PATCH 7/11]: REPOST: megaraid_sas: Add MegaRAID 9265/9285 specific
 functions: megaraid_sas_fusion.c
Date: Thu, 16 Dec 2010 12:26:17 -0800
Message-ID: <AANLkTimE43Tzett1bihP-poq__71tS+i2UNxwBvnO9nP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0022152d6665ada86f04978cdd0c
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52869 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab0LPU0S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2010 15:26:18 -0500
Received: by qwa26 with SMTP id 26so3644665qwa.19
        for <linux-scsi@vger.kernel.org>; Thu, 16 Dec 2010 12:26:17 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0022152d6665ada86f04978cdd0c
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

REPOSTED to fix stack usage issue found by Tomas Henzl @ RedHat.

This patch adds the MegaRAID 9265/9285 specific functions contained in
the file megaraid_sas_fusion.c.

Signed-off-by: Adam Radford <aradford@gmail.com>

Note: The patch has been included in-line below, and also as an
attachment in case Gmail hoses the patch.

diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_fusion.c	1969-12-31
16:00:00.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2010-12-16
12:03:42.000000000 -0800
@@ -0,0 +1,2250 @@
+/*
+ *  Linux MegaRAID driver for SAS based RAID controllers
+ *
+ *  Copyright (c) 2009-2011  LSI Corporation.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ *  FILE: megaraid_sas_fusion.c
+ *
+ *  Authors: LSI Corporation
+ *           Sumant Patro
+ *           Adam Radford <linuxraid@lsi.com>
+ *
+ *  Send feedback to: <megaraidlinux@lsi.com>
+ *
+ *  Mail to: LSI Corporation, 1621 Barber Lane, Milpitas, CA 95035
+ *     ATTN: Linuxraid
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/list.h>
+#include <linux/moduleparam.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/smp_lock.h>
+#include <linux/uio.h>
+#include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/compat.h>
+#include <linux/blkdev.h>
+#include <linux/mutex.h>
+#include <linux/poll.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+
+#include "megaraid_sas_fusion.h"
+#include "megaraid_sas.h"
+
+extern void megasas_free_cmds(struct megasas_instance *instance);
+extern struct megasas_cmd *megasas_get_cmd(struct megasas_instance
+					   *instance);
+extern void
+megasas_complete_cmd(struct megasas_instance *instance,
+		     struct megasas_cmd *cmd, u8 alt_status);
+int megasas_is_ldio(struct scsi_cmnd *cmd);
+int
+wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd);
+
+void
+megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd);
+int megasas_alloc_cmds(struct megasas_instance *instance);
+int
+megasas_clear_intr_fusion(struct megasas_register_set __iomem *regs);
+int
+megasas_issue_polled(struct megasas_instance *instance,
+		     struct megasas_cmd *cmd);
+
+u8
+MR_BuildRaidContext(struct IO_REQUEST_INFO *io_info,
+		    struct RAID_CONTEXT *pRAID_Context,
+		    struct MR_FW_RAID_MAP_ALL *map);
+u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL *map);
+struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
+
+u16 MR_GetLDTgtId(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
+u8 MR_ValidateMapInfo(struct MR_FW_RAID_MAP_ALL *map,
+		      struct LD_LOAD_BALANCE_INFO *lbInfo);
+u16 get_updated_dev_handle(struct LD_LOAD_BALANCE_INFO *lbInfo,
+			   struct IO_REQUEST_INFO *in_info);
+int megasas_transition_to_ready(struct megasas_instance *instance);
+void megaraid_sas_kill_hba(struct megasas_instance *instance);
+
+extern u32 megasas_dbg_lvl;
+
+/**
+ * megasas_enable_intr_fusion -	Enables interrupts
+ * @regs:			MFI register set
+ */
+void
+megasas_enable_intr_fusion(struct megasas_register_set __iomem *regs)
+{
+	writel(~MFI_FUSION_ENABLE_INTERRUPT_MASK, &(regs)->outbound_intr_mask);
+
+	/* Dummy readl to force pci flush */
+	readl(&regs->outbound_intr_mask);
+}
+
+/**
+ * megasas_disable_intr_fusion - Disables interrupt
+ * @regs:			 MFI register set
+ */
+void
+megasas_disable_intr_fusion(struct megasas_register_set __iomem *regs)
+{
+	u32 mask = 0xFFFFFFFF;
+	u32 status;
+
+	writel(mask, &regs->outbound_intr_mask);
+	/* Dummy readl to force pci flush */
+	status = readl(&regs->outbound_intr_mask);
+}
+
+int
+megasas_clear_intr_fusion(struct megasas_register_set __iomem *regs)
+{
+	u32 status;
+	/*
+	 * Check if it is our interrupt
+	 */
+	status = readl(&regs->outbound_intr_status);
+
+	if (status & 1) {
+		writel(status, &regs->outbound_intr_status);
+		readl(&regs->outbound_intr_status);
+		return 1;
+	}
+	if (!(status & MFI_FUSION_ENABLE_INTERRUPT_MASK))
+		return 0;
+
+	/*
+	 * dummy read to flush PCI
+	 */
+	readl(&regs->outbound_intr_status);
+
+	return 1;
+}
+
+/**
+ * megasas_get_cmd_fusion -	Get a command from the free pool
+ * @instance:		Adapter soft state
+ *
+ * Returns a free command from the pool
+ */
+struct megasas_cmd_fusion *megasas_get_cmd_fusion(struct megasas_instance
+						  *instance)
+{
+	unsigned long flags;
+	struct fusion_context *fusion =
+		(struct fusion_context *)instance->ctrl_context;
+	struct megasas_cmd_fusion *cmd = NULL;
+
+	spin_lock_irqsave(&fusion->cmd_pool_lock, flags);
+
+	if (!list_empty(&fusion->cmd_pool)) {
+		cmd = list_entry((&fusion->cmd_pool)->next,
+				 struct megasas_cmd_fusion, list);
+		list_del_init(&cmd->list);
+	} else {
+		printk(KERN_ERR "megasas: Command pool (fusion) empty!\n");
+	}
+
+	spin_unlock_irqrestore(&fusion->cmd_pool_lock, flags);
+	return cmd;
+}
+
+/**
+ * megasas_return_cmd_fusion -	Return a cmd to free command pool
+ * @instance:		Adapter soft state
+ * @cmd:		Command packet to be returned to free command pool
+ */
+static inline void
+megasas_return_cmd_fusion(struct megasas_instance *instance,
+			  struct megasas_cmd_fusion *cmd)
+{
+	unsigned long flags;
+	struct fusion_context *fusion =
+		(struct fusion_context *)instance->ctrl_context;
+
+	spin_lock_irqsave(&fusion->cmd_pool_lock, flags);
+
+	cmd->scmd = NULL;
+	cmd->sync_cmd_idx = (u32)ULONG_MAX;
+	list_add_tail(&cmd->list, &fusion->cmd_pool);
+
+	spin_unlock_irqrestore(&fusion->cmd_pool_lock, flags);
+}
+
+/**
+ * megasas_teardown_frame_pool_fusion -	Destroy the cmd frame DMA pool
+ * @instance:				Adapter soft state
+ */
+static void megasas_teardown_frame_pool_fusion(
+	struct megasas_instance *instance)
+{
+	int i;
+	struct fusion_context *fusion = instance->ctrl_context;
+
+	u16 max_cmd = instance->max_fw_cmds;
+
+	struct megasas_cmd_fusion *cmd;
+
+	if (!fusion->sg_dma_pool || !fusion->sense_dma_pool) {
+		printk(KERN_ERR "megasas: dma pool is null. SG Pool %p, "
+		       "sense pool : %p\n", fusion->sg_dma_pool,
+		       fusion->sense_dma_pool);
+		return;
+	}
+
+	/*
+	 * Return all frames to pool
+	 */
+	for (i = 0; i < max_cmd; i++) {
+
+		cmd = fusion->cmd_list[i];
+
+		if (cmd->sg_frame)
+			pci_pool_free(fusion->sg_dma_pool, cmd->sg_frame,
+				      cmd->sg_frame_phys_addr);
+
+		if (cmd->sense)
+			pci_pool_free(fusion->sense_dma_pool, cmd->sense,
+				      cmd->sense_phys_addr);
+	}
+
+	/*
+	 * Now destroy the pool itself
+	 */
+	pci_pool_destroy(fusion->sg_dma_pool);
+	pci_pool_destroy(fusion->sense_dma_pool);
+
+	fusion->sg_dma_pool = NULL;
+	fusion->sense_dma_pool = NULL;
+}
+
+/**
+ * megasas_free_cmds_fusion -	Free all the cmds in the free cmd pool
+ * @instance:		Adapter soft state
+ */
+void
+megasas_free_cmds_fusion(struct megasas_instance *instance)
+{
+	int i;
+	struct fusion_context *fusion = instance->ctrl_context;
+
+	u32 max_cmds, req_sz, reply_sz, io_frames_sz;
+
+
+	req_sz = fusion->request_alloc_sz;
+	reply_sz = fusion->reply_alloc_sz;
+	io_frames_sz = fusion->io_frames_alloc_sz;
+
+	max_cmds = instance->max_fw_cmds;
+
+	/* Free descriptors and request Frames memory */
+	if (fusion->req_frames_desc)
+		dma_free_coherent(&instance->pdev->dev, req_sz,
+				  fusion->req_frames_desc,
+				  fusion->req_frames_desc_phys);
+
+	if (fusion->reply_frames_desc) {
+		pci_pool_free(fusion->reply_frames_desc_pool,
+			      fusion->reply_frames_desc,
+			      fusion->reply_frames_desc_phys);
+		pci_pool_destroy(fusion->reply_frames_desc_pool);
+	}
+
+	if (fusion->io_request_frames) {
+		pci_pool_free(fusion->io_request_frames_pool,
+			      fusion->io_request_frames,
+			      fusion->io_request_frames_phys);
+		pci_pool_destroy(fusion->io_request_frames_pool);
+	}
+
+	/* Free the Fusion frame pool */
+	megasas_teardown_frame_pool_fusion(instance);
+
+	/* Free all the commands in the cmd_list */
+	for (i = 0; i < max_cmds; i++)
+		kfree(fusion->cmd_list[i]);
+
+	/* Free the cmd_list buffer itself */
+	kfree(fusion->cmd_list);
+	fusion->cmd_list = NULL;
+
+	INIT_LIST_HEAD(&fusion->cmd_pool);
+}
+
+/**
+ * megasas_create_frame_pool_fusion -	Creates DMA pool for cmd frames
+ * @instance:			Adapter soft state
+ *
+ */
+static int megasas_create_frame_pool_fusion(struct megasas_instance *instance)
+{
+	int i;
+	u32 max_cmd;
+	struct fusion_context *fusion;
+	struct megasas_cmd_fusion *cmd;
+	u32 total_sz_chain_frame;
+
+	fusion = instance->ctrl_context;
+	max_cmd = instance->max_fw_cmds;
+
+	total_sz_chain_frame = MEGASAS_MAX_SZ_CHAIN_FRAME;
+
+	/*
+	 * Use DMA pool facility provided by PCI layer
+	 */
+
+	fusion->sg_dma_pool = pci_pool_create("megasas sg pool fusion",
+					      instance->pdev,
+					      total_sz_chain_frame, 4,
+					      0);
+	if (!fusion->sg_dma_pool) {
+		printk(KERN_DEBUG "megasas: failed to setup request pool "
+		       "fusion\n");
+		return -ENOMEM;
+	}
+	fusion->sense_dma_pool = pci_pool_create("megasas sense pool fusion",
+						 instance->pdev,
+						 SCSI_SENSE_BUFFERSIZE, 64, 0);
+
+	if (!fusion->sense_dma_pool) {
+		printk(KERN_DEBUG "megasas: failed to setup sense pool "
+		       "fusion\n");
+		pci_pool_destroy(fusion->sg_dma_pool);
+		fusion->sg_dma_pool = NULL;
+		return -ENOMEM;
+	}
+
+	/*
+	 * Allocate and attach a frame to each of the commands in cmd_list
+	 */
+	for (i = 0; i < max_cmd; i++) {
+
+		cmd = fusion->cmd_list[i];
+
+		cmd->sg_frame = pci_pool_alloc(fusion->sg_dma_pool,
+					       GFP_KERNEL,
+					       &cmd->sg_frame_phys_addr);
+
+		cmd->sense = pci_pool_alloc(fusion->sense_dma_pool,
+					    GFP_KERNEL, &cmd->sense_phys_addr);
+		/*
+		 * megasas_teardown_frame_pool_fusion() takes care of freeing
+		 * whatever has been allocated
+		 */
+		if (!cmd->sg_frame || !cmd->sense) {
+			printk(KERN_DEBUG "megasas: pci_pool_alloc failed\n");
+			megasas_teardown_frame_pool_fusion(instance);
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
+/**
+ * megasas_alloc_cmds_fusion -	Allocates the command packets
+ * @instance:		Adapter soft state
+ *
+ *
+ * Each frame has a 32-bit field called context. This context is used to get
+ * back the megasas_cmd_fusion from the frame when a frame gets completed
+ * In this driver, the 32 bit values are the indices into an array cmd_list.
+ * This array is used only to look up the megasas_cmd_fusion given the context.
+ * The free commands themselves are maintained in a linked list
called cmd_pool.
+ *
+ * cmds are formed in the io_request and sg_frame members of the
+ * megasas_cmd_fusion. The context field is used to get a request descriptor
+ * and is used as SMID of the cmd.
+ * SMID value range is from 1 to max_fw_cmds.
+ */
+int
+megasas_alloc_cmds_fusion(struct megasas_instance *instance)
+{
+	int i, j;
+	u32 max_cmd, io_frames_sz;
+	struct fusion_context *fusion;
+	struct megasas_cmd_fusion *cmd;
+	union MPI2_REPLY_DESCRIPTORS_UNION *reply_desc;
+	u32 offset;
+	dma_addr_t io_req_base_phys;
+	u8 *io_req_base;
+
+	fusion = instance->ctrl_context;
+
+	max_cmd = instance->max_fw_cmds;
+
+	fusion->req_frames_desc =
+		dma_alloc_coherent(&instance->pdev->dev,
+				   fusion->request_alloc_sz,
+				   &fusion->req_frames_desc_phys, GFP_KERNEL);
+
+	if (!fusion->req_frames_desc) {
+		printk(KERN_ERR "megasas; Could not allocate memory for "
+		       "request_frames\n");
+		goto fail_req_desc;
+	}
+
+	fusion->reply_frames_desc_pool =
+		pci_pool_create("reply_frames pool", instance->pdev,
+				fusion->reply_alloc_sz, 16, 0);
+
+	if (!fusion->reply_frames_desc_pool) {
+		printk(KERN_ERR "megasas; Could not allocate memory for "
+		       "reply_frame pool\n");
+		goto fail_reply_desc;
+	}
+
+	fusion->reply_frames_desc =
+		pci_pool_alloc(fusion->reply_frames_desc_pool, GFP_KERNEL,
+			       &fusion->reply_frames_desc_phys);
+	if (!fusion->reply_frames_desc) {
+		printk(KERN_ERR "megasas; Could not allocate memory for "
+		       "reply_frame pool\n");
+		pci_pool_destroy(fusion->reply_frames_desc_pool);
+		goto fail_reply_desc;
+	}
+
+	reply_desc = fusion->reply_frames_desc;
+	for (i = 0; i < fusion->reply_q_depth; i++, reply_desc++)
+		reply_desc->Words = ULLONG_MAX;
+
+	io_frames_sz = fusion->io_frames_alloc_sz;
+
+	fusion->io_request_frames_pool =
+		pci_pool_create("io_request_frames pool", instance->pdev,
+				fusion->io_frames_alloc_sz, 16, 0);
+
+	if (!fusion->io_request_frames_pool) {
+		printk(KERN_ERR "megasas: Could not allocate memory for "
+		       "io_request_frame pool\n");
+		goto fail_io_frames;
+	}
+
+	fusion->io_request_frames =
+		pci_pool_alloc(fusion->io_request_frames_pool, GFP_KERNEL,
+			       &fusion->io_request_frames_phys);
+	if (!fusion->io_request_frames) {
+		printk(KERN_ERR "megasas: Could not allocate memory for "
+		       "io_request_frames frames\n");
+		pci_pool_destroy(fusion->io_request_frames_pool);
+		goto fail_io_frames;
+	}
+
+	/*
+	 * fusion->cmd_list is an array of struct megasas_cmd_fusion pointers.
+	 * Allocate the dynamic array first and then allocate individual
+	 * commands.
+	 */
+	fusion->cmd_list = kmalloc(sizeof(struct megasas_cmd_fusion *)
+				   *max_cmd, GFP_KERNEL);
+
+	if (!fusion->cmd_list) {
+		printk(KERN_DEBUG "megasas: out of memory. Could not alloc "
+		       "memory for cmd_list_fusion\n");
+		goto fail_cmd_list;
+	}
+
+	memset(fusion->cmd_list, 0, sizeof(struct megasas_cmd_fusion *)
+	       *max_cmd);
+
+	max_cmd = instance->max_fw_cmds;
+	for (i = 0; i < max_cmd; i++) {
+		fusion->cmd_list[i] = kmalloc(sizeof(struct megasas_cmd_fusion),
+					      GFP_KERNEL);
+		if (!fusion->cmd_list[i]) {
+			printk(KERN_ERR "Could not alloc cmd list fusion\n");
+
+			for (j = 0; j < i; j++)
+				kfree(fusion->cmd_list[j]);
+
+			kfree(fusion->cmd_list);
+			fusion->cmd_list = NULL;
+			goto fail_cmd_list;
+		}
+	}
+
+	/* The first 256 bytes (SMID 0) is not used. Don't add to cmd list */
+	io_req_base = fusion->io_request_frames +
+		MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE;
+	io_req_base_phys = fusion->io_request_frames_phys +
+		MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE;
+
+	/*
+	 * Add all the commands to command pool (fusion->cmd_pool)
+	 */
+
+	/* SMID 0 is reserved. Set SMID/index from 1 */
+	for (i = 0; i < max_cmd; i++) {
+		cmd = fusion->cmd_list[i];
+		offset = MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE * i;
+		memset(cmd, 0, sizeof(struct megasas_cmd_fusion));
+		cmd->index = i + 1;
+		cmd->scmd = NULL;
+		cmd->sync_cmd_idx = (u32)ULONG_MAX; /* Set to Invalid */
+		cmd->instance = instance;
+		cmd->io_request =
+			(struct MPI2_RAID_SCSI_IO_REQUEST *)
+		  (io_req_base + offset);
+		memset(cmd->io_request, 0,
+		       sizeof(struct MPI2_RAID_SCSI_IO_REQUEST));
+		cmd->io_request_phys_addr = io_req_base_phys + offset;
+
+		list_add_tail(&cmd->list, &fusion->cmd_pool);
+	}
+
+	/*
+	 * Create a frame pool and assign one frame to each cmd
+	 */
+	if (megasas_create_frame_pool_fusion(instance)) {
+		printk(KERN_DEBUG "megasas: Error creating frame DMA pool\n");
+		megasas_free_cmds_fusion(instance);
+		goto fail_req_desc;
+	}
+
+	return 0;
+
+fail_cmd_list:
+	pci_pool_free(fusion->io_request_frames_pool, fusion->io_request_frames,
+		      fusion->io_request_frames_phys);
+	pci_pool_destroy(fusion->io_request_frames_pool);
+fail_io_frames:
+	dma_free_coherent(&instance->pdev->dev, fusion->request_alloc_sz,
+			  fusion->reply_frames_desc,
+			  fusion->reply_frames_desc_phys);
+	pci_pool_free(fusion->reply_frames_desc_pool,
+		      fusion->reply_frames_desc,
+		      fusion->reply_frames_desc_phys);
+	pci_pool_destroy(fusion->reply_frames_desc_pool);
+
+fail_reply_desc:
+	dma_free_coherent(&instance->pdev->dev, fusion->request_alloc_sz,
+			  fusion->req_frames_desc,
+			  fusion->req_frames_desc_phys);
+fail_req_desc:
+	return -ENOMEM;
+}
+
+/**
+ * wait_and_poll -	Issues a polling command
+ * @instance:			Adapter soft state
+ * @cmd:			Command packet to be issued
+ *
+ * For polling, MFI requires the cmd_status to be set to 0xFF before posting.
+ */
+int
+wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd)
+{
+	int i;
+	struct megasas_header *frame_hdr = &cmd->frame->hdr;
+
+	u32 msecs = MFI_POLL_TIMEOUT_SECS * 1000;
+
+	/*
+	 * Wait for cmd_status to change
+	 */
+	for (i = 0; (i < msecs) && (frame_hdr->cmd_status == 0xff); i += 20) {
+		rmb();
+		msleep(20);
+	}
+
+	if (frame_hdr->cmd_status == 0xff)
+		return -ETIME;
+
+	return 0;
+}
+
+/**
+ * megasas_ioc_init_fusion -	Initializes the FW
+ * @instance:		Adapter soft state
+ *
+ * Issues the IOC Init cmd
+ */
+int
+megasas_ioc_init_fusion(struct megasas_instance *instance)
+{
+	struct megasas_init_frame *init_frame;
+	struct MPI2_IOC_INIT_REQUEST *IOCInitMessage;
+	dma_addr_t	ioc_init_handle;
+	u32 context;
+	struct megasas_cmd *cmd;
+	u8 ret;
+	struct fusion_context *fusion;
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	int i;
+	struct megasas_header *frame_hdr;
+
+	fusion = instance->ctrl_context;
+
+	cmd = megasas_get_cmd(instance);
+
+	if (!cmd) {
+		printk(KERN_ERR "Could not allocate cmd for INIT Frame\n");
+		ret = 1;
+		goto fail_get_cmd;
+	}
+
+	IOCInitMessage =
+	  dma_alloc_coherent(&instance->pdev->dev,
+			     sizeof(struct MPI2_IOC_INIT_REQUEST),
+			     &ioc_init_handle, GFP_KERNEL);
+
+	if (!IOCInitMessage) {
+		printk(KERN_ERR "Could not allocate memory for "
+		       "IOCInitMessage\n");
+		ret = 1;
+		goto fail_fw_init;
+	}
+
+	memset(IOCInitMessage, 0, sizeof(struct MPI2_IOC_INIT_REQUEST));
+
+	IOCInitMessage->Function = MPI2_FUNCTION_IOC_INIT;
+	IOCInitMessage->WhoInit	= MPI2_WHOINIT_HOST_DRIVER;
+	IOCInitMessage->MsgVersion = MPI2_VERSION;
+	IOCInitMessage->HeaderVersion = MPI2_HEADER_VERSION;
+	IOCInitMessage->SystemRequestFrameSize =
+		MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE / 4;
+
+	IOCInitMessage->ReplyDescriptorPostQueueDepth = fusion->reply_q_depth;
+	IOCInitMessage->ReplyDescriptorPostQueueAddress	=
+		fusion->reply_frames_desc_phys;
+	IOCInitMessage->SystemRequestFrameBaseAddress =
+		fusion->io_request_frames_phys;
+
+	init_frame = (struct megasas_init_frame *)cmd->frame;
+	memset(init_frame, 0, MEGAMFI_FRAME_SIZE);
+
+	frame_hdr = &cmd->frame->hdr;
+	context = init_frame->context;
+	init_frame->context = context;
+
+	frame_hdr->cmd_status = 0xFF;
+	frame_hdr->flags |= MFI_FRAME_DONT_POST_IN_REPLY_QUEUE;
+
+	init_frame->cmd	= MFI_CMD_INIT;
+	init_frame->cmd_status = 0xFF;
+
+	init_frame->queue_info_new_phys_addr_lo = ioc_init_handle;
+	init_frame->data_xfer_len = sizeof(struct MPI2_IOC_INIT_REQUEST);
+
+	req_desc =
+	  (union MEGASAS_REQUEST_DESCRIPTOR_UNION *)fusion->req_frames_desc;
+
+	req_desc->Words = cmd->frame_phys_addr;
+	req_desc->MFAIo.RequestFlags =
+		(MEGASAS_REQ_DESCRIPT_FLAGS_MFA <<
+		 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+
+	/*
+	 * disable the intr before firing the init frame
+	 */
+	instance->instancet->disable_intr(instance->reg_set);
+
+	for (i = 0; i < (10 * 1000); i += 20) {
+		if (readl(&instance->reg_set->doorbell) & 1)
+			msleep(20);
+		else
+			break;
+	}
+
+	instance->instancet->fire_cmd(instance, req_desc->u.low,
+				      req_desc->u.high, instance->reg_set);
+
+	wait_and_poll(instance, cmd);
+
+	frame_hdr = &cmd->frame->hdr;
+	if (frame_hdr->cmd_status != 0) {
+		ret = 1;
+		goto fail_fw_init;
+	}
+	printk(KERN_ERR "megasas:IOC Init cmd success\n");
+
+	ret = 0;
+
+fail_fw_init:
+	megasas_return_cmd(instance, cmd);
+	if (IOCInitMessage)
+		dma_free_coherent(&instance->pdev->dev,
+				  sizeof(struct MPI2_IOC_INIT_REQUEST),
+				  IOCInitMessage, ioc_init_handle);
+fail_get_cmd:
+	return ret;
+}
+
+/*
+ * megasas_return_cmd_for_smid -	Returns a cmd_fusion for a SMID
+ * @instance:				Adapter soft state
+ *
+ */
+void
+megasas_return_cmd_for_smid(struct megasas_instance *instance, u16 smid)
+{
+	struct fusion_context *fusion;
+	struct megasas_cmd_fusion *cmd;
+
+	fusion = instance->ctrl_context;
+	cmd = fusion->cmd_list[smid - 1];
+	megasas_return_cmd_fusion(instance, cmd);
+}
+
+/*
+ * megasas_get_ld_map_info -	Returns FW's ld_map structure
+ * @instance:				Adapter soft state
+ * @pend:				Pend the command or not
+ * Issues an internal command (DCMD) to get the FW's controller PD
+ * list structure.  This information is mainly used to find out SYSTEM
+ * supported by the FW.
+ */
+static int
+megasas_get_ld_map_info(struct megasas_instance *instance)
+{
+	int ret = 0;
+	struct megasas_cmd *cmd;
+	struct megasas_dcmd_frame *dcmd;
+	struct MR_FW_RAID_MAP_ALL *ci;
+	dma_addr_t ci_h = 0;
+	u32 size_map_info;
+	struct fusion_context *fusion;
+
+	cmd = megasas_get_cmd(instance);
+
+	if (!cmd) {
+		printk(KERN_DEBUG "megasas: Failed to get cmd for map info.\n");
+		return -ENOMEM;
+	}
+
+	fusion = instance->ctrl_context;
+
+	if (!fusion) {
+		megasas_return_cmd(instance, cmd);
+		return 1;
+	}
+
+	dcmd = &cmd->frame->dcmd;
+
+	size_map_info = sizeof(struct MR_FW_RAID_MAP) +
+		(sizeof(struct MR_LD_SPAN_MAP) *(MAX_LOGICAL_DRIVES - 1));
+
+	ci = fusion->ld_map[(instance->map_id & 1)];
+	ci_h = fusion->ld_map_phys[(instance->map_id & 1)];
+
+	if (!ci) {
+		printk(KERN_DEBUG "Failed to alloc mem for ld_map_info\n");
+		megasas_return_cmd(instance, cmd);
+		return -ENOMEM;
+	}
+
+	memset(ci, 0, sizeof(*ci));
+	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+	dcmd->cmd = MFI_CMD_DCMD;
+	dcmd->cmd_status = 0xFF;
+	dcmd->sge_count = 1;
+	dcmd->flags = MFI_FRAME_DIR_READ;
+	dcmd->timeout = 0;
+	dcmd->pad_0 = 0;
+	dcmd->data_xfer_len = size_map_info;
+	dcmd->opcode = MR_DCMD_LD_MAP_GET_INFO;
+	dcmd->sgl.sge32[0].phys_addr = ci_h;
+	dcmd->sgl.sge32[0].length = size_map_info;
+
+	if (!megasas_issue_polled(instance, cmd))
+		ret = 0;
+	else {
+		printk(KERN_ERR "megasas: Get LD Map Info Failed\n");
+		ret = -1;
+	}
+
+	megasas_return_cmd(instance, cmd);
+
+	return ret;
+}
+
+u8
+megasas_get_map_info(struct megasas_instance *instance)
+{
+	struct fusion_context *fusion = instance->ctrl_context;
+
+	fusion->fast_path_io = 0;
+	if (!megasas_get_ld_map_info(instance)) {
+		if (MR_ValidateMapInfo(fusion->ld_map[(instance->map_id & 1)],
+				       fusion->load_balance_info)) {
+			fusion->fast_path_io = 1;
+			return 0;
+		}
+	}
+	return 1;
+}
+
+/*
+ * megasas_sync_map_info -	Returns FW's ld_map structure
+ * @instance:				Adapter soft state
+ *
+ * Issues an internal command (DCMD) to get the FW's controller PD
+ * list structure.  This information is mainly used to find out SYSTEM
+ * supported by the FW.
+ */
+int
+megasas_sync_map_info(struct megasas_instance *instance)
+{
+	int ret = 0, i;
+	struct megasas_cmd *cmd;
+	struct megasas_dcmd_frame *dcmd;
+	u32 size_sync_info, num_lds;
+	struct fusion_context *fusion;
+	struct MR_LD_TARGET_SYNC *ci = NULL;
+	struct MR_FW_RAID_MAP_ALL *map;
+	struct MR_LD_RAID  *raid;
+	struct MR_LD_TARGET_SYNC *ld_sync;
+	dma_addr_t ci_h = 0;
+	u32 size_map_info;
+
+	cmd = megasas_get_cmd(instance);
+
+	if (!cmd) {
+		printk(KERN_DEBUG "megasas: Failed to get cmd for sync"
+		       "info.\n");
+		return -ENOMEM;
+	}
+
+	fusion = instance->ctrl_context;
+
+	if (!fusion) {
+		megasas_return_cmd(instance, cmd);
+		return 1;
+	}
+
+	map = fusion->ld_map[instance->map_id & 1];
+
+	num_lds = map->raidMap.ldCount;
+
+	dcmd = &cmd->frame->dcmd;
+
+	size_sync_info = sizeof(struct MR_LD_TARGET_SYNC) *num_lds;
+
+	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+	ci = (struct MR_LD_TARGET_SYNC *)
+	  fusion->ld_map[(instance->map_id - 1) & 1];
+	memset(ci, 0, sizeof(struct MR_FW_RAID_MAP_ALL));
+
+	ci_h = fusion->ld_map_phys[(instance->map_id - 1) & 1];
+
+	ld_sync = (struct MR_LD_TARGET_SYNC *)ci;
+
+	for (i = 0; i < num_lds; i++, ld_sync++) {
+		raid = MR_LdRaidGet(i, map);
+		ld_sync->targetId = MR_GetLDTgtId(i, map);
+		ld_sync->seqNum = raid->seqNum;
+	}
+
+	size_map_info = sizeof(struct MR_FW_RAID_MAP) +
+		(sizeof(struct MR_LD_SPAN_MAP) *(MAX_LOGICAL_DRIVES - 1));
+
+	dcmd->cmd = MFI_CMD_DCMD;
+	dcmd->cmd_status = 0xFF;
+	dcmd->sge_count = 1;
+	dcmd->flags = MFI_FRAME_DIR_WRITE;
+	dcmd->timeout = 0;
+	dcmd->pad_0 = 0;
+	dcmd->data_xfer_len = size_map_info;
+	dcmd->mbox.b[0] = num_lds;
+	dcmd->mbox.b[1] = MEGASAS_DCMD_MBOX_PEND_FLAG;
+	dcmd->opcode = MR_DCMD_LD_MAP_GET_INFO;
+	dcmd->sgl.sge32[0].phys_addr = ci_h;
+	dcmd->sgl.sge32[0].length = size_map_info;
+
+	instance->map_update_cmd = cmd;
+
+	instance->instancet->issue_dcmd(instance, cmd);
+
+	return ret;
+}
+
+/**
+ * megasas_init_adapter_fusion -	Initializes the FW
+ * @instance:		Adapter soft state
+ *
+ * This is the main function for initializing firmware.
+ */
+u32
+megasas_init_adapter_fusion(struct megasas_instance *instance)
+{
+	struct megasas_register_set __iomem *reg_set;
+	struct fusion_context *fusion;
+	u32 max_cmd;
+	int i = 0;
+
+	fusion = instance->ctrl_context;
+
+	reg_set = instance->reg_set;
+
+	/*
+	 * Get various operational parameters from status register
+	 */
+	instance->max_fw_cmds =
+		instance->instancet->read_fw_status_reg(reg_set) & 0x00FFFF;
+	instance->max_fw_cmds = min(instance->max_fw_cmds, (u16)1008);
+
+	/*
+	 * Reduce the max supported cmds by 1. This is to ensure that the
+	 * reply_q_sz (1 more than the max cmd that driver may send)
+	 * does not exceed max cmds that the FW can support
+	 */
+	instance->max_fw_cmds = instance->max_fw_cmds-1;
+	/* Only internal cmds (DCMD) need to have MFI frames */
+	instance->max_mfi_cmds = MEGASAS_INT_CMDS;
+
+	max_cmd = instance->max_fw_cmds;
+
+	fusion->reply_q_depth = ((max_cmd + 1 + 15)/16)*16;
+
+	fusion->request_alloc_sz =
+		sizeof(union MEGASAS_REQUEST_DESCRIPTOR_UNION) *max_cmd;
+	fusion->reply_alloc_sz = sizeof(union MPI2_REPLY_DESCRIPTORS_UNION)
+		*(fusion->reply_q_depth);
+	fusion->io_frames_alloc_sz = MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE +
+		(MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE *
+		 (max_cmd + 1)); /* Extra 1 for SMID 0 */
+
+	fusion->max_sge_in_main_msg =
+	  (MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE -
+	   offsetof(struct MPI2_RAID_SCSI_IO_REQUEST, SGL))/16;
+
+	fusion->max_sge_in_chain =
+		MEGASAS_MAX_SZ_CHAIN_FRAME / sizeof(union MPI2_SGE_IO_UNION);
+
+	instance->max_num_sge = fusion->max_sge_in_main_msg +
+		fusion->max_sge_in_chain - 2;
+
+	/* Used for pass thru MFI frame (DCMD) */
+	fusion->chain_offset_mfi_pthru =
+		offsetof(struct MPI2_RAID_SCSI_IO_REQUEST, SGL)/16;
+
+	fusion->chain_offset_io_request =
+		(MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE -
+		 sizeof(union MPI2_SGE_IO_UNION))/16;
+
+	fusion->last_reply_idx = 0;
+
+	/*
+	 * Allocate memory for descriptors
+	 * Create a pool of commands
+	 */
+	if (megasas_alloc_cmds(instance))
+		goto fail_alloc_mfi_cmds;
+	if (megasas_alloc_cmds_fusion(instance))
+		goto fail_alloc_cmds;
+
+	if (megasas_ioc_init_fusion(instance))
+		goto fail_ioc_init;
+
+	instance->flag_ieee = 1;
+
+	fusion->map_sz =  sizeof(struct MR_FW_RAID_MAP) +
+	  (sizeof(struct MR_LD_SPAN_MAP) *(MAX_LOGICAL_DRIVES - 1));
+
+	fusion->fast_path_io = 0;
+
+	for (i = 0; i < 2; i++) {
+		fusion->ld_map[i] = dma_alloc_coherent(&instance->pdev->dev,
+						       fusion->map_sz,
+						       &fusion->ld_map_phys[i],
+						       GFP_KERNEL);
+		if (!fusion->ld_map[i]) {
+			printk(KERN_ERR "megasas: Could not allocate memory "
+			       "for map info\n");
+			goto fail_map_info;
+		}
+	}
+
+	if (!megasas_get_map_info(instance))
+		megasas_sync_map_info(instance);
+
+	return 0;
+
+fail_alloc_cmds:
+fail_alloc_mfi_cmds:
+fail_map_info:
+	if (i == 1)
+		dma_free_coherent(&instance->pdev->dev, fusion->map_sz,
+				  fusion->ld_map[0], fusion->ld_map_phys[0]);
+fail_ioc_init:
+	return 1;
+}
+
+/**
+ * megasas_fire_cmd_fusion -	Sends command to the FW
+ * @frame_phys_addr :		Physical address of cmd
+ * @frame_count :		Number of frames for the command
+ * @regs :			MFI register set
+ */
+void
+megasas_fire_cmd_fusion(struct megasas_instance *instance,
+			dma_addr_t req_desc_lo,
+			u32 req_desc_hi,
+			struct megasas_register_set __iomem *regs)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&instance->hba_lock, flags);
+
+	writel(req_desc_lo,
+	       &(regs)->inbound_low_queue_port);
+	writel(req_desc_hi, &(regs)->inbound_high_queue_port);
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
+}
+
+/**
+ * map_cmd_status -	Maps FW cmd status to OS cmd status
+ * @cmd :		Pointer to cmd
+ * @status :		status of cmd returned by FW
+ * @ext_status :	ext status of cmd returned by FW
+ */
+
+void
+map_cmd_status(struct megasas_cmd_fusion *cmd, u8 status, u8 ext_status)
+{
+
+	switch (status) {
+
+	case MFI_STAT_OK:
+		cmd->scmd->result = DID_OK << 16;
+		break;
+
+	case MFI_STAT_SCSI_IO_FAILED:
+	case MFI_STAT_LD_INIT_IN_PROGRESS:
+		cmd->scmd->result = (DID_ERROR << 16) | ext_status;
+		break;
+
+	case MFI_STAT_SCSI_DONE_WITH_ERROR:
+
+		cmd->scmd->result = (DID_OK << 16) | ext_status;
+		if (ext_status == SAM_STAT_CHECK_CONDITION) {
+			memset(cmd->scmd->sense_buffer, 0,
+			       SCSI_SENSE_BUFFERSIZE);
+			memcpy(cmd->scmd->sense_buffer, cmd->sense,
+			       SCSI_SENSE_BUFFERSIZE);
+			cmd->scmd->result |= DRIVER_SENSE << 24;
+		}
+		break;
+
+	case MFI_STAT_LD_OFFLINE:
+	case MFI_STAT_DEVICE_NOT_FOUND:
+		cmd->scmd->result = DID_BAD_TARGET << 16;
+		break;
+
+	default:
+		printk(KERN_DEBUG "megasas: FW status %#x\n", status);
+		cmd->scmd->result = DID_ERROR << 16;
+		break;
+	}
+}
+
+/**
+ * megasas_make_sgl_fusion -	Prepares 32-bit SGL
+ * @instance:		Adapter soft state
+ * @scp:		SCSI command from the mid-layer
+ * @sgl_ptr:		SGL to be filled in
+ * @cmd:		cmd we are working on
+ *
+ * If successful, this function returns the number of SG elements.
+ */
+static int
+megasas_make_sgl_fusion(struct megasas_instance *instance,
+			struct scsi_cmnd *scp,
+			struct MPI25_IEEE_SGE_CHAIN64 *sgl_ptr,
+			struct megasas_cmd_fusion *cmd)
+{
+	int i, sg_processed;
+	int sge_count, sge_idx;
+	struct scatterlist *os_sgl;
+	struct fusion_context *fusion;
+
+	fusion = instance->ctrl_context;
+
+	cmd->io_request->ChainOffset = 0;
+
+	sge_count = scsi_dma_map(scp);
+
+	BUG_ON(sge_count < 0);
+
+	if (sge_count > instance->max_num_sge || !sge_count)
+		return sge_count;
+
+	if (sge_count > fusion->max_sge_in_main_msg) {
+		/* One element to store the chain info */
+		sge_idx = fusion->max_sge_in_main_msg - 1;
+	} else
+		sge_idx = sge_count;
+
+	scsi_for_each_sg(scp, os_sgl, sge_count, i) {
+		sgl_ptr->Length = sg_dma_len(os_sgl);
+		sgl_ptr->Address = sg_dma_address(os_sgl);
+		sgl_ptr->Flags = 0;
+		sgl_ptr++;
+
+		sg_processed = i + 1;
+
+		if ((sg_processed ==  (fusion->max_sge_in_main_msg - 1)) &&
+		    (sge_count > fusion->max_sge_in_main_msg)) {
+
+			struct MPI25_IEEE_SGE_CHAIN64 *sg_chain;
+			cmd->io_request->ChainOffset =
+				fusion->chain_offset_io_request;
+			sg_chain = sgl_ptr;
+			/* Prepare chain element */
+			sg_chain->NextChainOffset = 0;
+			sg_chain->Flags = (IEEE_SGE_FLAGS_CHAIN_ELEMENT |
+					   MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR);
+			sg_chain->Length =  (sizeof(union MPI2_SGE_IO_UNION)
+					     *(sge_count - sg_processed));
+			sg_chain->Address = cmd->sg_frame_phys_addr;
+
+			sgl_ptr =
+			  (struct MPI25_IEEE_SGE_CHAIN64 *)cmd->sg_frame;
+		}
+	}
+
+	return sge_count;
+}
+
+/**
+ * megasas_set_pd_lba -	Sets PD LBA
+ * @cdb:		CDB
+ * @cdb_len:		cdb length
+ * @start_blk:		Start block of IO
+ *
+ * Used to set the PD LBA in CDB for FP IOs
+ */
+void
+megasas_set_pd_lba(struct MPI2_RAID_SCSI_IO_REQUEST *io_request, u8 cdb_len,
+		   struct IO_REQUEST_INFO *io_info, struct scsi_cmnd *scp,
+		   struct MR_FW_RAID_MAP_ALL *local_map_ptr, u32 ref_tag)
+{
+	struct MR_LD_RAID *raid;
+	u32 ld;
+	u64 start_blk = io_info->pdBlock;
+	u8 *cdb = io_request->CDB.CDB32;
+	u32 num_blocks = io_info->numBlocks;
+	u8 opcode, flagvals, groupnum, control;
+
+	/* Check if T10 PI (DIF) is enabled for this LD */
+	ld = MR_TargetIdToLdGet(io_info->ldTgtId, local_map_ptr);
+	raid = MR_LdRaidGet(ld, local_map_ptr);
+	if (raid->capability.ldPiMode == MR_PROT_INFO_TYPE_CONTROLLER) {
+		memset(cdb, 0, sizeof(io_request->CDB.CDB32));
+		cdb[0] =  MEGASAS_SCSI_VARIABLE_LENGTH_CMD;
+		cdb[7] =  MEGASAS_SCSI_ADDL_CDB_LEN;
+
+		if (scp->sc_data_direction == PCI_DMA_FROMDEVICE)
+			cdb[9] = MEGASAS_SCSI_SERVICE_ACTION_READ32;
+		else
+			cdb[9] = MEGASAS_SCSI_SERVICE_ACTION_WRITE32;
+		cdb[10] = MEGASAS_RD_WR_PROTECT_CHECK_ALL;
+
+		/* LBA */
+		cdb[12] = (u8)((start_blk >> 56) & 0xff);
+		cdb[13] = (u8)((start_blk >> 48) & 0xff);
+		cdb[14] = (u8)((start_blk >> 40) & 0xff);
+		cdb[15] = (u8)((start_blk >> 32) & 0xff);
+		cdb[16] = (u8)((start_blk >> 24) & 0xff);
+		cdb[17] = (u8)((start_blk >> 16) & 0xff);
+		cdb[18] = (u8)((start_blk >> 8) & 0xff);
+		cdb[19] = (u8)(start_blk & 0xff);
+
+		/* Logical block reference tag */
+		io_request->CDB.EEDP32.PrimaryReferenceTag =
+			cpu_to_be32(ref_tag);
+		io_request->CDB.EEDP32.PrimaryApplicationTagMask = 0xffff;
+
+		io_request->DataLength = num_blocks * 512;
+		io_request->IoFlags = 32; /* Specify 32-byte cdb */
+
+		/* Transfer length */
+		cdb[28] = (u8)((num_blocks >> 24) & 0xff);
+		cdb[29] = (u8)((num_blocks >> 16) & 0xff);
+		cdb[30] = (u8)((num_blocks >> 8) & 0xff);
+		cdb[31] = (u8)(num_blocks & 0xff);
+
+		/* set SCSI IO EEDPFlags */
+		if (scp->sc_data_direction == PCI_DMA_FROMDEVICE) {
+			io_request->EEDPFlags =
+				MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG  |
+				MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
+				MPI2_SCSIIO_EEDPFLAGS_CHECK_REMOVE_OP |
+				MPI2_SCSIIO_EEDPFLAGS_CHECK_APPTAG |
+				MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
+		} else {
+			io_request->EEDPFlags =
+				MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG |
+				MPI2_SCSIIO_EEDPFLAGS_INSERT_OP;
+		}
+		io_request->Control |= (0x4 << 26);
+		io_request->EEDPBlockSize = MEGASAS_EEDPBLOCKSIZE;
+	} else {
+		/* Some drives don't support 16/12 byte CDB's, convert to 10 */
+		if (((cdb_len == 12) || (cdb_len == 16)) &&
+		    (start_blk <= 0xffffffff)) {
+			if (cdb_len == 16) {
+				opcode = cdb[0] == READ_16 ? READ_10 : WRITE_10;
+				flagvals = cdb[1];
+				groupnum = cdb[14];
+				control = cdb[15];
+			} else {
+				opcode = cdb[0] == READ_12 ? READ_10 : WRITE_10;
+				flagvals = cdb[1];
+				groupnum = cdb[10];
+				control = cdb[11];
+			}
+
+			memset(cdb, 0, sizeof(io_request->CDB.CDB32));
+
+			cdb[0] = opcode;
+			cdb[1] = flagvals;
+			cdb[6] = groupnum;
+			cdb[9] = control;
+
+			/* Transfer length */
+			cdb[8] = (u8)(num_blocks & 0xff);
+			cdb[7] = (u8)((num_blocks >> 8) & 0xff);
+
+			cdb_len = 10;
+		}
+
+		/* Normal case, just load LBA here */
+		switch (cdb_len) {
+		case 6:
+		{
+			u8 val = cdb[1] & 0xE0;
+			cdb[3] = (u8)(start_blk & 0xff);
+			cdb[2] = (u8)((start_blk >> 8) & 0xff);
+			cdb[1] = val | ((u8)(start_blk >> 16) & 0x1f);
+			break;
+		}
+		case 10:
+			cdb[5] = (u8)(start_blk & 0xff);
+			cdb[4] = (u8)((start_blk >> 8) & 0xff);
+			cdb[3] = (u8)((start_blk >> 16) & 0xff);
+			cdb[2] = (u8)((start_blk >> 24) & 0xff);
+			break;
+		case 12:
+			cdb[5]    = (u8)(start_blk & 0xff);
+			cdb[4]    = (u8)((start_blk >> 8) & 0xff);
+			cdb[3]    = (u8)((start_blk >> 16) & 0xff);
+			cdb[2]    = (u8)((start_blk >> 24) & 0xff);
+			break;
+		case 16:
+			cdb[9]    = (u8)(start_blk & 0xff);
+			cdb[8]    = (u8)((start_blk >> 8) & 0xff);
+			cdb[7]    = (u8)((start_blk >> 16) & 0xff);
+			cdb[6]    = (u8)((start_blk >> 24) & 0xff);
+			cdb[5]    = (u8)((start_blk >> 32) & 0xff);
+			cdb[4]    = (u8)((start_blk >> 40) & 0xff);
+			cdb[3]    = (u8)((start_blk >> 48) & 0xff);
+			cdb[2]    = (u8)((start_blk >> 56) & 0xff);
+			break;
+		}
+	}
+}
+
+/**
+ * megasas_build_ldio_fusion -	Prepares IOs to devices
+ * @instance:		Adapter soft state
+ * @scp:		SCSI command
+ * @cmd:		Command to be prepared
+ *
+ * Prepares the io_request and chain elements (sg_frame) for IO
+ * The IO can be for PD (Fast Path) or LD
+ */
+void
+megasas_build_ldio_fusion(struct megasas_instance *instance,
+			  struct scsi_cmnd *scp,
+			  struct megasas_cmd_fusion *cmd)
+{
+	u8 fp_possible;
+	u32 start_lba_lo, start_lba_hi, device_id;
+	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	struct IO_REQUEST_INFO io_info;
+	struct fusion_context *fusion;
+	struct MR_FW_RAID_MAP_ALL *local_map_ptr;
+
+	device_id = MEGASAS_DEV_INDEX(instance, scp);
+
+	fusion = instance->ctrl_context;
+
+	io_request = cmd->io_request;
+	io_request->RaidContext.VirtualDiskTgtId = device_id;
+	io_request->RaidContext.status = 0;
+	io_request->RaidContext.exStatus = 0;
+
+	req_desc = (union MEGASAS_REQUEST_DESCRIPTOR_UNION *)cmd->request_desc;
+
+	start_lba_lo = 0;
+	start_lba_hi = 0;
+	fp_possible = 0;
+
+	/*
+	 * 6-byte READ(0x08) or WRITE(0x0A) cdb
+	 */
+	if (scp->cmd_len == 6) {
+		io_request->DataLength = (u32) scp->cmnd[4];
+		start_lba_lo = ((u32) scp->cmnd[1] << 16) |
+			((u32) scp->cmnd[2] << 8) | (u32) scp->cmnd[3];
+
+		start_lba_lo &= 0x1FFFFF;
+	}
+
+	/*
+	 * 10-byte READ(0x28) or WRITE(0x2A) cdb
+	 */
+	else if (scp->cmd_len == 10) {
+		io_request->DataLength = (u32) scp->cmnd[8] |
+			((u32) scp->cmnd[7] << 8);
+		start_lba_lo = ((u32) scp->cmnd[2] << 24) |
+			((u32) scp->cmnd[3] << 16) |
+			((u32) scp->cmnd[4] << 8) | (u32) scp->cmnd[5];
+	}
+
+	/*
+	 * 12-byte READ(0xA8) or WRITE(0xAA) cdb
+	 */
+	else if (scp->cmd_len == 12) {
+		io_request->DataLength = ((u32) scp->cmnd[6] << 24) |
+			((u32) scp->cmnd[7] << 16) |
+			((u32) scp->cmnd[8] << 8) | (u32) scp->cmnd[9];
+		start_lba_lo = ((u32) scp->cmnd[2] << 24) |
+			((u32) scp->cmnd[3] << 16) |
+			((u32) scp->cmnd[4] << 8) | (u32) scp->cmnd[5];
+	}
+
+	/*
+	 * 16-byte READ(0x88) or WRITE(0x8A) cdb
+	 */
+	else if (scp->cmd_len == 16) {
+		io_request->DataLength = ((u32) scp->cmnd[10] << 24) |
+			((u32) scp->cmnd[11] << 16) |
+			((u32) scp->cmnd[12] << 8) | (u32) scp->cmnd[13];
+		start_lba_lo = ((u32) scp->cmnd[6] << 24) |
+			((u32) scp->cmnd[7] << 16) |
+			((u32) scp->cmnd[8] << 8) | (u32) scp->cmnd[9];
+
+		start_lba_hi = ((u32) scp->cmnd[2] << 24) |
+			((u32) scp->cmnd[3] << 16) |
+			((u32) scp->cmnd[4] << 8) | (u32) scp->cmnd[5];
+	}
+
+	memset(&io_info, 0, sizeof(struct IO_REQUEST_INFO));
+	io_info.ldStartBlock = ((u64)start_lba_hi << 32) | start_lba_lo;
+	io_info.numBlocks = io_request->DataLength;
+	io_info.ldTgtId = device_id;
+
+	if (scp->sc_data_direction == PCI_DMA_FROMDEVICE)
+		io_info.isRead = 1;
+
+	local_map_ptr = fusion->ld_map[(instance->map_id & 1)];
+
+	if ((MR_TargetIdToLdGet(device_id, local_map_ptr) >=
+	     MAX_LOGICAL_DRIVES) || (!fusion->fast_path_io)) {
+		io_request->RaidContext.regLockFlags  = 0;
+		fp_possible = 0;
+	} else {
+		if (MR_BuildRaidContext(&io_info, &io_request->RaidContext,
+					local_map_ptr))
+			fp_possible = io_info.fpOkForIo;
+	}
+
+	if (fp_possible) {
+		megasas_set_pd_lba(io_request, scp->cmd_len, &io_info, scp,
+				   local_map_ptr, start_lba_lo);
+		io_request->DataLength = scsi_bufflen(scp);
+		io_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
+		cmd->request_desc->SCSIIO.RequestFlags =
+			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY
+			 << MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+		if ((fusion->load_balance_info[device_id].loadBalanceFlag) &&
+		    (io_info.isRead)) {
+			io_info.devHandle =
+				get_updated_dev_handle(
+					&fusion->load_balance_info[device_id],
+					&io_info);
+			scp->SCp.Status |= MEGASAS_LOAD_BALANCE_FLAG;
+		} else
+			scp->SCp.Status &= ~MEGASAS_LOAD_BALANCE_FLAG;
+		cmd->request_desc->SCSIIO.DevHandle = io_info.devHandle;
+		io_request->DevHandle = io_info.devHandle;
+	} else {
+		io_request->RaidContext.timeoutValue =
+			local_map_ptr->raidMap.fpPdIoTimeoutSec;
+		io_request->Function = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
+		io_request->DevHandle = device_id;
+		cmd->request_desc->SCSIIO.RequestFlags =
+			(MEGASAS_REQ_DESCRIPT_FLAGS_LD_IO
+			 << MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+	} /* Not FP */
+}
+
+/**
+ * megasas_build_dcdb_fusion -	Prepares IOs to devices
+ * @instance:		Adapter soft state
+ * @scp:		SCSI command
+ * @cmd:		Command to be prepared
+ *
+ * Prepares the io_request frame for non-io cmds
+ */
+static void
+megasas_build_dcdb_fusion(struct megasas_instance *instance,
+			  struct scsi_cmnd *scmd,
+			  struct megasas_cmd_fusion *cmd)
+{
+	u32 device_id;
+	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
+	u16 pd_index = 0;
+	struct MR_FW_RAID_MAP_ALL *local_map_ptr;
+	struct fusion_context *fusion = instance->ctrl_context;
+
+	io_request = cmd->io_request;
+	device_id = MEGASAS_DEV_INDEX(instance, scmd);
+	pd_index = (scmd->device->channel * MEGASAS_MAX_DEV_PER_CHANNEL)
+		+scmd->device->id;
+	local_map_ptr = fusion->ld_map[(instance->map_id & 1)];
+
+	/* Check if this is a system PD I/O */
+	if ((instance->pd_list[pd_index].driveState == MR_PD_STATE_SYSTEM) &&
+	    (instance->pd_list[pd_index].driveType == TYPE_DISK)) {
+		io_request->Function = 0;
+		io_request->DevHandle =
+			local_map_ptr->raidMap.devHndlInfo[device_id].curDevHdl;
+		io_request->RaidContext.timeoutValue =
+			local_map_ptr->raidMap.fpPdIoTimeoutSec;
+		io_request->RaidContext.regLockFlags = 0;
+		io_request->RaidContext.regLockRowLBA = 0;
+		io_request->RaidContext.regLockLength = 0;
+		io_request->RaidContext.RAIDFlags =
+			MR_RAID_FLAGS_IO_SUB_TYPE_SYSTEM_PD <<
+			MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT;
+		cmd->request_desc->SCSIIO.RequestFlags =
+			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY <<
+			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+	} else {
+		io_request->Function  = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
+		io_request->DevHandle = device_id;
+		cmd->request_desc->SCSIIO.RequestFlags =
+			(MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
+			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+	}
+	io_request->RaidContext.VirtualDiskTgtId = device_id;
+	io_request->LUN[0] = scmd->device->lun;
+	io_request->DataLength = scsi_bufflen(scmd);
+}
+
+/**
+ * megasas_build_io_fusion -	Prepares IOs to devices
+ * @instance:		Adapter soft state
+ * @scp:		SCSI command
+ * @cmd:		Command to be prepared
+ *
+ * Invokes helper functions to prepare request frames
+ * and sets flags appropriate for IO/Non-IO cmd
+ */
+int
+megasas_build_io_fusion(struct megasas_instance *instance,
+			struct scsi_cmnd *scp,
+			struct megasas_cmd_fusion *cmd)
+{
+	u32 device_id, sge_count;
+	struct MPI2_RAID_SCSI_IO_REQUEST *io_request = cmd->io_request;
+
+	device_id = MEGASAS_DEV_INDEX(instance, scp);
+
+	/* Zero out some fields so they don't get reused */
+	io_request->LUN[0] = 0;
+	io_request->CDB.EEDP32.PrimaryReferenceTag = 0;
+	io_request->CDB.EEDP32.PrimaryApplicationTagMask = 0;
+	io_request->EEDPFlags = 0;
+	io_request->Control = 0;
+	io_request->EEDPBlockSize = 0;
+	io_request->IoFlags = 0;
+	io_request->RaidContext.RAIDFlags = 0;
+
+	memcpy(io_request->CDB.CDB32, scp->cmnd, scp->cmd_len);
+	/*
+	 * Just the CDB length,rest of the Flags are zero
+	 * This will be modified for FP in build_ldio_fusion
+	 */
+	io_request->IoFlags = scp->cmd_len;
+
+	if (megasas_is_ldio(scp))
+		megasas_build_ldio_fusion(instance, scp, cmd);
+	else
+		megasas_build_dcdb_fusion(instance, scp, cmd);
+
+	/*
+	 * Construct SGL
+	 */
+
+	sge_count =
+		megasas_make_sgl_fusion(instance, scp,
+					(struct MPI25_IEEE_SGE_CHAIN64 *)
+					&io_request->SGL, cmd);
+
+	if (sge_count > instance->max_num_sge) {
+		printk(KERN_ERR "megasas: Error. sge_count (0x%x) exceeds "
+		       "max (0x%x) allowed\n", sge_count,
+		       instance->max_num_sge);
+		return 1;
+	}
+
+	io_request->RaidContext.numSGE = sge_count;
+
+	io_request->SGLFlags = MPI2_SGE_FLAGS_64_BIT_ADDRESSING;
+
+	if (scp->sc_data_direction == PCI_DMA_TODEVICE)
+		io_request->Control |= MPI2_SCSIIO_CONTROL_WRITE;
+	else if (scp->sc_data_direction == PCI_DMA_FROMDEVICE)
+		io_request->Control |= MPI2_SCSIIO_CONTROL_READ;
+
+	io_request->SGLOffset0 =
+		offsetof(struct MPI2_RAID_SCSI_IO_REQUEST, SGL) / 4;
+
+	io_request->SenseBufferLowAddress = cmd->sense_phys_addr;
+	io_request->SenseBufferLength = SCSI_SENSE_BUFFERSIZE;
+
+	cmd->scmd = scp;
+	scp->SCp.ptr = (char *)cmd;
+
+	return 0;
+}
+
+union MEGASAS_REQUEST_DESCRIPTOR_UNION *
+megasas_get_request_descriptor(struct megasas_instance *instance, u16 index)
+{
+	u8 *p;
+	struct fusion_context *fusion;
+
+	if (index >= instance->max_fw_cmds) {
+		printk(KERN_ERR "megasas: Invalid SMID (0x%x)request for "
+		       "descriptor\n", index);
+		return NULL;
+	}
+	fusion = instance->ctrl_context;
+	p = fusion->req_frames_desc
+		+sizeof(union MEGASAS_REQUEST_DESCRIPTOR_UNION) *index;
+
+	return (union MEGASAS_REQUEST_DESCRIPTOR_UNION *)p;
+}
+
+/**
+ * megasas_build_and_issue_cmd_fusion -Main routine for building and
+ *                                     issuing non IOCTL cmd
+ * @instance:			Adapter soft state
+ * @scmd:			pointer to scsi cmd from OS
+ */
+static u32
+megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
+				   struct scsi_cmnd *scmd)
+{
+	struct megasas_cmd_fusion *cmd;
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	u32 index;
+	struct fusion_context *fusion;
+
+	fusion = instance->ctrl_context;
+
+	cmd = megasas_get_cmd_fusion(instance);
+	if (!cmd)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
+	index = cmd->index;
+
+	req_desc = megasas_get_request_descriptor(instance, index-1);
+	if (!req_desc)
+		return 1;
+
+	req_desc->Words = 0;
+	cmd->request_desc = req_desc;
+	cmd->request_desc->Words = 0;
+
+	if (megasas_build_io_fusion(instance, scmd, cmd)) {
+		megasas_return_cmd_fusion(instance, cmd);
+		printk(KERN_ERR "megasas: Error building command.\n");
+		cmd->request_desc = NULL;
+		return 1;
+	}
+
+	req_desc = cmd->request_desc;
+	req_desc->SCSIIO.SMID = index;
+
+	if (cmd->io_request->ChainOffset != 0 &&
+	    cmd->io_request->ChainOffset != 0xF)
+		printk(KERN_ERR "megasas: The chain offset value is not "
+		       "correct : %x\n", cmd->io_request->ChainOffset);
+
+	/*
+	 * Issue the command to the FW
+	 */
+	atomic_inc(&instance->fw_outstanding);
+
+	instance->instancet->fire_cmd(instance,
+				      req_desc->u.low, req_desc->u.high,
+				      instance->reg_set);
+
+	return 0;
+}
+
+/**
+ * complete_cmd_fusion -	Completes command
+ * @instance:			Adapter soft state
+ * Completes all commands that is in reply descriptor queue
+ */
+int
+complete_cmd_fusion(struct megasas_instance *instance)
+{
+	union MPI2_REPLY_DESCRIPTORS_UNION *desc;
+	struct MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR *reply_desc;
+	struct MPI2_RAID_SCSI_IO_REQUEST *scsi_io_req;
+	struct fusion_context *fusion;
+	struct megasas_cmd *cmd_mfi;
+	struct megasas_cmd_fusion *cmd_fusion;
+	u16 smid, num_completed;
+	u8 reply_descript_type, arm;
+	u32 status, extStatus, device_id;
+	union desc_value d_val;
+	struct LD_LOAD_BALANCE_INFO *lbinfo;
+
+	fusion = instance->ctrl_context;
+
+	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR)
+		return IRQ_HANDLED;
+
+	desc = fusion->reply_frames_desc;
+	desc += fusion->last_reply_idx;
+
+	reply_desc = (struct MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR *)desc;
+
+	d_val.word = desc->Words;
+
+	reply_descript_type = reply_desc->ReplyFlags &
+		MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
+
+	if (reply_descript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
+		return IRQ_NONE;
+
+	d_val.word = desc->Words;
+
+	num_completed = 0;
+
+	while ((d_val.u.low != UINT_MAX) && (d_val.u.high != UINT_MAX)) {
+		smid = reply_desc->SMID;
+
+		cmd_fusion = fusion->cmd_list[smid - 1];
+
+		scsi_io_req =
+			(struct MPI2_RAID_SCSI_IO_REQUEST *)
+		  cmd_fusion->io_request;
+
+		if (cmd_fusion->scmd)
+			cmd_fusion->scmd->SCp.ptr = NULL;
+
+		status = scsi_io_req->RaidContext.status;
+		extStatus = scsi_io_req->RaidContext.exStatus;
+
+		switch (scsi_io_req->Function) {
+		case MPI2_FUNCTION_SCSI_IO_REQUEST:  /*Fast Path IO.*/
+			/* Update load balancing info */
+			device_id = MEGASAS_DEV_INDEX(instance,
+						      cmd_fusion->scmd);
+			lbinfo = &fusion->load_balance_info[device_id];
+			if (cmd_fusion->scmd->SCp.Status &
+			    MEGASAS_LOAD_BALANCE_FLAG) {
+				arm = lbinfo->raid1DevHandle[0] ==
+					cmd_fusion->io_request->DevHandle ? 0 :
+					1;
+				atomic_dec(&lbinfo->scsi_pending_cmds[arm]);
+				cmd_fusion->scmd->SCp.Status &=
+					~MEGASAS_LOAD_BALANCE_FLAG;
+			}
+			if (reply_descript_type ==
+			    MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS) {
+				if (megasas_dbg_lvl == 5)
+					printk(KERN_ERR "\nmegasas: FAST Path "
+					       "IO Success\n");
+			}
+			/* Fall thru and complete IO */
+		case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO Path */
+			/* Map the FW Cmd Status */
+			map_cmd_status(cmd_fusion, status, extStatus);
+			scsi_dma_unmap(cmd_fusion->scmd);
+			cmd_fusion->scmd->scsi_done(cmd_fusion->scmd);
+			scsi_io_req->RaidContext.status = 0;
+			scsi_io_req->RaidContext.exStatus = 0;
+			megasas_return_cmd_fusion(instance, cmd_fusion);
+			atomic_dec(&instance->fw_outstanding);
+
+			break;
+		case MEGASAS_MPI2_FUNCTION_PASSTHRU_IO_REQUEST: /*MFI command */
+			cmd_mfi = instance->cmd_list[cmd_fusion->sync_cmd_idx];
+			megasas_complete_cmd(instance, cmd_mfi, DID_OK);
+			cmd_fusion->flags = 0;
+			megasas_return_cmd_fusion(instance, cmd_fusion);
+
+			break;
+		}
+
+		fusion->last_reply_idx++;
+		if (fusion->last_reply_idx >= fusion->reply_q_depth)
+			fusion->last_reply_idx = 0;
+
+		desc->Words = ULLONG_MAX;
+		num_completed++;
+
+		/* Get the next reply descriptor */
+		if (!fusion->last_reply_idx)
+			desc = fusion->reply_frames_desc;
+		else
+			desc++;
+
+		reply_desc =
+		  (struct MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR *)desc;
+
+		d_val.word = desc->Words;
+
+		reply_descript_type = reply_desc->ReplyFlags &
+			MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
+
+		if (reply_descript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
+			break;
+	}
+
+	if (!num_completed)
+		return IRQ_NONE;
+
+	wmb();
+	writel(fusion->last_reply_idx,
+	       &instance->reg_set->reply_post_host_index);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * megasas_complete_cmd_dpc_fusion -	Completes command
+ * @instance:			Adapter soft state
+ *
+ * Tasklet to complete cmds
+ */
+void
+megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
+{
+	struct megasas_instance *instance =
+		(struct megasas_instance *)instance_addr;
+	unsigned long flags;
+
+	/* If we have already declared adapter dead, donot complete cmds */
+	spin_lock_irqsave(&instance->hba_lock, flags);
+	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
+		spin_unlock_irqrestore(&instance->hba_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
+
+	spin_lock_irqsave(&instance->completion_lock, flags);
+	complete_cmd_fusion(instance);
+	spin_unlock_irqrestore(&instance->completion_lock, flags);
+}
+
+/**
+ * megasas_isr_fusion - isr entry point
+ */
+irqreturn_t megasas_isr_fusion(int irq, void *devp)
+{
+	struct megasas_instance *instance = (struct megasas_instance *)devp;
+	u32 mfiStatus, fw_state;
+
+	if (!instance->msi_flag) {
+		mfiStatus = instance->instancet->clear_intr(instance->reg_set);
+		if (!mfiStatus)
+			return IRQ_NONE;
+	}
+
+	/* If we are resetting, bail */
+	if (test_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags))
+		return IRQ_HANDLED;
+
+	if (!complete_cmd_fusion(instance)) {
+		/* If we didn't complete any commands, check for FW fault */
+		fw_state = instance->instancet->read_fw_status_reg(
+			instance->reg_set) & MFI_STATE_MASK;
+		if (fw_state == MFI_STATE_FAULT)
+			schedule_work(&instance->work_init);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * build_mpt_mfi_pass_thru - builds a cmd fo MFI Pass thru
+ * @instance:			Adapter soft state
+ * mfi_cmd:			megasas_cmd pointer
+ *
+ */
+u8
+build_mpt_mfi_pass_thru(struct megasas_instance *instance,
+			struct megasas_cmd *mfi_cmd)
+{
+	struct MPI25_IEEE_SGE_CHAIN64 *mpi25_ieee_chain;
+	struct MPI2_RAID_SCSI_IO_REQUEST *io_req;
+	struct megasas_cmd_fusion *cmd;
+	struct fusion_context *fusion;
+	struct megasas_header *frame_hdr = &mfi_cmd->frame->hdr;
+
+	cmd = megasas_get_cmd_fusion(instance);
+	if (!cmd)
+		return 1;
+
+	/*  Save the smid. To be used for returning the cmd */
+	mfi_cmd->context.smid = cmd->index;
+
+	cmd->sync_cmd_idx = mfi_cmd->index;
+
+	/*
+	 * For cmds where the flag is set, store the flag and check
+	 * on completion. For cmds with this flag, don't call
+	 * megasas_complete_cmd
+	 */
+
+	if (frame_hdr->flags & MFI_FRAME_DONT_POST_IN_REPLY_QUEUE)
+		cmd->flags = MFI_FRAME_DONT_POST_IN_REPLY_QUEUE;
+
+	fusion = instance->ctrl_context;
+	io_req = cmd->io_request;
+	mpi25_ieee_chain =
+	  (struct MPI25_IEEE_SGE_CHAIN64 *)&io_req->SGL.IeeeChain;
+
+	io_req->Function    = MEGASAS_MPI2_FUNCTION_PASSTHRU_IO_REQUEST;
+	io_req->SGLOffset0  = offsetof(struct MPI2_RAID_SCSI_IO_REQUEST,
+				       SGL) / 4;
+	io_req->ChainOffset = fusion->chain_offset_mfi_pthru;
+
+	mpi25_ieee_chain->Address = mfi_cmd->frame_phys_addr;
+
+	mpi25_ieee_chain->Flags = IEEE_SGE_FLAGS_CHAIN_ELEMENT |
+		MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR;
+
+	mpi25_ieee_chain->Length = MEGASAS_MAX_SZ_CHAIN_FRAME;
+
+	return 0;
+}
+
+/**
+ * build_mpt_cmd - Calls helper function to build a cmd MFI Pass thru cmd
+ * @instance:			Adapter soft state
+ * @cmd:			mfi cmd to build
+ *
+ */
+union MEGASAS_REQUEST_DESCRIPTOR_UNION *
+build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
+{
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	u16 index;
+
+	if (build_mpt_mfi_pass_thru(instance, cmd)) {
+		printk(KERN_ERR "Couldn't build MFI pass thru cmd\n");
+		return NULL;
+	}
+
+	index = cmd->context.smid;
+
+	req_desc = megasas_get_request_descriptor(instance, index - 1);
+
+	if (!req_desc)
+		return NULL;
+
+	req_desc->Words = 0;
+	req_desc->SCSIIO.RequestFlags = (MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
+					 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+
+	req_desc->SCSIIO.SMID = index;
+
+	return req_desc;
+}
+
+/**
+ * megasas_issue_dcmd_fusion - Issues a MFI Pass thru cmd
+ * @instance:			Adapter soft state
+ * @cmd:			mfi cmd pointer
+ *
+ */
+void
+megasas_issue_dcmd_fusion(struct megasas_instance *instance,
+			  struct megasas_cmd *cmd)
+{
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	union desc_value d_val;
+
+	req_desc = build_mpt_cmd(instance, cmd);
+	if (!req_desc) {
+		printk(KERN_ERR "Couldn't issue MFI pass thru cmd\n");
+		return;
+	}
+	d_val.word = req_desc->Words;
+
+	instance->instancet->fire_cmd(instance, req_desc->u.low,
+				      req_desc->u.high, instance->reg_set);
+}
+
+/**
+ * megasas_release_fusion -	Reverses the FW initialization
+ * @intance:			Adapter soft state
+ */
+void
+megasas_release_fusion(struct megasas_instance *instance)
+{
+	megasas_free_cmds(instance);
+	megasas_free_cmds_fusion(instance);
+
+	iounmap(instance->reg_set);
+
+	pci_release_selected_regions(instance->pdev, instance->bar);
+}
+
+/**
+ * megasas_read_fw_status_reg_fusion - returns the current FW status value
+ * @regs:			MFI register set
+ */
+static u32
+megasas_read_fw_status_reg_fusion(struct megasas_register_set __iomem *regs)
+{
+	return readl(&(regs)->outbound_scratch_pad);
+}
+
+/**
+ * megasas_adp_reset_fusion -	For controller reset
+ * @regs:				MFI register set
+ */
+static int
+megasas_adp_reset_fusion(struct megasas_instance *instance,
+			 struct megasas_register_set __iomem *regs)
+{
+	return 0;
+}
+
+/**
+ * megasas_check_reset_fusion -	For controller reset check
+ * @regs:				MFI register set
+ */
+static int
+megasas_check_reset_fusion(struct megasas_instance *instance,
+			   struct megasas_register_set __iomem *regs)
+{
+	return 0;
+}
+
+/* This function waits for outstanding commands on fusion to complete */
+int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance)
+{
+	int i, outstanding, retval = 0;
+	u32 fw_state, wait_time = MEGASAS_RESET_WAIT_TIME;
+
+	for (i = 0; i < wait_time; i++) {
+		/* Check if firmware is in fault state */
+		fw_state = instance->instancet->read_fw_status_reg(
+			instance->reg_set) & MFI_STATE_MASK;
+		if (fw_state == MFI_STATE_FAULT) {
+			printk(KERN_WARNING "megasas: Found FW in FAULT state,"
+			       " will reset adapter.\n");
+			retval = 1;
+			goto out;
+		}
+
+		outstanding = atomic_read(&instance->fw_outstanding);
+		if (!outstanding)
+			goto out;
+
+		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
+			printk(KERN_NOTICE "megasas: [%2d]waiting for %d "
+			       "commands to complete\n", i, outstanding);
+			megasas_complete_cmd_dpc_fusion(
+				(unsigned long)instance);
+		}
+		msleep(1000);
+	}
+
+	if (atomic_read(&instance->fw_outstanding)) {
+		printk("megaraid_sas: pending commands remain after waiting, "
+		       "will reset adapter.\n");
+		retval = 1;
+	}
+out:
+	return retval;
+}
+
+void  megasas_reset_reply_desc(struct megasas_instance *instance)
+{
+	int i;
+	struct fusion_context *fusion;
+	union MPI2_REPLY_DESCRIPTORS_UNION *reply_desc;
+
+	fusion = instance->ctrl_context;
+	fusion->last_reply_idx = 0;
+	reply_desc = fusion->reply_frames_desc;
+	for (i = 0 ; i < fusion->reply_q_depth; i++, reply_desc++)
+		reply_desc->Words = ULLONG_MAX;
+}
+
+/* Core fusion reset function */
+int megasas_reset_fusion(struct scsi_cmnd *scmd)
+{
+	int retval = SUCCESS, i, j, retry = 0;
+	struct megasas_instance *instance;
+	struct megasas_cmd_fusion *cmd_fusion;
+	struct fusion_context *fusion;
+	struct megasas_cmd *cmd_mfi;
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	u32 host_diag, abs_state;
+
+	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+	fusion = instance->ctrl_context;
+
+	mutex_lock(&instance->reset_mutex);
+	set_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	instance->adprecovery = MEGASAS_ADPRESET_SM_INFAULT;
+	instance->instancet->disable_intr(instance->reg_set);
+	msleep(1000);
+
+	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
+		printk(KERN_WARNING "megaraid_sas: Hardware critical error, "
+		       "returning FAILED.\n");
+		retval = FAILED;
+		goto out;
+	}
+
+	/* First try waiting for commands to complete */
+	if (megasas_wait_for_outstanding_fusion(instance)) {
+		printk(KERN_WARNING "megaraid_sas: resetting fusion "
+		       "adapter.\n");
+		/* Now return commands back to the OS */
+		for (i = 0 ; i < instance->max_fw_cmds; i++) {
+			cmd_fusion = fusion->cmd_list[i];
+			if (cmd_fusion->scmd) {
+				scsi_dma_unmap(cmd_fusion->scmd);
+				cmd_fusion->scmd->result = (DID_RESET << 16);
+				cmd_fusion->scmd->scsi_done(cmd_fusion->scmd);
+				megasas_return_cmd_fusion(instance, cmd_fusion);
+				atomic_dec(&instance->fw_outstanding);
+			}
+		}
+
+		if (instance->disableOnlineCtrlReset == 1) {
+			/* Reset not supported, kill adapter */
+			printk(KERN_WARNING "megaraid_sas: Reset not supported"
+			       ", killing adapter.\n");
+			megaraid_sas_kill_hba(instance);
+			instance->adprecovery = MEGASAS_HW_CRITICAL_ERROR;
+			retval = FAILED;
+			goto out;
+		}
+
+		/* Now try to reset the chip */
+		for (i = 0; i < MEGASAS_FUSION_MAX_RESET_TRIES; i++) {
+			writel(MPI2_WRSEQ_FLUSH_KEY_VALUE,
+			       &instance->reg_set->fusion_seq_offset);
+			writel(MPI2_WRSEQ_1ST_KEY_VALUE,
+			       &instance->reg_set->fusion_seq_offset);
+			writel(MPI2_WRSEQ_2ND_KEY_VALUE,
+			       &instance->reg_set->fusion_seq_offset);
+			writel(MPI2_WRSEQ_3RD_KEY_VALUE,
+			       &instance->reg_set->fusion_seq_offset);
+			writel(MPI2_WRSEQ_4TH_KEY_VALUE,
+			       &instance->reg_set->fusion_seq_offset);
+			writel(MPI2_WRSEQ_5TH_KEY_VALUE,
+			       &instance->reg_set->fusion_seq_offset);
+			writel(MPI2_WRSEQ_6TH_KEY_VALUE,
+			       &instance->reg_set->fusion_seq_offset);
+
+			/* Check that the diag write enable (DRWE) bit is on */
+			host_diag = readl(&instance->reg_set->fusion_host_diag);
+			while (!(host_diag & HOST_DIAG_WRITE_ENABLE)) {
+				msleep(100);
+				host_diag =
+				readl(&instance->reg_set->fusion_host_diag);
+				if (retry++ == 100) {
+					printk(KERN_WARNING "megaraid_sas: "
+					       "Host diag unlock failed!\n");
+					break;
+				}
+			}
+			if (!(host_diag & HOST_DIAG_WRITE_ENABLE))
+				continue;
+
+			/* Send chip reset command */
+			writel(host_diag | HOST_DIAG_RESET_ADAPTER,
+			       &instance->reg_set->fusion_host_diag);
+			msleep(3000);
+
+			/* Make sure reset adapter bit is cleared */
+			host_diag = readl(&instance->reg_set->fusion_host_diag);
+			retry = 0;
+			while (host_diag & HOST_DIAG_RESET_ADAPTER) {
+				msleep(100);
+				host_diag =
+				readl(&instance->reg_set->fusion_host_diag);
+				if (retry++ == 1000) {
+					printk(KERN_WARNING "megaraid_sas: "
+					       "Diag reset adapter never "
+					       "cleared!\n");
+					break;
+				}
+			}
+			if (host_diag & HOST_DIAG_RESET_ADAPTER)
+				continue;
+
+			abs_state =
+				instance->instancet->read_fw_status_reg(
+					instance->reg_set);
+			retry = 0;
+
+			while ((abs_state <= MFI_STATE_FW_INIT) &&
+			       (retry++ < 1000)) {
+				msleep(100);
+				abs_state =
+				instance->instancet->read_fw_status_reg(
+					instance->reg_set);
+			}
+			if (abs_state <= MFI_STATE_FW_INIT) {
+				printk(KERN_WARNING "megaraid_sas: firmware "
+				       "state < MFI_STATE_FW_INIT, state = "
+				       "0x%x\n", abs_state);
+				continue;
+			}
+
+			/* Wait for FW to become ready */
+			if (megasas_transition_to_ready(instance)) {
+				printk(KERN_WARNING "megaraid_sas: Failed to "
+				       "transition controller to ready.\n");
+				continue;
+			}
+
+			megasas_reset_reply_desc(instance);
+			if (megasas_ioc_init_fusion(instance)) {
+				printk(KERN_WARNING "megaraid_sas: "
+				       "megasas_ioc_init_fusion() failed!\n");
+				continue;
+			}
+
+			instance->instancet->enable_intr(instance->reg_set);
+			instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
+
+			/* Re-fire management commands */
+			for (j = 0 ; j < instance->max_fw_cmds; j++) {
+				cmd_fusion = fusion->cmd_list[j];
+				if (cmd_fusion->sync_cmd_idx !=
+				    (u32)ULONG_MAX) {
+					cmd_mfi =
+					instance->
+					cmd_list[cmd_fusion->sync_cmd_idx];
+					if (cmd_mfi->frame->dcmd.opcode ==
+					    MR_DCMD_LD_MAP_GET_INFO) {
+						megasas_return_cmd(instance,
+								   cmd_mfi);
+						megasas_return_cmd_fusion(
+							instance, cmd_fusion);
+					} else  {
+						req_desc =
+						megasas_get_request_descriptor(
+							instance,
+							cmd_mfi->context.smid
+							-1);
+						if (!req_desc)
+							printk(KERN_WARNING
+							       "req_desc NULL"
+							       "\n");
+						else {
+							instance->instancet->
+							fire_cmd(instance,
+								 req_desc->
+								 u.low,
+								 req_desc->
+								 u.high,
+								 instance->
+								 reg_set);
+						}
+					}
+				}
+			}
+
+			/* Reset load balance info */
+			memset(fusion->load_balance_info, 0,
+			       sizeof(struct LD_LOAD_BALANCE_INFO)
+			       *MAX_LOGICAL_DRIVES);
+
+			if (!megasas_get_map_info(instance))
+				megasas_sync_map_info(instance);
+
+			/* Adapter reset completed successfully */
+			printk(KERN_WARNING "megaraid_sas: Reset "
+			       "successful.\n");
+			retval = SUCCESS;
+			goto out;
+		}
+		/* Reset failed, kill the adapter */
+		printk(KERN_WARNING "megaraid_sas: Reset failed, killing "
+		       "adapter.\n");
+		megaraid_sas_kill_hba(instance);
+		retval = FAILED;
+	} else {
+		instance->instancet->enable_intr(instance->reg_set);
+		instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
+	}
+out:
+	clear_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	mutex_unlock(&instance->reset_mutex);
+	return retval;
+}
+
+/* Fusion OCR work queue */
+void megasas_fusion_ocr_wq(struct work_struct *work)
+{
+	struct megasas_instance *instance =
+		container_of(work, struct megasas_instance, work_init);
+
+	instance->scmd.device = &instance->dev;
+	instance->dev.host = instance->host;
+	megasas_reset_fusion(&instance->scmd);
+}
+
+struct megasas_instance_template megasas_instance_template_fusion = {
+	.fire_cmd = megasas_fire_cmd_fusion,
+	.enable_intr = megasas_enable_intr_fusion,
+	.disable_intr = megasas_disable_intr_fusion,
+	.clear_intr = megasas_clear_intr_fusion,
+	.read_fw_status_reg = megasas_read_fw_status_reg_fusion,
+	.adp_reset = megasas_adp_reset_fusion,
+	.check_reset = megasas_check_reset_fusion,
+	.service_isr = megasas_isr_fusion,
+	.tasklet = megasas_complete_cmd_dpc_fusion,
+	.init_adapter = megasas_init_adapter_fusion,
+	.build_and_issue_cmd = megasas_build_and_issue_cmd_fusion,
+	.issue_dcmd = megasas_issue_dcmd_fusion,
+};

--0022152d6665ada86f04978cdd0c
Content-Type: application/octet-stream; name="megaraid_sas.patch7"
Content-Disposition: attachment; filename="megaraid_sas.patch7"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghs3ikwo0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YXJhaWRfc2FzX2Z1c2lvbi5jIGxpbnV4LTIuNi4zNy1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMKLS0tIGxpbnV4LTIuNi4zNy1yYzUub2xkL2RyaXZl
cnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMJMTk2OS0xMi0zMSAxNjowMDow
MC4wMDAwMDAwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4zNy1yYzUubmV3L2RyaXZlcnMvc2NzaS9t
ZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMJMjAxMC0xMi0xNiAxMjowMzo0Mi4wMDAwMDAw
MDAgLTA4MDAKQEAgLTAsMCArMSwyMjUwIEBACisvKgorICogIExpbnV4IE1lZ2FSQUlEIGRyaXZl
ciBmb3IgU0FTIGJhc2VkIFJBSUQgY29udHJvbGxlcnMKKyAqCisgKiAgQ29weXJpZ2h0IChjKSAy
MDA5LTIwMTEgIExTSSBDb3Jwb3JhdGlvbi4KKyAqCisgKiAgVGhpcyBwcm9ncmFtIGlzIGZyZWUg
c29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vcgorICogIG1vZGlmeSBpdCB1
bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlCisgKiAgYXMg
cHVibGlzaGVkIGJ5IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJzaW9u
IDIKKyAqICBvZiB0aGUgTGljZW5zZSwgb3IgKGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVy
c2lvbi4KKyAqCisgKiAgVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIHRo
YXQgaXQgd2lsbCBiZSB1c2VmdWwsCisgKiAgYnV0IFdJVEhPVVQgQU5ZIFdBUlJBTlRZOyB3aXRo
b3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YKKyAqICBNRVJDSEFOVEFCSUxJVFkgb3Ig
RklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICBTZWUgdGhlCisgKiAgR05VIEdlbmVy
YWwgUHVibGljIExpY2Vuc2UgZm9yIG1vcmUgZGV0YWlscy4KKyAqCisgKiAgWW91IHNob3VsZCBo
YXZlIHJlY2VpdmVkIGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UKKyAq
ICBhbG9uZyB3aXRoIHRoaXMgcHJvZ3JhbTsgaWYgbm90LCB3cml0ZSB0byB0aGUgRnJlZSBTb2Z0
d2FyZQorICogIEZvdW5kYXRpb24sIEluYy4sIDU5IFRlbXBsZSBQbGFjZSwgU3VpdGUgMzMwLCBC
b3N0b24sIE1BIDAyMTExLTEzMDcgVVNBCisgKgorICogIEZJTEU6IG1lZ2FyYWlkX3Nhc19mdXNp
b24uYworICoKKyAqICBBdXRob3JzOiBMU0kgQ29ycG9yYXRpb24KKyAqICAgICAgICAgICBTdW1h
bnQgUGF0cm8KKyAqICAgICAgICAgICBBZGFtIFJhZGZvcmQgPGxpbnV4cmFpZEBsc2kuY29tPgor
ICoKKyAqICBTZW5kIGZlZWRiYWNrIHRvOiA8bWVnYXJhaWRsaW51eEBsc2kuY29tPgorICoKKyAq
ICBNYWlsIHRvOiBMU0kgQ29ycG9yYXRpb24sIDE2MjEgQmFyYmVyIExhbmUsIE1pbHBpdGFzLCBD
QSA5NTAzNQorICogICAgIEFUVE46IExpbnV4cmFpZAorICovCisKKyNpbmNsdWRlIDxsaW51eC9r
ZXJuZWwuaD4KKyNpbmNsdWRlIDxsaW51eC90eXBlcy5oPgorI2luY2x1ZGUgPGxpbnV4L3BjaS5o
PgorI2luY2x1ZGUgPGxpbnV4L2xpc3QuaD4KKyNpbmNsdWRlIDxsaW51eC9tb2R1bGVwYXJhbS5o
PgorI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgorI2luY2x1ZGUgPGxpbnV4L3NwaW5sb2NrLmg+
CisjaW5jbHVkZSA8bGludXgvaW50ZXJydXB0Lmg+CisjaW5jbHVkZSA8bGludXgvZGVsYXkuaD4K
KyNpbmNsdWRlIDxsaW51eC9zbXBfbG9jay5oPgorI2luY2x1ZGUgPGxpbnV4L3Vpby5oPgorI2lu
Y2x1ZGUgPGxpbnV4L3VhY2Nlc3MuaD4KKyNpbmNsdWRlIDxsaW51eC9mcy5oPgorI2luY2x1ZGUg
PGxpbnV4L2NvbXBhdC5oPgorI2luY2x1ZGUgPGxpbnV4L2Jsa2Rldi5oPgorI2luY2x1ZGUgPGxp
bnV4L211dGV4Lmg+CisjaW5jbHVkZSA8bGludXgvcG9sbC5oPgorCisjaW5jbHVkZSA8c2NzaS9z
Y3NpLmg+CisjaW5jbHVkZSA8c2NzaS9zY3NpX2NtbmQuaD4KKyNpbmNsdWRlIDxzY3NpL3Njc2lf
ZGV2aWNlLmg+CisjaW5jbHVkZSA8c2NzaS9zY3NpX2hvc3QuaD4KKworI2luY2x1ZGUgIm1lZ2Fy
YWlkX3Nhc19mdXNpb24uaCIKKyNpbmNsdWRlICJtZWdhcmFpZF9zYXMuaCIKKworZXh0ZXJuIHZv
aWQgbWVnYXNhc19mcmVlX2NtZHMoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKTsK
K2V4dGVybiBzdHJ1Y3QgbWVnYXNhc19jbWQgKm1lZ2FzYXNfZ2V0X2NtZChzdHJ1Y3QgbWVnYXNh
c19pbnN0YW5jZQorCQkJCQkgICAqaW5zdGFuY2UpOworZXh0ZXJuIHZvaWQKK21lZ2FzYXNfY29t
cGxldGVfY21kKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKKwkJICAgICBzdHJ1
Y3QgbWVnYXNhc19jbWQgKmNtZCwgdTggYWx0X3N0YXR1cyk7CitpbnQgbWVnYXNhc19pc19sZGlv
KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCk7CitpbnQKK3dhaXRfYW5kX3BvbGwoc3RydWN0IG1lZ2Fz
YXNfaW5zdGFuY2UgKmluc3RhbmNlLCBzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZCk7CisKK3ZvaWQK
K21lZ2FzYXNfcmV0dXJuX2NtZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0
cnVjdCBtZWdhc2FzX2NtZCAqY21kKTsKK2ludCBtZWdhc2FzX2FsbG9jX2NtZHMoc3RydWN0IG1l
Z2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKTsKK2ludAorbWVnYXNhc19jbGVhcl9pbnRyX2Z1c2lv
bihzdHJ1Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncyk7CitpbnQKK21lZ2Fz
YXNfaXNzdWVfcG9sbGVkKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKKwkJICAg
ICBzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZCk7CisKK3U4CitNUl9CdWlsZFJhaWRDb250ZXh0KHN0
cnVjdCBJT19SRVFVRVNUX0lORk8gKmlvX2luZm8sCisJCSAgICBzdHJ1Y3QgUkFJRF9DT05URVhU
ICpwUkFJRF9Db250ZXh0LAorCQkgICAgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwKTsK
K3UxNiBNUl9UYXJnZXRJZFRvTGRHZXQodTMyIGxkVGd0SWQsIHN0cnVjdCBNUl9GV19SQUlEX01B
UF9BTEwgKm1hcCk7CitzdHJ1Y3QgTVJfTERfUkFJRCAqTVJfTGRSYWlkR2V0KHUzMiBsZCwgc3Ry
dWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwKTsKKwordTE2IE1SX0dldExEVGd0SWQodTMyIGxk
LCBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApOwordTggTVJfVmFsaWRhdGVNYXBJbmZv
KHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcCwKKwkJICAgICAgc3RydWN0IExEX0xPQURf
QkFMQU5DRV9JTkZPICpsYkluZm8pOwordTE2IGdldF91cGRhdGVkX2Rldl9oYW5kbGUoc3RydWN0
IExEX0xPQURfQkFMQU5DRV9JTkZPICpsYkluZm8sCisJCQkgICBzdHJ1Y3QgSU9fUkVRVUVTVF9J
TkZPICppbl9pbmZvKTsKK2ludCBtZWdhc2FzX3RyYW5zaXRpb25fdG9fcmVhZHkoc3RydWN0IG1l
Z2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKTsKK3ZvaWQgbWVnYXJhaWRfc2FzX2tpbGxfaGJhKHN0
cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSk7CisKK2V4dGVybiB1MzIgbWVnYXNhc19k
YmdfbHZsOworCisvKioKKyAqIG1lZ2FzYXNfZW5hYmxlX2ludHJfZnVzaW9uIC0JRW5hYmxlcyBp
bnRlcnJ1cHRzCisgKiBAcmVnczoJCQlNRkkgcmVnaXN0ZXIgc2V0CisgKi8KK3ZvaWQKK21lZ2Fz
YXNfZW5hYmxlX2ludHJfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVt
ICpyZWdzKQoreworCXdyaXRlbCh+TUZJX0ZVU0lPTl9FTkFCTEVfSU5URVJSVVBUX01BU0ssICYo
cmVncyktPm91dGJvdW5kX2ludHJfbWFzayk7CisKKwkvKiBEdW1teSByZWFkbCB0byBmb3JjZSBw
Y2kgZmx1c2ggKi8KKwlyZWFkbCgmcmVncy0+b3V0Ym91bmRfaW50cl9tYXNrKTsKK30KKworLyoq
CisgKiBtZWdhc2FzX2Rpc2FibGVfaW50cl9mdXNpb24gLSBEaXNhYmxlcyBpbnRlcnJ1cHQKKyAq
IEByZWdzOgkJCSBNRkkgcmVnaXN0ZXIgc2V0CisgKi8KK3ZvaWQKK21lZ2FzYXNfZGlzYWJsZV9p
bnRyX2Z1c2lvbihzdHJ1Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncykKK3sK
Kwl1MzIgbWFzayA9IDB4RkZGRkZGRkY7CisJdTMyIHN0YXR1czsKKworCXdyaXRlbChtYXNrLCAm
cmVncy0+b3V0Ym91bmRfaW50cl9tYXNrKTsKKwkvKiBEdW1teSByZWFkbCB0byBmb3JjZSBwY2kg
Zmx1c2ggKi8KKwlzdGF0dXMgPSByZWFkbCgmcmVncy0+b3V0Ym91bmRfaW50cl9tYXNrKTsKK30K
KworaW50CittZWdhc2FzX2NsZWFyX2ludHJfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVy
X3NldCBfX2lvbWVtICpyZWdzKQoreworCXUzMiBzdGF0dXM7CisJLyoKKwkgKiBDaGVjayBpZiBp
dCBpcyBvdXIgaW50ZXJydXB0CisJICovCisJc3RhdHVzID0gcmVhZGwoJnJlZ3MtPm91dGJvdW5k
X2ludHJfc3RhdHVzKTsKKworCWlmIChzdGF0dXMgJiAxKSB7CisJCXdyaXRlbChzdGF0dXMsICZy
ZWdzLT5vdXRib3VuZF9pbnRyX3N0YXR1cyk7CisJCXJlYWRsKCZyZWdzLT5vdXRib3VuZF9pbnRy
X3N0YXR1cyk7CisJCXJldHVybiAxOworCX0KKwlpZiAoIShzdGF0dXMgJiBNRklfRlVTSU9OX0VO
QUJMRV9JTlRFUlJVUFRfTUFTSykpCisJCXJldHVybiAwOworCisJLyoKKwkgKiBkdW1teSByZWFk
IHRvIGZsdXNoIFBDSQorCSAqLworCXJlYWRsKCZyZWdzLT5vdXRib3VuZF9pbnRyX3N0YXR1cyk7
CisKKwlyZXR1cm4gMTsKK30KKworLyoqCisgKiBtZWdhc2FzX2dldF9jbWRfZnVzaW9uIC0JR2V0
IGEgY29tbWFuZCBmcm9tIHRoZSBmcmVlIHBvb2wKKyAqIEBpbnN0YW5jZToJCUFkYXB0ZXIgc29m
dCBzdGF0ZQorICoKKyAqIFJldHVybnMgYSBmcmVlIGNvbW1hbmQgZnJvbSB0aGUgcG9vbAorICov
CitzdHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uICptZWdhc2FzX2dldF9jbWRfZnVzaW9uKHN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlCisJCQkJCQkgICppbnN0YW5jZSkKK3sKKwl1bnNpZ25lZCBsb25n
IGZsYWdzOworCXN0cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uID0KKwkJKHN0cnVjdCBmdXNp
b25fY29udGV4dCAqKWluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CisJc3RydWN0IG1lZ2FzYXNfY21k
X2Z1c2lvbiAqY21kID0gTlVMTDsKKworCXNwaW5fbG9ja19pcnFzYXZlKCZmdXNpb24tPmNtZF9w
b29sX2xvY2ssIGZsYWdzKTsKKworCWlmICghbGlzdF9lbXB0eSgmZnVzaW9uLT5jbWRfcG9vbCkp
IHsKKwkJY21kID0gbGlzdF9lbnRyeSgoJmZ1c2lvbi0+Y21kX3Bvb2wpLT5uZXh0LAorCQkJCSBz
dHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uLCBsaXN0KTsKKwkJbGlzdF9kZWxfaW5pdCgmY21kLT5s
aXN0KTsKKwl9IGVsc2UgeworCQlwcmludGsoS0VSTl9FUlIgIm1lZ2FzYXM6IENvbW1hbmQgcG9v
bCAoZnVzaW9uKSBlbXB0eSFcbiIpOworCX0KKworCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmZ1
c2lvbi0+Y21kX3Bvb2xfbG9jaywgZmxhZ3MpOworCXJldHVybiBjbWQ7Cit9CisKKy8qKgorICog
bWVnYXNhc19yZXR1cm5fY21kX2Z1c2lvbiAtCVJldHVybiBhIGNtZCB0byBmcmVlIGNvbW1hbmQg
cG9vbAorICogQGluc3RhbmNlOgkJQWRhcHRlciBzb2Z0IHN0YXRlCisgKiBAY21kOgkJQ29tbWFu
ZCBwYWNrZXQgdG8gYmUgcmV0dXJuZWQgdG8gZnJlZSBjb21tYW5kIHBvb2wKKyAqLworc3RhdGlj
IGlubGluZSB2b2lkCittZWdhc2FzX3JldHVybl9jbWRfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX2lu
c3RhbmNlICppbnN0YW5jZSwKKwkJCSAgc3RydWN0IG1lZ2FzYXNfY21kX2Z1c2lvbiAqY21kKQor
eworCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CisJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb24g
PQorCQkoc3RydWN0IGZ1c2lvbl9jb250ZXh0ICopaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKKwor
CXNwaW5fbG9ja19pcnFzYXZlKCZmdXNpb24tPmNtZF9wb29sX2xvY2ssIGZsYWdzKTsKKworCWNt
ZC0+c2NtZCA9IE5VTEw7CisJY21kLT5zeW5jX2NtZF9pZHggPSAodTMyKVVMT05HX01BWDsKKwls
aXN0X2FkZF90YWlsKCZjbWQtPmxpc3QsICZmdXNpb24tPmNtZF9wb29sKTsKKworCXNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoJmZ1c2lvbi0+Y21kX3Bvb2xfbG9jaywgZmxhZ3MpOworfQorCisvKioK
KyAqIG1lZ2FzYXNfdGVhcmRvd25fZnJhbWVfcG9vbF9mdXNpb24gLQlEZXN0cm95IHRoZSBjbWQg
ZnJhbWUgRE1BIHBvb2wKKyAqIEBpbnN0YW5jZToJCQkJQWRhcHRlciBzb2Z0IHN0YXRlCisgKi8K
K3N0YXRpYyB2b2lkIG1lZ2FzYXNfdGVhcmRvd25fZnJhbWVfcG9vbF9mdXNpb24oCisJc3RydWN0
IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQoreworCWludCBpOworCXN0cnVjdCBmdXNpb25f
Y29udGV4dCAqZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKKworCXUxNiBtYXhfY21k
ID0gaW5zdGFuY2UtPm1heF9md19jbWRzOworCisJc3RydWN0IG1lZ2FzYXNfY21kX2Z1c2lvbiAq
Y21kOworCisJaWYgKCFmdXNpb24tPnNnX2RtYV9wb29sIHx8ICFmdXNpb24tPnNlbnNlX2RtYV9w
b29sKSB7CisJCXByaW50ayhLRVJOX0VSUiAibWVnYXNhczogZG1hIHBvb2wgaXMgbnVsbC4gU0cg
UG9vbCAlcCwgIgorCQkgICAgICAgInNlbnNlIHBvb2wgOiAlcFxuIiwgZnVzaW9uLT5zZ19kbWFf
cG9vbCwKKwkJICAgICAgIGZ1c2lvbi0+c2Vuc2VfZG1hX3Bvb2wpOworCQlyZXR1cm47CisJfQor
CisJLyoKKwkgKiBSZXR1cm4gYWxsIGZyYW1lcyB0byBwb29sCisJICovCisJZm9yIChpID0gMDsg
aSA8IG1heF9jbWQ7IGkrKykgeworCisJCWNtZCA9IGZ1c2lvbi0+Y21kX2xpc3RbaV07CisKKwkJ
aWYgKGNtZC0+c2dfZnJhbWUpCisJCQlwY2lfcG9vbF9mcmVlKGZ1c2lvbi0+c2dfZG1hX3Bvb2ws
IGNtZC0+c2dfZnJhbWUsCisJCQkJICAgICAgY21kLT5zZ19mcmFtZV9waHlzX2FkZHIpOworCisJ
CWlmIChjbWQtPnNlbnNlKQorCQkJcGNpX3Bvb2xfZnJlZShmdXNpb24tPnNlbnNlX2RtYV9wb29s
LCBjbWQtPnNlbnNlLAorCQkJCSAgICAgIGNtZC0+c2Vuc2VfcGh5c19hZGRyKTsKKwl9CisKKwkv
KgorCSAqIE5vdyBkZXN0cm95IHRoZSBwb29sIGl0c2VsZgorCSAqLworCXBjaV9wb29sX2Rlc3Ry
b3koZnVzaW9uLT5zZ19kbWFfcG9vbCk7CisJcGNpX3Bvb2xfZGVzdHJveShmdXNpb24tPnNlbnNl
X2RtYV9wb29sKTsKKworCWZ1c2lvbi0+c2dfZG1hX3Bvb2wgPSBOVUxMOworCWZ1c2lvbi0+c2Vu
c2VfZG1hX3Bvb2wgPSBOVUxMOworfQorCisvKioKKyAqIG1lZ2FzYXNfZnJlZV9jbWRzX2Z1c2lv
biAtCUZyZWUgYWxsIHRoZSBjbWRzIGluIHRoZSBmcmVlIGNtZCBwb29sCisgKiBAaW5zdGFuY2U6
CQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAqLwordm9pZAorbWVnYXNhc19mcmVlX2NtZHNfZnVzaW9u
KHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKK3sKKwlpbnQgaTsKKwlzdHJ1Y3Qg
ZnVzaW9uX2NvbnRleHQgKmZ1c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CisKKwl1MzIg
bWF4X2NtZHMsIHJlcV9zeiwgcmVwbHlfc3osIGlvX2ZyYW1lc19zejsKKworCisJcmVxX3N6ID0g
ZnVzaW9uLT5yZXF1ZXN0X2FsbG9jX3N6OworCXJlcGx5X3N6ID0gZnVzaW9uLT5yZXBseV9hbGxv
Y19zejsKKwlpb19mcmFtZXNfc3ogPSBmdXNpb24tPmlvX2ZyYW1lc19hbGxvY19zejsKKworCW1h
eF9jbWRzID0gaW5zdGFuY2UtPm1heF9md19jbWRzOworCisJLyogRnJlZSBkZXNjcmlwdG9ycyBh
bmQgcmVxdWVzdCBGcmFtZXMgbWVtb3J5ICovCisJaWYgKGZ1c2lvbi0+cmVxX2ZyYW1lc19kZXNj
KQorCQlkbWFfZnJlZV9jb2hlcmVudCgmaW5zdGFuY2UtPnBkZXYtPmRldiwgcmVxX3N6LAorCQkJ
CSAgZnVzaW9uLT5yZXFfZnJhbWVzX2Rlc2MsCisJCQkJICBmdXNpb24tPnJlcV9mcmFtZXNfZGVz
Y19waHlzKTsKKworCWlmIChmdXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjKSB7CisJCXBjaV9wb29s
X2ZyZWUoZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzY19wb29sLAorCQkJICAgICAgZnVzaW9uLT5y
ZXBseV9mcmFtZXNfZGVzYywKKwkJCSAgICAgIGZ1c2lvbi0+cmVwbHlfZnJhbWVzX2Rlc2NfcGh5
cyk7CisJCXBjaV9wb29sX2Rlc3Ryb3koZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzY19wb29sKTsK
Kwl9CisKKwlpZiAoZnVzaW9uLT5pb19yZXF1ZXN0X2ZyYW1lcykgeworCQlwY2lfcG9vbF9mcmVl
KGZ1c2lvbi0+aW9fcmVxdWVzdF9mcmFtZXNfcG9vbCwKKwkJCSAgICAgIGZ1c2lvbi0+aW9fcmVx
dWVzdF9mcmFtZXMsCisJCQkgICAgICBmdXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzX3BoeXMpOwor
CQlwY2lfcG9vbF9kZXN0cm95KGZ1c2lvbi0+aW9fcmVxdWVzdF9mcmFtZXNfcG9vbCk7CisJfQor
CisJLyogRnJlZSB0aGUgRnVzaW9uIGZyYW1lIHBvb2wgKi8KKwltZWdhc2FzX3RlYXJkb3duX2Zy
YW1lX3Bvb2xfZnVzaW9uKGluc3RhbmNlKTsKKworCS8qIEZyZWUgYWxsIHRoZSBjb21tYW5kcyBp
biB0aGUgY21kX2xpc3QgKi8KKwlmb3IgKGkgPSAwOyBpIDwgbWF4X2NtZHM7IGkrKykKKwkJa2Zy
ZWUoZnVzaW9uLT5jbWRfbGlzdFtpXSk7CisKKwkvKiBGcmVlIHRoZSBjbWRfbGlzdCBidWZmZXIg
aXRzZWxmICovCisJa2ZyZWUoZnVzaW9uLT5jbWRfbGlzdCk7CisJZnVzaW9uLT5jbWRfbGlzdCA9
IE5VTEw7CisKKwlJTklUX0xJU1RfSEVBRCgmZnVzaW9uLT5jbWRfcG9vbCk7Cit9CisKKy8qKgor
ICogbWVnYXNhc19jcmVhdGVfZnJhbWVfcG9vbF9mdXNpb24gLQlDcmVhdGVzIERNQSBwb29sIGZv
ciBjbWQgZnJhbWVzCisgKiBAaW5zdGFuY2U6CQkJQWRhcHRlciBzb2Z0IHN0YXRlCisgKgorICov
CitzdGF0aWMgaW50IG1lZ2FzYXNfY3JlYXRlX2ZyYW1lX3Bvb2xfZnVzaW9uKHN0cnVjdCBtZWdh
c2FzX2luc3RhbmNlICppbnN0YW5jZSkKK3sKKwlpbnQgaTsKKwl1MzIgbWF4X2NtZDsKKwlzdHJ1
Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lvbjsKKwlzdHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uICpj
bWQ7CisJdTMyIHRvdGFsX3N6X2NoYWluX2ZyYW1lOworCisJZnVzaW9uID0gaW5zdGFuY2UtPmN0
cmxfY29udGV4dDsKKwltYXhfY21kID0gaW5zdGFuY2UtPm1heF9md19jbWRzOworCisJdG90YWxf
c3pfY2hhaW5fZnJhbWUgPSBNRUdBU0FTX01BWF9TWl9DSEFJTl9GUkFNRTsKKworCS8qCisJICog
VXNlIERNQSBwb29sIGZhY2lsaXR5IHByb3ZpZGVkIGJ5IFBDSSBsYXllcgorCSAqLworCisJZnVz
aW9uLT5zZ19kbWFfcG9vbCA9IHBjaV9wb29sX2NyZWF0ZSgibWVnYXNhcyBzZyBwb29sIGZ1c2lv
biIsCisJCQkJCSAgICAgIGluc3RhbmNlLT5wZGV2LAorCQkJCQkgICAgICB0b3RhbF9zel9jaGFp
bl9mcmFtZSwgNCwKKwkJCQkJICAgICAgMCk7CisJaWYgKCFmdXNpb24tPnNnX2RtYV9wb29sKSB7
CisJCXByaW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBmYWlsZWQgdG8gc2V0dXAgcmVxdWVzdCBw
b29sICIKKwkJICAgICAgICJmdXNpb25cbiIpOworCQlyZXR1cm4gLUVOT01FTTsKKwl9CisJZnVz
aW9uLT5zZW5zZV9kbWFfcG9vbCA9IHBjaV9wb29sX2NyZWF0ZSgibWVnYXNhcyBzZW5zZSBwb29s
IGZ1c2lvbiIsCisJCQkJCQkgaW5zdGFuY2UtPnBkZXYsCisJCQkJCQkgU0NTSV9TRU5TRV9CVUZG
RVJTSVpFLCA2NCwgMCk7CisKKwlpZiAoIWZ1c2lvbi0+c2Vuc2VfZG1hX3Bvb2wpIHsKKwkJcHJp
bnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IGZhaWxlZCB0byBzZXR1cCBzZW5zZSBwb29sICIKKwkJ
ICAgICAgICJmdXNpb25cbiIpOworCQlwY2lfcG9vbF9kZXN0cm95KGZ1c2lvbi0+c2dfZG1hX3Bv
b2wpOworCQlmdXNpb24tPnNnX2RtYV9wb29sID0gTlVMTDsKKwkJcmV0dXJuIC1FTk9NRU07CisJ
fQorCisJLyoKKwkgKiBBbGxvY2F0ZSBhbmQgYXR0YWNoIGEgZnJhbWUgdG8gZWFjaCBvZiB0aGUg
Y29tbWFuZHMgaW4gY21kX2xpc3QKKwkgKi8KKwlmb3IgKGkgPSAwOyBpIDwgbWF4X2NtZDsgaSsr
KSB7CisKKwkJY21kID0gZnVzaW9uLT5jbWRfbGlzdFtpXTsKKworCQljbWQtPnNnX2ZyYW1lID0g
cGNpX3Bvb2xfYWxsb2MoZnVzaW9uLT5zZ19kbWFfcG9vbCwKKwkJCQkJICAgICAgIEdGUF9LRVJO
RUwsCisJCQkJCSAgICAgICAmY21kLT5zZ19mcmFtZV9waHlzX2FkZHIpOworCisJCWNtZC0+c2Vu
c2UgPSBwY2lfcG9vbF9hbGxvYyhmdXNpb24tPnNlbnNlX2RtYV9wb29sLAorCQkJCQkgICAgR0ZQ
X0tFUk5FTCwgJmNtZC0+c2Vuc2VfcGh5c19hZGRyKTsKKwkJLyoKKwkJICogbWVnYXNhc190ZWFy
ZG93bl9mcmFtZV9wb29sX2Z1c2lvbigpIHRha2VzIGNhcmUgb2YgZnJlZWluZworCQkgKiB3aGF0
ZXZlciBoYXMgYmVlbiBhbGxvY2F0ZWQKKwkJICovCisJCWlmICghY21kLT5zZ19mcmFtZSB8fCAh
Y21kLT5zZW5zZSkgeworCQkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IHBjaV9wb29sX2Fs
bG9jIGZhaWxlZFxuIik7CisJCQltZWdhc2FzX3RlYXJkb3duX2ZyYW1lX3Bvb2xfZnVzaW9uKGlu
c3RhbmNlKTsKKwkJCXJldHVybiAtRU5PTUVNOworCQl9CisJfQorCXJldHVybiAwOworfQorCisv
KioKKyAqIG1lZ2FzYXNfYWxsb2NfY21kc19mdXNpb24gLQlBbGxvY2F0ZXMgdGhlIGNvbW1hbmQg
cGFja2V0cworICogQGluc3RhbmNlOgkJQWRhcHRlciBzb2Z0IHN0YXRlCisgKgorICoKKyAqIEVh
Y2ggZnJhbWUgaGFzIGEgMzItYml0IGZpZWxkIGNhbGxlZCBjb250ZXh0LiBUaGlzIGNvbnRleHQg
aXMgdXNlZCB0byBnZXQKKyAqIGJhY2sgdGhlIG1lZ2FzYXNfY21kX2Z1c2lvbiBmcm9tIHRoZSBm
cmFtZSB3aGVuIGEgZnJhbWUgZ2V0cyBjb21wbGV0ZWQKKyAqIEluIHRoaXMgZHJpdmVyLCB0aGUg
MzIgYml0IHZhbHVlcyBhcmUgdGhlIGluZGljZXMgaW50byBhbiBhcnJheSBjbWRfbGlzdC4KKyAq
IFRoaXMgYXJyYXkgaXMgdXNlZCBvbmx5IHRvIGxvb2sgdXAgdGhlIG1lZ2FzYXNfY21kX2Z1c2lv
biBnaXZlbiB0aGUgY29udGV4dC4KKyAqIFRoZSBmcmVlIGNvbW1hbmRzIHRoZW1zZWx2ZXMgYXJl
IG1haW50YWluZWQgaW4gYSBsaW5rZWQgbGlzdCBjYWxsZWQgY21kX3Bvb2wuCisgKgorICogY21k
cyBhcmUgZm9ybWVkIGluIHRoZSBpb19yZXF1ZXN0IGFuZCBzZ19mcmFtZSBtZW1iZXJzIG9mIHRo
ZQorICogbWVnYXNhc19jbWRfZnVzaW9uLiBUaGUgY29udGV4dCBmaWVsZCBpcyB1c2VkIHRvIGdl
dCBhIHJlcXVlc3QgZGVzY3JpcHRvcgorICogYW5kIGlzIHVzZWQgYXMgU01JRCBvZiB0aGUgY21k
LgorICogU01JRCB2YWx1ZSByYW5nZSBpcyBmcm9tIDEgdG8gbWF4X2Z3X2NtZHMuCisgKi8KK2lu
dAorbWVnYXNhc19hbGxvY19jbWRzX2Z1c2lvbihzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5z
dGFuY2UpCit7CisJaW50IGksIGo7CisJdTMyIG1heF9jbWQsIGlvX2ZyYW1lc19zejsKKwlzdHJ1
Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lvbjsKKwlzdHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uICpj
bWQ7CisJdW5pb24gTVBJMl9SRVBMWV9ERVNDUklQVE9SU19VTklPTiAqcmVwbHlfZGVzYzsKKwl1
MzIgb2Zmc2V0OworCWRtYV9hZGRyX3QgaW9fcmVxX2Jhc2VfcGh5czsKKwl1OCAqaW9fcmVxX2Jh
c2U7CisKKwlmdXNpb24gPSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0OworCisJbWF4X2NtZCA9IGlu
c3RhbmNlLT5tYXhfZndfY21kczsKKworCWZ1c2lvbi0+cmVxX2ZyYW1lc19kZXNjID0KKwkJZG1h
X2FsbG9jX2NvaGVyZW50KCZpbnN0YW5jZS0+cGRldi0+ZGV2LAorCQkJCSAgIGZ1c2lvbi0+cmVx
dWVzdF9hbGxvY19zeiwKKwkJCQkgICAmZnVzaW9uLT5yZXFfZnJhbWVzX2Rlc2NfcGh5cywgR0ZQ
X0tFUk5FTCk7CisKKwlpZiAoIWZ1c2lvbi0+cmVxX2ZyYW1lc19kZXNjKSB7CisJCXByaW50ayhL
RVJOX0VSUiAibWVnYXNhczsgQ291bGQgbm90IGFsbG9jYXRlIG1lbW9yeSBmb3IgIgorCQkgICAg
ICAgInJlcXVlc3RfZnJhbWVzXG4iKTsKKwkJZ290byBmYWlsX3JlcV9kZXNjOworCX0KKworCWZ1
c2lvbi0+cmVwbHlfZnJhbWVzX2Rlc2NfcG9vbCA9CisJCXBjaV9wb29sX2NyZWF0ZSgicmVwbHlf
ZnJhbWVzIHBvb2wiLCBpbnN0YW5jZS0+cGRldiwKKwkJCQlmdXNpb24tPnJlcGx5X2FsbG9jX3N6
LCAxNiwgMCk7CisKKwlpZiAoIWZ1c2lvbi0+cmVwbHlfZnJhbWVzX2Rlc2NfcG9vbCkgeworCQlw
cmludGsoS0VSTl9FUlIgIm1lZ2FzYXM7IENvdWxkIG5vdCBhbGxvY2F0ZSBtZW1vcnkgZm9yICIK
KwkJICAgICAgICJyZXBseV9mcmFtZSBwb29sXG4iKTsKKwkJZ290byBmYWlsX3JlcGx5X2Rlc2M7
CisJfQorCisJZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzYyA9CisJCXBjaV9wb29sX2FsbG9jKGZ1
c2lvbi0+cmVwbHlfZnJhbWVzX2Rlc2NfcG9vbCwgR0ZQX0tFUk5FTCwKKwkJCSAgICAgICAmZnVz
aW9uLT5yZXBseV9mcmFtZXNfZGVzY19waHlzKTsKKwlpZiAoIWZ1c2lvbi0+cmVwbHlfZnJhbWVz
X2Rlc2MpIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOyBDb3VsZCBub3QgYWxsb2NhdGUg
bWVtb3J5IGZvciAiCisJCSAgICAgICAicmVwbHlfZnJhbWUgcG9vbFxuIik7CisJCXBjaV9wb29s
X2Rlc3Ryb3koZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzY19wb29sKTsKKwkJZ290byBmYWlsX3Jl
cGx5X2Rlc2M7CisJfQorCisJcmVwbHlfZGVzYyA9IGZ1c2lvbi0+cmVwbHlfZnJhbWVzX2Rlc2M7
CisJZm9yIChpID0gMDsgaSA8IGZ1c2lvbi0+cmVwbHlfcV9kZXB0aDsgaSsrLCByZXBseV9kZXNj
KyspCisJCXJlcGx5X2Rlc2MtPldvcmRzID0gVUxMT05HX01BWDsKKworCWlvX2ZyYW1lc19zeiA9
IGZ1c2lvbi0+aW9fZnJhbWVzX2FsbG9jX3N6OworCisJZnVzaW9uLT5pb19yZXF1ZXN0X2ZyYW1l
c19wb29sID0KKwkJcGNpX3Bvb2xfY3JlYXRlKCJpb19yZXF1ZXN0X2ZyYW1lcyBwb29sIiwgaW5z
dGFuY2UtPnBkZXYsCisJCQkJZnVzaW9uLT5pb19mcmFtZXNfYWxsb2Nfc3osIDE2LCAwKTsKKwor
CWlmICghZnVzaW9uLT5pb19yZXF1ZXN0X2ZyYW1lc19wb29sKSB7CisJCXByaW50ayhLRVJOX0VS
UiAibWVnYXNhczogQ291bGQgbm90IGFsbG9jYXRlIG1lbW9yeSBmb3IgIgorCQkgICAgICAgImlv
X3JlcXVlc3RfZnJhbWUgcG9vbFxuIik7CisJCWdvdG8gZmFpbF9pb19mcmFtZXM7CisJfQorCisJ
ZnVzaW9uLT5pb19yZXF1ZXN0X2ZyYW1lcyA9CisJCXBjaV9wb29sX2FsbG9jKGZ1c2lvbi0+aW9f
cmVxdWVzdF9mcmFtZXNfcG9vbCwgR0ZQX0tFUk5FTCwKKwkJCSAgICAgICAmZnVzaW9uLT5pb19y
ZXF1ZXN0X2ZyYW1lc19waHlzKTsKKwlpZiAoIWZ1c2lvbi0+aW9fcmVxdWVzdF9mcmFtZXMpIHsK
KwkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBDb3VsZCBub3QgYWxsb2NhdGUgbWVtb3J5IGZv
ciAiCisJCSAgICAgICAiaW9fcmVxdWVzdF9mcmFtZXMgZnJhbWVzXG4iKTsKKwkJcGNpX3Bvb2xf
ZGVzdHJveShmdXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzX3Bvb2wpOworCQlnb3RvIGZhaWxfaW9f
ZnJhbWVzOworCX0KKworCS8qCisJICogZnVzaW9uLT5jbWRfbGlzdCBpcyBhbiBhcnJheSBvZiBz
dHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uIHBvaW50ZXJzLgorCSAqIEFsbG9jYXRlIHRoZSBkeW5h
bWljIGFycmF5IGZpcnN0IGFuZCB0aGVuIGFsbG9jYXRlIGluZGl2aWR1YWwKKwkgKiBjb21tYW5k
cy4KKwkgKi8KKwlmdXNpb24tPmNtZF9saXN0ID0ga21hbGxvYyhzaXplb2Yoc3RydWN0IG1lZ2Fz
YXNfY21kX2Z1c2lvbiAqKQorCQkJCSAgICptYXhfY21kLCBHRlBfS0VSTkVMKTsKKworCWlmICgh
ZnVzaW9uLT5jbWRfbGlzdCkgeworCQlwcmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogb3V0IG9m
IG1lbW9yeS4gQ291bGQgbm90IGFsbG9jICIKKwkJICAgICAgICJtZW1vcnkgZm9yIGNtZF9saXN0
X2Z1c2lvblxuIik7CisJCWdvdG8gZmFpbF9jbWRfbGlzdDsKKwl9CisKKwltZW1zZXQoZnVzaW9u
LT5jbWRfbGlzdCwgMCwgc2l6ZW9mKHN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24gKikKKwkgICAg
ICAgKm1heF9jbWQpOworCisJbWF4X2NtZCA9IGluc3RhbmNlLT5tYXhfZndfY21kczsKKwlmb3Ig
KGkgPSAwOyBpIDwgbWF4X2NtZDsgaSsrKSB7CisJCWZ1c2lvbi0+Y21kX2xpc3RbaV0gPSBrbWFs
bG9jKHNpemVvZihzdHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uKSwKKwkJCQkJICAgICAgR0ZQX0tF
Uk5FTCk7CisJCWlmICghZnVzaW9uLT5jbWRfbGlzdFtpXSkgeworCQkJcHJpbnRrKEtFUk5fRVJS
ICJDb3VsZCBub3QgYWxsb2MgY21kIGxpc3QgZnVzaW9uXG4iKTsKKworCQkJZm9yIChqID0gMDsg
aiA8IGk7IGorKykKKwkJCQlrZnJlZShmdXNpb24tPmNtZF9saXN0W2pdKTsKKworCQkJa2ZyZWUo
ZnVzaW9uLT5jbWRfbGlzdCk7CisJCQlmdXNpb24tPmNtZF9saXN0ID0gTlVMTDsKKwkJCWdvdG8g
ZmFpbF9jbWRfbGlzdDsKKwkJfQorCX0KKworCS8qIFRoZSBmaXJzdCAyNTYgYnl0ZXMgKFNNSUQg
MCkgaXMgbm90IHVzZWQuIERvbid0IGFkZCB0byBjbWQgbGlzdCAqLworCWlvX3JlcV9iYXNlID0g
ZnVzaW9uLT5pb19yZXF1ZXN0X2ZyYW1lcyArCisJCU1FR0FfTVBJMl9SQUlEX0RFRkFVTFRfSU9f
RlJBTUVfU0laRTsKKwlpb19yZXFfYmFzZV9waHlzID0gZnVzaW9uLT5pb19yZXF1ZXN0X2ZyYW1l
c19waHlzICsKKwkJTUVHQV9NUEkyX1JBSURfREVGQVVMVF9JT19GUkFNRV9TSVpFOworCisJLyoK
KwkgKiBBZGQgYWxsIHRoZSBjb21tYW5kcyB0byBjb21tYW5kIHBvb2wgKGZ1c2lvbi0+Y21kX3Bv
b2wpCisJICovCisKKwkvKiBTTUlEIDAgaXMgcmVzZXJ2ZWQuIFNldCBTTUlEL2luZGV4IGZyb20g
MSAqLworCWZvciAoaSA9IDA7IGkgPCBtYXhfY21kOyBpKyspIHsKKwkJY21kID0gZnVzaW9uLT5j
bWRfbGlzdFtpXTsKKwkJb2Zmc2V0ID0gTUVHQV9NUEkyX1JBSURfREVGQVVMVF9JT19GUkFNRV9T
SVpFICogaTsKKwkJbWVtc2V0KGNtZCwgMCwgc2l6ZW9mKHN0cnVjdCBtZWdhc2FzX2NtZF9mdXNp
b24pKTsKKwkJY21kLT5pbmRleCA9IGkgKyAxOworCQljbWQtPnNjbWQgPSBOVUxMOworCQljbWQt
PnN5bmNfY21kX2lkeCA9ICh1MzIpVUxPTkdfTUFYOyAvKiBTZXQgdG8gSW52YWxpZCAqLworCQlj
bWQtPmluc3RhbmNlID0gaW5zdGFuY2U7CisJCWNtZC0+aW9fcmVxdWVzdCA9CisJCQkoc3RydWN0
IE1QSTJfUkFJRF9TQ1NJX0lPX1JFUVVFU1QgKikKKwkJICAoaW9fcmVxX2Jhc2UgKyBvZmZzZXQp
OworCQltZW1zZXQoY21kLT5pb19yZXF1ZXN0LCAwLAorCQkgICAgICAgc2l6ZW9mKHN0cnVjdCBN
UEkyX1JBSURfU0NTSV9JT19SRVFVRVNUKSk7CisJCWNtZC0+aW9fcmVxdWVzdF9waHlzX2FkZHIg
PSBpb19yZXFfYmFzZV9waHlzICsgb2Zmc2V0OworCisJCWxpc3RfYWRkX3RhaWwoJmNtZC0+bGlz
dCwgJmZ1c2lvbi0+Y21kX3Bvb2wpOworCX0KKworCS8qCisJICogQ3JlYXRlIGEgZnJhbWUgcG9v
bCBhbmQgYXNzaWduIG9uZSBmcmFtZSB0byBlYWNoIGNtZAorCSAqLworCWlmIChtZWdhc2FzX2Ny
ZWF0ZV9mcmFtZV9wb29sX2Z1c2lvbihpbnN0YW5jZSkpIHsKKwkJcHJpbnRrKEtFUk5fREVCVUcg
Im1lZ2FzYXM6IEVycm9yIGNyZWF0aW5nIGZyYW1lIERNQSBwb29sXG4iKTsKKwkJbWVnYXNhc19m
cmVlX2NtZHNfZnVzaW9uKGluc3RhbmNlKTsKKwkJZ290byBmYWlsX3JlcV9kZXNjOworCX0KKwor
CXJldHVybiAwOworCitmYWlsX2NtZF9saXN0OgorCXBjaV9wb29sX2ZyZWUoZnVzaW9uLT5pb19y
ZXF1ZXN0X2ZyYW1lc19wb29sLCBmdXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzLAorCQkgICAgICBm
dXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzX3BoeXMpOworCXBjaV9wb29sX2Rlc3Ryb3koZnVzaW9u
LT5pb19yZXF1ZXN0X2ZyYW1lc19wb29sKTsKK2ZhaWxfaW9fZnJhbWVzOgorCWRtYV9mcmVlX2Nv
aGVyZW50KCZpbnN0YW5jZS0+cGRldi0+ZGV2LCBmdXNpb24tPnJlcXVlc3RfYWxsb2Nfc3osCisJ
CQkgIGZ1c2lvbi0+cmVwbHlfZnJhbWVzX2Rlc2MsCisJCQkgIGZ1c2lvbi0+cmVwbHlfZnJhbWVz
X2Rlc2NfcGh5cyk7CisJcGNpX3Bvb2xfZnJlZShmdXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjX3Bv
b2wsCisJCSAgICAgIGZ1c2lvbi0+cmVwbHlfZnJhbWVzX2Rlc2MsCisJCSAgICAgIGZ1c2lvbi0+
cmVwbHlfZnJhbWVzX2Rlc2NfcGh5cyk7CisJcGNpX3Bvb2xfZGVzdHJveShmdXNpb24tPnJlcGx5
X2ZyYW1lc19kZXNjX3Bvb2wpOworCitmYWlsX3JlcGx5X2Rlc2M6CisJZG1hX2ZyZWVfY29oZXJl
bnQoJmluc3RhbmNlLT5wZGV2LT5kZXYsIGZ1c2lvbi0+cmVxdWVzdF9hbGxvY19zeiwKKwkJCSAg
ZnVzaW9uLT5yZXFfZnJhbWVzX2Rlc2MsCisJCQkgIGZ1c2lvbi0+cmVxX2ZyYW1lc19kZXNjX3Bo
eXMpOworZmFpbF9yZXFfZGVzYzoKKwlyZXR1cm4gLUVOT01FTTsKK30KKworLyoqCisgKiB3YWl0
X2FuZF9wb2xsIC0JSXNzdWVzIGEgcG9sbGluZyBjb21tYW5kCisgKiBAaW5zdGFuY2U6CQkJQWRh
cHRlciBzb2Z0IHN0YXRlCisgKiBAY21kOgkJCUNvbW1hbmQgcGFja2V0IHRvIGJlIGlzc3VlZAor
ICoKKyAqIEZvciBwb2xsaW5nLCBNRkkgcmVxdWlyZXMgdGhlIGNtZF9zdGF0dXMgdG8gYmUgc2V0
IHRvIDB4RkYgYmVmb3JlIHBvc3RpbmcuCisgKi8KK2ludAord2FpdF9hbmRfcG9sbChzdHJ1Y3Qg
bWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kKQorewor
CWludCBpOworCXN0cnVjdCBtZWdhc2FzX2hlYWRlciAqZnJhbWVfaGRyID0gJmNtZC0+ZnJhbWUt
PmhkcjsKKworCXUzMiBtc2VjcyA9IE1GSV9QT0xMX1RJTUVPVVRfU0VDUyAqIDEwMDA7CisKKwkv
KgorCSAqIFdhaXQgZm9yIGNtZF9zdGF0dXMgdG8gY2hhbmdlCisJICovCisJZm9yIChpID0gMDsg
KGkgPCBtc2VjcykgJiYgKGZyYW1lX2hkci0+Y21kX3N0YXR1cyA9PSAweGZmKTsgaSArPSAyMCkg
eworCQlybWIoKTsKKwkJbXNsZWVwKDIwKTsKKwl9CisKKwlpZiAoZnJhbWVfaGRyLT5jbWRfc3Rh
dHVzID09IDB4ZmYpCisJCXJldHVybiAtRVRJTUU7CisKKwlyZXR1cm4gMDsKK30KKworLyoqCisg
KiBtZWdhc2FzX2lvY19pbml0X2Z1c2lvbiAtCUluaXRpYWxpemVzIHRoZSBGVworICogQGluc3Rh
bmNlOgkJQWRhcHRlciBzb2Z0IHN0YXRlCisgKgorICogSXNzdWVzIHRoZSBJT0MgSW5pdCBjbWQK
KyAqLworaW50CittZWdhc2FzX2lvY19pbml0X2Z1c2lvbihzdHJ1Y3QgbWVnYXNhc19pbnN0YW5j
ZSAqaW5zdGFuY2UpCit7CisJc3RydWN0IG1lZ2FzYXNfaW5pdF9mcmFtZSAqaW5pdF9mcmFtZTsK
KwlzdHJ1Y3QgTVBJMl9JT0NfSU5JVF9SRVFVRVNUICpJT0NJbml0TWVzc2FnZTsKKwlkbWFfYWRk
cl90CWlvY19pbml0X2hhbmRsZTsKKwl1MzIgY29udGV4dDsKKwlzdHJ1Y3QgbWVnYXNhc19jbWQg
KmNtZDsKKwl1OCByZXQ7CisJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb247CisJdW5pb24g
TUVHQVNBU19SRVFVRVNUX0RFU0NSSVBUT1JfVU5JT04gKnJlcV9kZXNjOworCWludCBpOworCXN0
cnVjdCBtZWdhc2FzX2hlYWRlciAqZnJhbWVfaGRyOworCisJZnVzaW9uID0gaW5zdGFuY2UtPmN0
cmxfY29udGV4dDsKKworCWNtZCA9IG1lZ2FzYXNfZ2V0X2NtZChpbnN0YW5jZSk7CisKKwlpZiAo
IWNtZCkgeworCQlwcmludGsoS0VSTl9FUlIgIkNvdWxkIG5vdCBhbGxvY2F0ZSBjbWQgZm9yIElO
SVQgRnJhbWVcbiIpOworCQlyZXQgPSAxOworCQlnb3RvIGZhaWxfZ2V0X2NtZDsKKwl9CisKKwlJ
T0NJbml0TWVzc2FnZSA9CisJICBkbWFfYWxsb2NfY29oZXJlbnQoJmluc3RhbmNlLT5wZGV2LT5k
ZXYsCisJCQkgICAgIHNpemVvZihzdHJ1Y3QgTVBJMl9JT0NfSU5JVF9SRVFVRVNUKSwKKwkJCSAg
ICAgJmlvY19pbml0X2hhbmRsZSwgR0ZQX0tFUk5FTCk7CisKKwlpZiAoIUlPQ0luaXRNZXNzYWdl
KSB7CisJCXByaW50ayhLRVJOX0VSUiAiQ291bGQgbm90IGFsbG9jYXRlIG1lbW9yeSBmb3IgIgor
CQkgICAgICAgIklPQ0luaXRNZXNzYWdlXG4iKTsKKwkJcmV0ID0gMTsKKwkJZ290byBmYWlsX2Z3
X2luaXQ7CisJfQorCisJbWVtc2V0KElPQ0luaXRNZXNzYWdlLCAwLCBzaXplb2Yoc3RydWN0IE1Q
STJfSU9DX0lOSVRfUkVRVUVTVCkpOworCisJSU9DSW5pdE1lc3NhZ2UtPkZ1bmN0aW9uID0gTVBJ
Ml9GVU5DVElPTl9JT0NfSU5JVDsKKwlJT0NJbml0TWVzc2FnZS0+V2hvSW5pdAk9IE1QSTJfV0hP
SU5JVF9IT1NUX0RSSVZFUjsKKwlJT0NJbml0TWVzc2FnZS0+TXNnVmVyc2lvbiA9IE1QSTJfVkVS
U0lPTjsKKwlJT0NJbml0TWVzc2FnZS0+SGVhZGVyVmVyc2lvbiA9IE1QSTJfSEVBREVSX1ZFUlNJ
T047CisJSU9DSW5pdE1lc3NhZ2UtPlN5c3RlbVJlcXVlc3RGcmFtZVNpemUgPQorCQlNRUdBX01Q
STJfUkFJRF9ERUZBVUxUX0lPX0ZSQU1FX1NJWkUgLyA0OworCisJSU9DSW5pdE1lc3NhZ2UtPlJl
cGx5RGVzY3JpcHRvclBvc3RRdWV1ZURlcHRoID0gZnVzaW9uLT5yZXBseV9xX2RlcHRoOworCUlP
Q0luaXRNZXNzYWdlLT5SZXBseURlc2NyaXB0b3JQb3N0UXVldWVBZGRyZXNzCT0KKwkJZnVzaW9u
LT5yZXBseV9mcmFtZXNfZGVzY19waHlzOworCUlPQ0luaXRNZXNzYWdlLT5TeXN0ZW1SZXF1ZXN0
RnJhbWVCYXNlQWRkcmVzcyA9CisJCWZ1c2lvbi0+aW9fcmVxdWVzdF9mcmFtZXNfcGh5czsKKwor
CWluaXRfZnJhbWUgPSAoc3RydWN0IG1lZ2FzYXNfaW5pdF9mcmFtZSAqKWNtZC0+ZnJhbWU7CisJ
bWVtc2V0KGluaXRfZnJhbWUsIDAsIE1FR0FNRklfRlJBTUVfU0laRSk7CisKKwlmcmFtZV9oZHIg
PSAmY21kLT5mcmFtZS0+aGRyOworCWNvbnRleHQgPSBpbml0X2ZyYW1lLT5jb250ZXh0OworCWlu
aXRfZnJhbWUtPmNvbnRleHQgPSBjb250ZXh0OworCisJZnJhbWVfaGRyLT5jbWRfc3RhdHVzID0g
MHhGRjsKKwlmcmFtZV9oZHItPmZsYWdzIHw9IE1GSV9GUkFNRV9ET05UX1BPU1RfSU5fUkVQTFlf
UVVFVUU7CisKKwlpbml0X2ZyYW1lLT5jbWQJPSBNRklfQ01EX0lOSVQ7CisJaW5pdF9mcmFtZS0+
Y21kX3N0YXR1cyA9IDB4RkY7CisKKwlpbml0X2ZyYW1lLT5xdWV1ZV9pbmZvX25ld19waHlzX2Fk
ZHJfbG8gPSBpb2NfaW5pdF9oYW5kbGU7CisJaW5pdF9mcmFtZS0+ZGF0YV94ZmVyX2xlbiA9IHNp
emVvZihzdHJ1Y3QgTVBJMl9JT0NfSU5JVF9SRVFVRVNUKTsKKworCXJlcV9kZXNjID0KKwkgICh1
bmlvbiBNRUdBU0FTX1JFUVVFU1RfREVTQ1JJUFRPUl9VTklPTiAqKWZ1c2lvbi0+cmVxX2ZyYW1l
c19kZXNjOworCisJcmVxX2Rlc2MtPldvcmRzID0gY21kLT5mcmFtZV9waHlzX2FkZHI7CisJcmVx
X2Rlc2MtPk1GQUlvLlJlcXVlc3RGbGFncyA9CisJCShNRUdBU0FTX1JFUV9ERVNDUklQVF9GTEFH
U19NRkEgPDwKKwkJIE1FR0FTQVNfUkVRX0RFU0NSSVBUX0ZMQUdTX1RZUEVfU0hJRlQpOworCisJ
LyoKKwkgKiBkaXNhYmxlIHRoZSBpbnRyIGJlZm9yZSBmaXJpbmcgdGhlIGluaXQgZnJhbWUKKwkg
Ki8KKwlpbnN0YW5jZS0+aW5zdGFuY2V0LT5kaXNhYmxlX2ludHIoaW5zdGFuY2UtPnJlZ19zZXQp
OworCisJZm9yIChpID0gMDsgaSA8ICgxMCAqIDEwMDApOyBpICs9IDIwKSB7CisJCWlmIChyZWFk
bCgmaW5zdGFuY2UtPnJlZ19zZXQtPmRvb3JiZWxsKSAmIDEpCisJCQltc2xlZXAoMjApOworCQll
bHNlCisJCQlicmVhazsKKwl9CisKKwlpbnN0YW5jZS0+aW5zdGFuY2V0LT5maXJlX2NtZChpbnN0
YW5jZSwgcmVxX2Rlc2MtPnUubG93LAorCQkJCSAgICAgIHJlcV9kZXNjLT51LmhpZ2gsIGluc3Rh
bmNlLT5yZWdfc2V0KTsKKworCXdhaXRfYW5kX3BvbGwoaW5zdGFuY2UsIGNtZCk7CisKKwlmcmFt
ZV9oZHIgPSAmY21kLT5mcmFtZS0+aGRyOworCWlmIChmcmFtZV9oZHItPmNtZF9zdGF0dXMgIT0g
MCkgeworCQlyZXQgPSAxOworCQlnb3RvIGZhaWxfZndfaW5pdDsKKwl9CisJcHJpbnRrKEtFUk5f
RVJSICJtZWdhc2FzOklPQyBJbml0IGNtZCBzdWNjZXNzXG4iKTsKKworCXJldCA9IDA7CisKK2Zh
aWxfZndfaW5pdDoKKwltZWdhc2FzX3JldHVybl9jbWQoaW5zdGFuY2UsIGNtZCk7CisJaWYgKElP
Q0luaXRNZXNzYWdlKQorCQlkbWFfZnJlZV9jb2hlcmVudCgmaW5zdGFuY2UtPnBkZXYtPmRldiwK
KwkJCQkgIHNpemVvZihzdHJ1Y3QgTVBJMl9JT0NfSU5JVF9SRVFVRVNUKSwKKwkJCQkgIElPQ0lu
aXRNZXNzYWdlLCBpb2NfaW5pdF9oYW5kbGUpOworZmFpbF9nZXRfY21kOgorCXJldHVybiByZXQ7
Cit9CisKKy8qCisgKiBtZWdhc2FzX3JldHVybl9jbWRfZm9yX3NtaWQgLQlSZXR1cm5zIGEgY21k
X2Z1c2lvbiBmb3IgYSBTTUlECisgKiBAaW5zdGFuY2U6CQkJCUFkYXB0ZXIgc29mdCBzdGF0ZQor
ICoKKyAqLwordm9pZAorbWVnYXNhc19yZXR1cm5fY21kX2Zvcl9zbWlkKHN0cnVjdCBtZWdhc2Fz
X2luc3RhbmNlICppbnN0YW5jZSwgdTE2IHNtaWQpCit7CisJc3RydWN0IGZ1c2lvbl9jb250ZXh0
ICpmdXNpb247CisJc3RydWN0IG1lZ2FzYXNfY21kX2Z1c2lvbiAqY21kOworCisJZnVzaW9uID0g
aW5zdGFuY2UtPmN0cmxfY29udGV4dDsKKwljbWQgPSBmdXNpb24tPmNtZF9saXN0W3NtaWQgLSAx
XTsKKwltZWdhc2FzX3JldHVybl9jbWRfZnVzaW9uKGluc3RhbmNlLCBjbWQpOworfQorCisvKgor
ICogbWVnYXNhc19nZXRfbGRfbWFwX2luZm8gLQlSZXR1cm5zIEZXJ3MgbGRfbWFwIHN0cnVjdHVy
ZQorICogQGluc3RhbmNlOgkJCQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAqIEBwZW5kOgkJCQlQZW5k
IHRoZSBjb21tYW5kIG9yIG5vdAorICogSXNzdWVzIGFuIGludGVybmFsIGNvbW1hbmQgKERDTUQp
IHRvIGdldCB0aGUgRlcncyBjb250cm9sbGVyIFBECisgKiBsaXN0IHN0cnVjdHVyZS4gIFRoaXMg
aW5mb3JtYXRpb24gaXMgbWFpbmx5IHVzZWQgdG8gZmluZCBvdXQgU1lTVEVNCisgKiBzdXBwb3J0
ZWQgYnkgdGhlIEZXLgorICovCitzdGF0aWMgaW50CittZWdhc2FzX2dldF9sZF9tYXBfaW5mbyhz
dHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCit7CisJaW50IHJldCA9IDA7CisJc3Ry
dWN0IG1lZ2FzYXNfY21kICpjbWQ7CisJc3RydWN0IG1lZ2FzYXNfZGNtZF9mcmFtZSAqZGNtZDsK
KwlzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICpjaTsKKwlkbWFfYWRkcl90IGNpX2ggPSAwOwor
CXUzMiBzaXplX21hcF9pbmZvOworCXN0cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uOworCisJ
Y21kID0gbWVnYXNhc19nZXRfY21kKGluc3RhbmNlKTsKKworCWlmICghY21kKSB7CisJCXByaW50
ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBGYWlsZWQgdG8gZ2V0IGNtZCBmb3IgbWFwIGluZm8uXG4i
KTsKKwkJcmV0dXJuIC1FTk9NRU07CisJfQorCisJZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxfY29u
dGV4dDsKKworCWlmICghZnVzaW9uKSB7CisJCW1lZ2FzYXNfcmV0dXJuX2NtZChpbnN0YW5jZSwg
Y21kKTsKKwkJcmV0dXJuIDE7CisJfQorCisJZGNtZCA9ICZjbWQtPmZyYW1lLT5kY21kOworCisJ
c2l6ZV9tYXBfaW5mbyA9IHNpemVvZihzdHJ1Y3QgTVJfRldfUkFJRF9NQVApICsKKwkJKHNpemVv
ZihzdHJ1Y3QgTVJfTERfU1BBTl9NQVApICooTUFYX0xPR0lDQUxfRFJJVkVTIC0gMSkpOworCisJ
Y2kgPSBmdXNpb24tPmxkX21hcFsoaW5zdGFuY2UtPm1hcF9pZCAmIDEpXTsKKwljaV9oID0gZnVz
aW9uLT5sZF9tYXBfcGh5c1soaW5zdGFuY2UtPm1hcF9pZCAmIDEpXTsKKworCWlmICghY2kpIHsK
KwkJcHJpbnRrKEtFUk5fREVCVUcgIkZhaWxlZCB0byBhbGxvYyBtZW0gZm9yIGxkX21hcF9pbmZv
XG4iKTsKKwkJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNlLCBjbWQpOworCQlyZXR1cm4gLUVO
T01FTTsKKwl9CisKKwltZW1zZXQoY2ksIDAsIHNpemVvZigqY2kpKTsKKwltZW1zZXQoZGNtZC0+
bWJveC5iLCAwLCBNRklfTUJPWF9TSVpFKTsKKworCWRjbWQtPmNtZCA9IE1GSV9DTURfRENNRDsK
KwlkY21kLT5jbWRfc3RhdHVzID0gMHhGRjsKKwlkY21kLT5zZ2VfY291bnQgPSAxOworCWRjbWQt
PmZsYWdzID0gTUZJX0ZSQU1FX0RJUl9SRUFEOworCWRjbWQtPnRpbWVvdXQgPSAwOworCWRjbWQt
PnBhZF8wID0gMDsKKwlkY21kLT5kYXRhX3hmZXJfbGVuID0gc2l6ZV9tYXBfaW5mbzsKKwlkY21k
LT5vcGNvZGUgPSBNUl9EQ01EX0xEX01BUF9HRVRfSU5GTzsKKwlkY21kLT5zZ2wuc2dlMzJbMF0u
cGh5c19hZGRyID0gY2lfaDsKKwlkY21kLT5zZ2wuc2dlMzJbMF0ubGVuZ3RoID0gc2l6ZV9tYXBf
aW5mbzsKKworCWlmICghbWVnYXNhc19pc3N1ZV9wb2xsZWQoaW5zdGFuY2UsIGNtZCkpCisJCXJl
dCA9IDA7CisJZWxzZSB7CisJCXByaW50ayhLRVJOX0VSUiAibWVnYXNhczogR2V0IExEIE1hcCBJ
bmZvIEZhaWxlZFxuIik7CisJCXJldCA9IC0xOworCX0KKworCW1lZ2FzYXNfcmV0dXJuX2NtZChp
bnN0YW5jZSwgY21kKTsKKworCXJldHVybiByZXQ7Cit9CisKK3U4CittZWdhc2FzX2dldF9tYXBf
aW5mbyhzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCit7CisJc3RydWN0IGZ1c2lv
bl9jb250ZXh0ICpmdXNpb24gPSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0OworCisJZnVzaW9uLT5m
YXN0X3BhdGhfaW8gPSAwOworCWlmICghbWVnYXNhc19nZXRfbGRfbWFwX2luZm8oaW5zdGFuY2Up
KSB7CisJCWlmIChNUl9WYWxpZGF0ZU1hcEluZm8oZnVzaW9uLT5sZF9tYXBbKGluc3RhbmNlLT5t
YXBfaWQgJiAxKV0sCisJCQkJICAgICAgIGZ1c2lvbi0+bG9hZF9iYWxhbmNlX2luZm8pKSB7CisJ
CQlmdXNpb24tPmZhc3RfcGF0aF9pbyA9IDE7CisJCQlyZXR1cm4gMDsKKwkJfQorCX0KKwlyZXR1
cm4gMTsKK30KKworLyoKKyAqIG1lZ2FzYXNfc3luY19tYXBfaW5mbyAtCVJldHVybnMgRlcncyBs
ZF9tYXAgc3RydWN0dXJlCisgKiBAaW5zdGFuY2U6CQkJCUFkYXB0ZXIgc29mdCBzdGF0ZQorICoK
KyAqIElzc3VlcyBhbiBpbnRlcm5hbCBjb21tYW5kIChEQ01EKSB0byBnZXQgdGhlIEZXJ3MgY29u
dHJvbGxlciBQRAorICogbGlzdCBzdHJ1Y3R1cmUuICBUaGlzIGluZm9ybWF0aW9uIGlzIG1haW5s
eSB1c2VkIHRvIGZpbmQgb3V0IFNZU1RFTQorICogc3VwcG9ydGVkIGJ5IHRoZSBGVy4KKyAqLwor
aW50CittZWdhc2FzX3N5bmNfbWFwX2luZm8oc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3Rh
bmNlKQoreworCWludCByZXQgPSAwLCBpOworCXN0cnVjdCBtZWdhc2FzX2NtZCAqY21kOworCXN0
cnVjdCBtZWdhc2FzX2RjbWRfZnJhbWUgKmRjbWQ7CisJdTMyIHNpemVfc3luY19pbmZvLCBudW1f
bGRzOworCXN0cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uOworCXN0cnVjdCBNUl9MRF9UQVJH
RVRfU1lOQyAqY2kgPSBOVUxMOworCXN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcDsKKwlz
dHJ1Y3QgTVJfTERfUkFJRCAgKnJhaWQ7CisJc3RydWN0IE1SX0xEX1RBUkdFVF9TWU5DICpsZF9z
eW5jOworCWRtYV9hZGRyX3QgY2lfaCA9IDA7CisJdTMyIHNpemVfbWFwX2luZm87CisKKwljbWQg
PSBtZWdhc2FzX2dldF9jbWQoaW5zdGFuY2UpOworCisJaWYgKCFjbWQpIHsKKwkJcHJpbnRrKEtF
Uk5fREVCVUcgIm1lZ2FzYXM6IEZhaWxlZCB0byBnZXQgY21kIGZvciBzeW5jIgorCQkgICAgICAg
ImluZm8uXG4iKTsKKwkJcmV0dXJuIC1FTk9NRU07CisJfQorCisJZnVzaW9uID0gaW5zdGFuY2Ut
PmN0cmxfY29udGV4dDsKKworCWlmICghZnVzaW9uKSB7CisJCW1lZ2FzYXNfcmV0dXJuX2NtZChp
bnN0YW5jZSwgY21kKTsKKwkJcmV0dXJuIDE7CisJfQorCisJbWFwID0gZnVzaW9uLT5sZF9tYXBb
aW5zdGFuY2UtPm1hcF9pZCAmIDFdOworCisJbnVtX2xkcyA9IG1hcC0+cmFpZE1hcC5sZENvdW50
OworCisJZGNtZCA9ICZjbWQtPmZyYW1lLT5kY21kOworCisJc2l6ZV9zeW5jX2luZm8gPSBzaXpl
b2Yoc3RydWN0IE1SX0xEX1RBUkdFVF9TWU5DKSAqbnVtX2xkczsKKworCW1lbXNldChkY21kLT5t
Ym94LmIsIDAsIE1GSV9NQk9YX1NJWkUpOworCisJY2kgPSAoc3RydWN0IE1SX0xEX1RBUkdFVF9T
WU5DICopCisJICBmdXNpb24tPmxkX21hcFsoaW5zdGFuY2UtPm1hcF9pZCAtIDEpICYgMV07CisJ
bWVtc2V0KGNpLCAwLCBzaXplb2Yoc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCkpOworCisJY2lf
aCA9IGZ1c2lvbi0+bGRfbWFwX3BoeXNbKGluc3RhbmNlLT5tYXBfaWQgLSAxKSAmIDFdOworCisJ
bGRfc3luYyA9IChzdHJ1Y3QgTVJfTERfVEFSR0VUX1NZTkMgKiljaTsKKworCWZvciAoaSA9IDA7
IGkgPCBudW1fbGRzOyBpKyssIGxkX3N5bmMrKykgeworCQlyYWlkID0gTVJfTGRSYWlkR2V0KGks
IG1hcCk7CisJCWxkX3N5bmMtPnRhcmdldElkID0gTVJfR2V0TERUZ3RJZChpLCBtYXApOworCQls
ZF9zeW5jLT5zZXFOdW0gPSByYWlkLT5zZXFOdW07CisJfQorCisJc2l6ZV9tYXBfaW5mbyA9IHNp
emVvZihzdHJ1Y3QgTVJfRldfUkFJRF9NQVApICsKKwkJKHNpemVvZihzdHJ1Y3QgTVJfTERfU1BB
Tl9NQVApICooTUFYX0xPR0lDQUxfRFJJVkVTIC0gMSkpOworCisJZGNtZC0+Y21kID0gTUZJX0NN
RF9EQ01EOworCWRjbWQtPmNtZF9zdGF0dXMgPSAweEZGOworCWRjbWQtPnNnZV9jb3VudCA9IDE7
CisJZGNtZC0+ZmxhZ3MgPSBNRklfRlJBTUVfRElSX1dSSVRFOworCWRjbWQtPnRpbWVvdXQgPSAw
OworCWRjbWQtPnBhZF8wID0gMDsKKwlkY21kLT5kYXRhX3hmZXJfbGVuID0gc2l6ZV9tYXBfaW5m
bzsKKwlkY21kLT5tYm94LmJbMF0gPSBudW1fbGRzOworCWRjbWQtPm1ib3guYlsxXSA9IE1FR0FT
QVNfRENNRF9NQk9YX1BFTkRfRkxBRzsKKwlkY21kLT5vcGNvZGUgPSBNUl9EQ01EX0xEX01BUF9H
RVRfSU5GTzsKKwlkY21kLT5zZ2wuc2dlMzJbMF0ucGh5c19hZGRyID0gY2lfaDsKKwlkY21kLT5z
Z2wuc2dlMzJbMF0ubGVuZ3RoID0gc2l6ZV9tYXBfaW5mbzsKKworCWluc3RhbmNlLT5tYXBfdXBk
YXRlX2NtZCA9IGNtZDsKKworCWluc3RhbmNlLT5pbnN0YW5jZXQtPmlzc3VlX2RjbWQoaW5zdGFu
Y2UsIGNtZCk7CisKKwlyZXR1cm4gcmV0OworfQorCisvKioKKyAqIG1lZ2FzYXNfaW5pdF9hZGFw
dGVyX2Z1c2lvbiAtCUluaXRpYWxpemVzIHRoZSBGVworICogQGluc3RhbmNlOgkJQWRhcHRlciBz
b2Z0IHN0YXRlCisgKgorICogVGhpcyBpcyB0aGUgbWFpbiBmdW5jdGlvbiBmb3IgaW5pdGlhbGl6
aW5nIGZpcm13YXJlLgorICovCit1MzIKK21lZ2FzYXNfaW5pdF9hZGFwdGVyX2Z1c2lvbihzdHJ1
Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCit7CisJc3RydWN0IG1lZ2FzYXNfcmVnaXN0
ZXJfc2V0IF9faW9tZW0gKnJlZ19zZXQ7CisJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb247
CisJdTMyIG1heF9jbWQ7CisJaW50IGkgPSAwOworCisJZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxf
Y29udGV4dDsKKworCXJlZ19zZXQgPSBpbnN0YW5jZS0+cmVnX3NldDsKKworCS8qCisJICogR2V0
IHZhcmlvdXMgb3BlcmF0aW9uYWwgcGFyYW1ldGVycyBmcm9tIHN0YXR1cyByZWdpc3RlcgorCSAq
LworCWluc3RhbmNlLT5tYXhfZndfY21kcyA9CisJCWluc3RhbmNlLT5pbnN0YW5jZXQtPnJlYWRf
Zndfc3RhdHVzX3JlZyhyZWdfc2V0KSAmIDB4MDBGRkZGOworCWluc3RhbmNlLT5tYXhfZndfY21k
cyA9IG1pbihpbnN0YW5jZS0+bWF4X2Z3X2NtZHMsICh1MTYpMTAwOCk7CisKKwkvKgorCSAqIFJl
ZHVjZSB0aGUgbWF4IHN1cHBvcnRlZCBjbWRzIGJ5IDEuIFRoaXMgaXMgdG8gZW5zdXJlIHRoYXQg
dGhlCisJICogcmVwbHlfcV9zeiAoMSBtb3JlIHRoYW4gdGhlIG1heCBjbWQgdGhhdCBkcml2ZXIg
bWF5IHNlbmQpCisJICogZG9lcyBub3QgZXhjZWVkIG1heCBjbWRzIHRoYXQgdGhlIEZXIGNhbiBz
dXBwb3J0CisJICovCisJaW5zdGFuY2UtPm1heF9md19jbWRzID0gaW5zdGFuY2UtPm1heF9md19j
bWRzLTE7CisJLyogT25seSBpbnRlcm5hbCBjbWRzIChEQ01EKSBuZWVkIHRvIGhhdmUgTUZJIGZy
YW1lcyAqLworCWluc3RhbmNlLT5tYXhfbWZpX2NtZHMgPSBNRUdBU0FTX0lOVF9DTURTOworCisJ
bWF4X2NtZCA9IGluc3RhbmNlLT5tYXhfZndfY21kczsKKworCWZ1c2lvbi0+cmVwbHlfcV9kZXB0
aCA9ICgobWF4X2NtZCArIDEgKyAxNSkvMTYpKjE2OworCisJZnVzaW9uLT5yZXF1ZXN0X2FsbG9j
X3N6ID0KKwkJc2l6ZW9mKHVuaW9uIE1FR0FTQVNfUkVRVUVTVF9ERVNDUklQVE9SX1VOSU9OKSAq
bWF4X2NtZDsKKwlmdXNpb24tPnJlcGx5X2FsbG9jX3N6ID0gc2l6ZW9mKHVuaW9uIE1QSTJfUkVQ
TFlfREVTQ1JJUFRPUlNfVU5JT04pCisJCSooZnVzaW9uLT5yZXBseV9xX2RlcHRoKTsKKwlmdXNp
b24tPmlvX2ZyYW1lc19hbGxvY19zeiA9IE1FR0FfTVBJMl9SQUlEX0RFRkFVTFRfSU9fRlJBTUVf
U0laRSArCisJCShNRUdBX01QSTJfUkFJRF9ERUZBVUxUX0lPX0ZSQU1FX1NJWkUgKgorCQkgKG1h
eF9jbWQgKyAxKSk7IC8qIEV4dHJhIDEgZm9yIFNNSUQgMCAqLworCisJZnVzaW9uLT5tYXhfc2dl
X2luX21haW5fbXNnID0KKwkgIChNRUdBX01QSTJfUkFJRF9ERUZBVUxUX0lPX0ZSQU1FX1NJWkUg
LQorCSAgIG9mZnNldG9mKHN0cnVjdCBNUEkyX1JBSURfU0NTSV9JT19SRVFVRVNULCBTR0wpKS8x
NjsKKworCWZ1c2lvbi0+bWF4X3NnZV9pbl9jaGFpbiA9CisJCU1FR0FTQVNfTUFYX1NaX0NIQUlO
X0ZSQU1FIC8gc2l6ZW9mKHVuaW9uIE1QSTJfU0dFX0lPX1VOSU9OKTsKKworCWluc3RhbmNlLT5t
YXhfbnVtX3NnZSA9IGZ1c2lvbi0+bWF4X3NnZV9pbl9tYWluX21zZyArCisJCWZ1c2lvbi0+bWF4
X3NnZV9pbl9jaGFpbiAtIDI7CisKKwkvKiBVc2VkIGZvciBwYXNzIHRocnUgTUZJIGZyYW1lIChE
Q01EKSAqLworCWZ1c2lvbi0+Y2hhaW5fb2Zmc2V0X21maV9wdGhydSA9CisJCW9mZnNldG9mKHN0
cnVjdCBNUEkyX1JBSURfU0NTSV9JT19SRVFVRVNULCBTR0wpLzE2OworCisJZnVzaW9uLT5jaGFp
bl9vZmZzZXRfaW9fcmVxdWVzdCA9CisJCShNRUdBX01QSTJfUkFJRF9ERUZBVUxUX0lPX0ZSQU1F
X1NJWkUgLQorCQkgc2l6ZW9mKHVuaW9uIE1QSTJfU0dFX0lPX1VOSU9OKSkvMTY7CisKKwlmdXNp
b24tPmxhc3RfcmVwbHlfaWR4ID0gMDsKKworCS8qCisJICogQWxsb2NhdGUgbWVtb3J5IGZvciBk
ZXNjcmlwdG9ycworCSAqIENyZWF0ZSBhIHBvb2wgb2YgY29tbWFuZHMKKwkgKi8KKwlpZiAobWVn
YXNhc19hbGxvY19jbWRzKGluc3RhbmNlKSkKKwkJZ290byBmYWlsX2FsbG9jX21maV9jbWRzOwor
CWlmIChtZWdhc2FzX2FsbG9jX2NtZHNfZnVzaW9uKGluc3RhbmNlKSkKKwkJZ290byBmYWlsX2Fs
bG9jX2NtZHM7CisKKwlpZiAobWVnYXNhc19pb2NfaW5pdF9mdXNpb24oaW5zdGFuY2UpKQorCQln
b3RvIGZhaWxfaW9jX2luaXQ7CisKKwlpbnN0YW5jZS0+ZmxhZ19pZWVlID0gMTsKKworCWZ1c2lv
bi0+bWFwX3N6ID0gIHNpemVvZihzdHJ1Y3QgTVJfRldfUkFJRF9NQVApICsKKwkgIChzaXplb2Yo
c3RydWN0IE1SX0xEX1NQQU5fTUFQKSAqKE1BWF9MT0dJQ0FMX0RSSVZFUyAtIDEpKTsKKworCWZ1
c2lvbi0+ZmFzdF9wYXRoX2lvID0gMDsKKworCWZvciAoaSA9IDA7IGkgPCAyOyBpKyspIHsKKwkJ
ZnVzaW9uLT5sZF9tYXBbaV0gPSBkbWFfYWxsb2NfY29oZXJlbnQoJmluc3RhbmNlLT5wZGV2LT5k
ZXYsCisJCQkJCQkgICAgICAgZnVzaW9uLT5tYXBfc3osCisJCQkJCQkgICAgICAgJmZ1c2lvbi0+
bGRfbWFwX3BoeXNbaV0sCisJCQkJCQkgICAgICAgR0ZQX0tFUk5FTCk7CisJCWlmICghZnVzaW9u
LT5sZF9tYXBbaV0pIHsKKwkJCXByaW50ayhLRVJOX0VSUiAibWVnYXNhczogQ291bGQgbm90IGFs
bG9jYXRlIG1lbW9yeSAiCisJCQkgICAgICAgImZvciBtYXAgaW5mb1xuIik7CisJCQlnb3RvIGZh
aWxfbWFwX2luZm87CisJCX0KKwl9CisKKwlpZiAoIW1lZ2FzYXNfZ2V0X21hcF9pbmZvKGluc3Rh
bmNlKSkKKwkJbWVnYXNhc19zeW5jX21hcF9pbmZvKGluc3RhbmNlKTsKKworCXJldHVybiAwOwor
CitmYWlsX2FsbG9jX2NtZHM6CitmYWlsX2FsbG9jX21maV9jbWRzOgorZmFpbF9tYXBfaW5mbzoK
KwlpZiAoaSA9PSAxKQorCQlkbWFfZnJlZV9jb2hlcmVudCgmaW5zdGFuY2UtPnBkZXYtPmRldiwg
ZnVzaW9uLT5tYXBfc3osCisJCQkJICBmdXNpb24tPmxkX21hcFswXSwgZnVzaW9uLT5sZF9tYXBf
cGh5c1swXSk7CitmYWlsX2lvY19pbml0OgorCXJldHVybiAxOworfQorCisvKioKKyAqIG1lZ2Fz
YXNfZmlyZV9jbWRfZnVzaW9uIC0JU2VuZHMgY29tbWFuZCB0byB0aGUgRlcKKyAqIEBmcmFtZV9w
aHlzX2FkZHIgOgkJUGh5c2ljYWwgYWRkcmVzcyBvZiBjbWQKKyAqIEBmcmFtZV9jb3VudCA6CQlO
dW1iZXIgb2YgZnJhbWVzIGZvciB0aGUgY29tbWFuZAorICogQHJlZ3MgOgkJCU1GSSByZWdpc3Rl
ciBzZXQKKyAqLwordm9pZAorbWVnYXNhc19maXJlX2NtZF9mdXNpb24oc3RydWN0IG1lZ2FzYXNf
aW5zdGFuY2UgKmluc3RhbmNlLAorCQkJZG1hX2FkZHJfdCByZXFfZGVzY19sbywKKwkJCXUzMiBy
ZXFfZGVzY19oaSwKKwkJCXN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdz
KQoreworCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CisKKwlzcGluX2xvY2tfaXJxc2F2ZSgmaW5zdGFu
Y2UtPmhiYV9sb2NrLCBmbGFncyk7CisKKwl3cml0ZWwocmVxX2Rlc2NfbG8sCisJICAgICAgICYo
cmVncyktPmluYm91bmRfbG93X3F1ZXVlX3BvcnQpOworCXdyaXRlbChyZXFfZGVzY19oaSwgJihy
ZWdzKS0+aW5ib3VuZF9oaWdoX3F1ZXVlX3BvcnQpOworCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
Jmluc3RhbmNlLT5oYmFfbG9jaywgZmxhZ3MpOworfQorCisvKioKKyAqIG1hcF9jbWRfc3RhdHVz
IC0JTWFwcyBGVyBjbWQgc3RhdHVzIHRvIE9TIGNtZCBzdGF0dXMKKyAqIEBjbWQgOgkJUG9pbnRl
ciB0byBjbWQKKyAqIEBzdGF0dXMgOgkJc3RhdHVzIG9mIGNtZCByZXR1cm5lZCBieSBGVworICog
QGV4dF9zdGF0dXMgOglleHQgc3RhdHVzIG9mIGNtZCByZXR1cm5lZCBieSBGVworICovCisKK3Zv
aWQKK21hcF9jbWRfc3RhdHVzKHN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24gKmNtZCwgdTggc3Rh
dHVzLCB1OCBleHRfc3RhdHVzKQoreworCisJc3dpdGNoIChzdGF0dXMpIHsKKworCWNhc2UgTUZJ
X1NUQVRfT0s6CisJCWNtZC0+c2NtZC0+cmVzdWx0ID0gRElEX09LIDw8IDE2OworCQlicmVhazsK
KworCWNhc2UgTUZJX1NUQVRfU0NTSV9JT19GQUlMRUQ6CisJY2FzZSBNRklfU1RBVF9MRF9JTklU
X0lOX1BST0dSRVNTOgorCQljbWQtPnNjbWQtPnJlc3VsdCA9IChESURfRVJST1IgPDwgMTYpIHwg
ZXh0X3N0YXR1czsKKwkJYnJlYWs7CisKKwljYXNlIE1GSV9TVEFUX1NDU0lfRE9ORV9XSVRIX0VS
Uk9SOgorCisJCWNtZC0+c2NtZC0+cmVzdWx0ID0gKERJRF9PSyA8PCAxNikgfCBleHRfc3RhdHVz
OworCQlpZiAoZXh0X3N0YXR1cyA9PSBTQU1fU1RBVF9DSEVDS19DT05ESVRJT04pIHsKKwkJCW1l
bXNldChjbWQtPnNjbWQtPnNlbnNlX2J1ZmZlciwgMCwKKwkJCSAgICAgICBTQ1NJX1NFTlNFX0JV
RkZFUlNJWkUpOworCQkJbWVtY3B5KGNtZC0+c2NtZC0+c2Vuc2VfYnVmZmVyLCBjbWQtPnNlbnNl
LAorCQkJICAgICAgIFNDU0lfU0VOU0VfQlVGRkVSU0laRSk7CisJCQljbWQtPnNjbWQtPnJlc3Vs
dCB8PSBEUklWRVJfU0VOU0UgPDwgMjQ7CisJCX0KKwkJYnJlYWs7CisKKwljYXNlIE1GSV9TVEFU
X0xEX09GRkxJTkU6CisJY2FzZSBNRklfU1RBVF9ERVZJQ0VfTk9UX0ZPVU5EOgorCQljbWQtPnNj
bWQtPnJlc3VsdCA9IERJRF9CQURfVEFSR0VUIDw8IDE2OworCQlicmVhazsKKworCWRlZmF1bHQ6
CisJCXByaW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBGVyBzdGF0dXMgJSN4XG4iLCBzdGF0dXMp
OworCQljbWQtPnNjbWQtPnJlc3VsdCA9IERJRF9FUlJPUiA8PCAxNjsKKwkJYnJlYWs7CisJfQor
fQorCisvKioKKyAqIG1lZ2FzYXNfbWFrZV9zZ2xfZnVzaW9uIC0JUHJlcGFyZXMgMzItYml0IFNH
TAorICogQGluc3RhbmNlOgkJQWRhcHRlciBzb2Z0IHN0YXRlCisgKiBAc2NwOgkJU0NTSSBjb21t
YW5kIGZyb20gdGhlIG1pZC1sYXllcgorICogQHNnbF9wdHI6CQlTR0wgdG8gYmUgZmlsbGVkIGlu
CisgKiBAY21kOgkJY21kIHdlIGFyZSB3b3JraW5nIG9uCisgKgorICogSWYgc3VjY2Vzc2Z1bCwg
dGhpcyBmdW5jdGlvbiByZXR1cm5zIHRoZSBudW1iZXIgb2YgU0cgZWxlbWVudHMuCisgKi8KK3N0
YXRpYyBpbnQKK21lZ2FzYXNfbWFrZV9zZ2xfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNl
ICppbnN0YW5jZSwKKwkJCXN0cnVjdCBzY3NpX2NtbmQgKnNjcCwKKwkJCXN0cnVjdCBNUEkyNV9J
RUVFX1NHRV9DSEFJTjY0ICpzZ2xfcHRyLAorCQkJc3RydWN0IG1lZ2FzYXNfY21kX2Z1c2lvbiAq
Y21kKQoreworCWludCBpLCBzZ19wcm9jZXNzZWQ7CisJaW50IHNnZV9jb3VudCwgc2dlX2lkeDsK
KwlzdHJ1Y3Qgc2NhdHRlcmxpc3QgKm9zX3NnbDsKKwlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1
c2lvbjsKKworCWZ1c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CisKKwljbWQtPmlvX3Jl
cXVlc3QtPkNoYWluT2Zmc2V0ID0gMDsKKworCXNnZV9jb3VudCA9IHNjc2lfZG1hX21hcChzY3Ap
OworCisJQlVHX09OKHNnZV9jb3VudCA8IDApOworCisJaWYgKHNnZV9jb3VudCA+IGluc3RhbmNl
LT5tYXhfbnVtX3NnZSB8fCAhc2dlX2NvdW50KQorCQlyZXR1cm4gc2dlX2NvdW50OworCisJaWYg
KHNnZV9jb3VudCA+IGZ1c2lvbi0+bWF4X3NnZV9pbl9tYWluX21zZykgeworCQkvKiBPbmUgZWxl
bWVudCB0byBzdG9yZSB0aGUgY2hhaW4gaW5mbyAqLworCQlzZ2VfaWR4ID0gZnVzaW9uLT5tYXhf
c2dlX2luX21haW5fbXNnIC0gMTsKKwl9IGVsc2UKKwkJc2dlX2lkeCA9IHNnZV9jb3VudDsKKwor
CXNjc2lfZm9yX2VhY2hfc2coc2NwLCBvc19zZ2wsIHNnZV9jb3VudCwgaSkgeworCQlzZ2xfcHRy
LT5MZW5ndGggPSBzZ19kbWFfbGVuKG9zX3NnbCk7CisJCXNnbF9wdHItPkFkZHJlc3MgPSBzZ19k
bWFfYWRkcmVzcyhvc19zZ2wpOworCQlzZ2xfcHRyLT5GbGFncyA9IDA7CisJCXNnbF9wdHIrKzsK
KworCQlzZ19wcm9jZXNzZWQgPSBpICsgMTsKKworCQlpZiAoKHNnX3Byb2Nlc3NlZCA9PSAgKGZ1
c2lvbi0+bWF4X3NnZV9pbl9tYWluX21zZyAtIDEpKSAmJgorCQkgICAgKHNnZV9jb3VudCA+IGZ1
c2lvbi0+bWF4X3NnZV9pbl9tYWluX21zZykpIHsKKworCQkJc3RydWN0IE1QSTI1X0lFRUVfU0dF
X0NIQUlONjQgKnNnX2NoYWluOworCQkJY21kLT5pb19yZXF1ZXN0LT5DaGFpbk9mZnNldCA9CisJ
CQkJZnVzaW9uLT5jaGFpbl9vZmZzZXRfaW9fcmVxdWVzdDsKKwkJCXNnX2NoYWluID0gc2dsX3B0
cjsKKwkJCS8qIFByZXBhcmUgY2hhaW4gZWxlbWVudCAqLworCQkJc2dfY2hhaW4tPk5leHRDaGFp
bk9mZnNldCA9IDA7CisJCQlzZ19jaGFpbi0+RmxhZ3MgPSAoSUVFRV9TR0VfRkxBR1NfQ0hBSU5f
RUxFTUVOVCB8CisJCQkJCSAgIE1QSTJfSUVFRV9TR0VfRkxBR1NfSU9DUExCTlRBX0FERFIpOwor
CQkJc2dfY2hhaW4tPkxlbmd0aCA9ICAoc2l6ZW9mKHVuaW9uIE1QSTJfU0dFX0lPX1VOSU9OKQor
CQkJCQkgICAgICooc2dlX2NvdW50IC0gc2dfcHJvY2Vzc2VkKSk7CisJCQlzZ19jaGFpbi0+QWRk
cmVzcyA9IGNtZC0+c2dfZnJhbWVfcGh5c19hZGRyOworCisJCQlzZ2xfcHRyID0KKwkJCSAgKHN0
cnVjdCBNUEkyNV9JRUVFX1NHRV9DSEFJTjY0ICopY21kLT5zZ19mcmFtZTsKKwkJfQorCX0KKwor
CXJldHVybiBzZ2VfY291bnQ7Cit9CisKKy8qKgorICogbWVnYXNhc19zZXRfcGRfbGJhIC0JU2V0
cyBQRCBMQkEKKyAqIEBjZGI6CQlDREIKKyAqIEBjZGJfbGVuOgkJY2RiIGxlbmd0aAorICogQHN0
YXJ0X2JsazoJCVN0YXJ0IGJsb2NrIG9mIElPCisgKgorICogVXNlZCB0byBzZXQgdGhlIFBEIExC
QSBpbiBDREIgZm9yIEZQIElPcworICovCit2b2lkCittZWdhc2FzX3NldF9wZF9sYmEoc3RydWN0
IE1QSTJfUkFJRF9TQ1NJX0lPX1JFUVVFU1QgKmlvX3JlcXVlc3QsIHU4IGNkYl9sZW4sCisJCSAg
IHN0cnVjdCBJT19SRVFVRVNUX0lORk8gKmlvX2luZm8sIHN0cnVjdCBzY3NpX2NtbmQgKnNjcCwK
KwkJICAgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbG9jYWxfbWFwX3B0ciwgdTMyIHJlZl90
YWcpCit7CisJc3RydWN0IE1SX0xEX1JBSUQgKnJhaWQ7CisJdTMyIGxkOworCXU2NCBzdGFydF9i
bGsgPSBpb19pbmZvLT5wZEJsb2NrOworCXU4ICpjZGIgPSBpb19yZXF1ZXN0LT5DREIuQ0RCMzI7
CisJdTMyIG51bV9ibG9ja3MgPSBpb19pbmZvLT5udW1CbG9ja3M7CisJdTggb3Bjb2RlLCBmbGFn
dmFscywgZ3JvdXBudW0sIGNvbnRyb2w7CisKKwkvKiBDaGVjayBpZiBUMTAgUEkgKERJRikgaXMg
ZW5hYmxlZCBmb3IgdGhpcyBMRCAqLworCWxkID0gTVJfVGFyZ2V0SWRUb0xkR2V0KGlvX2luZm8t
PmxkVGd0SWQsIGxvY2FsX21hcF9wdHIpOworCXJhaWQgPSBNUl9MZFJhaWRHZXQobGQsIGxvY2Fs
X21hcF9wdHIpOworCWlmIChyYWlkLT5jYXBhYmlsaXR5LmxkUGlNb2RlID09IE1SX1BST1RfSU5G
T19UWVBFX0NPTlRST0xMRVIpIHsKKwkJbWVtc2V0KGNkYiwgMCwgc2l6ZW9mKGlvX3JlcXVlc3Qt
PkNEQi5DREIzMikpOworCQljZGJbMF0gPSAgTUVHQVNBU19TQ1NJX1ZBUklBQkxFX0xFTkdUSF9D
TUQ7CisJCWNkYls3XSA9ICBNRUdBU0FTX1NDU0lfQURETF9DREJfTEVOOworCisJCWlmIChzY3At
PnNjX2RhdGFfZGlyZWN0aW9uID09IFBDSV9ETUFfRlJPTURFVklDRSkKKwkJCWNkYls5XSA9IE1F
R0FTQVNfU0NTSV9TRVJWSUNFX0FDVElPTl9SRUFEMzI7CisJCWVsc2UKKwkJCWNkYls5XSA9IE1F
R0FTQVNfU0NTSV9TRVJWSUNFX0FDVElPTl9XUklURTMyOworCQljZGJbMTBdID0gTUVHQVNBU19S
RF9XUl9QUk9URUNUX0NIRUNLX0FMTDsKKworCQkvKiBMQkEgKi8KKwkJY2RiWzEyXSA9ICh1OCko
KHN0YXJ0X2JsayA+PiA1NikgJiAweGZmKTsKKwkJY2RiWzEzXSA9ICh1OCkoKHN0YXJ0X2JsayA+
PiA0OCkgJiAweGZmKTsKKwkJY2RiWzE0XSA9ICh1OCkoKHN0YXJ0X2JsayA+PiA0MCkgJiAweGZm
KTsKKwkJY2RiWzE1XSA9ICh1OCkoKHN0YXJ0X2JsayA+PiAzMikgJiAweGZmKTsKKwkJY2RiWzE2
XSA9ICh1OCkoKHN0YXJ0X2JsayA+PiAyNCkgJiAweGZmKTsKKwkJY2RiWzE3XSA9ICh1OCkoKHN0
YXJ0X2JsayA+PiAxNikgJiAweGZmKTsKKwkJY2RiWzE4XSA9ICh1OCkoKHN0YXJ0X2JsayA+PiA4
KSAmIDB4ZmYpOworCQljZGJbMTldID0gKHU4KShzdGFydF9ibGsgJiAweGZmKTsKKworCQkvKiBM
b2dpY2FsIGJsb2NrIHJlZmVyZW5jZSB0YWcgKi8KKwkJaW9fcmVxdWVzdC0+Q0RCLkVFRFAzMi5Q
cmltYXJ5UmVmZXJlbmNlVGFnID0KKwkJCWNwdV90b19iZTMyKHJlZl90YWcpOworCQlpb19yZXF1
ZXN0LT5DREIuRUVEUDMyLlByaW1hcnlBcHBsaWNhdGlvblRhZ01hc2sgPSAweGZmZmY7CisKKwkJ
aW9fcmVxdWVzdC0+RGF0YUxlbmd0aCA9IG51bV9ibG9ja3MgKiA1MTI7CisJCWlvX3JlcXVlc3Qt
PklvRmxhZ3MgPSAzMjsgLyogU3BlY2lmeSAzMi1ieXRlIGNkYiAqLworCisJCS8qIFRyYW5zZmVy
IGxlbmd0aCAqLworCQljZGJbMjhdID0gKHU4KSgobnVtX2Jsb2NrcyA+PiAyNCkgJiAweGZmKTsK
KwkJY2RiWzI5XSA9ICh1OCkoKG51bV9ibG9ja3MgPj4gMTYpICYgMHhmZik7CisJCWNkYlszMF0g
PSAodTgpKChudW1fYmxvY2tzID4+IDgpICYgMHhmZik7CisJCWNkYlszMV0gPSAodTgpKG51bV9i
bG9ja3MgJiAweGZmKTsKKworCQkvKiBzZXQgU0NTSSBJTyBFRURQRmxhZ3MgKi8KKwkJaWYgKHNj
cC0+c2NfZGF0YV9kaXJlY3Rpb24gPT0gUENJX0RNQV9GUk9NREVWSUNFKSB7CisJCQlpb19yZXF1
ZXN0LT5FRURQRmxhZ3MgPQorCQkJCU1QSTJfU0NTSUlPX0VFRFBGTEFHU19JTkNfUFJJX1JFRlRB
RyAgfAorCQkJCU1QSTJfU0NTSUlPX0VFRFBGTEFHU19DSEVDS19SRUZUQUcgfAorCQkJCU1QSTJf
U0NTSUlPX0VFRFBGTEFHU19DSEVDS19SRU1PVkVfT1AgfAorCQkJCU1QSTJfU0NTSUlPX0VFRFBG
TEFHU19DSEVDS19BUFBUQUcgfAorCQkJCU1QSTJfU0NTSUlPX0VFRFBGTEFHU19DSEVDS19HVUFS
RDsKKwkJfSBlbHNlIHsKKwkJCWlvX3JlcXVlc3QtPkVFRFBGbGFncyA9CisJCQkJTVBJMl9TQ1NJ
SU9fRUVEUEZMQUdTX0lOQ19QUklfUkVGVEFHIHwKKwkJCQlNUEkyX1NDU0lJT19FRURQRkxBR1Nf
SU5TRVJUX09QOworCQl9CisJCWlvX3JlcXVlc3QtPkNvbnRyb2wgfD0gKDB4NCA8PCAyNik7CisJ
CWlvX3JlcXVlc3QtPkVFRFBCbG9ja1NpemUgPSBNRUdBU0FTX0VFRFBCTE9DS1NJWkU7CisJfSBl
bHNlIHsKKwkJLyogU29tZSBkcml2ZXMgZG9uJ3Qgc3VwcG9ydCAxNi8xMiBieXRlIENEQidzLCBj
b252ZXJ0IHRvIDEwICovCisJCWlmICgoKGNkYl9sZW4gPT0gMTIpIHx8IChjZGJfbGVuID09IDE2
KSkgJiYKKwkJICAgIChzdGFydF9ibGsgPD0gMHhmZmZmZmZmZikpIHsKKwkJCWlmIChjZGJfbGVu
ID09IDE2KSB7CisJCQkJb3Bjb2RlID0gY2RiWzBdID09IFJFQURfMTYgPyBSRUFEXzEwIDogV1JJ
VEVfMTA7CisJCQkJZmxhZ3ZhbHMgPSBjZGJbMV07CisJCQkJZ3JvdXBudW0gPSBjZGJbMTRdOwor
CQkJCWNvbnRyb2wgPSBjZGJbMTVdOworCQkJfSBlbHNlIHsKKwkJCQlvcGNvZGUgPSBjZGJbMF0g
PT0gUkVBRF8xMiA/IFJFQURfMTAgOiBXUklURV8xMDsKKwkJCQlmbGFndmFscyA9IGNkYlsxXTsK
KwkJCQlncm91cG51bSA9IGNkYlsxMF07CisJCQkJY29udHJvbCA9IGNkYlsxMV07CisJCQl9CisK
KwkJCW1lbXNldChjZGIsIDAsIHNpemVvZihpb19yZXF1ZXN0LT5DREIuQ0RCMzIpKTsKKworCQkJ
Y2RiWzBdID0gb3Bjb2RlOworCQkJY2RiWzFdID0gZmxhZ3ZhbHM7CisJCQljZGJbNl0gPSBncm91
cG51bTsKKwkJCWNkYls5XSA9IGNvbnRyb2w7CisKKwkJCS8qIFRyYW5zZmVyIGxlbmd0aCAqLwor
CQkJY2RiWzhdID0gKHU4KShudW1fYmxvY2tzICYgMHhmZik7CisJCQljZGJbN10gPSAodTgpKChu
dW1fYmxvY2tzID4+IDgpICYgMHhmZik7CisKKwkJCWNkYl9sZW4gPSAxMDsKKwkJfQorCisJCS8q
IE5vcm1hbCBjYXNlLCBqdXN0IGxvYWQgTEJBIGhlcmUgKi8KKwkJc3dpdGNoIChjZGJfbGVuKSB7
CisJCWNhc2UgNjoKKwkJeworCQkJdTggdmFsID0gY2RiWzFdICYgMHhFMDsKKwkJCWNkYlszXSA9
ICh1OCkoc3RhcnRfYmxrICYgMHhmZik7CisJCQljZGJbMl0gPSAodTgpKChzdGFydF9ibGsgPj4g
OCkgJiAweGZmKTsKKwkJCWNkYlsxXSA9IHZhbCB8ICgodTgpKHN0YXJ0X2JsayA+PiAxNikgJiAw
eDFmKTsKKwkJCWJyZWFrOworCQl9CisJCWNhc2UgMTA6CisJCQljZGJbNV0gPSAodTgpKHN0YXJ0
X2JsayAmIDB4ZmYpOworCQkJY2RiWzRdID0gKHU4KSgoc3RhcnRfYmxrID4+IDgpICYgMHhmZik7
CisJCQljZGJbM10gPSAodTgpKChzdGFydF9ibGsgPj4gMTYpICYgMHhmZik7CisJCQljZGJbMl0g
PSAodTgpKChzdGFydF9ibGsgPj4gMjQpICYgMHhmZik7CisJCQlicmVhazsKKwkJY2FzZSAxMjoK
KwkJCWNkYls1XSAgICA9ICh1OCkoc3RhcnRfYmxrICYgMHhmZik7CisJCQljZGJbNF0gICAgPSAo
dTgpKChzdGFydF9ibGsgPj4gOCkgJiAweGZmKTsKKwkJCWNkYlszXSAgICA9ICh1OCkoKHN0YXJ0
X2JsayA+PiAxNikgJiAweGZmKTsKKwkJCWNkYlsyXSAgICA9ICh1OCkoKHN0YXJ0X2JsayA+PiAy
NCkgJiAweGZmKTsKKwkJCWJyZWFrOworCQljYXNlIDE2OgorCQkJY2RiWzldICAgID0gKHU4KShz
dGFydF9ibGsgJiAweGZmKTsKKwkJCWNkYls4XSAgICA9ICh1OCkoKHN0YXJ0X2JsayA+PiA4KSAm
IDB4ZmYpOworCQkJY2RiWzddICAgID0gKHU4KSgoc3RhcnRfYmxrID4+IDE2KSAmIDB4ZmYpOwor
CQkJY2RiWzZdICAgID0gKHU4KSgoc3RhcnRfYmxrID4+IDI0KSAmIDB4ZmYpOworCQkJY2RiWzVd
ICAgID0gKHU4KSgoc3RhcnRfYmxrID4+IDMyKSAmIDB4ZmYpOworCQkJY2RiWzRdICAgID0gKHU4
KSgoc3RhcnRfYmxrID4+IDQwKSAmIDB4ZmYpOworCQkJY2RiWzNdICAgID0gKHU4KSgoc3RhcnRf
YmxrID4+IDQ4KSAmIDB4ZmYpOworCQkJY2RiWzJdICAgID0gKHU4KSgoc3RhcnRfYmxrID4+IDU2
KSAmIDB4ZmYpOworCQkJYnJlYWs7CisJCX0KKwl9Cit9CisKKy8qKgorICogbWVnYXNhc19idWls
ZF9sZGlvX2Z1c2lvbiAtCVByZXBhcmVzIElPcyB0byBkZXZpY2VzCisgKiBAaW5zdGFuY2U6CQlB
ZGFwdGVyIHNvZnQgc3RhdGUKKyAqIEBzY3A6CQlTQ1NJIGNvbW1hbmQKKyAqIEBjbWQ6CQlDb21t
YW5kIHRvIGJlIHByZXBhcmVkCisgKgorICogUHJlcGFyZXMgdGhlIGlvX3JlcXVlc3QgYW5kIGNo
YWluIGVsZW1lbnRzIChzZ19mcmFtZSkgZm9yIElPCisgKiBUaGUgSU8gY2FuIGJlIGZvciBQRCAo
RmFzdCBQYXRoKSBvciBMRAorICovCit2b2lkCittZWdhc2FzX2J1aWxkX2xkaW9fZnVzaW9uKHN0
cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKKwkJCSAgc3RydWN0IHNjc2lfY21uZCAq
c2NwLAorCQkJICBzdHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uICpjbWQpCit7CisJdTggZnBfcG9z
c2libGU7CisJdTMyIHN0YXJ0X2xiYV9sbywgc3RhcnRfbGJhX2hpLCBkZXZpY2VfaWQ7CisJc3Ry
dWN0IE1QSTJfUkFJRF9TQ1NJX0lPX1JFUVVFU1QgKmlvX3JlcXVlc3Q7CisJdW5pb24gTUVHQVNB
U19SRVFVRVNUX0RFU0NSSVBUT1JfVU5JT04gKnJlcV9kZXNjOworCXN0cnVjdCBJT19SRVFVRVNU
X0lORk8gaW9faW5mbzsKKwlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lvbjsKKwlzdHJ1Y3Qg
TVJfRldfUkFJRF9NQVBfQUxMICpsb2NhbF9tYXBfcHRyOworCisJZGV2aWNlX2lkID0gTUVHQVNB
U19ERVZfSU5ERVgoaW5zdGFuY2UsIHNjcCk7CisKKwlmdXNpb24gPSBpbnN0YW5jZS0+Y3RybF9j
b250ZXh0OworCisJaW9fcmVxdWVzdCA9IGNtZC0+aW9fcmVxdWVzdDsKKwlpb19yZXF1ZXN0LT5S
YWlkQ29udGV4dC5WaXJ0dWFsRGlza1RndElkID0gZGV2aWNlX2lkOworCWlvX3JlcXVlc3QtPlJh
aWRDb250ZXh0LnN0YXR1cyA9IDA7CisJaW9fcmVxdWVzdC0+UmFpZENvbnRleHQuZXhTdGF0dXMg
PSAwOworCisJcmVxX2Rlc2MgPSAodW5pb24gTUVHQVNBU19SRVFVRVNUX0RFU0NSSVBUT1JfVU5J
T04gKiljbWQtPnJlcXVlc3RfZGVzYzsKKworCXN0YXJ0X2xiYV9sbyA9IDA7CisJc3RhcnRfbGJh
X2hpID0gMDsKKwlmcF9wb3NzaWJsZSA9IDA7CisKKwkvKgorCSAqIDYtYnl0ZSBSRUFEKDB4MDgp
IG9yIFdSSVRFKDB4MEEpIGNkYgorCSAqLworCWlmIChzY3AtPmNtZF9sZW4gPT0gNikgeworCQlp
b19yZXF1ZXN0LT5EYXRhTGVuZ3RoID0gKHUzMikgc2NwLT5jbW5kWzRdOworCQlzdGFydF9sYmFf
bG8gPSAoKHUzMikgc2NwLT5jbW5kWzFdIDw8IDE2KSB8CisJCQkoKHUzMikgc2NwLT5jbW5kWzJd
IDw8IDgpIHwgKHUzMikgc2NwLT5jbW5kWzNdOworCisJCXN0YXJ0X2xiYV9sbyAmPSAweDFGRkZG
RjsKKwl9CisKKwkvKgorCSAqIDEwLWJ5dGUgUkVBRCgweDI4KSBvciBXUklURSgweDJBKSBjZGIK
KwkgKi8KKwllbHNlIGlmIChzY3AtPmNtZF9sZW4gPT0gMTApIHsKKwkJaW9fcmVxdWVzdC0+RGF0
YUxlbmd0aCA9ICh1MzIpIHNjcC0+Y21uZFs4XSB8CisJCQkoKHUzMikgc2NwLT5jbW5kWzddIDw8
IDgpOworCQlzdGFydF9sYmFfbG8gPSAoKHUzMikgc2NwLT5jbW5kWzJdIDw8IDI0KSB8CisJCQko
KHUzMikgc2NwLT5jbW5kWzNdIDw8IDE2KSB8CisJCQkoKHUzMikgc2NwLT5jbW5kWzRdIDw8IDgp
IHwgKHUzMikgc2NwLT5jbW5kWzVdOworCX0KKworCS8qCisJICogMTItYnl0ZSBSRUFEKDB4QTgp
IG9yIFdSSVRFKDB4QUEpIGNkYgorCSAqLworCWVsc2UgaWYgKHNjcC0+Y21kX2xlbiA9PSAxMikg
eworCQlpb19yZXF1ZXN0LT5EYXRhTGVuZ3RoID0gKCh1MzIpIHNjcC0+Y21uZFs2XSA8PCAyNCkg
fAorCQkJKCh1MzIpIHNjcC0+Y21uZFs3XSA8PCAxNikgfAorCQkJKCh1MzIpIHNjcC0+Y21uZFs4
XSA8PCA4KSB8ICh1MzIpIHNjcC0+Y21uZFs5XTsKKwkJc3RhcnRfbGJhX2xvID0gKCh1MzIpIHNj
cC0+Y21uZFsyXSA8PCAyNCkgfAorCQkJKCh1MzIpIHNjcC0+Y21uZFszXSA8PCAxNikgfAorCQkJ
KCh1MzIpIHNjcC0+Y21uZFs0XSA8PCA4KSB8ICh1MzIpIHNjcC0+Y21uZFs1XTsKKwl9CisKKwkv
KgorCSAqIDE2LWJ5dGUgUkVBRCgweDg4KSBvciBXUklURSgweDhBKSBjZGIKKwkgKi8KKwllbHNl
IGlmIChzY3AtPmNtZF9sZW4gPT0gMTYpIHsKKwkJaW9fcmVxdWVzdC0+RGF0YUxlbmd0aCA9ICgo
dTMyKSBzY3AtPmNtbmRbMTBdIDw8IDI0KSB8CisJCQkoKHUzMikgc2NwLT5jbW5kWzExXSA8PCAx
NikgfAorCQkJKCh1MzIpIHNjcC0+Y21uZFsxMl0gPDwgOCkgfCAodTMyKSBzY3AtPmNtbmRbMTNd
OworCQlzdGFydF9sYmFfbG8gPSAoKHUzMikgc2NwLT5jbW5kWzZdIDw8IDI0KSB8CisJCQkoKHUz
Mikgc2NwLT5jbW5kWzddIDw8IDE2KSB8CisJCQkoKHUzMikgc2NwLT5jbW5kWzhdIDw8IDgpIHwg
KHUzMikgc2NwLT5jbW5kWzldOworCisJCXN0YXJ0X2xiYV9oaSA9ICgodTMyKSBzY3AtPmNtbmRb
Ml0gPDwgMjQpIHwKKwkJCSgodTMyKSBzY3AtPmNtbmRbM10gPDwgMTYpIHwKKwkJCSgodTMyKSBz
Y3AtPmNtbmRbNF0gPDwgOCkgfCAodTMyKSBzY3AtPmNtbmRbNV07CisJfQorCisJbWVtc2V0KCZp
b19pbmZvLCAwLCBzaXplb2Yoc3RydWN0IElPX1JFUVVFU1RfSU5GTykpOworCWlvX2luZm8ubGRT
dGFydEJsb2NrID0gKCh1NjQpc3RhcnRfbGJhX2hpIDw8IDMyKSB8IHN0YXJ0X2xiYV9sbzsKKwlp
b19pbmZvLm51bUJsb2NrcyA9IGlvX3JlcXVlc3QtPkRhdGFMZW5ndGg7CisJaW9faW5mby5sZFRn
dElkID0gZGV2aWNlX2lkOworCisJaWYgKHNjcC0+c2NfZGF0YV9kaXJlY3Rpb24gPT0gUENJX0RN
QV9GUk9NREVWSUNFKQorCQlpb19pbmZvLmlzUmVhZCA9IDE7CisKKwlsb2NhbF9tYXBfcHRyID0g
ZnVzaW9uLT5sZF9tYXBbKGluc3RhbmNlLT5tYXBfaWQgJiAxKV07CisKKwlpZiAoKE1SX1Rhcmdl
dElkVG9MZEdldChkZXZpY2VfaWQsIGxvY2FsX21hcF9wdHIpID49CisJICAgICBNQVhfTE9HSUNB
TF9EUklWRVMpIHx8ICghZnVzaW9uLT5mYXN0X3BhdGhfaW8pKSB7CisJCWlvX3JlcXVlc3QtPlJh
aWRDb250ZXh0LnJlZ0xvY2tGbGFncyAgPSAwOworCQlmcF9wb3NzaWJsZSA9IDA7CisJfSBlbHNl
IHsKKwkJaWYgKE1SX0J1aWxkUmFpZENvbnRleHQoJmlvX2luZm8sICZpb19yZXF1ZXN0LT5SYWlk
Q29udGV4dCwKKwkJCQkJbG9jYWxfbWFwX3B0cikpCisJCQlmcF9wb3NzaWJsZSA9IGlvX2luZm8u
ZnBPa0ZvcklvOworCX0KKworCWlmIChmcF9wb3NzaWJsZSkgeworCQltZWdhc2FzX3NldF9wZF9s
YmEoaW9fcmVxdWVzdCwgc2NwLT5jbWRfbGVuLCAmaW9faW5mbywgc2NwLAorCQkJCSAgIGxvY2Fs
X21hcF9wdHIsIHN0YXJ0X2xiYV9sbyk7CisJCWlvX3JlcXVlc3QtPkRhdGFMZW5ndGggPSBzY3Np
X2J1ZmZsZW4oc2NwKTsKKwkJaW9fcmVxdWVzdC0+RnVuY3Rpb24gPSBNUEkyX0ZVTkNUSU9OX1ND
U0lfSU9fUkVRVUVTVDsKKwkJY21kLT5yZXF1ZXN0X2Rlc2MtPlNDU0lJTy5SZXF1ZXN0RmxhZ3Mg
PQorCQkJKE1QSTJfUkVRX0RFU0NSSVBUX0ZMQUdTX0hJR0hfUFJJT1JJVFkKKwkJCSA8PCBNRUdB
U0FTX1JFUV9ERVNDUklQVF9GTEFHU19UWVBFX1NISUZUKTsKKwkJaWYgKChmdXNpb24tPmxvYWRf
YmFsYW5jZV9pbmZvW2RldmljZV9pZF0ubG9hZEJhbGFuY2VGbGFnKSAmJgorCQkgICAgKGlvX2lu
Zm8uaXNSZWFkKSkgeworCQkJaW9faW5mby5kZXZIYW5kbGUgPQorCQkJCWdldF91cGRhdGVkX2Rl
dl9oYW5kbGUoCisJCQkJCSZmdXNpb24tPmxvYWRfYmFsYW5jZV9pbmZvW2RldmljZV9pZF0sCisJ
CQkJCSZpb19pbmZvKTsKKwkJCXNjcC0+U0NwLlN0YXR1cyB8PSBNRUdBU0FTX0xPQURfQkFMQU5D
RV9GTEFHOworCQl9IGVsc2UKKwkJCXNjcC0+U0NwLlN0YXR1cyAmPSB+TUVHQVNBU19MT0FEX0JB
TEFOQ0VfRkxBRzsKKwkJY21kLT5yZXF1ZXN0X2Rlc2MtPlNDU0lJTy5EZXZIYW5kbGUgPSBpb19p
bmZvLmRldkhhbmRsZTsKKwkJaW9fcmVxdWVzdC0+RGV2SGFuZGxlID0gaW9faW5mby5kZXZIYW5k
bGU7CisJfSBlbHNlIHsKKwkJaW9fcmVxdWVzdC0+UmFpZENvbnRleHQudGltZW91dFZhbHVlID0K
KwkJCWxvY2FsX21hcF9wdHItPnJhaWRNYXAuZnBQZElvVGltZW91dFNlYzsKKwkJaW9fcmVxdWVz
dC0+RnVuY3Rpb24gPSBNRUdBU0FTX01QSTJfRlVOQ1RJT05fTERfSU9fUkVRVUVTVDsKKwkJaW9f
cmVxdWVzdC0+RGV2SGFuZGxlID0gZGV2aWNlX2lkOworCQljbWQtPnJlcXVlc3RfZGVzYy0+U0NT
SUlPLlJlcXVlc3RGbGFncyA9CisJCQkoTUVHQVNBU19SRVFfREVTQ1JJUFRfRkxBR1NfTERfSU8K
KwkJCSA8PCBNRUdBU0FTX1JFUV9ERVNDUklQVF9GTEFHU19UWVBFX1NISUZUKTsKKwl9IC8qIE5v
dCBGUCAqLworfQorCisvKioKKyAqIG1lZ2FzYXNfYnVpbGRfZGNkYl9mdXNpb24gLQlQcmVwYXJl
cyBJT3MgdG8gZGV2aWNlcworICogQGluc3RhbmNlOgkJQWRhcHRlciBzb2Z0IHN0YXRlCisgKiBA
c2NwOgkJU0NTSSBjb21tYW5kCisgKiBAY21kOgkJQ29tbWFuZCB0byBiZSBwcmVwYXJlZAorICoK
KyAqIFByZXBhcmVzIHRoZSBpb19yZXF1ZXN0IGZyYW1lIGZvciBub24taW8gY21kcworICovCitz
dGF0aWMgdm9pZAorbWVnYXNhc19idWlsZF9kY2RiX2Z1c2lvbihzdHJ1Y3QgbWVnYXNhc19pbnN0
YW5jZSAqaW5zdGFuY2UsCisJCQkgIHN0cnVjdCBzY3NpX2NtbmQgKnNjbWQsCisJCQkgIHN0cnVj
dCBtZWdhc2FzX2NtZF9mdXNpb24gKmNtZCkKK3sKKwl1MzIgZGV2aWNlX2lkOworCXN0cnVjdCBN
UEkyX1JBSURfU0NTSV9JT19SRVFVRVNUICppb19yZXF1ZXN0OworCXUxNiBwZF9pbmRleCA9IDA7
CisJc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbG9jYWxfbWFwX3B0cjsKKwlzdHJ1Y3QgZnVz
aW9uX2NvbnRleHQgKmZ1c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CisKKwlpb19yZXF1
ZXN0ID0gY21kLT5pb19yZXF1ZXN0OworCWRldmljZV9pZCA9IE1FR0FTQVNfREVWX0lOREVYKGlu
c3RhbmNlLCBzY21kKTsKKwlwZF9pbmRleCA9IChzY21kLT5kZXZpY2UtPmNoYW5uZWwgKiBNRUdB
U0FTX01BWF9ERVZfUEVSX0NIQU5ORUwpCisJCStzY21kLT5kZXZpY2UtPmlkOworCWxvY2FsX21h
cF9wdHIgPSBmdXNpb24tPmxkX21hcFsoaW5zdGFuY2UtPm1hcF9pZCAmIDEpXTsKKworCS8qIENo
ZWNrIGlmIHRoaXMgaXMgYSBzeXN0ZW0gUEQgSS9PICovCisJaWYgKChpbnN0YW5jZS0+cGRfbGlz
dFtwZF9pbmRleF0uZHJpdmVTdGF0ZSA9PSBNUl9QRF9TVEFURV9TWVNURU0pICYmCisJICAgIChp
bnN0YW5jZS0+cGRfbGlzdFtwZF9pbmRleF0uZHJpdmVUeXBlID09IFRZUEVfRElTSykpIHsKKwkJ
aW9fcmVxdWVzdC0+RnVuY3Rpb24gPSAwOworCQlpb19yZXF1ZXN0LT5EZXZIYW5kbGUgPQorCQkJ
bG9jYWxfbWFwX3B0ci0+cmFpZE1hcC5kZXZIbmRsSW5mb1tkZXZpY2VfaWRdLmN1ckRldkhkbDsK
KwkJaW9fcmVxdWVzdC0+UmFpZENvbnRleHQudGltZW91dFZhbHVlID0KKwkJCWxvY2FsX21hcF9w
dHItPnJhaWRNYXAuZnBQZElvVGltZW91dFNlYzsKKwkJaW9fcmVxdWVzdC0+UmFpZENvbnRleHQu
cmVnTG9ja0ZsYWdzID0gMDsKKwkJaW9fcmVxdWVzdC0+UmFpZENvbnRleHQucmVnTG9ja1Jvd0xC
QSA9IDA7CisJCWlvX3JlcXVlc3QtPlJhaWRDb250ZXh0LnJlZ0xvY2tMZW5ndGggPSAwOworCQlp
b19yZXF1ZXN0LT5SYWlkQ29udGV4dC5SQUlERmxhZ3MgPQorCQkJTVJfUkFJRF9GTEFHU19JT19T
VUJfVFlQRV9TWVNURU1fUEQgPDwKKwkJCU1SX1JBSURfQ1RYX1JBSURfRkxBR1NfSU9fU1VCX1RZ
UEVfU0hJRlQ7CisJCWNtZC0+cmVxdWVzdF9kZXNjLT5TQ1NJSU8uUmVxdWVzdEZsYWdzID0KKwkJ
CShNUEkyX1JFUV9ERVNDUklQVF9GTEFHU19ISUdIX1BSSU9SSVRZIDw8CisJCQkgTUVHQVNBU19S
RVFfREVTQ1JJUFRfRkxBR1NfVFlQRV9TSElGVCk7CisJfSBlbHNlIHsKKwkJaW9fcmVxdWVzdC0+
RnVuY3Rpb24gID0gTUVHQVNBU19NUEkyX0ZVTkNUSU9OX0xEX0lPX1JFUVVFU1Q7CisJCWlvX3Jl
cXVlc3QtPkRldkhhbmRsZSA9IGRldmljZV9pZDsKKwkJY21kLT5yZXF1ZXN0X2Rlc2MtPlNDU0lJ
Ty5SZXF1ZXN0RmxhZ3MgPQorCQkJKE1QSTJfUkVRX0RFU0NSSVBUX0ZMQUdTX1NDU0lfSU8gPDwK
KwkJCSBNRUdBU0FTX1JFUV9ERVNDUklQVF9GTEFHU19UWVBFX1NISUZUKTsKKwl9CisJaW9fcmVx
dWVzdC0+UmFpZENvbnRleHQuVmlydHVhbERpc2tUZ3RJZCA9IGRldmljZV9pZDsKKwlpb19yZXF1
ZXN0LT5MVU5bMF0gPSBzY21kLT5kZXZpY2UtPmx1bjsKKwlpb19yZXF1ZXN0LT5EYXRhTGVuZ3Ro
ID0gc2NzaV9idWZmbGVuKHNjbWQpOworfQorCisvKioKKyAqIG1lZ2FzYXNfYnVpbGRfaW9fZnVz
aW9uIC0JUHJlcGFyZXMgSU9zIHRvIGRldmljZXMKKyAqIEBpbnN0YW5jZToJCUFkYXB0ZXIgc29m
dCBzdGF0ZQorICogQHNjcDoJCVNDU0kgY29tbWFuZAorICogQGNtZDoJCUNvbW1hbmQgdG8gYmUg
cHJlcGFyZWQKKyAqCisgKiBJbnZva2VzIGhlbHBlciBmdW5jdGlvbnMgdG8gcHJlcGFyZSByZXF1
ZXN0IGZyYW1lcworICogYW5kIHNldHMgZmxhZ3MgYXBwcm9wcmlhdGUgZm9yIElPL05vbi1JTyBj
bWQKKyAqLworaW50CittZWdhc2FzX2J1aWxkX2lvX2Z1c2lvbihzdHJ1Y3QgbWVnYXNhc19pbnN0
YW5jZSAqaW5zdGFuY2UsCisJCQlzdHJ1Y3Qgc2NzaV9jbW5kICpzY3AsCisJCQlzdHJ1Y3QgbWVn
YXNhc19jbWRfZnVzaW9uICpjbWQpCit7CisJdTMyIGRldmljZV9pZCwgc2dlX2NvdW50OworCXN0
cnVjdCBNUEkyX1JBSURfU0NTSV9JT19SRVFVRVNUICppb19yZXF1ZXN0ID0gY21kLT5pb19yZXF1
ZXN0OworCisJZGV2aWNlX2lkID0gTUVHQVNBU19ERVZfSU5ERVgoaW5zdGFuY2UsIHNjcCk7CisK
KwkvKiBaZXJvIG91dCBzb21lIGZpZWxkcyBzbyB0aGV5IGRvbid0IGdldCByZXVzZWQgKi8KKwlp
b19yZXF1ZXN0LT5MVU5bMF0gPSAwOworCWlvX3JlcXVlc3QtPkNEQi5FRURQMzIuUHJpbWFyeVJl
ZmVyZW5jZVRhZyA9IDA7CisJaW9fcmVxdWVzdC0+Q0RCLkVFRFAzMi5QcmltYXJ5QXBwbGljYXRp
b25UYWdNYXNrID0gMDsKKwlpb19yZXF1ZXN0LT5FRURQRmxhZ3MgPSAwOworCWlvX3JlcXVlc3Qt
PkNvbnRyb2wgPSAwOworCWlvX3JlcXVlc3QtPkVFRFBCbG9ja1NpemUgPSAwOworCWlvX3JlcXVl
c3QtPklvRmxhZ3MgPSAwOworCWlvX3JlcXVlc3QtPlJhaWRDb250ZXh0LlJBSURGbGFncyA9IDA7
CisKKwltZW1jcHkoaW9fcmVxdWVzdC0+Q0RCLkNEQjMyLCBzY3AtPmNtbmQsIHNjcC0+Y21kX2xl
bik7CisJLyoKKwkgKiBKdXN0IHRoZSBDREIgbGVuZ3RoLHJlc3Qgb2YgdGhlIEZsYWdzIGFyZSB6
ZXJvCisJICogVGhpcyB3aWxsIGJlIG1vZGlmaWVkIGZvciBGUCBpbiBidWlsZF9sZGlvX2Z1c2lv
bgorCSAqLworCWlvX3JlcXVlc3QtPklvRmxhZ3MgPSBzY3AtPmNtZF9sZW47CisKKwlpZiAobWVn
YXNhc19pc19sZGlvKHNjcCkpCisJCW1lZ2FzYXNfYnVpbGRfbGRpb19mdXNpb24oaW5zdGFuY2Us
IHNjcCwgY21kKTsKKwllbHNlCisJCW1lZ2FzYXNfYnVpbGRfZGNkYl9mdXNpb24oaW5zdGFuY2Us
IHNjcCwgY21kKTsKKworCS8qCisJICogQ29uc3RydWN0IFNHTAorCSAqLworCisJc2dlX2NvdW50
ID0KKwkJbWVnYXNhc19tYWtlX3NnbF9mdXNpb24oaW5zdGFuY2UsIHNjcCwKKwkJCQkJKHN0cnVj
dCBNUEkyNV9JRUVFX1NHRV9DSEFJTjY0ICopCisJCQkJCSZpb19yZXF1ZXN0LT5TR0wsIGNtZCk7
CisKKwlpZiAoc2dlX2NvdW50ID4gaW5zdGFuY2UtPm1heF9udW1fc2dlKSB7CisJCXByaW50ayhL
RVJOX0VSUiAibWVnYXNhczogRXJyb3IuIHNnZV9jb3VudCAoMHgleCkgZXhjZWVkcyAiCisJCSAg
ICAgICAibWF4ICgweCV4KSBhbGxvd2VkXG4iLCBzZ2VfY291bnQsCisJCSAgICAgICBpbnN0YW5j
ZS0+bWF4X251bV9zZ2UpOworCQlyZXR1cm4gMTsKKwl9CisKKwlpb19yZXF1ZXN0LT5SYWlkQ29u
dGV4dC5udW1TR0UgPSBzZ2VfY291bnQ7CisKKwlpb19yZXF1ZXN0LT5TR0xGbGFncyA9IE1QSTJf
U0dFX0ZMQUdTXzY0X0JJVF9BRERSRVNTSU5HOworCisJaWYgKHNjcC0+c2NfZGF0YV9kaXJlY3Rp
b24gPT0gUENJX0RNQV9UT0RFVklDRSkKKwkJaW9fcmVxdWVzdC0+Q29udHJvbCB8PSBNUEkyX1ND
U0lJT19DT05UUk9MX1dSSVRFOworCWVsc2UgaWYgKHNjcC0+c2NfZGF0YV9kaXJlY3Rpb24gPT0g
UENJX0RNQV9GUk9NREVWSUNFKQorCQlpb19yZXF1ZXN0LT5Db250cm9sIHw9IE1QSTJfU0NTSUlP
X0NPTlRST0xfUkVBRDsKKworCWlvX3JlcXVlc3QtPlNHTE9mZnNldDAgPQorCQlvZmZzZXRvZihz
dHJ1Y3QgTVBJMl9SQUlEX1NDU0lfSU9fUkVRVUVTVCwgU0dMKSAvIDQ7CisKKwlpb19yZXF1ZXN0
LT5TZW5zZUJ1ZmZlckxvd0FkZHJlc3MgPSBjbWQtPnNlbnNlX3BoeXNfYWRkcjsKKwlpb19yZXF1
ZXN0LT5TZW5zZUJ1ZmZlckxlbmd0aCA9IFNDU0lfU0VOU0VfQlVGRkVSU0laRTsKKworCWNtZC0+
c2NtZCA9IHNjcDsKKwlzY3AtPlNDcC5wdHIgPSAoY2hhciAqKWNtZDsKKworCXJldHVybiAwOwor
fQorCit1bmlvbiBNRUdBU0FTX1JFUVVFU1RfREVTQ1JJUFRPUl9VTklPTiAqCittZWdhc2FzX2dl
dF9yZXF1ZXN0X2Rlc2NyaXB0b3Ioc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLCB1
MTYgaW5kZXgpCit7CisJdTggKnA7CisJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb247CisK
KwlpZiAoaW5kZXggPj0gaW5zdGFuY2UtPm1heF9md19jbWRzKSB7CisJCXByaW50ayhLRVJOX0VS
UiAibWVnYXNhczogSW52YWxpZCBTTUlEICgweCV4KXJlcXVlc3QgZm9yICIKKwkJICAgICAgICJk
ZXNjcmlwdG9yXG4iLCBpbmRleCk7CisJCXJldHVybiBOVUxMOworCX0KKwlmdXNpb24gPSBpbnN0
YW5jZS0+Y3RybF9jb250ZXh0OworCXAgPSBmdXNpb24tPnJlcV9mcmFtZXNfZGVzYworCQkrc2l6
ZW9mKHVuaW9uIE1FR0FTQVNfUkVRVUVTVF9ERVNDUklQVE9SX1VOSU9OKSAqaW5kZXg7CisKKwly
ZXR1cm4gKHVuaW9uIE1FR0FTQVNfUkVRVUVTVF9ERVNDUklQVE9SX1VOSU9OICopcDsKK30KKwor
LyoqCisgKiBtZWdhc2FzX2J1aWxkX2FuZF9pc3N1ZV9jbWRfZnVzaW9uIC1NYWluIHJvdXRpbmUg
Zm9yIGJ1aWxkaW5nIGFuZAorICogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
aXNzdWluZyBub24gSU9DVEwgY21kCisgKiBAaW5zdGFuY2U6CQkJQWRhcHRlciBzb2Z0IHN0YXRl
CisgKiBAc2NtZDoJCQlwb2ludGVyIHRvIHNjc2kgY21kIGZyb20gT1MKKyAqLworc3RhdGljIHUz
MgorbWVnYXNhc19idWlsZF9hbmRfaXNzdWVfY21kX2Z1c2lvbihzdHJ1Y3QgbWVnYXNhc19pbnN0
YW5jZSAqaW5zdGFuY2UsCisJCQkJICAgc3RydWN0IHNjc2lfY21uZCAqc2NtZCkKK3sKKwlzdHJ1
Y3QgbWVnYXNhc19jbWRfZnVzaW9uICpjbWQ7CisJdW5pb24gTUVHQVNBU19SRVFVRVNUX0RFU0NS
SVBUT1JfVU5JT04gKnJlcV9kZXNjOworCXUzMiBpbmRleDsKKwlzdHJ1Y3QgZnVzaW9uX2NvbnRl
eHQgKmZ1c2lvbjsKKworCWZ1c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CisKKwljbWQg
PSBtZWdhc2FzX2dldF9jbWRfZnVzaW9uKGluc3RhbmNlKTsKKwlpZiAoIWNtZCkKKwkJcmV0dXJu
IFNDU0lfTUxRVUVVRV9IT1NUX0JVU1k7CisKKwlpbmRleCA9IGNtZC0+aW5kZXg7CisKKwlyZXFf
ZGVzYyA9IG1lZ2FzYXNfZ2V0X3JlcXVlc3RfZGVzY3JpcHRvcihpbnN0YW5jZSwgaW5kZXgtMSk7
CisJaWYgKCFyZXFfZGVzYykKKwkJcmV0dXJuIDE7CisKKwlyZXFfZGVzYy0+V29yZHMgPSAwOwor
CWNtZC0+cmVxdWVzdF9kZXNjID0gcmVxX2Rlc2M7CisJY21kLT5yZXF1ZXN0X2Rlc2MtPldvcmRz
ID0gMDsKKworCWlmIChtZWdhc2FzX2J1aWxkX2lvX2Z1c2lvbihpbnN0YW5jZSwgc2NtZCwgY21k
KSkgeworCQltZWdhc2FzX3JldHVybl9jbWRfZnVzaW9uKGluc3RhbmNlLCBjbWQpOworCQlwcmlu
dGsoS0VSTl9FUlIgIm1lZ2FzYXM6IEVycm9yIGJ1aWxkaW5nIGNvbW1hbmQuXG4iKTsKKwkJY21k
LT5yZXF1ZXN0X2Rlc2MgPSBOVUxMOworCQlyZXR1cm4gMTsKKwl9CisKKwlyZXFfZGVzYyA9IGNt
ZC0+cmVxdWVzdF9kZXNjOworCXJlcV9kZXNjLT5TQ1NJSU8uU01JRCA9IGluZGV4OworCisJaWYg
KGNtZC0+aW9fcmVxdWVzdC0+Q2hhaW5PZmZzZXQgIT0gMCAmJgorCSAgICBjbWQtPmlvX3JlcXVl
c3QtPkNoYWluT2Zmc2V0ICE9IDB4RikKKwkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBUaGUg
Y2hhaW4gb2Zmc2V0IHZhbHVlIGlzIG5vdCAiCisJCSAgICAgICAiY29ycmVjdCA6ICV4XG4iLCBj
bWQtPmlvX3JlcXVlc3QtPkNoYWluT2Zmc2V0KTsKKworCS8qCisJICogSXNzdWUgdGhlIGNvbW1h
bmQgdG8gdGhlIEZXCisJICovCisJYXRvbWljX2luYygmaW5zdGFuY2UtPmZ3X291dHN0YW5kaW5n
KTsKKworCWluc3RhbmNlLT5pbnN0YW5jZXQtPmZpcmVfY21kKGluc3RhbmNlLAorCQkJCSAgICAg
IHJlcV9kZXNjLT51LmxvdywgcmVxX2Rlc2MtPnUuaGlnaCwKKwkJCQkgICAgICBpbnN0YW5jZS0+
cmVnX3NldCk7CisKKwlyZXR1cm4gMDsKK30KKworLyoqCisgKiBjb21wbGV0ZV9jbWRfZnVzaW9u
IC0JQ29tcGxldGVzIGNvbW1hbmQKKyAqIEBpbnN0YW5jZToJCQlBZGFwdGVyIHNvZnQgc3RhdGUK
KyAqIENvbXBsZXRlcyBhbGwgY29tbWFuZHMgdGhhdCBpcyBpbiByZXBseSBkZXNjcmlwdG9yIHF1
ZXVlCisgKi8KK2ludAorY29tcGxldGVfY21kX2Z1c2lvbihzdHJ1Y3QgbWVnYXNhc19pbnN0YW5j
ZSAqaW5zdGFuY2UpCit7CisJdW5pb24gTVBJMl9SRVBMWV9ERVNDUklQVE9SU19VTklPTiAqZGVz
YzsKKwlzdHJ1Y3QgTVBJMl9TQ1NJX0lPX1NVQ0NFU1NfUkVQTFlfREVTQ1JJUFRPUiAqcmVwbHlf
ZGVzYzsKKwlzdHJ1Y3QgTVBJMl9SQUlEX1NDU0lfSU9fUkVRVUVTVCAqc2NzaV9pb19yZXE7CisJ
c3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb247CisJc3RydWN0IG1lZ2FzYXNfY21kICpjbWRf
bWZpOworCXN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24gKmNtZF9mdXNpb247CisJdTE2IHNtaWQs
IG51bV9jb21wbGV0ZWQ7CisJdTggcmVwbHlfZGVzY3JpcHRfdHlwZSwgYXJtOworCXUzMiBzdGF0
dXMsIGV4dFN0YXR1cywgZGV2aWNlX2lkOworCXVuaW9uIGRlc2NfdmFsdWUgZF92YWw7CisJc3Ry
dWN0IExEX0xPQURfQkFMQU5DRV9JTkZPICpsYmluZm87CisKKwlmdXNpb24gPSBpbnN0YW5jZS0+
Y3RybF9jb250ZXh0OworCisJaWYgKGluc3RhbmNlLT5hZHByZWNvdmVyeSA9PSBNRUdBU0FTX0hX
X0NSSVRJQ0FMX0VSUk9SKQorCQlyZXR1cm4gSVJRX0hBTkRMRUQ7CisKKwlkZXNjID0gZnVzaW9u
LT5yZXBseV9mcmFtZXNfZGVzYzsKKwlkZXNjICs9IGZ1c2lvbi0+bGFzdF9yZXBseV9pZHg7CisK
KwlyZXBseV9kZXNjID0gKHN0cnVjdCBNUEkyX1NDU0lfSU9fU1VDQ0VTU19SRVBMWV9ERVNDUklQ
VE9SICopZGVzYzsKKworCWRfdmFsLndvcmQgPSBkZXNjLT5Xb3JkczsKKworCXJlcGx5X2Rlc2Ny
aXB0X3R5cGUgPSByZXBseV9kZXNjLT5SZXBseUZsYWdzICYKKwkJTVBJMl9SUFlfREVTQ1JJUFRf
RkxBR1NfVFlQRV9NQVNLOworCisJaWYgKHJlcGx5X2Rlc2NyaXB0X3R5cGUgPT0gTVBJMl9SUFlf
REVTQ1JJUFRfRkxBR1NfVU5VU0VEKQorCQlyZXR1cm4gSVJRX05PTkU7CisKKwlkX3ZhbC53b3Jk
ID0gZGVzYy0+V29yZHM7CisKKwludW1fY29tcGxldGVkID0gMDsKKworCXdoaWxlICgoZF92YWwu
dS5sb3cgIT0gVUlOVF9NQVgpICYmIChkX3ZhbC51LmhpZ2ggIT0gVUlOVF9NQVgpKSB7CisJCXNt
aWQgPSByZXBseV9kZXNjLT5TTUlEOworCisJCWNtZF9mdXNpb24gPSBmdXNpb24tPmNtZF9saXN0
W3NtaWQgLSAxXTsKKworCQlzY3NpX2lvX3JlcSA9CisJCQkoc3RydWN0IE1QSTJfUkFJRF9TQ1NJ
X0lPX1JFUVVFU1QgKikKKwkJICBjbWRfZnVzaW9uLT5pb19yZXF1ZXN0OworCisJCWlmIChjbWRf
ZnVzaW9uLT5zY21kKQorCQkJY21kX2Z1c2lvbi0+c2NtZC0+U0NwLnB0ciA9IE5VTEw7CisKKwkJ
c3RhdHVzID0gc2NzaV9pb19yZXEtPlJhaWRDb250ZXh0LnN0YXR1czsKKwkJZXh0U3RhdHVzID0g
c2NzaV9pb19yZXEtPlJhaWRDb250ZXh0LmV4U3RhdHVzOworCisJCXN3aXRjaCAoc2NzaV9pb19y
ZXEtPkZ1bmN0aW9uKSB7CisJCWNhc2UgTVBJMl9GVU5DVElPTl9TQ1NJX0lPX1JFUVVFU1Q6ICAv
KkZhc3QgUGF0aCBJTy4qLworCQkJLyogVXBkYXRlIGxvYWQgYmFsYW5jaW5nIGluZm8gKi8KKwkJ
CWRldmljZV9pZCA9IE1FR0FTQVNfREVWX0lOREVYKGluc3RhbmNlLAorCQkJCQkJICAgICAgY21k
X2Z1c2lvbi0+c2NtZCk7CisJCQlsYmluZm8gPSAmZnVzaW9uLT5sb2FkX2JhbGFuY2VfaW5mb1tk
ZXZpY2VfaWRdOworCQkJaWYgKGNtZF9mdXNpb24tPnNjbWQtPlNDcC5TdGF0dXMgJgorCQkJICAg
IE1FR0FTQVNfTE9BRF9CQUxBTkNFX0ZMQUcpIHsKKwkJCQlhcm0gPSBsYmluZm8tPnJhaWQxRGV2
SGFuZGxlWzBdID09CisJCQkJCWNtZF9mdXNpb24tPmlvX3JlcXVlc3QtPkRldkhhbmRsZSA/IDAg
OgorCQkJCQkxOworCQkJCWF0b21pY19kZWMoJmxiaW5mby0+c2NzaV9wZW5kaW5nX2NtZHNbYXJt
XSk7CisJCQkJY21kX2Z1c2lvbi0+c2NtZC0+U0NwLlN0YXR1cyAmPQorCQkJCQl+TUVHQVNBU19M
T0FEX0JBTEFOQ0VfRkxBRzsKKwkJCX0KKwkJCWlmIChyZXBseV9kZXNjcmlwdF90eXBlID09CisJ
CQkgICAgTVBJMl9SUFlfREVTQ1JJUFRfRkxBR1NfU0NTSV9JT19TVUNDRVNTKSB7CisJCQkJaWYg
KG1lZ2FzYXNfZGJnX2x2bCA9PSA1KQorCQkJCQlwcmludGsoS0VSTl9FUlIgIlxubWVnYXNhczog
RkFTVCBQYXRoICIKKwkJCQkJICAgICAgICJJTyBTdWNjZXNzXG4iKTsKKwkJCX0KKwkJCS8qIEZh
bGwgdGhydSBhbmQgY29tcGxldGUgSU8gKi8KKwkJY2FzZSBNRUdBU0FTX01QSTJfRlVOQ1RJT05f
TERfSU9fUkVRVUVTVDogLyogTEQtSU8gUGF0aCAqLworCQkJLyogTWFwIHRoZSBGVyBDbWQgU3Rh
dHVzICovCisJCQltYXBfY21kX3N0YXR1cyhjbWRfZnVzaW9uLCBzdGF0dXMsIGV4dFN0YXR1cyk7
CisJCQlzY3NpX2RtYV91bm1hcChjbWRfZnVzaW9uLT5zY21kKTsKKwkJCWNtZF9mdXNpb24tPnNj
bWQtPnNjc2lfZG9uZShjbWRfZnVzaW9uLT5zY21kKTsKKwkJCXNjc2lfaW9fcmVxLT5SYWlkQ29u
dGV4dC5zdGF0dXMgPSAwOworCQkJc2NzaV9pb19yZXEtPlJhaWRDb250ZXh0LmV4U3RhdHVzID0g
MDsKKwkJCW1lZ2FzYXNfcmV0dXJuX2NtZF9mdXNpb24oaW5zdGFuY2UsIGNtZF9mdXNpb24pOwor
CQkJYXRvbWljX2RlYygmaW5zdGFuY2UtPmZ3X291dHN0YW5kaW5nKTsKKworCQkJYnJlYWs7CisJ
CWNhc2UgTUVHQVNBU19NUEkyX0ZVTkNUSU9OX1BBU1NUSFJVX0lPX1JFUVVFU1Q6IC8qTUZJIGNv
bW1hbmQgKi8KKwkJCWNtZF9tZmkgPSBpbnN0YW5jZS0+Y21kX2xpc3RbY21kX2Z1c2lvbi0+c3lu
Y19jbWRfaWR4XTsKKwkJCW1lZ2FzYXNfY29tcGxldGVfY21kKGluc3RhbmNlLCBjbWRfbWZpLCBE
SURfT0spOworCQkJY21kX2Z1c2lvbi0+ZmxhZ3MgPSAwOworCQkJbWVnYXNhc19yZXR1cm5fY21k
X2Z1c2lvbihpbnN0YW5jZSwgY21kX2Z1c2lvbik7CisKKwkJCWJyZWFrOworCQl9CisKKwkJZnVz
aW9uLT5sYXN0X3JlcGx5X2lkeCsrOworCQlpZiAoZnVzaW9uLT5sYXN0X3JlcGx5X2lkeCA+PSBm
dXNpb24tPnJlcGx5X3FfZGVwdGgpCisJCQlmdXNpb24tPmxhc3RfcmVwbHlfaWR4ID0gMDsKKwor
CQlkZXNjLT5Xb3JkcyA9IFVMTE9OR19NQVg7CisJCW51bV9jb21wbGV0ZWQrKzsKKworCQkvKiBH
ZXQgdGhlIG5leHQgcmVwbHkgZGVzY3JpcHRvciAqLworCQlpZiAoIWZ1c2lvbi0+bGFzdF9yZXBs
eV9pZHgpCisJCQlkZXNjID0gZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzYzsKKwkJZWxzZQorCQkJ
ZGVzYysrOworCisJCXJlcGx5X2Rlc2MgPQorCQkgIChzdHJ1Y3QgTVBJMl9TQ1NJX0lPX1NVQ0NF
U1NfUkVQTFlfREVTQ1JJUFRPUiAqKWRlc2M7CisKKwkJZF92YWwud29yZCA9IGRlc2MtPldvcmRz
OworCisJCXJlcGx5X2Rlc2NyaXB0X3R5cGUgPSByZXBseV9kZXNjLT5SZXBseUZsYWdzICYKKwkJ
CU1QSTJfUlBZX0RFU0NSSVBUX0ZMQUdTX1RZUEVfTUFTSzsKKworCQlpZiAocmVwbHlfZGVzY3Jp
cHRfdHlwZSA9PSBNUEkyX1JQWV9ERVNDUklQVF9GTEFHU19VTlVTRUQpCisJCQlicmVhazsKKwl9
CisKKwlpZiAoIW51bV9jb21wbGV0ZWQpCisJCXJldHVybiBJUlFfTk9ORTsKKworCXdtYigpOwor
CXdyaXRlbChmdXNpb24tPmxhc3RfcmVwbHlfaWR4LAorCSAgICAgICAmaW5zdGFuY2UtPnJlZ19z
ZXQtPnJlcGx5X3Bvc3RfaG9zdF9pbmRleCk7CisKKwlyZXR1cm4gSVJRX0hBTkRMRUQ7Cit9CisK
Ky8qKgorICogbWVnYXNhc19jb21wbGV0ZV9jbWRfZHBjX2Z1c2lvbiAtCUNvbXBsZXRlcyBjb21t
YW5kCisgKiBAaW5zdGFuY2U6CQkJQWRhcHRlciBzb2Z0IHN0YXRlCisgKgorICogVGFza2xldCB0
byBjb21wbGV0ZSBjbWRzCisgKi8KK3ZvaWQKK21lZ2FzYXNfY29tcGxldGVfY21kX2RwY19mdXNp
b24odW5zaWduZWQgbG9uZyBpbnN0YW5jZV9hZGRyKQoreworCXN0cnVjdCBtZWdhc2FzX2luc3Rh
bmNlICppbnN0YW5jZSA9CisJCShzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqKWluc3RhbmNlX2Fk
ZHI7CisJdW5zaWduZWQgbG9uZyBmbGFnczsKKworCS8qIElmIHdlIGhhdmUgYWxyZWFkeSBkZWNs
YXJlZCBhZGFwdGVyIGRlYWQsIGRvbm90IGNvbXBsZXRlIGNtZHMgKi8KKwlzcGluX2xvY2tfaXJx
c2F2ZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBmbGFncyk7CisJaWYgKGluc3RhbmNlLT5hZHByZWNv
dmVyeSA9PSBNRUdBU0FTX0hXX0NSSVRJQ0FMX0VSUk9SKSB7CisJCXNwaW5fdW5sb2NrX2lycXJl
c3RvcmUoJmluc3RhbmNlLT5oYmFfbG9jaywgZmxhZ3MpOworCQlyZXR1cm47CisJfQorCXNwaW5f
dW5sb2NrX2lycXJlc3RvcmUoJmluc3RhbmNlLT5oYmFfbG9jaywgZmxhZ3MpOworCisJc3Bpbl9s
b2NrX2lycXNhdmUoJmluc3RhbmNlLT5jb21wbGV0aW9uX2xvY2ssIGZsYWdzKTsKKwljb21wbGV0
ZV9jbWRfZnVzaW9uKGluc3RhbmNlKTsKKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZpbnN0YW5j
ZS0+Y29tcGxldGlvbl9sb2NrLCBmbGFncyk7Cit9CisKKy8qKgorICogbWVnYXNhc19pc3JfZnVz
aW9uIC0gaXNyIGVudHJ5IHBvaW50CisgKi8KK2lycXJldHVybl90IG1lZ2FzYXNfaXNyX2Z1c2lv
bihpbnQgaXJxLCB2b2lkICpkZXZwKQoreworCXN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0
YW5jZSA9IChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqKWRldnA7CisJdTMyIG1maVN0YXR1cywg
Zndfc3RhdGU7CisKKwlpZiAoIWluc3RhbmNlLT5tc2lfZmxhZykgeworCQltZmlTdGF0dXMgPSBp
bnN0YW5jZS0+aW5zdGFuY2V0LT5jbGVhcl9pbnRyKGluc3RhbmNlLT5yZWdfc2V0KTsKKwkJaWYg
KCFtZmlTdGF0dXMpCisJCQlyZXR1cm4gSVJRX05PTkU7CisJfQorCisJLyogSWYgd2UgYXJlIHJl
c2V0dGluZywgYmFpbCAqLworCWlmICh0ZXN0X2JpdChNRUdBU0FTX0ZVU0lPTl9JTl9SRVNFVCwg
Jmluc3RhbmNlLT5yZXNldF9mbGFncykpCisJCXJldHVybiBJUlFfSEFORExFRDsKKworCWlmICgh
Y29tcGxldGVfY21kX2Z1c2lvbihpbnN0YW5jZSkpIHsKKwkJLyogSWYgd2UgZGlkbid0IGNvbXBs
ZXRlIGFueSBjb21tYW5kcywgY2hlY2sgZm9yIEZXIGZhdWx0ICovCisJCWZ3X3N0YXRlID0gaW5z
dGFuY2UtPmluc3RhbmNldC0+cmVhZF9md19zdGF0dXNfcmVnKAorCQkJaW5zdGFuY2UtPnJlZ19z
ZXQpICYgTUZJX1NUQVRFX01BU0s7CisJCWlmIChmd19zdGF0ZSA9PSBNRklfU1RBVEVfRkFVTFQp
CisJCQlzY2hlZHVsZV93b3JrKCZpbnN0YW5jZS0+d29ya19pbml0KTsKKwl9CisKKwlyZXR1cm4g
SVJRX0hBTkRMRUQ7Cit9CisKKy8qKgorICogYnVpbGRfbXB0X21maV9wYXNzX3RocnUgLSBidWls
ZHMgYSBjbWQgZm8gTUZJIFBhc3MgdGhydQorICogQGluc3RhbmNlOgkJCUFkYXB0ZXIgc29mdCBz
dGF0ZQorICogbWZpX2NtZDoJCQltZWdhc2FzX2NtZCBwb2ludGVyCisgKgorICovCit1OAorYnVp
bGRfbXB0X21maV9wYXNzX3RocnUoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAor
CQkJc3RydWN0IG1lZ2FzYXNfY21kICptZmlfY21kKQoreworCXN0cnVjdCBNUEkyNV9JRUVFX1NH
RV9DSEFJTjY0ICptcGkyNV9pZWVlX2NoYWluOworCXN0cnVjdCBNUEkyX1JBSURfU0NTSV9JT19S
RVFVRVNUICppb19yZXE7CisJc3RydWN0IG1lZ2FzYXNfY21kX2Z1c2lvbiAqY21kOworCXN0cnVj
dCBmdXNpb25fY29udGV4dCAqZnVzaW9uOworCXN0cnVjdCBtZWdhc2FzX2hlYWRlciAqZnJhbWVf
aGRyID0gJm1maV9jbWQtPmZyYW1lLT5oZHI7CisKKwljbWQgPSBtZWdhc2FzX2dldF9jbWRfZnVz
aW9uKGluc3RhbmNlKTsKKwlpZiAoIWNtZCkKKwkJcmV0dXJuIDE7CisKKwkvKiAgU2F2ZSB0aGUg
c21pZC4gVG8gYmUgdXNlZCBmb3IgcmV0dXJuaW5nIHRoZSBjbWQgKi8KKwltZmlfY21kLT5jb250
ZXh0LnNtaWQgPSBjbWQtPmluZGV4OworCisJY21kLT5zeW5jX2NtZF9pZHggPSBtZmlfY21kLT5p
bmRleDsKKworCS8qCisJICogRm9yIGNtZHMgd2hlcmUgdGhlIGZsYWcgaXMgc2V0LCBzdG9yZSB0
aGUgZmxhZyBhbmQgY2hlY2sKKwkgKiBvbiBjb21wbGV0aW9uLiBGb3IgY21kcyB3aXRoIHRoaXMg
ZmxhZywgZG9uJ3QgY2FsbAorCSAqIG1lZ2FzYXNfY29tcGxldGVfY21kCisJICovCisKKwlpZiAo
ZnJhbWVfaGRyLT5mbGFncyAmIE1GSV9GUkFNRV9ET05UX1BPU1RfSU5fUkVQTFlfUVVFVUUpCisJ
CWNtZC0+ZmxhZ3MgPSBNRklfRlJBTUVfRE9OVF9QT1NUX0lOX1JFUExZX1FVRVVFOworCisJZnVz
aW9uID0gaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKKwlpb19yZXEgPSBjbWQtPmlvX3JlcXVlc3Q7
CisJbXBpMjVfaWVlZV9jaGFpbiA9CisJICAoc3RydWN0IE1QSTI1X0lFRUVfU0dFX0NIQUlONjQg
KikmaW9fcmVxLT5TR0wuSWVlZUNoYWluOworCisJaW9fcmVxLT5GdW5jdGlvbiAgICA9IE1FR0FT
QVNfTVBJMl9GVU5DVElPTl9QQVNTVEhSVV9JT19SRVFVRVNUOworCWlvX3JlcS0+U0dMT2Zmc2V0
MCAgPSBvZmZzZXRvZihzdHJ1Y3QgTVBJMl9SQUlEX1NDU0lfSU9fUkVRVUVTVCwKKwkJCQkgICAg
ICAgU0dMKSAvIDQ7CisJaW9fcmVxLT5DaGFpbk9mZnNldCA9IGZ1c2lvbi0+Y2hhaW5fb2Zmc2V0
X21maV9wdGhydTsKKworCW1waTI1X2llZWVfY2hhaW4tPkFkZHJlc3MgPSBtZmlfY21kLT5mcmFt
ZV9waHlzX2FkZHI7CisKKwltcGkyNV9pZWVlX2NoYWluLT5GbGFncyA9IElFRUVfU0dFX0ZMQUdT
X0NIQUlOX0VMRU1FTlQgfAorCQlNUEkyX0lFRUVfU0dFX0ZMQUdTX0lPQ1BMQk5UQV9BRERSOwor
CisJbXBpMjVfaWVlZV9jaGFpbi0+TGVuZ3RoID0gTUVHQVNBU19NQVhfU1pfQ0hBSU5fRlJBTUU7
CisKKwlyZXR1cm4gMDsKK30KKworLyoqCisgKiBidWlsZF9tcHRfY21kIC0gQ2FsbHMgaGVscGVy
IGZ1bmN0aW9uIHRvIGJ1aWxkIGEgY21kIE1GSSBQYXNzIHRocnUgY21kCisgKiBAaW5zdGFuY2U6
CQkJQWRhcHRlciBzb2Z0IHN0YXRlCisgKiBAY21kOgkJCW1maSBjbWQgdG8gYnVpbGQKKyAqCisg
Ki8KK3VuaW9uIE1FR0FTQVNfUkVRVUVTVF9ERVNDUklQVE9SX1VOSU9OICoKK2J1aWxkX21wdF9j
bWQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLCBzdHJ1Y3QgbWVnYXNhc19jbWQg
KmNtZCkKK3sKKwl1bmlvbiBNRUdBU0FTX1JFUVVFU1RfREVTQ1JJUFRPUl9VTklPTiAqcmVxX2Rl
c2M7CisJdTE2IGluZGV4OworCisJaWYgKGJ1aWxkX21wdF9tZmlfcGFzc190aHJ1KGluc3RhbmNl
LCBjbWQpKSB7CisJCXByaW50ayhLRVJOX0VSUiAiQ291bGRuJ3QgYnVpbGQgTUZJIHBhc3MgdGhy
dSBjbWRcbiIpOworCQlyZXR1cm4gTlVMTDsKKwl9CisKKwlpbmRleCA9IGNtZC0+Y29udGV4dC5z
bWlkOworCisJcmVxX2Rlc2MgPSBtZWdhc2FzX2dldF9yZXF1ZXN0X2Rlc2NyaXB0b3IoaW5zdGFu
Y2UsIGluZGV4IC0gMSk7CisKKwlpZiAoIXJlcV9kZXNjKQorCQlyZXR1cm4gTlVMTDsKKworCXJl
cV9kZXNjLT5Xb3JkcyA9IDA7CisJcmVxX2Rlc2MtPlNDU0lJTy5SZXF1ZXN0RmxhZ3MgPSAoTVBJ
Ml9SRVFfREVTQ1JJUFRfRkxBR1NfU0NTSV9JTyA8PAorCQkJCQkgTUVHQVNBU19SRVFfREVTQ1JJ
UFRfRkxBR1NfVFlQRV9TSElGVCk7CisKKwlyZXFfZGVzYy0+U0NTSUlPLlNNSUQgPSBpbmRleDsK
KworCXJldHVybiByZXFfZGVzYzsKK30KKworLyoqCisgKiBtZWdhc2FzX2lzc3VlX2RjbWRfZnVz
aW9uIC0gSXNzdWVzIGEgTUZJIFBhc3MgdGhydSBjbWQKKyAqIEBpbnN0YW5jZToJCQlBZGFwdGVy
IHNvZnQgc3RhdGUKKyAqIEBjbWQ6CQkJbWZpIGNtZCBwb2ludGVyCisgKgorICovCit2b2lkCitt
ZWdhc2FzX2lzc3VlX2RjbWRfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5j
ZSwKKwkJCSAgc3RydWN0IG1lZ2FzYXNfY21kICpjbWQpCit7CisJdW5pb24gTUVHQVNBU19SRVFV
RVNUX0RFU0NSSVBUT1JfVU5JT04gKnJlcV9kZXNjOworCXVuaW9uIGRlc2NfdmFsdWUgZF92YWw7
CisKKwlyZXFfZGVzYyA9IGJ1aWxkX21wdF9jbWQoaW5zdGFuY2UsIGNtZCk7CisJaWYgKCFyZXFf
ZGVzYykgeworCQlwcmludGsoS0VSTl9FUlIgIkNvdWxkbid0IGlzc3VlIE1GSSBwYXNzIHRocnUg
Y21kXG4iKTsKKwkJcmV0dXJuOworCX0KKwlkX3ZhbC53b3JkID0gcmVxX2Rlc2MtPldvcmRzOwor
CisJaW5zdGFuY2UtPmluc3RhbmNldC0+ZmlyZV9jbWQoaW5zdGFuY2UsIHJlcV9kZXNjLT51Lmxv
dywKKwkJCQkgICAgICByZXFfZGVzYy0+dS5oaWdoLCBpbnN0YW5jZS0+cmVnX3NldCk7Cit9CisK
Ky8qKgorICogbWVnYXNhc19yZWxlYXNlX2Z1c2lvbiAtCVJldmVyc2VzIHRoZSBGVyBpbml0aWFs
aXphdGlvbgorICogQGludGFuY2U6CQkJQWRhcHRlciBzb2Z0IHN0YXRlCisgKi8KK3ZvaWQKK21l
Z2FzYXNfcmVsZWFzZV9mdXNpb24oc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQor
eworCW1lZ2FzYXNfZnJlZV9jbWRzKGluc3RhbmNlKTsKKwltZWdhc2FzX2ZyZWVfY21kc19mdXNp
b24oaW5zdGFuY2UpOworCisJaW91bm1hcChpbnN0YW5jZS0+cmVnX3NldCk7CisKKwlwY2lfcmVs
ZWFzZV9zZWxlY3RlZF9yZWdpb25zKGluc3RhbmNlLT5wZGV2LCBpbnN0YW5jZS0+YmFyKTsKK30K
KworLyoqCisgKiBtZWdhc2FzX3JlYWRfZndfc3RhdHVzX3JlZ19mdXNpb24gLSByZXR1cm5zIHRo
ZSBjdXJyZW50IEZXIHN0YXR1cyB2YWx1ZQorICogQHJlZ3M6CQkJTUZJIHJlZ2lzdGVyIHNldAor
ICovCitzdGF0aWMgdTMyCittZWdhc2FzX3JlYWRfZndfc3RhdHVzX3JlZ19mdXNpb24oc3RydWN0
IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9tZW0gKnJlZ3MpCit7CisJcmV0dXJuIHJlYWRsKCYo
cmVncyktPm91dGJvdW5kX3NjcmF0Y2hfcGFkKTsKK30KKworLyoqCisgKiBtZWdhc2FzX2FkcF9y
ZXNldF9mdXNpb24gLQlGb3IgY29udHJvbGxlciByZXNldAorICogQHJlZ3M6CQkJCU1GSSByZWdp
c3RlciBzZXQKKyAqLworc3RhdGljIGludAorbWVnYXNhc19hZHBfcmVzZXRfZnVzaW9uKHN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKKwkJCSBzdHJ1Y3QgbWVnYXNhc19yZWdpc3Rl
cl9zZXQgX19pb21lbSAqcmVncykKK3sKKwlyZXR1cm4gMDsKK30KKworLyoqCisgKiBtZWdhc2Fz
X2NoZWNrX3Jlc2V0X2Z1c2lvbiAtCUZvciBjb250cm9sbGVyIHJlc2V0IGNoZWNrCisgKiBAcmVn
czoJCQkJTUZJIHJlZ2lzdGVyIHNldAorICovCitzdGF0aWMgaW50CittZWdhc2FzX2NoZWNrX3Jl
c2V0X2Z1c2lvbihzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsCisJCQkgICBzdHJ1
Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncykKK3sKKwlyZXR1cm4gMDsKK30K
KworLyogVGhpcyBmdW5jdGlvbiB3YWl0cyBmb3Igb3V0c3RhbmRpbmcgY29tbWFuZHMgb24gZnVz
aW9uIHRvIGNvbXBsZXRlICovCitpbnQgbWVnYXNhc193YWl0X2Zvcl9vdXRzdGFuZGluZ19mdXNp
b24oc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQoreworCWludCBpLCBvdXRzdGFu
ZGluZywgcmV0dmFsID0gMDsKKwl1MzIgZndfc3RhdGUsIHdhaXRfdGltZSA9IE1FR0FTQVNfUkVT
RVRfV0FJVF9USU1FOworCisJZm9yIChpID0gMDsgaSA8IHdhaXRfdGltZTsgaSsrKSB7CisJCS8q
IENoZWNrIGlmIGZpcm13YXJlIGlzIGluIGZhdWx0IHN0YXRlICovCisJCWZ3X3N0YXRlID0gaW5z
dGFuY2UtPmluc3RhbmNldC0+cmVhZF9md19zdGF0dXNfcmVnKAorCQkJaW5zdGFuY2UtPnJlZ19z
ZXQpICYgTUZJX1NUQVRFX01BU0s7CisJCWlmIChmd19zdGF0ZSA9PSBNRklfU1RBVEVfRkFVTFQp
IHsKKwkJCXByaW50ayhLRVJOX1dBUk5JTkcgIm1lZ2FzYXM6IEZvdW5kIEZXIGluIEZBVUxUIHN0
YXRlLCIKKwkJCSAgICAgICAiIHdpbGwgcmVzZXQgYWRhcHRlci5cbiIpOworCQkJcmV0dmFsID0g
MTsKKwkJCWdvdG8gb3V0OworCQl9CisKKwkJb3V0c3RhbmRpbmcgPSBhdG9taWNfcmVhZCgmaW5z
dGFuY2UtPmZ3X291dHN0YW5kaW5nKTsKKwkJaWYgKCFvdXRzdGFuZGluZykKKwkJCWdvdG8gb3V0
OworCisJCWlmICghKGkgJSBNRUdBU0FTX1JFU0VUX05PVElDRV9JTlRFUlZBTCkpIHsKKwkJCXBy
aW50ayhLRVJOX05PVElDRSAibWVnYXNhczogWyUyZF13YWl0aW5nIGZvciAlZCAiCisJCQkgICAg
ICAgImNvbW1hbmRzIHRvIGNvbXBsZXRlXG4iLCBpLCBvdXRzdGFuZGluZyk7CisJCQltZWdhc2Fz
X2NvbXBsZXRlX2NtZF9kcGNfZnVzaW9uKAorCQkJCSh1bnNpZ25lZCBsb25nKWluc3RhbmNlKTsK
KwkJfQorCQltc2xlZXAoMTAwMCk7CisJfQorCisJaWYgKGF0b21pY19yZWFkKCZpbnN0YW5jZS0+
Zndfb3V0c3RhbmRpbmcpKSB7CisJCXByaW50aygibWVnYXJhaWRfc2FzOiBwZW5kaW5nIGNvbW1h
bmRzIHJlbWFpbiBhZnRlciB3YWl0aW5nLCAiCisJCSAgICAgICAid2lsbCByZXNldCBhZGFwdGVy
LlxuIik7CisJCXJldHZhbCA9IDE7CisJfQorb3V0OgorCXJldHVybiByZXR2YWw7Cit9CisKK3Zv
aWQgIG1lZ2FzYXNfcmVzZXRfcmVwbHlfZGVzYyhzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5z
dGFuY2UpCit7CisJaW50IGk7CisJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb247CisJdW5p
b24gTVBJMl9SRVBMWV9ERVNDUklQVE9SU19VTklPTiAqcmVwbHlfZGVzYzsKKworCWZ1c2lvbiA9
IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CisJZnVzaW9uLT5sYXN0X3JlcGx5X2lkeCA9IDA7CisJ
cmVwbHlfZGVzYyA9IGZ1c2lvbi0+cmVwbHlfZnJhbWVzX2Rlc2M7CisJZm9yIChpID0gMCA7IGkg
PCBmdXNpb24tPnJlcGx5X3FfZGVwdGg7IGkrKywgcmVwbHlfZGVzYysrKQorCQlyZXBseV9kZXNj
LT5Xb3JkcyA9IFVMTE9OR19NQVg7Cit9CisKKy8qIENvcmUgZnVzaW9uIHJlc2V0IGZ1bmN0aW9u
ICovCitpbnQgbWVnYXNhc19yZXNldF9mdXNpb24oc3RydWN0IHNjc2lfY21uZCAqc2NtZCkKK3sK
KwlpbnQgcmV0dmFsID0gU1VDQ0VTUywgaSwgaiwgcmV0cnkgPSAwOworCXN0cnVjdCBtZWdhc2Fz
X2luc3RhbmNlICppbnN0YW5jZTsKKwlzdHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uICpjbWRfZnVz
aW9uOworCXN0cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uOworCXN0cnVjdCBtZWdhc2FzX2Nt
ZCAqY21kX21maTsKKwl1bmlvbiBNRUdBU0FTX1JFUVVFU1RfREVTQ1JJUFRPUl9VTklPTiAqcmVx
X2Rlc2M7CisJdTMyIGhvc3RfZGlhZywgYWJzX3N0YXRlOworCisJaW5zdGFuY2UgPSAoc3RydWN0
IG1lZ2FzYXNfaW5zdGFuY2UgKilzY21kLT5kZXZpY2UtPmhvc3QtPmhvc3RkYXRhOworCWZ1c2lv
biA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CisKKwltdXRleF9sb2NrKCZpbnN0YW5jZS0+cmVz
ZXRfbXV0ZXgpOworCXNldF9iaXQoTUVHQVNBU19GVVNJT05fSU5fUkVTRVQsICZpbnN0YW5jZS0+
cmVzZXRfZmxhZ3MpOworCWluc3RhbmNlLT5hZHByZWNvdmVyeSA9IE1FR0FTQVNfQURQUkVTRVRf
U01fSU5GQVVMVDsKKwlpbnN0YW5jZS0+aW5zdGFuY2V0LT5kaXNhYmxlX2ludHIoaW5zdGFuY2Ut
PnJlZ19zZXQpOworCW1zbGVlcCgxMDAwKTsKKworCWlmIChpbnN0YW5jZS0+YWRwcmVjb3Zlcnkg
PT0gTUVHQVNBU19IV19DUklUSUNBTF9FUlJPUikgeworCQlwcmludGsoS0VSTl9XQVJOSU5HICJt
ZWdhcmFpZF9zYXM6IEhhcmR3YXJlIGNyaXRpY2FsIGVycm9yLCAiCisJCSAgICAgICAicmV0dXJu
aW5nIEZBSUxFRC5cbiIpOworCQlyZXR2YWwgPSBGQUlMRUQ7CisJCWdvdG8gb3V0OworCX0KKwor
CS8qIEZpcnN0IHRyeSB3YWl0aW5nIGZvciBjb21tYW5kcyB0byBjb21wbGV0ZSAqLworCWlmICht
ZWdhc2FzX3dhaXRfZm9yX291dHN0YW5kaW5nX2Z1c2lvbihpbnN0YW5jZSkpIHsKKwkJcHJpbnRr
KEtFUk5fV0FSTklORyAibWVnYXJhaWRfc2FzOiByZXNldHRpbmcgZnVzaW9uICIKKwkJICAgICAg
ICJhZGFwdGVyLlxuIik7CisJCS8qIE5vdyByZXR1cm4gY29tbWFuZHMgYmFjayB0byB0aGUgT1Mg
Ki8KKwkJZm9yIChpID0gMCA7IGkgPCBpbnN0YW5jZS0+bWF4X2Z3X2NtZHM7IGkrKykgeworCQkJ
Y21kX2Z1c2lvbiA9IGZ1c2lvbi0+Y21kX2xpc3RbaV07CisJCQlpZiAoY21kX2Z1c2lvbi0+c2Nt
ZCkgeworCQkJCXNjc2lfZG1hX3VubWFwKGNtZF9mdXNpb24tPnNjbWQpOworCQkJCWNtZF9mdXNp
b24tPnNjbWQtPnJlc3VsdCA9IChESURfUkVTRVQgPDwgMTYpOworCQkJCWNtZF9mdXNpb24tPnNj
bWQtPnNjc2lfZG9uZShjbWRfZnVzaW9uLT5zY21kKTsKKwkJCQltZWdhc2FzX3JldHVybl9jbWRf
ZnVzaW9uKGluc3RhbmNlLCBjbWRfZnVzaW9uKTsKKwkJCQlhdG9taWNfZGVjKCZpbnN0YW5jZS0+
Zndfb3V0c3RhbmRpbmcpOworCQkJfQorCQl9CisKKwkJaWYgKGluc3RhbmNlLT5kaXNhYmxlT25s
aW5lQ3RybFJlc2V0ID09IDEpIHsKKwkJCS8qIFJlc2V0IG5vdCBzdXBwb3J0ZWQsIGtpbGwgYWRh
cHRlciAqLworCQkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXJhaWRfc2FzOiBSZXNldCBub3Qg
c3VwcG9ydGVkIgorCQkJICAgICAgICIsIGtpbGxpbmcgYWRhcHRlci5cbiIpOworCQkJbWVnYXJh
aWRfc2FzX2tpbGxfaGJhKGluc3RhbmNlKTsKKwkJCWluc3RhbmNlLT5hZHByZWNvdmVyeSA9IE1F
R0FTQVNfSFdfQ1JJVElDQUxfRVJST1I7CisJCQlyZXR2YWwgPSBGQUlMRUQ7CisJCQlnb3RvIG91
dDsKKwkJfQorCisJCS8qIE5vdyB0cnkgdG8gcmVzZXQgdGhlIGNoaXAgKi8KKwkJZm9yIChpID0g
MDsgaSA8IE1FR0FTQVNfRlVTSU9OX01BWF9SRVNFVF9UUklFUzsgaSsrKSB7CisJCQl3cml0ZWwo
TVBJMl9XUlNFUV9GTFVTSF9LRVlfVkFMVUUsCisJCQkgICAgICAgJmluc3RhbmNlLT5yZWdfc2V0
LT5mdXNpb25fc2VxX29mZnNldCk7CisJCQl3cml0ZWwoTVBJMl9XUlNFUV8xU1RfS0VZX1ZBTFVF
LAorCQkJICAgICAgICZpbnN0YW5jZS0+cmVnX3NldC0+ZnVzaW9uX3NlcV9vZmZzZXQpOworCQkJ
d3JpdGVsKE1QSTJfV1JTRVFfMk5EX0tFWV9WQUxVRSwKKwkJCSAgICAgICAmaW5zdGFuY2UtPnJl
Z19zZXQtPmZ1c2lvbl9zZXFfb2Zmc2V0KTsKKwkJCXdyaXRlbChNUEkyX1dSU0VRXzNSRF9LRVlf
VkFMVUUsCisJCQkgICAgICAgJmluc3RhbmNlLT5yZWdfc2V0LT5mdXNpb25fc2VxX29mZnNldCk7
CisJCQl3cml0ZWwoTVBJMl9XUlNFUV80VEhfS0VZX1ZBTFVFLAorCQkJICAgICAgICZpbnN0YW5j
ZS0+cmVnX3NldC0+ZnVzaW9uX3NlcV9vZmZzZXQpOworCQkJd3JpdGVsKE1QSTJfV1JTRVFfNVRI
X0tFWV9WQUxVRSwKKwkJCSAgICAgICAmaW5zdGFuY2UtPnJlZ19zZXQtPmZ1c2lvbl9zZXFfb2Zm
c2V0KTsKKwkJCXdyaXRlbChNUEkyX1dSU0VRXzZUSF9LRVlfVkFMVUUsCisJCQkgICAgICAgJmlu
c3RhbmNlLT5yZWdfc2V0LT5mdXNpb25fc2VxX29mZnNldCk7CisKKwkJCS8qIENoZWNrIHRoYXQg
dGhlIGRpYWcgd3JpdGUgZW5hYmxlIChEUldFKSBiaXQgaXMgb24gKi8KKwkJCWhvc3RfZGlhZyA9
IHJlYWRsKCZpbnN0YW5jZS0+cmVnX3NldC0+ZnVzaW9uX2hvc3RfZGlhZyk7CisJCQl3aGlsZSAo
IShob3N0X2RpYWcgJiBIT1NUX0RJQUdfV1JJVEVfRU5BQkxFKSkgeworCQkJCW1zbGVlcCgxMDAp
OworCQkJCWhvc3RfZGlhZyA9CisJCQkJcmVhZGwoJmluc3RhbmNlLT5yZWdfc2V0LT5mdXNpb25f
aG9zdF9kaWFnKTsKKwkJCQlpZiAocmV0cnkrKyA9PSAxMDApIHsKKwkJCQkJcHJpbnRrKEtFUk5f
V0FSTklORyAibWVnYXJhaWRfc2FzOiAiCisJCQkJCSAgICAgICAiSG9zdCBkaWFnIHVubG9jayBm
YWlsZWQhXG4iKTsKKwkJCQkJYnJlYWs7CisJCQkJfQorCQkJfQorCQkJaWYgKCEoaG9zdF9kaWFn
ICYgSE9TVF9ESUFHX1dSSVRFX0VOQUJMRSkpCisJCQkJY29udGludWU7CisKKwkJCS8qIFNlbmQg
Y2hpcCByZXNldCBjb21tYW5kICovCisJCQl3cml0ZWwoaG9zdF9kaWFnIHwgSE9TVF9ESUFHX1JF
U0VUX0FEQVBURVIsCisJCQkgICAgICAgJmluc3RhbmNlLT5yZWdfc2V0LT5mdXNpb25faG9zdF9k
aWFnKTsKKwkJCW1zbGVlcCgzMDAwKTsKKworCQkJLyogTWFrZSBzdXJlIHJlc2V0IGFkYXB0ZXIg
Yml0IGlzIGNsZWFyZWQgKi8KKwkJCWhvc3RfZGlhZyA9IHJlYWRsKCZpbnN0YW5jZS0+cmVnX3Nl
dC0+ZnVzaW9uX2hvc3RfZGlhZyk7CisJCQlyZXRyeSA9IDA7CisJCQl3aGlsZSAoaG9zdF9kaWFn
ICYgSE9TVF9ESUFHX1JFU0VUX0FEQVBURVIpIHsKKwkJCQltc2xlZXAoMTAwKTsKKwkJCQlob3N0
X2RpYWcgPQorCQkJCXJlYWRsKCZpbnN0YW5jZS0+cmVnX3NldC0+ZnVzaW9uX2hvc3RfZGlhZyk7
CisJCQkJaWYgKHJldHJ5KysgPT0gMTAwMCkgeworCQkJCQlwcmludGsoS0VSTl9XQVJOSU5HICJt
ZWdhcmFpZF9zYXM6ICIKKwkJCQkJICAgICAgICJEaWFnIHJlc2V0IGFkYXB0ZXIgbmV2ZXIgIgor
CQkJCQkgICAgICAgImNsZWFyZWQhXG4iKTsKKwkJCQkJYnJlYWs7CisJCQkJfQorCQkJfQorCQkJ
aWYgKGhvc3RfZGlhZyAmIEhPU1RfRElBR19SRVNFVF9BREFQVEVSKQorCQkJCWNvbnRpbnVlOwor
CisJCQlhYnNfc3RhdGUgPQorCQkJCWluc3RhbmNlLT5pbnN0YW5jZXQtPnJlYWRfZndfc3RhdHVz
X3JlZygKKwkJCQkJaW5zdGFuY2UtPnJlZ19zZXQpOworCQkJcmV0cnkgPSAwOworCisJCQl3aGls
ZSAoKGFic19zdGF0ZSA8PSBNRklfU1RBVEVfRldfSU5JVCkgJiYKKwkJCSAgICAgICAocmV0cnkr
KyA8IDEwMDApKSB7CisJCQkJbXNsZWVwKDEwMCk7CisJCQkJYWJzX3N0YXRlID0KKwkJCQlpbnN0
YW5jZS0+aW5zdGFuY2V0LT5yZWFkX2Z3X3N0YXR1c19yZWcoCisJCQkJCWluc3RhbmNlLT5yZWdf
c2V0KTsKKwkJCX0KKwkJCWlmIChhYnNfc3RhdGUgPD0gTUZJX1NUQVRFX0ZXX0lOSVQpIHsKKwkJ
CQlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdhcmFpZF9zYXM6IGZpcm13YXJlICIKKwkJCQkgICAg
ICAgInN0YXRlIDwgTUZJX1NUQVRFX0ZXX0lOSVQsIHN0YXRlID0gIgorCQkJCSAgICAgICAiMHgl
eFxuIiwgYWJzX3N0YXRlKTsKKwkJCQljb250aW51ZTsKKwkJCX0KKworCQkJLyogV2FpdCBmb3Ig
RlcgdG8gYmVjb21lIHJlYWR5ICovCisJCQlpZiAobWVnYXNhc190cmFuc2l0aW9uX3RvX3JlYWR5
KGluc3RhbmNlKSkgeworCQkJCXByaW50ayhLRVJOX1dBUk5JTkcgIm1lZ2FyYWlkX3NhczogRmFp
bGVkIHRvICIKKwkJCQkgICAgICAgInRyYW5zaXRpb24gY29udHJvbGxlciB0byByZWFkeS5cbiIp
OworCQkJCWNvbnRpbnVlOworCQkJfQorCisJCQltZWdhc2FzX3Jlc2V0X3JlcGx5X2Rlc2MoaW5z
dGFuY2UpOworCQkJaWYgKG1lZ2FzYXNfaW9jX2luaXRfZnVzaW9uKGluc3RhbmNlKSkgeworCQkJ
CXByaW50ayhLRVJOX1dBUk5JTkcgIm1lZ2FyYWlkX3NhczogIgorCQkJCSAgICAgICAibWVnYXNh
c19pb2NfaW5pdF9mdXNpb24oKSBmYWlsZWQhXG4iKTsKKwkJCQljb250aW51ZTsKKwkJCX0KKwor
CQkJaW5zdGFuY2UtPmluc3RhbmNldC0+ZW5hYmxlX2ludHIoaW5zdGFuY2UtPnJlZ19zZXQpOwor
CQkJaW5zdGFuY2UtPmFkcHJlY292ZXJ5ID0gTUVHQVNBU19IQkFfT1BFUkFUSU9OQUw7CisKKwkJ
CS8qIFJlLWZpcmUgbWFuYWdlbWVudCBjb21tYW5kcyAqLworCQkJZm9yIChqID0gMCA7IGogPCBp
bnN0YW5jZS0+bWF4X2Z3X2NtZHM7IGorKykgeworCQkJCWNtZF9mdXNpb24gPSBmdXNpb24tPmNt
ZF9saXN0W2pdOworCQkJCWlmIChjbWRfZnVzaW9uLT5zeW5jX2NtZF9pZHggIT0KKwkJCQkgICAg
KHUzMilVTE9OR19NQVgpIHsKKwkJCQkJY21kX21maSA9CisJCQkJCWluc3RhbmNlLT4KKwkJCQkJ
Y21kX2xpc3RbY21kX2Z1c2lvbi0+c3luY19jbWRfaWR4XTsKKwkJCQkJaWYgKGNtZF9tZmktPmZy
YW1lLT5kY21kLm9wY29kZSA9PQorCQkJCQkgICAgTVJfRENNRF9MRF9NQVBfR0VUX0lORk8pIHsK
KwkJCQkJCW1lZ2FzYXNfcmV0dXJuX2NtZChpbnN0YW5jZSwKKwkJCQkJCQkJICAgY21kX21maSk7
CisJCQkJCQltZWdhc2FzX3JldHVybl9jbWRfZnVzaW9uKAorCQkJCQkJCWluc3RhbmNlLCBjbWRf
ZnVzaW9uKTsKKwkJCQkJfSBlbHNlICB7CisJCQkJCQlyZXFfZGVzYyA9CisJCQkJCQltZWdhc2Fz
X2dldF9yZXF1ZXN0X2Rlc2NyaXB0b3IoCisJCQkJCQkJaW5zdGFuY2UsCisJCQkJCQkJY21kX21m
aS0+Y29udGV4dC5zbWlkCisJCQkJCQkJLTEpOworCQkJCQkJaWYgKCFyZXFfZGVzYykKKwkJCQkJ
CQlwcmludGsoS0VSTl9XQVJOSU5HCisJCQkJCQkJICAgICAgICJyZXFfZGVzYyBOVUxMIgorCQkJ
CQkJCSAgICAgICAiXG4iKTsKKwkJCQkJCWVsc2UgeworCQkJCQkJCWluc3RhbmNlLT5pbnN0YW5j
ZXQtPgorCQkJCQkJCWZpcmVfY21kKGluc3RhbmNlLAorCQkJCQkJCQkgcmVxX2Rlc2MtPgorCQkJ
CQkJCQkgdS5sb3csCisJCQkJCQkJCSByZXFfZGVzYy0+CisJCQkJCQkJCSB1LmhpZ2gsCisJCQkJ
CQkJCSBpbnN0YW5jZS0+CisJCQkJCQkJCSByZWdfc2V0KTsKKwkJCQkJCX0KKwkJCQkJfQorCQkJ
CX0KKwkJCX0KKworCQkJLyogUmVzZXQgbG9hZCBiYWxhbmNlIGluZm8gKi8KKwkJCW1lbXNldChm
dXNpb24tPmxvYWRfYmFsYW5jZV9pbmZvLCAwLAorCQkJICAgICAgIHNpemVvZihzdHJ1Y3QgTERf
TE9BRF9CQUxBTkNFX0lORk8pCisJCQkgICAgICAgKk1BWF9MT0dJQ0FMX0RSSVZFUyk7CisKKwkJ
CWlmICghbWVnYXNhc19nZXRfbWFwX2luZm8oaW5zdGFuY2UpKQorCQkJCW1lZ2FzYXNfc3luY19t
YXBfaW5mbyhpbnN0YW5jZSk7CisKKwkJCS8qIEFkYXB0ZXIgcmVzZXQgY29tcGxldGVkIHN1Y2Nl
c3NmdWxseSAqLworCQkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXJhaWRfc2FzOiBSZXNldCAi
CisJCQkgICAgICAgInN1Y2Nlc3NmdWwuXG4iKTsKKwkJCXJldHZhbCA9IFNVQ0NFU1M7CisJCQln
b3RvIG91dDsKKwkJfQorCQkvKiBSZXNldCBmYWlsZWQsIGtpbGwgdGhlIGFkYXB0ZXIgKi8KKwkJ
cHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXJhaWRfc2FzOiBSZXNldCBmYWlsZWQsIGtpbGxpbmcg
IgorCQkgICAgICAgImFkYXB0ZXIuXG4iKTsKKwkJbWVnYXJhaWRfc2FzX2tpbGxfaGJhKGluc3Rh
bmNlKTsKKwkJcmV0dmFsID0gRkFJTEVEOworCX0gZWxzZSB7CisJCWluc3RhbmNlLT5pbnN0YW5j
ZXQtPmVuYWJsZV9pbnRyKGluc3RhbmNlLT5yZWdfc2V0KTsKKwkJaW5zdGFuY2UtPmFkcHJlY292
ZXJ5ID0gTUVHQVNBU19IQkFfT1BFUkFUSU9OQUw7CisJfQorb3V0OgorCWNsZWFyX2JpdChNRUdB
U0FTX0ZVU0lPTl9JTl9SRVNFVCwgJmluc3RhbmNlLT5yZXNldF9mbGFncyk7CisJbXV0ZXhfdW5s
b2NrKCZpbnN0YW5jZS0+cmVzZXRfbXV0ZXgpOworCXJldHVybiByZXR2YWw7Cit9CisKKy8qIEZ1
c2lvbiBPQ1Igd29yayBxdWV1ZSAqLwordm9pZCBtZWdhc2FzX2Z1c2lvbl9vY3Jfd3Eoc3RydWN0
IHdvcmtfc3RydWN0ICp3b3JrKQoreworCXN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5j
ZSA9CisJCWNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSwgd29ya19p
bml0KTsKKworCWluc3RhbmNlLT5zY21kLmRldmljZSA9ICZpbnN0YW5jZS0+ZGV2OworCWluc3Rh
bmNlLT5kZXYuaG9zdCA9IGluc3RhbmNlLT5ob3N0OworCW1lZ2FzYXNfcmVzZXRfZnVzaW9uKCZp
bnN0YW5jZS0+c2NtZCk7Cit9CisKK3N0cnVjdCBtZWdhc2FzX2luc3RhbmNlX3RlbXBsYXRlIG1l
Z2FzYXNfaW5zdGFuY2VfdGVtcGxhdGVfZnVzaW9uID0geworCS5maXJlX2NtZCA9IG1lZ2FzYXNf
ZmlyZV9jbWRfZnVzaW9uLAorCS5lbmFibGVfaW50ciA9IG1lZ2FzYXNfZW5hYmxlX2ludHJfZnVz
aW9uLAorCS5kaXNhYmxlX2ludHIgPSBtZWdhc2FzX2Rpc2FibGVfaW50cl9mdXNpb24sCisJLmNs
ZWFyX2ludHIgPSBtZWdhc2FzX2NsZWFyX2ludHJfZnVzaW9uLAorCS5yZWFkX2Z3X3N0YXR1c19y
ZWcgPSBtZWdhc2FzX3JlYWRfZndfc3RhdHVzX3JlZ19mdXNpb24sCisJLmFkcF9yZXNldCA9IG1l
Z2FzYXNfYWRwX3Jlc2V0X2Z1c2lvbiwKKwkuY2hlY2tfcmVzZXQgPSBtZWdhc2FzX2NoZWNrX3Jl
c2V0X2Z1c2lvbiwKKwkuc2VydmljZV9pc3IgPSBtZWdhc2FzX2lzcl9mdXNpb24sCisJLnRhc2ts
ZXQgPSBtZWdhc2FzX2NvbXBsZXRlX2NtZF9kcGNfZnVzaW9uLAorCS5pbml0X2FkYXB0ZXIgPSBt
ZWdhc2FzX2luaXRfYWRhcHRlcl9mdXNpb24sCisJLmJ1aWxkX2FuZF9pc3N1ZV9jbWQgPSBtZWdh
c2FzX2J1aWxkX2FuZF9pc3N1ZV9jbWRfZnVzaW9uLAorCS5pc3N1ZV9kY21kID0gbWVnYXNhc19p
c3N1ZV9kY21kX2Z1c2lvbiwKK307Cg==
--0022152d6665ada86f04978cdd0c--
