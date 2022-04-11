Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF38C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Apr 2022 06:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245051AbiDKGsO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Apr 2022 02:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245131AbiDKGsD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2022 02:48:03 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575D0183B1
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 23:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649659550; x=1681195550;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f0Z65S+bPah2AV9sESLOkh8DUBO0u6CXX+epBZVJcWQ=;
  b=KqEk0ibJF8UH/ioV8iPXW7KUmcGFv45nuZrsV+fccHPC76jv3IU4TFJq
   voH891KU5eo7KzGVr0esrZyYkll1y8iL33XqCRNLFP5xUpsswlh2XMV6g
   732UTmxhC4Pq37VWKi7q4EO71bazcmKaq1nKyXWwhufl1+DJPoNtCe78z
   V0/7oTHVtYikFnocXhmVTDhgKtsfwEKQE/IGmNz0Y5w46QYyRvB7GdT/M
   Lp1W8NHRCxfhy61J0pq9Q5/VDBIscg6ON9/p3Hb9dA9ci9Ad2t3YFgaoK
   TMIfzcQ1Rsz1Vkv8yw2curTZ5pyYVUSey06pWZqM66XbiA9ZQcGn8V/By
   w==;
X-IronPort-AV: E=Sophos;i="5.90,251,1643698800"; 
   d="scan'208";a="160033974"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Apr 2022 23:45:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 10 Apr 2022 23:45:49 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Sun, 10 Apr 2022 23:45:49 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>,
        <john.garry@huawei.com>, Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v4 2/2] scsi: pm80xx: enable upper inbound, outbound queues
Date:   Mon, 11 Apr 2022 12:16:03 +0530
Message-ID: <20220411064603.668448-3-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220411064603.668448-1-Ajish.Koshy@microchip.com>
References: <20220411064603.668448-1-Ajish.Koshy@microchip.com>
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
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index a331a8ad0558..575d0f2a2d40 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -766,6 +766,10 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity	= 0x01;
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt		= 0x01;
 
+	/* Enable higher IQs and OQs, 32 to 63, bit 16 */
+	if (pm8001_ha->max_q_num > 32)
+		pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt |=
+							1 << 16;
 	/* Disable end to end CRC checking */
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.crc_core_dump = (0x1 << 16);
 
@@ -1027,6 +1031,13 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
 	if (0x0000 != gst_len_mpistate)
 		return -EBUSY;
 
+	/*
+	 *  As per controller datasheet, after successful MPI
+	 *  initialization minimum 500ms delay is required before
+	 *  issuing commands.
+	 */
+	msleep(500);
+
 	return 0;
 }
 
-- 
2.31.1

