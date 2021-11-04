Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B90DCC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 01:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FA2D611C9
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 01:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhKDCCa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 22:02:30 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:59352 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230198AbhKDCC3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 22:02:29 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A40e1Ed021274;
        Thu, 4 Nov 2021 01:59:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1mmZHMP2bT2e39+3OCacHXQsu29CbP0X6Lvkqh9HgjU=;
 b=wrL+VJv2FRAH1+xj31n2YT/Jvuk7L4JRK0USgLARpcgnsnPQkAiklYY7RS8HdsNHaG6I
 6UkxQgrGseyoRtmjMftneRGAOIhOluC/gCScbdZ+6jltxaD2bBNNk0wh21YCVaWmNJZT
 3i+dq32KNhzWMFYvNZYsnAHON3WAbVQdi6FF2bdlnku4dmkH1+tFFXzm3q5UJqKkiDwU
 tsSfxXVPk767WCWFDCeWOB5aB78hknL8PxEb3+PrwaEWxyBp6ohSKUsRKALCH5ridUKv
 NuCt89qirFd1uHqd7aspM1KBsQV3T/Pc7+O8Dqgeg3aEIHk6UvLp6Ukh/3moxCbzz0b3 fQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c3mxh68ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 01:59:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A41pgRn102558;
        Thu, 4 Nov 2021 01:59:49 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by aserp3030.oracle.com with ESMTP id 3c3pfykh2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Nov 2021 01:59:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrmQF+eDUVetg+gBWLaXLe6jfGZ4nyC9sYNNfrTxszdx8h3XAc1QPgLsJ54GaP+2rJelIzvOkX6/N1y0CWIiXCeimZXyupmO9klMFBUhj8IIErVuEbpf1ezqmKFujinA04okF0NtlGKVB+j9zZNyWbdRkIgzmAGxGWi+xHzZXGPU8TyEvGYpj4yYpBrxqfUpghRIvNFET8Y/chEuxBxLtZ27nc90EB41H4MmhopQxElwesz8UYe2nOkBB7Zm2MZnR7nVgy5lFxiHjoiTxDid2C2qrqwUgvMCbakCzJTdPBAcy0EtfR5vZlNwOUvuzqldg4d++29z1zuk7/ikQnOrkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1mmZHMP2bT2e39+3OCacHXQsu29CbP0X6Lvkqh9HgjU=;
 b=XeZ66LUeTeza5Ra5OjQNJGMjxbeY5OHxmGhu0/1LHsjRGGiiIGsS5zDP4F4uWyA8ouJa59Rm9VbPbCDy8VAJQJlFS+SbyvaRJXhnVjuwfiVY2wTC+/DBE2MSf7/1J2GXrFo77M6lUPF+D5qQ7MTqshv21/kYcTB6G28bVY/XloSJ8Hadv1wSuTi4oYP/bf4EumDwr0Loqt1opEn8O9SYHitPDRudn6ZxLSt/uZS9R4V1sp2Xpmh/Z/ZC2YMnLURXG9IJ+HIM3BVVkJrg+sJyYiCw3L5+H/i/FmUCNPFn4YgyK2b+wU/zNE8FqGje5dPhpgg1/Tykq5oeQmGswR3B3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1mmZHMP2bT2e39+3OCacHXQsu29CbP0X6Lvkqh9HgjU=;
 b=S53Dz9iQI0c1ci6/BS0UYQD3UgLWeekmL1CszqP2LfoeHS5MPP1kEaNfkNdt3siaH/ObN1y5y29XjVkxMNwoL+rL3B4oZcIiC+rH8ukcS+oFu/BtvZJP1M8B8YzwqlIkO4p8qEyZyfDi3BztldTjXUPbesyrM7Ql3xmBSyIIdzA=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4438.namprd10.prod.outlook.com (2603:10b6:510:36::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 4 Nov
 2021 01:59:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 01:59:47 +0000
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     gregkh@linuxfoundation.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH v2] scsi: scsi_debug: fix type in min_t to avoid stack OOB
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r3wr8ck.fsf@ca-mkp.ca.oracle.com>
References: <1635861997-987-1-git-send-email-george.kennedy@oracle.com>
Date:   Wed, 03 Nov 2021 21:59:43 -0400
In-Reply-To: <1635861997-987-1-git-send-email-george.kennedy@oracle.com>
        (George Kennedy's message of "Tue, 2 Nov 2021 09:06:37 -0500")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0096.namprd05.prod.outlook.com
 (2603:10b6:803:22::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.26) by SN4PR0501CA0096.namprd05.prod.outlook.com (2603:10b6:803:22::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Thu, 4 Nov 2021 01:59:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2be3a8d9-b101-4dfc-4b3e-08d99f36c73f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4438:
X-Microsoft-Antispam-PRVS: <PH0PR10MB44384F4AA4D3486F4E65AEFE8E8D9@PH0PR10MB4438.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4FNVa1E2GGUiyywcHwT3ckOyuThFPTWu19ABb8aLnn+2ZFHyKT0UcGJ5qcefm1zEtHrPvMwfMqmKjvIGmJXlHYzinGXNFLVCewL6YZTtYvntYd/SsOWP+iL/ShVjsp6VLZ1bciqVuhmUkZweiTLxemFBYLfaeryfyhlANWG+D7f7OR3WgE8mNFWFb3SS22UAD9XcdOTpM5DnOFCcIhOL+PyKZZkZ4OgJkRIJUYssQefpq4YsSMi93y4zFTULK8BlyD4SVjiT7Aap6v/IOu9bZYip64P+Qmsi4H15bpnRGl31JBAU3Gcdg3gdMc0Lw8ijMFB/Ys5neUDbAIKM4haIlX+H1i4RgKNvfTX99QvlSmqOIIBOyOvgZMaHjQL5WF+qX6MyNWsKWp2/J8dNBrfWMvrzafkZoSHBBD137Wk3VprfXf87iY2aZsG+ClOIYv6sad6h8kw2+wN4Wn3b1P5Yu/BPJSh5V9DYiTDaKGFmvCKEvAIAEURLXmsomXU0A2OZrNWNpbAgj5UuRAs4nY2lI/OqPvDp4upgWtsXoD+VpnloDKnFxTtasqn7uE0EVCUpXpZLfIVbgjfzH91P3lqfmYQxHTEIDD5UM1HxQWW9FbP8t0otW6oVo99cu3mPYhZcaKGVycO5XHzulMDomyj/UOSMQlgsYvqsoJMf940J3/M5JJAUmU7QKzrCP6MCPOOBz+cjBsQQBy4w4AcKdiYiuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6636002)(6666004)(8936002)(316002)(8676002)(4744005)(4326008)(5660300002)(186003)(55016002)(66946007)(38350700002)(38100700002)(2906002)(66556008)(66476007)(956004)(7696005)(52116002)(508600001)(86362001)(107886003)(26005)(36916002)(6862004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xucFCwgWxstGFn95xpX3u+RaJw98VPAg6gXRzcX8oG2yOnt2uXE9ywhZJBBm?=
 =?us-ascii?Q?yZYWDA9VoA04yzCHGw8nmkGygFA+q6LNwzRQpnyLugo6XueZoF7pVCAPrv90?=
 =?us-ascii?Q?Lyy6BX4UXmvLkFRveVRU99dK2VHUCL5D/IS2Io81ajJMqV3lXWtvuCMDPlAw?=
 =?us-ascii?Q?ZeMPreXJGEnfzMFsq1upO1IP9zGlp1c8ojPX612ZLvUhFmjOZZqGVbKNN1nI?=
 =?us-ascii?Q?2T0MBwJnN8J2PTWQN0upVNpWtpPt8U0Xaii6EJz+4en0cudK7wjDiR6iOpPy?=
 =?us-ascii?Q?Q9Zhjy5LyRwpMemIEsLQzotD6jEhs7x8NaBevSVhLsoFWfhTYwa2zjqzktqt?=
 =?us-ascii?Q?a2bABK4aemWjEwSWSdjz2hsH4gvERUbDyAG3zouT6bTAG4sP4gxPZPzXa+NH?=
 =?us-ascii?Q?eaZp3NWAfXmdeOe19srEiHTwi4vSPs2N4I7hrpIr76PZlg5QdJyA9f6el/VG?=
 =?us-ascii?Q?8OdlzIUKmKYrl/szJ3CFpP5a8dRUoLFvaCbiqA9QWhdcMmmxbi1pIv4urfXb?=
 =?us-ascii?Q?aTiklxlSvloM1cyiv03POCZ2lenqO8N3wJM2u3Bwvj78GBaKfg4Ub1JDofKb?=
 =?us-ascii?Q?Ts0NtalKuN81vLu/SUwcO6yBS0QBTbILg7Ur37FzgzFBgb0K932r1zl3QR9o?=
 =?us-ascii?Q?1PYvMzhWQQ6X0IBIQskyHy5xKbs6fqj8raGP/pkO56t8bIivFefLEeep7grW?=
 =?us-ascii?Q?W4fQM1Xzw3Ye/UNh5YeHCShHJi4LgYfLJ4ODKu0P2UZteo0JopSIbtM01ppB?=
 =?us-ascii?Q?vsq5ImOy4TXH3F7v0nz8oQMLhz5HlVq8PjVr0Ng0imLDTjtqVn40FGrV0rQ4?=
 =?us-ascii?Q?/olQNubrgWS4pMqkeDBtqM2Wrt48J2ruFmK/Mu4blFINkCx9criixZGXkvVO?=
 =?us-ascii?Q?Hb2OhkZI7Aeka05JiYWisobZlKJr/Pvaio04xrCuJYHCZfNzGpGtlnWIQBeW?=
 =?us-ascii?Q?hFrlByDciV45nYybzGp0+n2Ig+5Ym0b4h2pVcvyiu6dG1iqtaHv9ze5xn/eb?=
 =?us-ascii?Q?Risvxgswbz97tkot33gKc4uNvHzPzi9SMSGPMbL8hdy1ya1d92Qs6+zrBpIi?=
 =?us-ascii?Q?kftadNxXSELHdi6yVdPhwK+snZ8kmNkSBSl4U8oA/4NK8SR13vqlxLB0xJEq?=
 =?us-ascii?Q?KRzhobsPkX+z231niBt/syVX/hcXhnw4hnKrUgz/YPl6xp4aZP0T+bSW/dKT?=
 =?us-ascii?Q?ML6GZOSafnYzPS33IIqeUwEb3wqEPi073QPOX8WTir7c5k2Ls7g5e9nnEcPb?=
 =?us-ascii?Q?iUSR0AT/gQ0tKlMwAg07t7BfBkFh6So3qbCJ8f66r2iE9tX6toi/sSYhhvZw?=
 =?us-ascii?Q?e+Lj6uKclnkDuGmFS3s57OTUCRtAAIruR663Y3zs0vqNy1fnNk8XCMdCv0iD?=
 =?us-ascii?Q?Pabzujdg0pPcnP9AASpxUiqisQ53u3FKxa0XI38g2krZGwimBKSyEOXyDGl4?=
 =?us-ascii?Q?CdjKpE4v1qPkx6myShc/DMNlxeMj/VtD1RqGOCI2/Ji3MZmwhyHSeaSHAHk5?=
 =?us-ascii?Q?m9MG7OgqKKJ+EuFJZcda+/AkML8O3ko4Ylfk/GKJRdy39fvCpRpVW1xBLRjF?=
 =?us-ascii?Q?05yHL7z/N7n8Uz+Mde+T0squUUVjINsdTIRws3gPpKykjP8Qui5kOy1oqf7U?=
 =?us-ascii?Q?4y4uzOclqVl1DQpXTKW7iJaLkiYCUsDoaK/DazfCUZDzEOgiOBSrU9U8pRHH?=
 =?us-ascii?Q?KQghbQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2be3a8d9-b101-4dfc-4b3e-08d99f36c73f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 01:59:47.1352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hBRAkJi+cSwd13qnsTQR8WpYkjzHfXgwidIdTVbOwW1FIzMhPGVFgHL2hC/CGk4IOQV1UTGEoQ6znOowuKZhhAsH5yB+tf8K3CJjF0jkefM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4438
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10157 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111040007
X-Proofpoint-ORIG-GUID: 0sPfZtUCT5WLdNCE_S3HZW_x1IqzfhO3
X-Proofpoint-GUID: 0sPfZtUCT5WLdNCE_S3HZW_x1IqzfhO3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


George,

> Change min_t() to use type "unsigned int" instead of type "int" to
> avoid stack out of bounds. With min_t() type "int" the values get sign
> extended and the larger value gets used causing stack out of bounds.

This needs to be reconciled with the following commits:

f347c26836c2 scsi: scsi_debug: Fix out-of-bound read in resp_report_tgtpgs()
4e3ace0051e7 scsi: scsi_debug: Fix out-of-bound read in resp_readcap16()

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
