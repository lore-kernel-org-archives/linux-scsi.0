Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19781C001DF
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjGNVia (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbjGNViT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:38:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F64135AE
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:38:16 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4cix015000;
        Fri, 14 Jul 2023 21:35:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=w2orixFRdn42BUfmqu1rB9BYmZWXH6/gCfe+pzXU7mk=;
 b=Qnp8OR8CGmmX1ByjewhGAyGGbO6rJzoLMB/0kJKDnziMEcyhWYnpo3lDn2rz5yYZ/r75
 AInmDHup1eUDzXpQY+B+s/sczJOIvbX+4WrSlppP0s0mcW7SCHWSfyUdaF+m9tnNgiwt
 Ut8p10tv5aeFm/izZMXoEsqjQmLw8DuFT7O4mf+dud67JNO+hsgvGjnHLuNb1AdtX/FK
 gDj5eInuwR2VmAG//VLCvkOWrOOdNyhFHrxF66XKIO/fwEHWXIa0mxpKUXB6YuD0klK5
 X/mJ6X8QvC3XFeu+aACXIlbYjoiqYrmXSBU5PxmHXVvrtdgYWhAtkysIjDkL8PvEOonW GA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtptx2f6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:06 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EJrurj032969;
        Fri, 14 Jul 2023 21:35:05 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvrs4sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+FD6cPT4DD9+pp19urTJ/IppcL15yWPxYhsejPM23D2vIyckmoIr0uYE4HSIkJOgC99CxEKpv4jNIZxN0aijcyzVVLDKF6XQfupSJBwHGvBTcvWQL0JmLqsEUbzPrt10Ke+PamN5mPoQsfn8TAdEAd9MVo8NFkJwDaimM/ZkRvMopNs7975o7tClEbXp/f+S42yc3BmW1soa4TlkDlJPSHLm7EIrQuUjIlIml1FJWjiaDOF7v1QQQvgV4Og1fipgobh2FRuNXWPrRu+e/x2ks+PqcF6ZIhRd9SIIBdYjA5EkaBQAYOXRAa83Ayw8W0Xwn1skNRWUAJl5gUSDwUXaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w2orixFRdn42BUfmqu1rB9BYmZWXH6/gCfe+pzXU7mk=;
 b=Nqe6Rn9+Nnee7x8eKy0BXtEY9z/f6AuFHi2R7QHKRpugXkDnPIgtdrFxPmeTnuFSXh2w71UWysct+U69pVsSZ8Ayq24MVJ5GGJbQPloQ9Htr5rx6eHL8g89MsOfTqqf6Odp8AHOklFG7jh/0KC2FjZUFZYgDgCGyknbu+VWUUqIQKbVo4vzdsqVDuc0cYbd5f6C5G9gN6l1prVjkJ5E8bElje8+f8EPqTLcj6jq/7LZkyI6sR9CJVlhuTZJQ+WnXeD3AiZPJd/yRCMCu2EXXmChSEilSPBEKfSq5bYgEVZGnelITVFX3n8DUvm1sVqVBWR50sLO41+HvtlA6VVPNFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w2orixFRdn42BUfmqu1rB9BYmZWXH6/gCfe+pzXU7mk=;
 b=XB2vawEcev+0vQy1a4NcP9TnKx8aFaFggcfkPXPQd1+NuBdiGWoyxwDnWz9ROK/NaOihD37St2fWzZEmPZmoRWdm997w7PZIAE7DBw1fVpehuAEQHgsijieOxmTAqUZYhi5zZzaeZrjltItarqAibE8AMDoaw6OGWVd2C2fNTBU=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:35:03 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:35:03 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 24/33] scsi: sd: Have pr commands retry UAs
Date:   Fri, 14 Jul 2023 16:34:10 -0500
Message-Id: <20230714213419.95492-25-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:5:40::39) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c9388bc-68d4-400e-f2a3-08db84b22ee9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aZ1kN8ZEnyYPLuEKfG5TBZ2cP1FJLxVlTHugJ8dz0c74wDA8A7FSaTz+J6Td9XQZK/rY3O/AuW8guOYSMyC0PB9KgF8p5VQ4V+a3lIAzQJloezQ2iUkLgKAao5f7XjSYt8mJ5dn8yv37DMAsnOPLO4arYDzWU/2/M5q0kiP8Aj53WPY2/1N7SNxiWC/K9R2WAUhNyiUPiyuy5LLtnWHaAYMOXq7p6fHfZlCJ4bp2gJGlrm+rN4fn3fh2M2yy/wHsqCrkCnVfS0XJEmIpWdSBOIIrJnZ7hJJeogsuSPRbXl0WRRcJIBuEUglRthIsGdGDudV4tqGo0MwVEwsXQRIo+Kc7/fqvL01OKiktFmvJ5J2dtO2ZasbQFxgULN8ZAXjqqbbQn5A00lkC0WHGyrodTJXSUOgEX3xzxGynvwr3b4gDoHztx1zwSnWD9yuIeOeqeBVvjW6x24xHbtkCAEkF8dzr/zazu6sqVMGSw9EYv1AJ4nj9G32xMDrZCDY4ZoyIP9Z1OvkbgUQyX5CoYL5a2evrQsFQVDtM9XnWeB1+zseL4eeFFTUxsPI3ZPIt+kHz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199021)(5660300002)(38100700002)(41300700001)(8936002)(8676002)(316002)(86362001)(2906002)(6512007)(26005)(6506007)(1076003)(107886003)(6486002)(6666004)(478600001)(2616005)(83380400001)(36756003)(186003)(4326008)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xq6tjvzTATASzEqcwjwTYHu9++mpsgXPD47dwuX52l160kMjWoQ+Qyin6zDv?=
 =?us-ascii?Q?d0z7AG04CikAJbtNEpl7a/5ZMg89KITiX8TsqEd3LWw3ZaNXMZIo+kEdTkgN?=
 =?us-ascii?Q?yxvnoX3E0iknA1mTpEnJtpPoSJux/YfeFSLh6YWOJP9yJ0SHt53OPMB8G22b?=
 =?us-ascii?Q?BdKt3GJeBOZTQ51dt7BH6K3zmc/ntE0HVaoKOGlUu1izVu9/u8ZwTsFZUGLp?=
 =?us-ascii?Q?GA75nG/rUyQ2pouPDqFASf7eidakQ1ixh6Y41iN8EJADfWR456dt9qXhZlEF?=
 =?us-ascii?Q?ZnIZEg0+EVrF2HL0IUn7qB0I71aYSVqddT6qVl9vB9cAMiV941TvqOqBIslr?=
 =?us-ascii?Q?KoxWS8X3V9xM8abnpv3nvAcRlDBF+bWI4pWswtggjli5oXRLeNP8EZOPBguC?=
 =?us-ascii?Q?MY+XbV1YdXOqW5YNh1fb+HviBrW87bFV0enpCwmN2Te50bRuL86ONumogoPU?=
 =?us-ascii?Q?XeMNF++SItf8N1KGmbqy0R10QahV6j0Ikx5QRfIeLZZFO4LZULQHhPysMICk?=
 =?us-ascii?Q?iR4zRq2JqzFnlaAojeInUJ1OoEPgnT3nPdMyCEmk+ciq2iLefJFr3/DcGDoe?=
 =?us-ascii?Q?0z4k595Rlcp9jdOCAzPVXlXCW7gVgjsxuJjv6vETXDhNYJnJOmt/rbZtCFNz?=
 =?us-ascii?Q?Mz76EmZOIjoS80O6moSToqxPb/C4eKFD1XsYOCTiT2NTmS2i9ToX13lnpq4U?=
 =?us-ascii?Q?Rl8lWS1sBjOzlpNZ4Q/AWpXUQ7r/g+Hv9E2yl8Gdtc/0hnadroKG/zU33E/5?=
 =?us-ascii?Q?St0VXX2KeGeOLEuVOFyXUyrfG+eZ4yGi900GdngScwVvtkJw6RjziSPoveYU?=
 =?us-ascii?Q?zBnUUtjN1hwon7a7pdyqzsEjnA7Il+6DCpWuJs4ihZquGwxubRoBJGgEq4RI?=
 =?us-ascii?Q?DyijTVa62C764q8Kdyo/7WUxSVQ4fV4P7fNvr5GCyvu3TeCwbt7m6hf2KLDu?=
 =?us-ascii?Q?L8wB6WFVxOZtAo9BNdyjRQ8rCi1v1K7MRGSrxwkc/vTkIZczngQzuEATU7Ec?=
 =?us-ascii?Q?w2CSOtocsiyyaBivgbYNZzSxJ8igma9ImO8i0wWsiLJS99654Ey/JtShMyxZ?=
 =?us-ascii?Q?7HK1ckNIhl2xS5Emmwr4ph6gi+mLO1RWcUhk5+/3c0LY26RGxd1cjor0eMau?=
 =?us-ascii?Q?XqdNnVovUJB4LFH33xcWgN2LUUiImNYnCN8F0V+9pbzA3f25Ktbdn60id48y?=
 =?us-ascii?Q?j5LWzRBe/k9SksAEEtvy+mvQohHovjxTx9R1DPT04VqFU2DGn/OX0BF6Rkr/?=
 =?us-ascii?Q?yq9PLfQwlVca6PYMbAK65zNRQQ6698E5D+ME3z2r6+N2DtdFGhJfzDbYmls5?=
 =?us-ascii?Q?neibm22wYpQShMpRgauk8yYMe2DNwJV5sBYvvZBWnB0X5d4b8ztYpmidK3Ww?=
 =?us-ascii?Q?3dhGQU9tY/juAm1JgDi02n07uySo1HcuFROKyFR/uoWiknOFtDLzXIKEYfOM?=
 =?us-ascii?Q?2zxH6LXO7vsxashWGz+a2vMPa7JoKcffPTXNVoEw+Ylpon5O3KMePVX45QAX?=
 =?us-ascii?Q?T8XVbPGEX0fIO/0B3tnY8IQi3BWPSOItMN+Pa2VcorgdFPSr8fq5MukNLZyy?=
 =?us-ascii?Q?F1eR6BmBxRsmWp2yyUch7Ic4JVpYGkd5iM3LP4yPRiUhK9xgP6UizvBXIqp5?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NVSihunr5U2ZjPvywnQ1U1AKGGMwxfRV6c5T/sPz0TUfPmtgOlnUN5+9jwFoHPcnmAx9LZ8Y7QlcV64VjkFrznSyKANjYI8tKy51NHO0APPcLUi/4xbZbnsUv3GH6SHAzhfKtXg1AFQge+fdGI0yM39BL9xjeKcXlfUrbp21x6Heo8/OHHlpEfItV11NM0YTphSBV/hL8sask42SXwmxkUO/WkfAlRN4Dn/Elke2yU1+FZEM1E3Rqlc6Ku1dBrzyFkv0/T4Cx1gVh/PMn5PqFukabUFsOV7VHU7jvGG+C3PtFcbi/wfihWggApfY4FdKf62cwVqw4PkxKV5j/oDrvXDYUNwUjJZPuNmxOQBBEeyny5VynxVn13DahAvFL9szf5MXzxedX/bQq1W135G5OczCjSZfm6fd23Lairq9kGE4evBoEjkiNqJhfnCecFWod8+OonoDU2IfwBrI1DaRsSHR4lHGqdImpvWL+QYcxa4l3ceO8DJR8Uaty2Qze/ZqBrIPzpJAC8MHcFXvjkNV97cK011uSNk8cDgZpWe+fo93LHaLqWW0gN18W/oIe+1xVJwTgCSaT6yGFsDYL0pV4FlzSqfpnd8MJ9cFP49FtIYK4UvmHAovUxZ5huEBlu/rBTXNLOk35i30poZkKZXjarMeCsbDcwW1yDI/fijLw70qKTh3bZtcuihWDyzLkr3XYhDZMgdngx+k08N8Xhya/dqnZt4FlDflR3PcWDbiiUQxmLYdQ+qcnUIo9H9pp2bx8loFmArt4WuAioe7ZX2eYi+Qi5T4EUjaCFJA/Y/c4KT9oizAq/RvSSOGnnNixhUK54VDH3AVOaLX/iPJ2K8XoUOnwiLyjXMAod1UIVUK/X8mRLrqmPrfD690cMp58EfM
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c9388bc-68d4-400e-f2a3-08db84b22ee9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:35:03.0300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gr6vNjrx64IeJFaelfGL/FiF24ytrm0fYyfouQLq7hWxL7PKLgrjJiU1q3dOis2V8J5q/oKBlog5gX+gvMJoiuWUrt4nZtSH9f69LLRinGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: rONwYjjXbpxV90evKbfD-mkcXS5s6nS8
X-Proofpoint-GUID: rONwYjjXbpxV90evKbfD-mkcXS5s6nS8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's common to get a UA when doing PR commands. It could be due to a
target restarting, transport level relogin or other PR commands like a
release causing it. The upper layers don't get the sense and in some cases
have no idea if it's a SCSI device, so this has the sd layer retry.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 53719cf9d86e..c4de2f959393 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1753,8 +1753,19 @@ static int sd_pr_in_command(struct block_device *bdev, u8 sa,
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
 	u8 cmd[10] = { PERSISTENT_RESERVE_IN, sa };
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int result;
 
@@ -1841,8 +1852,19 @@ static int sd_pr_out_command(struct block_device *bdev, u8 sa, u64 key,
 	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
 	struct scsi_device *sdev = sdkp->device;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 5,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 	int result;
 	u8 cmd[16] = { 0, };
-- 
2.34.1

