Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA01C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 03:19:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEE8260FF4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 03:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbhG0Cit (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 22:38:49 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46138 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234513AbhG0Cit (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jul 2021 22:38:49 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R3B9El023673;
        Tue, 27 Jul 2021 03:19:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=c7wEszgMOk0HzwXpzHd8wU/cNg9Vk2I1OPw9JsEf7r8=;
 b=K+oX7tSJSJvOBerqJwTIne6bhj/I3iE9GBerd+TKCQbtTlZl5AzyTbk0CXs7wNdhOpTB
 FV5b3QZ3089lxRCms+myUjkwJIWol947+xYk9VSBhudaQNp7AgkrPARdrpQHv/OvNV+u
 1DzD/eQF4vZXqfLI7rQ39XT589zbBdXZfCG4iPPxatZYBmWf8Vn7lmKBYE9/XCE/N//5
 Mw1XEPaGLljJ5GBQ0kmXj4X2w/mROa9iFQYhyGGDBc8RY6SdGFp+j4Ux0YbXW+qppQZI
 sfO5tW8xx2jMThBlE8AY9xDNkNex5+cm5zR6hbagMFB1cWMRVJd2vGpZ4TqAcsS6JErZ PQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=c7wEszgMOk0HzwXpzHd8wU/cNg9Vk2I1OPw9JsEf7r8=;
 b=lT3CHtAF4S4SS/MQkVpPgVkTF4rH+Em9zHzV0f1KQP4MHtkq8FuU+JPyu3skAQEvFzxn
 maUYbTBItrSFcXNc8NIMLq7k07XCV1/KuP+RVF7l3KXR3fCLdWhgjlOwcjOMKzyGaiQY
 JGfoqJXOCJMy/AtmiDazDVBM9tKNU0BS8WO5yguDpNcgk7MYpeU7/wQ3knxQaBijh/CT
 roBd3muMxaJuPS1vcK1p6uwW2U43EV9ahDvg0p+dBvsl67gNuql4eKERlB0LBdkgeryO
 ll6AowrN66hssDsAH1F6rDEWxEop8+063U4G0SHcQFE92xhqHbFeTlhmd71dhX+Ylhs9 MA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w0mkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 03:19:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R3AhMi142070;
        Tue, 27 Jul 2021 03:19:07 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 3a234umkgp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 03:19:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+usiSDK6HaJ2DGYt+xHLOJmr8lGe3JGJpVzxcjjRXKeD0m4f9xxbof2K9JNcRekI4RXZNXgtJBzmTnTuLIAc9wz1+7G8aNScFNtgpo+uJTbR1C9MQ0YxcgWOXD+K1WAqfBOMeod8FYojaxw3MZN351akXERxcVnEMevrym2JRj0CTcp0owidJsYsk6uXAltTr3OflUEPUD/kZoxqekVaVuZ6uWjMO5ACW6LUWUjaGgzRbht/G4jhjVUQ8wFq29mZm1RCWGBt6UhrpJrGHGTjAI4+PIrR5fIMnUPg5hvsT4X4p6E8S1hWtwvK/wO3B+AufKkISxVBZoDTm1Yd/CBMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7wEszgMOk0HzwXpzHd8wU/cNg9Vk2I1OPw9JsEf7r8=;
 b=geTluP2kwBmCs385Q37n9FJePtV3OznN7ZSb4MtplDdWbKTD+JXq7umHkOtzkt6fSX7Ifhc0x0rtnFDajXOjywZ5/XxhFXz3OW2Z/mn6jnX8f08XyEAj5oYnebfUWxGR9utEoT8Lxn2rkBYY9HvHabdrdqQ4IoQ9Xjiy6XcO1dXV2B2CLJ5PjgmB4tjLD4KyPYwuF/AMUsG4o/hoVgcOJtMpWo6AcncvQV/n697G3HrWyU7FcVPv87ti71Ji2lEise9D9Gsn6mhTcX6N5EiAIcXjZKgnSAGn8+FCTe/eFdAIC98E0ByQjxhjnYlSv5Wqh/h2FmEw/0yHMl2pjq7i9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7wEszgMOk0HzwXpzHd8wU/cNg9Vk2I1OPw9JsEf7r8=;
 b=uyUm3SJelk1bSBMHWHu1fDcw2bwez5gC54uRWfUFHSJPG4LAJ7JKLxecLnMtYyZqSTGovnz3DoziCVgGop8WxlPRmDxuW1e0DZnvuttcBSc0sQR+ILZRLDiZpXYepP8Uo+C6p8wjFDgIqafovbSOqsAG/5UuPauJOEJk5IMtxfY=
Authentication-Results: cloud.ionos.com; dkim=none (message not signed)
 header.d=none;cloud.ionos.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5578.namprd10.prod.outlook.com (2603:10b6:510:f1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 03:19:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 03:19:05 +0000
To:     Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     Igor Pylypiv <ipylypiv@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>, Yu Zheng <yuuzheng@google.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: pm80xx: Fix tmf task completion race condition
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmv4qwbs.fsf@ca-mkp.ca.oracle.com>
References: <20210707185945.35559-1-ipylypiv@google.com>
Date:   Mon, 26 Jul 2021 23:19:01 -0400
In-Reply-To: <20210707185945.35559-1-ipylypiv@google.com> (Igor Pylypiv's
        message of "Wed, 7 Jul 2021 11:59:45 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0043.namprd02.prod.outlook.com
 (2603:10b6:803:2e::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0201CA0043.namprd02.prod.outlook.com (2603:10b6:803:2e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Tue, 27 Jul 2021 03:19:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cfdeada-7231-4c5a-5579-08d950ad4a2c
X-MS-TrafficTypeDiagnostic: PH0PR10MB5578:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5578CB752BFE004168FACE3A8EE99@PH0PR10MB5578.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dgesFqE4hUX4nRmfSzTFvjwPjUeKKtNVmYNQjSYJtoz0vzvVy7SYSJwkCi0NoALcNydLIe0n/sZmS08W8HDT6gCF2vlxNGeQJEKaISL0eF/x8s3tzVCtTFxTib55lfK8myhjK8sf5DyZl28iEgy7sXqGFP+PI21sBeV2MacBH5B1LaGLAaMCCMCIsFsIHoak3KB30Kh8/Gj5IgmyGUaLOZuMWx+ZiQe44V7bmkj0A4m2Q0E8facPfcFdyPLBHHMA1tWfCfdPT/UBejkDSPNY123B8h4OtIb0MJtpUV9o6XGj8KiIaNB5bbXehVxW0Qkq90hAYIPxqCsR3FOGD01TNTQmM251Tljw2444dDyZL9vG5i7tiAxg4nWs9cBZGrIu2TeqTdPa31l9U08PLRJcNYzonDsF4MmPhPojnRLOFgmTJInHHAXzDq+DkP8Yp8tFkWNbzd9rnIXYyQdQP/5LKknaapU+C9quofEqvWJEHczfchMklhofzZpzF0+YJaNwGQbTgYu7jhbCc9YyicUmWAkGw3Qzk/Wu6KGsmtrGG8qQ3PkKknbrH55O8Cwi4AeCma/bAha2fPAUr1hqjDWpnRprpM5z1yzfog8Ihmn0ooLdEItRSkVrH53JSBbE4XuTT+i9VFHw9x27F/lwHFWzo2CuLp9FQq1kUKHHXEIABiavoc7IzuxZxcB77yXi1eekB+cnO151Ue1T8jPERXLFNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(376002)(366004)(39860400002)(4744005)(2906002)(26005)(52116002)(4326008)(6666004)(7696005)(55016002)(8936002)(956004)(66556008)(5660300002)(38350700002)(186003)(86362001)(478600001)(54906003)(36916002)(8676002)(6916009)(66476007)(38100700002)(316002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5jb3GMWgpH/AK4EPEEzeePV3QIjPI2PnLe8arC4DdU0GKqrPCzAjeUj3Pztg?=
 =?us-ascii?Q?oi2BuSFDEjbsu/2BTdYTMdbCvIYvKcCgAK0r/M5NzCJtKBDbBDj1bT01UXu+?=
 =?us-ascii?Q?sdU0YaQEYVtGbZzD9WJ5s/HYa63KE7O4GMFrBTWaPt55FGya+Qxfod9HV7Hz?=
 =?us-ascii?Q?0IxDPI0lpIhnx5+dftZ36/RJccYigcXQRmZjI5C/m+ytct5B+SsXGs1Y2Oo7?=
 =?us-ascii?Q?xINVmKG6+JlCDtkFvEbQZdudpHwPM2CCcmz55/yeQWYJPvJB3jNYPI94lpvF?=
 =?us-ascii?Q?sgERZ7S/g9IZxmLsWRc4bLQ6Ny+lSlLJvtafWYCPo7XVNB29OXnHGMF2DaJP?=
 =?us-ascii?Q?zPpai1+YoPJfPbo/uYm+ZDjB5LLLCS5X+QtW1Su9ZhsuN3DyEhSQqi+Q8yI5?=
 =?us-ascii?Q?V4dGdRBAqtMowEstn2KQZzR/7wsxGax79mBB44FYHg2oAfG5mVC2NgUztZEn?=
 =?us-ascii?Q?l7uj8Rd0jZK9+nzhYK6I8a+vuN2oWjeFsXeUeUxMyd8UlVxeDDJntCSHvdix?=
 =?us-ascii?Q?I/BASulfw2M9A0eSSp7lFojuVrMR3WQG1BupOVuOjuI+wWvRUW1mep/Arv2W?=
 =?us-ascii?Q?TtxTq+H3tru69M7xzAbqXu/BL9itJg+B3nhvbsG8SlZwpeXks/rysHqLpP0U?=
 =?us-ascii?Q?l3yAnqqx9A3xMPBtl2z3qBiRkb6qyf+7bTtkQzP1SiSFOZbCVum5jrGBopd8?=
 =?us-ascii?Q?1hx71G+ki5+kIXEAj0C//SxGllxTNyeOOQJNlPdrfL5D3zKxAgXJStDO0VZ6?=
 =?us-ascii?Q?YDKjsNwgvwqxC4EPuR7lpPdcDtpZMRFd9AUNHs9gU4GpVdnGXVxb/Nc7WfIV?=
 =?us-ascii?Q?GiWSFDXZWuA4CQKJfZt9fRLQAECRJ7uQqOGwWYEOUC1BENlrCt7jdyh+r3MN?=
 =?us-ascii?Q?RkMFbE+NvfI0xOPtyi1wyuKyEJDXyCDQthCus278QInYsegE6jI/6f9aPOAx?=
 =?us-ascii?Q?0LWjRdrGhJ6QEgK5rPhwVZSODsSMdqWDgdbVMdHPR6o/z9LHgC7kd54apRag?=
 =?us-ascii?Q?ygiQvSmPJ9n3CDHJ2++9X7rHb/h/0IF/3kb3O3n77HnZRBGmaN3tPOW0BucQ?=
 =?us-ascii?Q?CczP0beUa81DnINsnQEgcylM6MjDpcoWZXdxH50ta88O7CVUvgDf2+o768st?=
 =?us-ascii?Q?wdoj+OnNyAvaJ0tGwFJeInNfZS/rljBtHM5jcAV00NohMAPjyRBXGoC6wxXW?=
 =?us-ascii?Q?tssmUPdn39nj8DVpld7wTvUZF4l57K8PNtd8SWBopthM/F7GKmV5JEMZ/okR?=
 =?us-ascii?Q?+X4Qk6Etj2lL+2VM0O62Ue6hPr6BQbzM31I58UiBBPLhHRoHg3tllbiLmKA6?=
 =?us-ascii?Q?x+DmuSO/ZCKzOTcFxF0ee8+S?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cfdeada-7231-4c5a-5579-08d950ad4a2c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 03:19:05.5620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qzjg9KQi2/skHFc5kO3S/gpr3O2kJrEA9aTHuU3h72wgytf/qQS+amO9mzT6SRgDm+Absv9sxWvAj3X2tbgsrwrHADRkfE80e+YA/BLT/Qg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5578
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270017
X-Proofpoint-ORIG-GUID: flJZ1o5Ut1aMPoVlINcCgaljn7EhVgam
X-Proofpoint-GUID: flJZ1o5Ut1aMPoVlINcCgaljn7EhVgam
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jack,

> The tmf timeout timer may trigger at the same time when the response
> from a controller is being handled. When this happens the sas task may
> get freed before the response processing is finished.
>
> Fix this by calling complete() only when SAS_TASK_STATE_DONE is not set.
>
> Similar race condition was fixed in commit b90cd6f2b905
> ("scsi: libsas: fix a race condition when smp task timeout")

Please review. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
