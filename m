Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 193B0C11F66
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3888613C9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240041AbhGNSbl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 14:31:41 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:34842 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhGNSbk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 14:31:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626287328; x=1657823328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LVDDdK+yZdK6U3WZYWD6evcFgcekDy5NcMaTSBH6FMo=;
  b=bkA5J7PXjmZa65ns39Xo7icsCawiMtTFGH+h/AzJeuFBOEGN9EWHQ0B/
   BfN/F6VRJFLnvl2W4/qlmHrGBD8BWbbtfqjbAdOsjNQOEG8YjEN/jaoI8
   67wj/DYtYw3ZkRnJ8dIlEFkgxhu50u9CWQOTAC8ewDsh6ALZbaViAM5rj
   J7JYX/lZLiXLgU75Pw88RkN3CWzrt3CL5KXvxpHtemiEPyOO2QEaLlS0m
   9Vg8eeOMaZcN0GTdt/Lc/gtlmAPPiPLsnWHggrLfGUYDD7/WUBprjwJUH
   QduFKmGbFHDwzvSrjLutp8Zfw7mGUJGpq8Xmbm7cCjY18luNwD/TpCSuV
   Q==;
IronPort-SDR: gZBnCSGDGupGympTqBbigN98oVJlK2Y54qFgsDguLBREkh6uOWy+TwS0oYoDjju818PfhXnkv7
 nILPlD3P3aSYDL28RWo8dP1Fy/axIw45cVCacHEA0etQ+YFowcg9cGcg7PE6htVHNqu4j9O/d4
 LNQgTANUHVtVYg/ABOmkjnm/0+k6NfriMdwWiY2A70BwdojCD/yp4+51IIKC8z0Op+JJFlqsC/
 W43LYYyySXClyEx2R2cr993gtqGZHosg6Iedo+59e1gscBTIMpjkS1riEBExnUjy+W+zEFioGy
 aC8=
X-IronPort-AV: E=Sophos;i="5.84,239,1620716400"; 
   d="scan'208";a="122053846"
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
        id 2D0567025D4; Wed, 14 Jul 2021 13:28:47 -0500 (CDT)
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
Subject: [smartpqi updates V3 PATCH 1/9] smartpqi: add pci ids for H3C P4408 controllers
Date:   Wed, 14 Jul 2021 13:28:39 -0500
Message-ID: <20210714182847.50360-2-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210714182847.50360-1-don.brace@microchip.com>
References: <20210714182847.50360-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>

Add support for H3C P4408-Ma-8i-2GB device ID
     VID_9005, DID_028F, SVID_193D and SDID_1108
     VID_9005, DID_028F, SVID_193D and SDID_1109

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index dcc0b9618a64..64ea4650ca10 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8711,6 +8711,14 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x1107)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x193d, 0x1108)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x193d, 0x1109)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x8460)
-- 
2.28.0.rc1.9.ge7ae437ac1

