Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE043C07E9E
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C19B661C5D
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhGFSS7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 14:18:59 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:47117 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhGFSS6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 14:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625595379; x=1657131379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zRLm1m85t9VWbNKqEZHfeP3cKUleVf2WkqeWJ1Wz34k=;
  b=W6H3E4EFdxaRTk/dd9vrxDHkukCCgbieyu80KSxCXCduFKhIj8cc9q0F
   VaVErFXcMnUsdzYvG6tEyS4wfrMglMZx51DEwnKGTEmssNOy2bK4LT7O8
   Gu4H23FAk+7HbdPsnVM910zba6BScfSA7qk0yL6XAOv6SNsUI5nhlI45V
   f/qm/h9i4rbYFECwbJ7fkmvDAZUUhW59Db0pkSALQ1N4rOpu3WvcAms+S
   h7zgZEOjdEOUbrPZS/o2Co12QxDzQwoucHb7e7DQCInSIG3tbS/i/WUMF
   IR5AIZSkMHBHsuiEUsYqbkxX0tNXhv2pNKcUm1PCppSSpZnfGw2hsaxlh
   w==;
IronPort-SDR: AihNXkbkY0ZO227P7vqAnF6nacR7OwPYnAasfqB9jh4eTzRwuxP44vVR0j46JNnodCJyW5Y14m
 CEPS70G7ly4u7CKDhTAhX8oDNuI3D6btRBO6d2j4neIKzxzC9lwJC1OPZBU5TdFXVVhgc+P6sm
 SyJYJB/nm0woZe8yKnGJqJFDd3WPKqdtzGPzzIZ7ponVNu6ZMUlNVi/1M0ZUORwYpUFIMyu+cd
 q7h12uoD2/eNO8GW8xvO8pHPIiYF/T7MUZPCkd4TRAuHlK0n/q0ElcYexAFmfRJiAyVmODA4Za
 xlM=
X-IronPort-AV: E=Sophos;i="5.83,329,1616482800"; 
   d="scan'208";a="134786018"
Received: from smtpout.microchip.com (HELO smtp.microsemi.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2021 11:16:18 -0700
Received: from AVMBX1.microsemi.net (10.10.46.67) by AUSMBX1.microsemi.net
 (10.10.76.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 6 Jul 2021
 11:16:18 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by avmbx1.microsemi.net
 (10.10.46.67) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 6 Jul 2021 11:16:18 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 5907770249B; Tue,  6 Jul 2021 13:16:18 -0500 (CDT)
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
Subject: [smartpqi updates  PATCH 1/9] smartpqi: add pci id for H3C controller
Date:   Tue, 6 Jul 2021 13:16:10 -0500
Message-ID: <20210706181618.27960-2-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210706181618.27960-1-don.brace@microchip.com>
References: <20210706181618.27960-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>

Add support for H3C P4408-Ma-8i-2GB device ID
     VID_9005, DID_028F, SVID_193D and SDID_1108

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index dcc0b9618a64..d977c7b30d5c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8711,6 +8711,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x1107)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x193d, 0x1108)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x8460)
-- 
2.28.0.rc1.9.ge7ae437ac1

