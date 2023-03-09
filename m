Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C0BC61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 22:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjCIWeo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 17:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231408AbjCIWeH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 17:34:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE52EF9ECD;
        Thu,  9 Mar 2023 14:33:52 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329LxEk1006464;
        Thu, 9 Mar 2023 22:33:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=chMr/Oq5Jbs0LvFD/FAENLg6xQxMrwm0Fp9h0/zAc2Y=;
 b=y3jLqvDgo0Vn3U0/hXjbEGX8f+HI+oWdBkDBn0EQaX98t3s/Sx/y7F/mbob0ThE37Uhh
 8H3QEZRMpmYvl/NZeewZ623NbK3lOImwcwoU+BNKzd35Dx0yVFuML3f78k0bNyEI9lqK
 YDmKc3I8fiYTdaJtehDlHWYvD+OpG6ix1wsy86egB2/GWJ5xOClcn2UYSnlF3J2N6msP
 rB6uM0qbaaFtd4/djXo7HePaaaOAlTqgCyW9z6amsEMK5SIpgCSd46pDB8AFIBemphnV
 bfQlv40VCsv4+goo53zHTkgU5nL1RmPx80uVJFCq2wrPQHhDwH3mWAAYJCYyHcfOwmQN Ww== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn98bpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329Lf5BA020892;
        Thu, 9 Mar 2023 22:33:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fua4rk2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 22:33:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H63T6Mlee8MTeSZVtA4b90C7YqoknkCq5g7TJGUk2ydjuqLilQr4vx1I41uRGUh4br3sactL/QlsSGmh8bvYhoEb9KsmJO28p14JzhnAl/zQiY49wMdRWkTF4Q1QxylMdxxT/do9p5BBAfJ34fqgikjKyqFcFxkCqx0H6k6N2t3eRsdm0VSJihQZlHgktrxmTYEAD79sxv6TwiaFQOKro6twX/+Yacya2uedyddHI5FjnIHKBnpnq7UabxSQPTh3cePmQur12eZBVpT49TtCi2mCAli+05UIs2IVVgmwaFhy5hx7acffBx+ml4U3q4V0Bnds3vkwLrhWUkWl1wjwyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=chMr/Oq5Jbs0LvFD/FAENLg6xQxMrwm0Fp9h0/zAc2Y=;
 b=EFM/1t5tQ4ul1ss+8917oHoFS83I5X0C/drtaJU98/KqHRkOZgMyIjLuBqKs7mjv8BZiVUIQNtiweVqHj3dn7zQni8f90Si/Ik9Xyci4OEU7hvs9sSHva1MUdYvmZvP5DbYxZkGmYmGGMQKPbKNt1XJiaaga/RqRvz5bkY6kOd4IShxRA4uKjW7CV0nAS/lmAm+0MzQswK7OP7xydLH6B5h2ulAUVqrUKvejkEmgozhOXYCWrmBRpefIRaplpB2BqvXl5lJRKdd6vt1mfox6Y/pbe9Mc3bxnuvytssGicQAo48jv7aIagoSzIyJ8xdb2Pr8rflIQ0lyk3YL6ysvjWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chMr/Oq5Jbs0LvFD/FAENLg6xQxMrwm0Fp9h0/zAc2Y=;
 b=ZUwzZbOmw1WNg+jlIZnaaHu7tvRdwDV45RzzWRNE6jQL5gjJ0waf4NKBzt8TZxsyDn+VxojPmZJWuhoqDVkHfpIWOmb8O4qDPhvMdmETa3iSUmBeGz/dVEhNtfqEeC6KkCxH6Tz7M5UTlJ08EGmMQt0N4d/+dQ8bjcsnM2rqNj0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6782.namprd10.prod.outlook.com (2603:10b6:208:42a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19; Thu, 9 Mar 2023 22:33:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 22:33:38 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, d.bogdanov@yadro.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 16/18] scsi: target: drop tas arg from __transport_wait_for_tasks
Date:   Thu,  9 Mar 2023 16:33:10 -0600
Message-Id: <20230309223312.94595-17-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230309223312.94595-1-michael.christie@oracle.com>
References: <20230309223312.94595-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:5:40::36) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6782:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b7854f7-6e63-4b94-9101-08db20ee53f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 43XY8GeHEf1bMLv3AJUi+NUP+7Ac9lqkjYwl/MY67t5osg7jrq7GCAUBilvjoQu/CKeukd+IN6nxB6VXIfJaSBx2WtDaYpFKycFS554RU5JIVPbunFnd9hz+N6swkAAjOKh9nnd/HWxKXx+sz2FwSnv4P/AXvbtBH/Ucb+PWLLvrcuanuo9iljibsErVtn1fxSiXkltri60u5pRvjlmwLSX5aSsoiiPuN5FW0I0nKFzeCYxJG4NtNHDbJDQGIyKSwQiMGUh7qUyA5UyYBucsbAmp9Qs6DfeoreDc4vmdBshxMDMlTJHhA5DtXLcNKVusPTAcH7XVP+ubRDJWGMhA6m+O9fEbQfSYrWdf7LvXSIvzq+UpFCPM74qeiCRrb9FUS+qoDEy709mKYa1vB5kw4/JDBLTVWFfzxTFn6Ra0yzm8fPHY5ysmI9Dp3LhrK+NRJoaD9k79tGRb3bW1dH7CmHpWd+n8UtO8lmPCDJmwUfOp/Z1p/0IKK6dcs1O5LSKYPju1hxoHTq1Q4ZH9rpFsxIskwTPGKSYVqwtaXFjGaomGZbiTzrPmSaw2TDGRW8C+Nn0UhBe/1m3b7dfj5/qw9TyNKJa1HjGGYixOe/y+vIMOqtuBN6ONrR7fGqj21MHVLqcKJiw1bCTV64p34vCTUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199018)(83380400001)(36756003)(478600001)(316002)(38100700002)(6486002)(2616005)(107886003)(6506007)(1076003)(6666004)(6512007)(186003)(26005)(5660300002)(66556008)(66946007)(8676002)(2906002)(41300700001)(66476007)(8936002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mnz7ck2nbqKeo2IdEXT0/Lf29RrVogUhaogHrVNMVFLZz5lYCAKE5j/p+03b?=
 =?us-ascii?Q?1JKrUvZvDFK6pBxaxByFOfA50Bqh7bYRwLy0t6nePjx6dSPKjHzYxGM9VBEG?=
 =?us-ascii?Q?vcrgbFjOJlRejsMkPHKyD4nz7YuURp26cQstOYI87tqcb3IAn2MlA0Cu4/sv?=
 =?us-ascii?Q?0+lSLL/+O6wezQ0KqwJav0aolj4vLIKEmptA70KUsrqK6aEfN55veS2Wup4l?=
 =?us-ascii?Q?ma7fI7k7YT/9GykOtO4lQCwz9dinEsYasdwvqHHNKYozL/z70peKTFQ8Aq7H?=
 =?us-ascii?Q?tQl0FRB7sEqutlkSy+do8Yf9Ke2iTKzJHESwOseuQx3ze4/3r1z9NyCwWb+B?=
 =?us-ascii?Q?iOX6qpAFmX+bq18dMQ+OJkk1kvhHY4O5wQ/cY+GO2uWVeHW6J4kMmjo+Lsqv?=
 =?us-ascii?Q?2jzZe71x9MiVsU5aoGxE6BYDF6bsrH2udwgJLjgNUp32NJSVPQWYK24/PgYS?=
 =?us-ascii?Q?tMb+ZBiSFiR2mET6CuxhumwxPiYQ5CWoQm37/TNYKkck+VoyADD2EQgLmPK3?=
 =?us-ascii?Q?83XfHAt3iR24jdNOPdC+3Euj+k9GfKcYCftNdAP3ifTpH07EJwi0/9cisqfr?=
 =?us-ascii?Q?Nawgo3FPvSkmfDIn4Jz7rV9qSlGkCoHfilyN0DCvcFLfpeD2AaEiH7Jrynmg?=
 =?us-ascii?Q?BxlJTkmG8BcNIMETHe53bdlRBc1JcjIIXMxFIICLVJPgObKi5ElujJIdF4v7?=
 =?us-ascii?Q?40jhQYFIW4wfm9iIaeYQNSNd+NGJ+BPDZ0REjJZvuuTg7PiHyzGTgj3+xUCA?=
 =?us-ascii?Q?/Bc/eBGJ2FMQax/+E6x8eBkfAe5IduRuJ9a1jOBKlffatmIGEDoPPqn+E7Cm?=
 =?us-ascii?Q?jNxAtyvGT04I7WTTZHS80/A7G2mHamdt8qSCAhTGAEpttEqMYX+6Bc8WimeJ?=
 =?us-ascii?Q?0AkEKRcR0r5oUpa+kj4qPQ9OzolXu4qgAgYdGjoSbMkkIRfckfQAB1gQrQPo?=
 =?us-ascii?Q?j7/j3KxXXjDLKclJa7T/KQBiuB4jPCb8lcO88dicKIk3XAs50FoFAkys1Zk3?=
 =?us-ascii?Q?laBWuw2uenQ5HjEpuAQFCiJZydZp9QOpL2BsqNwP006vWgVMT3kBnQ6DB8mi?=
 =?us-ascii?Q?sAfWWM/Dk7hUfBUDHaq00FpWump7xsfRkGuoZBsT0tkEwDkPkF6aUhkFGJe2?=
 =?us-ascii?Q?Oiu90zsvHX+4u9myGL2tFDK8t4PH0nq6JsA7aTNXjZy/dHRrp1xMMDD7J+Qv?=
 =?us-ascii?Q?A1kqY0crjEu6Gb3LJ0cZTR7hdeEnTaSZbVqOwJvjAUdr02PXwtMjKFI4vS5I?=
 =?us-ascii?Q?vlgHVJ/uFQh8prw+HlY+brTgcpV5d+gLnPewVQwkQjY/gjNJR76ZG0OxGayr?=
 =?us-ascii?Q?e8WPT5u7FsHk5IiUOqEj+9a8e7laJ6lvQw4KUWc1v6vnf1rK4kEaoMaWpfwC?=
 =?us-ascii?Q?0IGU/uONRX2t/AujtFpLuSiT9rwPu9tisfey8LnqXmsgM2R4c/8eWK6zzsD5?=
 =?us-ascii?Q?9g6uTNPQ/c2fOn3AhmL91bI4YRs3WTLwia9YxLIMPpjMHnITRSPvIRNxxaz4?=
 =?us-ascii?Q?UUtMckKtSItyjTGuDrLc5bkFaoP3DfOlUNpK9+1WXyN4jg0Q1Mr0V4vjLy9y?=
 =?us-ascii?Q?DCv3l17zniTEu1XtycUc9W5z9275dRGIUQ/vMZY3fkfFhzQ2aiSejiF7itnh?=
 =?us-ascii?Q?QQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: tAkEtFw5hX82wFL+drTqFedzGk+t+2+q2mhzsPGjSUU/6A0vTqZXfeKRTqZ6RIbsFRIm05+tOcx4UFWL+2rjqwo/fQV01sDhCrE9j535RcqdJvxU5IiY4n9GcmOSNGAV2BHTSppUTPOD1siN9RxNGzrqz3YSk1HxP3dVqa1y+5VpScjQQiqyV/UY97rCo7NUpWOXAMEkI6IxA7f+K+uEJWn47DUR3G8Etuw3N6k3HjaVh4BwvWLaRjOgyoqqSKExlhKjKWAdsXreyMPDTYY/+WSji9dsfqVFvMcztt1BfppZr5XTlPZq23yh6RkiHKcxutN6AhjHpxyMq46N4tJUCwlfP5pvQhqMQodlgQtJTTSGlDG2i8q6PP0Zf3LN7oRcJnqA1VZLJLd9yqonU34L3P1FrN64Zkx2IPvFJwZUXwYBno6VNa26Wi/ZoNFfv2P4YtaEivXdLCcADRs4E/68ZtB4jk/15NtmeipS3HZRyNEWpek7JfbENoyAtwF1hFrRxMHOoeZAriHlviY1BOFqlmF1vBaXT/BWyV+TK6pRKbJmbfJvyOgdVl8UGDFxA6VJPE3tEflznkoU5C34a9XLoT9AkSl7m+zeE4lkpb51r6BknO7csF5m2v8uYQY7WjU8AiHgbmsYrZQk0HzHca3Nx2s+oWlymkm/h1nUQ2vfYMtsLazFhchqCSkNwc91ZeJlwL7ebaYI906Vw2T2JcUuMWV3IEh36cfbfhel2V2rKVvT2BWMkQHJFIr7r+NuA/oZv3f079XzjXjymBy96qqeTdICssysLOTNLR16ALF4xYaPTrVqGDAQWmNFsmU9cNFpSFn9/vh/sXrzNXCNSYM8QaJqjVMfBwKA1ZBEx9szTwshXvlN1jdIzeyJPihpVdbs
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b7854f7-6e63-4b94-9101-08db20ee53f0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 22:33:38.6730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2nGU2iTWWL6Vm7YZd7UuhlyRyVf8TmdK0NF5Q1wEQmSaGXl44If42YvpSHF5X0lT5ndJrXui5gNnaEdnMPQMY+szp/fNksSM+fASDq2epwk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090180
X-Proofpoint-GUID: Sip_h4Ra0cxPFd_4ylnd9Gg8GQepv-5Y
X-Proofpoint-ORIG-GUID: Sip_h4Ra0cxPFd_4ylnd9Gg8GQepv-5Y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The tas arg is no longer used by callers of __transport_wait_for_tasks
so drop it. Also, fix up comment about us skipping the put, when TAS is
not set because that was not correct as we always did the put.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_transport.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1e42fd3ac8a8..692104325b38 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2904,15 +2904,14 @@ static void transport_write_pending_qf(struct se_cmd *cmd)
 }
 
 static bool
-__transport_wait_for_tasks(struct se_cmd *, bool, bool *, bool *,
-			   unsigned long *flags);
+__transport_wait_for_tasks(struct se_cmd *, bool, bool *, unsigned long *flags);
 
-static void target_wait_free_cmd(struct se_cmd *cmd, bool *aborted, bool *tas)
+static void target_wait_free_cmd(struct se_cmd *cmd, bool *aborted)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	__transport_wait_for_tasks(cmd, true, aborted, tas, &flags);
+	__transport_wait_for_tasks(cmd, true, aborted, &flags);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 }
 
@@ -2946,8 +2945,6 @@ void target_put_cmd_and_wait(struct se_cmd *cmd)
  *   CMD_T_COMPLETE has been set.
  * - CMD_T_ABORTED is set atomically after the CMD_T_COMPLETE check for
  *   commands that will be aborted.
- * - If the CMD_T_ABORTED flag is set but CMD_T_TAS has not been set
- *   transport_generic_free_cmd() skips its call to target_put_sess_cmd().
  * - For aborted commands for which CMD_T_TAS has been set .queue_status() will
  *   be called and will drop a reference.
  * - For aborted commands for which CMD_T_TAS has not been set .aborted_task()
@@ -2957,10 +2954,10 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 {
 	DECLARE_COMPLETION_ONSTACK(compl);
 	int ret = 0;
-	bool aborted = false, tas = false;
+	bool aborted = false;
 
 	if (wait_for_tasks)
-		target_wait_free_cmd(cmd, &aborted, &tas);
+		target_wait_free_cmd(cmd, &aborted);
 
 	if (cmd->se_cmd_flags & SCF_SE_LUN_CMD) {
 		/*
@@ -3239,7 +3236,7 @@ void transport_clear_lun_ref(struct se_lun *lun)
 
 static bool
 __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
-			   bool *aborted, bool *tas, unsigned long *flags)
+			   bool *aborted, unsigned long *flags)
 	__releases(&cmd->t_state_lock)
 	__acquires(&cmd->t_state_lock)
 {
@@ -3254,9 +3251,6 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
 	if (fabric_stop && !*aborted)
 		cmd->transport_state |= CMD_T_FABRIC_STOP;
 
-	if (cmd->transport_state & CMD_T_TAS)
-		*tas = true;
-
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD) &&
 	    !(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
 		return false;
@@ -3297,10 +3291,10 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
 bool transport_wait_for_tasks(struct se_cmd *cmd)
 {
 	unsigned long flags;
-	bool ret, aborted = false, tas = false;
+	bool ret, aborted = false;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	ret = __transport_wait_for_tasks(cmd, false, &aborted, &tas, &flags);
+	ret = __transport_wait_for_tasks(cmd, false, &aborted, &flags);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	return ret;
-- 
2.31.1

