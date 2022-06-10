Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5160AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jun 2022 17:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbiFJRIn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jun 2022 13:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349541AbiFJRIm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2022 13:08:42 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459063A703
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2022 10:08:42 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25AEOiJ4013372;
        Fri, 10 Jun 2022 17:08:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=xMRw9QDLLIBSGQq2ExO6kPldNNiXd81mJF4LR6t6AWY=;
 b=i9kXamhKhPZUXD454yG0ZwYeItntuO9PDXglURCqcuJbs0OkjvhGQVkH7pnxbCEOJ3Ry
 mCgP+3SU4VMEoy8ihJ5PRw3SOvjU8KFnIGWBpEU/hGmA2IULp01vDC4NhH6YbxFYm6nG
 7Ym7BQ6aAPTWLKfHbzDtQmOGGtecEItQn2NB7FkQzZcbYlbJy4P203+CtEuX6MkN8yGf
 RrYBPEx+vzOxHba6uSbZVe3Sx814KsU9ZbiEJvYEiy1/sgv7fMMb3wQmBHjBoigXk1ho
 oxYdbQgM9dwUReweX64q8pt0Vqc/OvvOAsxF0LAhjE+5YlvypVnGvinwLSkBmr3il2CW 4g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfydqx4fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 17:08:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25AGjvhE019842;
        Fri, 10 Jun 2022 17:08:30 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwuc6x32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 17:08:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TjfEqTd9EByGxys9X5aFJt5F1e7y8YRRHMT3s7iHUFYkmf/zp/iWN7JPJG+OZGhW7TheIjHPvFzhcMhV316Q1+cIcxHdlVe9ZWcNnXVxoDVXviS1POXLd2VWAZaIEkFZ1lX07z3WSdV1G6V8GDGvcj7AQVSJmRSiuJva9+fO58262RuBrP09xo9rUoDjeRvVFKZUDpw481deWiO0jWA2wjwE9wFm6gx77DtUpDBrx5akrpyw/r1MsskAQTNffdq5acr6xRsE7TdRIROqqdY16xO2fg9vTEivfULEQmp3xljUQC1FIhw6dd0h3jt5ioAxUHJDnxwdgUDuDs2ADEl8sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xMRw9QDLLIBSGQq2ExO6kPldNNiXd81mJF4LR6t6AWY=;
 b=g+Y/J5Jlf9Unz4mJSfQkLnAjkbzzwOSwxAk3uHtRqrLLLf1yNCwfbbRLLcQTzFaG4cWMm7andtRH2C7CVkIXKDTmyVsXvabe5gji31xZOCBS+RTuI6DTiK8VIZZ72y24tyNamORyRY2JlkDmTqZmTOrhWMTymXSwGjbYjUEAzcuBkvUapCMOtHsVRpT4SfkMsH/ep3K6m1UhIBbUsKD5ZhQtXwkHUMtmxb8LPSENFFnh2f0mAnkBLkGjJpb4Bph8B4JHUkVxaZZaxg80cvE76gygQRMT/BjTNN65wc5nL/PEWtwt9hEbHPNOv/eigjxibOskE8CMkvMRr5EzZH3UVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMRw9QDLLIBSGQq2ExO6kPldNNiXd81mJF4LR6t6AWY=;
 b=PibG0uk35begbYm8nawcEWGAiMSL9ccNeCHoK6CnXFeObe6QCtpuKjLhy3ig+NYlgY/bNmdyYEvMBtZx6uuv0vZ99C8Oywf09EGi49q30xkBzmstt/iGheeqo1xvylYREdrZVvZ8f48fRU1A3iJd8ogBcFncx+hyw3GAo7tHVpU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN6PR10MB2543.namprd10.prod.outlook.com (2603:10b6:805:45::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Fri, 10 Jun
 2022 17:08:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 17:08:28 +0000
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 0/3] Fix compilation warnings with gcc12
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y1y4v43f.fsf@ca-mkp.ca.oracle.com>
References: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
Date:   Fri, 10 Jun 2022 13:08:26 -0400
In-Reply-To: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
        (Damien Le Moal's message of "Thu, 9 Jun 2022 11:24:53 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0132.namprd11.prod.outlook.com
 (2603:10b6:806:131::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e681185-5d58-4d62-c74b-08da4b03d68c
X-MS-TrafficTypeDiagnostic: SN6PR10MB2543:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB25430E91872E7A07982D2FBA8EA69@SN6PR10MB2543.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ktM93i3t9QXl3IxgF6xe38Hl/bfOeDO6xzxp+mr5i0BelmrsDlOuURfJBVqwF4nSRmi0bS63pzjalilWrXgvBaxEArFXqSRpoapZgq3na8ylRtGSfGzoCFHWYKnsr46yDdk/k0QP8ZwZ0/4vklLY2vynBxMtyEgHEh0EUOM502UFGI/qoCmyH6xIlyRCDlHvn14xXGqrv8wXswBGkRoK+W6NE8VAYjHDir3h31YHtNHVu/EaQ+C8GlVSoFYFw0hFra9vilQGopMG4u33yhM8/2oB1hsgE6OKyOZoY4iOjJoQwZKo8OyU60dL+k4PHPGLx0wN/cqEVNFRLuRAlmwEbcn8OY9ZVSbheUuXrgEOXfpUZg+MzXALp0iiQlIalEzImc7Ji71jEMNC3G6U0wUeEd5onkGMZIDYSXHfVDWdzxpDhYL/sKxgFrUROyKW8ETQZw9Es3P1wbr78tvl+ofi8+jdAH6kMP8WHDqqyixozJ2pP8OTj0fd7SmyCJgnjiM6Y9gNs8U5pY9wN6uhYuUtT8kQI34w9di5dDONEg8CMG/wEjo6odfVlnd2F5veyA7FZUksJETbqkA4PmkckjzWpdvX7Ro5uBx6vmZxae8jy4Q17OhJXIlHi5qR1ezniRhOfXX18II6dMgsstthGFBsjPJ/OIV0RTQSWUZrMxgrQ0E1Ns8SNx9EJsRHJp6K9pLd8MMr3MAK0R1irRrzBkbCNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(52116002)(6506007)(36916002)(6512007)(26005)(83380400001)(38350700002)(38100700002)(5660300002)(66946007)(8936002)(4744005)(8676002)(86362001)(4326008)(2906002)(316002)(66476007)(6486002)(508600001)(66556008)(6916009)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jsd7jiwXbxT3rl+DzSinFzoaB4kmag9axIXfOHsY7wnvThpO1xRXTdc5DIgE?=
 =?us-ascii?Q?GvsgyazJhl3JljVgEGSyxpkRXfSivgS/+lAl/0kPu+5KntPBiFYiwOUsGgEH?=
 =?us-ascii?Q?l0X9FSJNpW2rKoIjXYcVyrjj1oBQSsTkvJMzkNJMYuYeWQU647FQqkzfDTI7?=
 =?us-ascii?Q?C2R3BscCpnqEyuC2X40Ows6cdy9Cf0+TUH19Ri+R/hYNVc+c5iRjUKisQzij?=
 =?us-ascii?Q?D1ucdK3JqSDrsXfOPjCekzMEGRJB65N0Ia6dCfdLu8y/Us8Yqy0BnXEYLH4j?=
 =?us-ascii?Q?JSCvdHcZzHKzutIPXfcWc3DBmT7V2Pw4gYg/yy3WrKJtuuP/UnIjTlQDYCGY?=
 =?us-ascii?Q?8p/8RqLru4deFKtP1mnyq9zS0LU+fmfcZ/Nh4k+TDWGjTu8UnPeM6KkBAZlX?=
 =?us-ascii?Q?vNG1WKlXj8WCqZV4HFZtH6Ok5v6ztjEyYNdG09qwAHOssZslgwtRJvhPTV8s?=
 =?us-ascii?Q?PGUY5U5V8Xm/86XId2aQfLfmer48hJo8ND6vAIl/GJ9hHvnFVzB8IFUjh/yD?=
 =?us-ascii?Q?Pq2G2F4QhBm2dWcJuDLy80DfFCwiDBzNjY4DYV45iPgEhCrZdySSP9vfZGSv?=
 =?us-ascii?Q?FVkFkgiRrhGmY/GuN1rzuDRdykyojtU9tTD3niq3ynXR28J72irtYbde4JIf?=
 =?us-ascii?Q?NJmofiPDiMdNzi5rpv5gZenfvh7BXn/6lH4BZRkwdgkO0nr3oCRjZl1oVCVZ?=
 =?us-ascii?Q?AZg6XCaweazudoU5cacbExKj/fInYXss10B5TCQMP9wa7CqAzJYwl74GE58x?=
 =?us-ascii?Q?aLImZk9q842GRKdOzuHuwoODlM4KWv3XYI1r+L4omf/TMEnjzUc/wnr4LsZi?=
 =?us-ascii?Q?tLUupS7lcmZbWchmdfzF9ozIjlZiEtALxuDh86yDpnenYRkydPOpG0bKbX1D?=
 =?us-ascii?Q?DwrhSmaFYx7C/acVdVMcPU4xhaosPhheHHTEy7OucQ+70tHm0vVLltkfsWY7?=
 =?us-ascii?Q?MJ2IVKREHMTW0xBVCrcOYtaPmTS/ntq8z3fzrWCKEWWpiuYug7MIrhWxZLt/?=
 =?us-ascii?Q?JNWfGWJvEMwEOMrME72rKQIsMh/1jyUCjTe52aFe6pq3lTRZOO9JCBSOp/Mx?=
 =?us-ascii?Q?B/NThfk6UHKmNGshiLchzvr0nuReciSq6WmVmrtWliyPsJn0rHotpSczrNLA?=
 =?us-ascii?Q?zU80re+VTspzqymx8Anu/6ym2t12XqnfW15KpeJVwOmQGA2isNeNb69Slkmq?=
 =?us-ascii?Q?gTiZS0gGZcp9BsXjH8im1gClE+CRAhbOkHwjRC+lqXcXsUmC7f//PP1+QZnL?=
 =?us-ascii?Q?fetT2yGEqkrO2UrpL8rNUeeGVPRBpB8xkOKukVRvYUnm4T+jp5vIUdCKnJzO?=
 =?us-ascii?Q?Lgeqm89/D3+le+QI5T4QOgrb1feUhyWhsM1vPcr6IseVVida1pAsdJeIHMqF?=
 =?us-ascii?Q?kr391e6dEMYAvBPbDhvHazi4A8uWfNgGBHrRJpxmo7eo/6CX8qtdpKccq8Dr?=
 =?us-ascii?Q?F7ELX2WIcbtseeHuAMTCUuXyDcA+zlpq64281Pi7tr6Okh95sDviCu0Ig481?=
 =?us-ascii?Q?zWpPmMWe8qZbel7CJSffz3JtTvpaFJfRlaXlnKF3TTYpwjaGpVQz6tl4bgre?=
 =?us-ascii?Q?7kifM/hrkUG+b/8ttT/C/4evpjLBr6NHBKmXvJwX1BR0yDowOLIlsktlDYK7?=
 =?us-ascii?Q?Cxk8qywBy1ZbbYdMEgZxL3RgrNO5+fVaG/Yt/RsaPVtOvtyfDsdRenRZbWEQ?=
 =?us-ascii?Q?RI0hunBy0+k+ENm9ACBonSx5uHGbugbSpsVIA76KalrTjm/7FfgJmfJUMxz0?=
 =?us-ascii?Q?kpNMtgIlfpzxY5gw4c8oxe7E7jXfvGY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e681185-5d58-4d62-c74b-08da4b03d68c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 17:08:28.4131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: plb5Cgj+3vr+dGF7TXcAG7/ywniyM/Qtu6siB1b9+WEze19oRR+h7kXsilvHt4/7i9/W+uLsX8clJs3IphOPcywUWgDmsNvMrpKlQciqfgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2543
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-10_06:2022-06-09,2022-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=828
 adultscore=0 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206100067
X-Proofpoint-GUID: kSVHd_ir4QoYZ0LQlEwAlPxBX5CrbQPJ
X-Proofpoint-ORIG-GUID: kSVHd_ir4QoYZ0LQlEwAlPxBX5CrbQPJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> Patch 1 and 2 fix compilation warnings with gcc 12, leading to kernel
> compilation failures if CONFIG_WERROR is enabled. Patch 3 complement
> these fixes to have a consistent code with regard to sas responses.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
