Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D716EC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 02:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiKIC7s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:59:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKIC7r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 21:59:47 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6330183BA
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 18:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667962785; x=1699498785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j8c+bO4eueYzHHu19Rt1BDu+PJCsJDKTZtARN12tb1E=;
  b=Y6dBiOviPK2sp97IsRXw4orR5y2snwSWuF5PLcJKewWAnBwjhcbzpYJr
   xQpFizZhDeBwqhcJfkrKh9psuz0MsOL/30nVzyfkOnWOr5xANOO1sVBXC
   UN6QEGbJDbf+3G49n0D4mTHUSucE/TgSxXwAryMTWRE2NP06DmY0oI2Qj
   WWUiXyKnlFG+ME/ZedNEjfHw7y+mpf0MHy1K00xjyFQxNY4vvYyCwaM6e
   SQ27sKVwxbkfw3Jycs+LJWvSXPIhip5KpV2VxY8qE3uhriIJv8UK1kUiw
   taCQ3Badx525XXYfwmLTp0yybR6kp9viAwSe5GslleskM0PzOlICja6R2
   g==;
X-IronPort-AV: E=Sophos;i="5.96,149,1665417600"; 
   d="scan'208";a="220979690"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2022 10:59:44 +0800
IronPort-SDR: fUq09P8P3Cfa9g/putA+JsngTIYIS6XELbFbs2/uRWKQP6IxnlpyocJMZGHC9jnKYfSdP4fThT
 6g/MJcd3X2hK9z9Wwi6ZB53BZArw5LyeQlU5LDip2pzqOB9ZuFO9Aa36vqWEEtsN/oUqD52De4
 6sdNsCJDg3LXnvT43jSOGH+yFfwH8iTQcxniuc02XGO1YEOUeEsqH9e4UbuoEqlw6FO7KIsHAT
 abPlUeKjnMAI+9fwQvz3+8ODlCf5X6BKj1tXXQ7vIpmtEvNsGimfXm/FigZ4poIXkB9a/jM3VH
 F4M=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 18:18:49 -0800
IronPort-SDR: Ug4nUsDk9NbefF7XfRg/VNknLqK2qEI1rF3n20y5z9VtB1TTaMCe7xykuyNk/YHdCkN11sQa0a
 NOUoPCRrcshA3OOjWUUjTtfGmR/sCfJkPAtDqGEgIbZDA0HNv3zIVIow1SIDVAI+LQ6BQAnyEe
 HBNQJmioiwDayDl0Ey00qDZsJp1KFUzDvzkuU63RADuIZml6H7djr5zlvuPNUTgMl/OeSvz6XX
 UD1N1z3VvQJKdc+4XjPUVkWzMExbmE8qT42TpHFnxWzJYMWEKwIBRmW4Us2w9M2XyKDs05NvEY
 618=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 18:59:44 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] scsi: sd_zbc: do not enforce READ/WRITE (16) on host-aware devices
Date:   Wed,  9 Nov 2022 11:59:40 +0900
Message-Id: <20221109025941.1594612-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221109025941.1594612-1-shinichiro.kawasaki@wdc.com>
References: <20221109025941.1594612-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ZBC Zoned Block Commands specification mandates READ (16) and WRITE (16)
commands only for host-managed zoned block devices. It does not mandate
the commands for host-aware zoned block devices. However, current
sd_zbc_read_zones() code assumes the commands were mandated for host-
aware devices also and enforces the commands. If the host-aware drives
do not support the commands, they may fail.

To conform to the ZBC specification and to avoid the failure, check
device type and modify use_16_for_rw and use_10_for_rw flags only for
host-managed zoned block devices, so that the READ (16) and WRITE (16)
commands are not enforced on host-aware zoned block devices.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/sd_zbc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index bd15624c6322..4717a55dbf35 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -921,9 +921,11 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 		return 0;
 	}
 
-	/* READ16/WRITE16 is mandatory for ZBC disks */
-	sdkp->device->use_16_for_rw = 1;
-	sdkp->device->use_10_for_rw = 0;
+	/* READ16/WRITE16 is mandatory for host-managed devices */
+	if (sdkp->device->type == TYPE_ZBC) {
+		sdkp->device->use_16_for_rw = 1;
+		sdkp->device->use_10_for_rw = 0;
+	}
 
 	if (!blk_queue_is_zoned(q)) {
 		/*
-- 
2.37.1

