Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1F5C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jun 2022 22:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237753AbiFBWqO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jun 2022 18:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239742AbiFBWqG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jun 2022 18:46:06 -0400
Received: from esa.hc4959-67.iphmx.com (esa.hc4959-67.iphmx.com [216.71.153.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B973F37A82;
        Thu,  2 Jun 2022 15:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=seagate.com; i=@seagate.com; q=dns/txt; s=stxiport;
  t=1654209965; x=1685745965;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=eb7xTJtCIh8JPBdgQmEpvQXXnwnVATmYzvJbreqvvl4=;
  b=rLk4t/T3sm1Ne/d/DwIxCLQC/4VwyqzQhC0MpJiIxazImoFGLYYQ97Xf
   45Jqa5FvZo1hfVOBwSFXLndOD8joRbg24kAIY1v4qg2bi82bI9bZzyv1Y
   y78+lwOPQuOH5oqninXmh9EzMrXR7eWAf5CZMRc4nsRi3KehLgr8ySRSM
   4=;
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.176])
  by ob1.hc4959-67.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 15:46:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4vyxH2FxCTpwToI3WXnPvo/PvXoV/22jDKuU64KrmidIoYvGigjzZoQVA/5uLKBvys8GYSxzRCMxdBvdm3vgf2K6mA4pI/Ax3YYvnwaJUdIm70OwoBi4bO/jsg02sCzLeuHg9m8OeJCjAEI1yMwLydeU5MxiDCfHOttXIZ+PaUfpS9QwGM+J3O9SIhbgbwmV9/j1hTFdhqjo5KJTXwOwML4yXWi/GdqfymeAeQEGp2fsTsz5bUVhEpeGaveMi/UwBgeB5rlOlwh5nlcD7cUXipFZQwkTwOevqoRuNXTSeGwRY3vVnKdEZwCyTF1S+S/5Xln4HAvjn1SWWewVR8aBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D9GUDTiACZXCvJ9iUr/A4XfNXj3+i2pVZVsHdx17j3U=;
 b=oClFm5xDkJfI9Rqk1hY6VfS144O6S5T+E8rllxk78D/MacZ2uSe9bzt02falgWroHitfpu4deR04KRTgp2i4gJdsVoqy21Lsu9PvryY1Cu+zjnjS0Zpg0VUDZRFnE9n1ahthXhSYuIatVSEhGo5rX68FNTRLYPnRVLGCNTHzwS4EzeKQUT+3t3cc0Qw/RuQ/wOu/RBOFy6xx6MkUbBWjnJm5JUw0QO/H8eCHHQjofY9rRgwsBCbz1eFVDohCDWO+PkyVtM+p1dgyxir6PKpPI1wrSzpHKr41ZdHUr5qhmvw0BDDoEO/qGoqc7sccG/0uga40sp0WjWqm7BN+3UnGRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 192.55.16.51) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=seagate.com;
 dmarc=fail (p=reject sp=reject pct=100) action=oreject
 header.from=seagate.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9GUDTiACZXCvJ9iUr/A4XfNXj3+i2pVZVsHdx17j3U=;
 b=hKzGPlr6XMPRadk6E/Yd0Z8+Z4lUgW+ZGJWRkKt/3qDS8vbgePcf/qBvY4BarPouzWGUxkUDCjlj0pTVdIeXhBjkzFV+Qoi6Pw3Hb7jg9zTrWaPSQiMp7v6bCaVoGYwMjofjVPB8ZNAenDaZcdrWQnsVs5NtpihrRs5c795KgWc=
Received: from DM3PR12CA0104.namprd12.prod.outlook.com (2603:10b6:0:55::24) by
 BN0PR20MB4087.namprd20.prod.outlook.com (2603:10b6:408:12d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.13; Thu, 2 Jun 2022 22:46:01 +0000
Received: from DM6NAM10FT049.eop-nam10.prod.protection.outlook.com
 (2603:10b6:0:55:cafe::18) by DM3PR12CA0104.outlook.office365.com
 (2603:10b6:0:55::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12 via Frontend
 Transport; Thu, 2 Jun 2022 22:46:01 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is 192.55.16.51)
 smtp.mailfrom=seagate.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=seagate.com;
Received: from sgspzesaa002.seagate.com (192.55.16.51) by
 DM6NAM10FT049.mail.protection.outlook.com (10.13.153.121) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12 via Frontend Transport; Thu, 2 Jun 2022 22:46:00 +0000
Received: from sgspiesaa002.seagate.com ([10.4.144.53])
  by sgspzesaa002.seagate.com with ESMTP; 02 Jun 2022 15:48:36 -0700
X-IronPort-AV: E=Sophos;i="5.91,272,1647327600"; 
   d="scan'208";a="62195121"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
STX-Internal-Mailhost: TRUE
Received: from unknown (HELO tyler-ubuntu.colo.seagate.com) ([10.4.50.15])
  by sgspiesaa002.seagate.com with ESMTP; 02 Jun 2022 15:33:32 -0700
From:   Tyler Erickson <tyler.erickson@seagate.com>
To:     damien.lemoal@opensource.wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com, tyler.erickson@seagate.com,
        stable@vger.kernel.org
Subject: [PATCH v2 2/3] libata: fix translation of concurrent positioning ranges
Date:   Thu,  2 Jun 2022 16:51:12 -0600
Message-Id: <20220602225113.10218-3-tyler.erickson@seagate.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220602225113.10218-1-tyler.erickson@seagate.com>
References: <20220602225113.10218-1-tyler.erickson@seagate.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
MIME-Version: 1.0
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: c6e41293-1905-42cc-c9b9-08da44e9ab03
X-MS-TrafficTypeDiagnostic: BN0PR20MB4087:EE_
X-Microsoft-Antispam-PRVS: <BN0PR20MB4087919F149D50E42F950B7E89DE9@BN0PR20MB4087.namprd20.prod.outlook.com>
STX-Hosted-IronPort-Oubound: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lonApMpQL2yGrPXhLGs/UjX5F+Q66kWsN3a2oG5idNbBfStzkdYKZ2Sim4xY3WBqTCfK/xmi8nz+VTQXqLi7MJ3mJSFCvJqUPlKtwoNuP6gOrb0pN4nvtPTGvgI49AjS5oGCsvAMRVe+RPUdwWwWzNdVCTFOMMQ5hTydJoWJ3S2mrL6t9mJHcdL9i0ZWrEFUzHHoqapC4cIpxvy41Ex910TjffcGNuBvps8jdQoz4MvCr/rUwblZ2i46Cr/OSSHV4IDfEuvnWp7QHZQITiE8932iLZXgkL5moG8aigosWmAm9OU/a1Glxs1p74CFUVIKdKMcyjpEqdH1Al8aQ34xSt70Z5jyJOgXhG/eB0udtJw+ykXZdFWlgpVKIPswLDqDO+MR+ECKSpxApVne08S1ywPjmrZt8NJ/DsPZDnjpPlRz2E0y9qH5O0A/wKZ4KppoDuV3sSLD//SYpWF0GPYBInuIHjU9NglmKitjdB1m+H+1Q1Z0C8Kyn6C/2yC+U9iJUHB2njfEV/KBn28PuzpM1zF8hGeGlAF3W+g4ZLj3U6HeqVSbTDXlQ9rLnPM5Wf/FHO4upexL4ishuCe9lKUNNulTv1LdKCQ0a1RPfWEdVUHZyDk0cYjkN6AQdtmen6t8Q45W3jv2/wY8HYrF+/qq/RIomFC2JT1awEvBHCqBdWOFXZkRg8ZYop54SJlZLUred3lF99Ih0h+siGh2ZWevMg==
X-Forefront-Antispam-Report: CIP:192.55.16.51;CTRY:SG;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sgspzesaa002.seagate.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(36840700001)(46966006)(40470700004)(70206006)(83380400001)(44832011)(186003)(1076003)(2616005)(2906002)(47076005)(8676002)(36860700001)(82310400005)(336012)(426003)(8936002)(7696005)(26005)(5660300002)(36756003)(6666004)(508600001)(356005)(40460700003)(81166007)(86362001)(450100002)(316002)(4326008)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: seagate.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 22:46:00.1380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e41293-1905-42cc-c9b9-08da44e9ab03
X-MS-Exchange-CrossTenant-Id: d466216a-c643-434a-9c2e-057448c17cbe
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d466216a-c643-434a-9c2e-057448c17cbe;Ip=[192.55.16.51];Helo=[sgspzesaa002.seagate.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM10FT049.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR20MB4087
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixing the page length in the SCSI translation for the concurrent
positioning ranges VPD page. It was writing starting in offset 3
rather than offset 2 where the MSB is supposed to start for
the VPD page length.

Cc: stable@vger.kernel.org
Fixes: fe22e1c2f705 ("libata: support concurrent positioning ranges log")
Signed-off-by: Tyler Erickson <tyler.erickson@seagate.com>
Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
Tested-by: Michael English <michael.english@seagate.com>
---
 drivers/ata/libata-scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 42cecf95a4e5..86dbb1cdfabd 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2125,7 +2125,7 @@ static unsigned int ata_scsiop_inq_b9(struct ata_scsi_args *args, u8 *rbuf)
 
 	/* SCSI Concurrent Positioning Ranges VPD page: SBC-5 rev 1 or later */
 	rbuf[1] = 0xb9;
-	put_unaligned_be16(64 + (int)cpr_log->nr_cpr * 32 - 4, &rbuf[3]);
+	put_unaligned_be16(64 + (int)cpr_log->nr_cpr * 32 - 4, &rbuf[2]);
 
 	for (i = 0; i < cpr_log->nr_cpr; i++, desc += 32) {
 		desc[0] = cpr_log->cpr[i].num;
-- 
2.17.1

