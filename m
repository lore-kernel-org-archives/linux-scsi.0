Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E41C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B736D20866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T1K6mGDe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbfHNX5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:30 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33222 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728947AbfHNX51 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:27 -0400
Received: by mail-pg1-f194.google.com with SMTP id n190so438183pgn.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8yIhMcON7xLN0hMLhvEm8QIWhIJo6dFKEW3lh9pAS0U=;
        b=T1K6mGDeN+2eWmUtmmvo7n1+xkRoaU7Fot39S9ftxjOiil+BlVOKq8wi/vgMy7G9yu
         d+5+17XvzoxfZJS23K1gmCfpQ/nMPBYmbV4fplNejf4l66Shsfs1tBZdG9TXB6vehBC2
         pWvEfWm0hS7gKCvLXwDAxOGMgXvdTh2Mhn1cAAqcfWAPG9VYRMfWQVW1hpo7PUk3GSRP
         LV0jDrc+n4YixB1P8vgmZqUTVOt4h8UIaX0FjdXHjaZexLamwRLAh5iqbATrTnXcFjWI
         /yIsyYiHvSdcFF2ncdWOAUY6p8eFm+gh487JzjABCyqm+zEEfL+dLmWGR010Kp2tObKM
         8V+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8yIhMcON7xLN0hMLhvEm8QIWhIJo6dFKEW3lh9pAS0U=;
        b=D8oslY3JucRU5QHuc9tl6FYrY53psaov8W0bffnZrFEoNSGDN815QMzKXCe5q12cZX
         dRXolvSaM/LiPrwkvjet2o7HslAQjVtcdFkWwLG7qIDzva+eG4UJs7XQniQ3AgFsOIgY
         JJmEnqQWRz1xTSJT+ZcybiMzWMVSmxu/xJ4M5Ut3GHFABN/NR9mjXlvOf8ioCVfL7aeb
         t38l87BZdHLoUK0UVw1lPBw9MGX5Zmash8gcImT/mt8zCcWkATRjwECL+JcPKKjULd+B
         cn9Ucqvvnxt2kxuGsIqWn/PCPROZ+dNrc1W93JwW0tTa3md7rkrca/snzktCagCvpqyr
         eVmg==
X-Gm-Message-State: APjAAAWSqVhnPM9s5e/L2YFs6N6b9zmMh166LBt5tD608Jglg/Dhuepv
        elUBDqcYT/zLM6hpROUi43EzUP07
X-Google-Smtp-Source: APXvYqz8eQONFv2bUjX63+1oQeVlClR73BMFg1tsOnxN59ql3Eeo54xcMn90rZT6K1tCk6CuX+5G8Q==
X-Received: by 2002:aa7:8602:: with SMTP id p2mr2593987pfn.138.1565827046263;
        Wed, 14 Aug 2019 16:57:26 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:25 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 05/42] lpfc: Fix failure to clear non-zero eq_delay after io rate reduction
Date:   Wed, 14 Aug 2019 16:56:35 -0700
Message-Id: <20190814235712.4487-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Unusually high IO latency can be observed with little IO in
progress. The latency may remain high regardless of amount of IO and
can only be cleared by forcing lpfc_fcp_imax values to non-zero and
then back to zero.

The driver's eq_delay mechanism that scales the interrupt coalescing
based on io completion load failed to reduce or turn off coalescing
when load decreased. Specifically, if no io completed on a cpu within
an eq_delay polling window, the eq delay processing was skipped and no
change was made to the coalescing values. This left the coalescing
values set when they were no longer applicable.

Fix by always clearing the percpu counters for each time period and
always run the eq_delay calculations if an eq has a non-zero
coalescing value.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 50d641f65af9..72353c9c0fa9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1262,6 +1262,7 @@ lpfc_hb_eq_delay_work(struct work_struct *work)
 	unsigned char *eqcnt = NULL;
 	uint32_t usdelay;
 	int i;
+	bool update = false;
 
 	if (!phba->cfg_auto_imax || phba->pport->load_flag & FC_UNLOADING)
 		return;
@@ -1275,20 +1276,29 @@ lpfc_hb_eq_delay_work(struct work_struct *work)
 	if (!eqcnt)
 		goto requeue;
 
-	/* Loop thru all IRQ vectors */
-	for (i = 0; i < phba->cfg_irq_chann; i++) {
-		/* Get the EQ corresponding to the IRQ vector */
-		eq = phba->sli4_hba.hba_eq_hdl[i].eq;
-		if (eq && eqcnt[eq->last_cpu] < 2)
-			eqcnt[eq->last_cpu]++;
-		continue;
-	}
+	if (phba->cfg_irq_chann > 1) {
+		/* Loop thru all IRQ vectors */
+		for (i = 0; i < phba->cfg_irq_chann; i++) {
+			/* Get the EQ corresponding to the IRQ vector */
+			eq = phba->sli4_hba.hba_eq_hdl[i].eq;
+			if (!eq)
+				continue;
+			if (eq->q_mode) {
+				update = true;
+				break;
+			}
+			if (eqcnt[eq->last_cpu] < 2)
+				eqcnt[eq->last_cpu]++;
+		}
+	} else
+		update = true;
 
 	for_each_present_cpu(i) {
-		if (phba->cfg_irq_chann > 1 && eqcnt[i] < 2)
-			continue;
-
 		eqi = per_cpu_ptr(phba->sli4_hba.eq_info, i);
+		if (!update && eqcnt[i] < 2) {
+			eqi->icnt = 0;
+			continue;
+		}
 
 		usdelay = (eqi->icnt / LPFC_IMAX_THRESHOLD) *
 			   LPFC_EQ_DELAY_STEP;
-- 
2.13.7

