Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B0FC43217
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 02:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiKIC7u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiKIC7s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 21:59:48 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C301A224
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 18:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667962787; x=1699498787;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KZ5Bp4L/1uG4qac+pAbZLDgLd7MTZ4c6uQu244VB0Ts=;
  b=I/8un7XGk33l0sAM3ayzmkSzsLNh9v9aLHcxMLAmVpmb9rOS8bx7WiDd
   6ZrUZS8CcNsG/2OdtVDgeExJZ8VkIuly56d8KLzQMx7jhnjFjrpzCyIR0
   7dxrwfNvnsGSjwF30W/JrGL5DBQVQxj5yk8EosbeAu10puBv8n2Xx0TNK
   Rxl6tHOorxzZ5MNWPZzuOYjItHY4+tZzcM6m+5e9unaqmIwY7ecawe5Ao
   jIjpckAhLj3QU6/3ekQcsIXx5tVg3kE+WkggLsGHjA2Cr2BotbcMiSXKG
   KUD7NzxSq3ApWPHzLArRP55Bv4k6vxP3FxTKUk0WZY65tK36uFbD3CV/2
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,149,1665417600"; 
   d="scan'208";a="220979691"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2022 10:59:45 +0800
IronPort-SDR: zpitj1mE/n1unbcNlOkFcIFMCd1NPGQcu8U4d5VWA9pc1SlyEpN4u4gr4S4TSRmxgeR87FVHT+
 2+HoXVVVUdf4G/gfkuU4s8AUn4RyRma0I6qFLb7P1qanOi/TrtNRP/eIzmBP/l5fynLGcMmIqw
 jvI40lOV5EIsL0OOxCAIsvYarCcpRNtX6VP501UTOOHngAB2YoSVJrkLV+vUMyIJQCAGMSjvIN
 pbjxZ3XjSJQyDihPSVjuBgajqxNzaaMOClEXDUWpOM/d5i+GuhrFu1PypzT8ASXFmFnVpEtZuw
 OxA=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 18:18:50 -0800
IronPort-SDR: Yp8Brlp1DGvDEwB8KE9egI0Un7elqrU+uGD6+GSAiJXO/qaP4NpmL48PyAFN5p7H+7YCHXxENn
 l1C4QN9eDkggJ0NuNDxCDzvlEL5iEzvGNbr+Z+dQskjWdfYDJLloKFNPqjfYGEC18RHNrkSfxY
 b26IbBFvSxRV8FwmPALkvNz/juB3z/ML5gUHUcQViP7VbRQ9zMAAs/ZtubulolZQJP7/4BE8eg
 ZRsx02VfkOTz8Dn8J2PhCEWK3RI4C1690JhRsLijZl3U5FBqDERSQGvj8NB1jG0ELdJkDprWVJ
 ubo=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 18:59:45 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/2] scsi: sd: enforce SYNCHRONIZE CACHE (16) on host-managed devices
Date:   Wed,  9 Nov 2022 11:59:41 +0900
Message-Id: <20221109025941.1594612-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221109025941.1594612-1-shinichiro.kawasaki@wdc.com>
References: <20221109025941.1594612-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ZBC Zoned Block Commands specification mandates SYNCHRONIZE CACHE (16)
for host-managed zoned block devices, but does not mandate SYNCHRONIZE
CACHE (10). Call SYNCHRONIZE CACHE (16) in place of SYNCHRONIZE CACHE
(10) to ensure that the command is always supported. For this purpose,
add use_16_for_sync flag to struct scsi_device in same manner as
use_16_for_rw flag.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/sd.c          | 16 ++++++++++++----
 drivers/scsi/sd_zbc.c      |  3 ++-
 include/scsi/scsi_device.h |  1 +
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index eb76ba055021..faa2b55d1a21 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1026,8 +1026,13 @@ static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 	/* flush requests don't perform I/O, zero the S/G table */
 	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 
-	cmd->cmnd[0] = SYNCHRONIZE_CACHE;
-	cmd->cmd_len = 10;
+	if (cmd->device->use_16_for_sync) {
+		cmd->cmnd[0] = SYNCHRONIZE_CACHE_16;
+		cmd->cmd_len = 16;
+	} else {
+		cmd->cmnd[0] = SYNCHRONIZE_CACHE;
+		cmd->cmd_len = 10;
+	}
 	cmd->transfersize = 0;
 	cmd->allowed = sdkp->max_retries;
 
@@ -1587,9 +1592,12 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		sshdr = &my_sshdr;
 
 	for (retries = 3; retries > 0; --retries) {
-		unsigned char cmd[10] = { 0 };
+		unsigned char cmd[16] = { 0 };
 
-		cmd[0] = SYNCHRONIZE_CACHE;
+		if (sdp->use_16_for_sync)
+			cmd[0] = SYNCHRONIZE_CACHE_16;
+		else
+			cmd[0] = SYNCHRONIZE_CACHE;
 		/*
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 4717a55dbf35..a998f9c091dd 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -921,10 +921,11 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 		return 0;
 	}
 
-	/* READ16/WRITE16 is mandatory for host-managed devices */
+	/* READ16/WRITE16/SYNC16 is mandatory for host-managed devices */
 	if (sdkp->device->type == TYPE_ZBC) {
 		sdkp->device->use_16_for_rw = 1;
 		sdkp->device->use_10_for_rw = 0;
+		sdkp->device->use_16_for_sync = 1;
 	}
 
 	if (!blk_queue_is_zoned(q)) {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c36656d8ac6c..afd2986007a4 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -184,6 +184,7 @@ struct scsi_device {
 	unsigned no_report_opcodes:1;	/* no REPORT SUPPORTED OPERATION CODES */
 	unsigned no_write_same:1;	/* no WRITE SAME command */
 	unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(10) */
+	unsigned use_16_for_sync:1;	/* Use sync (16) over sync (10) */
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned skip_vpd_pages:1;	/* do not read VPD pages */
-- 
2.37.1

