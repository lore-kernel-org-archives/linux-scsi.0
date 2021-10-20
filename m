Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09DAC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAF1161284
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhJTVQw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhJTVQo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:16:44 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CBAC061749
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:28 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t21so8983950plr.6
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=umOpU67khKNbJoJIeW5eB8eN825/mrgzUU4aCVjEX3c=;
        b=dc3bUiuKFbq5gdv+Wzp0tbXQXLV621lABmwiaHpjlYBY3ZSWVSu98YR1kybqW4Xzdc
         GFaBzNjknwPnsq+9d8Zx35mF5lBXrUSpWogLntcaboUuvF+Wd2ak8o2Ock0yPiy4wYo7
         7DO7uIH9BmpxXd2eH4HKbwwpmVL+FkRN5gp21Jf87Z3Cxeoh7uQUxt1iiEOd9pqIWs/E
         5zSEhUvfID5PiO2EyIqK7iRpWxgWwzfa9sGH1P+Dd27GyFrcnOD7qKCis4AqGqx74RGl
         e3tt5nIp4PwV8q17UbSXHuW8xhcU+raVXvAPTVGCnmQewHdeee3GnTC3fO1MW4/+1X8j
         SsKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=umOpU67khKNbJoJIeW5eB8eN825/mrgzUU4aCVjEX3c=;
        b=m89FR7vbiCxQvlwn3KPlaabxQ8UXBPAoQvDyy74SS8ddteCEggpsLDBpjhgx9sTqbd
         /NeGpQ/9jpLhywJlsIYdZR3lOL6cr0ZJpcU0yFsUy9VJmr0WacvZ1cfFUKp+z3rD+PMx
         amD0R+1lrwEx7dS1PjW6BeLLbZ/CfBxYcl0QZelkFDTGscaBMQEuJVpVthkPIUZRI9pV
         yWE9Nb7Mc6BNKtE8uC2e3JiY/2me4hsKqQ5c8H3/gzAoWsuf9cmCbHn/EMqGzukXHC2d
         8l02TYyoZuXt9IHQJM2SN/jvt18B44fewKe10ARfGyaohj1klth3Jrzq/IBXF2JuJTFB
         ACGw==
X-Gm-Message-State: AOAM532wVk6LFc6i/H0+HjzgWK6VO7SCByVWwHDh8r8Z0JGJBkBi+LDV
        m+PHLZgDHzQNrE2NG1ykS7rG5nXiKes=
X-Google-Smtp-Source: ABdhPJyIf56oPLtEOC4+gvNwv+S/8Z2hPsAa9Of9d9EBiE4iYbpLbXdT5iYk/nKBpA3+CmRjW1WU6g==
X-Received: by 2002:a17:902:e883:b0:13f:1393:d185 with SMTP id w3-20020a170902e88300b0013f1393d185mr1404098plg.64.1634764468247;
        Wed, 20 Oct 2021 14:14:28 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id pi9sm3700689pjb.31.2021.10.20.14.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:14:27 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 6/8] lpfc: Fix link down processing to address NULL pointer dereference
Date:   Wed, 20 Oct 2021 14:14:15 -0700
Message-Id: <20211020211417.88754-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211020211417.88754-1-jsmart2021@gmail.com>
References: <20211020211417.88754-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If an FC link down transition while PLOGIs are outstanding to
fabric well known addresses, outstanding ABTS requests may result
in a NULL pointer dereference. Driver unload requests may hang with
repeated "2878" log messages.

The Link down processing results in ABTS requests for outstanding ELS
requests. The Abort WQEs are sent for the ELS's before the driver had
set the link state to down. Thus the driver is sending the Abort with
the expectation that an ABTS will be sent on the wire. The Abort
request is stalled waiting for the link to come up. In some conditions
the driver may auto-complete the ELS's thus if the link does come up,
the Abort completions may reference an invalid structure.

Fix by ensuring that Abort set the flag to avoid link traffic if
issued due to conditions where the link failed.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f82f809617a0..5dedb3de271d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12403,17 +12403,17 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 	/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 	abtsiocbp->hba_wqidx = cmdiocb->hba_wqidx;
-	if (cmdiocb->iocb_flag & LPFC_IO_FCP) {
-		abtsiocbp->iocb_flag |= LPFC_IO_FCP;
-		abtsiocbp->iocb_flag |= LPFC_USE_FCPWQIDX;
-	}
+	if (cmdiocb->iocb_flag & LPFC_IO_FCP)
+		abtsiocbp->iocb_flag |= (LPFC_IO_FCP | LPFC_USE_FCPWQIDX);
 	if (cmdiocb->iocb_flag & LPFC_IO_FOF)
 		abtsiocbp->iocb_flag |= LPFC_IO_FOF;
 
-	if (phba->link_state >= LPFC_LINK_UP)
-		iabt->ulpCommand = CMD_ABORT_XRI_CN;
-	else
+	if (phba->link_state < LPFC_LINK_UP ||
+	    (phba->sli_rev == LPFC_SLI_REV4 &&
+	     phba->sli4_hba.link_state.status == LPFC_FC_LA_TYPE_LINK_DOWN))
 		iabt->ulpCommand = CMD_CLOSE_XRI_CN;
+	else
+		iabt->ulpCommand = CMD_ABORT_XRI_CN;
 
 	if (cmpl)
 		abtsiocbp->iocb_cmpl = cmpl;
-- 
2.26.2

