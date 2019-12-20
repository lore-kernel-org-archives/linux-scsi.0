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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4614AC2D0C8
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4C172082E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:38:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tm2w5wwT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfLTWiL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:38:11 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36840 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfLTWiH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:38:07 -0500
Received: by mail-pf1-f196.google.com with SMTP id x184so6007161pfb.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/7rLC3z+hvmbi/6HCDw+bCWxsPOKE3kw8WUbUd2h4W0=;
        b=tm2w5wwT+jqpAwf2Wj1Z2PVztqotRlEwBeDuIqdZDKWgjFTKL3n+x/UoBL7SzwDcit
         wj/rc1Xh3UZ0oXkH8/XCWonm+awTdVdQV354I5OK2NTSWsmq/mfefx9rvMWCIYamgGbP
         z1aaoMSw/0PsEbY5hjwMDtTTZ8glxL1c40H7wGgoeQ4dw9hXgUjeY7j24s5aUD/tO90h
         cev4Re1Y+i3P76vAHIkkANPMaHJ8RjsT39UZhpTR7FlRs0jcFHDPzZLNdoBuaYp2g9Z3
         khSZxjo1k8N+zi2ylpIrn1TePExl0YxRYZchuidGmmlraNBJy5r70k+VEw4XQpUz1H6h
         5wqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/7rLC3z+hvmbi/6HCDw+bCWxsPOKE3kw8WUbUd2h4W0=;
        b=QsyqtRnFoJU/lYug65S2r/YtzhNxYHES04cPQWnQnizYl+BuxqjYcO0rhYT9CJ/9yJ
         DyEKIbHvEL3fZbYE4aWJzqyEY0Z//FlxUIwh8924BWf2JhWvulWgW/9vddlU72HN1PEo
         l9xgDwAiIkSqc/9K9w/he8xABU5jMYYXWOQ4oN6a1plZlj9PoE/7Dxo+5tJz14tzgGDs
         xR0NL6I0UdkGd+Reek2wnCS5zFXbsjWSMIYvoWGKv01GNgtpDrjnvtRCNx4gTYpPzEm/
         A/8rpevJ6PNjj1SQN1BKQFwDC2Gzaq37p0P5r6KGy87dcNyHcAgjmCrlplKfVRKiYWyp
         FtOw==
X-Gm-Message-State: APjAAAWiaV6l2XCy9eZMYpZJ+rCW77JiD8FW1XavuFx8QhPysMkyElmi
        s/4OYasL38irH4ZGjgqIlY47CXL0
X-Google-Smtp-Source: APXvYqxpgawkFWhqjsx6z5s2GM1z9ST6+YgbXw0ONX3QtMBTxyzhOj1yJHLTV4cucNrNf2UClob28g==
X-Received: by 2002:a63:8c48:: with SMTP id q8mr18004681pgn.213.1576881485000;
        Fri, 20 Dec 2019 14:38:05 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.38.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:38:04 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 29/32] elx: efct: Firmware update, async link processing
Date:   Fri, 20 Dec 2019 14:37:20 -0800
Message-Id: <20191220223723.26563-30-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191220223723.26563-1-jsmart2021@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Handling of async link event.
Registrations for VFI, VPI and RPI.
Add Firmware update helper routines.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_hw.c | 1633 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h |   57 +-
 2 files changed, 1689 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index c18bda1351cc..23d55d0d26c3 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -48,6 +48,12 @@ struct efct_hw_host_stat_cb_arg {
 	void *arg;
 };
 
+struct efct_hw_fw_wr_cb_arg {
+	void (*cb)(int status, u32 bytes_written,
+		   u32 change_status, void *arg);
+	void *arg;
+};
+
 /* HW global data */
 struct efct_hw_global hw_global;
 
@@ -180,6 +186,175 @@ efct_hw_read_max_dump_size(struct efct_hw *hw)
 	return EFCT_HW_RTN_SUCCESS;
 }
 
+static int
+__efct_read_topology_cb(struct efct_hw *hw, int status,
+			u8 *mqe, void *arg)
+{
+	struct sli4_cmd_read_topology *read_topo =
+				(struct sli4_cmd_read_topology *)mqe;
+	u8 speed;
+	struct efc_domain_record drec = {0};
+	struct efct *efct = hw->os;
+
+	if (status || le16_to_cpu(read_topo->hdr.status)) {
+		efc_log_debug(hw->os, "bad status cqe=%#x mqe=%#x\n",
+			       status,
+			       le16_to_cpu(read_topo->hdr.status));
+		kfree(mqe);
+		return -1;
+	}
+
+	switch (le32_to_cpu(read_topo->dw2_attentype) &
+		SLI4_READTOPO_ATTEN_TYPE) {
+	case SLI4_READ_TOPOLOGY_LINK_UP:
+		hw->link.status = SLI_LINK_STATUS_UP;
+		break;
+	case SLI4_READ_TOPOLOGY_LINK_DOWN:
+		hw->link.status = SLI_LINK_STATUS_DOWN;
+		break;
+	case SLI4_READ_TOPOLOGY_LINK_NO_ALPA:
+		hw->link.status = SLI_LINK_STATUS_NO_ALPA;
+		break;
+	default:
+		hw->link.status = SLI_LINK_STATUS_MAX;
+		break;
+	}
+
+	switch (read_topo->topology) {
+	case SLI4_READ_TOPOLOGY_NPORT:
+		hw->link.topology = SLI_LINK_TOPO_NPORT;
+		break;
+	case SLI4_READ_TOPOLOGY_FC_AL:
+		hw->link.topology = SLI_LINK_TOPO_LOOP;
+		if (hw->link.status == SLI_LINK_STATUS_UP)
+			hw->link.loop_map = hw->loop_map.virt;
+		hw->link.fc_id = read_topo->acquired_al_pa;
+		break;
+	default:
+		hw->link.topology = SLI_LINK_TOPO_MAX;
+		break;
+	}
+
+	hw->link.medium = SLI_LINK_MEDIUM_FC;
+
+	speed = (le32_to_cpu(read_topo->currlink_state) &
+		 SLI4_READTOPO_LINKSTATE_SPEED) >> 8;
+	switch (speed) {
+	case SLI4_READ_TOPOLOGY_SPEED_1G:
+		hw->link.speed =  1 * 1000;
+		break;
+	case SLI4_READ_TOPOLOGY_SPEED_2G:
+		hw->link.speed =  2 * 1000;
+		break;
+	case SLI4_READ_TOPOLOGY_SPEED_4G:
+		hw->link.speed =  4 * 1000;
+		break;
+	case SLI4_READ_TOPOLOGY_SPEED_8G:
+		hw->link.speed =  8 * 1000;
+		break;
+	case SLI4_READ_TOPOLOGY_SPEED_16G:
+		hw->link.speed = 16 * 1000;
+		hw->link.loop_map = NULL;
+		break;
+	case SLI4_READ_TOPOLOGY_SPEED_32G:
+		hw->link.speed = 32 * 1000;
+		hw->link.loop_map = NULL;
+		break;
+	}
+
+	kfree(mqe);
+
+	drec.speed = hw->link.speed;
+	drec.fc_id = hw->link.fc_id;
+	drec.is_nport = true;
+	efc_domain_cb(efct->efcport, EFC_HW_DOMAIN_FOUND, &drec);
+
+	return 0;
+}
+
+/* Callback function for the SLI link events */
+static int
+efct_hw_cb_link(void *ctx, void *e)
+{
+	struct efct_hw	*hw = ctx;
+	struct sli4_link_event *event = e;
+	struct efc_domain	*d = NULL;
+	int		rc = EFCT_HW_RTN_ERROR;
+	struct efct	*efct = hw->os;
+	struct efc_dma *dma;
+
+	efct_hw_link_event_init(hw);
+
+	switch (event->status) {
+	case SLI_LINK_STATUS_UP:
+
+		hw->link = *event;
+		efct->efcport->link_status = EFC_LINK_STATUS_UP;
+
+		if (event->topology == SLI_LINK_TOPO_NPORT) {
+			struct efc_domain_record drec = {0};
+
+			efc_log_info(hw->os, "Link Up, NPORT, speed is %d\n",
+				      event->speed);
+			drec.speed = event->speed;
+			drec.fc_id = event->fc_id;
+			drec.is_nport = true;
+			efc_domain_cb(efct->efcport, EFC_HW_DOMAIN_FOUND,
+				      &drec);
+		} else if (event->topology == SLI_LINK_TOPO_LOOP) {
+			u8	*buf = NULL;
+
+			efc_log_info(hw->os, "Link Up, LOOP, speed is %d\n",
+				      event->speed);
+			dma = &hw->loop_map;
+			dma->size = SLI4_MIN_LOOP_MAP_BYTES;
+			dma->virt = dma_alloc_coherent(&efct->pcidev->dev,
+						       dma->size, &dma->phys,
+						       GFP_DMA);
+			if (!dma->virt)
+				efc_log_err(hw->os, "efct_dma_alloc_fail\n");
+
+			buf = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+			if (!buf)
+				break;
+
+			if (!sli_cmd_read_topology(&hw->sli, buf,
+						  SLI4_BMBX_SIZE,
+						       &hw->loop_map)) {
+				rc = efct_hw_command(hw, buf, EFCT_CMD_NOWAIT,
+						     __efct_read_topology_cb,
+						     NULL);
+			}
+
+			if (rc != EFCT_HW_RTN_SUCCESS) {
+				efc_log_test(hw->os, "READ_TOPOLOGY failed\n");
+				kfree(buf);
+			}
+		} else {
+			efc_log_info(hw->os, "%s(%#x), speed is %d\n",
+				      "Link Up, unsupported topology ",
+				     event->topology, event->speed);
+		}
+		break;
+	case SLI_LINK_STATUS_DOWN:
+		efc_log_info(hw->os, "Link down\n");
+
+		hw->link.status = event->status;
+		efct->efcport->link_status = EFC_LINK_STATUS_DOWN;
+
+		d = hw->domain;
+		if (d)
+			efc_domain_cb(efct->efcport, EFC_HW_DOMAIN_LOST, d);
+		break;
+	default:
+		efc_log_test(hw->os, "unhandled link status %#x\n",
+			      event->status);
+		break;
+	}
+
+	return 0;
+}
+
 enum efct_hw_rtn
 efct_hw_setup(struct efct_hw *hw, void *os, struct pci_dev *pdev)
 {
@@ -5107,3 +5282,1461 @@ efct_hw_async_call(struct efct_hw *hw,
 	}
 	return rc;
 }
+
+static void
+efct_hw_port_free_resources(struct efc_sli_port *sport, int evt, void *data)
+{
+	struct efct_hw *hw = sport->hw;
+	struct efct *efct = hw->os;
+
+	/* Clear the sport attached flag */
+	sport->attached = false;
+
+	/* Free the service parameters buffer */
+	if (sport->dma.virt) {
+		dma_free_coherent(&efct->pcidev->dev,
+				  sport->dma.size, sport->dma.virt,
+				  sport->dma.phys);
+		memset(&sport->dma, 0, sizeof(struct efc_dma));
+	}
+
+	/* Free the command buffer */
+	kfree(data);
+
+	/* Free the SLI resources */
+	sli_resource_free(&hw->sli, SLI_RSRC_VPI, sport->indicator);
+
+	efc_lport_cb(efct->efcport, evt, sport);
+}
+
+static int
+efct_hw_port_get_mbox_status(struct efc_sli_port *sport,
+			     u8 *mqe, int status)
+{
+	struct efct_hw *hw = sport->hw;
+	struct sli4_mbox_command_header *hdr =
+			(struct sli4_mbox_command_header *)mqe;
+	int rc = 0;
+
+	if (status || le16_to_cpu(hdr->status)) {
+		efc_log_debug(hw->os, "bad status vpi=%#x st=%x hdr=%x\n",
+			       sport->indicator, status,
+			       le16_to_cpu(hdr->status));
+		rc = -1;
+	}
+
+	return rc;
+}
+
+static int
+efct_hw_port_free_unreg_vpi_cb(struct efct_hw *hw,
+			       int status, u8 *mqe, void *arg)
+{
+	struct efc_sli_port *sport = arg;
+	int evt = EFC_HW_PORT_FREE_OK;
+	int rc = 0;
+
+	rc = efct_hw_port_get_mbox_status(sport, mqe, status);
+	if (rc) {
+		evt = EFC_HW_PORT_FREE_FAIL;
+		rc = -1;
+	}
+
+	efct_hw_port_free_resources(sport, evt, mqe);
+	return rc;
+}
+
+static void
+efct_hw_port_free_unreg_vpi(struct efc_sli_port *sport, void *data)
+{
+	struct efct_hw *hw = sport->hw;
+	int rc;
+
+	/* Allocate memory and send unreg_vpi */
+	if (!data) {
+		data = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+		if (!data) {
+			efct_hw_port_free_resources(sport,
+						    EFC_HW_PORT_FREE_FAIL,
+						    data);
+			return;
+		}
+		memset(data, 0, SLI4_BMBX_SIZE);
+	}
+
+	rc = sli_cmd_unreg_vpi(&hw->sli, data, SLI4_BMBX_SIZE,
+			       sport->indicator, SLI4_UNREG_TYPE_PORT);
+	if (rc) {
+		efc_log_err(hw->os, "UNREG_VPI format failure\n");
+		efct_hw_port_free_resources(sport,
+					    EFC_HW_PORT_FREE_FAIL, data);
+		return;
+	}
+
+	rc = efct_hw_command(hw, data, EFCT_CMD_NOWAIT,
+			     efct_hw_port_free_unreg_vpi_cb, sport);
+	if (rc) {
+		efc_log_err(hw->os, "UNREG_VPI command failure\n");
+		efct_hw_port_free_resources(sport,
+					    EFC_HW_PORT_FREE_FAIL, data);
+	}
+}
+
+static void
+efct_hw_port_send_evt(struct efc_sli_port *sport, int evt, void *data)
+{
+	struct efct_hw *hw = sport->hw;
+	struct efct *efct = hw->os;
+
+	/* Free the mbox buffer */
+	kfree(data);
+
+	/* Now inform the registered callbacks */
+	efc_lport_cb(efct->efcport, evt, sport);
+
+	/* Set the sport attached flag */
+	if (evt == EFC_HW_PORT_ATTACH_OK)
+		sport->attached = true;
+
+	/* If there is a pending free request, then handle it now */
+	if (sport->free_req_pending)
+		efct_hw_port_free_unreg_vpi(sport, NULL);
+}
+
+static int
+efct_hw_port_alloc_init_vpi_cb(struct efct_hw *hw,
+			       int status, u8 *mqe, void *arg)
+{
+	struct efc_sli_port *sport = arg;
+	int rc;
+
+	rc = efct_hw_port_get_mbox_status(sport, mqe, status);
+	if (rc) {
+		efct_hw_port_free_resources(sport,
+					    EFC_HW_PORT_ALLOC_FAIL, mqe);
+		return -1;
+	}
+
+	efct_hw_port_send_evt(sport, EFC_HW_PORT_ALLOC_OK, mqe);
+	return 0;
+}
+
+static void
+efct_hw_port_alloc_init_vpi(struct efc_sli_port *sport, void *data)
+{
+	struct efct_hw *hw = sport->hw;
+	int rc;
+
+	/* If there is a pending free request, then handle it now */
+	if (sport->free_req_pending) {
+		efct_hw_port_free_resources(sport, EFC_HW_PORT_FREE_OK, data);
+		return;
+	}
+
+	rc = sli_cmd_init_vpi(&hw->sli, data, SLI4_BMBX_SIZE,
+			      sport->indicator, sport->domain->indicator);
+	if (rc) {
+		efc_log_err(hw->os, "INIT_VPI format failure\n");
+		efct_hw_port_free_resources(sport,
+					    EFC_HW_PORT_ALLOC_FAIL, data);
+		return;
+	}
+
+	rc = efct_hw_command(hw, data, EFCT_CMD_NOWAIT,
+			     efct_hw_port_alloc_init_vpi_cb, sport);
+	if (rc) {
+		efc_log_err(hw->os, "INIT_VPI command failure\n");
+		efct_hw_port_free_resources(sport,
+					    EFC_HW_PORT_ALLOC_FAIL, data);
+	}
+}
+
+static int
+efct_hw_port_alloc_read_sparm64_cb(struct efct_hw *hw,
+				   int status, u8 *mqe, void *arg)
+{
+	struct efc_sli_port *sport = arg;
+	u8 *payload = NULL;
+	struct efct *efct = hw->os;
+	int rc;
+
+	rc = efct_hw_port_get_mbox_status(sport, mqe, status);
+	if (rc) {
+		efct_hw_port_free_resources(sport,
+					    EFC_HW_PORT_ALLOC_FAIL, mqe);
+		return -1;
+	}
+
+	payload = sport->dma.virt;
+
+	memcpy(&sport->sli_wwpn,
+	       payload + SLI4_READ_SPARM64_WWPN_OFFSET,
+		sizeof(sport->sli_wwpn));
+	memcpy(&sport->sli_wwnn,
+	       payload + SLI4_READ_SPARM64_WWNN_OFFSET,
+		sizeof(sport->sli_wwnn));
+
+	dma_free_coherent(&efct->pcidev->dev,
+			  sport->dma.size, sport->dma.virt, sport->dma.phys);
+	memset(&sport->dma, 0, sizeof(struct efc_dma));
+	efct_hw_port_alloc_init_vpi(sport, mqe);
+	return 0;
+}
+
+static void
+efct_hw_port_alloc_read_sparm64(struct efc_sli_port *sport, void *data)
+{
+	struct efct_hw *hw = sport->hw;
+	struct efct *efct = hw->os;
+	int rc;
+
+	/* Allocate memory for the service parameters */
+	sport->dma.size = 112;
+	sport->dma.virt = dma_alloc_coherent(&efct->pcidev->dev,
+					     sport->dma.size, &sport->dma.phys,
+					     GFP_DMA);
+	if (!sport->dma.virt) {
+		efc_log_err(hw->os, "Failed to allocate DMA memory\n");
+		efct_hw_port_free_resources(sport,
+					    EFC_HW_PORT_ALLOC_FAIL, data);
+		return;
+	}
+
+	rc = sli_cmd_read_sparm64(&hw->sli, data, SLI4_BMBX_SIZE,
+				  &sport->dma, sport->indicator);
+	if (rc) {
+		efc_log_err(hw->os, "READ_SPARM64 format failure\n");
+		efct_hw_port_free_resources(sport,
+					    EFC_HW_PORT_ALLOC_FAIL, data);
+		return;
+	}
+
+	rc = efct_hw_command(hw, data, EFCT_CMD_NOWAIT,
+			     efct_hw_port_alloc_read_sparm64_cb, sport);
+	if (rc) {
+		efc_log_err(hw->os, "READ_SPARM64 command failure\n");
+		efct_hw_port_free_resources(sport,
+					    EFC_HW_PORT_ALLOC_FAIL, data);
+	}
+}
+
+/*
+ * This function allocates a VPI object for the port and stores it in the
+ * indicator field of the port object.
+ */
+enum efct_hw_rtn
+efct_hw_port_alloc(struct efc *efc, struct efc_sli_port *sport,
+		   struct efc_domain *domain, u8 *wwpn)
+{
+	struct efct *efct = efc->base;
+	struct efct_hw *hw = &efct->hw;
+
+	u8	*cmd = NULL;
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+	u32 index;
+
+	sport->indicator = U32_MAX;
+	sport->hw = hw;
+	sport->free_req_pending = false;
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(&hw->sli) > 0) {
+		efc_log_crit(hw->os,
+			      "Chip is in an error state - reset needed\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (wwpn)
+		memcpy(&sport->sli_wwpn, wwpn, sizeof(sport->sli_wwpn));
+
+	if (sli_resource_alloc(&hw->sli, SLI_RSRC_VPI,
+			       &sport->indicator, &index)) {
+		efc_log_err(hw->os, "VPI allocation failure\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (domain) {
+		cmd = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+		if (!cmd) {
+			rc = EFCT_HW_RTN_NO_MEMORY;
+			goto efct_hw_port_alloc_out;
+		}
+		memset(cmd, 0, SLI4_BMBX_SIZE);
+
+		/*
+		 * If the WWPN is NULL, fetch the default
+		 * WWPN and WWNN before initializing the VPI
+		 */
+		if (!wwpn)
+			efct_hw_port_alloc_read_sparm64(sport, cmd);
+		else
+			efct_hw_port_alloc_init_vpi(sport, cmd);
+	} else if (!wwpn) {
+		/* This is the convention for the HW, not SLI */
+		efc_log_test(hw->os, "need WWN for physical port\n");
+		rc = EFCT_HW_RTN_ERROR;
+	}
+	/* domain NULL and wwpn non-NULL */
+	// no-op;
+
+efct_hw_port_alloc_out:
+	if (rc != EFCT_HW_RTN_SUCCESS) {
+		kfree(cmd);
+
+		sli_resource_free(&hw->sli, SLI_RSRC_VPI,
+				  sport->indicator);
+	}
+
+	return rc;
+}
+
+static int
+efct_hw_port_attach_reg_vpi_cb(struct efct_hw *hw,
+			       int status, u8 *mqe, void *arg)
+{
+	struct efc_sli_port *sport = arg;
+	int rc;
+
+	rc = efct_hw_port_get_mbox_status(sport, mqe, status);
+	if (rc) {
+		efct_hw_port_free_resources(sport,
+					    EFC_HW_PORT_ATTACH_FAIL, mqe);
+		return -1;
+	}
+
+	efct_hw_port_send_evt(sport, EFC_HW_PORT_ATTACH_OK, mqe);
+	return 0;
+}
+
+static void
+efct_hw_port_attach_reg_vpi(struct efc_sli_port *sport, void *data)
+{
+	struct efct_hw *hw = sport->hw;
+	int rc;
+
+	if (!sli_cmd_reg_vpi(&hw->sli, data, SLI4_BMBX_SIZE,
+			    sport->fc_id, sport->sli_wwpn,
+			sport->indicator, sport->domain->indicator,
+			false) == 0) {
+		efc_log_err(hw->os, "REG_VPI format failure\n");
+		efct_hw_port_free_resources(sport,
+					    EFC_HW_PORT_ATTACH_FAIL, data);
+		return;
+	}
+
+	rc = efct_hw_command(hw, data, EFCT_CMD_NOWAIT,
+			     efct_hw_port_attach_reg_vpi_cb, sport);
+	if (rc) {
+		efc_log_err(hw->os, "REG_VPI command failure\n");
+		efct_hw_port_free_resources(sport,
+					    EFC_HW_PORT_ATTACH_FAIL, data);
+	}
+}
+
+/**
+ * This function registers a previously-allocated VPI with the
+ * device.
+ */
+enum efct_hw_rtn
+efct_hw_port_attach(struct efc *efc, struct efc_sli_port *sport,
+		    u32 fc_id)
+{
+	struct efct *efct = efc->base;
+	struct efct_hw *hw = &efct->hw;
+
+	u8	*buf = NULL;
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+
+	if (!sport) {
+		efc_log_err(hw->os,
+			     "bad parameter(s) hw=%p sport=%p\n", hw,
+			sport);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(&hw->sli) > 0) {
+		efc_log_crit(hw->os,
+			      "Chip is in an error state - reset needed\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	buf = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+	if (!buf)
+		return EFCT_HW_RTN_NO_MEMORY;
+
+	memset(buf, 0, SLI4_BMBX_SIZE);
+	sport->fc_id = fc_id;
+	efct_hw_port_attach_reg_vpi(sport, buf);
+	return rc;
+}
+
+/* Issue the UNREG_VPI command to free the assigned VPI context */
+enum efct_hw_rtn
+efct_hw_port_free(struct efc *efc, struct efc_sli_port *sport)
+{
+	struct efct *efct = efc->base;
+	struct efct_hw *hw = &efct->hw;
+
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+
+	if (!sport) {
+		efc_log_err(hw->os,
+			     "bad parameter(s) hw=%p sport=%p\n", hw,
+			sport);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(&hw->sli) > 0) {
+		efc_log_crit(hw->os,
+			      "Chip is in an error state - reset needed\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (sport->attached)
+		efct_hw_port_free_unreg_vpi(sport, NULL);
+	else
+		sport->free_req_pending = true;
+
+	return rc;
+}
+
+static int
+efct_hw_domain_get_mbox_status(struct efc_domain *domain,
+			       u8 *mqe, int status)
+{
+	struct efct_hw *hw = domain->hw;
+	struct sli4_mbox_command_header *hdr =
+			(struct sli4_mbox_command_header *)mqe;
+	int rc = 0;
+
+	if (status || le16_to_cpu(hdr->status)) {
+		efc_log_debug(hw->os, "bad status vfi=%#x st=%x hdr=%x\n",
+			       domain->indicator, status,
+			       le16_to_cpu(hdr->status));
+		rc = -1;
+	}
+
+	return rc;
+}
+
+static void
+efct_hw_domain_free_resources(struct efc_domain *domain,
+			      int evt, void *data)
+{
+	struct efct_hw *hw = domain->hw;
+	struct efct *efct = hw->os;
+
+	/* Free the service parameters buffer */
+	if (domain->dma.virt) {
+		dma_free_coherent(&efct->pcidev->dev,
+				  domain->dma.size, domain->dma.virt,
+				  domain->dma.phys);
+		memset(&domain->dma, 0, sizeof(struct efc_dma));
+	}
+
+	/* Free the command buffer */
+	kfree(data);
+
+	/* Free the SLI resources */
+	sli_resource_free(&hw->sli, SLI_RSRC_VFI, domain->indicator);
+
+	efc_domain_cb(efct->efcport, evt, domain);
+}
+
+static void
+efct_hw_domain_send_sport_evt(struct efc_domain *domain,
+			      int port_evt, int domain_evt, void *data)
+{
+	struct efct_hw *hw = domain->hw;
+	struct efct *efct = hw->os;
+
+	/* Free the mbox buffer */
+	kfree(data);
+
+	/* Send alloc/attach ok to the physical sport */
+	efct_hw_port_send_evt(domain->sport, port_evt, NULL);
+
+	/* Now inform the registered callbacks */
+	efc_domain_cb(efct->efcport, domain_evt, domain);
+}
+
+static int
+efct_hw_domain_alloc_read_sparm64_cb(struct efct_hw *hw,
+				     int status, u8 *mqe, void *arg)
+{
+	struct efc_domain *domain = arg;
+	int rc;
+
+	rc = efct_hw_domain_get_mbox_status(domain, mqe, status);
+	if (rc) {
+		efct_hw_domain_free_resources(domain,
+					      EFC_HW_DOMAIN_ALLOC_FAIL, mqe);
+		return -1;
+	}
+
+	hw->domain = domain;
+	efct_hw_domain_send_sport_evt(domain, EFC_HW_PORT_ALLOC_OK,
+				      EFC_HW_DOMAIN_ALLOC_OK, mqe);
+	return 0;
+}
+
+static void
+efct_hw_domain_alloc_read_sparm64(struct efc_domain *domain, void *data)
+{
+	struct efct_hw *hw = domain->hw;
+	int rc;
+
+	rc = sli_cmd_read_sparm64(&hw->sli, data, SLI4_BMBX_SIZE,
+				  &domain->dma, SLI4_READ_SPARM64_VPI_DEFAULT);
+	if (rc) {
+		efc_log_err(hw->os, "READ_SPARM64 format failure\n");
+		efct_hw_domain_free_resources(domain,
+					      EFC_HW_DOMAIN_ALLOC_FAIL, data);
+		return;
+	}
+
+	rc = efct_hw_command(hw, data, EFCT_CMD_NOWAIT,
+			     efct_hw_domain_alloc_read_sparm64_cb, domain);
+	if (rc) {
+		efc_log_err(hw->os, "READ_SPARM64 command failure\n");
+		efct_hw_domain_free_resources(domain,
+					      EFC_HW_DOMAIN_ALLOC_FAIL, data);
+	}
+}
+
+static int
+efct_hw_domain_alloc_init_vfi_cb(struct efct_hw *hw,
+				 int status, u8 *mqe, void *arg)
+{
+	struct efc_domain *domain = arg;
+	int rc;
+
+	rc = efct_hw_domain_get_mbox_status(domain, mqe, status);
+	if (rc) {
+		efct_hw_domain_free_resources(domain,
+					      EFC_HW_DOMAIN_ALLOC_FAIL, mqe);
+		return -1;
+	}
+
+	efct_hw_domain_alloc_read_sparm64(domain, mqe);
+	return 0;
+}
+
+static void
+efct_hw_domain_alloc_init_vfi(struct efc_domain *domain, void *data)
+{
+	struct efct_hw *hw = domain->hw;
+	struct efc_sli_port *sport = domain->sport;
+	int rc;
+
+	/*
+	 * For FC, the HW alread registered an FCFI.
+	 * Copy FCF information into the domain and jump to INIT_VFI.
+	 */
+	domain->fcf_indicator = hw->fcf_indicator;
+	rc = sli_cmd_init_vfi(&hw->sli, data, SLI4_BMBX_SIZE,
+			      domain->indicator, domain->fcf_indicator,
+			sport->indicator);
+	if (rc) {
+		efc_log_err(hw->os, "INIT_VFI format failure\n");
+		efct_hw_domain_free_resources(domain,
+					      EFC_HW_DOMAIN_ALLOC_FAIL, data);
+		return;
+	}
+
+	rc = efct_hw_command(hw, data, EFCT_CMD_NOWAIT,
+			     efct_hw_domain_alloc_init_vfi_cb, domain);
+	if (rc) {
+		efc_log_err(hw->os, "INIT_VFI command failure\n");
+		efct_hw_domain_free_resources(domain,
+					      EFC_HW_DOMAIN_ALLOC_FAIL, data);
+	}
+}
+
+/**
+ * This function starts a series of commands needed to connect to the domain,
+ * including
+ *   - REG_FCFI
+ *   - INIT_VFI
+ *   - READ_SPARMS
+ */
+enum efct_hw_rtn
+efct_hw_domain_alloc(struct efc *efc, struct efc_domain *domain,
+		     u32 fcf)
+{
+	struct efct *efct = efc->base;
+	struct efct_hw *hw = &efct->hw;
+	u8 *cmd = NULL;
+	u32 index;
+
+	if (!domain || !domain->sport) {
+		efc_log_err(efct,
+			     "bad parameter(s) hw=%p domain=%p sport=%p\n",
+			    hw, domain, domain ? domain->sport : NULL);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(&hw->sli) > 0) {
+		efc_log_crit(efct,
+			     "Chip is in an error state - reset needed\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	cmd = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+	if (!cmd)
+		return EFCT_HW_RTN_NO_MEMORY;
+
+	memset(cmd, 0, SLI4_BMBX_SIZE);
+
+	/* allocate memory for the service parameters */
+	domain->dma.size = 112;
+	domain->dma.virt = dma_alloc_coherent(&efct->pcidev->dev,
+					      domain->dma.size,
+					      &domain->dma.phys, GFP_DMA);
+	if (!domain->dma.virt) {
+		efc_log_err(hw->os, "Failed to allocate DMA memory\n");
+		kfree(cmd);
+		return EFCT_HW_RTN_NO_MEMORY;
+	}
+
+	domain->hw = hw;
+	domain->fcf = fcf;
+	domain->fcf_indicator = U32_MAX;
+	domain->indicator = U32_MAX;
+
+	if (sli_resource_alloc(&hw->sli,
+			       SLI_RSRC_VFI, &domain->indicator,
+				    &index)) {
+		efc_log_err(hw->os, "VFI allocation failure\n");
+
+		kfree(cmd);
+		dma_free_coherent(&efct->pcidev->dev,
+				  domain->dma.size, domain->dma.virt,
+				  domain->dma.phys);
+		memset(&domain->dma, 0, sizeof(struct efc_dma));
+
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	efct_hw_domain_alloc_init_vfi(domain, cmd);
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+static int
+efct_hw_domain_attach_reg_vfi_cb(struct efct_hw *hw,
+				 int status, u8 *mqe, void *arg)
+{
+	struct efc_domain *domain = arg;
+	int rc;
+
+	rc = efct_hw_domain_get_mbox_status(domain, mqe, status);
+	if (rc) {
+		hw->domain = NULL;
+		efct_hw_domain_free_resources(domain,
+					      EFC_HW_DOMAIN_ATTACH_FAIL, mqe);
+		return -1;
+	}
+
+	efct_hw_domain_send_sport_evt(domain, EFC_HW_PORT_ATTACH_OK,
+				      EFC_HW_DOMAIN_ATTACH_OK, mqe);
+	return 0;
+}
+
+static void
+efct_hw_domain_attach_reg_vfi(struct efc_domain *domain, void *data)
+{
+	struct efct_hw *hw = domain->hw;
+	int rc;
+
+	if (!sli_cmd_reg_vfi(&hw->sli, data, SLI4_BMBX_SIZE,
+			    domain->indicator, domain->fcf_indicator,
+			domain->dma, domain->sport->indicator,
+			domain->sport->sli_wwpn,
+			domain->sport->fc_id) == 0) {
+		efc_log_err(hw->os, "REG_VFI format failure\n");
+		goto cleanup;
+	}
+
+	rc = efct_hw_command(hw, data, EFCT_CMD_NOWAIT,
+			     efct_hw_domain_attach_reg_vfi_cb, domain);
+	if (rc) {
+		efc_log_err(hw->os, "REG_VFI command failure\n");
+		goto cleanup;
+	}
+
+	return;
+
+cleanup:
+	hw->domain = NULL;
+	efct_hw_domain_free_resources(domain,
+				      EFC_HW_DOMAIN_ATTACH_FAIL, data);
+}
+
+enum efct_hw_rtn
+efct_hw_domain_attach(struct efc *efc,
+		      struct efc_domain *domain, u32 fc_id)
+{
+	struct efct *efct = efc->base;
+	struct efct_hw *hw = &efct->hw;
+
+	u8	*buf = NULL;
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+
+	if (!domain) {
+		efc_log_err(hw->os,
+			     "bad parameter(s) hw=%p domain=%p\n",
+			hw, domain);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(&hw->sli) > 0) {
+		efc_log_crit(hw->os,
+			      "Chip is in an error state - reset needed\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	buf = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+	if (!buf)
+		return EFCT_HW_RTN_NO_MEMORY;
+
+	memset(buf, 0, SLI4_BMBX_SIZE);
+	domain->sport->fc_id = fc_id;
+	efct_hw_domain_attach_reg_vfi(domain, buf);
+	return rc;
+}
+
+static int
+efct_hw_domain_free_unreg_vfi_cb(struct efct_hw *hw,
+				 int status, u8 *mqe, void *arg)
+{
+	struct efc_domain *domain = arg;
+	int evt = EFC_HW_DOMAIN_FREE_OK;
+	int rc = 0;
+
+	rc = efct_hw_domain_get_mbox_status(domain, mqe, status);
+	if (rc) {
+		evt = EFC_HW_DOMAIN_FREE_FAIL;
+		rc = -1;
+	}
+
+	hw->domain = NULL;
+	efct_hw_domain_free_resources(domain, evt, mqe);
+	return rc;
+}
+
+static void
+efct_hw_domain_free_unreg_vfi(struct efc_domain *domain, void *data)
+{
+	struct efct_hw *hw = domain->hw;
+	int rc;
+
+	if (!data) {
+		data = kzalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+		if (!data)
+			goto cleanup;
+	}
+
+	rc = sli_cmd_unreg_vfi(&hw->sli, data, SLI4_BMBX_SIZE,
+			       domain->indicator, SLI4_UNREG_TYPE_DOMAIN);
+	if (rc) {
+		efc_log_err(hw->os, "UNREG_VFI format failure\n");
+		goto cleanup;
+	}
+
+	rc = efct_hw_command(hw, data, EFCT_CMD_NOWAIT,
+			     efct_hw_domain_free_unreg_vfi_cb, domain);
+	if (rc) {
+		efc_log_err(hw->os, "UNREG_VFI command failure\n");
+		goto cleanup;
+	}
+
+	return;
+
+cleanup:
+	hw->domain = NULL;
+	efct_hw_domain_free_resources(domain, EFC_HW_DOMAIN_FREE_FAIL, data);
+}
+
+enum efct_hw_rtn
+efct_hw_domain_free(struct efc *efc, struct efc_domain *domain)
+{
+	struct efct *efct = efc->base;
+	struct efct_hw *hw = &efct->hw;
+
+	enum efct_hw_rtn	rc = EFCT_HW_RTN_SUCCESS;
+
+	if (!domain) {
+		efc_log_err(hw->os,
+			     "bad parameter(s) hw=%p domain=%p\n",
+			hw, domain);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(&hw->sli) > 0) {
+		efc_log_crit(hw->os,
+			      "Chip is in an error state - reset needed\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	efct_hw_domain_free_unreg_vfi(domain, NULL);
+	return rc;
+}
+
+enum efct_hw_rtn
+efct_hw_domain_force_free(struct efc *efc, struct efc_domain *domain)
+{
+	struct efct *efct = efc->base;
+	struct efct_hw *hw = &efct->hw;
+
+	if (!domain) {
+		efc_log_err(efct,
+			     "bad parameter(s) hw=%p domain=%p\n", hw, domain);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	dma_free_coherent(&efct->pcidev->dev,
+			  domain->dma.size, domain->dma.virt, domain->dma.phys);
+	memset(&domain->dma, 0, sizeof(struct efc_dma));
+	sli_resource_free(&hw->sli, SLI_RSRC_VFI,
+			  domain->indicator);
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+enum efct_hw_rtn
+efct_hw_node_alloc(struct efc *efc, struct efc_remote_node *rnode,
+		   u32 fc_addr, struct efc_sli_port *sport)
+{
+	struct efct *efct = efc->base;
+	struct efct_hw *hw = &efct->hw;
+
+	/* Check for invalid indicator */
+	if (rnode->indicator != U32_MAX) {
+		efc_log_err(hw->os,
+			     "RPI allocation failure addr=%#x rpi=%#x\n",
+			    fc_addr, rnode->indicator);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(&hw->sli) > 0) {
+		efc_log_crit(hw->os,
+			      "Chip is in an error state - reset needed\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/* NULL SLI port indicates an unallocated remote node */
+	rnode->sport = NULL;
+
+	if (sli_resource_alloc(&hw->sli, SLI_RSRC_RPI,
+			       &rnode->indicator, &rnode->index)) {
+		efc_log_err(hw->os, "RPI allocation failure addr=%#x\n",
+			     fc_addr);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	rnode->fc_id = fc_addr;
+	rnode->sport = sport;
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+static int
+efct_hw_cb_node_attach(struct efct_hw *hw, int status,
+		       u8 *mqe, void *arg)
+{
+	struct efc_remote_node *rnode = arg;
+	struct sli4_mbox_command_header *hdr =
+				(struct sli4_mbox_command_header *)mqe;
+	enum efc_hw_remote_node_event	evt = 0;
+
+	struct efct   *efct = hw->os;
+
+	if (status || le16_to_cpu(hdr->status)) {
+		efc_log_debug(hw->os, "bad status cqe=%#x mqe=%#x\n", status,
+			       le16_to_cpu(hdr->status));
+		atomic_sub_return(1, &hw->rpi_ref[rnode->index].rpi_count);
+		rnode->attached = false;
+		atomic_set(&hw->rpi_ref[rnode->index].rpi_attached, 0);
+		evt = EFC_HW_NODE_ATTACH_FAIL;
+	} else {
+		rnode->attached = true;
+		atomic_set(&hw->rpi_ref[rnode->index].rpi_attached, 1);
+		evt = EFC_HW_NODE_ATTACH_OK;
+	}
+
+	efc_remote_node_cb(efct->efcport, evt, rnode);
+
+	kfree(mqe);
+
+	return 0;
+}
+
+/* Update a remote node object with the remote port's service parameters */
+enum efct_hw_rtn
+efct_hw_node_attach(struct efc *efc, struct efc_remote_node *rnode,
+		    struct efc_dma *sparms)
+{
+	struct efct *efct = efc->base;
+	struct efct_hw *hw = &efct->hw;
+
+	enum efct_hw_rtn	rc = EFCT_HW_RTN_ERROR;
+	u8		*buf = NULL;
+	u32	count = 0;
+
+	if (!hw || !rnode || !sparms) {
+		efc_log_err(efct,
+			     "bad parameter(s) hw=%p rnode=%p sparms=%p\n",
+			    hw, rnode, sparms);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(&hw->sli) > 0) {
+		efc_log_crit(hw->os,
+			      "Chip is in an error state - reset needed\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	buf = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+	if (!buf)
+		return EFCT_HW_RTN_NO_MEMORY;
+
+	memset(buf, 0, SLI4_BMBX_SIZE);
+	/*
+	 * If the attach count is non-zero, this RPI has already been reg'd.
+	 * Otherwise, register the RPI
+	 */
+	if (rnode->index == U32_MAX) {
+		efc_log_err(efct, "bad parameter rnode->index invalid\n");
+		kfree(buf);
+		return EFCT_HW_RTN_ERROR;
+	}
+	count = atomic_add_return(1, &hw->rpi_ref[rnode->index].rpi_count);
+	count--;
+	if (count) {
+		/*
+		 * Can't attach multiple FC_ID's to a node unless High Login
+		 * Mode is enabled
+		 */
+		if (!hw->sli.high_login_mode) {
+			efc_log_test(hw->os,
+				      "attach to attached node HLM=%d cnt=%d\n",
+				     hw->sli.high_login_mode, count);
+			rc = EFCT_HW_RTN_SUCCESS;
+		} else {
+			rnode->node_group = true;
+			rnode->attached =
+			 atomic_read(&hw->rpi_ref[rnode->index].rpi_attached);
+			rc = rnode->attached  ? EFCT_HW_RTN_SUCCESS_SYNC :
+							 EFCT_HW_RTN_SUCCESS;
+		}
+	} else {
+		rnode->node_group = false;
+
+		if (!sli_cmd_reg_rpi(&hw->sli, buf, SLI4_BMBX_SIZE,
+				    rnode->fc_id,
+				    rnode->indicator, rnode->sport->indicator,
+				    sparms, 0, 0))
+			rc = efct_hw_command(hw, buf, EFCT_CMD_NOWAIT,
+					     efct_hw_cb_node_attach, rnode);
+	}
+
+	if (count || rc) {
+		if (rc < EFCT_HW_RTN_SUCCESS) {
+			atomic_sub_return(1,
+					  &hw->rpi_ref[rnode->index].rpi_count);
+			efc_log_err(hw->os,
+				     "%s error\n", count ? "HLM" : "REG_RPI");
+		}
+		kfree(buf);
+	}
+
+	return rc;
+}
+
+enum efct_hw_rtn
+efct_hw_node_free_resources(struct efc *efc,
+			    struct efc_remote_node *rnode)
+{
+	struct efct *efct = efc->base;
+	struct efct_hw *hw = &efct->hw;
+	enum efct_hw_rtn	rc = EFCT_HW_RTN_SUCCESS;
+
+	if (!hw || !rnode) {
+		efc_log_err(efct, "bad parameter(s) hw=%p rnode=%p\n",
+			     hw, rnode);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (rnode->sport) {
+		if (rnode->attached) {
+			efc_log_err(hw->os, "Err: rnode is still attached\n");
+			return EFCT_HW_RTN_ERROR;
+		}
+		if (rnode->indicator != U32_MAX) {
+			if (sli_resource_free(&hw->sli, SLI_RSRC_RPI,
+					      rnode->indicator)) {
+				efc_log_err(hw->os,
+					     "RPI free fail RPI %d addr=%#x\n",
+					    rnode->indicator,
+					    rnode->fc_id);
+				rc = EFCT_HW_RTN_ERROR;
+			} else {
+				rnode->node_group = false;
+				rnode->indicator = U32_MAX;
+				rnode->index = U32_MAX;
+				rnode->free_group = false;
+			}
+		}
+	}
+
+	return rc;
+}
+
+static int
+efct_hw_cb_node_free(struct efct_hw *hw,
+		     int status, u8 *mqe, void *arg)
+{
+	struct efc_remote_node *rnode = arg;
+	struct sli4_mbox_command_header *hdr =
+				(struct sli4_mbox_command_header *)mqe;
+	enum efc_hw_remote_node_event evt = EFC_HW_NODE_FREE_FAIL;
+	int		rc = 0;
+	struct efct   *efct = hw->os;
+
+	if (status || le16_to_cpu(hdr->status)) {
+		efc_log_debug(hw->os, "bad status cqe=%#x mqe=%#x\n", status,
+			       le16_to_cpu(hdr->status));
+
+		/*
+		 * In certain cases, a non-zero MQE status is OK (all must be
+		 * true):
+		 *   - node is attached
+		 *   - if High Login Mode is enabled, node is part of a node
+		 * group
+		 *   - status is 0x1400
+		 */
+		if (!rnode->attached ||
+		    (hw->sli.high_login_mode && !rnode->node_group) ||
+				(le16_to_cpu(hdr->status) !=
+				 MBX_STATUS_RPI_NOT_REG))
+			rc = -1;
+	}
+
+	if (rc == 0) {
+		rnode->node_group = false;
+		rnode->attached = false;
+
+		if (atomic_read(&hw->rpi_ref[rnode->index].rpi_count) == 0)
+			atomic_set(&hw->rpi_ref[rnode->index].rpi_attached,
+				   0);
+		 evt = EFC_HW_NODE_FREE_OK;
+	}
+
+	efc_remote_node_cb(efct->efcport, evt, rnode);
+
+	kfree(mqe);
+
+	return rc;
+}
+
+enum efct_hw_rtn
+efct_hw_node_detach(struct efc *efc, struct efc_remote_node *rnode)
+{
+	struct efct *efct = efc->base;
+	struct efct_hw *hw = &efct->hw;
+	u8	*buf = NULL;
+	enum efct_hw_rtn	rc = EFCT_HW_RTN_SUCCESS_SYNC;
+	u32	index = U32_MAX;
+
+	if (!hw || !rnode) {
+		efc_log_err(efct, "bad parameter(s) hw=%p rnode=%p\n",
+			     hw, rnode);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(&hw->sli) > 0) {
+		efc_log_crit(hw->os,
+			      "Chip is in an error state - reset needed\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	index = rnode->index;
+
+	if (rnode->sport) {
+		u32	count = 0;
+		u32	fc_id;
+
+		if (!rnode->attached)
+			return EFCT_HW_RTN_SUCCESS_SYNC;
+
+		buf = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+		if (!buf)
+			return EFCT_HW_RTN_NO_MEMORY;
+
+		memset(buf, 0, SLI4_BMBX_SIZE);
+		count = atomic_sub_return(1, &hw->rpi_ref[index].rpi_count);
+		count++;
+		if (count <= 1) {
+			/*
+			 * There are no other references to this RPI so
+			 * unregister it
+			 */
+			fc_id = U32_MAX;
+			/* and free the resource */
+			rnode->node_group = false;
+			rnode->free_group = true;
+		} else {
+			if (!hw->sli.high_login_mode)
+				efc_log_test(hw->os,
+					      "Inval cnt with HLM off, cnt=%d\n",
+					     count);
+			fc_id = rnode->fc_id & 0x00ffffff;
+		}
+
+		rc = EFCT_HW_RTN_ERROR;
+
+		if (!sli_cmd_unreg_rpi(&hw->sli, buf, SLI4_BMBX_SIZE,
+				      rnode->indicator,
+				      SLI_RSRC_RPI, fc_id))
+			rc = efct_hw_command(hw, buf, EFCT_CMD_NOWAIT,
+					     efct_hw_cb_node_free, rnode);
+
+		if (rc != EFCT_HW_RTN_SUCCESS) {
+			efc_log_err(hw->os, "UNREG_RPI failed\n");
+			kfree(buf);
+			rc = EFCT_HW_RTN_ERROR;
+		}
+	}
+
+	return rc;
+}
+
+static int
+efct_hw_cb_node_free_all(struct efct_hw *hw, int status, u8 *mqe,
+			 void *arg)
+{
+	struct sli4_mbox_command_header *hdr =
+				(struct sli4_mbox_command_header *)mqe;
+	enum efc_hw_remote_node_event evt = EFC_HW_NODE_FREE_FAIL;
+	int		rc = 0;
+	u32	i;
+	struct efct   *efct = hw->os;
+
+	if (status || le16_to_cpu(hdr->status)) {
+		efc_log_debug(hw->os, "bad status cqe=%#x mqe=%#x\n", status,
+			       le16_to_cpu(hdr->status));
+	} else {
+		evt = EFC_HW_NODE_FREE_ALL_OK;
+	}
+
+	if (evt == EFC_HW_NODE_FREE_ALL_OK) {
+		for (i = 0; i < hw->sli.extent[SLI_RSRC_RPI].size;
+		     i++)
+			atomic_set(&hw->rpi_ref[i].rpi_count, 0);
+
+		if (sli_resource_reset(&hw->sli, SLI_RSRC_RPI)) {
+			efc_log_test(hw->os, "RPI free all failure\n");
+			rc = -1;
+		}
+	}
+
+	efc_remote_node_cb(efct->efcport, evt, NULL);
+
+	kfree(mqe);
+
+	return rc;
+}
+
+enum efct_hw_rtn
+efct_hw_node_free_all(struct efct_hw *hw)
+{
+	u8	*buf = NULL;
+	enum efct_hw_rtn	rc = EFCT_HW_RTN_ERROR;
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(&hw->sli) > 0) {
+		efc_log_crit(hw->os,
+			      "Chip is in an error state - reset needed\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	buf = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
+	if (!buf)
+		return EFCT_HW_RTN_NO_MEMORY;
+
+	memset(buf, 0, SLI4_BMBX_SIZE);
+
+	if (!sli_cmd_unreg_rpi(&hw->sli, buf, SLI4_BMBX_SIZE, 0xffff,
+			      SLI_RSRC_FCFI, U32_MAX))
+		rc = efct_hw_command(hw, buf, EFCT_CMD_NOWAIT,
+				     efct_hw_cb_node_free_all,
+				     NULL);
+
+	if (rc != EFCT_HW_RTN_SUCCESS) {
+		efc_log_err(hw->os, "UNREG_RPI failed\n");
+		kfree(buf);
+		rc = EFCT_HW_RTN_ERROR;
+	}
+
+	return rc;
+}
+
+struct efct_hw_get_nvparms_cb_arg {
+	void (*cb)(int status,
+		   u8 *wwpn, u8 *wwnn,
+		u8 hard_alpa, u32 preferred_d_id,
+		void *arg);
+	void *arg;
+};
+
+static int
+efct_hw_get_nvparms_cb(struct efct_hw *hw, int status,
+		       u8 *mqe, void *arg)
+{
+	struct efct_hw_get_nvparms_cb_arg *cb_arg = arg;
+	struct sli4_cmd_read_nvparms *mbox_rsp =
+			(struct sli4_cmd_read_nvparms *)mqe;
+	u8 hard_alpa;
+	u32 preferred_d_id;
+
+	hard_alpa = le32_to_cpu(mbox_rsp->hard_alpa_d_id) &
+				SLI4_READ_NVPARAMS_HARD_ALPA;
+	preferred_d_id = (le32_to_cpu(mbox_rsp->hard_alpa_d_id) &
+			  SLI4_READ_NVPARAMS_PREFERRED_D_ID) >> 8;
+	if (cb_arg->cb)
+		cb_arg->cb(status, mbox_rsp->wwpn, mbox_rsp->wwnn,
+			   hard_alpa, preferred_d_id,
+			   cb_arg->arg);
+
+	kfree(mqe);
+	kfree(cb_arg);
+
+	return 0;
+}
+
+int
+efct_hw_get_nvparms(struct efct_hw *hw,
+		    void (*cb)(int status, u8 *wwpn,
+			       u8 *wwnn, u8 hard_alpa,
+			       u32 preferred_d_id, void *arg),
+		    void *ul_arg)
+{
+	u8 *mbxdata;
+	struct efct_hw_get_nvparms_cb_arg *cb_arg;
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+
+	/* mbxdata holds the header of the command */
+	mbxdata = kmalloc(SLI4_BMBX_SIZE, GFP_KERNEL);
+	if (!mbxdata)
+		return EFCT_HW_RTN_NO_MEMORY;
+
+	memset(mbxdata, 0, SLI4_BMBX_SIZE);
+
+	/*
+	 * cb_arg holds the data that will be passed to the callback on
+	 * completion
+	 */
+	cb_arg = kmalloc(sizeof(*cb_arg), GFP_KERNEL);
+	if (!cb_arg) {
+		kfree(mbxdata);
+		return EFCT_HW_RTN_NO_MEMORY;
+	}
+
+	cb_arg->cb = cb;
+	cb_arg->arg = ul_arg;
+
+	/* Send the HW command */
+	if (!sli_cmd_read_nvparms(&hw->sli, mbxdata, SLI4_BMBX_SIZE))
+		rc = efct_hw_command(hw, mbxdata, EFCT_CMD_NOWAIT,
+				     efct_hw_get_nvparms_cb, cb_arg);
+
+	if (rc != EFCT_HW_RTN_SUCCESS) {
+		efc_log_test(hw->os, "READ_NVPARMS failed\n");
+		kfree(mbxdata);
+		kfree(cb_arg);
+	}
+
+	return rc;
+}
+
+struct efct_hw_set_nvparms_cb_arg {
+	void (*cb)(int status, void *arg);
+	void *arg;
+};
+
+static int
+efct_hw_set_nvparms_cb(struct efct_hw *hw, int status,
+		       u8 *mqe, void *arg)
+{
+	struct efct_hw_set_nvparms_cb_arg *cb_arg = arg;
+
+	if (cb_arg->cb)
+		cb_arg->cb(status, cb_arg->arg);
+
+	kfree(mqe);
+	kfree(cb_arg);
+
+	return 0;
+}
+
+int
+efct_hw_set_nvparms(struct efct_hw *hw,
+		    void (*cb)(int status, void *arg),
+		u8 *wwpn, u8 *wwnn, u8 hard_alpa,
+		u32 preferred_d_id,
+		void *ul_arg)
+{
+	u8 *mbxdata;
+	struct efct_hw_set_nvparms_cb_arg *cb_arg;
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+
+	/* mbxdata holds the header of the command */
+	mbxdata = kmalloc(SLI4_BMBX_SIZE, GFP_KERNEL);
+	if (!mbxdata)
+		return EFCT_HW_RTN_NO_MEMORY;
+
+	/*
+	 * cb_arg holds the data that will be passed to the callback on
+	 * completion
+	 */
+	cb_arg = kmalloc(sizeof(*cb_arg), GFP_KERNEL);
+	if (!cb_arg) {
+		kfree(mbxdata);
+		return EFCT_HW_RTN_NO_MEMORY;
+	}
+
+	cb_arg->cb = cb;
+	cb_arg->arg = ul_arg;
+
+	/* Send the HW command */
+	if (!sli_cmd_write_nvparms(&hw->sli, mbxdata, SLI4_BMBX_SIZE, wwpn,
+				  wwnn, hard_alpa, preferred_d_id))
+		rc = efct_hw_command(hw, mbxdata, EFCT_CMD_NOWAIT,
+				     efct_hw_set_nvparms_cb, cb_arg);
+
+	if (rc != EFCT_HW_RTN_SUCCESS) {
+		efc_log_test(hw->os, "SET_NVPARMS failed\n");
+		kfree(mbxdata);
+		kfree(cb_arg);
+	}
+
+	return rc;
+}
+
+static int
+efct_hw_cb_fw_write(struct efct_hw *hw, int status,
+		    u8 *mqe, void  *arg)
+{
+	struct sli4_cmd_sli_config *mbox_rsp =
+					(struct sli4_cmd_sli_config *)mqe;
+	struct sli4_rsp_cmn_write_object *wr_obj_rsp;
+	struct efct_hw_fw_wr_cb_arg *cb_arg = arg;
+	u32 bytes_written;
+	u16 mbox_status;
+	u32 change_status;
+
+	wr_obj_rsp = (struct sli4_rsp_cmn_write_object *)
+		      &mbox_rsp->payload.embed;
+	bytes_written = le32_to_cpu(wr_obj_rsp->actual_write_length);
+	mbox_status = le16_to_cpu(mbox_rsp->hdr.status);
+	change_status = (le32_to_cpu(wr_obj_rsp->change_status_dword) &
+			 RSP_CHANGE_STATUS);
+
+	kfree(mqe);
+
+	if (cb_arg) {
+		if (cb_arg->cb) {
+			if (!status && mbox_status)
+				status = mbox_status;
+			cb_arg->cb(status, bytes_written, change_status,
+				   cb_arg->arg);
+		}
+
+		kfree(cb_arg);
+	}
+
+	return 0;
+}
+
+static enum efct_hw_rtn
+efct_hw_firmware_write_sli4_intf_2(struct efct_hw *hw, struct efc_dma *dma,
+				   u32 size, u32 offset, int last,
+			      void (*cb)(int status, u32 bytes_written,
+					 u32 change_status, void *arg),
+				void *arg)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_ERROR;
+	u8 *mbxdata;
+	struct efct_hw_fw_wr_cb_arg *cb_arg;
+	int noc = 0;
+
+	mbxdata = kmalloc(SLI4_BMBX_SIZE, GFP_KERNEL);
+	if (!mbxdata)
+		return EFCT_HW_RTN_NO_MEMORY;
+
+	memset(mbxdata, 0, SLI4_BMBX_SIZE);
+
+	cb_arg = kmalloc(sizeof(*cb_arg), GFP_KERNEL);
+	if (!cb_arg) {
+		kfree(mbxdata);
+		return EFCT_HW_RTN_NO_MEMORY;
+	}
+	memset(cb_arg, 0, sizeof(struct efct_hw_fw_wr_cb_arg));
+	cb_arg->cb = cb;
+	cb_arg->arg = arg;
+
+	/* Send the HW command */
+	if (!sli_cmd_common_write_object(&hw->sli, mbxdata, SLI4_BMBX_SIZE,
+					noc, last, size, offset, "/prg/",
+					dma))
+		rc = efct_hw_command(hw, mbxdata, EFCT_CMD_NOWAIT,
+				     efct_hw_cb_fw_write, cb_arg);
+
+	if (rc != EFCT_HW_RTN_SUCCESS) {
+		efc_log_test(hw->os, "COMMON_WRITE_OBJECT failed\n");
+		kfree(mbxdata);
+		kfree(cb_arg);
+	}
+
+	return rc;
+}
+
+/* Write a portion of a firmware image to the device */
+enum efct_hw_rtn
+efct_hw_firmware_write(struct efct_hw *hw, struct efc_dma *dma,
+		       u32 size, u32 offset, int last,
+			void (*cb)(int status, u32 bytes_written,
+				   u32 change_status, void *arg),
+			void *arg)
+{
+	return efct_hw_firmware_write_sli4_intf_2(hw, dma, size, offset,
+						     last, cb, arg);
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index 862504b96a23..598d05694ac3 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -479,7 +479,6 @@ struct efct_hw_io {
 	void			*ul_io;
 };
 
-
 /* Typedef for HW "done" callback */
 typedef int (*efct_hw_done_t)(struct efct_hw_io *, struct efc_remote_node *,
 			      u32 len, int status, u32 ext, void *ul_arg);
@@ -1040,5 +1039,61 @@ efct_hw_port_control(struct efct_hw *hw, enum efct_hw_port ctrl,
 		     uintptr_t value,
 		void (*cb)(int status, uintptr_t value, void *arg),
 		void *arg);
+extern enum efct_hw_rtn
+efct_hw_port_alloc(struct efc *efc, struct efc_sli_port *sport,
+		   struct efc_domain *domain, u8 *wwpn);
+extern enum efct_hw_rtn
+efct_hw_port_attach(struct efc *efc, struct efc_sli_port *sport,
+		    u32 fc_id);
+extern enum efct_hw_rtn
+efct_hw_port_free(struct efc *efc, struct efc_sli_port *sport);
+extern enum efct_hw_rtn
+efct_hw_domain_alloc(struct efc *efc, struct efc_domain *domain,
+		     u32 fcf);
+extern enum efct_hw_rtn
+efct_hw_domain_attach(struct efc *efc,
+		      struct efc_domain *domain, u32 fc_id);
+extern enum efct_hw_rtn
+efct_hw_domain_free(struct efc *efc, struct efc_domain *domain);
+extern enum efct_hw_rtn
+efct_hw_domain_force_free(struct efc *efc, struct efc_domain *domain);
+extern enum efct_hw_rtn
+efct_hw_node_alloc(struct efc *efc, struct efc_remote_node *rnode,
+		   u32 fc_addr, struct efc_sli_port *sport);
+extern enum efct_hw_rtn
+efct_hw_node_free_all(struct efct_hw *hw);
+extern enum efct_hw_rtn
+efct_hw_node_attach(struct efc *efc, struct efc_remote_node *rnode,
+		    struct efc_dma *sparms);
+extern enum efct_hw_rtn
+efct_hw_node_detach(struct efc *efc, struct efc_remote_node *rnode);
+extern enum efct_hw_rtn
+efct_hw_node_free_resources(struct efc *efc,
+			    struct efc_remote_node *rnode);
+
+extern enum efct_hw_rtn
+efct_hw_firmware_write(struct efct_hw *hw, struct efc_dma *dma,
+		       u32 size, u32 offset, int last,
+		       void (*cb)(int status, u32 bytes_written,
+				  u32 change_status, void *arg),
+		       void *arg);
+
+extern enum efct_hw_rtn
+efct_hw_get_nvparms(struct efct_hw *hw,
+		    void (*mgmt_cb)(int status, u8 *wwpn,
+				    u8 *wwnn, u8 hard_alpa,
+				    u32 preferred_d_id, void *arg),
+		    void *arg);
+extern
+enum efct_hw_rtn efct_hw_set_nvparms(struct efct_hw *hw,
+				       void (*mgmt_cb)(int status, void *arg),
+		u8 *wwpn, u8 *wwnn, u8 hard_alpa,
+		u32 preferred_d_id, void *arg);
+
+typedef int (*efct_hw_async_cb_t)(struct efct_hw *hw, int status,
+				  u8 *mqe, void *arg);
+extern int
+efct_hw_async_call(struct efct_hw *hw,
+		   efct_hw_async_cb_t callback, void *arg);
 
 #endif /* __EFCT_H__ */
-- 
2.13.7

