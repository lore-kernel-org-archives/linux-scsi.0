Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D163C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 08:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5188B61019
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 08:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbhHJIq6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 04:46:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:38160 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236398AbhHJIq5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 04:46:57 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A8gCbM016134;
        Tue, 10 Aug 2021 08:46:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=IBmOBKwP+OJbV7VlkkAiD9c3EUFWGXTfw2c4qhQ/ZpE=;
 b=orIkWIGporeHEkzey+slMqgmMsQ34m3FriISCTLTq5uqvj1Uodez70e2QBRoGPz7TWC8
 3AtrYCPePOeQyjYh8eAe6slET9Z++s6uoruD+qqJbjAnd9k0pWOSDBktGC0Yn61/ax5D
 fkfIjHjnkEJ8C/Jgd8M85+RqjK0gOJffFVBhTufeJX5Xz2UOgIf3WgiDrtAqNm4/cP0C
 d+dCgw1Rg20M4M7ezUtX3GcsrDx7UfN3Lbn4ft8YYhlNtXNJ9a2gQcn92IEE4T7pOuyP
 UyQTeDqabK4d7NtQu2VeflotSUxo8TWxQ/iANDUxZmC0cujLRl9hgLdw/VyevFpgLnmm rg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=IBmOBKwP+OJbV7VlkkAiD9c3EUFWGXTfw2c4qhQ/ZpE=;
 b=mn8KL3VdgJZdTh4+2kKTUmeS0sZhdEKllS5oXpJV6kTxlqPMOWNKC1TGL65lOfLaTbvp
 l1XYu6MXw3XjRHmaJIER4emth99WaucH6XIdXKbEaMtP5sQQXcfiyXJz0iS62m++hguv
 XSlFh1nwpQ4u3U48GIQ9sxhpE+kX29+yHXdgUyuFP4/hHsAc0RvtJRx1Vh5IT+2lH0s2
 vJqrkLO7quRtvXYoLq23opUh2qQ1gWb/uPrp4w7ollP+NCoqbHNUHMEdEmDuvmfxt95E
 61Qlq2M+4UP69RyPuDOFpgYGig4sZrEfmlznblzA0otM39EipxZ7L7w+QkyeR43fdqiY iA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aay0fu4hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 08:46:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A8eUV4189415;
        Tue, 10 Aug 2021 08:46:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3030.oracle.com with ESMTP id 3aa8qsqkn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 08:46:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwR+DS6hyHyn4Q2/v27/J+0n7cj/0zs2k5wyTZ3+Q+pkepK4QPQA1rGqSXP6lbyAqoIgZEbcsWEsGGo5iL2hFDoGJLyl+JrRsxEbEZt8XlTVem9pyYt238JHLQeXY/q3InNG3j8etjAKwrx/adbmahKEoDRy3ghxT8YfnPL0I5N34tjqd2f/PwU5D/ahWqOUQ9FKraZ5QJA5m6fB9PXDgo81mEWBNe29d0/SZejoJYzsWMCNZe4ssreyzD6szhxKge0t5WUQM5LLpZXIgvMSzuLw37Ish3QaPsJ2S9izmTtHw+xqcs75pO8Lz/X5mM6uLvihK2htM97NeR2XBNkJqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBmOBKwP+OJbV7VlkkAiD9c3EUFWGXTfw2c4qhQ/ZpE=;
 b=gbVQ+SUecP40x2CYL7mzGNhL/sQDbeBKsEJrV0TpT/jpiBBGeKseN122TLC9Sn2SGaPTzV7NrcdB41UaVbN2rLeBRK/f6l5bLQ7JUm54deBf42xXI5gZqb8kdIUaF3Xaa5VNnyWUvuq/9NJpBqGkMv6r8ZcbixsrGrvPIKO+x/o72O4a7qPmoloXd0kkcClku+J6T8FKuyFJlkWdS+qe6qg/jxOpBym3f9mmi06G5BqF571o2RRpt4yt9CK5VaXq43CsPBrc12GoTOchiomMmnGirDFMDTxlXUQP1e9xK2PJ2PSSkB93o26YmEuzd5wuqR+wOIcjU7QOR22UA2U5Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IBmOBKwP+OJbV7VlkkAiD9c3EUFWGXTfw2c4qhQ/ZpE=;
 b=vWprgtU50W7ZSBM0ENrMjWCVOrA94ZnAAW5c1oiB8ybd0yON1XuU4gXZdA3lCmtgScdTztMpSJdBkJG1w2AXOev9S2iXv4Y8RKdHiaDtNDHWRkV7AsehPpbgo/T7qx2fWEWAliIBAyMREbxaw2j8ROCYgFG3oGwsuIBCxftelW0=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1566.namprd10.prod.outlook.com
 (2603:10b6:300:27::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Tue, 10 Aug
 2021 08:46:29 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 08:46:29 +0000
Date:   Tue, 10 Aug 2021 11:46:13 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Don Brace <don.brace@microchip.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Dave Carroll <david.carroll@microsemi.com>,
        Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>,
        Murthy Bhat <murthy.bhat@microsemi.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: smartpqi: Fix an error code in pqi_get_raid_map()
Message-ID: <20210810084613.GB23810@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0089.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (102.222.70.252) by ZR0P278CA0089.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 08:46:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2fc4e59-91a7-4bcb-a100-08d95bdb58bb
X-MS-TrafficTypeDiagnostic: MWHPR10MB1566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB15667BABBC7BDE6DED7907F38EF79@MWHPR10MB1566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:240;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eooX7PkKP7rSBPbGRo1r9K8w5bBsaQuF0eES4MGnlTL8YCI+pXY9I4+QhY2ZMD5tRLBHJoZR490s3YFigReqCNL2zAB6tjAe7wOcIeomHXFVWbVnvF2luFUz9EInrvrOpyXuscxkIyHJH2OZKv3fGgW+qiLGqi9WdoTsfeXwbVLPv/X04km6aVeEeKgS+g44QoPVRbteQ/UjZ+k2QokeBFMIVC1uQouP/C/jpdDJbke1lTcp1rusc8UaKY1lNDA5zISBwniMNPni5SQC9d54Mju6Z6dysgEi28ruf/seZ8HMtRKLXOHWrR4TZy0mOYZGpPYjzOX2/f+x+7S7t10VmLUXZblrPP9NELTfHsT9ZVdus03zHmEto52WTfkjt9bQ/bM/ZsEsX03MHCg4v1vfMBVU6Tn6kz/kKRsFadsgy95DmKLN2L+q4zFwBD/LfOd484ipZaPAZL5aEE4RYuRv/511nXuJS9XbILhUdszNZqY+q1vg7JFzM96pDaLv/vgNGxMBrKdjH0fiTp/T/eVJSZaImV6vQTGByOLTxa5iU8/gq2PRfjaymKlGbxq9GZ7otoOROviBR6mt2zXaN3ldFlk7TZsY+5c6PJjPE/0MB0Ng1VnX/2C0dLI4xMobFf6ZdVGM/cTAMEB/ZlHSeZKDh6wMomIrBqbOl+5NTo/3LTOBOptX2NHCF9HEjZ3wD9ki2+cCbWScBIcw+Jmh2dtTaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(346002)(396003)(38350700002)(52116002)(1076003)(55016002)(86362001)(9686003)(478600001)(6496006)(956004)(83380400001)(33716001)(44832011)(54906003)(26005)(38100700002)(6666004)(316002)(4326008)(8936002)(9576002)(66946007)(66476007)(66556008)(2906002)(8676002)(186003)(33656002)(6916009)(5660300002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9tSKZjtI1FM+36k1qKkzRIMzy4t2LhGTrgFmaLru9+p3MG9WB2zt99SbqIXc?=
 =?us-ascii?Q?rM2N5/AO9JvIssLYtTp8wWY3gYUZE5r3l/9vU7t2c78XhhQvKXU/tRi7Yg3c?=
 =?us-ascii?Q?1GGEf7ck8jncLGeoR5KvP8ljYlVp07xyODv8VqDSuw0sn7X+AfN3zQVahtXI?=
 =?us-ascii?Q?KDd36tLTQGaR44cuBmmkfWs89fW5Ap5a8dMu6/oK3/WYaU2K86K/uvzjtxUo?=
 =?us-ascii?Q?sEfMLqXxEmeLU/d8KvYLrulS7lwcYC7ntJKrSj3wdRoE9QNdlYJo9VGLSqR1?=
 =?us-ascii?Q?G2JALnWVzxgeQ3/UJmScHLCny2MDdl2uboypJ7D8NNW9gss9wycx+g5fzKPf?=
 =?us-ascii?Q?RpoZrKU6CIz7w9vLrAEcqptpXV/XZaf6QB0DNtW/ekA9iGr3l0eU2wpzgupd?=
 =?us-ascii?Q?F7/BvU+Eka1iGlpqcqcpHeITZRYEDuwZe8wpRMcISisu/yE+C2BMq1armpq7?=
 =?us-ascii?Q?kBOfyQXEiRGDD/mVkWQ3xJBHCdkiyhO2Ew5Zj7T02lIEq8ZfCUhLqvJQbXhn?=
 =?us-ascii?Q?vTZnYJEBFlfT/mhQqzu8aHe65NWnut4ieOVuLTJZlG/kYLunEGJD6BWlV1BW?=
 =?us-ascii?Q?lS3R/NXn5D1F7ikZ45LmoOkp4ZSaayY3xi5ktf/zngiZh90N8SXVgbfSRnxG?=
 =?us-ascii?Q?AN8uq8axVRI05Pg8+l8Lj3RVQy8f1s5fRlmKdWA6A8m6SVjEr9cgF7pMuNVP?=
 =?us-ascii?Q?TsIvlbdSZRHtZeZJCN/Ho+IiPCBZTc5B8NPH3N9tpjH/irZLwLG5KjZoYifQ?=
 =?us-ascii?Q?QwwlWSo412XCEs+SJVVNzeGKk2UTur4VoNvyCJE5V1eeLqivtKxLQ07yE4nB?=
 =?us-ascii?Q?99JktAEpj7nijghX1TqkFAykzF3dunoMkAtymZB1RpOGsF4GpcVnhFZxWX3O?=
 =?us-ascii?Q?QlYc2Z935fx+p67td8wbrH9qpKrptcAOCLbof27yl3QICLUOqdTKcE3HViF+?=
 =?us-ascii?Q?hKe8m3Zu//K3Y0E2b8M4vuLDbL+b6LxgjQDcrXvxOreu/NZ0OHp9kQsFbOWs?=
 =?us-ascii?Q?rVGBwcu/yRgTKKQLHPralC9gsS+AN+I/AR/mPs0Xm6qgzwoJsFFjTlNwHmqF?=
 =?us-ascii?Q?LdvzGpgfzPKIsAhYiYcnkluRxaCrFHbr2PYK67iWmwZOBkYeOWM/baWMC837?=
 =?us-ascii?Q?xvG90qcvgY8x8iySotqgLLqpaM5DnD00AFvCzsKNvnam/RSl/rrd19WHrdiT?=
 =?us-ascii?Q?ST+T6/D1DUvmiEN57RaWG0DMjDh8ZhTFaTOymxIsezj9R/qA/NfFYnR/DS+L?=
 =?us-ascii?Q?imy06uzXo4DXI0zv3Qme9h+ncOLcksW6535LLNezz+4PyavmMDbjowxPknYc?=
 =?us-ascii?Q?tl/hrCcTKR0lTEX4TH24Z4jH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2fc4e59-91a7-4bcb-a100-08d95bdb58bb
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 08:46:29.7281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ql0/YaPhe2QGGdTuCKME76jVx/yQWQjMHx8p9LC28gmPwDzKFf+vX76SFHakuyG4HOA8w5zQG79vkfsPf1et9Y5McrEe92lmQ9lIvpjiT2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1566
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100054
X-Proofpoint-ORIG-GUID: 8wkqavjDcigdSaJZCCQapt-E9jqZOfsn
X-Proofpoint-GUID: 8wkqavjDcigdSaJZCCQapt-E9jqZOfsn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Return -EINVAL on failure instead of success.

Fixes: a91aaae0243b ("scsi: smartpqi: allow for larger raid maps")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c1f0f8da9fe2..7ccf8e704486 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1322,6 +1322,7 @@ static int pqi_get_raid_map(struct pqi_ctrl_info *ctrl_info,
 				"requested %u bytes, received %u bytes\n",
 				raid_map_size,
 				get_unaligned_le32(&raid_map->structure_size));
+			rc = -EINVAL;
 			goto error;
 		}
 	}
-- 
2.20.1

