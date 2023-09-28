Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11087E81810
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Sep 2023 02:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjI1CJY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 22:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjI1CJV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 22:09:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B86B7;
        Wed, 27 Sep 2023 19:09:19 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RL66k7000505;
        Thu, 28 Sep 2023 02:09:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=wgeGot3zr7OFEcHNYj4OulCxe9EwIfAjFKU53rDvP5E=;
 b=Lg3chZCAk6mjH+eobMGpQYug4pwMbuXVhmi3RVkXKYG7umcfW1lozOCXNYbsNWG4d9lI
 uk36hokOxqQDA3Lsg4GI/3hezSW+VRPmrN5yLgpv1T+FUfiI2YoFacwlCaO9LgpT7xBp
 v3iXoLSico3BOwWbZ8+s0t7kg0C5PpFgNZVBwJnawj8oEIdsu8O2OwHpSlnEORGsc3uJ
 eVsTExeqIY6SNQTDQPlgQfE6qRgc2qnvrGWR2zOXTZjfeJvP26tFI5jp4GNLmll3P5+w
 jglDi1wbN3P/3Ry1cMlDhy2RzMCpcZEKlovoC3Ful66BHMxlt3/A1lymj6ZfR9ozHTvt 1w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pxc34pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:19 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38RNWBJU034921;
        Thu, 28 Sep 2023 02:09:18 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pf9784a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Sep 2023 02:09:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjRoWIVpOksRshmWOm2FasGE5e77Fg/BoD7kQMqEWHzH27Jk60egCi819x9JMoiIpssX7hhls6SduDJcmGyAyP0GQ1i2UqsfNIqFR6F65rsM0TboszYMLipUQdPiflAtjncXKwzHaN62yRk5UuNIseX/Gcla73Ap/hX4q/0elYq7AG6V1fMrt+6YiJoxyALxWmXMe29JVfXawF0sVnA0HDVOXnSxR+rq2c/9/nas3tK/BkJKLU0ZPl2/IP5gY8WAMkqvN3h+R/o6Cbd4Jex0wnP9L/8riSy4/gHQ53M0rjn82ptkaSrVPjjrZgRVnoAHTnT+NtLpFZQa4FLZ2H4NpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wgeGot3zr7OFEcHNYj4OulCxe9EwIfAjFKU53rDvP5E=;
 b=ORypWVYBT9XvI+NA01b0rWQnZFhln43uks8aApjOpb05Gj9bwGK8HiS/v2gJ3aQN4bd7k4IN0vMfCoX5qnFUKq7ZqKBXqhHeia5PDsAA65LdErs6kYhn43Fy3MHIz960yfsbxZhoPGdmUijE4G4165/rVKcYMzy79zHviwgJ3yyv2Ci9xxoyjySJn7Kcjvj8cxBW/bpPrsY1+pjwypjxOjHeACJaImlYECr/EoFDNETWpxn20simiTUGE1rxzRg5Y5ZDq+Z8OLKnAAOKP3732W81GzN6APtkQsraNMZbf8sCnAbuNKpl2U2/JNIiLO2/wgSME/t1R1Dwqu0hDA2jDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgeGot3zr7OFEcHNYj4OulCxe9EwIfAjFKU53rDvP5E=;
 b=HsBygKG+NsXXB3zjHZfiQCU/hGLSNV8rPrB5p6h4+v6e0hhSldxW1YYHxqRCwR+6s7wtlIqB9kTlb9VMor/LQ070/z8bivQxZ0P3AKSggQm2ds241JTGrkxdCGxttiTMQ/0HtUK0ln/q9XPHdxYSFNxG0++Rjas31zqBFwFinQY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Thu, 28 Sep
 2023 02:09:17 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%6]) with mapi id 15.20.6813.017; Thu, 28 Sep 2023
 02:09:17 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 6/8] scsi: target: Allow userspace to request direct submissions
Date:   Wed, 27 Sep 2023 21:09:05 -0500
Message-Id: <20230928020907.5730-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230928020907.5730-1-michael.christie@oracle.com>
References: <20230928020907.5730-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR13CA0038.namprd13.prod.outlook.com
 (2603:10b6:5:134::15) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ec3df67-f367-40d6-1800-08dbbfc7eb7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fQQm8qQl4DV9Z1sdIBK6LC2njeyOU1vMMmqBWxPnGGKddYhjblT/bHul9ojA2/OVd2/Q18XF0KV/XkitRZRpLj/N8m6jCnq/H3JGLN5YYMHpRmCdAUrmOo8D5rVL4Zt2r/cVfOA6+B+giigCK/H4vYbx2GoPEcEm8Mq/Llhpb5Ts0zT5u0Bch45NcsX3zJnNcCX1l5+c39u5R1Cs4DMWjJxWZbBBrYyvdIR5bTZRmb0g7acvamg/tM1Z4n23yFy++PzwZBqMRGA8pwKMSdbemd2Te1+L6wKFRGJ44jP2ODz8DULRAatGLpyJBd5Uzf9Jeyhf4hBsfqDKPaM0+/HIlIaZhXv/K2GyCWKe3oomYpkmodgjZxCNUZJejmfxd4yVkBGOB79y9Uo8tg+vMMukdg92W8YbQCcPOQX20UmQ3n+bdHLjRy1b7jqay86mdfohs7DU2x1IFt3klxWULlNuQvDiEpt9vvmsX54GuLhj94ybQHs/GlR9pxMZ1BGRcv6Uw8/hfyO+XwnCIkKf89K5MYNNmm3bi1sHAkFNUUgb8QA2X8+5abAvsW6FDRcEesAr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(376002)(346002)(396003)(366004)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(6666004)(6506007)(6486002)(83380400001)(2906002)(478600001)(1076003)(5660300002)(4326008)(107886003)(66476007)(8676002)(66556008)(450100002)(66946007)(8936002)(2616005)(41300700001)(316002)(38100700002)(26005)(6512007)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g7JSQEKCc+gfxsbpvjTUGuXwAydocRGxd62qg2R9h0l2o/QaQ50wTMO3YjC9?=
 =?us-ascii?Q?3yOjv8o8HsVj3LQR8zBFwN7oMG9IpBYaOyk8xcPUGqYS8rJcv7Lr148LyzJF?=
 =?us-ascii?Q?N2QrvQS6vaeOHAs4/KRJkNTJ4y0SaW6+rUOjB2CuQNoHyAa1MgruNSj4JA8f?=
 =?us-ascii?Q?qa5qiPCXWNut4WAsi4rvCi2KNoQtGJzaFGuThEwjDyURwihy+hH/7sDqOSAx?=
 =?us-ascii?Q?6VFDA6c3PQpuCIUVoK63bafPIlmUrYIHaIkHD0EwMb3JP5UsK+yEDrL63WHc?=
 =?us-ascii?Q?+wyaO53HuBPmqka93N3/4DE7UE/p4Q9M5Npi+i2ViD0DctpzlzwlRdhPpTeN?=
 =?us-ascii?Q?ASbU5WpylMD7QJVm09xqsCXcxMAzPz0SMXxAaAEKZyAz9FmkG2Jgj6XnFUIz?=
 =?us-ascii?Q?nQolJQqkGe0GGL+lEjcxYTW30sIoFbqYbLlKLT8PrcFnxTf0L025OI5AoHtd?=
 =?us-ascii?Q?dpW5CmVbsPN182g8y5BTKPSvtSt3yvddehVIRZG0Kcw3eoUDMikkk1eXLj0l?=
 =?us-ascii?Q?6kbMCj4ZlppwPXRJotwesen/MNqPe4VhxYXBlWxvDxh5KDUI5JfPuEz1NDQZ?=
 =?us-ascii?Q?wDvAWSKMsqXyyZ7PFI5ydts5O7Fgiq5hLnGlKqxQE5mnuE+Y6KrUhPeEVrHv?=
 =?us-ascii?Q?UFW66EsdFPvu71gvktYrLU3p2Fq11vMbJTsQteRwBJpapPaS+j4GqRrK4IDW?=
 =?us-ascii?Q?3lVDrooSzTpztuKK1MOa4gLnLCo9ke3RnAN/DaV6FPfxgW9r+CS9zWFsFWxm?=
 =?us-ascii?Q?FyIDroWP4L/mGbD+B3VDP0BaMhyBtzEUadW1Z8/DI1DpnVPOnWCebwJiX8ON?=
 =?us-ascii?Q?v30SPfqButUO90oFZEZOhzTf/6YnPihb+9MNHG3aYhtsviu0tLhWc5EabX4q?=
 =?us-ascii?Q?kz+KMaQbNnNtdQMXVPMc2wnBHD8t2Qt3EhT65kltfmmHyd+4aYIGP1nadMyF?=
 =?us-ascii?Q?2FyMNyKArsZqYO6Bw38gTZHRwDkcKJQ3ENM+CQKc54u6UagIut993sbUdsGd?=
 =?us-ascii?Q?p+SVJS42talk7Ao+MJ7zN2rRcYGTiQh2iMapW54gx7nz2+6IyfsfuOVesRgx?=
 =?us-ascii?Q?KAxwMfoG1Qls9irIU1q3NDPsmgwanrWEWY+f4tgXKfsKms/o87fXuEOLK/Rs?=
 =?us-ascii?Q?kc6dcYUcT2TdFqxdduh8s5wIzZ7fiZKqFfhRl9209QoqjzKz1HBPTmZT64yw?=
 =?us-ascii?Q?1p8yMINPbVwTZd+Yq59fVAPoC/AdZLcdKGurREY8HK0XEv5mVfocdEyFMGJj?=
 =?us-ascii?Q?SC5YeOm8J86l1YiiNME7wguLTOHwlWdbIGGLAuzboolgJhuTvQybwT/6XT/u?=
 =?us-ascii?Q?i7gVojUSWZLVByGHpOOfz6Zp2rZE469kjGc3NQB5MRNo5x4G610cHB1/2OpI?=
 =?us-ascii?Q?dbrQgyuOZ1oO5NztIP5W0/Uk/Oat4JGU/6qXRJQ5ro94Xv2kcrdtAwHRhxhB?=
 =?us-ascii?Q?2ATyd8Y45ZDzJc45smguIFmV8frQI9KMyhCMlpMMj3SOB3XrGj73aLLopn06?=
 =?us-ascii?Q?JdVZANdA7gcCrTeuWAlNbp+u/C+YQ/plaHORTtAhKs6+QNQao5rNHyjl3PUe?=
 =?us-ascii?Q?651ITwPyiBjmB7hLBzE+DaLTVvd5WrX9ZXEPzfuZwB6t0WTw/x1OEATJV4pb?=
 =?us-ascii?Q?mQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Ec81VfwMdDnizGrT+eOfozrJGjZ1YiGX6NGXRrP5AZSAXEYssLGfyensmBdMj1gJWT0Aeo5Q2RKFkch6XPEJo75WzKDClsymijxn6S27xGFxni+a5hgY979yWgZ79Vbq8sX/lz86NlHPzpiS2mmyE8o37Ziq9xfTP6pv9DpC+mHAbPb/VQ87388qG1WKQN6hFAS45IfdPm3EJZ/ZZpAZzIZKvZ2IvtBc91NXPEccB66/oVfwVq5zSeIxMBtKJXxCjU+WuiqSUXWKsgL21KkRPPrcyFt5aWkZ0amQImkPWobuwQ7w4yVBmF/d5LofRM6F5qHdyviprTHFmvBcrl2kKg1LEUHMfiL5sA2ebCm7mxblzcz2DmvJmY13omUxf+L4DY4DXYw8zgsaznWu7x+PbSHYkRADZecVLY1eodYAqYeI6Yp0vMv/ZpfpGntGq4mKKeKiNdoAcHb+8ZKkBa9BTch6CGzcqX5pIqn0X/1vf7gyud2kyTzddP1WDwuz/G60Fffq/bzeRFEpe4/+/ZC7RrLTHMrdKSkz26D89+FgOaO/lPVEtREK7n3Bc3jMOThSbmrIVjjRur4EECw7hXyX4OUV9Jem0NCWwDrsj455sF5f2wIoZxlbd+0dmqoSH4C01s4LUuVUcf1n2+PPYTUCvqbXUoNNwABI9a+yfNAW8w+9DAPMYcxUpnPx0+lNGCVMmS6pVZgW6RHPZZP7WSz0yhB6ah4hJaH8EosKb/CThugTzJSjxNGhfrnEbQO8RXLEIxf3mhWscynnFT97YkMqJQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ec3df67-f367-40d6-1800-08dbbfc7eb7f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 02:09:17.4666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r1sRrrnrfdD0p0bzEAbgsEFNjAdPXFRP7ye1ACE439Sp8Xq0cl9e5pM6HsDtFCet4NN8TTkowo/jauDYVasN0yjL1PtS2REFoqwb2mUJSiQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_17,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309280018
X-Proofpoint-GUID: dJI5HkfUs4EENEMSEH-HB32pcxqqmbdb
X-Proofpoint-ORIG-GUID: dJI5HkfUs4EENEMSEH-HB32pcxqqmbdb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This allows userspace to request the fabric drivers do direct submissions
if they support it. With the new device file, submit_type, users can
write 0 - 2 to control how commands are submitted to the backend:

0 - TARGET_FABRIC_DEFAULT_SUBMIT - LIO will use the fabric's default
submission type. This is the default for compat.
1 - TARGET_DIRECT_SUBMIT - LIO will submit the cmd to the backend from
the calling context if the fabric the cmd was received on supports it,
else it will use the fabric's default type.
2 - TARGET_QUEUE_SUBMIT - LIO will queue the cmd to the LIO submission
workqueue which will pass it to the backend.

When using a nvme drive and vhost-scsi with direct submission we see
around a 20% improvement in 4K IOs:

fio jobs        1       2       4       8       10
--------------------------------------------------
defer           94K     190K    394K    770K    890K
direct          128K    252K    488K    950K    -

And when using the queueing mode, we now no longer see issues like where
the iSCSI tx thread is blocked in the block layer waiting on a tag so it
can't respond to a nop or perform IOs for other LUs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/loopback/tcm_loop.c     |  2 +-
 drivers/target/target_core_configfs.c  | 22 ++++++++++++++
 drivers/target/target_core_device.c    |  1 +
 drivers/target/target_core_transport.c | 41 +++++++++++++++++++-------
 drivers/vhost/scsi.c                   |  2 +-
 include/target/target_core_base.h      |  1 +
 6 files changed, 57 insertions(+), 12 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index fbacccdd2ff6..8e4035ff3674 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -154,7 +154,7 @@ static void tcm_loop_target_queue_cmd(struct tcm_loop_cmd *tl_cmd)
 			       GFP_ATOMIC))
 		return;
 
-	target_queue_submission(se_cmd);
+	target_submit(se_cmd);
 	return;
 
 out_done:
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index d5860c1c1f46..a5f58988130a 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -577,6 +577,7 @@ DEF_CONFIGFS_ATTRIB_SHOW(unmap_granularity_alignment);
 DEF_CONFIGFS_ATTRIB_SHOW(unmap_zeroes_data);
 DEF_CONFIGFS_ATTRIB_SHOW(max_write_same_len);
 DEF_CONFIGFS_ATTRIB_SHOW(emulate_rsoc);
+DEF_CONFIGFS_ATTRIB_SHOW(submit_type);
 
 #define DEF_CONFIGFS_ATTRIB_STORE_U32(_name)				\
 static ssize_t _name##_store(struct config_item *item, const char *page,\
@@ -1231,6 +1232,24 @@ static ssize_t emulate_rsoc_store(struct config_item *item,
 	return count;
 }
 
+static ssize_t submit_type_store(struct config_item *item, const char *page,
+				 size_t count)
+{
+	struct se_dev_attrib *da = to_attrib(item);
+	int ret;
+	u8 val;
+
+	ret = kstrtou8(page, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	if (val > TARGET_QUEUE_SUBMIT)
+		return -EINVAL;
+
+	da->submit_type = val;
+	return count;
+}
+
 CONFIGFS_ATTR(, emulate_model_alias);
 CONFIGFS_ATTR(, emulate_dpo);
 CONFIGFS_ATTR(, emulate_fua_write);
@@ -1266,6 +1285,7 @@ CONFIGFS_ATTR(, unmap_zeroes_data);
 CONFIGFS_ATTR(, max_write_same_len);
 CONFIGFS_ATTR(, alua_support);
 CONFIGFS_ATTR(, pgr_support);
+CONFIGFS_ATTR(, submit_type);
 
 /*
  * dev_attrib attributes for devices using the target core SBC/SPC
@@ -1308,6 +1328,7 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
 	&attr_alua_support,
 	&attr_pgr_support,
 	&attr_emulate_rsoc,
+	&attr_submit_type,
 	NULL,
 };
 EXPORT_SYMBOL(sbc_attrib_attrs);
@@ -1325,6 +1346,7 @@ struct configfs_attribute *passthrough_attrib_attrs[] = {
 	&attr_emulate_pr,
 	&attr_alua_support,
 	&attr_pgr_support,
+	&attr_submit_type,
 	NULL,
 };
 EXPORT_SYMBOL(passthrough_attrib_attrs);
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index b7ac60f4a219..0f3fd775fe6d 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -779,6 +779,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.unmap_zeroes_data =
 				DA_UNMAP_ZEROES_DATA_DEFAULT;
 	dev->dev_attrib.max_write_same_len = DA_MAX_WRITE_SAME_LEN;
+	dev->dev_attrib.submit_type = TARGET_FABRIC_DEFAULT_SUBMIT;
 
 	xcopy_lun = &dev->xcopy_lun;
 	rcu_assign_pointer(xcopy_lun->lun_se_dev, dev);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d78f24c2dfcf..1fde18e1ef3f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1576,14 +1576,7 @@ target_cmd_parse_cdb(struct se_cmd *cmd)
 }
 EXPORT_SYMBOL(target_cmd_parse_cdb);
 
-/**
- * target_submit - perform final initialization and submit cmd to LIO core
- * @cmd: command descriptor to submit
- *
- * target_submit_prep or something similar must have been called on the cmd,
- * and this must be called from process context.
- */
-int target_submit(struct se_cmd *cmd)
+static int __target_submit(struct se_cmd *cmd)
 {
 	sense_reason_t ret;
 
@@ -1643,7 +1636,6 @@ int target_submit(struct se_cmd *cmd)
 		transport_generic_request_failure(cmd, ret);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(target_submit);
 
 sense_reason_t
 transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *sgl,
@@ -1905,7 +1897,7 @@ void target_queued_submit_work(struct work_struct *work)
 			se_plug = target_plug_device(se_dev);
 		}
 
-		target_submit(se_cmd);
+		__target_submit(se_cmd);
 	}
 
 	if (se_plug)
@@ -1928,6 +1920,35 @@ void target_queue_submission(struct se_cmd *se_cmd)
 }
 EXPORT_SYMBOL_GPL(target_queue_submission);
 
+/**
+ * target_submit - perform final initialization and submit cmd to LIO core
+ * @cmd: command descriptor to submit
+ *
+ * target_submit_prep or something similar must have been called on the cmd,
+ * and this must be called from process context.
+ */
+int target_submit(struct se_cmd *se_cmd)
+{
+	const struct target_core_fabric_ops *tfo = se_cmd->se_sess->se_tpg->se_tpg_tfo;
+	struct se_dev_attrib *da = &se_cmd->se_dev->dev_attrib;
+	u8 submit_type;
+
+	if (da->submit_type == TARGET_FABRIC_DEFAULT_SUBMIT)
+		submit_type = tfo->default_submit_type;
+	else if (da->submit_type == TARGET_DIRECT_SUBMIT &&
+		 tfo->direct_submit_supp)
+		submit_type = TARGET_DIRECT_SUBMIT;
+	else
+		submit_type = TARGET_QUEUE_SUBMIT;
+
+	if (submit_type == TARGET_DIRECT_SUBMIT)
+		return __target_submit(se_cmd);
+
+	target_queue_submission(se_cmd);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(target_submit);
+
 static void target_complete_tmr_failure(struct work_struct *work)
 {
 	struct se_cmd *se_cmd = container_of(work, struct se_cmd, work);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index dc274463bdf0..4e3b2c25c721 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -909,7 +909,7 @@ static void vhost_scsi_target_queue_cmd(struct vhost_scsi_cmd *cmd)
 			       cmd->tvc_prot_sgl_count, GFP_KERNEL))
 		return;
 
-	target_queue_submission(se_cmd);
+	target_submit(se_cmd);
 }
 
 static void
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 401abdf8a9ef..97099a5e3f6c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -726,6 +726,7 @@ struct se_dev_attrib {
 	u32		unmap_granularity;
 	u32		unmap_granularity_alignment;
 	u32		max_write_same_len;
+	u8		submit_type;
 	struct se_device *da_dev;
 	struct config_group da_group;
 };
-- 
2.34.1

