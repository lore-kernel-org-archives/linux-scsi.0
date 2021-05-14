Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97421C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B1B361029
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 21:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbhENVhn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 17:37:43 -0400
Received: from mail-pj1-f47.google.com ([209.85.216.47]:46809 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233639AbhENVh0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 17:37:26 -0400
Received: by mail-pj1-f47.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso458310pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 14:36:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=39CFdvPUx2YylU5fmmA6ia5kiG8IPH28yP2o/gwmaNE=;
        b=El34IGpWecKy6+ahaqHgUiSI30A2T2W4failC1KIhfSsQESDtehJCoIURHmvAiNBmh
         HyRdvicrRUmaqssIr3fx6XrxT65S5MYmqIMbnv+jpihge0/cSFh2tYx4kT/KHER1J5cl
         oNsG+1+3MPdtdI1vy+UL0VHCiZI4rWvZ5pYpC2cvcz0bzQYhn0iIaSZjIKKBTUGZzW7+
         Gid6nDwK43G1NQNCP14hh9iSkSQwbWqdpm3ZDNNVc8Cby0JAGcuxwMRLzedV8T/QgOwQ
         mPt02Iazn3VJE3HUJBgpguOsefT5KsjfhQ5R9HBBzco4eOpwgWcbp5s084x0XSGzy7Ib
         jYGQ==
X-Gm-Message-State: AOAM5328rvxW4D9HLCziSGzab8UuTsJiBhwqxwBAriwe7S+KiuViEiu0
        o6FOxSvgyWP1uwDNHuHK9OI=
X-Google-Smtp-Source: ABdhPJxdCKiNAoRbIvA4YqJd0EOTeQ8ZXOnpc9+bhIy2+ih6V0rgbn6heNZsiAYsUXaRlu3l9EdPbw==
X-Received: by 2002:a17:902:e5cb:b029:ed:64d5:afee with SMTP id u11-20020a170902e5cbb02900ed64d5afeemr47444536plf.41.1621028173583;
        Fri, 14 May 2021 14:36:13 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:e40c:c579:7cd8:c046])
        by smtp.gmail.com with ESMTPSA id js6sm9307262pjb.0.2021.05.14.14.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:36:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 24/50] ips: Use blk_req() instead of scsi_cmnd.request
Date:   Fri, 14 May 2021 14:33:30 -0700
Message-Id: <20210514213356.5264-76-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514213356.5264-1-bvanassche@acm.org>
References: <20210514213356.5264-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using blk_req() instead. This
patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index bc33d54a4011..6bcc655d1f15 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3733,7 +3733,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 		scb->cmd.dcdb.segment_4G = 0;
 		scb->cmd.dcdb.enhanced_sg = 0;
 
-		TimeOut = scb->scsi_cmd->request->timeout;
+		TimeOut = blk_req(scb->scsi_cmd)->timeout;
 
 		if (ha->subsys->param[4] & 0x00100000) {	/* If NEW Tape DCDB is Supported */
 			if (!scb->sg_len) {
