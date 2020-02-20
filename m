Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B02C11D24
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 20:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5B22208CD
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 20:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgBTUJG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Feb 2020 15:09:06 -0500
Received: from smtp.infotech.no ([82.134.31.41]:47305 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729049AbgBTUJG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Feb 2020 15:09:06 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id A7AA42041BD;
        Thu, 20 Feb 2020 21:09:03 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uckynJB4atPN; Thu, 20 Feb 2020 21:09:02 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 30624204255;
        Thu, 20 Feb 2020 21:09:00 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com, Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v3 14/15] scsi_debug: zone_size_mb module parameter
Date:   Thu, 20 Feb 2020 15:08:37 -0500
Message-Id: <20200220200838.15809-15-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220200838.15809-1-dgilbert@interlog.com>
References: <20200220200838.15809-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

Add the zone_size_mb module parameters to control the zone size of a
ZBC device. If the zone size specified is not a divisor of the device
capacity, the last zone of the device will be created as a smaller
"runt" zone. This parameter is ignored for device types other than
0x14 (zbc=2 case).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a88f182af5c5..b02f98a00d28 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -800,7 +800,7 @@ static int dif_errors;
 
 /* ZBC global data */
 static bool sdeb_zbc_in_use;		/* true when ptype=TYPE_ZBC [0x14] */
-static const int zbc_zone_size_mb;
+static int sdeb_zbc_zone_size_mb;
 static int sdeb_zbc_max_open = DEF_ZBC_MAX_OPEN_ZONES;
 static int sdeb_zbc_nr_conv = DEF_ZBC_NR_CONV_ZONES;
 
@@ -4678,10 +4678,10 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 	unsigned int i;
 
 	/*
-	 * Set zone size: if zbc_zone_size_mb was not set, figure out a zone
-	 * size allowing for at least 4 zones on the device.
+	 * Set zone size: if sdeb_zbc_zone_size_mb was not set, figure out
+	 * a zone size allowing for at least 4 zones on the device.
 	 */
-	if (!zbc_zone_size_mb) {
+	if (!sdeb_zbc_zone_size_mb) {
 		devip->zsize = (DEF_ZBC_ZONE_SIZE_MB * SZ_1M)
 			>> ilog2(sdebug_sector_size);
 		while (capacity < devip->zsize * 4 && devip->zsize >= 2)
@@ -4691,7 +4691,7 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 			return -EINVAL;
 		}
 	} else {
-		devip->zsize = (zbc_zone_size_mb * SZ_1M)
+		devip->zsize = (sdeb_zbc_zone_size_mb * SZ_1M)
 			>> ilog2(sdebug_sector_size);
 		if (devip->zsize >= capacity) {
 			pr_err("Zone size too large for device capacity\n");
@@ -5464,6 +5464,7 @@ module_param_named(write_same_length, sdebug_write_same_length, int,
 module_param_named(zbc, sdeb_zbc_model_s, charp, S_IRUGO | S_IWUSR);
 module_param_named(zone_max_open, sdeb_zbc_max_open, int, S_IRUGO);
 module_param_named(zone_nr_conv, sdeb_zbc_nr_conv, int, S_IRUGO);
+module_param_named(zone_size_mb, sdeb_zbc_zone_size_mb, int, S_IRUGO);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -5528,6 +5529,7 @@ MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xff
 MODULE_PARM_DESC(zbc, "'none' [0]; 'aware' [1]; 'managed' [2] (def=0). Can have 'host_' prefix");
 MODULE_PARM_DESC(zone_max_open, "Maximum number of open zones; [0] for no limit (def=auto)");
 MODULE_PARM_DESC(zone_nr_conv, "Number of conventional zones (def=1)");
+MODULE_PARM_DESC(zone_size_mb, "Zone size in MiB (def=auto)");
 
 #define SDEBUG_INFO_LEN 256
 static char sdebug_info[SDEBUG_INFO_LEN];
-- 
2.25.0

