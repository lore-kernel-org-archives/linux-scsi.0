Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE0FDC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 00:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiESAgL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 20:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiESAfh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 20:35:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FFF195786
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 17:35:36 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IMIrZ6005352;
        Thu, 19 May 2022 00:35:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=rwVpXPQz+ovPXjwqTcFprCI2d0/MaY6/euKpOGg+E68=;
 b=v4eCxmDaTTpa8h9k6Ijx8dLzgaHFajvx4+sSOqVGJwSuVISEeHeiXzLdFsM2O8yPag5f
 G62X5DxVEnS68zKcqXvgVjhVjSpjZVQg9iyxRY3ryDq5b/bF8eSANXlM5O3A4/97AZ42
 TUgC/jCatAClW65J8iz+feup+cLUhjNijBT23NQMxQPiAkB0D4DfnzFzt6+O/u+MzepX
 Pz5i9KvOn9L4NB+L1A2mdKyPZ4x6POq6oOeIIVV1kn1sRZy4PSW6xA52w5E2k0/aoJBR
 hb/ccDUMoQHAF4kfH7pa908FRpnPq8k8Q4aEeyxOZJYNBVQahAEMX+f92nHcPmFqJeDJ UQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g23723165-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24J0V4VB015306;
        Thu, 19 May 2022 00:35:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v4s0u2-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maFXJ+S0PQ5KD2PvLqSi7zidBXaMvnc0F6pOZC275d12/zmAixdTPgIBzfSi02Xqo5N8RT6hBYTayhlbDM7WjVWAAqyLiIBNwaLY6pu4eubQsdIL48qnnK7U/3vRWDHdE72TXTyTNI47YC8cuhBAAcFeB2V4wYXHZsWy7Ra64zNLWgrrJWv14IlcsTMkpySs9fxqME+WnDoEiF2cZnEBsEWMJiPOqnmKxb0vndQ9N6DtZbH1vVkfvmQr7H+GRLTmXP4f0xoP8LlLZeFAdt5UiqTYHksaMKCUMUvFWXCXn0/uOwERL17qeIU1dwyE468EnWFDidfOEXeRt8N7GGZshg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rwVpXPQz+ovPXjwqTcFprCI2d0/MaY6/euKpOGg+E68=;
 b=A51VqOYcyUNbUC5GkP34bgbGH6+qfMqhfeJtZU2FVM5H7dm2ypPEEjxnA9wlAJ12vqTyOxZvkc1jw+CtGuf9gl1NmNArqv0PFaORE/wLWRC3re5TT3MlzzTXeeSA6NF9b5DP54YXVWFVuqv6uhrh5p/XINDnD19zKtohYDOhJVin/Ai/KbyKp0YllQ7Hn86UuK+/AEA/sHXfKr5rKLdElMDSz/33m0qUt63awrQgUwNzgjuGQBiCbEhZP+gdgqo7MCV5+eAcr1Yeol1frOi4SeZdN5j8d7e1sj5IxaEI2x/jZsqAyV6y3Qmv64BmblTDEirgVcnWnFpX1UQnsiHa2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwVpXPQz+ovPXjwqTcFprCI2d0/MaY6/euKpOGg+E68=;
 b=OoT+HAd9APfkgnlejwbgvbnkDOGTpg92yB1XrN7m/Jkhn3wc7Hmeh2FODR6sDUO8Vr8CcSOUuN8H4cEzAF7ax9tkFHvGeKmcqCoJddwppZqvMprF2TT65LZocSkqEzF/iIW/ym0b5ARm10P7Wv3C/LxiG+0v3myu/ep6Wne/hTs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3020.namprd10.prod.outlook.com (2603:10b6:5:67::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 00:35:29 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 00:35:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 06/13] scsi: iscsi: Add recv workqueue helpers
Date:   Wed, 18 May 2022 19:35:11 -0500
Message-Id: <20220519003518.34187-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220519003518.34187-1-michael.christie@oracle.com>
References: <20220519003518.34187-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b897a9e-3c0e-4a06-146e-08da392f7917
X-MS-TrafficTypeDiagnostic: DM6PR10MB3020:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB30206A8B01B4727776B611F9F1D09@DM6PR10MB3020.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Os5VNYBydCOp2C/kTgwl4NoaaN7kLHc70Z9CyglEIUwFFy8aDohpbuVoOlA1yxDRmEiO4rhxq+8G/TJ/yQ+N+EiFblPmF9ah8LOrHh/YoABCxuxbx7/Nib34F/VIW/4nkE3mHWS0mNjG9tQ9Y7ZbwdOiQXE2SxkV1amYtadXdIUjWWUG01rwlI1W30RsLRs1YwC3aql3jfI1oKlGkFb6Mq2Wo8r+HeIK1Iu/7Wok8MwX0T9iIW62jMQVPm5zhAePvha1bKmlEpeklRDkklu+qzd1qireyVA+0rC5MjHEpaM6WSQe/DKogMnjO/hwT3rnjcda32CvSmrPcBXKqsGQZmxBLyd1wvnqL0w0a0H2vBFjGNnj+Pf4VgVRSb7sogOgd8a90OmgiIh0gB0cHyyADGH6tBz8rObNrw/6B/EUoEn2eCqUqCuPxLj9SAHu5Gjy4C43fe4WJyQLUI5qgMFiourKDFL2yKbk/oi2mshaLav8w2os+1uqc/ShthbrFMAf29tP8mZzbrnFUzaqQgG5GMiXTrI68X7+9Xf/sGu40d+okmUC7Q5VGqGBZkRn9u9vPm8WITSiDWl5zFaAws8oOW7tGNivolrxKfUD2ED/eTs/wHRUd/lnRm1+EaQuwqZoWWqMWV24uWO0/5zazXTzyGKVDqDPTsj8nM8RyaV6DdXYbQ8uXLmMHdcWskB/EgL39jQuNCbPjrAPH3DfQk5mA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(186003)(66556008)(1076003)(52116002)(2616005)(2906002)(6512007)(36756003)(26005)(107886003)(8936002)(66476007)(38100700002)(86362001)(66946007)(5660300002)(8676002)(6666004)(38350700002)(4326008)(508600001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8snS1otmEoJNKx1BA0c66DyXDqc2MmKHkXmLfhqA3kh4Ibdq7F68nUssqgFq?=
 =?us-ascii?Q?mhL5SlIeBmX+LBsoSZFb7wLk29JdGSqaDPFnTa8wwTJMaAv9wi3ddzbLWgoa?=
 =?us-ascii?Q?IYul0veQuBowBQxrPPm8jp5YdBsq/YXe+Rh+OHF2gQWW11YWTGbrW5KrtKXg?=
 =?us-ascii?Q?AfeJX5RZWSwSUdgAKB6zG2ubKpHl1m05fC/LM6R8XViUlEDZsMtXNx3V+VNT?=
 =?us-ascii?Q?y4oTs68K81qtswheQELBAXB9Ly75r++KEMDJMnTpjvQObSASJjHTAA1j+y9E?=
 =?us-ascii?Q?dSrDug44T0vXg9+2PcxnW2BmHv0A+LQccV1YhpoUHlru0zA2hUbTAgsNHbex?=
 =?us-ascii?Q?xWVNWGfFag9X8hEveL6re3MwF8EgkUFyA+kxarkQI1wtvQJgdfz4Y58BXo8c?=
 =?us-ascii?Q?11mtY2722EDO3tN7eKLKzlI4a3pZLbAvnR7w1pXZ58r0irm5282T01+Rv7cW?=
 =?us-ascii?Q?ThVBxHOMgHrRPIm9uxi4Ru4Fi+VWIVEjzmt+Ry5lCbXW1O2ZFCQ49A23R9m/?=
 =?us-ascii?Q?XfHyUXbhL40PoSO2KRSteLx1AYP6gJh3Zcfa9ps5gnW/7ZJd3G9ug/rxIgqc?=
 =?us-ascii?Q?Kq/QL904VnZJEUK3qRJPx4YE5HL10WCOylQlhpOiqKpQXJp2KWThRC8tOP8H?=
 =?us-ascii?Q?vghhRYM6iC5eY8Fs5Uiu+7V/M2pULKN9bDtgl02X3PdCepIIz3Gyws4UketD?=
 =?us-ascii?Q?vqh95yGZ3kdzUGxwVUoBy7C7CCErfHeXftYsPcu8Y2ae1Bx1JgiFtjn6hCnk?=
 =?us-ascii?Q?w/OQeGlD4MvqDMaoslCFLV+TgLcEBcfjFnJxNOkvVGw29W8THPjKyIS1AaW0?=
 =?us-ascii?Q?Vu2gJLDwhU3ZI1yH/b2oAOs9X++dAOkVlNsmNJZQ089KZ6/iEv+JNHeOauVj?=
 =?us-ascii?Q?9RLDPVCzQkvVm9zoTkdsuQTjuQ3kzpyGbfnQW0bLvuQG6LWhzobMgPu6cTsR?=
 =?us-ascii?Q?z+mFAoTyaiSoSz4uPfUMFddLtB8fqyV3k+XiAMp6itLc8RElEoCIjiw5J6PC?=
 =?us-ascii?Q?Jh6j2jicgi1uE9gs8dOd4OtVQmdNTkmZ7cuc6e917s1rM0NL7A4hngL3NzFa?=
 =?us-ascii?Q?MGWAQoZT3OKJMNX4QGQjwgn98ceIx1hQPAK0l8cj/g0x703C3qM2OsbA3/bB?=
 =?us-ascii?Q?HwX7YNH2YMevi1SeqyCpsJSfuVtNQsqjKRO4OAxtJZ4KETNHe1jqvMk5qMfC?=
 =?us-ascii?Q?rhw6YVK0HN6vDh1sOrWlgBudrPOtrUzt6TVvlOhdeGdqk6tGH/eOipUE1Ze5?=
 =?us-ascii?Q?yGv+E7obFIMBcDyH75SvljVkqs5ugubwhd9wNFLs3FlaF5bx/2kBPGGqFELc?=
 =?us-ascii?Q?bsgQUcpXYIFs5jP6gjD2Ai3glFQSAa2f0F39C3rHYBK3BTa765COUgLyMtrk?=
 =?us-ascii?Q?dtZ6L8TWrAikGwPD6M4LoooTz9C+yXLkS5ciBhgSapyPC8fug4suQCrZyZKa?=
 =?us-ascii?Q?s5ywoRvg488HzMVmLB0yewM7i+wXmPzlDWNrKwff8+ljJ7n7SBIVvjZ2tRZK?=
 =?us-ascii?Q?7uTNsDI4JfuvVsn6FbKZaI4Iodz0zduN74CDPcB/abythTu0DRpeIxr+GcJL?=
 =?us-ascii?Q?6H4k0oxrHF/XkhubS6OPhvduspGgVm7jjwxFFsCcY/y6QZFNZebJZVLxM0FY?=
 =?us-ascii?Q?uVAk6AcukOoKItA8PeS4NWsjUqJTZhloambXrNMulLxWMwITl0LomuZUDwIs?=
 =?us-ascii?Q?AeXNaCDTK+z3S7gho2Ypr+TfrixZtmtCnrGlUKJHM48/tbQLsltJcz2+6kyJ?=
 =?us-ascii?Q?jLR6NqL1g+8Rn2HHPPmJhDedgys+PgQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b897a9e-3c0e-4a06-146e-08da392f7917
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 00:35:28.5398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FLjDVnsa+jKowjkOE7ayxHrAxlLvA6XVjNFDDpO41l82mW+ADXHqOCE+57DkoGXAAXlQHF/rtwhX9k/eb7i1yh6RxvdyQcJqppypIXHdo5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3020
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190002
X-Proofpoint-GUID: kltPY3xGDSTjHZJ-HJJkr-dVfAMVyv4_
X-Proofpoint-ORIG-GUID: kltPY3xGDSTjHZJ-HJJkr-dVfAMVyv4_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add helpers to allow the drivers to run their recv paths from libiscsi's
workqueue.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 29 +++++++++++++++++++++++++++--
 include/scsi/libiscsi.h |  4 ++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1bd772d9b804..8f73c8d6ef22 100644
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
@@ -1943,7 +1953,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
 
 /**
  * iscsi_suspend_tx - suspend iscsi_data_xmit
- * @conn: iscsi conn tp stop processing IO on.
+ * @conn: iscsi conn to stop processing IO on.
  *
  * This function sets the suspend bit to prevent iscsi_data_xmit
  * from sending new IO, and if work is queued on the xmit thread
@@ -1956,7 +1966,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
 
 	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	if (ihost->workq)
-		flush_workqueue(ihost->workq);
+		flush_work(&conn->xmitwork);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 
@@ -1966,6 +1976,21 @@ static void iscsi_start_tx(struct iscsi_conn *conn)
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
index cd1049393733..1e7c5c7f19ac 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -213,6 +213,8 @@ struct iscsi_conn {
 	struct list_head	cmdqueue;	/* data-path cmd queue */
 	struct list_head	requeue;	/* tasks needing another run */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
+	/* recv */
+	struct work_struct	recvwork;
 	unsigned long		flags;		/* ISCSI_CONN_FLAGs */
 
 	/* negotiated params */
@@ -452,8 +454,10 @@ extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
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

