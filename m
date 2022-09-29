Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A9DC04A95
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbiI2C5a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234844AbiI2C5M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:57:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C138311F112
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:57:11 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1TRoF011074;
        Thu, 29 Sep 2022 02:54:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=A/xvSpK4Im7k0WYeCwfj3rNU2d9AWE8FTbCSFu4vjLs=;
 b=NKw7EGPlJiAhxt1K4pJpIKKXPrKy3D8quKDhXBm/ZTHFhUQZO9oKW8zsshJmVrbYnd5u
 x3HUiu7JYt7pTas+B1kKGyyUilJMLEekEw/8WuTpjYv44mgZTAtlkllJK/LD7VrVgw3P
 sTQn4EcuEYU87Q+C8tgnP4TVbHPJEdBompa3ELieorlvUS4tAzSGgEef83nytRRXisWa
 TsDFLXy39NvUrBDysTltXtYUSQaSRc2eWirb536R+ZHfHs4jMtyTJe0MBhFQze8pTh5q
 e2fiH7as4qQTmdqlFnK8uzXrk1JFZvcifdouNvalfOkpanA9h1fn6kA8wA2pjOvjoYyE ZQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst0ku9mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T2SjAG040236;
        Thu, 29 Sep 2022 02:54:56 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpubbphh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UdQdF9PGe7Vo4q+j6MYLQdHUwPcYesLYje4GfJOrIsY4mT4xXkRZUwnBcDWgXYk6/qQTSC7u83ApirPM2p3+INVMc4fG7l66jxTiQYgBfMZoc68WoMXA+pBw0078YP0iqP0d51LWcXS3asoR6aAArlkfW5eTUOWy1BxnUzQ5qC8iEYUuzk3ybCnZ/luSU2QZpMakh/NImq7kKERslM2Q4OB2EbYP7LcC/folgGyKjgGLo+WdrWHPiP8HJMu1L6wYFXK5xvzhsgSY/VGXcEbxE39krV7ssE7Gm2eVAOHrz4GaYNEgFR2SSSHDTGhI90FhX7cK4sSELC4cbSx5NMRQXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A/xvSpK4Im7k0WYeCwfj3rNU2d9AWE8FTbCSFu4vjLs=;
 b=Lma/aHtCUuwdRL6AflcWoV+slDA5jZCiQDgniVI/Fti7+xVFr0u9YQIS9BNgMuFsjoLCZSJpUSgEUvT4cMM+WsmrVxLXnEjAEm0VF0NuVXBq3Fy2rK5hJp4k8605znxHvRwTsiyshK/CXjtWdw2uOGT9kIAC3xH06o08fhl1gFsBIRdyEtvvRNYh7gf88zKrqehVK1FedXB85HBwc8zTBZwWIFj/J0VLltTyWMMPYwCG8HVXw9M9zpS6pqflfkX+0dnrZcBVqgibhvyuRmlFkma/R6SlN2bCxkQuoZ1F5lWObF0K61AH6nzsrtsijurvXAmHqA75R6GS6OzTgDJhTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A/xvSpK4Im7k0WYeCwfj3rNU2d9AWE8FTbCSFu4vjLs=;
 b=cnO2yFfYt1WTvogIjgPgHsAUgRWLTfP652eOwa2UVQUTzsRgCvu/p8Ccpsjgs+RfVwk2v4eYNQseU7mLEKl8bxK+CtG+hY+COn0S9252mkVvbELH3v9o4xGMSi6NS7Yyl3b4w+E9MHSJ3iYshmE4JfHeCNpBZJMd5EtjbKWmq9Q=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 02:54:54 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:54 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 28/35] scsi: ch: Have scsi-ml retry ch_do_scsi errors
Date:   Wed, 28 Sep 2022 21:54:00 -0500
Message-Id: <20220929025407.119804-29-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0062.namprd04.prod.outlook.com
 (2603:10b6:610:74::7) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5872:EE_
X-MS-Office365-Filtering-Correlation-Id: f2a079d3-d983-425c-bed6-08daa1c5fc8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DyYHet8b9AuHyKetDAQ4EykfRdKab35AIoLJyUUJ64Puxb9R15mcp0ys5gDEmkntMDp5j1QHLl1EPhwT+SGfeFFNFhuHTtWgAiCiLHnAglvjJKgaRi/iOxvLQ9Hs3GuZ+rho3vlj/LTe8GS31XADKksTeVqf5hZUl5P6hHQdEpkiYDcRYmttj8sJ8ZoqG88+8f+OqBOopFWNlFZ1LV9UQAZTa7xyWEbBq8Segfw4aigCT9PJGGlAhSJTq8DVMpbeBoVz5fDLcSXr1HipJSENYHocI+RmsoalcPD5OqxUX+xGBNHrBsBil2KhiaXgWz7e38fN61gVwG/ky//QldAr+VY/qXJPYqHORe9G/iDRbfOdBXCcevaEFAi7+KanxT1srD70aFGs0EX3NZCmpT8E9fAZYLc+U6FE21X6raeXuvHojcR0LNp1asCZD5xV8Bpxz2DMy4FfxOmjmfZKBbBdhzJWUDM4e3au99okK4KftyQezZjNKGWQFguwjmztTacZW/1EhuRPcqch3gl1hzMDA6t2LESsrt/eg//X0cPvHiZvn87GcNWuNmwDo0JfPEiuz8ONwl0PjRz5UXRpHZYGesEfgipXQyuyAQZAvmfZ5b+YWlq+Vk+8l6Dlc5uOU5CvqSPbJn3a8zNZFQxLrfeqfjCt/PaM1Z7JRjf8o7b8dVpQIlMQTSvDB1UlJcoQmGHVPez0nIyFahUNRyBGOyvoog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(2906002)(6666004)(41300700001)(83380400001)(66946007)(6506007)(107886003)(6512007)(478600001)(8936002)(36756003)(6486002)(38100700002)(26005)(186003)(1076003)(86362001)(4326008)(2616005)(66476007)(316002)(8676002)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rFMOnMTawCuONWW3AAue2s18pZ0KO7PIkPuquCe+E4W5NsG8W/ZCy+KeUuWz?=
 =?us-ascii?Q?NZ6KO9xhSSeY0063Iy08Wxyn5JgrHV7MzEoZ+epD2pmtudP7iYIdMT/eViiR?=
 =?us-ascii?Q?/5T4GRLlYLZURm3DoZ8J5Ip6h1szjyfC+1IpJFQgJFuIMnWll/Xt05StGwq+?=
 =?us-ascii?Q?Mn1mYLICtPWVl3IEAl2p3lH+4/bSZXCWNQq8hkhFPFRvcniG3LhfTXS+T+Jo?=
 =?us-ascii?Q?F6M6Nf67dC+QDl6/CajduE5odj/g8YSqQM8ojJKbRzpzN7FbTJuljXljHaN7?=
 =?us-ascii?Q?a/qeXxzBdZFCNMDDIlXXpCik3y2b2/1YO5Rfy3TuwxmmJzADxuM1BmADIDt6?=
 =?us-ascii?Q?GeQcfyz47gsJDE8lTANyf4DD6wxIEHhh61yTi4JUBoZZ/l6HHBdgUaIMlyMd?=
 =?us-ascii?Q?bQoEAi66JTTw6x4U/jaU8kIEZIEC5bAgSNV07uaawa7JCupAs6Vt+ltsuiDI?=
 =?us-ascii?Q?mpQ0Qgyv07lVwPoiSgioTLr9VxF08ZSMS1RzDEcCoillFUmzohNd10iNPWjY?=
 =?us-ascii?Q?nkiGd01keTP1M9Gbu/bzNzGV4O2Qx1vOQ/0FQfFu5AoFgYy7opmzD79tsWJc?=
 =?us-ascii?Q?ULorq/gK9m6MI87UQHbckf2za3bKPj/l/ml0aiWy+ZvXAS2ukkZnRKtCZkvK?=
 =?us-ascii?Q?2NJCBTFfRa/qWRT4VOfOLIafczBCF5a4hbG6g5IVq4X0G2hxc8yh6xvhJO/K?=
 =?us-ascii?Q?e5BHKFouq5WesPPoBhExjmwd0m1CJmNuJHeNrDXZdRLlXOjh17me/VTDOWES?=
 =?us-ascii?Q?vuankX4gW0oB6bPoDyusAbvHWjtDRP9DGEapbaeFRl7sF/fmX3oBZFzzwIdB?=
 =?us-ascii?Q?an/T97g5acb2LMcE8aQ/gFB7sPc3ahC1886WJv+0R1KEEYNQhII4YRbjn6P0?=
 =?us-ascii?Q?d1Pax1gdZawDSOg6rkFV6TP7+VUy+B3q3SoFXjwup2fhM+IfjzNseP8OJ/Lw?=
 =?us-ascii?Q?ErPqhWc5UxMdKxptBB5uJMp/87ghHVReHccbjDepY5mH1ucwexGqzlAC+pJB?=
 =?us-ascii?Q?cRqnQm/R4mvBjNxGvdXy1qAak46A7LTErSOPhvG60nRcYbdnyA7eIK69A+6T?=
 =?us-ascii?Q?AIJMX28DKwtptMjtFa53nsBHWAAYu2wgMWhPxmZOy6DNHXGremlcoJNL2VQP?=
 =?us-ascii?Q?o9wyvVoV03jYcwrw/2bvYwJ3crw7Fb1q5CTylNCYCHcTqNiWH2BSAnV+87Re?=
 =?us-ascii?Q?Go8hWOmi/5kh8rHD1LZg3iXnHcnFwuUUdct30sleJ70d9TseO7V5FAa7Dmpu?=
 =?us-ascii?Q?JRkKK5xjzX5fVb1GAXSW6C+8MmVKIGNaejBtr98HScDwpxiRxXB7alOpPTFJ?=
 =?us-ascii?Q?XL7QtbyMwg1nsEq+Mcd6KKulW61lGtL249eZPfjqBk5eQHgDjWb/010JCKYN?=
 =?us-ascii?Q?mydgxx2hltGr+2WMRfmxZe2gSsvPN4ew9vA3pkdPUwZxWrpSD7SleiinZ/TT?=
 =?us-ascii?Q?OgI7xYsfwW83G+kqfLQOS8tGVpBf72GrWpcdJVLkCVHUn0+e7+6DiD6lrnef?=
 =?us-ascii?Q?39+3meRqeZtLUH0QmPQ/ovLmzYMTYSISKEN+Q3uzkQUAT4k6UwTIazOuanje?=
 =?us-ascii?Q?bFHRQRRKC2rt/QMJutLTKkG3DuzrjPIm5HdjEMZU66SMokr0lb4/GIs+YXa9?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2a079d3-d983-425c-bed6-08daa1c5fc8f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:54.5348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JOxa7TtSsAkYuBAl9k3wQaZaVbyB/hC7+AR595TfhUHW8eUdGOIZHOdE4gu0h+vVOP1rg3mtABRgR07ZnUt2wrVsYMoJ9Y+o91FWt26G2oQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-GUID: xP4PmUtzahh0KB3sN6Z1nkNJ1ohS9bWV
X-Proofpoint-ORIG-GUID: xP4PmUtzahh0KB3sN6Z1nkNJ1ohS9bWV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This has ch_do_scsi have scsi-ml retry errors instead of driving them
itself.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/ch.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 511df7a64a74..015cdc0ab575 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -113,7 +113,6 @@ typedef struct {
 	struct scsi_device  **dt;        /* ptrs to data transfer elements */
 	u_int               firsts[CH_TYPES];
 	u_int               counts[CH_TYPES];
-	u_int               unit_attention;
 	u_int		    voltags;
 	struct mutex	    lock;
 } scsi_changer;
@@ -187,13 +186,22 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	   void *buffer, unsigned buflength,
 	   enum dma_data_direction direction)
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
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
 
- retry:
 	errno = 0;
 	result = scsi_exec_req(((struct scsi_exec_args) {
 					.sdev = ch->device,
@@ -203,21 +211,14 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 					.buf_len = buflength,
 					.sshdr = &sshdr,
 					.timeout = timeout * HZ,
-					.retries = MAX_RETRIES }));
+					.retries = MAX_RETRIES,
+					.failures = failures }));
 	if (result < 0)
 		return result;
 	if (scsi_sense_valid(&sshdr)) {
 		if (debug)
 			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
 		errno = ch_find_errno(&sshdr);
-
-		switch(sshdr.sense_key) {
-		case UNIT_ATTENTION:
-			ch->unit_attention = 1;
-			if (retries++ < 3)
-				goto retry;
-			break;
-		}
 	}
 	return errno;
 }
-- 
2.25.1

