Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC27C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB2A020866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OzFHpdMZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbfHNX5z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35024 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729387AbfHNX5y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:54 -0400
Received: by mail-pf1-f196.google.com with SMTP id d85so349778pfd.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4ztQaypWVKpbUqHrBM+X6fl/OPzOL81/dhYaxK+vKHM=;
        b=OzFHpdMZQVc/fBbdTTiQn8PUtodZ5d3cobG1zFXc4VfwAvFPeNfsTo8BZ9fjvx/gRG
         m+om0I/PdqlbyvYoWoKpdw2DzGQewqZ8GhTWdspG97cRtNmm2nJMzGbFIYuc1XBui0Bn
         7dxa94UEF2SD6+4fCr1cKBZJAXljsBhvWoMi/N/bPnMk4TnSHd5686AQfgvog3UGInAl
         Vy+N88bRrY4lNjBctAbhNG8piqajaCGxEtqHFzVxj/ULFYwe3RmAU07NMVyp5kEaeicA
         qF+MosZZr19ZTS1LytoszWW2dgewX+jXP3KdBZYMgwRuQoJFec1UN8DamMxVlEn9+q+r
         Aljw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4ztQaypWVKpbUqHrBM+X6fl/OPzOL81/dhYaxK+vKHM=;
        b=Vx4IBaWLeqHVg2VW3gktYeK3xFIhUobEgkSoVUCGUSVtvp+vj4lpZg8YTuj4K2eHMb
         no++TZajllhP/XUB+kWv1lellbz/u6i3aE4MrQpplLncjC8KEADr+fQg8TKfXX9OoKCe
         keeam9/RIqy9EBcX9LUPoOCM/UZ7zRp+5Dg0aJGqJVXudRt78RiMyG0mb1BM3RsrqIxG
         OT9omGwZ38oabTJTiR/H8b5NBq5N8oThLRdhFMiOEYSxRylLlvHCzw6CDbLr5DeC3YaS
         Uus85hX0bZ6Ilf6ZAIdc6obPl7omqj9Y8vd4eL9GWg7exxycxlBLW90TmF5B9qf7Q0ab
         85vg==
X-Gm-Message-State: APjAAAXW0YqyR7Vhqj1owGVFS+BLeSKszwDnZCJMVXAue3urAX65pXJV
        X/BtJAWZh81nrV/4Rq7SwvLu2MfT
X-Google-Smtp-Source: APXvYqzKYJzi23VbcGQlYuADKTwQogSJHb1tGFxSqaRZtmKFEOZERZ1L+bpW62tL0kS7xlxfz2em5w==
X-Received: by 2002:a65:60cd:: with SMTP id r13mr1400272pgv.315.1565827073819;
        Wed, 14 Aug 2019 16:57:53 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:53 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 40/42] lpfc: Add NVMe sequence level error recovery support
Date:   Wed, 14 Aug 2019 16:57:10 -0700
Message-Id: <20190814235712.4487-41-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

FC-NVMe-2 added support for sequence level error recovery in the
FC-NVME protocol. This allows for the detection of errors and
lost frames and immediate retransmission of data to avoid exchange
termination, which escalates into NVMeoFC connection and association
failures. A significant RAS improvement.

The driver is modified to indicate support for SLER in the
NVMe PRLI is issues and to check for support in the PRLI response.
When both sides support it, the driver will set a bit in the WQE
to enable the recovery behavior on the exchange. The adapter will
take care of all detection and retransmission.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h           |  1 +
 drivers/scsi/lpfc/lpfc_disc.h      |  2 ++
 drivers/scsi/lpfc/lpfc_els.c       |  4 ++++
 drivers/scsi/lpfc/lpfc_hw4.h       |  8 ++++++++
 drivers/scsi/lpfc/lpfc_init.c      |  8 ++++++++
 drivers/scsi/lpfc/lpfc_nportdisc.c | 13 ++++++++++++-
 drivers/scsi/lpfc/lpfc_nvme.c      |  3 +++
 7 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 856a468d9b7d..8fb43169a445 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -797,6 +797,7 @@ struct lpfc_hba {
 	uint8_t  mds_diags_support;
 	uint8_t  bbcredit_support;
 	uint8_t  enab_exp_wqcq_pages;
+	u8	 nsler; /* Firmware supports FC-NVMe-2 SLER */
 
 	/* HBA Config Parameters */
 	uint32_t cfg_ack0;
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 49bb0b180b19..482e4a888dae 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -112,6 +112,8 @@ struct lpfc_nodelist {
 	uint8_t         nlp_retry;		/* used for ELS retries */
 	uint8_t         nlp_fcp_info;	        /* class info, bits 0-3 */
 #define NLP_FCP_2_DEVICE   0x10			/* FCP-2 device */
+	u8		nlp_nvme_info;	        /* NVME NSLER Support */
+#define NLP_NVME_NSLER     0x1			/* NVME NSLER device */
 
 	uint16_t        nlp_usg_map;	/* ndlp management usage bitmap */
 #define NLP_USG_NODE_ACT_BIT	0x1	/* Indicate ndlp is actively used */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 30bbfa3f6086..d5303994bfd6 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2435,6 +2435,10 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		npr_nvme = (struct lpfc_nvme_prli *)pcmd;
 		bf_set(prli_type_code, npr_nvme, PRLI_NVME_TYPE);
 		bf_set(prli_estabImagePair, npr_nvme, 0);  /* Should be 0 */
+		if (phba->nsler) {
+			bf_set(prli_nsler, npr_nvme, 1);
+			bf_set(prli_conf, npr_nvme, 1);
+		}
 
 		/* Only initiators request first burst. */
 		if ((phba->cfg_nvme_enable_fb) &&
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index e198de8eda32..bd533475c86a 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3480,6 +3480,10 @@ struct lpfc_sli4_parameters {
 #define cfg_bv1s_MASK                           0x00000001
 #define cfg_bv1s_WORD                           word19
 
+#define cfg_nsler_SHIFT                         12
+#define cfg_nsler_MASK                          0x00000001
+#define cfg_nsler_WORD                          word19
+
 	uint32_t word20;
 #define cfg_max_tow_xri_SHIFT			0
 #define cfg_max_tow_xri_MASK			0x0000ffff
@@ -4621,6 +4625,7 @@ struct lpfc_nvme_prli {
 #define prli_type_code_WORD             word1
 	uint32_t word_rsvd2;
 	uint32_t word_rsvd3;
+
 	uint32_t word4;
 #define prli_fba_SHIFT                  0
 #define prli_fba_MASK                   0x00000001
@@ -4637,6 +4642,9 @@ struct lpfc_nvme_prli {
 #define prli_conf_SHIFT                 7
 #define prli_conf_MASK                  0x00000001
 #define prli_conf_WORD                  word4
+#define prli_nsler_SHIFT		8
+#define prli_nsler_MASK			0x00000001
+#define prli_nsler_WORD			word4
 	uint32_t word5;
 #define prli_fb_sz_SHIFT                0
 #define prli_fb_sz_MASK                 0x0000ffff
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 35faaf915c6a..7e620c0b5b4a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11867,6 +11867,14 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	else
 		phba->mds_diags_support = 0;
 
+	/*
+	 * Check if the SLI port supports NSLER
+	 */
+	if (bf_get(cfg_nsler, mbx_sli4_parameters))
+		phba->nsler = 1;
+	else
+		phba->nsler = 0;
+
 	return 0;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 41ac07b99739..f4b879d25fe9 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -799,9 +799,15 @@ lpfc_rcv_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			if (npr->writeXferRdyDis)
 				ndlp->nlp_flag |= NLP_FIRSTBURST;
 		}
-		if (npr->Retry)
+		if (npr->Retry && ndlp->nlp_type &
+					(NLP_FCP_INITIATOR | NLP_FCP_TARGET))
 			ndlp->nlp_fcp_info |= NLP_FCP_2_DEVICE;
 
+		if (npr->Retry && phba->nsler &&
+		    ndlp->nlp_type & (NLP_NVME_INITIATOR | NLP_NVME_TARGET))
+			ndlp->nlp_nvme_info |= NLP_NVME_NSLER;
+
+
 		/* If this driver is in nvme target mode, set the ndlp's fc4
 		 * type to NVME provided the PRLI response claims NVME FC4
 		 * type.  Target mode does not issue gft_id so doesn't get
@@ -2024,6 +2030,11 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		if (bf_get_be32(prli_init, nvpr))
 			ndlp->nlp_type |= NLP_NVME_INITIATOR;
 
+		if (phba->nsler && bf_get_be32(prli_nsler, nvpr))
+			ndlp->nlp_nvme_info |= NLP_NVME_NSLER;
+		else
+			ndlp->nlp_nvme_info &= ~NLP_NVME_NSLER;
+
 		/* Target driver cannot solicit NVME FB. */
 		if (bf_get_be32(prli_tgt, nvpr)) {
 			/* Complete the nvme target roles.  The transport
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 5e48318eb7a9..f66859d928ac 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1255,6 +1255,9 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 		       sizeof(uint32_t) * 8);
 		cstat->control_requests++;
 	}
+
+	if (pnode->nlp_nvme_info & NLP_NVME_NSLER)
+		bf_set(wqe_erp, &wqe->generic.wqe_com, 1);
 	/*
 	 * Finish initializing those WQE fields that are independent
 	 * of the nvme_cmnd request_buffer
-- 
2.13.7

