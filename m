Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 211D4C11F69
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 085E361C68
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhGFSTD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 14:19:03 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:6083 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhGFSS7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 14:18:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625595380; x=1657131380;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TyV0MIcOMOIMTZB5HtlzGaCyLDdHL59A5foxIGfMkY8=;
  b=va9aoKXoafDcszS+l9130EUbgvVf9etZD7GLw3dljsJnD6NlZxP8GDKr
   GPLwvji0fBWtlszYCcrh/736kUxCnYRdxuTV42QXA5zXjEFADhFrcx6KR
   vo6klJFPYDuCsT3ZItXvkpPqsjIJ1PCnynGMR9xItHc0Rn7S+unDVmMph
   MW/e5orByMuUL4MSP7RpUQDTvPe5C/9j4vlen0r40aNFEtyeHqtq9Xvk8
   dtzlOikAtLYaQW6AsSrqsNM9KIxpvzbObpCmJ7BTztjXYfsBygBTG3WCJ
   6TGNzgc7EElm+QBOelrhKIR2RcMT86yCOcgUb7fHvCQPC3QBAjIM6w49O
   g==;
IronPort-SDR: Li9h16rUzmPvkaMqym3WnygXilxw+EP5XcISbIaRop3Wd5UZcq8zuVM+TNvfc0iOEAVFXn1JeC
 Ll6SYzVTOVzirNEekIc+znezuO9kGucCYY7WFLIfIyP8EMXb6b5KqlRi38bGJV0wXA3wp3tgKu
 7a4eVBY3vHXYZttXrXujZzfbDN1j6TUVNVQj1lqJxlm9SFiX3qZPOfQLFPOkx6CvaYRPJseV1J
 SSPnM7Dfdy9479pYgQIDZams1TODmpajjkkZZgHk7Zzxh4gkSIFGnyjdWXS1XN8ALav40/mCvB
 0Ec=
X-IronPort-AV: E=Sophos;i="5.83,329,1616482800"; 
   d="scan'208";a="127846832"
Received: from f5out.microchip.com (HELO smtp.microsemi.com) ([198.175.253.81])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2021 11:16:19 -0700
Received: from AVMBX2.microsemi.net (10.10.46.68) by AVMBX1.microsemi.net
 (10.10.46.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 6 Jul 2021
 11:16:18 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by avmbx2.microsemi.net
 (10.10.46.68) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 6 Jul 2021 11:16:18 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 7123B7025BA; Tue,  6 Jul 2021 13:16:18 -0500 (CDT)
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
Subject: [smartpqi updates  PATCH 5/9] smartpqi: add PCI id for H3C P4408 controller
Date:   Tue, 6 Jul 2021 13:16:14 -0500
Message-ID: <20210706181618.27960-6-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210706181618.27960-1-don.brace@microchip.com>
References: <20210706181618.27960-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Balsundar P <balsundar.p@microchip.com>

Added support for H3C P4408-Mr-8i-2GB device ID.
      VID_9005, DID_028F, SVID_193D and SDID_1109

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Balsundar P <balsundar.p@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c2ddb66b5c2d..1195e70b6ec3 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8714,6 +8714,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x1108)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x193d, 0x1109)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x8460)
-- 
2.28.0.rc1.9.ge7ae437ac1

