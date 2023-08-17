Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3F6C41513
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 13:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbjHQNNW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 09:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351405AbjHQNNK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 09:13:10 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF113AB3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 06:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692277964; x=1723813964;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bxVTnTo22qivxImDIHPDWcC/aThn69MAlos4VbkdNpI=;
  b=XRcG2RrpgLcLCsdpOU0+734Byd/utDcjKNKpfc1ZZbprKPVctB4TyRrZ
   mXwd8R1xxEczpgE/Slw6CIurtbUMgDOIocq4AjFVcK+X08BAw31j+M34Q
   FiQeWeYd5vYaTLUuJ/4dgaEdqYqd8dZZQdUuzwlafxKLJiOtgAyzAJ1JI
   m726NjIffCKKTE4onzkcJUnBGVW98Ad4YxFmB/matYPBPzHB/OozHZzZ1
   pZFGa2q80amtJ3vVytQgKFYtmYt39kQqDsQuNU1rTwmkJhk5WEMEcOcJb
   9OZxHdxCgaDStXh2qghUkxgcDoDe9FEmW+E1aX6FPmDezhIJ1D5+GWpLP
   A==;
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="166911871"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2023 06:11:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 17 Aug 2023 06:11:07 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 17 Aug 2023 06:11:06 -0700
From:   Don Brace <don.brace@microchip.com>
To:     <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
        <scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
        <murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
        <jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH 6/9] smartpqi: enhance shutdown notification
Date:   Thu, 17 Aug 2023 08:12:29 -0500
Message-ID: <20230817131232.86754-7-don.brace@microchip.com>
X-Mailer: git-send-email 2.42.0.rc2
In-Reply-To: <20230817131232.86754-1-don.brace@microchip.com>
References: <20230817131232.86754-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: David Strahan <David.Strahan@microchip.com>

Provide more detailed information about cache flush errors
during shutdown.

Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: David Strahan <David.Strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index e3ce5b738e15..2612818d476d 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8870,7 +8870,7 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
 	rc = pqi_flush_cache(ctrl_info, shutdown_event);
 	if (rc)
 		dev_err(&pci_dev->dev,
-			"unable to flush controller cache\n");
+			"unable to flush controller cache during shutdown\n");
 
 	pqi_crash_if_pending_command(ctrl_info);
 	pqi_reset(ctrl_info);
-- 
2.42.0.rc2

