Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB20BC11F69
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8DE861374
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240098AbhGNSbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 14:31:48 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:36768 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240049AbhGNSbm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 14:31:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626287330; x=1657823330;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eC9h7AuB2uBlbeufFeAaVi7C6flhHEAtOrptRD5MlTE=;
  b=TECis2EjB2eULH23xLuaH1FPvCGrrRGIHCPY5//kndMLZJ267KJp4Uj+
   EBcNoVARCdIpgnBNSpbhYGL5lOVZZOFnAZ3tdF05EFV2WxmpETfA/ZLUc
   HxDmuu4uezDIMwqNknrGoFDCwaOuUdZ2S8ISpJ76lNiiUhrzZoACJlKVd
   xvM3cssKM/T1On85cCR6TFo2UZCIl+5gMs+UQgGvoFQj1ootH4gsG+EyG
   39fTJbzrnqVnq0wJmT4Dr2yAFAoV6oxabEIQ3iwYuOa4X1mSQzWMvhEOq
   NRm1FZMJACK1wbxo67FFQ0mJOgOR+v43gnymTy1hXT7EATKw15WAhQPt4
   w==;
IronPort-SDR: 5PuP2DScttMCZQHbUPc3nXur2vM/wUIw/Q8/cphuMP2PORCeAtXgLV6R2YEAccQsyYiUb1wi46
 GukW6VUEljgO8V/z3XyMo/BTpB9UPkQcppVmDGlJcJgTS7XR6YuBIaw6GiLCxx91yQuDzVk7nD
 biHGY5QZRhDhMK14XyJN7VvcGj105csjzWklbk7441Bs9gXvIhNjixV7Ldy0LJCa8J7DDf2aKq
 KCH7KJTizqd01bQWO+nc8AD5hNrnKEV37bjgl6xNphCtl5/d7V+ji0tUYCJZGbAbFY8BMEXrlV
 xX0=
X-IronPort-AV: E=Sophos;i="5.84,239,1620716400"; 
   d="scan'208";a="124579313"
Received: from smtpout.microchip.com (HELO smtp.microsemi.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2021 11:28:49 -0700
Received: from AVMBX1.microsemi.net (10.10.46.67) by AUSMBX1.microsemi.net
 (10.10.76.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Jul
 2021 11:28:47 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by avmbx1.microsemi.net
 (10.10.46.67) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 14 Jul 2021 11:28:47 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 4CBE270345A; Wed, 14 Jul 2021 13:28:47 -0500 (CDT)
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
Subject: [smartpqi updates V3 PATCH 6/9] smartpqi: add PCI-ID for new ntcom controller
Date:   Wed, 14 Jul 2021 13:28:44 -0500
Message-ID: <20210714182847.50360-7-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210714182847.50360-1-don.brace@microchip.com>
References: <20210714182847.50360-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike McGowen <mike.mcgowen@microchip.com>

Add support for Norsi ntcom Raid-24i controller
VID_0x9005, DID_0x028f, SVID_0x1dfc, SDID_0x3161

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ffc7ca221e27..c0b181ba795c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9181,6 +9181,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_GIGABYTE, 0x1000)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1dfc, 0x3161)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_ANY_ID, PCI_ANY_ID)
-- 
2.28.0.rc1.9.ge7ae437ac1

