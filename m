Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E02CDC001B0
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Jul 2023 20:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjGWU3v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Jul 2023 16:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjGWU3u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jul 2023 16:29:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88761B8
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jul 2023 13:29:49 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36NK0mEX022165;
        Sun, 23 Jul 2023 20:29:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=lg8p8/edhQM2Ow4fvBTc32f9GZXYnRIXdFgN2FFb50E=;
 b=TBA0ipwBb1MJxkT/GVEK8nX4hYkXtZEXOS0m0e9wonRXLUrCHDENuteoRb+owTafcgzA
 nTtdWexNn+TVDg8qcUBEChO9SmwGaCuO6Y+7lFO17ITrgBEBmmEoMN1PeW3GPKO3v+FU
 hy1bbCNZleVn/DoYWiEBT1b1Ferg2QI3745f1ZewHx1QTP/iFMDMS1IEVSXZ7GSAQOhG
 NdpIs5C33MZXRng545ssa9rJQOY48uGYpPtzgUn1WzSB5AlAqv98fvrNC57OQClDMrtb
 ZoGETsG4swZe531kUwRVygyXGwraQjz8nun/0db194UQLP7nywR/f0amrTnx71970mub 0A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s07nuhf6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jul 2023 20:29:33 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36NFv1Dq028602;
        Sun, 23 Jul 2023 20:29:32 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j2xj1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jul 2023 20:29:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fm+g8RErRTduK1c+qSDTYUArBvf2Cqr9whSbc0TN8jnZGayGc4YfIe45+8l7W41Pk/BBiwxYX8ywWAm7en713DUQtO30OLeWdL3uWVVI/gWp//5mfU3OvsFoJaZIDPzc8U3+jBw/D8qlGyNhznAP6bXHid1fZWnE60NO45RKPkOMkvv3P9otaI9FGTtd9IsoC4rLY5cgPOhYCKF6QmrrbHMLt+xnFWMHZAic/ZzmOVv5QIRWHsjm59h8DnxN5EwEEJSLAythhJLO85OCeyYFVU0ByX17PvF1Rey1t0Mnlhs5Ttsda7mHqn1L0RL8IpGC2wovf/OczxUqQlWLPh4cAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lg8p8/edhQM2Ow4fvBTc32f9GZXYnRIXdFgN2FFb50E=;
 b=NSiCQIfwAjt5w16yj2yZMBg4Yjn0kC+vZ3vijN/O0Vx34hKsVZR7b+k3o5K8EJH/JZUCSsHK/ZV05oJO42RaxyQwW8Ie02/QQWJWnBe2nUBiijL42QyktBH/aaQh+irsbF+UmbZOQmni1Kue9dRIKSzYoa4qZPCkBDnyN/jzVcd8YkR+a9X9tFYWiNpT+CMePyal2T3meeTwJ/w80COhgc9J1oT//AZaXoxvci8YJk7zKQmjVi65CTPQ3ITrlYeBNDDaqsllrzJnFy02bfM6aM/W1zkX93O9z1nJNzDhsNvCcKIoj8lwE5+xVJToC5d4faffZmzxmXOZDOfRR8GMfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lg8p8/edhQM2Ow4fvBTc32f9GZXYnRIXdFgN2FFb50E=;
 b=KNZrai7JBHm1vRA5k+fcMRdosD6m4AM3Gp81Jdx3huSWmMoWTcUqi/Urfu2FtNqoici7CvrxRmtLOoenXICpRMO4E+14zWWcZRb57k5k+oc+UqW+eZIATCDwDBIXjsOw0A8LqdqN5k0aMZY7D14te2XnIP6IG5RUWJTfvVKfJoU=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by BN0PR10MB5319.namprd10.prod.outlook.com (2603:10b6:408:129::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.31; Sun, 23 Jul
 2023 20:29:29 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::f82a:5d0:624d:9536]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::f82a:5d0:624d:9536%7]) with mapi id 15.20.6609.030; Sun, 23 Jul 2023
 20:29:29 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 00/10] qla2xxx driver bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pm4i4bj8.fsf@ca-mkp.ca.oracle.com>
References: <20230714070104.40052-1-njavali@marvell.com>
Date:   Sun, 23 Jul 2023 16:29:23 -0400
In-Reply-To: <20230714070104.40052-1-njavali@marvell.com> (Nilesh Javali's
        message of "Fri, 14 Jul 2023 12:30:54 +0530")
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0164.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::13) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|BN0PR10MB5319:EE_
X-MS-Office365-Filtering-Correlation-Id: fb5887c4-d560-491b-cdc4-08db8bbb83c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qNWfvZJawno4EQjxh1MLVmQBSTI0XXHVvfA8vC76LvLPgAmwyp20gSYzZFSknaQOdTwhXLP6cAth8cASs+OucxoMojl1pNE+pZd/ANpeZiUU4XnkawNmAIHE8dNaxeTtmJOxPl2+cTKPttou9P/EpJAmLKZFihxV3yc/UUuYkveffZgGlq3/JZY1g3XRVfdeD2+g6xvWr8ZnutUpqJ+bFMCmiu9uI12zEP8MfI4rtJ8WudpjAsxfX+lzC6+su23FhWEK1R6EK8sLJ0B2ieBHoXh2oLG5DXRihvrvJrOk7MXwoMfcSFqBCif0aq6+ah3io8iqL3yfwTiV8/95S/1Dw0xmQHArlq7vZNNOB/nYe7t1Ejsric7bpjLNSPCtwkG36V89v3PmR9aUtG5w/qHi1w7QSpeeUQZH5vlzkKzneqVoZZgJ7IHHzKwSB04JK6LqwtARXGhAIqZCqqKiCl1sDlq7HkGcbVcA8F3Y0qoo9+9+UYm+3hq5KILGXmWSXHW4sT63GnxDIQMe8m7WXqDBPKDvw37XoVxxMInnfVcnsCncc/7zbjFMO/Z2RrW9cguZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(346002)(376002)(136003)(451199021)(2906002)(66946007)(66476007)(66556008)(6916009)(558084003)(6666004)(478600001)(6486002)(36916002)(6512007)(54906003)(86362001)(186003)(26005)(6506007)(38100700002)(4326008)(41300700001)(8936002)(8676002)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?66xycORgzFFG2NSXwEu62MItX88h78zmWUwi/e/UqEWOw+wwLupkrvdfSszN?=
 =?us-ascii?Q?UBdIhRSF2hCclzPICu2EEuy+EFPIPENa0F4RwU8BQ9I1JbrGlSzMeWL/ZogF?=
 =?us-ascii?Q?SfohUw44hHz4GbPAa1QS4AM9qvXg1miMWthP9wf2dHdM9OYnAAuAfPYhgf13?=
 =?us-ascii?Q?Rvlmeu9BchxT7RnB3Y9ycUyxI105uiqfdMc3MaGGyUPq+y04JPXoS9FKTCjp?=
 =?us-ascii?Q?QbJ5Sj+RAtF5+LHOwpGR42sWU8ZgjPUEw6WuUZhu8ORToJJaBHcVHo9RByMF?=
 =?us-ascii?Q?lbOkTlS+TI0iOuaw6KIZDreFbd4/JAcfrG37F54k5y9MXBjzCtFHIK9BEPLG?=
 =?us-ascii?Q?O4UCeUG7ElGg3TSuAiRWxvfX3wNA1MJh1INS8FAxalaOmN245eHXaYu41ZuG?=
 =?us-ascii?Q?l8qdzsGZLmDg+fgNCWhSI+jMDUpgmP0hLi2eixi05k5flAnIkrYmIegqrVpT?=
 =?us-ascii?Q?hKIfkA08F4cqmKgh4qsMOOptWtL68bHLfRhcOthpZoSavOBobXnf1ClE/k2Q?=
 =?us-ascii?Q?oeWjITsFdLXjseOk2wDPfPoel1pIDPbQm7YTWu38MKHtfoEO/pnFB6BzJ+tn?=
 =?us-ascii?Q?/Nty7+lbefbaKIxdS+XTUDcOOkgSoq8gbvJqXDcCN600MyAtVD5vgrf3wz8c?=
 =?us-ascii?Q?e5DWeNLjozWqvcDQ+W8Tux1uyh62kCK0r9cAPwHGroQ3Y2Fxxh38pHRmLSCH?=
 =?us-ascii?Q?+6bPw/7YofiZjOS6A9Cxgg69ATQC8m0wkWPqTzaFzByL1pWuJz5ZIC4efDSs?=
 =?us-ascii?Q?ldZ373Y8lWKTS2QatQTnBfiIsv7FbaLlvjjdGONyufphJmWw8RCsFeF3O4cK?=
 =?us-ascii?Q?jr0wCsoTXpxWHAnUS9JZVWz9J3GKnhSzK22iwdGHM9IlUDcAJnxymefdQz0F?=
 =?us-ascii?Q?UUiE451BgAy7yzGkbSUKwGT/9Nl6g3V5RVHwpHK8Ekf3k3oYrHGXSg6+o04F?=
 =?us-ascii?Q?IRGZZJTCiAkVkMoWa2Wov2nsEKFnqPn3RNK5ESsIoIc8CoC9VteaR8NJw7bl?=
 =?us-ascii?Q?WOISaM2wHSbHdGk4d0pVabC72YzD2VPoY6D/pUvgUnLbQ65S9B4nwLF9w4e1?=
 =?us-ascii?Q?gQa2of2+sLKp8czMjEoSYj6tLrj1Uc5VOvigACqFoJK0L+dwm3iavPl4hN6o?=
 =?us-ascii?Q?jpyccv3G167w8zv3B2MtQj0hOAsX6kMey3Xl9KilY96VLwRRsj4+3xCzyxhP?=
 =?us-ascii?Q?ojrWbYgBpc72vbSs94vCxd6/f/6MyTcpDdU++jTzZBuccxcZfzDKwtE5s5VJ?=
 =?us-ascii?Q?F5K0M5/lmZpaw1SrCmGtrznotAKBdO2o49iGIGvMR6D532CJQNOQxOQfYWIG?=
 =?us-ascii?Q?7UOoJ0Cjcepmd424gjgQCBiWIzTyNsQvDhFq+/KbGcpUoLt4hQmbiVHqt2up?=
 =?us-ascii?Q?Yxt9F9EQ6v0+JlB3L4AB0PKcx7tEZ4LpxFt5wpIi+znhfZ5l3QGOIa29nsZ0?=
 =?us-ascii?Q?lBgAtIRiB3qlKfvO4zBcEClb1gYmRkuW8McWZlg2usUzqLN7yN86gZB3H2NH?=
 =?us-ascii?Q?5+Ywr8UNVoOLAfSi9eZ73ljK9k5BOFVcEZq0TYV2Qp/9ihE4ySnuDf/WmgXq?=
 =?us-ascii?Q?Krx6GowqE24q2TaUH5d0otkUvljUQl6ye0AT74JuNFnmnxFpSvR4zW3la8sW?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cfwJFARNukzuJEjerMmExLsy8w9QXut1ZUnWmSAWJUf1qtc41MX0JP0v4t85CrzLMp8+clvi/Ie2vWFvY0DP2GT5OtW8ILzK2vlZg2PntRDd5tUh/BBYeGcVVHvesioWnpPTxlbioSrR/8ctvbdkCtQM2aawWtkVH69UC3MTIchYxv2vvZR9ntWRZ5QowzTR2+4dZzPgXLPq0yroHj+0b/tUGjYcnxDS5sNnCyP4euxuu6sh77e+WCPfbQzhiR35tcvExHZh/+vFoJ8aNOU/KEzDpOCmSGNDFJGEl+zErqoTF4uTTvyNgmJjNxZZo4B3DBN2OZ0AYb1uLDm/gLTJjQmRG9szk+3W3VGNGCyVDZdGKlPTWlzKbd5ZPbrknTxbZuh2Jk7fPZRxCEoVDIWj9hZPE/OB0ZtzjpvhrUsaoyNdPqJmHxvP3Qvpja8ZFQg+OIWvQuzlUzTOVgtgurHPEAorllJ8QiOiB51Irde1Y9jFbv1u9fPJmv7OZZzJuIjMThppu9C/EW+/kB3OQxTepJcJBio/xWDuaPTzZfXp4m2iqjAoVwNYcY8c6Sg7hEgX/OIkamqaJ4FAy2yylI6BPEM5+OPUdl2zseZD3mu3O3OOgP628ePgcUSg4EAkHJUTnMT3sgXnu9Vuj2DsIBsNlCMsvOUY//u6b8zBgE29cRxT1AxcJw++q3d8YlYmUYn+tPUSHLpDXmWVkuQWleHB7XdrDC//83MFrLIPFSTQ+0qGfko5BfqPNTv4mv5fecCLJ4S0Z2Rvb2VDQcwGwk+wW3xXyUoosNanBFAuHJcQ0GA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb5887c4-d560-491b-cdc4-08db8bbb83c2
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2023 20:29:29.0344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9EpiY5F4/7Bbxb55i0EC5kZdkv6kH3IWC0eWdpb8pJ9bRRtsEnKt/HCm725iPqFENWAP0FMphr40Xake/njZvJDkjuTZvVG8iwwbb0sMOXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5319
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-23_08,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=719 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307230192
X-Proofpoint-ORIG-GUID: L33kbFlGfMkeTsI_ELslebMfhUVLMmbj
X-Proofpoint-GUID: L33kbFlGfMkeTsI_ELslebMfhUVLMmbj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver bug fixes to
> the scsi tree at your earliest convenience.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
