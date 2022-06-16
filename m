Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED92C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378725AbiFPWqT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378590AbiFPWqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:46:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE04D62135
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:46:16 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GIQFvP026656;
        Thu, 16 Jun 2022 22:46:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=30veNVdGdWLohkh5NmOj/rSP1gCQdKhZ+kJv8SWs9Wc=;
 b=SApJtO6sLqJ0zjjG73IJP1tqkF7BrDsYR76ptIVDiW5LVae3OC6uk05WuYMt3SogONJN
 tc60+Il6CDtXjiUexHLMPlqFssT+IUJLOfDY22OLwfhUcUyCeCjRGajpXkk7xgzIleb9
 DI59ChiKKhR9S1XYKbn6I19imtzo87h4hLCgpIFNoD5A2ythuIrbaZ71Co5oIrUBWjPp
 nBslXswkL2yjDO7L5iKMLXC0GXv6zPB23pi6JUlM6rGAxvVsA/7Jo6olnuhaTvgvbCdr
 uH/IrXqUImqAIn6tXWOAEA3m2Xh6AmvuaeTen5cozFyJOdjBVbh5fjG5C47fz2kGrgKt XA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhn0mjp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:09 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMaOYc035621;
        Thu, 16 Jun 2022 22:46:08 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr27dmq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:46:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDPuCTi7B2Y52CTf1fpH9XMXFX6lqvr08pQYahLQ7K2QAMhatdFCfYlMBCp2NmGqeke1ycxlpR4ovHpBIj5dicMVMG9SUJyaofgoX6F+SzvotwAsXkbsXrJEmkXlI7a72OPDLG0mAmeKR+VtpbPXOdf6MCZF5wzwZiAdJARUSIQv+YPBi9NRGPFfEnru0SvT+a0/pG8cQKEa+tk89f95q3omiS2gdiq51gX8ui8h8D+/0rM0O8Ei3whbEink3ASfb9tkkLrmg7CNa6w+CpGWNRakvvNfv7afw6ydNNFFt7akGISrnM9ZxWsmmmnC8Y9uVDrOJSHJko+mvP5sQKtx1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30veNVdGdWLohkh5NmOj/rSP1gCQdKhZ+kJv8SWs9Wc=;
 b=ljKXt7NeoIpwvPV/3s6ozKnsyVJs8Rnv4Bm0k7Z1axnK0iRGLbQYoHgrywc6hVv1NVcvicSHWYkeH2AE+eg8P6uc1anQVWNhF04bvgLAopx0+S3vcdivCOtddANfxPbMnxzLojTKBppzh8ODv/S99TZX5l6nsCKwWiZP9iYdnolKzzZb1vjMv8vHLkzOhGHJ4mSi0HOZxI62/pICpgz0vJGkNC5/wKKz1XAn9++J4LBejOncK3d5bnd3KVSKc9rWSVaEX3Niwt2v+r3vozcIcn93OOISfdWWu8Lti+lR8avAKhklmxkzRGSfPj/wp6bvaBdVSDEyok7i/xWA+m6gpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30veNVdGdWLohkh5NmOj/rSP1gCQdKhZ+kJv8SWs9Wc=;
 b=TK+mpak6/aGfGx30R5K7ydM3wpVd0twFGSpGz/GHYWSv2iM4vUYhIlJL/UI+bp0H6kY+b5Sskify9drRDnTO3ZLFhYiA1Q5pCNAPC5RvoE14L1EJwvWChmU6YwPFWFaBhSPpzMkclTwmDn2D3mu1bVVV12ISNDGsWOGo/3wp8ZA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5617.namprd10.prod.outlook.com (2603:10b6:303:148::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Thu, 16 Jun
 2022 22:46:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:46:06 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/9] scsi: iscsi: Add recv workqueue helpers
Date:   Thu, 16 Jun 2022 17:45:50 -0500
Message-Id: <20220616224557.115234-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220616224557.115234-1-michael.christie@oracle.com>
References: <20220616224557.115234-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:5:3b3::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab0f00c4-bcc9-42cb-d7ba-08da4fe9ffaf
X-MS-TrafficTypeDiagnostic: CO6PR10MB5617:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5617AED8280DCC0B35731A5CF1AC9@CO6PR10MB5617.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OyXLclhkPLz8d2NkT4Bhl4GUeLIQERQPrwXl8GU+aB5E690gV5CbtiMeBXNrnjDRHevprSAtddoWvxuRHeE6Ml0fCzZ9XPcg2jIO+EeuYb+KUffqctcZ8KhFvqzH+Jvi+ntxbmVRAq2ECbMbSFQiEp5X8m2NjylVfL2bvVI6eAS+dzpl291yqlHRQmtxM2pMH9wSxiWBgoid5k87I08OMWcZGiu341bFqNLWhP1waT3bp5qslp0WAY92Noo3mfk0MgbeYHwznjhocW86z8XNWsCSDxWDuS5kkeEA1J5TZqZuxtrCY2Rad4FRlvSEsYllNw0pMto6U/0yvFqX2WF1AvzhwwAYh6rMW1QMIPRcaAlS5OVl46+bxZ4GL75Hp+wM0W0rR13Eg6jJ/eZTPnkqISKzt14Gg2+v9QCdc1jH3793VbHam0yRGSZOa26cDiDlkthpJwtfJMou2MXc4EZTY/2Ezh13sigqgQ353vlHOToCFI04H5a1yoFIk/gATFJRg5kEL4ijYN8gsuOPFbY4rMxONnFs83EitbEv6JL5xT2vyWDb9bANEqJENnDqyJhCSCcWLf1za3W5Gf7T11Wor3tSPYYHcRfqjw83zC34BR0AUpqvJ/DmkpR+sarNbSC/lDNZURsMsCXVGB1/iw2bWRO1wf/i6QoXXJ0jqS75UDHRGIZ3jVx4k/miq6IY3Eir/pW5H6AS8KLqaUXxWUBdWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(83380400001)(2616005)(52116002)(6666004)(66476007)(5660300002)(38350700002)(38100700002)(36756003)(4326008)(6506007)(8936002)(508600001)(6486002)(66556008)(8676002)(6512007)(26005)(186003)(107886003)(1076003)(66946007)(316002)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8N7iWfTjH2Urj3jXa2HRnMBCtrRTX/8pxQ2GJmdY290VV2RZ6TKlQwQxiFvn?=
 =?us-ascii?Q?Wx9ChXA9EejhG+8mUrOfKZD3JGT+su4tQIq/baqY7Q238JxehVsk/UOYIcoA?=
 =?us-ascii?Q?3caMZhUhWblVb3YPeXItFn0Msv20LUyj2sgaM4WXTUOgtNJxmvYkHnZWWTcB?=
 =?us-ascii?Q?/K2rvWxW5xzSPc7pltQPXYtzXeKl/jNuWZxR9JJrBYUORd9EVAlC+oc9+nT0?=
 =?us-ascii?Q?gW979XWSSaMMYnE+8BMQVvhtZgbMPJWCCji5IVbF/ABK5PnT2rUcHBBMopQr?=
 =?us-ascii?Q?IlUuQsTPJQ+evIDucplKQCuoM5qGhsrTdgeqtPN2crmFEiwoCLdGmNeg1MR5?=
 =?us-ascii?Q?GQubw2it0T4PVeWG7Y7JmkmX5oRb3vW/lcHf94TnLnLQsKzsK1MC4sdIzmK9?=
 =?us-ascii?Q?mwM0PGwrJ/nqe5u5oAIIMc3GCe54FFbVeNZltv4d3WSqBBKVtis91W/WlgPW?=
 =?us-ascii?Q?VYZT+Rc6HIUEofQLuSAjJR6UWzUuJ2DtHpxVZVWEicufpCfxQfcVDZ0l7d7n?=
 =?us-ascii?Q?aKTpExrLwTEaRYYPm4lTuyBfBMYjUBCFEbjZvwGRErRfFmtELieajgtdBwl2?=
 =?us-ascii?Q?rmlhK2t3MAudBVgQAhqSrzobsRtYjsQD/UcYzjEAyTfJpBLDQTKXqel/S3WL?=
 =?us-ascii?Q?hwIpelbv6gDu8CszN9wZtzbR6qE9mI8EwFvL3atuDz/wPDR8wFkPfO7EVUMv?=
 =?us-ascii?Q?RPgfo6Wpeclb4uF2TMmXVA9iKm4gZIXIaf+LjIwftKsoGRTuj6mDsl66hxgF?=
 =?us-ascii?Q?tAy7tUUkVx40hcJ3RKpAgxB6LjUziL9f4iayv3e53E+hHPfE6nLpIvMfwr0/?=
 =?us-ascii?Q?PMAL/um3XIxc1lxuv8lt7suJbWAOZOgPm5R+8U4kq1a8E/tBFi1uJlD2Fhvz?=
 =?us-ascii?Q?4j2ue22hilfw0plCRWmUB9qw9dnJFj2dmQpM3oKJXfv8gXzFajl7VB0jlQEi?=
 =?us-ascii?Q?E5ANT4DmGyursaLZhP+1rJ1hqiwtQoiAItjdoghqc6X56gK7UuUUxtwAeynM?=
 =?us-ascii?Q?OYYxuwLHJSqDeUfnXDB1gfnM1gWluOjLcbYbrPyutDHPs0H8usheUef2yZVX?=
 =?us-ascii?Q?fpOEFjCwEuydKmTdDru/UF2d9TZBe8/ebCTBejc1vbdEqJpIZmVcBvvn1h2J?=
 =?us-ascii?Q?N/BvpPpMeOG3R7X3DofH+xo233egzXC1YWCLcCGZu9U8x0x+Hyn3uRu3Yn5H?=
 =?us-ascii?Q?XPnxfIxQ1dxfURXGGJ4cII0stTeZcwtf4iz61iPdhJxOfHBQqO30Yl9hhW6m?=
 =?us-ascii?Q?+0SID/dubQmbqQu2+nXsLolJqj52fTZZMbEPDSd/1ycyLUJWbrm5XChY0SjM?=
 =?us-ascii?Q?oiq9rg6zMbUfUpdIkhcdv/AVKq+1iDq4wJfH/tIWdjARoRkjE05LthOyzLp6?=
 =?us-ascii?Q?ysgpX3IwPqi+FE1AS2hpH6W/u2OPqpKJFi8ant6gkhRztlpTvz+Vu/sAdPXS?=
 =?us-ascii?Q?azVt7k2l3op3qrROmL8Aw0rKs6syXi2Xem7gQq4CC6M0iSAgc9RaAj8oCi1W?=
 =?us-ascii?Q?npy82NA1qFDkQo0H7HNrKpzMf5Scs8wVUEwwQZ6XPRWZ2uuufYnFjc/7lpVX?=
 =?us-ascii?Q?n+yFlYDBgMRxCZ9r+mE0LeRgLw6xPo7mPfZISUMzOi+xVbizCG44QNipih5u?=
 =?us-ascii?Q?Xil9k3TOV/ITHcifpx0PH9lfphC/nuA8TlRmAsVFRZo4rmNTp/muOYbbY6SS?=
 =?us-ascii?Q?YhinrvUcWONkvKR937ZFX3/Lw6cqb3I78UoRHWF9x3afHs5T7Wy68eiuK5/4?=
 =?us-ascii?Q?sB9SzFxoDCSXshrErNUSuwMO6one8o0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab0f00c4-bcc9-42cb-d7ba-08da4fe9ffaf
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:46:06.4065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OgOri8ITa8nq8gGBdmphTUiPlOoVPbqrInZNN1D8K7YOVD0A3TJg13XHko6RxQiBk5wOeApvfOG72YooLrC8NHirsCHCuprHkNE5tU8doa0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5617
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206160091
X-Proofpoint-GUID: 0hKebPY48tTExHXH74fJjnlZclkWoFn3
X-Proofpoint-ORIG-GUID: 0hKebPY48tTExHXH74fJjnlZclkWoFn3
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
index 3a73aadc96a4..44283014c4eb 100644
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
@@ -1947,7 +1957,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
 
 /**
  * iscsi_suspend_tx - suspend iscsi_data_xmit
- * @conn: iscsi conn tp stop processing IO on.
+ * @conn: iscsi conn to stop processing IO on.
  *
  * This function sets the suspend bit to prevent iscsi_data_xmit
  * from sending new IO, and if work is queued on the xmit thread
@@ -1960,7 +1970,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
 
 	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
 	if (ihost->workq)
-		flush_workqueue(ihost->workq);
+		flush_work(&conn->xmitwork);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 
@@ -1970,6 +1980,21 @@ static void iscsi_start_tx(struct iscsi_conn *conn)
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
index 4f4be93aa0d9..b4700de3445a 100644
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

