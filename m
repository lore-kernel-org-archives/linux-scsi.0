Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FF8C2D0D2
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6592E222C2
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TIhSAy3K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfLRX6d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:58:33 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37237 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbfLRX6c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 18:58:32 -0500
Received: by mail-wm1-f65.google.com with SMTP id f129so3796904wmf.2
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 15:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sJThSQrCzIMCci9msuxVVOlbZZ2FNJGh01WUc1dAmJM=;
        b=TIhSAy3KQhGzo513x/gBQMqnMKvm+BO7VKyWx3Wh3K/yTYx9AKynZRI7rVYBreGkwS
         uCTruuEiE3g8xUHfPqWLOqfZOTCPK+7WkpH514Y5vsEmjdqBA5Q6uo3g8ehhslXxAH5y
         l5Pxqjwo78Pb1wSTnvIKEhXw5S5/26+tCJl6nJq1dHMRhS7ibQp5uq+xRDiOD3gWg16p
         NuAbujTqOus7B+N4HvRGIfRE/3zpoysTzooXOGtIeiCpbEPuDyIUUINC/B0FjRfVysrr
         186citorqF4b4+InjVZqeVoraqpkWwV7tal7jojsr4GjanukQhjsgSdrIkhmqCRmJP8W
         A2lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sJThSQrCzIMCci9msuxVVOlbZZ2FNJGh01WUc1dAmJM=;
        b=fj2/4E97raf0iQNivCuYIcP2jaFXHrUwhdHSZC5BJ1D6DuOHhv546qgVTjUs4ZP/p3
         htNJhCK3myLhXYaAahN5vXFO6ewuurEWEDudNDU+iwKPzDYZzdd+GbWHTb6deVEjN4Hy
         vz/sMRUvHhLP18JJBnG4eMPHkTdmHG3SJuyhUyOxdBS4GmRwXQc2NGPOQwe4PhTscKxw
         5kAq+BjHbYf3nO/xsqBtZLUralu4cEZMNsiz3jS/5wchAvb2ROWdyJwvYQBx1xDUf2sC
         qqG0jtlhoh9gHKFYXju4zmxKxmC2RV8OV5k4yM13vBdIanSSVm2yc+vluCj/OpJdYoSh
         oayg==
X-Gm-Message-State: APjAAAXijCCLtw8holVqONBVv9aNnodj5n9vHYPCiHP5qpOHmoJaoW4K
        +5C6DFyIcLilq8uy58VBlZhtPmO3
X-Google-Smtp-Source: APXvYqxvyy/EFWfIt5aCqSyOlV9ep+vZ2wFiLBCAi0Hm1HRSCEslz3ZllNMC8dSUKi14p2oIExMtpQ==
X-Received: by 2002:a05:600c:20c7:: with SMTP id y7mr6527924wmm.21.1576713511140;
        Wed, 18 Dec 2019 15:58:31 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x11sm4240731wmg.46.2019.12.18.15.58.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Dec 2019 15:58:30 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 08/10] lpfc: Fix MDS Latency Diagnostics Err-drop rates
Date:   Wed, 18 Dec 2019 15:58:06 -0800
Message-Id: <20191218235808.31922-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191218235808.31922-1-jsmart2021@gmail.com>
References: <20191218235808.31922-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When running Cisco-MDS diagnostics which perform driver-level frame loop
back, the switch is reporting errors. Diagnostic has a limit on latency
that is not being met by the driver.

The requirement of Latency frames is that they should be responded back
by the host with a maximum delay of few hundreds of microseconds. If the
switch doesn't get response frames within this time frame, it fails the
test.

Test is failing as the lpfc-wq workqueue was overwhelmed by the packet
rate and in some cases, the work element yielded to other kernel elements.

To resolve, reduce the outstanding load allowed by the adapter. This
ensures the driver spends a reasonable amount of time doing loopback and
can do so such that latency values can be met.  Load is managed by reducing
the number of receive buffers posted such that the link can be
backpressured to reduce load.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 12319f63cb45..e660ee98ad8b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4918,8 +4918,17 @@ static int
 lpfc_sli4_rb_setup(struct lpfc_hba *phba)
 {
 	phba->hbq_in_use = 1;
-	phba->hbqs[LPFC_ELS_HBQ].entry_count =
-		lpfc_hbq_defs[LPFC_ELS_HBQ]->entry_count;
+	/**
+	 * Specific case when the MDS diagnostics is enabled and supported.
+	 * The receive buffer count is truncated to manage the incoming
+	 * traffic.
+	 **/
+	if (phba->cfg_enable_mds_diags && phba->mds_diags_support)
+		phba->hbqs[LPFC_ELS_HBQ].entry_count =
+			lpfc_hbq_defs[LPFC_ELS_HBQ]->entry_count >> 1;
+	else
+		phba->hbqs[LPFC_ELS_HBQ].entry_count =
+			lpfc_hbq_defs[LPFC_ELS_HBQ]->entry_count;
 	phba->hbq_count = 1;
 	lpfc_sli_hbqbuf_init_hbqs(phba, LPFC_ELS_HBQ);
 	/* Initially populate or replenish the HBQs */
-- 
2.13.7

