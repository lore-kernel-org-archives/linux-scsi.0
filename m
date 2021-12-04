Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8645AC433FE
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Dec 2021 00:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354449AbhLDAaR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 19:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344630AbhLDAaQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 19:30:16 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2F6C061353
        for <linux-scsi@vger.kernel.org>; Fri,  3 Dec 2021 16:26:51 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id s37so4606382pga.9
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 16:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ur/r6wT/Vkx34niFpBt5uzndAh1CFO1vZCZdCvcCCxg=;
        b=FervtfrDDlhkyT/du5h87yCB7RpDpPr02S9TKP7GRSFXVdsomMRlI3+PuyJpTHyUdD
         G+1TAo/QQ7pbN74ZuSiw0BMeopk9ze16FmnMJVD0xQB8n/uuTXg9Yqixo1uplxqM9maf
         5pO2Pdl+/Etzq60IZmfsPvbUQWFZhEa1kIqbo08BbJ+CN75luO+irRskuNNLGqxiFHlS
         aQRJVu6aCxgtdZE7+P1r7M8LqXpQAPzmYxf4ts+ewv0cYn0y7lvmaZ6a0x2s4m0g8/ib
         qPo2eMdCW9AcAvVzc8C70pdgR4czBL/OUxQ4Bac444IlMYzZyARyXOrn4l2YtNh/xiZ2
         R0Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ur/r6wT/Vkx34niFpBt5uzndAh1CFO1vZCZdCvcCCxg=;
        b=1Ppfhmrf1TbExRAyCC8Jpd88r30ASd06PpmoSOofbVg7ck0XGexBj/G8VCAvAjv5Bf
         te2CBc7BquKyHYTyOrA4boB1qr7RmkzgNuZvbelxCFfmZNpXRpVgpfHn2nrZIw0c6S8A
         rHwdB3JHEeUkjoFV2Pjwu2JEO1H+E0IqwVIhi00mzKSKKRXl3HGNHuYtJ5ljJTR5333X
         wWRExeOKcOIEomd/nklZF5kz/UmjJOdRjZJbW3TLHM7NnOZc1yJbBYEJZFgO8FMVPcJc
         Ci404ve3k7Xc/2R6J/bX5l7bs3LncfSJkV3BFYDp/LiBSorPT0nOWDrRVXbIIoPBLJvo
         CWtA==
X-Gm-Message-State: AOAM5339j2cgEvIkJ1QaJUeC1BrBrrnl+acrQqIjC+BA0QmsJLOJTs1M
        FwVztgnxBwgqbKD+EaUStETENi2AWSI=
X-Google-Smtp-Source: ABdhPJysXjvIRshm1X8WO8oDfqW/j0BiOD5yNcVSZM9BFKrgewPuKz/pgI12hvlzqSenIHt2QuPpxw==
X-Received: by 2002:a05:6a00:ac6:b029:374:a33b:a74 with SMTP id c6-20020a056a000ac6b0290374a33b0a74mr22161365pfl.51.1638577611194;
        Fri, 03 Dec 2021 16:26:51 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q17sm4970707pfu.117.2021.12.03.16.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 16:26:50 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 1/9] lpfc: Fix leaked lpfc_dmabuf mbox allocations with npiv
Date:   Fri,  3 Dec 2021 16:26:36 -0800
Message-Id: <20211204002644.116455-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211204002644.116455-1-jsmart2021@gmail.com>
References: <20211204002644.116455-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During rmmod testing, messages appeared indicating lpfc_mbuf_pool entries
were still busy. This situation was only seen doing rmmod after at least
1 vport (NPIV) instance was created and destroyed. The number of messages
scaled with the number of vports created.

When a vport is created, it can receive a PLOGI from another initiator
Nport.  When this happens, the driver prepares to ack the plogi and
prepares an RPI for registration (via mbx cmd) which includes an mbuf
allocation. During the unsolicited plogi processing and after the rpi
preparation, the driver recognizes it's one of the vport instances and
decides to reject the PLOGI. During the LS_RJT preparation for the PLOGI,
the mailbox struct allocated for RPI registration is freed, but the mbuf
that was also allocated is not released.

Fix by freeing the mbuf with the mailbox struct in the LS_RJT path.

As part of the code review to figure the issue out, a couple of other
areas where found that also would not have released the mbuf. Those
are cleaned up as well.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c       | 6 +++++-
 drivers/scsi/lpfc/lpfc_init.c      | 8 ++++++--
 drivers/scsi/lpfc/lpfc_nportdisc.c | 6 ++++++
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index e83453bea2ae..5c10416c1c75 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -6899,6 +6899,7 @@ static int
 lpfc_get_rdp_info(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context)
 {
 	LPFC_MBOXQ_t *mbox = NULL;
+	struct lpfc_dmabuf *mp;
 	int rc;
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
@@ -6914,8 +6915,11 @@ lpfc_get_rdp_info(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context)
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_rdp_page_a0;
 	mbox->ctx_ndlp = (struct lpfc_rdp_context *)rdp_context;
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
-	if (rc == MBX_NOT_FINISHED)
+	if (rc == MBX_NOT_FINISHED) {
+		mp = (struct lpfc_dmabuf *)mbox->ctx_buf;
+		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		goto issue_mbox_fail;
+	}
 
 	return 0;
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ba17a8f740a9..7628b0634c57 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5373,8 +5373,10 @@ lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
 	 */
 	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
 		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
-		if (rc == MBX_NOT_FINISHED)
+		if (rc == MBX_NOT_FINISHED) {
+			lpfc_mbuf_free(phba, mp->virt, mp->phys);
 			goto out_free_dmabuf;
+		}
 		return;
 	}
 	/*
@@ -6337,8 +6339,10 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *phba, struct lpfc_acqe_fc_la *acqe_fc)
 	}
 
 	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
-	if (rc == MBX_NOT_FINISHED)
+	if (rc == MBX_NOT_FINISHED) {
+		lpfc_mbuf_free(phba, mp->virt, mp->phys);
 		goto out_free_dmabuf;
+	}
 	return;
 
 out_free_dmabuf:
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 27263f02ab9f..7d717a4ac14d 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -322,6 +322,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 {
 	struct lpfc_hba    *phba = vport->phba;
 	struct lpfc_dmabuf *pcmd;
+	struct lpfc_dmabuf *mp;
 	uint64_t nlp_portwwn = 0;
 	uint32_t *lp;
 	IOCB_t *icmd;
@@ -571,6 +572,11 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		 * a default RPI.
 		 */
 		if (phba->sli_rev == LPFC_SLI_REV4) {
+			mp = (struct lpfc_dmabuf *)login_mbox->ctx_buf;
+			if (mp) {
+				lpfc_mbuf_free(phba, mp->virt, mp->phys);
+				kfree(mp);
+			}
 			mempool_free(login_mbox, phba->mbox_mem_pool);
 			login_mbox = NULL;
 		} else {
-- 
2.26.2

