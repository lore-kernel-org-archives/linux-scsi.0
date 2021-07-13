Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C11C11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC1706115B
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235821AbhGMVFl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 17:05:41 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:8300 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235545AbhGMVFf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 17:05:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626210165; x=1657746165;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YCU1lNbnN3QiScgV4I4qmlBlxDGRHX9C+VP7ZGwbfYg=;
  b=pisslaDmmA7ROmT7kCGx/w0VZ2aQOnowOnwoQhMyWBzwcXEioeqz1vdW
   e8CeV8NTZU6qhGTVlXdZQ5q7AzDRKVFy28KmCd2iRXe9Wfuzn/v+xW7Wp
   or1vwKGlpJyUVgXKxcHkrslctIX8nqATe2fQ6I8XI/9SJVXjGIZwJilnS
   7hXUhLYImsyCdXqUOuTmYgsVNV05m5zmWVTqAiw3L092PoQ4RvXENBWC3
   S+SMkefWCTdCOLsxT043/gvHTLiLc/FxrboTlr0qm6f7dQ+FCJ3J011KK
   T8iAWh1FeT3DN6W/O1lrXAqx0c31/Wop/E09uaN+yDZ92KI7zbT/QA8Eq
   g==;
IronPort-SDR: 5ni/sRww5tZghr+xVpS/r2c7ExmTKUt4lrY4IDXe6EMQAGhqOjVGsipd/4nyqCUw3iUNYSrsJf
 G7E+0H4HV4r0PTjDVXEDAyig2/Wti4FGRuFOLlUQh53ahTB4/5SwozXTcyYj8FGHPS3VTv290n
 fuMHY/7bueWscMHkUGsNmtHgI2gdYrRjZun6i1VSUOMEHQlwdqxzPi4HxYeWAvhGKX6J37W+Mg
 OATm+3q8nr/cFOQ4LlVq7eRc/Ru2bqopzb8hDofJPg8cweUPPzj5ENAsUme1TNBwVYSi9nOIio
 EC8=
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="121925990"
Received: from f5out.microchip.com (HELO smtp.microsemi.com) ([198.175.253.81])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jul 2021 14:02:44 -0700
Received: from AUSMBX1.microsemi.net (10.10.76.217) by AVMBX2.microsemi.net
 (10.10.46.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 13 Jul
 2021 14:02:43 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by ausmbx1.microsemi.net
 (10.10.76.217) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 13 Jul 2021 14:02:43 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 917F0703519; Tue, 13 Jul 2021 16:02:43 -0500 (CDT)
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
Subject: [smartpqi updates V2 PATCH 8/9] smartpqi: fix isr accessing uninitialized data
Date:   Tue, 13 Jul 2021 16:02:42 -0500
Message-ID: <20210713210243.40594-9-don.brace@microchip.com>
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

