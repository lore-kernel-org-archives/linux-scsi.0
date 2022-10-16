Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660CAC4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 16 Oct 2022 20:01:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJPUB3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 16:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiJPUBM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 16:01:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39F9286FF
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 13:00:47 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29GJXnrS015579;
        Sun, 16 Oct 2022 20:00:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=9bWR6hXJgiUr4ymLqPipIoXShO7vFEUJPX4u9jgKu3o=;
 b=FYoJiS6cNLgkFk5nSpiB/J4h+cTalCcdcNBYAzhkTPkSlftCKjxaGR8ozPGWrHtI7Gur
 lM1kuwX62B1DEDcjXCa9APKtxw6pCKdCEoIMkNOLThFTckPMJWPjD6GfOlBr8karpLGj
 zHH3RKiM8i19gScEqOZR9aPpR5wFih4lYOckQ2IwFtYc5RpmbA2sLvhM2akk0+I+u3/A
 Bwtn/EJoXBoLiNJ68yQDpeIt3LJiZd8f2GeD/Sl8DYbox5RmS+u6c8Row8sCXMtLQmla
 VUBvHgdQYbXy0Ay5XVUHF80SrYDJWqHpq4o3iZ9U8xOa7Nb5CPFvoOQW7PK1BUQ71eH3 rA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k8jt2g7ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29GCTJNH040018;
        Sun, 16 Oct 2022 20:00:34 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8j0nc1tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 16 Oct 2022 20:00:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dXdwvKGFwrLpSqql8EwbpN0VYPBYxCXFomIIg4Y+QLMTnCO6gFmyX7vfEhv6+pYOqGUXOAl2MMz5PogQcn1lua8d3m7iF6iJRecLgAiM2Z2StB3aY4VXa4qlFvwYnvRqtg6MJQyt1fYWXfw9uKK/AU7mwM9hc5DD85yT0jaeJpmSsa5WILaMSTWaujcihMf36IUOILfI1VADVxxOrUQ+S/nCNazky16bnNbJu/4PiUblUvckJl3iM0pWlIa2xShhjMRNMmMxCGNmubr6Q/kGwqDJmCJzJ2HXnjGU0AFA5mV0WXkEc7oqpK8phJ3UsfgqmUeBr2UipyyNMUXbvb0XPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9bWR6hXJgiUr4ymLqPipIoXShO7vFEUJPX4u9jgKu3o=;
 b=Zjcn54T67sxNTKP6rScb/gq5hJFlHJuGsMS31O1wyLHZ8PtOZi9Pnz93J9+1kdaqrYAhouojnGtQ4fLdg0LzTZss9WYKzlpBqYTvIppJEEIxjQBm3zKDQSNpELV74/BnU7+2IWIHgfmZSiLXTmcd7JWD8d4STuqsiqywJz18Qw56ITks7WE//S9qlvr3LZRVfo1VqxthKdgZrUEhhpv1xQPI3BKFXFroQK+KsSWkzatBYRtx9NTlmzqFUevyh6FIRwX6d14uLwwt5uWUVMOPjZyvb/qsUrxU7i/VdZxXYM4+aWong0EoIAcAxUxgJGLH7/VwneHVmKfmwqBBM2c4iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bWR6hXJgiUr4ymLqPipIoXShO7vFEUJPX4u9jgKu3o=;
 b=LSRlMMHiELx4zLkWADRVRgTfeDVVZn+iNhJNi1zj+1bVjJ7BL1X4fPzJJ2w02SDQBdHk44k/qHdLNFx2qofF4Wjj+RxIqOpkkj6vubjVLCEimReEc3n87qV/8iXBBHozrj9gB9baVA2GzqkUksoDzlOr6CFSIzkHmlCxqOJ5rU4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6727.namprd10.prod.outlook.com (2603:10b6:8:13a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Sun, 16 Oct 2022 20:00:32 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5723.033; Sun, 16 Oct 2022
 20:00:32 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 22/36] scsi: Have scsi-ml retry read_capacity_16 errors
Date:   Sun, 16 Oct 2022 14:59:32 -0500
Message-Id: <20221016195946.7613-23-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221016195946.7613-1-michael.christie@oracle.com>
References: <20221016195946.7613-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0022.namprd20.prod.outlook.com
 (2603:10b6:610:58::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6727:EE_
X-MS-Office365-Filtering-Correlation-Id: d2674b96-c351-4aa4-4d93-08daafb11533
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EuWzkyBya/3JbHVRiF426aHARl7cYlLJfMU0hy3xJtmz/22ufIe14KV7rhqySV8EwbVrMUKujY6SgKpYRt2OBiKV9K03+jdOlp6hoxsg+GDtrYiOWE5KH2mDQX/ulEepQF5mhWvyXFvXreyY3SEpWdGajIcdvNKxstxuBe7aNW2QCjh4NRGNSJGLf1IZbB8n5aDF7VjLOvwlC4Ga0OSaJs8FnIMVlfpncrw3xZ8zcErm23CMcJblxbtb64um/bsbVHULCv+F0XT3Y45VP199KUWr2fsIcoIjebNiQEtZGUQAP99fL1+SExySjUHx8TPhMvkvkGRTqlJIL7px6oaqNqFwncIHYt5UqDJSu9WOPh64ivKakh7aGqSSEXR1+BCFQA2Lwh0z79Ne9jxrwXQb0T2TPQA6eo6mEcPtejk8ZT9aMeoLAy9Y4Z5ojkifo4Da8CyWk5FK11rc9VzFdvoQGXD68RYdYP85y6v7bmMYyGFrnAyBBD5ehT1T+VdtI/m0VhpfuuuCqmovZivCTdR26OjczPgZ8mBv2XU+aiQeiY0STPpW4R4t4g4bf1NdcwmZ2B1t344YdNr+QRALQGVodB4Tobxr1Y+wXE70zJsnze/w7Q3sNaJ0jlIWrWt4vLqx8jnd5/nqF14/RwAfCA29bxXHeZpihXMF+XTVuUxWgp+PVDSHzE+b1c++MQ5FIInJSqxK00WWMoZoshAJ4mA+9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(346002)(396003)(451199015)(38100700002)(478600001)(6486002)(186003)(4326008)(2616005)(36756003)(6506007)(316002)(66476007)(107886003)(66946007)(66556008)(1076003)(8676002)(5660300002)(6512007)(2906002)(26005)(8936002)(86362001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DidCNu5OlYPttKpGIjaaGkBQMwU6F6oyErae5cnmduNj3SJdgIO8+Sv30khe?=
 =?us-ascii?Q?y14Z3j2QQLdEb0Xmtz//LE69KDBnLY9DKjL0zbAlQ5nbAprpR6WOp/AgA/tG?=
 =?us-ascii?Q?u0r7jte/PeUXPSvYXojCEol1MmoNSl7VY4hfOW8Q6N6inRTaJxsdYBSO040V?=
 =?us-ascii?Q?mnQRlfrAV/kgE/OkBH1NfKwiWM85DD8/mXLgc/1kt7+xm7QUMHa2ikkq6LW1?=
 =?us-ascii?Q?dFVvwBhsNdbbRjjKWF8bG6uVCV+lpIDbU6F2fcK8p2z+6WvOhxoi7lPd7aKF?=
 =?us-ascii?Q?fQE5CZHuSwu2lvz7Bahy0DSzt3SJHSeH0UlwRVCd+Yw3Jhzv0CFFOFfY+PFs?=
 =?us-ascii?Q?ysVGPOQU+4H2cO7wUMkbe92S7/kydHFcp8AYKa+RfBuVGaEnOpt9ezvtT6Ju?=
 =?us-ascii?Q?/0TPACK4idULlDB/KrTivQkwDX0JZ6gQqKEpF0M+drxo1H4MPMVfanSCcZSV?=
 =?us-ascii?Q?7eXDXQ4Ybciqq3SGuAHMNnRQm4VDqEFNfVKrhlCVdQpBR0q8s7Uweb46jcuy?=
 =?us-ascii?Q?Epxk6kvrUY92F1fZfyLFjbdUn/VsOITDaKNvaMPaBHbfpJNEoUcupeV/Sw7C?=
 =?us-ascii?Q?RMzft06UcrgEkToyV5DuFc63NlvK8hrAr3wN3PrfY2/HPkv686eUyMdy2rVv?=
 =?us-ascii?Q?Z46DBWL2ZM2D2stSJphJWPDYZS39PgOr+m+KMr1A8ljs1mQ0Fu7cOZ5z0tCA?=
 =?us-ascii?Q?7IAVCOL+nZAayh+B4t1lPdMaPSupYYN3y3oyZgVqtMeju1E+sD8OUzVqKhrs?=
 =?us-ascii?Q?hXjNI3TLhY2QqIkAEV0Kyq3JQTgRTxm+NqNc6KJGy0RtuKsAB4cmguNzMMoZ?=
 =?us-ascii?Q?rSHJMDe+BchcMsCWYCJzoeA1PPZzk3Kfxkb6+tQq0XmCe2Ciid40ypY1VEJv?=
 =?us-ascii?Q?/78ShHreQF+FOkqJ4txoa3m41YLxpdcJPny+BF3WmPgD5DSrx/n/o7xCBhtU?=
 =?us-ascii?Q?vSdErjMKNvAxhErKHDzNi9NYEcBCxuSvi3Ma2VO4Z52jB5p8AuizSOjgDGI4?=
 =?us-ascii?Q?VkXSq3Po+lSiXbt5Ar3aThPcWuiD3BRTqtSaRlQ4p5WzyWfhjSQVhcUh27RF?=
 =?us-ascii?Q?qO4Lv3sMejI9Kv9o0LOUyEyAHsQIDxFen1D3sZTRw7/vZRUunNC5BPFlBFPY?=
 =?us-ascii?Q?cb8LIv/dJmoWsB9xQKcBl3HivY8LzBBHKMEc0paNKLz8EPxEPDduU3UJN3nh?=
 =?us-ascii?Q?RYikNgOO0BTgh1mhaVf8LF2giNSOvssIeIdYrkgT1hwWD7unG/b026+VwvXQ?=
 =?us-ascii?Q?xHY95+MbH1WeOkmFfrMghkUf46wgu/xaor07VKJ/7AeuDN7KhpOZLkiywfKF?=
 =?us-ascii?Q?9NFac3aou65WUqfH5sRJJJ8d9qGZY+pjoXjP9o/wW2BMZ4MZklrXbMm9/qbm?=
 =?us-ascii?Q?EM1jUkwg9vzF2dG487cl2Bf88CUOdr8SNv4Dteh4YUm17EcmDgThp9/qyST7?=
 =?us-ascii?Q?Vgx4afI7UaNysivFiLLFtDnqp8QhLwbIrLiQZlJmPf+Hr7+5v3OwYVKlngfQ?=
 =?us-ascii?Q?vbSktReYThrhb8SGSdEEcIJU3PRpSgKr27VV4C/2hKjZeA49XtWAAdN+joBT?=
 =?us-ascii?Q?PLenVXqC+36bXoeNGepS7tLVYIbjuHxkxDVBG++GZHgN4gSx9YYNugReyR2V?=
 =?us-ascii?Q?cA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2674b96-c351-4aa4-4d93-08daafb11533
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2022 20:00:32.7508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i3JUZqtwwV0SCvUGvfku2JHp7CLUSNFAUOWkMuAng2WGkHAF6LJtS8dQJzNkDcT/++qrAtcQ/l+zki+VM/MtBZ7KlngoIve884eOdlQkD6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-16_15,2022-10-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210160124
X-Proofpoint-ORIG-GUID: t5hfyLGrBcTTd_gXcHlAlItsFV4IB9zi
X-Proofpoint-GUID: t5hfyLGrBcTTd_gXcHlAlItsFV4IB9zi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_16 have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 81 +++++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 37eafa968116..aedc37613c81 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2279,59 +2279,58 @@ static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
 static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 						unsigned char *buffer)
 {
-	unsigned char cmd[16];
+	static const u8 cmd[16] = { SERVICE_ACTION_IN_16, SAI_READ_CAPACITY_16,
+				    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, RC16_LEN };
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	unsigned int alignment;
 	unsigned long long lba;
 	unsigned sector_size;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = 0,
+			/* Device reset might occur several times */
+			.allowed = READ_CAPACITY_RETRIES_ON_RESET,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.result = SCMD_FAILURE_ANY,
+			.allowed = 3,
+		},
+		{},
+	};
 
 	if (sdp->no_read_capacity_16)
 		return -EINVAL;
 
-	do {
-		memset(cmd, 0, 16);
-		cmd[0] = SERVICE_ACTION_IN_16;
-		cmd[1] = SAI_READ_CAPACITY_16;
-		cmd[13] = RC16_LEN;
-		memset(buffer, 0, RC16_LEN);
-
-		the_result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdp,
-						.cmd = cmd,
-						.data_dir = DMA_FROM_DEVICE,
-						.buf = buffer,
-						.buf_len = RC16_LEN,
-						.sshdr = &sshdr,
-						.timeout = SD_TIMEOUT,
-						.retries = sdkp->max_retries }));
-
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
+	the_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = RC16_LEN,
+					.sshdr = &sshdr,
+					.timeout = SD_TIMEOUT,
+					.retries = sdkp->max_retries,
+					.failures = failures }));
 
-		if (the_result > 0) {
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == ILLEGAL_REQUEST &&
-			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
-			    sshdr.ascq == 0x00)
-				/* Invalid Command Operation Code or
-				 * Invalid Field in CDB, just retry
-				 * silently with RC10 */
-				return -EINVAL;
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
+	if (media_not_present(sdkp, &sshdr))
+		return -ENODEV;
 
-	} while (the_result && retries);
+	if (the_result > 0) {
+		sense_valid = scsi_sense_valid(&sshdr);
+		if (sense_valid && sshdr.sense_key == ILLEGAL_REQUEST &&
+		    (sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
+		     sshdr.ascq == 0x00)
+			/*
+			 * Invalid Command Operation Code or Invalid Field in
+			 * CDB, just retry silently with RC10
+			 */
+			return -EINVAL;
+	}
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(16) failed", the_result);
-- 
2.25.1

