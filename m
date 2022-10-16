Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9199C4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiJPUB5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiJPUBQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:01:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D06D43E49
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:54 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJXnrT015579;
        Sun, 16 Oct 2022 20:00:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=3w0UX2ZqiBlW2PS8bR9mI5uNY046r91V5K3LINURgPA=;
 b=bVD2XDy0tAfwx5z8zaPF/YZ/JnUAJgCj6qb0M82/7keqwIzaPOdYbzbe7DixscRt73+s
 Y/s681lk7BSp65DpkLXR/LRMY/BYL8XoSFsYA5JkqpIC9de3TYLReuoaW4+n0VLbb3hL
 oE52uSfIfXeAgGr+QKGOOBppQ12hqD2WCuT1tiPiKGz6RIY5QidmIkFZocKvATMn6C+D
 imnjOhJxKzYX1MhXuPId7w/eh21KNPlu6HSTLqDp0YfrKOtwHnjIL8+mU+0H511M2nzK
 d4xx/yBx9pJA+kcfRSX+5tDAxCZNUrusgPpcqXiFwgGPP6L/biCUAxdRWTH6EgIH8zeI hg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g7af-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCG8vg007018;
        Sun, 16 Oct 2022 20:00:39 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k8htdvdq7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d4m4TX4SuI4y1VAgs+f5H9zXdiqgvwhr79Og77/L+zFTM0HU9teDpYpWcwNi03UJq9Bpp4pwwcrCdiSm+kliYdGGJm5SnavJIJkY9fsoq1oNxH5DitZI84NjZVR7fEm8KKOSzbu6F3T8kTNj4+dbP7L1n2txgxhYQQ4SI0KZXld95ml9shgFFpKl3Xkuxh3K6mlOAZARN0GJjwTwgnfivPCKB4DgIgq7hp0Zz4cBsYii3Nz74gq+fnSKGBOLF9OqS7JHAzOUFCU4h0mfl8E9nWp1UrJ/21Fuu0w6Z+9CWwasFtIHUubTpbC2Amg8kmx6+m328VRpX4qbYx3mPiTDJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3w0UX2ZqiBlW2PS8bR9mI5uNY046r91V5K3LINURgPA=;
 b=fm2YGlEHs2j0gO7jEzCusok5ZfzZJfJj7YEhlpqx6ResWPVtoTt9R6nCc/Rc4w5DOu5Zq0ZU1V5GtQlq5+xRZyoax6ocdOFId3cN28lKT5ocmXE16fMfZJixTfM2QaibZ6ukfuPeRej6IYuT3kCuy3qiux2wIamC0YfQ3EzhiLtMBLa+wEFwnQHy09l7jPt8YYmAxyo6nE32LeEv7Nyd797DqbCQ0b8Ub4VI0+Q4Yn0c+ZEHLBkz+y+KhkdmLwAVwVfqSbZqdKZDbThvH0U7S9l1Um+vAxjBmBfL49UakfvIiwUG+Cs1IA3a8k1K1YMkZ/vCaJJWF1qBM63Xax0N3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3w0UX2ZqiBlW2PS8bR9mI5uNY046r91V5K3LINURgPA=;
 b=vVhE+OVOHm6+ypofbIK9PytwQYvgRb3Emm2gwc5KUSDU9lTkRwlfGT5X4gaAbaSsp813k1oe3T0Z5HVTJOPIJDBifUCVYszzKYa2y3kBqCWLo9S05N6SzNB0+x7tXNfW+NP1r05l1ylNNBk/LUnnbtzGqF/JJq8jDzvzSLwtddY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Sun, 16 Oct
 2022 20:00:37 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 25/36] scsi: rdac: Have scsi-ml retry send_mode_select errors
Date:   Sun, 16 Oct 2022 14:59:35 -0500
Message-Id: <20221016195946.7613-26-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR18CA0023.namprd18.prod.outlook.com
 (2603:10b6:610:4f::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SA2PR10MB4603:EE_
X-MS-Office365-Filtering-Correlation-Id: eda550a8-a9d4-4e7b-342a-08daafb117d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kOlNULJu1eKxFuj2Qc7+Gy+P5w1+cfY39blHnM6pMsv46GNofPyTJEOJdcC6TVEHHHRD5GsrrL/ZlcmvyTGOIkDvB2PQhX0Ry1GqmAFvBfcr5HkD4otLSLUb542tbba6M3O/ubsW79VpG6e6JYT/o8jdpfPe6bI/YXlc9GQpCERCdl9dQtC16bWEVWz+KQf8VtwvV/0+ci7zwT4H5Mwj7u1nRZ58/nF/+wi733075RHCXLxZvqTS1YDLwIimYpa0P1D4Y9E2JABfs0VwdFLxtSZHK5hz7BuR6rdOIBQfj3ijdkCB0GFs0t/o0eb9lESAPv7hPw/gNoOMgbrbQGibHLDqE3HYt5v5Xc/B9K9qYPQr6DDQ8xdMwLlzqhUfMGaiineDxLoICm+9q5IKPpT3kvCZluQiTpfjWiPk10k8Wolx+kLkVLRIxmf2UmrhaKK1t+tNs8IYD/A5OCe14M+CnZCyISYavwXeHy4nUnBsd64fAD/4Y+qziBKLJqrVm1lux495Sdd3zg/NMiMmYUnbe9sWVcj/HHRmSqE25SbKB5u9H8MHv7Op+koyrSS8YQEC4r4Yn31mRg/0oXn5z7yHLpk+2DeDyXzU5+h9a1zv1GoxV5ZvbiBzWnGs2OW1tgOEX6nrj0slaUdfwMTZ0543QP+f5A2SUPjvDqAW9McJukU2Hiv6cKXjB5AgsfREBfWrfmXCyihThulQkcpQf323Sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199015)(6486002)(4326008)(316002)(478600001)(107886003)(66946007)(2616005)(66476007)(8676002)(66556008)(1076003)(5660300002)(2906002)(6506007)(186003)(41300700001)(8936002)(6512007)(36756003)(26005)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ofit5w/2CXugmJUXF/aff33XaWvxJTA6i3bxTQEWDNV+PjqZvSfWLiJ7O8f0?=
 =?us-ascii?Q?AheajM2GJb60FFvASuk/DIHsZvOUW6vrvhxBwDmchN6Wj6kQk8C7D+Kd3Rls?=
 =?us-ascii?Q?/+zcMyLuOqghknypeVyetgmuq3UIfEIwv7B7RuFEuI7c2kWPKBnss1t/b5Sb?=
 =?us-ascii?Q?cQ58r0MWHGb1U+sdBPyYHuxcMVE/I31c5yhnBMjT1dl0VxjP6M8ggJHYWgGD?=
 =?us-ascii?Q?fNv3NxTj0o75US+zev3ztf4A8VlaOc5ma8QKiUyTthdEXEHObI8L9xfQpyW6?=
 =?us-ascii?Q?y+W/Eb5bSEU7ljIt+CvalYmOdJarqM1ljUNik6jOREah9rEmwEP/1vVJSyjO?=
 =?us-ascii?Q?WRDfjdQX9CYg/qaklMahJ1DAniBwH2xHZiTKuVClUxgtetS5b+rDz8bWpAp+?=
 =?us-ascii?Q?wAQ1jbAe/J2maKoBEizTuhvkzvVLTNCTyHZfhj9+sj5eTQdXdfsrUBu9jZJy?=
 =?us-ascii?Q?C+DXUk33KTvoRsSuWUz0mQD0S21SU6fm4gKW6KcVWGXz9T2/dJfUihCQjSJd?=
 =?us-ascii?Q?0AulFESkaSWAdavyd9660RmCGpTAhVxsOqfDYM5+uusZh3uoMWG0FJ53BFpU?=
 =?us-ascii?Q?Uf24OKhxkf8qZLrPTh6oIv2IzYhs+eDUJoMQ8R0stDmtDWLt1/8e8wHI2UtA?=
 =?us-ascii?Q?BcomkVl44dvP49Wzomz4F4zqYWU9NnBjcUEx5LIL94b5D96e1Y1Y8Yfh5EV2?=
 =?us-ascii?Q?qLPo9Qsh5WRLegQ9KzORncf5serzGrGmVuz+BOen43rCGTSmSWhOD/TRmbG8?=
 =?us-ascii?Q?B6E9lmh53rvKRyU69yMY05M5ymkNbSEjxNqykt4Q/VzdYmAIZZsJTyW9VcxJ?=
 =?us-ascii?Q?vA8trvdb96d62uK8dp3BiKPh47i8d6y1WI2h2IbsXYWGRYxo/OzF/YlWLiJS?=
 =?us-ascii?Q?E2sB9HSrQPWMSJ7RSuvur9LAeTy+e4tWe6SFhPiKQqhZXwtacRlUncH1mQne?=
 =?us-ascii?Q?xle1DIdD3FXP5068jaKLs4o2I/3U2su2sWSfcd89dOu6nSwlzr8jLbXRIjZv?=
 =?us-ascii?Q?N/dtzk2US8XLdf1fiRrWCYch9fk1Jk2FDe2/hh4b1g0mG7LFAkdh2n2TGnaI?=
 =?us-ascii?Q?Hvsn4jefwBwgEkyRxnnAUGuvVSj9iFVSICYdUFT15S/FboRjV74tpvchE+qf?=
 =?us-ascii?Q?dJ4S1DcuqcnHRyri+pnRn7QaDvA3O0o4QVr/0un4vl0l/uktTOn26WSHxJsu?=
 =?us-ascii?Q?9uhrHHkR3VEzhWerfSM4KD2nYPwbGdk92rTWgPNeuZDweAwcsWbJrLiH91QV?=
 =?us-ascii?Q?VvvKEFSgX0YMWzM5x/c/DiKZ2Ytejw1GDjT/L0zbEI8LKvHrSQKt6LH98FGH?=
 =?us-ascii?Q?8dY1PwwY36GaKgSn0tgAK24fZOOSIDZr2jzT1BEsGGZOGBJp4IlczZE6C6qj?=
 =?us-ascii?Q?zeiXDHb/B23aXJa9Wk7wRHMuwWJAXY+ex00yvQ9ykJAjUdRKzAur4fmBFkzI?=
 =?us-ascii?Q?hAmQ8zrWypXTX+vWB5UPc33LcuPqMqiKoIHWK6pilw+FWtHzZgWIrH6gPcRW?=
 =?us-ascii?Q?2iTGmUIpnhZ3foyt4Ds1LKdkvdtE07bY20SDEWtvlHbhs/+3ofVZI/eCLNIN?=
 =?us-ascii?Q?POyMD5iDduzDrblxF1O3xGSn3mGOk96HgNmtp4wT1EayJ1lUvgnsqkxr3Jfw?=
 =?us-ascii?Q?VA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eda550a8-a9d4-4e7b-342a-08daafb117d1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:37.1098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h+3eabboEoY6QKU3R4haYV8BVIj8rNA0/4nEeExBjb5XWXr8/e0ZiySzI1l/9UkHKmmfWzX9aksOs/In/EgAyOeo5JMSPFOQ5XHJ333XyIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: zWm2VL8YxSUNaAphdLaqXMPMR8NxauW6
X-Proofpoint-GUID: zWm2VL8YxSUNaAphdLaqXMPMR8NxauW6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has rdac have scsi-ml retry errors instead of driving them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 109 ++++++++++++---------
 1 file changed, 60 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index c4d1830512ca..480185d57071 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -485,43 +485,17 @@ static int set_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
 static int mode_select_handle_sense(struct scsi_device *sdev,
 				    struct scsi_sense_hdr *sense_hdr)
 {
-	int err = SCSI_DH_IO;
 	struct rdac_dh_data *h = sdev->handler_data;
 
 	if (!scsi_sense_valid(sense_hdr))
-		goto done;
-
-	switch (sense_hdr->sense_key) {
-	case NO_SENSE:
-	case ABORTED_COMMAND:
-	case UNIT_ATTENTION:
-		err = SCSI_DH_RETRY;
-		break;
-	case NOT_READY:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
-			/* LUN Not Ready and is in the Process of Becoming
-			 * Ready
-			 */
-			err = SCSI_DH_RETRY;
-		break;
-	case ILLEGAL_REQUEST:
-		if (sense_hdr->asc == 0x91 && sense_hdr->ascq == 0x36)
-			/*
-			 * Command Lock contention
-			 */
-			err = SCSI_DH_IMM_RETRY;
-		break;
-	default:
-		break;
-	}
+		return SCSI_DH_IO;
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 		"MODE_SELECT returned with sense %02x/%02x/%02x",
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
 
-done:
-	return err;
+	return SCSI_DH_IO;
 }
 
 static void send_mode_select(struct work_struct *work)
@@ -530,7 +504,7 @@ static void send_mode_select(struct work_struct *work)
 		container_of(work, struct rdac_controller, ms_work);
 	struct scsi_device *sdev = ctlr->ms_sdev;
 	struct rdac_dh_data *h = sdev->handler_data;
-	int err = SCSI_DH_OK, retry_cnt = RDAC_RETRY_COUNT;
+	int err = SCSI_DH_OK, result;
 	struct rdac_queue_data *tmp, *qdata;
 	LIST_HEAD(list);
 	unsigned char cdb[MAX_COMMAND_SIZE];
@@ -538,7 +512,49 @@ static void send_mode_select(struct work_struct *work)
 	unsigned int data_size;
 	blk_opf_t req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
-	int result;
+	struct scsi_failure failures[] = {
+		{
+			/* Command Lock contention */
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCMD_FAILURE_NO_LIMIT,
+			.result = SAM_STAT_CHECK_CONDITION,
+			},
+		{
+			.sense = NO_SENSE,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/*
+			 * LUN Not Ready and is in the Process of Becoming
+			 * Ready
+			 */
+			.sense = NOT_READY,
+			.asc = 0x04,
+			.ascq = 0x01,
+			.allowed = RDAC_RETRY_COUNT,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 
 	spin_lock(&ctlr->ms_lock);
 	list_splice_init(&ctlr->ms_head, &list);
@@ -546,33 +562,28 @@ static void send_mode_select(struct work_struct *work)
 	ctlr->ms_sdev = NULL;
 	spin_unlock(&ctlr->ms_lock);
 
- retry:
 	memset(cdb, 0, sizeof(cdb));
 
 	data_size = rdac_failover_get(ctlr, &list, cdb);
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-		"%s MODE_SELECT command",
-		(char *) h->ctlr->array_name, h->ctlr->index,
-		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
+		"MODE_SELECT command",
+		(char *) h->ctlr->array_name, h->ctlr->index);
 
 	result = scsi_exec_req(((struct scsi_exec_args) {
-					.sdev = sdev,
-					.cmd = cdb,
-					.data_dir = DMA_TO_DEVICE,
-					.buf = &h->ctlr->mode_select,
-					.buf_len = data_size,
-					.sshdr = &sshdr,
-					.timeout = RDAC_TIMEOUT * HZ,
-					.retries = RDAC_RETRIES,
-					.op_flags = req_flags }));
-	if (result) {
+				.sdev = sdev,
+				.cmd = cdb,
+				.data_dir = DMA_TO_DEVICE,
+				.buf = &h->ctlr->mode_select,
+				.buf_len = data_size,
+				.sshdr = &sshdr,
+				.timeout = RDAC_TIMEOUT * HZ,
+				.retries = RDAC_RETRIES,
+				.op_flags = req_flags,
+				.failures = failures }));
+	if (result)
 		err = mode_select_handle_sense(sdev, &sshdr);
-		if (err == SCSI_DH_RETRY && retry_cnt--)
-			goto retry;
-		if (err == SCSI_DH_IMM_RETRY)
-			goto retry;
-	}
+
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
 		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-- 
2.25.1

