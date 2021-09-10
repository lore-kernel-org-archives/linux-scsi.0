Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F90CC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11D5E61206
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbhIJXdV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 19:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbhIJXdU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 19:33:20 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A97C061574
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:09 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c4so582987pls.6
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vCHNRfaj2dKGgARCTQjE9Cv8ooW2hX6jrMwBXg6VlYQ=;
        b=expjbiICBtnT3J4yUyWnm1J4/2KQBuiLlz2j2I8lkhelCF/RDE1G04KJh8iEZx8eqz
         TY+79QYtLf94wg5djLI/fMq8rdyUcZJnHhYHNToChu05dTDP5UCUXV8lLlkj+ReJEhTY
         IfRBENT5yohYY4F5e/AZetQ4qxoM1XONGGtcLkFQK7E1a4fySDZMVWbbPGCFMLcV6fKP
         418bvYjKr8oNXVulMFzw+nU5CKKCFCRgbh+w4DLbJ83fJOQ8JeZ7Sh+2e55l8KKUuCF3
         igGOQzV+Auv4JpOK63rN948BUC3zFcyTu/pyNLMYE0dVTqRTGkrAUgxvvI22vj+QS/oq
         9v6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vCHNRfaj2dKGgARCTQjE9Cv8ooW2hX6jrMwBXg6VlYQ=;
        b=x7IjoHIzxXhDVnf3WtqWZnhhgsO1FzrdVehFI0M8uRZrZs9NCMR5gAWHSWuYVPI4jl
         cy5ZN7dAdFQorGVny2g9hr+v0EQ6GaKNuvcUOAwT1iGO2AjkZ5wF31TL4aOCOYu7uIa0
         vIIv6l1818YEs5yPe6PnSFslU7phYOQhikPVFv5e8MWEr+/UoFE5AV7nOIBiHqFwRPH/
         dBRPz4n1+z9JqEKArPPwzpkuQgzHTnzUCHC+m4yjfOUpykue8V5Xl8EnkqzvzVTvnszy
         iQvF2klTSo2FcRFHSJ8W6l6Imkw4lJhvwVFjF9nB1OsglscfT/u+uMJZ5P40wimY4P8w
         PPMw==
X-Gm-Message-State: AOAM530VYFDBbHbbwNqX5XkoaFEoHeztQQk9wYjz1NTXLYwpFHaQPs0N
        EE72Sg+7VxH2fQ0gkc0b+MXr9kEvF9VaLX92
X-Google-Smtp-Source: ABdhPJwnxbBkf+7Kszh+aJmhIO5T9KZVwGsVtxjhWz813/CzCgv+MM/RrvP455xYaVv4PShJ6YAE2A==
X-Received: by 2002:a17:90b:33c8:: with SMTP id lk8mr112020pjb.241.1631316728434;
        Fri, 10 Sep 2021 16:32:08 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm11325pfk.143.2021.09.10.16.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:32:07 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 01/14] lpfc: Fix list_add corruption in lpfc_drain_txq
Date:   Fri, 10 Sep 2021 16:31:46 -0700
Message-Id: <20210910233159.115896-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When parsing the txq list in lpfc_drain_txq, the driver attempts to
pass the requests to the adapter. If such an attempt fails, a local
"fail_msg" string is set and a log message output.  The job is then
added to a completions list for cancellation.

Processing of any further jobs from the txq list continues, but since
"fail_msg" remains set, jobs are added to the completions list
regardless of whether a wqe was passed to the adapter.  If successfully
added to txcmplq, jobs are added to both lists resulting in list
corruption.

Fix by clearing the fail_msg string after adding a job to the
completions list. This stops the subsequent jobs from being
added to the completions list unless they had an appropriate failure.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index ffd8a140638c..546c851938bc 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -21104,6 +21104,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 					fail_msg,
 					piocbq->iotag, piocbq->sli4_xritag);
 			list_add_tail(&piocbq->list, &completions);
+			fail_msg = NULL;
 		}
 		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	}
-- 
2.26.2

