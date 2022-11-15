Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D055AC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 00:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237426AbiKOA3K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Nov 2022 19:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237411AbiKOA3I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Nov 2022 19:29:08 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC8A1758B
        for <linux-scsi@vger.kernel.org>; Mon, 14 Nov 2022 16:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668472147; x=1700008147;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1sMvjUJPVd6hL6XHmcIiskN2ktQubWTH0YRFH5UAyrk=;
  b=flp0elYqmiHny40tpLZ4+hXyXtlD8iwXD4s/5scFUKGBPd03H7ciDZvq
   YmR7PGm3ROiKMJBShC+ioUhN2UJiXdKyKg8iFK76tDlazDwXPKD3gBQQq
   pTzC5eclzmnD+51CzZBwSyEZyKAqmCZP4QZZEDDRKL/rOrL7i/QfR5epf
   iV2CeZb1baQeb1qFrsr7KXM+8CRW7vZJpDS7HaM956KbFrjELNk8gHl0I
   /GMkTnWVVmhbOkNz0MOdB+KAObtcn6grkDBzbaLeHQzsscvmHcTFHS8nl
   5nIBnZwaOSzfCCepD/tk3ysDrwSUgzYE586BfmplgT9n1/yHprzh3H71u
   A==;
X-IronPort-AV: E=Sophos;i="5.96,164,1665417600"; 
   d="scan'208";a="214533599"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Nov 2022 08:29:06 +0800
IronPort-SDR: teAx4T1SxuZPiDvK427UfwdggXul/3xcbvSzDZM9Zf4YF1hulcZpsBhnxam5MHB/aCjJCycDed
 1BJlqwoktsV9FT6CGUK9aJMz2ntgoSF7mAL8963SDfYavyNrU99zGzyy/nCoabg4YT72O2JdeR
 +4aVsTB8sE1CQoxpeC2K2WRrwB5NhBgMbFW+JZcYA4cTJHJ/tqr+MmBV2EdmnMQeUopVGyExwz
 190NRYkcAtaotNcECz/fvz9i+JX0f0vy4A9fUJRHjLasGvhWo/Y0bbk6/35ZPHYHGoO3soH51T
 Nck=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Nov 2022 15:48:04 -0800
IronPort-SDR: 2ODwM0iEIEwf2aChJ9+4JJFpCGkSzp9nwYxS41/KiXLRAMMnp0Ovofe73ZsealEYWc8WTKh6AQ
 Y2HEsu6fqIyKK4RWAQUKUUdlq9kXaPoi7cBdfToNYI3IOxlXF5MDYeQsOos9RFgVmOkhfzWm5V
 /0YSXcrwYO59gh14yOj/bB6x9LE0U/jrlLS74WWlmR+XadEgqGS4q/3LWBXxD57g3hxQ/a9tq5
 2+wheo5UGVDNXOAPy0TO0/53/HAA9E4AGpcKSQ6ZR37k3OwzRFgGAsOy9zFuSG1IrE9zLxjk0G
 sQ8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 14 Nov 2022 16:29:05 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3] scsi: sd: call SYNC 16 in place of SYNC 10 on ZBC devices
Date:   Tue, 15 Nov 2022 09:29:05 +0900
Message-Id: <20221115002905.1709006-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
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

To be precise, ZBC does not mandate SYNCHRONIZE CACHE (16) for host-
aware zoned block devices. However, modern devices should support 16
byte commands. Hence, call SYNCHRONIZE CACHE (16) on both types of ZBC
devices, host-aware and host-managed. Of note is that READ (16) and
WRITE (16) have same story and they are already called for both types of
ZBC devices before this change.

Another note is that this patch depends on the fix commit ea045fd344cb
("ata: libata-scsi: fix SYNCHRONIZE CACHE (16) command failure").

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opendource.wdc.com>
---
Changes from v2:
* Rephrased commit message to reflect discussion on the list
* Modifed reference of dependent change in commit message from URL to git hash
* Added a Reviewed-by tag

Changes from v1:
* Dropped the first patch to relax check on host-aware devices
* Call SYNC 16 command on both host-aware and host-managed devices

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
index bd15624c6322..b163bf936acc 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -921,9 +921,10 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 		return 0;
 	}
 
-	/* READ16/WRITE16 is mandatory for ZBC disks */
+	/* READ16/WRITE16/SYNC16 is mandatory for ZBC devices */
 	sdkp->device->use_16_for_rw = 1;
 	sdkp->device->use_10_for_rw = 0;
+	sdkp->device->use_16_for_sync = 1;
 
 	if (!blk_queue_is_zoned(q)) {
 		/*
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

