Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27CAFC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 14:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F029260F45
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 14:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242874AbhIFOId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 10:08:33 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:61256 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbhIFOIa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 10:08:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630937245; x=1662473245;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xI8SYaQ/ul2G0E/XJS8JDbWb56Nt7GOhsFkjHY5obF4=;
  b=jlBFjvhe77W/g1tVBhTYAF+bpnVY6vsJXMMEo4XoZ+1Wy/+VETWG3ELV
   orhztF6Kme7sBIWeB+90IScrufwUm4ZVYCmW6K+sZFUMgBgGSuYjSMKZX
   BhRNDj4RTcqMSdd1i4gzPU7RlUEARucIxW8+v/2xJxGJ2pcwDn7nLlxcx
   yo/+e6MImMj87oGMZ7b/50W7f5SeRizDP0yPIAIqfZUL/lQQAwi2Evka5
   u9wNg1zPpJ2u/vZu9w1g46NupJXYu1FeJD5p5xEscG9w3xJ0kU2gUm7Up
   o6WHk9e7u4J2p6vb/WNwwKPMx+qAKxAogqO2xExNYV83OYvw7Fz/91Ahe
   w==;
X-IronPort-AV: E=Sophos;i="5.85,272,1624291200"; 
   d="scan'208";a="179299155"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Sep 2021 22:07:25 +0800
IronPort-SDR: aU8EhDE3VXY9li+5pa+GtyXPD4jzxuJcNsQssjO90J4Nbho11Zq5hJbfOk2xwDdU+gqDO6T0Wz
 vzA3iLLQHQgtVWrBgin+TpfxNyTiRQ4lE/YjsxcCpB2M6MfUEHrc8+1w+r6gpCaoWVct6wi6GF
 ZiGru1p9JRpWcnkKod03+LjfUgmxet8jFFkNLCYBT4pk/sQE3I0fWI1yRKtcH5Y7MNLSUZsIXP
 XN8N4KPcDTLS5AKCJolUJMxloqYpd8Wkl63sKILvuSqm2mVBRslGhcTiF4mJDDbcsHNeLvedtC
 siJhGHSUJ5lSG2HS4RtaY+uZ
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2021 06:44:05 -0700
IronPort-SDR: KuN48U7CJAOficMvuCGTSLp7BuPOHHoN205VI/rbVrr7DnxzRTxL/J95IUSSNMd+zSXD7SU4vv
 J6kGHDDDgUez3i8CX7xQoT+QzaP6rQTbUxBHxslfXoT3w/MkWlMADORKZQkL+OPtKEUnmWZRp6
 /H6qbwjWVPErYr2/TWo9TK/V/C4qYHZG+bgCxyDHPqknt3HOEQZ4eMm/Z3S+btKIxYiW+wC5XY
 UKNxtd30WKKX7FcD4tJ3B+xhsx3kNycKCd+jQmC2QlEocFw2cQr9Ve7L33boBAaXTWmz5pAzrd
 a80=
WDCIronportException: Internal
Received: from 8x4k3x2.ad.shared (HELO naota-xeon.wdc.com) ([10.225.51.17])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Sep 2021 07:07:25 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-scsi@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH] scsi: sd_zbc: ensure buffer size is aligned to SECTOR_SIZE
Date:   Mon,  6 Sep 2021 23:06:42 +0900
Message-Id: <20210906140642.2267569-1-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reporting zones on a SCSI device sometimes fail with the following error.

[76248.516390] ata16.00: invalid transfer count 131328
[76248.523618] sd 15:0:0:0: [sda] REPORT ZONES start lba 536870912 failed

The error (from drivers/ata/libata-scsi.c ata_scsi_zbc_in_xlat())
indicates that buffer size is not aligned to SECTOR_SIZE.

This happens when the __vmalloc() failed. Consider we are reporting 4096
zones, then we will have "bufsize = roundup((4096 + 1) * 64,
SECTOR_SIZE)" = (513 * 512) = 262656. Then, __vmalloc() failure halven
the bufsize to 131328, which is no longer aligned to SECTOR_SIZE.

Use rounddown() to ensure the size is always aligned to SECTOR_SIZE and
fix the comment as well.

Fixes: 23a50861adda ("scsi: sd_zbc: Cleanup sd_zbc_alloc_report_buffer()")
Cc: stable@vger.kernel.org # 5.5+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 drivers/scsi/sd_zbc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 186b5ff52c3a..ea8b3f6ee5cd 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -154,8 +154,8 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 
 	/*
 	 * Report zone buffer size should be at most 64B times the number of
-	 * zones requested plus the 64B reply header, but should be at least
-	 * SECTOR_SIZE for ATA devices.
+	 * zones requested plus the 64B reply header, but should be aligned
+	 * to SECTOR_SIZE for ATA devices.
 	 * Make sure that this size does not exceed the hardware capabilities.
 	 * Furthermore, since the report zone command cannot be split, make
 	 * sure that the allocated buffer can always be mapped by limiting the
@@ -174,7 +174,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 			*buflen = bufsize;
 			return buf;
 		}
-		bufsize >>= 1;
+		bufsize = rounddown(bufsize >> 1, SECTOR_SIZE);
 	}
 
 	return NULL;
-- 
2.33.0

