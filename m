Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A95D28850E
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 23:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765410304; cv=none; b=uiUvwn4CcrIVMtf/IsIQ9lF8ZQ20m0bmnf83YGQ1eBON/Aphht5QODv3G3/hjyPYhT7lGdv3snTmzoljo3+OeO3n7XGupXzmHJarMxj+k7Xvf/xPkpm5FfjMohklkNHYvDA9ovpd8DInIBnpzQmbLGeR7IiyU+n2i77QdXn4kBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765410304; c=relaxed/simple;
	bh=92O/V1b3gog3LUHGpJPWQd7pThw7WRbXZIqw9MJs804=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t0J3PrH/qv8cIALOYwdHXRVZfGgeTSXpjnU7MxsMFSx0Dl5v6QAXjrd9M1fiC1dGhgwP11guxDkfhcldF9kMNdOQTPDVtcGPyrvvKcOFvMfcYoOxG4HRhGm0dANkYWk4ZtI1wkpN7TRLuMHFXbHuCK+7vJ64hW80fJKGHaAboyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P6rW3cCo; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P6rW3cCo"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4edf1be4434so2919391cf.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765410301; x=1766015101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rwnu7FfuzDwk0Txpbigba1YkxTylXWANVFQU3YWOErs=;
        b=P6rW3cCoq0lQbbIOky3UAYKQ0QoslMEpEXFiV+j4eKpalZnsqPm2bp0nmrXt5EhSnU
         lYu6FHt39RCj1GMMr2CAnbjRVpIwEEqc+p4Zp5Zg2CfpFwz4rd+Nvzi5UWBXNArW6X/8
         vGJaod9+C+YzpRJenSrzINFTettDcZdX204v+Xjkpo4kWsWrlPQLHFNx56wt1NFrhm2q
         Txz4ZZ4wWuJklLw+PaVPKKunhOv3G9C4OHkc+gr+/CfEgcfe5X6Pi+IDizzKYFV7T97O
         mmkUpE/qmb0CbBcuHoAGPOBQEUiFqULHXIt04PoilzXufqKhYw/yEAemZMu66KvBh6fr
         XfUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765410301; x=1766015101;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rwnu7FfuzDwk0Txpbigba1YkxTylXWANVFQU3YWOErs=;
        b=eJZ34E/xC25GScrOSmVVbX9lpt9Qp7cBazpC13Z4U2yf2Hm61FSixHZdCPOKRS7HAX
         nJs6hSb8slAXSNLKWSN6sSyOt4Se+Wqhsln3gnZbvs2WraO7UMGe2Cl7bec+j3DsLEho
         LPkzTgw+4CVM7dK29kxmDaba6hUFSvLwsZR2DYEwGS6s172gKodI0nCNbPZtqZC0SjLm
         SigH8aBjReGqO9WH8MwoIV0umgyiqZnC8NTNEYhlMUHlFL3VOVpE8kvIW94Jqpt01qpW
         XE2xhb961LCbZ83nmmoAq+MivPEenWKkUanEsHDPzA1TSi9GNUZgp6nKINu+EYzRs8qW
         f4rA==
X-Gm-Message-State: AOJu0YxA8/MSCd4lGghPvqWOM9iLcmTcI1+kpPYvLNMIFksevdUKH+yi
	inAHogHAyebvJTVg0p3xillQfnzrC2vVJq1gCk2WpUTZKKKMvN8G5A7UGJY3nm0L
X-Gm-Gg: ASbGncu8jDunWnX37tri+vB4XW0b6uJUvAMBYoLxvB+9Q760hyZHJCkqqavAQydED+p
	GEcpOdKrCfZI41KILqh8ayGv5mLty4ZCz4LR0UUTJxlaY4PnMDnAomhiyIWa/j0CDibQ8XncLiO
	0RNpbAQ+ecpPs/jDM2m5GZDuuIQ/P6xHEUQQzFXBqAkx+bLPlZZYQUiTjZcohoEx9KA2KTT83zT
	KLjnw79KaGJtWSt1QFCIyI3Dq6x8TSYOFg+TPditMsWxVMsJ5eIz/8VcykE8UG+xl3/tb5xa9IM
	tnyK1h00fGst6OG6VAW1JsxU3+65Rrcmo2snUoIRijflKphlRqhXFo5IxHEKODhLhzkBt1UuXrv
	T7XUg+2CkqNyAj5WaJLSx4oDS/iplv2vtmhAYXgY+q4AFk632kWe9ZidByC6P7PhuS0sDFyPOws
	CDV77ML/6nDwofu9df4JtByUaxPCqDwwMPJ9KXdW4u2EJQMAmsaqHboXsuTotTGnzl4nOck88=
X-Google-Smtp-Source: AGHT+IGcGBbfVmfHjFo6JK9Chkwx2zj1JR9DHrbasBcx0MxZdn+KNihCbDhhjd/mgi3AN1sWmq+h6A==
X-Received: by 2002:a05:622a:1448:b0:4ee:28d1:4b91 with SMTP id d75a77b69052e-4f1b1aa7ef7mr58367671cf.54.1765410301130;
        Wed, 10 Dec 2025 15:45:01 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f1bd6b502asm5869051cf.16.2025.12.10.15.45.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Dec 2025 15:45:00 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Sarah Catania <sarah.catania@broadcom.com>,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 2/3] lpfc: Add support for reporting encryption events
Date: Wed, 10 Dec 2025 16:16:58 -0800
Message-Id: <20251211001659.138635-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251211001659.138635-1-justintee8345@gmail.com>
References: <20251211001659.138635-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sarah Catania <sarah.catania@broadcom.com>

Support logging encryption events in both point to point and fabric
topologies.  A new LOG_ENCRYPTION flag is defined for reporting
encryption related events for HBAs that support the FEDIF feature.
Encryption information is stored in each ndlp object, which is determined
during the discovery stage after PLOGI completes.

For reporting encryption information to upper layers, the
.get_fc_rport_enc_info routine is implemented in lpfc_get_enc_info.  This
allows encryption status to be reported through fc_remote_ports sysfs.
Debugfs is also updated to report encryption information for all ndlp
objects.

Signed-off-by: Sarah Catania <sarah.catania@broadcom.com>
Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c    | 40 ++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_debugfs.c |  7 ++++
 drivers/scsi/lpfc/lpfc_disc.h    |  7 ++++
 drivers/scsi/lpfc/lpfc_els.c     | 57 ++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_hbadisc.c |  1 +
 drivers/scsi/lpfc/lpfc_hw4.h     | 11 +++++-
 drivers/scsi/lpfc/lpfc_init.c    |  5 +++
 drivers/scsi/lpfc/lpfc_logmsg.h  |  3 +-
 drivers/scsi/lpfc/lpfc_sli4.h    |  4 +++
 9 files changed, 133 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 33582d48ec09..4af5c069635a 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -6979,6 +6979,42 @@ lpfc_reset_stats(struct Scsi_Host *shost)
 	return;
 }
 
+/**
+ * lpfc_get_enc_info - Return encryption information about the session for
+ *                     a given remote port.
+ * @rport: ptr to fc_rport from scsi transport fc
+ *
+ * Given an rport object, iterate through the fc_nodes list to find node
+ * corresponding with rport. Pass the encryption information from the node to
+ * rport's encryption attribute for reporting to upper layers. Information is
+ * passed through nlp_enc_info struct which contains encryption status.
+ *
+ * Returns:
+ * - Address of rport's fc_encryption_info struct
+ * - NULL when not found
+ **/
+static struct fc_encryption_info *
+lpfc_get_enc_info(struct fc_rport *rport)
+{
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct fc_encryption_info *ef = NULL;
+	struct lpfc_nodelist *ndlp, *next_ndlp;
+	unsigned long iflags;
+
+	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
+	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
+		if (ndlp->rport && ndlp->rport == rport) {
+			ef = &rport->enc_info;
+			ef->status = ndlp->nlp_enc_info.status;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
+	return ef;
+}
+
+
 /*
  * The LPFC driver treats linkdown handling as target loss events so there
  * are no sysfs handlers for link_down_tmo.
@@ -7196,6 +7232,8 @@ struct fc_function_template lpfc_transport_functions = {
 	.get_fc_host_stats = lpfc_get_stats,
 	.reset_fc_host_stats = lpfc_reset_stats,
 
+	.get_fc_rport_enc_info = lpfc_get_enc_info,
+
 	.dd_fcrport_size = sizeof(struct lpfc_rport_data),
 	.show_rport_maxframe_size = 1,
 	.show_rport_supported_classes = 1,
@@ -7265,6 +7303,8 @@ struct fc_function_template lpfc_vport_transport_functions = {
 	.get_fc_host_stats = lpfc_get_stats,
 	.reset_fc_host_stats = lpfc_reset_stats,
 
+	.get_fc_rport_enc_info = lpfc_get_enc_info,
+
 	.dd_fcrport_size = sizeof(struct lpfc_rport_data),
 	.show_rport_maxframe_size = 1,
 	.show_rport_supported_classes = 1,
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 92b5b2dbe847..646f88c776f5 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -872,6 +872,13 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 				 ndlp->nlp_rpi);
 		len += scnprintf(buf+len, size-len, "flag:x%08lx ",
 				 ndlp->nlp_flag);
+		if (ndlp->nlp_enc_info.status) {
+			len += scnprintf(buf + len,
+					 size - len, "ENCRYPTED");
+			len += scnprintf(buf + len, size - len,
+					 ndlp->nlp_enc_info.level
+					 ? "(CNSA2.0) " : "(CNSA1.0) ");
+		}
 		if (!ndlp->nlp_type)
 			len += scnprintf(buf+len, size-len, "UNKNOWN_TYPE ");
 		if (ndlp->nlp_type & NLP_FC_NODE)
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 51cb8571c049..de0adeecf668 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -77,6 +77,11 @@ struct lpfc_node_rrqs {
 	unsigned long xri_bitmap[XRI_BITMAP_ULONGS];
 };
 
+struct lpfc_enc_info {
+	u8 status; /* encryption status for session */
+	u8 level; /* CNSA encryption level */
+};
+
 enum lpfc_fc4_xpt_flags {
 	NLP_XPT_REGD		= 0x1,
 	SCSI_XPT_REGD		= 0x2,
@@ -138,6 +143,8 @@ struct lpfc_nodelist {
 	uint8_t		vmid_support;		/* destination VMID support */
 #define NLP_NVME_NSLER     0x1			/* NVME NSLER device */
 
+	struct lpfc_enc_info nlp_enc_info; /* Encryption information struct */
+
 	struct timer_list   nlp_delayfunc;	/* Used for delayed ELS cmds */
 	struct lpfc_hba *phba;
 	struct fc_rport *rport;		/* scsi_transport_fc port structure */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 02b6d31b9ad9..32da3c23c7f4 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2014,6 +2014,58 @@ lpfc_cmpl_els_rrq(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	lpfc_nlp_put(ndlp);
 	return;
 }
+
+/**
+ * lpfc_check_encryption - Reports an ndlp's encryption information
+ * @phba: pointer to lpfc hba data structure.
+ * @ndlp: pointer to a node-list data structure.
+ * @cmdiocb: pointer to lpfc command iocbq data structure.
+ * @rspiocb: pointer to lpfc response iocbq data structure.
+ *
+ * This routine is called in the completion callback function for issuing
+ * or receiving a Port Login (PLOGI) command. In a PLOGI completion, if FEDIF
+ * is supported, encryption information will be provided in completion status
+ * data. If @phba supports FEDIF, a log message containing encryption
+ * information will be logged. Encryption status is also saved for encryption
+ * reporting with upper layer through the rport encryption attribute.
+ **/
+static void
+lpfc_check_encryption(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
+		      struct lpfc_iocbq *cmdiocb, struct lpfc_iocbq *rspiocb)
+{
+	struct lpfc_vport *vport = cmdiocb->vport;
+	u32 did = ndlp->nlp_DID;
+	struct lpfc_enc_info *nlp_enc_info = &ndlp->nlp_enc_info;
+	char enc_status[FC_RPORT_ENCRYPTION_STATUS_MAX_LEN] = {0};
+	char enc_level[8] = "N/A";
+	u8 encryption;
+
+	if (phba->sli4_hba.encryption_support &&
+	    ((did & Fabric_DID_MASK) != Fabric_DID_MASK)) {
+		encryption = bf_get(lpfc_wcqe_c_enc,
+				    &rspiocb->wcqe_cmpl);
+		nlp_enc_info->status = encryption;
+
+		strscpy(enc_status, encryption ? "Encrypted" : "Unencrypted",
+			sizeof(enc_status));
+
+		if (encryption) {
+			nlp_enc_info->level = bf_get(lpfc_wcqe_c_enc_lvl,
+						     &rspiocb->wcqe_cmpl);
+			strscpy(enc_level, nlp_enc_info->level ? "CNSA2.0" :
+								 "CNSA1.0",
+				sizeof(enc_level));
+		}
+
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_ENCRYPTION,
+				 "0924 DID:x%06x %s Session "
+				 "Established, Encryption Level:%s "
+				 "rpi:x%x\n",
+				 ndlp->nlp_DID, enc_status, enc_level,
+				 ndlp->nlp_rpi);
+	}
+}
+
 /**
  * lpfc_cmpl_els_plogi - Completion callback function for plogi
  * @phba: pointer to lpfc hba data structure.
@@ -2153,6 +2205,8 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			goto out;
 		ndlp = lpfc_plogi_confirm_nport(phba, prsp->virt, ndlp);
 
+		lpfc_check_encryption(phba, ndlp, cmdiocb, rspiocb);
+
 		sp = (struct serv_parm *)((u8 *)prsp->virt +
 					  sizeof(u32));
 
@@ -5407,6 +5461,9 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		goto out;
 	}
 
+	if (!ulp_status && test_bit(NLP_RCV_PLOGI, &ndlp->nlp_flag))
+		lpfc_check_encryption(phba, ndlp, cmdiocb, rspiocb);
+
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
 		"ELS rsp cmpl:    status:x%x/x%x did:x%x",
 		ulp_status, ulp_word4, did);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index bb803f32bc1b..1aeebdc08073 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5340,6 +5340,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		clear_bit(NLP_NPR_ADISC, &ndlp->nlp_flag);
 		if (acc_plogi)
 			clear_bit(NLP_LOGO_ACC, &ndlp->nlp_flag);
+		memset(&ndlp->nlp_enc_info, 0, sizeof(ndlp->nlp_enc_info));
 		return 1;
 	}
 	clear_bit(NLP_LOGO_ACC, &ndlp->nlp_flag);
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index a7f7ed86d2b0..c000474c3066 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -437,6 +437,12 @@ struct lpfc_wcqe_complete {
 #define lpfc_wcqe_c_cmf_bw_MASK		0x0FFFFFFF
 #define lpfc_wcqe_c_cmf_bw_WORD		total_data_placed
 	uint32_t parameter;
+#define lpfc_wcqe_c_enc_SHIFT		31
+#define lpfc_wcqe_c_enc_MASK		0x00000001
+#define lpfc_wcqe_c_enc_WORD		parameter
+#define lpfc_wcqe_c_enc_lvl_SHIFT	30
+#define lpfc_wcqe_c_enc_lvl_MASK	0x00000001
+#define lpfc_wcqe_c_enc_lvl_WORD	parameter
 #define lpfc_wcqe_c_bg_edir_SHIFT	5
 #define lpfc_wcqe_c_bg_edir_MASK	0x00000001
 #define lpfc_wcqe_c_bg_edir_WORD	parameter
@@ -2942,7 +2948,10 @@ struct lpfc_mbx_read_config {
 #define lpfc_mbx_rd_conf_topology_SHIFT		24
 #define lpfc_mbx_rd_conf_topology_MASK		0x000000FF
 #define lpfc_mbx_rd_conf_topology_WORD		word2
-	uint32_t rsvd_3;
+	uint32_t word3;
+#define lpfc_mbx_rd_conf_fedif_SHIFT		6
+#define lpfc_mbx_rd_conf_fedif_MASK		0x00000001
+#define lpfc_mbx_rd_conf_fedif_WORD		word3
 	uint32_t word4;
 #define lpfc_mbx_rd_conf_e_d_tov_SHIFT		0
 #define lpfc_mbx_rd_conf_e_d_tov_MASK		0x0000FFFF
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 2bd445703146..0d00f5fd5395 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -9999,6 +9999,11 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 				(phba->sli4_hba.max_cfg_param.max_vpi - 1) : 0;
 		phba->max_vports = phba->max_vpi;
 
+		if (bf_get(lpfc_mbx_rd_conf_fedif, rd_config))
+			phba->sli4_hba.encryption_support = true;
+		else
+			phba->sli4_hba.encryption_support = false;
+
 		/* Next decide on FPIN or Signal E2E CGN support
 		 * For congestion alarms and warnings valid combination are:
 		 * 1. FPIN alarms / FPIN warnings
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index 59bd2bafc73f..e00d101d548c 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2025 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
@@ -47,6 +47,7 @@
 #define LOG_RSVD1	0x01000000	/* Reserved */
 #define LOG_RSVD2	0x02000000	/* Reserved */
 #define LOG_CGN_MGMT    0x04000000	/* Congestion Mgmt events */
+#define LOG_ENCRYPTION  0x40000000      /* EDIF Encryption events. */
 #define LOG_TRACE_EVENT 0x80000000	/* Dmp the DBG log on this err */
 #define LOG_ALL_MSG	0x7fffffff	/* LOG all messages */
 
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index fd6dab157887..ee58383492b2 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -888,6 +888,10 @@ struct lpfc_sli4_hba {
 #define LPFC_FP_EQ_MAX_INTR_SEC         10000
 
 	uint32_t intr_enable;
+
+	 /* Indicates whether SLI Port supports FEDIF */
+	bool encryption_support;
+
 	struct lpfc_bmbx bmbx;
 	struct lpfc_max_cfg_param max_cfg_param;
 	uint16_t extents_in_use; /* must allocate resource extents. */
-- 
2.38.0

