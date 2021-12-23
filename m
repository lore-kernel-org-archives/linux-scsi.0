Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B1BC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 04:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbhLWEje (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 23:39:34 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:32474 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhLWEjd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Dec 2021 23:39:33 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BN0JQrg016934;
        Thu, 23 Dec 2021 04:39:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=t2V9/RRfAuD+8S0OdxO+6JjZoRe8HNtVlC6IvxdrUzI=;
 b=fGPoG6hlbWwaJYWC4GXPmKILHXhTJHfoAqT2TiEP57kG6Bi4l2jn/a06ZEAr4lQMl+bc
 Y9QC4hT4LxDpgIlqYcve3EXzM6Tivg9DYE8HdTOzjMf1EbsaEM6N8ER4rI/L2WQW08L/
 2X8VAGsrBWMn7rB9a+1PnrOCheYyCsEAQ85jZy7r9NL0slKVHM06vUFYMRdL2pegM4Nv
 RuC37iiqj58D0bmwkxsmXiULo0qXiTKPWO4TIlynZh8uKW4KZm91UH700uyVoBurvP3+
 JHKklKjzllTiEHWup53NZneeQBiuzSSGLFDs2TdTw7iEPXF85Rs8Rt9nuAj2kfEUiF3G /w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d46qn1mat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:39:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BN4V2PZ005967;
        Thu, 23 Dec 2021 04:39:20 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by aserp3030.oracle.com with ESMTP id 3d15pfkfdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:39:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B7iEYb1jZjJh+f/o8XSovMJGaOaMvgjb+u1FjtaJGi2549mGkL/Jgt2EPCbk+VQwiJTEvmB2T6N6BFEeZA//9026oFW7jM+JxjpesgUWEe0bF1kZEl9bYke7S8x1GaoUXsCc/sT2gGtcMX/a0jP0dyYSojLDoxqVT5vpArmjwGHH4Gkqi0U7bNyKVgQnsPB208vYvE4mZJnOkl/m8s5Q5TnebyK2vRk+9hVuOCqW8Z+rNsoAEubuWoVbB7PIZfKpHztoe55uuSz7HAMTexRnHMY4+B+WDrDzMZ1GYvJ3cJzP/nPBJLQl/QbpuEZgt02WCM1u6ZKCmsu0/JjjdIF8lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t2V9/RRfAuD+8S0OdxO+6JjZoRe8HNtVlC6IvxdrUzI=;
 b=UN4orzJP0aPtrQDLwKgkOD9BMf20k7dmw3k6l/Zdq+kH+dIGx7lqTuLJWqZNhPUChZMXvlr9X9ZHrjx5qu/icn6TlU9VMR9lc7OKFPg1mB381jOoM2JPsCLN1dKl7/lpMXtYSUfwuDG21gknFBfhDspsfS8lAaLco7tUbYJ+mz5C7KNh3b7z3vHInG8Z3nI/Z0NzhoK13EjVWets0KBAzWYUBVe7G3y9YofPr+BTMMmwOshHs3h1V03Edpi6JkG8pd8vxcQXnN1KY7zCrorpqSyaGth+0Q4jHbFAmeKP5HiCucqjQSCZ0DWh0MhevTR7aUxFEk7/5QawRVeo3vw8AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2V9/RRfAuD+8S0OdxO+6JjZoRe8HNtVlC6IvxdrUzI=;
 b=Ukbx+99ucag7hjfsT+y+T5pUzyOHqfm7LqtakbmW+1eMXWkBdMf1+1788hAaR+MYmYOVmro4imJU3xFPX3ckUFnazbNSYIggaLGbS2KR1gqqtnZfCb64emiMzcowS0xpP9GsXH3SRA9yYBgvFP3TsAmDFkga3jIgxwm2njmKhSo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4695.namprd10.prod.outlook.com (2603:10b6:510:3f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 04:39:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%8]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 04:39:18 +0000
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <john.garry@huawei.com>
Subject: Re: [PATCH v2 00/15] Add runtime PM support for libsas
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135mkhr53.fsf@ca-mkp.ca.oracle.com>
References: <1639999298-244569-1-git-send-email-chenxiang66@hisilicon.com>
Date:   Wed, 22 Dec 2021 23:39:15 -0500
In-Reply-To: <1639999298-244569-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Mon, 20 Dec 2021 19:21:23 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0039.namprd04.prod.outlook.com
 (2603:10b6:806:120::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eac06f2b-b259-4c71-0a37-08d9c5ce2e87
X-MS-TrafficTypeDiagnostic: PH0PR10MB4695:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4695FCFAC7BBCA9B627BC7778E7E9@PH0PR10MB4695.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X4sIhAur8D1TQt429VK34bMlrgV9Dc4rsufURi3H8trC+mxkuVmCvcrDsRuCYDryFtXZBP4C4atJ8qnk9mdgysfxQF1Jz31c7g44F7oboAZbVJrFAZIuzlxLn8k6ewjL7LCzC7HNeFudEF6bZmTvExa3nl/k478e/N3e+HYQOCbgQAfT57djC4C5oYYGH3NrTgRNoukVVGM8SRKXzCIqUAW0TVDZmAuQ/zuXKjDaV+g/brY91c9nzIzo3qBeO6tBHtfe07tv0wYulSFuWuw3GPnTfvvCOPNhG9Zhqo+o9kU6tRbyHzKip3HUX2bWakt3wQHynxgDO/lV1o4gcEBx6kG3Y58/YqDI+phNNozrtKOz1amSwBRzAhkZk/eKQWXqjfcnq8TRuNyoKCIiQiWcXtx0PaPRXTIUEDg+YuxSWyTBxKgvBUy042DpFNKN57RQ1gmrIEcqYjQEvvacVL2cP3KJTUj8xFlK7dRFNbauLD3OkC6Nc6ZLsFa0utrJdXwr69bR0AoMzmMmivFb6Gk+TWvnZxvGDtELMQXd3ZbJapLEShJbVPl6Vb48EZED/oZTXJlA/aNtKj4aq7wsVG/rLDv581r527/ffTUokKMPkoi4I9Sd3oJ5YGFF97b3euLyu6l3fyWY09bEDi+Xcq5oXBN1UR1s67/XrygoO/tPzEIuDUi+UJbrVE+N8y37NH6Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4744005)(6666004)(66476007)(66556008)(66946007)(38350700002)(6916009)(316002)(86362001)(2906002)(508600001)(83380400001)(5660300002)(54906003)(186003)(8676002)(6512007)(8936002)(52116002)(36916002)(4326008)(6486002)(38100700002)(6506007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EACaL8UvjNILUn9EzWzWHxl36grch2eNFj9wZZIn72BQkg5UW5bPmUvsBw8+?=
 =?us-ascii?Q?VWJ3bSjJQSki5TQk7C5+9uAaMnkPHzfOUHz6H4wYKmUqem3b6OC4e6ttUWN0?=
 =?us-ascii?Q?4+0iCQacQtjvqNxFpxWyo6dUzmGouPYxfjjF0C+rAymS/lP5/rtoGqS2jYJk?=
 =?us-ascii?Q?BmKQxcrEgY7bl9tj5/zqwKM+i4dTTzu2n5R6PI4xuyJs7l04Xmf37CdLvwWA?=
 =?us-ascii?Q?GLPt8iv99JdWXoIhLyp7wIFFLcA62vtGTM9xWSNSZKJ/9kz92uvfgEKTjOkc?=
 =?us-ascii?Q?zmOXqDaT4YnmFMwnRcnSMq/2A2EN8ZYbkf+vtxSA4TNpkaeFZ8b0KGMpVmfn?=
 =?us-ascii?Q?0/FZ/QdogV7kB7wNBYM6lqTyfGRAJZ4brc/MZRDdz7EgWsaBKZLoMvV2A92a?=
 =?us-ascii?Q?NtGs8yAa2+wsCGVQYWsz6IibzkSUJXsNPnenvHfMMCQOYrT0Yk5nqkvIk1Sf?=
 =?us-ascii?Q?vJB3Ad0uUL1vq9lL54FAXS2ipRcnEHRzuSeiLF08Nz11nw+b7YeDgTqGvtBL?=
 =?us-ascii?Q?AF9Q78iFx12xOM7O8hufyyQZuWvW3l4b7azF0vmHXcNww6Y6No7zNSTeeqhZ?=
 =?us-ascii?Q?hj1HKhTEbRag2Dfh3L6BRXWoHiCH0zF/1JJDiUjVLLGivpVELGbHCboBTV0G?=
 =?us-ascii?Q?7G6pkWwBx9IL0EhmMxGUfPQpVDp+kyMHz5UdoMnPcLxdZIILMJMegzLfbRb7?=
 =?us-ascii?Q?LqRnGg0sioliXus2X6CLZJJ29ys5gjJpcnit6MJb67gbYfSB4kvssYalGttx?=
 =?us-ascii?Q?dFWZNC8s4HKDwGwhdjOTiXruVETizIFEXRSSm8UkFov1thHECiHj8XXNSCLT?=
 =?us-ascii?Q?ppYoDu+V2AVJxY7jW/lF4bOoy9OusGjCiIJaQcmUy8d8Jm9qiE6ZXkp/moZV?=
 =?us-ascii?Q?nflF3xM9k6IbAidyRNe7h090Ctgz+8Jxz8mK0EDHtuKLUkg2/zbFoXO5gCBX?=
 =?us-ascii?Q?f/bfMZbUkcil3J/GjR+opkfvAJyr0a0L5VCPNZqQR7w80yjccMqPlfxNEhn6?=
 =?us-ascii?Q?6atyfqn3cGmhvXBdGCLbn/WVImCsxb25nx3BxAVJwG4cPHYgY4KqDiUXfVxa?=
 =?us-ascii?Q?Zk/+nxJ0g+SW6FmNRbhjRbMZJ4/WmemKXhsZ1FD3jfbNY76zapWD9ytv17H/?=
 =?us-ascii?Q?H4iuemJp+1IkzAU74zRuhRsoTizPM7t6/FWWJbUv5ukbb9rJV8R5zzdEbnDU?=
 =?us-ascii?Q?K1v+2/cwsXZgmaHz7ol/VXw0q44KAh2wJRxlPPFbXxbrnmE0cqhoqwzmy2vj?=
 =?us-ascii?Q?f5DrtMO4Uf/6CQ8Ci2kDyZTygxyoYnkrhmP7n8yclDAGpG6fvsuAqqMr+Pky?=
 =?us-ascii?Q?6qmKK6wMvpA/JjL+bv3at+qr3bfnoBkX/f1M3D+xZ4agc4BHOwkx46xfm78N?=
 =?us-ascii?Q?FYblQkSo3SFLg8kYxHsH6YOfTgR6DKWuDqXpGUxJoxdHrkk5v1Ct27Ndfhst?=
 =?us-ascii?Q?Ylw+LmkwcOW0cSg4Z4qpFhVctv2alwyJJ3/1JKxrRGq5Nyo2UI0F4t9/mJL2?=
 =?us-ascii?Q?2nW7RH4MOZex1YF/mhPHTYZkdF3mEPWtju5eVOOvHnAycrMAueUv/UGiwmgs?=
 =?us-ascii?Q?uKUqvmg8EJ2EQKKvGt/l4Xxl4f+0veth8Fhn/fugOB7EIc28OoV3ru7nLWA1?=
 =?us-ascii?Q?pVS8Woj5EwQQ048kSVkMW48YMwDq/j6Z3mR3kboNCyfWQ9QTDCiCCcDoWsJ/?=
 =?us-ascii?Q?opdVBA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eac06f2b-b259-4c71-0a37-08d9c5ce2e87
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 04:39:18.4964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8eLPo91ohST9m++dv4a9Q0JLmrSrmNkkBSQa6WwEE3JdvVjOUaPh3x9mW71/bh/tEIWDRQ0F03XuqMsis5uYob3BzjjEi0vmrA0wuUcm36g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4695
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10206 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=966 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230023
X-Proofpoint-ORIG-GUID: 4PTQFT9-XZa63eLWOXEcSutipEL2UoLP
X-Proofpoint-GUID: 4PTQFT9-XZa63eLWOXEcSutipEL2UoLP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


chenxiang,

> This series addresses those issues, briefly described as follows:
> a. As far as we can see, this drain is unneeded, so conditionally remove it
> in patch 1~2;
> b. Just insert broadcast events to revalidate the topology in patch 4~7;
> c. and e. When processing any events from the LLD, make libsas keep the
> host active until finished processing all works related to the original
> events in patch 9 and 14;
> d. Defer phyup event processing in case described in patch 10~12;

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
