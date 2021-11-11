Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4657CC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 03:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F6EA61284
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 03:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbhKKEBv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 23:01:51 -0500
Received: from mail-eopbgr1310127.outbound.protection.outlook.com ([40.107.131.127]:47808
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232444AbhKKEBu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Nov 2021 23:01:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hvRVRFJwxqZsjHjRDEIMu+GgybAFhetDgX1zGYH+e8M3ShEeM9zUaysaMOC55MxcNfGEqyhSHlEwVVw/TIvD9NP0yZtvjH89p6LRaUFjgvfkv8/YkQl/TBQGRyjJvQ/5LvBRE37o4l+bNJ9d5Qvn8l169267mUGSDyI44NCdtl1HkfAJp2O4TJB8Mmc2bbBuAyYFPlbCrvAv946IPblzdfFMOl9W1kLFTFI3xvetmjcruyKfRXFxFvBUwHa8zArlSlrY9CBmnmj/5Y6JAJJkT3qDcC9K5HtlwXlPPhK78TAqXDZliiFJIjqR5DaM1b8AQ0a+IM+WS2s0fmdQMug32A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vl6Na4y/t+uibFF824rTo53+HvDGijlD0wUs3EE6f4U=;
 b=kwBzbzvRafRM854h8WzPKs4coaNqdl7rnWs4ENLln2lGk/BvNx1oISHY6xXVf8zGKxOpAWM9v24CkyUiOjdImG1yX0yXTIgewOrer50TS2odmqj2oERE8IkTKPasv55FHyxoTsfoyNfPGj1mpEeK7Pd8bpMJEdzrGUVrNGyMo9elq4p6xdNEX8XcYcnkDWd/sBi+2DPa4QowIzQn3SuUdWfiETGA/xW9Qu/MPDMvIFEvl3lmy3WjiesVL5Yv789e4E+U1xgV0lFp8ws5WxfRwtUiBAO2Gf46NTk6EXUHcmiuy9uE8r5HL3TEQKZnnJTKUW6ciE4s80RBA1YqR4LFag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vl6Na4y/t+uibFF824rTo53+HvDGijlD0wUs3EE6f4U=;
 b=YttGR8rYkks9X6En6L+mSPRERsGl8zdqjhvxjkOCgXowgkBqRcABEfYTxZjg5MIlnnlGa7fFkKeAaYO/YYUk039jf57x5c8atjfgEcDAlaP0WepppjpYaAZRnO1PxBTYcGDxP5zipWJwH/b1OiRKFFYuAQwLtRnE2fw5klg840c=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=vivo.com;
Received: from KL1PR0601MB4003.apcprd06.prod.outlook.com (2603:1096:820:26::6)
 by KL1PR0601MB3765.apcprd06.prod.outlook.com (2603:1096:820:10::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 11 Nov
 2021 03:58:55 +0000
Received: from KL1PR0601MB4003.apcprd06.prod.outlook.com
 ([fe80::2598:abcb:1fca:a01a]) by KL1PR0601MB4003.apcprd06.prod.outlook.com
 ([fe80::2598:abcb:1fca:a01a%5]) with mapi id 15.20.4690.016; Thu, 11 Nov 2021
 03:58:55 +0000
From:   Fengnan Chang <changfengnan@vivo.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, bvanassche@acm.org, stanley.chu@mediatek.com,
        adrian.hunter@intel.com, asutoshd@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, tanghuan <tanghuan@vivo.com>
Subject: [PATCH] scsi:ufs:add quirk to keep write booster on
Date:   Thu, 11 Nov 2021 11:58:44 +0800
Message-Id: <20211111035844.395208-1-changfengnan@vivo.com>
X-Mailer: git-send-email 2.32.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0401CA0012.apcprd04.prod.outlook.com
 (2603:1096:202:2::22) To KL1PR0601MB4003.apcprd06.prod.outlook.com
 (2603:1096:820:26::6)
MIME-Version: 1.0
Received: from comdg01144017.vivo.xyz (203.90.234.88) by HK2PR0401CA0012.apcprd04.prod.outlook.com (2603:1096:202:2::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4669.13 via Frontend Transport; Thu, 11 Nov 2021 03:58:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 979dc253-34d1-4b54-c331-08d9a4c79490
X-MS-TrafficTypeDiagnostic: KL1PR0601MB3765:
X-Microsoft-Antispam-PRVS: <KL1PR0601MB3765203C1108EEC84C88267CBB949@KL1PR0601MB3765.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uVRLKjd7zci/ayUSiRQLVN75uMPzTdOdpdTPHKdcUJWbdfElBYqfjYKwtgu9tfuZ3z5gsBpX5HFd2b9hAQ2DCpEY6K23xU/vwRWFCn50dHr0Nl3FNRYdbyVTOrwwOMZ/2wdWZIWUDdf1IHQujpLqI6qmQthISd0CUIAGKUu05PKp9zm4qzsNLGVbIQqwSxy5Pg862X1yCYS28I9wVfREZLj7pcyPHScFfb0hLhZQoyT92+Ov5rjGTLJccWIDw0meTwzgGD2HIod6KIUW+8MG6lJoBw5M2XsVRQuDSKcHfHj2ojbHkLFsU45/HAA3OAbYdC80dHUMnmE3VtJpeySznrykjNtLCUuS+2ptxBzTkfeFjl5UWlmPwvowpB/Eofv3lK5l0mtC32nR7LXQktJ6wZ0v2z+Ty6vZx1v9TX2xOVgF0zC6zIm8kTxQ6vPX13RZk1yUwuwWIEydoymLfwr0IqNlQvgNuj299wK13frqUCz+cBtg19lXezhhfAlio2PL4TT/F5XPO64CD1zZK+d28nvZR0VSFaq05yQBWmGBGegUcqwGa8In6yRHj89wWe47ctzhTqesUuM2fczsRtzlhHXnEXOL3Otvy3imxKll/kWMbOgJIGWki+aesbctSxG7pjvtchstp24N3hAHBGU5F4vze0EyCV60PzfmNxfhurdtsQ1y4/O1pEtSvvG/wFwPdaIXZJT3rx7bB6YMRfyI+yKKCVV0aMTkNwj9uKgCAG2lJ7zGGq/H+9gKEE8en0jP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0601MB4003.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(508600001)(86362001)(5660300002)(4326008)(6486002)(6666004)(316002)(1076003)(186003)(107886003)(26005)(8936002)(66556008)(2906002)(66946007)(6506007)(6512007)(2616005)(956004)(8676002)(921005)(38100700002)(38350700002)(83380400001)(52116002)(66476007)(36756003)(4730100017);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?raR02zBbrNfxCPJ8qFvQNHT3dG/5dsV8GSS1YiZwqID4vQfHrNWt4CDxxhnA?=
 =?us-ascii?Q?sFPK906Yrw4c7rmHEcdVR2ryTZ7EcdIr5gDk7tNiGTGykNjmTdI1AqoeFhsY?=
 =?us-ascii?Q?BCwz82wGFtR/2P81dCZWjp5quOoU0EJQqPIb9q/PgXCIFQ3FrX1SdJMX0oQB?=
 =?us-ascii?Q?OHF9+0UEbex/vppopeblP+a+AciUDou9Wh6LlI8vqwLtyNOKreZWyl35dF9I?=
 =?us-ascii?Q?OY3SjKclwN5qrY2Mkscyc6Kg0s/FcaWhbumlCAmgBMZ9vBRaFYcbTkWcdf7I?=
 =?us-ascii?Q?8ya4KEfPGnSEeL8pyhyKk5smsaJp5SLIOs11cj4N8PEjXvi8/NyLSp8s9/v9?=
 =?us-ascii?Q?QitKpr9oTzTnutVnU5PJ84/yEHzpeOfEUGfpYLPYq2zsDpHm6AgIULYIetgB?=
 =?us-ascii?Q?5ozaXzMQbCl4fhIYpopX4TWjgpLIXUhXgBU4MK1sg+Si+oj9hgHTufXzlZXO?=
 =?us-ascii?Q?8FQchKA3Tw9WfHhB1xkoE5N4eBb9ko9y9kVJjs8NRYdoXWNR5f8NaZpTpbJq?=
 =?us-ascii?Q?eaQ8Prep/bXDB9cw0L8xjEYzl6pFvKj5lLushd4UKlegBUpX9HnvLfKGl9iu?=
 =?us-ascii?Q?0VOdHD2O72epFQi6Khh5w6U++7JrEY1rSj1CEwIkKNBAbYID2vaN/g0bEmi1?=
 =?us-ascii?Q?emSvYgucSBis4ebIRscGTiAI3PDQOiXNuMHMZ1tUeiapAZzQubFksMxjqp/A?=
 =?us-ascii?Q?goeFGz60Io0jOqALt2EjOfZw6HcTCJjDTPJhSzPoKTHjEhHq/7w94O5EJYrp?=
 =?us-ascii?Q?PfwnAlkt5g1x/XI2boDHNiobigusa4t7OuwqdhseWg3ArOqvrL6KdIBoYNAm?=
 =?us-ascii?Q?ObSVCfrduhlRXcK71w0B46hES5VcR99UX5FUOFJHPEj2SpOWs4p1wnVYbFBJ?=
 =?us-ascii?Q?CnBhVyydnb4F9AkJPozaE9RaAgTCzYkrCsSnJRkwKsCYgAzLTpeMvYyBGi3p?=
 =?us-ascii?Q?1bLcs2DwKoo82HEPK0PTRMWh6tIHHcnMvhI9g8V34CiY54Tj03u9AUbx5hYU?=
 =?us-ascii?Q?Uq/EqnXsmt9IHTJrMKdtoplXUY0rFjX8CXdYxZ/ELpKV54cULIu7Jh7dwbc+?=
 =?us-ascii?Q?+A8OUu3f06121rZlyYs5cH5i+H9lQy5KTY6VtNQ+vjh1gFks1qLEkz6Tr9/I?=
 =?us-ascii?Q?t2KVhPh7jW6pJhwNbkjDZJA07YYUiTsZLkjYsXnjYZDv69pKo87jjBpYOb/I?=
 =?us-ascii?Q?3Ve5g0fG8IihWOQxdHSXemob60+DRIjytzA2h+yAEWwe01XD2dYo2kZczo4O?=
 =?us-ascii?Q?q9GUVmZWnX3AJFzgUTwlJ8my7HtSg7qlsCLnvn6Zz7oyVqV+cYRwTBX3wDl/?=
 =?us-ascii?Q?UPa8IJRq6WF9eQDBnc+E8JDpNth0PxVzP3vr43JPt/coCIQ237w1EvWVeBle?=
 =?us-ascii?Q?lfjxSYAs8UmyUVVF44OrfPNLjHUmvzGFO4O1a2pS5YBgD3EzdWCxz8ryN2yR?=
 =?us-ascii?Q?ORbvrtMgfHav2GWeDZ69Tr5JAWBp0whpbELoTRpwRrqpJrn3YPzLsg9LGHfp?=
 =?us-ascii?Q?wybpRa5KYinDgP4JnCM/XnGH2GVprQ9DOa2LSo1/3CeHqAUHrJ92K361ZFA9?=
 =?us-ascii?Q?CedLi6szzjzFJYVPYTjqJ5BQc0rqxGf7s4AKXkeeLVgZeRJ7hu4BcI2nN75h?=
 =?us-ascii?Q?yqYiEmz2FwmIBmBAWS9a0u0=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 979dc253-34d1-4b54-c331-08d9a4c79490
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0601MB4003.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 03:58:54.9320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 49j48AiHQZYGHAIhsQ4a6DhPK+JGa1M40038pOUSyi+Wu8RPBCEQ8rTgkBKQqfoQUYqym42PBieTYDZq0nGOGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB3765
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: tanghuan <tanghuan@vivo.com>

Some samsung devices have performance issue when the
remaining space is low, and the write booster needs
to be always on.

Therefore, add quirk option UFS_DEVICE_QUIRK_KEEP_ON_WB

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
index dac8fbf221f7..acca346b43c4 100644
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
+		ufshcd_wb_ctrl(hba, scale_up);
+	}
 
 out_unprepare:
 	ufshcd_clock_scaling_unprepare(hba, is_writelock);
-- 
2.32.0

