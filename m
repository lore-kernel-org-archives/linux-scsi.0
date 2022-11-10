Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CD5C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 03:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbiKJDvL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 22:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbiKJDu4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 22:50:56 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39EA3122E
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 19:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668052247; x=1699588247;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Y9J2qK6obDPDGX+Pb4FpsZoX8K1nRGPUZEHjoWG8FVQ=;
  b=N1h+GJbYGKdCLtXEOtyyHj/vIuMVhH5K0P/xkXxVxeW9Q57c+wdgiOtn
   1nG0qidiAVTMHSd55FGXqnIA7TeZMWBrm17xeUjhhOF262/D90RaZZE/0
   +S5SxBNqGKJKs99PffbZ9dxYYNou9Pvjm23swOpMZofc7hbSvdUrXrQoq
   mdWkVwqMb5Ok6oxSgVdyLIGWzC/bLaxhY9Z+UaLcCU86u/GcXE1uJKq13
   UYs1XcTSOGohSjj0yHnmfSAwQD4FWlZ/5K1oGmJcjbtrbWAlBswj4yyCT
   FgmG6NU8+oFT1Fv5NEp1vz0tnIFC2XQpRkiWILM8HWkaV5qeqtCaTv+1/
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,152,1665417600"; 
   d="scan'208";a="214197389"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2022 11:50:47 +0800
IronPort-SDR: Y5MX8JiPhXtFYXWwQ8fLjFiEAOcragz5PDW1wlx0YMWP9mEVeSto2W51W5fVZG4BZDbsCFXkKA
 Ivi50re+YJL2nZMfI/sxMepihqLjcZOWNa46GqQJE8RDY9lTZqLd8lewoepOqEx2uXn+CBKx/w
 cj4PaT05SKq+WK1bzOTFRm3aQ/RaMi7xxa1E9oUtlAhJ/uY7bkbp8nn0ifIaa6nfGBAkCHkG46
 COkW1C7CNwFgQ5bZ89wNFidfphIU4H0mSlKR7qvJPzA+EmqUVVtNwW1cZb+5Pw8Rm79aRrqwFH
 Xqo=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Nov 2022 19:09:50 -0800
IronPort-SDR: EbvhCnoLhYgU0iIDVbW+dHbDwKnkzfWR4M3t9fL30kH5UHNr20rjJe7QDsL1Ij/p3YjYy8yw8Z
 aBMim9l7cBa5N86q2DrxSiw2q3CpKmN+oQqTwNOAAdNsI4r84e8v1eMotTPXeQZrRNcy02nymV
 VuFIlW6cdOAZOW6lu3Grk/1DAOKt5sPIjcxirSngI2boCVXfB14ngWUp8tCvPU5AGyNvBCOcQk
 B4cg+d/Kw5hvGStBPB82yoZb2YrskhEqYyDOwBHIPm+vie+JW6640BUHo42Kwag8EY6WWbnS2q
 F84=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Nov 2022 19:50:47 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2] scsi: sd: enforce SYNCHRONIZE CACHE (16) on ZBC devices
Date:   Thu, 10 Nov 2022 12:50:45 +0900
Message-Id: <20221110035045.1633965-1-shinichiro.kawasaki@wdc.com>
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

To be precise, ZBC does not mandate READ(16), WRITE (16) and SYNCHRONIZE
CACHE (16) commands for host-aware zoned block devices. However, modern
devices should support the 16 byte commands. Hence, enforce the 16 byte
commands on both types of ZBC devices, host-aware and host-managed.

Of note is that this patch depends on the libata-scsi fix [1], and
should be merged to upstream after it.

[1] https://lore.kernel.org/linux-ide/20221107040229.1548793-1-shinichiro.kawasaki@wdc.com/

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
Changes from v1:
* Dropped the first patch to relax check on host-aware devices
* Enforce SYNC 16 command on both host-aware and host-managed devices

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

