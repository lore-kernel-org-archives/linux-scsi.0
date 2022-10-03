Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD21C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:53:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiJCRxx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiJCRxu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:53:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7D237181
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:53:49 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GONAv006557;
        Mon, 3 Oct 2022 17:53:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=lkAeM7RbNmR9/2pMUIxoISiYj3HFSG79+Ej+yWSva8M=;
 b=Pn8eIbgSGyW+zx3NdCpynYUt4Sa8f2v6NkEBWPOHaa4U95c0PUOgnUTlRhqGKMYoezH/
 bBOYBGYAVPvG36DyJYviZFX+8BdS4049kYN5jcdEIMt+kUlVUt3fsurQDJwun79qkVYY
 Hqua7rZ64eJz/DK6TzBmcPLKcxeDSkIFgunAuY2MECMCHvWLPR4LiSYpO3z15geWTjFw
 vobNzviWcxC996GrRdlA8GO87eM5UiKXluNMlA7XmgF9Aul5uKddfGIcc8cjReIN/elU
 3Urjk8FKDuMS9E4P1Y9ElYf3jo4IwBKZlgUhNDekIV/z32qGc+bSTodaGOCA5P9YeI8K qg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxbyn48t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:41 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293Hd0xh015519;
        Mon, 3 Oct 2022 17:53:41 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03g3m0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:53:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZwUotUyUhieYN8AanqLWaMx9zycxFUfOTgaSc47IYNJ0bUmpSqoVvxGsV/M8k2Pa0bV8oJhQpNa8jOf3UwctOnUAuraSfYZo9Tthp9RXsBstOR5kBt9uhAnQk1oyjI70oxJitJ8IP8jDk+mbO5xhPj24Ay0Y+TF+e9KdTK0+YhZy8rB+tKxlATGLp7tGiFphMVy5E8bhe8zXGktxJjcNJW7M6ckyp/OpdHVvZqW3D9iAmQVXYOrqtJrI3v3Snk2Y5REhDpEmN5/PKgniG0/We+9U3uhvYiMmwS2OXKEUYAEZ83+f29/HauSTNp7zcWhxJCPVftCLIso7olCyyBT11Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lkAeM7RbNmR9/2pMUIxoISiYj3HFSG79+Ej+yWSva8M=;
 b=MBl+SI493dSCFVNrh5sE2IJios53NCvlRKs8TxEGlRCqY7iwcSeo2HIr/dQofYw+ndHAgP7aDMm5yIeEMi07ymHf02SBljbKgQIcdETzfdRxCU1TK9J1ESFgsD7clEWLEsi1qs9Iz8Ibc1IPxRHtJ4keDe5GtDwSLnZ41bk2x8m2Ca8gdrQANjRq25SLj10Iob6FaUvNn4zE9/qsOj1+cd1qcaP5jPOHWh+ZSrg+q7Ps6CIjBzpjEOU9DVnuS6tn5NVlpEjWZr+EJ8miOmF1FxrlPTtBqfvPtnJNvuwBDSemrsaFi5zQNpZqwT5wFhHLvivE7IH8T0hWST8pDpH5pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lkAeM7RbNmR9/2pMUIxoISiYj3HFSG79+Ej+yWSva8M=;
 b=QRDDyGc261B9+PF1hkU232aa2O6LktLBLSHf+c0ceYloLvVCObKCMFLi3F98WOwkWjW4hXoT987eYD1rtGI/g2UESDQxvYjuPM9rPClFbe13JAupJr3l959r4DoEhLyl2Nes65cm2Oba+Q8adk1i3A42edmziZ9XeXtjkZd4yIA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB4834.namprd10.prod.outlook.com (2603:10b6:208:307::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:53:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:31 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 05/35] scsi: libata: Convert to scsi_exec_req
Date:   Mon,  3 Oct 2022 12:52:51 -0500
Message-Id: <20221003175321.8040-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:610:38::41) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB4834:EE_
X-MS-Office365-Filtering-Correlation-Id: 308cbb77-71b0-4a0d-112d-08daa5682f47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bvThzffJc/23VtHqd34515MJ37xV1OUMHUTVhIcsn4mf5PCYx6fIZ+75lZwhBRrZLTQaKRTmMPeUHOqbkuB0jNGXhph6NS3YUkJ7ZhlDpXfSlyk9D6pkNgW48BRh7ntflwg/xXHESWIyJOfVRaszjKtW80usmJRCwveGAuJVW516sr6y0XrwrXrp5pkRDW6ONwcp6HhDH2WgkCyqJeAty0Oe2sPn6pPE/0bMIZWEOhP45MjXnjpA8/KqQrQeV/9I+eVBhcHO0YDc2AobHGsr4ep8z4aiKnVCtO1zG1TD4RNa8Z0gSxVrczp32iyJ3OJePG/eIAObZBXyUx7lzG4zRf3IlCaaUBImTE6SSxiP9oA18TLQ9lZhnz/X7Lv5vN4Nw8C/4wIh6u81SVbRs+fxk6LlSzmBemKTpk46rYg28aVDJodMORTUIiicwrMLqtltS9AnHpgxalj7UbA0Quoa/yHcNIoekTWLkGDC+5S+0Goq4mbo76oOxsBNJFXQMC0xoWH87WAsdW6FAi2EkZeLuT4X+5aOOcLsP4/X0JdrdRwBN9zu31vFj2TwFDAFoBmUm80wOHwkqQl6PrvC14k2CgqPKpsqmwYEykpJLcu5wCWk8nvh+QJ+4w2Io8VUESfDEA5HZd120cf4ObBFJCaVJ+anhOVpBX4xGH7EaefDr/Rzv8WpVqJvo2C5bNuT+QJrMyhLtQfWEi57lB1fnoKjjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(86362001)(83380400001)(38100700002)(186003)(41300700001)(8936002)(5660300002)(316002)(8676002)(66946007)(66556008)(66476007)(4326008)(6506007)(6666004)(107886003)(26005)(1076003)(2616005)(2906002)(6512007)(478600001)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fITZcn/szdsCbw88nw86wd8iCN0Tol0/f3+CdvSTkwBj9S87FcMq9vNlRhCg?=
 =?us-ascii?Q?6O6c+zb26uUDfz1o5GfAqZ0g4n1Vc+fAPVyNSoUTzFfYMBv16a2zbqcyA86M?=
 =?us-ascii?Q?6iI3ncV1mGWbKRBaD59l/X6J8QQPyD3QSYOAXVnuZZRet48YHFmsI7Ki/uvD?=
 =?us-ascii?Q?dE5rfGx6uHEYgneZ7chkQoc6GHzD6tZSYe0Onnxhbx0GJUZa9DPTPFIMg1MX?=
 =?us-ascii?Q?pGPQaiAd9WunEqHlUz7/66Q+6lk4Aga5/UgYnnBCPn2JE2/RsH17LzjZvL6E?=
 =?us-ascii?Q?ZQ0yba3f74SWWvWghRlt4UqfJD9wTIMJ8ivNW2qIRLdDtOxM3dF0A+mt2uha?=
 =?us-ascii?Q?nAOz9jbO5ojIjSH81eaZvu6lGuvzh9oT0M1vR2cEX52xjz3vW21rsC20SIlh?=
 =?us-ascii?Q?rbKnLs6V3hAiWvULTXVzOh3fgNoVxJ8lLfFvBIqq++BEbYke6wOD6l0609Wk?=
 =?us-ascii?Q?m4zF8nl/hDLGwUsByY7ABz4Q+8+geYeOQE8jJ6TEK8F1F7MP4CPFUVuS1ANA?=
 =?us-ascii?Q?19v8uq1vCyT6OxIE5MbMhAd0atvoaFcXQT3hj8cZaMyvxjxx8xHtqKa33xUt?=
 =?us-ascii?Q?muiuF7wevpRCROq4HvbdkroL2laUR6PT+ToTr1vpJ2/KMflzDJqxvOXKO+F1?=
 =?us-ascii?Q?i1oI7tRqQzlJzb+1HKNUOUtUeuh58yPCdzY5s7HW8x8xreVu+v10Gr8enkzX?=
 =?us-ascii?Q?dp2tcnAh0hoMExkNfcGBDmJ1QA29CJwCQpfo2ymMHgw45jHEU21T4p9Wwa+a?=
 =?us-ascii?Q?5Q8MtQPSXzNNHKQFH14hip43oX7S3Z9pAl264PmV37gc66GxMenvHn9IPb5U?=
 =?us-ascii?Q?q2E6xeOL7kolRniTJ9Iq6tAbkivNZfNZm6EGuLOpiLPHsznPXGSJHp5sW16/?=
 =?us-ascii?Q?SNL0OA744JLIxuo0w0oMEojrMuNmpheZReU3tCznA45Y3bGpmlkvLd1Q7Ob6?=
 =?us-ascii?Q?2zDDQbTECaM2DLbR7jNJtKEQxjSudLW00it7W69Mqb4E/atdrU2HW5lUBRux?=
 =?us-ascii?Q?fs+SzTvkqh22OtRyEVXPLJX/NB5QfLIPA+cwx8jeloXeso6ovX643BatR5dz?=
 =?us-ascii?Q?1Z8mk33f3Ej0b6//I/nIbvksFrS0swAmXBioCLYmMO+Wqy9hQxG6xRG1kt19?=
 =?us-ascii?Q?10Hv0OtcMIkYhb0eSbs/T7FCD8++D/ekIA+pGHBy3klCKDtSblyYssltnHM7?=
 =?us-ascii?Q?pCWqGK4rGEvVA65A4LEznsQzkcSyRfKViAWn+I1IBJQRyz8d3rHMWSE+NVaq?=
 =?us-ascii?Q?BNRRywp7KSOZUIRl0pS80Eqs9x5sh7f9YWOaLnRKfn4cJZgs7L8NyWEeyS2D?=
 =?us-ascii?Q?Ep72LlfS3Y1/ZbVtJfPDa7GY2ujQSX1oyxmW5sJuZAjU7R8QzqNP3LJVKANK?=
 =?us-ascii?Q?UiZIILcRJT1goTjv2HnlCNK5Rjg56A/m1JJGBWygrgfRehjGsqJOu/v8oZVI?=
 =?us-ascii?Q?3ea9OchFmoPCTHJxmrkRGdsARGtsg65Kk6h0em1EIe/EtoodLAOwZXS245xX?=
 =?us-ascii?Q?+2rF4sHPB6WsGOjQ6trJlpNKDvsOsUKgyf2xhkBetDZLfwIFmmVj2aUMS8Kd?=
 =?us-ascii?Q?hhFLFcEn+OOvsQHLdEcPwtKVhTKGVFgE10BIdfsjlykw/AsxC5CU3WcH102L?=
 =?us-ascii?Q?1w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 308cbb77-71b0-4a0d-112d-08daa5682f47
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:53:31.5496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xF14ISUNOWm5u8yYLMNQLp+K1ASNxAc+d2zQ9t94noU5Ju168wA7wbIzIUtT3ZqO7t/AEhN1Bo76ODhYWT9VPvAe6zp2wew3+xrVZvxo3II=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4834
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: 1UfMvCoFgtSzeeIuxadSOXXVEaiIZboo
X-Proofpoint-ORIG-GUID: 1UfMvCoFgtSzeeIuxadSOXXVEaiIZboo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert libata to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/ata/libata-scsi.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ff9602a0e54e..4c07d618bfed 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -413,9 +413,17 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
-				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = scsidev,
+					.cmd = scsi_cmd,
+					.data_dir = data_dir,
+					.buf = argbuf,
+					.buf_len = argsize,
+					.sense = sensebuf,
+					.sense_len = sizeof(sensebuf),
+					.sshdr = &sshdr,
+					.timeout = 10 * HZ,
+					.retries = 5 }));
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
@@ -497,9 +505,15 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
-				sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = scsidev,
+					.cmd = scsi_cmd,
+					.data_dir = DMA_NONE,
+					.sense = sensebuf,
+					.sense_len = sizeof(sensebuf),
+					.sshdr = &sshdr,
+					.timeout = 10 * HZ,
+					.retries = 5 }));
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
-- 
2.25.1

