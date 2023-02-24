Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5AB8C7EE23
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 17:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBXRsH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 12:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjBXRr4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 12:47:56 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71D61FCC;
        Fri, 24 Feb 2023 09:47:49 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OHhqCE003290;
        Fri, 24 Feb 2023 17:45:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=P9Lzi/ZtfXnWhqP/2lFsblJTFnvLSerrPfLluzUW4fw=;
 b=CA/pWrO/E4Cxf77+h2dzkxVQggf5AS7+jOiB42vIxD58vDQETKX8gk+wGtwkb8rsshoS
 aX3pmHb6JIu0lRnTKT2W5Qn43kwYfD1hduIX+XyFj+1HJ18FVk3C7lKdzwov0SZ5F9VP
 2NUk2TKcZYnL6/2hXTwLshtYL/8KLZWiR1wz7hagy29ahE2pQUnWqqyN+CCCpI0BGL6y
 YRjJLWg8JKMccNDuRazFQYvaFsEQiBRsLcRQZl8jhPVFOPMvq/VpvZBsHkXPxca5czTA
 WQMnaOfSjqZBtOoFb6XZ1C0SJ0HeJ3I1ngcXvl+KPUJDJRAJKj03gMf28/QoYJvky8Co /Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntpqcntjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31OGY1aV000677;
        Fri, 24 Feb 2023 17:45:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nxsb4kud4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FSarWEGu3Kb6R5k55Ss8G2BWvQOW/9PVvVJAS2yaDH0PjRhyHYsW2hcaWXrhcKsWzzy1TmVxKaN2RatAaJwNo2sL6v+G9II+BiW/9YXN3VU9qNmRzL1QH0L5qjnAkl1iOTecTZfpgSzSGyz9euhM+jz+FnxKV6KDhGQ9pv+fpwZlS7bajn3Zhamjw31HTVLKsqgtUDM9Ve5d9OMevSfy0MT6pzqb3BVdxqV0HQIsiZ2QfY40au/z+ikPeYnU0qdhNuvyAmS0NpOxZrPiy0tPzUS/q/Q/Aa2OZziikqQdxj+0//EM0WPzUG9X5p7kWiAr1c/ZVG5f/pJwtY1u32R0Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9Lzi/ZtfXnWhqP/2lFsblJTFnvLSerrPfLluzUW4fw=;
 b=kSTrVjG7ltT/9nWDCtltZgu7gmGDRuKIDpTaDladsgbLd9GdP7HR+x1WErVwzBim4iJmlu3/0GVdHWCdTjCNJi0Tlh/ffKaN5bnj5Co4UXMB7vNvBWftzdRJKjBG1a8CuqZhtElwwSJgfdmqvKSkB+/R9LPQCZsJAbQv7GGAqNSZtm5BXrx6fjlXVORkUN86ZCEvGD3yOX1pRyyPHljA8lZuN1D2ZngXhHXRTmm4z9XCbChIDs+qtdGOrTq2J0NxKWhkxvwkhXv6ybQn0kP/l+goj28Qg3EnO1gH49bi1gvY+49sV6thPxKjxN0oUz3mD5vrZl6rIU8HD25aR9RLaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9Lzi/ZtfXnWhqP/2lFsblJTFnvLSerrPfLluzUW4fw=;
 b=gb7YQ8If68NJDPDxfZ47teq903aVMkFFNofys6at3m7EfUoMDcxFwgIkSEjjI9L+FDj9yk5qh8+NcoC86l8kiYUAge5xyzJSe8D3h7jaB6GhZ420EPKFMXO6fehcdSpgLCtlF+yoaQbeg2isro5annQfMBSz3O2uZcCRiQlPopw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:28 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 16/18] scsi: target: Pass struct target_opcode_descriptor to enabled
Date:   Fri, 24 Feb 2023 11:45:00 -0600
Message-Id: <20230224174502.321490-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:8:2f::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fa3cbf2-958b-463c-fcb8-08db168eeacd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pk/NDOHRjYZqTF4sSDKTer5XX1ohrfqLySLT9kIqGChyRl4gAYaew0BEyWW9ttfk6xOgkUyHWO+mXGPFoIimxXZMkQ0q/uQ+SfC0werZY4B5Zyfv+mpK5Noi/7RjwwVTR9Z2j06Jl69ayF3Ho9rle+jzvMdvDnRVRBVHAlYSP2PDTwERqcBJHIyNkeL0WrNjzBFdWIOOs6QgH4FihkarAIDb4lm16biOFhe4vVj5pnSBS8ukrLQQIcD5Sq8sTH4C1KsHZMKtvNrw/v4OxIm3a3TpeU4VMfhUFiJDMGePQWsoCHHCxrwpuYb1X9JpmSUZC/tlPLV34X++rCZExR8LVlt4v1JW9CsgFuGQ7jfRJMZToFMgeCQz6z+4RiA/eq+oFoZRoUOuKXJtZdt9hlZwMGGXcukG6aD1vpQ7c0e31kW8SDG4kyelOwsrzD/TITUDJBgIiqCRvK/rNOjr1Jo/AoQfpNLQo+Yv/UZQ2YWpMdlIMFWfKOH9IjnEg56N5xhO6VJ7MFio13lhcVb+lzreiv+nKSpHcUIfWQj0izqgAGd83ToEjwaDUYx4+6Eo1yuyDQhmB93s9PChIoZtMoTmzYHHHNTNZSboqw04RSYK3SImv3POP5pTUQ+RwLYllcGGwGxY55tLCURU953h2pUWo0FlnC970rhrgaYwsdP+DMIWxjDlxZtbjGf7mm02nPsw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(107886003)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mFVs4YQ/U29EYkcHCMf2gHwraxMhL+50oA8zTlB6v/soQC/4MbWIbSq8g26S?=
 =?us-ascii?Q?fSld6yxoGXBP4hvmUT+cl3nmhgQZ33iSRID0SOoURs1z1Q0NsuQdOl16qoNU?=
 =?us-ascii?Q?KC71esud5S5H2FTxnCfakW0wX3g/T+B1G8JMEov0JvEApoOv71h1UoSJElq7?=
 =?us-ascii?Q?gG0Ax8i5sZ7FwTQ2Tq4dmRzgaDkfTT1JuNKwcoAKd2uQQlq6vICVAlhmW2Qu?=
 =?us-ascii?Q?6D2F8ACBljyvuVyVYb+B/fuiLuxu37qTzszYNBKI9HxXEsRiIqxhhcBH6WgV?=
 =?us-ascii?Q?oD81A/hCTZ6xPSOCLxGgzZw70+1lFBKS163d+Ec2VpBg6wsD+OZTevZTZ8rS?=
 =?us-ascii?Q?PXBFJ/LXOBMfCVp3BOn2NJuCAAppw05D5iBntcaprkS0uKfVZQsN9Dp/G1B6?=
 =?us-ascii?Q?2Py/afSHza30+tIhfi9yvvNb23eQSNMRlaD56SZDq6UflSltaFfk7Pccc5Wq?=
 =?us-ascii?Q?cVfvOxrLJodKOouxTGBhYQxiilKKQdzmL15J9KzsJBVYPAqWbgZQuXuU3+Xj?=
 =?us-ascii?Q?cxdoTuvkdeQFfNRBUHfbVP04xoHLV4piTOlkUhEhkUldq7tin64x54UEBwOm?=
 =?us-ascii?Q?HpZ18qBASF7YZy4MvxTnkzYifa5idYtNILsaY1zccUt8gHVWtmgmcp8fAZUe?=
 =?us-ascii?Q?E01Dt8UfwNyk7J2O2uWcFKT5JN+c5RzxVa+/Um1r55ph100GnypY083XJglf?=
 =?us-ascii?Q?XcqLwpuG6/9gB0XaZZyj1YgJElNXBpz8mMGp8FRPOpYu30SdwuIlk2RMJ8L/?=
 =?us-ascii?Q?qb9v4gjKqClpbDT8v8NfVppoNX4j8Q5qsa5WjgwklANyyIsXch/QOVZCcYuC?=
 =?us-ascii?Q?xR7DZtoXHG165XtoWqE93IaYFqDtJsHpER1TGLFT6FoB+fra8DG7BF7w+gwM?=
 =?us-ascii?Q?plyqodkFNelS8QZEcXwjWc6DgVChIcfbTFn7FjZCnujuOgC2hkLHAYrfm32Q?=
 =?us-ascii?Q?iSmo4qWerNCNRUQOn3nbci93A0zo37r/3wF1ZmfKti37oWFpX5fGcxvD0tTG?=
 =?us-ascii?Q?OrxiCZxtgkJG014s0tu3RqY55ZKkXGkqfZVB7GNq5lfBMqdmFct1+VHP+o8I?=
 =?us-ascii?Q?e97wibi5lEwpuawMrctU2vv6tD3RfNTH0KUGbJvIcxsCK/EcxIG62re5Su57?=
 =?us-ascii?Q?4LQ+HuZasqf6/y+AEd7esO4euJx5CqztemZvOU9OTisjCabxRQwGP6Ck/qPt?=
 =?us-ascii?Q?SGNIOVd5MvEkQNqKCp36V+cg2tQ8IrR8lRjzXivXGZTUYNwyX3/JVfRQW+nH?=
 =?us-ascii?Q?QHzrWHKj73eYKVjMVdyeTEYJSh8ePv9VffkewiEQvIytCu1m8Plkf/bCOOOt?=
 =?us-ascii?Q?E1o9KDpYOG1OZftqhIfKmJdGLOxZLLCuE91W2x/RUf8hUkOtOijxvU1N2FZ7?=
 =?us-ascii?Q?QCRdi6oecVaVbgqbGoyLsV2inPp4kxfdE9sfqcLEkEue++FrBoAt+ngXAXML?=
 =?us-ascii?Q?vHYLA6psCuXd0/mk82aoRX7W0JNCMCgB3lwBShPXQUlksTRKBOU54/3Jokjp?=
 =?us-ascii?Q?p5QZEnJ6FTlWzbI8V1Ou/9ZGtBq6WNDH2K+DQ1fTAysEn9WT4sfJT5mFAToM?=
 =?us-ascii?Q?Y5njldBTd/F+Cd9Ym6MHGHq2CFG34O3j2Ph6k1WE2mN5wETa+2ZWm0NxxPEp?=
 =?us-ascii?Q?pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?43918OYwmOfK93Vf+MnmOf+Y6Vt23KAqD4yIONMEj53sgamZML2/2zxg75sB?=
 =?us-ascii?Q?KR40XERnF5q+bzxaBHv3FJJDfLXSnfU/JhqPcPPLDd6yy2ROK/fGVThNzGVM?=
 =?us-ascii?Q?pkhpFODveJVkWoxpe5FHVuxrRxqEdLtzI0PQIbIYPFKhMxW5wkPuMljukn/n?=
 =?us-ascii?Q?7NntQnixwB2Uf2sSaJOElihTf0XP6jugzZhZ53Yv9GboBGG80vYdI9nbDW45?=
 =?us-ascii?Q?Ld75KYGCmt1uxReQGVWiXf5cq3IMQkARDfpzKc/9K8XdSF5QAL96bF1mBg1v?=
 =?us-ascii?Q?paRkQ8llVJnLjLMncZrapl+VGWF71xo5TWYKQTBMPh9SQ2Z+IWVQaRCnAM7d?=
 =?us-ascii?Q?m9ih7bhkJWxezUVsFCCpX0HKqYO2voR2afc+i9kfApu+OOsUmqlmmNOWcnku?=
 =?us-ascii?Q?W3x3mCj37s3lbDv67OyJ2bgjaWlILoIsJ9wgX0yPYv3x8GVvaMX8N+Y1y1K+?=
 =?us-ascii?Q?IlGRgxemj3v5JwrZZ458L403MXLDvlyK1CPGyXu5/j4mFRZxgObzUGhJFbs0?=
 =?us-ascii?Q?GRrNclksT0+HsXPCJfgs0XRx0XCxd3b9blrWiScbrbQ7G9L9RDTK3rTeNqWL?=
 =?us-ascii?Q?YSYi9Rsp2xJd2qUGNyMQ3px1C2z0lwOGvXmVM+i5P3aYXyGhisBN33SP7eta?=
 =?us-ascii?Q?dRXsN7v8MbOaY/zafU5/5vaim5wC5ZEca9hNzCAFBrRWrBApb7Gy1B9DgGdE?=
 =?us-ascii?Q?egqcu2IuPQ/5CjOggg8EVBuyV7JPTu+Z9fye8PS/h6u5Q0tSacw90iixMn5l?=
 =?us-ascii?Q?YKSuVEcIR+QMF3SO+jqR4Ywgowl/4nkShv3jEdkyS9N7NYVJcij6Yuvr8UuB?=
 =?us-ascii?Q?Be4Bq04bMSV/fQ70ez9g+mvzlqvnQYUcZXSx6/nZ80CtagJwOSaDeudZ3PVD?=
 =?us-ascii?Q?iTrIE/o7y7iyREOUkt0ARpM/mMUZOkhVFN6C9FpIVe8pMfNqtohysj988Ylo?=
 =?us-ascii?Q?+yU5GJqoczIE8pocIGBhUTTK5AhGMv1/ILlxHjLbW3TB6wJLcqjrjtpXwbPZ?=
 =?us-ascii?Q?nh+4XKsSzcnr5DnA8//qOZ6VQg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fa3cbf2-958b-463c-fcb8-08db168eeacd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:28.4998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PDvWvvlP7YVw+utwWb3LYwjJUVG2cDcJIt23EOUtzA38b3G96HCpxiV1PDBcSvf2GU4vDqm95MLNZgf/mf9+ENvE0kxDJjsswZr5hv4X/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-GUID: 6tXktHyy9pcXOS_GsOHb333fvSjtwej-
X-Proofpoint-ORIG-GUID: 6tXktHyy9pcXOS_GsOHb333fvSjtwej-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The iblock pr_ops support does not support commands that require port or
I_T Nexus info. This adds a struct target_opcode_descriptor as an argument
to the enabled callout so we can still have the common tcm_is_pr_enabled
and tcm_is_scsi2_reservations_enabled functions and also determine if the
command is supported based on the command and service action and device
settings.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_spc.c  | 40 +++++++++++++++++++------------
 include/target/target_core_base.h |  3 ++-
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 00d34616df5d..caf8d1325007 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1429,7 +1429,8 @@ static struct target_opcode_descriptor tcm_opcode_write_verify16 = {
 	.update_usage_bits = set_dpofua_usage_bits,
 };
 
-static bool tcm_is_ws_enabled(struct se_cmd *cmd)
+static bool tcm_is_ws_enabled(struct target_opcode_descriptor *descr,
+			      struct se_cmd *cmd)
 {
 	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
@@ -1456,7 +1457,8 @@ static struct target_opcode_descriptor tcm_opcode_write_same32 = {
 	.update_usage_bits = set_dpofua_usage_bits32,
 };
 
-static bool tcm_is_caw_enabled(struct se_cmd *cmd)
+static bool tcm_is_caw_enabled(struct target_opcode_descriptor *descr,
+			       struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1496,7 +1498,8 @@ static struct target_opcode_descriptor tcm_opcode_read_capacity16 = {
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_rep_ref_enabled(struct se_cmd *cmd)
+static bool tcm_is_rep_ref_enabled(struct target_opcode_descriptor *descr,
+				   struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1507,7 +1510,6 @@ static bool tcm_is_rep_ref_enabled(struct se_cmd *cmd)
 	}
 	spin_unlock(&dev->t10_alua.lba_map_lock);
 	return true;
-
 }
 
 static struct target_opcode_descriptor tcm_opcode_read_report_refferals = {
@@ -1542,7 +1544,8 @@ static struct target_opcode_descriptor tcm_opcode_sync_cache16 = {
 		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_unmap_enabled(struct se_cmd *cmd)
+static bool tcm_is_unmap_enabled(struct target_opcode_descriptor *descr,
+				 struct se_cmd *cmd)
 {
 	struct exec_cmd_ops *ops = cmd->protocol_data;
 	struct se_device *dev = cmd->se_dev;
@@ -1664,7 +1667,8 @@ static struct target_opcode_descriptor tcm_opcode_pri_read_resrv = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_pr_enabled(struct se_cmd *cmd)
+static bool tcm_is_pr_enabled(struct target_opcode_descriptor *descr,
+			      struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1793,7 +1797,9 @@ static struct target_opcode_descriptor tcm_opcode_pro_register_move = {
 	.enabled = tcm_is_pr_enabled,
 };
 
-static bool tcm_is_scsi2_reservations_enabled(struct se_cmd *cmd)
+static bool
+tcm_is_scsi2_reservations_enabled(struct target_opcode_descriptor *descr,
+				  struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1854,7 +1860,8 @@ static struct target_opcode_descriptor tcm_opcode_inquiry = {
 		       0xff, SCSI_CONTROL_MASK},
 };
 
-static bool tcm_is_3pc_enabled(struct se_cmd *cmd)
+static bool tcm_is_3pc_enabled(struct target_opcode_descriptor *descr,
+			       struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1915,8 +1922,8 @@ static struct target_opcode_descriptor tcm_opcode_report_target_pgs = {
 		       0xff, 0xff, 0x00, SCSI_CONTROL_MASK},
 };
 
-
-static bool spc_rsoc_enabled(struct se_cmd *cmd)
+static bool spc_rsoc_enabled(struct target_opcode_descriptor *descr,
+			     struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -1936,7 +1943,8 @@ static struct target_opcode_descriptor tcm_opcode_report_supp_opcodes = {
 	.enabled = spc_rsoc_enabled,
 };
 
-static bool tcm_is_set_tpg_enabled(struct se_cmd *cmd)
+static bool tcm_is_set_tpg_enabled(struct target_opcode_descriptor *descr,
+				   struct se_cmd *cmd)
 {
 	struct t10_alua_tg_pt_gp *l_tg_pt_gp;
 	struct se_lun *l_lun = cmd->se_lun;
@@ -2123,7 +2131,7 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			if (descr->serv_action_valid)
 				return TCM_INVALID_CDB_FIELD;
 
-			if (!descr->enabled || descr->enabled(cmd))
+			if (!descr->enabled || descr->enabled(descr, cmd))
 				*opcode = descr;
 			break;
 		case 0x2:
@@ -2137,7 +2145,8 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			 */
 			if (descr->serv_action_valid &&
 			    descr->service_action == requested_sa) {
-				if (!descr->enabled || descr->enabled(cmd))
+				if (!descr->enabled || descr->enabled(descr,
+								      cmd))
 					*opcode = descr;
 			} else if (!descr->serv_action_valid)
 				return TCM_INVALID_CDB_FIELD;
@@ -2150,7 +2159,8 @@ spc_rsoc_get_descr(struct se_cmd *cmd, struct target_opcode_descriptor **opcode)
 			 * be returned in the one_command parameter data format.
 			 */
 			if (descr->service_action == requested_sa)
-				if (!descr->enabled || descr->enabled(cmd))
+				if (!descr->enabled || descr->enabled(descr,
+								      cmd))
 					*opcode = descr;
 			break;
 		}
@@ -2207,7 +2217,7 @@ spc_emulate_report_supp_op_codes(struct se_cmd *cmd)
 
 		for (i = 0; i < ARRAY_SIZE(tcm_supported_opcodes); i++) {
 			descr = tcm_supported_opcodes[i];
-			if (descr->enabled && !descr->enabled(cmd))
+			if (descr->enabled && !descr->enabled(descr, cmd))
 				continue;
 
 			response_length += spc_rsoc_encode_command_descriptor(
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 12c9ba16217e..04646b3dbf75 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -878,7 +878,8 @@ struct target_opcode_descriptor {
 	u8			specific_timeout;
 	u16			nominal_timeout;
 	u16			recommended_timeout;
-	bool			(*enabled)(struct se_cmd *cmd);
+	bool			(*enabled)(struct target_opcode_descriptor *descr,
+					   struct se_cmd *cmd);
 	void			(*update_usage_bits)(u8 *usage_bits,
 						     struct se_device *dev);
 	u8			usage_bits[];
-- 
2.25.1

