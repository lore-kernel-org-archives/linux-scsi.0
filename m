Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE37C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 21:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85701611C8
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 21:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343668AbhIQVYr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 17:24:47 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:55827 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239420AbhIQVYq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 17:24:46 -0400
Received: by mail-pj1-f53.google.com with SMTP id t20so7803051pju.5
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 14:23:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tl2dQIaN8K9Jr658VeUBw6mwUcRa+v3rzBPMf9M0MRU=;
        b=O8O6TC1OO99sEDGg2hu4VTKvSa+3IrrHqN3YBf4aPWRWfmsT9h399Bl+GV/QPpRrap
         5zMC2m5p5dLSySoJxlcbLcuN/4LwQ+vIdVEhR6h7vrDPmQQaYkLbtHV1qML+v9uAEUbn
         aBEcIHwlKgZOG/lvaev6nMBwYAbFnyXxkIYvzAvnLggNAw4R6EVcmfUaNSXNUOgWJeWt
         M0Q2UtQh5W6+QBYAGYVpbPFi3nR5ziR21EEOSa8MzvFpsyvE/9Xcrev1aKEC6Pe7rcMv
         FCJ16ya8Nr4c0300P7ETsL/iKq2urMhexL37SAiR2NA5h9K5FLflNxqYyL2oHzvrgOup
         Vxyg==
X-Gm-Message-State: AOAM533UqxDZPOVVMpGdjiznRa+Qy9hZkqc3KltYuqwkiQ+Qe2FoFRNS
        uVOpqS72J8v6N32wHjqCOaw=
X-Google-Smtp-Source: ABdhPJxYwiVks9VDY9L2qaCeMONy+fNjgtsjMXnigGqMy+AQ5G8jNooUwitPpt+XejZoACKk8E3u4Q==
X-Received: by 2002:a17:90a:4498:: with SMTP id t24mr14442415pjg.235.1631913803735;
        Fri, 17 Sep 2021 14:23:23 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:aa45:4fa2:923f:21d1])
        by smtp.gmail.com with ESMTPSA id w14sm7293769pge.40.2021.09.17.14.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 14:23:23 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: sd_zbc: Support disks with more than 2**32 logical blocks
Date:   Fri, 17 Sep 2021 14:23:14 -0700
Message-Id: <20210917212314.2362324-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch addresses the following Coverity report about the
zno * sdkp->zone_blocks expression:

CID 1475514 (#1 of 1): Unintentional integer overflow (OVERFLOW_BEFORE_WIDEN)
overflow_before_widen: Potentially overflowing expression zno *
sdkp->zone_blocks with type unsigned int (32 bits, unsigned) is evaluated
using 32-bit arithmetic, and then used in a context that expects an
expression of type sector_t (64 bits, unsigned).

Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>
Fixes: 5795eb443060 ("scsi: sd_zbc: emulate ZONE_APPEND commands")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd_zbc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index b9757f24b0d6..ded4d7a070a0 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -280,7 +280,7 @@ static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
 {
 	struct scsi_disk *sdkp;
 	unsigned long flags;
-	unsigned int zno;
+	sector_t zno;
 	int ret;
 
 	sdkp = container_of(work, struct scsi_disk, zone_wp_offset_work);
