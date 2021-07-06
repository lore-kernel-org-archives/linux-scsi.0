Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FF1C07E96
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF3E061C69
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhGFSTB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 14:19:01 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:56937 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbhGFSS6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 14:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625595381; x=1657131381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c0MUWPA6+1IpPLjFc8iGB0brGn+MCUu7WL0cx4xm9H8=;
  b=K7Gu9NBAcSUbdyutfxkuZ30tboZrcauPp1obYHakRwDq3kTO0DCO5BkD
   TTllm/BTni4XkHAvNU37lPKvrO6R2MXAoJwGNqAkyOp5Nx4vh9qXnDo85
   ysx6zYk4FPgb9/cOoCniZ+3jF3svkopUOg0TFyKXxdlnjqZAUqU9hVmp0
   QGvYrmG9mWC0uflIqfBLs/Ys3A8bHbisu3ju3ubsKvaB5eYRV8Tri40xf
   f/9obD7EhriSJSlff7pe3HSOKGqfT4CK8wPNvMgzwFiNY2DkBF9UJk7iP
   JvGsm5TwnU8w/2Xcrchleg2yBzntLR0DKC84sgaquCs6kjQdggzTxO7Bb
   Q==;
IronPort-SDR: GARfzhiZYUNM1EADB18XH6P67QTK8XhQKpHHQjzz355of4BDewy7SqxMt09ZMAud1wHJZ7RZjn
 RKIqNZaevA0AEnw0EgniLqmwNskNlIoFBGwDFhpTgD+yGRKnu+ri6CHFEZLJWo2fPwCVy4dh13
 H2GU8mhGQLtSOhhw7XqVpDMCxr+Lq7apdBee4zQE4sj6dBIy39qYUlW25YWhAZMe3BV96K83to
 cXGXgYb4QgeIOMDK8q3UbKBUJeE+esIOQsM29uEgzazT+LFYQmjDAw96+WV9CrWYbi3AqmfDWd
 Qv4=
X-IronPort-AV: E=Sophos;i="5.83,329,1616482800"; 
   d="scan'208";a="127272699"
Received: from smtpout.microchip.com (HELO smtp.microsemi.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2021 11:16:20 -0700
Received: from AUSMBX1.microsemi.net (10.10.76.217) by AUSMBX2.microsemi.net
 (10.10.76.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 6 Jul 2021
 11:16:18 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by ausmbx1.microsemi.net
 (10.10.76.217) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 6 Jul 2021 11:16:18 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 893C570295C; Tue,  6 Jul 2021 13:16:18 -0500 (CDT)
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
Subject: [smartpqi updates  PATCH 9/9] smartpqi: update version to 2.1.10-020
Date:   Tue, 6 Jul 2021 13:16:18 -0500
Message-ID: <20210706181618.27960-10-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210706181618.27960-1-don.brace@microchip.com>
References: <20210706181618.27960-1-don.brace@microchip.com>
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
index eeaf0568b5e3..a41acf8729a3 100644
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

