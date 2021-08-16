Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A83C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99AD360F39
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 17:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhHPRT7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 13:19:59 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:20654 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229699AbhHPRT6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 13:19:58 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GHHcqY015602;
        Mon, 16 Aug 2021 17:19:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=RIkFUs5iDABU35iLXIs/GszCJlvvMJkJ6oAC//5d9lk=;
 b=rxymStAsmeN5C2hrdMY+jVYZvPBcUMHG/zlQ7TGP/i01vtwvG21bfv3gAfZ/zkXSEmSp
 9hm9tTGxVgRtrfrzKO/cP9MxPK79NJitF2LAXVtjyht3Aj/O2MEMQDPAq0LHY0XtVaqr
 YH4dGuV5m4PLKFy04iDjirD47UiFTcvHnhe7gQfL51I6LdoJHC24PyRDsDVh70klGEJn
 YroNHGfsN8Y8lZL7hitncA9lenzb5GhLuRoSC1ocg+s7Nha++A4az/1irhyCiccY8FVj
 b1Y071yQ93diHihC+7foKHwZV3rET+aGP/BdVYmZZiRRp1NzpeGp2coCMJ/unz2m/+Dx Mg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=RIkFUs5iDABU35iLXIs/GszCJlvvMJkJ6oAC//5d9lk=;
 b=mz6f5sdnj/Voi5vohjo0FYPQpPHmk/rD7u+JmSTVVvxPeCESYIgd8lyfGzfR/wErdMbX
 1hDQxEb12BBHLAf/zmQ5NARZIhxO10o+/KarJrJt6TtrKXtbmTz/eLA5H35rj1tocgY+
 nM7j//mPK1qCM+b4DRyoXJ7bExljA0kuC3cXYkdkQWjKb2ceQTTX/kY6w/QS5XrKorOM
 8zPVHbdq5CYT0TBKdAqlCe5iQo8h/b/4lYvc5LCnjMK6bi3f3DQEuGPCcKj7yMGZQo3j
 7oAJp0NXFsi+RR+MEazV4D0GDWIUxUbz9VpkKgNGDT998vv3v6EcmX9xJ0P9Y/7zHD6R ZQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afgpghq1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:19:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17GHEti4158463;
        Mon, 16 Aug 2021 17:19:22 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by userp3030.oracle.com with ESMTP id 3ae2xxjvgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 17:19:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U87RbSUFDvR00mDriEKniJt1uvEszeUi+ptwHw4cAmIdwGCSsdvbvmuNiSDF4mRgMpoF1scQMxJdW/DYFxNEYFhp5vTSoPdhkHT9xwuoLOmxIivedOWP6vhHtTDHtFnwfumWLdJk8bjT3fXr/WIfdNhZBFmEZeSy+a5tUvaNvbKb4v1so7LMye/JfanAIAP15imzci1Ms/PvsRO625NA6r8pVtHT7Dh7yjmSJYDRefyNGZB3BwsGZreIrWtodCXRljwfsUl0JTnmzWIITXxllfJpqLwNgeCaUvuls0Fw+mrMSJzyo08byC11QVGWiSB+QFvQstQp6JLjsKyp+MY7Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIkFUs5iDABU35iLXIs/GszCJlvvMJkJ6oAC//5d9lk=;
 b=hAhJQxSUsks/V0f3QyR97aaYnK8bPqmly00GsC/4JdVjbvjwk26se7vvURhGBrj9CsuFUc1TSdSfiUc4eCMOCeHqUgkzPSeLD9D2QdZqo30xnSU/ulwq6aOs3ymHXj+0TX9Fv8+GeCll9JL7ji+k2Dzfm/lEsqTsd0UxjoPXEEfUDboy28Rd+rWwyiTyNyDUnDhKQeLbKJo0NH0Zi/KQXB5/XLRixitFMruDE0a0K2fVA5SGa/Fzhw8BiS5waNIsLZZwM62eJQnfGFoxwPA3cUhMzRhRYG0Gxbpi5yvITa202oNuOmLFWe9VwTtjm7aUSz5kPpqmaTnOkW/DdFIUuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RIkFUs5iDABU35iLXIs/GszCJlvvMJkJ6oAC//5d9lk=;
 b=L/+VMniVTO8FI5N+x9SeCc7QjsUO//mqyLGuFxSO3SB77e5BQmt/BNv7x97l6pMtRoHIaeddrDUIfFsqFTZ6OaHbQ3ecbgE11Tt9Blp9p6X8H1WhMTB1ccKgUHE56e0GsIxb3N1IXOjjBHag0+utachSHhmHGvN9sNZ9hMm4mZI=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5548.namprd10.prod.outlook.com (2603:10b6:510:db::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Mon, 16 Aug
 2021 17:19:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 17:19:20 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qedi: add missing curly braces
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1etpau1.fsf@ca-mkp.ca.oracle.com>
References: <20210812063305.GA9100@kili>
Date:   Mon, 16 Aug 2021 13:19:17 -0400
In-Reply-To: <20210812063305.GA9100@kili> (Dan Carpenter's message of "Thu, 12
        Aug 2021 09:33:05 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0078.namprd13.prod.outlook.com
 (2603:10b6:806:23::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0078.namprd13.prod.outlook.com (2603:10b6:806:23::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Mon, 16 Aug 2021 17:19:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7835ed8a-38a4-478e-c3e9-08d960d9fbe9
X-MS-TrafficTypeDiagnostic: PH0PR10MB5548:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55480C46DC7748710B366B2A8EFD9@PH0PR10MB5548.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ragL1XBdo9vpnsnE4MV1YSnj2SQzYSMd97fme6pBVUFPYbnDWFniBD3HLelMPQjD1yuv2RSaG6Lyx/yLJSIBysjNf+8HLX6xZRuKOA+cVhwom0o/oD9pRFK70+tb0WYzcxB3DkNc9oaS+QyOYhK3NQJxPvjyR9ib+tN3fJoiCGxK5VLUKtcENHiyeuZnQ5NIEXf3nnyX3ejujo1vaoAN5XfDQZNf5RmAfl8GdCL9l48uAX6ymng29Tt/vFrfUjGlHeEhLMXBJWiNTMi1Z3E5P5n+j5aRGtivpyenAdZG6qOxR9qLZFsfHrvx4eCrTMXhlKmV45/+JssHJlVdZhrxRxIBlxYLfdrj/Zr35ADg8PiH1zrNt2kaGNA0JD6i7i27Y9X62f0fb0dCzKMgzRF91tha/YrVngk9T7dmYdFnIlYtOimq/rqrKMIAGFaaqV6lgNjq7dGVjlIPUcG0L3gNPVOyTBUsxgl6Qv/ts3onKntgbLi9L1EKSRB9JFzxgnLf6wIvoRb6kJ1hfebgPWzcyT/mMGXUGN3I+2rI5tPTy3ZmkCnnD+7p87tM4cs6zHOJq93+zsAlCLPyhvC9oTyF5M3zJ7cASDsYOliZ0GdpPtUS+A3MdLrZt2738ywU7WMEtws2cKNUDm+kfmtqYJR6iZk1KrWUvkSZFeHAyAN2PoqpqNCADEu+8m7VBY5AcgMeIO+KuGLtdsQOUg6skhjtqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39860400002)(366004)(136003)(7696005)(52116002)(36916002)(6636002)(956004)(558084003)(55016002)(38350700002)(38100700002)(4326008)(478600001)(66946007)(8936002)(26005)(2906002)(5660300002)(6862004)(8676002)(54906003)(186003)(66556008)(316002)(86362001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lIZwtm1J4DrJZQHioLUQe5buSTJ2fnvQuf/alKU1s0diO+W3oVCJNJBqCSBB?=
 =?us-ascii?Q?uomFIUj4bKcu9OtovTFjWsZoo7M9FhzPVtkW9H1Z1An+d784NXBg/NbJ4Faa?=
 =?us-ascii?Q?FvBRjSIVKvwFxdQ3tR9fRN3reKLwy5JU4u9iJyrlu3QG5kxDaiY8iAHZa44h?=
 =?us-ascii?Q?TfV0a0nnVNjhLgAH6PT8o10IJxW2VZ5V6iZDRoGITQ4TmEIXme/aoFIzCWht?=
 =?us-ascii?Q?wU9joOtFQLLjkiG1U/iNPEkBegv5xAA+qQbXIR8ZArIM5Zv4q1WJ9M7vx17k?=
 =?us-ascii?Q?7+AviE6HqUA+FtfklBB3/CzAnT22H57w6hndq3+PZss/TvWGXOg8guC0vz2u?=
 =?us-ascii?Q?o0nRP2dKWAiblmeCRpjl5BP8o7MeEYieSgw2EyQngNBQGvNcl0eGH8S7KdMN?=
 =?us-ascii?Q?zlxTJHhNDMXZgrQPbOFd1NMYtuTAFIcdJGMebGd+QH5egiFTeTZ5LZk7KJ3p?=
 =?us-ascii?Q?yU1f25pPPR9gMOVzhAwnpNB9e/Z95whYobpwLG9RBYbRg8aaS1yxvUEPlQw+?=
 =?us-ascii?Q?t6gyMilycxvr2uF374cqCG+Arpm6Pz5+pNa6TIU8SYzUotliyptqNVJO7iab?=
 =?us-ascii?Q?VP8y78Xw7Zw8KSAAWlgVPDkmo+xilPCYiK2B6idPreLuowHVvluWb8XGbalL?=
 =?us-ascii?Q?8Ym9A/d+0UlxGM2cOauN6fsDLnc932RiBDEcMLS0hpJysxmpFqf1xny3Yh3M?=
 =?us-ascii?Q?/zhXT3W2l84MDX3T7n6VdGMFEEHXB5ClwhXy3HGN67eLMzwr7hqWBNLCPkA2?=
 =?us-ascii?Q?FC+y8Pm8cSnrk1iwHD2MqulE70cbIsxRxGutXvhk5bUC3gY0Oxh59cV3VIsu?=
 =?us-ascii?Q?WGIWqYfnEYpVCiICmKMFw3W2pvBm6wmeJeLK6+rp01IIO7S7XiKluo9gB3r+?=
 =?us-ascii?Q?o8WTTh/EBk8rgP6aCFjKsP4Hnd26UWmyW6ukNDmAxpF0MV4ozRBp0/Pomm0U?=
 =?us-ascii?Q?sgCp+O8fijFu0AlFfD2qdzV6GgUusdyan0kfeeTwgs4UWHMAenURt1HW37Ry?=
 =?us-ascii?Q?tfNdi032UY1gnCwYePlwxJnhE/E5RJUbx5wuspDd4VCMmETLVJ6qaVjkIS5n?=
 =?us-ascii?Q?D/kJvYRpq+rXI7gYGkCYmA729kTsivQtfTRJtqN0ujWPev+s/+4aGhqPxnlD?=
 =?us-ascii?Q?k0rYvMKrl4kKodkDs+ikCW9tLM5++fg05u9dPZuFTvMXROxq/m6nFsAanX8B?=
 =?us-ascii?Q?RKzK11dwyVlaoccp5zu4ibTb/VMU4gBmVCE+tI95ETCNETVXcNloXE2DK6pR?=
 =?us-ascii?Q?LVSA/HDEfNEAPj0VciumWZ/AeHk1oqmSNixTdAT9CwYx416lVQyv73s+Kley?=
 =?us-ascii?Q?qgjza4+3FSOy5T8K85QwjY/P?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7835ed8a-38a4-478e-c3e9-08d960d9fbe9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 17:19:20.2277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: upLdmtFIZG1LTFRwuQsHO2pgwQvU/SwOQNb0x+hYh7vrxoK8XNLObqaBOxUWOkE51Q5/QOg81+0jq+kyL/+pCgvY84I/yAMicV/YjEaieVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5548
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=889 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108160110
X-Proofpoint-GUID: C9wi2xhel8r_FvvPqx8QtjHibi562sMS
X-Proofpoint-ORIG-GUID: C9wi2xhel8r_FvvPqx8QtjHibi562sMS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Dan!

> This if statement has missing curly braces so it will always report an
> error even when the call to ->offload_conn() succeeded.

Already fixed this up in 9757f8af0442.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
