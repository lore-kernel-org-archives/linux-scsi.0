Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEED8C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A355720784
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbhADSEW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727762AbhADSEV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 13:04:21 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2424C0617A6
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:03:27 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id f14so57941pju.4
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 10:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qPdELg+OjQVtOy3duOch0ZFOqM5IHxny4qn9DDoNPCo=;
        b=pqE9qsLkBFdQhnqCcJ55QD4jb+sCQTuBuw7ARhsHv4HR76qnt+FqjEMSIDcsqOJ1dr
         DqsRH64CPgAgWSz8LOwSsA87OQ9BK0xFrCo/i9U3CPnQHuFbSCufxJeIBmmbCgJTR9Oq
         qVIkB0eoZUEgHJP9mksdAc5RgTpcS4xsvh15eiODGk0o+JZJg2VyE0DFbh5jyovO8GB6
         Zr9Hnam6tT7eQDLXdQeKtw9LjeT/nez0vxKQWii/yV6jvcqy7Dwtkj68PAfuRI07RZmT
         RHm3H5Fm9iMRf9G/C/0cjTi5wutquulY1DON+GT2s96TL4TPFHw4vhQjCCHKnzZiCs6N
         0EiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qPdELg+OjQVtOy3duOch0ZFOqM5IHxny4qn9DDoNPCo=;
        b=crwreNGx/IePqkVjbg1jPNrf7y6UihoYydV2aqC5HbBOW18dl+8BrxyLeYt6HLP38P
         9yxk0eHA82ZTnTVl8jgV22dkEnoW07DKnSC1dQDEAZFiiaE9/HCHJj5b+UCtNMfGjhvw
         hbpz6/ATWTC8JLLgLmmb9BlSH3nfgSzTnijMbudO1DzNg7OrUApnSyt91qIzeTsoSEyl
         w5lKiRggD4SanlUnIkoV0Vc23uaoWb2HBt7UDIPL8TmmeQwXLGShPpxvRLNuJWImyhue
         Vjri7AX8QKC/nXhaUTa/g62MEIFwl2/+W8lSH3FpniiymTNgavavfhw2q0W2Wqc9OKiA
         MaoQ==
X-Gm-Message-State: AOAM530XH29o1rh1Zz7u9hILkxyegTt3hL44dV6xywMuBRqjdkx7H6zj
        h5yrg7Seix+idTor7eUHfQW4r+20mZ8=
X-Google-Smtp-Source: ABdhPJxUT/rosTT0yyNSdHB5gCHOwcFkO1MFxKBu80aSZYn47xUgjInaLeNk9h76clxEvs/zs+OLng==
X-Received: by 2002:a17:902:d34a:b029:da:861e:ecd8 with SMTP id l10-20020a170902d34ab02900da861eecd8mr66480355plk.45.1609783407353;
        Mon, 04 Jan 2021 10:03:27 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm57570885pfg.18.2021.01.04.10.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 10:03:26 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 14/15] lpfc: Enhancements to LOG_TRACE_EVENT for better readability
Date:   Mon,  4 Jan 2021 10:02:39 -0800
Message-Id: <20210104180240.46824-15-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While testing recent discovery node rework, several items were seen
that could be done better with respect to the new trace event logic.

1) in the following msg:
      kernel: lpfc 0000:44:00.0: start 35 end 35 cnt 0
   If cnt is zero in the 1st message, there is no reason to display the
   1st message, which is just giving start/end positioning.

   Fix by not displaying message if cnt is 0.

2) If the driver is loaded with module log verbosity off, and later a
   single NPIV host instance verbosity is enabled via sysfs, it enables
   messages on all instances. This is due to the trace log verbosity
   checks (lpfc_dmp_dbg) looking at the phba only. It should look at the
   phba and the vport.

   Fix by enabling a check on both phba and vport.

3) in the following messages:
       2904 Firmware Dump Image Present on Adapter
       2887 Reset Needed: Attempting Port Recovery...
   These messages are not necessary for the trace event log, which is
   primarily for discovery.

   Fix by changing log level on these 2 messages to LOG_SLI.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 20 +++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli.c  |  2 +-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index dbd7e40f67f9..71f340dd4fbd 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1865,7 +1865,7 @@ lpfc_sli4_port_sta_fn_reset(struct lpfc_hba *phba, int mbx_action,
 
 	/* need reset: attempt for port recovery */
 	if (en_rn_msg)
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"2887 Reset Needed: Attempting Port "
 				"Recovery...\n");
 
@@ -14177,15 +14177,32 @@ void lpfc_dmp_dbg(struct lpfc_hba *phba)
 	int i;
 	int j = 0;
 	unsigned long rem_nsec;
+	struct lpfc_vport **vports;
 
+	/* Don't dump messages if we explicitly set log_verbose for the
+	 * physical port or any vport.
+	 */
 	if (phba->cfg_log_verbose)
 		return;
 
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL) {
+		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+			if (vports[i]->cfg_log_verbose) {
+				lpfc_destroy_vport_work_array(phba, vports);
+				return;
+			}
+		}
+	}
+	lpfc_destroy_vport_work_array(phba, vports);
+
 	if (atomic_cmpxchg(&phba->dbg_log_dmping, 0, 1) != 0)
 		return;
 
 	start_idx = (unsigned int)atomic_read(&phba->dbg_log_idx) % DBG_LOG_SZ;
 	dbg_cnt = (unsigned int)atomic_read(&phba->dbg_log_cnt);
+	if (!dbg_cnt)
+		goto out;
 	temp_idx = start_idx;
 	if (dbg_cnt >= DBG_LOG_SZ) {
 		dbg_cnt = DBG_LOG_SZ;
@@ -14215,6 +14232,7 @@ void lpfc_dmp_dbg(struct lpfc_hba *phba)
 			 rem_nsec / 1000,
 			 phba->dbg_log[temp_idx].log);
 	}
+out:
 	atomic_set(&phba->dbg_log_cnt, 0);
 	atomic_set(&phba->dbg_log_dmping, 0);
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index d51d86959bbc..fa1a714a78f0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7491,7 +7491,7 @@ static void lpfc_sli4_dip(struct lpfc_hba *phba)
 			return;
 
 		if (bf_get(lpfc_sliport_status_dip, &reg_data))
-			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"2904 Firmware Dump Image Present"
 					" on Adapter");
 	}
-- 
2.26.2

