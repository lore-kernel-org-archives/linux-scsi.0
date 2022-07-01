Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D48C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 21:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbiGAVPM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 17:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiGAVPI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 17:15:08 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325264163F
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 14:15:07 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id b133so2718502qkc.6
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2022 14:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hkom9/V5kSNPIdNrL8sYvaqYmccrsMrCEbg+qguoL2k=;
        b=bHTENbV+uZcHJ3SBHU0Z/fJ1Bo3pRrqTj4OiXkHq2E6aHwwonDVfrGEJqSDC1s6zTx
         EVQinyBCw4ftsQTlwqbopDjwDD29RPJgSe2ejzNhqhWrsUZv0fg4dinwDU0Ip/6GPEKA
         IyzjfJn2F78QMdi6RyTX5+W53mRjnkELuVSXKz5Q1/hhEEQCuI7gq8/octS9P1s4z3sK
         Lm3HTpn0MmVDk7WHZrNKNy+tyd6FOzzE2cH7DKoVoZSbUXAZhmV4M6J/TOd4T4q0yr6c
         PNkYsCGvk2b0UJIdekaKdMA7Finwl6zwuo7sh7uz/WiTii8eR5fg8wT3FpiEm7sFoUoL
         wLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hkom9/V5kSNPIdNrL8sYvaqYmccrsMrCEbg+qguoL2k=;
        b=DiHQxVSwV3X/UwGOTxkF+fSxB7Lwr6sPMMyeyXjeiY3wJIzPPo8c4YMErOhHcl/NjU
         z1ZmBd3tNCTEMFeblWnC8I7YbLM66QxIDwCOcocrUVTrYTdedXfoXOO0Ua/rvVtWdajQ
         ajpzjzxyrVjUnj/7APN8iaKfLY6aO0PdxYGfQ0U1NDifN26ssWVDrMtx89hoyJ4HXR5A
         qDQXDmi2wq8OUXCq+m5iyMmBxNq1gacK/0casUPwxuLTFkernHtRjpGG2K7+VBCQcZ8t
         rInf89LiYuhY4NSeU71uW+85wuz8OOh+pk4pQ9Qzsw0cl13F+Z3mcSfsN7v2kwL/nAx9
         603g==
X-Gm-Message-State: AJIora98G6K6tevRwBYDoiOIncgT4HXIpp+O2Yoljuw91cQ3lfUQmc0i
        ZgaXVUeKqynVi8b+/11r+GxAf9QAiQ0=
X-Google-Smtp-Source: AGRyM1sqRmIth/RHJmqrUdEfkCVpTe4U+mgLCLoJSkRx/D/1Bdtn+sXZetjmuCODpBKpXNWQZuWtMQ==
X-Received: by 2002:a05:620a:414b:b0:6af:2281:6c98 with SMTP id k11-20020a05620a414b00b006af22816c98mr12171061qko.93.1656710106147;
        Fri, 01 Jul 2022 14:15:06 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g6-20020ac842c6000000b00317ccc66971sm14584509qtm.52.2022.07.01.14.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 14:15:05 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 06/12] lpfc: Fix attempted FA-PWWN usage after feature disable
Date:   Fri,  1 Jul 2022 14:14:19 -0700
Message-Id: <20220701211425.2708-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220701211425.2708-1-jsmart2021@gmail.com>
References: <20220701211425.2708-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Disabling FA-PWWN should be effective after port reset, but in some cases
it was found to be impossible to clear FA-PWWN usage without a driver
reload.

Clean up FA-PWWN flag management to make enable and disable of the feature
more robust.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 6 +++++-
 drivers/scsi/lpfc/lpfc_sli.c  | 7 ++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 750dd1e9f2cc..7424b194d20e 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -375,6 +375,9 @@ lpfc_update_vport_wwn(struct lpfc_vport *vport)
 		if (phba->sli_rev == LPFC_SLI_REV4 &&
 		    vport->port_type == LPFC_PHYSICAL_PORT &&
 		    phba->sli4_hba.fawwpn_flag & LPFC_FAWWPN_FABRIC) {
+			if (!(phba->sli4_hba.fawwpn_flag & LPFC_FAWWPN_CONFIG))
+				phba->sli4_hba.fawwpn_flag &=
+						~LPFC_FAWWPN_FABRIC;
 			lpfc_printf_log(phba, KERN_INFO,
 					LOG_SLI | LOG_DISCOVERY | LOG_ELS,
 					"2701 FA-PWWN change WWPN from %llx to "
@@ -9975,7 +9978,8 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 					"configured on\n");
 			phba->sli4_hba.fawwpn_flag |= LPFC_FAWWPN_CONFIG;
 		} else {
-			phba->sli4_hba.fawwpn_flag = 0;
+			/* Clear FW configured flag, preserve driver flag */
+			phba->sli4_hba.fawwpn_flag &= ~LPFC_FAWWPN_CONFIG;
 		}
 
 		phba->sli4_hba.conf_trunk =
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 81c61d377e43..71442faaa6c2 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5265,7 +5265,8 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 	phba->pport->stopped = 0;
 	phba->link_state = LPFC_INIT_START;
 	phba->hba_flag = 0;
-	phba->sli4_hba.fawwpn_flag = 0;
+	/* Preserve FA-PWWN expectation */
+	phba->sli4_hba.fawwpn_flag &= LPFC_FAWWPN_FABRIC;
 	spin_unlock_irq(&phba->hbalock);
 
 	memset(&psli->lnk_stat_offsets, 0, sizeof(psli->lnk_stat_offsets));
@@ -6054,6 +6055,10 @@ lpfc_sli4_retrieve_pport_name(struct lpfc_hba *phba)
 	/* obtain link type and link number via READ_CONFIG */
 	phba->sli4_hba.lnk_info.lnk_dv = LPFC_LNK_DAT_INVAL;
 	lpfc_sli4_read_config(phba);
+
+	if (phba->sli4_hba.fawwpn_flag & LPFC_FAWWPN_CONFIG)
+		phba->sli4_hba.fawwpn_flag |= LPFC_FAWWPN_FABRIC;
+
 	if (phba->sli4_hba.lnk_info.lnk_dv == LPFC_LNK_DAT_VAL)
 		goto retrieve_ppname;
 
-- 
2.26.2

