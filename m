Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4384DC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 03:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388866AbiEFD72 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 23:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388837AbiEFD7O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 23:59:14 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963A57662
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 20:55:31 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r192so971387pgr.6
        for <linux-scsi@vger.kernel.org>; Thu, 05 May 2022 20:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SLwWUvlai3KzAUVZn6rYkydiknSt0y7PlHGQ2nlMZV4=;
        b=JKqioQyFdo5S2TlsQuyGXK+kMWELnCXzc3H6SeKtMQJsV1zxNGyI+gky05KdTqjjKb
         fk1O96hvUrxPSgcue1U67IjLueO5lXdrAL3qQG2AFKJoy2raKeQ23DIq7RiMs+trZqZE
         XlqtDp3qniuE2hzlGvgPsOM5BeXbkxFQkz12pZyChhrBNkTmC04cAgimycpoo4TJLEzR
         KdAfl8Tc2vcK8hdFHezrXGhj3/MrXqD0pUs/OjHrS645aal+saH2epHZK5DPVYsZ2jfC
         mulDybohr2qXotsu6qyod0AH2UavvQs4WZXjhjwtBZZz3S6K8O6HDLQj3Q+uc2AaqFRC
         Xu+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SLwWUvlai3KzAUVZn6rYkydiknSt0y7PlHGQ2nlMZV4=;
        b=4W2LOh6gW8jIPriiSzbn8egZNurzJ2gvtGwuFdm+NYGW5LBm1bKO3nzLbU5E4h9DZR
         IniW53uLGILicr9eVVdtFfabtUGipb17nqrYeBChfqMlEu9GhIbifi7pCfJGNQyWYDXN
         fMeu++PFbZxDtbj4S6DqkO8EZRyt9s9QvO/hPxPdKzjWp+sRSZHKAEUG9j9H75CT4ffz
         9eHy51uaLjm8O/QaR98g4jlGgwceeccZC2ViLy6sjtg+n0DzfuDKNUgQQku6odLMe68d
         Wpd3mOw16mY/DyqLMTmx9cDipNRIyktowPyQXSXD0GFZZmTAWaTUl/h1EhGmz6/6VvtH
         cm5g==
X-Gm-Message-State: AOAM533csddpcffVXvBA9d0qHlkrM18ushKghs1Eadzjsr6+7wZ74Sh2
        rub2YK9UyW7VsbKJ2ZsczAEQu4q6Cwo=
X-Google-Smtp-Source: ABdhPJwnQGkVjOagTbmZKA8sKGeZLWEsYIRtb2Ee+PYeHXcXTCWh8oQd8/ZPyAUo2a/5wi9nZskSxA==
X-Received: by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP id l15-20020a056a00140f00b004e069959c48mr1690459pfu.59.1651809330862;
        Thu, 05 May 2022 20:55:30 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ck3-20020a17090afe0300b001cd4989feebsm6065187pjb.55.2022.05.05.20.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 20:55:30 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 04/12] lpfc: Inhibit aborts if external loopback plug is inserted
Date:   Thu,  5 May 2022 20:55:11 -0700
Message-Id: <20220506035519.50908-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220506035519.50908-1-jsmart2021@gmail.com>
References: <20220506035519.50908-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After running a short external loopback test, when the external loopback
is removed and a normal cable inserted that is directly connected to a
target device, the system oops in the llpfc_set_rrq_active routine.

When the loopback was inserted an FLOGI was transmit. As we're looped
back, we receive the FLOGI request. The FLOGI is ABTS'd as we recognize
the same wppn thus understand it's a loopback. However, as the ABTS sends
address information the port is not set to (fffffe), the ABTS is dropped
on the wire. A short 1 frame loopback test is run and completes before
the ABTS times out. The looback is unplugged and the new cable plugged
in, and the an FLOGI to the new device occurs and completes. Due to a
mixup in ref counting the completion of the new FLOGI releases the
fabric ndlp. Then the original ABTS completes and references the
released ndlp generating the oops.

Correct by no-op'ing the ABTS when in loopback mode (it will be dropped
anyway). Added a flag to track the mode to recognize when it should be
no-op'd.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         |  1 +
 drivers/scsi/lpfc/lpfc_els.c     | 12 ++++++++++++
 drivers/scsi/lpfc/lpfc_hbadisc.c |  3 +++
 drivers/scsi/lpfc/lpfc_sli.c     |  8 +++++---
 4 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 346661dc5bf2..405c8a8dd795 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1025,6 +1025,7 @@ struct lpfc_hba {
 #define LS_MDS_LINK_DOWN      0x8	/* MDS Diagnostics Link Down */
 #define LS_MDS_LOOPBACK       0x10	/* MDS Diagnostics Link Up (Loopback) */
 #define LS_CT_VEN_RPA         0x20	/* Vendor RPA sent to switch */
+#define LS_EXTERNAL_LOOPBACK  0x40	/* External loopback plug inserted */
 
 	uint32_t hba_flag;	/* hba generic flags */
 #define HBA_ERATT_HANDLED	0x1 /* This flag is set when eratt handled */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index ace812ce857d..583a287b2d0c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1373,6 +1373,9 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	phba->hba_flag |= (HBA_FLOGI_ISSUED | HBA_FLOGI_OUTSTANDING);
 
+	/* Clear external loopback plug detected flag */
+	phba->link_flag &= ~LS_EXTERNAL_LOOPBACK;
+
 	/* Check for a deferred FLOGI ACC condition */
 	if (phba->defer_flogi_acc_flag) {
 		/* lookup ndlp for received FLOGI */
@@ -8128,6 +8131,9 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	uint32_t fc_flag = 0;
 	uint32_t port_state = 0;
 
+	/* Clear external loopback plug detected flag */
+	phba->link_flag &= ~LS_EXTERNAL_LOOPBACK;
+
 	cmd = *lp++;
 	sp = (struct serv_parm *) lp;
 
@@ -8179,6 +8185,12 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			return 1;
 		}
 
+		/* External loopback plug insertion detected */
+		phba->link_flag |= LS_EXTERNAL_LOOPBACK;
+
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS | LOG_LIBDFC,
+				 "1119 External Loopback plug detected\n");
+
 		/* abort the flogi coming back to ourselves
 		 * due to external loopback on the port.
 		 */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index e4805101cd5c..a833a493a3ee 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1229,6 +1229,9 @@ lpfc_linkdown(struct lpfc_hba *phba)
 
 	phba->defer_flogi_acc_flag = false;
 
+	/* Clear external loopback plug detected flag */
+	phba->link_flag &= ~LS_EXTERNAL_LOOPBACK;
+
 	spin_lock_irq(&phba->hbalock);
 	phba->fcf.fcf_flag &= ~(FCF_AVAILABLE | FCF_SCAN_DONE);
 	spin_unlock_irq(&phba->hbalock);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index fe4eb36426df..b509b3147759 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12201,7 +12201,8 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	if (phba->link_state < LPFC_LINK_UP ||
 	    (phba->sli_rev == LPFC_SLI_REV4 &&
-	     phba->sli4_hba.link_state.status == LPFC_FC_LA_TYPE_LINK_DOWN))
+	     phba->sli4_hba.link_state.status == LPFC_FC_LA_TYPE_LINK_DOWN) ||
+	    (phba->link_flag & LS_EXTERNAL_LOOPBACK))
 		ia = true;
 	else
 		ia = false;
@@ -12660,7 +12661,8 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		ndlp = lpfc_cmd->rdata->pnode;
 
 		if (lpfc_is_link_up(phba) &&
-		    (ndlp && ndlp->nlp_state == NLP_STE_MAPPED_NODE))
+		    (ndlp && ndlp->nlp_state == NLP_STE_MAPPED_NODE) &&
+		    !(phba->link_flag & LS_EXTERNAL_LOOPBACK))
 			ia = false;
 		else
 			ia = true;
@@ -21112,7 +21114,7 @@ lpfc_sli4_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	abtswqe = &abtsiocb->wqe;
 	memset(abtswqe, 0, sizeof(*abtswqe));
 
-	if (!lpfc_is_link_up(phba))
+	if (!lpfc_is_link_up(phba) || (phba->link_flag & LS_EXTERNAL_LOOPBACK))
 		bf_set(abort_cmd_ia, &abtswqe->abort_cmd, 1);
 	bf_set(abort_cmd_criteria, &abtswqe->abort_cmd, T_XRI_TAG);
 	abtswqe->abort_cmd.rsrvd5 = 0;
-- 
2.26.2

