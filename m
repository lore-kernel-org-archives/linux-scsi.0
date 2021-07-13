Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A920C07E95
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6334B61164
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbhGMVFm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 17:05:42 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:8300 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbhGMVFf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 17:05:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626210165; x=1657746165;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LFpZ+CYZzqb1YpQvsDbpspaRBSX0vQfqNpAp5FAHVuQ=;
  b=OLnRdWJywAW/30tvDfduSmMT1gx/U+cxeB3ZeuLWl1Cs0AGASzq+MXz/
   b3ea97ifZzmjSOQ1bgkHzEdLUl8DqmGwGQlv/e2eb0NavLZvczrXSLxPy
   GymxEJ9EzWHwlgm3Y8wufhQ9Esr4WQMRmkAUgzWCwupsN7CzXbObrnRWm
   F+Ay/hnTFZA3NAKW9EjNOBz/nX0r30WEgr4XUl0EZ6S9Zbqg21HQnRFmd
   wlyHjKmCZ7kIBBj4UVgabXC6j9V6gjPMykHjzgN3Mw/eT3Hp3X9EG/rth
   ui9BDBAbpDyxIutcroNxKjayWuLW9aBa2GSURLlLgOHmBEp17k/7eN0Ef
   g==;
IronPort-SDR: 20HJmPvh+kFpkYFfhCpUA9X3rTmxu5UMNEXppSZ5b30i5lhoDyPjwy1ACZQKj/G56lxwUPi32w
 +AGxUD3q4MESw+oupBzyobJwr2j2RHtxwI15/u9ED7ZtqAF4BnB/s+VBI8pzeibO25elWcV+pG
 EkOuQixX/lGZOJVlqnoCkJhUeo3ZlgQFTxPGxEzUN88ZVqGAFnNwf0zKaB6hgSsB1hC8EPYz2E
 Lw+x3PiHe/srXHWTWFN1MFur5x8buZN2VqabYfgBABzWQnxgy6XdOIMMJT5yFyRGGbFSReuZWe
 3kE=
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="121925988"
Received: from f5out.microchip.com (HELO smtp.microsemi.com) ([198.175.253.81])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jul 2021 14:02:44 -0700
Received: from AUSMBX2.microsemi.net (10.10.76.218) by AVMBX2.microsemi.net
 (10.10.46.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 13 Jul
 2021 14:02:43 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by ausmbx2.microsemi.net
 (10.10.76.218) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 13 Jul 2021 14:02:43 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 8A8B4703503; Tue, 13 Jul 2021 16:02:43 -0500 (CDT)
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
Subject: [smartpqi updates V2 PATCH 7/9] smartpqi: add PCI IDs for new ZTE controllers
Date:   Tue, 13 Jul 2021 16:02:41 -0500
Message-ID: <20210713210243.40594-8-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210713210243.40594-1-don.brace@microchip.com>
References: <20210713210243.40594-1-don.brace@microchip.com>
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

