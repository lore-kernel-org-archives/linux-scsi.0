Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D17F0C43217
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiJPUBp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiJPUBN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:01:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1E2437FF
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:51 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJ28C2011941;
        Sun, 16 Oct 2022 20:00:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=r2ky/VnpqfsVUO1jYDC5N49eG5u0Eb38mr0Ylx4JHu0=;
 b=gL+vR5r8laWeCV8Zfu2dpFeMol01U8Qx6bvpowrtyoPim+FjXn1AxDp4QYjIf2YQefDJ
 7WlYG7Tvdu/njYvcplXlRs9JptvrZllGz9iG1f2YqlOWXIpZQnskqREMx6h5Lvkhw0Z7
 rKGX02mQtGt6OAeOqqDBvi1+bjSuVo6CnQGejnCc7/xhSo6KokIsoXQMSnGWDiSQBcnK
 yxjcTuVnGiOOIU9IfH9eBWtk6j4VxntEPUE54j9EAHAPoKDS1FJrivu/mQIpS8lPLcgF
 1uuuISB3SGnOCJKDplQMlg3bxSoksgCxIVATVsMEfEtIawRj1PWBKaI5M/G3WnkFbE81 gg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw39yds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCG8vf007018;
        Sun, 16 Oct 2022 20:00:38 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htdvdq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nc0ZlcQoirXOkwiI4fX8N4yAK/Bh5eR3OGrCur4za7XstDD7CzltQ8CVO1ME6RuqklSL7Ow1SZN5UVBUvlarIrb+58TfO6oFsQNuWVQ7Um5H+E4w9xxukKm9z6uxFO8CwtfE8PhRs3yDuYYQL613SSG9WBZQSYzHBSnXDhzXJI2mvr7VWE6Nnmz+4S0VBjkIaOtGnKbBIDQKCw3PfU8KGj/FwbX+8ORSOFhbZ8LDTex/0A7hzRVZKz0GFV7oMmnxTorHh4stvQkGZE3mFyemy4YwF0CinD/X11TXnUSWnivqF4rFPwdvrQ4CApI9XCEMVdI/8h1WvbdyIljYiQWLYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2ky/VnpqfsVUO1jYDC5N49eG5u0Eb38mr0Ylx4JHu0=;
 b=QmspNJmvuxl3lefD9nECCJwY3zS6IN+gZ+Q2kuDau3HtYINzUHD2Gucw3+82ldrBUxSgtQU+/JFlo+9V2uqIb7eQUx+OfxnWuLPY12ls11Scf5haXRTSJNS5umeCIyZVHTY+PkHiHFkHFB87CHdxdQadJ3OriP+H+SeNfgT071cXNdOCuv8Z4y2Mgb0aFt4zgWC/PIx6EGyufUF/PJ41dVHWj52sldARF5YC+4/re+o8XxYsKiZISoqKhRB8pYQWxNnS1bRbjaZr530kWbfwxlwwr682MrIfo2yVmMwmtz99pyWX1bgSGqceQHlgrfOPQvf4rx6I0519K23Nagntrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2ky/VnpqfsVUO1jYDC5N49eG5u0Eb38mr0Ylx4JHu0=;
 b=YoYGPYlAvUsWEsWuQ0TfJ+yEzRsAw67Yovvq1kvp/x9FKxGpBNhw/7nnEIWrX93JqqDmw/Wo745OtLfbW2YEpqglHxtsAPtOdQl7x3RTc3UbXOOATP73yP2tp1DV0twg3cySKrn0icUsBJ2ISHyq+UpY5Bv5GTNWI3IB/o6+/A4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Sun, 16 Oct
 2022 20:00:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 24/36] scsi: hp_sw: Have scsi-ml retry scsi_exec_req errors
Date:   Sun, 16 Oct 2022 14:59:34 -0500
Message-Id: <20221016195946.7613-25-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0018.namprd18.prod.outlook.com
 (2603:10b6:610:4f::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4603:EE_
X-MS-Office365-Filtering-Correlation-Id: a78a805c-5e68-4d1d-e070-08daafb116f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FsP45BqyXk8nBtIAQneaO0VODu8m58gDY0TpgNltfCPyimQvFOk0PAzEuDZSw6ZrylC6rDjaWEGqzt0yjAHSgYfa6MEAwSmbX7pSqKWWKT4nKvuV2wNMhOgx6ad/8Ebkj2bIPIFKpJZm9gm3+LCS6BD/r5P2AzzmRV8yQNY6X9Bmh8gep2/tanB1Dd97mKaZiMMyQD25mXG/VJjWGB+B9IrgrS7uGTRNV6MVe1KxYWA7A7m/Uvm6THNk/R6D9NTZlpyv8bIgYgBNkLendMWVL6eumnc/jh9guzzSRg5kBiv2oBH+kAnb/9nbZoknXhA5xqowcx/X7wY7VYR+/N+4HGtCx6MbzYLEU7shBcp89DjOdSX3Ntqsf4Xk2SrmjxtXD7eMvimbUszr6ozJeAxoTBZ9lKXPc9f8vzjWaWGVHCf5eYoyELPwt/SmQJibkc2FDi7GxoWVpqkccKIAF30yiC1fuoR8oZ8obh7ntsuEIXBvJFijTau6iYCldb8Rg74KMPysOzfyfpUTJ+8X0ZMIy+Bvm8b5yTxADw9Tur7ZWLHrCxD29ZoivdpyerAOvi17XhSKgI2Naznz1lOPZiX4ZbnAkeRT5vNikg1dmOzGJ11q8VqV6qzzZjDRyebw/0hIVl8WbG841GA1tgfUdhHOrpufSxKX9OGarRU3OiFGmMboy/jg8c+YwyKC5PyCV7Z+zLJ0k8SesGHUYv0LJfwZhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199015)(6486002)(4326008)(316002)(478600001)(107886003)(66946007)(2616005)(66476007)(8676002)(66556008)(1076003)(5660300002)(2906002)(6506007)(186003)(41300700001)(8936002)(6512007)(36756003)(26005)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3RuSreObhL/7n5q3LmDgvvyO8+1up+CKyYXimw7ENshWh7usM0erJD4CjzYv?=
 =?us-ascii?Q?X/dHjHZFzxhNtc/v7bPFLqC65aLxI5HR+XZWi5f90jlUg9OTUdd4g7QMW4dL?=
 =?us-ascii?Q?BZvgiOTvcYWCYo81KHHERVtV+PSOAhGxikGcCmcdmGtA0FGJs0idI39I3wWR?=
 =?us-ascii?Q?lovB/z0EuP8ip7PNrzkicNhtaTXxIVN1zMbO4UnnwukymFNKySv36EGfm6YK?=
 =?us-ascii?Q?ImzkbnBDgO5OxgV2EhoC+15R7WKos2iqlud4v6pWLWmCSuem/p+RjO+O/qml?=
 =?us-ascii?Q?Ws1ltPlEgAK20Pz9zJaYj68ys11FEuIICmZBbKDcxBzGpviHH3zfN88ZdWqc?=
 =?us-ascii?Q?GkE/Uin9J11nu9SLA8gjs65LOjqmU9fY9RHot8MQ10xTno+6/Bsu4nukGa25?=
 =?us-ascii?Q?rYkSkPGBCbXn6kk7ItSlwJc5QT28AGVnkBoWawJ2LpBVNIlmQoT8qTCL4sch?=
 =?us-ascii?Q?gBzBzL0ws7hTO4DuwIxdW5kXTufwE8lEt2lC0c7MtA4Ytjdv9uPpVbWqYO8v?=
 =?us-ascii?Q?o8PwjyoAlELOgYe17RLR7uuaLF8SqwS3EoqKU1lfM4MuxZ5Bw+QrQWk+zYDR?=
 =?us-ascii?Q?AcGIwjJ3+pYNVBkK2ssg5HO+n5RS98spUeNDCb21SjefLOAlQFK4ZXIu1uCg?=
 =?us-ascii?Q?VPt//s6PYDGyD/H1BTxCxxt7KTJyGdtVT0De4AeBGWjpR/kgzDRimHYYYLLg?=
 =?us-ascii?Q?0JGVIxMTfyiB2o0iNjNaJy/UqsQ5l0i8bAEwe9hR+aE20MA/bAIa5XBXuhmU?=
 =?us-ascii?Q?NRIrH5/oQR/JMFYCanDkbUphCQjrfzdWv/MS6Np983rn1gEJb3+zF9RmIn7a?=
 =?us-ascii?Q?99fhdkBpkimE57x7mFyEk0pnlPyPfaCRl2MMuigWEshT//pTc7GWBOGmkK8V?=
 =?us-ascii?Q?kxSs6Y03qf+5GEZeVolygegwo1w47Qdnbi+nLqOhBlkEML0mQsPBXgq+b3SQ?=
 =?us-ascii?Q?3XVv8Bp9WTNnokbY/XS6qKAYLmXqRDagD+y9ePeaBszA56GatZG/jRDM42qh?=
 =?us-ascii?Q?bl1qL93KZ/XU9qj+FHTM8GaPnC7zXMUL+eZOFSmLiR7Y+ptna/pyI12lN5M2?=
 =?us-ascii?Q?pFXAgBWxuoYaKfd+bZ7bXKSW+kpMWW3inAIA9xgUtm9NtuVpHcF9hSKNlctp?=
 =?us-ascii?Q?mKMY0TV0z0TJiYB4b0//fujkKW2RuL0lEykT3SfI4CTqfzdktwMr3IiuMLse?=
 =?us-ascii?Q?VukpjhUDihEZDXfbq2f+0eC2hrUxdiQ2rVzHiVFUt2AwSKxqHvO39wylZBx0?=
 =?us-ascii?Q?FBlxjgFLBLuzfQqhEnUkMBnt2X/2yuB7RQYR6D/c6xZJnzUkEQhWvwrlLxJM?=
 =?us-ascii?Q?vdOYqOpgXvhOL0sKu/dRi3Cm69AN2uO716Wb8mp9mu3DiI3SrhgPgCneKDPq?=
 =?us-ascii?Q?P1QJYp6ABh3AqlG/4z4xCeIjeNdVKVb6Xc2s90GQQz7D+PLMbPRDhzYlaqoa?=
 =?us-ascii?Q?2f4T6xbYL/U2fYmdUGyoOgcMNW6KaBPZWp5S1LnH3gwIDqCN0/y2/y64+gYj?=
 =?us-ascii?Q?lExfXpiLT8nx0pQdm7dhs2L5gKre4F5Vp4sYApk4pHowZFifuDqzGaTj+1Z8?=
 =?us-ascii?Q?QRS8AvgDaP6m/yBq9F6c7o57bVOwl1rIhuOL/dUqm0KX2y3J03TxPMCwDrph?=
 =?us-ascii?Q?LQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a78a805c-5e68-4d1d-e070-08daafb116f5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:35.7037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TnzAPuTIcl1a3+8+d+xsb+vveLlOOFdIwew+2Wopo6M2Z5l6bpUcidTcGpQu6w1qrHZVjpG/zGrpvUVPbTJrQKR9oNqGeeuUfqig1+qvmNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: qPtkiZH_e5JtTrV55Wvn2WFmebbM5nn0
X-Proofpoint-GUID: qPtkiZH_e5JtTrV55Wvn2WFmebbM5nn0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has hp_sw have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 46 +++++++++++++--------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index adcbe3b883b7..8c09d512a415 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -46,9 +46,6 @@ static int tur_done(struct scsi_device *sdev, struct hp_sw_dh_data *h,
 	int ret = SCSI_DH_IO;
 
 	switch (sshdr->sense_key) {
-	case UNIT_ATTENTION:
-		ret = SCSI_DH_IMM_RETRY;
-		break;
 	case NOT_READY:
 		if (sshdr->asc == 0x04 && sshdr->ascq == 2) {
 			/*
@@ -85,8 +82,17 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	int ret = SCSI_DH_OK, res;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
-retry:
 	res = scsi_exec_req(((struct scsi_exec_args) {
 				.sdev = sdev,
 				.cmd = cmd,
@@ -94,7 +100,8 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 				.sshdr = &sshdr,
 				.timeout = HP_SW_TIMEOUT,
 				.retries = HP_SW_RETRIES,
-				.op_flags = req_flags }));
+				.op_flags = req_flags,
+				.failures = failures }));
 	if (res) {
 		if (scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
@@ -108,8 +115,6 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		h->path_state = HP_SW_PATH_ACTIVE;
 		ret = SCSI_DH_OK;
 	}
-	if (ret == SCSI_DH_IMM_RETRY)
-		goto retry;
 
 	return ret;
 }
@@ -126,11 +131,24 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev = h->sdev;
 	int res, rc = SCSI_DH_OK;
-	int retry_cnt = HP_SW_RETRIES;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
+	struct scsi_failure failures[] = {
+		{
+			/*
+			 * LUN not ready - manual intervention required
+			 *
+			 * Switch-over in progress, retry.
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x03,
+			.allowed = HP_SW_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
-retry:
 	res = scsi_exec_req(((struct scsi_exec_args) {
 				.sdev = sdev,
 				.cmd = cmd,
@@ -138,7 +156,8 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 				.sshdr = &sshdr,
 				.timeout = HP_SW_TIMEOUT,
 				.retries = HP_SW_RETRIES,
-				.op_flags = req_flags }));
+				.op_flags = req_flags,
+				.failures = failures }));
 	if (res) {
 		if (!scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
@@ -149,13 +168,6 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 		switch (sshdr.sense_key) {
 		case NOT_READY:
 			if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
-				/*
-				 * LUN not ready - manual intervention required
-				 *
-				 * Switch-over in progress, retry.
-				 */
-				if (--retry_cnt)
-					goto retry;
 				rc = SCSI_DH_RETRY;
 				break;
 			}
-- 
2.25.1

