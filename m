Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0E6CA9EA9
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 218B42089C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P7y+v/Ef"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503012AbfJRVTF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:19:05 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46583 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503005AbfJRVTF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:19:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id e15so4000812pgu.13
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/esfdQdeUyygF3ZL8hiDMbx5RWAB03QI1mPsZ+FeHxo=;
        b=P7y+v/EfpC3BguYGGBPM6K3OugvQCXHBASHJajso1SF7I9mpVLnKbW9gqYV6WZKiI8
         kRsjWMfcYt2paEBpeUMrrHyjSC8zTc+e9eL1bX2XCldc1tWvf9qk+5/SeyTNuHYPBGWn
         2ywsptQWnRzyqV5QfpNB4qKKwIxDWKMa3+5LvYrKFZxW6Xmov9bO9jj+FsHyYZelU80N
         EXwnJcc+0fODt25mGCPjdLZeSrDBK2I7ktaQAbvRG1Uls7Gxq6lGnacwt93JXxrbSuIu
         sDUb6+hbSeRGthnAyl8/o3t0TStvqtH86cbZyvwEqQ8wxVpK87Kn1nQNZr/olQp8bi2u
         EnNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/esfdQdeUyygF3ZL8hiDMbx5RWAB03QI1mPsZ+FeHxo=;
        b=FZcVJ5Y5z6Q9dxJQ2fQzqjx7jXg+KnMz5+R9bxTcmQmPRABydY3rQEXuiY5Bdh+fA2
         0fSBc5ddGReGU7S5bEND2Q2mcl52HBq3VD1tbW9xn9YGgDVSHnYv0GSsySYjrFy0FuaA
         b+MVRf9aKl648UJpPclOlaWpVAL1wzHDez4dog2NyL5DrQvwNmUOdf85odl6zjz2liPG
         fdkuk3Tw2VKOTeSCosX0LpUCrYDYOn3Xdb4grZJKaAV03RNgZ5LdSk4j7k1QUJs1fbjX
         ZfRzAYTRIqZy/vsXCJS39PeUXlGaYI9xvlaBYYGyxKo1DCFUheA329sI5utLTFjUqDWx
         6taQ==
X-Gm-Message-State: APjAAAXZ/XiyTv5xVcy7pEOsMBuUyI3V9mo1ohsBYWnePUJ7tqfNyvpm
        KzQ5qSJDGsgri2/mrKtXmrckio6a
X-Google-Smtp-Source: APXvYqxEoNZcuvSBVPsxpOLL4zR7HvR1Enx1pyoiNu/6foS3ISIORGaeWYmkIwOO/At3dT3k9/JYmw==
X-Received: by 2002:a63:c045:: with SMTP id z5mr12182907pgi.69.1571433544652;
        Fri, 18 Oct 2019 14:19:04 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.19.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:19:04 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 07/16] lpfc: fix coverity error of dereference after null check
Date:   Fri, 18 Oct 2019 14:18:23 -0700
Message-Id: <20191018211832.7917-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Log message conditional upon vport being NULL dereferences vport
to determine log verbose setting.

Changed to use lpfc_print_log which uses phba to determine the
active log verbose setting.

Fixes: 43bfea1bffb6 ("scsi: lpfc: Fix coverity errors on NULL pointer checks")
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index da90c7bf2287..2235a45999a8 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4292,8 +4292,8 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	irsp = &rspiocb->iocb;
 
 	if (!vport) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
-				 "3177 ELS response failed\n");
+		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
+				"3177 ELS response failed\n");
 		goto out;
 	}
 	if (cmdiocb->context_un.mbox)
-- 
2.13.7

