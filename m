Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C89C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 19:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A28726101D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 19:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbhJLTVC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 15:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbhJLTVB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 15:21:01 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CC0C061570
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 12:18:59 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c4so207310pls.6
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 12:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fTY3DhHW7LUii63lWpR4+Xk0XrztfZ+GRECwzD/3xaU=;
        b=QzmV/l8EALH+kI5heXQqOmxj5AViWh43yBqek9UlwfD4FCmOxCgivmMECz1rNAUtH4
         1imnuVb+lDVS7cpKFzdRp1j6BhXDb+PwMiEZ7Pd4bE+PIeseIcNyavF5GKmnBAnpnm78
         0XAjseVjfJQPaNoHtHKT4P4llOGVPFwjrzP9k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fTY3DhHW7LUii63lWpR4+Xk0XrztfZ+GRECwzD/3xaU=;
        b=1CDenb5Z3P6/c8lPC7enH1PZ53zgCvtPevkn/DKg0WEZcsabICio5MYNsVPEYVSfh2
         xkvYoqnn/iLJy75XPsM4CMFIx3ChnJuED1f/maTg9oRWZi+mEwYxmGJmtsGierHBA4vM
         OEvvky9gyv+zHl05gmKY5AJSV33gmjSirjbzAdkvrqhf3bP6Ru4vTYWK9Ba1RdVg0Arw
         78nTlJ5nn4IupKtL5nm++icrNnXfehdkrBdFe5qP9AHDwEYD2F4No6K6+TycSYH+X6Gb
         OXdqisJkgQQ/V4YlGhKdZ/Hp7UZxE573Yplasr6cA+1MXNwteLphVMfiY8D/DbwMclAf
         3wPg==
X-Gm-Message-State: AOAM532kpi35ByuzrMOASO8cPx9d1dnKNnRQyXIebppFaneCQMl1tMnW
        ceJyY77kJ8dcGml7x12sx71o18h/8krfjMjkPhqVFT1EFirgs6w2aZvmWsWAjMyjk0P8wiVU+oj
        ImuQ2TFPGnPvfyuK2ciKPfKxldYrxjvtBnpr05TpEkiFUbn882nkDo2ncw+OBGgyuQLz+fHvVz3
        aibM7fa8Mm
X-Google-Smtp-Source: ABdhPJxSj3SoMeWrA9XTfE7rI1UQI5/v/5yL1FS6Jv+Nbc750MFqFiJHbpPS/gv0NqgvUp6GO4i6sQ==
X-Received: by 2002:a17:90a:aa14:: with SMTP id k20mr8140354pjq.88.1634066338404;
        Tue, 12 Oct 2021 12:18:58 -0700 (PDT)
Received: from dev-jgu.dev.purestorage.com ([192.30.188.252])
        by smtp.googlemail.com with ESMTPSA id 139sm11838872pfz.35.2021.10.12.12.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 12:18:58 -0700 (PDT)
From:   Joy Gu <jgu@purestorage.com>
To:     linux-scsi@vger.kernel.org
Cc:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        bvanassche@acm.org, Joy Gu <jgu@purestorage.com>
Subject: [PATCH 1/2] scsi: qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()
Date:   Tue, 12 Oct 2021 12:18:33 -0700
Message-Id: <20211012191834.90306-2-jgu@purestorage.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211012191834.90306-1-jgu@purestorage.com>
References: <20211012191834.90306-1-jgu@purestorage.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 8c0eb596baa5 ("[SCSI] qla2xxx: Fix a memory leak in an error path of
qla2x00_process_els()"), intended to change

        bsg_job->request->msgcode == FC_BSG_HST_ELS_NOLOGIN

to

        bsg_job->request->msgcode != FC_BSG_RPT_ELS

but changed it to

        bsg_job->request->msgcode == FC_BSG_RPT_ELS

instead.

Change the == to a != to avoid leaking the fcport structure or freeing
unallocated memory.

Fixes: 8c0eb596baa5 ("[SCSI] qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()")
Signed-off-by: Joy Gu <jgu@purestorage.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 4b5d28d89d69..655cf5de604b 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -431,7 +431,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 	goto done_free_fcport;
 
 done_free_fcport:
-	if (bsg_request->msgcode == FC_BSG_RPT_ELS)
+	if (bsg_request->msgcode != FC_BSG_RPT_ELS)
 		qla2x00_free_fcport(fcport);
 done:
 	return rval;
-- 
2.17.1

