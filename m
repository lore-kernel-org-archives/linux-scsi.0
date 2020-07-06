Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9B8C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEE6F20715
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XgklHxdc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgGFMd6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 08:33:58 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37664 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgGFMd6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 08:33:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594038838; x=1625574838;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CPJcnLv0o7wPruH5hfsyoM7R2TiIe8k5zJELLtCoIcs=;
  b=XgklHxdceUhVusNzxYJVB1nMKF1RZ5VkKQ9e/f5dLexe2ZssDNzlvoTW
   reaIPH7IwQ63lF9zHXDfvLmtBxf8yFgT3CvSoJOS34qja71H4OGq+6PhN
   JLxv7DF1RfBQMsdX9ksd1o1duWB4T0x7uAFCLkDudgR0KeI/5c4pZPhYf
   OtD2vcpyGMIoauEcOgDJ3MmKEtrhde831pCLUFNcbaf5SmqoKNtRcLYhy
   wWMCLx9LSo0q6m2DzpF1mYYQBS6hXmEorSX3yA7EYzBlMCGSiSwMb+uou
   v3ahTrUaWJ48BvZ4rgPYM2kSQ/isyG5nmBTpGdI6nSkKZ6kk7DbDCvuEv
   Q==;
IronPort-SDR: x4kTPjChay5wb7ll1veb33sqGmHHB1r1bXYR/g9xOPNDdeN7j5fj1ndalM9sGPYgV15QAcPg6g
 TTDBU+/M74FxN0SCea4Ym+MAJzT4F2AbXJbT4YV+LwlYc/DqoLLDC7jtBdU7D07t2zPq6/Ig8B
 JE+NGplsEvcsPDd8hwkIYQQgQTSW5pwq06YYbk9A5vL6bhpJ2daABhb/rBKoxqmg7OfOXnpbNT
 RB0R0N2ckuur/4EcFj/mDT10pNPRlMJVPCsds5TRbeslYancbgqFURvzThOZumzxuuhxWU2YRj
 uxk=
X-IronPort-AV: E=Sophos;i="5.75,318,1589212800"; 
   d="scan'208";a="146052074"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2020 20:33:58 +0800
IronPort-SDR: QlLWnhaSoqwknU1kpsrY2plmCLl46BRkpjEP2wWEYrl0JTFS0TBlLwS9ubdEjW052iF/2aP7k+
 v2NId4eOOVcT/vXbIRvHRnFj2I8462izA=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 05:22:06 -0700
IronPort-SDR: 1jLMdNhVqvn2drUkHKODpRcnlKyMC+Ol988daExTDV/3hU75a+42c45BZEhe0FP4pmackhIElv
 BibEL5Wyn9ug==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2020 05:33:57 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 09/10] scsi: mpt3sas: Fix set but unused variable
Date:   Mon,  6 Jul 2020 21:33:56 +0900
Message-Id: <20200706123356.452135-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In _config_request(), the variable issue_reset is set using the macro
mpt3sas_check_cmd_timeout() but otherwise unused, causing a compiler
warning when compiling with W=1. Avoid this warning by removing this
variable, using the function mpt3sas_base_check_cmd_timeout() directly
instead of the mpt3sas_check_cmd_timeout() macro.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_config.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 62ddf53ab3ae..11026e0ef3d0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -303,7 +303,6 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 	u8 retry_count, issue_host_reset = 0;
 	struct config_request mem;
 	u32 ioc_status = UINT_MAX;
-	u8 issue_reset = 0;
 
 	mutex_lock(&ioc->config_cmds.mutex);
 	if (ioc->config_cmds.status != MPT3_CMD_NOT_USED) {
@@ -386,9 +385,9 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		if (!(ioc->logging_level & MPT_DEBUG_CONFIG))
 			_config_display_some_debug(ioc,
 			    smid, "config_request", NULL);
-		mpt3sas_check_cmd_timeout(ioc,
-		    ioc->config_cmds.status, mpi_request,
-		    sizeof(Mpi2ConfigRequest_t)/4, issue_reset);
+		ioc_err(ioc, "%s: command timeout\n", __func__);
+		mpt3sas_base_check_cmd_timeout(ioc, ioc->config_cmds.status,
+				mpi_request, sizeof(Mpi2ConfigRequest_t) / 4);
 		retry_count++;
 		if (ioc->config_cmds.smid == smid)
 			mpt3sas_base_free_smid(ioc, smid);
-- 
2.26.2

