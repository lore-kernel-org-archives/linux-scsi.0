Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A49FEC43217
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 00:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiKZAaV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 19:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiKZAaT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 19:30:19 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D27023BF7
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 16:30:18 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APLcZJs027908;
        Sat, 26 Nov 2022 00:30:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=BIcYUvMXr/dPyWQXTKUkNBy5o8mu5wiPvwq04vcioIU=;
 b=IOQhAhP/6woRIb9iuHVnIiPdAeqvvkyAb3ShSBGOl+gsRSpG9NNmLuHyoxhLbQt3PoSV
 RVSRrbrss9cx8pZtQfsVQc8+C3ulffcVxzx343wN1zkHwNjxSBsGYS7hGwZ+Ixj5Wj/D
 3Tvzq2LvwXik2101yZp4hCg2+ZLZzKiAwfwvFCid3eYEOXxNc16IvPWGVrLdx5sgs8CF
 /FNNXJAhkY6hfcLt2FO4XJGGMEIZcIZZlc0H+XDuP74uA8jyenf5D7hneC2JKOT2B865
 lUhboCqdMwKJU2hMt+GrfMeyDJLPRiA4YcEY8yvXX6/To03w5KQVQnv6rDSlVA1Ch/sl RQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxrfb9fhy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:30:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2APK4d1S015995;
        Sat, 26 Nov 2022 00:20:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnka1h1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:20:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=abFknwn/eOyDcAiojhjfsmFJuoiN28TEEFXaMr1uPUbpHnQJeyhIXKz8m+3wizIkHoStsTRc0dCWxonuNzsoMaGFD8Q2JCegsqOCteFSskcNyEP1nOOzPORRHxV/mUCoOYPXplupwbrwhsJzBfhhZu1Vmj7R0shejAXnmtltZrDj/adRjcyOYuLD3CtbrE5nY6eC6r4IHou2omesreb0NRpurizgfeNmwTIDrTtZzm4dRGM3jQB00IYf21+6Oc1voFAoJMa2MGLSPaGbJM4KCMKOxuxFQqD9Z6cblF9OfRoj8egKuZaf4AAVGIeO6A0deNWBbugobI5rW/NnPD89gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BIcYUvMXr/dPyWQXTKUkNBy5o8mu5wiPvwq04vcioIU=;
 b=itTQOKSRCiFGtWRCQGyGCLUs5CX6OssiRvHs+yYHiuNYL4/fClTRv8MUuFFTmz+gL08Bxj1WMEntmYMcf+vD5x/UK8LnS4daxtyKgMX4QtORLwvENwKzH4i5mJ6H+pIY6j78flh0jnUzJ2oDCn7V6Z0ErAfrAoQui/uaBmaglGz4PcWDDwkRcfHYkNpiJ3CViE4x71/zRC0+5I7xy8Ks7W0ZC1QDi5NJHac06ljmDk1N8G3VgnBu4DwmpmTSK91hcgnNacjV8GlDkmKiGW/0b7vrZgEbO88LsvLV18sP0S32zVrPhRjWhqOAwhTBb/uGzzll+xvH8PI/QLIvSK/G9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BIcYUvMXr/dPyWQXTKUkNBy5o8mu5wiPvwq04vcioIU=;
 b=pUIEUnxYut/4JBb70HblOugF0ttg33UZWgnCE4IUJU56hCfRDR1xVQ/YBJEH0fkoyddpRtQO1i/GCVJZGOTvlol/fCjt1zvqwHPNm8i0OETjvDXKrG3RZNFhYHDXQBd8Jv4qe3Ewq0dRl2Ml8elXcozS0UUpaILPFJshl6ZhnKI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB6391.namprd10.prod.outlook.com (2603:10b6:806:257::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Sat, 26 Nov
 2022 00:20:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 00:20:25 +0000
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-scsi@vger.kernel.org>, <hare@suse.de>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fcoe: fix possible name leak when
 device_register() fails
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18rjyr2gz.fsf@ca-mkp.ca.oracle.com>
References: <20221112094310.3633291-1-yangyingliang@huawei.com>
Date:   Fri, 25 Nov 2022 19:20:23 -0500
In-Reply-To: <20221112094310.3633291-1-yangyingliang@huawei.com> (Yang
        Yingliang's message of "Sat, 12 Nov 2022 17:43:10 +0800")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0085.namprd03.prod.outlook.com
 (2603:10b6:5:333::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB6391:EE_
X-MS-Office365-Filtering-Correlation-Id: 58653d77-0c6c-4442-d279-08dacf4403df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ygg7aQ+qwjz/xEANrUsVEa9K3lnKw39khKKD1hfTzGGwRPFHqjHjqdjL8OAjLvU+Qr6XcwD/A8FF03z9ra1sSW2Sni3j8z2m2RYld3zcjgBhdb1I+guL+66jfu2DKYUbschUeunUPxfZipz2GBnArd7vuENHGxJKdIV/c8io8o01HNGFrrZv5s7uioCfB1FTh9IScLjjH24+FtHkUSjrtZZjaKww1puLQVAez7sLj9aDNn3FpjSdVYzOAEE9MKAtk82iLF6YlTk9bhDTl/caZDz0ExiwDj7Mk+BzI3Gxu9ojGV02kQ96wZgHagwkYwRV/+x98/GyRlnGvYmsMpbxefqXp1ygYPvRBeYs2Bx5TMOi3PDUg7jsEbXl4bf4Be+vazgMKSrJkbrYToazKrncsj6JiOrU9wOrF49VXxxszUeL/pvzllbAPTpYGpZEhbPGS+vV9Z77jSWwlx3n09NDafBEItlhy5vwwIwRYVWs/YR1GPkSMEZM0pNYnBUaDoWyqRPHAQzgN0hH4qYcU97DaZlAf4KuOKh9dXkcMAyCzZluO6PgZx0BZJ2B8VxTasnRSckxIWdCVRUiizYMbmrAGzNP7BcEwfQrOY8x/HKwzhBPLxCi2+CWCXpQko56neY046Fm2JEJeiMrJq1s6RcDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(346002)(396003)(366004)(451199015)(8676002)(4326008)(66476007)(66946007)(66556008)(36916002)(38100700002)(41300700001)(6486002)(86362001)(6506007)(316002)(6916009)(26005)(54906003)(6512007)(107886003)(2906002)(186003)(5660300002)(8936002)(4744005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vyA5qBQMGCWnS2eN+tmLU3HPkfoF2efse70OP0OAS89NI52TxaZ1MuT3TQOE?=
 =?us-ascii?Q?S/L8LOf5E9fLPt8ICAsMowFAJcwFGV3JNfnX4+B7RswW5HMfrOOBB4LpUQLo?=
 =?us-ascii?Q?7CCfp6MxQ1FLbbN4a1Qy1ypCnHYzbcinv8KMhuuvYAyNbVtTv6kbb89K2qcR?=
 =?us-ascii?Q?PxtHhwEvu5VEi56Ts1U4/WU0P8MBm6BgcuMbMaIGfqR9aZoFz7lzcEpF2E2o?=
 =?us-ascii?Q?lmj9B+GVG8YqsmulNlMk+Ga8/imC4UzYJ6HsQ3k98Zs1eqcMZpMdeXTR1Og4?=
 =?us-ascii?Q?YvP11eOwjSZmMfJKgBn+ZiizIhJPKHfzfh7wUlPdThLuIoI2kcOV654eQcDu?=
 =?us-ascii?Q?+mtFt03t9TEzWwiHdw7HbaBgAWjZUeqQROtqX3q7mjtOBadHENI+HulR9gO3?=
 =?us-ascii?Q?b2UpfWyKCSFADp3ZF4xyTCa4tnzOH1lenzRdLCyAuqw7V1aDy7C0Z/Jy25Ef?=
 =?us-ascii?Q?C44s0tyeJanKPlubC2sZFqCaBXfqRTDDfPJRiuwLY973N0bFMFMJtDVs2HoR?=
 =?us-ascii?Q?huBQ8Mkks5j/yUHwvuEgHVdXGTVXvE5Ef4r3Dbr1P1Llx6bVahb2UUdGKaSl?=
 =?us-ascii?Q?sAm0LP7LpaXf9H0n02ZDfUM5+SzhydraqIw8WZVfmIhOo1HoklroB9V+vU13?=
 =?us-ascii?Q?8Ny1s1A1nhblDm/lcH93FwyBjC4CXFFb0TmpxDNFoMw6QsYrvXm0pRORrMlY?=
 =?us-ascii?Q?XIFgFI2jPa3yu4QHPIoz0RNxRtyZDp2y8lGNHXpCT5ymRElQ4FGM28edzdwV?=
 =?us-ascii?Q?QGK+6Jsj9dLBfXPlYQf1UonCIwPxUOV/0gaPPBDjCyR0cdRUkQm6nzMKlBuI?=
 =?us-ascii?Q?LWuwHDpz1KSmAHOsuZKmiwUQ+CS99z3ArDJll/wgid13XfaZ6p20Lg/Mc7EM?=
 =?us-ascii?Q?OfrWZpq1Xpm7YJhP3IwOU7owD7Hy9VAaobLM1P1WZJs4opL+8V6tQE/NPyvT?=
 =?us-ascii?Q?1APEL9OOmoWQpM1AIl7Y1yxSwnQuUbLp+nnPjHWRTidMIEWNw9IXC9JIXpnS?=
 =?us-ascii?Q?0W55t49SL2TyFStH7LrJe0LEnUZuyAb6IkCpeqqlCRquYitUo+zgrtmGGZ0m?=
 =?us-ascii?Q?7ud4BAezcvMsMLFPTfQGILrp9puKnOM41lzlqcWvCFarzdrwyAsv9RKsIUUp?=
 =?us-ascii?Q?0Uoa8GwLtyPHZSwlxNEPFX/FR3/m83GWYjUH81Q1D+wDJtjzyRNj1TfHsbEn?=
 =?us-ascii?Q?enYQ6IU4S6HH3E+8GXF5RGhTb+gZkiLeocEGGLRgL0FvXctgAunWxA45wOD+?=
 =?us-ascii?Q?c88+A6rZGJYuk08hGaNZ4cmwYyPtT8LtJHSF1gcyosqZ8ceSMjJ9UIhkMK3m?=
 =?us-ascii?Q?O31RwV5WTleyl3VmuUvg9RSt3NVtg2Z6PxmJnKN5maoeIMrn3ZjZJQP+Bnql?=
 =?us-ascii?Q?kCJVSzT+zS1jJVUhC0a52Dbhhhsf8Yih6pyY8/0zWA9Rq7YT4Zq+GJUSxYQ3?=
 =?us-ascii?Q?GWZbN2ZOIioTD56R9fD1sJh6EG038yovkWKdKK628Ac1BRe2sotHkQ7s1lFq?=
 =?us-ascii?Q?+5rqi7pUDbre8IKfoe3zms7unVoxaaOw/nBrAL4PwBVePei9TVwI/tOnXHRT?=
 =?us-ascii?Q?SL6i7pLOyuIVPNlWBohx1vWNwTw1d4kKk2xrT8fGyOveLOxidMb82ZuurNv3?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 9vTxaJLCk5Fbaw88+Fpzmt06OJ12BCOKAXpyac47vGuvRHhNZwWmTbB6YI9wAAc4jhJMuGu9uNkGr8nDaCIgqUWbiHSVtsxXS8IraewseZ70utkoguaVwt/wXIzQmu0JmwDm9oRZTOl4KcF1lndS1LzbU74ifDm1wg8Z0Yv90pKr6cfF0jZ7dHvhQ0FG/oeiD7P+eS91OEd3fgPXhYwmteniTeeWSdJxY5wYFcT7+KDcOHUB+Z6iDnQsDI3mTc+kHPqWVDTidGykbGqr7HxHSc3rxfJ70qf+CBR2ZjLaRMrvJmvsGxJ/I1FCxOFs/jCqV1DMnu1mCXhM5DQGpmR5at2OM0F+RjVSBH4S99KvEeNfGmw5hGmWPXwvV2lKkcTrbmyJbxfkP3RmeZLPLzpRNBb+d4AGmvTfyN5n+m0ZMDAUlcOtV9t+deOB/q0S6Q7iJT5IDa57KqtbD0qGaklZmfNp2cpNX/zmoo3HUIcHk5dSE1M8k5TdSQl75AUddsF5OKKvzCGjNd37ZiFLhX5f1QWOfpo6UhQQCuWS1w+uH1BNnxwYxw2s5qeqjoKW7aPWPOv/13JxGFzQ6843bt06Vg9Rp2js+Rf6115413y6B9fWYJmXoxwPYEJXgHpgw4WAW8fUIbjN+cWG4GU2r4us3qOvLIpodRJ/p6tvIeSPB42HMdbc4LCCA8z/z7mlqNEssyUomqWldlcaXB1FRsKc4BkiM2b9dwjOsHQhFEZepgXJIOhZyeyFPmTNecQOZ9A2/Cj/qRAkYvdDWEddd7eJJaxys9UfnBvUCt/LZBp+Zcm02iKiBq7Zda+ZdrziEHI5JvYDNwvZRkfeKH5kHvJli62KdsJwXMgqtRF26no8yxI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58653d77-0c6c-4442-d279-08dacf4403df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 00:20:25.7478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WIz19GLvHbNI7M601qJE053Q2pK0zRaTX2PMQXQ/IgL4eRn3xmHm0xSiAzawUpK+2yAYonLvm3pDNhc1MitRXqduxPzsXkHxVZGvWDuXkGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6391
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_12,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211260000
X-Proofpoint-GUID: MB-c1HExsR5ehp4J5BoeW9jzvJoRNhGx
X-Proofpoint-ORIG-GUID: MB-c1HExsR5ehp4J5BoeW9jzvJoRNhGx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yang,

> If device_register() returns error, the name allocated by
> dev_set_name() need be freed. As comment of device_register() says, it
> should use put_device() to give up the reference in the error path. So
> fix this by calling put_device(), then the name can be freed in
> kobject_cleanup().

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
