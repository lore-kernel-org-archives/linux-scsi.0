Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4996C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  5 May 2022 10:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354653AbiEEKaO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 06:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350947AbiEEKaI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 06:30:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7FF517F3;
        Thu,  5 May 2022 03:26:29 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245A6IRD018740;
        Thu, 5 May 2022 10:26:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=D579sgH7/IG3h8iYfMewvU9jmGNg5AQrkP8UaAgTyRE=;
 b=G5bUcla6YhOBzK9fkOMSoVM5GKjnmnkKoU3wvreB5uPlpM+nsCTfHXeKHatTNkRQ1dx9
 Rjk4Nbuk1V5gKgte2kIutowH6QTqDTiyzgw5tNxX6r24VZynXdkEyjgNFsnQ+oY1LGbx
 Id9kGlyRYHyqCfcDM/36nFPIcXVVBkrX+QH0xirZiH4Y5wj0KBTFFzqPS+wN2j7zd3ht
 Amt/fdd4xXyUQbDfTPvMvT3nj6eGM6IOYwOMAoKjjmDvuv5EiuU1T19+wA8CUX148siI
 u3HYNmp6a3TI+3WO3iSPQt8e2Ap/o02nzt8eR0CmmNX856wgcCh8cslBc9SwftvtYiYr 4A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frwntb0em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 10:26:26 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 245AOvCQ034310;
        Thu, 5 May 2022 10:26:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3frujah6vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 May 2022 10:26:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsDvdVaE/jkfXNJtkt0E3evOd2hdF69L8tecKHT5kJrYhiuwGlehJQf7PZjRWKHakKHtGlQYD9ebfxpq2uY3GBCK/NQ9Bbx4wuMDa2QD3VJIAyU/C/BwlvyzpxdKYgBepSqoqoO+tioKRS4YSxVzIMnl9pPfJR4x6zNzH87Ke3gRqVRxnzTjo946WkfSLtVWYUhATmn/pNL8EZYrZUElfKRPgjE5yphNtIShQLBBjFzvCvSwPY/35ik56xhqLoOelzOQhUXk4Jyph7jpuNFDkk64UQFQBEa5hIZcS8XO46gd278FbKM7WLoY453852MGmgCxqOHolYMKy4aiFzqxlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D579sgH7/IG3h8iYfMewvU9jmGNg5AQrkP8UaAgTyRE=;
 b=lsJPBVBF4tewr/7kDXKfSAixezL9bmIP3WMLIxVX+OV+4kY0F3MWu6RQoFQKM0suB6wb2ced3qkpxPbyCzaaryWBtYPvnsjjGlhnhpu/jwpYGEWkEGhzt1i0KniojjawQdoi34QVHmFbaRTgYHiVgE4Qf+0b5NoMjPbVwNRHwlM99EsXt52sgaKIV6yMZj2DHI1yE723R3/NQeSut2h+Tmu9KDx8KgJpptV5LlKNmKZjyu2WFnQf8CsF3R8kZPGiKz3bJiasUTVvG/EcMLDmeLJiDHy2qQLUZGFxyyRW2cZ9Hh6yj7spY/05luOUy48wtjrBpLS6AA95QB1h3G+u7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D579sgH7/IG3h8iYfMewvU9jmGNg5AQrkP8UaAgTyRE=;
 b=JL/dzbaKhcp7Uk1blIa5Oqee60n22s72S/E4glIPnoX48u8QplaepRMv7O211il3g9+Rp/9VA5K7a2iqGL6LB8TyJALtYkIxA6ggZWLQFfJ2XMyRlHk0br/oHkwVZB0SkS/0puWpuIl2+Ka5q2g/7R8evL0+V5OveNQ6wrUaO/o=
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32) by PH0PR10MB4710.namprd10.prod.outlook.com
 (2603:10b6:510:3e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 10:26:22 +0000
Received: from CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::e929:b74c:f47c:4b6e]) by CY4PR1001MB2358.namprd10.prod.outlook.com
 ([fe80::e929:b74c:f47c:4b6e%4]) with mapi id 15.20.5206.024; Thu, 5 May 2022
 10:26:22 +0000
Date:   Thu, 5 May 2022 13:25:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: Return error if dma_alloc_coherent() fails
Message-ID: <YnOmMGHqCOtUCYQ1@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0079.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::12) To CY4PR1001MB2358.namprd10.prod.outlook.com
 (2603:10b6:910:4a::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d573de92-3263-4fe8-3e10-08da2e81b364
X-MS-TrafficTypeDiagnostic: PH0PR10MB4710:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB47108476E8D9AFAB302D7B3C8EC29@PH0PR10MB4710.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zu0DR3Jo22mIk0uspQzzq5SBZttD9yvT969bu18X8ko+xjn973BNJ0wkdFZXLvEbTgFRJRGM2xzr+dIrF5I0HwDYTdXId1xhhg3MuKWZMeijQmyeK8VFlPx8ufdtfg7mgcer2IxoDMnfVhurgNhw4SUKNk7Y81lyqtzgbnxW/uT49NfMdyYYmyJmBhw8pAShGoIavBx96k69sPz9GlKwy0OrJZg1NEqJqKCqMk+juF2gVzIG2fJrLZv9+B84qLuVoylaKFZbR1fW0xTGYjbt+yv0N0/uueHGBV3bIr8mIBt5rx0OvcPe18PEsz91jfijCiWH4C8JgNywWIZrMx06TEMozZts+IojfT6pVwyEbMpstWX0B5fUHzI2X4x1jbBxQWyEk5yhzgSxwHRU0LtDD0bwMRq42CH1mHEkYNwiFQF0HWNiMlJpVeiurfOTmirjaUBQ0FSe9XWQBGWytxSTwqY2t/dqJdh4UnmtLk26Q4aaVWAThy8Drm9L/m3S/yj8DMdjD6Y86TIfD4qL1CVgu9wc27Af2rOHe7WHdvJtaoq83H9VOI6cDHdl0LgvfgNuDP9nih9TU9Aq4hjrW3KjO1yZUJsE+tECF8VAXWtFNWFVeH2m8IKNrd9QbOY1LGPMfy6U00Dvbu5D0D7cTpqLTeHPb2IXvi6ovBGCFnm8XCkmYVPimVdLYtSanCthKOzEgE7Mms08IisAhdBAGFO7TRzFzp5v6BOwUU69x07Wx9g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2358.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38350700002)(110136005)(38100700002)(86362001)(54906003)(26005)(9686003)(6512007)(66556008)(66946007)(8676002)(66476007)(4326008)(52116002)(83380400001)(6666004)(186003)(33716001)(316002)(44832011)(5660300002)(6506007)(508600001)(2906002)(8936002)(6486002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HHlU+rKwk3i+FfATWY6Z9Wu/tvBKxsJoBjM9dC3Gqh1sF6kUZ1k377jBlReU?=
 =?us-ascii?Q?DAPT9D3j5iNsW7vqfSCW9D9RG36dn4YbBqQDuTq7JW6L4j1iiPP2e4oTEBud?=
 =?us-ascii?Q?DnCAPeoUxMVy2XO9SG9cSFG7HYrCjlF+ZKG3tloqGp/DZphPSU5EX/nQOOYt?=
 =?us-ascii?Q?Zzr3mfxPU3jBqzjk5PoPYXfancwmNwrV7d1iOa8VoKXt2Gui6JgSVAPbeGLg?=
 =?us-ascii?Q?GH7gTycLF842knbE+bFZbFLYGUOL5BDapOrMux5jNwoHBleySyXscPWdQynF?=
 =?us-ascii?Q?x1+HxcWjY/EaEJzjMGNQsEquT5kDR/MXt0i7nbQGFgqRlp7mvu/qn+FIIoI1?=
 =?us-ascii?Q?K2iN5iz0KWxu6y60aC41kgptJGtOWVgGj+39VGbYzmeDnFulSWpuW9i881eZ?=
 =?us-ascii?Q?s5WdkepFBkY1G2fXgJLNOkFtXWGxgHxURjxZJ2odGCTxvBq4C6VkbSd5M7Z5?=
 =?us-ascii?Q?sIRBHuxHSMxFHu9WgJE81Sa43vLzDipHfBzF+aBSCiSF/iZadgH/U5e8ewFv?=
 =?us-ascii?Q?mx0QlrkptbfBsiiJaA0DiFvexiA/JEnsd58dSsI5/AS1O9HHccetqpIRltbe?=
 =?us-ascii?Q?eaJsD447rIpcXOQMr69uuXa6bz5Sv2Y7EyU8wxNiuJQGZYahPy0i0LNgFuw5?=
 =?us-ascii?Q?Ib68z1BNsRGeCUYA5C6mcsH53okcgZQu6X9Vz3KKIvN5Jz5M4oJrUf7fuDLL?=
 =?us-ascii?Q?GrwCEFHuOFR128a2npP/N32tElJlVqK/rHd+0Hz+F5gtjBeSYUWc82I1FC2R?=
 =?us-ascii?Q?eIW9gvF/j6WhYa/tRj+mv3d6QRr6CaJ5mBwl/ynrCLSUUd9HAerbKsMHOnQv?=
 =?us-ascii?Q?7aQxt3IgX5n+p7xlwK/2vGJxml72iVrKiuLd6iDiu78KQcBqvCK7UqsHU+/b?=
 =?us-ascii?Q?w1Pm78EHYkkg+qe6E95D0eRe6cYrTTxb/+mhF6huYUqdLEBCUtKZSf+yIlBo?=
 =?us-ascii?Q?OfJI7vYyy68w8ZzO8Sgp3Vf6C/L1EjsMFsMs5v0SiUEkqEhxvLgukqX1MWL5?=
 =?us-ascii?Q?Wria8t6MEf98H9veEACUk/jVCRrU9gDUwf9ytT9S8SewvL1S3k4K0SfVWYMq?=
 =?us-ascii?Q?vZ/AfofA4wfYrWaPwLsK05wbU069dJxUe8FrJ2t6YjvBg4Q3XdVEEqbYTP5W?=
 =?us-ascii?Q?jjbMzkqDnL0G3BDssrn753culmcsi9MjNrHftujEqcK0giJou9VttC4o40jg?=
 =?us-ascii?Q?33CEwdVd3uis2UMr7auv5V+RVr0Mms4Tg5XuPH4MeI85yIIBwuK9V2OF3G8G?=
 =?us-ascii?Q?U4SfF9iIX8UrSzGSY/5LetaPsXUBpnxBj5t2iKgi5XxZVJYrQDAG/N6hZn0A?=
 =?us-ascii?Q?NevgmCUjvHxXNKu910mY1CxNAfmNZg7+iYJ1wfYJJvefqKF//eWTn1qE3ct4?=
 =?us-ascii?Q?JlCCvKykduJ/WiZgLO56x3VDK7Id95PsPDEv5GRFmBxxe5iKDMOXKsTEy1OZ?=
 =?us-ascii?Q?mq7XGUZL4y5mE3qNzUvxrzTn/XvFvC3kLpFAn8oajQmiAtz2A/dp+DPnWqwi?=
 =?us-ascii?Q?d1l4ZartqAhmzR6Qk7V7sthsj+aTphj9ajHXipox/kkUHSGUl5l8cpQFViip?=
 =?us-ascii?Q?AKskmtW6bV7cnkmpnDDyqa7I1BjxH0fIXbfrbWwMdUlrEr7sbHigtyV88Uu4?=
 =?us-ascii?Q?8cyymlhEGJkOtippLJwMbC1tsu4VIg1KY8OIfIcXjHAHSr/tmEB0tFQ4dViz?=
 =?us-ascii?Q?JduXJJ8ixsi13xdiSNsXLngags17PWn4YVd9tQHFAG2slUDwAPN6/N+++sca?=
 =?us-ascii?Q?OkvbHMKNg7IL9L3HnABwcfxrWkPJKXA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d573de92-3263-4fe8-3e10-08da2e81b364
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2358.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 10:26:22.7789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ffkJRkiGGDtFEHNhLXpK1naU4BiUXduu2cNjWGj8aXfxlQmmdCLxj4FqPwP0lTQA0KPo6aoSBTfyu8tXAFCn1DSJ7BbFXDCMtB/7gTv5qMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4710
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-05_04:2022-05-05,2022-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205050074
X-Proofpoint-ORIG-GUID: NgDNgnq7ikkWhuLbTVc-bSP7d5lYPyvS
X-Proofpoint-GUID: NgDNgnq7ikkWhuLbTVc-bSP7d5lYPyvS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Return -ENOMEM instead of success if dma_alloc_coherent() fails.

Fixes: 43ca11005098 ("scsi: mpi3mr: Add support for PEL commands")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 74e09727a1b8..f1d4ea8ba989 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3754,8 +3754,10 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		mrioc->pel_seqnum_virt = dma_alloc_coherent(&mrioc->pdev->dev,
 		    mrioc->pel_seqnum_sz, &mrioc->pel_seqnum_dma,
 		    GFP_KERNEL);
-		if (!mrioc->pel_seqnum_virt)
+		if (!mrioc->pel_seqnum_virt) {
+			retval = -ENOMEM;
 			goto out_failed_noretry;
+		}
 	}
 
 	retval = mpi3mr_enable_events(mrioc);
@@ -3873,8 +3875,10 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		mrioc->pel_seqnum_virt = dma_alloc_coherent(&mrioc->pdev->dev,
 		    mrioc->pel_seqnum_sz, &mrioc->pel_seqnum_dma,
 		    GFP_KERNEL);
-		if (!mrioc->pel_seqnum_virt)
+		if (!mrioc->pel_seqnum_virt) {
+			retval = -ENOMEM;
 			goto out_failed_noretry;
+		}
 	}
 
 	if (mrioc->shost->nr_hw_queues > mrioc->num_op_reply_q) {
-- 
2.35.1

