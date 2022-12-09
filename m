Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422E8C10F1B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiLIGQJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiLIGPz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:15:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F97944CF
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:15:54 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8MIvCH029750;
        Fri, 9 Dec 2022 06:13:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=TWpWKPTJjOJqQwtwUfV0RbhOj49aoyayeLtrRaHXhw0=;
 b=k78ovrb7QOQbvcEc6rTR3+HjHsgSsfmgFF+RTSEzMycdbUVztMgge/WaohiwHbdI+kyp
 CcU4CZ+YZ5ZcirZbcfy8xVRDUtJfsa12QSzU3oSlX3KnXE8hWAIFl1Acvm7+H/2IXWcN
 ZZbijkYQfxOf4G/FVhpgjwOAGJsksISyXn/pM64voYEatQIUL4G75iSFHd9a7JGukocG
 YYnBQZJkTW47yb8ITPAOgWMPh5ydUze0QwcrZDz9bS6XhZHwkYqCcwEqq0TPAUJnFpLC
 ORBg7+I1ZyxuhNkhasnl8h0LH5SlrZSBZUxwMaM8nXuxfEH+Dw6NEvCgndhrUHPq4L22 Ng== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maubamj5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B93FAG5032666;
        Fri, 9 Dec 2022 06:13:43 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7fdafy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WLhfs15DHZ+D9xEoPDw14vqh5qUxhfSWrpi5cjPH8TfC2CpIdc1yfjnh/T3XHNMXEGKlG4q4eXfZuza402a3ygAjLHgsgqljf7YpVLWQaU9GP0BzjeW6DyreTrJslfpHigLgFOVnLb9S2/R/IcunXNKQiFehK+FWwowUqumtsHpQIlRUsnrn9oms4n1y+Sm5trTeReZsivgCeOgBr3lKkvNVzBWd//Y97Wht55aapFgFz2pBk1M+LD2kCRbXcfbhU/O+50q/nc+cUUJNLli6m+qz3KAkDPe/KtzBmeOS8csVRqRNf/jvvSh5TAWUf2/31LQMwEKBwnuTpQuxcKaLlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TWpWKPTJjOJqQwtwUfV0RbhOj49aoyayeLtrRaHXhw0=;
 b=Ml653ZVxjdbk6+DadIcZUgacSzYt8s700jmAzTjEUUNVwzrGkAIiNxa8prbuwebxTbCVKEoKyub7Y1LCEedbhoce/QbGjbaSprtYHIeOBkf3eokwymuFjK/rEeODcrMjf7jiB+YwTnP5cEHHQ+At6m4pniXnFfLOnXcb6xXVot2skMbPcgw3Wk6hfwh4VXjFMvqKt4k1tzopELniX2mgBGbAddB0R0m0zhXTLi6sg9tql7BXCj9+wGRpRiP+VKcK0XWdx1dKVH6WfcRc3KlAcTC6POi/7i4bkp+XnJVehW+Yu9Nd3lCBe3AMGEesJS8+o9zcOHVCYlZHYjzg4G/5pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWpWKPTJjOJqQwtwUfV0RbhOj49aoyayeLtrRaHXhw0=;
 b=xus8VB9dQdBQwWxCRvesOS0oHVQPbkNUjorOKmhEFxk0PAJeLND09matQ10Ry/aZXjnkzbSzfDTSOdr5hi5Ab64A+5w8wEExQhjRKy9Dq4uCFhP2nz5qngQ2j2fgt35co/DhdXtq7vH14kBPfupH8/l3IMtqrM5C7AUQYz+WuR0=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:13:40 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:13:40 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 06/15] scsi: core: Convert to scsi_execute_args/cmd
Date:   Fri,  9 Dec 2022 00:13:16 -0600
Message-Id: <20221209061325.705999-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209061325.705999-1-michael.christie@oracle.com>
References: <20221209061325.705999-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR14CA0005.namprd14.prod.outlook.com
 (2603:10b6:610:60::15) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: 6be7c7f1-8e27-4f20-6dd9-08dad9ac8476
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jX+qKUNy3nG2Lmbp+LBBse+qoEz/w6aKHcw5krTTuzEeJfPb4eTnRBi7Of7FU384sn0XgFUv7Y5956t9tuZL6mI/20FRf0aeJdW1pPTA3B4EehrbUMeYRy5jr7DoO9/LeV4So1pmECJBP6p81A8M9fYsnt2rWilYge3blHSTzPeYrTO9mUxTYCH3MXSDWmcRRnQi4nt2ztPja0MqHaowbJAkCNIzaY/TMJ5KnwkvWvYpkuX8lhWg2Y1cNnnyJSChsTyeGeDcmrSgA7aV6dnMtDn5kWdTseMyK/HnfZvptCqX0wt6r4Sg8bJrdViu8gb/zkGiXLElW3Tq4CYLOS/dtObL7cKfvUyifHevLopmcYDkf60gSxZYVDYotkbRU2CwINrkW7V22JdJ0nKczC1sop/TvfV5VnzyL7ISspCNznbVsQ+grJCPqa4dVAqhTT52xdKa+zzUXjcfBKbJVTmIBO7MJEE/Jvd3oej/Y+pjLHn21L9ddSKPR266SK0fvXwDLFBKIt8420hq9JdBcJmIZ10CNF2zqaz/dra98MtRgL5Gq5/To/vVi0EoqdE/QayYD4XNga5CslRPmOZ3wRDa02/BN6YmpgEuCNo2XE84v5Sp9h3b6GG21a20AEbb8RM2CNvXYNBja1iDIcuVXXcWaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(107886003)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?880pL31y2LVYErbk0sCLpbBJ4p5fxtnsDk0xZrZLlcC9U3k2JvHi1r/KodJu?=
 =?us-ascii?Q?9Jq3QZ32N0wtHXaHyaV6W37zXnc8oHCtpgnD+2/4AOz8OVCg7rV9NrA+IuSq?=
 =?us-ascii?Q?tr+6dOxeM2pVJwbMQpXNfIVgEby8df96eBXoKUPr3SW4Fai+ltU4z9IgZvu/?=
 =?us-ascii?Q?8gWHMhsMC/8syi/rnuOVr01FL1IAWdem1i/sNmRKEY+uhgmPczDj/U9BH3+o?=
 =?us-ascii?Q?08byvR0NuME2qJc9MvGcpm0juYLGVHmf0z86e8uZ2Hdf8LKce9/1p/FDmxRo?=
 =?us-ascii?Q?vv2sTPhyC4TM3BQsk1RR/mlJhisYB+jkgcMwKYl3vi5bmeP7V0VLQgy9UG8l?=
 =?us-ascii?Q?0za2fsDoVwnAHDF5Va2wN86ODbGP6imNyBQRvSPVvJ2mFsFW/Qyt0fMHfYx3?=
 =?us-ascii?Q?sObUEMnu/5yZ29dpJAZuMV9s/yCDSCTrH3hKFnfoePEsLqR78+xLYg4BIO0k?=
 =?us-ascii?Q?l27x5v8yztl8pV0QTUWO84BSxgHJipXPxGtFgxo4DNCU11GoiDmHs8Rzm4kt?=
 =?us-ascii?Q?d84zdGLkoPv6cqtY9kh9lJ79574YHs578hUrxcLz6goS2l07StUCHD7cFoTu?=
 =?us-ascii?Q?FpVPNOEqyMm0HOvcCr4AsDjuCdZ7O/B5vQm6bAIKzJKsHf0SbIleTzlLwubN?=
 =?us-ascii?Q?8ePPsjizYVU3YCMfcO+dxT28/Kz3PgF4aizc8Qu5fu6AETwgwY0S7mV5/SGc?=
 =?us-ascii?Q?nKNaPs1aRDp0Wj866Ej23acg/Lnszx4xMEehqY54+n0JkmrwfR+3W+VMhLsx?=
 =?us-ascii?Q?TczIx3KfWJcxY2r0JbiIY0URBhiir5/spAi1eh2b2iDyaO193Mg5Ma3Vlo49?=
 =?us-ascii?Q?+SRYhh7kamCoB9gg+RjoIYa0eU0tc9b7QoQ66vkrqhEwp/9urq9fzpmtb8OD?=
 =?us-ascii?Q?dFLSTL0zrTz/k1V4JRjqvNwAVbGGn6h8BMv+lqbCqnSfwrsSHuahqZDW1Rqt?=
 =?us-ascii?Q?+aiw7IP8BhO3bFp1eTCSEjkqF76UcQ4KaRdCSQdY2Rs1W1z49hHz2YEBZXgr?=
 =?us-ascii?Q?l39I/e+5hBXCmyJT+Bz28b61ycuH4ax+g9Lc0DsFn33Fqs3fVQIv95d2nQRf?=
 =?us-ascii?Q?39MENERDv28pKHQ6GqiB8c2TlVvJqspoPhcalrQyfrEZGkRcV/pOo8fHCrUh?=
 =?us-ascii?Q?QSobO90FpZYj63yEYHBt4q+8SVw1q5C3SQ0tQeFMkv3NHJKe3KrPiVcItRli?=
 =?us-ascii?Q?x/eqYAAUNLQ7QzaBsqDiEILQBBA0nSBLp+48Ezrz47i3WqtC8QbucpX2YBh6?=
 =?us-ascii?Q?0NX5g/CMsQJ2v8r/cRvYrNeH38qNQbj1yvg8HsxzblCel3zS5/opmzUYGCox?=
 =?us-ascii?Q?Gm/cQpgS9VT0mutlXpAFLWo367c5vdUp7O3kkVjcEzjfySfB82ZORbWd36sl?=
 =?us-ascii?Q?ITG1zjU2s/U95qSG/wji/CPm5hnlVDQeY++YNrR5Hx+l+RvnblC3Fdk5C3Lz?=
 =?us-ascii?Q?3KYoBk/jjF4bSUCp1GLN5ggYYj81vzxzbPjo0+Q4O3rVRQ4ePcPAS3yny5TG?=
 =?us-ascii?Q?/rRFGGecqB6qzpH4882/LqnREloGvPxJ3Sl+CyejQDBgwRyyWij1eaS+HBi6?=
 =?us-ascii?Q?fji312exxVopxGNPfkmfGmBPm733LZIB5tiky2zRI3Yx045kd6yZXGfYpo9r?=
 =?us-ascii?Q?1w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6be7c7f1-8e27-4f20-6dd9-08dad9ac8476
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:40.8177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dszfu+BjPLxzcVmyTFcQykZUXzqPpLHOer7au/EzFjznLKRmwIoPsOmd41mZEg51xPhSz6L7OVuMjbGSeKR7/+g1nQWuDlsaPmrX5sRNw4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090053
X-Proofpoint-GUID: tZ-GeA_J-eRGhBCtv9helIK-t1ELfZWb
X-Proofpoint-ORIG-GUID: tZ-GeA_J-eRGhBCtv9helIK-t1ELfZWb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert scsi-ml to
scsi_execute_args/cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi.c       | 12 +++++++-----
 drivers/scsi/scsi_ioctl.c |  7 +++++--
 drivers/scsi/scsi_lib.c   | 20 ++++++++++++++------
 drivers/scsi/scsi_scan.c  | 30 ++++++++++++++++++------------
 4 files changed, 44 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1426b9b03612..7717eede4039 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -309,8 +309,8 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	 * I'm not convinced we need to try quite this hard to get VPD, but
 	 * all the existing users tried this hard.
 	 */
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  len, NULL, 30 * HZ, 3, NULL);
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buffer, len,
+				  30 * HZ, 3);
 	if (result)
 		return -EIO;
 
@@ -510,6 +510,9 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
 	int result, request_len;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 	if (sdev->no_report_opcodes || sdev->scsi_level < SCSI_SPC_3)
 		return -EINVAL;
@@ -531,9 +534,8 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	put_unaligned_be32(request_len, &cmd[6]);
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  request_len, &sshdr, 30 * HZ, 3, NULL);
-
+	result = scsi_execute_args(sdev, cmd, REQ_OP_DRV_IN, buffer,
+				   request_len, 30 * HZ, 3, exec_args);
 	if (result < 0)
 		return result;
 	if (result && scsi_sense_valid(&sshdr) &&
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 1126a265d5ee..5ce90875866e 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -69,12 +69,15 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 {
 	int result;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 
 	SCSI_LOG_IOCTL(1, sdev_printk(KERN_INFO, sdev,
 				      "Trying ioctl with scsi command %d\n", *cmd));
 
-	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
-				  &sshdr, timeout, retries, NULL);
+	result = scsi_execute_args(sdev, cmd, REQ_OP_DRV_IN, NULL, 0, timeout,
+				   retries, exec_args);
 
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
 				      "Ioctl returned  0x%x\n", result));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f76acb468abb..994e133c19d0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2076,6 +2076,9 @@ int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 {
 	unsigned char cmd[10];
 	unsigned char *real_buffer;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = sshdr,
+	};
 	int ret;
 
 	memset(cmd, 0, sizeof(cmd));
@@ -2125,8 +2128,8 @@ int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 		cmd[4] = len;
 	}
 
-	ret = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, real_buffer, len,
-			       sshdr, timeout, retries, NULL);
+	ret = scsi_execute_args(sdev, cmd, REQ_OP_DRV_OUT, real_buffer, len,
+				timeout, retries, exec_args);
 	kfree(real_buffer);
 	return ret;
 }
@@ -2157,6 +2160,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	int header_length;
 	int result, retry_count = retries;
 	struct scsi_sense_hdr my_sshdr;
+	struct scsi_exec_args exec_args = {};
 
 	memset(data, 0, sizeof(*data));
 	memset(&cmd[0], 0, 12);
@@ -2168,6 +2172,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	/* caller might not be interested in sense, but we need it */
 	if (!sshdr)
 		sshdr = &my_sshdr;
+	exec_args.sshdr = sshdr;
 
  retry:
 	use_10_for_ms = sdev->use_10_for_ms || len > 255;
@@ -2190,8 +2195,8 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
-				  sshdr, timeout, retries, NULL);
+	result = scsi_execute_args(sdev, cmd, REQ_OP_DRV_IN, buffer, len,
+				   timeout, retries, exec_args);
 	if (result < 0)
 		return result;
 
@@ -2271,12 +2276,15 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	char cmd[] = {
 		TEST_UNIT_READY, 0, 0, 0, 0, 0,
 	};
+	const struct scsi_exec_args exec_args = {
+		.sshdr = sshdr,
+	};
 	int result;
 
 	/* try to eat the UNIT_ATTENTION if there are enough retries */
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
-					  timeout, 1, NULL);
+		result = scsi_execute_args(sdev, cmd, REQ_OP_DRV_IN, NULL, 0,
+					   timeout, 1, exec_args);
 		if (sdev->removable && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 920b145f80b7..2cdba56c1265 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -210,8 +210,8 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
 	scsi_cmd[3] = 0;
 	scsi_cmd[4] = 0x2a;     /* size */
 	scsi_cmd[5] = 0;
-	scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE, result, 0x2a, NULL,
-			 SCSI_TIMEOUT, 3, NULL);
+	scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN, result, 0x2a,
+			 SCSI_TIMEOUT, 3);
 }
 
 static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
@@ -647,8 +647,12 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
-	int pass, count, result;
+	int pass, count, result, resid;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.resid = &resid,
+	};
 
 	*bflags = 0;
 
@@ -666,18 +670,16 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	/* Each pass gets up to three chances to ignore Unit Attention */
 	for (count = 0; count < 3; ++count) {
-		int resid;
-
 		memset(scsi_cmd, 0, 6);
 		scsi_cmd[0] = INQUIRY;
 		scsi_cmd[4] = (unsigned char) try_inquiry_len;
 
 		memset(inq_result, 0, try_inquiry_len);
 
-		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, try_inquiry_len, &sshdr,
-					  HZ / 2 + HZ * scsi_inq_timeout, 3,
-					  &resid);
+		result = scsi_execute_args(sdev,  scsi_cmd, REQ_OP_DRV_IN,
+					   inq_result, try_inquiry_len,
+					   HZ / 2 + HZ * scsi_inq_timeout, 3,
+					   exec_args);
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
@@ -1403,6 +1405,9 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
 	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int ret = 0;
 
 	/*
@@ -1477,9 +1482,10 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 				"scsi scan: Sending REPORT LUNS to (try %d)\n",
 				retries));
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  lun_data, length, &sshdr,
-					  SCSI_REPORT_LUNS_TIMEOUT, 3, NULL);
+		result = scsi_execute_args(sdev, scsi_cmd, REQ_OP_DRV_IN,
+					   lun_data, length,
+					   SCSI_REPORT_LUNS_TIMEOUT, 3,
+					   exec_args);
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
 				"scsi scan: REPORT LUNS"
-- 
2.25.1

