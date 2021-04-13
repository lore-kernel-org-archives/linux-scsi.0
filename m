Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AA1C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38E84613B7
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347131AbhDMRIL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:08:11 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:38735 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347115AbhDMRIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:08:02 -0400
Received: by mail-pg1-f179.google.com with SMTP id w10so12400836pgh.5
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QoCVFea0rBzcHUxlyOuca8dkEEiPNeb8FPBb/uBAino=;
        b=ONsxeWq8NEtQzuwUeiDsCkX07ribWknIHx3KgLNbpD5DQLOjWndA0sIzYDfSAq651H
         /cBH0p8nQAGaRfgYvoNLXxrfBYJQSLnRX4DRvpCQiqprrxgbNSN9X4AFluWpShmYo1M6
         lzzk7rxDFn3Kv0rgeDiUEwgxCR1hV3u+z3Uchy7zo3qe4lLaRhfvSOaGcHMGUK0G71Bz
         9yL2/HAI3gyz1WukjotyNdIYJw8OFYzagqRLT/h6BMNN8ne8JGShxwkqWIyfwOwUbqN5
         rUDb5kArc3puI6C3icNw7qmzqQH2ZihtaFy66LnWcWYmoF9RFS/7BSV7O5nvkT7tG8nc
         IHwQ==
X-Gm-Message-State: AOAM531fuiP6IMeBAShlfsUXsK+HJQWBzDmtU0c1p60YO8V1J1W2B31z
        rxF79n5lBNvQZAF1wa6VXDU=
X-Google-Smtp-Source: ABdhPJxsUGgxGibxaLa0ulhjD70k7xQQeOU90VCG9/bQlXcZW9qUGBthZZ4QazDJXzLGV5WkiWiIhg==
X-Received: by 2002:a62:ab06:0:b029:249:db1c:3d7d with SMTP id p6-20020a62ab060000b0290249db1c3d7dmr15612945pff.72.1618333662633;
        Tue, 13 Apr 2021 10:07:42 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 18/20] target: Compare explicitly with SAM_STAT_GOOD
Date:   Tue, 13 Apr 2021 10:07:12 -0700
Message-Id: <20210413170714.2119-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of leaving it implicit that SAM_STAT_GOOD == 0, compare explicitly
with SAM_STAT_GOOD.

Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_pscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 1c9aeab93477..dac44caf77a3 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1046,7 +1046,7 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
 	int result = scsi_req(req)->result;
 	u8 scsi_status = status_byte(result) << 1;
 
-	if (scsi_status) {
+	if (scsi_status != SAM_STAT_GOOD) {
 		pr_debug("PSCSI Status Byte exception at cmd: %p CDB:"
 			" 0x%02x Result: 0x%08x\n", cmd, pt->pscsi_cdb[0],
 			result);
