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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30884C4332D
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AF29206CA
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbhACASS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jan 2021 19:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbhACASR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jan 2021 19:18:17 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A49C0617A2
        for <linux-scsi@vger.kernel.org>; Sat,  2 Jan 2021 16:17:17 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id d2so14150334pfq.5
        for <linux-scsi@vger.kernel.org>; Sat, 02 Jan 2021 16:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=372YtE8g/LlFqtHbGA+4Uprj5mZWcvkwKFbxQ3ClOLY=;
        b=BNJWslCDZhLU+FkgYlccUn7MIkHaD7U7yabm5Y1hwJSyC1SDiflrYgkkL/yxtpTdFO
         SYXZ4Evrmgj+2EX0nat9Y24isJbXi1lRiFjvqkq4vaIto5EshsqzJBgMcaxk7GmJAwWM
         +ItEVIb3UGnKcMB0y8EmE0NfftsN010l0WvX0yxVLJt3XUpjiCHNjKCj4bUBDibk7WEv
         QLr4jDFU9zvRve0tzkYs+qXtpZFDlwLkiOZ+HMnLN2J3gDuKRcf3vbP/tJkN0uHC0oDG
         UAdhWPCQxCe1mar8mhg3/8ZlAppbjY9bypyKQo6LhxtWukWxPHl8Bp+KqJ8PdPHGvGfs
         sl6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=372YtE8g/LlFqtHbGA+4Uprj5mZWcvkwKFbxQ3ClOLY=;
        b=OZccxve11tVHL8ClTmYeHWRxGv+miHwhz+4IHJwUTjBdqYivjGUQpygJUd47+KmRX8
         hkNLmDt/JtUus5MfXutEx5Kfxvb6Zdyr4ftJvdK26myhv652Ps5AKqivP4/fW8OLV9HX
         XOu8IBiKMfzxmC+0BQXi3sE4XV0uGgD3k97x22iXJYyrHSR807GssbdKP89H+6mJ7bON
         aFtvYURhTeAC+/tsFxReudWMVk+44uYBfw5k/DmNXkd5EYeoWXHOG0zUSnHEx86XwLun
         QXL7gFxtrE1CLr1nGM3zKMJtz0FR9VjDicnTOS00OSrhxkBeacJi0+FCD86KprJQV26s
         Chrw==
X-Gm-Message-State: AOAM5316Vve7HgKGZS8dS+N91mQgzH9lzXfWatdCoQ515yPdPICbm6cJ
        4DHq9CO0HWBEsikR/Pf/ssv0zEWZEZY=
X-Google-Smtp-Source: ABdhPJymn0IISqyNBbyj8xEy/PHKRvViCy2BwysjmjcW1IK7v1R7JmTm+tepvd3og/yPZ/k6EwP9+Q==
X-Received: by 2002:aa7:81d6:0:b029:19e:2987:7465 with SMTP id c22-20020aa781d60000b029019e29877465mr60968753pfn.29.1609633037375;
        Sat, 02 Jan 2021 16:17:17 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm55671867pgj.24.2021.01.02.16.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 16:17:17 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 11/15] lpfc: Fix vport create logging
Date:   Sat,  2 Jan 2021 16:16:35 -0800
Message-Id: <20210103001639.1995-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103001639.1995-1-jsmart2021@gmail.com>
References: <20210103001639.1995-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When with testing with large numbers of npiv vports and link bounces,
the driver is flooding the messages file, even with log_verbose = 0.

The new LOG_TRACE_EVENT messages are still generating events to the
messages files.

Fix by converting the vport create msg from LOG_TRACE_EVENT to
LOG_VPORT.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_vport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index a99fdfba7d27..ccf7b6cd0bd8 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -478,7 +478,7 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 	rc = VPORT_OK;
 
 out:
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
 			 "1825 Vport Created.\n");
 	lpfc_host_attrib_init(lpfc_shost_from_vport(vport));
 error_out:
-- 
2.26.2

