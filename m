Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D76EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2048060551
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243408AbhI1X4f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:56:35 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:25131 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243332AbhI1X4Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 19:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632873284; x=1664409284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qk+/mIlcitgiZ4zq0JfgYS+Zcn/YWafyHxI0W5AOSuE=;
  b=t7A7/Fo1zpvz9Arpb06dIO2dB3HqCB+bwWcsR/b1Wf3RK5Ak9Jah5kyC
   oDj/hqfuK2qwavdreafcWIcZbhnNiVw5uIPL06Wz969xO8Fh7yPi+wc+V
   gGrgWapM00IcvpKhmNxr4CYa8xYaltPHDFsDGZ3o66nB8ZLb3KZ0135dq
   Nisr3KSb83KbejWRaRp5Var3lo3iw6vijGPjwqIYaX+N4aqti9iqJ1pLA
   2/32ve0hXSjXAhaPUjiV/fCa62p/Vitj1rikcj4+fR9nevZA4HOeGHfJ9
   RJmB12Et+PrInFQBZdZG6l/d5pudTfYa3DSW+oE/mwc5y/Og51Irum5vM
   g==;
IronPort-SDR: fIXXAY1FXyT3Jix92e2XcAiGTEoXTLe6dtOV6eSJvr50kSGXtQHOprMJrWz6vAmao2WQcC7GVn
 w64w1Wczh46jBT4C+bbiV7XqqQXsZaAHgo1v/ezEjhedTZY5L8O+S6fESplkNP05MhJ3HRMLYX
 9iLavakFx+dvyJAL63nTPoA2AMmCGYsAdXU3h+F66R0DDdeHGaLCBOyJ2S5hEQ9Sr8jMCku8Y9
 MGh1h63Yv/BBwzmTXj4YUebI0iM2LU+m8qdgQQUMz36WJdpjsEEEO1yepfLRQx+mR9Ny7GyStO
 wuZW63mNT5U+qQRPf4vlnLFE
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="131019747"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 16:54:43 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 16:54:43 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 16:54:42 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 98413702927; Tue, 28 Sep 2021 18:54:42 -0500 (CDT)
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
Subject: [smartpqi updates PATCH V2 10/11] smartpqi: add 3252-8i pci id
Date:   Tue, 28 Sep 2021 18:54:41 -0500
Message-ID: <20210928235442.201875-11-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210928235442.201875-1-don.brace@microchip.com>
References: <20210928235442.201875-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike McGowen <Mike.McGowen@microchip.com>

Added PCI ID information for the
Adaptec SmartRAID 3252-8i controller:
    9005 / 028F / 9005 / 14A2

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mike McGowen <Mike.McGowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8be116992cb0..ffa217874352 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9287,6 +9287,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x14a1)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14a2)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x14b0)
-- 
2.28.0.rc1.9.ge7ae437ac1

