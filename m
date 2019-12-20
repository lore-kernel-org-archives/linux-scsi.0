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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18D63C2D0D2
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7DA62082E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:38:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mkB0JDiZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfLTWiK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:38:10 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40111 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbfLTWiH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:38:07 -0500
Received: by mail-pj1-f65.google.com with SMTP id bg7so4258280pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Jz7Ww/95G2zY6LNy4C+VHmj/WluDk/AhpMj8yBIJDdw=;
        b=mkB0JDiZmMfp8F7kFmh7pJkM84RCfeGky3uU6o7lmPpAQST5tvTz1S/LdgeBElE3FU
         to9JNiYYpqvqHSfIRXbpcJGczAUPyTOnjsGw+5EtYjqvNNF2vo0BHcSfK5l9qhpyCO2/
         A6tBzWvBcwmJhWBi2kvx3t60+gS+Ma9urAR7hnogKTz6XOiKMuhx9bBTVF38aHcGEaFW
         QImK443olP51vO0mfmwDl5x2fr0hrNeWOv4/wT6s9OaL4EhmtF5bUstjGJCZvxCtGV9d
         3ZP1O9pv91vqzAzFitHtaeFrTmfupC0u1X5Nf/HtfaD1xMA6gM2usKfGBZl7LnKgorat
         zovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Jz7Ww/95G2zY6LNy4C+VHmj/WluDk/AhpMj8yBIJDdw=;
        b=tEwwLyJBy6ojCsM/4x6v9aG+GCjpKVXY3zRRXx6VuVYQ09XHfIKXWrsC4f3R28r625
         H7RDY1hreoDhnUweM98+QvqoYS2uJbuwAvVQ3RcmihqLha4iqumqd3hiFNIfr2MH5qBy
         0glj2pv2cq8zP7aWOGjrJU/v2iHun8Y2uU0lrNtPeYJyMYHMoI7as/kuaha3FlFxH9/J
         NBtgZOMy6nmozLO20qtJCB3oAL3s870KUqh6glQO5f8XLRVLqVokd79Gpijteeb3XRSp
         5IbMs2nlI7GY7z74rEItovQ7Vb/26FQLET8/Yj+niM/8On+JGsDcXNBa9xoaCeqxb6fM
         0Zjg==
X-Gm-Message-State: APjAAAUCllLj1gJuK3pePGTAYzFk8FRDR1VUBKtt7pBPZ2ry64EReuYv
        A7i3hA8Hl8oY7/MnBAeXuqopVkEP
X-Google-Smtp-Source: APXvYqxPj1yrl6HCk33BLaWDrVljzxARJqvnCbU/hJFDT2cZlbmpxm2ZLpsOQ4FwL8J6T9SjW3Xqzg==
X-Received: by 2002:a17:902:9b84:: with SMTP id y4mr17095248plp.13.1576881485968;
        Fri, 20 Dec 2019 14:38:05 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.38.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:38:05 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 30/32] elx: efct: scsi_transport_fc host interface support
Date:   Fri, 20 Dec 2019 14:37:21 -0800
Message-Id: <20191220223723.26563-31-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191220223723.26563-1-jsmart2021@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Integration with the scsi_fc_transport host interfaces

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_xport.c | 496 +++++++++++++++++++++++++++++++++++++
 1 file changed, 496 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
index 6d8e0cefa903..024f65ee113a 100644
--- a/drivers/scsi/elx/efct/efct_xport.c
+++ b/drivers/scsi/elx/efct/efct_xport.c
@@ -974,3 +974,499 @@ int efct_scsi_del_device(struct efct *efct)
 	}
 	return 0;
 }
+
+static void
+efct_get_host_port_id(struct Scsi_Host *shost)
+{
+	struct efct_vport *vport = (struct efct_vport *)shost->hostdata;
+	struct efct *efct = vport->efct;
+	struct efc *efc = efct->efcport;
+	struct efc_sli_port *sport;
+
+	if (efc->domain && efc->domain->sport) {
+		sport = efc->domain->sport;
+		fc_host_port_id(shost) = sport->fc_id;
+	}
+}
+
+static void
+efct_get_host_port_type(struct Scsi_Host *shost)
+{
+	struct efct_vport *vport = (struct efct_vport *)shost->hostdata;
+	struct efct *efct = vport->efct;
+	struct efc *efc = efct->efcport;
+	struct efc_sli_port *sport;
+	int type = FC_PORTTYPE_UNKNOWN;
+
+	if (efc->domain && efc->domain->sport) {
+		if (efc->domain->is_loop) {
+			type = FC_PORTTYPE_LPORT;
+		} else {
+			sport = efc->domain->sport;
+			if (sport->is_vport)
+				type = FC_PORTTYPE_NPIV;
+			else if (sport->topology == EFC_SPORT_TOPOLOGY_P2P)
+				type = FC_PORTTYPE_PTP;
+			else if (sport->topology == EFC_SPORT_TOPOLOGY_UNKNOWN)
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
+	struct efc *efc = efct->efcport;
+
+	if (efc->domain)
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
+	if (efc->domain && efc->domain->sport) {
+		rc = efct_xport_status(efct->xport,
+				       EFCT_XPORT_LINK_SPEED, &speed);
+		if (rc == 0) {
+			switch (speed.value) {
+			case 1000:
+				fc_speed = FC_PORTSPEED_1GBIT;
+				break;
+			case 2000:
+				fc_speed = FC_PORTSPEED_2GBIT;
+				break;
+			case 4000:
+				fc_speed = FC_PORTSPEED_4GBIT;
+				break;
+			case 8000:
+				fc_speed = FC_PORTSPEED_8GBIT;
+				break;
+			case 10000:
+				fc_speed = FC_PORTSPEED_10GBIT;
+				break;
+			case 16000:
+				fc_speed = FC_PORTSPEED_16GBIT;
+				break;
+			case 32000:
+				fc_speed = FC_PORTSPEED_32GBIT;
+				break;
+			}
+		}
+	}
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
+	u32 rc = 1;
+
+	rc = efct_xport_status(xport, EFCT_XPORT_LINK_STATISTICS, &stats);
+	if (rc != 0) {
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
+	u32 rc = 0;
+
+	rc = efct_xport_status(efct->xport, EFCT_XPORT_LINK_STAT_RESET, &dummy);
+	if (rc != 0)
+		pr_err("efct_xport_status returned non 0 - %d\n", rc);
+}
+
+static void
+efct_get_starget_port_id(struct scsi_target *starget)
+{
+	pr_err("%s\n", __func__);
+}
+
+static void
+efct_get_starget_node_name(struct scsi_target *starget)
+{
+	pr_err("%s\n", __func__);
+}
+
+static void
+efct_get_starget_port_name(struct scsi_target *starget)
+{
+	pr_err("%s\n", __func__);
+}
+
+static void
+efct_set_vport_symbolic_name(struct fc_vport *fc_vport)
+{
+	pr_err("%s\n", __func__);
+}
+
+/**
+ * Bring the link down gracefully then re-init the link. The firmware will
+ * re-initialize the Fibre Channel interface as required.
+ * It does not issue a LIP.
+ */
+static int
+efct_issue_lip(struct Scsi_Host *shost)
+{
+	struct efct_vport *vport =
+			shost ? (struct efct_vport *)shost->hostdata : NULL;
+	struct efct *efct = vport ? vport->efct : NULL;
+
+	if (!shost || !vport || !efct) {
+		pr_err("%s: shost=%p vport=%p efct=%p\n", __func__,
+		       shost, vport, efct);
+		return -EPERM;
+	}
+
+	if (efct_xport_control(efct->xport, EFCT_XPORT_PORT_OFFLINE))
+		efc_log_test(efct, "EFCT_XPORT_PORT_OFFLINE failed\n");
+
+	if (efct_xport_control(efct->xport, EFCT_XPORT_PORT_ONLINE))
+		efc_log_test(efct, "EFCT_XPORT_PORT_ONLINE failed\n");
+
+	return 0;
+}
+
+struct efct_vport *
+efct_scsi_new_vport(struct efct *efct, struct device *dev)
+{
+	struct Scsi_Host *shost = NULL;
+	int error = 0;
+	struct efct_vport *vport = NULL;
+	union efct_xport_stats_u speed;
+	u32 supported_speeds = 0;
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
+	shost->can_queue = efct_scsi_get_property(efct, EFCT_SCSI_MAX_IOS);
+	shost->max_cmd_len = 16; /* 16-byte CDBs */
+	shost->max_id = 0xffff;
+	shost->max_lun = 0xffffffff;
+
+	/* can only accept (from mid-layer) as many SGEs as we've pre-regited*/
+	shost->sg_tablesize = efct_scsi_get_property(efct, EFCT_SCSI_MAX_SGL);
+
+	/* attach FC Transport template to shost */
+	shost->transportt = efct_vport_fc_tt;
+	efc_log_debug(efct, "vport transport template=%p\n",
+		       efct_vport_fc_tt);
+
+	/* get pci_dev structure and add host to SCSI ML */
+	error = scsi_add_host_with_dma(shost, dev, &efct->pcidev->dev);
+	if (error) {
+		efc_log_test(efct, "failed scsi_add_host_with_dma\n");
+		return NULL;
+	}
+
+	/* Set symbolic name for host port */
+	snprintf(fc_host_symbolic_name(shost),
+		 sizeof(fc_host_symbolic_name(shost)),
+		     "Emulex %s FV%s DV%s", efct->model,
+		     efct->fw_version, efct->driver_version);
+
+	/* Set host port supported classes */
+	fc_host_supported_classes(shost) = FC_COS_CLASS3;
+
+	speed.value = 1000;
+	if (efct_xport_status(efct->xport, EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+			      &speed)) {
+		supported_speeds |= FC_PORTSPEED_1GBIT;
+	}
+	speed.value = 2000;
+	if (efct_xport_status(efct->xport, EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+			      &speed)) {
+		supported_speeds |= FC_PORTSPEED_2GBIT;
+	}
+	speed.value = 4000;
+	if (efct_xport_status(efct->xport, EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+			      &speed)) {
+		supported_speeds |= FC_PORTSPEED_4GBIT;
+	}
+	speed.value = 8000;
+	if (efct_xport_status(efct->xport, EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+			      &speed)) {
+		supported_speeds |= FC_PORTSPEED_8GBIT;
+	}
+	speed.value = 10000;
+	if (efct_xport_status(efct->xport, EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+			      &speed)) {
+		supported_speeds |= FC_PORTSPEED_10GBIT;
+	}
+	speed.value = 16000;
+	if (efct_xport_status(efct->xport, EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+			      &speed)) {
+		supported_speeds |= FC_PORTSPEED_16GBIT;
+	}
+	speed.value = 32000;
+	if (efct_xport_status(efct->xport, EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+			      &speed)) {
+		supported_speeds |= FC_PORTSPEED_32GBIT;
+	}
+
+	fc_host_supported_speeds(shost) = supported_speeds;
+	vport->shost = shost;
+
+	return vport;
+}
+
+int efct_scsi_del_vport(struct efct *efct, struct Scsi_Host *shost)
+{
+	if (shost) {
+		efc_log_debug(efct,
+			       "Unregistering vport with Transport Layer\n");
+		efct_xport_remove_host(shost);
+		efc_log_debug(efct, "Unregistering vport with SCSI Midlayer\n");
+		scsi_remove_host(shost);
+		scsi_host_put(shost);
+		return 0;
+	}
+	return -1;
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
+	return 0;
+
+fail:
+	return -1;
+}
+
+static int
+efct_vport_delete(struct fc_vport *fc_vport)
+{
+	struct efct_vport *vport = *(struct efct_vport **)fc_vport->dd_data;
+	struct Scsi_Host *shost = vport ? vport->shost : NULL;
+	struct efct *efct = vport ? vport->efct : NULL;
+	int rc = -1;
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
+	return 0;
+}
+
+static struct fc_function_template efct_xport_functions = {
+	.get_starget_node_name = efct_get_starget_node_name,
+	.get_starget_port_name = efct_get_starget_port_name,
+	.get_starget_port_id  = efct_get_starget_port_id,
+
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
+	.set_vport_symbolic_name = efct_set_vport_symbolic_name,
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
+	.get_starget_node_name = efct_get_starget_node_name,
+	.get_starget_port_name = efct_get_starget_port_name,
+	.get_starget_port_id  = efct_get_starget_port_id,
+
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
+	.set_vport_symbolic_name = efct_set_vport_symbolic_name,
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
2.13.7

