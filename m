Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFEEC3A5A4
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 23:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95BD720679
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 23:19:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d/APXiMg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfH1XTY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 19:19:24 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40010 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbfH1XTY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2019 19:19:24 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so513985pgj.7
        for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2019 16:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=W6COeA4Ac/dznQfbO5F5p+ZRR+cO5zCdbu4dzcsO01A=;
        b=d/APXiMgFw9BXbnbs5xuPp+miBLOrvsxVZ64JRCbXOrVcA21M6oAfmQQzTeoq9YSJg
         BGCVXwHa1dnm8K+01fufG7RoJL1djVR7/dwaoaChGCzbVKmiUprInqUmFJ+02DUUH3/4
         Zlia2UBjHu3WA1kUnAZRzcQAZpWDedJR54TgKh/J11A/JsKkIul9aD5somjUCBmjr7z0
         a5W3qw9QhihNMLQOk9hlVBlNFQ/1CUUDgyCg1W6fZxxdNhaetQbZBc8r5ocOPiNzMwJg
         t4wMZkx6Mb7ZkZuEjeRfV99WwiYi8BLKGHyWJhPQVAgj4znuojozFwPytv4rQ4TmC3Nl
         9i0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=W6COeA4Ac/dznQfbO5F5p+ZRR+cO5zCdbu4dzcsO01A=;
        b=OirCVbH7p7lYwtS8zNumCeKAUTEI6G2nVGZOAJq4Y0CBODBWm0hmO3q0NREDNSxisg
         +WyDIqervDOLaHrgTU7qyAlcTCuMB127fXp5RZ4otCVaWOM5GwKHkDjovUYTr1nv1liY
         BAIyrgz8/EKDuW4SWZO6PvuE88/jUH/MkaT9jz78yI+gPZH4rpwmPDJHPY0MGF8mMEhx
         MVFngMKyrZtCa1nuyjIVkkuw2+BhEJAy92sxPMqaChCFi/Wzfk0TIg5hAvkCTcS8GI2I
         L8YtJG9KyDugUpMsaQsReIl4qqfj3/+03sg+4H+z9dFJELDetbZl3+z5PB82VJRjpl4p
         adVA==
X-Gm-Message-State: APjAAAWD2yHT3Zd/XfAqohwPQlOjtWAV2QV25LKQRyp7GoBu/emNvrUa
        vER/xCns8OifA4b/glk/rQU/zSco
X-Google-Smtp-Source: APXvYqxtEtXJ6pwRKkaBy1A6urP+THRgc2hUVoHvhPHPmCvTTpzIegg3Vx5M9iPzOGmNCIpsq2WVtg==
X-Received: by 2002:aa7:920b:: with SMTP id 11mr7433429pfo.231.1567034363153;
        Wed, 28 Aug 2019 16:19:23 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e9sm475244pfh.155.2019.08.28.16.19.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 28 Aug 2019 16:19:22 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH] lpfc: fix 12.4.0.0 GPF at boot
Date:   Wed, 28 Aug 2019 16:19:11 -0700
Message-Id: <20190828231911.8587-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 12.4.0.0 patch that merged WQ/CQ pairs into single per-cpu pair
contained a bug: a local variable was set to the queue pair by index.
This should have allowed the local variable to be natively used.
Instead, the code reused the index relative to the local variable,
obtaining a random pointer value that when used eventually faulted
the system

Convert offending code to use local variable.

Fixes: c00f62e6c546 ("scsi: lpfc: Merge per-protocol WQ/CQ pairs into single per-cpu pair")
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>

---
Offending patch and this patch are in 5.4/scsi-queue branch.
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 0dfd30aa4d99..bb5705267c39 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5553,7 +5553,7 @@ lpfc_sli4_arm_cqeq_intr(struct lpfc_hba *phba)
 		for (qidx = 0; qidx < phba->cfg_hdw_queue; qidx++) {
 			qp = &sli4_hba->hdwq[qidx];
 			/* ARM the corresponding CQ */
-			sli4_hba->sli4_write_cq_db(phba, qp[qidx].io_cq, 0,
+			sli4_hba->sli4_write_cq_db(phba, qp->io_cq, 0,
 						LPFC_QUEUE_REARM);
 		}
 
-- 
2.13.7

