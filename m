Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E4FC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Dec 2021 03:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbhLQDwt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Dec 2021 22:52:49 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:6792 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232507AbhLQDws (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Dec 2021 22:52:48 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BH2XcSt013710;
        Fri, 17 Dec 2021 03:52:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=HqI/899b6ks3K2EIeMV2agRM2jrxNaqV6nUQ3jyUWWU=;
 b=CxvZItqNy9quSwOXnQqka5+FaqEs4WYWS0JAAytrf3RFUbiPQqNN4obEviqSUI8SnTwN
 igHTh8VJgbGOtmnYmTOvF8NWQEhGe4zjtmQqeOB4t1xU6fx0veFXhrnec0nRUgmYNIUE
 MOrksxt/9UeEZoG4bxXYcFALw9pXDYI/+spcwfqiqaF4hKvskMgdiaMd2FPBLQSHEZgd
 dVIksg5m7Ix5E0cwEsnETMDl3caxeSri1yC8Qjxvm9Wp2LWO9HAJaS2bdNGLx+js1KfQ
 gx5KIQeK1xddkPGbJJ+q+f8Z0/pX+NbRTBVlY3hkteeXpWCa8j1VwzAiVLP9mazcYsTd 5w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cyknc4p73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 03:52:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BH3ocVL111309;
        Fri, 17 Dec 2021 03:52:44 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by aserp3020.oracle.com with ESMTP id 3cxmree64g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 03:52:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLYR3kLlRo4+xH/POyK4pGvRpeHoL1/TmomWohUyww7j/mXOyqwUVOizBjxaffom4MVnvrKMBrceOacKBQmIL6sJ7hYsZOLe117NSAWSYqwKvymb6fC2Xio151mHaA+X5JhRUZOAYeuY3J2+YCxynDQcxf6dbJyXE0J96q5YhbqDT6Y2Xle9dsqW8LYV+5Qzg+Y2I3YWd5RHlMUouVTP/xHPYbHUbd9F1XWKld5NWd6xrU5HX2vnnVeQhyhn/p5FyyzwAYa8PBouTzU3/3DouLjMr52Nuc5vhwrinnkB7OSqYhmE+yNK96o94ZMNWGtOwMYJ5ImJdhnZE3rXu+4zpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HqI/899b6ks3K2EIeMV2agRM2jrxNaqV6nUQ3jyUWWU=;
 b=n5nlYd0xjF6JWInakvRvI//5RDs0viWi2WfFqTfmeUuYyVFJyu/W8AXh1LsPqiF9PsZbsvfE2xGVNmBF59AAZ6uca9vZejeR5mcf1gBbGQWQh2M6EtYABxtRdfo2fFMxtFWyCQXKJec0Q4iO1TsHE8d+0YDlvjEwhsuHxDnf4QLLJSIibPMQ9hCOaKjffYohoOi2VbylhAUqa5mr7D9zXJ5OEawvCdDtJ5/n4PAPB49j4gTzUiseXkjNP1q/vqAWpnm3q87xCYRO9xx21tOK7YcjjWNx6RROJCY4Z33Nig1pATDxKEdHtq86aA0ETmrGwSnv7Ebh8b4bnrQC9WcTdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqI/899b6ks3K2EIeMV2agRM2jrxNaqV6nUQ3jyUWWU=;
 b=JcOzyu5M3qeYWbmO8MjVvXjKNxrBwhU9kTuntSAMXw2cg2wP+Wex9uxRa+I6vcX/j0TTAsWxuQ55Fa0MtPRqbn2la5qktEBKanG0JyXEyYvLr8B6nGN4aq9vACmbx0SZGqoBYup5t1c1FbfNXa/ZsNpTxlGrutXVXPqNG2BUYlU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4741.namprd10.prod.outlook.com (2603:10b6:510:3d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Fri, 17 Dec
 2021 03:52:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%8]) with mapi id 15.20.4801.015; Fri, 17 Dec 2021
 03:52:42 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     james.smart@broadcom.com, ram.vegesna@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] efct: don't pass GFP_DMA to dma_alloc_coherent
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135mrlwfy.fsf@ca-mkp.ca.oracle.com>
References: <20211214163605.416288-1-hch@lst.de>
Date:   Thu, 16 Dec 2021 22:52:40 -0500
In-Reply-To: <20211214163605.416288-1-hch@lst.de> (Christoph Hellwig's message
        of "Tue, 14 Dec 2021 17:36:05 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR10CA0029.namprd10.prod.outlook.com
 (2603:10b6:806:a7::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8456d8d-8ed1-4685-c56e-08d9c110ad71
X-MS-TrafficTypeDiagnostic: PH0PR10MB4741:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4741A17FEFA7259BA2E445B48E789@PH0PR10MB4741.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YMEk9y27FWnCUHkhqEYqTOVozxokUGIa7ETAPDhijHk4U4+ZmVv1YMW13LmW5+BI1Jd1SahCLmKFoxmOniQHa8lY0FE5wFFHaeljQNdQSDVCpUJ379AGQYdWgc358DkgcHwhKjY7ULBQsHF+AVPXpQPpLW1M27zryQqLxrirZdnGo9OCOgwZWE6VbWu2/e449GjOW5/JGNh0Ou2dMBx8+sH+BVu+mUTr2Ls3liIgBXlyEgBJoYvBsLykO6JkxSIQRsV/TnfvmDIuIjmtZUafFHDZCU5rf6zJ0m9UwANnqYge/UQUfDfMQkSzNUMRPOTy00VUFjB/y7ODEft2UhQm4+ohP9HKnHI9aZXCW63bwyJ0Bl3tBe4jGX1uspouwE4h3HH+1L11omMPmWvBVjcw2FwRY7hh9VMb/BcgN+8fZhXd2/R2HRe/75M235Q7z4oVH9KDt/wcDH5ViZz3SdcM08x6z/Gvvc56PGSNJ9lKUSg5A5gfiEwxW6iA02DkjTeVOhr7EWOAQvKk+B9KlVW2/tH/UJjyGXxGSKYUdVhsDkkRreeSaLSvw/HR3ddbc809Pu8sDaUBD4BFfYPevkSizRiJkcvi0NEAj0LsDkvR470PtCytfmPX3lHtGghMJ+wNITnURyVcQ8a1VU1u03nP/FfchJhqvyXksgs/jBBLtmdf3EaXZu26UXl/MtWey4xholfDjDY+R3IWpm6THwpo+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(4326008)(6512007)(8936002)(38350700002)(86362001)(36916002)(52116002)(66556008)(558084003)(508600001)(6916009)(38100700002)(26005)(6506007)(2906002)(8676002)(6486002)(66476007)(66946007)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k+Sj54+t7HiMCixuqTHtf+neq3RrmeTyqHzTG0DDXtW8Hg4GGcrTRLExHNAB?=
 =?us-ascii?Q?UXPkxBxJ1/Zs6UQUa15iODof3RKhbtG9Lww1r0GTI8+SgvfyW08mz6ZaWrKp?=
 =?us-ascii?Q?wJnldDh/bwA5Df2FqdsoH5lE47wBGnLO7+NrIBgD+M3S3yVIxBySvkzGWrBN?=
 =?us-ascii?Q?gxm7lrxaJzVeQ3TFUYfs3FJXE8JUVt65SH/t6vqDFEBxe0SMxvQzPQ0tgDyu?=
 =?us-ascii?Q?/lKuShHgTvWZDUp3q973KVYRKx+TPoh4Gt3LOysIx31iMsRoOHByyIrajJxL?=
 =?us-ascii?Q?N9rH6zSsGzaYzpf67pazpjeHLeeYX0yLF35DvCxWJxFFh2Y5lUHMg94Kira3?=
 =?us-ascii?Q?FGjZkBEzrnZyPoRjCtPsF7zt2CYEWrfZSU3BnrR/GQ7RlGmVlfICI5qYa4AC?=
 =?us-ascii?Q?Xq+YvrQQrvtdCVXz7v31d8I0L1bpbuqvVgGhdcLcy6IWLmmQ3QINyhOLG+Cv?=
 =?us-ascii?Q?6R5B5xBGRaQpsbwU7irP9py87CnKw9rWBSF5A5B6CBY2Pxc1y1bhyrYNliCH?=
 =?us-ascii?Q?lZiDtkB+v/5hv9vkde0P3CfZT2d1aCSEYhmYQf+EjK+lgNnx5P+vCa5dps+X?=
 =?us-ascii?Q?hw31rzfrNKXxao2gJAuhg2aST0WLMn/W/xJwvGIEjuy8ZlbEzjiGOe8fQtT7?=
 =?us-ascii?Q?HddBtyinWC8tbLRmiafUaMKUGJrf+ulK8n8IUrdzhAym6KIpCkoyl/lcXsdY?=
 =?us-ascii?Q?72BwdTGlNWuFD538ukiiOHZDa48Ea9XrbKVNmP5K4Ta5k3LlTN93+d8hY+jr?=
 =?us-ascii?Q?0/oWSYsydQbL7CEJRHySzF3Er9TMmpWa+D0XCIZpyw1uCfQ1weVaSySRXJKv?=
 =?us-ascii?Q?9i8PriUMGXplAjlHia4qRjO3YtJ1MQupsS2mM3v+fJXBPrGHhp2C/0saUXsu?=
 =?us-ascii?Q?eDpaHI/WyoemmA1z1JqMoujj0aFPxIb+c1+X2PXHwoDFNB1OzFzCJTuf4nBr?=
 =?us-ascii?Q?nlra6pFMRwgs7e1cZ4t0dySiq1elvWQvT4JAy6UJYJdc6yLysfGgOK8nut0l?=
 =?us-ascii?Q?gMH+14QLx4AsNiwv++QjxJ0MXkBHT0BiDuxy79ylnQHtHgEe8/GyIc/iEsud?=
 =?us-ascii?Q?xN2C1qExL0NBlPfFyC+DPHVai9gr2JAKhIgB+gB5U+oKq4ycV+EtHdliH8W3?=
 =?us-ascii?Q?K8PZa6FKCrAd7j1PfmSlxjEtRJ6Zk8hMDKJh9diS+5jP2r0LfFF0ReHWp8m+?=
 =?us-ascii?Q?BWNBih3KBdLO5NWj1fZtpLVJdOlH9q0Ff3p9f4IYmoDLsomHLftS9isssz2l?=
 =?us-ascii?Q?vA5+WSZTElS98fGRkqsI3WixSYtNEumohuxIGAHBWUK9/C4zI0DdeW8KIFS6?=
 =?us-ascii?Q?Wy2Xbrx8p4MjsbbwbSsBX/D07Htba6ttJZR3uOClJijgiVSZ55wyZf+B4nSq?=
 =?us-ascii?Q?aW3+RgplUtK+w+eV7Q3/g5+LLWQpcVJUNcY04wtuceqGAxmNGlBli55zFWPz?=
 =?us-ascii?Q?/vQwb/EhSRXgyI0Jqf/yBmAaEtz9rjPgSAgfw1BNg183LPMiQbLg5/vVuVx/?=
 =?us-ascii?Q?axvCtlN7rbJ1iVmnXyZRpglI8bjRyKChXW9SodKIgBgW2U6W5ZKtUS/mGJ5r?=
 =?us-ascii?Q?CxyfRBb5aEnBl3U57yM9Ie7s4YjfLLI943SVbE1zhu5gYrh7b6HWTkT/qGG5?=
 =?us-ascii?Q?WCuym81DfBpj2nr3Ifj4aE4ckOdcwp7gbhotXUndxexelsLsjoez2wqVS+/P?=
 =?us-ascii?Q?sqgpMQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8456d8d-8ed1-4685-c56e-08d9c110ad71
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 03:52:42.4125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u+4UT2jttnmFZF9Jw+2jaRF2b2F2eopmD1EtkQ7WyfSwxJ8VpA3775HB5N0oUuXug0FP5k0WdcgPoVSIZkUJgn3w9nHSA3NbbiB2efNoMIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4741
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10200 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=593 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112170019
X-Proofpoint-ORIG-GUID: ng0ezoLWNMNGhlCIr3OZnZIAthNTzTCk
X-Proofpoint-GUID: ng0ezoLWNMNGhlCIr3OZnZIAthNTzTCk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> dma_alloc_coherent ignores the zone specifiers, so this is pointless
> and confusing.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
