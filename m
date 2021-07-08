Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A89C07E95
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 03:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98FB561CD6
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 03:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhGHDgO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 23:36:14 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:46988 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230349AbhGHDgN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 23:36:13 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1683Qecb001283;
        Thu, 8 Jul 2021 03:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=sAndndDdyxbIfSvxLzyUr6jcNEqODNSJLp554tgDOmE=;
 b=v0zGsPJzpfzyJkh9586y5SyPeWlAAP7iBMJdNxphtNFCp6Sx8S8EtZ/5vmJT9YnTFxGS
 /FOmL0ymvFzLBoPxMN+fa0RB4s7bipPDf49MgTrR9tvynpVHWbs3yeU9yzktHBMaGLdh
 q1KrUOd2uuYArxNEIk/izJoQVdPJtZYBpzRrYDUL3S5e+L/WxDSeAVe0QRGmRAb097vI
 C/3jqnyJcW+wu6rbsAguLVsIUxG2xvvZD2ir0TqIlFKLOAChtPb9ZlZbfuZHRJ7qq6o9
 rGmxXOzSeOOGK1CHSKTdtDS4TbEw5fCybRWVcbeH08oMTvu8LIrrsP1EVObt4lBIchrF Sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39npwbr4ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jul 2021 03:33:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1683QXs5140470;
        Thu, 8 Jul 2021 03:33:12 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3030.oracle.com with ESMTP id 39nbg3b2gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jul 2021 03:33:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcgTkbCuwWRiDZXtyW66PKLzJnRUCFNCdWdJIJdjYO/l5ONvbRGzjOy998CIZ86J7M6dxskFvLwLIKR1/IfBCY3kmhh63E6EVDjFFCqCPkUHlKB+haXPWKg2vcckODvo9tvuqjUXycrs6GfCDxNEy669CA7iVTDGH1fuJtMWBMmep7C83Ro24WWJS3SgUo2YDA8bbJfIDQ7wcjP8IfdbZnwvnhQ/hf1HiKF9JbQsGZMioXylDcL24/g0xe5mZxZl/iiRMsvHliJogJd7oTaFl3Ge9IlErAaPXkXIiC92gYmDyRoKkTUB9oyv7rvxYTWI7SPdrnt+6PHvtm55D5mmYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sAndndDdyxbIfSvxLzyUr6jcNEqODNSJLp554tgDOmE=;
 b=SnNiO8joiglvp12ZdRGJMI8/vy2f3jSzFB4lnYkuOc5NQDMG2Bhn8lcR2bE1y6UNFazZ/9sIOJmWKS8mONPuiTtPjH4SFv3baMENGUACDJgGfJq4av0d4IBDSkt9xEebiMnn2TrY7arRwwmZ4CJJw23u+cQpdRQiDwVmafHeBR2Dcdw/Bh/oaXCzw8W2u2JfkeA3UfrZUhHhxGceqFGTW/PcQCf7T+ZlTL3RZBY4CkbJeGew2YLDUEpLCKb1vzrKWJCcdgbP05RRW/6Jqvwb3nnSlQvR0pFxW7fS/IGkHz5FY6Qaa+uLcZFF8l4zdNaoqPVmGwgz+4l5IL/lSazYRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sAndndDdyxbIfSvxLzyUr6jcNEqODNSJLp554tgDOmE=;
 b=UCiJrIN3tT/liHVBru6BJfQ3VgxSCkor+0N/RncQQsc0ro4lBP75NIHh0u0c/bejNN94I+g0RCLrgOYmQJaTE9LAe02kRdFZ1tRmuBktmbLWm230cGM3fvuoonPZHx6fnKpk3h/3qyr2eFbWTJSM/IF95IOmVVtQ1MqqLnQKMhE=
Authentication-Results: orcam.me.uk; dkim=none (message not signed)
 header.d=none;orcam.me.uk; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.27; Thu, 8 Jul
 2021 03:33:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%7]) with mapi id 15.20.4308.022; Thu, 8 Jul 2021
 03:33:10 +0000
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nix <nix@esperi.org.uk>, Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PING][PATCH v2 0/5] Bring the BusLogic host bus adapter driver
 up to Y2021
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0m1bhwd.fsf@ca-mkp.ca.oracle.com>
References: <alpine.DEB.2.21.2104201934280.44318@angie.orcam.me.uk>
        <alpine.DEB.2.21.2106110102340.1657@angie.orcam.me.uk>
        <yq1eed9cjkl.fsf@ca-mkp.ca.oracle.com>
        <alpine.DEB.2.21.2106250007050.37803@angie.orcam.me.uk>
Date:   Wed, 07 Jul 2021 23:33:08 -0400
In-Reply-To: <alpine.DEB.2.21.2106250007050.37803@angie.orcam.me.uk> (Maciej
        W. Rozycki's message of "Wed, 30 Jun 2021 12:36:14 +0200 (CEST)")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0113.namprd05.prod.outlook.com
 (2603:10b6:a03:334::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0113.namprd05.prod.outlook.com (2603:10b6:a03:334::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.10 via Frontend Transport; Thu, 8 Jul 2021 03:33:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e15a4e24-2ab7-4ada-aaa6-08d941c11c07
X-MS-TrafficTypeDiagnostic: PH0PR10MB4774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4774552F244056A238D0C7028E199@PH0PR10MB4774.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wAwRt0Hqt18pchWDC3IvJTVVIKAwfT//VOL1c0mj9BePBTXof63rVtNdR1XzSSd3P/alnrU+FddyanaqenAXqOlTjnfx9FtyZejJhHTmg54dGWuAhJ6YiFXVGBAgSXviZIiRHoF61ceHqKmxnSRV+g4UXeym6bwW7HSz1YCu1E2pskIaoAmN3nY/9sRq7zoh4q6Um/96L6egXpFJqsN8vWog3I1NNKvINJkaoi8LV5JBebs8a2qGWq8My5LqJ6w/FTgXZDSLmAtJxnaWxV6gJpBQ08m5sNGGnxlJpTMR+2TvsX7G0fgo6kWDfqtZduTTV50GSVdfA7RhdqpK8So1xkCr2s0E68MBF5FuF/hyZ1Jhxp2BCK9lIDEEJyk8Mx3HQMyE7Gj8bJXkoeQmnBrzPRDw7d7tXEeKzNpFo7X8yUUXOkwmt6USFjKCopiJDk4b8qwx5BoMfmwfIs1B+kMEeYXuJghjJ5ouSRk1szoJI7g32Zfh1DFBeraGkzO+mZVN1BvJzCjh2Sv5PGqtqamjk5OSc3Bry1OWhSzO7YpDt9aQ21PLJ9BycecS9fHDyJ+ov2n8RnrU2b5XfIWZRp0pawCK6LhIiUWlEcZt8QscMDJqqsWupUx63csh5ZSy16M9CQlc4Y6bBOFxafkT0GdNdeOaPBTMwwlheeeItqWsjDzXmCVf5P90CTI6KrPioKt+Oc0HpfmBi+mzps0Z3ccBCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(366004)(136003)(346002)(86362001)(956004)(186003)(66946007)(55016002)(4326008)(26005)(2906002)(7696005)(52116002)(5660300002)(6916009)(8676002)(66556008)(36916002)(478600001)(4744005)(38350700002)(38100700002)(316002)(54906003)(66476007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4k8tQOD6ee3q3SLrEeSZL4eYK7FNS6H5nLU6pXhvx4q4cre9s0+LIP3MpVhd?=
 =?us-ascii?Q?SIxZiR9JMh//7LJKMmKq/vihdW+CxzuUSifvGoKZzVmLdMSro9t4Qmmmnm2/?=
 =?us-ascii?Q?0rPtrA5D7HhT6HBSILxLJIQhKWs1PysU1+Qwb6NWeRXtK/ZgrhbrXlF6bkfv?=
 =?us-ascii?Q?Dclc9d/6YkNUfyGT8rnDB0ll/KcHL7OAjJai40ZmyBtn5rBGZ/Q6D8CjdyJE?=
 =?us-ascii?Q?D6bD0MYRPMdFrXb6EbCN0FlEQatOcu+dZN2z69L/vOVgjq+6pTvjniKb24aq?=
 =?us-ascii?Q?LFyYqFsuFAvAZr+rXT2b/AnF0qFUmefBadBQGZ9wZ+r4B4W8jb+TBcVhfYld?=
 =?us-ascii?Q?lhFyC5gznaagiTmyE5+Wy2s8Kuu6P4HzpTepMZVWFDoLIpQBOTyEj2lOpdre?=
 =?us-ascii?Q?Uzq86NF/U9o4QPHKaFDbSl8yV034e5qQq94uD5ybGkt4VX3wEG/mT7AGegDp?=
 =?us-ascii?Q?24goQkHYclGyKyBCjhXiO62+FWADOzg+hBBUOKZsgFvBk51EhTHOnjxyOHz0?=
 =?us-ascii?Q?wxcGhQb6iNCj43trM8kXUtvaNzcyxPw/FDF/6HfhevyAJ2dlbFO1cbWLKzqM?=
 =?us-ascii?Q?QeD/VFSCwhyWczBc0FbMGzjCAg/LCIxgogQ8+XWLUIc5oSUjV4qUm06ZoDyI?=
 =?us-ascii?Q?c2D/cMVBJ5DK9ADwHoPTkdRkn8FlmR4a5z2T0WSVB85IJ81LFfmukGWqsJJc?=
 =?us-ascii?Q?kcqbDDxiQ3LgA6XPMPzDmcnm5wURhHlHpRkqtr7ycY4BrHdIUlxPU8JgTj0i?=
 =?us-ascii?Q?L7jVCVOnpfYpw+MUhmnCvDcZ3iny70hFpIac4mnjEq+zIaaCpglQP/e9qGBN?=
 =?us-ascii?Q?dWrb0kPnE7cCj/3d0Ktwtq8myT31A55fovmiIGUu8+goK61kQybGMl14Ozry?=
 =?us-ascii?Q?DUaGen6TwyqO6TJ6+HymCbZxw00I+F/Pv1OXTTr6w4PCGq0yUKjYjBnYDWLG?=
 =?us-ascii?Q?2UNLyxKWOy+DEr5K7jUDQBwpBiEjchSaaYdOJIpgUWR8bV10wJBkhABF5aCC?=
 =?us-ascii?Q?2r1Kcs3k3anxkrMYpXc4N+KlYBKoK8xm69zBlJ1f1o6SfaLVnhtMJK3CJHDN?=
 =?us-ascii?Q?42HdGSC134qqUOeM8hGHSzYvIYYI5/bxeyoQY7qVPh1iQ6l+yMxWq9zIy22S?=
 =?us-ascii?Q?XPQzNGJLkwG/vLoMEn9VinzxomNRQB9pCsWiCDZUBlF46OYrCbl8fQizdO9K?=
 =?us-ascii?Q?U3yH0GJokHTf0PDd1lN+euotEm/C9jHYgcPrdM5iQpotXtb9CJoSeeuzPVfy?=
 =?us-ascii?Q?8+/O1YafGwN4ZkNyT7rzQutSgpJroFeTPxkdt6Ff/YdfwNk1uog/ngzzelkd?=
 =?us-ascii?Q?B67CacVwuiRdaJQYrqDhfacX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e15a4e24-2ab7-4ada-aaa6-08d941c11c07
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 03:33:10.5359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PEDHXYxRU8OGGgHxhsmYjBcMbKB/iSzNCJxCLX9z5UWXyExvPgrDbr6YXzliFjORM5sq8Ch5uGkehoYhKl/g1i+ZVEokDzUtf8MWj/1g1Hc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10038 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107080016
X-Proofpoint-GUID: xc7csMC3Hxncib25Ah7mQvBkRNGVZyX0
X-Proofpoint-ORIG-GUID: xc7csMC3Hxncib25Ah7mQvBkRNGVZyX0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Maciej,

> Sounds good, thanks!  I got distracted again, in particular by this
> nice HiFive Unmatched board, but please do let me know if I can assist
> you with these changes somehow.  E.g. shall I resolve the clashes
> (which branch?)?  I'm away from my lab for the time being, but I can
> do all the usual stuff remotely.

I'll post my revamp of the VPD/discard/zeroout stuff soon. I will
include your Buslogic-specific patches when I do.

-- 
Martin K. Petersen	Oracle Linux Engineering
