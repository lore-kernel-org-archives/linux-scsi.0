Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8942C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7AA361381
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243841AbhI2DO6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 23:14:58 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:56494 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230022AbhI2DO5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 23:14:57 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T36k3B001820;
        Wed, 29 Sep 2021 03:12:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0lSvErenF0o6M2io2CYTLl9gZ8GMSwTGuQgK6SRskE4=;
 b=vfkLI2uM+45kNF1hMwxU8w6Fw9+RV98lm55MfMQrlvHn8cjBpW0alIqPtmQNbfVbveZn
 P+D3vvTU4qS0+YtXufyIFbo0bIm3xOS3MZorNsybGFXyPLQ8YMB6HK6ENtyUOMfjr1TS
 BJlQEn9AbKJpBw48SiumYMeRCSEEWNNm1fqsizRJDRbvwCVHz8pAYRoGUPHzyt+lKECt
 IUTB5E+1bLppcyNZfG1Za83+eoY6Lc3eeA2wM4h7IG8+n/ysbA5VvnS2fgNI0ffMHheW
 XicryRSrOO+EkoasxYNEy/jLluOcb/rx1CETfIF5DukdJeUoVAUy8+wgGglNiBrb0DjF Ig== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bccc88wqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:12:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T3AS9H040280;
        Wed, 29 Sep 2021 03:12:47 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2046.outbound.protection.outlook.com [104.47.74.46])
        by userp3030.oracle.com with ESMTP id 3bc3bj99aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:12:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctXTXOSdVAyZTxut0mYLxs18URFHOXYScaCAiitToquy9MPx6WqxajTnl5z8PApSo82yctHpET+KnaXz+es2tvNZwv/PRkRwsLMFZF8A08Jt1OC6uml6s2JPNZkkFeG0U4vghHU9IKW/UAxagH4TC+ejDFIlfQJzspzDstT90dsQvTqJ7b8rH01WJtaHxSpz+H7xjT4Zw0zuAhFp/MAq6A6VVU8PjB6JadLNJ1BnbyaZT1xDT4K//r4ptGVqD7mQa8QUfutYPXKD3xt4vNz7iM58VxrfC2btYmrbSstGdVRthCqdT70gkSQguFWStQueYMb5tCX1zAVXx3mx3ffiWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0lSvErenF0o6M2io2CYTLl9gZ8GMSwTGuQgK6SRskE4=;
 b=bk+3Ag2DbU+0pqQuLXjjsmcqHzhucQKY+CCRMdyDOxuTAhlLSk5ybYXpSg3BI9SEFmhmNOeX2CPIfjeQsICD5sq+v0oVZx/+rbWpVcddwoce41ffdkVudgLMvl+9IaWaCRrHWoErB4jbeQrI1CKiiP1IxuqmlIujGFzxJp1CmSHbHZGEPH5fovRXh9ORyxdDZW7jH6t7TY/O0ez93+xFI1cZDC5AT6TWn6jfBEwAAQUvtwWWqLzAv8EZevOUrZolWX8jdnXy4bmpVF6lPPxmoYy+9x85bIuHJpgbYCa40BXlw7HpKW0MvjbVGkndCbRmj3y8mFFyuFYEjsfYXShNWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0lSvErenF0o6M2io2CYTLl9gZ8GMSwTGuQgK6SRskE4=;
 b=jPe8+NzzgOEM6MIDs/lGGMyf4TmJxOmu/KeXLSCOTVUw2y1ncQperJ0D4jTAYPU4FdjpJM+MfMjRXErV5Y5OSEaxZuOqyRixwsUFUAvaV7ThwqdWcec2Fuv72SNXjFuNnF7USb7/pck/bVEvBYP0yaJsXD7bsb/HS/aATUStN9E=
Authentication-Results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Wed, 29 Sep
 2021 03:12:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 03:12:45 +0000
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Michael Reed <mdr@sgi.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] scsi: qla1280: Fix a function name in comments
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v92kf5pj.fsf@ca-mkp.ca.oracle.com>
References: <20210925125324.1760-1-caihuoqing@baidu.com>
Date:   Tue, 28 Sep 2021 23:12:43 -0400
In-Reply-To: <20210925125324.1760-1-caihuoqing@baidu.com> (Cai Huoqing's
        message of "Sat, 25 Sep 2021 20:53:21 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0207.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.46) by SJ0PR13CA0207.namprd13.prod.outlook.com (2603:10b6:a03:2c3::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.9 via Frontend Transport; Wed, 29 Sep 2021 03:12:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d44e86aa-c5a2-42f0-caef-08d982f70224
X-MS-TrafficTypeDiagnostic: PH0PR10MB4439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44392FFD27DEE178F2C142D08EA99@PH0PR10MB4439.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ukrGnkRCQ+7ZVe/wg+F81oeK4sRu+M70z2iMjYrmhHv76pQm/UkM0Ck+MH18ZaRSqX62S02cJwnH3RhyMtuVyUpwqBdFpwaEZcEcpi1RwPYB7MqO49cjg/FVTGbU9nC119b7RGR2vDokyCDWCdtniUA6d8Akj+dE1392x/1yenASSqedTxQqhJ+tdAcuG/7RJZN42VpbTmp5sWgRyowQjQQWe2nbb+yqtQXtvq5QctvetC648AyMEMggGs5gdO7TN1+I06fM0rK8ooLR05lhszno1L3ZRCqP6kZaJvhnA1o9VbHqwxrw19KXd83uD9j9nIcMr+r9VO6RSJlvAoJ3XX1oRiXpX6bic9IrRGy3VKxvf37PkA5F7pWpCkvMTBQZmj6cc6luDqC4adRgKKhXhyFw43ZAnOae6jx2SNOFmn6a5cnrPQcz2q7VjdhMkuF6anZUYlCo2a+7MNtAewd/kV3etTwGqNf3Hw+iI78iaieG8ibKMZ7x585YXmUJ0PlJoEt2fdJYlXuAirYVARUFgCN+GsBo/rIbKf3GDbjvktG/u7i9+ibrzUXsZHTV94l28D7uUqykXg938n7iqTP97ehjkdTD1sf1eiELgr77QyMYxMwlBUqPp+A6MrkEqn4+Kc9ulC8WMtILQtPc0uUohxi+YiyP7ygN5TbCYglO1jA6YD4TAfUeuKL7nLyIH9KCYmpAiHv4n+8jDixBGCL35Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(54906003)(6916009)(26005)(8676002)(38350700002)(38100700002)(8936002)(316002)(4326008)(86362001)(55016002)(5660300002)(66556008)(52116002)(4744005)(66476007)(36916002)(956004)(186003)(508600001)(7696005)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O5pr3pWqzvV2C9FK3lWQrJb7YMwT1my+QdNNGC6cu14jKh2m1V0C1UnMVdQt?=
 =?us-ascii?Q?dpjVfUC5nURPJth6J74miT6PcYf8N5Xhb0CHu9Y+Vso71O2FeZFy9IEJ4CmN?=
 =?us-ascii?Q?sM9hvtTkRGugrS+dUC0Qov8m/e/Eovx63soOhGKM/j9/rZCcWKDzcAApYVpB?=
 =?us-ascii?Q?18B+6PSxRE1TC9tVktmumC1GWG8FPdwKFhWYwcMOgwABUAtLq7Llsxibf+Pm?=
 =?us-ascii?Q?9XMXJEXiJwY22tIN25IfhJoOp3zJ1nWuVExeIcVDz4ZkofVFAnuzRuTGU6wf?=
 =?us-ascii?Q?wdqe99rrfOhMeFsGCxm/nknAMU1eBcLzqq9tJwt+spm9nWv4AT7+tmxtIybC?=
 =?us-ascii?Q?twDrFR1LGORovxQToQxdYyWc5bWrp6OD5jjMF2/SaKCfHpe1yNaPuRtoiwk/?=
 =?us-ascii?Q?YsniMWfaNPqkaBsiDEhOSfZfCELULgUWAWLbDFvag8x4S5ChasH+K2S7lCR2?=
 =?us-ascii?Q?WpcGpMygGR/zMnCjbT9ukrdla/EKqxkg2xdTxQq7PDXS9h+xHep2iuxBNr0w?=
 =?us-ascii?Q?L0WGnd1taLGyd6bjijiOUNmxy20OPWE1UsUnqtopndDKI6GFXHfa3is9HvYC?=
 =?us-ascii?Q?Cjsf3tyHyiYgKX55Mw8r/bha93EugYKsEhUQckb7z2BCQGEGe9ieztM8yHjK?=
 =?us-ascii?Q?76tGc/MG+UcwSbSXpI1Y1UlMvS56Y94WZy7EOP4rCqc8wr35ew6uRI2qscc3?=
 =?us-ascii?Q?DoARwr9fraYltD5KwTTUgupH7nUfINIY5mVXhlSZjNTVmg1biN8JJK21dsX0?=
 =?us-ascii?Q?SuH0V4M3a+TLR373OSOBlGYhf0oanFVkU05Y/020rbPDLRu1EpwaOetZL4mt?=
 =?us-ascii?Q?WJ8rjK+DLFUxecWCDLpTMVBpPgN0PRW9PcE8XA9cXY0yCuaMqCYSHscdpZp9?=
 =?us-ascii?Q?4A+qrqWuJDQyDM6NpsArMFORBJityfLqS3TK4eHLOmEGhrHf0IYHF30pU8e5?=
 =?us-ascii?Q?TCHkTvj5clvputau2iJROVf7lkASsLrvQv8q0oTrkKTcCVW6y+Lg6RHSIUQp?=
 =?us-ascii?Q?u9URFUL0YCmXjArcr4nk5SEtaWHyj5Yck3tjrmydGxBnq/INMrr6z/0HGr6r?=
 =?us-ascii?Q?0U6G2veL2INlE7xPFJc7rzYABkQk36oAcwFyQalke8oAX9hnmoJ1sn9fzY1T?=
 =?us-ascii?Q?e6Zni1BZoKbJNabln2yvgxQCNftKR47ffyrG930Nmm21Z7KLl8JKvD4gSimh?=
 =?us-ascii?Q?OMHrks8VgNWbz9bsG2YBssEydga+wg/rUJ/79gsbbWDjIDMOhYOUCcwByg2S?=
 =?us-ascii?Q?OskS8yg0+3NYUZ7JLmDVO9ektlIe81ulrHW4pETtDfutmk0MJUsxFDIeGegv?=
 =?us-ascii?Q?BqoJPE+AFdp2PUvpwal+J6Ln?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d44e86aa-c5a2-42f0-caef-08d982f70224
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 03:12:45.5428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0STqOaBWM5/QTeFr/DsRp8lfrQN3dJdG16nSye/KCBwkoeeIT2etQExUqOycTHWMm5CmOmbbDVgFmkfEdQDT88et5B1ezyz4IKOV/FKrfrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290017
X-Proofpoint-GUID: k2Au49o9MneC4zE-7vbTujXjp3qkOE0X
X-Proofpoint-ORIG-GUID: k2Au49o9MneC4zE-7vbTujXjp3qkOE0X
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Cai,

> Use dma_map_single() instead of pci_map_single(),
> because only dma_map_single() is called here.

pci_map_single() was the appropriate interface when the change log entry
was written. And the original entry accurately describes the change that
was made to the code back then. Whereas your proposed fix does not.

There is little benefit to having change logs in drivers in a modern
context. However, these entries predate git history and should therefore
be preserved.

-- 
Martin K. Petersen	Oracle Linux Engineering
