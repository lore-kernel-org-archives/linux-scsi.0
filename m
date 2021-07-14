Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF44C07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 976F4613C5
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239944AbhGNSbk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 14:31:40 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:55496 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhGNSbk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 14:31:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626287328; x=1657823328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hXxOvXw4eeJpjDBFqXC+wHjs9TywmXrN9BduamjpANo=;
  b=mbWddmUBwDQEuKk1RrHIBmEXbWH8Quw1aiD8L8pHLeLXFQlH1aLdabif
   4FPA0lv9NPMmUKNxD1yP3RqhHNDekhJ4DVKopcS8M3y6zdjY4f6uLJjyr
   d7xFMy5is93NJJkT0+/xMReGYobY1TZPmG/xZcPJYTxi35euCpELU5pdB
   mWNX1xftWyGQ+i4/Od0HqsRpCWGZnjUJ+T25efAw56C7YsKjyBihgLWeb
   AiICXL2BLwjpVtqu6h5GQeXIeZBXb+K+bx7Z6bFa0ggdlDcIxS7o7hEQT
   3A5wRCFxVho74mU6XML3gLnwS6nSHHcaIIjoAeDyBlxFVAgznJ+jv+hgo
   Q==;
IronPort-SDR: uf8EjJDclI18xmegvKNl088WOALhUrO7tBiGBr49v6XyTzkPyGKIQujuWRYbmSTnJqRUbwAtfj
 Fg5H+HNZWClFogcgVxzfA/2BrLfRDOFDAr1dj+XoDfV3LSDOwcvBqn9+pTb/byHjS3E0tnMKVB
 yl6vqut+o0YmyVUSpgYCHifzGszFEw/GaxUQZF31JAkoEQPmkBSqw5VjBf7+vymGqSp84IrwE5
 ahm5g7D+tE6KawofbTY6YWIKI24q+f32nDKyUUQH32q7XBbWFjgC9h7Ke529qXG2LxfVTpY8yQ
 sr8=
X-IronPort-AV: E=Sophos;i="5.84,239,1620716400"; 
   d="scan'208";a="135875338"
Received: from f5out.microchip.com (HELO smtp.microsemi.com) ([198.175.253.81])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2021 11:28:47 -0700
Received: from AUSMBX1.microsemi.net (10.10.76.217) by AVMBX1.microsemi.net
 (10.10.46.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Jul
 2021 11:28:47 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by ausmbx1.microsemi.net
 (10.10.76.217) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 14 Jul 2021 11:28:47 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 40494702821; Wed, 14 Jul 2021 13:28:47 -0500 (CDT)
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
Subject: [smartpqi updates V3 PATCH 4/9] smartpqi: change Kconfig menu entry to microchip
Date:   Wed, 14 Jul 2021 13:28:42 -0500
Message-ID: <20210714182847.50360-5-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210714182847.50360-1-don.brace@microchip.com>
References: <20210714182847.50360-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change Microsemi to Microchip
---
 drivers/scsi/smartpqi/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/smartpqi/Kconfig b/drivers/scsi/smartpqi/Kconfig
index eac7baecf42f..6f83e2df4d64 100644
--- a/drivers/scsi/smartpqi/Kconfig
+++ b/drivers/scsi/smartpqi/Kconfig
@@ -38,14 +38,14 @@
 # HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
 
 config SCSI_SMARTPQI
-	tristate "Microsemi PQI Driver"
+	tristate "Microchip PQI Driver"
 	depends on PCI && SCSI && !S390
 	select SCSI_SAS_ATTRS
 	select RAID_ATTRS
 	help
-	This driver supports Microsemi PQI controllers.
+	This driver supports Microchip PQI controllers.
 
-	<http://www.microsemi.com>
+	<http://www.microchip.com>
 
 	To compile this driver as a module, choose M here: the
 	module will be called smartpqi.
-- 
2.28.0.rc1.9.ge7ae437ac1

