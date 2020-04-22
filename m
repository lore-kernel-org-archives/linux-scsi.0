Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B0F3C5518A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 665112073A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 10:43:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IHU5AtcB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731737AbgDVKnA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 06:43:00 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22891 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731749AbgDVKm0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 06:42:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587552147; x=1619088147;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a3cnJUKTxpELMeGC+aZBWL8ZE+rDocPhvLtQoCOLIcY=;
  b=IHU5AtcBAUhMPN0TKD4mFwSk6m7eWBSvVVvbQ2jQaCXniv87KNbCBkeh
   Q/LHqhpCZeratf1jcFgbXujUGDM5AFxpb44kmZss/1t4yNRsA7GDD/UL7
   IFXSiOTb0g18GP20xzq4g6UpbkWY3OjpxoJfpKT0mTLA4l0gw2vRgJQup
   HdrsjAsgjZCn2FrwukN8h4nXrvog5K1Mma4mStKDRWq5SWC1pW++g4CHa
   w+TrxS0DMUvdMICgkwYrBu9+CWpbdyHPwOjwwdWxcKSNbQ4oROCKFaX8j
   n+X2X+tPbzMiCrXiniQffbgLveDNgbVCOTijQ3EPMG5q/AcLKFfZujL0s
   w==;
IronPort-SDR: 0/zLck5MU0a8+JAYKJ8vriayiryV/7k4wQm6YvQvISI/BwZkD/SHHBtdp66b3kbDt4fW+B5spc
 VxJ0B2mmdxTTcXay1PDONQt4ZVOjyYHo+4KP1KeefT4+NeuLBUmNXz2kFtvJJKXdL4SU2jjjSv
 jZtJUCPTVwsJYv60jFzy75n8z2/KavvMFKOCe+5srq4QqNbyTvQDU4zdehEFtHNNFQcr5pzPSS
 rQ41UopOqJPqXVEnE3jewaVR2qfN4jaeZWFuyL5Qy+NxdmbL1aK1Xh2fB/ZoX/+Ie61qSW8tHt
 4DU=
X-IronPort-AV: E=Sophos;i="5.72,414,1580745600"; 
   d="scan'208";a="140230024"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Apr 2020 18:42:26 +0800
IronPort-SDR: Ryv7U3yVa57VQcqIyVEP0F0p0CVbCvbg1pTtrtrOyj75bhxXCyWa7HI9NRYh4CcwlAV2w+5D1I
 oiriTZI8O7j1lqHbcV5C60AHT0ezR1ieI=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 03:33:16 -0700
IronPort-SDR: Ldd9Cm0rfu7vvQJcndFeGnDYS60KTTOGpo9o0XODOIEG3PdjLLQHiXBrzvgeTUgx0dOpyQTtI0
 JEhO5LfTmGRw==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Apr 2020 03:42:25 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 4/7] scsi_debug: add zone_max_open module parameter
Date:   Wed, 22 Apr 2020 19:42:18 +0900
Message-Id: <20200422104221.378203-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200422104221.378203-1-damien.lemoal@wdc.com>
References: <20200422104221.378203-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add the zone_max_open module parameters to control the maximum number
of open zones of a ZBC device. This parameter is ignored for device
types other than 0x14 (zbc=2 case).

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_debug.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6ef01b97e1ae..36aeda10a117 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -822,7 +822,7 @@ static int dif_errors;
 /* ZBC global data */
 static bool sdeb_zbc_in_use;		/* true when ptype=TYPE_ZBC [0x14] */
 static const int zbc_zone_size_mb;
-static const int zbc_max_open_zones = DEF_ZBC_MAX_OPEN_ZONES;
+static int sdeb_zbc_max_open = DEF_ZBC_MAX_OPEN_ZONES;
 
 static int submit_queues = DEF_SUBMIT_QUEUES;  /* > 1 for multi-queue (mq) */
 static struct sdebug_queue *sdebug_q_arr;  /* ptr to array of submit queues */
@@ -4788,10 +4788,10 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 	devip->nr_zones = (capacity + devip->zsize - 1) >> devip->zsize_shift;
 
 	/* zbc_max_open_zones can be 0, meaning "not reported" (no limit) */
-	if (zbc_max_open_zones >= devip->nr_zones - 1)
+	if (sdeb_zbc_max_open >= devip->nr_zones - 1)
 		devip->max_open = (devip->nr_zones - 1) / 2;
 	else
-		devip->max_open = zbc_max_open_zones;
+		devip->max_open = sdeb_zbc_max_open;
 
 	devip->zstate = kcalloc(devip->nr_zones,
 				sizeof(struct sdeb_zone_state), GFP_KERNEL);
@@ -5540,6 +5540,7 @@ module_param_named(wp, sdebug_wp, bool, S_IRUGO | S_IWUSR);
 module_param_named(write_same_length, sdebug_write_same_length, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(zbc, sdeb_zbc_model_s, charp, S_IRUGO);
+module_param_named(zone_max_open, sdeb_zbc_max_open, int, S_IRUGO);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -5602,6 +5603,7 @@ MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique de
 MODULE_PARM_DESC(wp, "Write Protect (def=0)");
 MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xffff)");
 MODULE_PARM_DESC(zbc, "'none' [0]; 'aware' [1]; 'managed' [2] (def=0). Can have 'host-' prefix");
+MODULE_PARM_DESC(zone_max_open, "Maximum number of open zones; [0] for no limit (def=auto)");
 
 #define SDEBUG_INFO_LEN 256
 static char sdebug_info[SDEBUG_INFO_LEN];
-- 
2.25.3

