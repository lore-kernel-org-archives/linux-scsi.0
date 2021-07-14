Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 983DFC07E9C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CAD6613C8
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240055AbhGNSbm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 14:31:42 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:36768 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhGNSbk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 14:31:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626287328; x=1657823328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7GWo7ZtH3qsEMz3OZG0KlNbXjxhc+zeAxPNwHr5M6lE=;
  b=ZStwnPkfB4WqERe0VDBUOnX+1KAzOEocykGz1YvSvBsCqfj/8jZfLh8A
   cFaJjY6liGdB5bEHC0t6idZo1ugPNT6F3xIEOukEJmCSBHeX0OnUFsakv
   VegyyYpl0Rr8H499spXwotGiF9BsH6pW+tXbyaIA1hpts20VQFDof3rDj
   8d3VT69xMANFawjuMuFoOBmycn33VX8+lvUImRD8MhkrQIEUmNI7ssyd5
   48FQtUuRk/11b1xBqxjdDmvlJdXMpjmUvrIK5zy7TBio9vaVIdM9dsSIo
   YX9m2AeyY0HC+D/16juaiKCc7RYb3KcHM7970AaYEialiezeaaW2Xz4eG
   w==;
IronPort-SDR: rsGY4UadCLikoJ2XBTGXz3xFiGGwI3CyaSPeSo1T2Bt9hVKzM6crPFrolNp+cbtHs6hzcoDih8
 Am2slXikLIQldo0Z4zaTZmc4kJh+ulsCNCj54thgVqWafBr9HWFqi5V6qQH4r5nO6r9VYOe+7f
 /r6HRdv6XQc5O+ELb/FqWrnenL2ow/brN5Qmfh0csrd8h4ZrNV8TaQG32Lsg98er/dilsam4sp
 wzx8U0l8qQ8e+vmQUC3seRTlmGLHBU/NFkCJy+LsJYa0NxOJTi118EGKmlIgfvIf9L1z+ttqha
 BnE=
X-IronPort-AV: E=Sophos;i="5.84,239,1620716400"; 
   d="scan'208";a="124579306"
Received: from smtpout.microchip.com (HELO smtp.microsemi.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2021 11:28:48 -0700
Received: from AUSMBX1.microsemi.net (10.10.76.217) by AUSMBX1.microsemi.net
 (10.10.76.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Jul
 2021 11:28:47 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by ausmbx1.microsemi.net
 (10.10.76.217) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 14 Jul 2021 11:28:47 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 39FD27026B1; Wed, 14 Jul 2021 13:28:47 -0500 (CDT)
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
Subject: [smartpqi updates V3 PATCH 3/9] smartpqi: change driver module MACROS to microchip
Date:   Wed, 14 Jul 2021 13:28:41 -0500
Message-ID: <20210714182847.50360-4-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
In-Reply-To: <20210714182847.50360-1-don.brace@microchip.com>
References: <20210714182847.50360-1-don.brace@microchip.com>
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

