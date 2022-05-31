Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 542E6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 17:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239789AbiEaRwl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 13:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346698AbiEaRwd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 13:52:33 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 May 2022 10:52:32 PDT
Received: from esa.hc4959-67.iphmx.com (esa.hc4959-67.iphmx.com [216.71.153.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654F95BE65;
        Tue, 31 May 2022 10:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=seagate.com; i=@seagate.com; q=dns/txt; s=stxiport;
  t=1654019552; x=1685555552;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GbN3L71MpgJGmm3dULdhJiSFt9GSMZiq4yWrKPCs+8w=;
  b=HSghhnA59nB5gbSJt/0GRpeQpucgd2RZkIFWPzkXk0PmVix8ipcIXVGT
   lcN3ZQaMxlfHKZD+BOJErSYE4fU5Ey0dukMIum3/hJwQISstQVzPa2VyJ
   ScelDUogKGnNcV+72qfsMjpLG2NJqG7ixqXRZ+Ey+bET3PvpjRIYM+ZbF
   o=;
Received: from mail-dm6nam08lp2042.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.42])
  by ob1.hc4959-67.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 10:51:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgEYBzn2q5pK0iEgXTFxQohVL+L4QY9pl9uFEb0BV3ctDYjvUU/ALsbcAvZi4S+9WlQ8XviJIMy2soRaeWyx6NENmkQ6rRDgg09h2k3kudU6dGmmlj3e+M9cgfNEkMs8+/w0Dxe/vVNo+5eUf9OoA1f/WWXBtSG737BRj3UevXt2VQfEBlx1rimJgArz6tTza6Qk66gsi9e6Qas0a94fHpHMH2k+GOfW5RlWM17E7Kz7Fp2FKmT1vysOZN933GgozshE24hvhhThePNaxhZjlhuEaEh6G2atQx8oobCrERcENGLUWZMUCg+hPctuMFWrY1kUfIBLxW04Pl6Eqc428Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RRLj6wKCiSiFFKSLBFnw8fyjcuglBJHxeBxUBBhFpG8=;
 b=cN6Ek57WO+iM8X6gPunL9BhHgx3cvw51JJzrPvo8TGalWc4u4on02ZGN3Zuid/gGdAeSE9FFsdqnzuHmPD/gci6gjQB6J1lXv/gUjoHXqW6BDkwx2Uz4qsdxt70iJRpKP+Nrct+aJ+nKyD1YCBeuXze5VEJLxRQaLC7Pxd6EBJfwQUU/5R/X27dVHF1SLiKRagYFbrzfcMkkvLUtYRcWw6JiJvSd7LThZX/oZpMJB3lCxLEpIDPk7Nvrlj0DjzMbb6jFXXXdCHwnTRYZFM8TWY5edfqXg9SkHCjYAaS3wtZrBELZcLAR3WSREpGX2/mCV9wvhhRqaDjD/ok6YfejbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 192.55.16.50) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=seagate.com;
 dmarc=fail (p=reject sp=reject pct=100) action=oreject
 header.from=seagate.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRLj6wKCiSiFFKSLBFnw8fyjcuglBJHxeBxUBBhFpG8=;
 b=LSgFHVNXxDbD5ZQW+C/SwSIslAvi1SSboT0b5VZbHehSxatyoAYNF36ECODUwMs8XqqXuIsxsk/jCWCPcxrEVg3oCOweaOGd0QDbVkfJO0lUAOmFJT9+zzcaFV6s5tqHqX+8AvtlNSuDMSAXhWfu+KR4LWL88ls2i9Xql51bX+k=
Received: from CO2PR04CA0141.namprd04.prod.outlook.com (2603:10b6:104::19) by
 DS7PR20MB4782.namprd20.prod.outlook.com (2603:10b6:8:9a::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12; Tue, 31 May 2022 17:51:27 +0000
Received: from MW2NAM10FT050.eop-nam10.prod.protection.outlook.com
 (2603:10b6:104:0:cafe::6c) by CO2PR04CA0141.outlook.office365.com
 (2603:10b6:104::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12 via Frontend
 Transport; Tue, 31 May 2022 17:51:27 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is 192.55.16.50)
 smtp.mailfrom=seagate.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=seagate.com;
Received: from sgspzesaa001.seagate.com (192.55.16.50) by
 MW2NAM10FT050.mail.protection.outlook.com (10.13.155.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12 via Frontend Transport; Tue, 31 May 2022 17:51:26 +0000
Received: from sgspiesaa001.seagate.com ([10.4.144.52])
  by sgspzesaa001.seagate.com with ESMTP; 31 May 2022 10:51:44 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="63170335"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
STX-Internal-Mailhost: TRUE
Received: from unknown (HELO COL-U500816L003.ad.seagate.com) ([10.4.50.11])
  by sgspiesaa001.seagate.com with ESMTP; 31 May 2022 10:44:20 -0700
From:   Tyler Erickson <tyler.erickson@seagate.com>
To:     damien.lemoal@opensource.wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com, tyler.erickson@seagate.com
Subject: [PATCH 0/2] ata,sd: Fix reading concurrent positioning ranges
Date:   Tue, 31 May 2022 11:50:07 -0600
Message-Id: <20220531175009.850-1-tyler.erickson@seagate.com>
X-Mailer: git-send-email 2.36.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 6a9cd91b-3a7b-4871-916a-08da432e2f87
X-MS-TrafficTypeDiagnostic: DS7PR20MB4782:EE_
X-Microsoft-Antispam-PRVS: <DS7PR20MB4782822830A28FE432E6613589DC9@DS7PR20MB4782.namprd20.prod.outlook.com>
STX-Hosted-IronPort-Oubound: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KptogStZJYhi3VYJs27a8H9Z+dXEGC+DisQHvqkLAGdUrqpZL9z3iJwYPEZ2Qm3Y45jOmcnZMlcXy4zcy+ivj9dbgntis1qf0JNuTCaVUDQIPSA8ZjQxvjlNT1VJ5N5nUDI9Bc0JX1PhcLlkofKe/sykGlM2DCFw+UqLoD2uIlEWXXvM59a/fS2OE9BzTUUxAxYxRFgbvfi1mFz02P1am6g0VVbKThA6q9dH1KXWnpTayIt4eGqlU+33pQqWxlOFNcUS1Ko+lIa99BAK/xCTABbCVG7X50p5BAqzSZ8hobGQh5/5TmP0WyYdQvHh2wJy8QqfO/WVhGl/AzqVmvpwh4UF7VhfKZPVnPmdKWWAvFOccu4daUJNvNaCR1a0S7ih3uPQrlbki8kaG/a5byGVmxAsY1LuriKsSyKF2bIlcnDVPW7F9ciWgSIU/Uvt9MN9q0q7PebEme4uRbsQ/cldxf0icqtSNY+A8ZS8cSBh53n/jbEW/8O2QcSegeEsQKA1NO1sNzgIo4iJIGXqSwgcfZKfqh7EJ25ef9s+W/0eFbHoTNP8rgYETcdAZUUJErqyqblSP/iAqeAX3+WiASTcr1L0Z/GInHCeyXvckFAXgLrF7rCWs1Y+WgHkTpnnmf8alV1N7BViW4jL6hCg/kHBTKoc6Zo4mYBicDT8c0q8paBPTRQFyCrv3K6bTkgDHHhnE3Dhp8pdWT2htzUHp8tW3w==
X-Forefront-Antispam-Report: CIP:192.55.16.50;CTRY:SG;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sgspzesaa001.seagate.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(40470700004)(46966006)(36840700001)(8676002)(316002)(450100002)(70586007)(186003)(107886003)(8936002)(4744005)(81166007)(36860700001)(2616005)(86362001)(83380400001)(426003)(5660300002)(40460700003)(26005)(356005)(70206006)(4326008)(336012)(44832011)(82310400005)(7696005)(6666004)(47076005)(1076003)(36756003)(508600001)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: seagate.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 17:51:26.3036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9cd91b-3a7b-4871-916a-08da432e2f87
X-MS-Exchange-CrossTenant-Id: d466216a-c643-434a-9c2e-057448c17cbe
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d466216a-c643-434a-9c2e-057448c17cbe;Ip=[192.55.16.50];Helo=[sgspzesaa001.seagate.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM10FT050.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR20MB4782
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series fixes reading the concurrent positioning ranges.

The first patch fixes reading this in libata, where it was reading
more data than a drive necessarily supports, resulting in a 
command abort. There was also a change to the SCSI translated
data to put the VPD page length in the correct starting byte.

In sd, the fix is adding 4 instead of 3 for the header length.
Using 3 will always result in an error and was likely used incorrectly
as T10 specifications list all tables starting at byte 0, and byte 3 is
the page length, which would mean there are 4 total bytes before the
remaining data that contains the ranges and other information.

Tyler Erickson (2):
  libata: fix reading concurrent positioning ranges log
  sd: Fixing interpretation of VPD B9h length

 drivers/ata/libata-core.c | 21 +++++++++++++--------
 drivers/ata/libata-scsi.c |  2 +-
 drivers/scsi/sd.c         |  2 +-
 3 files changed, 15 insertions(+), 10 deletions(-)


base-commit: af2d861d4cd2a4da5137f795ee3509e6f944a25b
-- 
2.25.1

