Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F391C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Dec 2022 19:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiL2TCn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Dec 2022 14:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbiL2TCR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2022 14:02:17 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55240D9A
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2022 11:02:15 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BTIxEB6002266;
        Thu, 29 Dec 2022 19:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=VODJsb1JedxyYEAFoiUMHndz89Wm1ZP2qfulPNupDUw=;
 b=VgI73wLcQPPnCrEyt5mDaBvImLly3UToAmggFINbW8j5+4JtgDXmU1vijrvInzKhUYn8
 t2eVbPfOQFUvksTlnBoWHeT5ssNAb4JXIXjRaz/QckkXTfihfWWl46BSn0beJYKBALpL
 gUWxkyCgeJ5tG66IMn9QXuDb0IzolsdfsUs1tJsjiaeeBVdUaLookc63pCe28727AuTW
 Uw5+w/VlzUNBbL6lruv/FSL1zhtc5H6TZ+D7w+ixYsWJ0KjIb4glnWzkspyAzaSiXSNz
 WF5xPdrGwOzJEl/yj6UjtP96PGVYQ+tgrKBnXUG5UzH70KqhpIdOAqc4IBeKL+bOtQEp lA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnsfcfa84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BTGRg96034219;
        Thu, 29 Dec 2022 19:02:03 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2045.outbound.protection.outlook.com [104.47.51.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv6s0g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Dec 2022 19:02:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drtK1RrvE/QpmLQh3NSqod+mxzyXKCcwaBPNIGahcWk9LoCdTDTJKhhKzDynbWJ9fgZz2ibNEHsttuSVIGU1IRfiVtaVEelZ1J/mLK6PnSNoDFbK2oBuu9HfWKjumqBGr4ZFrp5onoudjbkr1EGFlUPT2cXXmGcy5HMuukTLy/6skW1if/TzwJtZ6Q06vNRWNPCG/VvYo0HIdW5WgWzY4ZYesT8gWJu2+MA08JOjTnfFElerjNtOCEwGKByqUx72bQvPIoZkOpqKdtKwJA3b5SzUYLPBpxe5RNJQf0zgvF8xRfvGmE1qI6CutzZhNV3ZZE/mJHItlleXXl7wdqzBYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VODJsb1JedxyYEAFoiUMHndz89Wm1ZP2qfulPNupDUw=;
 b=J4BmMT+b8EKTujwx8NW9Ofj+GiTPSSHKGQiZL1UVqycB+/ZxL1CaTXRmK2+griIvds0LuoK7dcjW0rSQSfZ0WQ8NSZ0kJb6fj1CTB1Hq5PSi1te5JKQsDL63gWnizwTPU7VXOFyKj3Q2kQO4MD0K+xCwXX+T2yfp6pmSo8Z+JsHQCcADxleFYo/Kfvcw77p/MLSGyw36uOLuqY6/XIFLwzABqgiSbIOqTZgftxJGaI9tPtRSsCcdFCHJhNsecjzq/HpzCXbUVQYDyneiOO7leAZD8ZIvL9S6z35sJ2EczONk1Y1IIUDHh4r3cJD+drMqYTLhsltdm5SI/ofs0Mjmpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VODJsb1JedxyYEAFoiUMHndz89Wm1ZP2qfulPNupDUw=;
 b=oGglKUm3Rwo8y6zy5PzAIkvbcmr2/RwtICNuUeZ4Nm0CBhTgHDzF2K/FiybjJGKOv8wydEE7iwlA4hyw/RAJeCQS5Mr5Chd9VYfLskQNXy0lkrJ1Zacoz+OlCdKlZK/BmyQ/mk1sj5nVYlBvI+QShKmEUybOoDMSTKAb83BJaRM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 19:02:01 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.5944.016; Thu, 29 Dec 2022
 19:02:01 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH v4 02/15] ata: libata-scsi: Convert to scsi_execute_cmd
Date:   Thu, 29 Dec 2022 13:01:41 -0600
Message-Id: <20221229190154.7467-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
References: <20221229190154.7467-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0420.namprd03.prod.outlook.com
 (2603:10b6:610:11b::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f065e24-7571-4ffb-220b-08dae9cf2a9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zERJBVzM2eMg9bZryEDaKjZie8LgdjbNI5tbjEijOekUt54sefj6t0b4T/NzLG6MMo4XUHm6oO9ObX/nt+L1mU250wqf4g1AJRWKb4oJj4dT0BeFNZrhOQkMeHmZ0X/RRW/g0odaQktg5mtJvSyD88kPcICEOUCpKLr5rxSLuGB4NOSIA1rzvTx1eFO02Ln5w/QG9j1s1wACRqLFEqMpmi5BcM324YzhLEwjqdz2wD/RKObm5Q6ANXMAI2b89h/VRi/oVlS8azx+scewo+YGdpNCTFxcLHn0Q1RvACp/ASIyRfyh2pz0Jh4Y5F0SBHNkx1dSTh01f0XtaH+/WowGVLB72tq85Ha0LId9um8QR6ViTnaIZsSXduNYE2QtzlJ0PUhn7L1qNPuqWScoYAih9o/CzKGfr/++YUJJnzxvBd3jpHKRuFAcGUpGqUGyPS4hSn8nRH3RSLR7l7a5yetAUPtk1GkjnhYA4g6OYK/HDg14va9s376R3GgB2IugSnTn7ETw1/GgC8invs4uWoxIEcpQ349OP/SlLDDghOCGwt4akHG4dmQmRlMOlQF6gClLpenBqWI3FNCn12WtUxgXnlJf5CdXrBEh33+essQsbrbxMLfhI/hbqp+bqi0E4E8+RmVDwuT1BHCJqXISkRLOSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199015)(36756003)(2906002)(38100700002)(8936002)(41300700001)(5660300002)(86362001)(83380400001)(66476007)(66556008)(54906003)(66946007)(6666004)(478600001)(6506007)(1076003)(4326008)(316002)(8676002)(6512007)(26005)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OZ8xJxIvh0nGmCq18aDf/z4ZwkUhUUiQxYEr2xwY3M6t1YxM3NyW1kvhZj8z?=
 =?us-ascii?Q?9GkNca/ixVkUzJqlUAlrgyIAcuCmp12yxA3NpaTLmw+MXD3/ikD3CMFqZ+2V?=
 =?us-ascii?Q?JS6+4IuCYw4IBRXWud2YPaaCo0l6ANKwveHHVSnFR5pz1bI02jT9kRuDCGHE?=
 =?us-ascii?Q?kH2yQEd+NKycc82F5SSA1hwuNSG68w3QisA/BpwTkZZ1BsDrJMdOr614566B?=
 =?us-ascii?Q?54BUvnX3t5+0zv7ynWPM4aSMBLzxjpRlyIMIEqC/UMCPRGQpiqS0NwgOrUUH?=
 =?us-ascii?Q?U/sLqBN3qz+R1Opad3Ag9w4zXrIRfsd4hYrTmxygJEtfDGrj+bSz4UxfHHGX?=
 =?us-ascii?Q?TvVPQw/VGErO/wr8+QA/P+YF38xCq1JKJVW82dOgFg52OYzcw9jzZE8M3XE1?=
 =?us-ascii?Q?dNUCnmg8SFfcTfDrwgIFilL3aCAfGxrKu5LrMASw6e2OkRQ75+lnbIJd01bZ?=
 =?us-ascii?Q?ctFdWRViN5P8BMNkmF4Dj7StF0WY7TKIZ/pNgYDGJI7MVKJHCXqsq1EPlEpm?=
 =?us-ascii?Q?I83akTNcJimxFjS7pjbBg9xR0uDcvHfc0iSvLfbQDamkepSaGjO5/QA3uPNU?=
 =?us-ascii?Q?V7y7hpVUrNKJYixF7Zz2gdjCDFCc6XpSqp3llfjRvPyAn/fsoduKaOsKI7d3?=
 =?us-ascii?Q?7bq0FthlVNPVDI+E3mGBmaaKvrNMeeIZnWhWp4T6Yxw/gk8OjJeuqM6T7cwB?=
 =?us-ascii?Q?qZSDSVYX43p/riThO1JKGtuJ/c9nEresYw0qsYFgl2Em/sIOr/rZUgjVSBgu?=
 =?us-ascii?Q?4dRtRerjONjZUAIbxGSDWyjkYuJ+oWgx1qzr4nWZbbhq0nFr0esTUrbF1eBn?=
 =?us-ascii?Q?AatA1ezV8wa8MN1tu38NCZs8opW2eqk2F90BxZJwXtofVohNhYNlYd4XAxRq?=
 =?us-ascii?Q?0sqI/UaroUTMFOXfF6sDPP5dRgjziHzsh2sc2709McFeYuKL+uxLskA6bsRc?=
 =?us-ascii?Q?1TYMeL2vhA21kIMZvZlz5TjJ/XSd6t+ZZlRO8uQm44qQ4LE70UjcoxYlLXVp?=
 =?us-ascii?Q?1OyRg1de6JaPpM5K0g1f8OnfDTE/NyX7aFs7YvFsPeoVgWtA0jxaT+4XHy8S?=
 =?us-ascii?Q?JTwDk6PGhFJjb8d/6VL/vNuCxomglDRHn7ecUKvGcx38vD8/JKZ06ipAvEmV?=
 =?us-ascii?Q?vo4NVql2WZP66JIvKs1peo14ZM0UPuN0hQwtbv5mawilmxlZAFgzRoNSpEV/?=
 =?us-ascii?Q?d1vsOE/hcv8mNmb9EEdYRt+6Eyl+f8StWPcddVyV5jXEMcoEIrYP9lf2ZFuZ?=
 =?us-ascii?Q?idOe3VNqrzWqoNZkVzz1S0YQHrV4jNGqFJbwVwpBQyMdnR3sar1t7BjfbwVI?=
 =?us-ascii?Q?IFGQWHfxcMAntz2bqiX2OVH6gASDnzhvTB7on9yhmhCU16t3j2FSfqBCZdzS?=
 =?us-ascii?Q?j4PkOiPCmqbAOVa0hWP0khPyxFTaMRId1J3GQB2v/+vKwgPSCcyv8B2YnarZ?=
 =?us-ascii?Q?MmSr6G4QdKKLfksgIGlKGKyVZsTsPNP00GzaqkHYdPv8O13aGTK3/PgcuYVL?=
 =?us-ascii?Q?op916Z1DYYb+7rrdi0OEcHXSw7hBGyVXIgWUi4N+hnnsWWH7lBFIPyPRln+7?=
 =?us-ascii?Q?BufiuKLFkXdidP0+aTkoBi5e2RDOMZzZEiI9kPM8/lUE3o4FrKr56m1JmIAO?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f065e24-7571-4ffb-220b-08dae9cf2a9d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 19:02:01.0039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rsvJisNVcR3d37xYUWYMLpiyz6CPiFJejKmp//imzX3cjJziyVwKmBm+WgO+yQV4gWO8ZSIscLvvA899OiVWwaDw5SXh1WKr4Umc6ADlYsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-29_10,2022-12-29_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212290157
X-Proofpoint-GUID: 0Nq90LbzmAk05nuilSDG_y_oM5WzxWKN
X-Proofpoint-ORIG-GUID: 0Nq90LbzmAk05nuilSDG_y_oM5WzxWKN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_execute_req is going to be removed. Convert libata to
scsi_execute_cmd.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/ata/libata-scsi.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index cbb3a7a50816..0cc1e6d660ad 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -383,8 +383,12 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 	u8 scsi_cmd[MAX_COMMAND_SIZE];
 	u8 args[4], *argbuf = NULL;
 	int argsize = 0;
-	enum dma_data_direction data_dir;
 	struct scsi_sense_hdr sshdr;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.sense = sensebuf,
+		.sense_len = sizeof(sensebuf),
+	};
 	int cmd_result;
 
 	if (arg == NULL)
@@ -407,11 +411,9 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 		scsi_cmd[1]  = (4 << 1); /* PIO Data-in */
 		scsi_cmd[2]  = 0x0e;     /* no off.line or cc, read from dev,
 					    block count in sector count field */
-		data_dir = DMA_FROM_DEVICE;
 	} else {
 		scsi_cmd[1]  = (3 << 1); /* Non-data */
 		scsi_cmd[2]  = 0x20;     /* cc but no off.line or data xfer */
-		data_dir = DMA_NONE;
 	}
 
 	scsi_cmd[0] = ATA_16;
@@ -429,9 +431,8 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
-				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_execute_cmd(scsidev, scsi_cmd, REQ_OP_DRV_IN, argbuf,
+				      argsize, 10 * HZ, 5, &exec_args);
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
@@ -491,6 +492,11 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 	u8 args[7];
 	struct scsi_sense_hdr sshdr;
 	int cmd_result;
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.sense = sensebuf,
+		.sense_len = sizeof(sensebuf),
+	};
 
 	if (arg == NULL)
 		return -EINVAL;
@@ -513,9 +519,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
-				sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
-
+	cmd_result = scsi_execute_cmd(scsidev, scsi_cmd, REQ_OP_DRV_IN, NULL,
+				      0, 10 * HZ, 5, &exec_args);
 	if (cmd_result < 0) {
 		rc = cmd_result;
 		goto error;
-- 
2.25.1

