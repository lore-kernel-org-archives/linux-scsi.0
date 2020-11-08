Return-Path: <SRS0=09q6=EO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBE2C55ABD
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Nov 2020 13:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33D72206ED
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Nov 2020 13:02:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sC78MXFh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgKHNCH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Nov 2020 08:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgKHNCG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2020 08:02:06 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6194AC0613CF;
        Sun,  8 Nov 2020 05:02:05 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id z24so4568010pgk.3;
        Sun, 08 Nov 2020 05:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=baQXkRR6e9uHEZqC3za9aR5n/gsZOkBVETdFnf8c6uM=;
        b=sC78MXFhLyF1YgRln72rPRqiI3EmKP4W97GcI6U5fLkgmVfgaiq76kRXHLAKx4TC/x
         BV4OSa1aVM3Cc+ESWfDhTjk3JcJikElj1sCSesbFEdVrRkE+RF//1JrFl5DHU0IRMmOt
         uvxLVIH0qAvdm+uGjn0P8gqPwEy+jTvW4g30O8lhWwOeO+sS07V3XigVWOHyEfmu/1c1
         A8ORLGdG2UoTuSAeoG1pz6O3vhfAeyGtBSt6OW3YjZ7FCheSQrORYkT//UtR1fjYllG4
         zsLFk7R4heTpms9CcFllMvVeGGfH/4cDUbiiEbwcPd4HrdZeGgPAsW76MArPv6PkmZ3G
         uW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=baQXkRR6e9uHEZqC3za9aR5n/gsZOkBVETdFnf8c6uM=;
        b=aFkQ7b/vjENAW6RzHi48Sw0O2VH0GQz4WZcA5DvbbL55UZG2iqb1IXBC4yXZKioslS
         nB6MMAbpcgSnQIuVbZ6FbVsvuh9yoDKr3NadxlT5L7rSE4WBAHJuWdkVqMu4Zz4MyuAV
         BsomgQqEHWT8qy2fKxUQXa9IaUrZCwhSjT+T+Sfp+VmiadlFT9xrYUPT7Y63qfMhvDiS
         arX4gvsWzPL4J6fvnlmbpQfwGQyREEBT3zPiEiw6DDWIlKhqWeRu6iuY+ofWv3qEaAiL
         OzDL/BeVa4a97Nu5c/IsrcZMseTYnVxoMUDEBdmybItqK2+wv+FSD5tlkKkZUfZ/jpOZ
         u1JQ==
X-Gm-Message-State: AOAM532SE+JpVLASkY5o8GyHtOjj43fU2kA5UGRcVD4jPP5CaBGZUl3s
        AHXSnIS/GJhadKSOSoYNzg==
X-Google-Smtp-Source: ABdhPJzIOJssGmKJYbWQ0xau3+hOEvaYPQxO+6BvCj2Dl94hbw1p0fx2k9F2oqWBXOYN25wCyj+XFw==
X-Received: by 2002:aa7:92d4:0:b029:163:e68e:5ffb with SMTP id k20-20020aa792d40000b0290163e68e5ffbmr9329624pfa.40.1604840524948;
        Sun, 08 Nov 2020 05:02:04 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id z17sm7558650pga.85.2020.11.08.05.02.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 08 Nov 2020 05:02:04 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] scsi: lpfc: make lpfc_sli_process_sol_iocb() void
Date:   Sun,  8 Nov 2020 21:01:58 +0800
Message-Id: <1604840518-12625-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The function lpfc_sli_process_sol_iocb() always return 1, so there's no
reason for a return value. In addition, no other functions will use the
return value of lpfc_sli_process_sol_iocb().

Convert lpfc_sli_process_sol_iocb() to a void function, and fix the
following Coccinelle warning:

./drivers/scsi/lpfc/lpfc_sli.c:3247:5-7: Unneeded variable: "rc". Return "1" on line 3372

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e158cd77d387..45c8cac61c76 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3239,12 +3239,11 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
  * is changed to IOSTAT_LOCAL_REJECT/IOERR_SLI_ABORTED.
  * This function always returns 1.
  **/
-static int
+static void
 lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			  struct lpfc_iocbq *saveq)
 {
 	struct lpfc_iocbq *cmdiocbp;
-	int rc = 1;
 	unsigned long iflag;
 
 	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
@@ -3368,8 +3367,6 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 					 saveq->iocb.ulpContext);
 		}
 	}
-
-	return rc;
 }
 
 /**
@@ -3761,7 +3758,7 @@ lpfc_sli_sp_handle_rspiocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		switch (type) {
 		case LPFC_SOL_IOCB:
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
-			rc = lpfc_sli_process_sol_iocb(phba, pring, saveq);
+			lpfc_sli_process_sol_iocb(phba, pring, saveq);
 			spin_lock_irqsave(&phba->hbalock, iflag);
 			break;
 
-- 
2.20.0

