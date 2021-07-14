Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F07DBC07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC29F613C3
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240083AbhGNSbq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 14:31:46 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:55496 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240007AbhGNSbk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 14:31:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626287328; x=1657823328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YCU1lNbnN3QiScgV4I4qmlBlxDGRHX9C+VP7ZGwbfYg=;
  b=2AEGO/AArr5VDQPA9ujtadgIRaQqgyhWRjl/hot8O7Q9t1Ii1DqN1Ru9
   oP9/w2Jt8uXIBcAIKEb+mepy6ImWspXcJDDyR+Ip+HVotrIBIAbi/aJBD
   KAz7sskl8cw7uGar9PcIW6nRg/igU5HrBLkaRM5WnKYnX6qYpNvpLXELo
   AP5fVlHeyvhbz/bIilmTKlL+5xWfNsf7Nt4+LtWNLoNHncL8YmEUx5NKg
   T51pxvYFLu1tUVAU4DSgy9KDEAWEvSrB2JtIecoNlGToNymySoC1lSbOf
   4777scFpKVQGmX3YqyGLvuD6BNqeaJN51vGf2Gn+DfgfqbnH18eDK3s99
   A==;
IronPort-SDR: RvAJnvaO8m8cdFmG/3ImMEzxHkbbN8HR9VpV9Njb78jnlN/p3xJqiixc8wi63QDcEl15T36lMG
 k3ZDKbJm5Ubsn2rx3poZdTje0gtI4yPpxDW3FfNR46aP+IgyuD0wif3OwxR+tOkYz2Ck1anIbd
 1b45doyga8gwT4rf+8B1GwNdjBbIaUGr4ht0y946npZXOXxHF98j3R9sxCKAjsoXKNcJDRnL2D
 aEr2R3/LI3Illk4cmRPpxMf7BmFUeW5nY52Qr1iG3elyjrfE+ogfreJaRzmqpT4qmsbyf7DQq/
 4qs=
X-IronPort-AV: E=Sophos;i="5.84,239,1620716400"; 
   d="scan'208";a="135875340"
Received: from f5out.microchip.com (HELO smtp.microsemi.com) ([198.175.253.81])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2021 11:28:48 -0700
Received: from AUSMBX1.microsemi.net (10.10.76.217) by AVMBX1.microsemi.net
 (10.10.46.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Jul
 2021 11:28:47 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by ausmbx1.microsemi.net
 (10.10.76.217) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 14 Jul 2021 11:28:47 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 5956C703469; Wed, 14 Jul 2021 13:28:47 -0500 (CDT)
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
Subject: [smartpqi updates V3 PATCH 8/9] smartpqi: fix isr accessing uninitialized data
Date:   Wed, 14 Jul 2021 13:28:46 -0500
Message-ID: <20210714182847.50360-9-don.brace@microchip.com>
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

Correct driver's ISR accessing a data structure member
that has not been fully initialized during driver
initialization.
  - The pqi queue groups can have uninitialized members
    when an interrupt fires. This has not resulted in
    any driver crashes. This was found during our own
    internal testing. No bugs were ever filed.

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index f0e84354f782..ab1c9c483478 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7760,11 +7760,11 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 
 	pqi_init_operational_queues(ctrl_info);
 
-	rc = pqi_request_irqs(ctrl_info);
+	rc = pqi_create_queues(ctrl_info);
 	if (rc)
 		return rc;
 
-	rc = pqi_create_queues(ctrl_info);
+	rc = pqi_request_irqs(ctrl_info);
 	if (rc)
 		return rc;
 
-- 
2.28.0.rc1.9.ge7ae437ac1

