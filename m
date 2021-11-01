Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B610C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 23:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E80F860EE5
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 23:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhKAXbj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 19:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbhKAXbi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2021 19:31:38 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6FCC061714
        for <linux-scsi@vger.kernel.org>; Mon,  1 Nov 2021 16:29:04 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y125-20020a25dc83000000b005c2326bf744so9158175ybe.21
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2021 16:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Sph44qoedFxIBxzHBFHZscYWNo2pFD2fSGj7R4UIzT0=;
        b=g+ZdiZ3qPkBdI92UTCk1wchRVYwSwgqHl0uPpjhAXRAVudH4vUIp1aDES4gK0PA7zM
         FAJ0kjrC0LMmZTcvqONSkcuG30GPdCzneoOKkthz22+3bU5DVinN4ZZ3fwxfaFdcQktD
         fSCYcNuHT9/yK3G+1mvBM/5d6CIFIg17njJPH2YLN+1z/2Lqf4lTORAjLDYQP2qKVVAF
         cGspxZL6tVBCRhj2bDGfjB1d5M2WV1xNLSq7kEVkmqNLLNkeBLq2936TsvDKNn7EwnyU
         INSP6za9bP3YjteEgan2TLnHsubvftv/KSMpZ9p98rJwj30z5Z54lEMA/4oSXZLGnxen
         KVUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Sph44qoedFxIBxzHBFHZscYWNo2pFD2fSGj7R4UIzT0=;
        b=v226KPi1JMlxPKbRUzyw31L2oGdRTesKRhbq9UEpOg7oSzvwKmDFoMQ0yHqQO2d9VT
         DgcfsvcVndXWzXlLVi/Sqfpuh9d0RbBbFGhv8qX5414/ByNnbXWIRkMArLGSa8xxL2/z
         MLXNITQK4kJcjmayjfeaQ+h6zmhD2Bw6+ke+na4/2ddgiQoHh8FY570LxB532zp9zNgU
         AM6ntn8cf7F326ltDlaJGMskGj5e+x6r5ItpLh1/CN8AV2Ofv2gj+iBwina58vC3SNmG
         Bc++OkE6SRs+bZzAdWzsK6QHb/Y5hKVDX2SSnZTOtHQFOMUh8nq6KNcojO5y+tU+D43k
         qtgg==
X-Gm-Message-State: AOAM531nXOwzXyV4v+MvDG0ofbUOlBGkQ0P2xJaNbOvsJEcBNr23PznO
        w3BniRTqBwCJkJWCOqpkV0SdYGNct+/PuQ==
X-Google-Smtp-Source: ABdhPJw8vJA4UOq7Y3ucFhZM6bqoxrEwkT6g/1r8Zz6DyOv2wKQgzpT4DQyKKLQNWb9PH6eFDeCkmZxOSwP1OQ==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:3684:4dd2:e6b6:ef66])
 (user=ipylypiv job=sendgmr) by 2002:a25:744d:: with SMTP id
 p74mr31897561ybc.445.1635809344022; Mon, 01 Nov 2021 16:29:04 -0700 (PDT)
Date:   Mon,  1 Nov 2021 16:28:25 -0700
In-Reply-To: <20211101232825.2350233-1-ipylypiv@google.com>
Message-Id: <20211101232825.2350233-5-ipylypiv@google.com>
Mime-Version: 1.0
References: <20211101232825.2350233-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 4/4] scsi: pm80xx: Use bitmap_zalloc() for tags bitmap allocation
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We used to allocate X bytes while we only need X bits.

Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 47db7e0beae6..9935cf20b93d 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -178,7 +178,7 @@ static void pm8001_free(struct pm8001_hba_info *pm8001_ha)
 	}
 	PM8001_CHIP_DISP->chip_iounmap(pm8001_ha);
 	flush_workqueue(pm8001_wq);
-	kfree(pm8001_ha->tags);
+	bitmap_free(pm8001_ha->tags);
 	kfree(pm8001_ha);
 }
 
@@ -1193,7 +1193,7 @@ pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha, struct Scsi_Host *shost,
 	can_queue = ccb_count - PM8001_RESERVE_SLOT;
 	shost->can_queue = can_queue;
 
-	pm8001_ha->tags = kzalloc(ccb_count, GFP_KERNEL);
+	pm8001_ha->tags = bitmap_zalloc(ccb_count, GFP_KERNEL);
 	if (!pm8001_ha->tags)
 		goto err_out;
 
-- 
2.33.1.1089.g2158813163f-goog

