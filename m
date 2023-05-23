Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18157C77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 18:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236429AbjEWSWS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 14:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbjEWSWR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 14:22:17 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0398F
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:16 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1ae4048627aso6257485ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684866136; x=1687458136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/km8r/hoK7uPsU/DWvsiWqa0QeEAv+3IjDh4hwQlcM=;
        b=mgFCU78SOvRFsyYr6c5Vv9hfQ6EjI9KMEbRIlYir1Pw7AEJZC/NK4CdQFCP5jNOXjd
         /sJlXu+nFVV2e6XR70nckOMPuSAbzeeQGJ1mHlw97dSKVLwzfesUVEYYFpyICBevHorC
         DkM6deDn9wQaBn1m2NxynGmfdW/mvKAYeeL1DOhR8zs3620R2N87dWAVPcfooH17wi00
         xGy9Nvz/Hn63tgXfLDpx2fZ2aQDLleUpTeylPnBnkdo472hOFrKiWz05kucR+U2oKq1X
         3fQDteO2UDE4c3Tne94ol3t8uCl+MbrghwmPOnJPE816SwNSgG6NHmrKi31YELcw14DD
         VW5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684866136; x=1687458136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1/km8r/hoK7uPsU/DWvsiWqa0QeEAv+3IjDh4hwQlcM=;
        b=JRHWa5FvRxOBj7f9TFn16dE7/7E/0K19ju4nciwongoRWmFNssrX43POMwrKNzTVyn
         YWxPDJuwI+09kwzv9voMNpr6Rl4yGen43lfW799LvTPFt4tH7LhrrH1EAm5fo4/Drb/K
         Ot0sP+ZjbrbvU5V14rvr4/UMoRQYl9c7sRoWFlJ030uLsVEp3BZDgGqtMclvpi1ccT7Q
         O1vhlSOQ3hD1eE6hGofFGj2Do1nzwxK908QX+eWV77Vgt12kZqzaCrIOrsG/vUeOd3e9
         5GBbt44q/HpUc35m33xCL5rt5YsvKqS3a7t3Hhk2jyOyLO+tN45xhz0NoBkhSapipDkq
         5BSA==
X-Gm-Message-State: AC+VfDzOqY16VWHzFxJ26yu2roy8/pzx+8DV66rh0H1U+OvSV8jOwusN
        cN7FsxDY5d7kFhQNPlRMcy3eVwC4o5Q=
X-Google-Smtp-Source: ACHHUZ7NUDGnWiCjnoEVc0UncwJeca7rTLIoEUpsalnpAAlU8gDe9ti6UDgtCV9lUmMKNG/671FhhA==
X-Received: by 2002:a17:903:32c3:b0:1ae:3dcf:ecf3 with SMTP id i3-20020a17090332c300b001ae3dcfecf3mr16426522plr.6.1684866136416;
        Tue, 23 May 2023 11:22:16 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w10-20020a170902e88a00b001a687c505e9sm7070870plg.237.2023.05.23.11.22.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 11:22:16 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 2/9] lpfc: Clear NLP_IN_DEV_LOSS flag if already in rediscovery
Date:   Tue, 23 May 2023 11:31:59 -0700
Message-Id: <20230523183206.7728-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230523183206.7728-1-justintee8345@gmail.com>
References: <20230523183206.7728-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In dev_loss_tmo callback routine, we early return if the ndlp is in a state
of rediscovery.  This occurs when a target proactively PLOGIs or PRLIs
after an RSCN before the dev_loss_tmo callback routine is scheduled to run.
Move clear of the NLP_IN_DEV_LOSS flag before the ndlp state check in such
cases.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 63e42e3f2165..f99b5c206cdb 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -556,6 +556,9 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 				 ndlp->nlp_DID, ndlp->nlp_flag,
 				 ndlp->nlp_state, ndlp->nlp_rpi);
 	}
+	spin_lock_irqsave(&ndlp->lock, iflags);
+	ndlp->nlp_flag &= ~NLP_IN_DEV_LOSS;
+	spin_unlock_irqrestore(&ndlp->lock, iflags);
 
 	/* If we are devloss, but we are in the process of rediscovering the
 	 * ndlp, don't issue a NLP_EVT_DEVICE_RM event.
@@ -565,9 +568,6 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 		return fcf_inuse;
 	}
 
-	spin_lock_irqsave(&ndlp->lock, iflags);
-	ndlp->nlp_flag &= ~NLP_IN_DEV_LOSS;
-	spin_unlock_irqrestore(&ndlp->lock, iflags);
 	if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
 		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
 
-- 
2.38.0

