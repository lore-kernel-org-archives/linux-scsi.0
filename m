Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 051B9C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 22:46:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239738AbiFBWqD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jun 2022 18:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237041AbiFBWqC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2022 18:46:02 -0400
Received: from esa.hc4959-67.iphmx.com (esa.hc4959-67.iphmx.com [139.138.35.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465ED344D3;
        Thu,  2 Jun 2022 15:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=seagate.com; i=@seagate.com; q=dns/txt; s=stxiport;
  t=1654209961; x=1685745961;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=OvYfV4KBsfweQ9t7i1V+hQSHTXoBitwN8bBZ/Gs/TzY=;
  b=rNOzI526W06kMrmnu8+WTuPMiddG584FTJPYpoiJCePNK69jsB8xNQ5O
   BOM4hBK0WCAciyKo7QbrndF7g8r+pkao8aoEVbRDJl7YnHZ30m7d7oqBg
   O6Cas04MfN5yBkIAQm6c1ILzP42ggJyFZG/N2ETN87P5JJW4y3DOCk5Qs
   Y=;
Received: from mail-bn8nam04lp2040.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.40])
  by ob1.hc4959-67.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 15:45:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCaYl5m02W0kuIn89Je0amURQwd5Ah/tMMVJ3MDBmHibE+bGDLJ0yTWUf1nAM3UgSuV9MHo9y4OuI8KEx4mFcx+LeO0wMsqTq7kZsZxo5srCX+eTN8P+9FZZPyQLkpe5YKws/PZn6XF6lHHXIaonNPgSnkGT32lJhLFKNc5MHzdzKkIc+Mb6EcEHizMUPL1ZpinZOfpGr2IvhR+ZCdGMkiJb+boR2S9EN+nomtFDsmkMNPn7PrqwWM9SOWaJ1u9XCvHn4o/6UDWy4z92wEaUDt/VhsJIDE2UiBCvFKr30lx2ljbqTiMI7egoW4URUIQR/1U+HKkO+ySnAqSYUnp61Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=imlVvGS984rlhIW9reTser89ku7OpBGjPj8D3a3Jaso=;
 b=XxPep0i/St3/ApWiXqKhgYMRCMG9TafPn2YED8rrtpfQFJaQtFlSFnCHKP1fn9CauUHPEzz0y4ya/3z+wpjApJnkC23MBjsUYt1NQhGiRBYKr4ensJqDSQ4ZF6jeoh6jhZovaxm66zHAhMl3tEfSv/hMNnUr82uppl4ksejXeZsas0Q6+jX/iHGR2B9uzX1Kg7EsG4HEqtJPOSXr9JYTRzcL7BmBPGvUyCityIKPdqWX46adKeiFIPhQ2uiXqxRbJymUyaG268eldyIuGIX3FZRuZtym/Jo4pSm4wMjiVEORxVc5ZPyAPDD0rc1fRD0k3E1TUdUa7nUxgJg8Salvyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 192.55.16.51) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=seagate.com;
 dmarc=fail (p=reject sp=reject pct=100) action=oreject
 header.from=seagate.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imlVvGS984rlhIW9reTser89ku7OpBGjPj8D3a3Jaso=;
 b=IX4nlcHwrI+rIMY4jANj3mpeLKHE47KwHaoW6KNBGnD44OzTDv8SKqFne4bXD1Tp0xSkXidROr2/XpBLo+aNC3WmyCZPn6eHKu3RLYeMq92vkVhxDaGv9Uw7AkWa/JqGlTx77AYbsoer0iD5sXXu4O706/g63TYd/seScKwWaiw=
Received: from DM6PR02CA0135.namprd02.prod.outlook.com (2603:10b6:5:1b4::37)
 by SA0PR20MB3341.namprd20.prod.outlook.com (2603:10b6:806:72::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 22:45:58 +0000
Received: from DM6NAM10FT031.eop-nam10.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::50) by DM6PR02CA0135.outlook.office365.com
 (2603:10b6:5:1b4::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12 via Frontend
 Transport; Thu, 2 Jun 2022 22:45:58 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is 192.55.16.51)
 smtp.mailfrom=seagate.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=seagate.com;
Received: from sgspzesaa002.seagate.com (192.55.16.51) by
 DM6NAM10FT031.mail.protection.outlook.com (10.13.152.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12 via Frontend Transport; Thu, 2 Jun 2022 22:45:56 +0000
Received: from sgspiesaa002.seagate.com ([10.4.144.53])
  by sgspzesaa002.seagate.com with ESMTP; 02 Jun 2022 15:48:31 -0700
X-IronPort-AV: E=Sophos;i="5.91,272,1647327600"; 
   d="scan'208";a="62195110"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
STX-Internal-Mailhost: TRUE
Received: from unknown (HELO tyler-ubuntu.colo.seagate.com) ([10.4.50.15])
  by sgspiesaa002.seagate.com with ESMTP; 02 Jun 2022 15:33:27 -0700
From:   Tyler Erickson <tyler.erickson@seagate.com>
To:     damien.lemoal@opensource.wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com, tyler.erickson@seagate.com
Subject: [PATCH v2 0/3] ata,sd: Fix reading concurrent positioning ranges
Date:   Thu,  2 Jun 2022 16:51:10 -0600
Message-Id: <20220602225113.10218-1-tyler.erickson@seagate.com>
X-Mailer: git-send-email 2.17.1
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 81dbb009-eaab-4d96-69bb-08da44e9a8fa
X-MS-TrafficTypeDiagnostic: SA0PR20MB3341:EE_
X-Microsoft-Antispam-PRVS: <SA0PR20MB334121DF1C95728E2DD9964289DE9@SA0PR20MB3341.namprd20.prod.outlook.com>
STX-Hosted-IronPort-Oubound: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9nempM2CJhLo5Deod6nNIM11L62mpYqYHG8en/bbUGgqWLqGK6i21+V1AfPkza+mzYGaZUF1UlUWgfi1t48K6Of3bbwtdDE0nIF7qtFoI6owU1CYKaHrmKOkSVGvum8ATtCechK1aPdEuzKdaLaKFtAze/4RYQoHFgMCvcu8cTQDA7iKfEnjRbkhiE8jej4lCiAc8Ahx/VEmeWnDbCPFY+JM/O8RrSIaHuY5t2adYLA2bDOxXzcH97SlMVyE2cGQQfIkKgIsIg1NglsNapdN6yc1fPUxltq7l7eK1ztNj1uw5aZEK3fIa+vth7bRwkykmBFaZAbR8cdqihfyvGHU3CHNp778g11TAsoT2QRf40Dx32L9uVcMR74c2ebqf8yrXnxM4OlothLifWncZgAB2AZbJzsVKyBBinzBrbZgrwNlfthP6Zt4G7bCRFNREFzedaScS0+JzjzHZTYS7q8DK6DaQKWyXXb9aJfxG85I82XsDxpX2OUzOOoOzpmPGwO1PAGW53BEbSNJB+77szugyeRFty945XiCPCEpGcEX0f24F253RmpxmAvqvcfJpoc33dwN17FJYclbzq/Yi2oAfSOxq5wKIcMrMcsAaVrvx5iAdgYpPO87nxyvOH/IpK7d6rYYvd8OPZ5pwPPajh12f2lv1H3Ml3bIC52hRg51hrxDf7w2q+eizTegxp4zx0Dweq5noWWQnt9tUAOeTBuHRA==
X-Forefront-Antispam-Report: CIP:192.55.16.51;CTRY:SG;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sgspzesaa002.seagate.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(36840700001)(40470700004)(46966006)(26005)(44832011)(8936002)(2906002)(83380400001)(450100002)(47076005)(36756003)(4326008)(82310400005)(81166007)(8676002)(5660300002)(70586007)(70206006)(186003)(336012)(316002)(107886003)(86362001)(36860700001)(426003)(356005)(2616005)(508600001)(6666004)(7696005)(1076003)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: seagate.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 22:45:56.9243
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81dbb009-eaab-4d96-69bb-08da44e9a8fa
X-MS-Exchange-CrossTenant-Id: d466216a-c643-434a-9c2e-057448c17cbe
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d466216a-c643-434a-9c2e-057448c17cbe;Ip=[192.55.16.51];Helo=[sgspzesaa002.seagate.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM10FT031.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR20MB3341
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series fixes reading the concurrent positioning ranges.

The first patch fixes reading this in libata, where it was reading
more data than a drive necessarily supports, resulting in a 
command abort. 

The second patch fixes the SCSI translated data to put the VPD page
length in the correct starting byte.

The third patch in sd, the fix is adding 4 instead of 3 for the header
length. Using 3 will always result in an error and was likely used
incorrectly as T10 specifications list all tables starting at byte 0,
and byte 3 is the page length, which would mean there are 4 total
bytes before the remaining data that contains the ranges and other
information.

Tyler Erickson (3):
  libata: fix reading concurrent positioning ranges log
  libata: fix translation of concurrent positioning ranges
  scsi: sd: Fix interpretation of VPD B9h length

 drivers/ata/libata-core.c | 21 +++++++++++++--------
 drivers/ata/libata-scsi.c |  2 +-
 drivers/scsi/sd.c         |  2 +-
 3 files changed, 15 insertions(+), 10 deletions(-)


base-commit: 700170bf6b4d773e328fa54ebb70ba444007c702
-- 
2.17.1

