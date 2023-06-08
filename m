Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18455C7EE23
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 01:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbjFHBEM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 21:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbjFHBEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 21:04:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B5E2115
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jun 2023 18:04:02 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 357N4WQX002031;
        Thu, 8 Jun 2023 01:03:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=9c4WSb6wIC729OmuP/ozqbXG/qW4FajKSO8pDFgZucU=;
 b=et/OFavmztlZe4rHbgBIK/FS5HwrsaCANFe8vkvcjZvNOCVE6ly1NIia2IdObJA4/HWU
 2yvpydo6+gHkTO5RQdYo2YzmdL2FPG3PJLV7U2cEGgI78UyFbor+svZFfA0YLyimc1vk
 VVKuKxitK+0RuxMYlJToLK2+1zkAZcLp6sM9ysd12IawTkQRpa7VYbfdxEUQPx9RMxx5
 Q7RWnsAFo6HZBazUpFUlwPg1F2+0t4xiWQ4E2ydGu/AY1dlXPDFzGNvniV5v2Y3+vQ+U
 oyODztj0vXaABWGy39qtrOwHRDBE8b1RK7qiA+MowkCkQN8ioOGulq5/G8E6PQBptgsW /Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6u34h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:03:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 357N3hdX036097;
        Thu, 8 Jun 2023 01:03:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6s7tx9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 01:03:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWVecj2P+FKDsW4t3yBRUh5NTofviREqRxKIBviPsYmh/Ug+6HBYBXDjGrGI6E2ELmxrZ5D7COm6LUvS9ozE8GGYUL6hDaev5NnVO772HZ9eCeBqv7fmRuhyEbJh/oD8cfA9UnzXkf0bxGXzuLTj0SOnaqYIIDx0iWVnJknuGwx1pzRy7sUg9tIQv4jXs/55RSqM60z+J14NJI+3JA/2CydSPRZ/tGFxZ5ZYaCig7H4SUhhdtcPeWgVBiqcu+wUBFzHAm9wqYpmjgF39jofdhy7txcXYWb5rRsgpZujn22DJWseCylo5eWM3AkBcVNKYDNCSbhyP3d8iHzcBa1o+rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9c4WSb6wIC729OmuP/ozqbXG/qW4FajKSO8pDFgZucU=;
 b=kmIFbfnqN9q7lzUuoyTNSLSBp/QfTp8XgwtmTaRjiQpUcYWq2Bk9JNimsS/xyrZ0omNYUpcVYofdCMrDmeb+W66sKvDPPZJsjLbGcyG3VDri0uT5wvTc3Lb+F239GOVVAKHZGOcRPeU/LFB0V7iBn+qjPhSWBcaZjAxdGPV1+/pMRJWAO0ZlmhiuJ94Vwtv2boA97H+BkJqIdIplAbaLlndMrLADYnOf4aqbzOHxTx/iEnYLUcJXdTji74YMJRm8MHIs3iEBLcR/pyaNlMgA7N7JiRchRrGlazqKhfr2YmRinrZYKRY3g1+cw6BrRs4HUYKSYBgqFxudwRxxpu7Yjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9c4WSb6wIC729OmuP/ozqbXG/qW4FajKSO8pDFgZucU=;
 b=Drmye4XrxQqh+9niE2q/mOIDTejHQxRmh4tvlJgMUmJGJwD0T/NkjTWX2dMqXvBzLw5gfa7PZerkvWgubTGR7cIsFXzSiMGilkWQqcfaQH+0qZWyMbHan4aL/EZTfABe2TyRSlKolJnUrOFfsesclyHlshy8EWjnit0u5MM23AI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA0PR10MB7372.namprd10.prod.outlook.com (2603:10b6:208:40f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 01:03:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0%6]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 01:03:53 +0000
To:     Justin Tee <justintee8345@gmail.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        justin.tee@broadcom.com,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3][next] scsi: lpfc: Use struct_size() helper
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17cse69zl.fsf@ca-mkp.ca.oracle.com>
References: <20230531223319.24328-1-justintee8345@gmail.com>
Date:   Wed, 07 Jun 2023 21:03:50 -0400
In-Reply-To: <20230531223319.24328-1-justintee8345@gmail.com> (Justin Tee's
        message of "Wed, 31 May 2023 15:33:19 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0174.namprd13.prod.outlook.com
 (2603:10b6:806:28::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA0PR10MB7372:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e499538-ea27-46f6-bf70-08db67bc3a1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zF2iwFNrM9oRoKxkUnzd6axJfIUpiVfaoBDqE06zFhipS+nnuI8syC0TQ03SdBe53PN1tU0uqsRg6MZgSnaPFDjJReqDJRHEIf1o45U5aON4MATrYmMtFdS4WyfllvpPAL/h2nKrTQm0ltfspo3DL7dRXtP+U4R5ttdfB8QuPV3ylBqqjxzq8G2k6pRW7Iy/DsdF6CsBJMXPJsxa7d8o9oPXtyNdzi0rW0K+SJshH7ryuGS5oXjV2mvgopzJBnBmZoka3xz8ZhUAmkMU9ZOjYViT8T/mCdUVu4TIsBr/ECDTu6WJS2+JubzGVtbpq1C0pRpgsN66sZfwr+J0kVN5crOPq4gQL6WvRgc2upw7Pjja56H0JOYbn7Sw3mxd3h96YphqSBsf3oB0tp6oW6idj5/ZH59qv2+hqcLxOCipP3fJ00uYkmDg1adU3P/s1F7gG/3JmJhHohneVcZ6Y0tMrKkLjbXkBi4dd+asihkGG5JVPoyhmWLKBll7Tybe+xGU7W/8saoPFROy2+8b318w/+RyhWByC5YNNnj/x0dKnEAq6C9NtbJ6mXZqM0IsBaCo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199021)(66476007)(6916009)(54906003)(66556008)(66946007)(38100700002)(4326008)(478600001)(36916002)(6486002)(4744005)(2906002)(6506007)(26005)(6512007)(316002)(41300700001)(186003)(5660300002)(8676002)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0p/In+pO2i/saZ3EImBMBIBlQySh6cgtiSye5gNSzL6muSqIRhln0/yIeu1G?=
 =?us-ascii?Q?6gyPDSQFMzRvELZbxUzPramK3CGdneYaQ+1+WrhrEWUVB3Xxejmri7XNrVPv?=
 =?us-ascii?Q?WkodUfay+1V5SWyH5JJlx2mvl6mMjrPUpSO8JH1/RT6fGWEofNI8XSqFgnyB?=
 =?us-ascii?Q?CMnCPtFRGsTMqNSfH0HZ/LWhBlJg/nG3QTC3z9Dlm0kXgm63ghPadiC/J5GP?=
 =?us-ascii?Q?wDALxkvcvbRCJPuZEIETW1lLnWLT+NSpv1FA7ILtQG01fWeZhPBO19t1OkNK?=
 =?us-ascii?Q?9OQ3sECefxcxzEgUPTCR0cIZOJro6rWAU2VIwM4v/XwXYIYKdMiFR+CZbMGI?=
 =?us-ascii?Q?1vv9R6p2GsRS8SMDx+oN2i49b1Dwm/VNjkUjq7eGgO0NxvnaZqa0Ru/1oEYE?=
 =?us-ascii?Q?xjn29xu01XAGx8UsdXJDzVDLr6gMjixN/6nJtahIswuZjl/WQA75LWpjo2ru?=
 =?us-ascii?Q?QwwYzyag+YEvINOGoy88assbtORPQcUs/Jbz71qTsuzktaeugHtBwV+FXgzx?=
 =?us-ascii?Q?1vwcuF8YhjzoWnkkgZu9F0EjHWlGKbprlW0Y9WZnLWWgDVrCOVSeTRcJrOAr?=
 =?us-ascii?Q?ixD/lJx1ZqoqgQJ2g8BKKkdG1Fe9u1Pc/FDpfHWWFdI74ANQHMlQATjoPS3h?=
 =?us-ascii?Q?IyqkfCpcNot3rKTMPepgVfHxkZBfGtkgYjJ3mZeXWLnL9qadAtPGzRtNwDF8?=
 =?us-ascii?Q?o0wn3C2zQ0tdGuO5B3L59fA0OloMTr2zXF2W8U6VqFXp03aB5FZhd+TShCkW?=
 =?us-ascii?Q?6PRd7soymB0n+SMiDTyS0mPMJ1+IonOQNOnO+2JKn09FXUkuNAUcTI6LyzsO?=
 =?us-ascii?Q?VtatBTijuy7De0yauIyAu0yvX8n1EvQmAzCjl11JsRPHj8aNP4de6pkW4R2K?=
 =?us-ascii?Q?jdyBk647alrtrx7wSYQ2m6M80a4Z2cYx0lBITuLEEbEMBf+WURnMQ/a8ltgO?=
 =?us-ascii?Q?e3X/7+QJ0Aml4sF4s4O1i/YsW0W7XA9EaG5gORTvtla8zUvGgQakJvNM9Say?=
 =?us-ascii?Q?4fNo1dspdY/qAaNNQ1kTwoWM5uBwD7L9CzdSa/MuIid/fwOdZIrl55Sa4NUU?=
 =?us-ascii?Q?+R8RpZKiY/D5hlyL1mavLAdBA06svN5bseGRPKj5BJUJuyPj4MLv3SU6lCwj?=
 =?us-ascii?Q?V7AnKUUrHAGVy4IPA90U570ee2waeYV1QceC/9JghKOJy5BvcGjZFc/o7r6R?=
 =?us-ascii?Q?QUde4kpwOwfQhmEkl2iN6zwZ/nUqRMxzqu2lKRqRSAJuC4geklo/UdN1ZFki?=
 =?us-ascii?Q?o9rDbfBzBh6lBIWI9dZ37e09xEN7syH59BY5t0lI8plhyDKNuRsFocIZnQ/0?=
 =?us-ascii?Q?1R8PdbwIaO+7xrkBb7illExopcGB5v8p38qxZYC+1y2czqY4XTmxa+3yiU3J?=
 =?us-ascii?Q?iqDjBd6zdGzah0rMd3HiIhfm6jFBkPtvBZ/K69IgJl033VnAl3aJ6tmz7pMn?=
 =?us-ascii?Q?S0JsOLODzVqrcgoyLXVwIXnssypiJYhiXZW+WZqPEcXba6VZXIVukRq/vuFm?=
 =?us-ascii?Q?8GL8FnCUHBUyCCXqdM+pl7ubWO7tC2A7X+ogh5E5NGl1HEmLI6dqwEfh6gY0?=
 =?us-ascii?Q?Jk6ZM5VLdUYI6n+j7GDWKveXmbPwCY/1RrsGUEGY3eyl8Er/JB4O0DUjXIYs?=
 =?us-ascii?Q?XQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xf/FFD/xJKT1edN/GnBsPoOg2FOEPh4fZbz5821tPcTvoAvvSeCu5iwO4/InkfV1tU4Ji0jPqHi/rTkTyT0TZPv5eKAiDJpbHGdqM2FyNqnPLFJx2bEXhxYodRuupfMZvjdKsruHd+WX0WUZaPucliYYFMKm0OfmR3RjzIdAgAHOc6oh15qxOp2OaHLDhXMTD4Ps1za2F0Id7+s/vK3pRoPZ7lYGeXeCwVZo1A240h0rpoITEywZ1dFd9D7EYRZCVH5i42zHgRfKy+uQyDdtSH9e71hLv8JdC3eBEGW6IBy0tpdWW3/AcKz/pM7SGo4UDtvCvQhnVvwy/0KY658nXMcQ0jDv6MjAWHLuurug55w/XNf1T/Zrz2RbOBAe3uEVABQB9qIS5b826Ghzri1KTTJ2gzZ7NWG6MtGO0kpAMFxDCuinAsn1pkZZL5QGHSV37Ul3yBVNbNqeFuxOv+dchaod0A368vvDGfU6WJpUjvCG/RcFpeZZatEtq/P2oela3jplltsD4Ej/eAYi7lyMtvr3vWNQGnwNcVytwF2MeRqAra3Ve7jfq4Afe5sSKdpHk680ef9wXfW6xkypaurrJ1NgAo9UfkpwX5K1WuBg+JR6M8Ncl843c0t5svZRhJlBxYXHrYAQ3crTwhWkrfZv0lJYam38qSDRLxzBbXIlJoF+Jo+dtkcGNh38tPKRV0r01vT7MfZJ9gQ7jIlR9M4dMdHXRcTo9PEiJarOo10VLD1Fn1SXWspCIdCJ6u+5/vDkXQVljoO1s/dSjMJ+B/pgVeYgif7SW/OOLj5hKwuwYID6otpnDO9YmecOGqTKC0OYZ5o4x8TcnIsSnu4NidSt4k3eqMCJlJeIsabkWqsz9lnYckI9HdJ/Wra/zJq0uZ2l
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e499538-ea27-46f6-bf70-08db67bc3a1e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 01:03:53.0675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wv3jDXw4ndmzH4CLTDizf1kzkK1T99xmyZidZxUWnGrN7QklaVmauBTXUIfCxGatRc2rAS2kKqoH/ay97fcvEu3B9m29b4Jx5yVxJm99xKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7372
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-07_13,2023-06-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=599
 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306080006
X-Proofpoint-GUID: SQxPlIZYNNDKzkpT_mCiTkQbcTgVCmW_
X-Proofpoint-ORIG-GUID: SQxPlIZYNNDKzkpT_mCiTkQbcTgVCmW_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Justin,

> Prefer struct_size() over open-coded versions of idiom:
>
> sizeof(struct-with-flex-array) + sizeof(typeof-flex-array-elements) * count
>
> where count is the max number of items the flexible array is supposed to
> contain.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
