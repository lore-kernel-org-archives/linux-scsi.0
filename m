Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FECC11F68
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC5E4613C8
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240065AbhGNSbn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 14:31:43 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:34842 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbhGNSbk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 14:31:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626287328; x=1657823328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LFpZ+CYZzqb1YpQvsDbpspaRBSX0vQfqNpAp5FAHVuQ=;
  b=j7BDWbX7mOX0+uLI+1lvTR6fCJSKdX+8Ud2z5ZWvxGXpgUJ2+V33s7nx
   2+Af/vb/q2BU9pXfMfRrWNb+hS7BLcQCZYqEKym4c8KNp52Z6XMvRGrGJ
   d6ypvRhBAk+aiaWx8KfIR29kdYh9OKaUNVyYsjLG4/iUkgw4NiQa+bN+T
   XOvmWuODJmpJTRjD5hgVNSGVjeuRfIca3S+3hyEZ9J5NBrEFo6RoYCfCc
   9QTHHp5oVkxapDmVMn6qFxpR7MQk5ZduOqvlOcA8A9ixJSkxkQkNEEMYL
   DD39Zm8/z6NEEj2yzF+XiwuzmnrwIQdq7jH/vCQ/ovUmxDE9XG0D2mSk0
   g==;
IronPort-SDR: 7aXrA4IZH8g+83YxKBqJV7n6Xpe9JLzBdqblJxp6iHPkFs3jdiBtKMm1YtOZQlwPstkBtycIU4
 8wqlNHj7U+rkrn4h0VuUTk1lNmGQPZgi/nCcE/ELG9BaZan+MbdTOjsso/EQDIjU5d1nUAosOr
 E/movizdG9gfsUWP8VG3uYwcbmpF2NHpVyzyWvq9IAn09O07UNj8gqPsxFn4zmicTYp5+jECq4
 6127XDwkC+kk7YvUo/zPWTl8u4MPOVf3hMlfXREhCPQziNOL8H1PDF+X66Z5cClOolfjz3U9ZR
 Xyk=
X-IronPort-AV: E=Sophos;i="5.84,239,1620716400"; 
   d="scan'208";a="122053848"
Received: from f5out.microchip.com (HELO smtp.microsemi.com) ([198.175.253.81])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2021 11:28:47 -0700
Received: from AVMBX1.microsemi.net (10.10.46.67) by AVMBX2.microsemi.net
 (10.10.46.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Jul
 2021 11:28:47 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by avmbx1.microsemi.net
 (10.10.46.67) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 14 Jul 2021 11:28:47 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 52FE370345B; Wed, 14 Jul 2021 13:28:47 -0500 (CDT)
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
Subject: [smartpqi updates V3 PATCH 7/9] smartpqi: add PCI IDs for new ZTE controllers
Date:   Wed, 14 Jul 2021 13:28:45 -0500
Message-ID: <20210714182847.50360-8-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210714182847.50360-1-don.brace@microchip.com>
References: <20210714182847.50360-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Balsundar P <balsundar.p@microchip.com>

Added support for ZTE RM241-18i 2G device ID.
VID_9005, DID_028F, SVID_1CF2 and SDID_5445

Added support for ZTE RM242-18i 4G device ID.
VID_9005, DID_028F, SVID_1CF2 and SDID_5446

Added support for ZTE RM243-18i device ID.
VID_9005, DID_028F, SVID_1CF2 and SDID_5447

Added support for ZTE SDPSA/B-18i 4G device ID.
VID_9005, DID_028F, SVID_1CF2 and SDID_0B27

Added support for ZTE SDPSA/B_I-18i device ID.
VID_9005, DID_028F, SVID_1CF2 and SDID_0B29

Added support for ZTE SDPSA/B_L-18i 2G device ID.
VID_9005, DID_028F, SVID_1CF2 and SDID_0B45

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Balsundar P <balsundar.p@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c0b181ba795c..f0e84354f782 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9185,6 +9185,30 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1dfc, 0x3161)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5445)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5446)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5447)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x0b27)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x0b29)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x0b45)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_ANY_ID, PCI_ANY_ID)
-- 
2.28.0.rc1.9.ge7ae437ac1

