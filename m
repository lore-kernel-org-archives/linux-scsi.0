Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A431AC3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 20:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CE8A22CE3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 20:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391874AbfHVUjI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 16:39:08 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:2817 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387798AbfHVUjI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2019 16:39:08 -0400
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=don.brace@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  don.brace@microsemi.com designates 208.19.100.22 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.22;
  receiver=esa5.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="don.brace@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.22; receiver=esa5.microchip.iphmx.com;
  envelope-from="don.brace@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: MrBQWZq/TUEj3fV14mEeM3TMy9QfADLZi7rxW7i7qWVAw+arYpc0Tz06Qu3klytwdquMLDlPJo
 3WRsQEg9x8ypwOYmomNPUwnk5JfzfeZ8U8EAMj6Er1SABYsFsYvCHYvQ2tVcn7uR6HbQ4AW9Sx
 TamcQ5OZtiaiVj06rokCr9mbW1CDSOqKIc3BglHktMdr6AVa3QVcOsm3L0kT0H0oKSMRnbgkl3
 sjYEwCtlAhTa9tpRi28oeo6BEmK+FIfHoqKxrpq9u1+hdKCqOQANmPx74ZpDHZG9KJhCtJyCyS
 fR0=
X-IronPort-AV: E=Sophos;i="5.64,418,1559545200"; 
   d="scan'208";a="44671272"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.22])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Aug 2019 13:39:08 -0700
Received: from AVMBX1.microsemi.net (10.100.34.31) by AVMBX2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 22 Aug
 2019 13:39:06 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX1.microsemi.net
 (10.100.34.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 22 Aug
 2019 13:39:05 -0700
Received: from [127.0.1.1] (10.238.32.34) by avmbx2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 22 Aug 2019 13:39:05 -0700
Subject: [PATCH 02/11] smartpqi: add pci ids for fiberhome controller
From:   Don Brace <don.brace@microsemi.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <bader.alisaleh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>, <shunyong.yang@hxt-semitech.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 22 Aug 2019 15:39:04 -0500
Message-ID: <156650634488.18562.16511032638625636719.stgit@brunhilda>
In-Reply-To: <156650628375.18562.9889154437665249418.stgit@brunhilda>
References: <156650628375.18562.9889154437665249418.stgit@brunhilda>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Gilbert Wu <gilbert.wu@microsemi.com>

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Gilbert Wu <gilbert.wu@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 4324234aa26c..fa6403b2741c 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8254,6 +8254,22 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_HP, 0x1101)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1d8d, 0x0800)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1d8d, 0x0908)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1d8d, 0x0806)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1d8d, 0x0916)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_ANY_ID, PCI_ANY_ID)

