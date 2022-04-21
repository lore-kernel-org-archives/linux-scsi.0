Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5EFC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 18:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391396AbiDUSdt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 14:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391369AbiDUSdk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 14:33:40 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D6D4BB80
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:49 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id i24so5759925pfa.7
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pX8d48ZPCsQGTJ4Rx6/9uqNJV4YJFux4MxoOiukWboc=;
        b=AjOxDJx+InmMlpxiGEyUM+k64T/gYFyYp4e5sPhujajv2zeXKXmTbdxNJ0HSzdjh92
         FTfa03ZuoNUv98PCXVJaeAvHHhq35yWzkqiD9THGyk8V3qMrlu0Bg1LPf9idm0IGCULL
         WGnxYcpEdYz253aHLPmdO7gdlrVLdv29k42IDABqkh5goephs6ROULpdGjvLrXu+ZiBO
         rAYqp8klmjNhjdUJ/0s8e+snfhH892/AuQXBLamdVKVgkpmGy0H6STRh850Mw3C1U2Ki
         Q6VjTSLjwtU14TJfn+2Maw1rmAMaTFs2puBhILk04Q5vfvpI/lkvzogOJeD4QO8rlbVW
         LDwg==
X-Gm-Message-State: AOAM531UUBhqVabjvjdws8zijiIzSMIGSoWtcVZIiQWolcs9jA1gI+CU
        W3quMsL2B4G0YV8UEmRneUE=
X-Google-Smtp-Source: ABdhPJwxpTUR1WYu7hoQ6e3MuuV9PrUWbge47/XIWyOx1jBJyl7+la4UDeVfipBQ1BJfq6QiD+hgcw==
X-Received: by 2002:a63:cc53:0:b0:372:7d69:49fb with SMTP id q19-20020a63cc53000000b003727d6949fbmr633963pgi.21.1650565849153;
        Thu, 21 Apr 2022 11:30:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a034:31d8:ca4e:1f35])
        by smtp.gmail.com with ESMTPSA id a22-20020a62d416000000b0050bd98eaccbsm2181079pfh.213.2022.04.21.11.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 11:30:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 8/9] scsi_debug: Rename zone type constants
Date:   Thu, 21 Apr 2022 11:30:22 -0700
Message-Id: <20220421183023.3462291-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
In-Reply-To: <20220421183023.3462291-1-bvanassche@acm.org>
References: <20220421183023.3462291-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rename the scsi_debug zone type constants to prevent a conflict with the
ZBC_ZONE_TYPE_GAP constant from include/scsi/scsi_proto.h.

Cc: Douglas Gilbert <dgilbert@interlog.com>
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
