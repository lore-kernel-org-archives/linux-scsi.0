Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7D9C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8216360C41
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243385AbhI1X4c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:56:32 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:42065 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243314AbhI1X4Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 19:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632873284; x=1664409284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7SfRriv3lj7ni9vkNCmDdcJ/4GI3pG+BRfDXQiStT98=;
  b=1QAHQG+M9/bmfZQ8pC3vLsrLNBtm12VTDrJOTouy2PhIAI+dgptyC1GZ
   +5IGGGrhX0Bshnh8Z4O1RzGfB/aHB13nns7/NW9p8QCm/cvsEdpAF/AU0
   Pwi/SYlTlYsVABfHTTeKJ0qZ0485DMsBqDlS5aEHrjsWGRlINsLxfU2Vt
   jnkHC9iXL13Wcg24ef+mcPkSpEY0T9Rz9fh42qLUFeyWz6UjXIk1URTnY
   GFcwaK+7QZH5nFArKjFFxEsv4LDEhPicau2716/JRTn6IvumIJvIuZxG1
   8ruMdjGZI+MI+sDy0o6FARwg4XhGeNy7BnYrBaJT6DRA2xQycVDFpYKNp
   Q==;
IronPort-SDR: PWZlg6x4aTItYTAn2DZuVaSam9cxs5Xqgdd1JfblpGRuQMzFIfRvhJ3snpJx+I+Lv4/cydna5E
 wRROeFBItrazWUBci+tAsBp2ZBj60xmIfdw1hAf5CZH3JNsJ4cHZexBt8TCNMY6mUiPCRaYeOb
 Uykqc719AokVBolZxwtH0jsplvbSTMQiIeAEuDBHXEEu9vC2aLSHCwgZqERVSew5b9t+KaOx2p
 fOCaekVBlcivTcZPPN5x8M7aE5MtE5eiKliicBteF7Wu0j+zkcBhxAPeQhBqzQrM5ZoZwBC2Xx
 oqpc7Ykr/r2tdWAkDwFo9Q62
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="146019805"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 16:54:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 16:54:42 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 16:54:42 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 8B5D37028EA; Tue, 28 Sep 2021 18:54:42 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates PATCH V2 08/11] smartpqi: fix boot failure during lun rebuild
Date:   Tue, 28 Sep 2021 18:54:39 -0500
Message-ID: <20210928235442.201875-9-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210928235442.201875-1-don.brace@microchip.com>
References: <20210928235442.201875-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike McGowen <Mike.McGowen@microchip.com>

Move the delay in the register polling loop to
the beginning of the loop to ensure there is always
a delay between writing the register and reading it.

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mike McGowen <Mike.McGowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 1e27e6ba0159..c28eb7ea4a24 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -4278,12 +4278,12 @@ static int pqi_create_admin_queues(struct pqi_ctrl_info *ctrl_info)
 
 	timeout = PQI_ADMIN_QUEUE_CREATE_TIMEOUT_JIFFIES + jiffies;
 	while (1) {
+		msleep(PQI_ADMIN_QUEUE_CREATE_POLL_INTERVAL_MSECS);
 		status = readb(&pqi_registers->function_and_status_code);
 		if (status == PQI_STATUS_IDLE)
 			break;
 		if (time_after(jiffies, timeout))
 			return -ETIMEDOUT;
-		msleep(PQI_ADMIN_QUEUE_CREATE_POLL_INTERVAL_MSECS);
 	}
 
 	/*
-- 
2.28.0.rc1.9.ge7ae437ac1

