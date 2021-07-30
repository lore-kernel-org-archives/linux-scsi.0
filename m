Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 073AEC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 02:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC93460FD7
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jul 2021 02:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhG3C5I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 22:57:08 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:11144 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229750AbhG3C5H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Jul 2021 22:57:07 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16U2uIen028217;
        Fri, 30 Jul 2021 02:56:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=4pRde8F/YNDOkeS5ofNaSzZq6wIQnbM8ZhxBNsEL3Gg=;
 b=GXXz+AiFA8rwPWL0bX295CpS2TVo9otaK0BJ/wu1eEbdhiZ23vEnSQwVuHl1uqYksn28
 Z7wQFHk/pA7rT0Jyd5XH4m7wAPSWb+GzaS1ENimFx3+Mek723hzXm9abNg2CNe1+mlrZ
 0xEP3o3BVaxe+ctNjYtFuLc9Jg0ZghjfU+S9hVqisMgGDqHlDrazrLApPAG9A7jRcbPM
 fR+z84Gbk1jNvrRthQfOUmuL1cMWU/QZ8EqjEqynFioRil9SDukj6zZoz5qY160C9XWx
 RNHo9ksjFOnBOU+FZslXeHfXK2zEcQHBezRXWV4wAH3Qq/mIV+ERAw5deJnj88LSCrNZ pg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=4pRde8F/YNDOkeS5ofNaSzZq6wIQnbM8ZhxBNsEL3Gg=;
 b=onEdrq5oYgEbrVHL6Pok+Q6zZRNA9u4XZ3hDoJRKL4c/NgeGi4Vm9mvmckPCIre4xoCW
 4iqfWwufZtmyU9gkz75dYzvUh0vpiZDyFcLXz1Vs+VQgxFq9oFsv77XDcULyUtj9nfr1
 BBRTDqEsGEuTxC4vMJaal2QsWJg1YYaPWUOAR0SM0pq1bvsLHCU1UWGg97atr7T3kxmy
 W8Gci0/+pVWP9j9XQcs2AemXk0e6T22J6XhrPpId143zz4QxE7HC2qvKRAkGPd+S8JRO
 qDM2B+IWFQQm3gdudS8KOFYePihPjRg0oSZsGMPIl6/Wp3g9Q9X7Y0vmiw9Yre9wz//j ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3jpd2mnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 02:56:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16U2ps1K078354;
        Fri, 30 Jul 2021 02:56:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3030.oracle.com with ESMTP id 3a234fpa3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jul 2021 02:56:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGJgONaGHVpTh0d82wNagR4vUSDLTgIPgzSgL3h63byw0mnkHNw0Gz8+TdSX0d5AC51pvyYShss75g5KlYfz/9cOZskuKUt61vaWGZ09MsIf8A/tUxHwJXtVG86a/u9hFTcupI3KQxUSTqOBaaqmyxRxlsiFxZxFJI4s330pe0t4q6RtBRVucjZjq4KfOOognZFW6WaSUIkVS1/m6TN2SMzoYfP4qNr+VESGcCVKqnNfgZkRhZbygLJdny11HlJwWc4TXN5Jr3xxRxcrCyibHrrKZSbNTuCeXOOdEJud9r1N0ijDl/CWO7UaoVFwqYyN7t7JTwmp+tHCzMzvHOlTXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pRde8F/YNDOkeS5ofNaSzZq6wIQnbM8ZhxBNsEL3Gg=;
 b=iwMA6Yt2YxHnpYa8/nR20dVIdc5YYUPjF4/G5dbILNktweYd6vO0lGhmqGeDXSt1+EmCruG3YXxyk7haRfJpRe9GOfIcHfNe9/e2/zeVJOPapV+uvG1fapng/ub/J7aY0N4mkeUZ2/s40CwwJpV/b3MmxahMhEKu6Su/nURSfibE1WOLInKg439EcTzPLI5HbTlkjp97Z7i2TMTkLWZopkQxsREck7o51xPpS+LPNgESV8cM2MjkWvGgkZWxgJkYcaSvMjxuAzFeF6sE0mrS8kcXPqMlP841mBpRIuKf3D29N/Uwzj9Hf8VaCsep61VHPXggFZEEL9JKHVWuGOE52g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pRde8F/YNDOkeS5ofNaSzZq6wIQnbM8ZhxBNsEL3Gg=;
 b=Kk4e9+gKHnYzulQJ0NFIZcox9vu/63fuDrwHbJrCO0AIF00vI6QJS/2cjkH3OkDMaYVf1Ud6jXV0nHfJgzp8CoIKHW2Ij9qZk9s4TS7Jsm7mYLrv40w7epCZwjD6vYMn/2bPUJAST+uYsxdP++CoBWuDqeHEqf0IPlq/yR7b+cQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4486.namprd10.prod.outlook.com (2603:10b6:510:42::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.22; Fri, 30 Jul
 2021 02:56:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.022; Fri, 30 Jul 2021
 02:56:50 +0000
To:     Bean Huo <huobean@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH] scsi: ufs: Fix memory corruption by
 ufshcd_read_desc_param()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dh8o6gx.fsf@ca-mkp.ca.oracle.com>
References: <20210719231127.869088-1-bvanassche@acm.org>
        <162752979291.3014.727185988515749106.b4-ty@oracle.com>
        <36eeace45248316f4c674bff0ae1d0b598e669aa.camel@gmail.com>
Date:   Thu, 29 Jul 2021 22:56:46 -0400
In-Reply-To: <36eeace45248316f4c674bff0ae1d0b598e669aa.camel@gmail.com> (Bean
        Huo's message of "Thu, 29 Jul 2021 16:05:21 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0190.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0190.namprd11.prod.outlook.com (2603:10b6:806:1bc::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Fri, 30 Jul 2021 02:56:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e8ee42c-d506-4a89-5dbd-08d95305add7
X-MS-TrafficTypeDiagnostic: PH0PR10MB4486:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44869846FC68BE637AAA4CAD8EEC9@PH0PR10MB4486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3HAgnDoQVLTS7cXIBaLh7S3aI45ESsdUvFuPXJWm36GDKS5Q/tMwsfWDc1D0/0xM5+rHeDNnCPNHL7H2QF20mhV/6aKPQ/moPoDKKQY0XJWj8RFFUc2yKWslantfQdBwRzsKbo1baFGblbSMgrOPtElkXbxSHqEVfS/VTrBXtwofR8TU93ebYnJRfbSgVweOUbbkC6tyn1hbkk8KAyMqKpgClRmHEBbU4TeNxnkQ8IJWDJa3+YIBcVb7C3tR1QgAelLIR21xRsLD7iuMLHtdKZO0uD941xeHWO8QKEWOIN3QTkRtl6gws8McXLaR6XDKGoMziNetTkzoT040bIz1eB3xxMGbMwKR5WYDBr3b9+l1HW4s1eZAxpBuNHZ4IT2XEqTkYOjv0Mimv4jhfTaEOJc2qQMGepZwHo8EL9+18o0QFhez1UuBaOcI9ucLQi8MWX9GXLC+NOsKAM/NDGyar86jrmHLq2MrS2Zkxt2SHpp/HtrVDmn7TNWcn4fSaliYCqukb+V1nEKPSEZcQm8YGbo9ASAiDvQbsr3VXoavFCnFRToHxx1inNlOnKydZfQwpnSts9rMueSJ63Mu7a/H6GBhwTrpSSmyXhl8QmbpcI9cW+pymfljaAfOeDfK6sXrNasFm5w0P2+qiY+0ygtZ9E7do3QwUG70dntMZyOkFr+AWmDvBu/eC4f2o7dOklNqS7JrlI51PaZ6i7v7nnB7Ww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(366004)(396003)(54906003)(8936002)(66476007)(6916009)(66946007)(2906002)(6666004)(26005)(55016002)(66556008)(7416002)(558084003)(38350700002)(86362001)(8676002)(316002)(7696005)(36916002)(956004)(52116002)(38100700002)(478600001)(186003)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FiH9YVkryBGIQ7lU7wkrbFojwYgVxDnfh7lW3w0ElyESnVVUWZvi+4SCPy4H?=
 =?us-ascii?Q?OfWQZ2CWy2yLQRPptglKINYvz3WAlrdx69irg7geAWZLE6Dy22hO38g8JOGK?=
 =?us-ascii?Q?a3MBfgeyCn/nItC/3ml18+DhnVapJOIM6XahMJvLsCv1yjsKe5Xr57VesNYX?=
 =?us-ascii?Q?keQZBvUBks0kfPAhKgqhq0fXr4y05ffdILZbh13Z9pakYwLUIK+pJ1iCVz/p?=
 =?us-ascii?Q?IpqwQKvJzt4LzfQJzscvCX+o2rrP2FnoDr4HqBj1VOpgnw766lTFQk5mbCtK?=
 =?us-ascii?Q?8M/9i0KZ1RiImvfQVQcrU3jM261SNHtGClaEVneTmDLexl6Ba19i2q9A0Ns/?=
 =?us-ascii?Q?JCZSdRGzuc3KW0KQ9CHYQ+mkxeRuscrwaLs25h6OcyxhqSWfb0Mc4QqH0Qkn?=
 =?us-ascii?Q?KGSQhmDe0hsDdCz3MEV1+HqGi2XK/HmsTbafDvmoVC/APfzRw/DbHD9lQuAl?=
 =?us-ascii?Q?72NXbDitjJA9pOJkktghHDZWCKe750B6TXls67vxi8X5CpAjyZzBA/Je9VbB?=
 =?us-ascii?Q?NhNYzQvDjGUpfVXsYW6I+vQBWIlLMiSPRWz8WRsLnR+zXxa0ACiUVqkrQCKa?=
 =?us-ascii?Q?hZOl2hICRGHAIMqT4PQ6kOQxDoZiBDGSKOgA4zwpVtZ6fTfkfWhWIBJApUXG?=
 =?us-ascii?Q?AmGgFEHeJL6NVrpqZtBVew7GE9EPGUD8alzqcd69STZkyC05YCxEiAIu3mc6?=
 =?us-ascii?Q?aiESUtNtTS49MEYS0lKmZK/Yusf0tbqG6pMCD1ISzSeHwgb4jONzf5LfXutY?=
 =?us-ascii?Q?6JvKew2v5yVdRBMKwY2lgVKm6s+O8U0xnmhpiQoBznr7lBnuFC62esxefNd4?=
 =?us-ascii?Q?uSlS3SinCubiRiV9ht6O5o2LhJ5UZ+t6hjYUl/2/iDPadCsovvZc91vCev5q?=
 =?us-ascii?Q?MOTiU41btW92vx5OOliuNs21xlsFs7b9H0F4R0LGz+tfbJhPRWqnlU6D0Ug9?=
 =?us-ascii?Q?lb6fJXVr/qsZ0etxhqcqefWZh0A6I1zvS1UPhd6+NqUqzit5WUS9MkK7lhQQ?=
 =?us-ascii?Q?fUGFghwZjP0q+Wx3T2uiQIs4Q1uis+2yLCciRVvqD3R6PQB3pzLg8k4ptTdM?=
 =?us-ascii?Q?xgLr86EDPoagFo6Jwf7s3ZDXlOgQuUAl9+xiyJzGJnPC2t1MZTehEJrpnSt5?=
 =?us-ascii?Q?FjTXimQm75vX/5/eKG0Tc7Dzih6+NlyEKlwI4IlKb4nj0UAFC6B1lAye7EQD?=
 =?us-ascii?Q?9eL1RnapO3XiJ8/LGxdhgjOuzUPPkeO5PJ4N9r/N1qdQdUPFIaejX0abusTN?=
 =?us-ascii?Q?64nJtf7/e7I16HCx6eTyXkxk1m2BvE2Y0AWnG9XyAgXusfxtUy828eYzOsPB?=
 =?us-ascii?Q?mwbbgeUXK0Fe42gtD2vRq398?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e8ee42c-d506-4a89-5dbd-08d95305add7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 02:56:50.8370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z450wWwGcVUrw96QjgVMTefVXMaf23z+Jo7bdhVRRztNmgYr57G0wOc+9mEJZfoOHUW33BlyKhkY9vec4u4w+/2ESp1FTphnL8uQHIR5qAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4486
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10060 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=934 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107300015
X-Proofpoint-ORIG-GUID: d7EAqa_F6nZSkxCB3Dez0CSRK3Xe8K78
X-Proofpoint-GUID: d7EAqa_F6nZSkxCB3Dez0CSRK3Xe8K78
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

> This patch has a problem, we should revert it.
>
> and the correct fix patch is in Bart's another series of patch:

OK, that explains why b4 was confused. Dropped.

-- 
Martin K. Petersen	Oracle Linux Engineering
