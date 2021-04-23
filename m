Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA2BC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 23:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E1E66146B
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 23:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244242AbhDWXhi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 19:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244158AbhDWXgJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2021 19:36:09 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B73C06134F
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 16:35:23 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id h20so25974228plr.4
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 16:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j1cSqkv101oWa61v8wDwxL5HI6hUlTvA/DPe13MlgRU=;
        b=NlhW8AMFXlvaHcUVYXIOK+bwD1IsVCW0a0YztzFY1fAbpVjiHOgWsSfuugZMKMWvRI
         DQojnZnJycJC5NA6cCMt75CYowMsanqSm9miPACEOZVOHLjKDnB3faKJP1r+/J4mqq4x
         4DkGYm8x+Q/2IGLoOuXfFKf3j47upMh5Tpb/ZgbwT+5izuLncziMxjzW2XoYqb7NYvGX
         9yTxFK3upvE7Qxj+uZRwMZm9v5mG8QqZ92zVHM2BIk1aR56weo14rOxJ4XxhICuw3IDc
         sHKkwT7KNN8nyXEnAOjMj7cEnzVW8EXdMhHYODr9ovqBJXdHLrv9V8/DMn5p63bCa+7y
         ndDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j1cSqkv101oWa61v8wDwxL5HI6hUlTvA/DPe13MlgRU=;
        b=r/JfPr8T9wh9SP+Mt4AJZUe29O+JwCOBo88bKh59iisdXRIX1KxwewGOxrFfWLWzH/
         VrgCeJ4XPIUKXlUsJoCn9FV6K5c7EdnLEq5EC/OZ0Bx6YUqxR9wVC2qfDpiil03bUGTi
         8LhkHyFvOfeb3Z+g11fNW9ztrpZ86kZttzKo9J5ZmCH7UmYD0O+me6zzB5sE8bYZ41B3
         LmsNlP1TSSVf0g/cGFP1qgKaYm1z+un274k1Dwg35zrlMya05EdqsttYvwa08f81O1qk
         Z0XXF0jzKLWqF8V+nnXFF52bvthAi4tCwl970MDoDyLWtcqA8mfMoytwApBO5LCLSSOn
         5m8Q==
X-Gm-Message-State: AOAM531C0s3YHas/YWZcYv6p38N+hp0at3eZm59puJWaqbXTpeg3KArD
        xz5hNvKB/BgqlxmBfCJAP8WvlK13FlM=
X-Google-Smtp-Source: ABdhPJysKVNqVnAHPUTC/eQ1U8k/pU9tVyqv9b21dIWMVCT9GSOiWW3TbHQe+7Dg+niUmwffakZCDA==
X-Received: by 2002:a17:90b:714:: with SMTP id s20mr8385721pjz.62.1619220922493;
        Fri, 23 Apr 2021 16:35:22 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v123sm5346892pfb.80.2021.04.23.16.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 16:35:22 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v8 28/31] elx: efct: xport and hardware teardown routines
Date:   Fri, 23 Apr 2021 16:34:52 -0700
Message-Id: <20210423233455.27243-29-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210423233455.27243-1-jsmart2021@gmail.com>
References: <20210423233455.27243-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines to detach xport and hardware objects.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>

---
v8:
Remove waiting for flushing pending commands in reset and teardown path
---
 drivers/scsi/elx/efct/efct_hw.c    | 252 ++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h    |  27 +++
 drivers/scsi/elx/efct/efct_xport.c | 261 +++++++++++++++++++++++++++++
 3 files changed, 540 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 1084db4f5843..018e852cf720 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -3356,3 +3356,255 @@ efct_hw_firmware_write(struct efct_hw *hw, struct efc_dma *dma, u32 size,
 
 	return rc;
 }
+
+static int
+efct_hw_cb_port_control(struct efct_hw *hw, int status, u8 *mqe,
+			void  *arg)
+{
+	return EFC_SUCCESS;
+}
+
+enum efct_hw_rtn
+efct_hw_port_control(struct efct_hw *hw, enum efct_hw_port ctrl,
+		     uintptr_t value,
+		     void (*cb)(int status, uintptr_t value, void *arg),
+		     void *arg)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
+	u8 link[SLI4_BMBX_SIZE];
+	u32 speed = 0;
+	u8 reset_alpa = 0;
+
+	switch (ctrl) {
+	case EFCT_HW_PORT_INIT:
+		if (!sli_cmd_config_link(&hw->sli, link))
+			rc = efct_hw_command(hw, link, EFCT_CMD_NOWAIT,
+					     efct_hw_cb_port_control, NULL);
+
+		if (rc != EFCT_HW_RTN_SUCCESS) {
+			efc_log_err(hw->os, "CONFIG_LINK failed\n");
+			break;
+		}
+		speed = hw->config.speed;
+		reset_alpa = (u8)(value & 0xff);
+
+		rc = EFCT_HW_RTN_ERROR;
+		if (!sli_cmd_init_link(&hw->sli, link, speed, reset_alpa))
+			rc = efct_hw_command(hw, link, EFCT_CMD_NOWAIT,
+					     efct_hw_cb_port_control, NULL);
+		/* Free buffer on error, since no callback is coming */
+		if (rc)
+			efc_log_err(hw->os, "INIT_LINK failed\n");
+		break;
+
+	case EFCT_HW_PORT_SHUTDOWN:
+		if (!sli_cmd_down_link(&hw->sli, link))
+			rc = efct_hw_command(hw, link, EFCT_CMD_NOWAIT,
+					     efct_hw_cb_port_control, NULL);
+		/* Free buffer on error, since no callback is coming */
+		if (rc)
+			efc_log_err(hw->os, "DOWN_LINK failed\n");
+		break;
+
+	default:
+		efc_log_debug(hw->os, "unhandled control %#x\n", ctrl);
+		break;
+	}
+
+	return rc;
+}
+
+void
+efct_hw_teardown(struct efct_hw *hw)
+{
+	u32 i = 0;
+	u32 destroy_queues;
+	u32 free_memory;
+	struct efc_dma *dma;
+	struct efct *efct = hw->os;
+
+	destroy_queues = (hw->state == EFCT_HW_STATE_ACTIVE);
+	free_memory = (hw->state != EFCT_HW_STATE_UNINITIALIZED);
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
+	dma_free_coherent(&efct->pci->dev,
+			  hw->rnode_mem.size, hw->rnode_mem.virt,
+			  hw->rnode_mem.phys);
+	memset(&hw->rnode_mem, 0, sizeof(struct efc_dma));
+
+	if (hw->io) {
+		for (i = 0; i < hw->config.n_io; i++) {
+			if (hw->io[i] && hw->io[i]->sgl &&
+			    hw->io[i]->sgl->virt) {
+				dma_free_coherent(&efct->pci->dev,
+						  hw->io[i]->sgl->size,
+						  hw->io[i]->sgl->virt,
+						  hw->io[i]->sgl->phys);
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
+	dma_free_coherent(&efct->pci->dev,
+			  dma->size, dma->virt, dma->phys);
+	memset(dma, 0, sizeof(struct efc_dma));
+
+	dma = &hw->loop_map;
+	dma_free_coherent(&efct->pci->dev,
+			  dma->size, dma->virt, dma->phys);
+	memset(dma, 0, sizeof(struct efc_dma));
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
+	/* Free rq buffers */
+	efct_hw_rx_free(hw);
+
+	efct_hw_queue_teardown(hw);
+
+	kfree(hw->wq_cpu_array);
+
+	sli_teardown(&hw->sli);
+
+	/* record the fact that the queues are non-functional */
+	hw->state = EFCT_HW_STATE_UNINITIALIZED;
+
+	/* free sequence free pool */
+	kfree(hw->seq_pool);
+	hw->seq_pool = NULL;
+
+	/* free hw_wq_callback pool */
+	efct_hw_reqtag_pool_free(hw);
+
+	mempool_destroy(hw->cmd_ctx_pool);
+	mempool_destroy(hw->mbox_rqst_pool);
+
+	/* Mark HW setup as not having been called */
+	hw->hw_setup_called = false;
+}
+
+static enum efct_hw_rtn
+efct_hw_sli_reset(struct efct_hw *hw, enum efct_hw_reset reset,
+		  enum efct_hw_state prev_state)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
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
+enum efct_hw_rtn
+efct_hw_reset(struct efct_hw *hw, enum efct_hw_reset reset)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+	enum efct_hw_state prev_state = hw->state;
+
+	if (hw->state != EFCT_HW_STATE_ACTIVE)
+		efc_log_debug(hw->os,
+			      "HW state %d is not active\n", hw->state);
+
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
+	if (prev_state != EFCT_HW_STATE_UNINITIALIZED) {
+		efct_hw_flush(hw);
+
+		if (list_empty(&hw->cmd_head))
+			efc_log_debug(hw->os,
+				      "All commands completed on MQ queue\n");
+		else
+			efc_log_err(hw->os,
+				    "Some commands still pending on MQ queue\n");
+	}
+
+	/* Reset the chip */
+	rc = efct_hw_sli_reset(hw, reset, prev_state);
+	if (rc == EFCT_HW_RTN_INVALID_ARG)
+		return EFCT_HW_RTN_ERROR;
+
+	return rc;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index acd668d11e7e..b669efb677ff 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -749,4 +749,31 @@ typedef void (*efct_hw_async_cb_t)(struct efct_hw *hw, int status,
 int
 efct_hw_async_call(struct efct_hw *hw, efct_hw_async_cb_t callback, void *arg);
 
+struct hw_eq *efct_hw_new_eq(struct efct_hw *hw, u32 entry_count);
+struct hw_cq *efct_hw_new_cq(struct hw_eq *eq, u32 entry_count);
+u32
+efct_hw_new_cq_set(struct hw_eq *eqs[], struct hw_cq *cqs[],
+		   u32 num_cqs, u32 entry_count);
+struct hw_mq *efct_hw_new_mq(struct hw_cq *cq, u32 entry_count);
+struct hw_wq
+*efct_hw_new_wq(struct hw_cq *cq, u32 entry_count);
+u32
+efct_hw_new_rq_set(struct hw_cq *cqs[], struct hw_rq *rqs[],
+		   u32 num_rq_pairs, u32 entry_count);
+void efct_hw_del_eq(struct hw_eq *eq);
+void efct_hw_del_cq(struct hw_cq *cq);
+void efct_hw_del_mq(struct hw_mq *mq);
+void efct_hw_del_wq(struct hw_wq *wq);
+void efct_hw_del_rq(struct hw_rq *rq);
+void efct_hw_queue_teardown(struct efct_hw *hw);
+void efct_hw_teardown(struct efct_hw *hw);
+enum efct_hw_rtn
+efct_hw_reset(struct efct_hw *hw, enum efct_hw_reset reset);
+
+enum efct_hw_rtn
+efct_hw_port_control(struct efct_hw *hw, enum efct_hw_port ctrl,
+		     uintptr_t value,
+		void (*cb)(int status, uintptr_t value, void *arg),
+		void *arg);
+
 #endif /* __EFCT_H__ */
diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
index b18159425d45..b34b3af8e9c0 100644
--- a/drivers/scsi/elx/efct/efct_xport.c
+++ b/drivers/scsi/elx/efct/efct_xport.c
@@ -507,3 +507,264 @@ efct_scsi_release_fc_transport(void)
 
 	efct_vport_fc_tt = NULL;
 }
+
+int
+efct_xport_detach(struct efct_xport *xport)
+{
+	struct efct *efct = xport->efct;
+
+	/* free resources associated with target-server and initiator-client */
+	efct_scsi_tgt_del_device(efct);
+
+	efct_scsi_del_device(efct);
+
+	/*Shutdown FC Statistics timer*/
+	if (timer_pending(&xport->stats_timer))
+		del_timer(&xport->stats_timer);
+
+	efct_hw_teardown(&efct->hw);
+
+	efct_xport_delete_debugfs(efct);
+
+	return EFC_SUCCESS;
+}
+
+static void
+efct_xport_domain_free_cb(struct efc *efc, void *arg)
+{
+	struct completion *done = arg;
+
+	complete(done);
+}
+
+static void
+efct_xport_post_node_event_cb(struct efct_hw *hw, int status,
+			      u8 *mqe, void *arg)
+{
+	struct efct_xport_post_node_event *payload = arg;
+
+	if (payload) {
+		efc_node_post_shutdown(payload->node, payload->evt,
+				       payload->context);
+		complete(&payload->done);
+		if (atomic_sub_and_test(1, &payload->refcnt))
+			kfree(payload);
+	}
+}
+
+int
+efct_xport_control(struct efct_xport *xport, enum efct_xport_ctrl cmd, ...)
+{
+	u32 rc = 0;
+	struct efct *efct = NULL;
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
+		unsigned long timeout;
+
+		/* if a PHYSDEV reset was performed (e.g. hw dump), will affect
+		 * all PCI functions; orderly shutdown won't work,
+		 * just force free
+		 */
+		if (sli_reset_required(&efct->hw.sli)) {
+			struct efc_domain *domain = efct->efcport->domain;
+
+			if (domain)
+				efc_domain_cb(efct->efcport, EFC_HW_DOMAIN_LOST,
+					      domain);
+		} else {
+			efct_hw_port_control(&efct->hw, EFCT_HW_PORT_SHUTDOWN,
+					     0, NULL, NULL);
+		}
+
+		init_completion(&done);
+
+		efc_register_domain_free_cb(efct->efcport,
+					efct_xport_domain_free_cb, &done);
+
+		efc_log_debug(efct, "Waiting %d seconds for domain shutdown\n",
+				(EFC_SHUTDOWN_TIMEOUT_USEC / 1000000));
+
+		timeout = usecs_to_jiffies(EFC_SHUTDOWN_TIMEOUT_USEC);
+		if (!wait_for_completion_timeout(&done, timeout)) {
+			efc_log_err(efct, "Domain shutdown timed out!!\n");
+			WARN_ON(1);
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
+		struct efc_node *node;
+		u32	evt;
+		void *context;
+		struct efct_xport_post_node_event *payload = NULL;
+		struct efct_hw *hw;
+
+		/* Retrieve arguments */
+		va_start(argp, cmd);
+		node = va_arg(argp, struct efc_node *);
+		evt = va_arg(argp, u32);
+		context = va_arg(argp, void *);
+		va_end(argp);
+
+		payload = kzalloc(sizeof(*payload), GFP_KERNEL);
+		if (!payload)
+			return EFC_FAIL;
+
+		hw = &efct->hw;
+
+		/* if node's state machine is disabled,
+		 * don't bother continuing
+		 */
+		if (!node->sm.current_state) {
+			efc_log_debug(efct, "node %p state machine disabled\n",
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
+			efc_log_debug(efct, "efct_hw_async_call failed\n");
+			kfree(payload);
+			rc = -1;
+			break;
+		}
+
+		/* Wait for completion */
+		if (wait_for_completion_interruptible(&payload->done)) {
+			efc_log_debug(efct,
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
+void
+efct_xport_free(struct efct_xport *xport)
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
+static void
+efct_xport_remove_host(struct Scsi_Host *shost)
+{
+	fc_remove_host(shost);
+}
+
+int efct_scsi_del_device(struct efct *efct)
+{
+	if (efct->shost) {
+		efc_log_debug(efct, "Unregistering with Transport Layer\n");
+		efct_xport_remove_host(efct->shost);
+		efc_log_debug(efct, "Unregistering with SCSI Midlayer\n");
+		scsi_remove_host(efct->shost);
+		scsi_host_put(efct->shost);
+		efct->shost = NULL;
+	}
+	return EFC_SUCCESS;
+}
-- 
2.26.2

