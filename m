Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EC5C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 07:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E8C661261
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 07:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbhKKICe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 03:02:34 -0500
Received: from mail-eopbgr1310121.outbound.protection.outlook.com ([40.107.131.121]:3967
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231880AbhKKICd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Nov 2021 03:02:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LnyrntUMXFZCU2X+WdOpZqn3iXeSwCFTu6Lovex3KRP6BsxR28JPzs6UoqXp2/iOaGofDj4aHrTKGzFw6lS+Ho+O+ZvoHmfwsk1iRAX8WBX+hgV13CxH1yF2p6EqqJZP06sqKpC5QdGfKb9/sQQRLTGx79MBlO/AXXZY32z0kWIyW/mt7gIaYTvP/150jMFLSgTvmQOGtqqVTQIUj+S3Zv//1drQaIa7lukhil30LdvUR6TbTWs66CDV1IORf0ZipUyfuQvvuRz6QralxiOtq2TmSCGaEPjBWmJcmOAW8nWdJXdtBJywB9dBhj9ZNT5byO50Tvibv4XxIoL1I9xOdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mmbf4I068+vLt+HwBPeb/jEPqn1m6XFW6IR8XXQFiG4=;
 b=Vj0KBfI5/iW2rVjVa9901M/o608+AxgvIxc3GI5dOXpz/n5/PfGSue40MQnnI2hRUWJXWWWymgyZsmiDlE0UMNC8kVkHsGI9TYm+15iISmgTatu1peWXR2BpVASLhjiGMjgKFfnqGHpSxm2CL00f7ulChfvFHdREcZH9sD0Kh9z8bY9z1uOJea11/hgjTM8e15pSMy9LZ3Or/R+6ZOs3aRPYl8iA8h+4L3QIhJ4XDFoqUFFtvMeHmj5E2EOpA2JDdgY6DhF8YWu2aeg0d4Z0Zat71lkh0xxBEclUEwLFN+NigkiGMBTnX/m62kYPjNE91ceubD2gJI53UIrKNjM0rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mmbf4I068+vLt+HwBPeb/jEPqn1m6XFW6IR8XXQFiG4=;
 b=iA0Wcr4D7RNjwrdQPVZEOt+xl6r1MvHHaCCxulkxmbjnpnvJ+qM3wg+1M8DjQcwHU8HnGdS5n+A4uqBXiwtO2MfDp6az39688xrQca6QZeVWdlb7zqAM41TOt/IviCzQ7hAjnbHfJgxSc3i5yimV+SOgg2AH9PsqBsbCl+fuCJQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR0601MB4003.apcprd06.prod.outlook.com (2603:1096:820:26::6)
 by KL1PR0601MB4035.apcprd06.prod.outlook.com (2603:1096:820:25::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Thu, 11 Nov
 2021 07:59:39 +0000
Received: from KL1PR0601MB4003.apcprd06.prod.outlook.com
 ([fe80::2598:abcb:1fca:a01a]) by KL1PR0601MB4003.apcprd06.prod.outlook.com
 ([fe80::2598:abcb:1fca:a01a%5]) with mapi id 15.20.4690.016; Thu, 11 Nov 2021
 07:59:39 +0000
From:   Fengnan Chang <changfengnan@vivo.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, bvanassche@acm.org, stanley.chu@mediatek.com,
        adrian.hunter@intel.com, asutoshd@codeaurora.org, tanghuan@vivo.com
Cc:     linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: [PATCH v2] scsi:ufs:add quirk to keep write booster on
Date:   Thu, 11 Nov 2021 15:59:28 +0800
Message-Id: <20211111075928.119801-1-changfengnan@vivo.com>
X-Mailer: git-send-email 2.32.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR04CA0058.apcprd04.prod.outlook.com
 (2603:1096:202:14::26) To KL1PR0601MB4003.apcprd06.prod.outlook.com
 (2603:1096:820:26::6)
MIME-Version: 1.0
Received: from comdg01144017.vivo.xyz (203.90.234.88) by HK2PR04CA0058.apcprd04.prod.outlook.com (2603:1096:202:14::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4669.13 via Frontend Transport; Thu, 11 Nov 2021 07:59:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c07c2bf1-3557-4d3e-a215-08d9a4e93605
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4035:
X-Microsoft-Antispam-PRVS: <KL1PR0601MB40353DAB6F63573AB9521D9FBB949@KL1PR0601MB4035.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y9/rBeBUGC2UuTBXYsMA0rWHUIbmxxi016b5N6OQ+YyIEevFvrPl5dxbKFL3LakmFOqJeGG5RCii4s971NRUazAREDY/GNAkQn8a/rhKzX3yTyG/5/NFvmBvWcEDxhfHdK1PKjE1I6HN20/as5eotIuYBzvD2psuK/3smLg7NNHVoEHMZggKFK70sK8wVBxPdeDyxE8He+GgVP4vkvPi7PgaaD1b+aCRSM/VBBa+Pdmx+0UeWNPADV06GOcejo2vSBOWI/ptq/+Mw6XPKeGvXfqiCHjAn93txBYd37f7kkm4tTe8IOA0831cVDmt8wAW25uBUyAWqYBhax6L2DA/96c0F+HTl+0jaVXcub0SXDhP6rV0t8F9GfsLcDFJUxFFvjWw87IF707hTFRGAGoeSliwWzRj4Yp1ikDx0xXECXsITbAWNX98WTy5pEo6WYn0aXJWVXfyxv8RVipk7wvvV3X2LNSKetM69S6SNWCzgt6W//uXajKjCD3Jdb2+MyO42CtkuHVOTSsA7RSjMxDdATGAi4BL2T21dGcvlAbe02Qfv8ERrE7e6pUenMeVqsIZq0+Iu4l8hVW0A0HXd41fHahJAIEpbTR23tAXqe1Ta+YHt9mXwoM+LLU68EmjTzkTTeP61UCs3T/VD9b1L3aetGMo0ov/lizJ5DiEniFUop4wxQ9tDdA2WOq0KSITXrwL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0601MB4003.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(921005)(186003)(6666004)(66556008)(8676002)(66946007)(2906002)(5660300002)(1076003)(316002)(8936002)(26005)(6636002)(7416002)(508600001)(36756003)(6486002)(83380400001)(38350700002)(956004)(6512007)(2616005)(38100700002)(6506007)(4326008)(86362001)(52116002)(4730100017);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IKhWDEUE+OVHSay12V5pdKuqU8HfI9i3aYKf0MEjLvG1dBdCxRcFb93gwSOq?=
 =?us-ascii?Q?FcRCeoFLoswfjvIUJLspLyl802or1dUQE8+X+Q++Fl/jqH4wz8Ejk+JNetmT?=
 =?us-ascii?Q?LyOjXT8Wp/57bQQn3Gfxt20uQjqXdrvt7E6szhQRAdmdo9Tg9qyFIItD9Vi/?=
 =?us-ascii?Q?AAcI8ILjnCPmj1+VeNN22KkhlHqV3Z7w2hXDX/TcTGVWq+95q0S/uubW5IJZ?=
 =?us-ascii?Q?MbUh2xnwD3ryMGPfqml+xnZ7ARhnLtgvNVwJwoXY0EkJkZ1293HoPH5aZ9w+?=
 =?us-ascii?Q?uePcm5qmiYWDUwbDzMIO/XjofzZcxMvXxMVal0YSaVt/uP6E0FzWwYGQSdLP?=
 =?us-ascii?Q?FwbSY1y34c4LQR/cdbfI4WNNH6B7mNYxiBvSRrZOwYnOFogNTpUmVzDjrd/Z?=
 =?us-ascii?Q?a/eYsSyyG/5hG1z1E1NvjTJGsi9l7g6nSqZYLXoHt7Yg/sjKPELXUG91VEPg?=
 =?us-ascii?Q?tntzWTqk6DTPabc3sgBOu/kx2iIgAh1jvXY+pqzfFKOHpLvcx1wGDhc2EU07?=
 =?us-ascii?Q?kX7nJVJYNxhnMCUJnN9N2L4wsm0QBnSe+qnV6iJroOnPTBWgLiCT2bvbDx8n?=
 =?us-ascii?Q?Az8dmL5G+kfLxoIyGzeXNLynbXqHLtyGKcwbFDviP0WFQ6KU471d7nXHadGX?=
 =?us-ascii?Q?DBmMdJ1jW7OhIp/I7oVGUwTErpTTs++ZQTjvvBMogf3SfVfaRquz1ZBsMunw?=
 =?us-ascii?Q?k37Je2tOlhVODizTaCke1254/RcHhXoL9eJSkbDMEPM4u6zr2suTLNTdzJdr?=
 =?us-ascii?Q?zXVWQOxcyux13V4wE6sZPKjdXXQfnztdiB7Mnv9zIKsit0alG7SB32QBrcYy?=
 =?us-ascii?Q?g06nKAr2tc+lOK+nMhapXaJWrCV5/71ICYmwPizhmsKbZvo/NztuE3THzb4o?=
 =?us-ascii?Q?rett4LvNcwlrsYd767ajuZO7TZ0rH+lcD8WANYqcQX1qnvrnCNk7UV/CwKn1?=
 =?us-ascii?Q?769zMFrjh7sLB8Q8tBnbh/UTuIKuQ7IKAMqj5m9TyxGPUXKoXiOoP1ILuE2n?=
 =?us-ascii?Q?riQv?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c07c2bf1-3557-4d3e-a215-08d9a4e93605
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0601MB4003.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 07:59:39.3147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P3QimIPFNV5IEzzh4tXqH2nKvv3W8/F80lJBRjkdtVQ5DC/Feo3ltrdmY0cLb+iHnX8SmZ6YBikQuISi/cXMqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4035
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: tanghuan <tanghuan@vivo.com>

Some samsung devices have performance issue when the
remaining space is low, and the write booster needs
to be always on.

Therefore, add quirk option UFS_DEVICE_QUIRK_KEEP_ON_WB

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: tanghuan <tanghuan@vivo.com>
---
 drivers/scsi/ufs/ufs_quirks.h |  6 ++++++
 drivers/scsi/ufs/ufshcd.c     | 13 +++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index 35ec9ea79869..532719eb4f50 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -122,4 +122,10 @@ struct ufs_dev_fix {
  */
 #define UFS_DEVICE_QUIRK_SWAP_L2P_ENTRY_FOR_HPB_READ (1 << 12)
 
+/*
+ * Some SAMSUNG UFS devices require keep on Write Booster for prevent
+ * performance drop. Enable this quirk to keep on Write Booster
+ */
+#define UFS_DEVICE_QUIRK_KEEP_ON_WB        (1 << 13)
+
 #endif /* UFS_QUIRKS_H_ */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dac8fbf221f7..b0b9c4e6b185 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1250,10 +1250,15 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 		}
 	}
 
-	/* Enable Write Booster if we have scaled up else disable it */
-	downgrade_write(&hba->clk_scaling_lock);
-	is_writelock = false;
-	ufshcd_wb_toggle(hba, scale_up);
+	/*
+	 * if no need UFS_DEVICE_QUIRK_KEEP_ON_WB, Enable Write
+	 * Booster if we have scaled up else disable it
+	 */
+	if (!(hba->dev_quirks & UFS_DEVICE_QUIRK_KEEP_ON_WB)) {
+		downgrade_write(&hba->clk_scaling_lock);
+		is_writelock = false;
+		ufshcd_wb_toggle(hba, scale_up);
+	}
 
 out_unprepare:
 	ufshcd_clock_scaling_unprepare(hba, is_writelock);
-- 
2.32.0

