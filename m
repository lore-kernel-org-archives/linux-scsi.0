Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76318C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiL2TEQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiL2TEP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:04:15 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FCCD9A
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:04:13 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIwwTY001190;
        Thu, 29 Dec 2022 19:02:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=EDny0ENvdlXLHVjQLBic469/Ygt3sCIoMnVgxsyFd0U=;
 b=YttI5cZ5UpNvvk8SSoBPtsRmJhZgXajCYX5B3ow+odO3doA6hTtw8CGV1MQ0+h8N6U/1
 pFjyLJLlWd4TLoSzkqjPrH0abPog9fuS3MGzfGY51tScyWhNVY+uvd6NXvxXf96OtxX4
 ifk3pY870Cp0KML6wn+NVfqVki+xPZNAmWOwGSQK8T0JQIj2JEfpEstidoRFTBFxBUJL
 I8O4LxPSXnvXT3/OS6jple8v5H4C4Uu/j3lVejA6Q5fzmUycccXiq2sMDiPOSpiNxXs4
 S+glcWuaIKUf3bgSPrH8LD0Z1CN/1gZpOXwWWCyg69RJccK3ZpTWws6CxQSHMmm6aYRu fQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnr73f7qg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:02 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTHNQ7L008629;
        Thu, 29 Dec 2022 19:02:01 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv77rnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iOEGK7kxWDra2DZVDPCXp40w+JM+dQg1y6gnsttPkLIKuvdw2ynzWMgUYR1cD5lpWQiKLm8wPXmLZ5tUpNEV2sKu0KAKxf89GY8JtHTfR5RRAwqzzeCaq2M8Ws7Q1/Q06ZyDxZGfir1tgtOWiDHszFrP5TvlASfd7PjpveGHd2qQH2mVyfJDTJpnmlccFxLx5gLO1w1GOCDSYUsmYDJSk9L+N9ZrsjBpjy9WeUQgIFYUHavk2xmnTTL90WahGa7IwoWxqDodeoUg6IbmMh0k9Eiue95UT1nI+KIDAvrwy37b7RwZOEoA8XvCKBVA1pMryoXIPriaFbWPCiXImBqOkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDny0ENvdlXLHVjQLBic469/Ygt3sCIoMnVgxsyFd0U=;
 b=TVY4sTkvr/tHbMLBi6FHcdF+pyhhg4WiJid0P8sCn6kb/nes+njUBorNY+w3AEzlVThQNCi2bxgQSoTlRIQPKDEzLEf+NfZMzKVaS1N3xDmo3+GTMbxfONm+cLBjZsOFSmtMmDxW99SUyFAgssiPxpguiSKwbHd8tbJHs/CNTdb+6WCCoGGeHa1HbaQiLNYAF4Mcj1CFMUFgvPzJ2aaAVd+gREv3Kp2IM9QPxrSNx/ds2TDHUNxfC6g0c3KJ0MS/whpdcn6KpVe79h/+Rwoe+OHR1xSyobH0Cy/E3V1MTuetlK8+IzLzIDIm9gF49/l7vu5wDUAMBzxL/yvZI/OOlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EDny0ENvdlXLHVjQLBic469/Ygt3sCIoMnVgxsyFd0U=;
 b=KY5KoLfVJRuB5d0bC1hnYKr0lytv3dw1VoRyK0EPofDiWN1Gy6K3NnFR0aM2AnJLz3FFyWIw6TDJjwE8PLtxKi7vaF35iqH9yJpLAeEslaI77LJlcNuNqbhPNwaPXAj8GaRXvBAd2dt+WlrJPEBxrPaJBCQOjZXuuRDyqAFX0rI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:01:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:01:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 01/15] scsi: Add struct for args to execution functions
Date:   Thu, 29 Dec 2022 13:01:40 -0600
Message-Id: <20221229190154.7467-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0400.namprd03.prod.outlook.com
 (2603:10b6:610:11b::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: e169a7ce-9a13-4e08-973b-08dae9cf2988
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XIhisotgBvaGSK8IYCqUA1AN/SUIXsVN+w9y3vRBJ2+JFwdunLCORF4tLsTG21hO3D1Uwj5jZA9UUydgqEHXw8P/j+WAAgnNMYBs9vrESte45RWR/22fcDCbGXcii4MvfzqEib4VSCXsq7m1mrr4RImfHlsltwnwthUNcAXPS3eE4+/ouztq0oYFFeDul58lBYakNF8e7cKNwPVaYQLITsleRhmFBwyTmIa0aIsME1EA0czKFFZWMsMavrMkMQCBYF2ZhtWnAThYxKjn3ZjJYtod4V6sLKc42OQDijQkNpT2B0rzCA+bUldXqKrg1/LTdnr9woBElTtat/Wc6HULFA+HQApSf37lJZX1gggU7c5VOmw3yGXrGQr55NvXkpJet5IwWNfF1Q9o+fE2Sru+vGn0UZOuz4B4E3KCQYO08eWWkNlEpI5c3cMd8i5lX4EvA7b/fATDI7UeIcE4eGE+TVrs8kvkIwZf8u21Vf5cCaOOBrVQo5ciDEnSehdaspuG3YLfeFd72c14Sw+BuKZMeOU84bc9ADziw7ofxmn3j8ukqsW+kNs7Mu4r9qBlA28KcYVyA9Zg4yt0QoARSSSftpUmWDxXkn0kWZcmXwcsM3PwDuIPIfFhwESvJtq3YsYUKVdL7DKVy95kSfLKcUoGnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(2906002)(38100700002)(8936002)(41300700001)(5660300002)(86362001)(83380400001)(66476007)(66556008)(66946007)(107886003)(6666004)(478600001)(6506007)(1076003)(4326008)(316002)(8676002)(6512007)(26005)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZnSHW2eAiMNPQq0pE8U2MWDBEetNvr7aVpXXszzKUijL0VND3BIxnCbo9eyG?=
 =?us-ascii?Q?g9DekwlBH/jpiKWDNfUTS1Jwb1nR7TqWBHo4mdQuLbUXlFhLEbATOiGSB44W?=
 =?us-ascii?Q?PFDUnTnolYMPSmqOBe7Rvt0uzWM4BK6XW7WfjJ/LxqUJKEKUv7VLfE5Gj5TA?=
 =?us-ascii?Q?4+5esl7zYixFww27RJiPC6XIjM/HI2G4pcXWeldaqOdaFbgf/LsbAFxRENLB?=
 =?us-ascii?Q?vH+C0jxHJDE4wTlKqbBesX1/aswz9qE3GDIYVOFYL/KDc7Ani2hVjKfCFcQx?=
 =?us-ascii?Q?aaduhzksNnANQgWdupPesJ6v/l/ZQSGpn+9AJE6U7vGIQCSD+rOTssHggFWV?=
 =?us-ascii?Q?eXLngrrO78aYqDWikpMh1YT8BDkcQXGyEfOnhzZxQUQZyYtyYHcjmwl/PpCB?=
 =?us-ascii?Q?dNub2m/Q6liNA4RPFqZbmGMupAc5NR7XZcmCWb/UDIIPb0LpAUQGDJzcxk9D?=
 =?us-ascii?Q?Lw6iFuqum7A/8PbwMvB+6izeoX/XZQL9vyVbXMmyXUuOEG4dTcdV4mG0M4YF?=
 =?us-ascii?Q?A6QqqDf5z3ZQr6ma33SqVNZZpy6lDz7awcCyLFXVs0zUTv9O3wmJeeOZO4ei?=
 =?us-ascii?Q?gaGKGD8GiT9WD29SbcbZmLzgRvJKObqE4jKFVtP6nzg/2dJtCyFiy+EJVo/S?=
 =?us-ascii?Q?5GcOvj9Nfak834/jxnC9lUvj/O8DBv3wIV4IUygt89PkZtHouQiq95JLXRj+?=
 =?us-ascii?Q?LzWd4MhW2Dyudhys436uX2iF8C+k6WsMnuM50uI6UFWk9bKJ1hjGvOce5F0Y?=
 =?us-ascii?Q?4zts8nDQ2AN3zs2jYCVI6qRer0pFVtSUTesVSX3q56CYk5lzZGJ2g8Isty8e?=
 =?us-ascii?Q?Hdgf+cP4OW+bghY15VQRy1weIr3svqK0k9nRRGha6Xbi4V/DWgyHJNPxWbuf?=
 =?us-ascii?Q?4mD84RUeAnbS4SGJ160LkiKEQF8ONRVFZ62eF23eOIcTXX2tSkNzaJGvAe+7?=
 =?us-ascii?Q?4ceVrZxcFsrP95zUMfYgAyeC8ek+0XRUCzjVCKLH095XB/jk3t5xtyU8SKgl?=
 =?us-ascii?Q?0iJCZ91MD2fZYGW3I2/J2SQRQG7qA8XtIJ+1PJcXhmR6Nbva2Vm5gpcF7QxS?=
 =?us-ascii?Q?aISUpnZAXULWeANiFldjxp8FleBNAfgb0HL4ESKpxiKHfagt+Oj7t/Z2y2vj?=
 =?us-ascii?Q?AKWE4aHjrlNCa+wSFns+V13ltmITZaFpdTPYi2+4fmS7fbAb2pJEboKWjtzH?=
 =?us-ascii?Q?u4ImxX+GRsgJPIO/2snrUqBaw8Fs+UJbCxrquWALyHlc30Jz1NESdQKWI2X5?=
 =?us-ascii?Q?MvZZaobHrdd6I0wXuPxJUGDv/hyUnfW0lntjCVsjaBaMSqiBPe8ZNRdVGr+Z?=
 =?us-ascii?Q?msYsTDqG5auv0Zion+iV3ceiM8lyki4t/AgfSi6YeQrP9HMYbSGC4AFvLGW1?=
 =?us-ascii?Q?lMG2VLuIa7mLAlyZQ2W8DTYQtt4XPt2N/MRJRWNqSQRLDqGbWCZFRQklB+cC?=
 =?us-ascii?Q?/OvlepASp3WpN0Hx1nX6aZA2+KoIsMCIFj8hXDegUrqDawWnEMYG3/KhJmpp?=
 =?us-ascii?Q?YlLYZb0j+/AOBsTpRv2coXEb6ncLljt9QL31oqGqMbCRIwPNFnYBLrt0s/+N?=
 =?us-ascii?Q?DMw3fF/6EApeYXYXHzPZ2GzgmBqNq9p76XECWxgTF6NrLpymRMn75hSAfdb5?=
 =?us-ascii?Q?kA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e169a7ce-9a13-4e08-973b-08dae9cf2988
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:01:59.1759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HKvLjFe2+EHxAsgwpNNz6E/FGQwn9FznZcSt7tz8mgh+K8eGfm2LckHZEW43qugfkG6h2vt7+5aKTzFkkFtrqYIpOlCUDhr7cm1wyRB9QLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290157
X-Proofpoint-GUID: qVEWRopFers8a_8VeFVwwaFtbMYkqBuW
X-Proofpoint-ORIG-GUID: qVEWRopFers8a_8VeFVwwaFtbMYkqBuW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This begins to move the SCSI execution functions to use a struct for
passing in optional args. This patch adds the new struct, temporarily
converts scsi_execute and scsi_execute_req ands a new helper,
scsi_execute_cmd, which takes the scsi_exec_args struct.

There should be no change in behavior. We no longer allow users to pass
in any request->rq_flags value, but they were only passing in RQF_PM
which we do support by allowing users to pass in the BLK_MQ_REQ flags used
by blk_mq_alloc_request.

The next patches will convert scsi_execute and scsi_execute_req users to
the new helpers then remove scsi_execute and scsi_execute_req.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_lib.c    | 52 ++++++++++++++++++--------------------
 include/scsi/scsi_device.h | 51 +++++++++++++++++++++++++++----------
 2 files changed, 62 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ed1ebcb7443..7d324db6b2f7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -185,39 +185,37 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 	__scsi_queue_insert(cmd, reason, true);
 }
 
-
 /**
- * __scsi_execute - insert request and wait for the result
- * @sdev:	scsi device
+ * scsi_execute_cmd - insert request and wait for the result
+ * @sdev:	scsi_device
  * @cmd:	scsi command
- * @data_direction: data direction
+ * @opf:	block layer request cmd_flags
  * @buffer:	data buffer
  * @bufflen:	len of buffer
- * @sense:	optional sense buffer
- * @sshdr:	optional decoded sense header
  * @timeout:	request timeout in HZ
  * @retries:	number of times to retry request
- * @flags:	flags for ->cmd_flags
- * @rq_flags:	flags for ->rq_flags
- * @resid:	optional residual length
+ * @args:	Optional args. See struct definition for field descriptions
  *
  * Returns the scsi_cmnd result field if a command was executed, or a negative
  * Linux error code if we didn't get that far.
  */
-int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-		 int data_direction, void *buffer, unsigned bufflen,
-		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
-		 int timeout, int retries, blk_opf_t flags,
-		 req_flags_t rq_flags, int *resid)
+int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
+		     blk_opf_t opf, void *buffer, unsigned int bufflen,
+		     int timeout, int retries,
+		     const struct scsi_exec_args *args)
 {
+	static const struct scsi_exec_args default_args;
 	struct request *req;
 	struct scsi_cmnd *scmd;
 	int ret;
 
-	req = scsi_alloc_request(sdev->request_queue,
-			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
-			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
+	if (!args)
+		args = &default_args;
+	else if (WARN_ON_ONCE(args->sense &&
+			      args->sense_len != SCSI_SENSE_BUFFERSIZE))
+		return -EINVAL;
+
+	req = scsi_alloc_request(sdev->request_queue, opf, args->req_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -232,8 +230,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	scmd->allowed = retries;
 	req->timeout = timeout;
-	req->cmd_flags |= flags;
-	req->rq_flags |= rq_flags | RQF_QUIET;
+	req->rq_flags |= RQF_QUIET;
 
 	/*
 	 * head injection *required* here otherwise quiesce won't work
@@ -249,20 +246,21 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	if (unlikely(scmd->resid_len > 0 && scmd->resid_len <= bufflen))
 		memset(buffer + bufflen - scmd->resid_len, 0, scmd->resid_len);
 
-	if (resid)
-		*resid = scmd->resid_len;
-	if (sense && scmd->sense_len)
-		memcpy(sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
-	if (sshdr)
+	if (args->resid)
+		*args->resid = scmd->resid_len;
+	if (args->sense)
+		memcpy(args->sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+	if (args->sshdr)
 		scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
-				     sshdr);
+				     args->sshdr);
+
 	ret = scmd->result;
  out:
 	blk_mq_free_request(req);
 
 	return ret;
 }
-EXPORT_SYMBOL(__scsi_execute);
+EXPORT_SYMBOL(scsi_execute_cmd);
 
 /*
  * Wake up the error handler if necessary. Avoid as follows that the error
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3642b8e3928b..f6b33c6c1064 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -455,28 +455,51 @@ extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
-extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
-			int data_direction, void *buffer, unsigned bufflen,
-			unsigned char *sense, struct scsi_sense_hdr *sshdr,
-			int timeout, int retries, blk_opf_t flags,
-			req_flags_t rq_flags, int *resid);
+
+/* Optional arguments to scsi_execute_cmd */
+struct scsi_exec_args {
+	unsigned char *sense;		/* sense buffer */
+	unsigned int sense_len;		/* sense buffer len */
+	struct scsi_sense_hdr *sshdr;	/* decoded sense header */
+	blk_mq_req_flags_t req_flags;	/* BLK_MQ_REQ flags */
+	int *resid;			/* residual length */
+};
+
+int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
+		     blk_opf_t opf, void *buffer, unsigned int bufflen,
+		     int timeout, int retries,
+		     const struct scsi_exec_args *args);
+
 /* Make sure any sense buffer is the correct size. */
-#define scsi_execute(sdev, cmd, data_direction, buffer, bufflen, sense,	\
-		     sshdr, timeout, retries, flags, rq_flags, resid)	\
+#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
+		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
+		     _resid)						\
 ({									\
-	BUILD_BUG_ON((sense) != NULL &&					\
-		     sizeof(sense) != SCSI_SENSE_BUFFERSIZE);		\
-	__scsi_execute(sdev, cmd, data_direction, buffer, bufflen,	\
-		       sense, sshdr, timeout, retries, flags, rq_flags,	\
-		       resid);						\
+	scsi_execute_cmd(_sdev, _cmd, (_data_dir == DMA_TO_DEVICE ?	\
+			 REQ_OP_DRV_OUT : REQ_OP_DRV_IN) | _flags,	\
+			 _buffer, _bufflen, _timeout, _retries,	\
+			 &(struct scsi_exec_args) {			\
+				.sense = _sense,			\
+				.sshdr = _sshdr,			\
+				.req_flags = _rq_flags & RQF_PM  ?	\
+						BLK_MQ_REQ_PM : 0,	\
+				.resid = _resid,			\
+			 });						\
 })
+
 static inline int scsi_execute_req(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
 	int retries, int *resid)
 {
-	return scsi_execute(sdev, cmd, data_direction, buffer,
-		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
+	return scsi_execute_cmd(sdev, cmd,
+				data_direction == DMA_TO_DEVICE ?
+				REQ_OP_DRV_OUT : REQ_OP_DRV_IN, buffer,
+				bufflen, timeout, retries,
+				&(struct scsi_exec_args) {
+					.sshdr = sshdr,
+					.resid = resid,
+				});
 }
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
-- 
2.25.1

