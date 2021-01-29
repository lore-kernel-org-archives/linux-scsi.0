Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2AB6C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 18:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F8506024A
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 18:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhA2SDR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 13:03:17 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45414 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhA2SDP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2021 13:03:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THsQ7I131404;
        Fri, 29 Jan 2021 18:02:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=oumMOZ9oaLKQQfBA8Hg6111H3281soqop7BmAMvdHtE=;
 b=jS13NIvDdFnNcFyqNsJjJ4dQrJIMp4Qi1ttlcyN/7WtxTNISj3JYko83dQsSRWZsNKIR
 7NaZlqEIFn/aI3tP2POTNlIjtAw6S/1TLqkhNCQNODp8Y076YXCyLcuuTTuDOFUucw4C
 z6XgzqTI6z3uzHzGsse1EKI0gtXiZmBPpa7/JIA70wnM6h26PVesGZQ9oloehCu1DzgA
 Wr8H4vlFe3lSwe9vfhXBmckNRpEEzBEqj+I/PM2Szw39r2xkQ8ERl+XkAsrpo0husjPm
 NW2/n/9cQmLehv2/JQxVcyf+O/PU4IIfKsJXyilheemTTq62wh8yFkfwNNzZYoEVKWkR 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 368b7ramme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 18:02:18 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TI0h59044445;
        Fri, 29 Jan 2021 18:02:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by aserp3020.oracle.com with ESMTP id 36ceug7axk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 18:02:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4OwsKqhnj5QvNgGAx69ilHPL0UvIzXxVKvvmohG6tbZkQStzJHlqS+xYekxrXWiZ7EmUwhC0AtCFHFE8TCXKnEBQOTZH6OY7wL+hTPkCy2HDG0BE98MhX19h/lejsoiFJEKdswWKYskFjguluX4RmRIXD/EbwGYMtLRruVEOLBrgtJFaNq3+UzCFRj87EKjupft4LhsXyvmHWKqAugNTb7YBdl/IVlo4PPT+3UC83vzOMJoXPPhbs3WW3gy+LxcCzQ3ULup4oHgFw/g8OwIX/0P3/71XmLcNj608px1rUozkawVooDjXeQcOPi5/JZB+evhZj2Ge+oeu/6yZsYbrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oumMOZ9oaLKQQfBA8Hg6111H3281soqop7BmAMvdHtE=;
 b=M05omn3YcWusonWNHrEfeNWEbINCZz+JOS1Din9VOW9ITcKhg4DsSYszq1k8m/jPnu/jagduxgHDqCKJEYVExYZNLIZcDkC15+0HW5g4ogqN9KinMgUD/Za6W4vUfnaxoQQqiqQbUxtabx9fgfSidEOepKD4hpUf3jysVZtE+2hhFIP5RqdLwwNt9QnBha//brO7Stv4NMVvD4o9xiruCNWsTMaNw/LJvRQl5/MQBvWs0Oa526ZUQITzFNjzWKfczHRBuidyeXMjDa7c8//gFeBg6HCTe/hQR3woMBLmb0AmJFv1HcV6Cpuw+9Bd1UEEXDrNeXbaJ1ECjadBgeSzdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oumMOZ9oaLKQQfBA8Hg6111H3281soqop7BmAMvdHtE=;
 b=ZhwNpBbdZnzMDQbjq8b5t3QnyFNB/dQfPvsagHJoAvqSiEaMlYd06dh+oiWccsb0xOSkAFm5GFJIXpp+SgPWORIy/NKJXg/SvtyLrAcyd5bgcbreSker0wvkxTbrxRz6R5wbrPKsTRXiYBIeQeym5QXLfCqOAV54S4DLerhKKtE=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 18:02:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3805.021; Fri, 29 Jan 2021
 18:02:15 +0000
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V7 00/13] blk-mq/scsi: tracking device queue depth via
 sbitmap
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6sr1v87.fsf@ca-mkp.ca.oracle.com>
References: <20210122023317.687987-1-ming.lei@redhat.com>
Date:   Fri, 29 Jan 2021 13:02:12 -0500
In-Reply-To: <20210122023317.687987-1-ming.lei@redhat.com> (Ming Lei's message
        of "Fri, 22 Jan 2021 10:33:04 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:a03:217::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR04CA0006.namprd04.prod.outlook.com (2603:10b6:a03:217::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 18:02:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 387a27d5-7afb-421a-a2ac-08d8c4800280
X-MS-TrafficTypeDiagnostic: PH0PR10MB4615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4615FDC454245EBF2B9B149C8EB99@PH0PR10MB4615.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4cOFuKz0OQXi9BkRoz4C98ItS+srfD8BDOGONP88L9h/uTuGCkOQz2+qoV2bq1MsmsJ1bxCiEB9aQmAn6RUFKSTSHrfRphg6Yg1llaeEt1nupKszoW+PzNSyUV/lBqeaO7O5gCYT2LhWoWmaJhSHHRUlokhdMllRK3U8LhmmS/n4RYTpXlgeluMdbTssLFTKTfYi7waN9rU/9Qqj8z/KFeXCNop2z1RrU83u5bqSrJCX+9VQrockioZm4onRi33z/iXZNDb0MUv0Z0VKyydZnL0dDvgl0Rs73p6U/HRwuDevHGmgQYtMk1nM67HySW8Wq8Fb8CbC7katpuSuTsejVHGBkwTA8IxkWI2LDhDxsy+rbALbx4tfA6VDLG6Yf9a8/9gRg+2JPGWm8s1guKtVnxJus2eV9kKKSjZ/90tgUT/q97M0A3hOItA1tWR3wbnZl8IyaaOX9iSBobikrDE8PyyJRoy5I2B4a9tMFC6GROlmlrHJMTQG+Oi2X4q9tIbwEZgebHSfc8LbEXB+qAGEIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(39860400002)(136003)(346002)(52116002)(26005)(956004)(36916002)(186003)(16526019)(54906003)(86362001)(7696005)(316002)(4744005)(5660300002)(66556008)(66476007)(66946007)(478600001)(8936002)(4326008)(83380400001)(55016002)(2906002)(6916009)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?j+CWoKPiJAEJbndDD4UAyY0Zkhy26Dyb193u9puPwjEE5iIaDIVr8MGyzqDZ?=
 =?us-ascii?Q?VYYx7FHvMaF7FFNQCFPidTvD+YL9d8Fn+c6/2llIFWNiq1XYVMJvPhIjWj/Z?=
 =?us-ascii?Q?D60CzeGtMm+POCzWrBCtjGnqSI0xGFO82pkK67E4vUTRfeNMPtYZz30f+xyz?=
 =?us-ascii?Q?FuMeU9PQdooUgBJORQwm6+5baLhPqtOClmeXn3HRHyUKhbHNbCGGrH4rVI+H?=
 =?us-ascii?Q?He9shvudSxuRXh+d6p+NFjR1ITtN45fyU1GSLttNCkUn3bncr0ok8RbXNOaA?=
 =?us-ascii?Q?TrGoNRNNgfVuDqJdSkiK8Yw8HEnIQBAFmOFkiUsXjLFHR3kHbPGBcyYE9T6Y?=
 =?us-ascii?Q?4G+tnhRRbtc0O9qVp/4uKXmpSzSob/j3X+ft8pwcM/2ADx8it1WumrnIdoiX?=
 =?us-ascii?Q?N0bUI3RpnfDM3f1iPbgWBlXsu2wg+jjobpeQOEPpcy9wcXdBm2tdmPXzauHY?=
 =?us-ascii?Q?yPTu/FqFA6TocVll1ZPP7WokHDlK087zjwEXUZFrRmDA4I3qxH1jqAWizC3B?=
 =?us-ascii?Q?9F5V+6Hfwthdo7bXNYfHk0zKwl3CvkUYTn5xG0JrJ64N5aH9mXJouclcoWri?=
 =?us-ascii?Q?AkQy99ZZYKjRIPa8vImZ0qbRMKjJ+5Z9AZfjMUwsQDeF3Oj6YW4eFj4/6d79?=
 =?us-ascii?Q?yWX8s3dRkAqm7Onug+WChwEGl8gK5IJIXfjpQrpkN1ly1kzY3daVZKsU0RVL?=
 =?us-ascii?Q?zS3j0bdJBKmnkfwKum0N3KSLTra/UBLVpADn6cccZ4AbCr7HO92B/M3f4Ykm?=
 =?us-ascii?Q?LgGdt+bx7nSzoN8r+7LW7FY3A8rhmCky7ylMedjWNDLu6y4vG70gn9YduZP3?=
 =?us-ascii?Q?A2IrN79xU64V9y+kZBrGzZY2Tt8uObRv3t9Tn3WEpMiRC9dwwYXWSDuuUDwG?=
 =?us-ascii?Q?vlIeEZka1dKxP70HWowGifIA5UvXvcj9mZ28LHGOqHbgdZg1Ds92UiYy1Zh/?=
 =?us-ascii?Q?cw/xNVYj8RM6XXtwQfgqRJqljhALbDBxa4Jor7YRnUTykMPw+yJ6t6Gi40+c?=
 =?us-ascii?Q?xnCp/R80oszFdCnSgfg22fXfszG7tFqyHFncvEMpz2a9+4sFjZVOE6gHJtFN?=
 =?us-ascii?Q?BDTqdo0j?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 387a27d5-7afb-421a-a2ac-08d8c4800280
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 18:02:15.1032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 35Jdbp7XQRw+m8hkffbop1g8q/Z5ffT13RafQ51cxhWuadGH5+Jr6KDmX5/LatDPtj9mjOtveMuhtJxNe8enM42+6JZ4UtKz6w6uyqdTXq0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4615
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 spamscore=0 malwarescore=0 phishscore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101290089
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290088
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ming,

> The last four patches changes SCSI for switching to track device queue
> depth via sbitmap.
>
> The patchset have been tested by Broadcom, and obvious performance boost
> can be observed on megaraid_sas.

This series deadlocks SCSI scanning for me on every system I have in my
test setup (mpt2sas, mpt3sas, megaraid_sas, qla2xxx, lpfc).

-- 
Martin K. Petersen	Oracle Linux Engineering
