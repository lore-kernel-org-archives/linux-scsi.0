Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655C4C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Oct 2022 17:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiJCR6B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Oct 2022 13:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiJCR5Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2022 13:57:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4061D40BE6
        for <linux-scsi@vger.kernel.org>; Mon,  3 Oct 2022 10:56:28 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 293GOJRs014345;
        Mon, 3 Oct 2022 17:54:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=n9qvxMk/MqOhLyjFdSy8PDxv7RKseupKjD1lJCbD0O8=;
 b=qCI6RunJmPXDCcXuA6m2TFC5BFi4tNh8vRJ4sb7mBUZegdrctThOPZD6V+Wd3utLvVpW
 BySp6RtLfKziF3e+QkLf9wfphHgDdFQKel1bOr3ogL+zFnH08gfWpsUp4Isnj0c1cung
 NKsBkV4GGh1FIv0CMN0PFhVOhYn0nLgK2RS3/DjJC0elXIbL9DFFtW/knBy9z0odoxg3
 2+CjTGG19N18DdT66FXzUngdi/dN/gscmyAq8b+tl+w4XRqENJ15qiTbpUv+CEbEfD9Y
 GX4/vceIpFfPw+o40ndDtMWOcOsDDx9lB4qSmmwg161af7NKEYozvOmpVlW9ObFJ+Au5 eQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxc51vj48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 293HdCZV015791;
        Mon, 3 Oct 2022 17:54:13 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc03g42j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Oct 2022 17:54:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/0R5a8PXjWxzVSmhliKmgcvgG3xG4AfItJBmqbbhY7CIiFGglicrIuFtnYrLqEB2+NhILGNXqJb4yoS+IST53O1DpeznW5GmYAsoKebpNG282JGAxSMBZ9FdnitNlPP6/Jf354SqUG4JStvvZMslp9LuYzJzCJtQpo7LDm1CTofhJZzLU/D+QoQZ5+s7TlKmAfiD4vz2jUiUEQpb5hIBYUlSLr/8xy2GbNtJIZooJMTKMzZtBvoc5jMmdMZOEeru+/elxM5Y0l+GnMLxX4C00jlSl3h+lCs7wSGenLKj5PAMS9Wv3w7+MycAf/zwnku8O9phAiXm9GLT6MSItupSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9qvxMk/MqOhLyjFdSy8PDxv7RKseupKjD1lJCbD0O8=;
 b=oCPLzpLjs41U0vI6OmKtCprvaLGitjx7TazYKQ+tcFnsg02axhgno6fwh0Ikem0RdApJH0A+eQKgFxMfz8K/uoqQGx4ltBYKn5bZgmq/rB2QY2bnTRWx3iRH0bv9fNpqD6s3ebAmoWPfbEYF45s7ugztxFtQUyTTySf+3nM0ZaxNPHLDIs9hCY+6itI38+aZtdIUAcjuaftboCGtK+daa14Y1WIY14Tp72JBdSbIl/kJSQbhm3hcMBUhoioio4gYowJWTuF7LaS3UY1TJTKanrRLz9ABKAU7kV+QwdhO12SXBXKrQd4XyO1s03DrD+CIHlxzAsx73IbWcBmjwlk4kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9qvxMk/MqOhLyjFdSy8PDxv7RKseupKjD1lJCbD0O8=;
 b=OmR+8JAKaUt1dJH/yBCxr6SUMSNxM7/uva7N5C5a1H7WAk+57srE/cARKNs/OSDZgYIK9xMeVPOp/ntPd7NIEiSW7EspM9lQx70Llg9yFjRsMlELXo/RukvzOqIo9dkfVuTwF3Few4rwfgMVz8Lv7/B8VIRk12dMxQhice211Is=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 17:54:12 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:54:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 32/35] scsi: sd: Have scsi-ml retry read_capacity_10 errors
Date:   Mon,  3 Oct 2022 12:53:18 -0500
Message-Id: <20221003175321.8040-33-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221003175321.8040-1-michael.christie@oracle.com>
References: <20221003175321.8040-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR11CA0030.namprd11.prod.outlook.com
 (2603:10b6:610:54::40) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4456:EE_
X-MS-Office365-Filtering-Correlation-Id: 827569c9-6f53-46af-c3f2-08daa568474d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yOapUx+930BJspyYvzRR7Zuse4bA6EYiyMv8/ZSb7bb1LFXIdrnIUenv2p8ju5vgd8hFjxYaweHq5srBV24noD3XespVG2cvNT12dQcGvh4e/UesMhpE13C/WEjjqrhj9KWq+nEhVHx0XcATmOPSeu5/UIrDEhFFTTOO8GMZWQDIhEGK+wfH8QhjbUy02/bSyzqpEknqvkrMQpALwDCUiicnASBDF3Fz7jgh8zZncvIDNUitKGrXZD7ZCnXqOqp5t8w1/B3o3NjIKevYHJdv6gfMUlAS7vz4v8z8fpRvnnO3Wd1gNitYE2ATULPksB/wKDRK7ZXFCns3Ef/xRr09deyOmDYPwNJngLigyNRjBRz3aIwi4LXykzksbXz4mYnawr47O0LTrdemIVIfFolBqP3El7fP5+UE50EehpXhR3cE4hXwx+wt+VnlNHQdVUHAS9uUaWQjgdufr33Fc8syLlgh77ym7gFuymv0CDWXWMVFuQRot0QmCR2OuL/aNmj5nuqWveI0eO9oh9aOiS/AfM2SOSMAlx7OlVZQfqoPbxuWLpqQ5ITcoCgpmsBs+ZlSw6E/0bVxT3ebL2APrEeGsbU8MrkL9sKy/9W7acMMZBl/ocefAqeqVUOv7nZU50ikIx/phtQXlGfSogP5L4d2e1CRHqXTzyEYipzlExwQStI2aHKeGq2nkSGhhGhmTovCYTmIR4YMZQHCF3HC1zzTPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(5660300002)(36756003)(66556008)(86362001)(4326008)(8676002)(316002)(66946007)(8936002)(41300700001)(66476007)(186003)(1076003)(2616005)(83380400001)(38100700002)(478600001)(6486002)(6512007)(6506007)(26005)(107886003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?38wHV6kQd3Eg5wM0s/Tb+k6OErVsqGN69MKnACtm6LacfVlc4Agk+8XTs1J+?=
 =?us-ascii?Q?0cwByKPHaCAoHP3Qe6/uI3IaA/ZvujmGm9oycgRzOyutd6SfAFhFtaxpoN6C?=
 =?us-ascii?Q?ZSrGGzM+Osb/J/iX73ui1A0K92oS10rcia+uc0EdrYzGW3YVO24JJ+Ec8r39?=
 =?us-ascii?Q?/XoNORK2H4MNrEJn6lF2OW2ml/0imtfFCIL2pXK/qMmGUl3H7k+xdsOL+bAB?=
 =?us-ascii?Q?kbXEuIPTbl0JjzAatdvrTiJuoJV+UlBz8G9TToj7I45E1mhDvUIWqhHr4nHI?=
 =?us-ascii?Q?B1RC1MFGcwKQJhFTMi8+KAvabQJVErNuQFsbsJIG/OPHB6xok40VsahHPi49?=
 =?us-ascii?Q?Hzq+7b9/nIiYanedRmV99Y2cOB/pwVaa0pCLvgQrpTHSw187pImU7j97emut?=
 =?us-ascii?Q?ZSSppSoGe1k/fqZCrWd2B9sCjVHP2haB6HMi+RLEvEn93kHR6Zcyi4M30V6F?=
 =?us-ascii?Q?1qB+YtZ6Mo3CCLzZVIA8rbgDNhIlHwRpnXLmneb+HWN9HEmCUhk/b1VKnRR8?=
 =?us-ascii?Q?t/XoXSmd/LBaYlExT2+pxcUOaNn6NOoeTpg9rWazkHdlcNlsw7ZR2/gKxpkh?=
 =?us-ascii?Q?6e8xCR/QQ6dos2O4vQWV2Iy4rUsFgSnT1lY/6Apu/IZtP5K0/zllEDpzE45c?=
 =?us-ascii?Q?9Dq303n0QhyTkhF8L4SK4yoKXa4qmEYvVtSxHTjseNp7k4CTGcZGGPgF+etM?=
 =?us-ascii?Q?Rg79kNitna+K8x9a2gRPGpEHHVhwnEsV5VQkiu/y69XiELr/thty9yMZSt5b?=
 =?us-ascii?Q?qPbHtFV/PAzRlJN+B0hmfcKGanyLzyMnX6XxtSlsNfBCVtFBX7pbnmwchQZl?=
 =?us-ascii?Q?olwy9+DNd3M6Qjv+RxnwEiEPbdf58IhB0GKH8hmLttax8fqlikmqytF5ChBn?=
 =?us-ascii?Q?intG4Y6E/XpAkwWwuLShNge61IDOb/LmYSbJml3zK4zwYgYppyKa3Osp7saR?=
 =?us-ascii?Q?pMq9ByNMwrMBVMTR2rbGbAUHXlowwKWJyiMfNlIlb7LCi1in47Kl74szyztD?=
 =?us-ascii?Q?aKHy0zqDBg99eSVU4+mzlYyiAQeZ1JcvVIhi6V3NO++GmqnhrFD/U9jHfK44?=
 =?us-ascii?Q?FDep33A4w1QGM7NLvSZvfZfBoPAzcA8KV4xQgzTK5GZ2L/rtd1wpIIcRyg5a?=
 =?us-ascii?Q?xF3lrptGCALjiyzPtPWoKIf9MHkRC0XYKX5Qx7BPQ/7xmg0PHe/VXq94v0V+?=
 =?us-ascii?Q?USm8YripV3vxbUpOvfADg5WlO1s2p9Lge8q1uFRSZqkA1ckTAkdPvo9GJCLW?=
 =?us-ascii?Q?xxCRk8LWaFrMhKrGAhOPrz8qhAxKr/aRT8Uc+1kULerzKrcLJtu4aZaRgidx?=
 =?us-ascii?Q?L8aGyIG8t5C17kJZxYdIulRAcTt+2j1VjqcyQnZhB526e3pws6QPXbrxuto0?=
 =?us-ascii?Q?1Tpvq/TKMOrPuHlj/Ch8syBJxgSq2WkXmVdhjVxu96b3aWJ9/Qe+MBtXj0nG?=
 =?us-ascii?Q?HtRHT9D2kP8/0wF24bvhXjIAuiN3VaX39+T3qEcOJduPZ7KS6hkuryf+psxD?=
 =?us-ascii?Q?pvYd4ICzyBPBIo78h8ekuU+KYzbFIiQ5OhZDxCbZFWfjLHMguucQS+lQ2Tiu?=
 =?us-ascii?Q?HAl/lHOc8o+dFJTewXeiF1aHPL4j6t/PrE1O+GMSDbjcC+OB3rBi2zLjrC+a?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 827569c9-6f53-46af-c3f2-08daa568474d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 17:54:11.8744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jlFAmuWpGNxr0UoCPNWdQNquBWOXfJtNzvUGq9KyGWUcEUaMO0HcWwk8RkOT1ftBPSO7VFQ8zm/A8E/9ET5bQO8oYVFLT7gKG0Y6xSTaaY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-03_02,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210030108
X-Proofpoint-GUID: tgcAqJSorgJDsCap8a4VVzsvCJ0Pct_y
X-Proofpoint-ORIG-GUID: tgcAqJSorgJDsCap8a4VVzsvCJ0Pct_y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has read_capacity_10 have scsi-ml retry errors instead of driving
them itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/sd.c | 60 +++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cb07a887b40c..dacd54af40c3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2401,41 +2401,41 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int the_result;
-	int retries = 3, reset_retries = READ_CAPACITY_RETRIES_ON_RESET;
 	sector_t lba;
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
 
-	do {
-		cmd[0] = READ_CAPACITY;
-		memset(&cmd[1], 0, 9);
-		memset(buffer, 0, 8);
-
-		the_result = scsi_exec_req(((struct scsi_exec_args) {
-						.sdev = sdp,
-						.cmd = cmd,
-						.data_dir = DMA_FROM_DEVICE,
-						.buf = buffer,
-						.buf_len = 8,
-						.sshdr = &sshdr,
-						.timeout = SD_TIMEOUT,
-						.retries = sdkp->max_retries }));
-
-		if (media_not_present(sdkp, &sshdr))
-			return -ENODEV;
+	cmd[0] = READ_CAPACITY;
+	memset(&cmd[1], 0, 9);
+	memset(buffer, 0, 8);
 
-		if (the_result > 0) {
-			sense_valid = scsi_sense_valid(&sshdr);
-			if (sense_valid &&
-			    sshdr.sense_key == UNIT_ATTENTION &&
-			    sshdr.asc == 0x29 && sshdr.ascq == 0x00)
-				/* Device reset might occur several times,
-				 * give it one more chance */
-				if (--reset_retries > 0)
-					continue;
-		}
-		retries--;
+	the_result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdp,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = 8,
+					.sshdr = &sshdr,
+					.timeout = SD_TIMEOUT,
+					.retries = sdkp->max_retries,
+					.failures = failures }));
 
-	} while (the_result && retries);
+	if (media_not_present(sdkp, &sshdr))
+		return -ENODEV;
 
 	if (the_result) {
 		sd_print_result(sdkp, "Read Capacity(10) failed", the_result);
-- 
2.25.1

