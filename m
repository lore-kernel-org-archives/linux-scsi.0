Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BAECA9EBB
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52040205ED
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:57:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m/JTo5fq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436631AbfJWV5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:57:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42241 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436645AbfJWV5B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:57:01 -0400
Received: by mail-wr1-f68.google.com with SMTP id r1so13917215wrs.9
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NSfuz2vLpi+XVpW4xpENeY0ubBahH6CekxS/8uolkig=;
        b=m/JTo5fqZY/PQhPNptLYB9ziDormAwI5T6Fm4Ij10IM8pQtMZHv9gIL/cr59Nx+ruE
         SW/7Ee1q+eywYCKNV0KQZ5oDtLlq4Egck7ykQeQUgTbUOd40/RevfbLs6EDVblGMsgAd
         Paq/vHQZW9xNQWHQNiIHHb2+n+dJr2+MFX/9PYrkhVzru6rHFDQzcFTKDRdmB8DuyaZK
         Yt6Y9OXBrgb2Seen3QSWVYC0ZtuTP3JEakC7cUECVUoV28Kk8in/LvccP8hMchyas7L5
         rtcNytn7v1EUKAaFk+DnqgITn9EbHSfmAfGSDlKcFRQzhxKjsYyD+beLE1snMHXKZ4oZ
         dQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NSfuz2vLpi+XVpW4xpENeY0ubBahH6CekxS/8uolkig=;
        b=oN5aM/GjSF8swG+4sH+x+KszdhMl7DYQrKGZOJkYXMVnVU0XvIpvsql93+sz/+PLX+
         KLcO0H74ETEgsy5zvbyGTYiV2JOqVrVitw4JoLZt692shrT8Q31kc73YUWTYFV5y/NDn
         +NxYS5J32g5nt1vza9VRbPFTWPkWPaG8c8QOSzUe/ZGeXaKKzIOjj4RqiZ5iFT81a0Qn
         f2irqBVA0KVnWcf71VzKaIjqqpeDVrZa6WJ0yoNMpKO2UrnjRgY191p4gTdMPMWgxKwQ
         30blArvyC83V5C3PtePceSTPUM+fJUjgZ/OXCyxCNXDMJWuAohIFkc7v2OdwH65FLeEp
         xxkA==
X-Gm-Message-State: APjAAAX4SRxJxqA6QWp5KLwTE0DTJkxPAkv1N9D8WjrcRGN2Sl+1E0Bb
        21klgQ1Q50Rd+A2J8xgege7nB1PH
X-Google-Smtp-Source: APXvYqyLF9VqxSUlHYggBd8rV2mww9lzEAXsctw0FXAiOVDEWdUVyaW4YGZZEwBPJIj8rh2Nj+lwKw==
X-Received: by 2002:a5d:55ce:: with SMTP id i14mr723102wrw.169.1571867816985;
        Wed, 23 Oct 2019 14:56:56 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:56 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 30/32] elx: efct: scsi_transport_fc host interface support
Date:   Wed, 23 Oct 2019 14:55:55 -0700
Message-Id: <20191023215557.12581-31-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191023215557.12581-1-jsmart2021@gmail.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
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
 drivers/scsi/elx/efct/efct_xport.c | 580 +++++++++++++++++++++++++++++++++++++
 1 file changed, 580 insertions(+)

diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
index d43027c57732..c0f75c0dde9c 100644
--- a/drivers/scsi/elx/efct/efct_xport.c
+++ b/drivers/scsi/elx/efct/efct_xport.c
@@ -1146,3 +1146,583 @@ int efct_scsi_del_device(struct efct_s *efct)
 	}
 	return 0;
 }
+
+/**
+ * @brief Copy the vport DID into the SCSI host port id.
+ *
+ * @param shost Kernel SCSI host pointer.
+ */
+static void
+efct_get_host_port_id(struct Scsi_Host *shost)
+{
+	struct efct_vport_s *vport = (struct efct_vport_s *)shost->hostdata;
+	struct efct_s *efct = vport->efct;
+	struct efc_lport *efc = efct->efcport;
+	struct efc_sli_port_s *sport;
+
+	if (efc->domain && efc->domain->sport) {
+		sport = efc->domain->sport;
+		fc_host_port_id(shost) = sport->fc_id;
+	}
+}
+
+/**
+ * @brief Set the value of the SCSI host port type.
+ *
+ * @param shost Kernel SCSI host pointer.
+ */
+static void
+efct_get_host_port_type(struct Scsi_Host *shost)
+{
+	struct efct_vport_s *vport = (struct efct_vport_s *)shost->hostdata;
+	struct efct_s *efct = vport->efct;
+	struct efc_lport *efc = efct->efcport;
+	struct efc_sli_port_s *sport;
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
+/**
+ * @brief Set the value of the SCSI host port state
+ *
+ * @param shost Kernel SCSI host pointer.
+ */
+static void
+efct_get_host_port_state(struct Scsi_Host *shost)
+{
+	struct efct_vport_s *vport = (struct efct_vport_s *)shost->hostdata;
+	struct efct_s *efct = vport->efct;
+	struct efc_lport *efc = efct->efcport;
+
+	if (efc->domain)
+		fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
+	else
+		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
+}
+
+/**
+ * @brief Set the value of the SCSI host speed.
+ *
+ * @param shost Kernel SCSI host pointer.
+ */
+static void
+efct_get_host_speed(struct Scsi_Host *shost)
+{
+	struct efct_vport_s *vport = (struct efct_vport_s *)shost->hostdata;
+	struct efct_s *efct = vport->efct;
+	struct efc_lport *efc = efct->efcport;
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
+/**
+ * @brief Set the value of the SCSI host fabric name.
+ *
+ * @param shost Kernel SCSI host pointer.
+ */
+static void
+efct_get_host_fabric_name(struct Scsi_Host *shost)
+{
+	struct efct_vport_s *vport = (struct efct_vport_s *)shost->hostdata;
+	struct efct_s *efct = vport->efct;
+	struct efc_lport *efc = efct->efcport;
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
+/**
+ * @brief Return statistical information about the adapter.
+ *
+ * @par Description
+ * Returns NULL on error for link down, no mbox pool, sli2 active,
+ * management not allowed, memory allocation error, or mbox error.
+ *
+ * @param shost Kernel SCSI host pointer.
+ *
+ * @return NULL for error address of the adapter host statistics.
+ */
+static struct fc_host_statistics *
+efct_get_stats(struct Scsi_Host *shost)
+{
+	struct efct_vport_s *vport = (struct efct_vport_s *)shost->hostdata;
+	struct efct_s *efct = vport->efct;
+	union efct_xport_stats_u stats;
+	struct efct_xport_s *xport = efct->xport;
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
+/**
+ * @brief Copy the adapter link stats information.
+ *
+ * @param shost Kernel SCSI host pointer.
+ */
+static void
+efct_reset_stats(struct Scsi_Host *shost)
+{
+	struct efct_vport_s *vport = (struct efct_vport_s *)shost->hostdata;
+	struct efct_s *efct = vport->efct;
+	/* argument has no purpose for this action */
+	union efct_xport_stats_u dummy;
+	u32 rc = 0;
+
+	rc = efct_xport_status(efct->xport, EFCT_XPORT_LINK_STAT_RESET, &dummy);
+	if (rc != 0)
+		pr_err("efct_xport_status returned non 0 - %d\n", rc);
+}
+
+/**
+ * @brief Set the target port id to the ndlp DID or -1.
+ *
+ * @param starget Kernel SCSI target pointer.
+ */
+static void
+efct_get_starget_port_id(struct scsi_target *starget)
+{
+	pr_err("%s\n", __func__);
+}
+
+/**
+ * @brief Set the target node name.
+ *
+ * @par Description
+ * Set the target node name to the ndlp node name wwn or zero.
+ *
+ * @param starget Kernel SCSI target pointer.
+ */
+static void
+efct_get_starget_node_name(struct scsi_target *starget)
+{
+	pr_err("%s\n", __func__);
+}
+
+/**
+ * @brief Set the target port name.
+ *
+ * @par Description
+ * Set the target port name to the ndlp port name wwn or zero.
+ *
+ * @param starget Kernel SCSI target pointer.
+ */
+static void
+efct_get_starget_port_name(struct scsi_target *starget)
+{
+	pr_err("%s\n", __func__);
+}
+
+/**
+ * @brief Set the vport's symbolic name.
+ *
+ * @par Description
+ * This function is called by the transport after the fc_vport's symbolic name
+ * has been changed. This function re-registers the symbolic name with the
+ * switch to propagate the change into the fabric, if the vport is active.
+ *
+ * @param fc_vport The fc_vport who's symbolic name has been changed.
+ */
+static void
+efct_set_vport_symbolic_name(struct fc_vport *fc_vport)
+{
+	pr_err("%s\n", __func__);
+}
+
+/**
+ * @brief Gracefully take the link down and reinitialize it
+ * (does not issue LIP).
+ *
+ * @par Description
+ * Bring the link down gracefully then re-init the link. The firmware will
+ * re-initialize the Fibre Channel interface as required.
+ * It does not issue a LIP.
+ *
+ * @param shost Scsi_Host pointer.
+ *
+ * @return
+ * - 0 - Success.
+ * - EPERM - Port is offline or management commands are being blocked.
+ * - ENOMEM - Unable to allocate memory for the mailbox command.
+ * - EIO - Error in sending the mailbox command.
+ */
+static int
+efct_issue_lip(struct Scsi_Host *shost)
+{
+	struct efct_vport_s *vport =
+			shost ? (struct efct_vport_s *)shost->hostdata : NULL;
+	struct efct_s *efct = vport ? vport->efct : NULL;
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
+struct efct_vport_s *
+efct_scsi_new_vport(struct efct_s *efct, struct device *dev)
+{
+	struct Scsi_Host *shost = NULL;
+	int error = 0;
+	struct efct_vport_s *vport = NULL;
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
+	vport = (struct efct_vport_s *)shost->hostdata;
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
+int efct_scsi_del_vport(struct efct_s *efct, struct Scsi_Host *shost)
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
+	struct efct_vport_s *pport = shost ?
+					(struct efct_vport_s *)shost->hostdata :
+					NULL;
+	struct efct_s *efct = pport ? pport->efct : NULL;
+	struct efct_vport_s *vport = NULL;
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
+	*(struct efct_vport_s **)fc_vport->dd_data = vport;
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
+	struct efct_vport_s *vport = *(struct efct_vport_s **)fc_vport->dd_data;
+	struct Scsi_Host *shost = vport ? vport->shost : NULL;
+	struct efct_s *efct = vport ? vport->efct : NULL;
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
+	.dd_fcrport_size = sizeof(struct efct_rport_data_s),
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
+	.dd_fcrport_size = sizeof(struct efct_rport_data_s),
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

