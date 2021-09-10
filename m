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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820F4C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65F2061212
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234895AbhIJXdh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 19:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbhIJXda (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 19:33:30 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D237C061762
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:15 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so1679105pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vkDJTH2aTOmNIXa8p77tBZ2TAUIoZ0mWBrTBpEZwNIs=;
        b=UJfRogdER0aIHwYmGXwUuLunKcXoyR9yxXVAR/h8kraTuNwLh2WciowSiuGfIsoFXj
         zGwk0hQOank5bkBMOkqxtp/erLZDJLDHqTE+HHgogpu/1rlVNcd5PCmqyXRxcQTwb6Tj
         lIfV5vk9x9YQd1ok2YOi0j3nxVwk6/ZznDgWLPVO/LUfDjXv4JuXdwHijLA/BWHH0JGI
         2HSyQY/Au7/REm91yYQZUe64vA0I4UC3J4UZ2/75bSB8zhrnZltGUyCFTXjLSI2jh/tZ
         4AOOloDJ4W9zLzaTMxX3IfR4nlx8gadwSzl3G39TQeIsH6DB8Q1+7qN4fsNM2V1CzGxd
         7FSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vkDJTH2aTOmNIXa8p77tBZ2TAUIoZ0mWBrTBpEZwNIs=;
        b=ky+kk1ufRn/gZvRCf680SwS+9CyjMv1uRwPUVy56x3h+BdOuPnCICwPsB4NRTPOF7b
         lr28a9D/XM7zr0gmuydP/j+bdNOzitVln+UTUWANUvlgBHpK7fjvPIgj59kG3wzwI/Oj
         FwutKBO3jK+dhPngJzIzcLInqSuzBhjnUYWH8VTGURLXka1xir7gY+1pJ4TCedtUtRjh
         VsWGVdeIQOEnBhS0LpR4lD9iQ1l051bwVWaDmqTYb4OS1Al7lE18sbmaMeH5MzKiNKoT
         LQvyw+HvuavpznMIxUXYnCfEn4oELA4nXqWG3oF7pITRs0KuXxjMBgHd2rnMd2zwKgXZ
         BqIw==
X-Gm-Message-State: AOAM530vaiae46J+GP+oUIx2u1ZzbRuZFk8rAPrhZrJSGbVHu9YV61Di
        i8nidREUFUFRTLf65SGhJYa6+wVc3P7rOP6G
X-Google-Smtp-Source: ABdhPJyYR/43L7WIRN0vubJcuqDz22Z8En8JoF3SZyPXysCsuWO1MUDMqfeH9eGYsXusPhgzagXsvQ==
X-Received: by 2002:a17:90a:9a2:: with SMTP id 31mr95827pjo.58.1631316734825;
        Fri, 10 Sep 2021 16:32:14 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm11325pfk.143.2021.09.10.16.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:32:14 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 06/14] lpfc: Don't remove ndlp on PRLI errors in P2P mode
Date:   Fri, 10 Sep 2021 16:31:51 -0700
Message-Id: <20210910233159.115896-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In pt-2-pt mode, the initiator does not log into the target after a
PRLI error.  In pt-2-pt mode, the target responded to the PRLI by
sending a LOGO. The LOGO causes all ELS and I/Os to be aborted. This
caused the PRLI to fail. The PRLI completion path caused the discovery
node to be dropped to avoid being stick in an UNUSED (not logged in)
state. As the node was dropped there is no retry of the login and as
it is pt-2-pt, there is no RSCN to retrigger discovery. Thus the other
end is not seen by the os.

Fix by ensuring the discovery node is not dropped if connecting pt-2-pt.
This will cause PLOGI to be retried.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6c9cb87ef174..c6eae545aabf 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2329,6 +2329,13 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 						NLP_EVT_CMPL_PRLI);
 
+		/*
+		 * For P2P topology, retain the node so that PLOGI can be
+		 * attempted on it again.
+		 */
+		if (vport->fc_flag & FC_PT2PT)
+			goto out;
+
 		/* As long as this node is not registered with the SCSI
 		 * or NVMe transport and no other PRLIs are outstanding,
 		 * it is no longer an active node.  Otherwise devloss
-- 
2.26.2

