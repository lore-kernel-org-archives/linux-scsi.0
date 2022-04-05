Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01599C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 10:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240915AbiDEKz1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 06:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345030AbiDEJmz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 05:42:55 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B320ABF95F
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 02:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649150903; x=1680686903;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VD6j8Nu3A7lXR9Uk4FkaKFGK5kcgYsNGW5r9o3Wwkqs=;
  b=EYVcgFktxXKZ6pSijtWBF+vPWIxcF7o4hXrdJILiNpJvi1UZWzabHrTJ
   2W2W1ViO87zrF8qw3LYZ6iahjOJ3BtlBl3iAXKBDTOTqhaK8ALkAPc2pS
   V+JO4dXnCCW0F0qFV4kyZRuy1X6UAdls8HHVUW9Kznq+FNN5EeZVHr4fK
   mp3OLVQznER2yo+h/MQWEMmcsQFSFMHXnVSDNhsi2uYS1a+fCAioeYEag
   vEuHvDrYrHsId2ANgPULFpy64eSzE8RJRNP/y8TkDjojItQpzgRq8PgDS
   wXw/ozy20zlFRGjTKK38t+pSEa3zTzrUSJmBZSMG8fmo/1CsiiFNOiBoa
   g==;
X-IronPort-AV: E=Sophos;i="5.90,236,1643698800"; 
   d="scan'208";a="159337353"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Apr 2022 02:28:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 5 Apr 2022 02:28:22 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 5 Apr 2022 02:28:22 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>,
        <john.garry@huawei.com>, Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 2/2] scsi: pm80xx: enable upper inbound, outbound queues
Date:   Tue, 5 Apr 2022 05:28:33 -0400
Message-ID: <20220405092833.83335-3-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220405092833.83335-1-Ajish.Koshy@microchip.com>
References: <20220405092833.83335-1-Ajish.Koshy@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Executing driver on servers with more than 32 CPUs were faced with command
timeouts. This is because we were not geting completions for commands
submitted on IQ32 - IQ63.

Set E64Q bit to enable upper inbound and outbound queues 32 to 63 in the
MPI main configuration table.

Added 500ms delay after successful MPI initialization as mentioned in
controller datasheet.

Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Fixes: 05c6c029a44d ("scsi: pm80xx: Increase number of supported queues")
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 3e6413e21bfe..c41c24a4b906 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -766,6 +766,10 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity	= 0x01;
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt		= 0x01;
 
+	/* Enable higher IQs and OQs, 32 to 63, bit 16*/
+	if (pm8001_ha->max_q_num > 32)
+		pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt |=
+							1 << 16;
 	/* Disable end to end CRC checking */
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.crc_core_dump = (0x1 << 16);
 
@@ -1027,6 +1031,8 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
 	if (0x0000 != gst_len_mpistate)
 		return -EBUSY;
 
+	msleep(500);
+
 	return 0;
 }
 
-- 
2.31.1

