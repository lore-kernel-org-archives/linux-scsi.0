Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B69C433E6
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Feb 2021 17:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FC9064E5D
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Feb 2021 17:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhBFRlV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Feb 2021 12:41:21 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:41414 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230327AbhBFRlO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2021 12:41:14 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 22D57128015D;
        Sat,  6 Feb 2021 09:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612633233;
        bh=wztkNCBX/ZeuHiJS/Vj2aETWcPrKfBF2Wrx0Qm5SnUA=;
        h=Message-ID:Subject:From:To:Date:From;
        b=ZX1O3cJ2hNAmo/oJqzwZLv0No7NRNGqB6mvicWUAXTQyXltAEIqESfgXCV6tg4Hs8
         R3Rdj3Qvb7D+t8RvFBjoOhpEBuxmGEZn1Cr3mskSoHw5N3u6i+3RQ2e21zYDanL1oR
         0arTj7koS7vH5MuEE4RkNQIvm9AVYKp6jrbJyAtY=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id G__BCZz8wh2Y; Sat,  6 Feb 2021 09:40:33 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C2E5712800EE;
        Sat,  6 Feb 2021 09:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612633233;
        bh=wztkNCBX/ZeuHiJS/Vj2aETWcPrKfBF2Wrx0Qm5SnUA=;
        h=Message-ID:Subject:From:To:Date:From;
        b=ZX1O3cJ2hNAmo/oJqzwZLv0No7NRNGqB6mvicWUAXTQyXltAEIqESfgXCV6tg4Hs8
         R3Rdj3Qvb7D+t8RvFBjoOhpEBuxmGEZn1Cr3mskSoHw5N3u6i+3RQ2e21zYDanL1oR
         0arTj7koS7vH5MuEE4RkNQIvm9AVYKp6jrbJyAtY=
Message-ID: <4694bcc43696d52e6a81c915c2215bc8022918fc.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.11-rc6
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 06 Feb 2021 09:40:32 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

One fix in drivers (lpfc) that stops an oops on resource exhaustion.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

James Smart (1):
      scsi: lpfc: Fix EEH encountering oops with NVMe traffic

And the diffstat:

 drivers/scsi/lpfc/lpfc_nvme.c | 3 +++
 1 file changed, 3 insertions(+)

With full diff below

James

---

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 1cb82fa6a60e..39d147e251bf 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -559,6 +559,9 @@ __lpfc_nvme_ls_req(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		return -ENODEV;
 	}
 
+	if (!vport->phba->sli4_hba.nvmels_wq)
+		return -ENOMEM;
+
 	/*
 	 * there are two dma buf in the request, actually there is one and
 	 * the second one is just the start address + cmd size.

