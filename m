Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B06A7C43334
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jun 2022 16:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349815AbiFJQwR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jun 2022 12:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349710AbiFJQv4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2022 12:51:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1CA1F42B5
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2022 09:51:20 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25AEOu5E026118;
        Fri, 10 Jun 2022 16:51:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=mTacVMBAgRH42THCYKhZIO+1vFs2KLo9iV/8vKOA7eY=;
 b=R8FrOfHygdJN7NlQolynbALpk44Uf6jZPpR+JThT5G/+Bq5OJmlCNWdMV1Iks0fY4vOi
 GMa/wu2hZhfUnq5nny+i3OpRMSV8sKUL+LUFjRe6PM5612DYrmpmOagu6y+dmzBS4o5K
 UmPD9CHY2KX19kLVreHKAtf7iYnN7yJ5EdectKmnQ6YSAD/eIYiby1iG+G5rXS4okf8m
 oLdHkShLGx1EHF7NIJeV3GT3yeWwHgxM7wm2CoRjIk+zopOiF+ndh0AAYorKorieFPCM
 5WSyQq8hr2qUCeQ3em8M28+lSj5bdfy8CPgr9l2be4KKj73ZAVZeDb5kWeydJmDI6KyA Ow== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ghvs3hbmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 16:51:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25AGkbeZ034560;
        Fri, 10 Jun 2022 16:51:18 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu651x4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 16:51:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cyilKM4q3v2tF4/o092QmDEBAmBBiLp7Mm7kWf+yhes18ZjWsEvKZk1gafIu1xu38MVrk+Z9onqF2eXKHD+aNmJorYtipcyRfjaIZsCWZ4uWUheNo+22RvQrD2tF5r2x0sxwfWbH3EyXF+JFm1ADduT9nKLh65Rzmusp7ZS/AB3qmI+Nrxc8MYjlXBkd9erKgVYJbxJf51dR7cEloiiI9ssH7f16pbahwYK4K4hIOUKRs4CRKYk6LgvKWD5+QfIrknqsw3vJVfhpAwL/4KxxYWviOxUAwgl4eCJzB12XfXNRh1QqktFHklYlFiUGEBpnoLcTAUJbGLgJ+Qqw/9X0Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTacVMBAgRH42THCYKhZIO+1vFs2KLo9iV/8vKOA7eY=;
 b=d8URSKSO+visqcXab5TA4ziPYmCLAMNJGRkMYGLB0lTv7T81Q0dP48K13EwbS0l024cFd7UWDL6sskJhPiOJnHYWNPe0LXVOR73rlHjFgWteSYG6e6KGVT1I10id4eJNCIq1G02TsB90sr71VRW+GCBYbgDXSt3Db005fIkkzfV+5t0HgbArP8g5PKZloavkfNyKKfwmmRn6FueoaaTYwNhIdj4UAtcuoOyE9lOtuX5+U1dTsME/GuO/7BIfNnrkTQzC89Js3Qg0MPDIb0TauzrH+hwNIt8Hrv+DPQ6mzsFL4XgD5Yz7k7r+WWaTm0VgPhbkQrHaQWG1Sh5115ijEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mTacVMBAgRH42THCYKhZIO+1vFs2KLo9iV/8vKOA7eY=;
 b=Ncv3BdFbsgaIl5n4btnQPxYp3UDv1buP2WBaWL7uil58m2upbcqtCMMw0/bkL1ckcPNi6jI5uhSyjCBDv3YLwL4uZ/sIy8wGTlp/AP8zkTb5PNoZR5WNiFXC/hzuLTnXyJKoiCUEPcQxXEwPQL7s71V3eul5X8tZm3EzNwAXszc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB2842.namprd10.prod.outlook.com (2603:10b6:5:64::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.18; Fri, 10 Jun
 2022 16:51:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 16:51:16 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [PATCH v2] scsi: scsi_debug: fix zone transition to full condition
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6akwji4.fsf@ca-mkp.ca.oracle.com>
References: <20220608011302.92061-1-damien.lemoal@opensource.wdc.com>
Date:   Fri, 10 Jun 2022 12:51:12 -0400
In-Reply-To: <20220608011302.92061-1-damien.lemoal@opensource.wdc.com> (Damien
        Le Moal's message of "Wed, 8 Jun 2022 10:13:02 +0900")
Content-Type: text/plain
X-ClientProxiedBy: DM5PR19CA0064.namprd19.prod.outlook.com
 (2603:10b6:3:116::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbeb068a-f659-4d72-71f2-08da4b016f3c
X-MS-TrafficTypeDiagnostic: DM6PR10MB2842:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2842EE9EA956277E981F1FAF8EA69@DM6PR10MB2842.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ClZNQmI3k4043aSjGYkz8xhmpj6/wk4zaC9IJZO9v3uV+MwpTRMXybcety9YB9OOQEDL6cny/isTGxZPlG13hMyARCXxfiRJX2C3Q0hAutqYPb8mYIwaXwwhhiPH5HX5x4uyu7RjqZvS6ip7dU9VqXIwIvaUpGI6ul4iN+dJJALVpzFnIpgV0ogZ9/2CWd7/er6dSmzagW1h2uy96JSZepOKR3fIYpa6TfWITap1VVXTWS7hsVLJZRff+4L7YAt+0Fgn5riPcaiuuQXQP15D9ry5tsBMD/tIWmmwvB6HoV0dDn0M/wMk46XNNVnaNjEr6mRJtwtuxFubGjwhIw64SFhuEhPrr9HxYu1gejYNE6OL6KLo0KpzHvzp7zK6jh8oaOx3MfTwybLuQ0KfegMj3jhW7IcZXj3MC43j2oZrJnJdfnjp2lEl3ZLbKAjEL9ye854VUrKFELtjQRofzHQB1yrEsOHcjOFxTz6OdJrYXY+edXuZWj7VGW6Pjb/PdrWyASSDUYm6yzd/yb5X9EMPDbbcRbd7ysnBwzXdTqjCsE/iK9wsGWAUQ9sW5xShzZeq4Z2vt64hJPPVoDYA23+6wmGL2r1A1XKtPeRVw0Pq/579jRKzKo8UkL3Q6e5hp2RiO7RL8ZdO9Pak5O7dpnbmdGi4MLF6x7vBLo7dvIKkwrSuJ9c7RDlxoCXVg4Nyq5F9e5RBaSncU+ydWoEIQqmY3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(558084003)(8676002)(86362001)(5660300002)(66476007)(36916002)(66946007)(66556008)(4326008)(6666004)(6486002)(186003)(6512007)(6506007)(52116002)(6916009)(54906003)(2906002)(316002)(26005)(508600001)(38100700002)(38350700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yDQOKckhVRsYEEeOGctmhp0BxhEwasrWilh/WR7tSTSKX/UA36mU4gpAoZuU?=
 =?us-ascii?Q?OLvK/TJIxLR0UBAZB6t/yw3JaVnVhw7ga3McPv4F9k8Zkusd9vt0Bq4hw923?=
 =?us-ascii?Q?3hlJTS4RDGTUSAG+qcmuUomOxEaqlEJuyGgRmzOn7NOSZig3Fviv20/a4mf7?=
 =?us-ascii?Q?2E+SozEbMZwuuNqUHiLS1skRv8zMesCwvWekvnauoCKqu/CSa8+BZoPWbJ0+?=
 =?us-ascii?Q?9xMUmCOf0nOGpqd+i6tVq0qV7os1CSqv0Eqr4e2P9xMIXVJCw+xZXaqRWKYy?=
 =?us-ascii?Q?rjZuVvah2Y9cjG4TP829B1hrBQB9WO/ZPcvwbZyEvby1junm7lZ/I/rZwdma?=
 =?us-ascii?Q?HbsQHHcEb99hXS8bum7ZclaJcfyzETzSBeSK0ra3tTPv0OwEzVp+oTutRvDL?=
 =?us-ascii?Q?HK12jvISU+hgnOEfx49+BY/RGConV7e88cuBObkygHjYcY/SBuKtd2yZyUgA?=
 =?us-ascii?Q?UNntmg4zIrNSoK7947uhwtdhveqtfc9yeRSpJj1H5Rw4cpCubaFlr5s1tC7p?=
 =?us-ascii?Q?DR4BSkdFAfAaDT6f9/njN69Z84/YpaBXNBgcD7TPXh6boA/bI5N6eQw8bWLT?=
 =?us-ascii?Q?pKdxd1CxqrHq8GCCRonawRtJH8QONXG6YDjEk0JOZ51tKyeW4TU+c2T5yYJs?=
 =?us-ascii?Q?SC0VwmGs7uTfSUaUNGDfwDyAy/G0cyhDxlovirDKMjg4mPZ/hWtYQTnYMnts?=
 =?us-ascii?Q?BgiaaxUVoYQUDoXADvcSit2JjsHigsHoa14ofEdcOFoiCBna2ZnUZlQ5rykm?=
 =?us-ascii?Q?DSODIMGPRzqYpjegQnAYU2r2ENoUqWGVfwUXHmHizrLRNpmDCGRnJwnLjc/p?=
 =?us-ascii?Q?JbP5W9HipRBqioaYPmgU1eUtzWBVKl70Nmrilz0EFbdmC1yeID8SLywbNviS?=
 =?us-ascii?Q?9WvaMmZu2/yFSjlghCS5pQiBvpS+6Fccn+2h+EyBtNBE7aafrsq8yFBAQkMz?=
 =?us-ascii?Q?2uv0GK+I+F9uGUueGnouh+xkJVZilcjvdDKiPwKj56gBJwHhreXYmWXE1iC9?=
 =?us-ascii?Q?D/Wwk14Cc1sQcarg5Vhg30D+uOXYYSgd3Ys+KmDHOFHOEnUcMpoqgrganlkd?=
 =?us-ascii?Q?4y04YUGZhEMXpyUQdR//wp0ofHelPhxR6iqs7n8Hv1iBIMuS/Tr+1+5LBOqk?=
 =?us-ascii?Q?Y9R8BRPymB3L4hgukBSnpNLgtr1txrcR/r/Xto+V2QR1kcwsRbP1MFZWzZWW?=
 =?us-ascii?Q?36uZJjOjhp97VnCN3qlyHP0GJ3M6qycSowo3jZO5BNuCv+zo3pGcK4wEU7OC?=
 =?us-ascii?Q?LGH/JHyl093Gy27Y78KK2/PdUcM+b6d5ZomyIQQo1e1PVjtu5B1F7W+Q3xLF?=
 =?us-ascii?Q?c6u0+WDMaEoIgkmBZgVyzH/KvwL7Ay+Wa0nSgvf2irb0lUdra9OhyZD0jspt?=
 =?us-ascii?Q?kDst8FBINGzmFcsvj0Hca9GMgn8iy/AdjQSN2Mci0JNiA4nBYlTncExigvr+?=
 =?us-ascii?Q?gYZgJbbxam0QjScvsqS66+onY8mWsfrsTUdMxF1+yJHnLPfEN/z5eN81G1L0?=
 =?us-ascii?Q?yasDuFYEHYHUBWoUUbhpyIUexmy2EIMToOaQIicaI9NhOjp+zG+O8LDuG8pS?=
 =?us-ascii?Q?Dzul6uzuNlVZNIQVAtUP50rksJCJaf1QZQpOYcCLsWc/NJ3/PFNT++rSzHsJ?=
 =?us-ascii?Q?6FsfM4JsWSx3imdn0WZIXYG+9P4077oAgW0XL1pfvEku2HYpxGGLkOOYj7uY?=
 =?us-ascii?Q?0jM31zqSzEr4TxuEbm7JBP7ajo13YQ20jH7PExHX6vJcGUWnOfYqqBEzEcrF?=
 =?us-ascii?Q?lu96iCOY90rPdJHdZ64ZHvI2EdZFtg8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbeb068a-f659-4d72-71f2-08da4b016f3c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 16:51:16.1035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uQzIKRCiYnnuQI3kSm258moUcOHTVYCYnCnWq3wUkJorEbYUf2Aid7wkHTl+PH9N60lAzT1Er2h62CMTG64sJTPP/qE1Wkiih787r9Qmj2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2842
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-10_06:2022-06-09,2022-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0 mlxlogscore=848
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206100067
X-Proofpoint-ORIG-GUID: J4waLs8D_d2sIbcKV4PaMOlbM8eEq0ga
X-Proofpoint-GUID: J4waLs8D_d2sIbcKV4PaMOlbM8eEq0ga
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Fixes: 0d1cf9378bd4 ("scsi: scsi_debug: Add ZBC zone commands")

Not sure where this SHA is from?

I fixed it up...

-- 
Martin K. Petersen	Oracle Linux Engineering
