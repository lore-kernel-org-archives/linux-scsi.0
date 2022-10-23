Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85BAC433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Oct 2022 03:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiJWDH3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Oct 2022 23:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiJWDG4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Oct 2022 23:06:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C672C7173A
        for <linux-scsi@vger.kernel.org>; Sat, 22 Oct 2022 20:06:47 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29N2t04Q014578;
        Sun, 23 Oct 2022 03:04:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=8X+JWQUV8Od86j1ax9yjgfmge9XaVfHHKHWpm1Ex48Y=;
 b=TRk22QYbudxvReRQxVcRH5bkxt/yaqHlZEfKpZn8JX+QvvSsj0lVsEvuqGH3kiJcHbeT
 X08/LIuuUkNevdpRIMtChHW8op7TZslEpdM5vrGXogKkLwylLX0oqp86eDa65/8PUDv3
 rAhymPLGuGnv/28+83cJX7bed1g1LpuQj6gkry5IfmFyvM4vRaIY1EfWL1DX/estmsK2
 q66P3goQJxVHKy1pTBitKHGAYj8wKiXT+cPFPt+K6wT3Q+ByplHTOPCrQJiB9ra+YLWt
 zJRHcQw2AqOZhrjQUy3g4wm5WJT4/e2v+HHyhpr7nR645erTTru1tt4ASp5Sokyk2u5K lA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a2s4q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MK5hQ1032154;
        Sun, 23 Oct 2022 03:04:39 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y30akv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 03:04:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lr0JI/THSibDabqxzRPD+2G1tYMICr2eX1QOEKlt4l4zqDw4qy2KkDuDOkHRoTix9QD3g5ywhHZTkzj3K3u8XfU0ova19Pr1C71/2JnZIL5xLOla+jwcZOWdw+V7Jt/yEcn41ZqFx5LvumXOVeCtufU1VzphwdN/MuSeUrrDVeE1an4QcZdm5j333ZeYUZLRZZqAY2/qgbU9kpO4os9EoVJAFJyZEwkuowZ0rY7tI3ynYXyKTWXiGGXdJ0QLkEpDqAXf4FS2/n/MtgTiWdhS8yOqwppURbLqLbkDBsHZaaV/+RQL7J+/AOnrnYwQu8k3hhT9zStZ8OG5MappRdIj+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8X+JWQUV8Od86j1ax9yjgfmge9XaVfHHKHWpm1Ex48Y=;
 b=T+KS5BJhXP7VvmCG+iZiYYgXmLqRUhuEHZDUb9KCpu5RRXsWiR9teUeHTRZKyG2hPulR7JzgSRIep5BlL2lS7V+yZ7zIpdOBHWd1R74Y/SkyfilMNYgfHvIIOnove1CTVurjuBY3JtvVoA6BDS/J3eKRmz3GTVutSr/OiWO8Q9b9VRIJB+368rw6RrDh4PcCgY6Vruk6I2ryzLHsPkm2xlD6Ef3pcTDPv3Tj/xOsJ8qP6VcyvHW1vHJtNELXWFQ6uIPt7yqGdQ2Lr5iCjpRSBtSmEmzcL4ApKqZDYRy7YL/4F7a8WjGKBaS4iM4QQkAXIpIsnlY5JCJp0Sbr22YyYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8X+JWQUV8Od86j1ax9yjgfmge9XaVfHHKHWpm1Ex48Y=;
 b=o0d15LdxcTs/VKynW+6TF75skB4rVoFUgNI9NwVR1D5d6aNf3YUx+z2f2d5xxqj57sNz4nMk3d6Ysxjpa0w2ulcobaayG5x++rvUmIiEUcoSjWXRA7/WNVwCjxh4A1F9wBLpxWs3SruyOM09uZ9nbb8mNCkceMyCtTwALbTmhDo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB4337.namprd10.prod.outlook.com (2603:10b6:a03:201::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 03:04:37 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 03:04:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 20/35] scsi: Have scsi-ml retry scsi_probe_lun errors
Date:   Sat, 22 Oct 2022 22:03:48 -0500
Message-Id: <20221023030403.33845-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221023030403.33845-1-michael.christie@oracle.com>
References: <20221023030403.33845-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:610:5a::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BY5PR10MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: a8d123e8-63b5-41b3-a391-08dab4a351f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fe3Hlspk8H1l4HYuM8/xJxKHUUQ1PjcdBOaC6ilubkTAw8WXM4rhf7ImxwUt0slmEICWk4CcEI1lgAQZSdR+kSJEEbPMaX10qKCoq1CApWG0QmkWdfjTBByrbqWT4AyP35qA9ZDVg29/JIidvLRd2TwVHV9JnIA6K7iL/AX+OXQgB9QjlqNcJMnWGujmcJrOwzufzIM5ZhAbOA15SgX/U8nvrVcK9QCxxjn/hZJ2WfluE+gpuLtRtNJdXk93F/VzGtAgEH8P2DDmMuI9/Aw0w4qkHvFN7zlG74EevcfgWiJsWt1QFaeHQtA8SaHlGKVPKZHBZ4OQ5S2kUGkI8wWokkBOYfod/+ue+mx1gDDCMkqrPYs6FGyflMre4KDx3pD1pDdZUNB6mXxrv9XKBtGhBvXbYJ4yU6ITbhhJGR18JisyeuMvUI8SWydYJLabUpd4j9tZweI0XWyFaOydpob3cwdZkcs/Gcz4rBDqag7kcsuH5w70sLryl/87114BkoH/0qXgAACeYPjdK9UCM5EzOApqhDUqXqSTEq5KIyjqnsQY36zyYA4IBZY4qBxZoik69rgPD0Im2zjHacSl+neTSwZx0uvDndIDTjfGzNy1BP2LSwpGcw8drqdMPDtJGPqPjSQgxaoHH37auXOL3EexkICVLfooBhzFbOjwa01K0YWSfgfyakxCsiGk12Jf3mYjlia9C8/uFy8bxksPrBH9fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(136003)(39850400004)(396003)(451199015)(66946007)(8676002)(316002)(478600001)(6506007)(6486002)(6666004)(4326008)(66476007)(66556008)(107886003)(8936002)(6512007)(186003)(2906002)(86362001)(1076003)(5660300002)(2616005)(26005)(41300700001)(36756003)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XNZZoDwbLMlW/aXtVp0xWosjj1TSgOXyuOMsCD5uXSbD+J6U+32bBhgBQjDS?=
 =?us-ascii?Q?cxtGsC3CGjuVl7h2Qp6XVd9iqBcolt5vCXu6BwhFTrtlLd3vfX2B/Ys36xze?=
 =?us-ascii?Q?kG2SjVsZZ8NddlevB/e1e525qAOy+2Ugr7Ean/Oal1VPZh8lb1k0LhmDH6/a?=
 =?us-ascii?Q?7vM70FRwrhFOnbWVad/VImwZ6cxWtEa9VlHjGvoe9P53aX0WA9bH0tG12gFf?=
 =?us-ascii?Q?xbsE9F+IYMF0y87fDgBfGp3fXIlx4BOdxLP38b3hEZmWIxgPKJ4krTgAFKmu?=
 =?us-ascii?Q?eF+rFMMCFmG5hgvyLwPo80HjKm396qtOltCKrxeeIbWk9jq0R+VCAzFbiojE?=
 =?us-ascii?Q?TZ+WpmjWCqOnxQoXKKiwPDqttBZJdzAcBJkFVLW56z8/80ccLQRrN3IDO8l8?=
 =?us-ascii?Q?mRcOymdY+mROyZNYaCcXHgBkeC76R2yNIbkvlF6JLALVlmH1ClYhavKp6N24?=
 =?us-ascii?Q?kLvc6YoOhDXY3CTYeYCOqODx/TbwbiJ1D1eNaCyXOAWhysZhX8YDuO73jrhY?=
 =?us-ascii?Q?0CvgpOyGta7FzE1E4wtXPRjgVgMlvNrHJAY6DLDx9DT4BmM653RbkCtyClmm?=
 =?us-ascii?Q?6UB3gO7WAxwph40kOlVaG5dY9l/acD1EXDmoSdiEKKNT/g67ejXncgz9Zdz4?=
 =?us-ascii?Q?0YrlWRvMGrmziBK3bzGmLuu5S4CjO+RFTsdpJGZDF86SMBDAT0hgfdMIXX5R?=
 =?us-ascii?Q?sW/xqLzj4Mi6eNeE8pUOic7BuVcLqx1OGxuYY0s1AQAAa/H3BEGu47Zawxnm?=
 =?us-ascii?Q?PiR4WFkrXd58bXlpARMysRHzGhQVAx0h+ty/kq/uRECevaVPxI4qhwjeKuL9?=
 =?us-ascii?Q?uMTSBPkAP24UqoJFP/HjbtWHS5crC+InDZOgxVtwZLn7/porGWTFMlcf0PQ+?=
 =?us-ascii?Q?JPsYpmSz8U6oF5XkgusGjWABTT+TR9rScxNw8dAO8+YZcl0qiIuoGOx4QNM2?=
 =?us-ascii?Q?G19U2b9PlbX3vApTpgIY2L/LkXM1nGQEy3685kLTFqsoTAxrC2vIiyqQ5Zv4?=
 =?us-ascii?Q?qC+WxCU4/E/FudWECrQbZ81yXVTkQmHrXPctPZg5GibMMO6QrltiCfAt50/h?=
 =?us-ascii?Q?J62Dv03Kc/SYFCcATiMOujWqNkD7T/Ij8bNJCUO51ze/OtPdRVMFiH7mAsMx?=
 =?us-ascii?Q?UrE45InRkCy9cmYZWQeih59feYCxQvZ9CzaO/2+Tcy1TEhFTVQZzpryziiaT?=
 =?us-ascii?Q?P8Ax53yuhimNOH03MgsCFrWZ7gQYubpF3WSFT2X2dl8Bu2nWr/IbHQ/A3ggf?=
 =?us-ascii?Q?9xdYVA7isdIuoI/kQyveRY/RtA9eKqRGJjeNeqTlVbZg3rhdSAM6DQtXR1Mx?=
 =?us-ascii?Q?JRaOqDwmnBhluIErn4ZOX/exfZKV/Py1i8Zsc0BjceaL/gubhpkBJ4AVhkiP?=
 =?us-ascii?Q?QjvfQ0GN8KRGDG+1xp4wf6/yRUjYOuG9z6aptodbWbj+PyHbqkvqqnWh3GWJ?=
 =?us-ascii?Q?wFPvv9ukFPDY1PwD37ZYjZYhv/Z5Ng8AQPZJISNjrlNp+n9mQshZvnNE5rXy?=
 =?us-ascii?Q?T37DuPpYdpViyJ9ZlOHu3KLCBQeMfuIv4G/NvuE9bFmixH46qAq69SAh45K7?=
 =?us-ascii?Q?0HRs/Czg1CpHRAlQjhm7WhnE6d7RlRGZTa4Ay5hYEERA63++HhLoReO2FKC8?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d123e8-63b5-41b3-a391-08dab4a351f7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 03:04:37.5136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uH3gklcDpzxqe/Qa06romhlqTikGlpc760pB/WNWAMxSIHkyohxBkPNdvFHKyN2lqKWBfFHg+7/k1E01ocggMvRKnL4/JEUpoX4qpGLAwMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210230018
X-Proofpoint-GUID: jA_mOMY5qO7nmM00y_FYAlxHrU4jdI4z
X-Proofpoint-ORIG-GUID: jA_mOMY5qO7nmM00y_FYAlxHrU4jdI4z
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has scsi_probe_lun ask scsi-ml to retry UAs instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c | 51 ++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 58edd5d641f8..ffdb043bda5f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -653,8 +653,29 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
-	int pass, count, result;
-	struct scsi_sense_hdr sshdr;
+	int pass, count, result, i;
+	/*
+	 * not-ready to ready transition [asc/ascq=0x28/0x0] or power-on,
+	 * reset [asc/ascq=0x29/0x0], continue. INQUIRY should not yield
+	 * UNIT_ATTENTION but many buggy devices do so anyway.
+	 */
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x28,
+			.ascq = 0,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = 0,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	*bflags = 0;
 
@@ -671,6 +692,11 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				pass, try_inquiry_len));
 
 	/* Each pass gets up to three chances to ignore Unit Attention */
+	for (i = 0; i < ARRAY_SIZE(failures); i++) {
+		if (failures[i].sense == UNIT_ATTENTION)
+			failures[i].retries = 0;
+	}
+
 	for (count = 0; count < 3; ++count) {
 		int resid;
 
@@ -686,32 +712,17 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 						.data_dir = DMA_FROM_DEVICE,
 						.buf = inq_result,
 						.buf_len = try_inquiry_len,
-						.sshdr = &sshdr,
 						.timeout = HZ / 2 +
 							HZ * scsi_inq_timeout,
 						.retries = 3,
-						.resid = &resid }));
+						.resid = &resid,
+						.failures = failures }));
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
 				result ? "failed" : "successful", result));
 
-		if (result > 0) {
-			/*
-			 * not-ready to ready transition [asc/ascq=0x28/0x0]
-			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
-			 * INQUIRY should not yield UNIT_ATTENTION
-			 * but many buggy devices do so anyway. 
-			 */
-			if (scsi_status_is_check_condition(result) &&
-			    scsi_sense_valid(&sshdr)) {
-				if ((sshdr.sense_key == UNIT_ATTENTION) &&
-				    ((sshdr.asc == 0x28) ||
-				     (sshdr.asc == 0x29)) &&
-				    (sshdr.ascq == 0))
-					continue;
-			}
-		} else if (result == 0) {
+		if (result == 0) {
 			/*
 			 * if nothing was transferred, we try
 			 * again. It's a workaround for some USB
-- 
2.25.1

