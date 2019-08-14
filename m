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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD9EC433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C18920866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f1P7Y1G3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbfHNX53 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:29 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32872 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728975AbfHNX51 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id g2so357287pfq.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vTWRb4KVSv8PpYi0pXLmCl55ulpugDqtN8ptRI2e4RQ=;
        b=f1P7Y1G362JGUS3M22rEQCrPO2b5tRCGsAGTLnXJTZTGUBjWuhfNQsoIs4tOYWJQGl
         eF1izrDfK0UA2oY1lyNGlaZdrM7vU91dwE4AqklpFPsXGIg/89us2qdYALDP/6AUdhKO
         skzM8Jgbtsh3mMua7XXKYdbguy7iSaeoighR7LtEvVL6T+xfN5rtYkw5OWwAEDP7DhYI
         7xV7J9t7W+AbFL2qBmHOQFyr59gtc9ZbajKFVQOb3fJg35CQggzTnw8ZSNzVZ2P5KLto
         hPmejqlEAytG1U78LcRYGcJfcaPbwBcbwbwGf72QP3/yl/MRDnpzwiRfHcvo/H2Q2HkR
         dW2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vTWRb4KVSv8PpYi0pXLmCl55ulpugDqtN8ptRI2e4RQ=;
        b=K/6h9mIxPzYjwjt4QVZy+Cs7lDgFU0mnICHOIndXZLiOvOsk5WKL3CFuba+MdjbKMh
         SCk6euHsTAxi+eHJIJRHQCuLWepZ8QmiuArDCq7BbGlyFejW9pevS115fOC0l5lUtyln
         lrHkt2qfSX9ikq7K24Dydi4XUtI2sZN//E1LkamYwMOEQkOHxwLm+2zjVm+kccrNm5iv
         64iXRw1kiMIjxOSSTFDAm4pl7Jo8yIJjW1asvjWXWqO78YGa5o+0YvHhEYBFUuhELDwk
         HoNL01Nc25CRtMkh+12/RBFL/rbVaszA1OnNZ/O3JbwfZeXnx4K77X7H5WF34k0NrUN2
         6jqw==
X-Gm-Message-State: APjAAAVnybPPRSz2ykVRF6Vu7LSF1J+zfJ8HYkrXwZoMa2NgmyM+2LGl
        25F9gkMiPDyRjpIGErVE8BpYQ4rl
X-Google-Smtp-Source: APXvYqxtNgv90e5vn4Cy+1CnmZxnIJMC9nPgkD37WCcDSHxTdlj5QRJwWihKQD1RHK6J5uw0SUPp+g==
X-Received: by 2002:a63:c44c:: with SMTP id m12mr1350592pgg.396.1565827046906;
        Wed, 14 Aug 2019 16:57:26 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:26 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 06/42] lpfc: Fix leak of ELS completions on adapter reset
Date:   Wed, 14 Aug 2019 16:56:36 -0700
Message-Id: <20190814235712.4487-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the adapter is reset while there are outstanding ELS's,
subsequent reinitialization of the adapter will fail as it has
not recovered all of the io contexts relative to the ELS's.

If an ELS timed out or otherwise failed and an the ELS was
attempted to be aborted (which changes the ELS completion context),
in causes where the driver generates completions for the outstanding
IO as the adapter would not due to being reset, the driver released
only the ELS context and failed to release the abort context.
When the adapter went to reinit, as it had not received all of the
contexts, it failed to reinit.

Fix by having the ELS completion handler identify the
driver-generated completion status and release the abort context.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 504f56a99b20..3e128ea01dc0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11097,6 +11097,9 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				irsp->ulpStatus, irsp->un.ulpWord[4]);
 
 		spin_unlock_irq(&phba->hbalock);
+		if (irsp->ulpStatus == IOSTAT_LOCAL_REJECT &&
+		    irsp->un.ulpWord[4] == IOERR_SLI_ABORTED)
+			lpfc_sli_release_iocbq(phba, abort_iocb);
 	}
 release_iocb:
 	lpfc_sli_release_iocbq(phba, cmdiocb);
-- 
2.13.7

