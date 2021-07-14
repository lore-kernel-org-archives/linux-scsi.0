Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B669C07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7354761374
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240057AbhGNSbn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 14:31:43 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:55496 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhGNSbk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 14:31:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626287328; x=1657823328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nUrPuatobHKMHbBSvnB/MtWNobqFZh/U9CeTgX581Hc=;
  b=qJDWQj9pchcc9Ppv0sgI0jHpFHKWkm5Mo4Cw0c1PzZLabubXsyV/XMMV
   Q9AmWCtkSCtzVlwFTTzuINUiS2roqUtrTnBJ6f+ijFGxRQ1vh9YJwC2W6
   kTWLq5Qnfc/r1RBMsjAe84Au1zYfivW4cLeG4UO4FQGuajGkXpHvWmCoY
   BEfuE1WOmb9uJRekFeI9BySvvRIwnjRodFW9xMtNdKWHSSLhFVW82M5V/
   tO6b2k05naeRcQgKx12INc4whUhUmGcyRvzn7CAOHJo/cHHOXUDAndgFR
   jIG0wen96ctq6LHdQJJIns68vjmd1uvJD/VD3ik39MDapavlcbhAUDD9/
   Q==;
IronPort-SDR: BVVGlpckuDz33Y4MPxP6wSu1Mnj93l+4QZYQKMwyRtw7AV566LwsOxFydKj3Eixkz0IzehaVw2
 wQfJ4v2dTOKTppqCyTFWECjyTUnj265Cdpf1J2viRpOSSmg4GZMMyNNxupRck9CzDv8Rx992/+
 xnSuHVvpgqf2wDe55kch6pU2ItgsYhpAqfT1LyWhdcw720ppU+uzEzcQ507u3qqXXrZyh5uWcz
 i5Fdy5GURDp9frwXLT6je5TE43bblNDt/ccdpZCqOY+jdWBaWmlt78XwhwrBsjUwVFyCFC2qN9
 bXY=
X-IronPort-AV: E=Sophos;i="5.84,239,1620716400"; 
   d="scan'208";a="135875339"
Received: from f5out.microchip.com (HELO smtp.microsemi.com) ([198.175.253.81])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2021 11:28:47 -0700
Received: from AVMBX2.microsemi.net (10.10.46.68) by AVMBX1.microsemi.net
 (10.10.46.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Jul
 2021 11:28:47 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by avmbx2.microsemi.net
 (10.10.46.68) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 14 Jul 2021 11:28:47 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 5FF0F703472; Wed, 14 Jul 2021 13:28:47 -0500 (CDT)
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
Subject: [smartpqi updates V3 PATCH 9/9] smartpqi: update version to 2.1.10-020
Date:   Wed, 14 Jul 2021 13:28:47 -0500
Message-ID: <20210714182847.50360-10-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210714182847.50360-1-don.brace@microchip.com>
References: <20210714182847.50360-1-don.brace@microchip.com>
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

