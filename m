Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217C2C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 07:18:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 020AE60F50
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Sep 2021 07:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238930AbhIQHTr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 03:19:47 -0400
Received: from mail-eopbgr1300135.outbound.protection.outlook.com ([40.107.130.135]:6127
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233196AbhIQHTq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Sep 2021 03:19:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZueMkNd4CpVG7gAIQqTAtwXiAzk9bal32Dc0K9YV+7qVLav3k5eBN94g4loRPmugM7e4HhXIMYIkRGyq0xa61iP9DbET+Aq1aktpiODPQMXIjG3Auy91ePYXJPhD/0gszEpLngyQtP75QkEXMQQBETSIN63crUo8yH72yFmnyPrhBWuiI8n+l/+aQlfl2yqJqQDsHtyzG9ppubo1Y+eT/JNAyApaL6xou64rG8i1jPx5SmA8c6viB6JGiwgVZ3eSPM6sULHXD7ts14/aCJxnIVev9iElckqNT1G8E8NzquokIT1RnLXt3wyK5Cw32f91zTGKDo6kGGr0FYigPFSFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/dKBhw2gAG2c80MxuMlDQJ5iia+puiltxfNBNghVt2A=;
 b=DOMJPO6FJuKnIEk9tPcYuBYEFTPkTf0p/LZpVLYJRHLcYPDxMcURznslu6MGVPrqVWTgFJzfpfeIqj6vbouXv6GYijNtjF08HJDJKI6PxA5ZapWJ9U923EKWm3j3Ph5cKVuj+88WXfPEoL9+N6YZRZImf9VxOV7OklHxpndKM9vBO62iiwFR01HqqxIWdY/Nz2yUuVdoIqh0vKO1Uiou6n0IsbZYgNrVgxM6qj7g2uxYoODX6QGMDlQYlfsatzKVLjlniN+WVmSXCI0/pEdntjvGaXP9i03a5bpQ3uvrseWOwq/lWHF9ewC6XJozCIo8kCReWrmnfbotGoDc1W9TPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/dKBhw2gAG2c80MxuMlDQJ5iia+puiltxfNBNghVt2A=;
 b=AHTSd7rAxOTDM8JPIWVWGRvxvXDYAsyt1GCUHdfz+5mWFhzTQzv7KFPZwNY11lN8AbzaksqLMSQDgm+C+q2dMQik578bWaQY1y10TLbyxifPGt7rZzNvD8/Y8MQheHhFgYuao27p5pdgAqag8kPAwqaMRJhhHFVERvPNEZ0b0lc=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3404.apcprd06.prod.outlook.com (2603:1096:100:3c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 07:18:23 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414%6]) with mapi id 15.20.4523.016; Fri, 17 Sep 2021
 07:18:23 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Qing Wang <wangqing@vivo.com>
Subject: [PATCH] message: fusion: switch from 'pci_' to 'dma_' API
Date:   Fri, 17 Sep 2021 00:18:17 -0700
Message-Id: <1631863097-10280-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0177.apcprd02.prod.outlook.com
 (2603:1096:201:21::13) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ubuntu.localdomain (218.213.202.189) by HK2PR02CA0177.apcprd02.prod.outlook.com (2603:1096:201:21::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 07:18:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec6969dc-3c18-41a3-e5a0-08d979ab55b2
X-MS-TrafficTypeDiagnostic: SL2PR06MB3404:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SL2PR06MB340480CC5115ED63E2B5A186BDDD9@SL2PR06MB3404.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fDLUCOMWlXKN2ZEKi+1NFoWHW5AAFc2XNzA6uMqGLSpMuBsEjWxDzAtGg3qO30RrlaWyRSVshmwUrLYk7BXlXa/hgVuAB9TX0m1BVC+BnUaTnNopVV8KQngyV2RBUiB0g6n8/MyKX0w3X1VOZWc/3I/0ppgAMPG1KRSpxJe4bZBf0+Uiwz2BGJL9rHBhYwP1ztKXV3vMdcpK1oCavYQRGhuAmzWIB/FNE1tlyjbGxsj4fumGQSkcezL7IWWmhGgR2rA5wiVFKnyp/Zu6jyWEjCdh5O8ZKFM1anNHHcGm7IAXbsrnMFypLYAw55HyhvMwU2XSxRIrCQmMPDq5JZMsie/3Nep5nK4vM4xpKLoH5eXWwBrPzcewZTcoqCHpruuQLlVslFPxm7Zz6gfsVChIruq3CJOVLBgqMeS0WfuXF8g7lIoMqT1SPa3v9iQoZjT/KaCwGxG/lxE8AmUzl9wjcdeko/lXJcHevWZBNo14/B6upfKTBIK29KWRDcZH0fvqbkCs1T3tL9ou+l0Z7ZyiV+fUXtwLzozMSxDXeJpylQqD2oGLjVu5SUN7QaX0GYlyA5TUtPoPss02MHG8gvbeWdbJuyJTXYQTlybQlgRKVIkgxSG49QQBnsDUbA0eftfTaQCH9ylg8h69YCljsW20fT056U8dWcSqzqHJr7I1cBw229w88OCJCZvTa8CUqQZQeXctKtgVYtxO8W4fUfZspjon9L2/Lm8DhG1qOXzG1n2DKA0y9GHnCE380G8GyDDeNUbMS1x69UVzMbfhrft51g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(38100700002)(6512007)(15650500001)(6666004)(38350700002)(966005)(6486002)(52116002)(8936002)(5660300002)(2906002)(6506007)(26005)(66476007)(478600001)(66556008)(83380400001)(8676002)(186003)(66946007)(4326008)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fkcyj7JI/WhzwSOqFOmDo1jQEtp0crvBuW27d2TFrEFlgxwVlPSaKQiNJtzg?=
 =?us-ascii?Q?bTjGQP528uXw3BT0Fi0bwcLOMt86U05eWEN7WMpr5ERNJVsbh94hqF3x9gFy?=
 =?us-ascii?Q?Dv8JtGm2XvR5oRvrOlNxzArTXDqRZJ0hvGkpNlsh9+lXKMCwh3swT6KQeJmZ?=
 =?us-ascii?Q?z4gQQOM/Do5q9BvhdXIwescvW5oclKLXCpcT9WCihCvVL0E/6qdbkk3lGl16?=
 =?us-ascii?Q?WlpsPP+iOQ/iQbajWt4v+FS7H5kkUDpMQiZVau/nzx4aKKaari6145nsYkK2?=
 =?us-ascii?Q?jZkM3UZnds+o4+yHdc4K0rdRaFyBpyEJDDRY4s4lBJLHEKFA4q+HAZc1lyP9?=
 =?us-ascii?Q?VtVXTMq5eioNDmFCFy/BilWFgUCxMq5k2iKW+oQMWcgKyrKOsgTqygyUJ5mz?=
 =?us-ascii?Q?aAjZI2ZiYRpZ0h4ugaAixadDMKQaclZW1agh+uxZtvPRMDhbCZIKle40JzQ6?=
 =?us-ascii?Q?2rlmaGCHqkecD1O5fKHvnh9DsqX0hAGqa9Hkcmxm1djK0ZA27rIVjOhxH3DJ?=
 =?us-ascii?Q?jbI3IzTJ66MOlLhyMNWwcZ0yUqH8rW/+ZyYCkSPUDW09WkyeK5EVSZ4zgksD?=
 =?us-ascii?Q?uy4lDE53zsjm6/JKTFuzG130UAhgEQMUAWDWagAmaiPAyBaj7K/wV0zAGWWd?=
 =?us-ascii?Q?OjmOGSxv32/x8XVa+FMDvO2hfMsNvj2ebfW84i2AF9zyKrh6xHAANXi/HgK0?=
 =?us-ascii?Q?of6HKbzHSWyFoVc1TN6iJCLc+FlvBOk5TBIK2qhMFzD6e+iy7uw69vSSlwmV?=
 =?us-ascii?Q?oLCYVF7Q6lJ15JXE8pFTMitxz4HzQf4xHGLA9RidW0uoGnIMOUY0JLm0UBzS?=
 =?us-ascii?Q?N5zpEtwyDZIQ+qb/MlHPmTgxWRrxGnHjvyByNT1FM/WqkfZpLMtf4DzUvs8H?=
 =?us-ascii?Q?UIf64qV/ufTO8y+CjMMrRycK6l32JC3nfadRHVStYQJ2scZq4BuVj+Dc7kvd?=
 =?us-ascii?Q?n7LEabnUfCHp44FOwN09CV02zb1vvNptNzg53eGEkDyr+r6u+hZuN1mmZ6uh?=
 =?us-ascii?Q?7sg0JJanruaY85WSeiKOqfz4stywc6pwgNeD6/bdOu22M0lCBbyapYyNtRgj?=
 =?us-ascii?Q?/Q7wSCGg7eriZhtcypuhoQiV39ttGeL/VaWlafXwcIehyLgXsDMEPpeQYLmf?=
 =?us-ascii?Q?143DXzDEmwOXAZPKg4RRs08gTlbZNFuTO3MOMJBqQ0fg5Eg7BD0+KfhOu6Du?=
 =?us-ascii?Q?qg0waXlxE+qDwuIuOPcCXERknbIC6MjmfO98ecU+ECqA5EZyP2/AO9AODLiv?=
 =?us-ascii?Q?I26ajoh7D3Re7bnEIAl385x/3DxwXnHZXEGeUdVjhoUS9kTc9PIa3riRdZgm?=
 =?us-ascii?Q?b/eB7NMs1n704f9ckP5vd0Ee?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec6969dc-3c18-41a3-e5a0-08d979ab55b2
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 07:18:23.4701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4Fn6n5SkRlnajMfjymFIYumXd6HdogvDfXbvg+nl3hxdOFLsH4/BwZLYGPry5jucqvrTU+9lOgBSFlvB9bPRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3404
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below.
expression e1, e2;
@@
-    pci_set_dma_mask(e1, e2)
+    dma_set_mask(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_consistent_dma_mask(e1, e2)
+    dma_set_coherent_mask(&e1->dev, e2)

While at it, some 'dma_set_mask()/dma_set_coherent_mask()' have been
updated to a much less verbose 'dma_set_mask_and_coherent()'.

This type of patches has been going on for a long time, I plan to 
clean it up in the near future. If needed, see post from 
Christoph Hellwig on the kernel-janitors ML:
https://marc.info/?l=kernel-janitors&m=158745678307186&w=4

Signed-off-by: Qing Wang <wangqing@vivo.com>
---
 drivers/message/fusion/mptbase.c | 31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 7f7abc9..c255d8a
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1666,16 +1666,12 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 		const uint64_t required_mask = dma_get_required_mask
 		    (&pdev->dev);
 		if (required_mask > DMA_BIT_MASK(32)
-			&& !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
-			&& !pci_set_consistent_dma_mask(pdev,
-						 DMA_BIT_MASK(64))) {
+			&& dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {
 			ioc->dma_mask = DMA_BIT_MASK(64);
 			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
 				": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
 				ioc->name));
-		} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
-			&& !pci_set_consistent_dma_mask(pdev,
-						DMA_BIT_MASK(32))) {
+		} else if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
 			ioc->dma_mask = DMA_BIT_MASK(32);
 			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
 				": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
@@ -1686,9 +1682,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 			goto out_pci_release_region;
 		}
 	} else {
-		if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
-			&& !pci_set_consistent_dma_mask(pdev,
-						DMA_BIT_MASK(32))) {
+		if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
 			ioc->dma_mask = DMA_BIT_MASK(32);
 			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
 				": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
@@ -4452,9 +4446,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		 */
 		if (ioc->pcidev->device == MPI_MANUFACTPAGE_DEVID_SAS1078 &&
 		    ioc->dma_mask > DMA_BIT_MASK(35)) {
-			if (!pci_set_dma_mask(ioc->pcidev, DMA_BIT_MASK(32))
-			    && !pci_set_consistent_dma_mask(ioc->pcidev,
-			    DMA_BIT_MASK(32))) {
+			if (!dma_set_mask_and_coherent(&ioc->pcidev, DMA_BIT_MASK(32))) {
 				dma_mask = DMA_BIT_MASK(35);
 				d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 				    "setting 35 bit addressing for "
@@ -4462,10 +4454,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 				    ioc->name));
 			} else {
 				/*Reseting DMA mask to 64 bit*/
-				pci_set_dma_mask(ioc->pcidev,
-					DMA_BIT_MASK(64));
-				pci_set_consistent_dma_mask(ioc->pcidev,
-					DMA_BIT_MASK(64));
+				dma_set_mask_and_coherent(&ioc->pcidev, DMA_BIT_MASK(64));
 
 				printk(MYIOC_s_ERR_FMT
 				    "failed setting 35 bit addressing for "
@@ -4600,9 +4589,8 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		alloc_dma += ioc->reply_sz;
 	}
 
-	if (dma_mask == DMA_BIT_MASK(35) && !pci_set_dma_mask(ioc->pcidev,
-	    ioc->dma_mask) && !pci_set_consistent_dma_mask(ioc->pcidev,
-	    ioc->dma_mask))
+	if (dma_mask == DMA_BIT_MASK(35) &&
+	    !dma_set_mask_and_coherent(&ioc->pcidev, ioc->dma_mask))
 		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "restoring 64 bit addressing\n", ioc->name));
 
@@ -4625,9 +4613,8 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 		ioc->sense_buf_pool = NULL;
 	}
 
-	if (dma_mask == DMA_BIT_MASK(35) && !pci_set_dma_mask(ioc->pcidev,
-	    DMA_BIT_MASK(64)) && !pci_set_consistent_dma_mask(ioc->pcidev,
-	    DMA_BIT_MASK(64)))
+	if (dma_mask == DMA_BIT_MASK(35) &&
+	    !dma_set_mask_and_coherent(&ioc->pcidev, DMA_BIT_MASK(64)))
 		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
 		    "restoring 64 bit addressing\n", ioc->name));
 
-- 
2.7.4

