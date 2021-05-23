Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C774C47080
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FF996117A
	for <linux-scsi@archiver.kernel.org>; Sun, 23 May 2021 17:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhEWR7l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 13:59:41 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46582 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbhEWR7f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 13:59:35 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHt9CX154069;
        Sun, 23 May 2021 17:58:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=kQTbcS8BmNx7KlPX4lIOAQxv1ol8AxbvmNhb2h4N3bc=;
 b=fgI9q+ad98pljh0zXT2eI5G/CLFoL/iqZbiDAoaoJ9yxVyaANo0kv+FIedh4WA6YWooQ
 FteVlPR/V2+ojySd4CpDLQOkqD5fzqRH6y+51lLiS4V2vhUe0m+QJvimOK22WoXS216J
 6vwlGPtlLXtQtQDOYBe/Lxio8ZXsFJUw8vb8l14L6VCZ4+gQxuGNmfXiAhK9JgQb+ilp
 F1i+5lUGs09bURX7n6vHAN15BB+UlxA5uVUZGHObk1fX3hHBVvmYOwpa6+8oOw4Sxi4A
 hFFgCb3ghd1zEXyJS179FZjLGzBj+Opcrz9qq/WCMuJQMliUUSZ2ts/vHHcPSB12L/qi hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 38pqfc9jad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14NHuctq161854;
        Sun, 23 May 2021 17:58:02 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by aserp3020.oracle.com with ESMTP id 38pss3qbg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 May 2021 17:58:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8YXmnlQAzUollQchznTYvXB5Jin7FUkbv7HTbDVQ7IS/Ihd+CSdjeOHfHPga3AQxrQ3xNKxYXSLZ/jppKRfLiMidtDO2PBsOJ7rUqEwp1Ou9c0yhYoS/CRFdOooQvWZFXIJXKcBHBJ+L/92SOanb+A2AppKok+R5a2j8zaKRHck1L1BnVScMXAPUjrTodpcc/+eQuCWhKE84ZMGTscVU8jUtqYRD6cfV7CFTW8emMTW5ogY14hCHG7/R8wkxNy3cUI6o9hLUZI923zngt8PYjGNmUzOyyqPCHB+uxkCEg9gSSCwX3ukUgocN3J2Xg6uh/sPDmWHZHJgnnyj+VaJ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQTbcS8BmNx7KlPX4lIOAQxv1ol8AxbvmNhb2h4N3bc=;
 b=MR63O2HlmqGrlxlL8OOV7IZs53Lc8XIoVz8oEnvTnxk40gkwtd/HIB2yY/1p0jNzdcJK0npAVTa9fwNlPzv3/nmin1+Kdx/s28s63L6lfxLFOZq1JdomlslQ+xZyib4VZGZ3TeQnk9Z437M62L09ufEtfq8Efj37yHkkBbbQn2V6bWjyenXaZQcXvYkrspWu6QOUw6Cky32uUCsXeQ0YHMP70iaMAYoRwPBMqA6IN9sKg5zRXOd7CFs5LFZQwxWC4T//IJsgCU3P91guCnhr0SO78BBAbGCOkK4t20wLVePBceGccssS68PCjif50bHRTOJ07uKyOJSOachQklBCVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQTbcS8BmNx7KlPX4lIOAQxv1ol8AxbvmNhb2h4N3bc=;
 b=KO7fwMwuer9272jiEUhwUEUDsGgqPWn5Q+KdHVHCfFsIye/nKb8PUag1ka+JS35alcehfJYdzDnnat0bawlu7vI6Vd9cvKC4odpNxQa0NqdHA/fjd26wYPM1oN2blJaChezHjEuz2sLuJL2KOPziqNYNf3/AQ0EfgG5vGIaKpz4=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4004.namprd10.prod.outlook.com (2603:10b6:a03:1b2::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sun, 23 May
 2021 17:58:00 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 17:58:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 10/28] scsi: iscsi: Add iscsi_cls_conn refcount helpers
Date:   Sun, 23 May 2021 12:57:21 -0500
Message-Id: <20210523175739.360324-11-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210523175739.360324-1-michael.christie@oracle.com>
References: <20210523175739.360324-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:5:40::46) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:40::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sun, 23 May 2021 17:57:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3800a52-978d-4b26-5cb7-08d91e144d73
X-MS-TrafficTypeDiagnostic: BY5PR10MB4004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB40046CA8B930F637444C8F8EF1279@BY5PR10MB4004.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9B9arlIz15Bshpsa+uWUqWaV7qIIUsyeu2IMoDPXgpDYNbgY8Y1PIywW1C0AHktWeUOLxIudf0bHMcHgvgcxI3IGSJMOrw1OTXWKjAtecEb0ASr/IwOBGS5OlMLuxgcjnmBybfC6mR8VDYS78/QOfIwXZ5cJ7qgdnmJGegQUd667PL5GMJNlmZf7awQV9v67r1BdGvFinmrpjQ1aXpcJPOQZsP011WDrdbG2p+K/cpvy+oG+VwrbvIl5l+5zPs1eB+RNQuVTJY9t+4BgMeMTtHAGhk/hPq2frTLS9ZiD8BGZhtIjl6PW7JSkAYZisTyggRh0L3oVYrbVaC7b2HgPrE9reOa1N1czuVjP8/ss9un9cjzamcO8M92CyZfaTRvWFtN4Cu7/q4/KzQh16z5EZwI0+BZiTjK4AymWtvvdg1mUcFr3wlKs33TdAYN0izVEDP/RcQWtJteOPznPgMGsyInMe11AWSBW76rUlHo2RRnOB6xNCeM/lzvqiItp72uzzVsVe0jtomENJeFRceRs30iCJjUVubd84ENL4rX4dBpUu7LP6yn0/71ABKNmXjlF6IrrMyXBrmHLVV6NWo6pNduaucRIh37/2n1vy2DZC8adnicTkI+D8farjaqM4YLcC2TuuUaithbvnWYlAy1vQiZF5zR2zFnphxV8OFMA+xVkg4+hUf5bv16s1G1Epdaq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(66476007)(66556008)(956004)(2616005)(66946007)(16526019)(478600001)(36756003)(2906002)(83380400001)(86362001)(5660300002)(186003)(6486002)(26005)(4326008)(1076003)(8676002)(6512007)(6666004)(8936002)(38100700002)(38350700002)(6506007)(107886003)(316002)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EQqEeaneC9xjD3VlMdFWCRpA3prZOsR0RJgzoHFVmWp8i24XFqURbffYkUqJ?=
 =?us-ascii?Q?QdDKVLAGFfooceQ80K6evpeC6ZGf54LGS1ncc8ST2h3I4E8FypNHm6lSy5dK?=
 =?us-ascii?Q?FevEgnG9FEn5GyqseiUPQCy5EKThz+i9a44a6axifS9tnq/0F8cN6tm12I3c?=
 =?us-ascii?Q?P2aak9+0G3D/bg1UJRWCcT1atfZ3g071OM3fucRWo/+2snlv6Z4G1JCLQbMp?=
 =?us-ascii?Q?kUsp4w8EZJxA9f4cM4+/WA/1QFUJv1oH/2Cai6sPmxSto1E1v/RHIFk+jbum?=
 =?us-ascii?Q?X5l6NE7kbSvgDuaMDaKlpL6P2mXgx5I+U6ksohLJT1oJgD8WtUQ5AgmbUM7d?=
 =?us-ascii?Q?ndbcwbG0lxJFESWLKsD+8KKWfkP125uJvaQLSiz8vumoI5QKQqZUPq3nS37F?=
 =?us-ascii?Q?bEbWFx8gU6QIEE0Z1pIemFfQ/IYvNE0X01bpk+LGcRqZESZU632uaiqhOysk?=
 =?us-ascii?Q?J/AjM9R8kOVeHEw27d8v6LCfmpqE8hQBn17ztl76w5LC3WahUfIW3QiVQH/r?=
 =?us-ascii?Q?GYG1Un8JrAno13df3y4If8npX4h+BBdx6cb6I2TKJzdX0Xy4EGd9QCPtLWhZ?=
 =?us-ascii?Q?/k42cCzkCbytD1jUbT0YrgBeUFm29RkKaVZ2WMPaLZvjYbgrw8kKv3t/2mfz?=
 =?us-ascii?Q?n/kCFqedMzZ7J2/9iaJQ+LkkO0JqROML3UnpG+NxvQCu3IuPkWeWy541wAdq?=
 =?us-ascii?Q?bpvGZpD67QgUkBIChxmKMkw5SqFX1e+W+ToTZ6uev2kUifyqd7OKJSmHWoXS?=
 =?us-ascii?Q?KlzAEBD5aCjJg+anOLmJOFtXSFFxmOWLeL/aCPFK0HfEFLT5gO9O5jZLhM53?=
 =?us-ascii?Q?Vmn36+oPp02h3nm6ZmW5v1Qp5IZ1TuL7sQeZUYf53Pmx9GzNzP63iTj9WPW1?=
 =?us-ascii?Q?8QRlLege7i06OAyImjUWXeqeiHKzXYvMclihM/9tJAJfFWQUeHocnh3cVJjP?=
 =?us-ascii?Q?U4FtKeblsGz4DMz38A4FmpJENE1nQKvuCe5KQFbd/ne2d8gPKdr6tdPlJAsS?=
 =?us-ascii?Q?HF1xypi7yNRm0ziTIuifFtVrAT/Ak+xhOnMxdL3aMPmGLg15VnndsUyHevIx?=
 =?us-ascii?Q?x68HsZoPqtkdjuCvZJgw6Q0EajfMswf44DodWLfcOaSZGREJNcpLcxDgBQZh?=
 =?us-ascii?Q?Jmo3wEEFINb2eZ2ofRFwh61mgeQNxdWkvjDTUJHiIH7FZWJciM2YBDrVaLxA?=
 =?us-ascii?Q?MjkUAAgXy3m0cbQFTt8788mSM4b3oaHxRug6VI4C41YAjv+fj+/wKFumktAZ?=
 =?us-ascii?Q?gbVMbBa2eXywCJ8g2iBBWt5PW5sBkEqhYIlxx/DoMmYh3N3dmcz/ElHamy00?=
 =?us-ascii?Q?dnz0HaydsCc+Vrf4wVagd36Y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3800a52-978d-4b26-5cb7-08d91e144d73
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 17:57:59.8730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K0UOSUjM0rYvW0Admde5eCZPiN1C+GpRh5QaRy9gGdJLlOHhu56panzJU08RIZl2FdVqhKD4as2VkNuKVZJK460LzWHM3kHXy0a2OeDJECA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4004
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105230136
X-Proofpoint-ORIG-GUID: NuoZONbATW6rLlMqaoBakzXPmtNZjixZ
X-Proofpoint-GUID: NuoZONbATW6rLlMqaoBakzXPmtNZjixZ
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105230136
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are a couple places where we could free the iscsi_cls_conn while
it's still in use. This adds some helpers to get/put a refcount on the
struct and converts an exiting user. The next patches will then use the
helpers to fix 2 bugs in the eh code.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c             |  7 ++-----
 drivers/scsi/scsi_transport_iscsi.c | 12 ++++++++++++
 include/scsi/scsi_transport_iscsi.h |  2 ++
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 2aaf83678654..ab39d7f65bbb 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1361,7 +1361,6 @@ void iscsi_session_failure(struct iscsi_session *session,
 			   enum iscsi_err err)
 {
 	struct iscsi_conn *conn;
-	struct device *dev;
 
 	spin_lock_bh(&session->frwd_lock);
 	conn = session->leadconn;
@@ -1370,10 +1369,8 @@ void iscsi_session_failure(struct iscsi_session *session,
 		return;
 	}
 
-	dev = get_device(&conn->cls_conn->dev);
+	iscsi_get_conn(conn->cls_conn);
 	spin_unlock_bh(&session->frwd_lock);
-	if (!dev)
-	        return;
 	/*
 	 * if the host is being removed bypass the connection
 	 * recovery initialization because we are going to kill
@@ -1383,7 +1380,7 @@ void iscsi_session_failure(struct iscsi_session *session,
 		iscsi_conn_error_event(conn->cls_conn, err);
 	else
 		iscsi_conn_failure(conn, err);
-	put_device(dev);
+	iscsi_put_conn(conn->cls_conn);
 }
 EXPORT_SYMBOL_GPL(iscsi_session_failure);
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b8a93e607891..909134b9c313 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2457,6 +2457,18 @@ int iscsi_destroy_conn(struct iscsi_cls_conn *conn)
 }
 EXPORT_SYMBOL_GPL(iscsi_destroy_conn);
 
+void iscsi_put_conn(struct iscsi_cls_conn *conn)
+{
+	put_device(&conn->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_put_conn);
+
+void iscsi_get_conn(struct iscsi_cls_conn *conn)
+{
+	get_device(&conn->dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_get_conn);
+
 /*
  * iscsi interface functions
  */
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 3974329d4d02..c5d7810fd792 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -443,6 +443,8 @@ extern void iscsi_remove_session(struct iscsi_cls_session *session);
 extern void iscsi_free_session(struct iscsi_cls_session *session);
 extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
 						int dd_size, uint32_t cid);
+extern void iscsi_put_conn(struct iscsi_cls_conn *conn);
+extern void iscsi_get_conn(struct iscsi_cls_conn *conn);
 extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
 extern void iscsi_unblock_session(struct iscsi_cls_session *session);
 extern void iscsi_block_session(struct iscsi_cls_session *session);
-- 
2.25.1

