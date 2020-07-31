Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED31C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82B5E208E4
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgGaVBb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 17:01:31 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:2929 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729043AbgGaVBa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 17:01:30 -0400
IronPort-SDR: rfnXoChi07GN9VAakoxoafWRTDZkybjd43SHNQCtMe64czDWn7KhF6231Uuyi6gWYpAnDLm9cm
 QBvpPxcUIaFOUq0yUEUrLyYuRjHXlyIHEBDq5WnIf2jMhi5gva1OEN/tXbA9G8miu0Bqjc2iZm
 AsetPjPTC150uV3B8iLL81JSwLMmXje84+iaWQOTPX9D/dC1ARTnfIUeVe+2pQa6GgYs+UqD7O
 Yf0Tl2OM3Hmcs3T88ZJohj/9r+7bqkmB7jo2Z5p+VDGwkPOC25bWTa/BBouDo8M+mYfGjpGmmb
 E7g=
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="86243997"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jul 2020 14:01:22 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 14:01:17 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 31 Jul 2020 14:01:20 -0700
Subject: [PATCH 2/7] smartpqi: add id support for SmartRAID 3152-8i
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 31 Jul 2020 16:01:21 -0500
Message-ID: <159622928143.30579.14769183842894725454.stgit@brunhilda>
In-Reply-To: <159622890296.30579.6820363566594432069.stgit@brunhilda>
References: <159622890296.30579.6820363566594432069.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>

- VID_9005, DID_028F, SVID_9005 and SDID_080A

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index a5c76f024224..4c13ee763974 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8294,6 +8294,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x0809)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x080a)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x0900)

