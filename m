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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF3FBC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 23:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A21A261476
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 23:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244262AbhDWXhr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 19:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244173AbhDWXgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2021 19:36:10 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB66C061350
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 16:35:24 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id m12so15488161pgr.9
        for <linux-scsi@vger.kernel.org>; Fri, 23 Apr 2021 16:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SZV8B2tdq47F10sQugBXOFQL+7CuORJYNK2/niqBsGQ=;
        b=G2+XGKdN4fIQKxF0IFSo8mjA8bMlIaxrpL1oCnN1h/M5zTiRBg9bP7JHGlsWw0p5Yi
         Ebnhtq0aVoOdYf5eIfs+YJiKPIJI4v5riElJzrdInoh7tBMyAVxhjJb+8ztq0tkBq97H
         kjAfl4Cj3ezijrP5u4yXtaRZxNjFBC3e4t2/rlYsL5NJ2kJW4NxCB2cABwNC7e63LB6S
         4SackwZdfsU0ElKtW5LzkZEsYDtkjp44WgUwfXf7tKNrwfqlag2b3aivJwVTi/J+gyex
         KuZRZfpV5Zepf9Hh6NnoQW1turXx2Lf+gxDvNB8885/1/d8F4F8BOkAKe64fTpiKfYxS
         o9gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SZV8B2tdq47F10sQugBXOFQL+7CuORJYNK2/niqBsGQ=;
        b=cPWSdFIELr2NkEfOhwwNC9UGeu0oKupA/fFMJdqbReC3OFDfT/P37hl9Hd07YzBlUD
         O2MTUvs4Qrn0qBbtA5f25WLIiZgrGqCbHSfb7sTyhfLzTuxETqLEkiH9fSUXmk+zrCmF
         1b99M/JhYvG0m6O3OCbAyEKy+ABjcfI5xhnt528eZZ30+sIc+qt+f8qdTlk3Xa4J/ZjG
         kf59rTzVbPMOrQLeG4M1X2PBzeKlGNsY5Kg6ormsP1R5EGrhMJ1oYPv37wfasAsZkIO2
         YkE0pc3PhqMGKp6o9RshE0dCTTRhGr0QvCQm1HyNxuooAifgBmur5i18cBxLZUJl7V3/
         bKgg==
X-Gm-Message-State: AOAM531Exynb+qrfXGUZY8PY3Qa8mPnddAh/qPXuie1TzSSZgLFe4Nta
        IQbXFONODxZ9DVvEvBqRk8xKHmrJSIc=
X-Google-Smtp-Source: ABdhPJxZZOKsH9F1efVFwRgeIt4qYpqMFIGsg/9rSC5Zefa+NgONhsc9+Rvfa4FzjSRUBcCzJh+Xsg==
X-Received: by 2002:a65:4b8c:: with SMTP id t12mr6250183pgq.257.1619220923338;
        Fri, 23 Apr 2021 16:35:23 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v123sm5346892pfb.80.2021.04.23.16.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 16:35:23 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH v8 29/31] elx: efct: scsi_transport_fc host interface support
Date:   Fri, 23 Apr 2021 16:34:53 -0700
Message-Id: <20210423233455.27243-30-jsmart2021@gmail.com>
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
Integration with the scsi_fc_transport host interfaces

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>

---
v8:
Remove unused stubs.
Add 64G and 128G to host speed reporting.
Use link speed to detect the port state.
---
 drivers/scsi/elx/efct/efct_xport.c | 466 ++++++++++++++++++++++++++++-
 1 file changed, 450 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
index b34b3af8e9c0..ba1af536ad0d 100644
--- a/drivers/scsi/elx/efct/efct_xport.c
+++ b/drivers/scsi/elx/efct/efct_xport.c
@@ -300,7 +300,6 @@ efct_xport_status(struct efct_xport *xport, enum efct_xport_status cmd,
 			result->value = EFCT_XPORT_PORT_OFFLINE;
 		else
 			result->value = EFCT_XPORT_PORT_ONLINE;
-		rc = 0;
 		break;
 
 	case EFCT_XPORT_LINK_SPEED:
@@ -508,7 +507,7 @@ efct_scsi_release_fc_transport(void)
 	efct_vport_fc_tt = NULL;
 }
 
-int
+void
 efct_xport_detach(struct efct_xport *xport)
 {
 	struct efct *efct = xport->efct;
@@ -525,8 +524,6 @@ efct_xport_detach(struct efct_xport *xport)
 	efct_hw_teardown(&efct->hw);
 
 	efct_xport_delete_debugfs(efct);
-
-	return EFC_SUCCESS;
 }
 
 static void
@@ -555,7 +552,7 @@ efct_xport_post_node_event_cb(struct efct_hw *hw, int status,
 int
 efct_xport_control(struct efct_xport *xport, enum efct_xport_ctrl cmd, ...)
 {
-	u32 rc = 0;
+	u32 rc = EFC_SUCCESS;
 	struct efct *efct = NULL;
 	va_list argp;
 
@@ -657,7 +654,7 @@ efct_xport_control(struct efct_xport *xport, enum efct_xport_ctrl cmd, ...)
 			efc_log_debug(efct, "node %p state machine disabled\n",
 				      node);
 			kfree(payload);
-			rc = -1;
+			rc = EFC_FAIL;
 			break;
 		}
 
@@ -674,7 +671,7 @@ efct_xport_control(struct efct_xport *xport, enum efct_xport_ctrl cmd, ...)
 				       payload)) {
 			efc_log_debug(efct, "efct_hw_async_call failed\n");
 			kfree(payload);
-			rc = -1;
+			rc = EFC_FAIL;
 			break;
 		}
 
@@ -682,7 +679,7 @@ efct_xport_control(struct efct_xport *xport, enum efct_xport_ctrl cmd, ...)
 		if (wait_for_completion_interruptible(&payload->done)) {
 			efc_log_debug(efct,
 				      "POST_NODE_EVENT: completion failed\n");
-			rc = -1;
+			rc = EFC_FAIL;
 		}
 		if (atomic_sub_and_test(1, &payload->refcnt))
 			kfree(payload);
@@ -756,15 +753,452 @@ efct_xport_remove_host(struct Scsi_Host *shost)
 	fc_remove_host(shost);
 }
 
-int efct_scsi_del_device(struct efct *efct)
+void
+efct_scsi_del_device(struct efct *efct)
+{
+	if (!efct->shost)
+		return;
+
+	efc_log_debug(efct, "Unregistering with Transport Layer\n");
+	efct_xport_remove_host(efct->shost);
+	efc_log_debug(efct, "Unregistering with SCSI Midlayer\n");
+	scsi_remove_host(efct->shost);
+	scsi_host_put(efct->shost);
+	efct->shost = NULL;
+}
+
+static void
+efct_get_host_port_id(struct Scsi_Host *shost)
+{
+	struct efct_vport *vport = (struct efct_vport *)shost->hostdata;
+	struct efct *efct = vport->efct;
+	struct efc *efc = efct->efcport;
+	struct efc_nport *nport;
+
+	if (efc->domain && efc->domain->nport) {
+		nport = efc->domain->nport;
+		fc_host_port_id(shost) = nport->fc_id;
+	}
+}
+
+static void
+efct_get_host_port_type(struct Scsi_Host *shost)
+{
+	struct efct_vport *vport = (struct efct_vport *)shost->hostdata;
+	struct efct *efct = vport->efct;
+	struct efc *efc = efct->efcport;
+	int type = FC_PORTTYPE_UNKNOWN;
+
+	if (efc->domain && efc->domain->nport) {
+		if (efc->domain->is_loop) {
+			type = FC_PORTTYPE_LPORT;
+		} else {
+			struct efc_nport *nport = efc->domain->nport;
+
+			if (nport->is_vport)
+				type = FC_PORTTYPE_NPIV;
+			else if (nport->topology == EFC_NPORT_TOPO_P2P)
+				type = FC_PORTTYPE_PTP;
+			else if (nport->topology == EFC_NPORT_TOPO_UNKNOWN)
+				type = FC_PORTTYPE_UNKNOWN;
+			else
+				type = FC_PORTTYPE_NPORT;
+		}
+	}
+	fc_host_port_type(shost) = type;
+}
+
+static void
+efct_get_host_vport_type(struct Scsi_Host *shost)
+{
+	fc_host_port_type(shost) = FC_PORTTYPE_NPIV;
+}
+
+static void
+efct_get_host_port_state(struct Scsi_Host *shost)
+{
+	struct efct_vport *vport = (struct efct_vport *)shost->hostdata;
+	struct efct *efct = vport->efct;
+	union efct_xport_stats_u status;
+	int rc;
+
+	rc = efct_xport_status(efct->xport, EFCT_XPORT_PORT_STATUS, &status);
+	if ((!rc) && (status.value == EFCT_XPORT_PORT_ONLINE))
+		fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
+	else
+		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
+}
+
+static void
+efct_get_host_speed(struct Scsi_Host *shost)
+{
+	struct efct_vport *vport = (struct efct_vport *)shost->hostdata;
+	struct efct *efct = vport->efct;
+	struct efc *efc = efct->efcport;
+	union efct_xport_stats_u speed;
+	u32 fc_speed = FC_PORTSPEED_UNKNOWN;
+	int rc;
+
+	if (!efc->domain || !efc->domain->nport) {
+		fc_host_speed(shost) = fc_speed;
+		return;
+	}
+
+	rc = efct_xport_status(efct->xport, EFCT_XPORT_LINK_SPEED, &speed);
+	if (!rc) {
+		switch (speed.value) {
+		case 1000:
+			fc_speed = FC_PORTSPEED_1GBIT;
+			break;
+		case 2000:
+			fc_speed = FC_PORTSPEED_2GBIT;
+			break;
+		case 4000:
+			fc_speed = FC_PORTSPEED_4GBIT;
+			break;
+		case 8000:
+			fc_speed = FC_PORTSPEED_8GBIT;
+			break;
+		case 10000:
+			fc_speed = FC_PORTSPEED_10GBIT;
+			break;
+		case 16000:
+			fc_speed = FC_PORTSPEED_16GBIT;
+			break;
+		case 32000:
+			fc_speed = FC_PORTSPEED_32GBIT;
+			break;
+		case 64000:
+			fc_speed = FC_PORTSPEED_64GBIT;
+			break;
+		case 128000:
+			fc_speed = FC_PORTSPEED_128GBIT;
+			break;
+		}
+	}
+
+	fc_host_speed(shost) = fc_speed;
+}
+
+static void
+efct_get_host_fabric_name(struct Scsi_Host *shost)
+{
+	struct efct_vport *vport = (struct efct_vport *)shost->hostdata;
+	struct efct *efct = vport->efct;
+	struct efc *efc = efct->efcport;
+
+	if (efc->domain) {
+		struct fc_els_flogi  *sp =
+			(struct fc_els_flogi  *)
+				efc->domain->flogi_service_params;
+
+		fc_host_fabric_name(shost) = be64_to_cpu(sp->fl_wwnn);
+	}
+}
+
+static struct fc_host_statistics *
+efct_get_stats(struct Scsi_Host *shost)
+{
+	struct efct_vport *vport = (struct efct_vport *)shost->hostdata;
+	struct efct *efct = vport->efct;
+	union efct_xport_stats_u stats;
+	struct efct_xport *xport = efct->xport;
+	int rc = EFC_SUCCESS;
+
+	rc = efct_xport_status(xport, EFCT_XPORT_LINK_STATISTICS, &stats);
+	if (rc) {
+		pr_err("efct_xport_status returned non 0 - %d\n", rc);
+		return NULL;
+	}
+
+	vport->fc_host_stats.loss_of_sync_count =
+		stats.stats.link_stats.loss_of_sync_error_count;
+	vport->fc_host_stats.link_failure_count =
+		stats.stats.link_stats.link_failure_error_count;
+	vport->fc_host_stats.prim_seq_protocol_err_count =
+		stats.stats.link_stats.primitive_sequence_error_count;
+	vport->fc_host_stats.invalid_tx_word_count =
+		stats.stats.link_stats.invalid_transmission_word_error_count;
+	vport->fc_host_stats.invalid_crc_count =
+		stats.stats.link_stats.crc_error_count;
+	/* mbox returns kbyte count so we need to convert to words */
+	vport->fc_host_stats.tx_words =
+		stats.stats.host_stats.transmit_kbyte_count * 256;
+	/* mbox returns kbyte count so we need to convert to words */
+	vport->fc_host_stats.rx_words =
+		stats.stats.host_stats.receive_kbyte_count * 256;
+	vport->fc_host_stats.tx_frames =
+		stats.stats.host_stats.transmit_frame_count;
+	vport->fc_host_stats.rx_frames =
+		stats.stats.host_stats.receive_frame_count;
+
+	vport->fc_host_stats.fcp_input_requests =
+			xport->fcp_stats.input_requests;
+	vport->fc_host_stats.fcp_output_requests =
+			xport->fcp_stats.output_requests;
+	vport->fc_host_stats.fcp_output_megabytes =
+			xport->fcp_stats.output_bytes >> 20;
+	vport->fc_host_stats.fcp_input_megabytes =
+			xport->fcp_stats.input_bytes >> 20;
+	vport->fc_host_stats.fcp_control_requests =
+			xport->fcp_stats.control_requests;
+
+	return &vport->fc_host_stats;
+}
+
+static void
+efct_reset_stats(struct Scsi_Host *shost)
+{
+	struct efct_vport *vport = (struct efct_vport *)shost->hostdata;
+	struct efct *efct = vport->efct;
+	/* argument has no purpose for this action */
+	union efct_xport_stats_u dummy;
+	int rc;
+
+	rc = efct_xport_status(efct->xport, EFCT_XPORT_LINK_STAT_RESET, &dummy);
+	if (rc)
+		pr_err("efct_xport_status returned non 0 - %d\n", rc);
+}
+
+static int
+efct_issue_lip(struct Scsi_Host *shost)
 {
-	if (efct->shost) {
-		efc_log_debug(efct, "Unregistering with Transport Layer\n");
-		efct_xport_remove_host(efct->shost);
-		efc_log_debug(efct, "Unregistering with SCSI Midlayer\n");
-		scsi_remove_host(efct->shost);
-		scsi_host_put(efct->shost);
-		efct->shost = NULL;
+	struct efct_vport *vport =
+			shost ? (struct efct_vport *)shost->hostdata : NULL;
+	struct efct *efct = vport ? vport->efct : NULL;
+
+	if (!shost || !vport || !efct) {
+		pr_err("%s: shost=%p vport=%p efct=%p\n", __func__,
+		       shost, vport, efct);
+		return -EPERM;
 	}
+
+	/*
+	 * Bring the link down gracefully then re-init the link.
+	 * The firmware will re-initialize the Fibre Channel interface as
+	 * required. It does not issue a LIP.
+	 */
+
+	if (efct_xport_control(efct->xport, EFCT_XPORT_PORT_OFFLINE))
+		efc_log_debug(efct, "EFCT_XPORT_PORT_OFFLINE failed\n");
+
+	if (efct_xport_control(efct->xport, EFCT_XPORT_PORT_ONLINE))
+		efc_log_debug(efct, "EFCT_XPORT_PORT_ONLINE failed\n");
+
 	return EFC_SUCCESS;
 }
+
+struct efct_vport *
+efct_scsi_new_vport(struct efct *efct, struct device *dev)
+{
+	struct Scsi_Host *shost = NULL;
+	int error = 0;
+	struct efct_vport *vport = NULL;
+
+	shost = scsi_host_alloc(&efct_template, sizeof(*vport));
+	if (!shost) {
+		efc_log_err(efct, "failed to allocate Scsi_Host struct\n");
+		return NULL;
+	}
+
+	/* save efct information to shost LLD-specific space */
+	vport = (struct efct_vport *)shost->hostdata;
+	vport->efct = efct;
+	vport->is_vport = true;
+
+	shost->can_queue = efct->hw.config.n_io;
+	shost->max_cmd_len = 16; /* 16-byte CDBs */
+	shost->max_id = 0xffff;
+	shost->max_lun = 0xffffffff;
+
+	/* can only accept (from mid-layer) as many SGEs as we've pre-regited*/
+	shost->sg_tablesize = sli_get_max_sgl(&efct->hw.sli);
+
+	/* attach FC Transport template to shost */
+	shost->transportt = efct_vport_fc_tt;
+	efc_log_debug(efct, "vport transport template=%p\n",
+		       efct_vport_fc_tt);
+
+	/* get pci_dev structure and add host to SCSI ML */
+	error = scsi_add_host_with_dma(shost, dev, &efct->pci->dev);
+	if (error) {
+		efc_log_debug(efct, "failed scsi_add_host_with_dma\n");
+		return NULL;
+	}
+
+	/* Set symbolic name for host port */
+	snprintf(fc_host_symbolic_name(shost),
+		 sizeof(fc_host_symbolic_name(shost)),
+		 "Emulex %s FV%s DV%s", efct->model, efct->hw.sli.fw_name[0],
+		 EFCT_DRIVER_VERSION);
+
+	/* Set host port supported classes */
+	fc_host_supported_classes(shost) = FC_COS_CLASS3;
+
+	fc_host_supported_speeds(shost) = efct_get_link_supported_speeds(efct);
+	vport->shost = shost;
+
+	return vport;
+}
+
+int efct_scsi_del_vport(struct efct *efct, struct Scsi_Host *shost)
+{
+	if (shost) {
+		efc_log_debug(efct,
+				"Unregistering vport with Transport Layer\n");
+		efct_xport_remove_host(shost);
+		efc_log_debug(efct, "Unregistering vport with SCSI Midlayer\n");
+		scsi_remove_host(shost);
+		scsi_host_put(shost);
+		return EFC_SUCCESS;
+	}
+	return EFC_FAIL;
+}
+
+static int
+efct_vport_create(struct fc_vport *fc_vport, bool disable)
+{
+	struct Scsi_Host *shost = fc_vport ? fc_vport->shost : NULL;
+	struct efct_vport *pport = shost ?
+					(struct efct_vport *)shost->hostdata :
+					NULL;
+	struct efct *efct = pport ? pport->efct : NULL;
+	struct efct_vport *vport = NULL;
+
+	if (!fc_vport || !shost || !efct)
+		goto fail;
+
+	vport = efct_scsi_new_vport(efct, &fc_vport->dev);
+	if (!vport) {
+		efc_log_err(efct, "failed to create vport\n");
+		goto fail;
+	}
+
+	vport->fc_vport = fc_vport;
+	vport->npiv_wwpn = fc_vport->port_name;
+	vport->npiv_wwnn = fc_vport->node_name;
+	fc_host_node_name(vport->shost) = vport->npiv_wwnn;
+	fc_host_port_name(vport->shost) = vport->npiv_wwpn;
+	*(struct efct_vport **)fc_vport->dd_data = vport;
+
+	return EFC_SUCCESS;
+
+fail:
+	return EFC_FAIL;
+}
+
+static int
+efct_vport_delete(struct fc_vport *fc_vport)
+{
+	struct efct_vport *vport = *(struct efct_vport **)fc_vport->dd_data;
+	struct Scsi_Host *shost = vport ? vport->shost : NULL;
+	struct efct *efct = vport ? vport->efct : NULL;
+	int rc;
+
+	rc = efct_scsi_del_vport(efct, shost);
+
+	if (rc)
+		pr_err("%s: vport delete failed\n", __func__);
+
+	return rc;
+}
+
+static int
+efct_vport_disable(struct fc_vport *fc_vport, bool disable)
+{
+	return EFC_SUCCESS;
+}
+
+static struct fc_function_template efct_xport_functions = {
+	.get_host_port_id = efct_get_host_port_id,
+	.get_host_port_type = efct_get_host_port_type,
+	.get_host_port_state = efct_get_host_port_state,
+	.get_host_speed = efct_get_host_speed,
+	.get_host_fabric_name = efct_get_host_fabric_name,
+
+	.get_fc_host_stats = efct_get_stats,
+	.reset_fc_host_stats = efct_reset_stats,
+
+	.issue_fc_host_lip = efct_issue_lip,
+
+	.vport_disable = efct_vport_disable,
+
+	/* allocation lengths for host-specific data */
+	.dd_fcrport_size = sizeof(struct efct_rport_data),
+	.dd_fcvport_size = 128, /* should be sizeof(...) */
+
+	/* remote port fixed attributes */
+	.show_rport_maxframe_size = 1,
+	.show_rport_supported_classes = 1,
+	.show_rport_dev_loss_tmo = 1,
+
+	/* target dynamic attributes */
+	.show_starget_node_name = 1,
+	.show_starget_port_name = 1,
+	.show_starget_port_id = 1,
+
+	/* host fixed attributes */
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+	.show_host_supported_classes = 1,
+	.show_host_supported_fc4s = 1,
+	.show_host_supported_speeds = 1,
+	.show_host_maxframe_size = 1,
+
+	/* host dynamic attributes */
+	.show_host_port_id = 1,
+	.show_host_port_type = 1,
+	.show_host_port_state = 1,
+	/* active_fc4s is shown but doesn't change (thus no get function) */
+	.show_host_active_fc4s = 1,
+	.show_host_speed = 1,
+	.show_host_fabric_name = 1,
+	.show_host_symbolic_name = 1,
+	.vport_create = efct_vport_create,
+	.vport_delete = efct_vport_delete,
+};
+
+static struct fc_function_template efct_vport_functions = {
+	.get_host_port_id = efct_get_host_port_id,
+	.get_host_port_type = efct_get_host_vport_type,
+	.get_host_port_state = efct_get_host_port_state,
+	.get_host_speed = efct_get_host_speed,
+	.get_host_fabric_name = efct_get_host_fabric_name,
+
+	.get_fc_host_stats = efct_get_stats,
+	.reset_fc_host_stats = efct_reset_stats,
+
+	.issue_fc_host_lip = efct_issue_lip,
+
+	/* allocation lengths for host-specific data */
+	.dd_fcrport_size = sizeof(struct efct_rport_data),
+	.dd_fcvport_size = 128, /* should be sizeof(...) */
+
+	/* remote port fixed attributes */
+	.show_rport_maxframe_size = 1,
+	.show_rport_supported_classes = 1,
+	.show_rport_dev_loss_tmo = 1,
+
+	/* target dynamic attributes */
+	.show_starget_node_name = 1,
+	.show_starget_port_name = 1,
+	.show_starget_port_id = 1,
+
+	/* host fixed attributes */
+	.show_host_node_name = 1,
+	.show_host_port_name = 1,
+	.show_host_supported_classes = 1,
+	.show_host_supported_fc4s = 1,
+	.show_host_supported_speeds = 1,
+	.show_host_maxframe_size = 1,
+
+	/* host dynamic attributes */
+	.show_host_port_id = 1,
+	.show_host_port_type = 1,
+	.show_host_port_state = 1,
+	/* active_fc4s is shown but doesn't change (thus no get function) */
+	.show_host_active_fc4s = 1,
+	.show_host_speed = 1,
+	.show_host_fabric_name = 1,
+	.show_host_symbolic_name = 1,
+};
-- 
2.26.2

