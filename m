Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0255C433F7
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9150E20720
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ntBIcsLk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgGMHsT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729249AbgGMHrH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:47:07 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D840C08C5DF
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:07 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z15so14648574wrl.8
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rsv1890EAaVy29cSOpHY+htSuPNyhdWUNl+08rJAqiI=;
        b=ntBIcsLkqlyxYanzlfC2o1xlo6Ee7AL4sI/5CvVsDBQG26dGWUk4Q40RjQJ7gs5anB
         rxovhh6wJ9o+YYM+zaze8u60YveI9FzLur/49aOY4Bi7mDHnEJHPqadeTji0qiBM8DMx
         5O2jYjgUcgXCCKdXvVh7grHzr6kGvWLOlcNwoRoPNkdzOEcckh7/RjDSi5RE5v4IpJGM
         mW6yxKma4yTybwzHNJ6bvxKQK5Jq5lzVA0hYJQJ+2gYzeCXuDvm9Pjrlrh45B6ZUVMnr
         icpuurgf/2KXjBDKjL1R+EXbjy6dyE+fUGGSeNRlXsZgo6xLEPXQ8fF3qxFNaw6lxk5c
         DOqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rsv1890EAaVy29cSOpHY+htSuPNyhdWUNl+08rJAqiI=;
        b=g/n4Y/WEhsycRU3eJcYg3uIfewKLqlTMCBA0K8btVG8IswNqYpDQOYgxzN9MKpBoY4
         NXmTypPEEvfrotpcbkZN8ccRbdFHdcN2XQlf/mE7JGRbS3FJt7i9HuJczr6Jp5YJRAnC
         BM+rkd3Xt6T3tq/uwXjwo0BQvfufm6zBE1EW47E+udmTOQuODz3lTICUCR/mut+dvU3P
         2ZwTT51sAp8XRVGovwTrBmnNHcj3873xKqo2VSjMOKR4Cc39msyxrT0VgJr3a9ahN8tK
         w+5WUPHz6ceGI08b/5uugnvum0B+H+pnk/LUhr/BLfmIxmvID9F+9cfrw6EEcmumsF6S
         9tCw==
X-Gm-Message-State: AOAM530kL0LqChd6H/NKuwjMxlm4k7ZGk3r6yDYLKKVJVB1wkVhixYM6
        6FECUGIkaU1EHRz/N4zIZJA2e60cgFQ=
X-Google-Smtp-Source: ABdhPJyL+QoRk9tlBZ1jCq/yf05x9CJ8M3cuEcOCJtrRqvY9LuI4ZhaSGLIhILeHNSZvBUzhxzxyTw==
X-Received: by 2002:adf:dc90:: with SMTP id r16mr79169289wrj.264.1594626425952;
        Mon, 13 Jul 2020 00:47:05 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:47:05 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com,
        Prakash Gollapudi <bprakash@broadcom.com>
Subject: [PATCH v2 17/29] scsi: bnx2fc: bnx2fc_tgt: Demote obvious misuse of kerneldoc to standard comment blocks
Date:   Mon, 13 Jul 2020 08:46:33 +0100
Message-Id: <20200713074645.126138-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No attempt has been made to document either of the demoted functions here.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bnx2fc/bnx2fc_tgt.c:442: warning: Function parameter or member 'lport' not described in 'bnx2fc_rport_event_handler'
 drivers/scsi/bnx2fc/bnx2fc_tgt.c:442: warning: Function parameter or member 'rdata' not described in 'bnx2fc_rport_event_handler'
 drivers/scsi/bnx2fc/bnx2fc_tgt.c:442: warning: Function parameter or member 'event' not described in 'bnx2fc_rport_event_handler'
 drivers/scsi/bnx2fc/bnx2fc_tgt.c:665: warning: Function parameter or member 'hba' not described in 'bnx2fc_alloc_session_resc'
 drivers/scsi/bnx2fc/bnx2fc_tgt.c:665: warning: Function parameter or member 'tgt' not described in 'bnx2fc_alloc_session_resc'

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bnx2fc/bnx2fc_tgt.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 50384b4a817c8..a3e2a38aabf2f 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -431,7 +431,7 @@ static int bnx2fc_init_tgt(struct bnx2fc_rport *tgt,
 	return 0;
 }
 
-/**
+/*
  * This event_callback is called after successful completion of libfc
  * initiated target login. bnx2fc can proceed with initiating the session
  * establishment.
@@ -656,9 +656,8 @@ static void bnx2fc_free_conn_id(struct bnx2fc_hba *hba, u32 conn_id)
 	spin_unlock_bh(&hba->hba_lock);
 }
 
-/**
- *bnx2fc_alloc_session_resc - Allocate qp resources for the session
- *
+/*
+ * bnx2fc_alloc_session_resc - Allocate qp resources for the session
  */
 static int bnx2fc_alloc_session_resc(struct bnx2fc_hba *hba,
 					struct bnx2fc_rport *tgt)
-- 
2.25.1

