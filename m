Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0040CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbiCHA3I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiCHA3F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:29:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F02D220F1
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:28:09 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227L6s6d028218;
        Tue, 8 Mar 2022 00:28:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=N4jkZysATB+z7KttZcm/s5CN+lZxxRYfe+fqa9hAyOY=;
 b=wzXfUn6VYMoC7VsApQo0/3g97DahD79vdhjD+yzsBN9asu5Z+8FsJMHlsZa1qVcrlaP3
 i4xL6rVV6GNeu2Of5VtI9Pg53vk6BoFmrWwq7ScX0/nM8ELVHhc4xGWV2nAHb6fj5uqh
 Eud1gpwtwDF2yRJL268EME5rRL3T0yqQebQIOr/CUhM98TDTAZwvckksHnPrxJvfwPQY
 aTW27tuOgy4gg7BtUgf8SWsLhalp+cZuh4brgvMvQ8KX35dKcA9p1iKqCxZTxOX1FKtn
 uDsMPs1FzrTWxK97RlFpBUaR+PQHH7rMSLHmyHCK1hNW3w+KU2KdYtvxc5nPfy0VuI0T dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn2dk4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280AJ99134548;
        Tue, 8 Mar 2022 00:28:03 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by userp3030.oracle.com with ESMTP id 3ekvyu3hrq-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:28:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWmSjiuigDas7SadKChQdDVYRhcZp3ewWOmem/6keYrPVHJIlG89E61nR2ULhOL3N2O7GZeweXZUQOQxkAekwznXyokJ2A3uF6tV3gvwe9/IwBdu/ffcJxKNpvQq/mkS+GOJNzzbzTDSOfGQmsHIah+dIKlwASH6dMSXliGZm0XFQ26s27jaZ4cxj8x/Mul2APM5dIUsbmCwSsY5BopgaEbBZ6sz6P0Kmhq6O0JfsAN37VIMrhbBsjJiVRuVFn+QViRU95i0JqJ6sOMJVGE7lYl85AcB5xfnGPivi8DN6rHZkkbQ9LfL5jBsjWZ9TPYa7mNfpGVumHSF9lTaSs0KOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N4jkZysATB+z7KttZcm/s5CN+lZxxRYfe+fqa9hAyOY=;
 b=OVrFXRm6zndoFT9ShgqGhDQSJenvHNXyS1/Al09syEItPl1d+PqXTtEyUh5H/UOAnbzGbzl/MZRRbDygJQRnWkkbM9ybIsjpNuYgh94Tzl7pB2/zi1YULuHgo+Gx4APxtldZwixjUHez7+4+xkpcOT3QTDgehfDPjvkru3RWxxZOFO7TEH0PVgDpPhnze6NTWKJrftpOzCTztzUNTYOWhi12aYIesRcxZ4xCPQXskQcOzfkcsyRB2KO2JV+TXWzGNjnIKAHy+7387YxA9QTHzxbhZMKheLdk3WivBYXUqnzKsEN4Q0ctUjAO9nkwN33qbdla05+gWvruaYd3XCvCUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4jkZysATB+z7KttZcm/s5CN+lZxxRYfe+fqa9hAyOY=;
 b=0NX1w8oV5QQoQuaDw5Gyo5WILhcb9M7b7YdtGKKrfnqHk/aJXmuNpFEj7/2LILN0lAX3krdBK++OrfVx+uAdVcK5htQcxLYqzBVzGjUIT5ypqX3T19qB3I2hHCmfRmryTvAlD+f2SEk6N0uIas32EqDQvjNteqeWT0rnBYYa/lc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB4361.namprd10.prod.outlook.com (2603:10b6:5:211::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Tue, 8 Mar 2022 00:27:58 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:27:58 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/12] scsi: iscsi: Add recv workqueue helpers
Date:   Mon,  7 Mar 2022 18:27:38 -0600
Message-Id: <20220308002747.122682-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308002747.122682-1-michael.christie@oracle.com>
References: <20220308002747.122682-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::30) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1621242-c547-489d-c105-08da009a7e75
X-MS-TrafficTypeDiagnostic: DM6PR10MB4361:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4361DCBE5F9A40EF5C64F98DF1099@DM6PR10MB4361.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kwZ63laozjbjsMQB+KQfnJxPShEyr8X/T3RqxUN6LU3+iBdrgTIZVeupJr9XYURUm0vamTN5Dt7jv2k0UkAcchjGeM9uhnirDkiskLcGc7fKPBdmU3b+/L37LOQrKfvbEoM5NtvvGLIDd/iX7Z8PznQdrEJRQs1bvnbfQK0f/B8dg3jLVCUAkUpaibdJZ//qlH2wcjYo38TQCokGgRzB7EZm7e8zk3/SWLO53FVDlAC24VtVLQZRW6VvKOZ8QzOq1PIwZexXrokI/oxX4AHx2Yzqmb/KBKo6Qi6BRM6cOyfhzsMvxLdijTgpeeN4mNjp1NJoMEb+VQqDeID7UD2KBVt3/j2z4ZFymwvzoyLXfpMFaRT29tT/DlpurrOYRdoZ9HeSJfhJichIgvCrda+e5l6N0zbBnvo/KVkU817Y2KUo+lVZlEAPdPp9/Rppfgehj0kWWToLQ6M+xGA4ItlWjbBC4+R2y0WhqHKH2JiO8o/tuiHx3K1OxYshb8PM1deBujP2tY+joKqvq2gq4TuBCcqh3kFuW3DtRntWUrPTh+IWaoA6CdRHjhMa91Nb86YTcJpN6coxjTkHRr22FtgkG+zj//5wWApUKl67AlkGlp9xieHpSPpvAb1veSXlONqVTUk0DIkJ3/akOI1sAH95K4i4kmzimUcff/PxfcpOUgP1m3rocYen/ddIJltHl3Ahow+IQNZLnOkaXKaX86hgeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(508600001)(6666004)(107886003)(1076003)(186003)(52116002)(86362001)(6486002)(6512007)(83380400001)(6506007)(2616005)(8936002)(5660300002)(38100700002)(66946007)(8676002)(4326008)(66556008)(66476007)(36756003)(2906002)(38350700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EZi5U/3LbHVcQCDQWLgAwepHkzHmoQjFCHbeK44nTiYe9xThZSlOPp0Lyw0a?=
 =?us-ascii?Q?6aEfgt5TrXu/BjmAw/dAOOjDqgfPrs+kaeQvNJBQGDA/YO9TDzXWeucN+ae+?=
 =?us-ascii?Q?5TXAX1a3Cd5dbo68BDUPgra+AP1XqlzM0+9+dkN8+EP+gdu1EWFtRsq9+EKx?=
 =?us-ascii?Q?5VpQRnXitnGOjJTSCdF7AA4lWdKHrjdQcrZMjOF8TwtztGf7oo7GXfxce9Ew?=
 =?us-ascii?Q?nHPtZpr2Q7rjrbxei7mn9tLSMhjYG49BQrrkwjGtMPS8S0D/snr37tP37xh8?=
 =?us-ascii?Q?QR7+w68/nr079fK1NOym1QpvW117dbkRHDU1NqPBsODJXEYcoZQcgjxLqWiZ?=
 =?us-ascii?Q?N5iRFjY3g8btYwYBsrZBDXv7A+N1w/otjSiMI/Pn1yGKDvrQ2ditnUJM5MJS?=
 =?us-ascii?Q?C4zoAirzc8b6RQ8FkNLUsg/B+AFcLzEhvz6u0tabx9TusfMYaVS4DU507D1V?=
 =?us-ascii?Q?5i5j9KQEuQ6liyNGJxPWO10yZfwNIZO/FlPJYHo2vdKKXDliiKN9ZRQPNYKJ?=
 =?us-ascii?Q?fZ+aH5Pn2mcLGDsKZRTqsjcE8i9GBDX28oxk0JFVkv53t6AuZCSWMEUY+k/c?=
 =?us-ascii?Q?PdKIWSRo9NimUR4OTzKQC0NUaTiM9QLRFBwlPi+Gxrv1U0la5ICtQKIMiW1d?=
 =?us-ascii?Q?OHYgH4JifOY9AYPKtzlNPWDahFWnI7X3B0yfEUKZHR43R3KWuuOvMHqUwDA8?=
 =?us-ascii?Q?FJfghNY7ZVNh3F5bMAbbOjTkoecTK1U43JKHfpSP6YQ6lt90dcf/8etLD69u?=
 =?us-ascii?Q?6CDHdWkEJD8DMSLepl75PzdnGwskHZmuxV0FsgcE6LjyDw+FcChguhKJ2aZt?=
 =?us-ascii?Q?bBJhnI8qwVzTCUpJkBomap83f12uGeCYjHmV8YUSKrNQnmjZ5+h2XpjTn10H?=
 =?us-ascii?Q?rinHIzb6tOo+w1zL05k8Qo6rRTUn1QpluqByaQNhpPL+wNYStH0odPCBZHwv?=
 =?us-ascii?Q?D6+yXQEHukh3nXrqadSzdyHbpWnC9FY0j4T3rWhM2X1z43bQvmaHt8wSkb8P?=
 =?us-ascii?Q?X3jA/BLdnrxWjAvyt7TcOrou+Kf8mMlvlGBBHcNjotfOWlSGJmkZiAirXl9g?=
 =?us-ascii?Q?wrxKh2eqni7KfJuvpDrgQL7Ftk3G7PY+fzl04c+J1+2i9qD1HnzoAQ6tIRcc?=
 =?us-ascii?Q?0MR2U646CvmISfbS19n/CjLV8zXITbPWPYH83J0rltGngTm6woc4NBqyt6g1?=
 =?us-ascii?Q?i1lnMKfJUAnPS2ckGSaF6+YK3XC3SPWC51b2fyLU+gBo0c/CwcdpN6l1ZWOi?=
 =?us-ascii?Q?cMtprEXS6je6S3gbZvJk2IV2eGDbrvLgnQXLGJymBiT1ShsJeOsW++oX3mzP?=
 =?us-ascii?Q?1DCTzQVyKUjN72xQ+LpnXm4vFUCzV6Z45EownsU1Buf5yXlSPUeTB/VN7rni?=
 =?us-ascii?Q?vpMAS/dkoI0vBrkgZE2+pg5QkEjuHZlNvcHvfT8Lz/KmQeUhSPwBW8sSvhUX?=
 =?us-ascii?Q?NdCurc6pl/rbM6yUMy8PZfn4G869SkRGZuyODsimFi3fxSkgoFIs3PJNR6FJ?=
 =?us-ascii?Q?sgy2c+KKqy6MMQqRHZqgxunrXNi287Jd610iSfn2EAH0ems4AB3oGi01OTe9?=
 =?us-ascii?Q?h8/88dfaYxOOMorG6VB3/SHggCRwpL1g5bmnyDwqQ7hAY95nU5FssUJKT2my?=
 =?us-ascii?Q?S7b5HErihwDOKfh5GcmOiIbP0SPc3fQJ6dOswBuEvJrmolgX6wjb8POGjBey?=
 =?us-ascii?Q?mI2N8w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1621242-c547-489d-c105-08da009a7e75
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:27:57.3893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WnWSC6fubL2tLlHlI8T65YfxGYY+fnvu6dTcXihqUFlTaSyxOlnGY1HxLQ93PIAk8ejTV/lJfm9Nd+hwTfdgKwjMKBUgjAXAxndRNlPT6Sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4361
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070121
X-Proofpoint-ORIG-GUID: DLvzGtXneHk-heXcui-sj9dQ_f2ZG_E9
X-Proofpoint-GUID: DLvzGtXneHk-heXcui-sj9dQ_f2ZG_E9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add helpers to allow the drivers to run their recv paths from libiscsi's
workqueue.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 29 +++++++++++++++++++++++++++--
 include/scsi/libiscsi.h |  4 ++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index fa44445dc75f..fec64cbfa4b6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -93,6 +93,16 @@ inline void iscsi_conn_queue_xmit(struct iscsi_conn *conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_queue_xmit);
 
+inline void iscsi_conn_queue_recv(struct iscsi_conn *conn)
+{
+	struct Scsi_Host *shost = conn->session->host;
+	struct iscsi_host *ihost = shost_priv(shost);
+
+	if (ihost->workq && !test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))
+		queue_work(ihost->workq, &conn->recvwork);
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_queue_recv);
+
 static void __iscsi_update_cmdsn(struct iscsi_session *session,
 				 uint32_t exp_cmdsn, uint32_t max_cmdsn)
 {
@@ -1942,7 +1952,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
 
 /**
  * iscsi_suspend_tx - suspend iscsi_data_xmit
- * @conn: iscsi conn tp stop processing IO on.
+ * @conn: iscsi conn to stop processing IO on.
  *
  * This function sets the suspend bit to prevent iscsi_data_xmit
  * from sending new IO, and if work is queued on the xmit thread
@@ -1955,7 +1965,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
 
 	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	if (ihost->workq)
-		flush_workqueue(ihost->workq);
+		flush_work(&conn->xmitwork);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 
@@ -1965,6 +1975,21 @@ static void iscsi_start_tx(struct iscsi_conn *conn)
 	iscsi_conn_queue_xmit(conn);
 }
 
+/**
+ * iscsi_suspend_rx - Prevent recvwork from running again.
+ * @conn: iscsi conn to stop.
+ */
+void iscsi_suspend_rx(struct iscsi_conn *conn)
+{
+	struct Scsi_Host *shost = conn->session->host;
+	struct iscsi_host *ihost = shost_priv(shost);
+
+	set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
+	if (ihost->workq)
+		flush_work(&conn->recvwork);
+}
+EXPORT_SYMBOL_GPL(iscsi_suspend_rx);
+
 /*
  * We want to make sure a ping is in flight. It has timed out.
  * And we are not busy processing a pdu that is making
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index b567ea4700e5..522fd16f1dbb 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -201,6 +201,8 @@ struct iscsi_conn {
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
+	/* recv */
+	struct work_struct	recvwork;
 	unsigned long		flags;		/* ISCSI_CONN_FLAGs */
 
 	/* negotiated params */
@@ -440,8 +442,10 @@ extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 extern int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
 				     enum iscsi_param param, char *buf);
 extern void iscsi_suspend_tx(struct iscsi_conn *conn);
+extern void iscsi_suspend_rx(struct iscsi_conn *conn);
 extern void iscsi_suspend_queue(struct iscsi_conn *conn);
 extern void iscsi_conn_queue_xmit(struct iscsi_conn *conn);
+extern void iscsi_conn_queue_recv(struct iscsi_conn *conn);
 
 #define iscsi_conn_printk(prefix, _c, fmt, a...) \
 	iscsi_cls_conn_printk(prefix, ((struct iscsi_conn *)_c)->cls_conn, \
-- 
2.25.1

