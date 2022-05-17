Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 891EDC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 22:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiEQW2A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 18:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiEQWZp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 18:25:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCADB52E6B
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 15:25:15 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKXoE4029115;
        Tue, 17 May 2022 22:25:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=6FEjvaY2qCVZWpCHdvZyWzWdPEteg7AlesRGJOl2g5U=;
 b=Gh/r/bwxYxIrQ5qjj1dW4g7DkduB6Q43mvYlnp7LwYvHDymdkAkd4h6DUkE6grXIyI2/
 gEHKAkSk6gXtWNzZlbt++Cq5nf+yL+XguTSGzXkawZREauq92HapZ/RzY/GDY/4NDOwO
 xPUNR1qBToejgTY4MLeLel7nCR4GOB28Dgtg5Cnq8Wp3w8bkraWyb3T3D+oFmqao6k+v
 ralItdehYOMnC0TDPgoJ3GV3JXunTZR7aYuQByUKWgxKNQWHfc1R17B06wGqOkczBMCS
 BWBiouQyQ/xAGefct8AxE/grRdmIU8qFnTJeT2fMdNnlwhGpHHpI1Fje/7erubgNv0ns +g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310qrn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:07 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMLnwL019398;
        Tue, 17 May 2022 22:25:06 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2047.outbound.protection.outlook.com [104.47.74.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v3c0cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVNrNqHfALB80+WTtmEACG1M2eC0tdYXY5ZITfgyrUzvSEwVdhkz9OTcEAuDWB9sgzHEgEem23bOwzRmzLa+TQ83+flA4KFIlgY+yrnG6qzw4K6x4TOkg43nQtYTdZvWgTLONrclAaFzVV/jxpT/GzAHMBQAuhmVAFl5twxYwLSglzmxeh+6jYebnsZstnwELoLnWVicOXGuNzFW4F8FQZsUUpNn6pb+j7jtWqWzKOMQRqAd2TXy3MwfmQ4SE2x4r9v83bBwv0U0iroQZNWSwHRRZLIgXhf4XH08ah+o0YJs4ngrCC+gs7xRCaD36NRFLC2XppRRTlzaQBckSzAIfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6FEjvaY2qCVZWpCHdvZyWzWdPEteg7AlesRGJOl2g5U=;
 b=DC0+BtcDciGBN6b8/IB2RST0CqOekzA4+7Q6XHS8aU73xaArfiBmHAyEwDbQsH7XbntBkirFiiKH9GoHknWF7d4p8vAprU5gDtBTjfdYFKWtyJ+8xxVWghAQAPAjOPq2thxr+C9wTstcFL+pDxfh1Y5dmJQcrefhy4g58F3SaqeoheuXzPZP60yFzFOoXB6n1x3nUk6k1iyFwQD+nU6MwShZkvP7WQmYCpM4DPHSTamQy1e13nsdBFcL/XXbfZ/8/iwNB5BCD0MAJz7cYOLfw/ozRPeAYFICkYSU88KAc4z4vJWrnv/3u6gYXOHL4N15T41cVFiqAW6tsspNW0/Veg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FEjvaY2qCVZWpCHdvZyWzWdPEteg7AlesRGJOl2g5U=;
 b=MRm8UHBaU0oKqzbQ9GgRuTgbZxkBnd+0awBkFas7WZ9s+aH6ljQDqYOiS06laxRkni96U//QOdfgdLfeb8vxC/0laPq2NX5Zm5hyJvH0Vg7NSZyD/kUDb4MuThX24WvhnUmXzcidUYtAsePbPks7rTxVCjGVGFoSqYzctfK69Cs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5517.namprd10.prod.outlook.com (2603:10b6:a03:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 22:25:03 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 22:25:03 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 13/13] scsi: libiscsi: improve conn_send_pdu API
Date:   Tue, 17 May 2022 17:24:48 -0500
Message-Id: <20220517222448.25612-14-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517222448.25612-1-michael.christie@oracle.com>
References: <20220517222448.25612-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0078.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46765a18-801e-4247-927b-08da385415c4
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5517:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB55175840CAE5829FD1DC882FF1CE9@SJ0PR10MB5517.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ok0AM3rBFgtFZwlP3tlqFpXlU8Bsu6fwEFdnRaDnmaxzptK9uJ11vsHDaFwrVXiFv9h6YxlBYBi3JOO/23IPGz5LYPNx1VQLP34nPHuxCyjNxHkwh02PXtVrRET2I1H26EBk4c8eqcFojtRU68QlMQLG+V5QW+UqC8uufB0lKQjOPuJCgwEHk33uWnPFGtTNERyU8TPO90CvuDHEh8ZhkYgUJxgc3hLZIXLFCzdOlifXTs/OJxAvUp7ibaQv/10cu47I1VwW89OdQEQMeysmUDoGHgIhbVUMlPWCnTlgLCQFkKKTwKHKc5SthFZ+Nj9lvTD5Dt/fkpL4TqiUoE5a0U8YLmESNY8va9QphTHmjfthxDQKrGdk5brs5Pjo9PONxcCSJC80saRQs7HpMuLSaty4aGLdSWdCcDOkaTlHf0/T+jQR0McNu3LDvxazEfvy4xL55z3lcMcRORe4w8We9FNRwTIXcePmjHJ3ZlavK4OvlKGEfc+21eT3IkIHcSEe3B+35zc5H+42bm6tY2sbppMWpzwrFkuRqKZvl6Xh12r3QcXEGzK7gMCRAq0Q0Y+XQbUfT2o2C2ug/hhhxa/muyUP+QSfPJbpz/8QiKgVIw0Gd1D35oNX9AcLRVJZJTwswC5Tzq/D5c0rpXe6/hTU/ITJEGZWcYBPjEEYHYj7G1R5M1rXRV5rLAetORiONpMRVcL4vy2/Pp/bPpfFQMoOCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(66556008)(66476007)(2616005)(8676002)(2906002)(26005)(6512007)(6506007)(1076003)(316002)(6486002)(186003)(83380400001)(8936002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(5660300002)(107886003)(36756003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wDdFZATeg95M1nSDYedLzc6qFJczN7S4X30YRuPmM6N7RNH/geDkBQav46nf?=
 =?us-ascii?Q?k2VsM6T44eggjU8lXU+0pdVr4ll58ZmNTL30VUD/K5CdrCK6UidYmlvmex65?=
 =?us-ascii?Q?hNPRZLVZUilQwZ+lOJ7dghPyVOt9V6RjKiN272dR0SlLOcn06iOKNwlGomFv?=
 =?us-ascii?Q?HwC6sPYuwcV4a/TomtynynFCxbpuaRfRZ08bxfRA9qYsgko41cykg6SsG5Pw?=
 =?us-ascii?Q?7YHiElJAKAz+7d3je7tP2MJ8YWQlrWojne9Um7O/iHPZdBr2Vt8DmgyxIAQO?=
 =?us-ascii?Q?yZJqn+iq5a3svAw6VOViZBdUrTiEnquKZ3CU7q0zHAzrG9h8yQJr+oC1UEa8?=
 =?us-ascii?Q?Qcu93dqymRHgJkmqyntmUhsExBA+JQc2nWyNbeXb4+qnvTGK8TIiDwbwOtf/?=
 =?us-ascii?Q?OOGff9yw89+IOZMQKNZYL4FsvHzNDfRgaJ7er83BT1gWy50T9Y4RrRdSJMyN?=
 =?us-ascii?Q?EfFaabYhBTQKJLXCKfN2QZyu4q9wlKReI7qmtUFKFYEDEdVNWn4DskyaL5Ug?=
 =?us-ascii?Q?Iioih8b568upBCRsCE2wth5Aw5SrrR5UtkIeKTJrZKvMH4fm1eMrWq/CcAli?=
 =?us-ascii?Q?xdoHFqfmXw78YXfd5Lb8EKp//or1n2vQaC2m+z15yIJr0VZauTSo52wIT6G4?=
 =?us-ascii?Q?Eo+n50gx87na4bEN+B6uabhQA14jaDdjcThWQFWASOTFf0aKyL9zY3bdd5Us?=
 =?us-ascii?Q?pE89CkwEAbqaRH/A9FPmxgbirnajo/cMp/sS6vcDuo8B6EKvbHj6vWtPxQWC?=
 =?us-ascii?Q?WV2suwrXu/KSB17dmcJqYvNkKU1eI40dHy8EUcIljpIoBFFSKaLavheKOwie?=
 =?us-ascii?Q?G5xG9lyx3NOb12hbSTEVqvO5V/dIcfHKgZF5HYohkiYRzy1qq4+q8kF5sLCY?=
 =?us-ascii?Q?pqJ4lm7GV/CqVN7W+2MP6PiONJJtQuM7vcU8cOiKN4I/c79+6mnqS3ZS6E/k?=
 =?us-ascii?Q?X2NGpozbal3nlG6WvdK5Q3yDE+Z1aneeqzG7a+EXrH3vNDxdMeM5HrUqpgA1?=
 =?us-ascii?Q?Ex/Mc/ef5SVRqgQYDOwSfSGiqcIhsZrmbkAYQxsF1wZgaNB2yJ4j2NzDqxh8?=
 =?us-ascii?Q?fP8okNS1UPXNgYsOCMAxGtyfVf4x96kl3+u6Mgm8mANn3kYSZ+JxwUUspfHm?=
 =?us-ascii?Q?90LKaB+Pdq+nsSLd00V7k0aa1L1qGvd7ObDOzbeFv5mgiPJKlfhSo+5hgigs?=
 =?us-ascii?Q?eNiXREG3Nch/2LEY8nN064KJa5k+xjMP7m8uRf7PEVhQ19p2N6ld71pQJeH1?=
 =?us-ascii?Q?KxqJDA5aUNZ86z1yjBIpad/vkv4om1oZV7FFnmPhjiFDQ+W4+plzM/aTXxyO?=
 =?us-ascii?Q?Kzkew7fP4w9dDOxRL0qSciv1rPFCLUabESB1vOO6BMe5OC7euoOhjYY/JVmG?=
 =?us-ascii?Q?pTIj2nMHO/XacBRn4uc/bFJ1OUvPMCd1LFoYT13lk3klLnApCz9ndEMBvABg?=
 =?us-ascii?Q?0FuOsY93ISd2IG4ndylUNaVZ10AeHYEj4W4ya6NcsSXqN/ZX+rNRKiipxRAr?=
 =?us-ascii?Q?cytTljw5EY9psJtdSP6y7CjeoFquYkLlguJ8nLY99Ux6T5c64URUXaKLGlpZ?=
 =?us-ascii?Q?43xXosS1dazasT1bm454Em7T1rHMe4yF1arP6Te+iBD6tTGEPjfZK1IEuHKk?=
 =?us-ascii?Q?WIGhP0c7Y2dPBpArCsViCLKPB7AI+Kr2gbfNClsD0K5T9KxmEYc+uCJpFQhz?=
 =?us-ascii?Q?7rm0N9LVQe+oETF9HO6Dq9QIi8KSjxDHN9lVQk1CcQy0cC8+QQ3ZjJwiTM0w?=
 =?us-ascii?Q?N0D+DXgtnYFSi6RfySJiYyebgviArSU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46765a18-801e-4247-927b-08da385415c4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:25:02.1365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VywpLlfEttqBV4CftggFVcCukIhUu3Sk4YEmlG2GweVh+QFBWM2eRvLB60oOAeyOfaKHVegCyRIXqoY1WMHl2WdYoqWtWCMqxowFrRMR0OU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5517
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170129
X-Proofpoint-ORIG-GUID: -NlO-u8Ay7Fu_UVXaD2DwrQ8tuXN9KHm
X-Proofpoint-GUID: -NlO-u8Ay7Fu_UVXaD2DwrQ8tuXN9KHm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The conn_send_pdu API is evil in that it returns a pointer to a
iscsi_task, but that task might have been freed already so you can't
touch it. This patch splits the task allocation and transmission, so
functions like iscsi_send_nopout can access the task before its sent and
do whatever book keeping is needed before it's sent.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 85 ++++++++++++++++++++++++++++++-----------
 include/scsi/libiscsi.h |  3 --
 2 files changed, 62 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 2bba10464cfa..ea0c67bc54bd 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -695,12 +695,18 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	return 0;
 }
 
+/**
+ * iscsi_alloc_mgmt_task - allocate and setup a mgmt task.
+ * @conn: iscsi conn that the task will be sent on.
+ * @hdr: iscsi pdu that will be sent.
+ * @data: buffer for data segment if needed.
+ * @data_size: length of data in bytes.
+ */
 static struct iscsi_task *
-__iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+iscsi_alloc_mgmt_task(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		      char *data, uint32_t data_size)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_host *ihost = shost_priv(session->host);
 	uint8_t opcode = hdr->opcode & ISCSI_OPCODE_MASK;
 	struct iscsi_task *task;
 	itt_t itt;
@@ -781,28 +787,57 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 						   task->conn->session->age);
 	}
 
-	if (unlikely(READ_ONCE(conn->ping_task) == INVALID_SCSI_TASK))
-		WRITE_ONCE(conn->ping_task, task);
+	return task;
+
+free_task:
+	iscsi_put_task(task);
+	return NULL;
+}
+
+/**
+ * iscsi_send_mgmt_task - Send task created with iscsi_alloc_mgmt_task.
+ * @task: iscsi task to send.
+ *
+ * On failure this returns a non-zero error code, and the driver must free
+ * the task with iscsi_put_task;
+ */
+static int iscsi_send_mgmt_task(struct iscsi_task *task)
+{
+	struct iscsi_conn *conn = task->conn;
+	struct iscsi_session *session = conn->session;
+	struct iscsi_host *ihost = shost_priv(conn->session->host);
+	int rc = 0;
 
 	if (!ihost->workq) {
-		if (iscsi_prep_mgmt_task(conn, task))
-			goto free_task;
+		rc = iscsi_prep_mgmt_task(conn, task);
+		if (rc)
+			return rc;
 
-		if (session->tt->xmit_task(task))
-			goto free_task;
+		rc = session->tt->xmit_task(task);
+		if (rc)
+			return rc;
 	} else {
 		list_add_tail(&task->running, &conn->mgmtqueue);
 		iscsi_conn_queue_xmit(conn);
 	}
 
-	return task;
+	return 0;
+}
 
-free_task:
-	/* regular RX path uses back_lock */
-	spin_lock(&session->back_lock);
-	__iscsi_put_task(task);
-	spin_unlock(&session->back_lock);
-	return NULL;
+static int __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
+				 char *data, uint32_t data_size)
+{
+	struct iscsi_task *task;
+	int rc;
+
+	task = iscsi_alloc_mgmt_task(conn, hdr, data, data_size);
+	if (!task)
+		return -ENOMEM;
+
+	rc = iscsi_send_mgmt_task(task);
+	if (rc)
+		iscsi_put_task(task);
+	return rc;
 }
 
 int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
@@ -813,7 +848,7 @@ int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
 	int err = 0;
 
 	spin_lock_bh(&session->frwd_lock);
-	if (!__iscsi_conn_send_pdu(conn, hdr, data, data_size))
+	if (__iscsi_conn_send_pdu(conn, hdr, data, data_size))
 		err = -EPERM;
 	spin_unlock_bh(&session->frwd_lock);
 	return err;
@@ -986,7 +1021,6 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	if (!rhdr) {
 		if (READ_ONCE(conn->ping_task))
 			return -EINVAL;
-		WRITE_ONCE(conn->ping_task, INVALID_SCSI_TASK);
 	}
 
 	memset(&hdr, 0, sizeof(struct iscsi_nopout));
@@ -1000,10 +1034,18 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	} else
 		hdr.ttt = RESERVED_ITT;
 
-	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
-	if (!task) {
+	task = iscsi_alloc_mgmt_task(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
+	if (!task)
+		return -ENOMEM;
+
+	if (!rhdr)
+		WRITE_ONCE(conn->ping_task, task);
+
+	if (iscsi_send_mgmt_task(task)) {
 		if (!rhdr)
 			WRITE_ONCE(conn->ping_task, NULL);
+		iscsi_put_task(task);
+
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
 		return -EIO;
 	} else if (!rhdr) {
@@ -1870,11 +1912,8 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 	__must_hold(&session->frwd_lock)
 {
 	struct iscsi_session *session = conn->session;
-	struct iscsi_task *task;
 
-	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
-				      NULL, 0);
-	if (!task) {
+	if (__iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0)) {
 		spin_unlock_bh(&session->frwd_lock);
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send TMF.\n");
 		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 7baffeac279f..b3efcd318f47 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -135,9 +135,6 @@ struct iscsi_task {
 	void			*dd_data;	/* driver/transport data */
 };
 
-/* invalid scsi_task pointer */
-#define	INVALID_SCSI_TASK	(struct iscsi_task *)-1l
-
 static inline int iscsi_task_has_unsol_data(struct iscsi_task *task)
 {
 	return task->unsol_r2t.data_length > task->unsol_r2t.sent;
-- 
2.25.1

