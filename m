Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B757C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Feb 2022 22:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240338AbiBSWtO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 17:49:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235536AbiBSWtO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 17:49:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAC91403D
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 14:48:54 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21JCZbsh007199;
        Sat, 19 Feb 2022 22:48:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=84QutZqMxWOTG1amdcs3UyuCWXJ4Yu6g6kCneJuamZU=;
 b=z5lFgozfBW8wvAxKxil3GndSKl6lcOzODdguzYvz/6oSBeKcLOlGCNqSd8j9EhZSqgUc
 pD7MpR70W8mX3Kcy4cAPFP2EKQryBahAL/XkYrhfQsNU5WJJHA+6iEn721lo4RxwnMhr
 xcKkg8dKE6vH/jjSRtl6K2o668KGa4Z6wxtQEfpTGzVksuA0/hTyGL5XPXNXTAA1QFDT
 lx6Y3qKAelCYqX9sZ52z9UPt8O8or7OgqO0U3gydpDBTc4FApXMKLhORqzMDwjeFEkt6
 E5HJscoor/tOQ/wXkgDWygZx/4gXOxpXrCw++MBbb2k81LuoXrv47i9LjeCGKWA6LovK Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eas3v0ygc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 22:48:53 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21JMl3fq117536;
        Sat, 19 Feb 2022 22:48:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by aserp3020.oracle.com with ESMTP id 3eb47x5thr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 22:48:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vo02I5CggX4u6tb0VAixLAsgwebiu+5VRkyyd1Pw6+XYhAHazLI5rvI7W6iq8dqeRIRqp084cc4shzMhozrBrfB1hI6pzKhBUyvE2Ak3nR4Qw7NPM8o5HTw2hUTgHEI+ORJQ4UPIq0aQEToZCEVvHkq2nbQKbQDue5OrfXrdx3PEh5HC9vUnqfnHupgTcLxO3WbyPoefkc2HBvZCEX36Okigb1PEcs2CYDg3tL6qABHFYGv1P2P2TDjeTsHDxOzjeAdeAnKpr7TEwpO4nPB28gVxg9zdMItz9PRmOV8Uu+hx/hg7o+VqUn8zpdRTWqravV6aZdYNrS7gb31R1irzQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=84QutZqMxWOTG1amdcs3UyuCWXJ4Yu6g6kCneJuamZU=;
 b=G53TFQ3QN5NrYIk2MJJYu6ruKjqGlcxmkFhXWzSOSkqgutIZ/6DGL2EZIaIEjXMs+GBTtdzyG0tJTpRpDyu4tW+q1ppRcNVw5uXKX/zp92+7R/Xam3NDMY0uXRa/JkD61FgM8omMpNOuV2MM1dfbkyqGL7PNivuaN3op/ytSzarGpYt1gnI+/XALu1R37Z1IfEA9lmx3xIXyNpEPKVyQdCvojXkRZ1Gruk+550DBqOvWhw7ACFaqsMitvKh2Bp6nX7VWO2iLlj0HlJ0SeC53K+HYMBC1+qLaOxShNli5hYDibut+/x1IzMgnv3Xcy4/64bqIu1CfSg/vqS8YZENRJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=84QutZqMxWOTG1amdcs3UyuCWXJ4Yu6g6kCneJuamZU=;
 b=UWp3ZmplF0B6roO9mhy6t4YtlF/4zjGpjM6n+HCqibmsg0nwSw/xAOIJasUgWtN/dBE3TTGCVd4Dy09Xu9nO5wCmOOB5n59ANb8UlQAzC3f/qlFdLaTLWf8jPfOQXQst3qRRsM0wWbi/t6czmTrMGMBZffpsuUPWWAMWEwZP1ww=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB3486.namprd10.prod.outlook.com (2603:10b6:208:10d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Sat, 19 Feb
 2022 22:48:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c9f0:b3fb:25a6:3593%5]) with mapi id 15.20.4995.026; Sat, 19 Feb 2022
 22:48:50 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        mpi3mr-linuxdrv.pdl@broadcom.com
Subject: Re: [PATCH] mpi3mr: Fix flushing !WQ_MEM_RECLAIM events warning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8xafp6i.fsf@ca-mkp.ca.oracle.com>
References: <20220218180515.27455-1-sreekanth.reddy@broadcom.com>
Date:   Sat, 19 Feb 2022 17:48:48 -0500
In-Reply-To: <20220218180515.27455-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Fri, 18 Feb 2022 23:35:15 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0168.namprd04.prod.outlook.com
 (2603:10b6:806:125::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 161163d5-eaad-43c7-131b-08d9f3f9ff42
X-MS-TrafficTypeDiagnostic: MN2PR10MB3486:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB3486A697A3369C0951DC93BB8E389@MN2PR10MB3486.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BJCbm7MXFUxWBh6HuBYmiiG0JIe3NTZzYC8uJ/0v5hSxNOoNjPtBhvjarUe9JsMYZ4Q+iBHhuzjg/VdcQEU5T1iy5tBYIa263+pRipH6gy0Fn9YPAvtsGHLubCkxe8mxpITZKUjs0QjJOXjeUX/V5lUqNmxkPpfXVPZ3lYPhvyuWRl9Z3Pondo2tSCc08A6jMLep0ITEMoX23qatHvzJvQfoaCf9PZ+OwgCJOc/NW4gp/KWoSgmYr8rCkcO1GJXEKUwUOnXiP3kz5s80c9dHGUTco3I1f+81Bw4mURjwroRraCz3Hpr3Vh+/tI6W7yM/qDnuiCeNXokAjf43R5Lpkf0UCtU5oncTtbJ0TyAsOuQuGgIOrOUidJLRZmLMT5FmitNIhF0dcAXww3k/mZrtNIz0fplU9IGHAuGvuKLnOeKXZxvo9aBi26CC3TS8U0/+0A7y60Adgz73k5KMTSyeAQ1JgaWVGfW7MSpfD5UcYC5cqlIPycSquTrPEKP/QpfJmTGEjdMW3NuDSqEqA7q6EBy9Rb7+DllLNOWRIBn7DaHUaAJAgsb0ORg7eJHXd62gTtBHPrkEX6kZ1QTrdTfWXI4gSvSknyw7JjI7YkM0AMzojqTDcTH4bOjhgmjddiL3S+S/ZWert7gdb9dCDSvZOIJcmqtu4/G182uDocvxhltIOYvB8vXsmInNfy64nY4a7X2Z6De+6u4V3fAe7tqnSAwwIQSTjuHBZkPtghgTj5A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36916002)(6506007)(2906002)(52116002)(6512007)(316002)(86362001)(6916009)(5660300002)(8936002)(186003)(26005)(4326008)(558084003)(38350700002)(38100700002)(66946007)(6486002)(66476007)(66556008)(83380400001)(508600001)(8676002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bgIxMkyPXMX9b4BBNCEfZHNS5p99ca86woCm+NMek7bp9j+jAZCLmXJQvwVA?=
 =?us-ascii?Q?ON+wgAxgVGTu0gv5wIE5w+5dAVN+YwBhWxPCmo7l0O29V+ASUFwfctitVgi7?=
 =?us-ascii?Q?OhVJ9O67t6a8IAUp1t5o6SKBsex0nmGbKdld9rmvU/g2QA202u1QjI9gGlpX?=
 =?us-ascii?Q?ufcHwGAe0oDJzR8Th5T8RFuMEaI7lpsLQBiqVGD3aG39dDfQETjXSo7zuxxV?=
 =?us-ascii?Q?EGDfgom7qXFtjdSyA3SYbdi5QJYLeDyxpnGLNAkZ+gpqefz9XntXEIwUFDTq?=
 =?us-ascii?Q?LG2fVl6EbulRIj6sda12VsMWdDDJ4E1kBw16W7uEDvDFuBLb4j54UDL6iW3Q?=
 =?us-ascii?Q?kDOKh6WuW0S2//N4/dM9qJkBJyqzyPj3hZ02oVB5eN/T53aLLLtNjPzK5Kfr?=
 =?us-ascii?Q?4HK368LadWXkz+9Bo9CJWtJ6oey/35HYVIJ5l30dF56aMQVoiKsSqz1BUXHr?=
 =?us-ascii?Q?lhYwELvxm6riT+qXgZa04wTdgBEM2h2rDjOrFyyqhlLAjvyzgnjP0evrw15K?=
 =?us-ascii?Q?9CIco1uOzZFAK6GvA7aKY5ubKqfCNQdANvbXZOkNJvheIfFmV5NPYloZk6S6?=
 =?us-ascii?Q?fEakoNJWwG8AXXssBfteP9UC7C2XRn+MA2mXeN+3Rar8RD2euahpKHmAIReS?=
 =?us-ascii?Q?X8loyCCu/Ivo32/2EVjSlIVu7giaadBb+oUKg61lfTV0+yoFXD1Bk1lthF6L?=
 =?us-ascii?Q?QSct5yCXvF61TltjaVavCfE1rS58kqlE3jDGkkAbfsfXGGb39ubO2Ma6e8ah?=
 =?us-ascii?Q?hq5Ly72LLkKBbQfMpYI11CqSOpI1pQyq86QRkfLYRVE7x8HRrnUKFyhQebfP?=
 =?us-ascii?Q?DopscyGk1Htsiw4GdLq2IZP8KLvpOa7/rWr8I2SK8UycaighTi2zk5R9ppqk?=
 =?us-ascii?Q?GYF2VVPgs9/Em+MVtkGyR5X+BgnAx+NzV8cv5q/yPYkipSn2tWA3kgHmJSHA?=
 =?us-ascii?Q?RAwGSH97aR574oOl7viV7aB3SNKh7Vy+CXeKKSJlTMe9BbSztb5kc8A1fsNu?=
 =?us-ascii?Q?gJIywS9H/PvgPB0wN6Mg2sxRB/4IGN/2GXTEh3FCDwOUvynhljl9HuRqTjVj?=
 =?us-ascii?Q?6YO7om0FC0FIZHJtPZSNX6umvxBPUZxke0DGqcwf6CXO30iVlfKj27xt2lfy?=
 =?us-ascii?Q?CUZ9dO/AmXR+Pkt+Rvrb2D/WHZwUOhouWplY9zWZ1wBCZ5pYgxULMrhhup2T?=
 =?us-ascii?Q?5c6DvMGFGdLz0JtuwBGVYlYCQS0ZPeJdTUgkLQffkQiBJ63I3zHsacTV1wG2?=
 =?us-ascii?Q?rkIlaipVXZbiE9hhcxMss6TCvdVdhfOiAX1XXsOLbHH604dK/6oimYxTJWJr?=
 =?us-ascii?Q?JI/5grhv0i++J9cdTf63yWJmOBxkDS7JGJ8lhebDfuPg/8wwWi4LrV5PL1K3?=
 =?us-ascii?Q?7iJQGQq80QDTtmxNRziXhMTAcB4vXS1lA29dWZxFf9OvxAj+aUyHoxM9ZTAx?=
 =?us-ascii?Q?FmXf5v89XEjwcv+2CmwwMx07jzddBSPFZ3PnEql3SWe0VHskgMEulVbdJ7QP?=
 =?us-ascii?Q?rhtKNx2qzU6SLF2I7RwRE0kKFwtghbyMIKrTtzopuKNz0VPsD3/71xAPPq3I?=
 =?us-ascii?Q?DgmnLrUYDaaL4Cv0lhYO+tB7OGYnanaTjii1WLUWHPZdDxCMp8NmQlx1SgST?=
 =?us-ascii?Q?0Quz7wO96ch1V4jUHcr5wyOmx3cdJnJ9isuuzFQFTanl28y++JSwZfy+0IYS?=
 =?us-ascii?Q?cTevkw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 161163d5-eaad-43c7-131b-08d9f3f9ff42
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 22:48:50.5812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0TFPS6O+jikWKEaYC8vEwj5lmDX/NbB2H0Js9dAQ71EHaW6F8bT0xe8feGAzMY1gcorl/REKaV+iKyBOYCglucQZpQrO4nZKd29OjpNxWCU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3486
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10263 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202190148
X-Proofpoint-GUID: Z2rTA-TxHU0ETXFqv422PArsjWpjYgX0
X-Proofpoint-ORIG-GUID: Z2rTA-TxHU0ETXFqv422PArsjWpjYgX0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Fix below warning by not allocating driver's event handling worker
> queue with WQ_MEM_RECLAIM flag enabled.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
