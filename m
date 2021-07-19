Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB0FC636C8
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 02:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 855D461179
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 02:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbhGSCKY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Jul 2021 22:10:24 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:7124 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233713AbhGSCKX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Jul 2021 22:10:23 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16J26kET003758;
        Mon, 19 Jul 2021 02:07:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=49KQkwiVTcZMf2C479YSQSfIJ0/DfWy6eG0yrYnsVmU=;
 b=W4eon/OAfHh8IailIsFKU+zECz+IDTGEY93zNyL2qjSMzVtpo7UscACKErR4VUCdGkxS
 LlGFW1HUEjC1XXbuUcgJ6fn4LIPpjbIoV1gedkHpLKzmV5xWkjOw3fLkb5ZxQMq8hUuh
 sH5z6UblxYnjbLv0AiZ9N1HpgNmIo5QiwRkbWvD3vC+78PN848KAPciCoY2N5W2w4IkX
 kCii19q8DZTGX0h2/pv6THqgJLJmLoBZ+AOBQXTXlXCR4Rx+s7OGedejLswJqdcq7TVU
 evi4yL5H9IF+W7yLFQrHyhdwKs/fYc1o/htGgldqgOwQ4Bx13qIzsOcIWyOJ7Yw0lgeB QA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=49KQkwiVTcZMf2C479YSQSfIJ0/DfWy6eG0yrYnsVmU=;
 b=slt8F/UEh/ZjQZNg8VCPAdQy9XAT4A6HnCMFsIVe0bAXApU3U07UjzFqIhekCfRDMoBf
 Op0VfwJKBTjI1MHiD8FHA2SaimV9YazdBG0PHAsCjxhzK6yAGhODEriwrMEML4RCxRHV
 swIpeu+0bqd04q/kKM81w6aD84ttAGj2uvllJH7N3FUTc0fNzIOF6Uy+uJ0lm9+jaQvk
 LDBYvuJ0QQhL4Thp33wfhg6lXL9ZlCswDxhEWfLQcYv/10Ce/snpNTfDXde/sh53AGwf
 wkrQ/fGEPv5nfT8SQeO6ee474J+7bk2Fe3PzA5ixXm5TQNr3J+kxX1L9HboUYA8Jf/ZO vQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39uptrsvd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 02:07:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16J25ApI015410;
        Mon, 19 Jul 2021 02:07:11 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by aserp3030.oracle.com with ESMTP id 39upe7cf95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 02:07:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYxyV9d9/Du/VAPWLEl5l55tEriuppFfuCJED7bck1O9XteEJ+M6zYU1w9lbxmfZ+fZZJfWBzRUPCG2PnozO1im3BWgn/JzLyDy9to3SrjhpQ9Rzipbu28LdPu9cMYD+lnlhyNWgRuRwPaY9ZOztQxhhIZGVJS39kf/1xzQRCRLBoNTNltKqR5iFVT9KZ5FfJ0o1aP8m+clzaCNaL3HEPht625nOFKdUKTLp5gkJG1ltlcDzm196JKnok6PeMGZto9HwlOMSXhnPnlkBX6JIpNaKldLkUR+mpcCLGdfm9USSPZGAKVnri89Yec+jjabNESByktZT/CZwfhkOIla5RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49KQkwiVTcZMf2C479YSQSfIJ0/DfWy6eG0yrYnsVmU=;
 b=TTu20KdkDdTEhems9qst9kYTRjBr1y8UxLhecgAtXPiD3E0mZRZABnrnyX16TaL+o+F8lNGaQQeJTj77Xsyrd5lFWmwYghlsRobD8GCWYr2xn28l5vkj/8fpqThX9vPahO38Asm+8POGrqofQ/kQpX9//mUyx9GK9qZeEyUJXt8UlXJOYCc7icsnuZNdVKD3d+1emgdaYoFSqO1M4tuq4opfzK5AmxOgtsUrdrCA26O134tz7RYt3sBXqDVJf6PZLlA0N1PBg/Q8XN/f5y6YgXjHwtW4NNFJPPmJcKJV69D9FkkXwUH3sfWXUYw9/oP5ZxUm5xnZRBmMTl0LHN2Auw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=49KQkwiVTcZMf2C479YSQSfIJ0/DfWy6eG0yrYnsVmU=;
 b=sYf7zYjxevtA3aBce/7kqry6h1IYC2jRFmG6MtwhtPtfXe3urh8qkTat/WuMWzzemcvmMXZ03vEbRIRtxTrclz5WmbpFAch9fRk0KYLOicKxtrU0Xz4yikFCROj9fb7abRR+S00Fk8QPi9FbVU+MuMlReHgM4Fh/4noq1AI25wo=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4519.namprd10.prod.outlook.com (2603:10b6:510:37::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Mon, 19 Jul
 2021 02:07:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 02:07:09 +0000
To:     "Chanho Park" <chanho61.park@samsung.com>
Cc:     "'Krzysztof Kozlowski'" <krzk@kernel.org>,
        "'Alim Akhtar'" <alim.akhtar@gmail.com>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>, <robh@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <avri.altman@wdc.com>, <martin.petersen@oracle.com>,
        <kwmad.kim@samsung.com>, <cang@codeaurora.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>
Subject: Re: [RESEND PATCH v10 08/10] dt-bindings: ufs: Add bindings for
 Samsung ufs host
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2a3ysix.fsf@ca-mkp.ca.oracle.com>
References: <CGME20200613030454epcas5p400f76485ddb34ce6293f0c8fa94332b8@epcas5p4.samsung.com>
        <20200613024706.27975-1-alim.akhtar@samsung.com>
        <20200613024706.27975-9-alim.akhtar@samsung.com>
        <CAGOxZ500JD5xNWb0xFyEgaUH0qwQKm+kn1Ng71_1SM1wmJFxKg@mail.gmail.com>
        <CAJKOXPd6VMBaW7zBDXb7tXDHr3xwV2yZXxZtLJqNe3T69oUqsw@mail.gmail.com>
        <000001d7783f$ae446670$0acd3350$@samsung.com>
Date:   Sun, 18 Jul 2021 22:07:06 -0400
In-Reply-To: <000001d7783f$ae446670$0acd3350$@samsung.com> (Chanho Park's
        message of "Wed, 14 Jul 2021 08:34:53 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR05CA0017.namprd05.prod.outlook.com
 (2603:10b6:805:de::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR05CA0017.namprd05.prod.outlook.com (2603:10b6:805:de::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.10 via Frontend Transport; Mon, 19 Jul 2021 02:07:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 577c7cde-bc40-4edd-307d-08d94a59ea87
X-MS-TrafficTypeDiagnostic: PH0PR10MB4519:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45196C59D1391B4218C1DCD78EE19@PH0PR10MB4519.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tokNI5N7MT22AHf9U27zw2xYGB/4BZX2oU9VnP/4+DsI9akhr+Jai6C+3ZIgQeMPZWh48KLuCxHVXQ0Pc/0CdMOljT2p8l+7ZvFXgpnchLxwi2+R+wmtI60a+KXrRyacP4P871tdx6U2HroTysm1FdY8bSmR6zq8wAxsWRg7UqZfty9J4WSH3z8okFIbMsBUR4EseWG0m2gvks8RTV/r6QlwNVi2Vx+bwAMTNFWsbX8fs33jKHP7bwumX0WUnQW++NE2u6hJy3xfNkenL0SFoG7FYD5UR/kKZr+i7XZczb5iln2OXWsbxQe0GTjMRtCp+/5vYey1163JkqEGyB31T5k6T137IJP7FTfWBtjIjzE1Q68cjhbBcPeTfV5VkQbkGqT7j6qCWDTMSbc4+qX/vTImceq21QgUkb0FL66iWbnbsvsWnw0ooGEgrho7Lk1fifJBbt/J9apqkhvUzVqCDVrJ3b4GhUMHn0H5OamMg+HJ1wXJzPY8cCvkA0i2oaYVdEQFjCPhq4gDEsjWkQ+OtxGSkuVitiyneg27/F4u5gQvzELkAsgcBTZsQpKjI7mJz4CXPuAcH3b5o9JpKTav9X51tP2x/sh+1Ps09qW4DUdnDS2MM0tjZtqhfh48J2K3wFyT7I5bdUFMW2WOE0bIESs7KUIGPlFSgQol+sBIP404+Ch5pgrIUmqFDuyAVK3yc3EmyAYY2HK4t5f0kVUM+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(54906003)(316002)(26005)(6916009)(52116002)(86362001)(186003)(36916002)(7696005)(7416002)(6666004)(508600001)(55016002)(2906002)(4744005)(8936002)(956004)(38100700002)(8676002)(38350700002)(66946007)(5660300002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ET+HoILi7+E5C+XPSfeWUH4An3YeUErYStr2E+pOH6KTzXQglcZhiAmaPaEu?=
 =?us-ascii?Q?5LjDdP0yDcT4i0R3XFnxKv8yrBS89yulIinFv79siTla8hGHl82cgoUce0Ts?=
 =?us-ascii?Q?c/YMry8P/zfCYXyWjsCFBwcK0NjHD5ZpAVivKMYVzCfK/ee0q61khXClW/+c?=
 =?us-ascii?Q?7KEblcLNTYjBJgvXjuMK7HYQKDEWImt4bE105Lx+CzBcSeAGzJzZfXoVaeFq?=
 =?us-ascii?Q?XdIs7mBXb53z/IZJ6HbEH3hwVeGZVmA4FOn8osNXgtpwO0BA+J0IhtqewgNd?=
 =?us-ascii?Q?1M/WzBNPMW4VFVRzbALN7YRt2jHeyyVpYRiDRQhp3jsaYWfuPtg0ndmmL9qm?=
 =?us-ascii?Q?aLF7+NpzzmsYaHE5+s3w4Vo4PL6C6/B3pGSTJZcOp38+JiL7jud4kOrBzg7l?=
 =?us-ascii?Q?jbrMSpHz1FnbtRZrYzIsr9GnM/CICQsX9xtd+fOwdhK18klwgnIhUCjdaDEc?=
 =?us-ascii?Q?3A8badxQRXBLWXVqQnVeYmgHS6pwzseGKuFm07cvIueHslMPYtKsZS+IfkMN?=
 =?us-ascii?Q?YoGg4gWI2Yopn58lUDQoLATd/4Pyk6VeUQCFybHmqgncrVWWn7ZYpg24XPjK?=
 =?us-ascii?Q?h1e7KRvvfvl/f6MREtHe8BSBUTjp6ESwuI3fY4KPVu2r14vU9vaR07yvjQd7?=
 =?us-ascii?Q?l6pwrgr3ao9MfjWMxbDomL6Oe2AsZeKqFnBl91paoc1HnVu+MtMyMZz2fe+r?=
 =?us-ascii?Q?4QKtp3N6kML2FQHAZpJi46SzUvmjq1tzUNm5lMpyY7CiZ2XxwuqJM3uLCQg4?=
 =?us-ascii?Q?WJVINtEjw1ObJ0yzY1V2hHB9CMyozNlA/Nzwb3+b5WM4dE8JJxKxV+Bax3iK?=
 =?us-ascii?Q?6Rg0LRI5eAtWOEHb894XytE89ERTe3c/MsHAIuiGM4sPqi6pPmdnkaj6pKLT?=
 =?us-ascii?Q?gauCVHs0qPTHOP0y5zeVPtEIMaIMSnM6z1xtEcpXpeBF/FQceQrZ/e9FYdG1?=
 =?us-ascii?Q?Q4OYq4gacUF4Fz37C+RjuLjY2eVA77crMVMSd8MfW9k05Qz5B5FzxuBwfbM1?=
 =?us-ascii?Q?//VR6qlo0cVaVi00QGfMj9kH6GzEFq4ZSkGiuVnz/KQIqhQulnTbHcFZQqrQ?=
 =?us-ascii?Q?RtsAXATtwSuTznoZCy9BsVeZ32XJbBLgntheCcAXUMhozn//YkTvEtY97Dnj?=
 =?us-ascii?Q?dzbhA++eQubPOLyxYtSQi7luvABdSJ8is/nm4nlrVJfqvHD5V9h5FKmz0Frq?=
 =?us-ascii?Q?vw/L2nUKk+P5AeI7W09XRJnUA+GMrUBPzLMyVkYt71Fy4KPYkv+KAXNhBgoa?=
 =?us-ascii?Q?A1715gJlNw+HnHn2Pe5px5IGgfYptKc/rAXAgyHlJkiWnGhgTVEtB/OtCM/K?=
 =?us-ascii?Q?mB1e/d69HtNd9o8W+9eNuc4X?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 577c7cde-bc40-4edd-307d-08d94a59ea87
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 02:07:09.7904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: smYtRY/CxyoyjZgE+M8fq1Wg91mz1PyWOYDKC/EuXMqEVrK/bcfEmyzAdwVcxlvU9tMYHasXcksZX3iae7fG094Kvl1Fac5uNQrYVFPwIv4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4519
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10049 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxlogscore=994 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107190011
X-Proofpoint-ORIG-GUID: NNBrGUqgrglLOIGdv40PLOgPiJu7Gl-l
X-Proofpoint-GUID: NNBrGUqgrglLOIGdv40PLOgPiJu7Gl-l
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Chanho,

>> It has Rob's ack, so it can be taken directly via SCSI tree.

> Anyway, who will take this patch?

I can't remember the rationale behind only taking a subset of the exynos
series through SCSI. However, it's been over a year. A resend is a
prerequisite.

-- 
Martin K. Petersen	Oracle Linux Engineering
