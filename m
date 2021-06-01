Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E740C47092
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 23:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 088F461245
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 23:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbhFAX5W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 19:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235249AbhFAX5N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 19:57:13 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8CFC061756
        for <linux-scsi@vger.kernel.org>; Tue,  1 Jun 2021 16:55:31 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mq2-20020a17090b3802b0290162428291f5so641365pjb.4
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jun 2021 16:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7V8lFH8ljOEoJtw7ohQMqe8mv8gjnSHPkwdD2Eo76/g=;
        b=We34wDb4BhkscKFVl4LrisKVRA+WxOsOoodPbWE/flqgF8caJcVmp7GTfUTCrQeyD+
         ire22vtmXtXosLfTE6iwF1C1q6UEKdKRANhsCgL9aYmPLdVNu7q4Gp0N4479xOuMi/i6
         3E7sJuas6JqYPn1B190vhPt31QvQTwSTtQ7UBSZV2p8B0CIltSVby5Kv8mgDrdcxJ3Fc
         KnsZW8WVNj6MCDC33uBCBmDKHg9EA5arbKbPfJNiBwVI/NayFYPwTC0SaJjKTyZC4goH
         tHHuSrodTjSs4OyQxWxuqGKX8AW/FFaBDC6dHVMDM7ZMngEzlBBMI/thCS7GpoRGarpp
         lK3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7V8lFH8ljOEoJtw7ohQMqe8mv8gjnSHPkwdD2Eo76/g=;
        b=bTS5LCVT8eKiLNaQgQ2Ywa9ynLwpdxTRTrvKN0bxokZ9CmreGgxw/JFmRUQOdH0ka7
         u8IO7bKgTCKNLrcUqzxqHPseBJshDEFOUWcMnM/ogq1F5HP/AXe6F7DmkFgeMFLa+u8o
         R3Qy2c/p9r9cUiiyT8lVsqu/f3+F2ZZJlLVaj4LYA4OMxCcki32xwOLYVKI6SyNLoZ9V
         u3fdcRJKI1M7LppjCe7Lbwre5Usjk9vhFiJ9b2GBBo/eu7+p3NW1/ZHWr97dgjprVjUn
         8I9Y2KBecGE6wqK1yR066VwQAaaewYb0eKDULGn6xFqZmXXiWBZZige28Jd7WG7wfNZE
         CQPQ==
X-Gm-Message-State: AOAM532btYs8sqwM6S29F4rqYSKR5ovAiluXgCd8V/dP+cCkLcoXa5bD
        b/cXbu49ccRZD8XEnJsXFt+wsId2RHs=
X-Google-Smtp-Source: ABdhPJxIBMW82CVUdwxzg9WZfP0CMAR74nMsAyK9R+iZwIbIHk3u2gQiTl6sMSYrK3LDswLlUJ9GeQ==
X-Received: by 2002:a17:90b:1e05:: with SMTP id pg5mr27683301pjb.65.1622591730625;
        Tue, 01 Jun 2021 16:55:30 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm13915357pfm.187.2021.06.01.16.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 16:55:30 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH v9 16/31] elx: libefc: Register discovery objects with hardware
Date:   Tue,  1 Jun 2021 16:54:57 -0700
Message-Id: <20210601235512.20104-17-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210601235512.20104-1-jsmart2021@gmail.com>
References: <20210601235512.20104-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the libefc library population.

This patch adds library interface definitions for:
-Registrations for VFI, VPI and RPI.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>

---
v9:
Non-functional changes:
  Remove EFC_SUCCESS/EFC_FAIL defines and use 0 and -Exxx errno values.
  Remove EFCT_xxx/EFCT_HW_RTN_xxx defines and use appropriate -Exxx errno
       values.
  Correct indentation on line continuations.
---
 drivers/scsi/elx/libefc/efc_cmds.c | 777 +++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc/efc_cmds.h |  35 ++
 2 files changed, 812 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_cmds.c
 create mode 100644 drivers/scsi/elx/libefc/efc_cmds.h

diff --git a/drivers/scsi/elx/libefc/efc_cmds.c b/drivers/scsi/elx/libefc/efc_cmds.c
new file mode 100644
index 000000000000..37e6697d86b8
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_cmds.c
@@ -0,0 +1,777 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efclib.h"
+#include "../libefc_sli/sli4.h"
+#include "efc_cmds.h"
+#include "efc_sm.h"
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
+
+	if (status || le16_to_cpu(hdr->status)) {
+		efc_log_debug(efc, "bad status vpi=%#x st=%x hdr=%x\n",
+			      nport->indicator, status, le16_to_cpu(hdr->status));
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int
+efc_nport_free_unreg_vpi_cb(struct efc *efc, int status, u8 *mqe, void *arg)
+{
+	struct efc_nport *nport = arg;
+	int evt = EFC_EVT_NPORT_FREE_OK;
+	int rc;
+
+	rc = efc_nport_get_mbox_status(nport, mqe, status);
+	if (rc)
+		evt = EFC_EVT_NPORT_FREE_FAIL;
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
+		efc_nport_free_resources(nport, EFC_EVT_NPORT_FREE_FAIL, data);
+		return;
+	}
+
+	rc = efc->tt.issue_mbox_rqst(efc->base, data,
+				     efc_nport_free_unreg_vpi_cb, nport);
+	if (rc) {
+		efc_log_err(efc, "UNREG_VPI command failure\n");
+		efc_nport_free_resources(nport, EFC_EVT_NPORT_FREE_FAIL, data);
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
+	if (evt == EFC_EVT_NPORT_ATTACH_OK)
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
+
+	if (efc_nport_get_mbox_status(nport, mqe, status)) {
+		efc_nport_free_resources(nport, EFC_EVT_NPORT_ALLOC_FAIL, mqe);
+		return -EIO;
+	}
+
+	efc_nport_send_evt(nport, EFC_EVT_NPORT_ALLOC_OK, mqe);
+	return 0;
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
+		efc_nport_free_resources(nport, EFC_EVT_NPORT_FREE_OK, data);
+		return;
+	}
+
+	rc = sli_cmd_init_vpi(efc->sli, data,
+			      nport->indicator, nport->domain->indicator);
+	if (rc) {
+		efc_log_err(efc, "INIT_VPI format failure\n");
+		efc_nport_free_resources(nport, EFC_EVT_NPORT_ALLOC_FAIL, data);
+		return;
+	}
+
+	rc = efc->tt.issue_mbox_rqst(efc->base, data,
+			efc_nport_alloc_init_vpi_cb, nport);
+	if (rc) {
+		efc_log_err(efc, "INIT_VPI command failure\n");
+		efc_nport_free_resources(nport, EFC_EVT_NPORT_ALLOC_FAIL, data);
+	}
+}
+
+static int
+efc_nport_alloc_read_sparm64_cb(struct efc *efc, int status, u8 *mqe, void *arg)
+{
+	struct efc_nport *nport = arg;
+	u8 *payload = NULL;
+
+	if (efc_nport_get_mbox_status(nport, mqe, status)) {
+		efc_nport_free_resources(nport, EFC_EVT_NPORT_ALLOC_FAIL, mqe);
+		return -EIO;
+	}
+
+	payload = nport->dma.virt;
+
+	memcpy(&nport->sli_wwpn, payload + SLI4_READ_SPARM64_WWPN_OFFSET,
+	       sizeof(nport->sli_wwpn));
+	memcpy(&nport->sli_wwnn, payload + SLI4_READ_SPARM64_WWNN_OFFSET,
+	       sizeof(nport->sli_wwnn));
+
+	dma_free_coherent(&efc->pci->dev, nport->dma.size, nport->dma.virt,
+			  nport->dma.phys);
+	memset(&nport->dma, 0, sizeof(struct efc_dma));
+	efc_nport_alloc_init_vpi(nport);
+	return 0;
+}
+
+static void
+efc_nport_alloc_read_sparm64(struct efc *efc, struct efc_nport *nport)
+{
+	u8 data[SLI4_BMBX_SIZE];
+	int rc;
+
+	/* Allocate memory for the service parameters */
+	nport->dma.size = EFC_SPARAM_DMA_SZ;
+	nport->dma.virt = dma_alloc_coherent(&efc->pci->dev,
+					     nport->dma.size, &nport->dma.phys,
+					     GFP_DMA);
+	if (!nport->dma.virt) {
+		efc_log_err(efc, "Failed to allocate DMA memory\n");
+		efc_nport_free_resources(nport, EFC_EVT_NPORT_ALLOC_FAIL, data);
+		return;
+	}
+
+	rc = sli_cmd_read_sparm64(efc->sli, data,
+				  &nport->dma, nport->indicator);
+	if (rc) {
+		efc_log_err(efc, "READ_SPARM64 format failure\n");
+		efc_nport_free_resources(nport, EFC_EVT_NPORT_ALLOC_FAIL, data);
+		return;
+	}
+
+	rc = efc->tt.issue_mbox_rqst(efc->base, data,
+				     efc_nport_alloc_read_sparm64_cb, nport);
+	if (rc) {
+		efc_log_err(efc, "READ_SPARM64 command failure\n");
+		efc_nport_free_resources(nport, EFC_EVT_NPORT_ALLOC_FAIL, data);
+	}
+}
+
+int
+efc_cmd_nport_alloc(struct efc *efc, struct efc_nport *nport,
+		    struct efc_domain *domain, u8 *wwpn)
+{
+	u32 index;
+
+	nport->indicator = U32_MAX;
+	nport->free_req_pending = false;
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
+		return -EIO;
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
+		/* domain NULL and wwpn non-NULL */
+		efc_log_err(efc, "need WWN for physical port\n");
+		sli_resource_free(efc->sli, SLI4_RSRC_VPI, nport->indicator);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int
+efc_nport_attach_reg_vpi_cb(struct efc *efc, int status, u8 *mqe,
+			    void *arg)
+{
+	struct efc_nport *nport = arg;
+
+	if (efc_nport_get_mbox_status(nport, mqe, status)) {
+		efc_nport_free_resources(nport, EFC_EVT_NPORT_ATTACH_FAIL, mqe);
+		return -EIO;
+	}
+
+	efc_nport_send_evt(nport, EFC_EVT_NPORT_ATTACH_OK, mqe);
+	return 0;
+}
+
+int
+efc_cmd_nport_attach(struct efc *efc, struct efc_nport *nport, u32 fc_id)
+{
+	u8 buf[SLI4_BMBX_SIZE];
+	int rc = 0;
+
+	if (!nport) {
+		efc_log_err(efc, "bad param(s) nport=%p\n", nport);
+		return -EIO;
+	}
+
+	nport->fc_id = fc_id;
+
+	/* register previously-allocated VPI with the device */
+	rc = sli_cmd_reg_vpi(efc->sli, buf, nport->fc_id,
+			     nport->sli_wwpn, nport->indicator,
+			    nport->domain->indicator, false);
+	if (rc) {
+		efc_log_err(efc, "REG_VPI format failure\n");
+		efc_nport_free_resources(nport, EFC_EVT_NPORT_ATTACH_FAIL, buf);
+		return rc;
+	}
+
+	rc = efc->tt.issue_mbox_rqst(efc->base, buf,
+				     efc_nport_attach_reg_vpi_cb, nport);
+	if (rc) {
+		efc_log_err(efc, "REG_VPI command failure\n");
+		efc_nport_free_resources(nport, EFC_EVT_NPORT_ATTACH_FAIL, buf);
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
+		return -EIO;
+	}
+
+	/* Issue the UNREG_VPI command to free the assigned VPI context */
+	if (nport->attached)
+		efc_nport_free_unreg_vpi(nport);
+	else
+		nport->free_req_pending = true;
+
+	return 0;
+}
+
+static int
+efc_domain_get_mbox_status(struct efc_domain *domain, u8 *mqe, int status)
+{
+	struct efc *efc = domain->efc;
+	struct sli4_mbox_command_header *hdr =
+			(struct sli4_mbox_command_header *)mqe;
+
+	if (status || le16_to_cpu(hdr->status)) {
+		efc_log_debug(efc, "bad status vfi=%#x st=%x hdr=%x\n",
+			      domain->indicator, status,
+			      le16_to_cpu(hdr->status));
+		return -EIO;
+	}
+
+	return 0;
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
+			  int port_evt, int domain_evt, void *data)
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
+
+	if (efc_domain_get_mbox_status(domain, mqe, status)) {
+		efc_domain_free_resources(domain,
+					  EFC_HW_DOMAIN_ALLOC_FAIL, mqe);
+		return -EIO;
+	}
+
+	efc_domain_send_nport_evt(domain, EFC_EVT_NPORT_ALLOC_OK,
+				  EFC_HW_DOMAIN_ALLOC_OK, mqe);
+	return 0;
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
+					  EFC_HW_DOMAIN_ALLOC_FAIL, data);
+		return;
+	}
+
+	rc = efc->tt.issue_mbox_rqst(efc->base, data,
+				     efc_domain_alloc_read_sparm64_cb, domain);
+	if (rc) {
+		efc_log_err(efc, "READ_SPARM64 command failure\n");
+		efc_domain_free_resources(domain,
+					  EFC_HW_DOMAIN_ALLOC_FAIL, data);
+	}
+}
+
+static int
+efc_domain_alloc_init_vfi_cb(struct efc *efc, int status, u8 *mqe,
+			     void *arg)
+{
+	struct efc_domain *domain = arg;
+
+	if (efc_domain_get_mbox_status(domain, mqe, status)) {
+		efc_domain_free_resources(domain,
+					  EFC_HW_DOMAIN_ALLOC_FAIL, mqe);
+		return -EIO;
+	}
+
+	efc_domain_alloc_read_sparm64(domain);
+	return 0;
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
+					  EFC_HW_DOMAIN_ALLOC_FAIL, data);
+		return;
+	}
+
+	efc_log_err(efc, "%s issue mbox\n", __func__);
+	rc = efc->tt.issue_mbox_rqst(efc->base, data,
+				     efc_domain_alloc_init_vfi_cb, domain);
+	if (rc) {
+		efc_log_err(efc, "INIT_VFI command failure\n");
+		efc_domain_free_resources(domain,
+					  EFC_HW_DOMAIN_ALLOC_FAIL, data);
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
+		return -EIO;
+	}
+
+	/* allocate memory for the service parameters */
+	domain->dma.size = EFC_SPARAM_DMA_SZ;
+	domain->dma.virt = dma_alloc_coherent(&efc->pci->dev,
+					      domain->dma.size,
+					      &domain->dma.phys, GFP_DMA);
+	if (!domain->dma.virt) {
+		efc_log_err(efc, "Failed to allocate DMA memory\n");
+		return -EIO;
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
+		return -EIO;
+	}
+
+	efc_domain_alloc_init_vfi(domain);
+	return 0;
+}
+
+static int
+efc_domain_attach_reg_vfi_cb(struct efc *efc, int status, u8 *mqe,
+			     void *arg)
+{
+	struct efc_domain *domain = arg;
+
+	if (efc_domain_get_mbox_status(domain, mqe, status)) {
+		efc_domain_free_resources(domain,
+					  EFC_HW_DOMAIN_ATTACH_FAIL, mqe);
+		return -EIO;
+	}
+
+	efc_domain_send_nport_evt(domain, EFC_EVT_NPORT_ATTACH_OK,
+				  EFC_HW_DOMAIN_ATTACH_OK, mqe);
+	return 0;
+}
+
+int
+efc_cmd_domain_attach(struct efc *efc, struct efc_domain *domain, u32 fc_id)
+{
+	u8 buf[SLI4_BMBX_SIZE];
+	int rc = 0;
+
+	if (!domain) {
+		efc_log_err(efc, "bad param(s) domain=%p\n", domain);
+		return -EIO;
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
+	int rc;
+
+	rc = efc_domain_get_mbox_status(domain, mqe, status);
+	if (rc) {
+		evt = EFC_HW_DOMAIN_FREE_FAIL;
+		rc = -EIO;
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
+	if (!domain) {
+		efc_log_err(efc, "bad parameter(s) domain=%p\n", domain);
+		return -EIO;
+	}
+
+	efc_domain_free_unreg_vfi(domain);
+	return 0;
+}
+
+int
+efc_cmd_node_alloc(struct efc *efc, struct efc_remote_node *rnode, u32 fc_addr,
+		   struct efc_nport *nport)
+{
+	/* Check for invalid indicator */
+	if (rnode->indicator != U32_MAX) {
+		efc_log_err(efc,
+			    "RPI allocation failure addr=%#x rpi=%#x\n",
+			    fc_addr, rnode->indicator);
+		return -EIO;
+	}
+
+	/* NULL SLI port indicates an unallocated remote node */
+	rnode->nport = NULL;
+
+	if (sli_resource_alloc(efc->sli, SLI4_RSRC_RPI,
+			       &rnode->indicator, &rnode->index)) {
+		efc_log_err(efc, "RPI allocation failure addr=%#x\n",
+			    fc_addr);
+		return -EIO;
+	}
+
+	rnode->fc_id = fc_addr;
+	rnode->nport = nport;
+
+	return 0;
+}
+
+static int
+efc_cmd_node_attach_cb(struct efc *efc, int status, u8 *mqe, void *arg)
+{
+	struct efc_remote_node *rnode = arg;
+	struct sli4_mbox_command_header *hdr =
+				(struct sli4_mbox_command_header *)mqe;
+	int evt = 0;
+
+	if (status || le16_to_cpu(hdr->status)) {
+		efc_log_debug(efc, "bad status cqe=%#x mqe=%#x\n", status,
+			      le16_to_cpu(hdr->status));
+		rnode->attached = false;
+		evt = EFC_EVT_NODE_ATTACH_FAIL;
+	} else {
+		rnode->attached = true;
+		evt = EFC_EVT_NODE_ATTACH_OK;
+	}
+
+	efc_remote_node_cb(efc, evt, rnode);
+
+	return 0;
+}
+
+int
+efc_cmd_node_attach(struct efc *efc, struct efc_remote_node *rnode,
+		    struct efc_dma *sparms)
+{
+	int rc = -EIO;
+	u8 buf[SLI4_BMBX_SIZE];
+
+	if (!rnode || !sparms) {
+		efc_log_err(efc, "bad parameter(s) rnode=%p sparms=%p\n",
+			    rnode, sparms);
+		return -EIO;
+	}
+
+	/*
+	 * If the attach count is non-zero, this RPI has already been reg'd.
+	 * Otherwise, register the RPI
+	 */
+	if (rnode->index == U32_MAX) {
+		efc_log_err(efc, "bad parameter rnode->index invalid\n");
+		return -EIO;
+	}
+
+	/* Update a remote node object with the remote port's service params */
+	if (!sli_cmd_reg_rpi(efc->sli, buf, rnode->indicator,
+			     rnode->nport->indicator, rnode->fc_id, sparms, 0, 0))
+		rc = efc->tt.issue_mbox_rqst(efc->base, buf,
+					     efc_cmd_node_attach_cb, rnode);
+
+	return rc;
+}
+
+int
+efc_node_free_resources(struct efc *efc, struct efc_remote_node *rnode)
+{
+	int rc = 0;
+
+	if (!rnode) {
+		efc_log_err(efc, "bad parameter rnode=%p\n", rnode);
+		return -EIO;
+	}
+
+	if (rnode->nport) {
+		if (rnode->attached) {
+			efc_log_err(efc, "rnode is still attached\n");
+			return -EIO;
+		}
+		if (rnode->indicator != U32_MAX) {
+			if (sli_resource_free(efc->sli, SLI4_RSRC_RPI,
+					      rnode->indicator)) {
+				efc_log_err(efc,
+					    "RPI free fail RPI %d addr=%#x\n",
+					    rnode->indicator, rnode->fc_id);
+				rc = -EIO;
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
+	int evt = EFC_EVT_NODE_FREE_FAIL;
+	int rc = 0;
+
+	if (status || le16_to_cpu(hdr->status)) {
+		efc_log_debug(efc, "bad status cqe=%#x mqe=%#x\n", status,
+			      le16_to_cpu(hdr->status));
+
+		/*
+		 * In certain cases, a non-zero MQE status is OK (all must be
+		 * true):
+		 *   - node is attached
+		 *   - status is 0x1400
+		 */
+		if (!rnode->attached ||
+		    (le16_to_cpu(hdr->status) != SLI4_MBX_STATUS_RPI_NOT_REG))
+			rc = -EIO;
+	}
+
+	if (!rc) {
+		rnode->attached = false;
+		evt = EFC_EVT_NODE_FREE_OK;
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
+	int rc = -EIO;
+
+	if (!rnode) {
+		efc_log_err(efc, "bad parameter rnode=%p\n", rnode);
+		return -EIO;
+	}
+
+	if (rnode->nport) {
+		if (!rnode->attached)
+			return -EIO;
+
+		rc = -EIO;
+
+		if (!sli_cmd_unreg_rpi(efc->sli, buf, rnode->indicator,
+				       SLI4_RSRC_RPI, U32_MAX))
+			rc = efc->tt.issue_mbox_rqst(efc->base, buf,
+					efc_cmd_node_free_cb, rnode);
+
+		if (rc != 0) {
+			efc_log_err(efc, "UNREG_RPI failed\n");
+			rc = -EIO;
+		}
+	}
+
+	return rc;
+}
diff --git a/drivers/scsi/elx/libefc/efc_cmds.h b/drivers/scsi/elx/libefc/efc_cmds.h
new file mode 100644
index 000000000000..4d353ab04dc3
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_cmds.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#ifndef __EFC_CMDS_H__
+#define __EFC_CMDS_H__
+
+#define EFC_SPARAM_DMA_SZ	112
+int
+efc_cmd_nport_alloc(struct efc *efc, struct efc_nport *nport,
+		    struct efc_domain *domain, u8 *wwpn);
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

