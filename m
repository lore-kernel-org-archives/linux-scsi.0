Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961EBC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 23:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiLNXw7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 18:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiLNXwi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 18:52:38 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7424874E
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 15:52:36 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEMwiBc026674;
        Wed, 14 Dec 2022 23:50:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=U9YUbYXckhFwNyf/bt2t7bKxycCmtnjgtYOSa0JGfuI=;
 b=nnbfeYlSWB3UiSKFAStMOK3144xsU++fmncL299ZREs8xvrhPKOuFKrDLk4/nVCJSMZU
 2hv1ZjHwjztxGX20yo8vlRQG0EzTJ05O7OsO34k6cmrIBClFXLBcU5Qk0O0Xlb31l3GU
 bKb2jUx1sMC1JMWDypA40lXp4FcdKEnHRsLWuy2s0hoiCgkGnrPUv3SPhPmRQCD/8i9e
 hUIq8PYhkmUdpfCzgm9renVJHcjarXPVa47J9qWXNY6LmfHACqX0unFoBJ2QzBd31hIL
 MdFqilT8Oz2gEQBmBb+4zbm58oS7b9y3RxvaSHsOfHzHr1Nrk/8hKaD8GPKV6wIJmoL+ 3A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeruq5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEM8a46025159;
        Wed, 14 Dec 2022 23:50:29 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyen35ye-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 23:50:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frfyheT1SXCdACIlEa0YFJEaQqr9ef5+Nz728FtmBtCXvroeWp21F/znbtIAb2AkNoRDDhkRZcpXoH1Kjrf2c98SXSExf9sj5fR9KSZ7hhTP2XRtFRyyGxuoqOjDBSpKlX9/asD8ASwrL98bQD9+stJyzqdUSaaJiV0FKAc6ZpW/uinHpIsoryqonWTKSQj/q3pEUBXU5bBctj08I8yAESQ/ZlpK1/Pk8SMtWMkk8tU5FVBj/6f0FS38Nw47YxLx+YP13UDvRwqLSARb6xRuOhVB1s/07VSdvciwvXgtb5EVD6nxq+1B/Xrs+A2AWsD4KQrQYbmqf4n1XoONtMtyVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9YUbYXckhFwNyf/bt2t7bKxycCmtnjgtYOSa0JGfuI=;
 b=Zget2j4igtqhfOOohbzalU3osRKnBhDZyBXf0EI0TYgG1DsHoBAjykaN3a2y6kArAJSqK7UiNcHHZv+QqSNvivnISBclZsI5S34Vo79BPHjFQksd5Z3lH/bPfEOgTf03jjWV7Pucrguie9MpDxObCw8YYrFq3f4gDinQpLqWt/wFH4WP1SpACvH8ZQlTE/cue/qRs78FsKSSPmnxItBHXrzG0hbhyZdaKljSb88EB0L5CzIoOQfNP/uYinJLtR6UL1a5J1tgCLac7BK17s1YAXOL2S0oWHfEayzY+2+gRikr5D8WUZgj/f60bSpve4mdpQyO8/uja7kcIr1W8OfRMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9YUbYXckhFwNyf/bt2t7bKxycCmtnjgtYOSa0JGfuI=;
 b=WA+4zPZCHU4KgPqveCOmSVLBZBy+qyuuRJBIWZDuwCSHcPyGTLvE24xjXrhKx7GPYtlyPn+yjXDMAjY9Rp8WAmId9835rxAAlPvgq3L5RkCc/MI5Mw1Sd5HIuSB5w1+uHel41vIgTukJ9feMLayhDRTbhs7YyP2L6xy3enKwBYY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA0PR10MB6699.namprd10.prod.outlook.com (2603:10b6:208:441::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Wed, 14 Dec 2022 23:50:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%4]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 23:50:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 15/15] scsi: Remove scsi_execute_req/scsi_execute functions
Date:   Wed, 14 Dec 2022 17:50:01 -0600
Message-Id: <20221214235001.57267-16-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221214235001.57267-1-michael.christie@oracle.com>
References: <20221214235001.57267-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0377.namprd03.prod.outlook.com
 (2603:10b6:610:119::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA0PR10MB6699:EE_
X-MS-Office365-Filtering-Correlation-Id: aa66285f-6aec-48e3-0b23-08dade2df9f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9pnGDd5zYc3OSTCJUFaGKwPPL1YU8Tg1rZTTUyHgwAIBtQZXnG620jrS/R3aGTAqlrEH4AEFlZX7h5u8PGIPAxm95nlFK6UgwOx0eZJgqVfkj/hdSwXjCBkToQongaUzHsw8wk7+hFt6+AE4NIgY3u8cOSYd8tmoKagjEI6dlagUxXHHseHwRu6puBZLdkaZPBovEtfg8GBsBihNu/mX+AY7dgTrMJUQw40a1orDf+WjBESY14OFkn57IsI3ozMLnjb0eOK2vSE6+fsin2EREmEe4KTX0v8ohX77FAhNYqiFmW3wbTKhB/f7PUTWNWQ+CWl9ECOS903txuoYooYg9DIpBhGpwdhNelkmSXmjLXT8r1OUGQZ5RZvbfl4dkIT8N3wiQeCePFTRXpIvUNqOD9IfnLaeBLpUDq9hlrE3lOiEVcxdyg5+4DsYJNqXNJ50Wz6l/gJyPEw+Zte+yshwqDy6/X8tFD9Dokc/gSzP3O/gDewJ8diVDr6lW10hIb1a6pnduG4zeT9+baRLk261Pe6ZzXhpy/cNFjN+juxXEQptcFJxDVFvJFHfJ0WbCi93L3W0crcSkN/3rq19erU8+AFVPnGtPuN6rrJ32U+OFvWyQpTOfykqI3SR7EltqYn9XxlJBzc6KbP1NX3raMf9UQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199015)(36756003)(6486002)(86362001)(478600001)(316002)(38100700002)(6512007)(107886003)(1076003)(186003)(6666004)(6506007)(2616005)(26005)(66556008)(66946007)(41300700001)(8936002)(66476007)(2906002)(83380400001)(5660300002)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?af9RZc8kz16wVyyCd5j+x04IWX0YXO4y0knTUHV2iP+bfZU5jgPbcS91welo?=
 =?us-ascii?Q?MtGzc05sE+paLcHzDcNJnz4tXSRyJGFTqocA1GYa4csXSqEXKHIRmCEAB3LP?=
 =?us-ascii?Q?35hdvKv2jMelgrfg2KZIIGeYGo/KiUcgliEi/AIOeam1PSYbskz8SXnLSoiL?=
 =?us-ascii?Q?SRVkM/6lGxa+pWuImWjCKLA10e1hVhqPJxHu0WIVrJ4SSkUOvFbyNeBsFMKc?=
 =?us-ascii?Q?KGZMudlBYMvBU9Z18lqoaXbz89KKrY++PcRfBUiHI56qB4MXVVGzRgiTuDNY?=
 =?us-ascii?Q?KpfdjuJ2Y1XTe1aFRMXDzmTM5Pdu3/ziKECN3im47hZd2whFxKW5Gs0lD20i?=
 =?us-ascii?Q?uM4xY9YW8QKV4zLq3IVmSm1lztPhcounRcLWKTIFn6MahqweEoT2dDNL+FLn?=
 =?us-ascii?Q?ulyTX78UUfUjzIvmdMhaSOaT0nDNPP/7x1qpXZ/NNiY7GYUMpgLo5En1RelU?=
 =?us-ascii?Q?6D8UQuQ150MaPLgzbicruohNy9AGRoenv83+00JGZeNGHTbwWaOSaM5zNycc?=
 =?us-ascii?Q?JYWEr1qC72hfnciVKEZEPyYw0KdbWVplrT3NKafX0m8nbmQZuDVa4MkkfxQf?=
 =?us-ascii?Q?EzVZrVrrpYO8qIjU+Dm2x7bEgwzywH4k4KTkAbdzgO2lxruViSDkVi2Gl3/S?=
 =?us-ascii?Q?beJFH739rnB+cFOWtVutwEp3GdGZWLSb1YpiS1bXZZRGpzXReMKxB9m88++L?=
 =?us-ascii?Q?PQeCshOI6G0MxG25p3iJOmn+5v2a9Y04xiXm1ZXD0JO+Nw2xns0ETgfAg4np?=
 =?us-ascii?Q?NBQst5VbqYbjwc2UrsULAR9hGfE2Z+CIAd+zi4EPoE5LSRTwqDQrX3wODX7l?=
 =?us-ascii?Q?e3RcseSJZKf8LsUZnu8SvyoN6JiJSybPiYIeUb/5nxk/g8yDpPOzaLir1c9m?=
 =?us-ascii?Q?pHIVvNHbJb046/71JUyccLn2BBIus5yczy25og8xepz0VmfQnMkCnA/YULDh?=
 =?us-ascii?Q?2RqM2KryMI1VfWZZretpt3Hs3JwMOOafNiLXV5J4qLcfKERzpJzVUDXcV8u8?=
 =?us-ascii?Q?MQ2VaF26m8YR3+Ep+A/ujrYnjlh7V01CGixqo9IdFsZtsF3mQJrsi7no6gaY?=
 =?us-ascii?Q?T58qfq9K167XEALDlSiW2H4k2aTzbpzSW7SaRgwcPNlw0EDMits2N2X8bXjA?=
 =?us-ascii?Q?q1yQdP3Wz6nSdxXEi2zD17UoAFFOQCRS4dLlq7OENc0B0l1s6Jc5mo5KtXTo?=
 =?us-ascii?Q?3Up1tbg88iWBDDpUXqdZ9cCTY/b4g4ZqWMqcfNGGcfSitM3GlsDMgFk/W1Ol?=
 =?us-ascii?Q?0RhDxNBGcl8HrP1RdJSDq2j4EnT9diPpVaLzvhTsXH9evxOyOtzRhc7Q7r1L?=
 =?us-ascii?Q?PwHmxL6OXAZmYx4pj6kXyg8uwYyX+c2jhnCvpziksmcCeO8CqihtvxknJANW?=
 =?us-ascii?Q?Q2/qU+JXlVAcwpT07C/isbVmQCZ2Idp4vsoaKidCMKBYcP8TgdHHeK0b0mhk?=
 =?us-ascii?Q?1YCAVJ4nfSX94NTDJg88WHAHzXfqlivC4rwE/eQU1b/8A9A/dU5mBdEWp1Pl?=
 =?us-ascii?Q?bH2D3psVfzXT1/CQWw296NolmmZuRL5dJtEbvM6DM8SU4L6108qhdD1dV8oG?=
 =?us-ascii?Q?JjS4STT9j4XUnw0DVND9EktHXQDQmqx1tb7kkoGoFYKlqRyFoCOweyVqaREM?=
 =?us-ascii?Q?zA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa66285f-6aec-48e3-0b23-08dade2df9f7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:50:27.6051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kqzKvDdwKuRw5q9ClDBfnbw7HQij8gWOTG8Zd35RN9crtB6Yk4a45Cjzq36hg2imTMCMSECOgvOCRqImdzGsJWT2bpVuZz6mcp3v8tKHOsE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6699
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140196
X-Proofpoint-ORIG-GUID: 0pTHgezhKofC8jVCbRplfmfs7sylF3X1
X-Proofpoint-GUID: 0pTHgezhKofC8jVCbRplfmfs7sylF3X1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute and scsi_execute_req are no longer used so remove them.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_device.h | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index f6b33c6c1064..7e95ec45138f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -470,37 +470,6 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
 		     int timeout, int retries,
 		     const struct scsi_exec_args *args);
 
-/* Make sure any sense buffer is the correct size. */
-#define scsi_execute(_sdev, _cmd, _data_dir, _buffer, _bufflen, _sense,	\
-		     _sshdr, _timeout, _retries, _flags, _rq_flags,	\
-		     _resid)						\
-({									\
-	scsi_execute_cmd(_sdev, _cmd, (_data_dir == DMA_TO_DEVICE ?	\
-			 REQ_OP_DRV_OUT : REQ_OP_DRV_IN) | _flags,	\
-			 _buffer, _bufflen, _timeout, _retries,	\
-			 &(struct scsi_exec_args) {			\
-				.sense = _sense,			\
-				.sshdr = _sshdr,			\
-				.req_flags = _rq_flags & RQF_PM  ?	\
-						BLK_MQ_REQ_PM : 0,	\
-				.resid = _resid,			\
-			 });						\
-})
-
-static inline int scsi_execute_req(struct scsi_device *sdev,
-	const unsigned char *cmd, int data_direction, void *buffer,
-	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-	int retries, int *resid)
-{
-	return scsi_execute_cmd(sdev, cmd,
-				data_direction == DMA_TO_DEVICE ?
-				REQ_OP_DRV_OUT : REQ_OP_DRV_IN, buffer,
-				bufflen, timeout, retries,
-				&(struct scsi_exec_args) {
-					.sshdr = sshdr,
-					.resid = resid,
-				});
-}
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
 extern int scsi_vpd_lun_id(struct scsi_device *, char *, size_t);
-- 
2.25.1

