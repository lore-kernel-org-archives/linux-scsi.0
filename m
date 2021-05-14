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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F0EC43460
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C17C61624
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbhENT5i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 15:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbhENT5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 15:57:22 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE13EC06175F
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:10 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id v191so488553pfc.8
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fw1FyxfDcJM9wY/W7sMo9SgwlzVFTsIJLJ44vv6FcJw=;
        b=h6Cd9iICJterbGwSM4xWeGJt5M1Lss/aXXbtBmVCb62RjiNlsYYOeiLrD8gL+zGw21
         J6++O9RO61LDgHsFGvJfVXgcgiBgf+qh6j8C7569djZkMv/Oc930cr05VPz2A4W1S/JD
         fwwNwubNw+ZPkXe7iW7BY8vMo4X1tKaRPn02bP/+KPZoax7dLhaMgV3c+pB9YL/bWgXK
         ZjiY0Mo6hdrNimKLMk66BXzgLKx4L3hvsqOCi8aOZzh6ARKKXQ9Ksr9JsR0Ix3K5U4J7
         wUqw5SY2LCjogJEh0rDvhESsoeArPa+nzTN921zbRS8elPL9Hbr6oe5X/3IRvu4nQwK/
         nZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fw1FyxfDcJM9wY/W7sMo9SgwlzVFTsIJLJ44vv6FcJw=;
        b=hhsGtVincz/LDq1k+QOqgAk/9xcM1JCb17HqC40G2Tu/jfKDCcfC442CKSF+6Gs/U4
         uxh5dhsTKILP+eSGSk2wxp4xKjo9phCCB2mnhQvI5yFahINYptfxXBiuCMfUi3h7Pwh1
         xmba5nwIvH+8vdufrsxefXeGqIfYZD76ynHGTgoNKPnuJ5+jWTS8+NMFOLvA3R5dkYnz
         BODyi9E1UXgEsl64zSKFFTMBDiaCPzAnQssvKLayfHVgqgkcDrFrLFo94lYzFWMkeMzo
         7Mci9u+ysGaXLLCZQJVwQNM0f9OklkjNIZcjx4LuqW6nTSVSACFwlvVWeAzz6yU+sqGL
         ki3A==
X-Gm-Message-State: AOAM533+a1KQWQsXlGiHlvjGNygV6dGs7V7pQFAnH5dIWV6w9tUmzRXe
        U1sZXuDUySMUReL6V2rDgu79s1NBpfU=
X-Google-Smtp-Source: ABdhPJyMnfLqWw54P5AI2IJNWSQ0BzSEOxHqem8aqkKCbfYvOtjS8ZAbYoq9ctGLhYGciahnFviRAw==
X-Received: by 2002:a63:1d06:: with SMTP id d6mr47907867pgd.202.1621022170296;
        Fri, 14 May 2021 12:56:10 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id v15sm4961850pgc.57.2021.05.14.12.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 12:56:10 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 08/11] lpfc: Fix crash when lpfc_sli4_hba_setup fails to initialize the SGLs
Date:   Fri, 14 May 2021 12:55:56 -0700
Message-Id: <20210514195559.119853-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210514195559.119853-1-jsmart2021@gmail.com>
References: <20210514195559.119853-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver is encountering a crash in lpfc_free_iocb_list() while
performing initial attachment.

Code review found this to be an errant failure path that was taken,
jumping to a tag that then referenced structures that were
uninitialized.

Fix the failure path.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index fa4722c7a551..1ad1beb2a8a8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7964,7 +7964,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 				"0393 Error %d during rpi post operation\n",
 				rc);
 		rc = -ENODEV;
-		goto out_destroy_queue;
+		goto out_free_iocblist;
 	}
 	lpfc_sli4_node_prep(phba);
 
@@ -8130,8 +8130,9 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 out_unset_queue:
 	/* Unset all the queues set up in this routine when error out */
 	lpfc_sli4_queue_unset(phba);
-out_destroy_queue:
+out_free_iocblist:
 	lpfc_free_iocb_list(phba);
+out_destroy_queue:
 	lpfc_sli4_queue_destroy(phba);
 out_stop_timers:
 	lpfc_stop_hba_timers(phba);
-- 
2.26.2

