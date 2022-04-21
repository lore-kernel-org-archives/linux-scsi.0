Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C379EC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 18:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391383AbiDUSdl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 14:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391368AbiDUSde (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 14:33:34 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D32C4BB84
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:44 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id md4so5694369pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IMaqiEmvW8IdKU81nnUqSEa/O3hGhvNCLFggqQwvW9g=;
        b=qTIO+R7934DAiPuiKdQS2mS/PLX54enJPPIdSTJG8LF/29OYaO8k2BQVHZuVd2B3mA
         mMa1VZzyyf5avvXAih7WW7VAQOP3UO746TY6R8jAlfgq36K9Ri9cyYWLi0m3vkGV1atW
         dCkjQfF9OhUUL/bYYTSz+WHmZTFn9VReEG327BOX4+GGvS3gxp0n+n01EvWpRS+1Yoam
         5kltNNU61F39o6wV2kwfcF4hOmhBa9iJ8MlG7ADED7h4c+N4qcGSNilQxyN9tKo+dIBf
         vUFqZLBMfz2t6lQcMlyxix1Y7Cxif6RIEjjHyTWhjANATxoV93xPYKhJ8n2TnIqnlS3N
         6Hiw==
X-Gm-Message-State: AOAM532XOEy7Fc+4mZMkOkk5DKNk7/f50k7WhDgOk3AaXkydC0JIcYNX
        ZArlSN+C/HR25BTtxMQScmc=
X-Google-Smtp-Source: ABdhPJyG4wtciLvv3+vFMI6YNIvQ8/E+PVB8gKsxEBaj5q9g4BOp/e/n5aU2zoLDu7PQTEfqaQQQwA==
X-Received: by 2002:a17:90b:2691:b0:1d2:72b9:b9b with SMTP id pl17-20020a17090b269100b001d272b90b9bmr1062550pjb.80.1650565843628;
        Thu, 21 Apr 2022 11:30:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a034:31d8:ca4e:1f35])
        by smtp.gmail.com with ESMTPSA id a22-20020a62d416000000b0050bd98eaccbsm2181079pfh.213.2022.04.21.11.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 11:30:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 5/9] scsi: sd_zbc: Return early in sd_zbc_check_zoned_characteristics()
Date:   Thu, 21 Apr 2022 11:30:19 -0700
Message-Id: <20220421183023.3462291-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
In-Reply-To: <20220421183023.3462291-1-bvanassche@acm.org>
References: <20220421183023.3462291-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Return early in sd_zbc_check_zoned_characteristics() for host-aware
disks. This patch does not change any functionality but makes a later
patch easier to read.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
[ bvanassche: extracted this change from a larger patch ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd_zbc.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index ac557a5a65c8..c53e166362b9 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -592,14 +592,15 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
 		sdkp->zones_optimal_open = get_unaligned_be32(&buf[8]);
 		sdkp->zones_optimal_nonseq = get_unaligned_be32(&buf[12]);
 		sdkp->zones_max_open = 0;
-	} else {
-		/* Host-managed */
-		sdkp->urswrz = buf[4] & 1;
-		sdkp->zones_optimal_open = 0;
-		sdkp->zones_optimal_nonseq = 0;
-		sdkp->zones_max_open = get_unaligned_be32(&buf[16]);
+		return 0;
 	}
 
+	/* Host-managed */
+	sdkp->urswrz = buf[4] & 1;
+	sdkp->zones_optimal_open = 0;
+	sdkp->zones_optimal_nonseq = 0;
+	sdkp->zones_max_open = get_unaligned_be32(&buf[16]);
+
 	/*
 	 * Check for unconstrained reads: host-managed devices with
 	 * constrained reads (drives failing read after write pointer)
