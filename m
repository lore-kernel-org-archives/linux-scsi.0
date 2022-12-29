Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0269FC3DA79
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbiL2TEh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbiL2TE3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:04:29 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061F814024
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:04:27 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIxEB8002266;
        Thu, 29 Dec 2022 19:02:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=jcOOF2gJCkC4Gp8uSwowQzR1cQCS5+tCQtNQQOYhrsM=;
 b=BhkU4RGM/6/90kh6ezNU/n2BpuGc6fSvmW1E71Grx56379CrrcjGN8c2i4IkMyKG30aF
 3eicqQ4P+Tj2PMvR1EnrOtYqlXpLIwnNxun17QcZqC/UCR94wyZHlCmjDPIiRe4evKOC
 B9chhTELTPUZiOqv1eO0vIMt2VC61TKWN6J+OKb8puA2qco9gRVM9kVzxzM/OZiutkqn
 mXULd/xAySSTkpS9hmmJsdVZr9kE1vRxDmJqoRAmlOGfeyfCBfkQRkqczcTQ5wzZmHaT
 Z/GuobrupcQGbh0WHsvE4EZriRWtiDSNXCp1yyFV7b0K/vJQtCCZt+/CiTWG2nhiJ1wJ wA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnsfcfa8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTI72c4001350;
        Thu, 29 Dec 2022 19:02:17 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2043.outbound.protection.outlook.com [104.47.51.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv798ak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DYuwO1ANoYTsB3v1LNYY6GMLR+HLUwmmyv3WJkfMhPQEzYTW42XhO2B8T8A8AwLIEDaR/wSuYzoFSOMYgy0HbZFtamMcCDABz6L4FSsX6hyafoTOQP6wIx5dcxeQSKR0c5eZ1YBnluKp5cPRCYAGWhv+y4B0gqZgyjPYqWRPodYPboaVSOukrU7K9nU3HqADxNrlCsDwdHz8CSXGTAJ/YVClqn95nByK5Kxbk64fQQYdHe9mO69BR6iNa7EPdTSblah1mSKS3zhawRG3cUmVSsNYYkPAHXKGdGZo9s4On9EHsSBuqIh13w0YH6GZPFByHucWGW/zptRLbS2Ibw7QqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jcOOF2gJCkC4Gp8uSwowQzR1cQCS5+tCQtNQQOYhrsM=;
 b=lZvNq0FabcIPHRjY7I97eVrgR9jVm4iDIZ9sEStSLlDvyPkuaVFFazTVsGelXrApQZYPwpoe5rb+eMJjmi3TG4Effd1Kh0VNnDSVae5qNHsY1IwfGmRG1ycjldL3kZOrXnDJcAz6n/M9xCJcF0+11l1kS0EAoGNzQLjju7UIFsdj+QrKMkilXfMeI3UtKfcTIuB3gmMXPYiRzufWv/CLQKkiqrLwcKz2L/vLMoS8Xbt77ic+yDpW3hQXfLlGSS6kS0DBpzjogwOR8+wpLn54VwfSIt7Bv7mnWt9/ixCEd+2loBH7Ut3e7mJJk5z38XTMF2yy5E5QzA2eMF74gYKRAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcOOF2gJCkC4Gp8uSwowQzR1cQCS5+tCQtNQQOYhrsM=;
 b=leJaLkQGK3qQnRxjWwm4nvzjLQo6QkpBxVfPrWPf8QyzVAldTGhDkaD3SLiCOoRFDltNN9E3tBVORP7OEjYW+as/bEHvsIOiZ/gnG8me4HDfz4OXh4O722EFrdzJZhZcd5iXsS10sAEp9esl7j978JaNomA0vMNVaYXOG5xm858=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:02:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:02:15 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 11/15] scsi: sr: Convert to scsi_execute_cmd
Date:   Thu, 29 Dec 2022 13:01:50 -0600
Message-Id: <20221229190154.7467-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0004.namprd20.prod.outlook.com
 (2603:10b6:610:58::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: 301d2278-9343-4f4c-165e-08dae9cf333f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CR+eOf1e2I9wmWbIPyKawcwSUwyXzz1jf5k4s+0qQXUhrs+S7TDxp+SGRee0qei8qF23+KoDWwc41ZLf5GwJVR3L9TLs54JGT/LTSHfOn9J4ENSly85DLBIV6Ql5DYm4GodN5mivKIbNdFj6iq3ty5R4ymCnsKJrqIltIaDPBIz41Y34X0nuGTU+3dyb+cniMCBgfmLudqh3ny8tOIsQcaL34UKG7okrKBVP73RlUW1OA1ZQgBXnmqyIHEj/nwG/qt6jlucrUbBDY+/KG2c7kD/6B8asakGHuVb/Xzx02qoG5q7QYDDZd6PY/lwge5h7t74UuNM+q1uljM4mUtSNwv4FboK9/WepXZ4RL6UxcvPLk2czqfDltOa7vzvuSJRCQB8OhnDvo4f64j427UKgeR5Qb1d7PTxtzDcr2OwSUBSJLcKa9Vb67Tefw8rm3j+Y30N1ep+ILETZaiMld9U2b1HmuI6yHuIFl62vNik69ucLn/xH/RYTBfp4mFnaeAWcQCrKIlsM1IInqWdoSyLn1T5lJqSYBdT2MMeZA681F9uuoZ1afdaXt/FlyQ1dDubT76KDhDY56BmgK1qw6R5ZU1/rikY24fi11na1pY3ZTaSSmbsNHjBP2NE7D+JPG+rzVlDbmYQf6Bmiiu8DV0XiIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(2906002)(38100700002)(8936002)(41300700001)(5660300002)(86362001)(83380400001)(66476007)(66556008)(66946007)(107886003)(6666004)(478600001)(6506007)(1076003)(4326008)(316002)(8676002)(6512007)(26005)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/YfURqq4HGEMdpInOAVjdDQsFU2oSTZ1KZZRzRn7fwPmTRNnTAw1fokNrfSx?=
 =?us-ascii?Q?uBEhm3GLszvwjMnC2ekFnVFOsQG/ClHgAFBf8TVojZKW5OXHHdZdeIrnoc25?=
 =?us-ascii?Q?bcVASlWCDuDrhZnzHVFQ4yAGb3Q0BmLNJ/pL3mlntp4awwt4XXcH4ng/W8ep?=
 =?us-ascii?Q?US/yJa3XqLYcR/OBjtq/T7CrUZ7WoSH0tRgX9tPGfvYc/4oW8XkUocYwJvrT?=
 =?us-ascii?Q?dXLe2syAeImNJq1pTMi1drXYBk1NYNC1zTRhQGyRo0xhSGbWyQvbXADZMtFB?=
 =?us-ascii?Q?NsW01bDDzxUTEURubr8hKBu9phFTQaGcgEUZIzXXCOYx+HovS+gm0cz4Rg8q?=
 =?us-ascii?Q?S2oPz9HpfcsvvfSiQXxfj6jBLqLs94kHjTdAMPh1pFApB9Wsm8HiIv3G4KpE?=
 =?us-ascii?Q?n5Z0EqQeeT0MDI8NftIALhSw2T8JpEe3WPMlmWu4+cdWgEMqnCLPao/ucxvu?=
 =?us-ascii?Q?xCmxnXskKOxnGFb4eWtooUKZw4gltgQdeEhgfF5MOvzCddeP2pXeWI/8vt8/?=
 =?us-ascii?Q?uRzxUc2BkGFpmH9U8eorECvtcLc7MOl/4MeFy2sgqiZP9CnnBYaFcwPxvaUM?=
 =?us-ascii?Q?3Y6Mtbf0lWKn9ChsVdgdMibc/i08NFPkmNUFy8XzW5zOt+OW/m9MeovOPN3s?=
 =?us-ascii?Q?qbYm/4aeBYQ1F59zrni7m6ZwLyJj94yh0FANe+7BMD+8/DNc4BhVRmwM1u/u?=
 =?us-ascii?Q?0lfEAbwF4po5HNW8K0ojvWI7ZCgBNMGnkeswNPuTGEMq606cenJBqg0Ov6fP?=
 =?us-ascii?Q?1rorOTu2TjOTLezmqjNH7oZdK2Tbiur6GcmgvVC2J/LG1BwojPnIo3RB1+Cn?=
 =?us-ascii?Q?pZXCNDeSKYKNwx8NqtesfmUG96mQAbA/+90n37qL4m4SL5VHlLiiQrVETBq5?=
 =?us-ascii?Q?Je38TTmr9zzGcSrW4cW+QZyXtyBfG/HTUVDDFHee4nEn+m9VLX6DLZEi3dxF?=
 =?us-ascii?Q?rFGpslqFGX0QgLNVmF1zx4e3WjONQP44ej3DR4Onz0MiN/IDcgIj3ltJ9i0X?=
 =?us-ascii?Q?FwMmOfN3eFqQ9ZqaMEXYxR7taVhB5Lx6LLWi/go902BVNVkx9kliVvN5RJ2R?=
 =?us-ascii?Q?vX5u3YaOREih99jtYJn0C7eglUUV5WnEhDvQFm+G0uSSdMVlKXa9M/X6OZeZ?=
 =?us-ascii?Q?dFdUahs3lcPVVWksvGJgOuyLhmEKW/WRFYrZFj5vLwZbN5881bAv7nEH8pkF?=
 =?us-ascii?Q?MiPyFUMEjlgaaopnydDVvaBPo2uIPm/nOW1a3SopfBw9RSww2k+wzK4ps8JI?=
 =?us-ascii?Q?UzG53lTpzWReto2hMtTRD+IvW2lcmXINDHVLRBTO1nPWZh0k8MKes/+jWDw7?=
 =?us-ascii?Q?Jo3qRhlh4C4KLLdWV71o3/P39rWaFCO0noI1wO5ERlc3qmPS2rBOP0wtG5jX?=
 =?us-ascii?Q?2GI0/tHoRhW1RS4hClEb97vUpwdfjYy3AgIcGvTIGlVGMeXtZJTe2SyECEUK?=
 =?us-ascii?Q?WWxMkc/NPIAbAfAQSPKHF7qPmweg5Z507nq4FxHRW6ZIq3JdWpTuQ4P9vE+h?=
 =?us-ascii?Q?aYabJKZ+RqK7XGAZk4VVJX3WVBSuPftaJvsJ65Hebzi9Ci102ttALwVmkJhA?=
 =?us-ascii?Q?zcvjqLj8G4ByrLfqhBUEfgbZeMGTLfVj96fGCtMNZX1HkmCOSOYAiNrm3YTQ?=
 =?us-ascii?Q?wA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 301d2278-9343-4f4c-165e-08dae9cf333f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:02:15.5027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Bp20jwYPy56eLVMdIWKIa2ug0BFHW5rVXhSjGm6jUxyl54GnyYkatdkjKMzoTcskbVC8DNsp5Uvz9zLS0mCAfd+cmAkpame3NjXFCFep9Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212290157
X-Proofpoint-GUID: 0jLn31sixM42aD6R9qb_F3UedoEwahc6
X-Proofpoint-ORIG-GUID: 0jLn31sixM42aD6R9qb_F3UedoEwahc6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert sr to scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sr.c       | 11 +++++++----
 drivers/scsi/sr_ioctl.c | 17 ++++++++++-------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a278b739d0c5..9e51dcd30bfd 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -170,10 +170,13 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	struct event_header *eh = (void *)buf;
 	struct media_event_desc *med = (void *)(buf + 4);
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int result;
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, sizeof(buf),
-				  &sshdr, SR_TIMEOUT, MAX_RETRIES, NULL);
+	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, sizeof(buf),
+				  SR_TIMEOUT, MAX_RETRIES, &exec_args);
 	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
 		return DISK_EVENT_MEDIA_CHANGE;
 
@@ -730,8 +733,8 @@ static void get_sectorsize(struct scsi_cd *cd)
 		memset(buffer, 0, sizeof(buffer));
 
 		/* Do the command and wait.. */
-		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
-					      buffer, sizeof(buffer), NULL,
+		the_result = scsi_execute_cmd(cd->device, cmd, REQ_OP_DRV_IN,
+					      buffer, sizeof(buffer),
 					      SR_TIMEOUT, MAX_RETRIES, NULL);
 
 		retries--;
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index fbdb5124d7f7..5b0b35e60e61 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -188,13 +188,15 @@ static int sr_play_trkind(struct cdrom_device_info *cdi,
 int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 {
 	struct scsi_device *SDev;
-	struct scsi_sense_hdr local_sshdr, *sshdr = &local_sshdr;
+	struct scsi_sense_hdr local_sshdr, *sshdr;
 	int result, err = 0, retries = 0;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = cgc->sshdr ? : &local_sshdr,
+	};
 
 	SDev = cd->device;
 
-	if (cgc->sshdr)
-		sshdr = cgc->sshdr;
+	sshdr = exec_args.sshdr;
 
       retry:
 	if (!scsi_block_when_processing_errors(SDev)) {
@@ -202,10 +204,11 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 		goto out;
 	}
 
-	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
-			      cgc->buffer, cgc->buflen, NULL, sshdr,
-			      cgc->timeout, IOCTL_RETRIES, 0, 0, NULL);
-
+	result = scsi_execute_cmd(SDev, cgc->cmd,
+				  cgc->data_direction == DMA_TO_DEVICE ?
+				  REQ_OP_DRV_OUT : REQ_OP_DRV_IN, cgc->buffer,
+				  cgc->buflen, cgc->timeout, IOCTL_RETRIES,
+				  &exec_args);
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
 	if (result < 0) {
 		err = result;
-- 
2.25.1

