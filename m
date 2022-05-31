Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D837FC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 17:52:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346698AbiEaRwo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 13:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346699AbiEaRwk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 13:52:40 -0400
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 May 2022 10:52:38 PDT
Received: from esa.hc4959-67.iphmx.com (esa.hc4959-67.iphmx.com [139.138.35.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E18A63BCC;
        Tue, 31 May 2022 10:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=seagate.com; i=@seagate.com; q=dns/txt; s=stxiport;
  t=1654019558; x=1685555558;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FEmyW6/boFQyTIeb8pc/UKKAg9Kqu1+J0zJ28RZGNmY=;
  b=ZdhtvZ4pmFqPs0gIry2dSJibZTQbCxDwlCJP6Qe5uvN/A3LfaBybq7gQ
   Ick6KGOn7+/CSiFkqd+HTwUWMsBdmpXB7BuWBjcGESvCX+9y3a3+9HWhr
   kWKLafq1Y8djkma53gZsaMGtXFteVNXVZCjdP9jOLXvnbtGJjRjOvVZA4
   Y=;
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hc4959-67.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 10:51:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMbj4Fk9+L/RCeDd3QENrew4wewWUe3kxvXpfpzlSVJMO7Zpaz4R35x8RgeDcF5cBQt69kPfsWEWuLDFec+jzM8+LjXe+qghhE3g4NjqC6nrRJQgKn8tER/pbGhhv6D0+MkcTdfZmSkHMG4+35Lykx2gy3+o18zPn7IK8MSCOWZKCViizx50QtrcFanU0X6ch17lv2xDUq2eIU/0TkVWky26Z3JhVjWRUfVHtXFGjjyP0AbK0kXYhebXABIUuzO1C8iWHSkudlik+Idk5tXZ25a8m9ug9GfM1po0VsjPJ9ahJwRV952RnxBHG8CGemZuZoTBYIr2qLPopLi/LG4Spw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ss2JPsQChgHptBQ4bSJWQwKOXNkwjnHRq/y/iZXp+Kw=;
 b=gFDb2n8by+2Z3wOCrqxeSJ0rlgnOPzwnGd++GdhM0XCMX8TrqvKQdxMsQgUzq4sJf59Zs/awRx8ResfVXxswfUnYAw6aSFOSmKhcWKLU3H64ts6lcqLDsz8jUcncLJgCYUMaEIMYozKEeXBZoBsR5cptEM1CnIT4a1N6ygCkkIt15z3NNA3vP05jXm5IJtuVzQPAax/gHV+Zetk+UUsLCr19yidJwX82/ofEVusR8fsAfjpiex9WMVRBAjKHWGi5r7TnkVziZGp588t7uaNYvcSLoVVGHslaPmoeIddZqHhTrwFlZxHdPBkyH54DOq639JcgtdUrInIIppleXUAGpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 192.55.16.50) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=seagate.com;
 dmarc=fail (p=reject sp=reject pct=100) action=oreject
 header.from=seagate.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ss2JPsQChgHptBQ4bSJWQwKOXNkwjnHRq/y/iZXp+Kw=;
 b=WkncAmm1C6mbCsRhAJvARRqRs8VLSaQh1rXLKgaI7+UIWpad9bGcVaw6ltSUP9KHl3VtIN6seuSr2zSbliOrpQiV7vkkrHXgHqnjDv7lhh2ut+VQqTG81Req9U695UKR5kWTqZpZ8amGi0n5KgVCQsOapF710jA1zHCcaKT7Ric=
Received: from CO2PR04CA0133.namprd04.prod.outlook.com (2603:10b6:104::11) by
 SA0PR20MB3341.namprd20.prod.outlook.com (2603:10b6:806:72::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.19; Tue, 31 May 2022 17:51:32 +0000
Received: from MW2NAM10FT050.eop-nam10.prod.protection.outlook.com
 (2603:10b6:104:0:cafe::f2) by CO2PR04CA0133.outlook.office365.com
 (2603:10b6:104::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12 via Frontend
 Transport; Tue, 31 May 2022 17:51:32 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is 192.55.16.50)
 smtp.mailfrom=seagate.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=seagate.com;
Received: from sgspzesaa001.seagate.com (192.55.16.50) by
 MW2NAM10FT050.mail.protection.outlook.com (10.13.155.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12 via Frontend Transport; Tue, 31 May 2022 17:51:31 +0000
Received: from sgspiesaa001.seagate.com ([10.4.144.52])
  by sgspzesaa001.seagate.com with ESMTP; 31 May 2022 10:51:51 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="63170342"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
STX-Internal-Mailhost: TRUE
Received: from unknown (HELO COL-U500816L003.ad.seagate.com) ([10.4.50.11])
  by sgspiesaa001.seagate.com with ESMTP; 31 May 2022 10:44:27 -0700
From:   Tyler Erickson <tyler.erickson@seagate.com>
To:     damien.lemoal@opensource.wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com, tyler.erickson@seagate.com,
        Michael English <michael.english@seagate.com>
Subject: [PATCH 2/2] [PATCH v1 2/2] sd: Fixing interpretation of VPD B9h length
Date:   Tue, 31 May 2022 11:50:09 -0600
Message-Id: <20220531175009.850-3-tyler.erickson@seagate.com>
X-Mailer: git-send-email 2.36.0.windows.1
In-Reply-To: <20220531175009.850-1-tyler.erickson@seagate.com>
References: <20220531175009.850-1-tyler.erickson@seagate.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: c7b49cdb-f5aa-4ebf-1333-08da432e329f
X-MS-TrafficTypeDiagnostic: SA0PR20MB3341:EE_
X-Microsoft-Antispam-PRVS: <SA0PR20MB3341E013D06F7C17BD02725789DC9@SA0PR20MB3341.namprd20.prod.outlook.com>
STX-Hosted-IronPort-Oubound: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yv7RUtFGoZf/nbBEos/ENCegXr3xLoQmANVEa6tRdywmGGcfdb3LnNkwKfxUsYbr0nLpgxm7Zm9XLOe6pKJfX+8mQO4sQp9q40XrwaM12On2u1VDX6ocp4pa/rkqFOfHnLEcck2uX8ysGIvo0bR/S4g5jc/LlCszVGqiDJEGeM+yqwAOK4dDFwFi2zBoGDCzoCbmWg9TbvRKrz7p5YJfDOXAHRwYOHNFDIP5NELmW3vTpLnpVF54euq+5ik0GKG2bfYkL0lT/tKfI368DGHIxmJSueFNJ6Gq1xy31P2ICo2ZmvHcGc31AsQ4Ns5VDhAm7Lg0a7z2S3Z2c35fhB01MqdccTX55uCfwyOhu2sH5KeuoSDNJ/5zup3khDzS/t7FjTPnDNWQPZC+AQ3jS4eQUqeS2tJBxIO4qr+pf+yeQghtWlzZTeCkGgV7afLIXupefqlLF1J0g/07MdwAkSb0VOxuhaaXWzZlC/QCfjFBmp59i2emybqCRft6pPhHKYeRK1PEve83vFAUMwWOPREJbosS6ia1tShBfB5NUUIAzVKZhSCvpg0ItixCXXCLLsZ9gBk3/MEMFpedunXaJ+f17/rEf1sAhG9K8xOxM4brISAE+nvX0Ge0x6smIhz54p4KeujBxyZM42bpos/bGEfXFBZFwWmiDJL76L0rT/gOcSrvO5A3WKjJQa+hZP1Ex/ZeNJLDaIrG4bHSCuleEIgWqw==
X-Forefront-Antispam-Report: CIP:192.55.16.50;CTRY:SG;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sgspzesaa001.seagate.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(46966006)(40470700004)(36840700001)(86362001)(8676002)(4326008)(6666004)(450100002)(70586007)(81166007)(356005)(70206006)(508600001)(316002)(336012)(36860700001)(426003)(1076003)(107886003)(47076005)(186003)(7696005)(26005)(40460700003)(2616005)(44832011)(8936002)(2906002)(82310400005)(5660300002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: seagate.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 17:51:31.5064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7b49cdb-f5aa-4ebf-1333-08da432e329f
X-MS-Exchange-CrossTenant-Id: d466216a-c643-434a-9c2e-057448c17cbe
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d466216a-c643-434a-9c2e-057448c17cbe;Ip=[192.55.16.50];Helo=[sgspzesaa001.seagate.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM10FT050.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR20MB3341
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixing the interpretation of the length of the B9h VPD page
(concurrent positioning ranges). Adding 4 is necessary as
the first 4 bytes of the page is the header with page number
and length information. Adding 3 was likely a misinterpretation
of the SBC-5 specification which sets all offsets starting at zero.

This fixes the error in dmesg:
[ 9.014456] sd 1:0:0:0: [sda] Invalid Concurrent Positioning Ranges VPD page

Signed-off-by: Tyler Erickson <tyler.erickson@seagate.com>
Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
Tested-by: Michael English <michael.english@seagate.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dc6e55761fd1..14867e8cd687 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3067,7 +3067,7 @@ static void sd_read_cpr(struct scsi_disk *sdkp)
 		goto out;
 
 	/* We must have at least a 64B header and one 32B range descriptor */
-	vpd_len = get_unaligned_be16(&buffer[2]) + 3;
+	vpd_len = get_unaligned_be16(&buffer[2]) + 4;
 	if (vpd_len > buf_len || vpd_len < 64 + 32 || (vpd_len & 31)) {
 		sd_printk(KERN_ERR, sdkp,
 			  "Invalid Concurrent Positioning Ranges VPD page\n");
-- 
2.25.1

