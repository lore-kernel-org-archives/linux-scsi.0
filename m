Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1C6C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 726DA64E4A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhBKXrp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhBKXqz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:46:55 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31691C06121C
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:03 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id o63so5059713pgo.6
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rlvTP1LxTWr1Jm68l9z5rIe/zD5lnVcwmYbosICTVDY=;
        b=NjJICZ/n9jhmajNcX7PN2x/eA0KgSk8u3WGZeP9Q+leDLKymJqYjbqKlbppWes87My
         w9brWDj88S0eveVRcH8wQKDUoKiJmuIXJe8OnlLic7KasZ7to/LnUllC9cz3rhz4Xi+2
         YYNytC3Hjy0kY8BoKqDtxskcPFrB+qm+NorXMrC391Bd7vgsYFUlte9tJQrjzpmvNx0x
         mrSjGRurV+H/oBuwCL4mKxjNLGitCfX+0BlpzcBBUfoI7GwUqhKUkw+0n0omAvSF5Wtc
         yl0LUVI0AnwQ2zhg/Xfby5HIaNix8+Pc+tSrC1vLCNvOCkkiHpfLkDPU15ddeDO+SQsf
         ECtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rlvTP1LxTWr1Jm68l9z5rIe/zD5lnVcwmYbosICTVDY=;
        b=GzT8Pyy9KPDiq+YgG0WZOPLcMfBdS8+PnhNJPzyugp7Y+5a6YUn3N+12WeCUvBguBc
         C/wGJtD3s+fb2rPMhSoNFTfkaPfpYLVdCjaJU9XV/D56e0rrz6LartNLhl1uwq97cKf/
         ZZ3pE+cHZoaeJXA3O9EkK+JsNsZSyhG1xfAr0FPfMWdEP3pOz6DVT1unSn9fTlNGU8/Q
         LEc41ZN2FTkWTc26Ygi4nVQ+QDArjqBHPoGK4/D8kJRsIZPu6MPf63Mq6xcTA7Kwpiqm
         QfS377k/SJEdfZ//SFwWZbDgLYFTRqnk1pxbg/+r7uyhk7hSd4Q5fYDMjnP/0RTg/BSN
         zYng==
X-Gm-Message-State: AOAM533GIvyQL2qnjmuO87Sn/KH0svsJ2S87QW+/ohcpHtTkWDjL/PZP
        YGz3mwfemVcYulJkGS3CJ4RHXFDvDP4=
X-Google-Smtp-Source: ABdhPJxZvlsPk2IgGrA6Jyc7DlfK//kYPsOusBrnVD+aAfPWT6X4rGEPT/REmTOoMmOuQBvcVku1Dw==
X-Received: by 2002:a62:190d:0:b029:1bd:e11c:4eff with SMTP id 13-20020a62190d0000b02901bde11c4effmr222776pfz.22.1613087102645;
        Thu, 11 Feb 2021 15:45:02 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:45:02 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 17/22] lpfc: Fix crash caused by switch reboot
Date:   Thu, 11 Feb 2021 15:44:38 -0800
Message-Id: <20210211234443.3107-18-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Driver is causing a crash in __lpfc_sli_release_iocbq_s4() when it
dereferences the els_wq which is NULL.

Validate the pring for the els_wq before dereferencing. Reorg the code
to move the pring assignment closer to where it is actually used.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 56112c9fb6aa..941540fe67ba 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1403,7 +1403,6 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 			goto out;
 		}
 
-		pring = phba->sli4_hba.els_wq->pring;
 		if ((iocbq->iocb_flag & LPFC_EXCHANGE_BUSY) &&
 			(sglq->state != SGL_XRI_ABORTED)) {
 			spin_lock_irqsave(&phba->sli4_hba.sgl_list_lock,
@@ -1426,9 +1425,9 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 				      &phba->sli4_hba.lpfc_els_sgl_list);
 			spin_unlock_irqrestore(
 				&phba->sli4_hba.sgl_list_lock, iflag);
-
+			pring = lpfc_phba_elsring(phba);
 			/* Check if TXQ queue needs to be serviced */
-			if (!list_empty(&pring->txq))
+			if (pring && (!list_empty(&pring->txq)))
 				lpfc_worker_wake_up(phba);
 		}
 	}
-- 
2.26.2

