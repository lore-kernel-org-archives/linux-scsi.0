Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CF9C54EAA
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Jan 2023 22:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbjAWWOf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 17:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbjAWWOH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 17:14:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8824A3A59A
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2023 14:13:42 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NLiKN2020011;
        Mon, 23 Jan 2023 22:11:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Kw7EAiu2JBG8mY+hDbJDK4Ii9I6tBJxSqr5rWF50Y3U=;
 b=ae4SOyn+MRQAUuHLj+ym79W1DcYnLF9GMGXma/J/xMM16k3WHN/ImOjZpIgaXNN7dRK5
 3rBcsh2/jRvYntcqXpteAa1MicwKL+DLNGsODOXJ/gNizIUGbKxs7PDSQKuX0f4syXt4
 rt6Xy8GlDye6CQdXfDRS/tryILmo/V4+g2IbI2IEBloybZmXdFWe1WUEza5lQ+uRDdN7
 myIJLYxRXNS/mSRj4WpPNTWRWaYHEPsZ1XSVxK8xm8FuWMMdJTbM01htXzHMWdzOyHT7
 JW51oCUgawTvbW1FNzUMpFZC9ONpPJQvMqoB4KXF337YiSOiwbaA482tjQnWR1xJy+88 1Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86n0v3pt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NLAgj3040260;
        Mon, 23 Jan 2023 22:11:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g4513w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 22:11:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/O2ZzMw2mPxAzZsEptg6cfV1eMk8yCaZf+LBUTEHtjO/Pi1eW1UANAMsDUO3GRfrVQ8RFV4ZTer5Xm58lOnwk7IKFo09aW8upwLA91CvjcvU9x4fdSEZabBWxYSn6nbaH9P60ZaJ86j4xApeQo48nLf+XNgjLT/xIZrYRm6XFZh6/FpMp8HTGJufMCEjcqos91qR41/lu4tw6QphVSRtHAQX7gFfgLoFFK2tMppGdM9rRaoVhwxG+ejgp9JkRdW1urdSnaNZHmG3+ofNCKnCszgrEm228f0Jnn1HeYnpuW3jF/xSsxf2dNaHo8vOxvpsaKQRPyL15fuY9akdYspnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kw7EAiu2JBG8mY+hDbJDK4Ii9I6tBJxSqr5rWF50Y3U=;
 b=Mc4NZAfO7AV6clyV+IlVMLwfVuC0Ev1sks3b5V8U/UZ4HbuoidNqNEN1bCn8FvcKb5l92PoD1B1+IlmivsRTr0mrFm9KQ/HpsEEVQmuPsDea537tfV8rYYuoMbf30kMCPhnBsSvYePFpEKTAtBwKcHd2Orz4ZncJgT/T01GVRaSWgccVqTcQEpGki5Az7kuU8sloZXk5V3wYTcC945/Il0kwafV26JZ8xyqWW7IUv0IZMyvbVlQUzyqD9r9UcropNTsVbmZTWDFcYvODA3SiFlwECUb4fqe8g0GOHeJf31yE3vuoAa0n5LiAIIOuuQynG5zr4mfJaaJ958TUvKpBRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kw7EAiu2JBG8mY+hDbJDK4Ii9I6tBJxSqr5rWF50Y3U=;
 b=Nb0vKlvmfRrVtMntZr2MktMedlrDK1oFGkzNQ2FlJaDMHa2Z0J/y8sMsYRL+o8u45INahatmD/VMIG3BU1mKsyjWQMBzxsmIjJMSty07d13aaPDoctA5XwxLUoni7CTLG7p8bikWMoKzgtKSwo7Q8zxiHoekPMF4jiT3gwAjpFk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5597.namprd10.prod.outlook.com (2603:10b6:a03:3d4::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.16; Mon, 23 Jan 2023 22:11:12 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Mon, 23 Jan 2023
 22:11:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v7 14/22] scsi: ch: Have scsi-ml retry ch_do_scsi errors
Date:   Mon, 23 Jan 2023 16:10:38 -0600
Message-Id: <20230123221046.125483-15-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230123221046.125483-1-michael.christie@oracle.com>
References: <20230123221046.125483-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR08CA0025.namprd08.prod.outlook.com
 (2603:10b6:610:5a::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5597:EE_
X-MS-Office365-Filtering-Correlation-Id: be1ffffe-4246-436c-ff20-08dafd8ebc92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vbh6xzdiSjQ3jI6lVqQJc6RdDl0KqEpGTEKrlsHTlAcWotFNBWLu5xAShXehSLatuSCzWgJCI1uxlKHZFIUUQowsNGbceKxhCDr0iukM4Hpnckf1ZhsQBuFqI19+uI/qKDq2foXvzv1XyEsEnbwZpsDIZAuLAec+BuN6u8Jj7I3gZbJqWoeO89fWXbjDC/Vaq8CPYfOoAcgdceDWv9Tm4E9TZECuHerwlN25Ojj39eu4gFyG2TnKJKsMAcC0Owc1EozLpV6Gi2shzA0iQMd2wBsxbL4TorvO4kCAF+O7182eJlInJnhM/ilfrHbFMPO8vW9PxdMFyaKYvjtwAmwb72WToA0x3sfFUg5YsIzQ48P7rqiiEbgbSRRMCBtEABIV3s4X6SP+34xb0bk4ra7SQAlbJJqNslFNmHFQff0GN3TNch3SZhSYkXJ+ZxEE508m+iCcEdtEBEz81a/HQBOQfLlwcH1w+vRf67DoUg+MiCSvZ+R/iKJ9Q6sw1l3S1TW02FkHkzSBvXI6JsM0svGMtcUdfanwxzuB9edqyA6idiCbh1QNNRQM1HrUjOMMIRqVAQ8UoI7lco1Pr2PwqXjnXd/+ouoZLEokXVCpQXEzpMFkT5sgddei8RdD+NeKEO5haw+7erfpypm+f4wc0B4Mow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(346002)(39860400002)(451199015)(1076003)(66946007)(4326008)(66556008)(8676002)(6486002)(2616005)(66476007)(83380400001)(6512007)(6666004)(107886003)(41300700001)(26005)(8936002)(186003)(5660300002)(6506007)(2906002)(38100700002)(316002)(478600001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RNj1E4SVutyj4+cPB0gaMDS/id/yJKerwIikPWUWXXGgtk7xWVYr/2zZPz/O?=
 =?us-ascii?Q?WLwy4eAqCaM2BIj2RhyH5F0wlFAQojgkP29hLndyEdxLW0/yE3ojsAHIJOfH?=
 =?us-ascii?Q?Lm/QrQwhViJQALVEaZ99yEqafVrkFLEE3Vo14RIvKvkaeL/w2ujm56oTvhcj?=
 =?us-ascii?Q?IVwQD6HqsgIlpMoaKWms7iWUTXWIcc96gtmD2UITl6ZHTH3wjU/QbgJtRkVf?=
 =?us-ascii?Q?M2/LURVcKSjGhe32bw9d/oTmvCpwgqqKF00hsf1gNJsMMDy/sR08g5A2X5uk?=
 =?us-ascii?Q?GUzUuAOgjPPFMo2hd+0Rjle3rBZxTIFUSq9rkpCGEzGJWeCtvP5ylFhUCJsT?=
 =?us-ascii?Q?Xw+Qjw27jutOo6SMi9HZjpRs/kCB/SiAdC/5EtRpUVfKOFa7NJxn2Wn8PcsJ?=
 =?us-ascii?Q?OfHSc5pHdL23NoCM7JRkSlw55o1FUE0NuVZ6GZZMbxuIocpJ29SCRXs88WWD?=
 =?us-ascii?Q?MpeobEAV2ZhAj854v3M7eI6RXiCuLck4JAKyc6y1MTzdYlhhEjKDHxzahg7X?=
 =?us-ascii?Q?ZL9bvAPeox+ZN9yU+G3BXa+iHIw+I47fz0hzwvmSfanWDfhORFE0b6MXwjjb?=
 =?us-ascii?Q?Rx/PIPIojsKoQRAMB7ulMtdwbpIx7GB/8SVQZ4VVOE+P9+eau0vQLcke6ogy?=
 =?us-ascii?Q?JiJAZg7YWz4Nkao18Mdm5syKYCRWcgH19H4zKbfxLwUcq9whiA/Z9V+ZSuo9?=
 =?us-ascii?Q?11tvzW19fzoPOosijBQQ+8kucIUt2Es6TxtWbCRPRFFbKsiqO7ZUfo+h2fiY?=
 =?us-ascii?Q?aey0pOuYUdIRf9liwaGKjyObSFrD64EEFyYssxxBAEhyylag5JOz57YXkpkM?=
 =?us-ascii?Q?18zKx+FisiOAgEkUtbkbrEZGADLLh2hrbWbQRMY//3xaHmM9c1PUqunru6E1?=
 =?us-ascii?Q?OOSuWmppy9SkZMZO5x43VfFkYMPYhFTaW4tM5IjtSOAikuGBdGJUVCUc/tco?=
 =?us-ascii?Q?6fhSO+ZipDsCgsHrty5+LX9/e5pQ2er5YrpMZmGgMro0gKVxcWIUrygsoLOi?=
 =?us-ascii?Q?FjzP/+Y673P36O7sxT0VAngXb+Oq+abepU9sQg+wi12qzi25kS3vtLCVXphM?=
 =?us-ascii?Q?B7bI7TDaqRL10f36Gif1b9DE92LwM7l6BvWirqFbSfkv7STspadgz7NqYbQc?=
 =?us-ascii?Q?EcqSwUn+odftEQEBW8xjPTqK1BRCEf2WETFk7gukp2cJB/8h9j6VQ9Rs4qZK?=
 =?us-ascii?Q?0q+Oux9eBI6H68tjBL1b3nw6r9sSQkUnlahC9Ag+e6aDLi8TkNQn48RjZ0qe?=
 =?us-ascii?Q?DaEenm37sHSMQfgIz0sFfBM62b2e/SrzjbNeSzJPOOQLc2/zLdfuVvC1xQ1h?=
 =?us-ascii?Q?qviEykHs3C2gOU0RPcgL3CYxowAwO9AU7td4vX+3EqKNUHYG5HcpFgdaGE7G?=
 =?us-ascii?Q?hQbre9b7TWPFbf7nlORSasmDLx3vqCSCmMQjlW1TvYBI6kgOdcuWEj0tQunt?=
 =?us-ascii?Q?kKU3rlOce+By+nOqYhJh/n74Dyyp35DFtzP7hxZMsCpqH6HerN3O2s6kYMsO?=
 =?us-ascii?Q?NcUPrlKeY6NJH4HMwUIfwt5r3QGefXDi1jq1KnRIUULkO0e99rYzJxH5S9Ud?=
 =?us-ascii?Q?gjYNzKAU3vdnsu1AFwSZhtPodaei44pnaog2cJHVN45mX3ujFloztcfLGcp5?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: R2WllCglN1/Y29EqtMENDbfp4EupIhktw4xromCckjlP/OjVV8gKJZP2S9lmcaQ1OOCagN708bfzyFVQc3BugrnwcStRO8LHupxW5nezo8SWrhbRXUXm/0FGY2OUuyO9cgnQCwlsyZ+f+LC6sx5LrQQk7/MvrsSBt2KcXIY0o6Fa+mItTkAUldhSuku3/qcLs6zYUIJ2/DD3GeoktHb/STLRMkJllwPCHscQeeEmqoGqCcG+BgDNHhH4MNyQ4zGiRhNZQsFOZtaihIFXZNBn1Pg84hIVii/5sbgW7EiVNH7Hvzn+95ZF/yn4Q4nsVrUO4JZMx7IgTS0J0LZUWmGIHTe20sVUD/35H4ro4mZgOkAVqQw9BFNOYohKjHHaX7QgCiL783g1lPA8XkfsRLTia5SXrClQrO8UobCC7dXaqYDFzboKjifWxMyKU2A3dUj5vtxgO+KmihAgx1EtXLVxofrucZUX5dBIxXaSEJN9BGDQ6m1PpxF+cGYQ1Am8xRwt09GOn8bEx40vWnUHxOScxCuJh8XpUTnv83b/Rl6v1ohjdTwuFnXtKCBdXJaiUr5ZtBavRPA6yB5Q/zvrfX1gjcV+laSNbsRhXef7zXOEZKtT//vv6KZz7SFR2qkPYZAiII9T8LLpZgT+6Eos+I/4jcbFHdLoPAVHxPSjddOO5WJyuJuzbY4amMohOdG1VI/bU+bOmEcl8e9Z441SWvxPIOZpWQs6hd3zDLyHsTdE+3riGnGUxmn69iTE8vq+HlqFVXDLe7WwiWpc8PRNdxv8bCw/NyEmBZzsX//dbIxkgmdgmhQkWpqX40Af7EMF+1z8x48TdiHaxRR2C4FfK4wx8GyIwuMgzQxidDGgrBem8rV+0V9YDW/u2Hkyyl8k5emE
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be1ffffe-4246-436c-ff20-08dafd8ebc92
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:11:11.8842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cFSYeak+vYmc6aoSXeaNI7ExdWosX20VBjzd9w/e3mopE/61h7QfPXsVzawlThNS6Ey6r6tHHKsLZbI4V2hSi9kCihI6EKbEkk09+VbrF+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5597
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230210
X-Proofpoint-GUID: 6KBA5FMFZw7iPLFjTtcjXdY8bQkWX1kZ
X-Proofpoint-ORIG-GUID: 6KBA5FMFZw7iPLFjTtcjXdY8bQkWX1kZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ch_do_scsi have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ch.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 87eb3ca0d362..3e29c83f7c1f 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -185,16 +185,26 @@ static int
 ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	   void *buffer, unsigned int buflength, enum req_op op)
 {
-	int errno, retries = 0, timeout, result;
+	int errno, timeout, result;
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failures[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{},
+	};
 	const struct scsi_exec_args exec_args = {
 		.sshdr = &sshdr,
+		.failures = failures,
 	};
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
 
- retry:
 	errno = 0;
 	result = scsi_execute_cmd(ch->device, cmd, op, buffer, buflength,
 				  timeout * HZ, MAX_RETRIES, &exec_args);
@@ -204,13 +214,6 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
 		errno = ch_find_errno(&sshdr);
-
-		switch(sshdr.sense_key) {
-		case UNIT_ATTENTION:
-			if (retries++ < 3)
-				goto retry;
-			break;
-		}
 	}
 	return errno;
 }
-- 
2.25.1

