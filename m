Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116C4C07E96
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF9866115B
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbhGMVFk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 17:05:40 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:24265 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235601AbhGMVFg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 17:05:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626210166; x=1657746166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eC9h7AuB2uBlbeufFeAaVi7C6flhHEAtOrptRD5MlTE=;
  b=S/sJTjVKVbFJOPHO7LwzrBXu2IdFodv0qm/Yg2Jutfg0dUjqN/tbsIud
   iWmpOMwKjNpCO9tYQsJyD3drGXRTM/MbqQ/Hr7sGGa9mOCVcvS8Ao40nH
   e1uuNIAVM4QayrLEazDZS7lBmaCri0DtL3Xb29guk0JU4ckvqWWte/liK
   wYBO+E26OgTRPPvnXMLzeh68MhTTuGOvv4MriY36AIo5pvSEDGNZGWrz8
   rZzxvM8+hfDlIIEohr6a6IgjrWMe3WGRVt3KaTcKEW9T9T3JzuVE+WInw
   V1hs0bG/ST88hmqXo0QbP7TdR1JVywncq0RGUrUJmPbCgungXFECaWZl8
   g==;
IronPort-SDR: x9DE1I3L4QYAKX7NQYwYt5LO84qKfarHuzsNeckxREcIBKy6Ml3K3NP4A5kExL+pOC9STOTgFE
 2JwjiQ4EqFPiyV1vHHVcWuYWP0qk2FxKthbcQvREte7AwWMn7/UZYxxRo/md4QcRnC6sFgZRSh
 p8fP+DuvNtuF7vkYczppCZNURd88fznEORPA4QZkhCalF4I5p50tKeDBlKSIom//hNWCu91I/+
 OJdvilckfGzERjVMt0VM2deOwyEVmMf/M9bxDmi0GAG7ebuDKzFmfaIfUamtW3z0GiaOoPmBQe
 Byo=
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="124447488"
Received: from f5out.microchip.com (HELO smtp.microsemi.com) ([198.175.253.81])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jul 2021 14:02:45 -0700
Received: from AVMBX2.microsemi.net (10.10.46.68) by AVMBX1.microsemi.net
 (10.10.46.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 13 Jul
 2021 14:02:43 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by avmbx2.microsemi.net
 (10.10.46.68) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 13 Jul 2021 14:02:43 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 8431E703501; Tue, 13 Jul 2021 16:02:43 -0500 (CDT)
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
Subject: [smartpqi updates V2 PATCH 6/9] smartpqi: add PCI-ID for new ntcom controller
Date:   Tue, 13 Jul 2021 16:02:40 -0500
Message-ID: <20210713210243.40594-7-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210713210243.40594-1-don.brace@microchip.com>
References: <20210713210243.40594-1-don.brace@microchip.com>
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

