Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A271C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 18:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391375AbiDUSdj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 14:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391366AbiDUSdb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 14:33:31 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 872A64BB80
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:40 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso5968977pjj.2
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+ywR3IE+RqFTqhhoazuRftseC+YL/piARl7l7ozGdgw=;
        b=wcjtyKWqjipLzNZmwcob4mCxozEddAZkfQ607SROGg1SgeFer5fMNseX4IpyJwcZxV
         UGZP926V4T8R9OGYpdRBsfxteQ2DynnfRfCJXg9QBBD/zHBwoSFPXV3HR1BXMfVjVQ8/
         PywyFTNKkKTFaVx0xp8YUQ4oI3sUDohry+TnX1OSNQgdwgISU9YJb/tSL42SKRKv8NHX
         K+RFs17jecESIXtx/uV6thESMb3Cbdlu8+IEtYyNY7+Wwmq+UuPipjJzIQIQc+XhNQvp
         3vY7uSckyMSW91DvkfszY06n+XAxdbFWYZQWSNlm44Z64zrcpxMYzH/lYCeaaDunoT6D
         Wlwg==
X-Gm-Message-State: AOAM532kJRaDoA9ZEFS4eowBmc5WQn7KYDWxldfwDTK/dv49dFIWQBbS
        cZOLIRev+2Pn/IS+ywF4LPA=
X-Google-Smtp-Source: ABdhPJyP74pTX5pLIsKr2Zn4sS2D7vG67K615RiZwmmdFY38dAl/GYaskev4L/xcsOyYj+4SblTlKQ==
X-Received: by 2002:a17:902:ce0a:b0:156:72e2:f191 with SMTP id k10-20020a170902ce0a00b0015672e2f191mr798126plg.76.1650565839993;
        Thu, 21 Apr 2022 11:30:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a034:31d8:ca4e:1f35])
        by smtp.gmail.com with ESMTPSA id a22-20020a62d416000000b0050bd98eaccbsm2181079pfh.213.2022.04.21.11.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 11:30:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 3/9] scsi: sd_zbc: Use logical blocks as unit when querying zones
Date:   Thu, 21 Apr 2022 11:30:17 -0700
Message-Id: <20220421183023.3462291-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
In-Reply-To: <20220421183023.3462291-1-bvanassche@acm.org>
References: <20220421183023.3462291-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When querying zones, track the position in logical blocks instead of in
sectors. This change slightly simplifies sd_zbc_report_zones().

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
[ bvanassche: extracted this change from a larger patch ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd_zbc.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 9ef5ad345185..e76bcbfd0d1c 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -224,7 +224,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
-	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
+	sector_t lba = sectors_to_logical(sdkp->device, sector);
 	unsigned int nr, i;
 	unsigned char *buf;
 	size_t offset, buflen = 0;
@@ -235,7 +235,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 		/* Not a zoned device */
 		return -EOPNOTSUPP;
 
-	if (!capacity)
+	if (!sdkp->capacity)
 		/* Device gone or invalid */
 		return -ENODEV;
 
@@ -243,9 +243,8 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 	if (!buf)
 		return -ENOMEM;
 
-	while (zone_idx < nr_zones && sector < capacity) {
-		ret = sd_zbc_do_report_zones(sdkp, buf, buflen,
-				sectors_to_logical(sdkp->device, sector), true);
+	while (zone_idx < nr_zones && lba < sdkp->capacity) {
+		ret = sd_zbc_do_report_zones(sdkp, buf, buflen, lba, true);
 		if (ret)
 			goto out;
 
@@ -263,7 +262,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 			zone_idx++;
 		}
 
-		sector += sd_zbc_zone_sectors(sdkp) * i;
+		lba += sdkp->zone_blocks * i;
 	}
 
 	ret = zone_idx;
