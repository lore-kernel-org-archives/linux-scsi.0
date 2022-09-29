Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C32C32771
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 02:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiI2C4p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 22:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbiI2C4k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 22:56:40 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE87DE0E6
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 19:56:39 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28T1PmS0006378;
        Thu, 29 Sep 2022 02:54:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=nVadMB7A7ixKHwRjUGDO79r3xZ36lQpOksJp+ejaGp0=;
 b=bLJDOH+goeXOUIbpLsDDG6BDAuz9hqzrVHFz53AJ1NCwkcZlkRDbm98uQEK4gZu/AFEg
 IbMlQWjgO86Atym+YYgsbloqARLCGaueN3nzOxyNsUtAwja6oDIkerSTxUB3lZQeo/zW
 dmLRJRKJJrcyTVjXzQOspGriKGnXS516fdp/P+vNOSo7gfpYekszOim3HHe9+5uNdM/K
 jCLBc0ActQzmSoD1kXbYNEHFJtTGW5FdD5hFD0KKSl/c8DfeSpfzGr/gQe1ro+uY5XJA
 kcV7EQ9LN+S7eQk/VdSJ8VZTDxyB4O1JtM4IZy3dxO8J3kJw9A9I1dkekRAOGBKRe1bW lA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst0ku9m7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SM1ceb039455;
        Thu, 29 Sep 2022 02:54:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprvtcqb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Sep 2022 02:54:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=en3vVqdlt0UiAYWFGIs1AyX4IdmJoVTvxBxoq05UyBIygsjKG0p49UBfU6TKRZ0uXLun9G2+SvnoJXPQL009IQ0V5UEaZ+wtRgnOhAgOjCg36zWYroGcBmOP9BQ1RmrJECeUmMSSqAnKF1GQwZllDZGksAs10988LDNPQQbF2EQ8KCb7DgVUtgQzL/WGtIRWhbQQPF7P0STCkzFX4a2FGhLCmpSoxa9qE+7sdcezPkglbjcsxinXpQ6eApUvvQuHN9D/D7e5sMHqTeCgbAgcqWwRksPgg92NyFQBBgL4Ya+gz8VFE6O/f3J1GBjRQ+FTzKZHklvSBJ0LW0pZ6i1OZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nVadMB7A7ixKHwRjUGDO79r3xZ36lQpOksJp+ejaGp0=;
 b=VuAzjt6teE11tMic6GrsW7fTmecsKb0n2IQF5VApaAdAMhTzm9FOlQ9QU2uvq1GAL6QzzuG29fTsgrmBpIAGPg0LTVPutilRQzqEuC55X9t7g61v/LY51gqzVvgWcQyYluzB0DmcApD/RtLZ61SAb/uJRM8Y+yREXCq9UoUWui3pkaX9k+S2UqebFcZgK3k25vNATOoRg21blUpDLaRJP8AU1XcSpHxOqW/M70LU+/zKRgIIGEe8KjsVL3NOc6wYZMFkCF0O0+HVynzv5P5HjgpCGb+gZqIbfkbz+PFBZ0JQ0wlrhgynlJBFXzxyxfx4EXT6CZuF98gAMVaYZzr8ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVadMB7A7ixKHwRjUGDO79r3xZ36lQpOksJp+ejaGp0=;
 b=BNhrq06Q4tauXmZ6BeUs50lTpaI5bqdQyRPL3Q00llL+t8edpGig0Qk0TOlOB3nRuIr76XAUwUdOGJSA2A5UDW1mLl8DPTVvNj0BkuyBTwUs35QW4TuwznIr9WzCLltdxuOllUHhrdiT1Sf5ubz0xw27d74t3InQU3vdEvfkeRQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SN4PR10MB5653.namprd10.prod.outlook.com (2603:10b6:806:20c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.19; Thu, 29 Sep 2022 02:54:20 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Thu, 29 Sep 2022
 02:54:20 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 05/35] scsi: libata: Convert to scsi_exec_req
Date:   Wed, 28 Sep 2022 21:53:37 -0500
Message-Id: <20220929025407.119804-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220929025407.119804-1-michael.christie@oracle.com>
References: <20220929025407.119804-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0020.namprd20.prod.outlook.com
 (2603:10b6:610:58::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SN4PR10MB5653:EE_
X-MS-Office365-Filtering-Correlation-Id: 98eed89a-4dd2-4727-b633-08daa1c5e804
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pK4GL7ylZM9bMDuJpjRPuqsR+nm17N5Ba4MFxm9sUimZpsOUmh+WRigX8TOA/LfWK1QR2H9POEPz1WjrNu3+TLKrJisoXRKt5PFc4aVFLr7D9ec/aVx9sEg4cV0plcP698D55SjoYJIpDelytGNlnaQVI3HMD6XXU344pnmGXbEDMl/mIwVG/cJzguKlSPvngXbnQYxAEXBWf0regUzYxIOG1ejxg+D4U50zbzpqD6xYDNztX8HJD+IhJ4KZCRTl02ZiYL2am4uq7nL2BRAWbxthcsVEku2o2MUJKo2RPTAp6Je6MPA35I2X/xKwatKmsRxoG/RquzhWEZMI2RpNkBrHwAD57dyKtyg4ZEKQwUL1m9OkPjXY4ywTLGZ6RzpReCXQE12W/1NQS9VnGIdhOj8LyLiquZ2wAZNaMsBS1mREHoRsrVuGRurljrsSPz2PG+hF20LQq45eWCaxqRzWY96DpZfXU8eCDXrwUPHoe7FfTrxTu4sRYY7VjrE46MI7KtNS/dTismRqbwSRIRCHFaDeeuoo8mJLK60c7SacOrLtuUacHutWG4hNne60B4vclUWTDGeSHr++Y4LYIP2JEmzda/GIunCk/wi0hhWMvJj2Nfi7dyhE8n65lokTzWiDRz0JRx+ZJYVk/vWfmpMLtaAHB57RVMxoMrkiLJWQ7ZBVJoKuXfJ5FGl2dMeSn7/MaV/8h1+KKm5am+XE7Q+Fqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(66476007)(26005)(6512007)(1076003)(186003)(2616005)(36756003)(478600001)(6506007)(38100700002)(316002)(83380400001)(2906002)(6486002)(6666004)(107886003)(8936002)(5660300002)(66556008)(4326008)(8676002)(66946007)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?snmE4XbKT56wTp4Kpji6qQLzi/lwFPk5IxEZOO80rEoDfeesamaFvK1ZKfbe?=
 =?us-ascii?Q?eknN6K5uIlbrBYKf03U7j2AyqmZ+tlx8nP/31q8SKe8BLpnRsu1k0+utijON?=
 =?us-ascii?Q?gILLAbEuYo64Ik/4z2bbhzBbIIoDck96cNZcGpWkVIsY9snjTxbQe97ZXTUk?=
 =?us-ascii?Q?tQraiMogvMUX1y4TNTOUErqjonJyII76ya/ft0jiRiw2BWAvgqxx+BjSRq7h?=
 =?us-ascii?Q?sil2DeIP3Mxq11zRAfH5HxY6uIo3i+QpqW7UMqvupPlq82CYHPbPpVy73061?=
 =?us-ascii?Q?w/3lYJZqU1E3/FcQf+MbRszcUnbyU7/Rq639bzBcpehJU+okmXlHDmMWn98L?=
 =?us-ascii?Q?P17tvgT14xTFafTINZag0qQMKaR9ALWONS73gMqFaO1BvhIP2FVF4CWVtSK9?=
 =?us-ascii?Q?D8GJ2EJPG/3Ez0j3ZhogCc75PAwbNNxaWQmZAH79iP8zKBDxiB31vhMpTKWA?=
 =?us-ascii?Q?c39F9ukOzOADtOvrO803Phekxs03Jf4/iNDWy7deGsF44us3WLk7ElA01GzF?=
 =?us-ascii?Q?Z0Nq3BuCC2UmxzB8A3+yBzi5eZ9YY6Nq9ygrJDmexs9LhQkO1PyEDrU8n+CX?=
 =?us-ascii?Q?By+cYpeCyoQxir759xB8dtYUsPNkt7YxSkw4/ZnRIY7a0kw6XtwDvlFZRGlM?=
 =?us-ascii?Q?RlIV3uxEteKO2E9+6B4SCKFFMqlGsz6hxKqa+uupP0GOBlh4Iow6oOZVYtIu?=
 =?us-ascii?Q?bA/O24mgUrBrGvWlYqeJfONZ34JijvoYBE7FFguMFqssqQVpR+bh9Y7JG287?=
 =?us-ascii?Q?lzzNBZlvATfES2kprdBxXpKy2rzQGKpc2mEzcFPoKCPSkBxSJNaxAJbYs3d6?=
 =?us-ascii?Q?QOUEjsV5RhUzggNOQs+bH5kLk3vwjk5XRXzarsTfkvwVM+K4muawVE7a03tb?=
 =?us-ascii?Q?Z8urJB0qEu3E5LmjnE+W/Bw5Bxdv30IB91YDk+oNQr/sD4ulT/i29H25PNSg?=
 =?us-ascii?Q?c/hC7SN5V+zrpX/fnhXNO50H4TH2hLqnTfQEnNxGMyN+oCxXEYXZfyLo5YdY?=
 =?us-ascii?Q?f6hoP6qJXu0Sa21/jg5107HMP76mqemEEX7w3/CXvJunnBiTyPU9W5BUOFn+?=
 =?us-ascii?Q?9kBFpIsNwHbJCe3onBYfTjzGBuTCrqAYUeNgTvVH89Ridk2JNyCXbfLFyzU8?=
 =?us-ascii?Q?jmb9x7CZpicD7espDnjcPLpQg8e2YtJd6+QAOpdQdWhG0IdoCHlGufXpU4ou?=
 =?us-ascii?Q?HOTppQB1F9218TFutWmNCL16ggDjSXepmdRwWQxD1j6+0Ommjw/s55faSwLV?=
 =?us-ascii?Q?CdtM8B12/PbfO7CbWWEanKPl6CcZmDFjHebYK/nZNJoVdyES67Gp/XbBDEsp?=
 =?us-ascii?Q?rQiOUAhDdRRUgkI9+4zgm5PwNCj/8pE2Fp7d69KIG9HeRRGjxoRvhLQUKhlG?=
 =?us-ascii?Q?nJzYIh0kpMp+BuazumHZgzn5ApFuZljAekellkzjsz5SdBkhe3cwjgSvM1It?=
 =?us-ascii?Q?1dlefJSguGBUiE5HjL+bq/7o81t/u69OxbiWKidCLXTirAIR30yxx5HFM0qy?=
 =?us-ascii?Q?e8klsknnbVzoD2ZZRltGNHXn/NAph+OqD5eMXKLsX7B1o9jarOKtg0mDsdl8?=
 =?us-ascii?Q?5FD1wzS5yFGJH9X9WqdiflvQNiou76pPLaAjdyrpoNapYdjKK/KrNs0m2RDp?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98eed89a-4dd2-4727-b633-08daa1c5e804
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 02:54:20.0692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pddIXsws37PBITqp+NnYhNEoeYE9W54I7Otetj924Gd20xlSv2m6dODqcE7Rk12RXpsGaETDnLr5SkbS3u7nTRQIlpl82mvf+Z9TDR0+R4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_02,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290017
X-Proofpoint-GUID: Ai2zOxx2YyuGF7Vg_9RqIwoy_dZZBRKN
X-Proofpoint-ORIG-GUID: Ai2zOxx2YyuGF7Vg_9RqIwoy_dZZBRKN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert libata to scsi_exec_req so
we pass all args in a scsi_exec_args struct.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/ata/libata-scsi.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 29e2f55c6faa..484eed985db6 100644
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

