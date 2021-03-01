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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF55C433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8AAA65217
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238059AbhCARWE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237835AbhCARTM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:19:12 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE1AC061797
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:26 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id s7so3128307plg.5
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ak1E0xkuYN1qakVwPgq0NC9IML9/AUm8rrw3eyJlwZI=;
        b=GJf/k1XIOaQsfJ/vTXOll55vFxHx4eTjTsdqfJ4XPIB+a9oHJSNIHbE1ofIUFTWRq3
         oVZHRk2PH93/gGANWIfx5LbtVT+OzEHl1Q6u81CeTZ4prYpIkRjfcHNjM/KHVeBNK/sp
         AKPRlcqhQbNX1FealOzq6cQpBLubp9ENikArnlN1Odn+xJUStXwVKRMotsCNj9TIOaIp
         n5q9GNuiSN/kYJTuk1NblyP7PW/SLB+GxbRK004eXTxI00Y0MKXbn/I6vEm4bWyzAs2w
         EQrAqSIcTifquakzNRWENf/K4IL3PucrE4fLb5E+AIOinOClnV4YMoyQ27RdNER1dGYT
         gQ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ak1E0xkuYN1qakVwPgq0NC9IML9/AUm8rrw3eyJlwZI=;
        b=oyVz2q1XG22oCpzJ3CwqM4+ELaZLab33EDxdK3G9iYBKwFzVY9xS9WTTz6jrWNJboL
         2L5MuOy2iNCfddNJzXB3Th4UHSqENpfnKd+Aj+q7xxIftkaBzYJfwCx5qx45M9VzeGJ7
         pojQ8C3EjqX9zza1xq006u6KPhmZBTUe0gQmtXeszDW7JZqxiqBLos38/eGKhNhFxcoR
         4I3b8Uqwh+rCIXB5X5VYO4NE360lPnrmJ9l+ueubXvfuMadO8FvAncd6nfdt3eq1eGVs
         n3yyTyLGDK4PPw9kTTbVdTlYz087Z1SLrQF+GCj4Cz/OpLXsf1i/GfHVqMsV8a8IMiBH
         4Wgg==
X-Gm-Message-State: AOAM533xolHZZGxTnkxYQF4nw9a2R+wyiSy97c9tUYgF13EBFwNuDCGe
        igA5wHVE/W6SC/B7qRml2g/x8sI2mYA=
X-Google-Smtp-Source: ABdhPJz/gWAIuDACvjoc3/u34xCT1KQDTzfITqwLBYrK6zkeMFlP3XOPzm0qdVdEuAfALuPXn6I8kw==
X-Received: by 2002:a17:90a:e28c:: with SMTP id d12mr16336829pjz.167.1614619106472;
        Mon, 01 Mar 2021 09:18:26 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:26 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 01/22] lpfc: Fix incorrect dbde assignment when building target abts wqe
Date:   Mon,  1 Mar 2021 09:18:00 -0800
Message-Id: <20210301171821.3427-2-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The wqe_dbde field indicates whether a Data BDE is present in Words 0:2
and should therefore should be clear in the abts request wqe. By setting
the bit we can be misleading fw into error cases.

Clear the wqe_dbde field

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index bb2a4a0d1295..a3fd959f7431 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -3304,7 +3304,6 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	bf_set(wqe_rcvoxid, &wqe_abts->xmit_sequence.wqe_com, xri);
 
 	/* Word 10 */
-	bf_set(wqe_dbde, &wqe_abts->xmit_sequence.wqe_com, 1);
 	bf_set(wqe_iod, &wqe_abts->xmit_sequence.wqe_com, LPFC_WQE_IOD_WRITE);
 	bf_set(wqe_lenloc, &wqe_abts->xmit_sequence.wqe_com,
 	       LPFC_WQE_LENLOC_WORD12);
-- 
2.26.2

