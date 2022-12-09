Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1484C4167B
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiLIGQN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiLIGQA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:16:00 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41B6A431F
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:15:59 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B94VXMq023754;
        Fri, 9 Dec 2022 06:13:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=AQFjWA/Y12vls0B9lqvjsWA+TXcRJujOFD5cMoLX9oo=;
 b=PawByA/pwfG6Bdba5aZ6r5SBDEVqbg/iS6PIDIJyv9qx6pHzQnCN21yI9JYmxJn6kJlA
 P1zC75N1CUkiXtMtv1bypy0Fq3VSjImY7Lix7TU35p7CszKUiv80/kyeZ4KDF9jeNKbv
 H06+31Ain2156qKrOYQC1+VoI6FK6vdPQ4E5ZiU6IYRPnA4v9wJkHRNOHw8eKqLS+G1f
 6VdxbkYCNW0wRGnOHQez80sm6u5GDmtJcPB/FDSgvMvV/s6/OjpnpLz4XmkT1fqrA2eZ
 02veyyK51bKY4DsJnSionHZEaQqbsnxoz1Zg4ItnL9j8mDpbkQNU04KNn+rlmUOTl0Cb Dg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maujkmb8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B9657Wp008402;
        Fri, 9 Dec 2022 06:13:52 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa61ymtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRifMB9IedQ/mZ+aO38LgJIdanDBD4Ar/2Ndp6kEljTBuCfmlMioboG4o46bBf2mDKyMFNHrl4i83pxRmGfkp2dPTnSj1yHnk9r0vkLi8IjSDWWdF20AaBpC12QcL+odvTxBCD3Fyn1f8EbRI77e36n5StKTcQHrPtvLTc1wB5oTCUszveBi9+npXKgzr+Z0z/7fjW+iocblS62gLCx6KOOtMCWuLYW8IXXY1OmfxCEfqfL14OPn1hu7vrAIuxNFez/ayAgZN32zNvTLLtPhYCj0h9dTqEpGk/wRmiMV0r/kJjfaFNUf8BmZ1G85E/5/raqkwbBbsvxKkswrKWDxVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AQFjWA/Y12vls0B9lqvjsWA+TXcRJujOFD5cMoLX9oo=;
 b=nwIJFrocDo7FF9h/WiKalSuioASdkeMxmsddJ3+nz0L5lm6K56eoFBEYogsvmZrGFWT0iDUDHwSNmOziiNgMs0e//KYXUbcx44S4UlaBPUcoTsxx00pckA3CHczimmlL2RBeDqNt3WyxHn0sedqx9HOsLgwdGy6Rm+E7qOAz9ZrPQaXjEdoJlGHBvo6hG/l1g8HBk8+avVg62x6L604YtFg+rKqu1ea9EkN9hxm4gHhDRNPI/VVo9t9ozBoYdZazrZmjDcplvawkZf/k/LsW1DAEBXmdH+YjY+CyTCdFzR07VVg8nLcEEA/pSCvh89pVdE3SdmqSDHPrZL+8puBpCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AQFjWA/Y12vls0B9lqvjsWA+TXcRJujOFD5cMoLX9oo=;
 b=E9YkYhi7UPgiWAk96Y5paO6COiSBVz850w2GHFJatKiDSRrZ4xWwEYSxYW6F//zaSO+YNz/tYmjJM9AkNOUGMwoR1Dn7C2ErtxRgGS9QUESOmFAgYf+wmcvhSeZ3ctkSGGYubrLUSvAUe09f8HgulvhE8G6gUJHkbNhKx2BxAms=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:13:50 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:13:50 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 11/15] scsi: sr: Convert to scsi_execute_args/cmd
Date:   Fri,  9 Dec 2022 00:13:21 -0600
Message-Id: <20221209061325.705999-12-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209061325.705999-1-michael.christie@oracle.com>
References: <20221209061325.705999-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0051.namprd04.prod.outlook.com
 (2603:10b6:610:77::26) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: 852b83d0-a1c9-4628-43aa-08dad9ac8a60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sfDEIDWgfYTi40sNM3zM6da9TZYIdNOhLpaCLR4pOJfXBkgCLdmNLELhIMIAPNaHE/0OvCu9jTdAkIY8l4+Jd4CnmF3iOiEQn4HT9hGP+XKuZBs+uAJIFDmxolr245dCtPypHn1Au5NjeObp2lqLub3mNNIJQOpQ+HBVWCxwNtja4mJ8CkUbP8YE66NWhKOPsI9A9a2r8YDmNKfVEzQ+dWxxlqc3RkOoMUTMM9Iw1qTDJYiqHt9QQVbBPtuRuCNX9qZWD1rUUncBIr8bJbtQMmuPXRWO7Xhynk8eNi21KSpsACfKPBgJc1yjS40E2dVKIeFGaBhAGbLbjdIoSS+SZ+1dVUjTglQKhJ8pH10m3zckQS96uNHs8Qn5P3siE51+mZQo5Lbj53e6hEVr8526M/MrdNNIvEqwwFhcY1vrFQfHbJq3h3Ya9ltj1Ih/2D7IXm/RlERP6ooOTyouf3L9OCz8WBBDpug7DeHuGdhLQOo5iboh8IM7PrW5U07HLHwLxwqA/jmDWs1uEUSOdE2mek5Vo+bgUQwmEkYftXsMFG+YKmPrkYMQOEaVDTEAofTEI0vfHvlsrJShT16BnvFOIg8sQWPPxtd3FVLy8CLOXv0VMaNfsmNqcHhm7RrW/51IVsYtnMCLJ8i5wdGQSwixmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(107886003)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DqshLlaxwQK0SdCVtD75ckp5C5OxX2b3sLReU+g9kTAmtNr7MgN8SPlFcfzp?=
 =?us-ascii?Q?dqavjF28M/TRhhtT9h0CFxDxyhX9eKNzv3UvbxHVox2rXa3RrgRiQv1J1bW1?=
 =?us-ascii?Q?NegIzWMw3zrllZKilDmeHgiwyjigfoBysC9ohyvWSXaPP/L24y106o4vaDVz?=
 =?us-ascii?Q?uifMk0Z0DmhpoC/+VgUagpkOAQ3Y6uKWVrNmplkvE4adaBj9wjHhmQUZmzn+?=
 =?us-ascii?Q?7BqXPPTItY746RJ+yvAp3lWY0mI2lXlZR7AzkJlhc683K9LKXSBN4aSzukxT?=
 =?us-ascii?Q?7whxr8rPC8QZuzwu9DhrQ2jHQN0FXiK+PmE+cilUKqxoPYoOkcJKPT3Jj6DS?=
 =?us-ascii?Q?WJVbRi7SMyRFkVB0gORYfv7l2pKEFmoQ7DbLFAfQC1MdGoYZjKjVBI+DZqu4?=
 =?us-ascii?Q?4gkjQIKwA/d2GsLDG34GNOd0DrYjNy0KmPEz7Yzj6p76IGj+CUo4T6N1CZOP?=
 =?us-ascii?Q?fpSomGff5vaL2WDCfTMDgHUuqY0aSeHmDGWxbQT9oK08ZwqCW+IZ+bc86EEo?=
 =?us-ascii?Q?vKupmfiMaf8BqNdJmo8lH9A88CktkwaCGpVpIP7AfCexi9P0C/UoHJB0awSS?=
 =?us-ascii?Q?8+gXc9wV5RgLK9yUmmWHai+3758fS2ZlYxCTbZDwti5OeswwdozikQaiyOF0?=
 =?us-ascii?Q?YrsXhC0E6MeNzLJzKQd2mPN1FGO7rZTapwFNEqcLUPz9ZkXliOB5QzF1G4hL?=
 =?us-ascii?Q?fHwvDYRvhyt9OSbv2UrHG9cNUjzd1owWJXic7WP3rpn+E/rf5u3hifKeaKOq?=
 =?us-ascii?Q?PAysSn85KCOcagN6tNenvBfGu3hQ8GzIpk81mTQHIqQ6NK7jJwVWQDZeTn4Z?=
 =?us-ascii?Q?RAdPZzQEGVCvokqf+XCao4iDMkMYuvkdWZ7/Lev7rvPARiezk9O5XQUZAAEx?=
 =?us-ascii?Q?0D7uqqQzpAlWK7ppQBIsP/y0o92wROLFxyykCfCGsDZF39KqcEIv9TimWTi1?=
 =?us-ascii?Q?wb7pDhDmNBC71rnlsqZ/kopTJjHalsHfss+kZ/ISSmhf4lebA4DUVFXjX5h+?=
 =?us-ascii?Q?MNrvGTaIAOpgBw8E23niOBh+CYC/BAEYGJBh+b8xMo+Ycx4PaxD3ydz9xwyM?=
 =?us-ascii?Q?wxU1q825N5hNncPaCg9nAnpxnOEgD1ioQ7MzFDDeSo/KquWR332bBfCaewR+?=
 =?us-ascii?Q?XCNcEKFgvz7HBIl2uSfL+oSeIeAsYof57Xcov2mCiLDgz8lxFgBk8LWIrzbM?=
 =?us-ascii?Q?JT4klXi7G3yZKze/JII1ZQws+HMXV1wINs+BIjEiRKuncyOY5poyMLo130Wo?=
 =?us-ascii?Q?MhzXrfG6rp2XW+EGsZnqb7fIsOs+KZ2SxQbopXeazPyf/vrgmm3qKnsdeyMP?=
 =?us-ascii?Q?pAwFU7IkKGCH5LJ9WV0ahAlqHsv/CO8qXfU6Y9cWpeQkuxDvJ+BwEqtqvC6Z?=
 =?us-ascii?Q?gJepSzABp8noYasU6cQ9qezuUrgDwzpue0OMk7Wd4RzLsYjy/ay227qw8H9l?=
 =?us-ascii?Q?+DGvMJjpcWt8b1WC58CfyJUjoFqUzl8QhxletiB+qu4g4eC9ta2vqtrcptM8?=
 =?us-ascii?Q?0SfRwVDLYp6/ot8GpGm3GR65v64brhjLXj+mFxNh8i+QlRIfTNW5QFaAEyHI?=
 =?us-ascii?Q?7pVUYDMbbZdoAKxP0Od6dr7arbqmP33dhLbm5q/qNQv32dL5qJr/ufeeoX80?=
 =?us-ascii?Q?BQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 852b83d0-a1c9-4628-43aa-08dad9ac8a60
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:50.7232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y/4XUfXl2Y2l92ixCNS6mqCwkVAyBOU2YS+/gbmbAp2PSWFvFfRMmtRQMfMWDGLJb3I71Brm9iCqqWZZWPJzv/QnX04wGFMPrqJn3CR7HLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090053
X-Proofpoint-ORIG-GUID: AbY0zVpo5XukGfBe1KpN_jxDahdMHFya
X-Proofpoint-GUID: AbY0zVpo5XukGfBe1KpN_jxDahdMHFya
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute* is going to be removed. Convert sr to scsi_execute_args/cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sr.c       | 13 ++++++++-----
 drivers/scsi/sr_ioctl.c | 11 +++++++----
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a278b739d0c5..bcaf0701c120 100644
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
+	result = scsi_execute_args(sdev, cmd, REQ_OP_DRV_IN, buf, sizeof(buf),
+				   SR_TIMEOUT, MAX_RETRIES, exec_args);
 	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
 		return DISK_EVENT_MEDIA_CHANGE;
 
@@ -730,9 +733,9 @@ static void get_sectorsize(struct scsi_cd *cd)
 		memset(buffer, 0, sizeof(buffer));
 
 		/* Do the command and wait.. */
-		the_result = scsi_execute_req(cd->device, cmd, DMA_FROM_DEVICE,
-					      buffer, sizeof(buffer), NULL,
-					      SR_TIMEOUT, MAX_RETRIES, NULL);
+		the_result = scsi_execute_cmd(cd->device, cmd, REQ_OP_DRV_IN,
+					      buffer, sizeof(buffer),
+					      SR_TIMEOUT, MAX_RETRIES);
 
 		retries--;
 
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index fbdb5124d7f7..3d65c4eb70a4 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -190,11 +190,13 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 	struct scsi_device *SDev;
 	struct scsi_sense_hdr local_sshdr, *sshdr = &local_sshdr;
 	int result, err = 0, retries = 0;
+	struct scsi_exec_args exec_args = {};
 
 	SDev = cd->device;
 
 	if (cgc->sshdr)
 		sshdr = cgc->sshdr;
+	exec_args.sshdr = sshdr;
 
       retry:
 	if (!scsi_block_when_processing_errors(SDev)) {
@@ -202,10 +204,11 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 		goto out;
 	}
 
-	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
-			      cgc->buffer, cgc->buflen, NULL, sshdr,
-			      cgc->timeout, IOCTL_RETRIES, 0, 0, NULL);
-
+	result = scsi_execute_args(SDev, cgc->cmd,
+				   cgc->data_direction == DMA_TO_DEVICE ?
+				   REQ_OP_DRV_OUT : REQ_OP_DRV_IN, cgc->buffer,
+				   cgc->buflen, cgc->timeout, IOCTL_RETRIES,
+				   exec_args);
 	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
 	if (result < 0) {
 		err = result;
-- 
2.25.1

