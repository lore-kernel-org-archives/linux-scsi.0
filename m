Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBECC001E0
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Jul 2023 20:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjGIU3T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Jul 2023 16:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjGIU3Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jul 2023 16:29:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4271100;
        Sun,  9 Jul 2023 13:29:14 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 369JnGZh009377;
        Sun, 9 Jul 2023 20:29:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=iAbY5y7o82/70sJsy1uoPyr1tLG6IL64Fy0gZuvMIR4=;
 b=3FA2jcIr4ppqWg2yA44aWk+KJxXs/pynw05JCL8ZvSJ6Mm1mpn0Wr/FjgXS8VuB0x3Di
 ZOG3HDPX6xu7QVRm3WhJWfYt1t7GE9NEYiEEg013AOekPG58co8On7n7/K7Sk6FH1SMj
 EGOYya/2aARghZ+P7G6SovIeQ8uu0I94qrTJl4zMyOYy7zz/vz/4CDeRCJALa3vKO9Ix
 vWHukWWM4/w9sBGNumWFUaJb0LtY+a5UFbhGibd35d7enyr9morBKGtJAK/4CBHpbE9D
 Esh7QDrLp6C4kQ0nHfN4y423BQ8awWgrYLwDtZiSKvmYz8R2PWPlYZ7zSoKg6+D4tVcS eQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rq0bu1dfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 09 Jul 2023 20:29:09 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 369JpvKS006332;
        Sun, 9 Jul 2023 20:29:08 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx88y1wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 09 Jul 2023 20:29:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdagiHF+lJUgwPVEon4YQgB0jTofLytrhu4c344uUxzOBXrZRCtiSuhs8l8JKJmzPSQl2LTckSKvQve8ndxr7ONhnQuAfW6cMgrrg2UegXYLY0bGHkhDH6pqlQdrwhflUHlKRarng5PlY3aJLTXpop5djmgS7zUm+YBOncTsFS6gKLfNV5uaRvDeTNi3J429stHm//ScCUYRfHxQiL9ILoH5CuJZUWLgI2UVOxZCwlWXmwsRyPbogtHi9Te3GNSxrTNjSm83IOe2a3MUgfEUlNX541qT0U3J/huEPfeoNc/QsdH/D6LZOfKO1Ff1g4L0yMHkLM4NdAvJ4FxZVHnQGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iAbY5y7o82/70sJsy1uoPyr1tLG6IL64Fy0gZuvMIR4=;
 b=UIvZ9Q/+6eal1CGHVmwjzyY1pfEW2ktTCsCyh7berdEc6LQPiUdcKIsgugMBzxUGgPS8KxxAW/1vtoy6HuuSiwCTI0fqJ6+KE3jNMGCZfbgySdKSUMMjvJGIwvsIYmj4fx/1lf8w6BXu+VI4X3lbNlyU/9F+M2gMeksPwFQq5XvQPtUAHRv9ih/2r7bW3K4FECvGToGCZXErobxNG3tfvRRwl3ac6bTmPccYnpTWJidGEkOwtq7A1odSip/MZOWvQrf7icQHAljG8e2JNz40MoKSv1A2+B0rDf6VdGcueyk0esLwSDPA3/SS40mB6pCNAMihyUARQAaGe2IfzkUUYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAbY5y7o82/70sJsy1uoPyr1tLG6IL64Fy0gZuvMIR4=;
 b=f/nQcoeM/6FE2Xe5vdF9l2oC11xe0A+uuhMFlprGnuoYm1S714ONMFr8gfKwTEcMYADLnCskMc8ZI8STbZVtjM1X7U/eMZI6Pu/BFq7qEG6Glz/Z/fLpmZcBu4pH/uYNc5YcPWCxki9WBOd7LAHcgexmMQeXFC2c/9pm1o45leQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA1PR10MB5994.namprd10.prod.outlook.com (2603:10b6:208:3ee::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Sun, 9 Jul
 2023 20:29:05 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Sun, 9 Jul 2023
 20:29:04 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 1/2] vhost-scsi: Fix alignment handling with windows
Date:   Sun,  9 Jul 2023 15:28:58 -0500
Message-Id: <20230709202859.138387-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230709202859.138387-1-michael.christie@oracle.com>
References: <20230709202859.138387-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0089.namprd03.prod.outlook.com
 (2603:10b6:5:333::22) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA1PR10MB5994:EE_
X-MS-Office365-Filtering-Correlation-Id: f109e1cc-79d8-45ce-82de-08db80bb239c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DCflljbeorcyji0Jtq5sHEgPVHi9vx/ymUZIFkR5IBKLA4mZO4ICror9UuvRk2DU36YOl+S+QXAUmgCHzyrXeE4NZSgjAhIywLn9uhx5Ypt5u09pNO0GDqyeky6gMdAd8ni37hutWVwLyf7LKLcYG9AWa3YyssnGYU4XFs4utUy3Nfo+/Zcwf+0a3F8eyfwfqy1gjXitxvX7pNSckktKpM6BRiJvhbNgiZH/561Sm3TuuGOdRwfwpsrDhVVvK8x2zhF8iXyZPjvYLq3re6dFYHFEWEfU7IEQiUUb7isLQeu/szLoarG9io7F6IbLAsOKaL1sxT64XQsK3CDUsQQd+AvZ4J5JWqNg9bYD3gtE2/p8/wr2ayo0ONRE748lgQ8gM1u7rx4QRb+gEHtLGSsTwIEUPLL+G2rHU6ddwmHIB9Fw/dBitkQuCdUjZoXe5DWIkFhs0UfnFQyqhvt1n8wL3juZkMDGXUDJnzLvqdXRoarI+w+XbPDKmnxwFIGz/Gjnfo8JizrZ1tdi9AkFq3P/4JVTiE1sCtoEQLdqyCg6xnk1JXkvGfVz0ap+iXXBDAQR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199021)(86362001)(38100700002)(36756003)(6666004)(6486002)(107886003)(26005)(1076003)(6506007)(186003)(6512007)(2616005)(5660300002)(316002)(2906002)(66556008)(66946007)(478600001)(8676002)(8936002)(66476007)(83380400001)(4326008)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wp8TzV7pj8d2PSJAnaudrjvimXsERzbHyWy2U1zEiCCmtybIQVmCgIEenrYk?=
 =?us-ascii?Q?RYJEezYTvWvhEwp0UdA/dIhDtxOTwZWApigCLe5WT71osaYzdPq8TBmQ8gk5?=
 =?us-ascii?Q?nMAqeRrv3P9jHQf9yTDWXw/0jAfZPpEk4v5cO3HwNkDpyl5h0H0nm9Fv2xR1?=
 =?us-ascii?Q?+k+BNTQ7WolAQTzqSsVUt276OTZaCv0E03yeZQPALTnOK46yHiFd8Fx9lran?=
 =?us-ascii?Q?JlwqFmwYQF6iOmWi117VqUZW+e9p+FPx9AzK3JAa+D6E5HNJgCHtMIFetfxd?=
 =?us-ascii?Q?JFVC/eaAeJYk3O3zVo3cBBg7hn1wLdzzfDSHubd7YsX3FxN/Hf8cl1odR6AK?=
 =?us-ascii?Q?i0pSuVjIyA4/aAriAcfmNsGmcYipAbD3gMZcteJNouj3EfCffY+sr2o/EXem?=
 =?us-ascii?Q?mYvGEtrbTD0eKY8l5kU6qmMXGOCEbOGZI2i3eHupbJpsjlfyU8jnsnVLzBHm?=
 =?us-ascii?Q?QNAc6SEwcZ87kAiWvG8StxhhR9MlaB9qxGGLnnwxrnysZUdpGnQx5N9MkXT2?=
 =?us-ascii?Q?elzXTAoHMobyRc1gs3BF588+jrzBcT+YWGrQS5O25otBDR1st8DEWa2Ow5HT?=
 =?us-ascii?Q?YjhB1ZSnPRjJgyl+xYZZW0UqNRGV3W3AvzYIweVxVmseX7w3EukTh9K8hk27?=
 =?us-ascii?Q?G6YdFXAVUi7dfy5kI9WCvxu+LmB5aK+17zzWQZEb5u6TGu9o/9vLuAYj9Dl6?=
 =?us-ascii?Q?QwewSMz0Wp8PTCjin7AVPnzM1aVT75MWTi191yKNqp2Zgui1rRlIsIR+awVQ?=
 =?us-ascii?Q?pQ7ohVfNHalgcyfG2SakF+hLcEMS+e08X8fTyYsiNfF/h8fOncXwu5hEMprl?=
 =?us-ascii?Q?fWfPphzuOCtullgWuo2J65I5C1MrTmC99U0g1PVHbhZ36U/E4mT9c+a5rujY?=
 =?us-ascii?Q?V/bSGowpQadWNitaNIK5BFXEOSqVnYW/A/PEo20py9kzDuAynNQ0T6NtjMzK?=
 =?us-ascii?Q?ckPywWDnNkzVrfQSFLzuCL6wVn3A18jO8/FTaYAKk9p5PBHArdHJeQvTioRB?=
 =?us-ascii?Q?Ocn5CBQ4Im3XWdYJ5RqM1YAp+IQJnKkXshGIrrJ34ShY/a9xFcHVMrLwAA5F?=
 =?us-ascii?Q?Y9zb3Zskrrx/WElLmDkD8MDSGIQZG1zyhMybmJ8HPkRQygnR4MX7M60HqQ3A?=
 =?us-ascii?Q?COsEPcy2lHzFyW3Vkt7t9UQgEleCv0cCO9QoqEuEC4P1DfwVO7UKNdxmA7Ho?=
 =?us-ascii?Q?dM7E4nm00wF4PgVZAVLnC8EXJ56JwWtvmviqEv499qslFqOqK+BHA+GsTPl8?=
 =?us-ascii?Q?WDEnvd8UfNhd/cOjR60eL2LS4uLatAF2UR0HMHif3H9Ae1+4FieClKBqrPer?=
 =?us-ascii?Q?gPvl09mnwMhbeNgry3gx1WN5o4ituj30/27oHXhT8qMpfEkEhCdkL7nUrKpq?=
 =?us-ascii?Q?fHXC1jnS5Jrdnp4eoKeM47V3wcXTkRZBycxYOGXS7XFYEClbT6S4yOOxcYOD?=
 =?us-ascii?Q?pfVUYgJKxzc7Yyzh35/F7kmAy6GhtiLVKOc1CQ4H1RwCqzFswMv3CwuTAo8B?=
 =?us-ascii?Q?9j7lPtaz/Dde14q16/C4A4ugP5882k03PBVJFP33PrbroKf371uWmIbHZTFH?=
 =?us-ascii?Q?9z81+IZJeaYqnYWtjG3dASCwLpAvq3C5Y3djiSmh+drqkuBScUbFkhU4RARU?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gYrWDVeVnwLW2ptnOlnWU9g7xoJi1QsE+u/klKIKdqR7yjKB30EVGwSv2CrC68f1ViBo8orUl0wf8svog5u8gQTPERSoEojqKJLDpcVVtO6ADo1Vr5Uf6Bxk3QzuXgEst33BHSXjn6yZ09ShM7P8HbbdfmEubonk/xJAbNKtFqnmwnbFGJG9bPv3Q7K8n3TLuxL/p2eGn7MmPuX9a+7ITKyG+DsBl1lAQeBmZRvO7qsZKVR8UNrufdu3yns0gSC3kz1PvZNtbYRLF/IFyL1qu5mVQck8XRMTRSiWoNh2lLRNCLh2FZIVATUO51bEldY+gv4XJS+cHE7VCIYmCnZ65yEunEpXWNajhIN21N7AqWDZ7ADr24Yqu126HEsQNOujTvYjFyNsFapIvmvFY0nSiOhNKGb+uwLVdcMiMP1nQvV8pq1OCBOmPKGdympfBKfSvgqFq+XYbbRdhij236Z6U5OFq9zkLYIybOZQ58XKS52fSnwGwF3MwsC7w9eeQchQZx8d/jArxlykUZpBrmQ3JjPveGj9wW7U21uh39702M898MldvwgntDolCacqCIU/3dapNftacL5RCt2ep6TlmEqrztiU8GCJ0cT1VeP96fMJFWPnpEwfoqPxkxGlKgp0iGo8H1JMdFBd2xwie4m1TaMViBlVL7LM0FOkHl+7ek5PyFDtMse4HnXyU3siI7QbcpzGXqf3xoyGJ6rONMVY3W0kkZZ8RinHaB60IK/MHLvYhmN2+mn6hu54oLhZJVI7R8u3+3Oi1/jxbEqld337IyaZm4sh5HIhNnON2ImK6j0fiHPa70de+epoh86gLDDgNsaan5cJ0aiOla/05Us/gzzKpvTUfZmewTmAHyqh67k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f109e1cc-79d8-45ce-82de-08db80bb239c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2023 20:29:04.9086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fKT4UOF5IezF6fY2+9H4PaA4v29slDLrOkMsu3WwuUsIpjSi5Ubl6xX03W3RbTSOUEvKtcTvUlEDtTUkMKFHHt83PArcU+AG/U8+lY5ZejA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5994
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-09_14,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307090193
X-Proofpoint-ORIG-GUID: zJTIETHOUd8FEGjQukDfEJoRl_q8FX1P
X-Proofpoint-GUID: zJTIETHOUd8FEGjQukDfEJoRl_q8FX1P
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The linux block layer requires bios/requests to have lengths with a 512
byte alignment. Some drivers/layers like dm-crypt and the directi IO code
will test for it and just fail. Other drivers like SCSI just assume the
requirement is met and will end up in infinte retry loops. The problem
for drivers like SCSI is that it uses functions like blk_rq_cur_sectors
and blk_rq_sectors which divide the request's length by 512. If there's
lefovers then it just gets dropped. But other code in the block/scsi
layer may use blk_rq_bytes/blk_rq_cur_bytes and end up thinking there is
still data left and try to retry the cmd. We can then end up getting
stuck in retry loops where part of the block/scsi thinks there is data
left, but other parts think we want to do IOs of zero length.

Linux will always check for alignment, but windows will not. When
vhost-scsi then translates the iovec it gets from a windows guest to a
scatterlist, we can end up with sg items where the sg->length is not
divisible by 512 due to the misaligned offset:

sg[0].offset = 255;
sg[0].length = 3841;
sg...
sg[N].offset = 0;
sg[N].length = 255;

When the lio backends then convert the SG to bios or other iovecs, we
end up sending them with the same misaligned values and can hit the
issues above.

This just has us drop down to allocating a temp page and copying the data
when we detect a misaligned buffer and the IO is large enough that it
will get split into multiple bad IOs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 186 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 161 insertions(+), 25 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c83f7f043470..324e4b3846fa 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -25,6 +25,8 @@
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
 #include <linux/miscdevice.h>
+#include <linux/blk_types.h>
+#include <linux/bio.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi_common.h>
 #include <scsi/scsi_proto.h>
@@ -75,6 +77,9 @@ struct vhost_scsi_cmd {
 	u32 tvc_prot_sgl_count;
 	/* Saved unpacked SCSI LUN for vhost_scsi_target_queue_cmd() */
 	u32 tvc_lun;
+	u32 copied_iov:1;
+	const void *saved_iter_addr;
+	struct iov_iter saved_iter;
 	/* Pointer to the SGL formatted memory from virtio-scsi */
 	struct scatterlist *tvc_sgl;
 	struct scatterlist *tvc_prot_sgl;
@@ -328,8 +333,13 @@ static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
 	int i;
 
 	if (tv_cmd->tvc_sgl_count) {
-		for (i = 0; i < tv_cmd->tvc_sgl_count; i++)
-			put_page(sg_page(&tv_cmd->tvc_sgl[i]));
+		for (i = 0; i < tv_cmd->tvc_sgl_count; i++) {
+			if (tv_cmd->copied_iov)
+				__free_page(sg_page(&tv_cmd->tvc_sgl[i]));
+			else
+				put_page(sg_page(&tv_cmd->tvc_sgl[i]));
+		}
+		kfree(tv_cmd->saved_iter_addr);
 	}
 	if (tv_cmd->tvc_prot_sgl_count) {
 		for (i = 0; i < tv_cmd->tvc_prot_sgl_count; i++)
@@ -504,6 +514,28 @@ static void vhost_scsi_evt_work(struct vhost_work *work)
 	mutex_unlock(&vq->mutex);
 }
 
+static int vhost_scsi_copy_sgl_to_iov(struct vhost_scsi_cmd *cmd)
+{
+	struct iov_iter *iter = &cmd->saved_iter;
+	struct scatterlist *sg = cmd->tvc_sgl;
+	struct page *page;
+	size_t len;
+	int i;
+
+	for (i = 0; i < cmd->tvc_sgl_count; i++) {
+		page = sg_page(&sg[i]);
+		len = sg[i].length;
+
+		if (copy_page_to_iter(page, 0, len, iter) != len) {
+			pr_err("Could not copy data while handling misaligned cmd. Error %zu\n",
+			       len);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
 /* Fill in status and signal that we are done processing this command
  *
  * This is scheduled in the vhost work queue so we are called with the owner
@@ -527,15 +559,20 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 
 		pr_debug("%s tv_cmd %p resid %u status %#02x\n", __func__,
 			cmd, se_cmd->residual_count, se_cmd->scsi_status);
-
 		memset(&v_rsp, 0, sizeof(v_rsp));
-		v_rsp.resid = cpu_to_vhost32(cmd->tvc_vq, se_cmd->residual_count);
-		/* TODO is status_qualifier field needed? */
-		v_rsp.status = se_cmd->scsi_status;
-		v_rsp.sense_len = cpu_to_vhost32(cmd->tvc_vq,
-						 se_cmd->scsi_sense_length);
-		memcpy(v_rsp.sense, cmd->tvc_sense_buf,
-		       se_cmd->scsi_sense_length);
+
+		if (cmd->saved_iter_addr && vhost_scsi_copy_sgl_to_iov(cmd)) {
+			v_rsp.response = VIRTIO_SCSI_S_BAD_TARGET;
+		} else {
+			v_rsp.resid = cpu_to_vhost32(cmd->tvc_vq,
+						     se_cmd->residual_count);
+			/* TODO is status_qualifier field needed? */
+			v_rsp.status = se_cmd->scsi_status;
+			v_rsp.sense_len = cpu_to_vhost32(cmd->tvc_vq,
+							 se_cmd->scsi_sense_length);
+			memcpy(v_rsp.sense, cmd->tvc_sense_buf,
+			       se_cmd->scsi_sense_length);
+		}
 
 		iov_iter_init(&iov_iter, ITER_DEST, cmd->tvc_resp_iov,
 			      cmd->tvc_in_iovs, sizeof(v_rsp));
@@ -613,12 +650,12 @@ static int
 vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd,
 		      struct iov_iter *iter,
 		      struct scatterlist *sgl,
-		      bool write)
+		      bool is_prot)
 {
 	struct page **pages = cmd->tvc_upages;
 	struct scatterlist *sg = sgl;
-	ssize_t bytes;
-	size_t offset;
+	ssize_t bytes, mapped_bytes;
+	size_t offset, mapped_offset;
 	unsigned int npages = 0;
 
 	bytes = iov_iter_get_pages2(iter, pages, LONG_MAX,
@@ -627,13 +664,53 @@ vhost_scsi_map_to_sgl(struct vhost_scsi_cmd *cmd,
 	if (bytes <= 0)
 		return bytes < 0 ? bytes : -EFAULT;
 
+	mapped_bytes = bytes;
+	mapped_offset = offset;
+
 	while (bytes) {
 		unsigned n = min_t(unsigned, PAGE_SIZE - offset, bytes);
+		/*
+		 * The block layer requires bios/requests to be a multiple of
+		 * 512 bytes, but Windows can send us vecs that are misaligned.
+		 * This can result in bios and later requests with misaligned
+		 * sizes if we have to break up a cmd/scatterlist into multiple
+		 * bios.
+		 *
+		 * We currently only break up a command into multiple bios if
+		 * we hit the vec/seg limit, so check if our sgl_count is
+		 * greater than the max and if a vec in the cmd has a
+		 * misaligned offset/size.
+		 */
+		if (!is_prot &&
+		    (offset & (SECTOR_SIZE - 1) || n & (SECTOR_SIZE - 1)) &&
+		    cmd->tvc_sgl_count > BIO_MAX_VECS) {
+			WARN_ONCE(true,
+				  "vhost-scsi detected misaligned IO. Performance may be degraded.");
+			goto revert_iter_get_pages;
+		}
+
 		sg_set_page(sg++, pages[npages++], n, offset);
 		bytes -= n;
 		offset = 0;
 	}
+
 	return npages;
+
+revert_iter_get_pages:
+	iov_iter_revert(iter, mapped_bytes);
+
+	npages = 0;
+	while (mapped_bytes) {
+		unsigned int n = min_t(unsigned int, PAGE_SIZE - mapped_offset,
+				       mapped_bytes);
+
+		put_page(pages[npages++]);
+
+		mapped_bytes -= n;
+		mapped_offset = 0;
+	}
+
+	return -EINVAL;
 }
 
 static int
@@ -657,25 +734,80 @@ vhost_scsi_calc_sgls(struct iov_iter *iter, size_t bytes, int max_sgls)
 }
 
 static int
-vhost_scsi_iov_to_sgl(struct vhost_scsi_cmd *cmd, bool write,
-		      struct iov_iter *iter,
-		      struct scatterlist *sg, int sg_count)
+vhost_scsi_copy_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
+			   struct scatterlist *sg, int sg_count)
+{
+	size_t len = iov_iter_count(iter);
+	unsigned int nbytes = 0;
+	struct page *page;
+	int i;
+
+	if (cmd->tvc_data_direction == DMA_FROM_DEVICE) {
+		cmd->saved_iter_addr = dup_iter(&cmd->saved_iter, iter,
+						GFP_KERNEL);
+		if (!cmd->saved_iter_addr)
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < sg_count; i++) {
+		page = alloc_page(GFP_KERNEL);
+		if (!page) {
+			i--;
+			goto err;
+		}
+
+		nbytes = min_t(unsigned int, PAGE_SIZE, len);
+		sg_set_page(&sg[i], page, nbytes, 0);
+
+		if (cmd->tvc_data_direction == DMA_TO_DEVICE &&
+		    copy_page_from_iter(page, 0, nbytes, iter) != nbytes)
+			goto err;
+
+		len -= nbytes;
+	}
+
+	cmd->copied_iov = 1;
+	return 0;
+
+err:
+	pr_err("Could not read %u bytes while handling misaligned cmd\n",
+	       nbytes);
+
+	for (; i >= 0; i--)
+		__free_page(sg_page(&sg[i]));
+	kfree(cmd->saved_iter_addr);
+	return -ENOMEM;
+}
+
+static int
+vhost_scsi_iov_to_sgl(struct vhost_scsi_cmd *cmd, struct iov_iter *iter,
+		      struct scatterlist *sg, int sg_count, bool is_prot)
 {
 	struct scatterlist *p = sg;
+	size_t revert_bytes;
 	int ret;
 
 	while (iov_iter_count(iter)) {
-		ret = vhost_scsi_map_to_sgl(cmd, iter, sg, write);
+		ret = vhost_scsi_map_to_sgl(cmd, iter, sg, is_prot);
 		if (ret < 0) {
+			revert_bytes = 0;
+
 			while (p < sg) {
-				struct page *page = sg_page(p++);
-				if (page)
+				struct page *page = sg_page(p);
+
+				if (page) {
 					put_page(page);
+					revert_bytes += p->length;
+				}
+				p++;
 			}
+
+			iov_iter_revert(iter, revert_bytes);
 			return ret;
 		}
 		sg += ret;
 	}
+
 	return 0;
 }
 
@@ -685,7 +817,6 @@ vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
 		 size_t data_bytes, struct iov_iter *data_iter)
 {
 	int sgl_count, ret;
-	bool write = (cmd->tvc_data_direction == DMA_FROM_DEVICE);
 
 	if (prot_bytes) {
 		sgl_count = vhost_scsi_calc_sgls(prot_iter, prot_bytes,
@@ -698,9 +829,8 @@ vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
 		pr_debug("%s prot_sg %p prot_sgl_count %u\n", __func__,
 			 cmd->tvc_prot_sgl, cmd->tvc_prot_sgl_count);
 
-		ret = vhost_scsi_iov_to_sgl(cmd, write, prot_iter,
-					    cmd->tvc_prot_sgl,
-					    cmd->tvc_prot_sgl_count);
+		ret = vhost_scsi_iov_to_sgl(cmd, prot_iter, cmd->tvc_prot_sgl,
+					    cmd->tvc_prot_sgl_count, true);
 		if (ret < 0) {
 			cmd->tvc_prot_sgl_count = 0;
 			return ret;
@@ -716,8 +846,14 @@ vhost_scsi_mapal(struct vhost_scsi_cmd *cmd,
 	pr_debug("%s data_sg %p data_sgl_count %u\n", __func__,
 		  cmd->tvc_sgl, cmd->tvc_sgl_count);
 
-	ret = vhost_scsi_iov_to_sgl(cmd, write, data_iter,
-				    cmd->tvc_sgl, cmd->tvc_sgl_count);
+	ret = vhost_scsi_iov_to_sgl(cmd, data_iter, cmd->tvc_sgl,
+				    cmd->tvc_sgl_count, false);
+	if (ret == -EINVAL) {
+		sg_init_table(cmd->tvc_sgl, cmd->tvc_sgl_count);
+		ret = vhost_scsi_copy_iov_to_sgl(cmd, data_iter, cmd->tvc_sgl,
+						 cmd->tvc_sgl_count);
+	}
+
 	if (ret < 0) {
 		cmd->tvc_sgl_count = 0;
 		return ret;
-- 
2.25.1

