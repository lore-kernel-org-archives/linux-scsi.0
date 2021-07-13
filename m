Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E436C11F68
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 447CD60FED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235708AbhGMVFh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 17:05:37 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:8300 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbhGMVFf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 17:05:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626210164; x=1657746164;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7GWo7ZtH3qsEMz3OZG0KlNbXjxhc+zeAxPNwHr5M6lE=;
  b=KlNfozfaSW/ig0SrVQHwNbi87MjnggARLBAS0/ZYE0mrM9xdplmh8uP8
   dHmGKm8f9Q8kj8wERxyoo8T5KwEtX7c5mrRRqz57Ihx9ihMTXuiG2KBRP
   6PJ6TfLjYbYp9P3fWuBwRWMj/HsRSRprl/BaS2ifZaN19T6igXUaSJT/g
   O45cemAf/QAjbR5mTBFiMbNt54rr5FT/uNJoXe9i1hvZRocYdTin204v2
   u+NjUUCrsTUeUb8nmNk2GVBbH8kPjhLLp3guKamYhCVNJtfutE13oPNTn
   Yzssvo/SUsq7ZFQdZ7k3zA+7zRSt/uKv5VDU+SwrrOU2p6M3Hte8zktZf
   w==;
IronPort-SDR: LWzUZb3I1b9Y+1MrXmJqIDdeS4Aw4CApibCBNyVziCplz8H2bnfs5qBTcuF2lw7KtXTnHe7G5t
 gOwrHzpiOA7u5pGZQbGacz0uwfPOqVIVccGQ3cZpTxAd/ns0DqDH2smtilt22kpRE3nW4r4RVb
 9FkRmztu4JdwpeUSJpnPv0ISRxVD1Xw6Xb9x/2bTU+YC3+uV4YWI1S9tyOjRRSUIOkyehjzKLD
 IinlloYnhc1OH03rwjhDe7Wh3uYGg6PDe6K8jdGPjycgkVBF7vtpaXi71+1o1+oTk3kP7HhG77
 SLw=
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="121925987"
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
        id 72463703483; Tue, 13 Jul 2021 16:02:43 -0500 (CDT)
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
Subject: [smartpqi updates V2 PATCH 3/9] smartpqi: change driver module MACROS to microchip
Date:   Tue, 13 Jul 2021 16:02:37 -0500
Message-ID: <20210713210243.40594-4-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210713210243.40594-1-don.brace@microchip.com>
References: <20210713210243.40594-1-don.brace@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change driver module MACROS to reflect copyright changes.
  - Microsemi to Microchip.
---
 drivers/scsi/smartpqi/smartpqi_init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 6ce17a191c0b..29382b290243 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -39,7 +39,7 @@
 #define DRIVER_RELEASE		8
 #define DRIVER_REVISION		45
 
-#define DRIVER_NAME		"Microsemi PQI Driver (v" \
+#define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
 				DRIVER_VERSION BUILD_TIMESTAMP ")"
 #define DRIVER_NAME_SHORT	"smartpqi"
 
@@ -48,8 +48,8 @@
 #define PQI_POST_RESET_DELAY_SECS			5
 #define PQI_POST_OFA_RESET_DELAY_UPON_TIMEOUT_SECS	10
 
-MODULE_AUTHOR("Microsemi");
-MODULE_DESCRIPTION("Driver for Microsemi Smart Family Controller version "
+MODULE_AUTHOR("Microchip");
+MODULE_DESCRIPTION("Driver for Microchip Smart Family Controller version "
 	DRIVER_VERSION);
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
@@ -8451,7 +8451,7 @@ static void pqi_print_ctrl_info(struct pci_dev *pci_dev,
 	if (id->driver_data)
 		ctrl_description = (char *)id->driver_data;
 	else
-		ctrl_description = "Microsemi Smart Family Controller";
+		ctrl_description = "Microchip Smart Family Controller";
 
 	dev_info(&pci_dev->dev, "%s found\n", ctrl_description);
 }
-- 
2.28.0.rc1.9.ge7ae437ac1

