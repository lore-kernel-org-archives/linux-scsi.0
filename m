Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D560CC07E95
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7E9B61164
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhGMVFi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 17:05:38 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:5638 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234665AbhGMVFf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 17:05:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626210164; x=1657746164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nUrPuatobHKMHbBSvnB/MtWNobqFZh/U9CeTgX581Hc=;
  b=wpmMuCVm9hfBijUqFBSawTbg+Pm6sTwaZYRIwqsR5EYfDZu2meiBbNWq
   kl1p3R/uWsMrtSwD0zRRBvCwHhZcVykbUss8ipIVx+ENidhoZ25XOCIqX
   Di0GYYPMkwPh7H3Wp+rJMFhJ5dc0ctxwV7DQff8mpO2WvYSWeOFvdxhPA
   hv0wtduyMh8WY8LGNqC3+znUFxHglxdSC9zT5GznU4wvV5v3ErLIQhZLM
   8kGOfT0pWi8+L1wsEJtUgRMcaXrY1j/09h9j1pudz8PvYtUEwwP31j5zL
   Y51TDvHlqxYG2mabTTf4xrjlvo4YycTqACweKYHs8PyDTPy+Wp2qffPZn
   w==;
IronPort-SDR: g6tbyTzKs1+3GBtk5hG4hicJsghGiQH/QBGg6IxkpPO4NLeeoLFgJDJKhkNtck6QAJOB6EllLD
 lZTac1rPpXRwjHYPfDYbNPPZluzIt11so+V3ZG4ZL9gwgM4orobhG/PtjfRwMMxMQ6osEUUBod
 syfYMnX3wOzVbZuZ6MVDaO744M+8soxCdw4/VeE7eAdZUxlglVx2lN/1cFeUDlfjmepnFbtIzj
 CCbx/ycyR3bVSsZAJs/j5qUZmxlB2XhMaIGVyB96cVuPurds3rmPE/luOn62VwtBXxLd/hTEZ7
 wog=
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="62103595"
Received: from smtpout.microchip.com (HELO smtp.microsemi.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jul 2021 14:02:44 -0700
Received: from AVMBX2.microsemi.net (10.10.46.68) by AUSMBX2.microsemi.net
 (10.10.76.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 13 Jul
 2021 14:02:43 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by avmbx2.microsemi.net
 (10.10.46.68) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 13 Jul 2021 14:02:43 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 97D6770352F; Tue, 13 Jul 2021 16:02:43 -0500 (CDT)
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
Subject: [smartpqi updates V2 PATCH 9/9] smartpqi: update version to 2.1.10-020
Date:   Tue, 13 Jul 2021 16:02:43 -0500
Message-ID: <20210713210243.40594-10-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210713210243.40594-1-don.brace@microchip.com>
References: <20210713210243.40594-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Gerry Morong <gerry.morong@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ab1c9c483478..c1f0f8da9fe2 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -33,11 +33,11 @@
 #define BUILD_TIMESTAMP
 #endif
 
-#define DRIVER_VERSION		"2.1.8-045"
+#define DRIVER_VERSION		"2.1.10-020"
 #define DRIVER_MAJOR		2
 #define DRIVER_MINOR		1
-#define DRIVER_RELEASE		8
-#define DRIVER_REVISION		45
+#define DRIVER_RELEASE		10
+#define DRIVER_REVISION		20
 
 #define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"
-- 
2.28.0.rc1.9.ge7ae437ac1

