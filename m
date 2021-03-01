Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AF40C433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E228465239
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhCARZe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbhCARVU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:21:20 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09640C06121E
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:35 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id c19so11711430pjq.3
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L54foXu7heKpIkawa3bOmdrH6pnHNjIUWRhs/BP1mMQ=;
        b=aj1s+YnWCsP7Zowpd8OZDwfURjVl0+az6yejZEvlttqFAS7rK6VCinTduJeySLCSrX
         sCpCP0yVzcpjWmMk2Eq210E7WfCEirt5HzAEj5rGoPi4i5x0K2em9/2lxpcbZLpVjNF0
         weuoDAKL5pZi0npt9E2XQF7Q0oKcRz1WOb5+ILejOdkLE0OC6yHaGS0wW6nuovEgjdbD
         iJLS7oXufovAGrZcLQaRogMCwBKHI2zo1gopUgAyIQ3/DLVj80IGSZNlmqG2gQA77450
         58VCDxXigD2WjzuYotEJuE8CO06p9C8pXEc5kuUNI6DsjCoaUUWebqfNsW3rceEnATxL
         gA/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L54foXu7heKpIkawa3bOmdrH6pnHNjIUWRhs/BP1mMQ=;
        b=SLkFbuqieghS9R10dgnNyRn7BdEDlqnpdIgKmo8qpTTqAdBBGGhy9abEsq0S14U4D9
         EkcmfWVyuRPJlHjNl2X5CTN8uLxlKfYqkBhhGuOCJiz8F8s6JYrN6VQ6/rYxcO6O2O/U
         UiyoFXENtOQsUh8XkkiKqM/b8rpch7ViiBk/ZtyqIVu9OITegXuzFqtKUpkT6jY/2aVF
         D/daIKgzdxXSfUwShrT375+AlnolmlTiDkIxx1ufNrN6i//EEPRyMvRoed2gElP61tUT
         L4Vy73642DAFotd5hvSWLS5i86Yay9t9pgEM2+lOlFFbnWthxHITDQ8O7h06OkUEUPOR
         1Wdw==
X-Gm-Message-State: AOAM531xDfpkSwXE1b23CDfT0dkYmu6sB3+NZEsFNSkEouQXI47iw0sL
        gFPSChrqJoXUgnrUmyWqLdHyL1wrgFs=
X-Google-Smtp-Source: ABdhPJwCwYkoalhtMibVDLJhgFAXtj68kQAxpoNN3HdqDfcJhzX+HGBkbm4nGqtpjBKeeCtZahBSPw==
X-Received: by 2002:a17:903:1d0:b029:df:d098:f1cb with SMTP id e16-20020a17090301d0b02900dfd098f1cbmr16631543plh.49.1614619114453;
        Mon, 01 Mar 2021 09:18:34 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:34 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 11/22] lpfc: Fix status returned in lpfc_els_retry() error exit path
Date:   Mon,  1 Mar 2021 09:18:10 -0800
Message-Id: <20210301171821.3427-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An unlikely error exit path from lpfc_els_retry() returns incorrect
status to a caller, erroneously indicating that a retry has been
successfully issued or scheduled.

Change error exit path to indicate no retry.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 08de3496d065..3bd1482af72f 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3822,7 +3822,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		did = irsp->un.elsreq64.remoteID;
 		ndlp = lpfc_findnode_did(vport, did);
 		if (!ndlp && (cmd != ELS_CMD_PLOGI))
-			return 1;
+			return 0;
 	}
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
-- 
2.26.2

