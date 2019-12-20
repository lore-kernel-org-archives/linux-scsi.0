Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F52C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6B602082E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ibrCobvR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfLTWh5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:37:57 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34455 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfLTWh5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:37:57 -0500
Received: by mail-pg1-f195.google.com with SMTP id r11so5667579pgf.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KSyg4kmI4FZ1uRA0MSIUBs6tIE2N43XVAu6Q5r8dK/4=;
        b=ibrCobvRsRx+vlcYrfxhzaZqf9ABrOjxB36AjU2E7GFejB2MbKD7Eo8GeTVHb0D/P1
         mOJp9ZQeS529f5zCth6YJzXgG+jJCBdj/syuSnIAgN2Ps0+jHE6fPHlIEmFhbux136Mz
         T0EkuQdCblvBpVDveqXaIXYAkbLDvlRtmqAqKaazdqF1CjKAzuFWnf1V51gRhg89Pkj4
         e+vyusKhAuzWmg4l/ztlnpaSaLjBhN4oRETmKkpdED0/Fk9GCy36sX2b5tMpbuL4qP1G
         BXDVYPDxy4QkIT6leQKXMMb1vBZRoev8CuX2iOGtP7E/1pkzdc14uXQJNMSC3OL84+Wa
         hffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KSyg4kmI4FZ1uRA0MSIUBs6tIE2N43XVAu6Q5r8dK/4=;
        b=dRn03XNxRvzSCvz4QIYbdFGL0CsSVqNBoqIfZTHqX/0szTOzn4jbTu98mXFNgD6H+K
         sVYa0YcADbavdOzHKdsdBJZDHS48VQZE2pojJZmOB5rAYNL27UPSJ8ixZ75xF2solX/h
         KNb7klIk+ruG61a2OAET04CihC6LFuBeBc94mWjG+7438ZqSSX7ydIM40jp+pqDqDmLO
         G/ybrtPJysb9gwjVaeHwAFYXpE6uVlP6p/6p29PoAxlfSirWZXCozRpkAtvgmhQOYQqS
         VyiwE+nVezOfEjInvRDGL94dSh+/V0oD+6ZWLII5DaonuEsjb0awKxoA19nWbCdlk253
         nP5A==
X-Gm-Message-State: APjAAAXd3k/Ki1pdDf1/QE9lVKCisLezlaoUuynwW8soI+5a0srr4KYb
        +Esd0LLQbzQo2WJv495xjvj1UbZW
X-Google-Smtp-Source: APXvYqyrblDAw6JIQ53YnQbTt8auA6bLrx/evLNFkoZ145jworlbemkXHJBaeQPX1nwAES+6aTR/TQ==
X-Received: by 2002:a63:b005:: with SMTP id h5mr16922920pgf.67.1576881473758;
        Fri, 20 Dec 2019 14:37:53 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.37.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:37:52 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 19/32] elx: efct: Hardware IO and SGL initialization
Date:   Fri, 20 Dec 2019 14:37:10 -0800
Message-Id: <20191220223723.26563-20-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191220223723.26563-1-jsmart2021@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines to create IO interfaces (wqs, etc), SGL initialization,
and configure hardware features.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_hw.c | 1480 ++++++++++++++++++++++++++++++++++++---
 drivers/scsi/elx/efct/efct_hw.h |   46 ++
 2 files changed, 1427 insertions(+), 99 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 339e904b0276..beca8534813d 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -240,6 +240,505 @@ efct_logfcfi(struct efct_hw *hw, u32 j, u32 i, u32 id)
 		     j, hw->config.filter_def[j], i, id);
 }
 
+static inline void
+efct_hw_init_free_io(struct efct_hw_io *io)
+{
+	/*
+	 * Set io->done to NULL, to avoid any callbacks, should
+	 * a completion be received for one of these IOs
+	 */
+	io->done = NULL;
+	io->abort_done = NULL;
+	io->status_saved = false;
+	io->abort_in_progress = false;
+	io->rnode = NULL;
+	io->type = 0xFFFF;
+	io->wq = NULL;
+	io->ul_io = NULL;
+	io->tgt_wqe_timeout = 0;
+}
+
+static void
+efct_hw_io_restore_sgl(struct efct_hw *hw, struct efct_hw_io *io)
+{
+	/* Restore the default */
+	io->sgl = &io->def_sgl;
+	io->sgl_count = io->def_sgl_count;
+
+	/* Clear the overflow SGL */
+	io->ovfl_sgl = NULL;
+	io->ovfl_sgl_count = 0;
+	io->ovfl_lsp = NULL;
+}
+
+/* Initialize the pool of HW IO objects */
+static enum efct_hw_rtn
+efct_hw_setup_io(struct efct_hw *hw)
+{
+	u32	i = 0;
+	struct efct_hw_io	*io = NULL;
+	uintptr_t	xfer_virt = 0;
+	uintptr_t	xfer_phys = 0;
+	u32	index;
+	bool new_alloc = true;
+	struct efc_dma *dma;
+	struct efct *efct = hw->os;
+
+	if (!hw->io) {
+		hw->io = kmalloc_array(hw->config.n_io, sizeof(io),
+				 GFP_KERNEL);
+
+		if (!hw->io)
+			return EFCT_HW_RTN_NO_MEMORY;
+
+		memset(hw->io, 0, hw->config.n_io * sizeof(io));
+
+		for (i = 0; i < hw->config.n_io; i++) {
+			hw->io[i] = kmalloc(sizeof(*io), GFP_KERNEL);
+			if (!hw->io[i])
+				goto error;
+
+			memset(hw->io[i], 0, sizeof(struct efct_hw_io));
+		}
+
+		/* Create WQE buffs for IO */
+		hw->wqe_buffs = kmalloc((hw->config.n_io *
+					     hw->sli.wqe_size),
+					     GFP_ATOMIC);
+		if (!hw->wqe_buffs) {
+			kfree(hw->io);
+			return EFCT_HW_RTN_NO_MEMORY;
+		}
+		memset(hw->wqe_buffs, 0, (hw->config.n_io *
+					hw->sli.wqe_size));
+
+	} else {
+		/* re-use existing IOs, including SGLs */
+		new_alloc = false;
+	}
+
+	if (new_alloc) {
+		dma = &hw->xfer_rdy;
+		dma->size = sizeof(struct fcp_txrdy) * hw->config.n_io;
+		dma->virt = dma_alloc_coherent(&efct->pcidev->dev,
+					       dma->size, &dma->phys, GFP_DMA);
+		if (!dma->virt)
+			return EFCT_HW_RTN_NO_MEMORY;
+	}
+	xfer_virt = (uintptr_t)hw->xfer_rdy.virt;
+	xfer_phys = hw->xfer_rdy.phys;
+
+	for (i = 0; i < hw->config.n_io; i++) {
+		struct hw_wq_callback *wqcb;
+
+		io = hw->io[i];
+
+		/* initialize IO fields */
+		io->hw = hw;
+
+		/* Assign a WQE buff */
+		io->wqe.wqebuf = &hw->wqe_buffs[i * hw->sli.wqe_size];
+
+		/* Allocate the request tag for this IO */
+		wqcb = efct_hw_reqtag_alloc(hw, efct_hw_wq_process_io, io);
+		if (!wqcb) {
+			efc_log_err(hw->os, "can't allocate request tag\n");
+			return EFCT_HW_RTN_NO_RESOURCES;
+		}
+		io->reqtag = wqcb->instance_index;
+
+		/* Now for the fields that are initialized on each free */
+		efct_hw_init_free_io(io);
+
+		/* The XB flag isn't cleared on IO free, so init to zero */
+		io->xbusy = 0;
+
+		if (sli_resource_alloc(&hw->sli, SLI_RSRC_XRI,
+				       &io->indicator, &index)) {
+			efc_log_err(hw->os,
+				     "sli_resource_alloc failed @ %d\n", i);
+			return EFCT_HW_RTN_NO_MEMORY;
+		}
+		if (new_alloc) {
+			dma = &io->def_sgl;
+			dma->size = hw->config.n_sgl *
+					sizeof(struct sli4_sge);
+			dma->virt = dma_alloc_coherent(&efct->pcidev->dev,
+						       dma->size, &dma->phys,
+						       GFP_DMA);
+			if (!dma->virt) {
+				efc_log_err(hw->os, "dma_alloc fail %d\n", i);
+				memset(&io->def_sgl, 0,
+				       sizeof(struct efc_dma));
+				return EFCT_HW_RTN_NO_MEMORY;
+			}
+		}
+		io->def_sgl_count = hw->config.n_sgl;
+		io->sgl = &io->def_sgl;
+		io->sgl_count = io->def_sgl_count;
+
+		if (hw->xfer_rdy.size) {
+			io->xfer_rdy.virt = (void *)xfer_virt;
+			io->xfer_rdy.phys = xfer_phys;
+			io->xfer_rdy.size = sizeof(struct fcp_txrdy);
+
+			xfer_virt += sizeof(struct fcp_txrdy);
+			xfer_phys += sizeof(struct fcp_txrdy);
+		}
+	}
+
+	return EFCT_HW_RTN_SUCCESS;
+error:
+	for (i = 0; i < hw->config.n_io && hw->io[i]; i++) {
+		kfree(hw->io[i]);
+		hw->io[i] = NULL;
+	}
+
+	kfree(hw->io);
+	hw->io = NULL;
+
+	return EFCT_HW_RTN_NO_MEMORY;
+}
+
+static enum efct_hw_rtn
+efct_hw_init_io(struct efct_hw *hw)
+{
+	u32	i = 0, io_index = 0;
+	bool prereg = false;
+	struct efct_hw_io	*io = NULL;
+	u8		cmd[SLI4_BMBX_SIZE];
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+	u32	nremaining;
+	u32	n = 0;
+	u32	sgls_per_request = 256;
+	struct efc_dma	**sgls = NULL;
+	struct efc_dma	reqbuf;
+	struct efct *efct = hw->os;
+
+	prereg = hw->sli.sgl_pre_registered;
+
+	memset(&reqbuf, 0, sizeof(struct efc_dma));
+	if (prereg) {
+		sgls = kmalloc_array(sgls_per_request, sizeof(*sgls),
+				     GFP_ATOMIC);
+		if (!sgls)
+			return EFCT_HW_RTN_NO_MEMORY;
+
+		reqbuf.size = 32 + sgls_per_request * 16;
+		reqbuf.virt = dma_alloc_coherent(&efct->pcidev->dev,
+						 reqbuf.size, &reqbuf.phys,
+						 GFP_DMA);
+		if (!reqbuf.virt) {
+			efc_log_err(hw->os, "dma_alloc reqbuf failed\n");
+			kfree(sgls);
+			return EFCT_HW_RTN_NO_MEMORY;
+		}
+	}
+
+	for (nremaining = hw->config.n_io; nremaining; nremaining -= n) {
+		if (prereg) {
+			/* Copy address of SGL's into local sgls[] array, break
+			 * out if the xri is not contiguous.
+			 */
+			u32 min = (sgls_per_request < nremaining)
+					? sgls_per_request : nremaining;
+			for (n = 0; n < min; n++) {
+				/* Check that we have contiguous xri values */
+				if (n > 0) {
+					if (hw->io[io_index + n]->indicator !=
+					    hw->io[io_index + n - 1]->indicator
+					    + 1)
+						break;
+				}
+				sgls[n] = hw->io[io_index + n]->sgl;
+			}
+
+			if (!sli_cmd_post_sgl_pages(&hw->sli, cmd,
+						   sizeof(cmd),
+						hw->io[io_index]->indicator,
+						n, sgls, NULL, &reqbuf)) {
+				if (efct_hw_command(hw, cmd, EFCT_CMD_POLL,
+						    NULL, NULL)) {
+					rc = EFCT_HW_RTN_ERROR;
+					efc_log_err(hw->os,
+						     "SGL post failed\n");
+					break;
+				}
+			}
+		} else {
+			n = nremaining;
+		}
+
+		/* Add to tail if successful */
+		for (i = 0; i < n; i++, io_index++) {
+			io = hw->io[io_index];
+			io->state = EFCT_HW_IO_STATE_FREE;
+			INIT_LIST_HEAD(&io->list_entry);
+			list_add_tail(&io->list_entry, &hw->io_free);
+		}
+	}
+
+	if (prereg) {
+		dma_free_coherent(&efct->pcidev->dev,
+				  reqbuf.size, reqbuf.virt, reqbuf.phys);
+		memset(&reqbuf, 0, sizeof(struct efc_dma));
+		kfree(sgls);
+	}
+
+	return rc;
+}
+
+static enum efct_hw_rtn
+efct_hw_config_set_fdt_xfer_hint(struct efct_hw *hw, u32 fdt_xfer_hint)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+	u8 buf[SLI4_BMBX_SIZE];
+	struct sli4_rqst_cmn_set_features_set_fdt_xfer_hint param;
+
+	memset(&param, 0, sizeof(param));
+	param.fdt_xfer_hint = cpu_to_le32(fdt_xfer_hint);
+	/* build the set_features command */
+	sli_cmd_common_set_features(&hw->sli, buf, SLI4_BMBX_SIZE,
+				    SLI4_SET_FEATURES_SET_FTD_XFER_HINT,
+				    sizeof(param),
+				    &param);
+
+	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
+	if (rc)
+		efc_log_warn(hw->os, "set FDT hint %d failed: %d\n",
+			      fdt_xfer_hint, rc);
+	else
+		efc_log_info(hw->os, "Set FTD transfer hint to %d\n",
+			      le32_to_cpu(param.fdt_xfer_hint));
+
+	return rc;
+}
+
+/**
+ * efct_hw_config_mrq() - Configure Multi-RQ
+ *
+ * @hw: Hardware context allocated by the caller.
+ * @mode: 1 to set MRQ filters and 0 to set FCFI index
+ * @fcf_index: valid in mode 0
+ *
+ * Returns 0 on success, or a non-zero value on failure.
+ */
+static int
+efct_hw_config_mrq(struct efct_hw *hw, u8 mode, u16 fcf_index)
+{
+	u8 buf[SLI4_BMBX_SIZE], mrq_bitmask = 0;
+	struct hw_rq *rq;
+	struct sli4_cmd_reg_fcfi_mrq *rsp = NULL;
+	u32 i, j;
+	struct sli4_cmd_rq_cfg rq_filter[SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG];
+	int rc;
+
+	if (mode == SLI4_CMD_REG_FCFI_SET_FCFI_MODE)
+		goto issue_cmd;
+
+	/* Set the filter match/mask values from hw's filter_def values */
+	for (i = 0; i < SLI4_CMD_REG_FCFI_NUM_RQ_CFG; i++) {
+		rq_filter[i].rq_id = cpu_to_le16(0xffff);
+		rq_filter[i].r_ctl_mask  = (u8)hw->config.filter_def[i];
+		rq_filter[i].r_ctl_match = (u8)(hw->config.filter_def[i] >> 8);
+		rq_filter[i].type_mask   = (u8)(hw->config.filter_def[i] >> 16);
+		rq_filter[i].type_match  = (u8)(hw->config.filter_def[i] >> 24);
+	}
+
+	/* Accumulate counts for each filter type used, build rq_ids[] list */
+	for (i = 0; i < hw->hw_rq_count; i++) {
+		rq = hw->hw_rq[i];
+		for (j = 0; j < SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG; j++) {
+			if (!(rq->filter_mask & (1U << j)))
+				continue;
+
+			if (rq_filter[j].rq_id != cpu_to_le16(0xffff)) {
+				/*
+				 * Already used. Bailout ifts not RQset
+				 * case
+				 */
+				if (!rq->is_mrq ||
+				    rq_filter[j].rq_id !=
+				    cpu_to_le16(rq->base_mrq_id)) {
+					efc_log_err(hw->os, "Wrong q top.\n");
+					return EFCT_HW_RTN_ERROR;
+				}
+				continue;
+			}
+
+			if (!rq->is_mrq) {
+				rq_filter[j].rq_id = cpu_to_le16(rq->hdr->id);
+				continue;
+			}
+
+			rq_filter[j].rq_id = cpu_to_le16(rq->base_mrq_id);
+			mrq_bitmask |= (1U << j);
+		}
+	}
+
+issue_cmd:
+	/* Invoke REG_FCFI_MRQ */
+	rc = sli_cmd_reg_fcfi_mrq(&hw->sli,
+				  buf,	/* buf */
+				 SLI4_BMBX_SIZE, /* size */
+				 mode, /* mode 1 */
+				 fcf_index, /* fcf_index */
+				 /* RQ selection policy*/
+				 hw->config.rq_selection_policy,
+				 mrq_bitmask, /* MRQ bitmask */
+				 hw->hw_mrq_count, /* num_mrqs */
+				 rq_filter);/* RQ filter */
+	if (rc) {
+		efc_log_err(hw->os,
+			     "sli_cmd_reg_fcfi_mrq() failed: %d\n", rc);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
+
+	rsp = (struct sli4_cmd_reg_fcfi_mrq *)buf;
+
+	if (rc != EFCT_HW_RTN_SUCCESS ||
+	    le16_to_cpu(rsp->hdr.status)) {
+		efc_log_err(hw->os,
+			     "FCFI MRQ reg failed. cmd = %x status = %x\n",
+			     rsp->hdr.command,
+			     le16_to_cpu(rsp->hdr.status));
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (mode == SLI4_CMD_REG_FCFI_SET_FCFI_MODE)
+		hw->fcf_indicator = le16_to_cpu(rsp->fcfi);
+	return 0;
+}
+
+static enum efct_hw_rtn
+efct_hw_config_watchdog_timer(struct efct_hw *hw);
+
+static void
+efct_hw_watchdog_timer_cb(struct timer_list *t)
+{
+	struct efct_hw *hw = from_timer(hw, t, watchdog_timer);
+
+	efct_hw_config_watchdog_timer(hw);
+}
+
+static void
+efct_hw_cb_cfg_watchdog(struct efct_hw *hw, int status, u8 *mqe,
+			void  *arg)
+{
+	u16 timeout = hw->watchdog_timeout;
+
+	if (status != 0) {
+		efc_log_err(hw->os, "config watchdog timer failed, rc = %d\n",
+			     status);
+	} else {
+		if (timeout != 0) {
+			/*
+			 * keeping callback 500ms before timeout to keep
+			 * heartbeat alive
+			 */
+			timer_setup(&hw->watchdog_timer,
+				    &efct_hw_watchdog_timer_cb, 0);
+
+			mod_timer(&hw->watchdog_timer,
+				  jiffies +
+				  msecs_to_jiffies(timeout * 1000 - 500));
+		} else {
+			del_timer(&hw->watchdog_timer);
+		}
+	}
+
+	kfree(mqe);
+}
+
+/* Set configuration parameters for watchdog timer feature */
+static enum efct_hw_rtn
+efct_hw_config_watchdog_timer(struct efct_hw *hw)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+	u8 *buf = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+
+	if (!buf)
+		return EFCT_HW_RTN_ERROR;
+
+	sli4_cmd_lowlevel_set_watchdog(&hw->sli, buf, SLI4_BMBX_SIZE,
+				       hw->watchdog_timeout);
+	rc = efct_hw_command(hw, buf, EFCT_CMD_NOWAIT, efct_hw_cb_cfg_watchdog,
+			     NULL);
+	if (rc) {
+		kfree(buf);
+		efc_log_err(hw->os, "config watchdog timer failed, rc = %d\n",
+			     rc);
+	}
+	return rc;
+}
+
+static enum efct_hw_rtn
+efct_hw_set_dif_seed(struct efct_hw *hw)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+	u8 buf[SLI4_BMBX_SIZE];
+	struct sli4_rqst_cmn_set_features_dif_seed seed_param;
+
+	memset(&seed_param, 0, sizeof(seed_param));
+	seed_param.seed = cpu_to_le16(hw->config.dif_seed);
+
+	/* send set_features command */
+	if (!sli_cmd_common_set_features(&hw->sli, buf, SLI4_BMBX_SIZE,
+					SLI4_SET_FEATURES_DIF_SEED,
+					4,
+					(u32 *)&seed_param)) {
+		rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
+		if (rc)
+			efc_log_err(hw->os,
+				     "efct_hw_command returns %d\n", rc);
+		else
+			efc_log_debug(hw->os, "DIF seed set to 0x%x\n",
+				       hw->config.dif_seed);
+	} else {
+		efc_log_err(hw->os,
+			     "sli_cmd_common_set_features failed\n");
+		rc = EFCT_HW_RTN_ERROR;
+	}
+	return rc;
+}
+
+/* enable sli port health check */
+static enum efct_hw_rtn
+efct_hw_config_sli_port_health_check(struct efct_hw *hw, u8 query,
+				     u8 enable)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+	u8 buf[SLI4_BMBX_SIZE];
+	struct sli4_rqst_cmn_set_features_health_check param;
+	u32	health_check_flag = 0;
+
+	memset(&param, 0, sizeof(param));
+
+	if (enable)
+		health_check_flag |= SLI4_RQ_HEALTH_CHECK_ENABLE;
+
+	if (query)
+		health_check_flag |= SLI4_RQ_HEALTH_CHECK_QUERY;
+
+	param.health_check_dword = cpu_to_le32(health_check_flag);
+
+	/* build the set_features command */
+	sli_cmd_common_set_features(&hw->sli, buf, SLI4_BMBX_SIZE,
+				    SLI4_SET_FEATURES_SLI_PORT_HEALTH_CHECK,
+				    sizeof(param),
+				    &param);
+
+	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
+	if (rc)
+		efc_log_err(hw->os, "efct_hw_command returns %d\n", rc);
+	else
+		efc_log_test(hw->os, "SLI Port Health Check is enabled\n");
+
+	return rc;
+}
+
 enum efct_hw_rtn
 efct_hw_init(struct efct_hw *hw)
 {
@@ -712,104 +1211,6 @@ efct_hw_init(struct efct_hw *hw)
 	return EFCT_HW_RTN_SUCCESS;
 }
 
-/**
- * efct_hw_config_mrq() - Configure Multi-RQ
- *
- * @hw: Hardware context allocated by the caller.
- * @mode: 1 to set MRQ filters and 0 to set FCFI index
- * @fcf_index: valid in mode 0
- *
- * Returns 0 on success, or a non-zero value on failure.
- */
-static int
-efct_hw_config_mrq(struct efct_hw *hw, u8 mode, u16 fcf_index)
-{
-	u8 buf[SLI4_BMBX_SIZE], mrq_bitmask = 0;
-	struct hw_rq *rq;
-	struct sli4_cmd_reg_fcfi_mrq *rsp = NULL;
-	u32 i, j;
-	struct sli4_cmd_rq_cfg rq_filter[SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG];
-	int rc;
-
-	if (mode == SLI4_CMD_REG_FCFI_SET_FCFI_MODE)
-		goto issue_cmd;
-
-	/* Set the filter match/mask values from hw's filter_def values */
-	for (i = 0; i < SLI4_CMD_REG_FCFI_NUM_RQ_CFG; i++) {
-		rq_filter[i].rq_id = cpu_to_le16(0xffff);
-		rq_filter[i].r_ctl_mask  = (u8)hw->config.filter_def[i];
-		rq_filter[i].r_ctl_match = (u8)(hw->config.filter_def[i] >> 8);
-		rq_filter[i].type_mask   = (u8)(hw->config.filter_def[i] >> 16);
-		rq_filter[i].type_match  = (u8)(hw->config.filter_def[i] >> 24);
-	}
-
-	/* Accumulate counts for each filter type used, build rq_ids[] list */
-	for (i = 0; i < hw->hw_rq_count; i++) {
-		rq = hw->hw_rq[i];
-		for (j = 0; j < SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG; j++) {
-			if (!(rq->filter_mask & (1U << j)))
-				continue;
-
-			if (rq_filter[j].rq_id != cpu_to_le16(0xffff)) {
-				/*
-				 * Already used. Bailout ifts not RQset
-				 * case
-				 */
-				if (!rq->is_mrq ||
-				    rq_filter[j].rq_id !=
-				    cpu_to_le16(rq->base_mrq_id)) {
-					efc_log_err(hw->os, "Wrong q top.\n");
-					return EFCT_HW_RTN_ERROR;
-				}
-				continue;
-			}
-
-			if (!rq->is_mrq) {
-				rq_filter[j].rq_id = cpu_to_le16(rq->hdr->id);
-				continue;
-			}
-
-			rq_filter[j].rq_id = cpu_to_le16(rq->base_mrq_id);
-			mrq_bitmask |= (1U << j);
-		}
-	}
-
-issue_cmd:
-	/* Invoke REG_FCFI_MRQ */
-	rc = sli_cmd_reg_fcfi_mrq(&hw->sli,
-				  buf,	/* buf */
-				 SLI4_BMBX_SIZE, /* size */
-				 mode, /* mode 1 */
-				 fcf_index, /* fcf_index */
-				 /* RQ selection policy*/
-				 hw->config.rq_selection_policy,
-				 mrq_bitmask, /* MRQ bitmask */
-				 hw->hw_mrq_count, /* num_mrqs */
-				 rq_filter);/* RQ filter */
-	if (rc) {
-		efc_log_err(hw->os,
-			     "sli_cmd_reg_fcfi_mrq() failed: %d\n", rc);
-		return EFCT_HW_RTN_ERROR;
-	}
-
-	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
-
-	rsp = (struct sli4_cmd_reg_fcfi_mrq *)buf;
-
-	if (rc != EFCT_HW_RTN_SUCCESS ||
-	    le16_to_cpu(rsp->hdr.status)) {
-		efc_log_err(hw->os,
-			     "FCFI MRQ reg failed. cmd = %x status = %x\n",
-			     rsp->hdr.command,
-			     le16_to_cpu(rsp->hdr.status));
-		return EFCT_HW_RTN_ERROR;
-	}
-
-	if (mode == SLI4_CMD_REG_FCFI_SET_FCFI_MODE)
-		hw->fcf_indicator = le16_to_cpu(rsp->fcfi);
-	return 0;
-}
-
 enum efct_hw_rtn
 efct_hw_set(struct efct_hw *hw, enum efct_hw_property prop, u32 value)
 {
@@ -1221,6 +1622,10 @@ efct_get_wwn(struct efct_hw *hw, enum efct_hw_property prop)
 	return value;
 }
 
+/*
+ * An efct_hw_rx_buffer_t array is allocated,
+ * along with the required DMA mem
+ */
 static struct efc_hw_rq_buffer *
 efct_hw_rx_buffer_alloc(struct efct_hw *hw, u32 rqindex, u32 count,
 			u32 size)
@@ -1327,6 +1732,7 @@ efct_hw_rx_allocate(struct efct_hw *hw)
 	return rc ? EFCT_HW_RTN_ERROR : EFCT_HW_RTN_SUCCESS;
 }
 
+/* Post the RQ data buffers to the chip */
 enum efct_hw_rtn
 efct_hw_rx_post(struct efct_hw *hw)
 {
@@ -1414,7 +1820,7 @@ efct_hw_cmd_submit_pending(struct efct_hw *hw)
 	return rc;
 }
 
-/**
+/*
  * Send a mailbox command to the hardware, and either wait for a completion
  * (EFCT_CMD_POLL) or get an optional asynchronous completion (EFCT_CMD_NOWAIT).
  */
@@ -1575,3 +1981,879 @@ efct_hw_command_cancel(struct efct_hw *hw)
 
 	return 0;
 }
+
+static inline struct efct_hw_io *
+_efct_hw_io_alloc(struct efct_hw *hw)
+{
+	struct efct_hw_io	*io = NULL;
+
+	if (!list_empty(&hw->io_free)) {
+		io = list_first_entry(&hw->io_free, struct efct_hw_io,
+				      list_entry);
+		list_del(&io->list_entry);
+	}
+	if (io) {
+		INIT_LIST_HEAD(&io->list_entry);
+		INIT_LIST_HEAD(&io->wqe_link);
+		INIT_LIST_HEAD(&io->dnrx_link);
+		list_add_tail(&io->list_entry, &hw->io_inuse);
+		io->state = EFCT_HW_IO_STATE_INUSE;
+		io->abort_reqtag = U32_MAX;
+		kref_init(&io->ref);
+		io->release = efct_hw_io_free_internal;
+	} else {
+		atomic_add_return(1, &hw->io_alloc_failed_count);
+	}
+
+	return io;
+}
+
+struct efct_hw_io *
+efct_hw_io_alloc(struct efct_hw *hw)
+{
+	struct efct_hw_io	*io = NULL;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&hw->io_lock, flags);
+	io = _efct_hw_io_alloc(hw);
+	spin_unlock_irqrestore(&hw->io_lock, flags);
+
+	return io;
+}
+
+/*
+ * When an IO is freed, depending on the exchange busy flag, and other
+ * workarounds, move it to the correct list.
+ */
+static void
+efct_hw_io_free_move_correct_list(struct efct_hw *hw,
+				  struct efct_hw_io *io)
+{
+	if (io->xbusy) {
+		/*
+		 * add to wait_free list and wait for XRI_ABORTED CQEs to clean
+		 * up
+		 */
+		INIT_LIST_HEAD(&io->list_entry);
+		list_add_tail(&io->list_entry, &hw->io_wait_free);
+		io->state = EFCT_HW_IO_STATE_WAIT_FREE;
+	} else {
+		/* IO not busy, add to free list */
+		INIT_LIST_HEAD(&io->list_entry);
+		list_add_tail(&io->list_entry, &hw->io_free);
+		io->state = EFCT_HW_IO_STATE_FREE;
+	}
+}
+
+static inline void
+efct_hw_io_free_common(struct efct_hw *hw, struct efct_hw_io *io)
+{
+	/* initialize IO fields */
+	efct_hw_init_free_io(io);
+
+	/* Restore default SGL */
+	efct_hw_io_restore_sgl(hw, io);
+}
+
+/**
+ * Free a previously-allocated HW IO object. Called when
+ * IO refcount goes to zero (host-owned IOs only).
+ */
+void
+efct_hw_io_free_internal(struct kref *arg)
+{
+	unsigned long flags = 0;
+	struct efct_hw_io *io =
+			container_of(arg, struct efct_hw_io, ref);
+	struct efct_hw *hw = io->hw;
+
+	/* perform common cleanup */
+	efct_hw_io_free_common(hw, io);
+
+	spin_lock_irqsave(&hw->io_lock, flags);
+		/* remove from in-use list */
+		if (io->list_entry.next &&
+		    !list_empty(&hw->io_inuse)) {
+			list_del(&io->list_entry);
+			efct_hw_io_free_move_correct_list(hw, io);
+		}
+	spin_unlock_irqrestore(&hw->io_lock, flags);
+}
+
+int
+efct_hw_io_free(struct efct_hw *hw, struct efct_hw_io *io)
+{
+	/* just put refcount */
+	if (refcount_read(&io->ref.refcount) <= 0) {
+		efc_log_err(hw->os,
+			     "Bad parameter: refcount <= 0 xri=%x tag=%x\n",
+			    io->indicator, io->reqtag);
+		return -1;
+	}
+
+	return kref_put(&io->ref, io->release);
+}
+
+u8
+efct_hw_io_inuse(struct efct_hw *hw, struct efct_hw_io *io)
+{
+	return (refcount_read(&io->ref.refcount) > 0);
+}
+
+struct efct_hw_io *
+efct_hw_io_lookup(struct efct_hw *hw, u32 xri)
+{
+	u32 ioindex;
+
+	ioindex = xri - hw->sli.extent[SLI_RSRC_XRI].base[0];
+	return hw->io[ioindex];
+}
+
+/**
+ * Issue any pending callbacks for an IO and remove off the timer and
+ * pending lists.
+ */
+static void
+efct_hw_io_cancel_cleanup(struct efct_hw *hw, struct efct_hw_io *io)
+{
+	efct_hw_done_t done = io->done;
+	efct_hw_done_t abort_done = io->abort_done;
+	unsigned long flags = 0;
+
+	/* first check active_wqe list and remove if there */
+	if (io->wqe_link.next)
+		list_del(&io->wqe_link);
+
+	/* Remove from WQ pending list */
+	if (io->wq && io->wq->pending_list.next)
+		list_del(&io->list_entry);
+
+	if (io->done) {
+		void *arg = io->arg;
+
+		io->done = NULL;
+		spin_unlock_irqrestore(&hw->io_lock, flags);
+		done(io, io->rnode, 0, SLI4_FC_WCQE_STATUS_SHUTDOWN, 0, arg);
+		spin_lock_irqsave(&hw->io_lock, flags);
+	}
+
+	if (io->abort_done) {
+		void		*abort_arg = io->abort_arg;
+
+		io->abort_done = NULL;
+		spin_unlock_irqrestore(&hw->io_lock, flags);
+		abort_done(io, io->rnode, 0, SLI4_FC_WCQE_STATUS_SHUTDOWN, 0,
+			   abort_arg);
+		spin_lock_irqsave(&hw->io_lock, flags);
+	}
+}
+
+static int
+efct_hw_io_cancel(struct efct_hw *hw)
+{
+	struct efct_hw_io *io = NULL;
+	struct efct_hw_io *tmp_io = NULL;
+	u32 iters = 100; /* One second limit */
+	unsigned long flags = 0;
+
+	/*
+	 * Manually clean up outstanding IO.
+	 * Only walk through list once: the backend will cleanup any IOs when
+	 * done/abort_done is called.
+	 */
+	spin_lock_irqsave(&hw->io_lock, flags);
+	list_for_each_entry_safe(io, tmp_io, &hw->io_inuse, list_entry) {
+		efct_hw_done_t  done = io->done;
+		efct_hw_done_t  abort_done = io->abort_done;
+
+		efct_hw_io_cancel_cleanup(hw, io);
+
+		/*
+		 * Since this is called in a reset/shutdown
+		 * case, If there is no callback, then just
+		 * free the IO.
+		 *
+		 * Note: A port owned XRI cannot be on
+		 *       the in use list. We cannot call
+		 *       efct_hw_io_free() because we already
+		 *       hold the io_lock.
+		 */
+		if (!done &&
+		    !abort_done) {
+			/*
+			 * Since this is called in a reset/shutdown
+			 * case, If there is no callback, then just
+			 * free the IO.
+			 */
+			efct_hw_io_free_common(hw, io);
+			list_del(&io->list_entry);
+			efct_hw_io_free_move_correct_list(hw, io);
+		}
+	}
+
+	spin_unlock_irqrestore(&hw->io_lock, flags);
+
+	/* Give time for the callbacks to complete */
+	do {
+		mdelay(10);
+		iters--;
+	} while (!list_empty(&hw->io_inuse) && iters);
+
+	/* Leave a breadcrumb that cleanup is not yet complete. */
+	if (!list_empty(&hw->io_inuse))
+		efc_log_test(hw->os, "io_inuse list is not empty\n");
+
+	return 0;
+}
+
+enum efct_hw_rtn
+efct_hw_io_register_sgl(struct efct_hw *hw, struct efct_hw_io *io,
+			struct efc_dma *sgl,
+			u32 sgl_count)
+{
+	if (hw->sli.sgl_pre_registered) {
+		efc_log_err(hw->os,
+			     "can't use temp SGL with pre-registered SGLs\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+	io->ovfl_sgl = sgl;
+	io->ovfl_sgl_count = sgl_count;
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+enum efct_hw_rtn
+efct_hw_io_init_sges(struct efct_hw *hw, struct efct_hw_io *io,
+		     enum efct_hw_io_type type)
+{
+	struct sli4_sge	*data = NULL;
+	u32 i = 0;
+	u32 skips = 0;
+	u32 sge_flags = 0;
+
+	if (!io) {
+		efc_log_err(hw->os,
+			     "bad parameter hw=%p io=%p\n", hw, io);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/* Clear / reset the scatter-gather list */
+	io->sgl = &io->def_sgl;
+	io->sgl_count = io->def_sgl_count;
+	io->first_data_sge = 0;
+
+	memset(io->sgl->virt, 0, 2 * sizeof(struct sli4_sge));
+	io->n_sge = 0;
+	io->sge_offset = 0;
+
+	io->type = type;
+
+	data = io->sgl->virt;
+
+	/*
+	 * Some IO types have underlying hardware requirements on the order
+	 * of SGEs. Process all special entries here.
+	 */
+	switch (type) {
+	case EFCT_HW_IO_TARGET_WRITE:
+#define EFCT_TARGET_WRITE_SKIPS	2
+		skips = EFCT_TARGET_WRITE_SKIPS;
+
+		/* populate host resident XFER_RDY buffer */
+		sge_flags = le32_to_cpu(data->dw2_flags);
+		sge_flags &= (~SLI4_SGE_TYPE_MASK);
+		sge_flags |= (SLI4_SGE_TYPE_DATA << SLI4_SGE_TYPE_SHIFT);
+		data->buffer_address_high =
+			cpu_to_le32(upper_32_bits(io->xfer_rdy.phys));
+		data->buffer_address_low  =
+			cpu_to_le32(lower_32_bits(io->xfer_rdy.phys));
+		data->buffer_length = cpu_to_le32(io->xfer_rdy.size);
+		data->dw2_flags = cpu_to_le32(sge_flags);
+		data++;
+
+		skips--;
+
+		io->n_sge = 1;
+		break;
+	case EFCT_HW_IO_TARGET_READ:
+		/*
+		 * For FCP_TSEND64, the first 2 entries are SKIP SGE's
+		 */
+#define EFCT_TARGET_READ_SKIPS	2
+		skips = EFCT_TARGET_READ_SKIPS;
+		break;
+	case EFCT_HW_IO_TARGET_RSP:
+		/*
+		 * No skips, etc. for FCP_TRSP64
+		 */
+		break;
+	default:
+		efc_log_err(hw->os, "unsupported IO type %#x\n", type);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/*
+	 * Write skip entries
+	 */
+	for (i = 0; i < skips; i++) {
+		sge_flags = le32_to_cpu(data->dw2_flags);
+		sge_flags &= (~SLI4_SGE_TYPE_MASK);
+		sge_flags |= (SLI4_SGE_TYPE_SKIP << SLI4_SGE_TYPE_SHIFT);
+		data->dw2_flags = cpu_to_le32(sge_flags);
+		data++;
+	}
+
+	io->n_sge += skips;
+
+	/*
+	 * Set last
+	 */
+	sge_flags = le32_to_cpu(data->dw2_flags);
+	sge_flags |= SLI4_SGE_LAST;
+	data->dw2_flags = cpu_to_le32(sge_flags);
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+enum efct_hw_rtn
+efct_hw_io_add_seed_sge(struct efct_hw *hw, struct efct_hw_io *io,
+			struct efct_hw_dif_info *dif_info)
+{
+	struct sli4_sge	*data = NULL;
+	struct sli4_diseed_sge *dif_seed;
+	u32 sge_flags;
+	u16 dif_flags;
+
+	/* If no dif_info, or dif_oper is disabled, then just return success */
+	if (!dif_info ||
+	    dif_info->dif_oper == EFCT_HW_DIF_OPER_DISABLED)
+		return EFCT_HW_RTN_SUCCESS;
+
+	if (!io) {
+		efc_log_err(hw->os,
+			     "bad parameter hw=%p io=%p dif_info=%p\n", hw,
+			    io, dif_info);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	data = io->sgl->virt;
+	data += io->n_sge;
+
+	/* If we are doing T10 DIF add the DIF Seed SGE */
+	memset(data, 0, sizeof(struct sli4_diseed_sge));
+	dif_seed = (struct sli4_diseed_sge *)data;
+
+	dif_seed->ref_tag_cmp = cpu_to_le32(dif_info->ref_tag_cmp);
+	dif_seed->ref_tag_repl = cpu_to_le32(dif_info->ref_tag_repl);
+	dif_seed->app_tag_repl = cpu_to_le16(dif_info->app_tag_repl);
+
+	dif_flags = 0;
+	if (dif_info->repl_app_tag)
+		dif_flags |= DISEED_SGE_RE;
+
+	if (hw->sli.if_type != SLI4_INTF_IF_TYPE_2) {
+		if (dif_info->disable_app_ref_ffff)
+			dif_flags |= DISEED_SGE_ATRT;
+
+		if (dif_info->disable_app_ffff)
+			dif_flags |= DISEED_SGE_AT;
+	}
+	dif_flags |= SLI4_SGE_TYPE_DISEED << 11;
+
+	if ((io->type == EFCT_HW_IO_TARGET_WRITE) &&
+	    hw->sli.if_type != SLI4_INTF_IF_TYPE_2 &&
+	    dif_info->dif_separate) {
+		dif_flags &= ~SLI4_SGE_TYPE_MASK;
+		dif_flags |= SLI4_SGE_TYPE_SKIP << 11;
+	}
+
+	dif_seed->dw2w1_flags = cpu_to_le16(dif_flags);
+	dif_seed->app_tag_cmp = cpu_to_le16(dif_info->app_tag_cmp);
+
+	dif_flags = 0;
+	dif_flags |= (dif_info->blk_size & DISEED_SGE_BS_MASK);
+	if (dif_info->auto_incr_ref_tag)
+		dif_flags |= DISEED_SGE_AI;
+	if (dif_info->check_app_tag)
+		dif_flags |= DISEED_SGE_ME;
+	if (dif_info->check_ref_tag)
+		dif_flags |= DISEED_SGE_RE;
+	if (dif_info->check_guard)
+		dif_flags |= DISEED_SGE_CE;
+	if (dif_info->repl_ref_tag)
+		dif_flags |= DISEED_SGE_NR;
+
+	switch (dif_info->dif_oper) {
+	case EFCT_HW_SGE_DIFOP_INNODIFOUTCRC:
+		dif_flags |= DISEED_SGE_OP_RX_VALUE(IN_NODIF_OUT_CRC);
+		dif_flags |= DISEED_SGE_OP_TX_VALUE(IN_NODIF_OUT_CRC);
+		break;
+	case EFCT_HW_SGE_DIFOP_INCRCOUTNODIF:
+		dif_flags |= DISEED_SGE_OP_RX_VALUE(IN_CRC_OUT_NODIF);
+		dif_flags |= DISEED_SGE_OP_TX_VALUE(IN_CRC_OUT_NODIF);
+		break;
+	case EFCT_HW_SGE_DIFOP_INNODIFOUTCHKSUM:
+		dif_flags |= DISEED_SGE_OP_RX_VALUE(IN_NODIF_OUT_CSUM);
+		dif_flags |= DISEED_SGE_OP_TX_VALUE(IN_NODIF_OUT_CSUM);
+		break;
+	case EFCT_HW_SGE_DIFOP_INCHKSUMOUTNODIF:
+		dif_flags |= DISEED_SGE_OP_RX_VALUE(IN_CSUM_OUT_NODIF);
+		dif_flags |= DISEED_SGE_OP_TX_VALUE(IN_CSUM_OUT_NODIF);
+		break;
+	case EFCT_HW_SGE_DIFOP_INCRCOUTCRC:
+		dif_flags |= DISEED_SGE_OP_RX_VALUE(IN_CRC_OUT_CRC);
+		dif_flags |= DISEED_SGE_OP_TX_VALUE(IN_CRC_OUT_CRC);
+		break;
+	case EFCT_HW_SGE_DIFOP_INCHKSUMOUTCHKSUM:
+		dif_flags |= DISEED_SGE_OP_RX_VALUE(IN_CSUM_OUT_CSUM);
+		dif_flags |= DISEED_SGE_OP_TX_VALUE(IN_CSUM_OUT_CSUM);
+		break;
+	case EFCT_HW_SGE_DIFOP_INCRCOUTCHKSUM:
+		dif_flags |= DISEED_SGE_OP_RX_VALUE(IN_CRC_OUT_CSUM);
+		dif_flags |= DISEED_SGE_OP_TX_VALUE(IN_CRC_OUT_CSUM);
+		break;
+	case EFCT_HW_SGE_DIFOP_INCHKSUMOUTCRC:
+		dif_flags |= DISEED_SGE_OP_RX_VALUE(IN_CSUM_OUT_CRC);
+		dif_flags |= DISEED_SGE_OP_TX_VALUE(IN_CSUM_OUT_CRC);
+		break;
+	case EFCT_HW_SGE_DIFOP_INRAWOUTRAW:
+		dif_flags |= DISEED_SGE_OP_RX_VALUE(IN_RAW_OUT_RAW);
+		dif_flags |= DISEED_SGE_OP_TX_VALUE(IN_RAW_OUT_RAW);
+		break;
+	default:
+		efc_log_err(hw->os, "unsupported DIF operation %#x\n",
+			     dif_info->dif_oper);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	dif_seed->dw3w1_flags = cpu_to_le16(dif_flags);
+	/*
+	 * Set last, clear previous last
+	 */
+	sge_flags = le32_to_cpu(data->dw2_flags);
+	sge_flags |= SLI4_SGE_LAST;
+	data->dw2_flags = cpu_to_le32(sge_flags);
+	if (io->n_sge) {
+		sge_flags = le32_to_cpu(data[-1].dw2_flags);
+		sge_flags &= ~SLI4_SGE_LAST;
+		data[-1].dw2_flags = cpu_to_le32(sge_flags);
+	}
+
+	io->n_sge++;
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+static enum efct_hw_rtn
+efct_hw_io_overflow_sgl(struct efct_hw *hw, struct efct_hw_io *io)
+{
+	struct sli4_lsp_sge *lsp;
+	u32 dw2_flags = 0;
+
+	/* fail if we're already pointing to the overflow SGL */
+	if (io->sgl == io->ovfl_sgl)
+		return EFCT_HW_RTN_ERROR;
+
+	/* fail if we don't have an overflow SGL registered */
+	if (!io->ovfl_sgl)
+		return EFCT_HW_RTN_ERROR;
+
+	/*
+	 * Overflow, we need to put a link SGE in the last location of the
+	 * current SGL, after copying the the last SGE to the overflow SGL
+	 */
+
+	((struct sli4_sge *)io->ovfl_sgl->virt)[0] =
+			 ((struct sli4_sge *)io->sgl->virt)[io->n_sge - 1];
+
+	lsp = &((struct sli4_lsp_sge *)io->sgl->virt)[io->n_sge - 1];
+	memset(lsp, 0, sizeof(*lsp));
+
+	lsp->buffer_address_high =
+		cpu_to_le32(upper_32_bits(io->ovfl_sgl->phys));
+	lsp->buffer_address_low  =
+		cpu_to_le32(lower_32_bits(io->ovfl_sgl->phys));
+	dw2_flags = SLI4_SGE_TYPE_LSP << SLI4_SGE_TYPE_SHIFT;
+	dw2_flags &= ~SLI4_SGE_LAST;
+	lsp->dw2_flags = cpu_to_le32(dw2_flags);
+
+	io->ovfl_lsp = lsp;
+	io->ovfl_lsp->dw3_seglen =
+		cpu_to_le32(sizeof(struct sli4_sge) &
+			    SLI4_LSP_SGE_SEGLEN);
+
+	/* Update the current SGL pointer, and n_sgl */
+	io->sgl = io->ovfl_sgl;
+	io->sgl_count = io->ovfl_sgl_count;
+	io->n_sge = 1;
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+enum efct_hw_rtn
+efct_hw_io_add_sge(struct efct_hw *hw, struct efct_hw_io *io,
+		   uintptr_t addr, u32 length)
+{
+	struct sli4_sge	*data = NULL;
+	u32 sge_flags = 0;
+
+	if (!io || !addr || !length) {
+		efc_log_err(hw->os,
+			     "bad parameter hw=%p io=%p addr=%lx length=%u\n",
+			    hw, io, addr, length);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (length && (io->n_sge + 1) > io->sgl_count) {
+		if (efct_hw_io_overflow_sgl(hw, io) != EFCT_HW_RTN_SUCCESS) {
+			efc_log_err(hw->os, "SGL full (%d)\n", io->n_sge);
+			return EFCT_HW_RTN_ERROR;
+		}
+	}
+
+	if (length > hw->sli.sge_supported_length) {
+		efc_log_err(hw->os,
+			     "length of SGE %d bigger than allowed %d\n",
+			    length, hw->sli.sge_supported_length);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	data = io->sgl->virt;
+	data += io->n_sge;
+
+	sge_flags = le32_to_cpu(data->dw2_flags);
+	sge_flags &= ~SLI4_SGE_TYPE_MASK;
+	sge_flags |= SLI4_SGE_TYPE_DATA << SLI4_SGE_TYPE_SHIFT;
+	sge_flags &= ~SLI4_SGE_DATA_OFFSET_MASK;
+	sge_flags |= SLI4_SGE_DATA_OFFSET_MASK & io->sge_offset;
+
+	data->buffer_address_high = cpu_to_le32(upper_32_bits(addr));
+	data->buffer_address_low  = cpu_to_le32(lower_32_bits(addr));
+	data->buffer_length = cpu_to_le32(length);
+
+	/*
+	 * Always assume this is the last entry and mark as such.
+	 * If this is not the first entry unset the "last SGE"
+	 * indication for the previous entry
+	 */
+	sge_flags |= SLI4_SGE_LAST;
+	data->dw2_flags = cpu_to_le32(sge_flags);
+
+	if (io->n_sge) {
+		sge_flags = le32_to_cpu(data[-1].dw2_flags);
+		sge_flags &= ~SLI4_SGE_LAST;
+		data[-1].dw2_flags = cpu_to_le32(sge_flags);
+	}
+
+	/* Set first_data_bde if not previously set */
+	if (io->first_data_sge == 0)
+		io->first_data_sge = io->n_sge;
+
+	io->sge_offset += length;
+	io->n_sge++;
+
+	/* Update the linked segment length (only executed after overflow has
+	 * begun)
+	 */
+	if (io->ovfl_lsp)
+		io->ovfl_lsp->dw3_seglen =
+			cpu_to_le32(io->n_sge * sizeof(struct sli4_sge) &
+				    SLI4_LSP_SGE_SEGLEN);
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+enum efct_hw_rtn
+efct_hw_io_add_dif_sge(struct efct_hw *hw,
+		       struct efct_hw_io *io, uintptr_t addr)
+{
+	struct sli4_dif_sge *data = NULL;
+	u32 sge_flags = 0;
+
+	if (!io || !addr) {
+		efc_log_err(hw->os,
+			     "bad parameter hw=%p io=%p addr=%lx\n",
+			    hw, io, addr);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if ((io->n_sge + 1) > hw->config.n_sgl) {
+		if (efct_hw_io_overflow_sgl(hw, io) != EFCT_HW_RTN_ERROR) {
+			efc_log_err(hw->os, "SGL full (%d)\n", io->n_sge);
+			return EFCT_HW_RTN_ERROR;
+		}
+	}
+
+	data = io->sgl->virt;
+	data += io->n_sge;
+
+	sge_flags = le32_to_cpu(data->dw2_flags);
+	sge_flags &= ~SLI4_SGE_TYPE_MASK;
+	sge_flags |= SLI4_SGE_TYPE_DIF << SLI4_SGE_TYPE_SHIFT;
+
+	if ((io->type == EFCT_HW_IO_TARGET_WRITE) &&
+	    hw->sli.if_type != SLI4_INTF_IF_TYPE_2) {
+		sge_flags &= ~SLI4_SGE_TYPE_MASK;
+		sge_flags |= SLI4_SGE_TYPE_SKIP << SLI4_SGE_TYPE_SHIFT;
+	}
+
+	data->buffer_address_high = cpu_to_le32(upper_32_bits(addr));
+	data->buffer_address_low  = cpu_to_le32(lower_32_bits(addr));
+
+	/*
+	 * Always assume this is the last entry and mark as such.
+	 * If this is not the first entry unset the "last SGE"
+	 * indication for the previous entry
+	 */
+	sge_flags |= SLI4_SGE_LAST;
+	data->dw2_flags = cpu_to_le32(sge_flags);
+	if (io->n_sge) {
+		sge_flags = le32_to_cpu(data[-1].dw2_flags);
+		sge_flags &= ~SLI4_SGE_LAST;
+		data[-1].dw2_flags &= cpu_to_le32(sge_flags);
+	}
+
+	io->n_sge++;
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+void
+efct_hw_io_abort_all(struct efct_hw *hw)
+{
+	struct efct_hw_io *io_to_abort	= NULL;
+	struct efct_hw_io *next_io = NULL;
+
+	list_for_each_entry_safe(io_to_abort, next_io,
+				 &hw->io_inuse, list_entry) {
+		efct_hw_io_abort(hw, io_to_abort, true, NULL, NULL);
+	}
+}
+
+enum efct_hw_rtn
+efct_hw_io_abort(struct efct_hw *hw, struct efct_hw_io *io_to_abort,
+		 bool send_abts, void *cb, void *arg)
+{
+	enum sli4_abort_type atype = SLI_ABORT_MAX;
+	u32 id = 0, mask = 0;
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+	struct hw_wq_callback *wqcb;
+	unsigned long flags = 0;
+
+	if (!io_to_abort) {
+		efc_log_err(hw->os,
+			     "bad parameter hw=%p io=%p\n",
+			    hw, io_to_abort);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (hw->state != EFCT_HW_STATE_ACTIVE) {
+		efc_log_err(hw->os, "cannot send IO abort, HW state=%d\n",
+			     hw->state);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/* take a reference on IO being aborted */
+	if (kref_get_unless_zero(&io_to_abort->ref) == 0) {
+		/* command no longer active */
+		efc_log_test(hw->os,
+			      "io not active xri=0x%x tag=0x%x\n",
+			     io_to_abort->indicator, io_to_abort->reqtag);
+		return EFCT_HW_RTN_IO_NOT_ACTIVE;
+	}
+
+	/* Must have a valid WQ reference */
+	if (!io_to_abort->wq) {
+		efc_log_test(hw->os, "io_to_abort xri=0x%x not active on WQ\n",
+			      io_to_abort->indicator);
+		/* efct_ref_get(): same function */
+		kref_put(&io_to_abort->ref, io_to_abort->release);
+		return EFCT_HW_RTN_IO_NOT_ACTIVE;
+	}
+
+	/*
+	 * Validation checks complete; now check to see if already being
+	 * aborted
+	 */
+	spin_lock_irqsave(&hw->io_abort_lock, flags);
+	if (io_to_abort->abort_in_progress) {
+		spin_unlock_irqrestore(&hw->io_abort_lock, flags);
+		/* efct_ref_get(): same function */
+		kref_put(&io_to_abort->ref, io_to_abort->release);
+		efc_log_debug(hw->os,
+			       "io already being aborted xri=0x%x tag=0x%x\n",
+			      io_to_abort->indicator, io_to_abort->reqtag);
+		return EFCT_HW_RTN_IO_ABORT_IN_PROGRESS;
+	}
+
+	/*
+	 * This IO is not already being aborted. Set flag so we won't try to
+	 * abort it again. After all, we only have one abort_done callback.
+	 */
+	io_to_abort->abort_in_progress = true;
+	spin_unlock_irqrestore(&hw->io_abort_lock, flags);
+
+	/*
+	 * If we got here, the possibilities are:
+	 * - host owned xri
+	 *	- io_to_abort->wq_index != U32_MAX
+	 *		- submit ABORT_WQE to same WQ
+	 * - port owned xri:
+	 *	- rxri: io_to_abort->wq_index == U32_MAX
+	 *		- submit ABORT_WQE to any WQ
+	 *	- non-rxri
+	 *		- io_to_abort->index != U32_MAX
+	 *			- submit ABORT_WQE to same WQ
+	 *		- io_to_abort->index == U32_MAX
+	 *			- submit ABORT_WQE to any WQ
+	 */
+	io_to_abort->abort_done = cb;
+	io_to_abort->abort_arg  = arg;
+
+	atype = SLI_ABORT_XRI;
+	id = io_to_abort->indicator;
+
+	/* Allocate a request tag for the abort portion of this IO */
+	wqcb = efct_hw_reqtag_alloc(hw, efct_hw_wq_process_abort, io_to_abort);
+	if (!wqcb) {
+		efc_log_err(hw->os, "can't allocate request tag\n");
+		return EFCT_HW_RTN_NO_RESOURCES;
+	}
+	io_to_abort->abort_reqtag = wqcb->instance_index;
+
+	/*
+	 * If the wqe is on the pending list, then set this wqe to be
+	 * aborted when the IO's wqe is removed from the list.
+	 */
+	if (io_to_abort->wq) {
+		spin_lock_irqsave(&io_to_abort->wq->queue->lock, flags);
+		if (io_to_abort->wqe.list_entry.next) {
+			io_to_abort->wqe.abort_wqe_submit_needed = true;
+			io_to_abort->wqe.send_abts = send_abts;
+			io_to_abort->wqe.id = id;
+			io_to_abort->wqe.abort_reqtag =
+						 io_to_abort->abort_reqtag;
+			spin_unlock_irqrestore(&io_to_abort->wq->queue->lock,
+					       flags);
+			return 0;
+		}
+		spin_unlock_irqrestore(&io_to_abort->wq->queue->lock, flags);
+	}
+
+	if (sli_abort_wqe(&hw->sli, io_to_abort->wqe.wqebuf,
+			  hw->sli.wqe_size, atype, send_abts, id, mask,
+			  io_to_abort->abort_reqtag, SLI4_CQ_DEFAULT)) {
+		efc_log_err(hw->os, "ABORT WQE error\n");
+		io_to_abort->abort_reqtag = U32_MAX;
+		efct_hw_reqtag_free(hw, wqcb);
+		rc = EFCT_HW_RTN_ERROR;
+	}
+
+	if (rc == EFCT_HW_RTN_SUCCESS) {
+		if (!io_to_abort->wq)
+			io_to_abort->wq = efct_hw_queue_next_wq(hw,
+								io_to_abort);
+
+		/* ABORT_WQE does not actually utilize an XRI on the Port,
+		 * therefore, keep xbusy as-is to track the exchange's state,
+		 * not the ABORT_WQE's state
+		 */
+		rc = efct_hw_wq_write(io_to_abort->wq, &io_to_abort->wqe);
+		if (rc > 0)
+			/* non-negative return is success */
+			rc = 0;
+			/*
+			 * can't abort an abort so skip adding to timed wqe
+			 * list
+			 */
+	}
+
+	if (rc != EFCT_HW_RTN_SUCCESS) {
+		spin_lock_irqsave(&hw->io_abort_lock, flags);
+		io_to_abort->abort_in_progress = false;
+		spin_unlock_irqrestore(&hw->io_abort_lock, flags);
+		/* efct_ref_get(): same function */
+		kref_put(&io_to_abort->ref, io_to_abort->release);
+	}
+	return rc;
+}
+
+enum efct_hw_rtn
+efct_hw_reqtag_init(struct efct_hw *hw)
+{
+	if (!hw->wq_reqtag_pool) {
+		hw->wq_reqtag_pool = efct_pool_alloc(hw->os,
+					sizeof(struct hw_wq_callback),
+					65536);
+		if (!hw->wq_reqtag_pool) {
+			efc_log_err(hw->os,
+				     "efct_pool_alloc struct hw_wq_callback fail\n");
+			return EFCT_HW_RTN_NO_MEMORY;
+		}
+	}
+	efct_hw_reqtag_reset(hw);
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+struct hw_wq_callback *
+efct_hw_reqtag_alloc(struct efct_hw *hw,
+		     void (*callback)(void *arg, u8 *cqe, int status),
+		     void *arg)
+{
+	struct hw_wq_callback *wqcb = NULL;
+
+	if (!callback)
+		return wqcb;
+
+	wqcb = efct_pool_get(hw->wq_reqtag_pool);
+	if (wqcb) {
+		wqcb->callback = callback;
+		wqcb->arg = arg;
+	}
+	return wqcb;
+}
+
+void
+efct_hw_reqtag_free(struct efct_hw *hw, struct hw_wq_callback *wqcb)
+{
+	if (!wqcb->callback)
+		efc_log_err(hw->os, "WQCB is already freed\n");
+
+	wqcb->callback = NULL;
+	wqcb->arg = NULL;
+	efct_pool_put(hw->wq_reqtag_pool, wqcb);
+}
+
+struct hw_wq_callback *
+efct_hw_reqtag_get_instance(struct efct_hw *hw, u32 instance_index)
+{
+	struct hw_wq_callback *wqcb;
+
+	wqcb = efct_pool_get_instance(hw->wq_reqtag_pool, instance_index);
+	if (!wqcb)
+		efc_log_err(hw->os, "wqcb for instance %d is null\n",
+			     instance_index);
+
+	return wqcb;
+}
+
+void
+efct_hw_reqtag_reset(struct efct_hw *hw)
+{
+	struct hw_wq_callback *wqcb;
+	u32 i;
+
+	/* Remove all from freelist */
+	while (efct_pool_get(hw->wq_reqtag_pool))
+		;
+
+	/* Put them all back */
+	for (i = 0;
+	     ((wqcb = efct_pool_get_instance(hw->wq_reqtag_pool, i)) != NULL);
+	     i++) {
+		wqcb->instance_index = i;
+		wqcb->callback = NULL;
+		wqcb->arg = NULL;
+		efct_pool_put(hw->wq_reqtag_pool, wqcb);
+	}
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index 2360b64fc2c3..9e4ac83a81d4 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -869,5 +869,51 @@ void efct_hw_rx_free(struct efct_hw *hw);
 extern enum efct_hw_rtn
 efct_hw_command(struct efct_hw *hw, u8 *cmd, u32 opts, void *cb,
 		void *arg);
+struct efct_hw_io *efct_hw_io_alloc(struct efct_hw *hw);
+int efct_hw_io_free(struct efct_hw *hw, struct efct_hw_io *io);
+u8 efct_hw_io_inuse(struct efct_hw *hw, struct efct_hw_io *io);
+extern enum efct_hw_rtn
+efct_hw_io_send(struct efct_hw *hw, enum efct_hw_io_type type,
+		struct efct_hw_io *io, u32 len,
+		union efct_hw_io_param_u *iparam,
+		struct efc_remote_node *rnode, void *cb, void *arg);
+extern enum efct_hw_rtn
+efct_hw_io_register_sgl(struct efct_hw *hw, struct efct_hw_io *io,
+			struct efc_dma *sgl,
+			u32 sgl_count);
+extern enum efct_hw_rtn
+efct_hw_io_init_sges(struct efct_hw *hw,
+		     struct efct_hw_io *io, enum efct_hw_io_type type);
+extern enum efct_hw_rtn
+efct_hw_io_add_seed_sge(struct efct_hw *hw, struct efct_hw_io *io,
+			struct efct_hw_dif_info *dif_info);
+extern enum efct_hw_rtn
+efct_hw_io_add_sge(struct efct_hw *hw, struct efct_hw_io *io,
+		   uintptr_t addr, u32 length);
+extern enum efct_hw_rtn
+efct_hw_io_add_dif_sge(struct efct_hw *hw, struct efct_hw_io *io,
+		       uintptr_t addr);
+extern enum efct_hw_rtn
+efct_hw_io_abort(struct efct_hw *hw, struct efct_hw_io *io_to_abort,
+		 bool send_abts, void *cb, void *arg);
+extern u32
+efct_hw_io_get_count(struct efct_hw *hw,
+		     enum efct_hw_io_count_type io_count_type);
+extern struct efct_hw_io
+*efct_hw_io_lookup(struct efct_hw *hw, u32 indicator);
+void efct_hw_io_abort_all(struct efct_hw *hw);
+void efct_hw_io_free_internal(struct kref *arg);
+
+/* HW WQ request tag API */
+enum efct_hw_rtn efct_hw_reqtag_init(struct efct_hw *hw);
+extern struct hw_wq_callback
+*efct_hw_reqtag_alloc(struct efct_hw *hw,
+			void (*callback)(void *arg, u8 *cqe,
+					 int status), void *arg);
+extern void
+efct_hw_reqtag_free(struct efct_hw *hw, struct hw_wq_callback *wqcb);
+extern struct hw_wq_callback
+*efct_hw_reqtag_get_instance(struct efct_hw *hw, u32 instance_index);
+void efct_hw_reqtag_reset(struct efct_hw *hw);
 
 #endif /* __EFCT_H__ */
-- 
2.13.7

