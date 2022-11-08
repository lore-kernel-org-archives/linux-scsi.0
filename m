Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EB3C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 19:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiKHTTj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 14:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKHTTU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 14:19:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2A81402D
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 11:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667935159; x=1699471159;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wPWEjSiGYeM40hN6LdQ8v6U93uOKSA3fHVI0ZEuvWzo=;
  b=ZyuVDJk5uuaGKCfhiKfZWq4dC3ArPco0u49og0rVh+aU4sXKwkSe6kb/
   CU5YLRB01+nqP6VChG30JoyXYmQ6Up4mZuKMcUwfwHqVZtmOlvQGnmHKL
   j/MeDMwsPsOKZzx/mrNJ7gNSD9dsuP4AA1lmtMgME0OT3tA3KZ1cvfbp7
   Hw7XqbU5pJVa5KsvloDcuz5ui2HmA5r8JaxL4KtzUdKYxBhKHx1dIn6KD
   DKtV7spDkgf9CS2/USKyA6GCGp2Ff8EKg5Xbabxci6lJzR+ZYkz0gTEHZ
   zbqeyXgClHe8tBC05ftDjxCwGlU45f2IRkElABW5hEzAl9XuxkM3iAS45
   g==;
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="122430456"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Nov 2022 12:19:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 8 Nov 2022 12:19:17 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Tue, 8 Nov 2022 12:19:17 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 2A8JM9I7322639;
        Tue, 8 Nov 2022 13:22:09 -0600
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 2A8JM9WR322638;
        Tue, 8 Nov 2022 13:22:09 -0600
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH 7/8] smartpqi: initialize feature section info
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Nov 2022 13:22:09 -0600
Message-ID: <166793532902.322537.2436075977808555348.stgit@brunhilda>
In-Reply-To: <166793527478.322537.6742384652975581503.stgit@brunhilda>
References: <166793527478.322537.6742384652975581503.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Initialize features to 0 before processing.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike Mcgowan <mike.mcgowan@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index e9c924ac1bb2..fb4a33decde1 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8004,7 +8004,7 @@ static int pqi_process_config_table(struct pqi_ctrl_info *ctrl_info)
 	struct pqi_config_table *config_table;
 	struct pqi_config_table_section_header *section;
 	struct pqi_config_table_section_info section_info;
-	struct pqi_config_table_section_info feature_section_info;
+	struct pqi_config_table_section_info feature_section_info = {0};
 
 	table_length = ctrl_info->config_table_length;
 	if (table_length == 0)

