Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A87C04A95
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiI2C4w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:56:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbiI2C4l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:56:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481121191B6
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:56:40 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1TMZb004231;
        Thu, 29 Sep 2022 02:54:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=lFtlwiE3awzlDyF/UcTSVH2It7Y2wrljGZQn1Ltzqa4=;
 b=lIlcnmHdHONFVRl4LmB5raynLEQ4dGfUkVEdXSW660xqWeYWF5gf6GFBLf6oBzK/sXkG
 Y42AblP6XQeridZFhf5OXnJrxxW8gIsionDRDIIKwWYsGRx43SvayzcxXE12/PR/rnS7
 65P94jtu3T0LTkYQiXxD0oJWIIFNWMjMSUz6ClA7fryIeXyXcvqozr/73MJ6dmb1xHDU
 GWzw5Dm+jfMojVJWN8/a6gsyK917Hb+epU2Od2duDPHhS07UwvCazFU7ugjolmkx24Wv
 i+XLAnyzDuyaZ0QHmdQ38TBpdh1fxe5/neSVgjE+uiJTs0sFWARuIChaosVzDYlADbtX Ng== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssubkhhu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1HoFS036921;
        Thu, 29 Sep 2022 02:54:29 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpvfv4rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzRRPZj2Mv0LAIHdTej+NzO7EslyknSq4Yeuh3TmX2Zn28fLJ9IrP2jbUXppIu9CMAJ+wVpc6yr3A1cWDfM4XRkK6NP3FWsmMncCNVXjFhPxJ/4lpq1TaEtehx4A3DzsasbO/dgVmAVvAbuWjB//2yRhyGEwdzCNH4FuG0ixpGOxvXTeui7eQe4zUz7E0aOP3PdFei8cxYEYyUfO25C0KIMRaufLtykoH4zlacBVKajxgmmm41gfvWH2FpC5sEuZaDGMMy6YuMAc5dMmJGT0PaLWBfkmeaPYrKGBF6SgG5eWsstO0HtaDpZes3EQcGtexA+4osAcYP9ABarQXW3qNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lFtlwiE3awzlDyF/UcTSVH2It7Y2wrljGZQn1Ltzqa4=;
 b=LupI49AcNReuiRBMqL3qNwt8xWIbKP//FmIjs51mJXQ+vyUBKwJqxi2hpGHvUmA+r2lxqKWB8To7gQjUn5IcSSBudQ5I3GSqM2gwA48FRK1h3Q17OHNXC17KBM4KkwcWPM5U2BBcmP5haosRq7F01CHtjWeR9WiEILWYj1OZ0GIcVMi/+/oYj50olFy3zF9/UhmkmZmyFjko8R1WpcaaIVUKU86NuW0nfb77AHHy1rc5jJbFCDd916qJFI76Hbx1YLXt2+dsA8s+LiUSGgXCSzf+ouK7hT0pBRhLeq8ccH2I3Q0aege4TJefqc+NmDeS4uGfifwUs1VpeJ0TK4r0DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lFtlwiE3awzlDyF/UcTSVH2It7Y2wrljGZQn1Ltzqa4=;
 b=DpEIAgN6An7lvzUQsGftBmbgAlhsGQiUaXBGNxsTCr+ltqg05lxlbHLGCKFPc6A+ZHVFQaDedPd+95shug/dcux9A3jabZTlo/HM1dtVxW9rnApesoA9lpR1KgjSM9P45bnSWTwtUS5a9oGSU4EWt+P8utrpH8qZ4cnkHX9i2Nk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 09/35] scsi: core: Convert to scsi_exec_req
Date:   Wed, 28 Sep 2022 21:53:41 -0500
Message-Id: <20220929025407.119804-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0048.namprd07.prod.outlook.com
 (2603:10b6:610:5b::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: fb8ddc7f-3e15-4e51-ac82-08daa1c5ebdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YdSpWPMnBalhOwftKPBrNoMizVyDEOQFAZ0iKxU+VqGToDuyiexlgz1V6RHi6FTMEIRxfmNw3LBlh0b0jor7dKok7t476jV8vdkiJAblQUu9kHeRv3KOBHfhmYATkKJ3UQ34ClrgXKz/4iv7zdoLLF2e+8UZ7sA6F7lITConyK1iwxUU4Y41lJFYT7w+x0CG/qgU0ulBH6vlsgCbPHwqMQ0ehW2dQQejdVmeOWOCJgYBeNNKEwq8cCIKR0ljI08lQZKmvTKdSIMLePctuwcsdqRJicaytGqzcqJ5rVX8ikuva4jxuwRFXiSRVHP13xH7DhpQL5kJMKSt3nblQsHoZoM5U291gbPVSqK8XR+A7KpWho4sBjnVjSWZ3iZv06KmxomwuIh64+wuLLLOkBt8ipQsQCfgh2k6uiLGK2GHXLDeC0u7slPUbxAoOW5GBbca5Gi+vq0t3lB/I+vdAgrLO7zSd1p+bN4loc22CT1qNSu2IsKmM6KvuP881uiuAHK56YVI5Ok+W47VPMPfK5RZ5y2h94RdXMPfCKgzIsUvflybHteYhyzINWV0xsOU/eOVZpe0uUTEbjUtFrNPW8+rxJzSVNcafwQAhu7wh8rhLQQyQ0eNHwVovn49WO8Bvwvx4vFSmepdOMHEVuij5SwtXBn5jxlNA6CcvJ9ZY0PJ5pfHdbZNcB+Te0kEjJZsgMsvPIOehfeaMUsSbdVfFcoH+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D16TdJRVVWVEBf+9eNDXurqC7qFtFBT34yrXt5VI59nJEUlLPpPtmbun+azN?=
 =?us-ascii?Q?IlRmi/T578zvE5bKcTxg4rESteS/80DVr0mZBZP6rxS7rDyKeQfN6yQcBdJn?=
 =?us-ascii?Q?OGi9fJNvA8BK/ckvgCMstbXbkRgUtFFmLDP54u+I9DQaFnHZFY/LVA9d7jAE?=
 =?us-ascii?Q?3kiFG84NuysdgzbA9A8imzuVR1XqrWfMctBhAnuATl5XPZ1m4tmoiM1dkRS4?=
 =?us-ascii?Q?/czR3GFtoaDiRuUOxcwlwpeKdPUzUQ47wP2vlX5/mrr1o5TuQ4TbpeT9ezNB?=
 =?us-ascii?Q?pOLputVkCV6DJ7xhRD/OIMhQI5j+vxixrLBgPBPldMopqYAWijLBt7ZlJQ3V?=
 =?us-ascii?Q?f09+tdrkh9gFtrxgSqO56fpi/vLF2/DT1YKU2EmZBvtCndoPGZJ/eBUzOsZi?=
 =?us-ascii?Q?ezQz7auvIkfiKCZ/APagTZZkhwVHW7SJPauNBB48abS01ePwDJNU8iq9LwJn?=
 =?us-ascii?Q?YLV+dUEqm+NWy7u49pj06mEkwBslyEN08sUm7d6j+qJyjFIfD8p55fosQjpB?=
 =?us-ascii?Q?bVqFgDNZ1gqe5ucd8tuE7WUaN6ZHJ8lYP8RvtFqqgn5wKLcyNoj7wjuu5AMT?=
 =?us-ascii?Q?N+MmWqAJrLdKVDNj/mrt/ieTiuruitYsJkh7zxKvH6XqdllOjgO04YYJIOHW?=
 =?us-ascii?Q?XNPk9W+jVyF6iFJ3QxVyGljuqZJLUEWp2tbEV7nl/DX1MZqLVslzteKUDjPt?=
 =?us-ascii?Q?sGxcpUoSJt3ERHkwA8AyceGcKuBwMCQnYLKuK7KKtjXxH2R8Q3jQF/pBxNft?=
 =?us-ascii?Q?J85JaAUo2nbxnZToUw5WZwiwOxz2pj0ajoXFW1dISvSfI7uriENgzYYclOBH?=
 =?us-ascii?Q?rDu0/06V8bw4eZR9irJzmvdKndf7ca0DN+zUPOYc5WZAruuw1/gY+qt6Adzf?=
 =?us-ascii?Q?GffWQRYVPCpjbAtJZHi1nE3gVmDhARL9m2JO4Hc3jMhed7VXVfB3xXddcirt?=
 =?us-ascii?Q?aY6qljgYcr6XHug3Y8ukn8r6WPP7Wc8tu6MBbBBc5M5gHeeePHECeGeFrrQq?=
 =?us-ascii?Q?ExVmjXqzCbdr61QbdijEQq55vGUyGhNk2Yk7GLqrcdkvL3mJVNZuIVavhu4x?=
 =?us-ascii?Q?IOtO5R1ZcRm6vln6pqFMd8a10RcKNBNmVH4S6nZkNu2+MS3kufbUcD7OhLPH?=
 =?us-ascii?Q?hnE5h6y3Uc7fEjeZn5F3XD3a9xM5HpkGcxnNkoMCcaRJ1+CPwHrdrn3eknTk?=
 =?us-ascii?Q?EiP1xFAm4cDaIUlXccretbL7yuoTeI9X7w45CErIfLuaaRuxiCl5V5z489J8?=
 =?us-ascii?Q?EE6g2Bbm6ByB4lxD5/aFwUbUUCsX6Qi0Kyh5TmAq5IwbJPVODib3c4TqI85r?=
 =?us-ascii?Q?gaA9BCDYP0grRTfppUGUjc6KWd7KmbVV1kOTmASbjke1gJY++naIYQiTFFs8?=
 =?us-ascii?Q?wUHa9befSCjPbSSjVJnO18P1KTdFm2i9oLhLlzqlIbgYSUmLRM6z6B4vnVlL?=
 =?us-ascii?Q?yrNMN4209FZL1K/GSXbbQHJYKijLrE8HUcU+cv28cokpiklDMHKmd7ppCJP+?=
 =?us-ascii?Q?rfcD2+oEqi2M/xpYC9bmtrLHCyzJD9GZbOwLz+gYyqBLDHlApU1Hoz/kQRbE?=
 =?us-ascii?Q?kL/OqNryx0CDhvV6k/rVktPcwiaohzQB8PPEj4pqCLeCCpI41sSUqex4I4BA?=
 =?us-ascii?Q?SA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb8ddc7f-3e15-4e51-ac82-08daa1c5ebdf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:26.5530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: icl/L5JljF+Rcf/3WIznhFY+yi2FT2vWmNF1LVohxrJR8w1jos9LDUS6B17Zbn452+3uAlWDykd4z5OKomah0VPCuLfae4/o/QpoXLarAhE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-GUID: LuHzEOXy3Od-4VangzKb0cg4X0bUI6md
X-Proofpoint-ORIG-GUID: LuHzEOXy3Od-4VangzKb0cg4X0bUI6md
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi.c       | 21 +++++++++++++++++----
 drivers/scsi/scsi_ioctl.c |  9 +++++++--
 drivers/scsi/scsi_lib.c   | 31 +++++++++++++++++++++++++------
 drivers/scsi/scsi_scan.c  | 37 ++++++++++++++++++++++++++++---------
 4 files changed, 77 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c59eac7a32f2..8d8090c8fb05 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -309,8 +309,14 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	 * I'm not convinced we need to try quite this hard to get VPD, but
 	 * all the existing users tried this hard.
 	 */
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  len, NULL, 30 * HZ, 3, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = len,
+					.timeout = 30 * HZ,
+					.retries = 3 }));
 	if (result)
 		return -EIO;
 
@@ -531,8 +537,15 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	put_unaligned_be32(request_len, &cmd[6]);
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
-				  request_len, &sshdr, 30 * HZ, 3, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = request_len,
+					.sshdr = &sshdr,
+					.timeout = 30 * HZ,
+					.retries = 3 }));
 
 	if (result < 0)
 		return result;
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 729e309e6034..5708af4485bb 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -73,8 +73,13 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 	SCSI_LOG_IOCTL(1, sdev_printk(KERN_INFO, sdev,
 				      "Trying ioctl with scsi command %d\n", *cmd));
 
-	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
-				  &sshdr, timeout, retries, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_NONE,
+					.sshdr = &sshdr,
+					.timeout = timeout,
+					.retries = retries }));
 
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
 				      "Ioctl returned  0x%x\n", result));
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e1c19fea24e0..9136a3dfcd67 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2123,8 +2123,15 @@ int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 		cmd[4] = len;
 	}
 
-	ret = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, real_buffer, len,
-			       sshdr, timeout, retries, NULL);
+	ret = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_TO_DEVICE,
+					.buf = real_buffer,
+					.buf_len = len,
+					.sshdr = sshdr,
+					.timeout = timeout,
+					.retries = retries }));
 	kfree(real_buffer);
 	return ret;
 }
@@ -2188,8 +2195,15 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
-				  sshdr, timeout, retries, NULL);
+	result = scsi_exec_req(((struct scsi_exec_args) {
+					.sdev = sdev,
+					.cmd = cmd,
+					.data_dir = DMA_FROM_DEVICE,
+					.buf = buffer,
+					.buf_len = len,
+					.sshdr = sshdr,
+					.timeout = timeout,
+					.retries = retries }));
 	if (result < 0)
 		return result;
 
@@ -2273,8 +2287,13 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 
 	/* try to eat the UNIT_ATTENTION if there are enough retries */
 	do {
-		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
-					  timeout, 1, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = cmd,
+						.data_dir = DMA_NONE,
+						.sshdr = sshdr,
+						.timeout = timeout,
+						.retries = 1 }));
 		if (sdev->removable && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 5d27f5196de6..58edd5d641f8 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -210,8 +210,14 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
 	scsi_cmd[3] = 0;
 	scsi_cmd[4] = 0x2a;     /* size */
 	scsi_cmd[5] = 0;
-	scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE, result, 0x2a, NULL,
-			 SCSI_TIMEOUT, 3, NULL);
+	scsi_exec_req(((struct scsi_exec_args) {
+				.sdev = sdev,
+				.cmd = scsi_cmd,
+				.data_dir = DMA_FROM_DEVICE,
+				.buf = result,
+				.buf_len = 0x2a,
+				.timeout = SCSI_TIMEOUT,
+				.retries = 3 }));
 }
 
 static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
@@ -674,10 +680,17 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 		memset(inq_result, 0, try_inquiry_len);
 
-		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
-					  inq_result, try_inquiry_len, &sshdr,
-					  HZ / 2 + HZ * scsi_inq_timeout, 3,
-					  &resid);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = inq_result,
+						.buf_len = try_inquiry_len,
+						.sshdr = &sshdr,
+						.timeout = HZ / 2 +
+							HZ * scsi_inq_timeout,
+						.retries = 3,
+						.resid = &resid }));
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
@@ -1477,9 +1490,15 @@ static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags_t bflag
 				"scsi scan: Sending REPORT LUNS to (try %d)\n",
 				retries));
 
-		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
-					  lun_data, length, &sshdr,
-					  SCSI_REPORT_LUNS_TIMEOUT, 3, NULL);
+		result = scsi_exec_req(((struct scsi_exec_args) {
+						.sdev = sdev,
+						.cmd = scsi_cmd,
+						.data_dir = DMA_FROM_DEVICE,
+						.buf = lun_data,
+						.buf_len = length,
+						.sshdr = &sshdr,
+						.timeout = SCSI_REPORT_LUNS_TIMEOUT,
+						.retries = 3 }));
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk (KERN_INFO, sdev,
 				"scsi scan: REPORT LUNS"
-- 
2.25.1

