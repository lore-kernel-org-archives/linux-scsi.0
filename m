Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F4DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 03:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388857AbiEFD7X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 23:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388836AbiEFD7O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 23:59:14 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBF265AA
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 20:55:30 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id w5-20020a17090aaf8500b001d74c754128so9781832pjq.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 May 2022 20:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SpUVwnkg++HeDm+jTiQAVjn/6CkYaRl6cjZRC1hD6ec=;
        b=SyWA3/4OU808NPvKSfTJmyrIl4LadzO+0zull2PPnSLnbcTaalhTzUu3UDLxdWI8KD
         PU7HEJTwU0un8ELvuOBFdl4Ak74mWqdZrnqleD3WjusAYHAIQ1csCLraWFzbxgL0zWPt
         nvcKGUN6tPVyyIEJ5h/ALN58CBpeqlpbEmxnXJkAMSylrUnLSMmIApIWF4y8xjpGqO6t
         Ug4Eud1b46JiLINKTHHPULYp8VnvtDOSE52DvyK45SnvCbsY+qiH7PAIEeBpMIJWRsHj
         FGkOwaq77xPcFU7X47vsy9E4O5mdA/Y9kgLF/dbuK0Ozx/RvKzmoUKPGvxl0eOlrEaWG
         AcQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SpUVwnkg++HeDm+jTiQAVjn/6CkYaRl6cjZRC1hD6ec=;
        b=etVrIPa1i5tOZnkY0oKx3qLA41kqLzKEgJorsvB0/4LuNkAnzMg+KkMhn2LOr1VRjX
         pnGOUv+wPv17JXNXWfIFIP2yOKzl3Cfv2yDNaz5X/sId08OkB9/eupQq+gEoRroMbyeX
         uYenz0HLQ1KAl48j93G+9h0kjPFsPvGFaYVI82Av+/RjphpgxGI2oexkxVRqGb1pbsgJ
         cJ3NAFJyDviVBxoXs+byjI/56OOdUL1/9dsyjWYNDpgTfnuGvOS6njpxVfyv0qBmc3fd
         YaDpMOmTUgaFP67NeAIkeorlBjf9D9JDyTt8N3OKrQhzC4tVij8FISmO/LGM7FqY9lC3
         aHmA==
X-Gm-Message-State: AOAM532D7P8ZGwnmRnSmib4FI+EiAoMuOKhOhM5frVLGxfAS+GBcWwfd
        6pbovZBsb9rbI2vautSkGtFI9FcbjPY=
X-Google-Smtp-Source: ABdhPJyKNiZcKph15UQwtiveE7ID8CPgDQABTJrsdNcy78dR0lIU6QEpshyiE1gVMP9R9N3wk1lovw==
X-Received: by 2002:a17:903:120c:b0:154:c135:60d3 with SMTP id l12-20020a170903120c00b00154c13560d3mr1603579plh.48.1651809330092;
        Thu, 05 May 2022 20:55:30 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ck3-20020a17090afe0300b001cd4989feebsm6065187pjb.55.2022.05.05.20.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 20:55:29 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 03/12] lpfc: Fix ndlp put following a LOGO completion
Date:   Thu,  5 May 2022 20:55:10 -0700
Message-Id: <20220506035519.50908-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220506035519.50908-1-jsmart2021@gmail.com>
References: <20220506035519.50908-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During testing with repeated asynchronous resets of the target, and issue
was found when the driver issues a LOGO to disconnect it's login and
recover all exchanges. The LOGO command take a node reference but
neglects to remove it, keeping the node reference count artifically high.

Add a call to lpfc_nlp_put to lpfc_nlp_logo_unreg and move the mempool
free call to the routine exit along with the needed put.  This is always
safe as this will not be the last reference removed as lpfc_unreg_rpi
ensures there is an additional reference on the ndlp.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2d846256990c..e4805101cd5c 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5235,7 +5235,6 @@ lpfc_nlp_logo_unreg(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	if (!ndlp)
 		return;
 	lpfc_issue_els_logo(vport, ndlp, 0);
-	mempool_free(pmb, phba->mbox_mem_pool);
 
 	/* Check to see if there are any deferred events to process */
 	if ((ndlp->nlp_flag & NLP_UNREG_INP) &&
@@ -5262,6 +5261,13 @@ lpfc_nlp_logo_unreg(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		ndlp->nlp_flag &= ~NLP_UNREG_INP;
 		spin_unlock_irq(&ndlp->lock);
 	}
+
+	/* The node has an outstanding reference for the unreg. Now
+	 * that the LOGO action and cleanup are finished, release
+	 * resources.
+	 */
+	lpfc_nlp_put(ndlp);
+	mempool_free(pmb, phba->mbox_mem_pool);
 }
 
 /*
-- 
2.26.2

