Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C9AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 06:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241885AbiFCG5R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 02:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241836AbiFCG5J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 02:57:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3573DB82;
        Thu,  2 Jun 2022 23:57:04 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2531DiSX007640;
        Fri, 3 Jun 2022 06:55:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=Ef/dEWKNjU3lug+11K5RaUKuw+p1pfZuAkFArEjaOtY=;
 b=g6vOl4aGRTG3ZD5dUW45PjmWkjVQ1HedQF6k37oxlDOjvGKjdZEgUfbYVTTYmt7lKYyB
 cyXA1Omlqtu1L3PVCmJx2YtZkjGHdQ3NBMLZ2wg0C6OJV8ZpoHjoA35rNNEHUfvW3wx6
 VEtMYxp/De8VDo4Rq/ZdNSLhmL4aYw4mbl2VSehv2qzTNdn0iKM+a9LUfXoSYY0Aa269
 N4j6eQeQiViWUL20nfFwuvMgjx6Lj6zqyeSi56aBxw+tNTpVJLaNmqtUn+uNmXnmAAtE
 xVy2P0QKBTBDGJYSbfBAZeoVHbYbEGNlFPvlcs8OAZkHbwdPTHe7/ZEBZ4F6ckwq7SHz EQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc4xv7sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 06:55:52 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2536oNhd025389;
        Fri, 3 Jun 2022 06:55:52 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8p5nyqv-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 06:55:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIDt3nHi4u37E4/TqM49GEcAdLWEcXrBa9usNfl7xTmOJt5rFa8oGYq1b0KkTNZbngs3mmHrOWVA7iVFIrsjT+k+plIkCXPkZh2DW8LrJ+l42HaTxW/SZBth3iyc4hGTyapF7p6eGSuVZWjBtM8nXQdPOw17VaX2QDCOhpLPz7xlYI7AWA9rK0Ugt87o45TfpDIPnfESCSydM32WMcC+fHX71rkYhC86KpyoIh8T2n8BNieg+BDfnDIL1E7elp8FIq+rSlkFsqkFlYdHQhCmz4MFgRtTgpafORtNq+XMRL+aL8GIH/6EhlRSCJ4IPt6hyZ/vavGtksUWAOo+toLp0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ef/dEWKNjU3lug+11K5RaUKuw+p1pfZuAkFArEjaOtY=;
 b=URkacwSYbyVcK3rLINJ5HpxNhRgOY0fZ/7zaV8+udNvLHV1vmNfK8S8e0uViPkoC5gc9XbYTn7N0Bc3PNva3Qjn5AJSmUZdQo1RpNCKFz4v1ozGN4L0wLwwEjH4i/lrCaiagYYB7ryM0Vog65zMUfsYnqrE5NsWrub0iPW5wFL2Z0jsCmlBJIXtBmo2YOTElpAvRcuwVQDR8Si9ejyk6wF1R8QspCjqxZ6M7+o+PSBU1lNRcjhTOuTxWeP9Wi3B8QQipH5OJnmuoOAEA4DWJ0D/u3eWpbZP6rHaT8coaZ/WXNeYXxxAaGHM6Tu4teOCWCMVnC7/EhtvcijZibeaKEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ef/dEWKNjU3lug+11K5RaUKuw+p1pfZuAkFArEjaOtY=;
 b=pdT4N8iOUn/zBSn2RuiP429nTKNIlMPf5OB4tcrKiH/e56WIb4JYEyN9zskpQfbS3EeTgbMINUNUwP6EyqaRYsHU9512p1EzlTp585UJVoI6gFYaXfF7Sq4Fejm9X6V9TDW3DHuzy9mAoKWQAbFB3Hov1QZ2YD2IiZOqg8jH8Ew=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB2789.namprd10.prod.outlook.com (2603:10b6:a03:82::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.19; Fri, 3 Jun 2022 06:55:50 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5293.019; Fri, 3 Jun 2022
 06:55:50 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 05/11] scsi: Add support for block PR read keys/reservation.
Date:   Fri,  3 Jun 2022 01:55:30 -0500
Message-Id: <20220603065536.5641-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220603065536.5641-1-michael.christie@oracle.com>
References: <20220603065536.5641-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR16CA0012.namprd16.prod.outlook.com
 (2603:10b6:3:c0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55a7c3e5-f2cf-449a-8310-08da452e17fe
X-MS-TrafficTypeDiagnostic: BYAPR10MB2789:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB27897554B72782B2855941F7F1A19@BYAPR10MB2789.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tCICC4H/zQkRM6oGQrGH/h0cjjLQJI1bDnhgBTKfCDIhEpA7ZolriFTZ54qePMD2zqB+7qmB5XdJDt7RC4nKciPbKE5u6RBq4NNM6K0Sw4/hHPImPe7/aAiKkkhj/57gLTUzCUYvGrV7PgUM8o2RqejSa9yYyKpk+kArnRhf4n7gE2DpqohNAB/6x9BzsxntCl+E6PN1rmFaX0BgkKa9Gsk3lWauF6AXWrm8DJeTGu1avbn6cwUchNxDnhM1pPQMqSQ7QZh1YlUskLNZfZeVQOVdLK4Pkv2xpowbkpfXaJOgJSQHz6DQUJ9M8llm2QWoUQ66k8WRER766SiIZTBLjklrfhGVuFZTAW6EfrjMmE7PjV6+VOSqpzlhRM5/XF8yHCqeIGdvhx2LUHDwVkYLZmZJVhsKHWVJvi+SHHAMg8tYRLPYHRP2BasNLg6Sj2CozON9O72hIiuMJbqwn/10r9QYhQriSdo9ryZ+MdmiJCMPB8E3AhyTW3jVTKe1++6RqsEGUeOflWRfcMi9I2TQs6UuUWyHF52uLAHPFtp39izCLo46YBqfFw22YbmJgrD8ei6psJAdGwhXsSL5bVCab/hrjc0IwvntVi2L7vKw6Yvw2As9y+kpiDZd4+qpftbubl1emNZ1Yq2j2yOQqxGZ6RSOHhTePFq3+Uh57Iq3YecCuixqeQ4OjPoi1ZbeBNc38kxf/XyvqiYjCq6WgS4/zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(8676002)(38350700002)(38100700002)(66476007)(4326008)(66556008)(86362001)(83380400001)(36756003)(8936002)(107886003)(6486002)(2616005)(316002)(5660300002)(1076003)(6512007)(26005)(2906002)(6506007)(52116002)(186003)(6666004)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hahcfZK1Ee2+vQaR+D2dQaTwygXJfGMpQCqq8R17ySdBkiL9N4TNrQtPOg7g?=
 =?us-ascii?Q?dOPa8Z/zq5PBPa0dAFFiBkU67q5VhOE1x9wdSv+17gHINsJBoj+1nKrJGibe?=
 =?us-ascii?Q?cX/JYYUG6ZcVR8/QGNqh2flsYu+RsyjEgL7UzBXN4iz1TW7kSvvQ0EghjPEE?=
 =?us-ascii?Q?JuL4Ry7GOQtu9M4clUbcV+oBvCh17CwyBQA4kTiqa8WUoNTcxtl4+WjcGKd1?=
 =?us-ascii?Q?QARg5az41kGVGmI5zFWaoXvCXzLdGaPETXDz2eVIJXl4OqOhrqXaPftpXB2q?=
 =?us-ascii?Q?2Iu/byxCsKPZ9xbnNSGiXWmL33ZGT/V1Y7swuIDDHmrGVRpl1ykxy2gEmO42?=
 =?us-ascii?Q?TtIIz9mnyTqwskb435gLciIZlwB9IZCvPqMWp9DmUuqoNyKJ2hjlTP4hRBly?=
 =?us-ascii?Q?2NkLv8/tSBN26FJk7ocrUrZuHFMKVPnPXAqJvBrIH0f3D5fIjQ50DuMuDOHx?=
 =?us-ascii?Q?mNw4TkixFOHV+nEn5D7LlOmR0xPsWt28YfCHzTGR2u+tulrwhRWcfb8fBnst?=
 =?us-ascii?Q?4xYWUT4/QAuTh8IvqfgtbMsf2bTsPTTJ6iT1FHkEEO5WxjQiA32GLd0YOFoJ?=
 =?us-ascii?Q?jI7c7bLfQJpWmIkTvpEdYp6D6cpGlKJcY+CnGhVUVzcjb5u0RbF3mYrodLQe?=
 =?us-ascii?Q?j274muNCnkLboczh2DbTbBUD9KlDECciG7OhHX1ljAAF7Ln/Su8ZAGOqJYxi?=
 =?us-ascii?Q?fVtCLqq930GYB6sHQHmLJyzqpn2YlwAbNDCWRLL7ljFO82KnRxV82QpXm+aq?=
 =?us-ascii?Q?b0SV2J4pF5xdV/Ja2+4tB0C5BSo4Y59rNT0uJgpccBnd4ikWDoRhEZE3JM7F?=
 =?us-ascii?Q?3E6lgh5fbKGNPICba18jrLk+f4ZBPrErE1UhfVEPIIR1a2MFQdh3ZZUroMrO?=
 =?us-ascii?Q?MqJ5fAhZY2YAhUl1U63wG23ZN2MW7e5W0Bi5bYz6jEE2ZdxkSA6eJWvFQkGX?=
 =?us-ascii?Q?fEycKUAMiAGOBe68wnjdpRzFjvhsPTWcPvgf5GrqzviLC5E9sKxxc6gIBMxU?=
 =?us-ascii?Q?BliJI5HS1ZObz6BssoUnPN+m8KmsoB3tIxq7XtqoYJ/gbravz8Q5w0TuX5yt?=
 =?us-ascii?Q?96WmHWcrIhR1+PsnXKTG1x/P/OWLcCzCuVtE6s3nVvqYZi5KEAYPuY+3zq8I?=
 =?us-ascii?Q?PPTekoYgFVuMfivs4STXiyr5Ucy+kkUBtgN20H10c8fZ+kfMEPzuQwTHwIYQ?=
 =?us-ascii?Q?B2oaqVMa9d6T90rwzNVLfIC+GNkgucMQC4dR3BJoouoNKgye3hjUPCcA/5sX?=
 =?us-ascii?Q?6AM0FNMrLt70R6SwTvEZEcMSHjGP63iPYJLfGkHqzg0Awmk9Aq4kQzF0X2O9?=
 =?us-ascii?Q?8ZyOKqj7jazSpuEZfSPQT1hsj+PT07GsBbQrOn0EImEpygSwfdR1+SzKxumo?=
 =?us-ascii?Q?7GvRQj/OEtwwFsD4keEaEajggHXbd+oXdNThPMhE6IrqDLqlntWFRfuELzmK?=
 =?us-ascii?Q?/g82hUuGLbHXFvrVKj9A4QloWfkO0n5JSMW4r1UV/QYOOZ26yswS5QMD2qa9?=
 =?us-ascii?Q?40SPcDW2PkBWXmpAZgVjfCM/aJsILzJIA3tIcR87Pdh/5JLrhmqO8+DDf/nY?=
 =?us-ascii?Q?IYxiLtOphFZ1K/ju8zGjEfsuFcCrKJzhD3REamfRgqlmmwytneSb5qyeEywu?=
 =?us-ascii?Q?weloDLIsIDa4B4nDN7IwKdgJxty/of7HP0CglNPnLDIz43oTACEbjm9HXRyR?=
 =?us-ascii?Q?b+lE2TAOlmGy/2D8nbtKv644ysrOaBU7pm8oVLEHMa/UcqSTZu7I9816I1rD?=
 =?us-ascii?Q?aKcjsKYsEhV58sYy/Z9mGIo9H1kmXbM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55a7c3e5-f2cf-449a-8310-08da452e17fe
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 06:55:50.1432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POIJMB9DhMLr3cqTv9C61cFA7AMZYSJdJrmI5ZeJMTAx04q3LOM/OM7RJWIm1DjIfWIoma50xKjltpcjgBMwjI3mddzFMyTDbonDOlGaVxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2789
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-03_02:2022-06-02,2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030029
X-Proofpoint-GUID: P9n1_VNzfceYzCx-i2OkdUdejI3hzJhk
X-Proofpoint-ORIG-GUID: P9n1_VNzfceYzCx-i2OkdUdejI3hzJhk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds support in sd.c for the block PR read keys and read reservation
callouts.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/sd.c         | 88 +++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_proto.h |  5 +++
 2 files changed, 93 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 765fca0f38c7..71283aaf3e82 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1684,6 +1684,92 @@ static int sd_get_unique_id(struct gendisk *disk, u8 id[16],
 	return ret;
 }
 
+static int sd_pr_in_command(struct block_device *bdev, u8 sa,
+			    unsigned char *data, int data_len)
+{
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_sense_hdr sshdr;
+	u8 cmd[10] = { 0, };
+	int result;
+
+	cmd[0] = PERSISTENT_RESERVE_IN;
+	cmd[1] = sa;
+	put_unaligned_be16(data_len, &cmd[7]);
+
+	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, data, data_len,
+				  &sshdr, SD_TIMEOUT, sdkp->max_retries, NULL);
+	if (scsi_status_is_check_condition(result) &&
+	    scsi_sense_valid(&sshdr)) {
+		sdev_printk(KERN_INFO, sdev, "PR command failed: %d\n", result);
+		scsi_print_sense_hdr(sdev, NULL, &sshdr);
+	}
+
+	return result;
+}
+
+static int sd_pr_read_keys(struct block_device *bdev, struct pr_keys *keys_info,
+			   int keys_info_len)
+{
+	u8 *data = (u8 *)keys_info;
+	int result, i, data_offset;
+
+	if (keys_info_len < 8)
+		return -EINVAL;
+
+	result = sd_pr_in_command(bdev, READ_KEYS, data, keys_info_len);
+	if (result)
+		return result;
+	/*
+	 * The device gives us the info in BE, but users want it in a easier
+	 * to use format so we convert it for them.
+	 */
+	keys_info->generation = get_unaligned_be32(&data[0]);
+	keys_info->num_keys = get_unaligned_be32(&data[4]) / 8;
+
+	data_offset = 8;
+	for (i = 0; i < keys_info->num_keys; i++) {
+		if (data_offset + 8 > keys_info_len - 8)
+			return -EOVERFLOW;
+
+		keys_info->keys[i] = get_unaligned_be64(&data[data_offset]);
+		data_offset += 8;
+	}
+
+	return result;
+}
+
+static int sd_pr_read_reservation(struct block_device *bdev,
+				  struct pr_held_reservation *rsv)
+{
+	struct scsi_disk *sdkp = scsi_disk(bdev->bd_disk);
+	struct scsi_device *sdev = sdkp->device;
+	u8 data[24] = { 0, };
+	int result, len;
+
+	result = sd_pr_in_command(bdev, READ_RESERVATION, data, sizeof(data));
+	if (result)
+		return result;
+
+	memset(rsv, 0, sizeof(*rsv));
+	len = get_unaligned_be32(&data[4]);
+	if (!len)
+		return result;
+
+	/* Make sure we have at least the key and type */
+	if (len < 14) {
+		sdev_printk(KERN_INFO, sdev,
+			    "READ RESERVATION failed due to short return buffer of %d bytes\n",
+			    len);
+		return -EINVAL;
+	}
+
+	rsv->generation = get_unaligned_be32(&data[0]);
+	rsv->key = get_unaligned_be64(&data[8]);
+	rsv->type = scsi_pr_type_to_block(data[21] & 0x0f);
+	return 0;
+}
+
 static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
@@ -1758,6 +1844,8 @@ static const struct pr_ops sd_pr_ops = {
 	.pr_release	= sd_pr_release,
 	.pr_preempt	= sd_pr_preempt,
 	.pr_clear	= sd_pr_clear,
+	.pr_read_keys	= sd_pr_read_keys,
+	.pr_read_reservation = sd_pr_read_reservation,
 };
 
 static void scsi_disk_free_disk(struct gendisk *disk)
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index f017843a8124..07ff33ea27e9 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -151,6 +151,11 @@
 #define ZO_FINISH_ZONE	      0x02
 #define ZO_OPEN_ZONE	      0x03
 #define ZO_RESET_WRITE_POINTER 0x04
+/* values for PR in service action */
+#define READ_KEYS             0x00
+#define READ_RESERVATION      0x01
+#define REPORT_CAPABILITES    0x02
+#define READ_FULL_STATUS      0x03
 /* values for variable length command */
 #define XDREAD_32	      0x03
 #define XDWRITE_32	      0x04
-- 
2.25.1

