Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD3BC19F2D
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 03:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiHJDmZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 23:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbiHJDmQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 23:42:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5219A72EC8
        for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2022 20:42:15 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A0DqAa026711;
        Wed, 10 Aug 2022 03:42:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=whgYmqaET0iTljpIS31dMrefVThUKybewn6vHDJS42c=;
 b=LD0b7nH5JwKYzcTjVmEaZlq1trYcP8t6/mYMnMyIVtWFcLkJR2NgAq91O75R8hA8+JZS
 ZgibC/P+wXjeHKyPk2SakoR2nIb+NETo6M+0CEbS2dGIxjclGT7d3nHVRlfLkAMC2TuZ
 hz/Cs6zufOWMEyazB6RkpLmqd34Zdb7cCH4TqBsKNLqFto9LSpKMj6DQcocvk0VcH1WY
 LiVLdq5EoX5XIo8FspHeugHc2or0CrvSiUDzLINOXCu4v47gVrn9zl6MA7H6smxmrar2
 D1i4dsaSNwZ/NXloDVJ2ElCp4hwOwIis18vCx6L4LsxSTmykWVxXATuV3AD8XbL4UaS0 ZQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq90qwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:42:03 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 279NkcOf038712;
        Wed, 10 Aug 2022 03:42:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2049.outbound.protection.outlook.com [104.47.57.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqh90df-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 03:42:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c46vssnhfO0/vUYdRL3TMmxGt36ASs/8hjks6Y7DgaJmNCfNf0M64vy6uYZuyt0ZjKE4b6XcXFyv81czFWZJQhzFnN3YF6Jo3y+K38IBkEdk/k+IRYJFv16J87nZgyuZMB0aAv30e5j5qREBh3WS44h1OC8HRgdSbLptsr9604ZO3R3SFiMaaEvcUu21l860PmGcFZVMiGjJW6JwUwamLvupOkzJCCms7XpH0FNnW5EQwBgQ16aRgul/PmaKRfjVQTARxQXpzpHzAMUHnshxdn6B/gqOKXnNMbmu7bqR9R53LwS9G07wagLGPNu8yLsK7a12mGhPTp1a3EDL+6Wgug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whgYmqaET0iTljpIS31dMrefVThUKybewn6vHDJS42c=;
 b=hPfViNrvVDu2Kl7A2vaJtaf8oFHcrPnxvgWciJ8o36dyj0kYiSIkj21KXxwgpBYNOc+zIbmpHvdVtTBzOMa3CQJVSI7N/cRFxSsxI7knLyQsdwmhd5ioEsr/q5LIqIXT5IJ/1Y7woyN97s7/tUS5Vs5TtK+8iXCpK1Ktwqfr30QClM1PH6NJqJQgnzElN0ydCJb2RxE+Qc2pHGKy092fPy8aP0dW9oQWCF+85F5uGurUm7M/RcA+eDlUkiQnFdIHyxkNbuV8CeN17G+j6gsQBnML6yMzMxV4iHRAN8YOSFb/Ik+WSL292Z5hgB+ZYSXo+y67MPNzZw7iyIK+JWj7OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whgYmqaET0iTljpIS31dMrefVThUKybewn6vHDJS42c=;
 b=gM4HKuBhgC7QJtD6O5wDB6JRuetbnwh23FAZEmxYAfeVbnObxIRSE+kupqSgEPemcbnZctzCq2lHuWCXI/79qwTIbJIM2klQRGimgem2TkYHmNCApZAjeMOoha4QAleP1s81va4Z1YMlkCR6ox3471d92kpq85e+i0s9s97DOEw=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB6302.namprd10.prod.outlook.com (2603:10b6:a03:44e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 10 Aug
 2022 03:42:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 03:42:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/4] scsi: Add new SUBMITTED types for passthrough
Date:   Tue,  9 Aug 2022 22:41:53 -0500
Message-Id: <20220810034155.20744-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220810034155.20744-1-michael.christie@oracle.com>
References: <20220810034155.20744-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR17CA0002.namprd17.prod.outlook.com
 (2603:10b6:610:53::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dba0c17d-feda-4f69-9302-08da7a824869
X-MS-TrafficTypeDiagnostic: SJ0PR10MB6302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zmp4AkQ8aQTSwMQUBqbZiOLfcDeGD5mHiet7uqsYZCV/ZyRHahDl1/qG+gMW92rwYDRcWgrjEBRC/38g0nrEY9x53noKXO/gmie9ionQgBJZgqQKRi7/pIaKXp1MvEY5/cl7Mb2NKK7FqznOsPvWMyzSSsVw1PJeSsE26ftnbaXY6CCcwGP1GiQY9Za/8Suud6NQh8FvXZDLDodv5QjdVKabXTCULccRoodprYss5RsmoNgg/9LyahYZ4ymT6n34ti3x0dm8jLYfP5RJlRJYjF9pn2xqqRsD/q5ODVa8PmVdRPAXAThb0GPC33c6tOzsl6ltPrLlLf7ObUpgdwZvnUc0GmmaoN3e29vy+wjkH4q7Fpuoxc5m63+RaV6k2GjB1Xyt9Gj4D+CBgWivUwlJwh+g6o2GoOi0ILgrgO0jqb36xFlgT9+aiUAJUzxSp1T1GCPr9inQYblKoNDIiwZPIigqDLwieXK7WFScUZxookuGnFCdt1/dQKu9uAyl2ingSxrDchZ6dkWrwvBFmpI/q6HV+fngvJw5vAcpYq/UcF1j4vU09ZOjJp31NODkp1XFhTr68mf6gCvNIPj78Q6bRnm+ZqQUZT9O4zFgoxNtfa1tfpoaDM/F1Me71VlhPj91ZSnpnU3IB0cCQ8pBVI+vvU7/WVEIwDGCkRBPv226qA5mJJe9uz70njOwUWkHcBfl1EMNeyMV8whJxpn+XEcRcmjMoOHNs5VAC33qzx6iBzoZlTBiQU++BpVwDH4f1l3A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(39860400002)(366004)(396003)(2906002)(6506007)(107886003)(316002)(41300700001)(38100700002)(6666004)(86362001)(2616005)(66556008)(6512007)(186003)(1076003)(5660300002)(66476007)(8936002)(83380400001)(66946007)(36756003)(6486002)(4326008)(478600001)(26005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V7tlHrP4+0c+tf7VKpRXxvnhucp0eE48I1YklgCrzN5IPaHRIyDMvIG3HNgL?=
 =?us-ascii?Q?k4IA3ltscOgRAZawAZZ/ZUqCipVhIHXvvqdwHDWS+O6E5P6opM4JedI3Yehk?=
 =?us-ascii?Q?WOURVx7fWR350LvKox+VCgZBdi3gO/9QjqSXWAX1hj080u36/9bcrra1A6rP?=
 =?us-ascii?Q?my6vykeuUdV3tq4SrfRw65CZFE0qHoye+pBgDW9mSC0chIJOOPCVtwGefaxN?=
 =?us-ascii?Q?ViU2OfCjLp7iD3XBV/WKyEgZlikDC/fZh2J+71QYv4o/JzvLwPQuCS/gOBi8?=
 =?us-ascii?Q?rRDc9qTDO2UxOytVLx5C1PBWqZN9hycQhsp4SGaOUgUu+dURAq8pq77zGq6X?=
 =?us-ascii?Q?v7jLXJUZEV0iFKnHq6DQxC/R84UlA14ShGosiuoXFrIC6gR9+gjiyzAjt6iL?=
 =?us-ascii?Q?LKdjhTMwY71pAUMKbYth5xUhHYED1TzVaWo/LrRVkDHGNjdZh1FRhDDFftL4?=
 =?us-ascii?Q?julkg3fDj2kOC99+Vjyph9WuxfA8CVx4EMzon7R2WbsiWLoeWosPtg3Ec1Gk?=
 =?us-ascii?Q?q/F6GVS8YbYEBtuJ1qwsQQ70/FDyT2vaSJi8A+mueaQxRzSwT/mMnzHMNZw+?=
 =?us-ascii?Q?g/GoSIHDfahaogVndhKpqMLCGl6Vw1nEOsv0aTEEQgQDZOByWur+pUjM9oIm?=
 =?us-ascii?Q?GHZyWHOXtgbHs4ocsHt8gFeac51Y3nACyDiAI+pf80zrzGwwpPGuA3l7N1bc?=
 =?us-ascii?Q?Rqgj/vZeAc27N7uieWzHNdX4OJ0Oi+RG92lkr0ek9AG7saMLGlR/1YRhM/xE?=
 =?us-ascii?Q?5c6FAeWzkrH1+Yh/NFQiVgXdPsEY6gf+6qtAYuERkjzyV5ey5JLABCuL3CI3?=
 =?us-ascii?Q?1Xd3kqWt2m8NsMvrS8E3U9xrEVDeU54+jtHRPwshc/H+gIiOhTTXppc0CBbw?=
 =?us-ascii?Q?amoNbP93BX6wHj+UIAk+YrOEVvgM3RXNuz0KC2nq8XY/yYCuOYATeuIHsvac?=
 =?us-ascii?Q?6O1xLnazV1I3J+rK0i1zJzkTAmPLuG45HxlccquV0+tzGkazImChnIBTma8+?=
 =?us-ascii?Q?vRIih9hoYmJtj6eg9AvdsJ5LfbL0BJ2vx1KBmJf/ZofDYwQzrtuDn1Ud8zSB?=
 =?us-ascii?Q?mABU3smiZFe/4ExZlIbay2UJP8R3Mk3h9omcvSwPVR+Z3m1vw/yQgiB+AOCY?=
 =?us-ascii?Q?PshQlVsGydnx6gq1dPG8pTDIPj3aKPcrTinn1B5TQrmmEk8/0tGwX1DF1YMd?=
 =?us-ascii?Q?uAcnBC0gHc9U2FCAEcci5+BrCNm69PFhium/zrX9cBj5efRIsnPcZPJdRwIa?=
 =?us-ascii?Q?JmFy8oMaxRrD1JLM57gcEVmHdEoNVjFJyd3Ae3q4SMoqqh7S0TDxUTTRhklE?=
 =?us-ascii?Q?E9bEziRKNN8CedAk7rF1n0kAJLMoWxqQGFarnJ/GTEJOg0qUMU0tD9hEWjVW?=
 =?us-ascii?Q?dRSamUXcbCnlMLV14/HdYM+08y5R1pn2a7gVSYijx6lpOyYUsIchjoMoVciq?=
 =?us-ascii?Q?zs9RKLyvHgCFrwW+BpwGJnBYNKGRkAN3L0hkxT/aFu9hbx2St3guXJQ41Ip2?=
 =?us-ascii?Q?F0aEib9mRcYp5EW/VnklVuTT0GsWOAU0sy5BPJdDLGigykHeAWD9/2FW8DL8?=
 =?us-ascii?Q?gw0fcjZVdu+87TmgQOyBwvJ7TBvujVvNDqroXMTnuMV+FK2/78pLRaHgZsRq?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dba0c17d-feda-4f69-9302-08da7a824869
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 03:42:00.6655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kfGtR8kCL9EZhVLQDlNBqsrL+f/uJNF1AYbingrtwOhMWfcI7NE88hMy1NcmY0ql7cphmrTWqqKsOcA6vcOZWbceAyswqkPkCA/ojG0F/xU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6302
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_01,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100009
X-Proofpoint-GUID: raXeVXuAjCF4oBk4_AJ0lCC-ABaAB8uF
X-Proofpoint-ORIG-GUID: raXeVXuAjCF4oBk4_AJ0lCC-ABaAB8uF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds 2 new SUBMITTED types so we know if a command was queued
because of a scsi_execute user vs SG IO/tape/cd.

In the next patch we can then handle errors differently based on what
submitted the cmd. For scsi_execute we can let the scsi error handler
retry like normal if the user has requested retries. And for other users
we can fail fast for device errors like is expected by users like SG IO.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/block/pktcdvd.c            |  3 ++-
 drivers/scsi/scsi_bsg.c            |  3 ++-
 drivers/scsi/scsi_error.c          |  3 ++-
 drivers/scsi/scsi_ioctl.c          |  6 ++++--
 drivers/scsi/scsi_lib.c            | 23 ++++++++++++++++-------
 drivers/scsi/sd.c                  |  3 ++-
 drivers/scsi/sg.c                  |  3 ++-
 drivers/scsi/sr.c                  |  3 ++-
 drivers/scsi/st.c                  |  5 +++--
 drivers/target/target_core_pscsi.c |  5 +++--
 include/scsi/scsi_cmnd.h           |  5 ++++-
 11 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 4cea3b08087e..0bc69c56f36b 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -689,7 +689,8 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 	int ret = 0;
 
 	rq = scsi_alloc_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
-			     REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
+				REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0,
+				SUBMITTED_BY_BLOCK_PT);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	scmd = blk_mq_rq_to_pdu(rq);
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index 96ee35256a16..2d4ae1383892 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -26,7 +26,8 @@ static int scsi_bsg_sg_io_fn(struct request_queue *q, struct sg_io_v4 *hdr,
 	}
 
 	rq = scsi_alloc_request(q, hdr->dout_xfer_len ?
-				REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
+				REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0,
+				SUBMITTED_BY_BLOCK_PT);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	rq->timeout = timeout;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 448748e3fba5..ac4471e33a9c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2025,7 +2025,8 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	struct scsi_cmnd *scmd;
 	struct request *req;
 
-	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, 0);
+	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, 0,
+				 SUBMITTED_BY_BLOCK_PT);
 	if (IS_ERR(req))
 		return;
 	scmd = blk_mq_rq_to_pdu(req);
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 729e309e6034..d8bb638f835d 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -435,7 +435,8 @@ static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 		at_head = 1;
 
 	rq = scsi_alloc_request(sdev->request_queue, writing ?
-			     REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
+				REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0,
+				SUBMITTED_BY_BLOCK_PT);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	scmd = blk_mq_rq_to_pdu(rq);
@@ -546,7 +547,8 @@ static int sg_scsi_ioctl(struct request_queue *q, fmode_t mode,
 
 	}
 
-	rq = scsi_alloc_request(q, in_len ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
+	rq = scsi_alloc_request(q, in_len ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0,
+				SUBMITTED_BY_BLOCK_PT);
 	if (IS_ERR(rq)) {
 		err = PTR_ERR(rq);
 		goto error_free_buffer;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3ef85c8b689d..c689c28d6181 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -210,9 +210,10 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	int ret;
 
 	req = scsi_alloc_request(sdev->request_queue,
-			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
-			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
+				 data_direction == DMA_TO_DEVICE ?
+				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
+				 rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0,
+				 SUBMITTED_BY_SCSI_EXEC);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -226,6 +227,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
 	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
 	scmd->allowed = retries;
+	scmd->submitter = SUBMITTED_BY_SCSI_EXEC;
 	req->timeout = timeout;
 	req->cmd_flags |= flags;
 	req->rq_flags |= rq_flags | RQF_QUIET;
@@ -1119,13 +1121,18 @@ static void scsi_initialize_rq(struct request *rq)
 }
 
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
-				   blk_mq_req_flags_t flags)
+				   blk_mq_req_flags_t flags,
+				   enum scsi_cmnd_submitter submitter)
 {
+	struct scsi_cmnd *cmd;
 	struct request *rq;
 
 	rq = blk_mq_alloc_request(q, opf, flags);
 	if (!IS_ERR(rq))
 		scsi_initialize_rq(rq);
+
+	cmd = blk_mq_rq_to_pdu(rq);
+	cmd->submitter = submitter;
 	return rq;
 }
 EXPORT_SYMBOL_GPL(scsi_alloc_request);
@@ -1541,13 +1548,14 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 
 	scsi_init_command(sdev, cmd);
 
-	if (!blk_rq_is_passthrough(req))
+	if (!blk_rq_is_passthrough(req)) {
 		cmd->allowed = 0;
+		cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
+	}
 
 	cmd->eh_eflags = 0;
 	cmd->prot_type = 0;
 	cmd->prot_flags = 0;
-	cmd->submitter = 0;
 	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 	cmd->underflow = 0;
 	cmd->transfersize = 0;
@@ -1605,6 +1613,8 @@ static void scsi_done_internal(struct scsi_cmnd *cmd, bool complete_directly)
 
 	switch (cmd->submitter) {
 	case SUBMITTED_BY_BLOCK_LAYER:
+	case SUBMITTED_BY_SCSI_EXEC:
+	case SUBMITTED_BY_BLOCK_PT:
 		break;
 	case SUBMITTED_BY_SCSI_ERROR_HANDLER:
 		return scsi_eh_done(cmd);
@@ -1741,7 +1751,6 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	scsi_set_resid(cmd, 0);
 	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
 
 	blk_mq_start_request(req);
 	reason = scsi_dispatch_cmd(cmd);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8f79fa6318fe..550df58f228a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3637,7 +3637,8 @@ static int sd_submit_start(struct scsi_disk *sdkp, u8 cmd[], u8 cmd_len)
 	struct request *req;
 	struct scsi_cmnd *scmd;
 
-	req = scsi_alloc_request(q, REQ_OP_DRV_IN, BLK_MQ_REQ_PM);
+	req = scsi_alloc_request(q, REQ_OP_DRV_IN, BLK_MQ_REQ_PM,
+				 SUBMITTED_BY_BLOCK_PT);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 340b050ad28d..3f10cedf6f03 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1744,7 +1744,8 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 	 * not expect an EWOULDBLOCK from this condition.
 	 */
 	rq = scsi_alloc_request(q, hp->dxfer_direction == SG_DXFER_TO_DEV ?
-			REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
+				REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0,
+				SUBMITTED_BY_BLOCK_PT);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	scmd = blk_mq_rq_to_pdu(rq);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a278b739d0c5..8b9f44079aa6 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -933,7 +933,8 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
 	struct bio *bio;
 	int ret;
 
-	rq = scsi_alloc_request(disk->queue, REQ_OP_DRV_IN, 0);
+	rq = scsi_alloc_request(disk->queue, REQ_OP_DRV_IN, 0,
+				SUBMITTED_BY_BLOCK_PT);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 	scmd = blk_mq_rq_to_pdu(rq);
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 850172a2b8f1..b981a186e195 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -545,8 +545,9 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 	struct scsi_cmnd *scmd;
 
 	req = scsi_alloc_request(SRpnt->stp->device->request_queue,
-			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
+				 data_direction == DMA_TO_DEVICE ?
+				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0,
+				 SUBMITTED_BY_BLOCK_PT);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 	scmd = blk_mq_rq_to_pdu(req);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index e6a967ddc08c..a5886ddcf075 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -941,8 +941,9 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 	sense_reason_t ret;
 
 	req = scsi_alloc_request(pdv->pdv_sd->request_queue,
-			cmd->data_direction == DMA_TO_DEVICE ?
-			REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
+				 cmd->data_direction == DMA_TO_DEVICE ?
+				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0,
+				 SUBMITTED_BY_BLOCK_PT);
 	if (IS_ERR(req))
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index bac55decf900..1ade0d454874 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -63,6 +63,8 @@ enum scsi_cmnd_submitter {
 	SUBMITTED_BY_BLOCK_LAYER = 0,
 	SUBMITTED_BY_SCSI_ERROR_HANDLER = 1,
 	SUBMITTED_BY_SCSI_RESET_IOCTL = 2,
+	SUBMITTED_BY_SCSI_EXEC = 3,
+	SUBMITTED_BY_BLOCK_PT = 4,
 } __packed;
 
 struct scsi_cmnd {
@@ -387,6 +389,7 @@ extern void scsi_build_sense(struct scsi_cmnd *scmd, int desc,
 			     u8 key, u8 asc, u8 ascq);
 
 struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
-				   blk_mq_req_flags_t flags);
+				   blk_mq_req_flags_t flags,
+				   enum scsi_cmnd_submitter submitter);
 
 #endif /* _SCSI_SCSI_CMND_H */
-- 
2.18.2

