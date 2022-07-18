Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3D5C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 11:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbiGRLVJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 07:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiGRLVH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 07:21:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C101F626;
        Mon, 18 Jul 2022 04:21:07 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26IB3xAt024701;
        Mon, 18 Jul 2022 11:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=4KHCeWYipVxIyAMRSJ3TK5+Am0L/9MGC9R9c77UMw5g=;
 b=uNzIXLMhTa6hJajpwwKFL3xdoo76mSWyTYQc6nqn7Cmtwz1ifuYfdq0FPyYVSndtSdZJ
 QQYuNc2s42Q8h08loe/NTYPenhLMynp1QsGmESpEIdoogQWke2QjVZXmec55Cwudc1iJ
 KRMVfxSE1pQftxxGrtJUCydWcY67dyN/r1LLEZTHUN+o2uS+X6TH/8vQaVrgThVcYsWK
 O3Xa6Zivggo1XtfMxUdbK9Pd0elUvV1WQBRSjjLrI66+w35NbWa+YSJBiz9uLOuBjaeK
 xnN2LI/mRf0CmonHaDtWyCgXRPRDRz1NIr7rnHic3DWBufEFEiiBO6qte23KwHU+BBOt Mw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbm42ayfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jul 2022 11:21:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26I80Lpi001324;
        Mon, 18 Jul 2022 11:21:03 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k2cv15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jul 2022 11:21:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApC4MHgnVfg/MtPU4PxRkS3iGlbXAgbDOOR7DtkIQGruHtYpycLivpXWjtklersxIyQxK+VafHoiMgvCqrkdTjDa7Vfd8mqoxG1tlZlxbDqSeoiykviHIRtVUu4c7xCa40CISDzrnv02mDrZhdUULqF1F5D19IYAlKsdOyn3vA2CJa2SNnIqsd/HmGk5jdOQVQthNndmYpVtMLDV87jMfpMqhx8saWlNl//zUw3SuIP2zISFqMLLcOfeb9w6gM99V8d77ROOMwClwFPUyx54TxHdW/DopTtEmRX2lF0dJTU4hFt/eG4+QYIvAcon/yi5j0KOMqibzq2cNhGgoMKX4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4KHCeWYipVxIyAMRSJ3TK5+Am0L/9MGC9R9c77UMw5g=;
 b=iDxgFQOKP6cnvOwMCTNXZLnjFZkDeJ/8K1eodWBM246DnPtLIJd+UhOy6bY9Bc/TcMCOV4nwhydtuL+J9r8v5/x3+4B/HfwYwltbB2slILm+rSzAdI9Mf/I+a4x95lp2KsPc64Z1zK3E905VVZHxM2K3N7ONabxOW/xcO9NxanHVdMm+82tXAZGoQeJdeaUEtpdi4K+h0jIqj1zPY/tV0WluX3FjfvqeekJxbRH99cK1L26HKfgvJwJanvXWg7Byk7fgyLHcE/zTwkyKWjSYWByyeR4H9azB8iC6yXGJLCWTz7xJRaKTuxT39S23v3zpsiJtVgjesYAia8o+SUiUdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KHCeWYipVxIyAMRSJ3TK5+Am0L/9MGC9R9c77UMw5g=;
 b=D+wS+eeyjcq+YActzhBCNa8r7Pq2Ma7iNgEqfQoRB8aqAQklyNcz5kF7Z2qXP4qyNXOLGNswXTfjI736yDTaRLIxrhfC6Xe8cqqFaF2VLN/RvX8ffMV04jBxuudPIDsb00KTHg4pjMtFf01OiY+XOtbrpRIfA8MIxZ5N/LKpAuQ=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SJ0PR10MB5455.namprd10.prod.outlook.com
 (2603:10b6:a03:3b9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Mon, 18 Jul
 2022 11:21:02 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 11:21:02 +0000
Date:   Mon, 18 Jul 2022 14:20:50 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: unlock on error path
Message-ID: <YtVCEsxMU8buuMjP@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0037.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::6) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c8f82ea-bd38-47d5-5e47-08da68af98a8
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5455:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FOMcY25FzxiTx6LNRWDibmhWar9MvLRT6cvI12B77zeD/4+j3YJ1otKAYBURooITpMOt8ZbiCl0QY/UWYnM7Z5NulN03aX8U50hmYWeqgZ+pNA/J4/Yscy66O1kNRnuf+blEnyInfe183Xni/4gIUB3k4ES41Gm9xFHYjForIPCmx6k201kK+JNkiw+uN54vyomke4M3HtRQZxkwDGExzfshj9W/42LhA8IWIW9mfPIGEYXvUybFg4VvD/qgIOf+coNNJB7kg0LZmcCQfTtBrDuTD1NSUwcuNkurCsHfGbfOEYp+Z8mbCQ35p+7MBCZQL9guB835IBxNCo/HhIxkicyk+fvkZuImNIxGOxuEeYjJY+Rz5rQfCAK2xZ43oDsgPVm1wbmsU4o2yLexTDrxxBKSXJg4S21SAPjyNmduW1mwHKZLT4Fe+HgeEnV3XonXaquM5hYaAW9ATbWauzgDEbh6tFxcou+Dq8DFRrt3amD2fPPAXwbRPg0gS1+HWpKYedvlZZcq8evkW2kwARMjWz73quplqG4v8UeOCmNGrqhKdcja0hv7DYntknxRozTqWxeKj3KN72R96ciKiOXgTR7TaFWcAeMPYCBC20V3t3P1DHijOfXPjV23MvmryCN+CF7ZWzmoE9XV1B3yKYxbkJtsC/iKkjssmtZ2rYQyHYkNhSHVusRdN8Ha0OY2ZW1CF57eSX2/NhbEcES4AYBiC7xvaIIZyPVELAqpYRWCwtFLuJ5CO4K55TqOed5VAtAwjHPo0nHy3zXXhkDP7hjqCUAPriD0uKxXvAZx5V3eGw+9cnjCHEom5JoPmL8DHdZm9YoDH2h+ysTpS4142J+Kjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(39860400002)(376002)(366004)(396003)(136003)(6512007)(83380400001)(4744005)(9686003)(26005)(44832011)(41300700001)(6666004)(2906002)(52116002)(186003)(6506007)(86362001)(478600001)(6486002)(5660300002)(8936002)(38100700002)(316002)(6916009)(38350700002)(4326008)(8676002)(66476007)(66556008)(33716001)(66946007)(54906003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Nud+y3k1ffFVVMx/VX+t2FEdoabwfnRmVKYCJNzH6JOCQKrMbC5rN/xWkNKj?=
 =?us-ascii?Q?qh1Vf9dK12t9xzF2hvsrpq1faiVEXtYdqrcTnjkwmJQ5IHny+iJNfOoJ/j0L?=
 =?us-ascii?Q?XmUdLQo0+8VZEbpv5UrSY/7v6KJFDq2aU9Rd7h9SWAjE7ZqgHltQgT5/JpyM?=
 =?us-ascii?Q?diX5p7C58dw5URbAQR1dzh3zh9lQcsKpP+Cm5E7qioalHCkqv6BY9l677o6p?=
 =?us-ascii?Q?c4VO2daTosQ7XG/s98dc2I1W2151d7u7ehEasS7QGko+Me40hKzCHLi45NUB?=
 =?us-ascii?Q?rxre83Vh//TCwY4aQ0YjJS264lcgIbpGWYkhvxovRwv5A/jO5+cy/U6iBS0Q?=
 =?us-ascii?Q?7kqoMJOlJE/5bYgzaAfdkqYdpBIeQoG8KZX6Dk8+B+qIU6biwYR9ekJ29y6X?=
 =?us-ascii?Q?Qnte2SUbW4gzMpA4mZFGZ4jUjWQSeCDACUciRBfq7JRrFszymaBn+/fOcYnw?=
 =?us-ascii?Q?szvixshTc/TFebRW91xk64ggJUOhH3W9kkRL4Uu0u9VWHeFxIs/RTejWESsE?=
 =?us-ascii?Q?fDUjiemgzHhBtz6DDW6Ql/i//4KWrr1AsuR2H06XiGk6YarjYhbynAGYsSla?=
 =?us-ascii?Q?ggW5ldgdLm7HuAFWCAx9TfFRngjSDmjG4k7SrdJroZOqrUJgAMKBVN1Dqojv?=
 =?us-ascii?Q?+vf6tw25sUMBBsJcbuIE3DxgRsyUkWKqGBk/7C7baSvV+NAWO6m6Hz2smrib?=
 =?us-ascii?Q?iT8l6vWO2AaYodhlsnWyey5x6O7GSjSG7WK72z8FA3nlXcAOIY/hFg3NlGPw?=
 =?us-ascii?Q?Vwg1RdVfHxGTrYRhd2FfXugsH+B9FbBkdyRBgThzzsG/OL5NZq3sz0fjrJ26?=
 =?us-ascii?Q?3qoxsPXONODqJT5PFggzynnXbhZWRMq5dWMS9bbjccneX5MzcbvfU+M2fCd8?=
 =?us-ascii?Q?Odm9d3LbESWFU9kAal9xKF1B24zpgGbUCLpL2XEYG3XBSaOtEaP5LplyV/w9?=
 =?us-ascii?Q?FDthxnGSmsO5hB8PsVOGkBKINQMy2vkmDPUFPoW/23we0I4P0AH1U5tuoJ7i?=
 =?us-ascii?Q?puYIaIDi9wQ7ED5nvtPbPOt8OP6gVZmDvzxJJumFR6hQY000nC/siEWjnIJf?=
 =?us-ascii?Q?qsM8NlDdNGrIoQCZIyFLOjZBeKKtAi5XeOg5W93XKVVHFOosEQchgaSekOvL?=
 =?us-ascii?Q?tEKHWkfYlXtPEV1vuAEtwaRrpw2+fg4w6rQyBQDcFGinNCcluSTkwrDIXWBo?=
 =?us-ascii?Q?Z3hMcpikw3jYHiMGA/vqS7W9obD0xjIQhRAA+iBAXAbLndEjTLVhNWJNHf6V?=
 =?us-ascii?Q?35CGwWLimrRpBO0yvPCdWLms8ihgzgqfy4+560fV7ixp2V6KVKpu4yPxnCcI?=
 =?us-ascii?Q?dHqQQ21yocEFSAcf5Aso4V4OHvQiKBrs+Q1hIfe0thHowlWm6nve90TH2ffH?=
 =?us-ascii?Q?hduDVFWBFMJW7mNRp1a3n8ozcc7V0v6xP5zmLzRdPpVayGxrfAqhSe+qy0Dp?=
 =?us-ascii?Q?BdFKnserw5ne7DcfHQ38ymJTT0tsxt41Bhdz128mAAQ5rSmozYAyJBV7/nRJ?=
 =?us-ascii?Q?CCdkhcnQEiy2KXxPVe65faNElSuv2Wt8mZYJkiJ14Q2CJB+tPjiGRuAgZLji?=
 =?us-ascii?Q?jzIQkP11FJQdEQ67zdOCGvWtnmlQXuFWhjI4sDaZRt2Fsb8kLn2Qo68okdg7?=
 =?us-ascii?Q?Lg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c8f82ea-bd38-47d5-5e47-08da68af98a8
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 11:21:01.9364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 70/yZnEvBsm/SRM+UKVuP2s/oK6kCgKkNMJUgFRlVa8oZgAnXzTJSCbkllPbzfUpHOBmbwNlFX/Q+WqFJQ9qlUQt/DDrOcbw0zNi+/0wjcM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5455
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_10,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=874 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207180049
X-Proofpoint-ORIG-GUID: a122gOuNGyqk5QMfNCutyJmqFpdXlzwp
X-Proofpoint-GUID: a122gOuNGyqk5QMfNCutyJmqFpdXlzwp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is some clean up necessary before returning.  Smatch complains:

    drivers/scsi/mpi3mr/mpi3mr_fw.c:4786 mpi3mr_soft_reset_handler()
    warn: inconsistent returns '&mrioc->reset_mutex'.
      Locked on  : 4730
      Unlocked on: 4786

Fixes: fded192f1303 ("scsi: mpi3mr: Resource Based Metering")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 6e39f7969e63..0866dfd43318 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4727,7 +4727,8 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 		    "max io throttle group doesn't match old(%d), new(%d)\n",
 		    mrioc->num_io_throttle_group,
 		    mrioc->facts.max_io_throttle_group);
-		return -EPERM;
+		retval = -EPERM;
+		goto out;
 	}
 
 	mpi3mr_flush_delayed_cmd_lists(mrioc);
-- 
2.35.1

