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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72778C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BDD661213
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbhIJXdo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 19:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbhIJXdb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 19:33:31 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAA9C061764
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:16 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id dw14so1492602pjb.1
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XgCnLh+b92yUjOifde23K95AaE4qX1Fd7kkLemky5Ds=;
        b=npYErKmsnd74EXjwqIoO4uIwhNZWrIkrsbwWbou8dNs7J0JpHYG3TqSP4n671UsqbL
         rmS6ng8HkyBYEfwBYpI9eiPZnGnrG29/rjTlOCpPr6aM8sVlX5tfL6HzBKF8KUCFZcYU
         sJsBvKJWpJ+00y0XcWkAAj+mAc07roV2f0cwbwHDqVx5m+OnC+D5PDgKlhuNd6baTi71
         55h2enbge60T0KwzrtKb0RPeKQdclHkBLPeZJabMfkA7Al7DebEa17oSsj3WXrKGlNMY
         QsJPMGsXro9s+OBLDivcxx9uENJzrihEFKN57zC737j4ScD9KKwOuZQkYw7ADPj0n3XC
         PFnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XgCnLh+b92yUjOifde23K95AaE4qX1Fd7kkLemky5Ds=;
        b=nP519KG4dRsKa5kO+rAo5rqFbUgwwr4F8bi7szP8AvWQmqHeIScS8YWRh0lMFvzFL0
         //VHzEEJN7VlGdlnZtoKM0CjqsEa3RWO2asS/HQ3wMHwNnH4vT+yVCi0z8/9yhuS1e/b
         pBbUrepfgWluwzQuLb6oVspgoOXQ/ZDpMS46UyTYYL8cNu472fOKRKbttRJ1pz2TdVRc
         JodGEsZKOtinVR1wMB6bPmU9LXI3i6U85xupUfCtm0OBDyWOTLz/plwhgNUTDXzZvwFd
         uyu2gEjD/1vZkrLGCvmf8BfF3c9zh/u4v1XOP7eKQEMCouz1EKTprnq3Lm6ZnSWl0hHS
         YTSQ==
X-Gm-Message-State: AOAM533zJjYfWqvvHWfLIPqdEEv8mQcMcSJe2Ire2DVcG+oB+l/54tIv
        q7mhNiZ0B5F5EjwzKvSSzPNxy4DQvUUfn+UF
X-Google-Smtp-Source: ABdhPJyfS7Qj1wq79DkZS2pEQgx/foCGmvK1MVqgh0yzQrLKpXzWQJxXJFvr/+pmD4KJD0XPiGxPoA==
X-Received: by 2002:a17:90a:e7c8:: with SMTP id kb8mr140912pjb.19.1631316735680;
        Fri, 10 Sep 2021 16:32:15 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm11325pfk.143.2021.09.10.16.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:32:15 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 07/14] lpfc: Fix NVME I/O failover to non-optimized path
Date:   Fri, 10 Sep 2021 16:31:52 -0700
Message-Id: <20210910233159.115896-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently, we hold off unregistering with NVME transport layer until
GID_FT or ADISC completes upon receipt of RSCN. In the ADISC discovery
routine, for nodes not found in the GID_FT response, the nodes are
unregistered from the scsi transport but not UNREG_RPI'd. Meaning
outstanding WQEs continue to be outstanding and were not failed back to
the OS. If an NVMe device, this mean there wasn't initial termination of
the I/O's so they could be issued on a different NVME path.

Fix by unregistering the RPI so that I/O is cancelled.

Fixes: 0614568361b0 ("scsi: lpfc: Delay unregistering from transport until GIDFT or ADISC completes")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c6eae545aabf..40d166aeb466 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -6224,6 +6224,7 @@ lpfc_els_disc_adisc(struct lpfc_vport *vport)
 			 * from backend
 			 */
 			lpfc_nlp_unreg_node(vport, ndlp);
+			lpfc_unreg_rpi(vport, ndlp);
 			continue;
 		}
 
-- 
2.26.2

