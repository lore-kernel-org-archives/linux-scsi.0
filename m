Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59B6CA9EBC
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 941882064B
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jnqAygQN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436644AbfJWV46 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:58 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42235 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436631AbfJWV45 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:57 -0400
Received: by mail-wr1-f68.google.com with SMTP id r1so13917071wrs.9
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Pm77Ye/Wc2QHpbJVVCwP39ItUftJDLQLuOyHwPnu6gg=;
        b=jnqAygQNSxQo/JQS7cLAKEUj0VCs+yjWmlDSSooznqLpNAqcw1Bm4Xk4Ijj0VM8eWb
         786yC1Ui0mVT7KHxfW91D5F/QeP/jo+YM4pQOSOj+VpaQTvLPF9QCU2FY55TyP9/6PfC
         lC8bL6pbO40mqNzzLrS0Q8uvDIE52TSLeK24IZazLO4Ocl56nh4vGKqJdlPuUqObZWwr
         W7AS1Dra2n0CIrhccdjoh05lWsRjA/OGHHuSOEBVcTFH8P+XXVsVIGz5LVsAC0z9uQjp
         w4qqCY/0LvqKMn8KqpQoVJ0osaCRJ7NDTxzd4RNVD/2WlWhjP2e6qosWSAuHxAP+6EXP
         BYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Pm77Ye/Wc2QHpbJVVCwP39ItUftJDLQLuOyHwPnu6gg=;
        b=kdS2hLsO3+9aCnkbFnOvptpsJGGT3avPGHsz3Fa//H5tuxnnm6YZCdK29oQ5ubHkgc
         qs/vKoo/++hsgSQDWS/wYlGijLlFo3IOAPztOljsxadCVamB999kSKnSZkS+Y3dSJvjT
         7s78VgNxeBM9DreOLJ+GCRJqlaBQYopHozRRcgf6GDfe2OO9CAHt5GlSV5DSrmOAwXEx
         BhBeGf/+y3xl419aQ2H0ZrbHPAwvOGcnOLeoeO9gpFT75niTQeydQb7zOi2MGCt2b+zj
         JSUmUb/5bBdul8Au4Spnknwkor8H7mDd4fbCdkIh6+MOYPIKlVBlHQ/BXYOC/XsX/wfi
         k1AA==
X-Gm-Message-State: APjAAAUkA3RAhz5Ks1a5+NyaQHZhkw/B84A7gRwSATtjLigsD8uKTOMX
        7RF3nYbuKyks7ShEAK660E3bWoC1
X-Google-Smtp-Source: APXvYqwYMBOXKlQsQtQdfrjPCgSo7BEi+9WARZKV/8erNH8EyN5rym/k+nU8WQc7UYLvU464FHd2XQ==
X-Received: by 2002:adf:dd4d:: with SMTP id u13mr775088wrm.104.1571867811998;
        Wed, 23 Oct 2019 14:56:51 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:51 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 27/32] elx: efct: xport and hardware teardown routines
Date:   Wed, 23 Oct 2019 14:55:52 -0700
Message-Id: <20191023215557.12581-28-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191023215557.12581-1-jsmart2021@gmail.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines to detach xport and hardware objects.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_hw.c    | 499 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h    |  31 +++
 drivers/scsi/elx/efct/efct_xport.c | 483 +++++++++++++++++++++++++++++++++++
 3 files changed, 1013 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index f01a54d874b1..48cdbeebd058 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -5217,3 +5217,502 @@ efct_hw_cb_host_stat(struct efct_hw_s *hw, int status,
 
 	return 0;
 }
+
+/**
+ * @brief Called when the port control command completes.
+ *
+ * @par Description
+ * We only need to free the mailbox command buffer.
+ *
+ * @param hw Hardware context.
+ * @param status Status field from the mbox completion.
+ * @param mqe Mailbox response structure.
+ * @param arg Pointer to a callback function that signals the caller that the
+ * command is done.
+ *
+ * @return Returns 0.
+ */
+static int
+efct_hw_cb_port_control(struct efct_hw_s *hw, int status, u8 *mqe,
+			void  *arg)
+{
+	kfree(mqe);
+	return 0;
+}
+
+/**
+ * @ingroup port
+ * @brief Control a port (initialize, shutdown, or set link configuration).
+ *
+ * @par Description
+ * This function controls a port depending on the @c ctrl parameter:
+ * - @b EFCT_HW_PORT_INIT -
+ * Issues the CONFIG_LINK and INIT_LINK commands for the specified port.
+ * The HW generates an EFC_HW_DOMAIN_FOUND event when the link comes up.
+ * .
+ * - @b EFCT_HW_PORT_SHUTDOWN -
+ * Issues the DOWN_LINK command for the specified port.
+ * The HW generates an EFC_HW_DOMAIN_LOST event when the link is down.
+ * .
+ * - @b EFCT_HW_PORT_SET_LINK_CONFIG -
+ * Sets the link configuration.
+ *
+ * @param hw Hardware context.
+ * @param ctrl Specifies the operation:
+ * - EFCT_HW_PORT_INIT
+ * - EFCT_HW_PORT_SHUTDOWN
+ * - EFCT_HW_PORT_SET_LINK_CONFIG
+ *
+ * @param value Operation-specific value.
+ * - EFCT_HW_PORT_INIT - Selective reset AL_PA
+ * - EFCT_HW_PORT_SHUTDOWN - N/A
+ *
+ * @param cb Callback function to invoke the following operation.
+ * - EFCT_HW_PORT_INIT/EFCT_HW_PORT_SHUTDOWN - NULL (link events
+ * are handled by the EFCT_HW_CB_DOMAIN callbacks).
+ *
+ * @param arg Callback argument invoked after the command completes.
+ * - EFCT_HW_PORT_INIT/EFCT_HW_PORT_SHUTDOWN - NULL (link events
+ * are handled by the EFCT_HW_CB_DOMAIN callbacks).
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+enum efct_hw_rtn_e
+efct_hw_port_control(struct efct_hw_s *hw, enum efct_hw_port_e ctrl,
+		     uintptr_t value,
+		void (*cb)(int status, uintptr_t value, void *arg),
+		void *arg)
+{
+	enum efct_hw_rtn_e rc = EFCT_HW_RTN_ERROR;
+
+	switch (ctrl) {
+	case EFCT_HW_PORT_INIT:
+	{
+		u8	*init_link;
+		u32 speed = 0;
+		u8 reset_alpa = 0;
+
+		u8	*cfg_link;
+
+		cfg_link = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+		if (!cfg_link)
+			return EFCT_HW_RTN_NO_MEMORY;
+
+		if (!sli_cmd_config_link(&hw->sli, cfg_link,
+					SLI4_BMBX_SIZE))
+			rc = efct_hw_command(hw, cfg_link,
+					     EFCT_CMD_NOWAIT,
+					     efct_hw_cb_port_control,
+					     NULL);
+
+		if (rc != EFCT_HW_RTN_SUCCESS) {
+			kfree(cfg_link);
+			efc_log_err(hw->os, "CONFIG_LINK failed\n");
+			break;
+		}
+		speed = hw->config.speed;
+		reset_alpa = (u8)(value & 0xff);
+
+		/* Allocate a new buffer for the init_link command */
+		init_link = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+		if (!init_link)
+			return EFCT_HW_RTN_NO_MEMORY;
+
+		rc = EFCT_HW_RTN_ERROR;
+		if (!sli_cmd_init_link(&hw->sli, init_link, SLI4_BMBX_SIZE,
+				      speed, reset_alpa))
+			rc = efct_hw_command(hw, init_link, EFCT_CMD_NOWAIT,
+					     efct_hw_cb_port_control, NULL);
+		/* Free buffer on error, since no callback is coming */
+		if (rc != EFCT_HW_RTN_SUCCESS) {
+			kfree(init_link);
+			efc_log_err(hw->os, "INIT_LINK failed\n");
+		}
+		break;
+	}
+	case EFCT_HW_PORT_SHUTDOWN:
+	{
+		u8	*down_link;
+
+		down_link = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+		if (!down_link)
+			return EFCT_HW_RTN_NO_MEMORY;
+
+		if (!sli_cmd_down_link(&hw->sli, down_link, SLI4_BMBX_SIZE))
+			rc = efct_hw_command(hw, down_link, EFCT_CMD_NOWAIT,
+					     efct_hw_cb_port_control, NULL);
+		/* Free buffer on error, since no callback is coming */
+		if (rc != EFCT_HW_RTN_SUCCESS) {
+			kfree(down_link);
+			efc_log_err(hw->os, "DOWN_LINK failed\n");
+		}
+		break;
+	}
+	default:
+		efc_log_test(hw->os, "unhandled control %#x\n", ctrl);
+		break;
+	}
+
+	return rc;
+}
+
+/**
+ * @ingroup devInitShutdown
+ * @brief Tear down the Hardware Abstraction Layer module.
+ *
+ * @par Description
+ * Frees memory structures needed by the device, and shuts down the device.
+ * Does not free the HW context memory (which is done by the caller).
+ *
+ * @param hw Hardware context allocated by the caller.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+enum efct_hw_rtn_e
+efct_hw_teardown(struct efct_hw_s *hw)
+{
+	u32	i = 0;
+	u32	iters = 10;
+	u32	max_rpi;
+	u32 destroy_queues;
+	u32 free_memory;
+	struct efc_dma_s *dma;
+	struct efct_s *efct = hw->os;
+
+	destroy_queues = (hw->state == EFCT_HW_STATE_ACTIVE);
+	free_memory = (hw->state != EFCT_HW_STATE_UNINITIALIZED);
+
+	/* shutdown target wqe timer */
+	shutdown_target_wqe_timer(hw);
+
+	/* Cancel watchdog timer if enabled */
+	if (hw->watchdog_timeout) {
+		hw->watchdog_timeout = 0;
+		efct_hw_config_watchdog_timer(hw);
+	}
+
+	/* Cancel Sliport Healthcheck */
+	if (hw->sliport_healthcheck) {
+		hw->sliport_healthcheck = 0;
+		efct_hw_config_sli_port_health_check(hw, 0, 0);
+	}
+
+	if (hw->state != EFCT_HW_STATE_QUEUES_ALLOCATED) {
+		hw->state = EFCT_HW_STATE_TEARDOWN_IN_PROGRESS;
+
+		efct_hw_flush(hw);
+
+		/*
+		 * If there are outstanding commands, wait for them to complete
+		 */
+		while (!list_empty(&hw->cmd_head) && iters) {
+			mdelay(10);
+			efct_hw_flush(hw);
+			iters--;
+		}
+
+		if (list_empty(&hw->cmd_head))
+			efc_log_debug(hw->os,
+				       "All commands completed on MQ queue\n");
+		else
+			efc_log_debug(hw->os,
+				       "Some cmds still pending on MQ queue\n");
+
+		/* Cancel any remaining commands */
+		efct_hw_command_cancel(hw);
+	} else {
+		hw->state = EFCT_HW_STATE_TEARDOWN_IN_PROGRESS;
+	}
+
+	max_rpi = hw->sli.qinfo.max_qcount[SLI_RSRC_RPI];
+	if (hw->rpi_ref) {
+		for (i = 0; i < max_rpi; i++) {
+			u32 count;
+
+			count = atomic_read(&hw->rpi_ref[i].rpi_count);
+			if (count)
+				efc_log_debug(hw->os,
+					       "non-zero ref [%d]=%d\n",
+					       i, count);
+		}
+		kfree(hw->rpi_ref);
+		hw->rpi_ref = NULL;
+	}
+
+	dma_free_coherent(&efct->pcidev->dev,
+			  hw->rnode_mem.size, hw->rnode_mem.virt,
+			  hw->rnode_mem.phys);
+	memset(&hw->rnode_mem, 0, sizeof(struct efc_dma_s));
+
+	if (hw->io) {
+		for (i = 0; i < hw->config.n_io; i++) {
+			if (hw->io[i] && hw->io[i]->sgl &&
+			    hw->io[i]->sgl->virt) {
+				dma_free_coherent(&efct->pcidev->dev,
+						  hw->io[i]->sgl->size,
+						  hw->io[i]->sgl->virt,
+						  hw->io[i]->sgl->phys);
+				memset(&hw->io[i]->sgl, 0,
+				       sizeof(struct efc_dma_s));
+			}
+			kfree(hw->io[i]);
+			hw->io[i] = NULL;
+		}
+		kfree(hw->io);
+		hw->io = NULL;
+		kfree(hw->wqe_buffs);
+		hw->wqe_buffs = NULL;
+	}
+
+	dma = &hw->xfer_rdy;
+	dma_free_coherent(&efct->pcidev->dev,
+			  dma->size, dma->virt, dma->phys);
+	memset(dma, 0, sizeof(struct efc_dma_s));
+
+	dma = &hw->dump_sges;
+	dma_free_coherent(&efct->pcidev->dev,
+			  dma->size, dma->virt, dma->phys);
+	memset(dma, 0, sizeof(struct efc_dma_s));
+
+	dma = &hw->loop_map;
+	dma_free_coherent(&efct->pcidev->dev,
+			  dma->size, dma->virt, dma->phys);
+	memset(dma, 0, sizeof(struct efc_dma_s));
+
+	for (i = 0; i < hw->wq_count; i++)
+		sli_queue_free(&hw->sli, &hw->wq[i], destroy_queues,
+			       free_memory);
+
+	for (i = 0; i < hw->rq_count; i++)
+		sli_queue_free(&hw->sli, &hw->rq[i], destroy_queues,
+			       free_memory);
+
+	for (i = 0; i < hw->mq_count; i++)
+		sli_queue_free(&hw->sli, &hw->mq[i], destroy_queues,
+			       free_memory);
+
+	for (i = 0; i < hw->cq_count; i++)
+		sli_queue_free(&hw->sli, &hw->cq[i], destroy_queues,
+			       free_memory);
+
+	for (i = 0; i < hw->eq_count; i++)
+		sli_queue_free(&hw->sli, &hw->eq[i], destroy_queues,
+			       free_memory);
+
+	efct_hw_qtop_free(hw->qtop);
+
+	/* Free rq buffers */
+	efct_hw_rx_free(hw);
+
+	efct_hw_queue_teardown(hw);
+
+	if (sli_teardown(&hw->sli))
+		efc_log_err(hw->os, "SLI teardown failed\n");
+
+	/* record the fact that the queues are non-functional */
+	hw->state = EFCT_HW_STATE_UNINITIALIZED;
+
+	/* free sequence free pool */
+	efct_array_free(hw->seq_pool);
+	hw->seq_pool = NULL;
+
+	/* free hw_wq_callback pool */
+	efct_pool_free(hw->wq_reqtag_pool);
+
+	/* Mark HW setup as not having been called */
+	hw->hw_setup_called = false;
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+static enum efct_hw_rtn_e
+efct_hw_sli_reset(struct efct_hw_s *hw, enum efct_hw_reset_e reset,
+		  enum efct_hw_state_e prev_state)
+{
+	enum efct_hw_rtn_e rc = EFCT_HW_RTN_SUCCESS;
+
+	switch (reset) {
+	case EFCT_HW_RESET_FUNCTION:
+		efc_log_debug(hw->os, "issuing function level reset\n");
+		if (sli_reset(&hw->sli)) {
+			efc_log_err(hw->os, "sli_reset failed\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	case EFCT_HW_RESET_FIRMWARE:
+		efc_log_debug(hw->os, "issuing firmware reset\n");
+		if (sli_fw_reset(&hw->sli)) {
+			efc_log_err(hw->os, "sli_soft_reset failed\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		/*
+		 * Because the FW reset leaves the FW in a non-running state,
+		 * follow that with a regular reset.
+		 */
+		efc_log_debug(hw->os, "issuing function level reset\n");
+		if (sli_reset(&hw->sli)) {
+			efc_log_err(hw->os, "sli_reset failed\n");
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	default:
+		efc_log_err(hw->os,
+			     "unknown reset type - no reset performed\n");
+		hw->state = prev_state;
+		rc = EFCT_HW_RTN_INVALID_ARG;
+		break;
+	}
+
+	return rc;
+}
+
+enum efct_hw_rtn_e
+efct_hw_reset(struct efct_hw_s *hw, enum efct_hw_reset_e reset)
+{
+	u32	i;
+	enum efct_hw_rtn_e rc = EFCT_HW_RTN_SUCCESS;
+	u32	iters;
+	enum efct_hw_state_e prev_state = hw->state;
+	unsigned long flags = 0;
+	struct efct_hw_io_s *temp;
+	u32 destroy_queues;
+	u32 free_memory;
+
+	if (hw->state != EFCT_HW_STATE_ACTIVE)
+		efc_log_test(hw->os,
+			      "HW state %d is not active\n", hw->state);
+
+	destroy_queues = (hw->state == EFCT_HW_STATE_ACTIVE);
+	free_memory = (hw->state != EFCT_HW_STATE_UNINITIALIZED);
+	hw->state = EFCT_HW_STATE_RESET_IN_PROGRESS;
+
+	/*
+	 * If the prev_state is already reset/teardown in progress,
+	 * don't continue further
+	 */
+	if (prev_state == EFCT_HW_STATE_RESET_IN_PROGRESS ||
+	    prev_state == EFCT_HW_STATE_TEARDOWN_IN_PROGRESS)
+		return efct_hw_sli_reset(hw, reset, prev_state);
+
+	/* shutdown target wqe timer */
+	shutdown_target_wqe_timer(hw);
+
+	if (prev_state != EFCT_HW_STATE_UNINITIALIZED) {
+		efct_hw_flush(hw);
+
+		/*
+		 * If an mailbox command requiring a DMA is outstanding
+		 * (SFP/DDM), then the FW will UE when the reset is issued.
+		 * So attempt to complete all mailbox commands.
+		 */
+		iters = 10;
+		while (!list_empty(&hw->cmd_head) && iters) {
+			mdelay(10);
+			efct_hw_flush(hw);
+			iters--;
+		}
+
+		if (list_empty(&hw->cmd_head))
+			efc_log_debug(hw->os,
+				       "All commands completed on MQ queue\n");
+		else
+			efc_log_debug(hw->os,
+				       "Some commands still pending on MQ queue\n");
+	}
+
+	/* Reset the chip */
+	rc = efct_hw_sli_reset(hw, reset, prev_state);
+	if (rc == EFCT_HW_RTN_INVALID_ARG)
+		return EFCT_HW_RTN_ERROR;
+
+	/* Not safe to walk command/io lists unless they've been initialized */
+	if (prev_state != EFCT_HW_STATE_UNINITIALIZED) {
+		efct_hw_command_cancel(hw);
+
+		/* Try to clean up the io_inuse list */
+		efct_hw_io_cancel(hw);
+
+		efct_hw_link_event_init(hw);
+
+		spin_lock_irqsave(&hw->io_lock, flags);
+			/*
+			 * The io lists should be empty, but remove any that
+			 * didn't get cleaned up.
+			 */
+			while (!list_empty(&hw->io_timed_wqe)) {
+				temp = list_first_entry(&hw->io_timed_wqe,
+							struct efct_hw_io_s,
+							list_entry);
+				list_del(&temp->wqe_link);
+			}
+
+			while (!list_empty(&hw->io_free)) {
+				temp = list_first_entry(&hw->io_free,
+							struct efct_hw_io_s,
+							list_entry);
+				list_del(&temp->list_entry);
+			}
+
+			while (!list_empty(&hw->io_wait_free)) {
+				temp = list_first_entry(&hw->io_wait_free,
+							struct efct_hw_io_s,
+							list_entry);
+				list_del(&temp->list_entry);
+			}
+		spin_unlock_irqrestore(&hw->io_lock, flags);
+
+		for (i = 0; i < hw->wq_count; i++)
+			sli_queue_free(&hw->sli, &hw->wq[i],
+				       destroy_queues, free_memory);
+
+		for (i = 0; i < hw->rq_count; i++)
+			sli_queue_free(&hw->sli, &hw->rq[i],
+				       destroy_queues, free_memory);
+
+		for (i = 0; i < hw->hw_rq_count; i++) {
+			struct hw_rq_s *rq = hw->hw_rq[i];
+
+			if (rq->rq_tracker) {
+				u32 j;
+
+				for (j = 0; j < rq->entry_count; j++)
+					rq->rq_tracker[j] = NULL;
+			}
+		}
+
+		for (i = 0; i < hw->mq_count; i++)
+			sli_queue_free(&hw->sli, &hw->mq[i],
+				       destroy_queues, free_memory);
+
+		for (i = 0; i < hw->cq_count; i++)
+			sli_queue_free(&hw->sli, &hw->cq[i],
+				       destroy_queues, free_memory);
+
+		for (i = 0; i < hw->eq_count; i++)
+			sli_queue_free(&hw->sli, &hw->eq[i],
+				       destroy_queues, free_memory);
+
+		/* Free rq buffers */
+		efct_hw_rx_free(hw);
+
+		/* Teardown the HW queue topology */
+		efct_hw_queue_teardown(hw);
+
+		/*
+		 * Reset the request tag pool, the HW IO request tags
+		 * are reassigned in efct_hw_setup_io()
+		 */
+		efct_hw_reqtag_reset(hw);
+	} else {
+		/* Free rq buffers */
+		efct_hw_rx_free(hw);
+	}
+
+	return rc;
+}
+
+int
+efct_hw_get_num_eq(struct efct_hw_s *hw)
+{
+	return hw->eq_count;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index b372250c4408..6910dca917a4 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -1169,5 +1169,36 @@ efct_hw_get_host_stats(struct efct_hw_s *hw,
 			void *arg),
 		void *arg);
 
+struct hw_eq_s *efct_hw_new_eq(struct efct_hw_s *hw, u32 entry_count);
+struct hw_cq_s *efct_hw_new_cq(struct hw_eq_s *eq, u32 entry_count);
+extern u32
+efct_hw_new_cq_set(struct hw_eq_s *eqs[], struct hw_cq_s *cqs[],
+		   u32 num_cqs, u32 entry_count);
+struct hw_mq_s *efct_hw_new_mq(struct hw_cq_s *cq, u32 entry_count);
+extern struct hw_wq_s
+*efct_hw_new_wq(struct hw_cq_s *cq, u32 entry_count,
+		u32 class, u32 ulp);
+extern struct hw_rq_s
+*efct_hw_new_rq(struct hw_cq_s *cq, u32 entry_count, u32 ulp);
+extern u32
+efct_hw_new_rq_set(struct hw_cq_s *cqs[], struct hw_rq_s *rqs[],
+		   u32 num_rq_pairs, u32 entry_count);
+void efct_hw_del_eq(struct hw_eq_s *eq);
+void efct_hw_del_cq(struct hw_cq_s *cq);
+void efct_hw_del_mq(struct hw_mq_s *mq);
+void efct_hw_del_wq(struct hw_wq_s *wq);
+void efct_hw_del_rq(struct hw_rq_s *rq);
+void efct_hw_queue_dump(struct efct_hw_s *hw);
+void efct_hw_queue_teardown(struct efct_hw_s *hw);
+enum efct_hw_rtn_e efct_hw_teardown(struct efct_hw_s *hw);
+enum efct_hw_rtn_e
+efct_hw_reset(struct efct_hw_s *hw, enum efct_hw_reset_e reset);
+int efct_hw_get_num_eq(struct efct_hw_s *hw);
+
+extern enum efct_hw_rtn_e
+efct_hw_port_control(struct efct_hw_s *hw, enum efct_hw_port_e ctrl,
+		     uintptr_t value,
+		void (*cb)(int status, uintptr_t value, void *arg),
+		void *arg);
 
 #endif /* __EFCT_H__ */
diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
index 83782794225f..d43027c57732 100644
--- a/drivers/scsi/elx/efct/efct_xport.c
+++ b/drivers/scsi/elx/efct/efct_xport.c
@@ -663,3 +663,486 @@ efct_scsi_release_fc_transport(void)
 
 	return 0;
 }
+
+/**
+ * @brief Detaches the transport from the device.
+ *
+ * @par Description
+ * Performs the functions required to shut down a device.
+ *
+ * @param xport Pointer to transport object.
+ *
+ * @return Returns 0 on success or a non-zero value on failure.
+ */
+int
+efct_xport_detach(struct efct_xport_s *xport)
+{
+	struct efct_s *efct = xport->efct;
+
+	/* free resources associated with target-server and initiator-client */
+	efct_scsi_tgt_del_device(efct);
+
+	efct_scsi_del_device(efct);
+
+	/*Shutdown FC Statistics timer*/
+	del_timer(&efct->xport->stats_timer);
+
+	efct_hw_teardown(&efct->hw);
+
+	efct_xport_delete_debugfs(efct);
+
+	return 0;
+}
+
+/**
+ * @brief domain list empty callback
+ *
+ * @par Description
+ * Function is invoked when the domain is freed. By convention
+ * @c arg points to an struct completion instance, that is incremented.
+ *
+ * @param efct Pointer to device object.
+ * @param arg Pointer to completion instance.
+ *
+ * @return None.
+ */
+static void
+efct_xport_domain_free_cb(struct efc_lport *efc, void *arg)
+{
+	struct completion *done = arg;
+
+	complete(done);
+}
+
+/**
+ * @brief post node event callback
+ *
+ * @par Description
+ * This function is called from the mailbox completion interrupt context to
+ * post an event to a node object. By doing this in the interrupt context,
+ * it has the benefit of only posting events in the interrupt context,
+ * deferring the need to create a per event node lock.
+ *
+ * @param hw Pointer to HW structure.
+ * @param status Completion status for mailbox command.
+ * @param mqe Mailbox queue completion entry.
+ * @param arg Callback argument.
+ *
+ * @return Returns 0 on success, a negative error code value on failure.
+ */
+
+static int
+efct_xport_post_node_event_cb(struct efct_hw_s *hw, int status,
+			      u8 *mqe, void *arg)
+{
+	struct efct_xport_post_node_event_s *payload = arg;
+
+	if (payload) {
+		efc_node_post_shutdown(payload->node, payload->evt,
+				       payload->context);
+		complete(&payload->done);
+		if (atomic_sub_and_test(1, &payload->refcnt))
+			kfree(payload);
+	}
+	return 0;
+}
+
+/**
+ * @brief Initiate force free.
+ *
+ * @par Description
+ * Perform force free of EFCT.
+ *
+ * @param xport Pointer to transport object.
+ *
+ * @return None.
+ */
+
+static void
+efct_xport_force_free(struct efct_xport_s *xport)
+{
+	struct efct_s *efct = xport->efct;
+	struct efc_lport *efc = efct->efcport;
+
+	efc_log_debug(efct, "reset required, do force shutdown\n");
+
+	if (!efc->domain) {
+		efc_log_err(efct, "Domain is already freed\n");
+		return;
+	}
+
+	efc_domain_force_free(efc->domain);
+}
+
+/**
+ * @brief Perform transport attach function.
+ *
+ * @par Description
+ * Perform the attach function, which for the FC transport makes a HW call
+ * to bring up the link.
+ *
+ * @param xport pointer to transport object.
+ * @param cmd command to execute.
+ *
+ * efct_xport_control(struct efct_xport_s *xport, EFCT_XPORT_PORT_ONLINE)
+ * efct_xport_control(struct efct_xport_s *xport, EFCT_XPORT_PORT_OFFLINE)
+ * efct_xport_control(struct efct_xport_s *xport, EFCT_XPORT_PORT_SHUTDOWN)
+ * efct_xport_control(struct efct_xport_s *xport, EFCT_XPORT_POST_NODE_EVENT,
+ *		     struct efct_node_s *node, efc_sm_event_e, void *context)
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+
+int
+efct_xport_control(struct efct_xport_s *xport, enum efct_xport_ctrl_e cmd, ...)
+{
+	u32 rc = 0;
+	struct efct_s *efct = NULL;
+	va_list argp;
+
+	efct = xport->efct;
+
+	switch (cmd) {
+	case EFCT_XPORT_PORT_ONLINE: {
+		/* Bring the port on-line */
+		rc = efct_hw_port_control(&efct->hw, EFCT_HW_PORT_INIT, 0,
+					  NULL, NULL);
+		if (rc)
+			efc_log_err(efct,
+				     "%s: Can't init port\n", efct->desc);
+		else
+			xport->configured_link_state = cmd;
+		break;
+	}
+	case EFCT_XPORT_PORT_OFFLINE: {
+		if (efct_hw_port_control(&efct->hw, EFCT_HW_PORT_SHUTDOWN, 0,
+					 NULL, NULL))
+			efc_log_err(efct, "port shutdown failed\n");
+		else
+			xport->configured_link_state = cmd;
+		break;
+	}
+
+	case EFCT_XPORT_SHUTDOWN: {
+		struct completion done;
+		u32 reset_required;
+		unsigned long timeout;
+
+		/* if a PHYSDEV reset was performed (e.g. hw dump), will affect
+		 * all PCI functions; orderly shutdown won't work,
+		 * just force free
+		 */
+		if (efct_hw_get(&efct->hw, EFCT_HW_RESET_REQUIRED,
+				&reset_required) != EFCT_HW_RTN_SUCCESS)
+			reset_required = 0;
+
+		if (reset_required) {
+			efc_log_debug(efct,
+				       "reset required, do force shutdown\n");
+			efct_xport_force_free(xport);
+			break;
+		}
+		init_completion(&done);
+
+		efc_register_domain_free_cb(efct->efcport,
+					efct_xport_domain_free_cb, &done);
+
+		if (efct_hw_port_control(&efct->hw, EFCT_HW_PORT_SHUTDOWN, 0,
+					 NULL, NULL)) {
+			efc_log_debug(efct,
+				       "port shutdown failed, do force shutdown\n");
+			efct_xport_force_free(xport);
+		} else {
+			efc_log_debug(efct,
+				       "Waiting %d seconds for domain shutdown.\n",
+			(EFCT_FC_DOMAIN_SHUTDOWN_TIMEOUT_USEC / 1000000));
+
+			timeout = usecs_to_jiffies(
+					EFCT_FC_DOMAIN_SHUTDOWN_TIMEOUT_USEC);
+			if (!wait_for_completion_timeout(&done, timeout)) {
+				efc_log_debug(efct,
+					       "Domain shutdown timed out!!\n");
+				efct_xport_force_free(xport);
+			}
+		}
+
+		efc_register_domain_free_cb(efct->efcport, NULL, NULL);
+
+		/* Free up any saved virtual ports */
+		efc_vport_del_all(efct->efcport);
+		break;
+	}
+
+	/*
+	 * POST_NODE_EVENT:  post an event to a node object
+	 *
+	 * This transport function is used to post an event to a node object.
+	 * It does this by submitting a NOP mailbox command to defer execution
+	 * to the interrupt context (thereby enforcing the serialized execution
+	 * of event posting to the node state machine instances)
+	 */
+	case EFCT_XPORT_POST_NODE_EVENT: {
+		struct efc_node_s *node;
+		u32	evt;
+		void *context;
+		struct efct_xport_post_node_event_s *payload = NULL;
+		struct efct_s *efct;
+		struct efct_hw_s *hw;
+
+		/* Retrieve arguments */
+		va_start(argp, cmd);
+		node = va_arg(argp, struct efc_node_s *);
+		evt = va_arg(argp, u32);
+		context = va_arg(argp, void *);
+		va_end(argp);
+
+		payload = kmalloc(sizeof(*payload), GFP_KERNEL);
+		if (!payload)
+			return -1;
+
+		memset(payload, 0, sizeof(*payload));
+
+		efct = node->efc->base;
+		hw = &efct->hw;
+
+		/* if node's state machine is disabled,
+		 * don't bother continuing
+		 */
+		if (!node->sm.current_state) {
+			efc_log_test(efct, "node %p state machine disabled\n",
+				      node);
+			kfree(payload);
+			rc = -1;
+			break;
+		}
+
+		/* Setup payload */
+		init_completion(&payload->done);
+
+		/* one for self and one for callback */
+		atomic_set(&payload->refcnt, 2);
+		payload->node = node;
+		payload->evt = evt;
+		payload->context = context;
+
+		if (efct_hw_async_call(hw, efct_xport_post_node_event_cb,
+				       payload)) {
+			efc_log_test(efct, "efct_hw_async_call failed\n");
+			kfree(payload);
+			rc = -1;
+			break;
+		}
+
+		/* Wait for completion */
+		if (wait_for_completion_interruptible(&payload->done)) {
+			efc_log_test(efct,
+				      "POST_NODE_EVENT: completion failed\n");
+			rc = -1;
+		}
+		if (atomic_sub_and_test(1, &payload->refcnt))
+			kfree(payload);
+
+		break;
+	}
+	/*
+	 * Set wwnn for the port. This will be used instead of the default
+	 * provided by FW.
+	 */
+	case EFCT_XPORT_WWNN_SET: {
+		u64 wwnn;
+
+		/* Retrieve arguments */
+		va_start(argp, cmd);
+		wwnn = va_arg(argp, uint64_t);
+		va_end(argp);
+
+		efc_log_debug(efct, " WWNN %016llx\n", wwnn);
+		xport->req_wwnn = wwnn;
+
+		break;
+	}
+	/*
+	 * Set wwpn for the port. This will be used instead of the default
+	 * provided by FW.
+	 */
+	case EFCT_XPORT_WWPN_SET: {
+		u64 wwpn;
+
+		/* Retrieve arguments */
+		va_start(argp, cmd);
+		wwpn = va_arg(argp, uint64_t);
+		va_end(argp);
+
+		efc_log_debug(efct, " WWPN %016llx\n", wwpn);
+		xport->req_wwpn = wwpn;
+
+		break;
+	}
+
+	default:
+		break;
+	}
+	return rc;
+}
+
+
+
+static void
+efct_xport_link_stats_cb(int status, u32 num_counters,
+			 struct efct_hw_link_stat_counts_s *counters, void *arg)
+{
+	union efct_xport_stats_u *result = arg;
+
+	result->stats.link_stats.link_failure_error_count =
+		counters[EFCT_HW_LINK_STAT_LINK_FAILURE_COUNT].counter;
+	result->stats.link_stats.loss_of_sync_error_count =
+		counters[EFCT_HW_LINK_STAT_LOSS_OF_SYNC_COUNT].counter;
+	result->stats.link_stats.primitive_sequence_error_count =
+		counters[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_COUNT].counter;
+	result->stats.link_stats.invalid_transmission_word_error_count =
+		counters[EFCT_HW_LINK_STAT_INVALID_XMIT_WORD_COUNT].counter;
+	result->stats.link_stats.crc_error_count =
+		counters[EFCT_HW_LINK_STAT_CRC_COUNT].counter;
+
+	complete(&result->stats.done);
+}
+
+static void
+efct_xport_host_stats_cb(int status, u32 num_counters,
+			 struct efct_hw_host_stat_counts_s *counters, void *arg)
+{
+	union efct_xport_stats_u *result = arg;
+
+	result->stats.host_stats.transmit_kbyte_count =
+		counters[EFCT_HW_HOST_STAT_TX_KBYTE_COUNT].counter;
+	result->stats.host_stats.receive_kbyte_count =
+		counters[EFCT_HW_HOST_STAT_RX_KBYTE_COUNT].counter;
+	result->stats.host_stats.transmit_frame_count =
+		counters[EFCT_HW_HOST_STAT_TX_FRAME_COUNT].counter;
+	result->stats.host_stats.receive_frame_count =
+		counters[EFCT_HW_HOST_STAT_RX_FRAME_COUNT].counter;
+
+	complete(&result->stats.done);
+}
+
+static void
+efct_xport_async_link_stats_cb(int status, u32 num_counters,
+			       struct efct_hw_link_stat_counts_s *counters,
+			       void *arg)
+{
+	union efct_xport_stats_u *result = arg;
+
+	result->stats.link_stats.link_failure_error_count =
+		counters[EFCT_HW_LINK_STAT_LINK_FAILURE_COUNT].counter;
+	result->stats.link_stats.loss_of_sync_error_count =
+		counters[EFCT_HW_LINK_STAT_LOSS_OF_SYNC_COUNT].counter;
+	result->stats.link_stats.primitive_sequence_error_count =
+		counters[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_COUNT].counter;
+	result->stats.link_stats.invalid_transmission_word_error_count =
+		counters[EFCT_HW_LINK_STAT_INVALID_XMIT_WORD_COUNT].counter;
+	result->stats.link_stats.crc_error_count =
+		counters[EFCT_HW_LINK_STAT_CRC_COUNT].counter;
+}
+
+static void
+efct_xport_async_host_stats_cb(int status, u32 num_counters,
+			       struct efct_hw_host_stat_counts_s *counters,
+			       void *arg)
+{
+	union efct_xport_stats_u *result = arg;
+
+	result->stats.host_stats.transmit_kbyte_count =
+		counters[EFCT_HW_HOST_STAT_TX_KBYTE_COUNT].counter;
+	result->stats.host_stats.receive_kbyte_count =
+		counters[EFCT_HW_HOST_STAT_RX_KBYTE_COUNT].counter;
+	result->stats.host_stats.transmit_frame_count =
+		counters[EFCT_HW_HOST_STAT_TX_FRAME_COUNT].counter;
+	result->stats.host_stats.receive_frame_count =
+		counters[EFCT_HW_HOST_STAT_RX_FRAME_COUNT].counter;
+}
+
+
+
+/**
+ * @brief Free a transport object.
+ *
+ * @par Description
+ * The transport object is freed.
+ *
+ * @param xport Pointer to transport object.
+ *
+ * @return None.
+ */
+
+void
+efct_xport_free(struct efct_xport_s *xport)
+{
+	if (xport) {
+		efct_io_pool_free(xport->io_pool);
+
+		kfree(xport);
+	}
+}
+
+void
+efct_release_fc_transport(struct scsi_transport_template *transport_template)
+{
+	if (transport_template)
+		pr_err("releasing transport layer\n");
+
+	/* Releasing FC transport */
+	fc_release_transport(transport_template);
+}
+
+/**
+ * @ingroup scsi_api_initiator
+ * @brief Remove host from transport.
+ *
+ * @par Description
+ * Function called by the SCSI mid-layer module to terminate any
+ * transport-related elements for a SCSI host.
+ *
+ * @return None.
+ */
+static void
+efct_xport_remove_host(struct Scsi_Host *shost)
+{
+	/*
+	 * Remove host from FC Transport layer
+	 *
+	 * 1. fc_remove_host()
+	 * a. for each vport: queue vport_delete_work (fc_vport_sched_delete())
+	 *	b. for each rport: queue rport_delete_work
+	 *		(fc_rport_final_delete())
+	 *	c. scsi_flush_work()
+	 * 2. fc_rport_final_delete()
+	 * a. fc_terminate_rport_io
+	 *		i. call LLDD's terminate_rport_io()
+	 *		ii. scsi_target_unblock()
+	 *	b. fc_starget_delete()
+	 *		i. fc_terminate_rport_io()
+	 *			1. call LLDD's terminate_rport_io()
+	 *			2. scsi_target_unblock()
+	 *		ii. scsi_remove_target()
+	 *      c. invoke LLDD devloss callback
+	 *      d. transport_remove_device(&rport->dev)
+	 *      e. device_del(&rport->dev)
+	 *      f. transport_destroy_device(&rport->dev)
+	 *      g. put_device(&shost->shost_gendev) (for fc_host->rport list)
+	 *      h. put_device(&rport->dev)
+	 */
+	fc_remove_host(shost);
+}
+
+int efct_scsi_del_device(struct efct_s *efct)
+{
+	if (efct->shost) {
+		efc_log_debug(efct, "Unregistering with Transport Layer\n");
+		efct_xport_remove_host(efct->shost);
+		efc_log_debug(efct, "Unregistering with SCSI Midlayer\n");
+		scsi_remove_host(efct->shost);
+		scsi_host_put(efct->shost);
+		efct->shost = NULL;
+	}
+	return 0;
+}
-- 
2.13.7

