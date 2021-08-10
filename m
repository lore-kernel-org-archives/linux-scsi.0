Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 286E2C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0619A60F6F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 03:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbhHJDMV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 23:12:21 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:47642 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236425AbhHJDMV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 23:12:21 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A3B4Tn014820;
        Tue, 10 Aug 2021 03:11:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=DSwzWC1tIENj74tJgsBdrNn05tr8YdiC6Sr8R+qEwmM=;
 b=byY3TdjK3NUjTFRn4D/lZG6d3e9tE8vnZ5OVXFZ5uxjF47ARxtLZZf2xSk9nnGonH26F
 9PnfCac9KkmPoF+4dv3sb/aHzo7HJWesDbwbm85V5/iCQd63hLpxOSEEAZnaEdLgP8oe
 etAtIGUP0bQDOA8ZP9pier1uG0a6o3SaFY3Dk+64Q2wx3ncjEQW90rOy/z2ImVB0Kb1X
 sUYznkwqewnepJ/rtVQV1IRGFESJrct1WbiXrDhdJUHK6Fw1uSrmN1yM8i3HqouZw0hc
 Vbvkxadh+AKr5reDso1b70CWaMOCBkQY8pepBvgvDUkArh4u3vk4zYscAJFm7+4kjAOl EQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=DSwzWC1tIENj74tJgsBdrNn05tr8YdiC6Sr8R+qEwmM=;
 b=MMHjRjZktVlTm3fjhP//JDsZgWc00r8LJlhHKsoqSEgNZSq2KQez1drxR2Cz8dxxEP4X
 7zHZQAm6qvvct+CZU8gDziPU3+x05ZGvNcNVIZPjlf/8BXg0MTvtzwiYCvqCXKJxrRz1
 U9dM1AL/hlqgCgISGq3lkH++/AQg6xtiWh3My2uTG/rFULfZMCvefxYZXN4T3i217faJ
 faOVe/nM+3+5ghnTtLZd7mDipEQWv/sPARoAy+fUStHEefG4abNwrl/q+/dnM/wtx5PF
 QGNuJbuiweMYwr4VF81Zye5mf1uGqdQbS7OFIJBowhM7ZFwX8TOTuaUggFipanEz94Ig Lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aaqmutunf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:11:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A3AW4r112739;
        Tue, 10 Aug 2021 03:11:58 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by aserp3030.oracle.com with ESMTP id 3aa8qsbbhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 03:11:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oHLBxB7LXRQgpjwr9yDBLwEmpVwcbQWAbIccjajj7HjKzb+XIsa0B2XWuvkfoyAMKeAgSjf6iSD5A45ee3H8keKvxlH+OW7cL2qqBLZWUXKzVnDPLf7CDCWJw9ABPlhOwNOQ7WmdaalJBErmxkuPEtmJoEPIjDBOKl4YoVCXDZbMoLMdkJU5w5myyjvTVsqr9X6QDj+bKd2cVk26kb9tu4NdsodevroG924gzaM+vzj/Rc41lfmqEFTHniJKFi6LQvqdZfU6djFvgEJrQHXbWSF22R8GMtDbBINZFPQRa2DG/J39+1e1N7fe+oRyyM5NPUV9DXvP/VCYnATxQ39ZJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSwzWC1tIENj74tJgsBdrNn05tr8YdiC6Sr8R+qEwmM=;
 b=l5gbxeXO5VSPmtCOvZz+R9vQ6pSpLwMJROtsY4eYnMGLuo+FZkBi86FkNChjYzqMV8mHGdNPBeZ/JCE3rdJgMLPUk78wFJaBbI+0xtO8m8TEdJPeY5tP9pWsKG5hWin8VAG/ZymksjPZ4xo35YY7bj9+BMRCFQKVMKIEJEXqCAKJ3R2FeF35AoZB67m64mvpLtMfnkCIa2XClpoAeMy6m5i82LFwnMs1zmgMQofU22bvIp59kJHHXSUIQzv6z31jN6W4YMsl6FyqrcmHFBqI+sfvmP/s+Fy9zxyXMnejslhBgjys14+ehY7qdNpZpQNtwRGSnZAHYGYNYfpcCPvFaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DSwzWC1tIENj74tJgsBdrNn05tr8YdiC6Sr8R+qEwmM=;
 b=OfB/FUqvI02zDf6BiejJTX6bMXJ903lCUmHR2e+cgbak3wwS0ionej9Wt+PliS/qbA31N2PvH45KkmLRyuLclafe+Z5FWZhsKOfyFcbhUGElmUnAqBLsjJKdhBqPIZtmsbNbh5ZO38raNHeiskmCdtCXzxYYGV+dNSAxEFQCas0=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 03:11:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 03:11:56 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH RESEND] mpt3sas: Bump driver version to 38.100.00.00
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czqmxabv.fsf@ca-mkp.ca.oracle.com>
References: <20210803065134.19090-1-sreekanth.reddy@broadcom.com>
Date:   Mon, 09 Aug 2021 23:11:54 -0400
In-Reply-To: <20210803065134.19090-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Tue, 3 Aug 2021 12:21:34 +0530")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0052.namprd08.prod.outlook.com
 (2603:10b6:a03:117::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR08CA0052.namprd08.prod.outlook.com (2603:10b6:a03:117::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 03:11:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abd131c8-70d9-42ab-1c0f-08d95bac9c60
X-MS-TrafficTypeDiagnostic: PH0PR10MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB466250F5FD5519CDD23019B98EF79@PH0PR10MB4662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jvw1zjW412kp4pOMM/IvjuZRJ3aSqs+lp7N1e4bYN3TcwML4i5S93322LUYQg9+RjCgczwwI5wpfVE2fXKDcARruuq5A36dNUhd2smqA41j0/vN2BGXE7246NZSo+WBvxnYFvBM/797AAF3CfITaW/UsYtbNrYj1NrYblmGewpWmdhkmL/fEHqwmLonIEBBr4FmHrzFl4QiParfv+TusOOiE62oZk5x1mFshuKvHCV9ak1/jhft7F/IXWe4ageGd7A4VMM9aDFnwQuNP45gyRkkh7suCTGMZjNEKgR8QylN6kFW+Hpwnh4qGZVFtfOE8YcQ7zIXTsHDPi6waxBaMpLSNEO7xtDESw8VLsRm5DTSDRbUD38H17uz91u+4z1tSqrvpBFaq4xpSmy5Dr2yzPueMkCpSykUsDyTxGEEkyyZ204lKAnUU8FOctTiyuRemQJelXrypowLT4r8iuc6SE/TqlwfWutpRsVsabqMIfF0jct5/8PSz0Ap02NWi0bS+BOBlyCIcijaSN2d+GxF/ZKASC4tAiXuisoPug5yYOhO96vyxfwk3qNjBqNfTIJA51piYWqigAcbpa4ERqu40iOUCEZvxkaLOgSiXYpsAdHFRjXyqYTSoQIwBQtGygf3sol48l2R18f1WM64UWOnY1yzYV7ABrguvNszqKrrKb3w64+fdHUuQ5zo+btRhedvTanPeGFYAfK51K3uj88OBLscM6CuYBtNLasVZ78XpQ3M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(366004)(346002)(376002)(55016002)(2906002)(956004)(66946007)(38350700002)(38100700002)(4326008)(86362001)(107886003)(8936002)(6916009)(8676002)(7696005)(558084003)(5660300002)(186003)(478600001)(66556008)(66476007)(26005)(36916002)(52116002)(316002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JQR3n+FRuDZp7zks8eqTyx4ik80JR8PXoZQjS9FGDzQbcSvcIkdmJ4Ne5CKF?=
 =?us-ascii?Q?fswKSS2NskWVBCcJZ/D7nPHp0Ah/DI+mOE9VTA0XHRFdFIvtyO01WDXvHnjN?=
 =?us-ascii?Q?zsSnXKKYd+YTZw766Ylb3rP/bfJ7I4V5XY2ng1LfEx28w0/JHb4mEEcQKfE3?=
 =?us-ascii?Q?tOkGZLwmpsTw8IfCXgHmOmRI/6ND7QwCASRfI9Ps5s9QuZk0RzwJyH2HOQrV?=
 =?us-ascii?Q?gBT2TH2dwxs1/P8jSgH4mmI1Shcym/EYS/FpfnXqpBIvKDECWrqmSN9S47DQ?=
 =?us-ascii?Q?1yUOk1+LVxmQQm3EzKk3tCmld2ooelqZWMOgiOpb8+ufvI2WT3mmCMPBAnu1?=
 =?us-ascii?Q?IuLppQm9TJiCCKUAt+H5DSGHs5IGQoWEAICXqFvE23vuIyM1Vh6ug+y6tlKk?=
 =?us-ascii?Q?h7XEteWajdOsLfLKnllA2GFChObjKZPICY/iSn/8CwtXla/EUTzhIrne4oQZ?=
 =?us-ascii?Q?vsPXmoeNBfBtnUZOOxfRiA551TSwq9g5wQ84LsxU4HWFMnU8JKqAdvQlBe/8?=
 =?us-ascii?Q?Xg1u29Tk5k7X1RKRCxk8nwvNe/ESmHNK+F8GbZKtO7ZhHuFe7/I7ZKm8z0o0?=
 =?us-ascii?Q?oa+Zn3CDKXtzBKwe9W9ebGf4f7Sjqq6OaQkQ74vhz1oFZcVQfqHL/LO3jPA1?=
 =?us-ascii?Q?PEwCj5zTjbYxUUxxkRKLHOTGJBOUm/Kd2bluy9HZhjLNOVpTXO4BzFeRMEK/?=
 =?us-ascii?Q?qGkCLC9VDWLxYh77gfQAdDv2IUt7zaH4uM/DGvTwodkmxq4joqKNyI51p4iM?=
 =?us-ascii?Q?nCedd6UiS28F03Z0MZ0cZPFheCqMMTzkfWscccC8Ow0rkDQHF724iBMHAK7w?=
 =?us-ascii?Q?QJNVoH63UZqZjhiqmqMXq3JMxJj/FarKAOxfcp+wJUm8MYJRSqEh4NFT4VlH?=
 =?us-ascii?Q?3Pd9InJXiZ4441tLhIj8VyI7kGyxJGir8YXQjPZ1ar+EMb7QDtlurY4VuKKf?=
 =?us-ascii?Q?P3gsfPif/SaYCO98bbSuxPsCvgDHXW0KnNBBWk6vPwyWL9ES3hmG3Fey0MYh?=
 =?us-ascii?Q?V6jgbmJZHkRc+3qFkg1lvZPicdVi5gEBaN7ZxivLEeFt7KR6BCVsGiyit0Mh?=
 =?us-ascii?Q?cYir2B61Wr9D9sMus3K0ZKgWMpNcULEltPXIPkyOkcyqt9MAviMz2G2RslkI?=
 =?us-ascii?Q?6PRwyRxU7CabEme7WJqAhThjmG325fZuE1uEHKhtgVjJEEXAoDnfkmv4KeXr?=
 =?us-ascii?Q?jwHpDzQZgXbdkHabWr4FsviJAHJuhVFS7oEQcJcgKA1QjfH85G8DXJXNSTKW?=
 =?us-ascii?Q?mTI70BC0x0HJ0dyaBNPmK4828S53SHVGWzk3Abw4Bb3dAGog0vUoMR4Ci29Q?=
 =?us-ascii?Q?5DLlN2xS4x8gwDzRKyezlkFm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abd131c8-70d9-42ab-1c0f-08d95bac9c60
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 03:11:56.6628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uvH1bYvHipIs7WYxSqPfQuD5jP96VZ0GpFfOv1fTyoSg5ypXUmj0OOphHHyDfZ7WoRpRA5LMegqQQ50GXTjxXd1swvIvFWh8piFxn0CJqCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=827
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100019
X-Proofpoint-GUID: _Rq64qHJI3N431B647EZiJ30yNr_K0F6
X-Proofpoint-ORIG-GUID: _Rq64qHJI3N431B647EZiJ30yNr_K0F6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Bump driver version to 38.100.00.00

Applied to 5.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
