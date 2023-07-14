Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14647EB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Jul 2023 21:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjGNVhT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Jul 2023 17:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjGNVhR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2023 17:37:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9723589
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jul 2023 14:37:15 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36EL4cnj014937;
        Fri, 14 Jul 2023 21:35:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=fAOCTf0mOfg0GmgaiGHbbYGPWx4hGLLimLoI0hEJihU=;
 b=DBMST7xhrSL9c9aV0k89mgNwkFhPS1NC6VmxE0FhimxBKlam8J2uK1ybd61ap8+QIuuY
 VqOJ0UhXxxQ+/85GfznSKxWnAqaHOz2ZQFVheJMdzhSRgcM+ZfKKsY4eTbNIc07ymwS0
 qXJyf+LtxRe858HUWObe5F08l3PFVIj+3hdspC0lEjp8gGSNv0xvg8/HIAZOgsCnAMF7
 0glTghUJDQ/THG8va41bC9KA52bfhqKOv7EgjlHpsgJ4OyKkVnGOLUMel+pSP1ljL7Zo
 RqqFpNqgRouQOixqnmIWgsXlsy0MMdRIbXMxhkJhs0hkQZRpv147dUxFuBRzU81xqu6J cA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtptx2f6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:09 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36EK6Zlt007607;
        Fri, 14 Jul 2023 21:35:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvsrw5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jul 2023 21:35:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3ZRn+h+gkVwsH+CtJDXhMSxXEgqYf4PDrdm8+6kLtLP6o/n1Re7H4IVfu8LIVniKdVSRKvWxcJongCXq7PQ8JL3HtfQi5uDILG/WeKzIPC/MeGmKeUV4HMdDcAYjnI4cuIh/NzUEBBPxHb3Nxd74GrNQn8ByJEEtvb2tPpoDvEK7Hpwz0IOgne/DGl7DA2Q+314h5vjuLVuhJDqYMqDeNjMBx5DkpgtJfpMHrqL8+BT+NGzFLYwJs/DZsCxZ+OyGdKtSGNaconUEb4MTA5Y27gGo30I6Q9qJznHJCQdYTq2dkKzF4H8Mr9Ti/Ct/dAYryygytJgA/udS4zuMpGfjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAOCTf0mOfg0GmgaiGHbbYGPWx4hGLLimLoI0hEJihU=;
 b=U34rfTEMrhUAv4k8lJnb2tLOjVF+/curEa1wIae5ANGhP4md3r5QqJtWWCtSEN/OSCw0ObpFTDj9Gu5cAxfvfDKhHxr1khBM4PrwdfQzruZxXkj8H+FixZK50enobNQ5yoQ9rcwP6X+fcGVN8wlb1AAzqUmsEFYs+oq0Wom1eO8cqtw0SjM7jGuYcZO8wvsazhT8YCPecGJ4uS88H6z01T0XioAfZZb0y/yUaJIpVO7/0siqdloy4cgJX2lBpwUyXE2sS762aG3yckK0XnSafAk6NaMtM2WjCIv5t8D/xEnfUqun6TNdUpNtEBeB6RJCFroU9ZvQgvq9GIv7G2qguQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAOCTf0mOfg0GmgaiGHbbYGPWx4hGLLimLoI0hEJihU=;
 b=EON57Zvg9XIEYXN5EARPFUAGJeLpXxwORcSm40Ca/cMCUeRY2sclwXL+a1E9yW+M66cHvIjC0IAgVmPSYEd0iLE0fgS/2SWGHD7rowgkQ47U+A4MD9P2IYrFCREvRa9+caTodT1C5eOd7C6CGS7mXsLhh3ZVSL/9UiIxCX+RIRQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4377.namprd10.prod.outlook.com (2603:10b6:5:21a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Fri, 14 Jul
 2023 21:35:06 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6588.028; Fri, 14 Jul 2023
 21:35:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v10 26/33] scsi: ses: Have scsi-ml retry scsi_exec_req errors
Date:   Fri, 14 Jul 2023 16:34:12 -0500
Message-Id: <20230714213419.95492-27-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230714213419.95492-1-michael.christie@oracle.com>
References: <20230714213419.95492-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:5:40::40) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4377:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a6faaad-4335-4dad-39dd-08db84b230c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ajxx0GvD1vUsnm+P8+nJlj83oFFBqTODJHrJzzmaL5h60Db2Dwikh0uMClNpM0r4GBfrtz6XbY9M08IxRtYcOagT4xRU3WwSTd7v29Iw1DlI506lcXQOyrFD54QQetfOZIm4bIY0fFtbzKCIbzZ8DnphjNutAt0DP67YXI4jzQ0FiNfwHJGFIti28uPGrJBLVEX+elTuH8D4McL2vxPEOA5Jba08JLEryAOIqmAjf3mNjVynzzu/PZ2ZvZ9f8PzFwmtF49zI1JCXAe0dyiQ1kRV12eEfwTe6d4KCzQafzS34R55pd4wPx2gVEEAtkBwXhR9Ufc/kH7BFK72FkCCN1bgv9rcFIOH39Bj3d3dOZoSwtQHSGGKzAmX/c5y6uEUkZRidQXgz5kLH4otqf7R5dZqfJGVzlgjD7n2YWVPc9rRsParQjB9TMJeY5scX/0OmeVXxKn3Py1Re7jUp37I4nfrUouavjYue7Gyhvorm0/0MVazN5kg95qMF9lFx38CsS7U1p7+IT5XPzYtK4OlwiBSc0NZpK0loavyGPB/7X/VnL0kBmvTyoYYVc+NHQ2Zm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199021)(8676002)(5660300002)(8936002)(316002)(41300700001)(4326008)(2906002)(478600001)(6666004)(6512007)(6486002)(107886003)(26005)(6506007)(1076003)(186003)(66946007)(66556008)(66476007)(83380400001)(2616005)(38100700002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A12Qy1Cr7LEpg9lZLZ558nfF7ezGTobbz8ET9RHvmSCKY9U3Jm1gWnUfrCUV?=
 =?us-ascii?Q?wC4zFWgWUsMx2oFu6VOvcgHwwFichJm175iXeBXeeSSD1L2mG83cpRLAMR/c?=
 =?us-ascii?Q?8mWVRk7VKHiSuu6w8J0jonUUgwsA0+xZznnjqVo0uC6izfWGznLg3m2fQK1/?=
 =?us-ascii?Q?OkdqJwbpkbjgq6uo8QCFd82vdlA2B7tPLoKxpIZ10HB9p4GyDbX91kSSoZ63?=
 =?us-ascii?Q?GVY4TFmciJzOPjN3rHgtZvXm8sKsdMv8cN8VU6nYkFqrZjyX1Drog1HLzGR5?=
 =?us-ascii?Q?s/zF78ji3dCgxVbfoIJEUH0hNsbVPuejusR99GGVqo6eJc+ZoL3iGxFsZIB5?=
 =?us-ascii?Q?1lYgrNzNacXuLDqDlOTikwP0AFJQv2S6OncxZeX1DIkY5BeI6yQc2teQ9n0h?=
 =?us-ascii?Q?YDcbqEUGi5mSdAF6UZW77EykS7zrz0JlEXdnHkaTRqv2lcBYW4aJ5lfGgRza?=
 =?us-ascii?Q?m9nUbR/Q3z7IRc4WOdO857UcqhQfo/al3nkM5+skLnC6OpDZYso6rSOYtuFt?=
 =?us-ascii?Q?tnokLELtAsJQjkzr7iRYeto4Ob/LWsZKHHgHbHM79CGeLBditqgRTt9c0Zjt?=
 =?us-ascii?Q?Uzz5QIwrMyh3KOo4VB5i/ALZDdQs5kpVVxSqUSygxKsZ7bddrdAj8PIYrHt8?=
 =?us-ascii?Q?P0evMWCtq8LvU2XNO5HvVsPpyzwaJKcw1HD2toqISXZEmETJ5ELFB4oLMTdE?=
 =?us-ascii?Q?M+OQ7U4y2gs9lpnRw9q+HEgMzF9UiduRQwcOK3UM62tVaRG4i2osffJzPIFW?=
 =?us-ascii?Q?mFbyYl4ojkSSsjBB418o3Lz9IO8ANzNDEFXTQU1aP83yGjZBVS0UDsub7Znn?=
 =?us-ascii?Q?s3uQgs+791T6NVKovftpIgGjxjWDbNmGIsxc5WjXQzxsZpJbcnpKBwYO54Hf?=
 =?us-ascii?Q?mTs3g3v/LH8i0DJgO70KuvVbKdGR0duIa5vI+DwDJzxkEjF4Rttotiu2Ej0f?=
 =?us-ascii?Q?93lCXBIAODeTSdPt6uWRyjJWRsoiGVIVKAiMrG/o+PXLGenR9yowa1tMi1FW?=
 =?us-ascii?Q?uBrPGBl8UFdk466qlaMIphGyQPflvqO5IUcOTv/U1RTaB2DciVRPMJLRDH12?=
 =?us-ascii?Q?XJW31D0nzsHF1v7OtsI1mRRpHFOB24RidXjIS4kFDKdpdgHKcyrcL+rTXLhY?=
 =?us-ascii?Q?jxG8Bxi/s6xRU5nBS2C7g+GnPF4B5U/1ZQFbFTsAzmceZJjzIwRE00QEn6zz?=
 =?us-ascii?Q?4IE3WVcxf2at9k78mD/kseA9Iozr0RIE/ryB6zFPm6MxRue/0tnPJU7ISpa6?=
 =?us-ascii?Q?iRBnbS2QbsW3AO45Dgulr7BMXvjILd1moVqCav3GkrkUiPIzVXyhIcLIvoGi?=
 =?us-ascii?Q?aNl/oJc4nZvxviFFb3h9XmnSKXJ7tFYso98ok5uaqY0YjGtLhj50M3O5Jyvo?=
 =?us-ascii?Q?8BH2iZyL6z5P/Wlk+eeo9VYgBsrRuVf31DdUqW5K4vyqfwQ6oqwNJMjIPwNg?=
 =?us-ascii?Q?Mjo4MSC3aXTcQpiL4MKOfirDAhSpybgh8ZhgYen8rK7JnsjqPtb77EB5G5fd?=
 =?us-ascii?Q?pMOEnwG5SUQoZPed9nEe9RcHYmYYRd83hKnPUWSDpzxMPGgK5OVSCDECDjJ2?=
 =?us-ascii?Q?MnQK/RYw4ljSH949O7BfIxEqsUIDKIy48bEW1WqK4Yi7nM6eC6lDRnKRIEJ+?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0025TPHgcuF4Ni2Cu8iO8K8U3i0iDQKoqYcQWWi2xFsO0HvfSyfzMUc8owSd/URHVAXrwASDYPm256+rNwX7XdhfckWNKjJnJap3Dv5bMome9vM8WEpw6qk7bLQ5YleUEZ0y68cNpfuqKGXgmTaorOSkIU07ZyJBRiloh0VsxvqBB8ssyne9y5iqTkwCuBDU7pDIZ99NIIOWVej7D+dIEIXbFmSSZFFx3WMxkdntpBcqzBwMthGKKQN6CsJXxIrrbaqe+x0Ae3ev11rCcxuCgIrq5jqB5rirTgsVmohdoIBj+RQYHNL7u9ii2N6XhHqIHSXEzRGiPG5gWLOXHIMXaYxc19zuwbsDPO5Sf+sbz7mrGMkgVYg+dfDTrDSVzYjcgL29BGqDLQrEgWDdDJZstYqO/BW2uzeLlKBSBH2WwAvP8bZkaIc8PgpUF00dZNI1d0KdMwZB7iNVA3BVOHcMkw8NELVUQdXyI/5eJDbxii4DrcYn3DRhdmo7GSD/yjSy1TDGh1/h0I8/PXkrud7Eqpaupp6/1CyIFEJy6TlGRbQpfLz4SYd6PBvYPDRuwg23rAYVVTq1fJdRtuABZH2zdWzqsHbpArfV9v6w6JpqJZ6HFhGApFZaWrcqv2uPlbNF49cd+7/CAdOltry4+pKuWyBwoZQRTfWANAHwJjbmTvO61HXz9oX0KbvhxKWQzbuhUsAvspdB7UPhx5ux4NvigScqk/CFqik7O56F37W66QBkLoF7MEehkOpIHE7Sn1vQjzNXrDN4glch4eYT0IW/A4+2Iy2Bkbkjk0BjoLtNdINisKBjRW8nCg7/9z4wxh4BEHmIJ73O1bBbDYt6v9ERZQFw3OfhRCsHMgVeTHnjgegP0/0QaBEcUey+ctaP0iOJ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a6faaad-4335-4dad-39dd-08db84b230c9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 21:35:06.2143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DZ8GT0RHESuwIECqflJx0UrG3CCMcUqupCQOoYf1FczNZ1lyZXM1c/6veGmReMYGHv8xVrgsGDSdvZihIFzrgftj4uEVcuyOz56tczmRoxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4377
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-14_10,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307140198
X-Proofpoint-ORIG-GUID: 8I66hg7ReKrm35LZ_7E1xk18h4VyuzEh
X-Proofpoint-GUID: 8I66hg7ReKrm35LZ_7E1xk18h4VyuzEh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ses have scsi-ml retry scsi_exec_req errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ses.c | 60 ++++++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index d7d0c35c58b8..f3d497366af1 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,19 +87,29 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
-	unsigned int retries = SES_RETRIES;
-	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-	do {
-		ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
-				       SES_TIMEOUT, 1, &exec_args);
-	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-
+	ret = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, bufflen,
+			       SES_TIMEOUT, 1, &exec_args);
 	if (unlikely(ret))
 		return ret;
 
@@ -131,19 +141,29 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
-	struct scsi_sense_hdr sshdr;
-	unsigned int retries = SES_RETRIES;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SES_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
 	const struct scsi_exec_args exec_args = {
-		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
-	do {
-		result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, buf,
-					  bufflen, SES_TIMEOUT, 1, &exec_args);
-	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
-		 (sshdr.sense_key == NOT_READY ||
-		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
-
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_OUT, buf, bufflen,
+				  SES_TIMEOUT, 1, &exec_args);
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
-- 
2.34.1

