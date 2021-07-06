Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 032D1C07E9E
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E262261C20
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbhGFSTC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 14:19:02 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:47117 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbhGFSS6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 14:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625595380; x=1657131380;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DYUJjYUnIibuQ0qciSCkTmQL4WLi2jb8O8bLKJYtXbw=;
  b=ZrA0PJo6g1OVQWIPel5hiPzwPdZ0vuvD0n5bTR8TJHYphdIwO9apMnyu
   FimxwtwB56icbbnO/uhV5L5/6gRtmSOMy5krheiJiFZwaa3UXRCzraqu/
   g6rh6qTA16DeExnvYAnG2qUEYQPgsjXKWrdFY3kfOJmIYOo9SwFO0exC0
   JVTCCxLv4Q8jhNQGPu0X4CTi6uoJoQOV90cFPGNK83DKIlNA2uCxjWrg0
   9JnbOPEsWiKPXrLxFJZ4T2G2T14tP4Y4vQ10OR7euj4xvzkwBkDB6WGpG
   kEWilo9PfCZxAkaEYgJ4KpfIcW/+AaF+V0hX1R9s0hnv0p8ZmEbBbQF0G
   A==;
IronPort-SDR: fGT4vnuCjMfNKKhE4FIDSViVAuSbT3Ajd/lk/bjF8Niv5oRq5raWci7mwzFOHH7j9rKHR9i5Sx
 ehS8xJ0am2/HNKF/K047e0uUDeCh0HXOuOUNU5oY/27WEa8HbdGwja/dcat/5X+cDIwIBaOHoc
 5K9AhfxeYbkaUNfqEWTW2oLHnbK25sWI7eZU9BTCFl6vLWWdb6GZsnotwYeN3rKrleKbHKcqbX
 jz3HM3jC90MOX6UJtA3QYdrm5vkb7EPrEZXKx8pi3wKlRT14gFdvO46x8OKUfagWHoZW0Jgs7u
 /HI=
X-IronPort-AV: E=Sophos;i="5.83,329,1616482800"; 
   d="scan'208";a="134786021"
Received: from f5out.microchip.com (HELO smtp.microsemi.com) ([198.175.253.81])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2021 11:16:19 -0700
Received: from AUSMBX2.microsemi.net (10.10.76.218) by AVMBX2.microsemi.net
 (10.10.46.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 6 Jul 2021
 11:16:18 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by ausmbx2.microsemi.net
 (10.10.76.218) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 6 Jul 2021 11:16:18 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 778E97025BB; Tue,  6 Jul 2021 13:16:18 -0500 (CDT)
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
Subject: [smartpqi updates  PATCH 6/9] smartpqi: add PCI-ID for new Norsi controller
Date:   Tue, 6 Jul 2021 13:16:15 -0500
Message-ID: <20210706181618.27960-7-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210706181618.27960-1-don.brace@microchip.com>
References: <20210706181618.27960-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike McGowen <mike.mcgowen@microchip.com>

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 1195e70b6ec3..a8dfb6101830 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9178,6 +9178,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
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

