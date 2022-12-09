Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5DFC4167B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiLIGNr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLIGNo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:13:44 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346F86BCB8
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:13:42 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8MIfLk002811;
        Fri, 9 Dec 2022 06:13:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=gPESN0+UVCphq3XPGz/niqdDgtFl9XcUwVWpX+2N4iw=;
 b=vPBiqerD8xJt2WKFEGg9hABGQamHiTx1HfqdJsiRIhfpn64PHQ3fBinFYwkX+yfPUwX/
 yqZzwQvSIh8i36iY0m2Qcn++AotYyke9zYJWYyMlzJ13zAeSwZyQK4ee2z0r+5M0XGs7
 VTWGpx6iV3b/xa1Uq2lPS1IVK4WlKDTuM2MVPKfJZJdN9ZBg/F2aRsbf4uHJbIXWqqek
 9hZqEIUj2nMe0K3uyeLAaAClVWcSHrvWtMXa9Mou2zPhJ/gRHu10LaqsKta4pRm/S1ly
 RINchFix8gPgzVZTJRLBRQd8WkWGU7uhLW8yO5Kc8NEITS8vuBzrcRQgOc6khrx5q6TD xQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maudkcjdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B960gBS025407;
        Fri, 9 Dec 2022 06:13:29 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa80s29e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbvGY17r8hFL8qkEL05HlDik2SEcmBrtQuz1HVoUH7m7+S3NTd5S+q0EqY0XYYsPVh3VqriInNFyJttGV4viN6p2f5j1GVv5O7LRyEtHBrS9EiNd0bxLzMindQ38IyJVp3O3GTQ8Mmy7Wu4nei5wDFCBW0GBuWpVkEes5lokt5tjiBp5uxtulB5I9O5NmfG2ug1KYdJzpymgO+CYZaZZkPPx/B8jSBRh89rY91Nn+9sV4LF32JuZPS4jhWIk493/nVdz67NUNyInhtw+tM704KsL6b4YXw+YpJBKoN89Jwa7BInP0aM75i5IdjQ7xSlcA2haLpONKKo80UN+9sS72g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gPESN0+UVCphq3XPGz/niqdDgtFl9XcUwVWpX+2N4iw=;
 b=O2/KVi2PEwYYbn/Ni1Q0LPXOn6sz40ZoODImgHEDIoUwFPS+BQvMGtVmuVagK0gpdcDs8VdCdwEhEQuY7GVsH06GJd59R9PL8IX5g4T4mZaK3+iphrIjyXvcnrIzYGOV05OK+Toyq5pm1B/C9wWwYyuGYYkuCPXONtZpsCKh7P0RYxcCa+V10GcMvKTS3U28hFbYhbJ9WeloPZuor21npU7oIL21DrkZDGXv2H9LjPyqErPODhhBVGEU7+4et3mItFSf3UQRsH57N0diVe+T67izI4BPILgeSuRAyZwXtc2XqYZqhPcedJKLVUjY/oJO7sJ1uxixds3Rhum0muJuVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gPESN0+UVCphq3XPGz/niqdDgtFl9XcUwVWpX+2N4iw=;
 b=e/NSECMD72+96SCJyXvTVZg1JaXGsEZPND7ZstabflbqZcE4HianGjA6FuHOSu++QwZwOkbDj+cZl/ZGt+mSbACClDCSfRqQoutvj3IpWM4m2j2604OUjaWkLV/KByMAigbzZaMMPRplbrnZmWGxWzLsIMhjC0n5swOQuP52zuo=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:13:28 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:13:28 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v2 00/15] scsi: Add struct for args to execution functions
Date:   Fri,  9 Dec 2022 00:13:10 -0600
Message-Id: <20221209061325.705999-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:610:52::12) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: ea35723c-53f0-40cf-6517-08dad9ac7ceb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: biuJUDovZY5S4prmpzkNNi7SMI6bB7VxB2ANM+PeGaECdKj3x+0BexfzcSkuh8AAhS6yQXx25CJT25KOJ/yEcjfvCJ8Hivsjnsb3HmiG9GtoXpkpLXXy3T02WSMSjpgJTV+xX1IsKklO3IjZm6YzxdyTBZmra41SSKn2gKxXAgkswcgPk/oOApzG9hMjMzOroItDzeL8E7rWRa+41n/n/Yg3mmA0N+KFeFXd//ho9Ntho2whjgJ2yANEnjuAbpwlKtXdk5N8vixyjPIQJd2J9/6VvbA4g9S31zTTnjndSkbs3onmOOLns8fA6FPPWcgkoUHT0E3gmVzgHwTRJrALEU4tgN8ahxVj2asoBR+osJ4n5INoRCfEtBhZZv/qY88UhqzJYnNvdRw4OQ7awMAFvAkRrMlvS4dulZPQo24vRn1uW4IFt9bn9ZvSrwPgxxSdRU8Ui0rrp84hZFNKGdjYRF1hfXfrznvoy8+wHo5OcB85YABPSzd1Lux022ytWjzmt50xEvu0lnotPDAAaC+cvyUytIqgK68oZSezstIQHJ6Sb1DKVPQZoI9QMLKUp2ekszFpO/RnDGgMJ7dVS+CtR4JWTnGQgC3xDsUt1ZkvbhjVQe0XYpw1nAFchEWqpJ3NRCjIVhKye8kQbFhqMs2ZeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(4744005)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gCCKFaqINBQGy0f0/troYjTSMBiBjBG13RCsBEXdNAJFlcyZwmPluNA0nzbg?=
 =?us-ascii?Q?V4vQrabNJqc5PGG7uH1ab3ljX4pkDKRf4VvmgZzljHo8BY43D7gvp2Gw4Jae?=
 =?us-ascii?Q?yOZpAX1Ait/kxwg4tknl9TkOaGyzIw0kVHk43khQzF4/vrT84NSkUk9VrAeb?=
 =?us-ascii?Q?BrEOovFgUDcjNp0Mrrt4eCJr9ewMHuD8T06wJaJk0qq2anTyflPf2BJ8zFN2?=
 =?us-ascii?Q?TZUScVENlUf20i5mvn/vBFI15D7OhbsEclEoWcIA8JSSdVE2pPzew4M8Aet8?=
 =?us-ascii?Q?b/jururnnokHiRhX4iPFnkoIJihdo0eQlSPR5G6dmIPk3Rsf1Hi9tQMhmkS4?=
 =?us-ascii?Q?2R6kKs0iW68FJXXiNMUkUqKMe/6k2aqdxQTLLmOUc3Co86fpmLrOlukIxOYC?=
 =?us-ascii?Q?781J3aGutGAMeKvzo8j9h1C9GLe+A1f1OaWpFkYWt/NwIPivgWFwCmM1J5OC?=
 =?us-ascii?Q?w297nURmt3RAt/9X09GE0noO4H3NgMPBZJjDiuRSctAiPhhNatr7fI87Kjau?=
 =?us-ascii?Q?J45RkzJNDMU1EbnX0K446g8Y8vQ8uiveCNnAqUwV2hU3lFlIv4nXW4jlsubr?=
 =?us-ascii?Q?wZdOssf9V0wAw7wZhwbYCZ7Gk2HhQ4fX0w2LWe27ulnmapOPkLUVPKo7wlOP?=
 =?us-ascii?Q?Y80lq/e4+rEB+72rLUYR7rPL2AOolcBJSeZCNxOluGEQycgGC9o7GIxAsO0M?=
 =?us-ascii?Q?gGYkFbnFwz5Ng8aKZwL3nTJeDklbSuiyqfg7zqu1sDEtMHPyIy5yA6/DIOgX?=
 =?us-ascii?Q?786RWcKZALXAKCyTWUsjIXaDsRBryak51moDbK8Eg4XAfCsHjd/bYmmck3yP?=
 =?us-ascii?Q?5Z/L6w+kFqhfSNzqx8+mRx3MSOWCHe0K2mFMuqUF8R7d6YtmxTtFbTS5hvLc?=
 =?us-ascii?Q?EKEjuF/g4iqJF9z7wqOFW1WZZRLyZTceXogmz2YMCJMk9jSgnaZ2O8q4JAHi?=
 =?us-ascii?Q?PdiUYZt7AwBXY9Mq2VNYAYkbiqOQcAJzAteNCixHxJSmFYQonsBJYOTci0MM?=
 =?us-ascii?Q?1g6ZPC72osi9RwmuzvYb9gGPl6Mamhb45c3akcb7bti6rsok66btrO7PbcE1?=
 =?us-ascii?Q?KcX8Zf61swlSZrn3WOb5zELk8wepcqLm0WTm/ZCu1585bPO/wv3oA7l63mSq?=
 =?us-ascii?Q?8XcV7EA5a5vG3yNug5+tYh4FaFlQR9EFZOIwBI24zSawcvHWHhX5Kf6tu0cK?=
 =?us-ascii?Q?fTzAi1Rk8iQE/xTsjzFUJmJNub8yYOlzEQ1Gb7/ncMhtQ+Y8tZDHvL9e2IOZ?=
 =?us-ascii?Q?KC5/1HkKz8BLIgU1LtAImkdNxzL7IPeRvtDhSKInK22h0YYhfVbl9Yr5qNPo?=
 =?us-ascii?Q?6H1jrGigCwgv4+6jyy69vtSZUkxMJvJcQKLhCHutszjXrtB+Nq1sNoMEXY23?=
 =?us-ascii?Q?G34t6wZJlLaONJgDotzAbZN0E+CC/rrFMRqeF9CfW8Zwnh2lj/+9KJQs78bn?=
 =?us-ascii?Q?Q9ZSoL4gibzc810/z4eugmGIgI9UA6W4vNMmuZJpTeK9bOmqHjgPafmWrGu7?=
 =?us-ascii?Q?bXyDHDHNrpjGkb//+exiEs9Dilfx14MU+aJ5IYcrW8LVVnZuRsy41kh6vGpJ?=
 =?us-ascii?Q?NAu69plM1FpB+bpdklZElm4VRhEnypxtI0b0AawgOYWGmSFk1OmQ3ky9T8vQ?=
 =?us-ascii?Q?Ug=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea35723c-53f0-40cf-6517-08dad9ac7ceb
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:28.2093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uKt9VV0f6wVLkkMAVMSG9JBJcBHw9gY/96+2WaLOw/gQYoUGDkhyvAu0RY0A3NKZzUp8ALJw2hPY4/Uy2nNrFtSR6QzljZcIIXzJ8UH/Lqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=872 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212090053
X-Proofpoint-GUID: E7WyM0bYioldIKnG68zw1col_YGsGQc1
X-Proofpoint-ORIG-GUID: E7WyM0bYioldIKnG68zw1col_YGsGQc1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 6.2 scsi staging branch and
add a struct that contains optinal arguments to the scsi_execute* functions.
This will be needed for the patches that allow the scsi passthrough users
to control retries because I'm adding a new optional argument. I separated
the 2 sets to make it easier to review and post.

v2:
- Fix RQF_QUIET use.
- Use the more standard way of passing in a struct for passing in
  the scsi_exec_args struct.
- Pass a struct scsi_exec_args instead of pointer and add another
  macro for the case the caller doesn't want to pass in a scsi_exec_args
  struct. Then remove the NULL args check in __scsi_execute.



