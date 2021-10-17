Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95062C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 01:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6706A60EE3
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 01:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbhJQBuJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 21:50:09 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31878 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229456AbhJQBuI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 21:50:08 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19GNbos2005466;
        Sun, 17 Oct 2021 01:47:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=H70wNICxETr+GvHRs67Re8eTkf9ljaNUiWVbfgTyaQE=;
 b=HlUjtaSZzTuCdof19g8GiKuK0ktSlYSbUBcZlnTAJgWaDkaWOxE+4zrfacINkzaX93yA
 X1unJXNkiqcdFgoh7KLASbRSghqFlPD/EQDOMlP05ZzqOHAb/eg4+ZS5Tg6Mppym+gzh
 3uUVA0mgt+5CvjhMsQ8q2m8CQgdV+xyJ4jP8A3Gi8I/QoIQpVodkllfC5JnO6I0J1hgb
 65BPIONhVwVtr2tO6bAT/4FP5ni8OLSTljzriyZXh89cDtvAUfygPCxNlv2JFaQGZz0v
 k3UNpbDECF7GcMei82gCGBmYax37mWgdk3W6TmUzYL31DZ8IxG3WQiD90h3iNwjOl6/I ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqm19nv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 01:47:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H1ksb0192007;
        Sun, 17 Oct 2021 01:47:56 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3030.oracle.com with ESMTP id 3bqmsbjr78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 01:47:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mcFLzhFC5i0XV+KY7GXlJK3R21w2PIawhpXy1bKbfwzg54Z6bqBi+cN9g8QI36DuiAS7MO8RcHq60NyXkrou5jt4fh2lcb5+YEkEZUujieeHU1gilPIPjV1aITsx1LryQNgmE1u53xHMQAuO/iL7rtblx2kq5NP/PPEiFtcQvzZV6SPzjj1MraVmPF7/v9AOZtk05EaEljLjfXNBUX4NwoXsHD6yBo0T96EZQbeifZIY9wvEnteFGBRHCI9PxqtxO4lHtZkJ3eXWtsfC4M7u5BcMSxzH4UCCUaEBOkqmsyatF7pZIAIfa5/HO1qhFy2/6g1HCljNVFVb8wTPYSdVaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H70wNICxETr+GvHRs67Re8eTkf9ljaNUiWVbfgTyaQE=;
 b=oaCNcWymzgMBqwh0EtC934W94WUY0ECC3IseEW0Bjx4t7k/LU+kXbFv9RTbKKfDlf3NnMFS8ft4NGtgHqfTioTZoC/HQ2PQep6jQnsh/QGYmXAh/0v5HylY4PJxGLns5OZLlTLjbxoCT+3tdeMMOTclkF/TfbdhGy77YN1sewG4ksXJLeTCZWnRI6tim2vM7F60GFsRgoq7Cyggzls+Wfk1Ya0GHGy09pEISKoq96kdSn01UzUlRxsBHdfkr5kd67VOwVYDpEalnNNAvi4Nns2npFRsJK+6EsX0GWEh5mYxviGx1FExZ1mIX14un8zBbhAN5MuOsL9QLk9EPnLL/Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H70wNICxETr+GvHRs67Re8eTkf9ljaNUiWVbfgTyaQE=;
 b=0CMmZQ6b+FQYqaupRkac2WpqEULLZZl70R49ZwwBauVNVrC+ctfu9LlhL/47ZBgU/xGDfA9WCa3CIGDCvm5DzZOh+B1HnK1ahKo9QgnsPgPL28xj55nFoNlvp7Q/PCneF+0oqKq+sCz874KhyI5H1Akcbb4yv4c9KtrJlvNPzlg=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5746.namprd10.prod.outlook.com (2603:10b6:510:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Sun, 17 Oct
 2021 01:47:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 01:47:54 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 0/3] Rework SCSI runtime power management support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fst0ifr8.fsf@ca-mkp.ca.oracle.com>
References: <20211006215453.3318929-1-bvanassche@acm.org>
Date:   Sat, 16 Oct 2021 21:47:51 -0400
In-Reply-To: <20211006215453.3318929-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 6 Oct 2021 14:54:50 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0169.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by BL1PR13CA0169.namprd13.prod.outlook.com (2603:10b6:208:2bd::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.10 via Frontend Transport; Sun, 17 Oct 2021 01:47:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab851ca2-d250-4f8e-82a7-08d9911022fa
X-MS-TrafficTypeDiagnostic: PH7PR10MB5746:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH7PR10MB57464B5C09E302EB5B92E3C78EBB9@PH7PR10MB5746.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +D09VBXNv6n9jt3FxjSkNH24T1DtN1+7kyEN76I7U05LbDf+pwM782vFBujL9OXjjFJQpC9g+jFq5A8MOeNtEg1WC+bQdXLybQslGd9Op06n7NdSPQVjT2yBpOLJSBwGuEjn6oTisqMcKie4XIWQvN3EgfK4yccfBFhEE0drijSMlnikh8g7BqOaq4SFy4ZYMZlqSS+7ZGsjHRhZ6V/xIDjfkeETZ5cx2Y9nD9ZiCLi4WFU/EG3v05gUvEeP/CXxSTYee0Tyx/00PgtLhY7fTMRrrU4klcr+XMoTaw1SXB7C1FT6pBbn5eWxooCmYdScIysF7N8tvce4B5bAJIDmfUIT6hXaJaPl6yiedChaVcBMK1D4acZp0kuD2tbE15ufuyaABn/VWX7wBzI/nQO/yI0448cVMVQVDZkhFMNkyaTD23smAqXoqb9/nUCiHTYWZJYfP4tvKOQMdai2WyOVPkh56hotmx+D42J7PyYmAgw7s0G6vFWWCsJvg1RR0FP71DGrRWWnLNeprMZ7VGBCy+x5WLmNLWb2NxeeWd7StCNOp4kFvKMH87woJXu9on1SY2vNPYg2NCjGlNvZVSIN/w0Rd0y8FvMjNNYB5j+93/Dpg2b0ZlN4Hjv/94uPBYr1wdLjdygv3UIYT82oNCO5Bj0fSAuQY1/pFItP9ynjdH2TuC3fMfiMuQKzRGuMif54Z5PULqequigVx5gjzw8i8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(4326008)(7696005)(83380400001)(54906003)(38350700002)(38100700002)(52116002)(316002)(508600001)(86362001)(8936002)(36916002)(2906002)(956004)(5660300002)(8676002)(55016002)(66556008)(66946007)(66476007)(186003)(6916009)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Tu766Txs7/U9Wu7NM9j8UPduA0k5gPaSPHmPChMxNeaeWw5LfBavco7tzSBg?=
 =?us-ascii?Q?zUs17YDg6727LN3pQtdublRqD8mXLhWHgWsEAVZXsFVsXa4rTd2yr5okrzbZ?=
 =?us-ascii?Q?9Gbb8HQ3GVeUjAHBL+prpKHqEIb2sIMVgyY9Ic5xKp+od8zVD+gsOJroR1ak?=
 =?us-ascii?Q?DyEJctjbN95ynjUumYGP1IkB05SsGmlir17JsfiA0dCNHc1krmsga8z0bWds?=
 =?us-ascii?Q?nzxm5aeDoHXKZq4V+DE7Q+DfQP85NtVANlKpUMr2mKNsrVOomm6xRaCqDDGd?=
 =?us-ascii?Q?Zzokw1h91xabSbiwyXyy3Rl5qgy70sJy17GPW81b8i01LDjTFg+DzgHtHcNB?=
 =?us-ascii?Q?CR44LC9iWV/J82+REaNcWTXdxH/M1Q4Z8suF+/qdv2YWS2/EMDAnwlPhjSkB?=
 =?us-ascii?Q?FsLLwcQ2pmKEoQjLZybt4w7VmYViCBVO19SL/IAjNquxwHjMhRL4Jaf/ev59?=
 =?us-ascii?Q?8YB6TRNi68cO9OtoqjNHfOU1ZJcDqd47ray0u32lyM0h8oP0GizQVRIEvSX/?=
 =?us-ascii?Q?aLPhaXWl9kiAohaEhR4+RaR/AjsEiaJZjUZqCVo2IVlBBHWdVQLZZjGK0Z1L?=
 =?us-ascii?Q?jz2bsvQAwSmp9yX/riRGRR6V7173FUTTLEwLnbeJA/uyNEThbdLN/UAGoR3x?=
 =?us-ascii?Q?ujFtnaLYbuUmmWW2v41KXw6bpCy0c3ta7R0MjsXlcAYL29t6O1LWrCHggRzI?=
 =?us-ascii?Q?P8IGIthI+L4Tw6VLceisjBvyma6S8JGsHguJnlTcCXF5eSqdXEUVVsrQVZn1?=
 =?us-ascii?Q?YNy0gYDmZ25L8w9JLn7gAXSdJijwRWeVyjJetrjoAlbRO9kgh8+sMMm/tbWj?=
 =?us-ascii?Q?ilbX0XiNcQDAQTK278Px9XGCgbc/ht9gadISovZ3NnnfvGHqAoJQONi/M0W7?=
 =?us-ascii?Q?LUUcGx8e8scRApsgZyEkvjpzU9R03vY54MF3oFHgxHlVY3CGeyQcQPLoFH/q?=
 =?us-ascii?Q?2wurhK8uMG+Zbn0QfHGVNasQFOs1eQUBFKGIqzSYnFmE7MmdU6cdN0jlQyAy?=
 =?us-ascii?Q?kDZEl4tdTZ0cqxyC5sYRBaU/FJbP07ax0MITI19wUBkWLEEuZGm60KSjbtqr?=
 =?us-ascii?Q?QOpiSvw29rS7YNmr53gsHbpnUXr63Nz6ToXNBjcdwPPAS0/0Cw9Jf8Kt8uOb?=
 =?us-ascii?Q?WUl07tXi/auTyGx4UAhwN0FiqPL/Zhj9Ea+LXwFgCLD3JWVYnfp5NrfMJJzl?=
 =?us-ascii?Q?6Fws8OvzAIvR3k/XxkeqYCRq4N1C8piI7h4Uda9cuvl2ucVMKaz4mGZHHGB0?=
 =?us-ascii?Q?yWPymWJwNcZuvC5LtzYb2sunGrC4N6PFFPvNPxzP1f3O4LqTFv/3/0toz6te?=
 =?us-ascii?Q?WDRSbQMfLd9chInlmMv2JuB5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab851ca2-d250-4f8e-82a7-08d9911022fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 01:47:54.3356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vCrVrSwyQ6qdvUC/yUF6EJ+iZ/9uacppf94rwztpxSqrYzB3MfaqbT3szOiCFBsTRs5IvHG9voTpKtnuF4AB1BJ9SrGxvNxhJDKy91rtLSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5746
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=932 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110170010
X-Proofpoint-GUID: hd7s7_zxgr_m44uHtMXS6DjyD00T3Ykj
X-Proofpoint-ORIG-GUID: hd7s7_zxgr_m44uHtMXS6DjyD00T3Ykj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> For the UFS driver it is undesired that the SCSI power management core
> activates runtime suspended devices during system resume. This patch
> series leaves SCSI devices runtime suspended during system resume if
> these were runtime suspended before the system was suspended. Please
> consider this patch series for Linux kernel v5.16.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
