Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D892C47254
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 386472068E
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JDo26L/U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgEAVng (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 17:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgEAVnf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 17:43:35 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B83E4C061A0C
        for <linux-scsi@vger.kernel.org>; Fri,  1 May 2020 14:43:33 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g12so1288612wmh.3
        for <linux-scsi@vger.kernel.org>; Fri, 01 May 2020 14:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U1bVtl4y9fwwi9e93e1qxOPfvWLUSQ8CJk/V0MzCuyk=;
        b=JDo26L/UYIIbJ7EknjdYpxKZam88v0ZeYIOe9MDgKUO04h61XbykoV7BkhAtQecc12
         cffcldrPI465a7dV3OAT3bFNlue2dh+8pc7J8DtfQbjjujqeUgOWxn4ZF6oD+MYP91XT
         Cns7mjAHemK+K8oYpB3miCuFnFdpnGi78B1PP5h6NmYvN0itMwFriSZWnTScgdjnONz+
         /14DFomvcKBklsmowJHOX0WrEW+dAsHIyU8jjQb2A0M0917P3aSA7H561whRAoHZnFQ7
         fVVmlUhxleu3hqyeF5MKuD/SK85dACteB7ms8BFBjmvbfBZaWi/0Ok54FllTifd43U9R
         KtDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U1bVtl4y9fwwi9e93e1qxOPfvWLUSQ8CJk/V0MzCuyk=;
        b=J7cQVZQH7pfpMuGscQ65+1E7UN4+U1p1M+6Dq3H9lzV+FpoYKgKCgFfi6y8yzJQ1Tc
         bBr9biV6+Y/i8Y53IBZJITimuqmN6wQ8rz6GukCLD2dl1TzR+/PKav5oFm79egs+/cRV
         X2cfeCvquHUq2Du+k/6E5YOOuXlQPa9oLfsJknPSjrG4saVzVpoX/b78SQl/qIalFFXR
         MSQ6TPKXxWoCeIFeGWDo2aCzqwgrBJSmKQnALRfz/xmtBSXXIuy+/7RB71UUGinRxEFZ
         kryKbk3L0TWssRTpIuv8dDxGdoCzgkvT9u+INXOElAzRyIU24imFW3k4HQS3jkx5LQNo
         t9tQ==
X-Gm-Message-State: AGi0PuadRoqtlxbspnt7rNodX70JFrDUIZROB4hiDiac1QivnFQdN8+4
        umbI//e7Cb7bgPi3Iaby+HXBGD0P
X-Google-Smtp-Source: APiQypJS7/tuo50olOo8h/+ZRWTCU0KAL64zlhINopJSHZnPmAwPQHWhdPTroX/xfzPqn8Q7AfFJuQ==
X-Received: by 2002:a05:600c:2645:: with SMTP id 5mr1443107wmy.168.1588369412057;
        Fri, 01 May 2020 14:43:32 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t2sm1207734wmt.15.2020.05.01.14.43.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 May 2020 14:43:31 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 7/9] lpfc: Fix noderef and address space warnings
Date:   Fri,  1 May 2020 14:43:08 -0700
Message-Id: <20200501214310.91713-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200501214310.91713-1-jsmart2021@gmail.com>
References: <20200501214310.91713-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Running make C=1 M=drivers/scsi/lpfc triggers sparse warnings

Correct the code generating the following errors:
- Incompatible address space assignment without proper conversion.
- Deference of usespace and per cpu pointers.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 3 ++-
 drivers/scsi/lpfc/lpfc_mbox.c    | 3 ++-
 drivers/scsi/lpfc/lpfc_sli.c     | 8 ++++----
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 8a6e02aa553f..24d946ef8609 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -2436,7 +2436,8 @@ lpfc_debugfs_dif_err_write(struct file *file, const char __user *buf,
 		return 0;
 
 	if (dent == phba->debug_InjErrLBA) {
-		if ((buf[0] == 'o') && (buf[1] == 'f') && (buf[2] == 'f'))
+		if ((dstbuf[0] == 'o') && (dstbuf[1] == 'f') &&
+		    (dstbuf[2] == 'f'))
 			tmp = (uint64_t)(-1);
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index e35b52b66d6c..e34e0f11bfdd 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1378,7 +1378,8 @@ lpfc_config_port(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	 */
 
 	if (phba->cfg_hostmem_hgp && phba->sli_rev != 3) {
-		phba->host_gp = &phba->mbox->us.s2.host[0];
+		phba->host_gp = (struct lpfc_hgp __iomem *)
+				 &phba->mbox->us.s2.host[0];
 		phba->hbq_put = NULL;
 		offset = (uint8_t *)&phba->mbox->us.s2.host -
 			(uint8_t *)phba->slim2p.virt;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index df77e75b9f53..0c9844cac3aa 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -14272,7 +14272,6 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 	int ecount = 0;
 	int hba_eqidx;
 	struct lpfc_eq_intr_info *eqi;
-	uint32_t icnt;
 
 	/* Get the driver's phba structure from the dev_id */
 	hba_eq_hdl = (struct lpfc_hba_eq_hdl *)dev_id;
@@ -14300,11 +14299,12 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 		return IRQ_NONE;
 	}
 
-	eqi = phba->sli4_hba.eq_info;
-	icnt = this_cpu_inc_return(eqi->icnt);
+	eqi = this_cpu_ptr(phba->sli4_hba.eq_info);
+	eqi->icnt++;
+
 	fpeq->last_cpu = raw_smp_processor_id();
 
-	if (icnt > LPFC_EQD_ISR_TRIGGER &&
+	if (eqi->icnt > LPFC_EQD_ISR_TRIGGER &&
 	    fpeq->q_flag & HBA_EQ_DELAY_CHK &&
 	    phba->cfg_auto_imax &&
 	    fpeq->q_mode != LPFC_MAX_AUTO_EQ_DELAY &&
-- 
2.26.1

