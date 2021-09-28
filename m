Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F68FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 03:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AD8D606A5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 03:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238873AbhI1DoA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 23:44:00 -0400
Received: from mail-eopbgr1320122.outbound.protection.outlook.com ([40.107.132.122]:29825
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238850AbhI1Dn7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Sep 2021 23:43:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lr05lbBuYvoTVlD1yTdV5dgeVcfosjvqtI0cprOXt/kWfM3t8qv3xpeTjMqKZVwDDqiGFa1lX8ZWPXjHYmsus8OTukh0AnmLcOTI3dMLW4xs5OpQnaRSdvOREnt429+MGhsObvrf6mT/Bd5otxUhov8j7v5AQLB77U6ULlJx/1SCCTqiSf5MNGHyx4uXJgtwhlBLyNf67q6WvqH89R2TSdBqBTwGLO0uZUfxmGDxIP8xLgM4LSIdoZQ8Jn5iWlKC0dWgnemaU+F1r80+0kz7Y/p6JVxZN+Bqdmm7F/DDPKYUubNFr8Zpl/O0wtudfK70hEP8geg5PgFCZVhKXb2q7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BlXLUM/ert72C2DH1qhIy8zVsPTeVoE1568W5azf/uc=;
 b=nmmC1JTGosXceXYxvDjgHVG1k+gRMlB395DguiEd2Z715THXdqTrsX7Ys/8AbLPbwy3Eny+8TvfELNiMHx1gmiI5xyFyA/c0XNtLDsUCa5Ypy/UInZTqe79aEZxphOgXbZSpe/ILCCmrd4wDwHP+NCn12HWZRrqrSHueHLPPSYVqFSv8gGxhYv+zgaQJI/n3nrTnr3UHo0wunaZ1HdPA0mMn4dp3eOQqkLlcycxSMXeDebSe1Pu0y6mneFcVunpVPDLklWZSgLVZyTU7pmxm5bNoQV7szXfa5TLcTNDvdqRpiv514t904aNpjZ3u/SD2yeFMkDWuTOf8Gy/DF0GYsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BlXLUM/ert72C2DH1qhIy8zVsPTeVoE1568W5azf/uc=;
 b=MrkERfYI9BKkxrKAuwClv5WtgaLzUJd2ifsFUbZTkhj+8sp7q1iEz3v1UVWJgDqqhWYf271T7I62W76Tf28DGx9JUVvMJvesPf1qff/hnkM8XvA5N0l3HFlwGxhWNi8MAC2iS8M43L1R1/tKyLwZ01mevh3HJrpPPVzQbkazpq8=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Tue, 28 Sep
 2021 03:42:19 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::4c9b:b71f:fb67:6414%6]) with mapi id 15.20.4544.022; Tue, 28 Sep 2021
 03:42:19 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Qing Wang <wangqing@vivo.com>
Subject: [PATCH V2] message: fusion: switch from 'pci_' to 'dma_' API
Date:   Mon, 27 Sep 2021 20:42:11 -0700
Message-Id: <1632800532-108476-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HKAPR03CA0019.apcprd03.prod.outlook.com
 (2603:1096:203:c9::6) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
Received: from ubuntu.localdomain (103.220.76.181) by HKAPR03CA0019.apcprd03.prod.outlook.com (2603:1096:203:c9::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4566.8 via Frontend Transport; Tue, 28 Sep 2021 03:42:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 629ff662-01d0-40d4-b6d9-08d98231f8f5
X-MS-TrafficTypeDiagnostic: SL2PR06MB3082:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SL2PR06MB30824ED8C1A615B1EDAC7C3FBDA89@SL2PR06MB3082.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9DGZNrp+EAFFf1AcKW9eyW1lYuBVReN/hUE8PiMlVTMw6EXoXyBewEz7hIiyGDqEhxcDlKfOnqZaz03I5dzNXYUcz9Yp1lnfJfy63ZJIxLELsU8zTWOzFDA4kwqxUp6/RDzR5vfwx1WK1Y8xS2M+RF6IUKJmvPj7e20py6nr8ea4OPTgbpDUJkyoeHL9B6hXeZgC7SCASI/T7339A3bTJ3w4XPcntIQ3kk9B+QIdRn4g8r7xWrxkRzx7dGj7JTGScprYxu1K4r3HnrNAipkM9xbcaO1S/MrpsuAg9olQUSVVmNYP22oLEWydnEe8HvD+k9+TkGMzj1GWJFaK2tAU3mN+PPFBESykeCHO7InRYy00pZ97i1SYWRdIwkB/HI25K7yWmkPFnF+BmTTvW48oar00ypggbHDWmSO9/TpJlggd0jrD1thVtN+fjs5Dj3jlbwCkLm8wahePe/ir/PKVea5KDuQX0Msijr56dJ786Y01SpHZMq4UVRpfs1qRgURS6x8FJKJn685pFN8g3J83kp3UaLO078nHMeGKnaUYLF03js4f24ThNN4XGS4E69j8XOb+ZnNL3LZXXOZvO/yvstPyDDS6qJWL8RpjYbvQAzxj3w5FAGM8RDfaATIJw9fbSP0o/K1YCKs3Jn6G+9aAlYwhSqzNlQ6pm/uNG0bIf0OaBRxCZMjgIZGgMico9hfdFFMIuSW19GnmpsuBrutg7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(26005)(4326008)(107886003)(5660300002)(316002)(508600001)(2616005)(956004)(38350700002)(38100700002)(86362001)(6666004)(15650500001)(66946007)(6506007)(36756003)(6512007)(2906002)(83380400001)(8936002)(186003)(52116002)(6486002)(8676002)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a8vIo1RRNWuXK0c82aelscf6BAUW0RNDmhOLnrJxbC/jwtwBEglkqKxNHbf7?=
 =?us-ascii?Q?wo3KPcvNX0x0I+iCGvJIl6lvRY2Avl4utSSlNzKNHf9xdpfLT4LvjnklzRi6?=
 =?us-ascii?Q?99zoewU6tgumchrPUrrhOJ8FkAks7326TBOUFq6NyMBO8rmL1IKy2kM+ls6h?=
 =?us-ascii?Q?oY5B+Cl8dCsm0ltHv8+XHhwwXVG3WYY8Q8DW/aV56uJjL0zcyDhmySugKhBt?=
 =?us-ascii?Q?/r8HCfiR3TxRTkXEBW/5E5h2GTe79hCx/KLUOspTfEEVAoeKvMwY5/OjQyAi?=
 =?us-ascii?Q?fOzmYsNlTXBB6fosqgKnnl/78+Uz7JXrgKOrB6Ox/Adm85H8tNjQQ3N7YQTD?=
 =?us-ascii?Q?eOwiSpDGY7HstNd60SPikdG8KwuzNJ4Z0WnvqGb1cPCsrn6/Y0bfwkiYFHaT?=
 =?us-ascii?Q?5ivpfEfTsJsZ5b4kcKZxBh6nO9cjX4fZOTWoz3QCyGhqrVZWYPbsaHmHLv8Z?=
 =?us-ascii?Q?yQwRJbrhuHT/4KPLbwy9GjLBbia9WJF3cT2QvurlUW4UkDEfP8/0kt7Y3UxG?=
 =?us-ascii?Q?NqoLxDn41/1+cGk3X1kqSvx6TeOF+e995/vvcgtaVZMzVB5+QrgE1zRGzpAX?=
 =?us-ascii?Q?i5XUSOglqADkxdeXBYUJ1GeV3P6wfPkrLpB8cDyc4GwZF8JHpJJbI91anrYL?=
 =?us-ascii?Q?uygJXBTMLTfSS5p3LaHrxu3jYhe5URea9Lyo6e08HCWxSJ5a+nifWJVFfW7P?=
 =?us-ascii?Q?PX9KJfXXS1uKNQJ6rQ/0PYwBtHQwnxXTdPJG/Kk0oMdYKq3wjWSSSiubl7N5?=
 =?us-ascii?Q?YSLcX43O6wWrvGuRkpIj/6YUGwdP9NWnumIhX593O9GPKyLk8LVAvuYeiOlk?=
 =?us-ascii?Q?3lCs6gEFhDZcx28cLMWKrDcfUiKKAimUyhrVb6wD7yONVQWZ+/oSGT8p8gR0?=
 =?us-ascii?Q?NMEOl2Qzp934Tp3mXSBsmiTV9aIjQLJOHxgH8Kj+KYpqcQ6fOjDq3GDjbSnF?=
 =?us-ascii?Q?NeTt400E4wTSwnshfxlCzgUcepKRqg7XziogFTu/J6N/T4FuYHFitlhUhSCM?=
 =?us-ascii?Q?514n2WoF0ERI0z1WiloOf4QdmlEHZQjjw2THI8aokRpg6MzzZD3eKlA2hdfX?=
 =?us-ascii?Q?wKFlhR5i+iFfQXM+Ud/eQ+4tKPMDmhIfUGUCSVYTLrWpBh33Yzo/NM2lBVTx?=
 =?us-ascii?Q?RIIv+47kRKkenQIzXPVJiPE7reXzNuQ/+daFh98XV2iDWPe3Cbx+M9DPOH8c?=
 =?us-ascii?Q?Rh6xwcR9WFpdDZocUitlK5aRCJUOfVXeCnsmkSJsUPS2TF3ccfdlYzGq+4c/?=
 =?us-ascii?Q?ZQlK12e+q7jfxX2TOzQ4/FlScTF39X0xSynnvJNdDhmtMLwVTAlP0E2zf0Kr?=
 =?us-ascii?Q?oIbmrNT12cuSUBfAkVAlVhud?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 629ff662-01d0-40d4-b6d9-08d98231f8f5
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 03:42:19.2926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hqtMkid2Ce4g792nAINwG0Oipsvtx+5JRxoD9yqRkXzYHGsBY+DsxVyu4xB2CLiLWw8YK3MkcSDuYFJmcwN0Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3082
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

