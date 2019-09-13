Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA80C49ED7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22F26206BB
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="N6jIqaL7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387655AbfIMNFH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 09:05:07 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36171 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbfIMNFH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2019 09:05:07 -0400
Received: by mail-pg1-f195.google.com with SMTP id j191so4690249pgd.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2019 06:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7E/8Ckfzt8adr5wGWMwUFC7mUqpfHULJuU0jKyQCS7I=;
        b=N6jIqaL7cKEW5JffYfpI6te8dPbfq0xwkrMlq6t0Hvn4Yj8rD08ShMeYvMcPvmoAhI
         ZwieyHDeNVbZuAEoXg3/EZ9m26cH5lFg+U96x3M01liTFR9XXA3dk6rp80TixGxegZUu
         D6LC+LAsShb9xcwm3UKZ2wJFT9zaDML2ue16I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7E/8Ckfzt8adr5wGWMwUFC7mUqpfHULJuU0jKyQCS7I=;
        b=VFeiNhjcwbQ61KWyD8J30qUks5DNlpfPgl2RihYGyui7DtaydAH9f2IgDNqbOEfwMv
         SGdAYYkuqtlkYffvZsGbMTEIpoTKSbV0ISiJTrLrtbXrGjv0HgECVN7VTbwkJ9SY2zyr
         DjkoPflYm8gRfpHsxDRgmj/0XGNH57yezt8zjWEjkM33Gga+ix8pSDNTkhwqAY4fKPKw
         OfqMnTf5RQTrcrk1bB1Js/py+tIyJtt29vczUjwfcbQqm9EKdMKgu1RhaDZjQ1wSoraY
         oLwEvCRo8JZdvrVxYhGD899JT5/bc3K8WvuxSzh0Bng+weIlLzwgxxDoLvfMyd0whNCN
         uQ8A==
X-Gm-Message-State: APjAAAXSK8/jHQ73HjHoTFCR2lg6mMGVhTbSsrZMtm9a6tH3mmB0sogo
        jZAwVL6OaDrxZRTdu6/A1vSiIQ==
X-Google-Smtp-Source: APXvYqx2sBfphd7VK9U+A7gBcmzI/RwGeCBWWofhn4ORKfBNw/WvCcOif2xU3BQ5KXJIZv+X0buywA==
X-Received: by 2002:aa7:96f3:: with SMTP id i19mr57076587pfq.32.1568379905501;
        Fri, 13 Sep 2019 06:05:05 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 69sm37208841pfb.145.2019.09.13.06.05.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 06:05:05 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 02/13] mpt3sas: Display message before releasing diag buffer
Date:   Fri, 13 Sep 2019 09:04:39 -0400
Message-Id: <1568379890-18347-3-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
References: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Display message before releasing the diag buffer so that user knows
which event caused the release of diag buffer.

Releasing of diag buffer means HBA firmware stops posting the firmware
logs on the registered diag buffer.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |  7 +++++++
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c | 12 +++++++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 285edd7..76ca416 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -466,6 +466,13 @@ void mpt3sas_ctl_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 		if ((ioc->diag_buffer_status[i] &
 		     MPT3_DIAG_BUFFER_IS_RELEASED))
 			continue;
+
+		/*
+		 * add a log message to indicate the release
+		 */
+		ioc_info(ioc,
+		    "%s: Releasing the trace buffer due to adapter reset.",
+		    __func__);
 		mpt3sas_send_diag_release(ioc, i, &issue_reset);
 	}
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
index 6ac453f..8ec9bab 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
@@ -113,15 +113,21 @@ mpt3sas_process_trigger_data(struct MPT3SAS_ADAPTER *ioc,
 	struct SL_WH_TRIGGERS_EVENT_DATA_T *event_data)
 {
 	u8 issue_reset = 0;
+	u32 *trig_data = (u32 *)&event_data->u.master;
 
 	dTriggerDiagPrintk(ioc, ioc_info(ioc, "%s: enter\n", __func__));
 
 	/* release the diag buffer trace */
 	if ((ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
 	    MPT3_DIAG_BUFFER_IS_RELEASED) == 0) {
-		dTriggerDiagPrintk(ioc,
-				   ioc_info(ioc, "%s: release trace diag buffer\n",
-					    __func__));
+		/*
+		 * add a log message so that user knows which event caused
+		 * the release
+		 */
+		ioc_info(ioc,
+		    "%s: Releasing the trace buffer. Trigger_Type 0x%08x, Data[0] 0x%08x, Data[1] 0x%08x\n",
+		    __func__, event_data->trigger_type,
+		    trig_data[0], trig_data[1]);
 		mpt3sas_send_diag_release(ioc, MPI2_DIAG_BUF_TYPE_TRACE,
 		    &issue_reset);
 	}
-- 
1.8.3.1

