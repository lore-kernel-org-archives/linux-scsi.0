Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58785C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Apr 2022 20:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351741AbiDOUU4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Apr 2022 16:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351723AbiDOUUm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2022 16:20:42 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876C5DE911
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 13:18:13 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id 125so8423939pgc.11
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 13:18:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jE0kEJ+SIJpgTiVZRYiHIah2tqWx/U91UhZxn8X0mKs=;
        b=nBwCzCdIoEN73wrUOSuoifhX5yqW/yKsmhlztwNNx+P7IjZ9b5bk0cmTtw1B5IqxhQ
         3s29rcAj9rHKfosk9M3g4lSvEy3+F6bYpZys4HQCWtFF1HQzvl88r49W5oQLUTv8NDJZ
         jH4oNIXwDqx6er4V+bi777fCAhEk+j0eIS+Lf84M8UO7+UC3RavPgG+Lp9jhIzYZrSsc
         Tc8QWv2mMFYVJpNfuB9yuJ4CyuIbl4rmxcMqvatPN3CRypxt7MQgfQzaeN9UoxoHMzx/
         EqfszoIULexgoU3NV4iJuoijQgIBw0Esxbv/lTwPeL/7aWFbkqJLAPQKRzrzfMWcWJmC
         uW7Q==
X-Gm-Message-State: AOAM531ZLKBcoJSeL7VE9/BdJOy6W9gusAH3vIpdqRd8qKHXt3ykImVn
        IHh7+fnUxG94kw1gEwEpXLIvFv8fvA0ipg==
X-Google-Smtp-Source: ABdhPJwZ/n2YPWjZpwNT11fjXX8e1q5wVV5LuBJzhpq0a+E4XBgJ8BGUWyP/sS6N7a5SwfOJAsMAgg==
X-Received: by 2002:a65:6a4c:0:b0:39c:f169:b54a with SMTP id o12-20020a656a4c000000b0039cf169b54amr548112pgu.384.1650053893010;
        Fri, 15 Apr 2022 13:18:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a014:c21c:c3f8:d62])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00088900b004fe1a045e97sm3641141pfj.118.2022.04.15.13.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 13:18:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 7/8] scsi_debug: Rename zone type constants
Date:   Fri, 15 Apr 2022 13:17:51 -0700
Message-Id: <20220415201752.2793700-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220415201752.2793700-1-bvanassche@acm.org>
References: <20220415201752.2793700-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename the scsi_debug zone type constants to prevent a conflict with the
ZBC_ZONE_TYPE_GAP constant from include/scsi/scsi_proto.h.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
[ bvanassche: Extracted these changes from a larger patch ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 7cfae8206a4b..47cec83a4b7c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -252,9 +252,9 @@ static const char *sdebug_version_date = "20210520";
 
 /* Zone types (zbcr05 table 25) */
 enum sdebug_z_type {
-	ZBC_ZONE_TYPE_CNV	= 0x1,
-	ZBC_ZONE_TYPE_SWR	= 0x2,
-	ZBC_ZONE_TYPE_SWP	= 0x3,
+	ZBC_ZTYPE_CNV	= 0x1,
+	ZBC_ZTYPE_SWR	= 0x2,
+	ZBC_ZTYPE_SWP	= 0x3,
 };
 
 /* enumeration names taken from table 26, zbcr05 */
@@ -2720,7 +2720,7 @@ static struct sdeb_zone_state *zbc_zone(struct sdebug_dev_info *devip,
 
 static inline bool zbc_zone_is_conv(struct sdeb_zone_state *zsp)
 {
-	return zsp->z_type == ZBC_ZONE_TYPE_CNV;
+	return zsp->z_type == ZBC_ZTYPE_CNV;
 }
 
 static void zbc_close_zone(struct sdebug_dev_info *devip,
@@ -2801,7 +2801,7 @@ static void zbc_inc_wp(struct sdebug_dev_info *devip,
 	if (zbc_zone_is_conv(zsp))
 		return;
 
-	if (zsp->z_type == ZBC_ZONE_TYPE_SWR) {
+	if (zsp->z_type == ZBC_ZTYPE_SWR) {
 		zsp->z_wp += num;
 		if (zsp->z_wp >= zend)
 			zsp->z_cond = ZC5_FULL;
@@ -2868,7 +2868,7 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
 		return 0;
 	}
 
-	if (zsp->z_type == ZBC_ZONE_TYPE_SWR) {
+	if (zsp->z_type == ZBC_ZTYPE_SWR) {
 		/* Writes cannot cross sequential zone boundaries */
 		if (zsp_end != zsp) {
 			mk_sense_buffer(scp, ILLEGAL_REQUEST,
@@ -5005,14 +5005,14 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 		zsp->z_start = zstart;
 
 		if (i < devip->nr_conv_zones) {
-			zsp->z_type = ZBC_ZONE_TYPE_CNV;
+			zsp->z_type = ZBC_ZTYPE_CNV;
 			zsp->z_cond = ZBC_NOT_WRITE_POINTER;
 			zsp->z_wp = (sector_t)-1;
 		} else {
 			if (devip->zmodel == BLK_ZONED_HM)
-				zsp->z_type = ZBC_ZONE_TYPE_SWR;
+				zsp->z_type = ZBC_ZTYPE_SWR;
 			else
-				zsp->z_type = ZBC_ZONE_TYPE_SWP;
+				zsp->z_type = ZBC_ZTYPE_SWP;
 			zsp->z_cond = ZC1_EMPTY;
 			zsp->z_wp = zsp->z_start;
 		}
