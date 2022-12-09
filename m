Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 216A0C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 06:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiLIGOZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 01:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiLIGOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 01:14:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E96C9D2FD
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 22:13:57 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B94VNMW010492;
        Fri, 9 Dec 2022 06:13:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Kqo/c/FavKW89TINXx92/bxcE1yI27TngkykaycrckE=;
 b=snhk2Gghx2+6V+y9Izog1HocY6wFD/O4wN6qwcLwPK8QlQlF7m/sdUfB098wkRXyZrH3
 MXn0Rqr0DX/2rgVYIRj2KdMCvapBj//hIiWKv3pHwtOJag8NFfbpucoPg7L5BXYkNdrK
 E9jgQi/KV3xOB8fc7JcrDF3QBfEbdAn47TSaeeEytaobZpcWusqJw7kOTdxFIvt3x4PC
 6ML1pzoLnEXoPuKl7cHAVTVlQd25WcaUYireXLOBSTleFabo5RQu3tXsLeGXRbF3UJvq
 1w40pXu7tYBct2iTdKALKYz6nmye7BhyNQoggG0jyn137MRto1dTSu58RGA5yFqIVUBb dg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauduvcph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:49 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B93K3f8008472;
        Fri, 9 Dec 2022 06:13:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa61ymrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 06:13:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5baIM/WQBLZukcWT7LmCWfyxap85hdNy2P3rihPcUtazAhcqdGPyJkD4sx3a6QfCnZrDdCU9jWTik4grlRpQlI04hHrqBRXpaS19jJZaleJBzPUYbTE8Z3NUPPMJ00Zkjp705A2SqRfbsRt6egcLzoexUapEYy4Ga6cofHna+6f0XLgLGKGB43ZOtalQxVPWiidlodnLSWe9wqiLshcJCfXYEd4UeMP8jjDhnSl/Wx+OP+GFnroMNJiXfEAtnQKT1/qgnJ4NAPB6mKxht4x9+MRQql7hboJSXWGwh5ziyPCETYThJw7ScpObtSf8Q4bvgQbfwazfn+vy59A5A6x4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kqo/c/FavKW89TINXx92/bxcE1yI27TngkykaycrckE=;
 b=lscGsTURhZjU73aeOqfh4XNV0pRKMzw23WQUy0pYpSeVJbipQWr/ydfn4q06ESVXNmYLjV85xquhBgptBycWMzuE6Rvod/aPwp2zEjHk4AmxqVZSt3A5alTgm7urhyp1vYsRw3A81bNYU1oXvsiHy1U741tZF+3AbFHKJbm5HccpQwJ4Cgyey5kJcUPsvVe3wmjwjdixUOlL/tAUu6iWldPNxCmBVA2Taq5XLlZnnFOvwkMkhnNm15AFws5KqvcVrnNWawChs9DGc1fLlO7P8q+ESCdFfDPxXysGSg3CjxAsMTYNMazV6Cb7FNyGoBk/bkUKeWuONy1bl71wxEbgfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kqo/c/FavKW89TINXx92/bxcE1yI27TngkykaycrckE=;
 b=lK/QgN1kC+J66d+kvY2nrE+iTfSHat1YuyL1HFL7ja5VFsccaDYFiP2g0nz9yCQ9cxRMPwHeXc85J/LEKSVVvclK1LIWQN2AoWK+bBmYAiUI3vZF6nzW6XxuvVCYPgBosj3Xz3+ncqbnHRVlDm/lzQqEcnpRhX8pDZoUuJ+o0Rc=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by CH0PR10MB5066.namprd10.prod.outlook.com (2603:10b6:610:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 06:13:47 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::a99a:a833:4f4c:9e99%6]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 06:13:47 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 09/15] scsi: zbc: Convert to scsi_execute_args
Date:   Fri,  9 Dec 2022 00:13:19 -0600
Message-Id: <20221209061325.705999-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209061325.705999-1-michael.christie@oracle.com>
References: <20221209061325.705999-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR04CA0044.namprd04.prod.outlook.com
 (2603:10b6:610:77::19) To CY4PR10MB1463.namprd10.prod.outlook.com
 (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PR10MB1463:EE_|CH0PR10MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: 653f3f1b-a670-4461-5476-08dad9ac883e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Rw7W99gmPwKTC6e17NLTrinuJUrNpUIjcwhkE5uu8loCRX3KUS9//EuSVl7BEipOiUUnhPzuUfWGeYL9VwkT6NKY9n9MT16F0aFh9CUYK6wxJ4nuZI36HEYcjiDUq7YDnsC5gnlZJAyU166YN78ksOjougYB4RqARA7rvhbv5BxDairWTO+dYj+lAm1PeR58n3hsCYcnUskFfHxCt+dx2Dz3MzRahQb78LPYnAAIy376x2/mV/eIN85y2kcrv1L3Cgi3dZzOlwGNq+ERvWNDuIyB//RkMP2wNU7sq0btCGDANtoin+G/YaJujx9Ad6BTrQc3pUHuCjriWiObAsmcIfqRdC7/mfLPOUv7CiB0tfYR3h8Qn6iT92xA/Nc03z8NF1RlV7K9qMI819JKNK7qFkChpVXsv+++I/b8CKBZ8iLMyOQQ6wVIOFp/p4b3SK95M8MuYnCAMbb5/VjUW15jVxqvH3uBJNgaJMu9dRopeGTBl16Up+armoGUnfkGwjYtyz/KzPUnFVhz93r0/D3OLjIMr2H3TFAq1k9xO5OM5YDOGFkusYE5q4nCTvvG3CKMpdwyxaHJX9LNi5Un3SPFJ+dR0M2Da4XXzPhNrLzrMgpseUg6aBQKG7CwoNI0i8Va5/NvPjYzJTvQ/Q2MBTpqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199015)(478600001)(6512007)(26005)(2906002)(36756003)(6506007)(6666004)(107886003)(41300700001)(86362001)(8676002)(66556008)(66946007)(66476007)(4326008)(316002)(5660300002)(38100700002)(8936002)(6486002)(2616005)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?16JgnBAqeykidzDk0D617sPquClwVbun+5BVadSuiuZFRUfdQZRuxE7KcRxR?=
 =?us-ascii?Q?O+k57ym+7wH1UmiZy8LtQzj2GlRw5Ii0iCsodE8PD1Vi0SgivXTJALk45Iea?=
 =?us-ascii?Q?QFP/oSuqLLlqWHstC+RdNNfc2+G5ahHQFootTIZ4Uis3OfmBxCiKhv+qU4AA?=
 =?us-ascii?Q?YUdm9NU/bJjrUvJBQuMr/Jd6+1S4PwnEepjrBNybCp9Kgz9+cgR4N5o8Plbd?=
 =?us-ascii?Q?C5ZgP0ZFgOPMl5ip1/sMq+Msjpw9GthhjOSR6Iya/RfiPlPpplaAP1U518BZ?=
 =?us-ascii?Q?PTY2t0pJW0w/3RIEzqHb2diBeRNP5Vn+dX4k4vJ5den4fzjVSmGeN6ZMRJcz?=
 =?us-ascii?Q?stSfviG7r2u6Akg+xhhqLLdAnN/gjfGqE0E0FIGvjAXKyhfscYLLBgu/vf3f?=
 =?us-ascii?Q?9BMVi0bl6gOy2piTzodQcn4ALrxzdgwVPjonjLi5xux4zeRQMm08Muotwphf?=
 =?us-ascii?Q?FZO+UnS2xR65wD1Mon66xsAin2R5+DjQJiO/nX6TFh3S29aJJwRYW0lgkfYA?=
 =?us-ascii?Q?0Dln0WxKbM0nErbsCT0XdWqdPihTSstqkBN2skeFEH25riRZrZft/j7pXctr?=
 =?us-ascii?Q?0clbbNc82Pqja1jHnzP3RvdoWI1nyGSkCQuLTdbB9juhK7+d1cgSMFED+DkX?=
 =?us-ascii?Q?jVITNNntiK/g6TUwL/QWOCEY/6ObL2dfQJu1MRevg0IBPUJy9I0XGbJLzt7B?=
 =?us-ascii?Q?Y0XGw5J6Q800izznU5SaZzFZjeUhDL8hJmz2n5B4tcWDMcoKGJkW4U+b1hpo?=
 =?us-ascii?Q?+MF5BZp71SX/wT8R1RJMoehTJrQGew1G3Yj5qarMRI5LpFLXrhF5ctrvZX9x?=
 =?us-ascii?Q?zvt80RCUzBItJN4fqm8gMmTQibGqY90EGl3UWR31GOXa12E4fbwS5k9y0Fgy?=
 =?us-ascii?Q?QndCbDcSbiM3M2aRlfKUZ+AW51VXZ512Q1kuTppSdi114gWZ1S2IiEOcOxki?=
 =?us-ascii?Q?P0m/Oxoct6gAb1ezg2hzkpKW8V/6K+Y+lGXuZMCyaoi9wv987pM3jcWIexxx?=
 =?us-ascii?Q?MrZ3h23FOt+DeECQokJHqbPggplv5I6i5apnUU1Noy+aqYL3vYrNVVfrnN2H?=
 =?us-ascii?Q?jfPDuDk4vJK3HkQt4ClSUxwoczLz6Ij+BrzYvgXBLi20b9ttjwaT2bCXbE72?=
 =?us-ascii?Q?3X9HVQYHX1Dz9mvHc+ziPPUC1VtEUVVN+DnWNMmRLtSLXvTgA3PYaiekvwk/?=
 =?us-ascii?Q?pWObBea07RJAttI6o68tfJXLrVJkqOk2GdAmOqq+K45kWAZJMKCj3T38HD50?=
 =?us-ascii?Q?pcFiyxTBWcalVnYH6nuQkBfk+TQUE9AAXY8+cdcToYbmIi7NL0omnUQ4h9gI?=
 =?us-ascii?Q?BXbbCfsi/sBEYe0wW9IYawMFfjkZL93iKSzG+sHi4rkZwlKSJii0XgwudUs0?=
 =?us-ascii?Q?QGg7+mkr28IiCdsHwS7gRKbFd9zFu9+10SZ9IcmlO6nnJpJ6kTJx3QI1S6nH?=
 =?us-ascii?Q?MtDySDT5FOwXh/QL7EsHn6rngaznM7nNjsxDlMK/rFlBBMplMBJrBUOaSb4d?=
 =?us-ascii?Q?ZUwtuchfZeKxvUmuA4n0wDDD2xMWqzs23Nck0qQlqnYJR+6v2Zic4RIZL8Q2?=
 =?us-ascii?Q?us+GK0c0s2JD48fVUbRzJE5gYZ7AmZOu47nFqbFQ7lYvlfvJm70Wkp65Lpau?=
 =?us-ascii?Q?kw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 653f3f1b-a670-4461-5476-08dad9ac883e
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 06:13:47.1766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JqkFsi9QXQ9cqTbaAMq44kyLPXk2R0uwx+W3pqxxrcRNI10D2U3Sp8IJJz0ChJeXaZjHBjf3KFgn+GjbS+b0wRGWhwLoLfZngi0YkuztKfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_02,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090053
X-Proofpoint-ORIG-GUID: jN9bbEPr9JgkUDIa8xxzWF8-u4cS_eNJ
X-Proofpoint-GUID: jN9bbEPr9JgkUDIa8xxzWF8-u4cS_eNJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Conver zbc to scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd_zbc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 62abebbaf2e7..2a7c352343be 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -148,6 +148,9 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	unsigned char cmd[16];
 	unsigned int rep_len;
 	int result;
@@ -160,9 +163,8 @@ static int sd_zbc_do_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	if (partial)
 		cmd[14] = ZBC_REPORT_ZONE_PARTIAL;
 
-	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-				  buf, buflen, &sshdr,
-				  timeout, SD_MAX_RETRIES, NULL);
+	result = scsi_execute_args(sdp, cmd, REQ_OP_DRV_IN, buf, buflen,
+				   timeout, SD_MAX_RETRIES, exec_args);
 	if (result) {
 		sd_printk(KERN_ERR, sdkp,
 			  "REPORT ZONES start lba %llu failed\n", lba);
-- 
2.25.1

