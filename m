Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE32C11F68
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8186461C20
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhGFSTC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 14:19:02 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:47117 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbhGFSS6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 14:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625595379; x=1657131379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PWhEyabNaITf6RM3jWHD6lHoANm2XfzHlMwWkA8Z0Tg=;
  b=fxVFAAaTGyLT8gnK/l5rPNsY8PhkN7pesR82s7hC+F12lZ8BrZUlpVQv
   cz3h2Dl1/qnY1xBMn8Ei0/drS/F+uanHGf5lR5FsB8Pad8DoEPezzVtI6
   eSoFiMhd1YvnEP6Qac0WTDakS/dYWTbvNBedkcnsfhhRAGkZuoN587IzA
   lDG7wU4WpzBF8gTKS5Yqe2MzQrY+t2L79WUjjpZkiM2UeVspm2h+KBHXk
   eP5y1Abz7B8KO6/bHmEK+i2Xgk244YhDpR0f9aZeaws2Ukhp/CrkvJ77D
   rk7UkqNybekCGeLJMjW4dfX2TbVyqXGjB3dZxfQeiPh+26B4JDuQ249xk
   A==;
IronPort-SDR: ASe4NugIuaRQQh4A9twHNnFpWehphxvbWRGXL6DXUa0HGDwjG7g/PeFnB/4Vfp5JtNYtaetgq3
 +DONyuvwD+8JD2vGw8vDUToaTZZD9l7Cs3C7orzDCNSjLd/8ztExH5bAVx36gUjcGRQIHqGL67
 BtH+xrSIMtqC/BpuETR112Xkff/TyX7ulmDwWgz9lMLHL0mtfzh+gInDXJVMQdkFwOA89Pt8zG
 ie0xmerL9gp495RGNecWZDP7MtBiHs6M3T+2BrVBUDFt32EOeEVIPSdhrHG3SFltCdZNxM3zB+
 TM8=
X-IronPort-AV: E=Sophos;i="5.83,329,1616482800"; 
   d="scan'208";a="134786020"
Received: from smtpout.microchip.com (HELO smtp.microsemi.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2021 11:16:19 -0700
Received: from AVMBX1.microsemi.net (10.10.46.67) by AUSMBX1.microsemi.net
 (10.10.76.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 6 Jul 2021
 11:16:18 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by avmbx1.microsemi.net
 (10.10.46.67) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 6 Jul 2021 11:16:18 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 83EAF702821; Tue,  6 Jul 2021 13:16:18 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.peterson@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates  PATCH 8/9] smartpqi: fix isr accessing null structure member
Date:   Tue, 6 Jul 2021 13:16:17 -0500
Message-ID: <20210706181618.27960-9-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210706181618.27960-1-don.brace@microchip.com>
References: <20210706181618.27960-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike McGowen <mike.mcgowen@microchip.com>

Correct driver's ISR accessing a data structure member
that has not been fully initialized during driver init.
  - The pqi queue groups can be null when an interrupt fires.

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 6f2263abaa8c..eeaf0568b5e3 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7757,11 +7757,11 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 
 	pqi_init_operational_queues(ctrl_info);
 
-	rc = pqi_request_irqs(ctrl_info);
+	rc = pqi_create_queues(ctrl_info);
 	if (rc)
 		return rc;
 
-	rc = pqi_create_queues(ctrl_info);
+	rc = pqi_request_irqs(ctrl_info);
 	if (rc)
 		return rc;
 
-- 
2.28.0.rc1.9.ge7ae437ac1

