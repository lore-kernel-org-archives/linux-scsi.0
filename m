Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66847C282E7
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 03:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiHJDmW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiHJDmJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 23:42:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1113C72EC8
        for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2022 20:42:08 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0E0eD025960;
        Wed, 10 Aug 2022 03:42:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=QFe/I5eQ0VnB0qEEMbcvStNVjoZsko6oGexZ9DmsqNw=;
 b=gVekSQaQbjk/sbydWkJ/ggKYvp5UwTIJvcn1aYgEuajXIiPnZ0iJeIv13JR+AN71hjLx
 YP2F3TSlrbJABa/g5wVyIx4LC623UqPraRs3EEsPaq3Vp2HMLY+40yjJxTfGoNH/ga/F
 GGHGVMAtU/Sww1t/aPiRUnoZKyV3K1+EZx3mVotcavWK6Re9q9ED2a5KYZG1RfduDw7E
 TixNPMA7JWiZ1bLuB9miK17AnZ7XnpAzDEqBfprZQc0nsEqHfpjxJtW4QB0m9AM5juza
 vF+IyPKBsBD7tyMSHmwzLfPykwrAkyEm02FfSa6eqJwQA7Fmd+tXiO+6j9usTjTtLEA5 wQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqbgqwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:42:01 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0YZDW036587;
        Wed, 10 Aug 2022 03:42:00 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqfgyvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:42:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndpcLvDxFrqKo6eG5R805PLbZFkgM2YKJsZsJw7dDI8ccVx9IJQ3b0fjAFBydLaGTHX0Dd8UC2DAFFoHcf2yh2CMv6DMmWwkD3uUozLRqpmD8OgqOcxcx9rsfAPjSlYmfAEOf/RqOYQ/0m9gyHhibEkrV3UTp/9scj6kZyzV7fvotklWVh1PNhvhDVlWqkwuay4E5ziPlZHl1AtSW2MEhXygTejJFHgULvVRnFKuI0GKZ0lNWKz7c11fRdcTz2LtE37K2Eh6LTAGg+AN9AMrmKCIWHtWRI5sNngFLXkVBPXjxhsW/tp1HmOqmGBDrAhiO0hMHcb8eTHT1OhCUyBiMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QFe/I5eQ0VnB0qEEMbcvStNVjoZsko6oGexZ9DmsqNw=;
 b=mcNWm//RQBY4bGz3DiZXQ4Ofph0OD6oohTAysJR46M0NhKF4A1RbbzCIuwKj0TeLbiouaNEVsFg8dD3PkBuRobuB8+RBWUsdcvCCskfdI1v+sMvMSPWYBSdpPDEINkdWbPmESKe2cswll/lHFUghxJZ2gkQGlX2+HIVAFdvP0cZBTb6Ag+lROJqe38yIFuo5NcR5W8YPBoF6onBn5VRCilQ+rc1bKWsqVQDwzcZbNqFMF6Ya4ctQjqHTDVkVBUtt0q+9yIGDvJ0wxtFjeK9DJxMjWuK5esmuQiHhJBVOOqQrwOpWJDH0doof6LLZFuMeoaHi0zMpMVVjIh0VPZF12w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFe/I5eQ0VnB0qEEMbcvStNVjoZsko6oGexZ9DmsqNw=;
 b=h6TnlJjws27k8Ol+dZe/J2wqiCqO7fTLEM7w1Bq3gkK3duKcduXsNN6bKVy/lo5KICP2ZuuibS3nbVmxLKEajUsRQyJkahe3m9vkIxS4jIyu5j7TYLmDfgsCeY/DrF3kfF2kcFESPUWuggP2sG99YCTe80TkVkPXgKw+q/Q4ENI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB6302.namprd10.prod.outlook.com (2603:10b6:a03:44e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 10 Aug
 2022 03:41:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:41:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 0/4] scsi: passthrough fixes/improvements
Date:   Tue,  9 Aug 2022 22:41:51 -0500
Message-Id: <20220810034155.20744-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:610:53::39) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a72df204-75f7-4ee1-9f94-08da7a824685
X-MS-TrafficTypeDiagnostic: SJ0PR10MB6302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WLzSDzjs94D1yGF8MYvPfb0OS1rNWNf2m+g46kpTq/LRBuAyaQIdqqsCjrNxbe3b+DnZge96ZXosL8bH9rESwXrtRD58a3pnCtEL2uQQER8Z3srplpYY9Y08xGhWNHAOAB2uT0fFeMUf3Xed/QVbkvlys8wNTWCSN4hsFEoJUqtGGsGWzXITAFXTeq2K0E2a685dlIUeH24/S/0Wb56dPtfZ8XfSNFN/qUiHcv2aqEZX7RduPNWJDWggNHu6zKCztMhnIgRMzJZf3fW4UInicvgTABxgCoXsgso0ubCPLPZQE3JGYJEBCUHjjSpX1SS50t7BeVlMhJ5hlrcfeBfR6TShHkvZmt7INSCObotoN0151EnVIsbl50GG/kMVGnTLoUh5tsuQW7gsgikB/bVhoZKq+6T8i96IKsUsNt9MYXDFD0jafEcS+xtUxs/tmmY0dwjgN7HvMi4M18s3e9NOoejKxF6DEiPf027eFPllCwNFuxQYitQw6i4dWgq9TrMoZCn5t0DGKC5gCgDcPrAGrm+LFT9LOd0D31SaeRxbCXLypoIW6ceD7RGMRz6vT2kqYuXIC9bLDkp73fwZmM+Wvio8qQNgacLP+zvzmbpqrbzDR60qb5jWt/aLhBsONyMd0gjQxffETQAbtlVfaTGMlg0eSB1UBzsvFhre3HX+lsMuR5ScOX/yPNRc2FutegyYGyrywW85ZzEfBeRh3PiLK/yigxKBrRog3YVwL7Ez1SKMrlY39odLYk4Dv+nYABxJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39860400002)(366004)(396003)(2906002)(6506007)(316002)(41300700001)(38100700002)(6666004)(86362001)(2616005)(66556008)(6512007)(186003)(4744005)(1076003)(5660300002)(66476007)(8936002)(83380400001)(66946007)(36756003)(6486002)(478600001)(26005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5S42+FwDc2NZBcsgr/l7pwRRgL+DkZdLLZz0g6BorH3IQQuVV6iraA1/hbuW?=
 =?us-ascii?Q?+NKkbq4PFJsh3RKPFuTuN29AN317uYO3k8o9fukvtGvhtngFHAW+nzWYrVQf?=
 =?us-ascii?Q?LLBo0kbjaXnIZC3cvjpUZKbGEq1GRTBXFzRaELAfYqqm6rPEfIry+Le0BIod?=
 =?us-ascii?Q?X5ypjJM5xioXp2oEOgvI4zbpBlZwWGyijU7nvB2n8AOq5vrIWRMoVPresA6q?=
 =?us-ascii?Q?/37fa4x07UoooBaCJoMpY0ZYflMxz/xTH8SuXZjMuv8P6lwVxG/Q1jKtIE8V?=
 =?us-ascii?Q?7Dwmenp+SM6jbCRflfCZmnYfvr2P2L+ilu+/lgObE7BnRFvrNs2+IVE7SuF4?=
 =?us-ascii?Q?YBrlg1ZVhwWY0JyWwV4SzDXgxn17RKnPra2JlP5O1E8XKPnJzOx5mI6GJCXP?=
 =?us-ascii?Q?EIZKdP2w6kjhlBLseSkv4k1IynlV2yQymPCVSKRyDICxA0eaZyFSubzb6/mG?=
 =?us-ascii?Q?SSIOk81V3uYdNJmcwZ3vK4IxYB/GmG+CLiY+/pEk6DflDc2MtoV2Rv03txGz?=
 =?us-ascii?Q?RjjjPZyDmeKGnB3jt9G87kPE7iKCJVAGfPxH4OPaZa4lyEm4mH1XBOhlTNI/?=
 =?us-ascii?Q?9qgTVFc8om+Rg17tNBmYA+/fk3bf14K6c2lKnSSv6jSsC3iTQTsOeL2hXDSx?=
 =?us-ascii?Q?RDG3wxPUKsa8izxCcF8XVH725GYS2pM528/jjCmoNfr2f2ZfHjYhvOn/yrC+?=
 =?us-ascii?Q?FU28EBJWhRyiGOFxK56NeckFXOHdJvJqKJgF71PPqBy+yRM7W8tbhjRtYYfv?=
 =?us-ascii?Q?B50jcrmFNd+9xLPelMKIx4jsu7hgBzRAhAOFq2jrRy6eq06MD9So7HqlAcfj?=
 =?us-ascii?Q?yd2+UVLrgk7Z6e+vqqhdNkdjOszpNt79ZVBpkN+vP4BNZGthti7v/0XwA9wu?=
 =?us-ascii?Q?YMjCZg0hKO3sbV7BnXp6aK9r8LbBlQ1Pgx8aS7J5drYCLYTi2lUGpa1Aaojb?=
 =?us-ascii?Q?gdlShmz+lwBatMGKFKDEL34oUxU+McH9pLZK37FIAN/xq9fIoyEyiGsK4HxJ?=
 =?us-ascii?Q?7dWlh3/eI0wNYIljM+a8BOhl+spldJJlaG0FiStK4So4RTlwuUzsskjxvN/I?=
 =?us-ascii?Q?ipURbcf6GoT7pgzv5WyGZJTo8HiOWTcrpRjU4pgLbNMLr4YwxUlb2onlYP+u?=
 =?us-ascii?Q?PCXETYhsSW7yRVGHsZpvBiFe6PCQBM6Fw/NMyhxgN9nvrZNfW0aiYZh0Iygr?=
 =?us-ascii?Q?9ITC94yIns+RBIC91cs9teh0Tl1UMcy5xcHZMY/ys0v2HENi0kdhGL8wlZJg?=
 =?us-ascii?Q?5NhbjeAaQZ//fs4B4gfTQXFF6YxBXA3vz8A2ZiyjgQ8xzDniZTsBKNiNzMHU?=
 =?us-ascii?Q?My6Us4wAUIivo3U6KT4ZQQoJVbtieQiw/SfpZgZt1yGtzRpdYVpcSKHv46ku?=
 =?us-ascii?Q?ZMuebCUGqEdOkyQi6Pu+cq5yX7orKJ1Tg6GPZPYBwssJ/UcwKVFaYGj2AG3N?=
 =?us-ascii?Q?ZL6Z/DFO/y7x/GAtiOFt1+sKNKFkOR1XQqtfYhJcHIYkAk3tCxPoSULqy7/a?=
 =?us-ascii?Q?+IHoE7+DkD94QXU8Dn+wFq97WBloVazLkKuNq32N7n1LCrQbz6rhDCrAL358?=
 =?us-ascii?Q?1syBVkmHU6nBKm4s1kJOcn8phWoDqf0WcX6KITQ7ovmdk5ZvgqUpb4qM1k9J?=
 =?us-ascii?Q?5w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a72df204-75f7-4ee1-9f94-08da7a824685
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:41:57.5095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9HKjBBsz320z0i+VkmsBq9xv5RyUMMDd2UO9mdgK6zsPcgl/BLe6Z45omeSyHd/3xg2By/ynC4qNfP4MSbwkQ8f2xcExEg0aKgALQVFpgZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6302
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208100009
X-Proofpoint-GUID: w-ciyR2lx7ALfIDJbsUm1n08eWLLFixL
X-Proofpoint-ORIG-GUID: w-ciyR2lx7ALfIDJbsUm1n08eWLLFixL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus's tree and fix a couple
bugs/issues with passthrough commands:

1. Martin is hitting a bug where DID_TIME_OUT is not retried by
scsi-ml because it hits the general passthrough check.

2. I had mentioned to Martin that I was hitting a similar bug with
transport testing. It turns out my issue was slighlty different and
was a regression where we were always setting allowed to 0 for
passthrough commands so I failed before the noretry test.

3. I was hitting an issue where pr_ops calls are returning what
some apps considered a failure when it was just a UA that was a
result of a previous pr_op.

 


