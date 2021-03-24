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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36205C433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 06:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 122F4619DC
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 06:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235577AbhCXGqx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 02:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235573AbhCXGqs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 02:46:48 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2C7C061763;
        Tue, 23 Mar 2021 23:46:47 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id dc12so10895760qvb.4;
        Tue, 23 Mar 2021 23:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iKdTjkFOUGjD/3o95IGnMVTN3xwcieIE3gPA5ReilEk=;
        b=u+CVk9BjxR2IPflLx5NKRjBJU/eWxuYImaiw9aQTXjWab8JPem/6aOpEP/mL7MqcdU
         wIRSRv7UbURG285ZMeOdyVRIsNo0LWYlYTTqex3qTQ7OW5nauItRubmJb4eNrxkvz9qW
         7by3JKI0kneXo8xwD37bwDot9wlugH729SnARGlTV5JoaTMqxT1LsPuVhStqX96okwXT
         bVuXueYaBsnljsgMZJWxj0MVrEHv86RKNqEQBZNa+U99jO5b0k4ns3zmukxqvJLiJx4r
         BXlZsHOk+jvdEyR+3w1tptc10rvJoL/M1qLCArFVvpD4BgcbhLxi4eZC9ZxSYh+4c4hY
         UysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iKdTjkFOUGjD/3o95IGnMVTN3xwcieIE3gPA5ReilEk=;
        b=fag12YeDu5MSDn/lVM0JAaNu1yHQiHK3s96nKlth60K/41+sTox32yxIOgOHMC66+n
         uQigFKClsJxtuTlL8jrzrxcLnkcAESWNLsLda0wPwQT9kNWLxUP9HjTwTuaUmoixZNY1
         YF7GkVgBcvfrYCtxJS2LBTwekArdTWSQbLmCnNAY212gBejZBMQASx2zMl5IF76sw5Lh
         c1Ja38TipH3C7kLrdazypjbUHrXBhsFmq7QNqRx7+MbpS96qznorIpOz5cs2AGs+xtHF
         rqvw9JY7vJuPl0Bp65EP8ciFHL/NLz73MdrEB1JedQLrKVOki8pLwQXetJfaX2JJOds3
         vp/A==
X-Gm-Message-State: AOAM531J7D4IKhj6zjcmRX7XgROd7ufLnA1IAGtY4e4Rnr9gaGrLf5F4
        wUlx63F1VOt+NXqI23mqDII=
X-Google-Smtp-Source: ABdhPJzN5uKWcg3NdeaG74nB8bZc5A2sIUkSmVoQ8AESEYtr2bY1BAwdkXdg69F0MS8AjctrYtp4WQ==
X-Received: by 2002:ad4:58ed:: with SMTP id di13mr1742233qvb.34.1616568407186;
        Tue, 23 Mar 2021 23:46:47 -0700 (PDT)
Received: from Slackware.localdomain ([156.146.37.194])
        by smtp.gmail.com with ESMTPSA id a14sm1086172qkc.47.2021.03.23.23.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 23:46:46 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] scsi: lpfc: A mundane typo fix
Date:   Wed, 24 Mar 2021 12:18:29 +0530
Message-Id: <20210324064829.32092-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


s/conditons/conditions/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f0a758138ae8..04fb95edc5b0 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1912,7 +1912,7 @@ lpfc_cmpl_els_rrq(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
  * ndlp on the vport node list that matches the remote node ID from the
  * PLOGI response IOCB. If such ndlp does not exist, the PLOGI is simply
  * ignored and command IOCB released. The PLOGI response IOCB status is
- * checked for error conditons. If there is error status reported, PLOGI
+ * checked for error conditions. If there is error status reported, PLOGI
  * retry shall be attempted by invoking the lpfc_els_retry() routine.
  * Otherwise, the lpfc_plogi_confirm_nport() routine shall be invoked on
  * the ndlp and the NLP_EVT_CMPL_PLOGI state to the Discover State Machine
--
2.30.1

