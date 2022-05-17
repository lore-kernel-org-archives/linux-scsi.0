Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF990C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 22:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiEQWZS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 18:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiEQWZL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 18:25:11 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A59552E57
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 15:25:10 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HKgGle031659;
        Tue, 17 May 2022 22:25:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=nY8RVNTSHmPsi2eTJnAJycvAUOrAD6E5kDu2m1Ajg60=;
 b=pza9fBmmZsEC0BJBMeOARrSIZHnCvkvR2ntQQ8mYQ0HSo+eqgpjZUvOTCU7fm/x2rayZ
 7tgpe+U7GBUo3W8X3MSnKzL4yDwOy+jJOT1LNYlRVFRE4CN3lCnMOsvu90pTkXEfe4yq
 IShDyUmJFH3U5IGdpoG4/W1HKw/N/xdnnZPBswbIDVWlyooTqBKlMJXVBA5w9cl6lomp
 2RdLa7gpKzbatlmaJl5V0jyXgIylawLCWe9LX5w22WhUYNLPZaP214rDeLpeC6jIVFCQ
 8sKGNAPEvNRBmw0xr0FUWE7NgUdc+jzK7K3UyrS8wywlAISfWJMHllcZdy0LFKInz4ls xw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aafjgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:25:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24HMLghx031743;
        Tue, 17 May 2022 22:24:59 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cppmnb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 22:24:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gnhgf0pHxO99wL8jNruOUGxkflIkA7Rc5mRbKjgjgvxe1ozSgXKf4a4XGU9xKXuoXxZt2RCJknE+XIwvwU/n3oflwOtGuI9mn/3Jv02siAzflPKsWxDz754YaiQNNQ/OaReAMOOF/eBeQw1PaWp061P+7sp9QjePKTgQqWkecVE3P10BUEfR1varpKKhhbw96iHU5jOm7I8ccZ/AcLEq/wRrsxYcdHPd3q9z7t5RvEUfHSsCGFTATp3F3zEIliYChSFF7nVeumYS8IxCrpDRxTQQC67aZc5e6FFgPqSClerBOpDaX/i19IPRISnEqFTE8Bv6ZoCl0ZhGyywOCCJXkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nY8RVNTSHmPsi2eTJnAJycvAUOrAD6E5kDu2m1Ajg60=;
 b=nTi8yb5KS4vT9tVx09T7ZB+CbA1mmGaYPh/EkBOKhVxrCogLT8OFDMdhwmdBl7px23rlfdq89ZGFzFRG7SNOghuZl7BSRuUJA+QNzXjEZlLaYl97E0T6XdeUvEDhdGP/nODP24n86kGBXrO0fq33ZfO8SskuOdER3+KZUO9yTB1PpJZTCZjYhzMTlkQYKaTuZ8YbbyW2klMSR1ccZHW2fqeAZccrj6954molawf2kNMfkUqWMA/XfGIdRVB8sdIwzWevNFn1Kc9eIvJSnetrGtvPLBIaH3syhnvcI3ipBoT5reQZAQ/OkcdVeLTCSmbjNUHJsB1iKswnqsCEGBLhAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nY8RVNTSHmPsi2eTJnAJycvAUOrAD6E5kDu2m1Ajg60=;
 b=uQGDGSvNIKy0foOLKqCzGoT8zSq5BxshGSm/wHLOKKWXNRGJx0y5n1OsOw+cNXDE3QmiMc9Hyrc/mnKk2EtDB1Hxu1TwLJdOYSsXpJrZPyiS5K8+jpt+DNEDxOslK4Do/gCe+6XXZConOj4EXTApU4L3FlGbb/6Vwbmd3bH10gI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5517.namprd10.prod.outlook.com (2603:10b6:a03:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 22:24:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 22:24:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 02/13] scsi: iscsi: Add helper to remove a session from the kernel
Date:   Tue, 17 May 2022 17:24:37 -0500
Message-Id: <20220517222448.25612-3-michael.christie@oracle.com>
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
X-MS-Office365-Filtering-Correlation-Id: 4d8a101e-94cc-45c9-410d-08da38541276
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5517:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB551754D66F09E7CCE7EA4528F1CE9@SJ0PR10MB5517.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bn19kx43J83qwEtpeAmtWDw0l/pI01rFB3Mb3Qbk83JHMdk+kmi3/WMETSVTNBNmNf9z0zmHwc/0pCpsv5uaeyQ3ne4+qG4iG1HxPcG23jEY7do3YTY6vJzH1EdMEBOz9VxNW58rsU+MmYNtgsmjOmNs838vdGrk0M/ovxM2zqflUxsNE6Jow00mqZVbMYiFZFmZw5wQ8riq3kloH4MIwYFR5vW6kFUwcgwzPhsStPkPsHEelFr8eyOPoLDnM6MmKHrcXTOZARA6LAKlmNYmdaUrScYyr7wBmjRS62x07Cwo9/seYvLlDVykkuIDUgW8LhVQNm2Mrc6smfMM2KnhbY2+XuSEDoDhoXLVBARqnJBvjhL/dzHAX4qqVyUUmBa/lASSEDPnaK+8rmpCh/lZDrRzCgCHhpYExCGiYVSFVMyaF9moOarHe7kbHcGpQkc5y16yb3Pp651G4jrycdqhbhTP6MdjLa10lgwdFTBoN6Ni7+wFSkM2ziyaQc7qOUVPNULnt/y5LNu02ODMdrI+UCDTwsIjBszi4hOuOyuO0QrSzQOZATESsNj51wFj7d4/+LdZjZ0XidxEymkHTQdtirEz+7HvoJE8D9EhK8wq4LX8Ts3gCmYqyvkItKoTNfRr/lihfSOIZdzti/5SuQcAATP6MCiZZbjlFsYYOhlT2aYOALyoqtzzMV40gyQnvlsWR8AFfZ7oi0wWZk5XCC7pEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(66556008)(66476007)(2616005)(8676002)(2906002)(26005)(6512007)(6506007)(1076003)(316002)(6486002)(186003)(83380400001)(8936002)(52116002)(38350700002)(6666004)(38100700002)(86362001)(5660300002)(107886003)(36756003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?meTP1zRxXyAak7rdBvABA6sVQ5KuVeEBhpHcaI6D/l+pyfmpI01yOXwzRCnl?=
 =?us-ascii?Q?/a+a0y75qBwdR/em64BJGxTIHpFgmo1tzTY599o0lS5tnSZzGv9uRQZrqLbs?=
 =?us-ascii?Q?WyXbi3hJYxp9NL//Go/JPULvLPUd3TP/6doqgLvlpN8p4qijBqI8estJ5LyA?=
 =?us-ascii?Q?WQx/5oj4gLwORGzEXoFm0LSDfCS5d3gJ63F3XxrEedygPG8fJzsYeuvbkv9f?=
 =?us-ascii?Q?pqX5yBg8W+6DdhiWY9IthynQGomel5mFarBHMR9MgDLlEcmVvI/Qgc7XiQL7?=
 =?us-ascii?Q?nmIDA50li96ca8eLCUY5YCcprmx47Txpwyqw6Gx237CujA+CySWA99lsLZeV?=
 =?us-ascii?Q?4nUWhXIdOqEuMNxV6HUuwYOvQqAGCqge2RzFFrFZAh8dqBslbvy1zowISJEw?=
 =?us-ascii?Q?vu7E3RUiotSo/5yCnlRePdws+Hwo/qh4cor1tZHxKAGnbQnWgNwpJMRK7xFu?=
 =?us-ascii?Q?hP2mdbw/9y2nGWVxoJKhgHziBTTG7pkLA3K0hhlStQaQOyZ7itZGeQLts9RN?=
 =?us-ascii?Q?ucKnAd5PK3KLEJkpIsQT1+eRTj/rPzF7sW/JRf24QbYfYEfnhjRoms2MSDJX?=
 =?us-ascii?Q?PUHZdbUtRtbg2XkNzp7ePbpdcUb65yTQMSDOzPeEEN+sitzeZxRBjduJjbtr?=
 =?us-ascii?Q?NTo5DaB2960SCM5V/JeYQq1dETuJTq4jqr/q/pqJnO32lZnz+AWu7XNDxhez?=
 =?us-ascii?Q?6XDBfDALs6g+ueKa7wJEcFIKom4ZgupwyvCQ2KQp3PlO21buApZH07IMzz5W?=
 =?us-ascii?Q?daVebETOCjgcvMl7HMvE4AOEcc0/0xEsvk54Vm3+vfba5PZZMSfEPB7XAqtN?=
 =?us-ascii?Q?EHDGMrKEVc3b5Dq1JSUO9b2FCO/IEmhh/RGUK85I0od9PF8yIVwzDqeykIOP?=
 =?us-ascii?Q?jgrGHvMpdQZzSVrfC8TQdosndo9xEhlNWI9G/Hu+34+l77ESmk+8zJrdJEWU?=
 =?us-ascii?Q?GmzagGcdepQpQ7xsYoSMJxWXfWOMl0vKwMf5mpU8eqpWn0PN7g2NemftUoYI?=
 =?us-ascii?Q?W1LAn1JngPS2QSzrt9e5h5vrBpp+FyNMAorM5nQ0k0TEPevm47nRIwdEbxWP?=
 =?us-ascii?Q?ajq8wIpm1zOacXizxc72M5LWnq+Te7Y5EcnlcF5xkO9leJAAahEQ7j+K3PcQ?=
 =?us-ascii?Q?JL7WS0ZgXKcSxtjujDyC/SapA+A7XEXa8RM3s5ihPecG/v1jzDb6woOArjCD?=
 =?us-ascii?Q?w7CsoKoy+X5Yik2HGfEOZa0BwxOrhPh/q5RR9GUGPIj1AjJ2hSSmMiwUtges?=
 =?us-ascii?Q?3XXDNvfTa5BTSLkmBb6Y+KcyQA7URcsHr0p0ucTbUiZ47Ybybt92k9I3/69P?=
 =?us-ascii?Q?x7eJxW6GKbo54wfi4ALiXMESzOvFSVAl3FLWaJy9kQl9q2RE+2nI/JTeZ/4h?=
 =?us-ascii?Q?tMwuXjed+G3NxO31kHcjdck04NVV/Uk19Mm5PSdkRFyhPLyemZJmdxLTeM1H?=
 =?us-ascii?Q?RXtoCTvPDkxN9A85Tiw6uo3qqMuPrTAsgO+XgT/tVKn9w4Wbi3edlXZDcWg7?=
 =?us-ascii?Q?mZxzI2qqa2heclLDXVg4RY6OtZbpLY/Qs/tb8BbjgOonPxRQntwwWI4AEqyd?=
 =?us-ascii?Q?rPQ7eiCG5mvS7SM04UaogK/Brf2n1UIdeT4Q/ccAXohD0IdpMOuFAO+Fj6ux?=
 =?us-ascii?Q?bA0BKcrZcLLigD+YCfLfAOCJEq0dbVm/wyb2nfC6GMA4WVqryA/GVsMY1JpH?=
 =?us-ascii?Q?0KqNGq3BTv+1/avGBDy62VTt6xE0FRRiutnYKooYaFrjo1s8zuOZNVvoeuTL?=
 =?us-ascii?Q?9RNAYC5gd4mpeTwywQL0aAqu8NHDbRA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d8a101e-94cc-45c9-410d-08da38541276
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 22:24:56.5902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IxZ/dNgG0YKhRlpneT42TIB54BWa0vMPx4AK+2eeLVE6F9E3KEV+Soc8+kaye52BmlKfqXsK6s7XyMborYkIIGK93C4AFyXFL6huxZbAldU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5517
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-17_03:2022-05-17,2022-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170129
X-Proofpoint-ORIG-GUID: _NuMnZbKLxVju8fAakjBPOjA1Yt2uP3B
X-Proofpoint-GUID: _NuMnZbKLxVju8fAakjBPOjA1Yt2uP3B
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

qedi requires that we at least tell the FW to disconnect and cleanup
connections during shutdown, and patch;

Commit: d1f2ce77638d ("scsi: qedi: Fix host removal with running
sessions")

converted the driver to use the libicsi helper to drive session removal.
The problem is that during shutdown iscsid will not be running so when we
try to remove the root session we will hang wait for userspace to reply.

This patch adds a helper that will drive the destruction of sessions like
these during system shutdown.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 54 +++++++++++++++++++++++------
 include/scsi/scsi_transport_iscsi.h |  1 +
 2 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index e6084e158cc0..3b5e07544324 100644
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
+			     iscsi_iter_force_destroy_conn_fn);
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

