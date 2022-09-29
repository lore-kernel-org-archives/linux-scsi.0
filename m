Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 307DCC32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbiI2Cyk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbiI2Cyg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:54:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539BF5F44
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:54:35 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SNiJkQ023234;
        Thu, 29 Sep 2022 02:54:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=1PvwM47rb6P7g6jK7bWRImH0d68+Etl1rKiEAPDOP6U=;
 b=sglnu/N8WOnSTBedItrpBurMVKkZO1BG9WQMUMwf7t0j8m+5nnK9j1isgM6J/dOgyeX+
 Vg+K/Hnm7PQ9TIou/8foFxvGcys2yr+M0lX8LrZwfd1PWr82rdmOwDYa4icos1CS/y2q
 RZxSkmwlYIrQQrDHPHFKQBTJ8O6N6yqja8AyqWTJnM2rcKLfIcQTOqRPk2B6dsPB6lM7
 FraVffy2F7LXfuUDH/StXh1ePO1divvKwZm6Gy4zMlAW68ZwuW9wKNVl4lTnQdmGLT2D
 lgihGlyaY26QUVnSaZp6BDDsVfLXVc0uHaB1HQRtB2tUYcoIw1turiJeGb8jKIj5qhVw DQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jsstpu2wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SM1ced039455;
        Thu, 29 Sep 2022 02:54:26 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprvtcqb-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zix/JSUH6fWey6gQbqjjrndFsiqfSeMd8QBgLYOtuQMjvfJrafkT2lPa8qKudVSTCgZgFNvNksJZFXPOLdDJWPFnRkxgT6VPNIVol0jXaRNpRBca99avOl+2M7+/wdM8ZyhrpN75/Dn+4qous+y2iBa5SMNptAhImPc8vT1pGA+dyS1bNU8CHiuMPoQiLlwWc/7EfV4nUNkF0dMerm/LZVK9JOU48VQClXiKPn9y0AX2Z+bCREzN6puSyCeriCZB4dTY/X7FKNzvUuJ5Rc12GJNxSj88hvfzP2ljewnp3IoLQwHryGq82Gyr+OSAUWJgHiR5vGvX2p/JtrgivYIpQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1PvwM47rb6P7g6jK7bWRImH0d68+Etl1rKiEAPDOP6U=;
 b=I/80LHgO1rybI9NFb/hd/Wjz+LVS+AJV0JpN0GNH9uDezjINiOqUKazH4X4idghc+tH9PDPkjrWzDOx6VfqYXjQ2MmBcciqmLve/vJzLD/iA3iqfRc6zMmllJXS+OmERkdSCwXKocIjSQ0MjVcBWQahSxRpKYmlsn5Gtub4q2r4sX2igSbN+ZE+5AhQnDoWmG1QNOTTLSmBVJwjfREVD8nYGoKbUx2M2t0KKv2qZbLeEU/1cjtJJpN3xC6G8FG8UVrrfGXjJRpVCYjeJKpdfVd76LF/Lhjdmzp88XmoqDaWK7SA9q4wqNBYuPFv5kOLTGIrijm+Moz3VhZVVeZ13tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1PvwM47rb6P7g6jK7bWRImH0d68+Etl1rKiEAPDOP6U=;
 b=UxDm/g6a1GYZ1JpPZpiGSPbeFrk/EL51JpBQqkXzv4vW/kv29Dzoi4hDE2S6Ylm7GvmK+xejufg2qZE8B72bnOkqAHJkWGJwPR/pYYt2bHCo8Rt1L4kUPAGTjSoH8RDCa9Bf6YeKeMSzqSgXpsV6uYb6WSbzaBv+CqeRxmtDI9o=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:23 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:23 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 07/35] scsi: ch: Convert to scsi_exec_req
Date:   Wed, 28 Sep 2022 21:53:39 -0500
Message-Id: <20220929025407.119804-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0002.namprd08.prod.outlook.com
 (2603:10b6:610:5a::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 8caacf32-3bc8-41b9-bcb4-08daa1c5e9dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PKNSpFthj5/UATM2zGutixLozqFmruwmKOV3PZzLHc2c+AvGHQ6+s/525sBqbOjRsYDjY1ZPYx1hMgF0NI+I6/a+mPcfuwkUaBcwYwEP7Ll7w1ffTPlsuUUpness2VWSa9DHVFx1htGgWpCswJMXIsDAnojkpLzQmdvb79WHn7Kct9TYCTrA3Z3Gb9uatpcr34ClO9LFut3kFRwk5VVB//5ZDRaAxsH1d2zH4nXmjvnf1cTI8KkMDv6b/GbJQRSkA7Dtbtwvz8+15IoHdsr2yBx0RJfgcwbWxh4K51GzxyC6/H0l2bggwtIG57JgYf3SLo/dkyCHUw16MQZg/BjQ8dVUczl9Qt6TKZcDwfIjZNxnLyJaZ8kroPdVDQ3Dg5uO/POP4jVng5CiBNrE0nOXAkThlYRH6cVeRl4nc/s/X9pcazmb0otjmuzDX2tapPyjfn0/cO4ZbCYl7H+trs1W3mN5Vqg/ws0LTGJMHYuRrxfjKbhzo/4ozESnoQPtWYsiQ0r1zBeEpc+TKbx8sqRQa9qz/ym2vs54camcrn4alUmP5Kjjdt8IJuCT31rIgBQqRAZT9VTWE80X/pTgpnSKipGfyvKgP7c1fjzD3pwmPTolgEqdelrXT9wk6MCHMjAkFjdWpXeZruoEHBwbJyczSFpWEIQ6CmMd0pj5TbR+EsVXD7xIJ+30qlCuzs+SIQ/6hxksN0tKTakEnNewKEI42w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(4744005)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LbLnmDkkT5QE+9dxspm7ma+kH3A3N+cxhvLt+8+3UQ+jANR1q0DOWeJVv+pl?=
 =?us-ascii?Q?QA+ZVoH3OrkGBgCcLuTASrFb2LIVtOb/uEkSTa06NpcY4Do67zqg5DTCfo8r?=
 =?us-ascii?Q?uB7D3aGSeCp+RZ029lTNdibQCgnVj7pQCSUIMi13nvY4/hlVal5hFDam8MM5?=
 =?us-ascii?Q?SQfo0VJVoLA4byVmcsednbdIrIgctKWPOSfvXCuQ6dPLESOm15JX73qw4NfH?=
 =?us-ascii?Q?7lEhX4g7r1dUuFi388ENVg0S28mELjATW3IlWJsZKQX7U5OiJjTN7oeDZ5uK?=
 =?us-ascii?Q?Jl5w2w2cNvc4JA2UwCr8VejgqwhF+2drfn3fcDc2RH/2eumsM4tSFEE6eQts?=
 =?us-ascii?Q?Ptn6xLbs8KejUr6RwHPnGuzLUpqzA2UGLo0vRoeqr9T8Wuu75U8OBA1v4D6J?=
 =?us-ascii?Q?bFXyPLluH15p+aNBU85eJbTk5qaqsRHVJORxgDdeMtMTu1iY1lCV9pvDWDBF?=
 =?us-ascii?Q?GnBEDBJfjOwlv0KmBlaLpJS9m4Zb/jZ77jGt9G1HW5k561oOIjYzCYM613c6?=
 =?us-ascii?Q?FIVI3pSWYiMJD3Z55Fl5txzC2qqtshh+ebYABKaVbeCd4KEkA8QgwX1mpVqq?=
 =?us-ascii?Q?TyQbElA8zQFEeKgLb+UAWK/n1kd/hK85QO7JjMd34s1Hef3pw2utUTa2Rekg?=
 =?us-ascii?Q?vgDjXDc7IF3vi//JOXyNLkvsBHvVLqQOlI3HgOdlQYGCg6N3aqgTdgTmU/bu?=
 =?us-ascii?Q?h6lvKGcHcTZsMEpKXFEFrMkO1BKfAcjuzrVHapz+qRGE4JY19hBUIfpPoobd?=
 =?us-ascii?Q?xfPYnS+ip05xdpDIp7XEt/KJalPK8eLBHHWaBPdA5yNCVZNWc9IL+4z7E0Xp?=
 =?us-ascii?Q?4XpGiOiKyBOTkj08CCcZMHW3MRI62BFC9U4eCRNXFp1djeg5mILs4xCNFBIL?=
 =?us-ascii?Q?nJA/4WB0cmgsvzL0IgkowTjzYd5zpaugyB9sY3pALaz7qlycUCL4nTwd3MdE?=
 =?us-ascii?Q?ybyCW1SEq3f0Ux6hFZq/KZC5cSSsU70gyXfZY/T8SBpGtEHQr113EF0BUwlD?=
 =?us-ascii?Q?PQpT56ivrCiy67mytaMX5yb7kl/Y+OP9ctRVVvTdtPV1s4SnEsOw6wIuGYfa?=
 =?us-ascii?Q?pG4zCOnRk5V/wUYspW8UYwxpqwwFTg9YFe0xZJJzY3Y5YB3G9VoGvZaHWSv7?=
 =?us-ascii?Q?8DGl9tbwGlqst6zLN4I/vFQKEEoGev1PGFc1GQZdsz86hIAXMbONVqWK1iRT?=
 =?us-ascii?Q?k07IToZmqyfjXZ/feBMV2Msx4QtTrMHRuhM+mnYM4aW3qyimu+tTpFQmbUE1?=
 =?us-ascii?Q?KRFPpXAB97WA4HljV6kSLM8xKWQe1CWK5OwszqbSh5SuUwxfYtLFhEx0pcvB?=
 =?us-ascii?Q?1jUJWdIc3fSXMyyjrFEX0IwK8li3TZdUszz3nmeoUmjbfEmTUou3RYOCur3w?=
 =?us-ascii?Q?AmXOOR9W0tcsPZAz80UQV0pCMxqBpewjv4dWjhkGoj9yHQWj2y78ONOTIy+s?=
 =?us-ascii?Q?QATvKxB/Fon6Zjf+mJP07EwjVnp5wYnZVLyCyURk89rn/88+VmpNePVLsS9k?=
 =?us-ascii?Q?ANQdEU3Q5iAYVCIUJfZcZMsHZ4WglPZSYs8uaKUQufMLPIwGNUiq3ZcshhTO?=
 =?us-ascii?Q?H5YELzp9H8SWYbGI8fpKysJ7YKzpthML3BcZVxj7DaIGfQmIgQlE/e4zxD8D?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8caacf32-3bc8-41b9-bcb4-08daa1c5e9dc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:23.1470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qebi9SKog9OLwf7POGY8Lpf4lV6z2YRZXLBUAFRYPyHDz9UTdir36Hr0uql2La52zdYVGF4ZiL7Ia16wniXLsW6KNFPjbnB9TwwdorLo7EQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-ORIG-GUID: pbDt7g8QC3ASmLlrpGFxkKeK6aCQFouE
X-Proofpoint-GUID: pbDt7g8QC3ASmLlrpGFxkKeK6aCQFouE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ch.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 7ab29eaec6f3..511df7a64a74 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -195,9 +195,15 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 
  retry:
 	errno = 0;
-	result = scsi_execute_req(ch->device, cmd, direction, buffer,
-				  buflength, &sshdr, timeout * HZ,
-				  MAX_RETRIES, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = ch->device,
+					.cmd = cmd,
+					.data_dir = direction,
+					.buf = buffer,
+					.buf_len = buflength,
+					.sshdr = &sshdr,
+					.timeout = timeout * HZ,
+					.retries = MAX_RETRIES }));
 	if (result < 0)
 		return result;
 	if (scsi_sense_valid(&sshdr)) {
-- 
2.25.1

