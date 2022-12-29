Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0136C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiL2TCk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233693AbiL2TCL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:02:11 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98E6D9A
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:02:10 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIx0bF001931;
        Thu, 29 Dec 2022 19:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=EpbumOlYD82MDV9do+Lz0r0AgQaHarwknR6upss1bHM=;
 b=2wSabdKeSzsPStgoQVcAanb2isL1HxeJoqYc5Xg9w5VFuz1FEd/Wah1qOPZHCbL3hjD9
 qJ9RSXmZmQHOBOXLhLc1iuJhcyY6kNIuZSUgjeRo/EgY3H3b5bS4qASek7HIDrdfhr7x
 pQ/3OtnYTN06xjUVBtZErIlTAlzRu4u+rwj1Hav1w4ieime3Vq8kifF2VWPT9GbrV+Vq
 ShK4ehjpm8LBkx25AFnm2HxtAWKr4jlFEyEQ2vGLxSlStUwrFP0WSHq+QTghuq3693E2
 PsHjlQ7RXjFLtLuSx08Cg3QOlWYAVA18kpTly57uQo2ogl8+9rfyUQnfKuw1d5GM+Vfr Rw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnsfcfa82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:01:59 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTI1VhH001432;
        Thu, 29 Dec 2022 19:01:59 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2043.outbound.protection.outlook.com [104.47.51.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv7982u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:01:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuUB67uKoUiDXq1prDUNgrifY6cmX7JaJXbu0aMFLBjG9W81fSimp6zm9GgK1FBBSon/jbUTWcjl58DNPS44fUcVKnMcjtWI8d4ZEVjp5UIMjecF11JbPLKZ1xuh/KRHTuuIjKYjsp5IhBfNIcWuse1PnuQjfnR0p1LAYN02oNSyoVL5aAc0oGzklBv2SeP+kTYUyXp60B3MubB8afB9GDcD0zRW72YTSbMd/S7ICD6qBLUOWaXizhiOMfqkd36xB8J0xBOpmLL8CUlyYvBbYyKX1SvwMoHkDzujuNmh+RnasijJWHjzDPGlTR6+HbTAutRi5HlJbAkMb0C9scQGJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EpbumOlYD82MDV9do+Lz0r0AgQaHarwknR6upss1bHM=;
 b=nm+qQKQc2GVn31eLV84wLlUo/DGxhqzTITSectrwz46OW/t03S9cri9osIBqfuKqCIhu5VF4Rrt9yY9FkdjQBvFexamFJ55L5HMAfURXbT5rKhQMgKThPW1ckUxrKyA9a/hDawyjSXjwt4JaAaohbboJNS8mpw/tyi0h+QDuJv0iiZE/1qySj03Pm0wHM87vZMbarKLdt+gL715obb90EPwPYG191ru4jbnN05m+Dne51UjqR6oTmv79wQzjphCeVy1xOCF4c+HhAMHkVYFJWGdEnRPQRtdQzXaGsFg/HMUGZj0VUKstteH9vWu+AYpZcQKqG5KxNnI+/USHr5GmwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpbumOlYD82MDV9do+Lz0r0AgQaHarwknR6upss1bHM=;
 b=CS+cq1lma9Z6qcBbX+lDiNKHjdSkh+epCIsaUul338ghLDCTSAQCSUrjYvEpQjeZ74bZPhyEKmWr6PeDjV6A61inj2SJqMkBo6yzIlX3nhg1+utH8A7Bu8k9lr8nozttRRIT2wLx1HrDLhJKqxdXDs98eRwrAW1ifTauaRZVE+k=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:01:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:01:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v4 00/15] scsi: Add struct for args to execution functions
Date:   Thu, 29 Dec 2022 13:01:39 -0600
Message-Id: <20221229190154.7467-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0392.namprd03.prod.outlook.com
 (2603:10b6:610:11b::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: 82bbbc57-b97d-4c50-0c64-08dae9cf2874
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YnzFCnIy4DerZMuKA0E3SLW/EC71xWSK3OksBG78kBbKBA+ilac+/Cd+f+srPbLxcqysFyX8ynj0XSY+dZS9YxrkKVkof1so481dHDNTvK7COtI6TLnTMeiBEVVObEKy8LHL2tuzTx1W8fjeNWP5k13Dud9WAhPYwykNKG3WD4FZz5gYgpjTruKv2ObnSxn3zQY93eRdOvKXcTswdn4RuRBTzGnlJyXP7i4He/I9u+XlOiDHYTABng1rrrKQ1DJzJizNuFsnMkAblDio8d/PNYJdmzYC6w6BFRkUQCwiDTLDlQNdwjQFqTkiLFlmUk1tSQnZUVBKXsYnRQ9B4QiJi6fJf+BVy+LHXeJek4i/0vlLlDY0JqypWsoZUHjSLZm1+k6nIFuEGLmuSNqrSIuf/O8MSQ+OjYIhixIjl9hAQqr7GPgwpRZaFQalTdykzmkG7KO7/QTF5h6vQlLkUtGOZv0Hs738tfVaSrJ/ZViSFyZGFEVfkS02UhsQ2QETSwpsRP6m6Om7zsIxHzOVIoJa3b7Q9TiOtHTtYVe1fBbD6XIXmim4l+rdD7IlybxYHOV3+g9g0E5CgrbkilSjdRY31VV9hLd6P0Pnq8oo01uRfhkFT4macZJE8r0Ro+2YKeL6wKgrZS5jwQddkYZMKm9pXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(2906002)(38100700002)(8936002)(41300700001)(4744005)(5660300002)(86362001)(66476007)(66556008)(66946007)(6666004)(478600001)(6506007)(1076003)(316002)(8676002)(6512007)(26005)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mTitzcf3Q/Wt1naWKD+WKYXz4gL3uagCOIGyRrgu9DRFIBv3iZNYNm1rp7C+?=
 =?us-ascii?Q?8jbokeMrye5S4AqLa9AAtXcbnMMkjCBFCla0JZaTrjWyLnVrausxhOv90JMQ?=
 =?us-ascii?Q?nAu1J3fk9VDrWgMUk3GLtLb3OmIWHMNZ7teByfyHfAFKCE0Qk7ScHN+vdUGJ?=
 =?us-ascii?Q?Fqi7UAyAItmxBsVaLA64BLHcMYpQV3WgfsMbzYbdNnblAPAmUNDJVRXp1IRo?=
 =?us-ascii?Q?gvlLMmeaWG1eWiaEOpqG3amVDgHpyOTRq7GZKAxr36Wz1wW2QLm+wzhAHP0q?=
 =?us-ascii?Q?a8Z77iuCUF0oDZSZ3zUA33ieRgWTdzr3ya3rVIWTCsZBNW8l3wA+2BMdubUF?=
 =?us-ascii?Q?yHOhk7HOZGEUeIayfBM8Ct6g5iJB9oZVbJEniFhfUAakJJHZcLJOHaHkCOSG?=
 =?us-ascii?Q?HXo9roOlKQ+eDSw/76aYb+39y9BkhYK9P6RaRXpv7OyYrrMm6peIk7CNJzIU?=
 =?us-ascii?Q?LscbRt8ykmTeooXhTlOsGOtv2QQRf68I6f9dvLFU/Um0Pdn0UY7RAYdTbgv+?=
 =?us-ascii?Q?u8VZBnRfkNnKRyj+4OOlfGRzl+B/rmIQk2zl2puoyyZY/fFHckGHQpII4Q7l?=
 =?us-ascii?Q?loDsA8Us5C38smR7s6TkU11Egd9pMR/KR4EQ5JqCwWSw9m4Lf6ub23Dukd3w?=
 =?us-ascii?Q?ATng3ANvmtH9g7511ecFz7NO6i2qHtWn9FT/xLV1IVCOrkt1+G3GxnK4aAvS?=
 =?us-ascii?Q?oNMoIkVLmFvnZvXgFlHufuicF5sZ+7lKnAzOANokb16q7TG6DwjF9UVJavDh?=
 =?us-ascii?Q?aJOD4eYCSuqYgEdUD2DHNDu6tjsKvGTwbc2fmoaw6dsqmi2/FgWpO8hbzv7Z?=
 =?us-ascii?Q?+d3fk6H5hRc6DWCVSKUZDwqBZxBEafx8azUF7BUl3iZwYYSPzQqFzQHP1OpA?=
 =?us-ascii?Q?+4i917lTXIXAb/CoERGXVP6TI8X1LZJlOXDjTMiBbh/dKqBEAiRwswXEGJC1?=
 =?us-ascii?Q?/3jBu3nJhOoM4DjB4k6P7Q1RAuoF+7vDKnfqd62s9Z00gbWIMl/bnwFuWWd1?=
 =?us-ascii?Q?JOQVQoaoGkvA1vJFBpUxIIwbafh1fNDeqs8AcZe/rldRmPfzElmd6z6t/JRm?=
 =?us-ascii?Q?XGzc6nnQG9u1Ey2xm62KuuflHcrLeuxqugvqwZ32ckbSDhVUpeJhsZI2ty0G?=
 =?us-ascii?Q?0UiOg2GCJ5URCZBV1rcmqxKFVpJXIHYRk91dQU+nl60JCaJt/8za9vl9FcKD?=
 =?us-ascii?Q?57fJ90kfliNuDAsIcCuXnMwtxq8UkwOe6T7UPF/RAUQT71ptULJlBja2kIuX?=
 =?us-ascii?Q?ZkKBPn/E7Z+2qh2SfdnKrh7IbAGTvnuTLNrEyHgQpHV88oemr+0Y+9mFc7A9?=
 =?us-ascii?Q?fvuge0Rq0qMN/cOtd27WJCyfvHQNq6xtjeqZWOkIDUNZ8SS85Ul62957TT9X?=
 =?us-ascii?Q?fhSnTfqCSbi4Fj6KT09iN9Q/Cydny37g3kOu7ZYROKwxGNWm2qnNCL2lAx9p?=
 =?us-ascii?Q?SNjtDzFMoFr+t0PNswQHgFWQpqeSGjNVKkz03qWtF0Nel/qYNqxOMTbsVQYh?=
 =?us-ascii?Q?DEMSo9MrjyuRvwq8wz51FzFf5s3QzXoaGjhqC+YM5E5/6M0Z39rUtYXkU3m3?=
 =?us-ascii?Q?3DetN2x4g4WzmGoBuk/lQU+4T6dao3a5xYwI14A9XjRsMZGaD1TPSbcV9vy5?=
 =?us-ascii?Q?1g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82bbbc57-b97d-4c50-0c64-08dae9cf2874
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:01:57.3479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDaBI9s/xbSbsgwZflcdSxbEyEdbRQZso1jlgvUYhc0E+SuqWWD/rfliPniYyGpgFiCrsyxOp4PWO8gQIV0krfcyJi8t78rFa/hoAKMH3Tw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=948 suspectscore=0
 phishscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290157
X-Proofpoint-GUID: jVd86eie8qHg-NdUmCTNPzDdAWrYkEBe
X-Proofpoint-ORIG-GUID: jVd86eie8qHg-NdUmCTNPzDdAWrYkEBe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's scsi staging/next branch.
They add a struct that contains optinal arguments to the scsi_execute*
functions. This will be needed for the patches that allow the scsi
passthrough users to control retries because I'm adding a new optional
argument. I separated the 2 sets to make it easier to review and post.

V4:
- Fix patch1's description

v3:
- Init scsi_exec_args user's sshdr as "sshdr = sshdr ? : local".
- Use just one sense_len check and remove the scsi_execute_args wrapper.
- Just use one scsi_execute_cmd function and have it check if the args
  is NULL else use a local one.
- Pass exec_args by pointer.

v2:
- Fix RQF_QUIET use.
- Use the more standard way of passing in a struct for passing in
  the scsi_exec_args struct.
- Pass a struct scsi_exec_args instead of pointer and add another
  macro for the case the caller doesn't want to pass in a scsi_exec_args
  struct. Then remove the NULL args check in __scsi_execute.


