Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C639CC43457
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EAD42073A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="TzMTWYXu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390684AbgJLWwV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 18:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390662AbgJLWwU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 18:52:20 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0259AC0613D2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:20 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id 1so3682413ple.2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=g0kx9v8I8GKP21OUqCAeezCLJfTWtFfhtQ4Kipfg3Po=;
        b=TzMTWYXubjdmElRq72Pk4USXa4y2I1NQT674A30d8rt6nFhhM6iIt4XEMKs7Zq+aDs
         WBDH2PTIfG4bNeMJRhmpYJOidcaNrBu24aidvdUHhihvmUS4CbP5bs5H9thQplBRQxrI
         oepvzMKjTnGB7yx/6qPRm9gIVV0QvM6iqQ0nc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=g0kx9v8I8GKP21OUqCAeezCLJfTWtFfhtQ4Kipfg3Po=;
        b=GB34vp6hFXF4H2CN9t5NfStFYIK1HZ8O0g9ALeGYqXjxgQoUnvkTKPzaqFx/38qdFT
         HLHjvPzm6z1PnyE4aYKiBMx9SVx6zNmwIyNvpIWxutwP+ppicGjR5ESmEvz9o8Jsis2F
         ZZrEGFi9CIDMz+CAbq734xcsojf1KD71Y6Eg61zG7+e/FsRR4g4y/E9eNjfqriTZ3iCJ
         Jhw/SfdLqCloc4Y7bXs5LN2qm10EtBOZkA54OsOGIPRGFKNi1cItReDmoMOnGy8xwHNc
         02F0yRQlCZ3/3QIWarkw9k4/w6VtiiYd5FShoCYfb+xKy/XfAaz2RVfpJYS4Zlu0H6DC
         u9Nw==
X-Gm-Message-State: AOAM533v5O3QfyA/gWK16L3mlMaKzwYmUqT+SCOUV9mu0Z7Tdu+f/if8
        YmozywXw8GjSQlSxp2KPwVjiUcMu3uVZm2HlQ3IE6wucQJpaSktEIABhTGSW4ZpRxD9e5t/A9zD
        azDwY5tOI1QlJO5mIlBXVYrZG7HVSx9UAYrAbpeawWBUj8e0mkAibWt4+i9jEatmGuwb/jrUTPO
        K72U8=
X-Google-Smtp-Source: ABdhPJyszLJzVObv+KJuXWHCAWcLCJnUUy7dDLdGKTISqtB28JV/MUvUrvjPW8VGR1T0K2oQaYer9Q==
X-Received: by 2002:a17:902:9a8d:b029:d2:ac2e:ee5d with SMTP id w13-20020a1709029a8db02900d2ac2eee5dmr24605312plp.37.1602543138475;
        Mon, 12 Oct 2020 15:52:18 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x5sm21222287pfr.83.2020.10.12.15.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:52:17 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v4 16/31] elx: libefc: Register discovery objects with hardware
Date:   Mon, 12 Oct 2020 15:51:32 -0700
Message-Id: <20201012225147.54404-17-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012225147.54404-1-james.smart@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008e1d8d05b181267d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000008e1d8d05b181267d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch continues the libefc library population.

This patch adds library interface definitions for:
-Registrations for VFI, VPI and RPI.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v4:
  New patch cmds to register VFI, VPI and RPI.
  Removed all hw related template calls and added issue_mbox_rqst
     template call.
  Populate all the mbox related cmds in discovery library into efc_cmds.c.
  Removed allocation of command buffer for mailbox, use stack variable
---
 drivers/scsi/elx/libefc/efc_cmds.c | 877 +++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc/efc_cmds.h |  34 ++
 2 files changed, 911 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_cmds.c
 create mode 100644 drivers/scsi/elx/libefc/efc_cmds.h

diff --git a/drivers/scsi/elx/libefc/efc_cmds.c b/drivers/scsi/elx/libefc/efc_cmds.c
new file mode 100644
index 000000000000..500615a7aff9
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_cmds.c
@@ -0,0 +1,877 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efclib.h"
+#include "../libefc_sli/sli4.h"
+#include "efc_cmds.h"
+
+static void
+efc_nport_free_resources(struct efc_nport *nport, int evt, void *data)
+{
+	struct efc *efc = nport->efc;
+
+	/* Clear the nport attached flag */
+	nport->attached = false;
+
+	/* Free the service parameters buffer */
+	if (nport->dma.virt) {
+		dma_free_coherent(&efc->pci->dev, nport->dma.size,
+				  nport->dma.virt, nport->dma.phys);
+		memset(&nport->dma, 0, sizeof(struct efc_dma));
+	}
+
+	/* Free the SLI resources */
+	sli_resource_free(efc->sli, SLI4_RSRC_VPI, nport->indicator);
+
+	efc_nport_cb(efc, evt, nport);
+}
+
+static int
+efc_nport_get_mbox_status(struct efc_nport *nport, u8 *mqe, int status)
+{
+	struct efc *efc = nport->efc;
+	struct sli4_mbox_command_header *hdr =
+			(struct sli4_mbox_command_header *)mqe;
+	int rc = 0;
+
+	if (status || le16_to_cpu(hdr->status)) {
+		efc_log_debug(efc, "bad status vpi=%#x st=%x hdr=%x\n",
+			nport->indicator, status, le16_to_cpu(hdr->status));
+		rc = -1;
+	}
+
+	return rc;
+}
+
+static int
+efc_nport_free_unreg_vpi_cb(struct efc *efc, int status, u8 *mqe, void *arg)
+{
+	struct efc_nport *nport = arg;
+	int evt = EFC_HW_PORT_FREE_OK;
+	int rc = 0;
+
+	rc = efc_nport_get_mbox_status(nport, mqe, status);
+	if (rc) {
+		evt = EFC_HW_PORT_FREE_FAIL;
+		rc = -1;
+	}
+
+	efc_nport_free_resources(nport, evt, mqe);
+	return rc;
+}
+
+static void
+efc_nport_free_unreg_vpi(struct efc_nport *nport)
+{
+	struct efc *efc = nport->efc;
+	int rc;
+	u8 data[SLI4_BMBX_SIZE];
+
+	rc = sli_cmd_unreg_vpi(efc->sli, data, nport->indicator,
+			       SLI4_UNREG_TYPE_PORT);
+	if (rc) {
+		efc_log_err(efc, "UNREG_VPI format failure\n");
+		efc_nport_free_resources(nport, EFC_HW_PORT_FREE_FAIL, data);
+		return;
+	}
+
+	rc = efc->tt.issue_mbox_rqst(efc->base, data,
+				     efc_nport_free_unreg_vpi_cb, nport);
+	if (rc) {
+		efc_log_err(efc, "UNREG_VPI command failure\n");
+		efc_nport_free_resources(nport, EFC_HW_PORT_FREE_FAIL, data);
+	}
+}
+
+static void
+efc_nport_send_evt(struct efc_nport *nport, int evt, void *data)
+{
+	struct efc *efc = nport->efc;
+
+	/* Now inform the registered callbacks */
+	efc_nport_cb(efc, evt, nport);
+
+	/* Set the nport attached flag */
+	if (evt == EFC_HW_PORT_ATTACH_OK)
+		nport->attached = true;
+
+	/* If there is a pending free request, then handle it now */
+	if (nport->free_req_pending)
+		efc_nport_free_unreg_vpi(nport);
+}
+
+static int
+efc_nport_alloc_init_vpi_cb(struct efc *efc, int status, u8 *mqe, void *arg)
+{
+	struct efc_nport *nport = arg;
+	int rc;
+
+	rc = efc_nport_get_mbox_status(nport, mqe, status);
+	if (rc) {
+		efc_nport_free_resources(nport, EFC_HW_PORT_ALLOC_FAIL, mqe);
+		return EFC_FAIL;
+	}
+
+	efc_nport_send_evt(nport, EFC_HW_PORT_ALLOC_OK, mqe);
+	return EFC_SUCCESS;
+}
+
+static void
+efc_nport_alloc_init_vpi(struct efc_nport *nport)
+{
+	struct efc *efc = nport->efc;
+	u8 data[SLI4_BMBX_SIZE];
+	int rc;
+
+	/* If there is a pending free request, then handle it now */
+	if (nport->free_req_pending) {
+		efc_nport_free_resources(nport, EFC_HW_PORT_FREE_OK, data);
+		return;
+	}
+
+	rc = sli_cmd_init_vpi(efc->sli, data,
+			      nport->indicator, nport->domain->indicator);
+	if (rc) {
+		efc_log_err(efc, "INIT_VPI format failure\n");
+		efc_nport_free_resources(nport, EFC_HW_PORT_ALLOC_FAIL, data);
+		return;
+	}
+
+	rc = efc->tt.issue_mbox_rqst(efc->base, data,
+			efc_nport_alloc_init_vpi_cb, nport);
+	if (rc) {
+		efc_log_err(efc, "INIT_VPI command failure\n");
+		efc_nport_free_resources(nport, EFC_HW_PORT_ALLOC_FAIL, data);
+	}
+}
+
+static int
+efc_nport_alloc_read_sparm64_cb(struct efc *efc, int status, u8 *mqe, void *arg)
+{
+	struct efc_nport *nport = arg;
+	u8 *payload = NULL;
+	int rc;
+
+	rc = efc_nport_get_mbox_status(nport, mqe, status);
+	if (rc) {
+		efc_nport_free_resources(nport, EFC_HW_PORT_ALLOC_FAIL, mqe);
+		return EFC_FAIL;
+	}
+
+	payload = nport->dma.virt;
+
+	memcpy(&nport->sli_wwpn, payload + SLI4_READ_SPARM64_WWPN_OFFSET,
+		sizeof(nport->sli_wwpn));
+	memcpy(&nport->sli_wwnn, payload + SLI4_READ_SPARM64_WWNN_OFFSET,
+		sizeof(nport->sli_wwnn));
+
+	dma_free_coherent(&efc->pci->dev, nport->dma.size, nport->dma.virt,
+			  nport->dma.phys);
+	memset(&nport->dma, 0, sizeof(struct efc_dma));
+	efc_nport_alloc_init_vpi(nport);
+	return EFC_SUCCESS;
+}
+
+static void
+efc_nport_alloc_read_sparm64(struct efc *efc, struct efc_nport *nport)
+{
+	u8 data[SLI4_BMBX_SIZE];
+	int rc;
+
+	/* Allocate memory for the service parameters */
+	nport->dma.size = 112;
+	nport->dma.virt = dma_alloc_coherent(&efc->pci->dev,
+					     nport->dma.size, &nport->dma.phys,
+					     GFP_DMA);
+	if (!nport->dma.virt) {
+		efc_log_err(efc, "Failed to allocate DMA memory\n");
+		efc_nport_free_resources(nport, EFC_HW_PORT_ALLOC_FAIL, data);
+		return;
+	}
+
+	rc = sli_cmd_read_sparm64(efc->sli, data,
+				  &nport->dma, nport->indicator);
+	if (rc) {
+		efc_log_err(efc, "READ_SPARM64 format failure\n");
+		efc_nport_free_resources(nport, EFC_HW_PORT_ALLOC_FAIL, data);
+		return;
+	}
+
+	rc = efc->tt.issue_mbox_rqst(efc->base, data,
+				     efc_nport_alloc_read_sparm64_cb, nport);
+	if (rc) {
+		efc_log_err(efc, "READ_SPARM64 command failure\n");
+		efc_nport_free_resources(nport, EFC_HW_PORT_ALLOC_FAIL, data);
+	}
+}
+
+int
+efc_cmd_nport_alloc(struct efc *efc, struct efc_nport *nport,
+		    struct efc_domain *domain, u8 *wwpn)
+{
+	u32 rc = EFC_SUCCESS;
+	u32 index;
+
+	nport->indicator = U32_MAX;
+	nport->free_req_pending = false;
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(efc->sli) > 0) {
+		efc_log_crit(efc, "Chip is in an error state - reset needed\n");
+		return EFC_FAIL;
+	}
+
+	if (wwpn)
+		memcpy(&nport->sli_wwpn, wwpn, sizeof(nport->sli_wwpn));
+
+	/*
+	 * allocate a VPI object for the port and stores it in the
+	 * indicator field of the port object.
+	 */
+	if (sli_resource_alloc(efc->sli, SLI4_RSRC_VPI,
+			       &nport->indicator, &index)) {
+		efc_log_err(efc, "VPI allocation failure\n");
+		return EFC_FAIL;
+	}
+
+	if (domain) {
+		/*
+		 * If the WWPN is NULL, fetch the default
+		 * WWPN and WWNN before initializing the VPI
+		 */
+		if (!wwpn)
+			efc_nport_alloc_read_sparm64(efc, nport);
+		else
+			efc_nport_alloc_init_vpi(nport);
+	} else if (!wwpn) {
+		/* This is the convention for the HW, not SLI */
+		efc_log_err(efc, "need WWN for physical port\n");
+		rc = EFC_FAIL;
+	}
+
+	/* domain NULL and wwpn non-NULL */
+	if (rc)
+		sli_resource_free(efc->sli, SLI4_RSRC_VPI, nport->indicator);
+
+	return rc;
+}
+
+static int
+efc_nport_attach_reg_vpi_cb(struct efc *efc, int status, u8 *mqe,
+			       void *arg)
+{
+	struct efc_nport *nport = arg;
+	int rc;
+
+	rc = efc_nport_get_mbox_status(nport, mqe, status);
+	if (rc) {
+		efc_nport_free_resources(nport, EFC_HW_PORT_ATTACH_FAIL, mqe);
+		return EFC_FAIL;
+	}
+
+	efc_nport_send_evt(nport, EFC_HW_PORT_ATTACH_OK, mqe);
+	return EFC_SUCCESS;
+}
+
+int
+efc_cmd_nport_attach(struct efc *efc, struct efc_nport *nport, u32 fc_id)
+{
+	u8 buf[SLI4_BMBX_SIZE];
+	int rc = EFC_SUCCESS;
+
+	if (!nport) {
+		efc_log_err(efc, "bad param(s) nport=%p\n", nport);
+		return EFC_FAIL;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(efc->sli) > 0) {
+		efc_log_crit(efc,
+			      "Chip is in an error state - reset needed\n");
+		return EFC_FAIL;
+	}
+
+	nport->fc_id = fc_id;
+
+	/* register previously-allocated VPI with the device */
+	rc = sli_cmd_reg_vpi(efc->sli, buf, nport->fc_id,
+			    nport->sli_wwpn, nport->indicator,
+			    nport->domain->indicator, false);
+	if (rc) {
+		efc_log_err(efc, "REG_VPI format failure\n");
+		efc_nport_free_resources(nport, EFC_HW_PORT_ATTACH_FAIL, buf);
+		return rc;
+	}
+
+	rc = efc->tt.issue_mbox_rqst(efc->base, buf,
+				     efc_nport_attach_reg_vpi_cb, nport);
+	if (rc) {
+		efc_log_err(efc, "REG_VPI command failure\n");
+		efc_nport_free_resources(nport, EFC_HW_PORT_ATTACH_FAIL, buf);
+	}
+
+	return rc;
+}
+
+int
+efc_cmd_nport_free(struct efc *efc, struct efc_nport *nport)
+{
+	if (!nport) {
+		efc_log_err(efc, "bad parameter(s) nport=%p\n",	nport);
+		return EFC_FAIL;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(efc->sli) > 0) {
+		efc_log_crit(efc,
+			      "Chip is in an error state - reset needed\n");
+		return EFC_FAIL;
+	}
+
+	/* Issue the UNREG_VPI command to free the assigned VPI context */
+	if (nport->attached)
+		efc_nport_free_unreg_vpi(nport);
+	else
+		nport->free_req_pending = true;
+
+	return EFC_SUCCESS;
+}
+
+static int
+efc_domain_get_mbox_status(struct efc_domain *domain, u8 *mqe, int status)
+{
+	struct efc *efc = domain->efc;
+	struct sli4_mbox_command_header *hdr =
+			(struct sli4_mbox_command_header *)mqe;
+	int rc = 0;
+
+	if (status || le16_to_cpu(hdr->status)) {
+		efc_log_debug(efc, "bad status vfi=%#x st=%x hdr=%x\n",
+			       domain->indicator, status,
+			       le16_to_cpu(hdr->status));
+		rc = -1;
+	}
+
+	return rc;
+}
+
+static void
+efc_domain_free_resources(struct efc_domain *domain, int evt, void *data)
+{
+	struct efc *efc = domain->efc;
+
+	/* Free the service parameters buffer */
+	if (domain->dma.virt) {
+		dma_free_coherent(&efc->pci->dev,
+				  domain->dma.size, domain->dma.virt,
+				  domain->dma.phys);
+		memset(&domain->dma, 0, sizeof(struct efc_dma));
+	}
+
+	/* Free the SLI resources */
+	sli_resource_free(efc->sli, SLI4_RSRC_VFI, domain->indicator);
+
+	efc_domain_cb(efc, evt, domain);
+}
+
+static void
+efc_domain_send_nport_evt(struct efc_domain *domain,
+			      int port_evt, int domain_evt, void *data)
+{
+	struct efc *efc = domain->efc;
+
+	/* Send alloc/attach ok to the physical nport */
+	efc_nport_send_evt(domain->nport, port_evt, NULL);
+
+	/* Now inform the registered callbacks */
+	efc_domain_cb(efc, domain_evt, domain);
+}
+
+static int
+efc_domain_alloc_read_sparm64_cb(struct efc *efc, int status, u8 *mqe,
+				 void *arg)
+{
+	struct efc_domain *domain = arg;
+	int rc;
+
+	rc = efc_domain_get_mbox_status(domain, mqe, status);
+	if (rc) {
+		efc_domain_free_resources(domain,
+					      EFC_HW_DOMAIN_ALLOC_FAIL, mqe);
+		return EFC_FAIL;
+	}
+
+	efc_domain_send_nport_evt(domain, EFC_HW_PORT_ALLOC_OK,
+				      EFC_HW_DOMAIN_ALLOC_OK, mqe);
+	return EFC_SUCCESS;
+}
+
+static void
+efc_domain_alloc_read_sparm64(struct efc_domain *domain)
+{
+	struct efc *efc = domain->efc;
+	u8 data[SLI4_BMBX_SIZE];
+	int rc;
+
+	rc = sli_cmd_read_sparm64(efc->sli, data, &domain->dma, 0);
+	if (rc) {
+		efc_log_err(efc, "READ_SPARM64 format failure\n");
+		efc_domain_free_resources(domain,
+					      EFC_HW_DOMAIN_ALLOC_FAIL, data);
+		return;
+	}
+
+	rc = efc->tt.issue_mbox_rqst(efc->base, data,
+				     efc_domain_alloc_read_sparm64_cb, domain);
+	if (rc) {
+		efc_log_err(efc, "READ_SPARM64 command failure\n");
+		efc_domain_free_resources(domain,
+					      EFC_HW_DOMAIN_ALLOC_FAIL, data);
+	}
+}
+
+static int
+efc_domain_alloc_init_vfi_cb(struct efc *efc, int status, u8 *mqe,
+				 void *arg)
+{
+	struct efc_domain *domain = arg;
+	int rc;
+
+	rc = efc_domain_get_mbox_status(domain, mqe, status);
+	if (rc) {
+		efc_domain_free_resources(domain,
+					      EFC_HW_DOMAIN_ALLOC_FAIL, mqe);
+		return EFC_FAIL;
+	}
+
+	efc_domain_alloc_read_sparm64(domain);
+	return EFC_SUCCESS;
+}
+
+static void
+efc_domain_alloc_init_vfi(struct efc_domain *domain)
+{
+	struct efc *efc = domain->efc;
+	struct efc_nport *nport = domain->nport;
+	u8 data[SLI4_BMBX_SIZE];
+	int rc;
+
+	/*
+	 * For FC, the HW alread registered an FCFI.
+	 * Copy FCF information into the domain and jump to INIT_VFI.
+	 */
+	domain->fcf_indicator = efc->fcfi;
+	rc = sli_cmd_init_vfi(efc->sli, data, domain->indicator,
+			      domain->fcf_indicator, nport->indicator);
+	if (rc) {
+		efc_log_err(efc, "INIT_VFI format failure\n");
+		efc_domain_free_resources(domain,
+					      EFC_HW_DOMAIN_ALLOC_FAIL, data);
+		return;
+	}
+
+	efc_log_err(efc, "%s issue mbox\n", __func__);
+	rc = efc->tt.issue_mbox_rqst(efc->base, data,
+				     efc_domain_alloc_init_vfi_cb, domain);
+	if (rc) {
+		efc_log_err(efc, "INIT_VFI command failure\n");
+		efc_domain_free_resources(domain,
+					      EFC_HW_DOMAIN_ALLOC_FAIL, data);
+	}
+}
+
+int
+efc_cmd_domain_alloc(struct efc *efc, struct efc_domain *domain, u32 fcf)
+{
+	u32 index;
+
+	if (!domain || !domain->nport) {
+		efc_log_err(efc, "bad parameter(s) domain=%p nport=%p\n",
+			    domain, domain ? domain->nport : NULL);
+		return EFC_FAIL;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(efc->sli) > 0) {
+		efc_log_crit(efc,
+			     "Chip is in an error state - reset needed\n");
+		return EFC_FAIL;
+	}
+
+	/* allocate memory for the service parameters */
+	domain->dma.size = 112;
+	domain->dma.virt = dma_alloc_coherent(&efc->pci->dev,
+					      domain->dma.size,
+					      &domain->dma.phys, GFP_DMA);
+	if (!domain->dma.virt) {
+		efc_log_err(efc, "Failed to allocate DMA memory\n");
+		return EFC_FAIL;
+	}
+
+	domain->fcf = fcf;
+	domain->fcf_indicator = U32_MAX;
+	domain->indicator = U32_MAX;
+
+	if (sli_resource_alloc(efc->sli, SLI4_RSRC_VFI, &domain->indicator,
+			       &index)) {
+		efc_log_err(efc, "VFI allocation failure\n");
+
+		dma_free_coherent(&efc->pci->dev,
+				  domain->dma.size, domain->dma.virt,
+				  domain->dma.phys);
+		memset(&domain->dma, 0, sizeof(struct efc_dma));
+
+		return EFC_FAIL;
+	}
+
+	efc_domain_alloc_init_vfi(domain);
+	return EFC_SUCCESS;
+}
+
+static int
+efc_domain_attach_reg_vfi_cb(struct efc *efc, int status, u8 *mqe,
+				 void *arg)
+{
+	struct efc_domain *domain = arg;
+	int rc;
+
+	rc = efc_domain_get_mbox_status(domain, mqe, status);
+	if (rc) {
+		//hw->domain = NULL;
+		efc_domain_free_resources(domain,
+					      EFC_HW_DOMAIN_ATTACH_FAIL, mqe);
+		return EFC_FAIL;
+	}
+
+	efc_domain_send_nport_evt(domain, EFC_HW_PORT_ATTACH_OK,
+				      EFC_HW_DOMAIN_ATTACH_OK, mqe);
+	return EFC_SUCCESS;
+}
+
+int
+efc_cmd_domain_attach(struct efc *efc, struct efc_domain *domain, u32 fc_id)
+{
+	u8 buf[SLI4_BMBX_SIZE];
+	int rc = EFC_SUCCESS;
+
+	if (!domain) {
+		efc_log_err(efc, "bad param(s) domain=%p\n", domain);
+		return EFC_FAIL;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(efc->sli) > 0) {
+		efc_log_crit(efc,
+			      "Chip is in an error state - reset needed\n");
+		return EFC_FAIL;
+	}
+
+	domain->nport->fc_id = fc_id;
+
+	rc = sli_cmd_reg_vfi(efc->sli, buf, SLI4_BMBX_SIZE, domain->indicator,
+			     domain->fcf_indicator, domain->dma,
+			     domain->nport->indicator, domain->nport->sli_wwpn,
+			     domain->nport->fc_id);
+	if (rc) {
+		efc_log_err(efc, "REG_VFI format failure\n");
+		goto cleanup;
+	}
+
+	rc = efc->tt.issue_mbox_rqst(efc->base, buf,
+				     efc_domain_attach_reg_vfi_cb, domain);
+	if (rc) {
+		efc_log_err(efc, "REG_VFI command failure\n");
+		goto cleanup;
+	}
+
+	return rc;
+
+cleanup:
+	efc_domain_free_resources(domain, EFC_HW_DOMAIN_ATTACH_FAIL, buf);
+
+	return rc;
+}
+
+static int
+efc_domain_free_unreg_vfi_cb(struct efc *efc, int status, u8 *mqe, void *arg)
+{
+	struct efc_domain *domain = arg;
+	int evt = EFC_HW_DOMAIN_FREE_OK;
+	int rc = 0;
+
+	rc = efc_domain_get_mbox_status(domain, mqe, status);
+	if (rc) {
+		evt = EFC_HW_DOMAIN_FREE_FAIL;
+		rc = -1;
+	}
+
+	efc_domain_free_resources(domain, evt, mqe);
+	return rc;
+}
+
+static void
+efc_domain_free_unreg_vfi(struct efc_domain *domain)
+{
+	struct efc *efc = domain->efc;
+	int rc;
+	u8 data[SLI4_BMBX_SIZE];
+
+	rc = sli_cmd_unreg_vfi(efc->sli, data, domain->indicator,
+			       SLI4_UNREG_TYPE_DOMAIN);
+	if (rc) {
+		efc_log_err(efc, "UNREG_VFI format failure\n");
+		goto cleanup;
+	}
+
+	rc = efc->tt.issue_mbox_rqst(efc->base, data,
+				     efc_domain_free_unreg_vfi_cb, domain);
+	if (rc) {
+		efc_log_err(efc, "UNREG_VFI command failure\n");
+		goto cleanup;
+	}
+
+	return;
+
+cleanup:
+	efc_domain_free_resources(domain, EFC_HW_DOMAIN_FREE_FAIL, data);
+}
+
+int
+efc_cmd_domain_free(struct efc *efc, struct efc_domain *domain)
+{
+	int rc = EFC_SUCCESS;
+
+	if (!domain) {
+		efc_log_err(efc, "bad parameter(s) domain=%p\n", domain);
+		return EFC_FAIL;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(efc->sli) > 0) {
+		efc_log_crit(efc,
+			      "Chip is in an error state - reset needed\n");
+		return EFC_FAIL;
+	}
+
+	efc_domain_free_unreg_vfi(domain);
+	return rc;
+}
+
+int
+efc_cmd_node_alloc(struct efc *efc, struct efc_remote_node *rnode, u32 fc_addr,
+		   struct efc_nport *nport)
+{
+	/* Check for invalid indicator */
+	if (rnode->indicator != U32_MAX) {
+		efc_log_err(efc,
+			     "RPI allocation failure addr=%#x rpi=%#x\n",
+			    fc_addr, rnode->indicator);
+		return EFC_FAIL;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(efc->sli) > 0) {
+		efc_log_crit(efc,
+			      "Chip is in an error state - reset needed\n");
+		return EFC_FAIL;
+	}
+
+	/* NULL SLI port indicates an unallocated remote node */
+	rnode->nport = NULL;
+
+	if (sli_resource_alloc(efc->sli, SLI4_RSRC_RPI,
+			       &rnode->indicator, &rnode->index)) {
+		efc_log_err(efc, "RPI allocation failure addr=%#x\n",
+			     fc_addr);
+		return EFC_FAIL;
+	}
+
+	rnode->fc_id = fc_addr;
+	rnode->nport = nport;
+
+	return EFC_SUCCESS;
+}
+
+static int
+efc_cmd_node_attach_cb(struct efc *efc, int status, u8 *mqe, void *arg)
+{
+	struct efc_remote_node *rnode = arg;
+	struct sli4_mbox_command_header *hdr =
+				(struct sli4_mbox_command_header *)mqe;
+	enum efc_hw_remote_node_event	evt = 0;
+
+	if (status || le16_to_cpu(hdr->status)) {
+		efc_log_debug(efc, "bad status cqe=%#x mqe=%#x\n", status,
+			       le16_to_cpu(hdr->status));
+		rnode->attached = false;
+		evt = EFC_HW_NODE_ATTACH_FAIL;
+	} else {
+		rnode->attached = true;
+		evt = EFC_HW_NODE_ATTACH_OK;
+	}
+
+	efc_remote_node_cb(efc, evt, rnode);
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_cmd_node_attach(struct efc *efc, struct efc_remote_node *rnode,
+		    struct efc_dma *sparms)
+{
+	int rc = EFC_FAIL;
+	u8 buf[SLI4_BMBX_SIZE];
+
+	if (!rnode || !sparms) {
+		efc_log_err(efc, "bad parameter(s) rnode=%p sparms=%p\n",
+			    rnode, sparms);
+		return EFC_FAIL;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(efc->sli) > 0) {
+		efc_log_crit(efc, "Chip is in an error state - reset needed\n");
+		return EFC_FAIL;
+	}
+
+	/*
+	 * If the attach count is non-zero, this RPI has already been reg'd.
+	 * Otherwise, register the RPI
+	 */
+	if (rnode->index == U32_MAX) {
+		efc_log_err(efc, "bad parameter rnode->index invalid\n");
+		return EFC_FAIL;
+	}
+
+	/* Update a remote node object with the remote port's service params */
+	if (!sli_cmd_reg_rpi(efc->sli, buf, rnode->indicator,
+			rnode->nport->indicator, rnode->fc_id, sparms, 0, 0))
+		rc = efc->tt.issue_mbox_rqst(efc->base, buf,
+					     efc_cmd_node_attach_cb, rnode);
+
+	return rc;
+}
+
+int
+efc_node_free_resources(struct efc *efc, struct efc_remote_node *rnode)
+{
+	int rc = EFC_SUCCESS;
+
+	if (!rnode) {
+		efc_log_err(efc, "bad parameter rnode=%p\n", rnode);
+		return EFC_FAIL;
+	}
+
+	if (rnode->nport) {
+		if (rnode->attached) {
+			efc_log_err(efc, "Err: rnode is still attached\n");
+			return EFC_FAIL;
+		}
+		if (rnode->indicator != U32_MAX) {
+			if (sli_resource_free(efc->sli, SLI4_RSRC_RPI,
+					      rnode->indicator)) {
+				efc_log_err(efc,
+					    "RPI free fail RPI %d addr=%#x\n",
+					    rnode->indicator, rnode->fc_id);
+				rc = EFC_FAIL;
+			} else {
+				rnode->indicator = U32_MAX;
+				rnode->index = U32_MAX;
+			}
+		}
+	}
+
+	return rc;
+}
+
+static int
+efc_cmd_node_free_cb(struct efc *efc, int status, u8 *mqe, void *arg)
+{
+	struct efc_remote_node *rnode = arg;
+	struct sli4_mbox_command_header *hdr =
+				(struct sli4_mbox_command_header *)mqe;
+	enum efc_hw_remote_node_event evt = EFC_HW_NODE_FREE_FAIL;
+	int rc = 0;
+
+	if (status || le16_to_cpu(hdr->status)) {
+		efc_log_debug(efc, "bad status cqe=%#x mqe=%#x\n", status,
+			       le16_to_cpu(hdr->status));
+
+		/*
+		 * In certain cases, a non-zero MQE status is OK (all must be
+		 * true):
+		 *   - node is attached
+		 *   - status is 0x1400
+		 */
+		if (!rnode->attached ||
+		    (le16_to_cpu(hdr->status) != SLI4_MBX_STATUS_RPI_NOT_REG))
+			rc = EFC_FAIL;
+	}
+
+	if (!rc) {
+		rnode->attached = false;
+		evt = EFC_HW_NODE_FREE_OK;
+	}
+
+	efc_remote_node_cb(efc, evt, rnode);
+
+	return rc;
+}
+
+int
+efc_cmd_node_detach(struct efc *efc, struct efc_remote_node *rnode)
+{
+	u8 buf[SLI4_BMBX_SIZE];
+	int rc = EFC_FAIL;
+
+	if (!rnode) {
+		efc_log_err(efc, "bad parameter rnode=%p\n", rnode);
+		return EFC_FAIL;
+	}
+
+	/*
+	 * Check if the chip is in an error state (UE'd) before proceeding.
+	 */
+	if (sli_fw_error_status(efc->sli) > 0) {
+		efc_log_crit(efc, "Chip is in an error state - reset needed\n");
+		return EFC_FAIL;
+	}
+
+	if (rnode->nport) {
+		if (!rnode->attached)
+			return EFC_FAIL;
+
+		rc = EFC_FAIL;
+
+		if (!sli_cmd_unreg_rpi(efc->sli, buf, rnode->indicator,
+				      SLI4_RSRC_RPI, U32_MAX))
+			rc = efc->tt.issue_mbox_rqst(efc->base, buf,
+					efc_cmd_node_free_cb, rnode);
+
+		if (rc != EFC_SUCCESS) {
+			efc_log_err(efc, "UNREG_RPI failed\n");
+			rc = EFC_FAIL;
+		}
+	}
+
+	return rc;
+}
diff --git a/drivers/scsi/elx/libefc/efc_cmds.h b/drivers/scsi/elx/libefc/efc_cmds.h
new file mode 100644
index 000000000000..ee7bdb230cd7
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_cmds.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#ifndef __EFC_CMDS_H__
+#define __EFC_CMDS_H__
+
+int
+efc_cmd_nport_alloc(struct efc *efc, struct efc_nport *nport,
+		   struct efc_domain *domain, u8 *wwpn);
+int
+efc_cmd_nport_attach(struct efc *efc, struct efc_nport *nport, u32 fc_id);
+int
+efc_cmd_nport_free(struct efc *efc, struct efc_nport *nport);
+int
+efc_cmd_domain_alloc(struct efc *efc, struct efc_domain *domain, u32 fcf);
+int
+efc_cmd_domain_attach(struct efc *efc, struct efc_domain *domain, u32 fc_id);
+int
+efc_cmd_domain_free(struct efc *efc, struct efc_domain *domain);
+int
+efc_cmd_node_detach(struct efc *efc, struct efc_remote_node *rnode);
+int
+efc_node_free_resources(struct efc *efc, struct efc_remote_node *rnode);
+int
+efc_cmd_node_attach(struct efc *efc, struct efc_remote_node *rnode,
+		    struct efc_dma *sparms);
+int
+efc_cmd_node_alloc(struct efc *efc, struct efc_remote_node *rnode, u32 fc_addr,
+		   struct efc_nport *nport);
+
+#endif /* __EFC_CMDS_H */
-- 
2.26.2


--0000000000008e1d8d05b181267d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg7bT+Tz68NT9xJedE
txgR4CUisw6W/lqTMIcbxL9bz40wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDEyMjI1MjE5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBALL/0Lj2JnCyQvUHH7iXM1hlPCSWTE2Cv5cL
fwIWuh5xNn/1goixTXw5Uv7wSQDgdqvx8QIZmKI0VAmb6dQOyyO/C0IRhsrgoCXF4+MiZZ0CiS6l
K8NBIoGHWvB6yz2ZZ+ZMK1SrVv0RsaFFVr7PgQMzNE5Df5qoASjVI6yEE/yFp2qmeqUjOFrD9ZPl
2TLt3kXY1JFl/Td9PeeaoHHFwQWASNR5zNa49j8pdeutMOBwatp2aH88akPHMWZhtLh5yrBPDdAs
tDp+GKX+WDgyUOQA+k5cLxY4CKCFBQPK2gdyiiNP4jSDndVp0JLZP2K4yJzYXqEQ4vcBu20aFwLX
F/o=
--0000000000008e1d8d05b181267d--
