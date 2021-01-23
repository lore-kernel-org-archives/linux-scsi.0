Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2646AC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 01:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1F8723B53
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 01:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbhAWBbz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 20:31:55 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48018 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbhAWBbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 20:31:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N1UXX9065778;
        Sat, 23 Jan 2021 01:31:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=CZnfm/fJtK48aEKjPGPwuA2xsOAT0PsdCoP/UGap984=;
 b=ZKvkF5JyRP40eOkidSrJmpJq1Vw+Vhegi1kJ1jKZoaaR2w8iCT+bRw4WWupyNfxi39o+
 3m2vvKoJT2yb3qyQMdYTMlihsPlUawY38PEs8BtK28hMAoG9JlXvlLQyVcv6UA33TDR3
 FJorES8GyVjnUX+GB/WPKLZS6y9aqajQrHX2h1xpaxYRfqiD2Gy61J+WAG/ij2ID/rE7
 SotwlZYXZ51h4etp2QvH7J7ExBRB2xM7U616qEWUbxcnxrjOIjr19ZDV+m59Y9ouFlor
 nRjq76VL2SufGGhWG76TLQecEFmbrhQpbDqIo1biGNXh5U7T2fo5SmMamdnXS31mbndr Lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3668qaptua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 01:31:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N1Pqng121261;
        Sat, 23 Jan 2021 01:29:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by userp3030.oracle.com with ESMTP id 3688wrakmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 01:29:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mP7Cg7jrxaDfG0Lxeqz3iy9VeHSbQmDvQn4s2YmULB0pcpH9HI3Biu2+lb0SEedKHgaVp4e+dvN6GJc6JQ7WloC0gwXz6EtrCerPWMLG4KbNqctvfgjJ1kOzPKHNWtCc1WBAsJXDFK++tonaMamTvy0IVOb1ATx9oLawYNkh14P0ohmgaV7wuDWbG0YzqvgqOphZhTaiCD57x6A1KG9VVFD01LKZXdY3lXvOF63m4K03jd8BJM3JssItKX0xTBtiGICwGVWBO6fjPzYLm+jB1iY5LPrreSg1KNjzo7oxkrbf/2Z0RsdOLDEFkZDZ3ijbiX1sHYUuZhPnHJSOJORjYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZnfm/fJtK48aEKjPGPwuA2xsOAT0PsdCoP/UGap984=;
 b=KDSAPH4g2qARvDouIsk6LGXl8GdeE2RUX2xHBnWp8Uw3TZy1ZxlPRLVJclHdj+KQSn8rdDL+BmE6nLC9SGY4FzmhIVDuWC5SIZybEUCFsSZzwRCdOS+TYqE8HaB/nMuN6UfnhmIRx8sE/juHs6VXKeo3BrcU3S7yc8NCXcgqbV/fAmE4SXyVdBSoJAEm2VZfnPxRfZC8+sgtD1Jb1S1zWlCGZJxf7taraf19t2ZG1hlkz8Zgf5l8nZvJAySDQYguyRFlszgrDdqJVh8kONHpydLDeaknp0P9ZEf90nQcRUH/wqsZK7iPL/6GpFlLKG5JA93mpDCLrb/C1FaYslD+hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZnfm/fJtK48aEKjPGPwuA2xsOAT0PsdCoP/UGap984=;
 b=LhEjda6O+cibu5pLTlPhkcRGYtzIyDv28EgbYrsHZQeXJoUWNjVLwOdNcEd0YQCcwPVULqlS/br5UrP1cQjg4QfEtB1cBZBFftm8ozlHXMnCnJxDrE+09vpBjAPLHNVRK7ivP/+nVZVRTq/J89SydSpkt6Qmc8m8m6Tsem55vQA=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4599.namprd10.prod.outlook.com (2603:10b6:510:39::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 01:28:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 01:28:58 +0000
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH 0/6] scsi: target: Remove in_interrupt() usage.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czxwcuiy.fsf@ca-mkp.ca.oracle.com>
References: <20201220203638.43615-1-bigeasy@linutronix.de>
        <20210122165133.3ejgs4d5tewnuvps@linutronix.de>
Date:   Fri, 22 Jan 2021 20:28:53 -0500
In-Reply-To: <20210122165133.3ejgs4d5tewnuvps@linutronix.de> (Sebastian
        Andrzej Siewior's message of "Fri, 22 Jan 2021 17:51:33 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:610:52::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR04CA0014.namprd04.prod.outlook.com (2603:10b6:610:52::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Sat, 23 Jan 2021 01:28:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f17ef219-33ab-493a-df3c-08d8bf3e415f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4599:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB459958DD02BD44C57394D7958EBF9@PH0PR10MB4599.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iIv2TUvyCFGRq5OH/0yOXpnJ/XW3XMYIDEu5Mq8uZBKudIC329ql1rrrg4SAezGdcqeP/IBLKJdDbepizAr9u5l3EboLrCNafM5/JNZdh/FvEuCCXQs8/zDOTye/OabCjWOKDRKJZ4wO7yA0I6H+QDP2rwRjhmSYRBDK2Xu+W76lN6PdEPr6fkRRICbyfpem7pFVUtc/GPc132oY1POgAsVLXC3vGkUt/Dm9TfszrIDuM9v3YDBl70c/L+gs3zInP6gt359ssV+R/0ZeZ13IF84oP8aFxuY6GNG9wgfBIHoHloqe/O4yPgramWr2syekunO4KTJimywfQXMHtVYjTi9OwPjkm/nxUNa5EOsOY6ptDnVhpVB+kGrGnrKyazZIVMuEa5gZgyMExPgWT351CQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(366004)(136003)(376002)(66946007)(558084003)(66556008)(478600001)(5660300002)(55016002)(66476007)(8676002)(4326008)(186003)(6666004)(2906002)(86362001)(956004)(6916009)(316002)(26005)(54906003)(8936002)(36916002)(7696005)(52116002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?whWk8r/hEpHwbbp+FX0pJ4zhSV7gA4U9KVt42dVI5mgXUp0tqCgQAMsval42?=
 =?us-ascii?Q?B1waXU60+9431tCYqb/SbYbiIVb4nUyHGYlEziHFqtIe5o1wZDc4ZhXAa7yU?=
 =?us-ascii?Q?iH6Hff4owy0UawAIx+iSiCTQRvHT8IFKkg2sbyMRZHvYIrNvonb+laeKKqho?=
 =?us-ascii?Q?uAC995Zf3QvF5F9qwEMx6W/zbDzFG7aeYfuFIjN4ZOcgcZPve/iOgBnvQJm3?=
 =?us-ascii?Q?smLQwHGJ9dAL7dyYj3dXGuBsmEf7hE/q+qQU8vyt9porAk/yjtUzIZdTahcL?=
 =?us-ascii?Q?Ya1600+/MtBCHPBTr1OeVA0pFfji0lJFntDhme2CWDqeN8q/E4EeeGlvgs+3?=
 =?us-ascii?Q?oTquOFg0NS91NfsA3hTz5mrIaQUhGbXc0djFRQPwLXsBJk22VccQHVUUOPyc?=
 =?us-ascii?Q?8RYaBEwzreESHqGyj27FLSTiBQvW87NdufhYKKzKpdqBznggCrRFybFx5vP4?=
 =?us-ascii?Q?ZvC3G58H/450zGnvvGxHSlLUSrsG5unob+rMzqK1JnFpt/iQ9KjuW349UAOU?=
 =?us-ascii?Q?cAAEtLy0mQKlkqKogZ4XnVs27F+bUlgsvCHNwTwUw8MqaCGviyut3iA9RMtd?=
 =?us-ascii?Q?rXUu73LGXMQ8yLakrzuJFOYztRmYl+IWHyvMkNHd3b3li+kcy8qANxqJqdHX?=
 =?us-ascii?Q?nFzmCYHRiwDoADif2Iq+400dz/DkQMvedxfSke6pmEenCRJJd4a+DF4k+zKt?=
 =?us-ascii?Q?YDvJ0n1lvL5Br2w61tWX8yw4DDWz80oChgXxa/L+4o9dw6Ay2frJK+5rYyAD?=
 =?us-ascii?Q?ce6ICcvYPJvQy+Hl+atuDldGwAC7W36KAcNkNGBE7dNlMQ08x76ATCSQS6Zr?=
 =?us-ascii?Q?+AFeluuWKFeiYw5FvmqN4g9MSB98mAEB6a4YgB8k1C2o3URQ0pEh14EXkFqA?=
 =?us-ascii?Q?7DjjP8h+pxIzUJxmq4xyfH6PqMC388hiXWcJAE01PRGKTAa8kwZkwvjmGtdC?=
 =?us-ascii?Q?nJmbEc7A3lnm9cetOj5PpG+HiJ6vjIE5lWl8fI9nRVMfTnskhNLbxylafR5x?=
 =?us-ascii?Q?UiUYLqBU0sMFbI89ytacdrMTLB1fR1LVF0Fhfzs1mIANMJH2xJhA76Okzk15?=
 =?us-ascii?Q?MkGyb7Oz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f17ef219-33ab-493a-df3c-08d8bf3e415f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 01:28:58.0426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4iTbUk71YCEWbBzsAOgmsZ61b/VOdvamlJObKdoZw+1mZmQ58t9W83ygv/yZP1VPuWo4uEhCOhQIbEpqMn7xdsK3bur5xjv9mW6QdwHAkFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4599
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230005
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230005
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sebastian,

> A gentle ping case it got buried somewhere in the merge window / xmas.

It didn't get any reviews, presumably thanks to being submitted right
before the holidays. However, it looks OK to me.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
