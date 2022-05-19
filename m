Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E6E6C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 00:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiESAfp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 20:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbiESAfg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 20:35:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACEFB0423
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 17:35:34 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IMIqx6007842;
        Thu, 19 May 2022 00:35:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=aP28afUftfGNFLdlhzChriGKi3ybIJWdm/D4+7lFQyM=;
 b=Tj4toyiOAmu1318A9L9t+c9qx9kIVrQe1QDYDgxdpWJn2l12sTtieh/z1Ubrx/4od0SS
 kn3imonFusQMUAb1KeIma5CaDjgI9dz8RytjsgtxuHkCUKpZTBosG1a2YDxtJM2Luil0
 TjdqYW4ycJUwRmBI5ItMsDQZl2D5uFdMxzRddHvmFVt6ix58NeF2b1TXBDkH/C0h58ny
 Epj6ohTbw7MDygxzFXG3T16nSvDNKRwJ6xsK7gY8Dfp3DA5Z0o78neSxXr+h478HbczO
 NiWtp2lC7PBxT0pbnwQwG8mG3icazRl9jf26oGD8mUcH1dQaCmJgiujLY/Rxy5CraPgG jw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g22ucajj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24J0U2SJ020228;
        Thu, 19 May 2022 00:35:27 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22va9pcg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 00:35:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZ78R5oU8aUm/a2kj8lRxrVMZZgBD+xUePDUwn76kLx2p1RBTWHUctRs78E/m3kM1oETI4uq+wI7bHxxza0xP1U2+cKvG5rWirShjmiqKWfSTnVEqH/ArmOpV9Z5VUxXeWtnzb8IzZFL0JtpGeFd+9+88WIW4P7WpTzMVGkNKvoAnXc6YIYc0AmBE10C2esNyscsj4n6pObM0OIXR8Nz2BB2KKej5GdLK98qmHGRPEtHOJMXOUrb72WduufYe+u58zPvKpaiouo3m1iaaCRmgllW/Yf8PxyKDTFy+Xxawa7UfjmQ4Bn1SwR/Fx3gvb2yUlzonHTKV0m7rKh50izxgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aP28afUftfGNFLdlhzChriGKi3ybIJWdm/D4+7lFQyM=;
 b=S2wqCo0k8b1Ebh369GjgRq3RYfQdLLrYHs07k4rN8onzaEaH3f/XvzPp8WGVazBhJ0iKnlTSG2nxC1fQ5K33I0wvxDUznKlmqYoBXZ7McFI+ZMoSIJ6Bcg2Jj7wISUSXN8cdEBybCrha993uZXrFgVT4hS2tf2T8LKZ0D501wN6Dk6U48XW5loiiOWgyM+ocOcLNIjF//ZYHuPyJcE54w1Hi8Hy3s6io4hr6VRWsT/Dhf4sjPPyKpYyndO0zLaCYUaAyUmGDpeMaBB4+8o2kJman5IUjhL84JuUrnJdAryT8dN7HM6TM6aKeYoaXtdWb8rrogzmYr4utflvOV2gAkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aP28afUftfGNFLdlhzChriGKi3ybIJWdm/D4+7lFQyM=;
 b=0BRZ2y6tscppC6I3XKGVjewriXOvC/+LZxSQJpUg777EML+KwWYGp//eJweMdIFuNl6Rfm38ubsNlzBvfbBhB3zUUoAud8Qpz7G94ajJWAsJhEq1vsbiN5XlynECC4Ruk9QLL4YVghtCJ34Jx478jpJi7EXR3fmTHRJ3lAdzpEE=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3020.namprd10.prod.outlook.com (2603:10b6:5:67::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 00:35:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 00:35:26 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH V2 02/13] scsi: iscsi: Add helper to remove a session from the kernel
Date:   Wed, 18 May 2022 19:35:07 -0500
Message-Id: <20220519003518.34187-3-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 97644ddb-1a6d-40c3-543c-08da392f77aa
X-MS-TrafficTypeDiagnostic: DM6PR10MB3020:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB30200B72E204D71FF3A8AE27F1D09@DM6PR10MB3020.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: douPfuZcUwbwCOspMXyFHpalUBqTSW5WV/GE2c7NRm4n+j78sfBgZQRtXVLdGgMmrk4ehfdFdcVHZYrfNN5N2rsOegG66ZBbR4uoPpEBe9I6cggubFCM2F8AXfPQ6CESECvvqJyXXw6VfSyhA3Zu/CZ7bvG2OydxUPPDP8Mhg6jFKGB9CixY632Z9aYQmNKx6NsiM1yskq0xtPV2HSI+teLbUmVBnOKm3eOpjQP+3CGMjaKAuweyWnwCbGqtMc5mgcT0FdC4OgDOignQizMzb1gQCI5AaGmYDNnT8EXhhW/9hCaEgJinbp1AZ2sNlrk0j2fIn6OpjpB03cEViWMI7jLMrk7FZMIOVAnqNMhwHv9GAclPFdjS91dZiqdC1v9A5PnytzH4vQkwyGY31G01yK+dzDYJBcIfLURGkmKD9SxcF2hVVjY53vvfoqMD1HqQ909ma79G7PFxtZH8vYJjwNgnv/TdWNIlImeAb34d0zdNevVo8zSOieY2gDdRa9GWwl3NZe7J74UDzgc6ZTgPaKzH2rsAGFHlX281V+jvFhMVD6VpmxGrCKsthSr7twedmCX1YSmPD0rbfHhMVUp58mGyhEMomBClMDIUXTCf5KCyJx37Ih22lsEgATt4CRWXIajeYddRjT1Q1mMexQcJkk7IszDqIuN/F9V8AR5295vd+IJqgcJaZVFZJSRC8HcuwwGC6vxp83E+1uo7RVLQMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(83380400001)(186003)(66556008)(1076003)(52116002)(2616005)(2906002)(6512007)(36756003)(26005)(107886003)(8936002)(66476007)(38100700002)(86362001)(66946007)(5660300002)(8676002)(6666004)(38350700002)(4326008)(508600001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C5G3yQYFYRZ3PFU/o3V5nfMLAPSgIJTdcJxZZBKUBzuYR4OWvNTK3hXcmfJh?=
 =?us-ascii?Q?aFQ12ua6W3M32CVD/yVVwGz0WPFz57OD+MkkCC9qCLhNvpB8pePHcyQDxNzH?=
 =?us-ascii?Q?OlwoFsKFWTReFLo0hKQzcDCS2w55E0GRIWxBF3DZALFtMWe3pYS5sZFuFKOL?=
 =?us-ascii?Q?+1Yiu//XVLgGqBDart1+yOEGCPjGSNOXgUF3/7pqLS4kJ2D5ppHT9Agv1Yzc?=
 =?us-ascii?Q?OX7h7+qNSkPe3OFmICcS+KYtwq6Oh6d2oijHwo5oX7eSUmJLzDyROdmSpNVs?=
 =?us-ascii?Q?667Vn5meRCgLv/9rzGrv1spWW1v8Pq5zuKONAWPRgdP7f6KdQHjYQrl3HBUF?=
 =?us-ascii?Q?smZzzeMZcpd8QA4knh/yMZdp7xJYcH0tXVxb06d/cU6du+02gGGCwKFlC9e6?=
 =?us-ascii?Q?x2Pts59R9jI+hf2ebqjlK3p6+JyxvbDw8B3vAHbxQMv+/oYC+E/FRYP+/WdJ?=
 =?us-ascii?Q?+SQZHA/cCCvmp6n+nGXwhKSFTs3KqvXI/spd61veo8hBrfY7SJ6IaWMz6NEo?=
 =?us-ascii?Q?LBOWcL175rPuELSoZwTt1hFn2pSjECFRcLiatRGakZAmQbUjn2FwWUjVYQ6Y?=
 =?us-ascii?Q?19z8E5rf5VgQn4Ug/e7X5/DplgF83gbJFTAACzjvgOszKWg3PyGY1UAoYjkp?=
 =?us-ascii?Q?4C3mwP2pnZjS8cfqLOcMSRSXjL0VZ+TO1iYLdiZ87jSUc6RwAbAOzIJFbE4O?=
 =?us-ascii?Q?zrBAHOi6WlhU5WrlJ4fHKJo+bbdtuZ1eTl+Y0PqQURaoE6kuofjR5wdbbsYF?=
 =?us-ascii?Q?G0fJl7SPY/eb3pmQzxsG64XxlImlHdfRfhtt4N/noBvrVO4IbekX8tBnKBjr?=
 =?us-ascii?Q?1cAqctwrwSqwTRXraw4RJFBHEZQCkgAWEoXXgE8onbQ6i6Ex6DnGDLL0fgrK?=
 =?us-ascii?Q?f+cjphPQomKkg77oA6R28vdd33ZpRfg6zJRrq6nDSb4DOUhoKfLUxrgkg71P?=
 =?us-ascii?Q?0qOIv5ZO9ztQsK5kqWOgDcRmqTdixbQyOwqDt5EGzDHUCSjwIUejkPPQEBte?=
 =?us-ascii?Q?EWNeVlnchAfBHQj2wooObL4oVFsyMxroFiV0GdLS9uYE2wJuX11ArjmEiymq?=
 =?us-ascii?Q?5KJVmR8yBTP7b/AX67IFBw1EJ0KUu6DVdvAEK2unVLez0CDxs+BKM8UYavfB?=
 =?us-ascii?Q?sTbCziQ2Hmanef7V33pdUSb0vBwqfcbJHWT35PBQFYLlX/rnox5TxqlT7eFU?=
 =?us-ascii?Q?rz/O4iE6NgEBjamAQ55KNWoA8itFgo5jWowII4eBu+r5g3IAFUkexZcmzzXN?=
 =?us-ascii?Q?C6Xbk4zIhwrJKU1QrqXaYqD4HwZSymRLZ+6USt+nltC9T/mYEg450Dz2hVG0?=
 =?us-ascii?Q?gQmL7WLS6/SooqZrlf/W/mch8opAHkBQYHHokoRd9kX0u2DdJG6H5RM5Oewi?=
 =?us-ascii?Q?N8/CEj1LlxS98bcxmJNSlbqF8jZkmRoNV5ERmGrBHkZhOUj2gdAwyOCnVDLG?=
 =?us-ascii?Q?Mi3r9gJ1O/oSxBr3sJbmFRbCUXj3RSaJnLTCavYFjOU3t4SYQOeH11r626t/?=
 =?us-ascii?Q?dxQhzLYa9SubXoktWmT+1CyDeRAwaxc7T1og8n5BcpHj3mQKATEYpYqap3/m?=
 =?us-ascii?Q?0s/7m7UhlXj0/bEQoafxIh3Gz3Lx92TlzpP/4g9u/Hw2UNPgN4j+3XzR4i6Z?=
 =?us-ascii?Q?YMycf21ClDi7YphW3MynDFRaK3uMDh65ljQCCxI6idzWrXIWNnWg7fH5Mzn8?=
 =?us-ascii?Q?M+h/Nal4qq/4eIPVNPZBwgTtY7S0qyq/gPqLTwbrcjtrTD9ENaFrCEtz+9ZO?=
 =?us-ascii?Q?B6bq0YXgeYBjGNTaJgp4Hebnx1qlDRE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97644ddb-1a6d-40c3-543c-08da392f77aa
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 00:35:26.1337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6C3x2A7sroQbhn/Qb4fZoit4pOT37EXkmmPLL2bPggkaBPlTo3pEanbwGuvWjFBKdWZ2dIPkWeovsWnAD77JuAWpy/OSZ7r1WMXvlT+vw6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3020
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_06:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205190002
X-Proofpoint-GUID: CokJiys_RVeQ_irdw2XXl_H6cm_jGjw9
X-Proofpoint-ORIG-GUID: CokJiys_RVeQ_irdw2XXl_H6cm_jGjw9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qedi requires that we at least tell the FW to disconnect and cleanup
connections during shutdown, and patch:

commit d1f2ce77638d ("scsi: qedi: Fix host removal with running
sessions")

converted the driver to use the libicsi helper to drive session removal.
The problem is that during shutdown iscsid will not be running so when we
try to remove the root session we will hang wait for userspace to reply.

This patch adds a helper that will drive the destruction of sessions like
these during system shutdown.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 54 +++++++++++++++++++++++------
 include/scsi/scsi_transport_iscsi.h |  1 +
 2 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index e6084e158cc0..cdaa54b6f763 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2257,16 +2257,8 @@ static void iscsi_if_disconnect_bound_ep(struct iscsi_cls_conn *conn,
 	}
 }
 
-static int iscsi_if_stop_conn(struct iscsi_transport *transport,
-			      struct iscsi_uevent *ev)
+static int iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 {
-	int flag = ev->u.stop_conn.flag;
-	struct iscsi_cls_conn *conn;
-
-	conn = iscsi_conn_lookup(ev->u.stop_conn.sid, ev->u.stop_conn.cid);
-	if (!conn)
-		return -EINVAL;
-
 	ISCSI_DBG_TRANS_CONN(conn, "iscsi if conn stop.\n");
 	/*
 	 * If this is a termination we have to call stop_conn with that flag
@@ -2342,6 +2334,43 @@ static void iscsi_cleanup_conn_work_fn(struct work_struct *work)
 	ISCSI_DBG_TRANS_CONN(conn, "cleanup done.\n");
 }
 
+static int iscsi_iter_force_destroy_conn_fn(struct device *dev, void *data)
+{
+	struct iscsi_transport *transport;
+	struct iscsi_cls_conn *conn;
+
+	if (!iscsi_is_conn_dev(dev))
+		return 0;
+
+	conn = iscsi_dev_to_conn(dev);
+	transport = conn->transport;
+
+	if (READ_ONCE(conn->state) != ISCSI_CONN_DOWN)
+		iscsi_if_stop_conn(conn, STOP_CONN_TERM);
+
+	transport->destroy_conn(conn);
+	return 0;
+}
+
+/**
+ * iscsi_force_destroy_session - destroy a session from the kernel
+ * @session: session to destroy
+ *
+ * Force the destruction of a session from the kernel. This should only be
+ * used when userspace is no longer running during system shutdown.
+ */
+void iscsi_force_destroy_session(struct iscsi_cls_session *session)
+{
+	struct iscsi_transport *transport = session->transport;
+
+	WARN_ON_ONCE(system_state == SYSTEM_RUNNING);
+
+	device_for_each_child(&session->dev, NULL,
+			      iscsi_iter_force_destroy_conn_fn);
+	transport->destroy_session(session);
+}
+EXPORT_SYMBOL_GPL(iscsi_force_destroy_session);
+
 void iscsi_free_session(struct iscsi_cls_session *session)
 {
 	ISCSI_DBG_TRANS_SESSION(session, "Freeing session\n");
@@ -3713,7 +3742,12 @@ static int iscsi_if_transport_conn(struct iscsi_transport *transport,
 	case ISCSI_UEVENT_DESTROY_CONN:
 		return iscsi_if_destroy_conn(transport, ev);
 	case ISCSI_UEVENT_STOP_CONN:
-		return iscsi_if_stop_conn(transport, ev);
+		conn = iscsi_conn_lookup(ev->u.stop_conn.sid,
+					 ev->u.stop_conn.cid);
+		if (!conn)
+			return -EINVAL;
+
+		return iscsi_if_stop_conn(conn, ev->u.stop_conn.flag);
 	}
 
 	/*
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 9acb8422f680..d6eab7cb221a 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -442,6 +442,7 @@ extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
 						struct iscsi_transport *t,
 						int dd_size,
 						unsigned int target_id);
+extern void iscsi_force_destroy_session(struct iscsi_cls_session *session);
 extern void iscsi_remove_session(struct iscsi_cls_session *session);
 extern void iscsi_free_session(struct iscsi_cls_session *session);
 extern struct iscsi_cls_conn *iscsi_alloc_conn(struct iscsi_cls_session *sess,
-- 
2.25.1

