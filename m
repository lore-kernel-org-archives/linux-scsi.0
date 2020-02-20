Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E32C11D1B
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 20:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C49BC20722
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 20:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgBTUJF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Feb 2020 15:09:05 -0500
Received: from smtp.infotech.no ([82.134.31.41]:47297 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729080AbgBTUJE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Feb 2020 15:09:04 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 74E0120424C;
        Thu, 20 Feb 2020 21:09:02 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fWioYbaQsVIB; Thu, 20 Feb 2020 21:09:00 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id C44CA2041BD;
        Thu, 20 Feb 2020 21:08:58 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        Damien.LeMoal@wdc.com, Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v3 13/15] scsi_debug: zone_nr_conv module parameter
Date:   Thu, 20 Feb 2020 15:08:36 -0500
Message-Id: <20200220200838.15809-14-dgilbert@interlog.com>
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

Allow controlling the number of conventional zones of a zbc device with
the new zone_nr_conv module parameter. The default value is 1 and the
specified value must be less than the total number of zones of the
device. This parameter is ignored for device types other than 0x14
(zbc=2 case).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d4022eafe834..a88f182af5c5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -155,6 +155,7 @@ static const char *sdebug_version_date = "20190125";
 /* Default parameters for ZBC drives */
 #define DEF_ZBC_ZONE_SIZE_MB	128
 #define DEF_ZBC_MAX_OPEN_ZONES	8
+#define DEF_ZBC_NR_CONV_ZONES	1
 
 #define SDEBUG_LUN_0_VAL 0
 
@@ -292,6 +293,7 @@ struct sdebug_dev_info {
 	sector_t zsize;
 	sector_t zsize_shift;
 	unsigned int nr_zones;
+	unsigned int nr_conv_zones;
 	unsigned int nr_imp_open;
 	unsigned int nr_exp_open;
 	unsigned int nr_closed;
@@ -800,6 +802,7 @@ static int dif_errors;
 static bool sdeb_zbc_in_use;		/* true when ptype=TYPE_ZBC [0x14] */
 static const int zbc_zone_size_mb;
 static int sdeb_zbc_max_open = DEF_ZBC_MAX_OPEN_ZONES;
+static int sdeb_zbc_nr_conv = DEF_ZBC_NR_CONV_ZONES;
 
 static int submit_queues = DEF_SUBMIT_QUEUES;  /* > 1 for multi-queue (mq) */
 static struct sdebug_queue *sdebug_q_arr;  /* ptr to array of submit queues */
@@ -4699,6 +4702,13 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 	devip->zsize_shift = ilog2(devip->zsize);
 	devip->nr_zones = (capacity + devip->zsize - 1) >> devip->zsize_shift;
 
+	if (sdeb_zbc_nr_conv >= devip->nr_zones) {
+		pr_err("Number of conventional zones too large\n");
+		return -EINVAL;
+	}
+
+	devip->nr_conv_zones = sdeb_zbc_nr_conv;
+
 	/* sdeb_zbc_max_open can be 0, meaning "no limit" */
 	if (sdeb_zbc_max_open >= devip->nr_zones - 1)
 		devip->max_open = (devip->nr_zones - 1) / 2;
@@ -4715,7 +4725,7 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 
 		zsp->z_start = zstart;
 
-		if (i == 0) {
+		if (i < devip->nr_conv_zones) {
 			zsp->z_cond = zbc_not_write_pointer;
 			zsp->z_wp = (sector_t)-1;
 		} else {
@@ -5453,6 +5463,7 @@ module_param_named(write_same_length, sdebug_write_same_length, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(zbc, sdeb_zbc_model_s, charp, S_IRUGO | S_IWUSR);
 module_param_named(zone_max_open, sdeb_zbc_max_open, int, S_IRUGO);
+module_param_named(zone_nr_conv, sdeb_zbc_nr_conv, int, S_IRUGO);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -5516,6 +5527,7 @@ MODULE_PARM_DESC(wp, "Write Protect (def=0)");
 MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xffff)");
 MODULE_PARM_DESC(zbc, "'none' [0]; 'aware' [1]; 'managed' [2] (def=0). Can have 'host_' prefix");
 MODULE_PARM_DESC(zone_max_open, "Maximum number of open zones; [0] for no limit (def=auto)");
+MODULE_PARM_DESC(zone_nr_conv, "Number of conventional zones (def=1)");
 
 #define SDEBUG_INFO_LEN 256
 static char sdebug_info[SDEBUG_INFO_LEN];
-- 
2.25.0

