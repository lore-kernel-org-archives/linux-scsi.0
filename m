Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D6FC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 03:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388855AbiEFD71 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 23:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388847AbiEFD7W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 23:59:22 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AD8E086
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 20:55:36 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 15so5152056pgf.4
        for <linux-scsi@vger.kernel.org>; Thu, 05 May 2022 20:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SlJIELBy4z+xeHf/ycXLYr/gClJrx5Yhe/cSztGWovI=;
        b=U2gG1hzjnXr1tcj4X6q3kwzjQy/ENn7nZevEZ+9R7ajSNWZaacgJzyChhtzOFvWAv+
         NZSyC/bogPPt21DyKlf3UFcywlxAmDI64r21nDZxTCXj8caUqM2KqeIYrSSJ2YISsjGc
         cTbj1l2QDK/67SOXqUrf+eig9Cjb57YViACqIkVakzGr0bmHkTfqXxk1XfZ7Ek1zDSHu
         S+w3FQ4cUBocVl3Zxh99MIre3wRrTFktM4d4d+EEDK6my7be8rEJ4qs3FRmIMS6VYfPo
         MSwgWYCxP5CZFdT2FAQ7IiHQ/WseT876xqpepbYrrsZj1e5N/c97+tw92l29Sf6gnm7P
         SJ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SlJIELBy4z+xeHf/ycXLYr/gClJrx5Yhe/cSztGWovI=;
        b=U2TbKczlUJy2VAlLjAWnCXYx+njpAmbosFtAMTQML2TBCON5OFrI7vbz/DzmvIEwxK
         ATmqduMEvGRrlYcxrTkdu6FY7q3gLdTLseLgbm9lZP9AyL4BlFNR8eG2jtEqcw6EZcqC
         N9kbGNQ+EoX4deV/0fudx3qkJqxq9WY+w5qq8fXgthrOmfVFwIcq6kwsHs0LZ+ETifxX
         3IH0G39Jxq4NV09AHEghIFJpUWC/mlnv+C/ErNJ/wgC0M0WNde0LCiNocyUcNBeT+kP8
         Ju4RNJw9L1LrkwHORWSqp9AwOjEjB2hemy4yL3hTm8rqdY+JKAanGbDRKblkYUy/+Biy
         p2BQ==
X-Gm-Message-State: AOAM531FSR8U0Yjn8Om3TKpmhtan983o+cIyPlSOMWvZ/k3eRHetr1Oi
        NQ3uH3sweUGPyzY3VVqnqubdV8U3MBE=
X-Google-Smtp-Source: ABdhPJzmnhVyp3egkTrU8QkVk0tLf+c2QZIjNLK2OPF2DX235miV9ebaE0wp0RVW27A+e4aj90EiUA==
X-Received: by 2002:a63:680a:0:b0:3c2:7c45:c0ab with SMTP id d10-20020a63680a000000b003c27c45c0abmr1190955pgc.63.1651809335894;
        Thu, 05 May 2022 20:55:35 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ck3-20020a17090afe0300b001cd4989feebsm6065187pjb.55.2022.05.05.20.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 20:55:35 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 10/12] lpfc: Alter FPIN stat accounting logic
Date:   Thu,  5 May 2022 20:55:17 -0700
Message-Id: <20220506035519.50908-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220506035519.50908-1-jsmart2021@gmail.com>
References: <20220506035519.50908-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When configuring CMF management based on signals instead of FPINs, FPIN
alarm and warning statistics are not tracked.

Change the behavior so that FPIN alarms and warnings are always tracked
regardless of the configured mode.

Similar changes are made in the CMF signal stat accounting logic.  Upon
receipt of a signal, only track signaled alarms and warnings. FPIN
stats should not be incremented upon receipt of a signal.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c  | 49 +++++++++++------------------------
 drivers/scsi/lpfc/lpfc_init.c | 22 ++--------------
 2 files changed, 17 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 33fac4401e8f..51c505d15410 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3854,9 +3854,6 @@ lpfc_least_capable_settings(struct lpfc_hba *phba,
 {
 	u32 rsp_sig_cap = 0, drv_sig_cap = 0;
 	u32 rsp_sig_freq_cyc = 0, rsp_sig_freq_scale = 0;
-	struct lpfc_cgn_info *cp;
-	u32 crc;
-	u16 sig_freq;
 
 	/* Get rsp signal and frequency capabilities.  */
 	rsp_sig_cap = be32_to_cpu(pcgd->xmt_signal_capability);
@@ -3912,25 +3909,7 @@ lpfc_least_capable_settings(struct lpfc_hba *phba,
 		}
 	}
 
-	if (!phba->cgn_i)
-		return;
-
-	/* Update signal frequency in congestion info buffer */
-	cp = (struct lpfc_cgn_info *)phba->cgn_i->virt;
-
-	/* Frequency (in ms) Signal Warning/Signal Congestion Notifications
-	 * are received by the HBA
-	 */
-	sig_freq = phba->cgn_sig_freq;
-
-	if (phba->cgn_reg_signal == EDC_CG_SIG_WARN_ONLY)
-		cp->cgn_warn_freq = cpu_to_le16(sig_freq);
-	if (phba->cgn_reg_signal == EDC_CG_SIG_WARN_ALARM) {
-		cp->cgn_alarm_freq = cpu_to_le16(sig_freq);
-		cp->cgn_warn_freq = cpu_to_le16(sig_freq);
-	}
-	crc = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ, LPFC_CGN_CRC32_SEED);
-	cp->cgn_info_crc = cpu_to_le32(crc);
+	/* We are NOT recording signal frequency in congestion info buffer */
 	return;
 
 out_no_support:
@@ -9919,11 +9898,14 @@ lpfc_els_rcv_fpin_cgn(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
 			/* Take action here for an Alarm event */
 			if (phba->cmf_active_mode != LPFC_CFG_OFF) {
 				if (phba->cgn_reg_fpin & LPFC_CGN_FPIN_ALARM) {
-					/* Track of alarm cnt for cgn_info */
-					atomic_inc(&phba->cgn_fabric_alarm_cnt);
 					/* Track of alarm cnt for SYNC_WQE */
 					atomic_inc(&phba->cgn_sync_alarm_cnt);
 				}
+				/* Track alarm cnt for cgn_info regardless
+				 * of whether CMF is configured for Signals
+				 * or FPINs.
+				 */
+				atomic_inc(&phba->cgn_fabric_alarm_cnt);
 				goto cleanup;
 			}
 			break;
@@ -9931,11 +9913,14 @@ lpfc_els_rcv_fpin_cgn(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
 			/* Take action here for a Warning event */
 			if (phba->cmf_active_mode != LPFC_CFG_OFF) {
 				if (phba->cgn_reg_fpin & LPFC_CGN_FPIN_WARN) {
-					/* Track of warning cnt for cgn_info */
-					atomic_inc(&phba->cgn_fabric_warn_cnt);
 					/* Track of warning cnt for SYNC_WQE */
 					atomic_inc(&phba->cgn_sync_warn_cnt);
 				}
+				/* Track warning cnt and freq for cgn_info
+				 * regardless of whether CMF is configured for
+				 * Signals or FPINs.
+				 */
+				atomic_inc(&phba->cgn_fabric_warn_cnt);
 cleanup:
 				/* Save frequency in ms */
 				phba->cgn_fpin_frequency =
@@ -9944,14 +9929,10 @@ lpfc_els_rcv_fpin_cgn(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
 				if (phba->cgn_i) {
 					cp = (struct lpfc_cgn_info *)
 						phba->cgn_i->virt;
-					if (phba->cgn_reg_fpin &
-						LPFC_CGN_FPIN_ALARM)
-						cp->cgn_alarm_freq =
-							cpu_to_le16(value);
-					if (phba->cgn_reg_fpin &
-						LPFC_CGN_FPIN_WARN)
-						cp->cgn_warn_freq =
-							cpu_to_le16(value);
+					cp->cgn_alarm_freq =
+						cpu_to_le16(value);
+					cp->cgn_warn_freq =
+						cpu_to_le16(value);
 					crc = lpfc_cgn_calc_crc32
 						(cp,
 						LPFC_CGN_INFO_SZ,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0dedb7cf621b..2bffaa681fcc 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5864,21 +5864,8 @@ lpfc_cgn_save_evt_cnt(struct lpfc_hba *phba)
 
 	/* Use the frequency found in the last rcv'ed FPIN */
 	value = phba->cgn_fpin_frequency;
-	if (phba->cgn_reg_fpin & LPFC_CGN_FPIN_WARN)
-		cp->cgn_warn_freq = cpu_to_le16(value);
-	if (phba->cgn_reg_fpin & LPFC_CGN_FPIN_ALARM)
-		cp->cgn_alarm_freq = cpu_to_le16(value);
-
-	/* Frequency (in ms) Signal Warning/Signal Congestion Notifications
-	 * are received by the HBA
-	 */
-	value = phba->cgn_sig_freq;
-
-	if (phba->cgn_reg_signal == EDC_CG_SIG_WARN_ONLY ||
-	    phba->cgn_reg_signal == EDC_CG_SIG_WARN_ALARM)
-		cp->cgn_warn_freq = cpu_to_le16(value);
-	if (phba->cgn_reg_signal == EDC_CG_SIG_WARN_ALARM)
-		cp->cgn_alarm_freq = cpu_to_le16(value);
+	cp->cgn_warn_freq = cpu_to_le16(value);
+	cp->cgn_alarm_freq = cpu_to_le16(value);
 
 	lvalue = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ,
 				     LPFC_CGN_CRC32_SEED);
@@ -6585,9 +6572,6 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 		/* Alarm overrides warning, so check that first */
 		if (cgn_signal->alarm_cnt) {
 			if (phba->cgn_reg_signal == EDC_CG_SIG_WARN_ALARM) {
-				/* Keep track of alarm cnt for cgn_info */
-				atomic_add(cgn_signal->alarm_cnt,
-					   &phba->cgn_fabric_alarm_cnt);
 				/* Keep track of alarm cnt for CMF_SYNC_WQE */
 				atomic_add(cgn_signal->alarm_cnt,
 					   &phba->cgn_sync_alarm_cnt);
@@ -6596,8 +6580,6 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 			/* signal action needs to be taken */
 			if (phba->cgn_reg_signal == EDC_CG_SIG_WARN_ONLY ||
 			    phba->cgn_reg_signal == EDC_CG_SIG_WARN_ALARM) {
-				/* Keep track of warning cnt for cgn_info */
-				atomic_add(cnt, &phba->cgn_fabric_warn_cnt);
 				/* Keep track of warning cnt for CMF_SYNC_WQE */
 				atomic_add(cnt, &phba->cgn_sync_warn_cnt);
 			}
-- 
2.26.2

