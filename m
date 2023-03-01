Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1263C7EE23
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 23:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbjCAXHm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 18:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjCAXHd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 18:07:33 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E846556501
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 15:07:30 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id l18so15180229qtp.1
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 15:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677712050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4NuW/fyBX5PvRhWHd/VY/4AadEIaueL9fCOPZtAPXjM=;
        b=aGC/c5Y5djl40XdnKpP9RQu275cv+fS5OFsWd51LLP5vYDrcElvgstVAUQP+zpp7Yr
         oh6XYOzi+I6jRq5g9XwyIuIbG2wFqJsKFvWj6Kra4uvN7yDfgVdM+luMrMGqBrqYVqyx
         edp2mlu7F/kxA46TxzQz8FedANNQEL18w5gxQYaBsqq3xekdaq+9qU8bUfqwE4JWXc5t
         4dlB1FRnEnenDvLI9WfbMwMCPj7cY8Djq8409R4nq9mES7YbTZ7yRpMFklLX9NZpz8h/
         Ix+i3bhaHpj2L24OptMM72cy1W6jFp1kyW8tvJdX1tYO7vXmmn4AEcU+Ofp9Ds2NAi6I
         Z0vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677712050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4NuW/fyBX5PvRhWHd/VY/4AadEIaueL9fCOPZtAPXjM=;
        b=PwJ/HXCCI6YDn4751+Uaxr2bHRu4E+F7OZSMgn0xsWSxUr+7c4T+vQHYLDM0A564dP
         SkmfjcPDk6POsiz5LTmbIR/MGNzQyDtKFO5iQEDs6g3Y7yVR6nHBH/AeNDVLHfFFXYDJ
         SVWTOdO676VyG0zdx+uzVvfu4Fp72edpH1ncsqAs2wn0cxWcU8FwktJyaHk/TKafSL9m
         qdWu2Z+Woo8w32LiCAORUB/hzWnNXLdUIlvN0Op6811B4rloFaabL6UBBOd2OYgRGGc3
         35PUq7Coc/OQ3lZZD1E0gXiuQKUDG0ysbJgCJ8cTokjdjceXUK+qxcsrMLcRGUkB//86
         GL4A==
X-Gm-Message-State: AO0yUKUyA7sJwFMRame5GKa9UcslyToTuHGqBQkM89znBOeKJN3HHLm8
        +f75T7D54ANNPREMXI0ufohzwEZg0yk=
X-Google-Smtp-Source: AK7set9rj/WlBq1QudITm99Cm5zFstKVdBLAJ69dyvrCQ2HGabyQtQSCgz4jvHmYqAXOZJP4JM/0kg==
X-Received: by 2002:ac8:5c86:0:b0:3bf:b0c6:497b with SMTP id r6-20020ac85c86000000b003bfb0c6497bmr16155956qta.2.1677712049722;
        Wed, 01 Mar 2023 15:07:29 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9-20020ac85509000000b003b86b99690fsm9047572qtq.62.2023.03.01.15.07.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Mar 2023 15:07:29 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 08/10] lpfc: Revise lpfc_error_lost_link reason code evaluation logic
Date:   Wed,  1 Mar 2023 15:16:24 -0800
Message-Id: <20230301231626.9621-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230301231626.9621-1-justintee8345@gmail.com>
References: <20230301231626.9621-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Extended status reason code errors should mask off the IOERR_PARAM_MASK
before checking strict equalities for IOERR values.

Update the lpfc_error_lost_link routine as such.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h    |  2 ++
 drivers/scsi/lpfc/lpfc_ct.c      |  4 ++--
 drivers/scsi/lpfc/lpfc_els.c     | 14 ++++++-------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 35 ++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_hw.h      | 12 -----------
 5 files changed, 46 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 976fd5ee7f7e..b833b983e69d 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -458,6 +458,8 @@ void lpfc_get_cfgparam(struct lpfc_hba *);
 void lpfc_get_vport_cfgparam(struct lpfc_vport *);
 int lpfc_alloc_sysfs_attr(struct lpfc_vport *);
 void lpfc_free_sysfs_attr(struct lpfc_vport *);
+bool lpfc_error_lost_link(struct lpfc_vport *vport, u32 ulp_status,
+			  u32 ulp_word4);
 extern const struct attribute_group *lpfc_hba_groups[];
 extern const struct attribute_group *lpfc_vport_groups[];
 extern struct scsi_host_template lpfc_template;
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index e290aff2e881..c6e10e23f342 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -958,7 +958,7 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 		goto out;
 	}
-	if (lpfc_error_lost_link(ulp_status, ulp_word4)) {
+	if (lpfc_error_lost_link(vport, ulp_status, ulp_word4)) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "0226 NS query failed due to link event: "
 				 "ulp_status x%x ulp_word4 x%x fc_flag x%x "
@@ -1181,7 +1181,7 @@ lpfc_cmpl_ct_cmd_gid_pt(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 		goto out;
 	}
-	if (lpfc_error_lost_link(ulp_status, ulp_word4)) {
+	if (lpfc_error_lost_link(vport, ulp_status, ulp_word4)) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "4166 NS query failed due to link event: "
 				 "ulp_status x%x ulp_word4 x%x fc_flag x%x "
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 9f50f6116627..6a15f879e517 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1088,7 +1088,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			}
 
 			/* Do not register VFI if the driver aborted FLOGI */
-			if (!lpfc_error_lost_link(ulp_status, ulp_word4))
+			if (!lpfc_error_lost_link(vport, ulp_status, ulp_word4))
 				lpfc_issue_reg_vfi(vport);
 
 			lpfc_nlp_put(ndlp);
@@ -1207,7 +1207,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
 	spin_unlock_irq(&phba->hbalock);
 
-	if (!lpfc_error_lost_link(ulp_status, ulp_word4)) {
+	if (!lpfc_error_lost_link(vport, ulp_status, ulp_word4)) {
 		/* FLOGI failed, so just use loop map to make discovery list */
 		lpfc_disc_list_loopmap(vport);
 
@@ -2087,7 +2087,7 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 					 ulp_word4);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (!lpfc_error_lost_link(ulp_status, ulp_word4))
+		if (!lpfc_error_lost_link(vport, ulp_status, ulp_word4))
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PLOGI);
 
@@ -2383,7 +2383,7 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 ndlp->fc4_prli_sent);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (!lpfc_error_lost_link(ulp_status, ulp_word4))
+		if (!lpfc_error_lost_link(vport, ulp_status, ulp_word4))
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PRLI);
 
@@ -3038,7 +3038,7 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 ndlp->nlp_DID, ulp_status,
 				 ulp_word4);
 
-		if (lpfc_error_lost_link(ulp_status, ulp_word4))
+		if (lpfc_error_lost_link(vport, ulp_status, ulp_word4))
 			skip_recovery = 1;
 	}
 
@@ -4930,7 +4930,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	if ((cmd == ELS_CMD_FLOGI) &&
 	    (phba->fc_topology != LPFC_TOPOLOGY_LOOP) &&
-	    !lpfc_error_lost_link(ulp_status, ulp_word4)) {
+	    !lpfc_error_lost_link(vport, ulp_status, ulp_word4)) {
 		/* FLOGI retry policy */
 		retry = 1;
 		/* retry FLOGI forever */
@@ -4944,7 +4944,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		else if (cmdiocb->retry >= 32)
 			delay = 1000;
 	} else if ((cmd == ELS_CMD_FDISC) &&
-	    !lpfc_error_lost_link(ulp_status, ulp_word4)) {
+	    !lpfc_error_lost_link(vport, ulp_status, ulp_word4)) {
 		/* retry FDISCs every second up to devloss */
 		retry = 1;
 		maxretry = vport->cfg_devloss_tmo;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 11ba26ac495a..5ba3a9ad9501 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -7269,3 +7269,38 @@ lpfc_parse_fcoe_conf(struct lpfc_hba *phba,
 		lpfc_read_fcf_conn_tbl(phba, rec_ptr);
 
 }
+
+/*
+ * lpfc_error_lost_link - IO failure from link event or FW reset check.
+ *
+ * @vport: Pointer to lpfc_vport data structure.
+ * @ulp_status: IO completion status.
+ * @ulp_word4: Reason code for the ulp_status.
+ *
+ * This function evaluates the ulp_status and ulp_word4 values
+ * for specific error values that indicate an internal link fault
+ * or fw reset event for the completing IO.  Callers require this
+ * common data to decide next steps on the IO.
+ *
+ * Return:
+ * false - No link or reset error occurred.
+ * true - A link or reset error occurred.
+ */
+bool
+lpfc_error_lost_link(struct lpfc_vport *vport, u32 ulp_status, u32 ulp_word4)
+{
+	/* Mask off the extra port data to get just the reason code. */
+	u32 rsn_code = IOERR_PARAM_MASK & ulp_word4;
+
+	if (ulp_status == IOSTAT_LOCAL_REJECT &&
+	    (rsn_code == IOERR_SLI_ABORTED ||
+	     rsn_code == IOERR_LINK_DOWN ||
+	     rsn_code == IOERR_SLI_DOWN)) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_SLI | LOG_ELS,
+				 "0408 Report link error true: <x%x:x%x>\n",
+				 ulp_status, ulp_word4);
+		return true;
+	}
+
+	return false;
+}
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 5c283936ff08..e9244bedb0f4 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -4435,16 +4435,4 @@ lpfc_is_LC_HBA(unsigned short device)
 		return 0;
 }
 
-/*
- * Determine if failed because of a link event or firmware reset.
- */
-static inline int
-lpfc_error_lost_link(u32 ulp_status, u32 ulp_word4)
-{
-	return (ulp_status == IOSTAT_LOCAL_REJECT &&
-		(ulp_word4 == IOERR_SLI_ABORTED ||
-		 ulp_word4 == IOERR_LINK_DOWN ||
-		 ulp_word4 == IOERR_SLI_DOWN));
-}
-
 #define BPL_ALIGN_SZ 8 /* 8 byte alignment for bpl and mbufs */
-- 
2.38.0

