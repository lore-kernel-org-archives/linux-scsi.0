Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DBAC43334
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jun 2022 17:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350149AbiFJRFM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jun 2022 13:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350157AbiFJRE6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2022 13:04:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9DF396BB
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2022 10:04:40 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25AEOvjS026192;
        Fri, 10 Jun 2022 17:04:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=x56Locem4S3rJT+D7SNNfxpghKos0M0c5/7Zya8qzks=;
 b=UaEE2L5w+WSeoPSJFyEWjy7iLzfkbINvcSc++e/TXPyt2nWWg0Z4bMvnOJPY2TOU7T5N
 PfUj77WP+W8zsc56htyiZQAzCWhNYM2mBo18Z64mLSZR62dXagwo4IepFmtWjfjXPw80
 V5tnzJ2MvhNQD31aBA2dMgzOXSfbSBh2GIyB0DtlGCVxmZp/Pqksgm6JAo9xQGbSkViw
 8cHmWS1MYyAAWCa3C2FDCjBAIdBkcFY6JbuBWqRjqmCUXACa94hZIhjp2he2vFcTzMrx
 hcNdIrxcWTGdrmjH1tdk9qiMzu/ekCBeMHgRgqX/KF/ptnTpJKrEyRYILYOS66rrV4B7 ug== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ghvs3hchh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 17:04:38 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25AGkh6A033410;
        Fri, 10 Jun 2022 17:04:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu68skk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Jun 2022 17:04:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVHfPGRtDkC00YWyn9RPZeFCBIOSGKN4ssyw/nO4ILg0NVy37mkmexu9U3T+MZWnrw5tm5e1jhtr0Wtc25F6cgmqwYEjioOT3CDzc7pYiBfLZ0moWWZqcNwaoBx7YTBxPge60RrEtNr+TawvUyDUImFHViOnzHUsKC1QZU/70t8DNYJSp/zscG492C+XqdUIUSNZelMrD4gKQ6aaID5YSH4YfUcQb1OQCriGmkql9kuce0yEYFZ01aUTwrKBMQ6rpMwPsuoVpGfStTQFfTlvKpNYOEWYlF7XREm8LgN2Kf+ezUUNY8iz6/U5q4fGeV/FBv6PjBrbAnEMgYw1/g22FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x56Locem4S3rJT+D7SNNfxpghKos0M0c5/7Zya8qzks=;
 b=O2qYuc8gY1Dnidn1dWRdE8jrMpgzCbnZCW+SqZxeTvr3BlHWbjHIPr+bzEQVF86bijd6K2zsgN+sVAEbPMh3+R4NPx4f62A9AHFHLscnGC5yFlpFJ1i21LPjSx2DItbAm5fOUPOL6AUBAiHNVrn7WDvZ4EkvyWWcmkjCCslkosQ3t6gQfjbI1EKqb7PgbzJRX9fEtRy6FitkscXbbEoIBTv59tBHAtWVllH2LX5UqctluWIuyKeON9f/LYtEQCMNluRKiaWbT0xWFyR2pGrDegki8gEtoFalN7jZksY5T89Ydd7aNS7IPUsM7BjooeBWdGIgnSV69dQ23ijeutBCNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x56Locem4S3rJT+D7SNNfxpghKos0M0c5/7Zya8qzks=;
 b=psBnl/0YCN/Odn1J4+gA1rjuk00f+6lA3zrwfPSOoQYQVqNrq+Qw1NbepNxcteA9IcBPDnMVM8WEr50UBZ8oYW4bAhhRad2g9O8GdL4KDu/dkyA81COfwBAGbVu5lbT7PDBObaMdB6yI523B8+nMZYZxsf4Zmbtzcavp2cEXLHc=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BYAPR10MB2549.namprd10.prod.outlook.com (2603:10b6:a02:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Fri, 10 Jun
 2022 17:04:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 17:04:29 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 00/10] Additional EDiF bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14k0swium.fsf@ca-mkp.ca.oracle.com>
References: <20220608115849.16693-1-njavali@marvell.com>
Date:   Fri, 10 Jun 2022 13:04:27 -0400
In-Reply-To: <20220608115849.16693-1-njavali@marvell.com> (Nilesh Javali's
        message of "Wed, 8 Jun 2022 04:58:39 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0086.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcd0dad4-866e-4948-82b6-08da4b0347f7
X-MS-TrafficTypeDiagnostic: BYAPR10MB2549:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB2549F3279B5FD594148068C88EA69@BYAPR10MB2549.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VyaZD+ouUUyV4PE+kpi+GMuFVP/3KJKY5tXMEDj7WcxLyZys6nYvNDbXyWGqmJQk/YE31gzDxFusYptE3zQmj9Hyj4R4+9jsUpgGYL7+G81+M7tTtCWogU2k9KpMqiFlIku4FrqBH9Wj3mjQKw22ueHmNDXzRPDK6t9rdk1zuGrOeB26PP9mwi1Yz14JUkEiZKbwgLRoQa9PV1VYtLHJC6btONp7KcVWNaRpwkn/VvQEZsyy+kK1vWbDDivp9nJqC0Kx4V4LuuTVet4Ps1m7xYW23K9xmAp88SNKUIJOPvwFQAZOncz+WzHO2VbgrB6P0YiwMwuLvG/3qWGNNYeye/6UPpyDdYfq7cFr7bBSxCRMq0I95VVVWzduqsFpAmYiYAFCnHoFfP1rc8yNnhRRUk1SVAE8k77uAVTS9mxBEYXBtaL6VVqS+oVm2cWdTel8PiUlHruk5pw1NqPE5YNhwvOGZ2AHpUdpOzkYRhk92kkK2Sh90Cr6TtoDFmwsNM/lWdj/3PbbJJ1O88cJkAL8PeSMxImtl/JnS7ha7+hPCzWxsJC4OgUbb4QopePjDVMEHWagB+PeBIC/VpiFGkEyIvHS3ZHxg/0Ujir9ZOK475h8LZEJklRO6xKZlNRXTVcATpSD31+yk/D1gUhd52N95NMDn9VIGx0RB62GpMX+vCscJ62CPdk+bJfccCPe8SsSK11eEsIv9VI38SmpvUmAxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(52116002)(5660300002)(6506007)(186003)(36916002)(6916009)(8936002)(26005)(2906002)(4326008)(8676002)(558084003)(6486002)(38100700002)(508600001)(6512007)(66476007)(316002)(66556008)(66946007)(54906003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o2BCB62m3cvztXviVrIS3oDEZvP3NvkcQeJQ+JkWCUVjIzcJja27W/kk/tog?=
 =?us-ascii?Q?aNvHoBEuyJCtBKtHSG3m4I6qevlLJPBnIomXD0MIZp1hHozl02v53Goqhrbn?=
 =?us-ascii?Q?XdGXHgjB6SnC7FDij7tjyOZBRRf62imVYYse8ZbVzEShIXi2aFMOu6vkm0U0?=
 =?us-ascii?Q?bA9TPPm0vnfPTLgMxHItwmE1Gh3THdRjqE6L7vArJibJA2zfkw02RQ77MJLY?=
 =?us-ascii?Q?IG8g+eyhhN7mPC7GYASpm79pdM1qCj/E5032XkIhNzFgG0ElP7IHvxOS3a3N?=
 =?us-ascii?Q?mQSZh8Cjy1/KMAR1bhFhV2Kbzt9GWzwH6f+owNKyryp+MZU5kbKSWpt7zMkZ?=
 =?us-ascii?Q?rpGHe50u71xN8aYlM3fZeKRdtMZpi05KLVpzcdbXa/CYiaBBrC4DTwepzGhT?=
 =?us-ascii?Q?XvTAKZPL0lyJvLMBe/+uO66ACRX7EYrS9YUhkndIH5VmPcOFNYng6tTezsKv?=
 =?us-ascii?Q?AEagPNy/0FMaCswEsiV/KrKHF8EcoXYRa5DXEipU/c3/APbJpI3mKyewotgy?=
 =?us-ascii?Q?X/DktgQ60yTEKeZHtgfvlm5dFj2vHYr8eyw9B+qXcbgWh9uVxIPB1S03p59P?=
 =?us-ascii?Q?aIOk0CPAUL9GG1EYbQEs8BtEsAk24KDWPic/F8Nups8k+Hei3Zd2xCcks8v+?=
 =?us-ascii?Q?tvYafsiYc4wyHSplUD49BLFT+ofe1hOhQxSkGBTqp77s9ZccQFwA+sYq2JDN?=
 =?us-ascii?Q?CCM+z79FTsXQVt5xppAuijTXDGccLKbyHNnY+xpKKOXVzGCiy5W9hdywIi4G?=
 =?us-ascii?Q?gsQPxwpUFQxP4xkM7jNdUdd7thTE/dL6HCgL1ZdRmHR76NgQ0HrCLWQntQzk?=
 =?us-ascii?Q?I0t67mzCW4NwugaLHMKDJYFLPSGM1MyTczrw3E+lbTQslptTKFQO7GVDVDxg?=
 =?us-ascii?Q?RRjQoKW9wCp3e+k/a+0z7dKqclKgg7hTJrKEPfdznePtGBsPByVixkv2wsMc?=
 =?us-ascii?Q?PxOP5hx2CCYGV3m0SQTsNX4k/wo1BRYItz4NkLEl4zHha37KkL6LoajceS9X?=
 =?us-ascii?Q?/cn0V6zbj3PZTBzrueSHeN0bpLRdjHx6H7fztHRk5ANlAxroszTata2vwlMY?=
 =?us-ascii?Q?Mwe6R6VRgL072/0iaGFFb/QsnBaflvwbgpLiAMVm6CwakeiFY0vQx4cpEkud?=
 =?us-ascii?Q?aO2PSFRVdQhIKkM03A+xJcttCYeAH5YenaCT4YCZ/qowS3D7usKeGKRXa7xm?=
 =?us-ascii?Q?IhjbQFoHp7gdLAhfCrOUC1/w0dQFS+s2/NxgkuGw9Q9cvFrGANnJ6LPqXSAl?=
 =?us-ascii?Q?IQjsKF04xBeJjf/sJwJXVdkKJZH4TQe1diFlQmPmkkgzXhEa6vJcPa0gJXIE?=
 =?us-ascii?Q?kVCJiNwfRfWl5mM6tDzVql9BifBHesgGJyZRF9ReeLUAsO5pAoNwgNA2xdu3?=
 =?us-ascii?Q?/ccNfg75poh8LuuAVLPDaA/ncQcMf1Vt5oFRTrdHi0d5IwKP2BqvzHE28cw4?=
 =?us-ascii?Q?O+E2EmJzIixqjMshTaA3Qkcp2f40UzJCW27EDx96vpj/2fxOQxrbcnTyus1i?=
 =?us-ascii?Q?ZFzFXueyP2DGJ5xVeQJqlzY4BMqkJKeABHi9xCEzwryHAwXpd2NckiWmV7uu?=
 =?us-ascii?Q?3gnWYiCpz254Zl6+/JkAVDXreCAFa+dCwbMW+pTd5crADqi/RyL7qL3CxbT0?=
 =?us-ascii?Q?g8/AwaiOybJNt8lLoeSqqr7N+j5UkIDhijgf5gD9+beKVthDpTI0nTC0cfHS?=
 =?us-ascii?Q?HKJxJOPxA21KRE1aKYaAzDENOG2pY/ZBlpC6+BfvHWAAmdzc+kmWsu1OsyBx?=
 =?us-ascii?Q?nBge5cWXSsDt591B8b0FuJK5X06exWw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcd0dad4-866e-4948-82b6-08da4b0347f7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 17:04:29.3078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8VbrwhkQrAsuj+YUgW6JuQPyaZHdV2oDNFMh9VUgsJNlmlgslc1vN6ANiSIungtjx68k6S0/OT0tkMti7xMCZLK20Cq0RzicoJLEZ48Ys8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2549
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-10_06:2022-06-09,2022-06-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=718 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206100067
X-Proofpoint-ORIG-GUID: dDImZV5_B23gud5D5mSKewSQx-7opz1i
X-Proofpoint-GUID: dDImZV5_B23gud5D5mSKewSQx-7opz1i
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver additional EDiF bug fixes to the scsi
> tree at your earliest convenience.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
