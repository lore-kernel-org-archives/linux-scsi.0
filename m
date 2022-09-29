Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A06C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 03:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbiI2DJA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 23:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbiI2DIz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 23:08:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C293126458
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 20:08:53 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1PvsP032602;
        Thu, 29 Sep 2022 03:08:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=uTH/yBfi2dN2Gzmf4fEr9WdYA89sSvyAUe6ES5Siqe0=;
 b=Y0xoQ9d5WUIkhaDDGQd33Nq7TBI0WZRfVRCieqoQ9PKBHExBhbZGaWV9ofqznN7e+OPh
 eQ9VAu4+rEzsw/0x6IM53KBb9X+soVzcFpf0cN4I32a89XEGFcevRPsNOhA6CA+5Vg/V
 eIhGXBvDyYewMlst/IeRnq2xPL1soMmrzP69RwS/UXPX2lqA8dOSBmOQCllIFZubNprS
 pd1GiC5CwXqASgvf3a/8AMnatN9Woxu8dt2KPfrejiD++Q9OJgpKYhwhyMxgng0I5uou
 zqlv7youtS+m3V2w1ArpgjemgWeNEZvAQr02aSbbj1FQ2ow0gg7mAQvco8KmXmW/Ibib 7Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssubkj1v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 03:08:43 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SML3Vl033548;
        Thu, 29 Sep 2022 02:55:19 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpv22r08-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:55:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0SbYKplMzHLjRYuAm4oJGlc5UwiAPzptL+h4mOVWhsCSM9dpLum0tVlXxX2iVDTy1KL57UAsC4IBlUgaFLACATsRBj8oGX1qmtJ93e43NkNJvqR1elcXUtijM30fuka+zTNAmFJNESUlaUNtSlplq59cT2ywxUTPEPGML/KW0B+dPXupDfpZDANiE0lZvx2SdOSfk3LhjaPEGI5FkqMGrAjMpHj+yt2uLAT6N+1+HqYzEwNOj99VtQmOEukX7FZHRxRMeJyDAy8bsrmqHegqhXWlt8CHgJagZBVmEJUfyV+qwn+DDEqzn4TXHEX538Xem5ms2pNE+dV4t86zgE24Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTH/yBfi2dN2Gzmf4fEr9WdYA89sSvyAUe6ES5Siqe0=;
 b=Cn2w1OOVezMnDTWJp8pMN6EOfbL1mqFaY2o5YNo97/CZT41X8RvXYgIJ2Yq5QAsQPGSVG8BaoHyKefCjpaozWTDYv7jo3GJbIlIdPb7NaUP04+3J1Q/9XNNIADa1sTqYdO7Y+m7lmMJuOUS3+TIQI0eeBOd5Ln8cHqBAatVE/murHOlOPfcoAH5Pdd6/77u51mK8uBiA6Kl4WWvxIUhQP7fSBy+suHQW/755yImHs6Z9GBuBhODy5bOnFFgj6aEi8vw7fdjL5u9YH180kAyCeXzIIonEXUkkg0JjoWX8sW0ovFoh2N/JlrXnYwLUSoDnYt8sWeJclVnFexVdjodGjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTH/yBfi2dN2Gzmf4fEr9WdYA89sSvyAUe6ES5Siqe0=;
 b=EtL4mvD7SOr6WDskjglvo44GY9vC6KOx4GDmoo8O0+F93DIXVAaIXtbVh4qhyq5bkpNhd4kyQcrMSecJ75i7u0Z0nFlHRIUMVQX6pUpyNxlzks/Ukrv8u6S8H5HT9gLYnMV4yyV7nnRbsfqF/flboJzI4vn4zdt8gIM68BRB7Xk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 02:55:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:55:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 35/35] scsi: cxlflash: Have scsi-ml retry read_cap16 errors
Date:   Wed, 28 Sep 2022 21:54:07 -0500
Message-Id: <20220929025407.119804-36-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR19CA0010.namprd19.prod.outlook.com
 (2603:10b6:610:4d::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: 15a7791e-e8d7-4814-8a87-08daa1c602d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CAYzdyS1gDE+Kp/rP9LDJKWi4CFpYBdTzZEsE3Ia/gF9Eowu2hJbVuZjQ1IB7jaO2gOqcA5AmkHBAL7+1dHHWhZxsJDTImJ4JEHUrn4JRBlrfYz72SeAhqSv50smIJFp873OtTfUMFYwxDtDWFlN6ME8h6gf2cml+h5SOBSX8Sa3V8OTQ60Tfvw35s66uWJyc450nr/grOIJS08FPSTjW5j0nIXikc/BaWATPMRHaLP/pMQbpiiOOQTaMQxruUHMaENySlD9TnbbgMCmjlK0lLcP+InXiCSkvAzxsxKNs854sMFS4nBf4Vs1Ld51TUYCJaDC+5P5MHBVZBmNRMZVRUW2eZGOrmvUmTrzdnTZme+FhDZJLmjZ+vRnQnGK+Ct2Djt7NHnu/OuQwpFfsHTt79zrc+S7TK6fJ8V9/bxcb8o3jNzPDPMNf0cEtgY+6TbJ+l9GgAjmJhgcCgIFk3vwCuKHoPeGyKcEHJ2js2vpKXhVUlv64VRuZmKTqItAk/FCWax4aI0+ilcwUulddaGuPe+i+Xnhpl5B2IvvQXagujHDKqUxhQcoep6z8Uo1w/PCaJgqyFZJXqhhrbn668mZU3XP4c9kc6Qbp10F0y5LxJawEp+/KHWSBjIt2OxJMMJGIJJDAsHAJdJFJNLOZ+AC436DVfFhd05GAyfYaMFL2OXwKtgVaa7cyKgDOy1Gt1n472NmfcZ3cfzUIhAZAIXT9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2906002)(41300700001)(83380400001)(66946007)(6506007)(107886003)(6512007)(478600001)(8936002)(36756003)(6486002)(38100700002)(26005)(186003)(1076003)(86362001)(4326008)(2616005)(66476007)(316002)(8676002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wAb0kdH3mKdT5qkj6vW9bg4x10FzBSfdU+r5dKKWqGf3f1tgw46cUk4uoLas?=
 =?us-ascii?Q?F9LsMlad+XpO/FpjKrSNex3LO9CUwi3A1eOvbPUdi6ijnw5hxURPjLllpiqK?=
 =?us-ascii?Q?iGIbMAiQjbkadj/+zlglhYI0rgX11wvs7wykBNmXKRMvQbrk6I8aBZhqOMP2?=
 =?us-ascii?Q?TL5agTOFSo++eWTxnw26qgk8XW/T9BLRHtbt5rl/SkqQrwtPVsuocTuJJqKN?=
 =?us-ascii?Q?Mmc3eJkV3tfX/YstcKdhG9Fmtjpwg2/GYuWR349Intzaq0uoOR3YQjAjy6nd?=
 =?us-ascii?Q?4DwWN6rrW20Bs3QxBaPSSd95uXXU5/dkFJJgSBwezHJTsG4N9AqTAPsh5jvt?=
 =?us-ascii?Q?xDHfdj+aPkQpePKXRV2WdZjMaZsQI4kc24sKfWccsm/k3OWwtjI2sgAtec8s?=
 =?us-ascii?Q?mEaourvrC9a001cvg14oRgRQlket8D2T6vnfmyK453nVDSGP7LpvNKpwM3X5?=
 =?us-ascii?Q?3yeXR8gVXyxb2TSp1hTtyqC9hNjLyT/yc03LTKj+o8cWtzVG6Bu9KwQqoGwf?=
 =?us-ascii?Q?sfT9wgzuXcmlDrRMg/v9oTqmZovcfi90E2PFzWKx6TqZaOeC4bjoNk4dcafk?=
 =?us-ascii?Q?ZL0BpyFBzVkf2FNTQHLqUxVTZeZXsFyA9ZL0dOqKK4LuAzmolnFhqaAlHlK3?=
 =?us-ascii?Q?5AIx3VKXm9b99W+xV5qE6Ffi7WHxcjDEgqSVLjwfGZUMUik3RkrE1Xs2WDyE?=
 =?us-ascii?Q?j3YQSFj7sMwSr8zgErodtZu0Dc030WcuPxvSN2GH4xX2UbuJoRqrvmNZPnE2?=
 =?us-ascii?Q?9QGHVGrKVax/cZeBeb3tELarlITGcfR5ZnWcx/+fp6NNctfxTVNAv/XSaxIh?=
 =?us-ascii?Q?OfPWL+DUItCsqWgDr4i1Vl4V+TBHjtOn+Mdt5StjaMaCALLFvygZRDFI7/fO?=
 =?us-ascii?Q?b9cS1Rm+vIVXydmn6hJPNKaFeIRTXd/Wv7uv0rVqfnDtLt7N0Wz491P9HSPi?=
 =?us-ascii?Q?xfd95VnAKIrEhYa9cKB4KB2mA2uzfr8hfZh95BW3BK5O0l9GttapxemRT91G?=
 =?us-ascii?Q?15rf77R+0oaLxz9eNNw0D+5AmL/k4canh78rsmlyxIvIeDBE/mje76abWkpL?=
 =?us-ascii?Q?S4Yf+BrFFBgKRAmAYRXMSPpCDWKP9PmwoCabB9v57ulJQT7Pp3QdpDZnAIDC?=
 =?us-ascii?Q?YSnDv6C+xCzy/j/PdutSrgmyg/pNXOltgEMDBiNCwTxFYzjCFGgN0O6kZwLo?=
 =?us-ascii?Q?00O4FUiNhKEw67jdvqJB9M3Shwkqzp7vV3eWP4TDuMH/25KRp3a+rubJWY9F?=
 =?us-ascii?Q?SITk1evoxjL1GtffKOO3cYYZQJjIsG7tbaWRBK4XHF0Nbk1/ryP3HuOK7lqX?=
 =?us-ascii?Q?ax+Y+SsXP1zWqar00cQkn41Fd4A1KhkOHTY12YC/DIemRsHmdH5YjRzGd4vc?=
 =?us-ascii?Q?BoT+eD5TkHf9QspB82IoIhj1WkEb++X29eRV7ZmFoow8qgvwpzEpIiuH2IGV?=
 =?us-ascii?Q?byybE7CnjY3EIapgbJEGLgTFHu7RdFPCEclJUYwCY2uQh+LIp/tfXEp/aUbj?=
 =?us-ascii?Q?NYhFcYWCCOAOEWOAwGeI6j+sg/fdhAbagXPArcXEO7YhxrCzvUhm8/VlqTcc?=
 =?us-ascii?Q?J0sis3D0mPLKdjejOCPnXRmPcm6XhszNNE8frqDNBaz898+XWN4dOPrAy55T?=
 =?us-ascii?Q?sA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15a7791e-e8d7-4814-8a87-08daa1c602d6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:55:05.0963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8dkHUCfKLt39PPWKxfhr2j9r1zNcKFC2j82WFo/J5fB1ux+jnaWreOJZ6q8ftb/tl+BIcBVfVsHFBMAIZQYN+9Zn35MzLkP0/74z34jqmfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209290017
X-Proofpoint-GUID: jtDFYgNLbRY7cbWE-A0XcN4ySdQ8qi4H
X-Proofpoint-ORIG-GUID: jtDFYgNLbRY7cbWE-A0XcN4ySdQ8qi4H
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_cap16 have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/cxlflash/superpipe.c | 46 ++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 724e52f0b58c..8627c825d031 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -337,10 +337,32 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	u8 *scsi_cmd = NULL;
 	int rc = 0;
 	int result = 0;
-	int retry_cnt = 0;
 	u32 to = CMD_TIMEOUT * HZ;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 1,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x2A,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 1,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x3F,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 1,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
-retry:
 	cmd_buf = kzalloc(CMD_BUFSIZE, GFP_KERNEL);
 	scsi_cmd = kzalloc(MAX_COMMAND_SIZE, GFP_KERNEL);
 	if (unlikely(!cmd_buf || !scsi_cmd)) {
@@ -352,8 +374,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	scsi_cmd[1] = SAI_READ_CAPACITY_16;	/* service action */
 	put_unaligned_be32(CMD_BUFSIZE, &scsi_cmd[10]);
 
-	dev_dbg(dev, "%s: %ssending cmd(%02x)\n", __func__,
-		retry_cnt ? "re" : "", scsi_cmd[0]);
+	dev_dbg(dev, "%s: sending cmd(%02x)\n", __func__, scsi_cmd[0]);
 
 	/* Drop the ioctl read semahpore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
@@ -365,7 +386,8 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 					.buf_len = CMD_BUFSIZE,
 					.sshdr = &sshdr,
 					.timeout = to,
-					.retries = CMD_RETRIES }));
+					.retries = CMD_RETRIES,
+					.failures = failures }));
 	down_read(&cfg->ioctl_rwsem);
 	rc = check_state(cfg);
 	if (rc) {
@@ -383,20 +405,6 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 			case NOT_READY:
 				result &= ~SAM_STAT_CHECK_CONDITION;
 				break;
-			case UNIT_ATTENTION:
-				switch (sshdr.asc) {
-				case 0x29: /* Power on Reset or Device Reset */
-					fallthrough;
-				case 0x2A: /* Device capacity changed */
-				case 0x3F: /* Report LUNs changed */
-					/* Retry the command once more */
-					if (retry_cnt++ < 1) {
-						kfree(cmd_buf);
-						kfree(scsi_cmd);
-						goto retry;
-					}
-				}
-				break;
 			default:
 				break;
 			}
-- 
2.25.1

