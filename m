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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FC4C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2415760230
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbhDLBcY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236556AbhDLBcV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 21:32:21 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD94C061574
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:03 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id w10so8155597pgh.5
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lgk8f6DK7y9pIb91Ok4Yx7IaeKuJWR4Lt9c5q+73t18=;
        b=XfliAmX+wYJeGpQMzVqQIxiwcU8nkekWoQg+OZwuvG18TLIZ0oMCvnAfsi4flt7Poy
         tOgmItuSpa07PrXi624EXKPUBA35zbBC9GY7TgV5/lAXWHmIYnUDICLmO0XJtb8llhHd
         FbcGaW/EPOsUBN+0EoB54CIVhrcBAJMcIo8YWApFTMMOy5jKtbm+CegXIxMB86V4tn+A
         28Kr28YPsOOeMhr+2aP4YGhMXizKs6UjWJXw+Sz7SfTLQeydCGv34Db7j4YawjGKFna0
         tI2yF6xSw66IZ2tK/2HIIgFDEDK73ux2AZp4Kkj/m3+cPuZdBpyAGj0sezF5z49dDgIK
         gsyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lgk8f6DK7y9pIb91Ok4Yx7IaeKuJWR4Lt9c5q+73t18=;
        b=VRBiBM8RV4Gw1+yNHLysUBAaVEIjXzDuyrre9LSdQHVEqa+Jwn4ZAjnDW2F3cYXMoe
         ynFvxQcom8FTYUQI+3PVvwB+bKOpWnazHdHFiO2lZDSjnaH5YU5IDdZJd9DOxs+/3kl0
         xY7ZkWqFpf8PrnnBl7BruMVS5zLDxp2AWjLoYisW9ZStN6gzkK1cVoCmC7WT5Txs/Own
         OsslJ/vzeC593jagL0lKNDeKPqNQJa4H89/euhWHWCM7sZabq6WPdYjafysS054EcFn7
         Kg2rDfv9UJA5DJ9A9v7O8kfqd6Qw6F+qumrzyRRfkpGez+pgyDdyCHZpewi2LebOF/K2
         VDqw==
X-Gm-Message-State: AOAM532OgdJKoydQrp84zAty01q4LF0BlPznuz4tY7POYdmi9s2WB2CM
        KRV8JI73uwGMXtC6rx6Kb+skN1EOWdc=
X-Google-Smtp-Source: ABdhPJzZ7eNNOIfNY+ZlhjxTP2EjhkvXwbrn16twd0Z9Ig7gXWXqI+zkDj17SWM0E7m4jfmq4eW+zQ==
X-Received: by 2002:aa7:8d5a:0:b029:227:7b07:7d8b with SMTP id s26-20020aa78d5a0000b02902277b077d8bmr22221663pfe.26.1618191123008;
        Sun, 11 Apr 2021 18:32:03 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id i17sm8153163pfd.84.2021.04.11.18.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:32:02 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 05/16] lpfc: Fix lack of device removal on port swaps with PRLIs
Date:   Sun, 11 Apr 2021 18:31:16 -0700
Message-Id: <20210412013127.2387-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210412013127.2387-1-jsmart2021@gmail.com>
References: <20210412013127.2387-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During target port-swap testing with link flips, the initiator could
encounter PRLI errors.  If the target node disappears permanently, the
ndlp is found stuck in UNUSED state with ref count of 1. The rmmod of
the driver will hang waiting for this node to be freed.

While handling a link error in PRLI completion path, the code intends to
skip triggering the discovery state machine. However this is causing the
final reference release path to be skipped. This causes the node to be
stuck with ref count of 1

Fix by ensuring the code path triggers the device removal event on the
node state machine.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 1bb1e3cf7113..ed57d92e96e1 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2233,9 +2233,7 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 irsp->un.ulpWord[4], ndlp->fc4_prli_sent);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
-		if (lpfc_error_lost_link(irsp))
-			goto out;
-		else
+		if (!lpfc_error_lost_link(irsp))
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PRLI);
 
-- 
2.26.2

