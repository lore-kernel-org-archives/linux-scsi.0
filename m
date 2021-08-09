Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA14C4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5FD560FE3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 23:05:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237002AbhHIXFY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 19:05:24 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:53902 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236937AbhHIXFT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 19:05:19 -0400
Received: by mail-pj1-f50.google.com with SMTP id j1so30351048pjv.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 16:04:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6RFPIMyLjhMpfnOIb75hPSlP1Uw3EoOUZEQ1HTdVJZU=;
        b=EV8JCMw6zLwDp/BJxXt/lG8YfAJkUsMZGtBPut2NsGSSipiIYHo7qZqtiZfbcuXfIH
         KgrFkoRc261vsqiQyLBGf7+Oxlo5LHvoCPghgrcEaBxV2Eqn5qmmSubhmHqWTBn4f5V2
         g544vfatP1vaay/8W7ps3y/9EB04ZL1rlxJdHZr+ISpIW8fwHfUpCD6jEMVrS1SLmlZR
         pr6aMm+gcFHF7qBNot1EMktdVu+i5qqlR1AQTZWdmf0u2x+ThyOiLCKF8P5QE26dTc/W
         Vo/qzcO8JQIpGYZ7EVSmWxOGjli0xfalL16+HrBGrbvEKW89l+gKvCL863ooFmz44SQm
         SV4g==
X-Gm-Message-State: AOAM531zqhdHygiksBB12Dwi6SJns9GnWGOT+8PV8nwQW3l7ykGpvTgA
        aUUXnCxhiU0UTvzECowYdKQ=
X-Google-Smtp-Source: ABdhPJyIRy9PJiAqfvCNY+6WrpjLvu3aae88ickeamVbNfRsEPQFai7D3grT8aw8h8lcDfTe6j37iw==
X-Received: by 2002:a17:90a:6782:: with SMTP id o2mr1467632pjj.165.1628550297977;
        Mon, 09 Aug 2021 16:04:57 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id j6sm24102260pgq.0.2021.08.09.16.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:04:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 35/52] qedf: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Mon,  9 Aug 2021 16:03:38 -0700
Message-Id: <20210809230355.8186-36-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809230355.8186-1-bvanassche@acm.org>
References: <20210809230355.8186-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedf/qedf_io.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 6b5b6a75ac88..3404782988d5 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -1162,13 +1162,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 		return;
 	}
 
-	if (!sc_cmd->request) {
-		QEDF_WARN(&(qedf->dbg_ctx), "sc_cmd->request is NULL, "
-		    "sc_cmd=%p.\n", sc_cmd);
-		return;
-	}
-
-	if (!sc_cmd->request->q) {
+	if (!scsi_cmd_to_rq(sc_cmd)->q) {
 		QEDF_WARN(&(qedf->dbg_ctx), "request->q is NULL so request "
 		   "is not valid, sc_cmd=%p.\n", sc_cmd);
 		return;
