Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DEDC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2C4A61246
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 23:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347841AbhDMXHg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:07:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48078 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348738AbhDMXHb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 19:07:31 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMhoVn002699;
        Tue, 13 Apr 2021 23:07:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=yfX4mBDsuBCr3AAdOOD8MHZqfm+FIw6N0IaLkEYzFWg=;
 b=SD53vKFVvaoU3rLmOeI1Gph/qzXwPCI45rHngKXrCMmnTwLD4JejQJKYmKvlg+IguuPP
 o1f266ceY8HzE6/1oHgYYimq7VWNNiSo8hC4RE/y5O3gXijxxV6ghL8XNx/xfXgA7Bxs
 myNvYn4luFQQ29o6mf03Tsx71QnT8DkXqYyf7cOAH01LnQBtdssNG++JnTOwP2f3URTf
 ZUw1Q0bfO4LV1bP6v55PgC1uPouZ4qstGIZprzodn7BLHHri0aSExqbMhuwKoAy4cGTV
 6Bz7jHH0d1RcB5ZTvSwcO5skFwga4jf0KTrvwVfsJXdjBEFO+suTqEArG8Nxtms6p5Pa xg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37u3ergpf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DMjTQx105371;
        Tue, 13 Apr 2021 23:07:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 37unst1tvs-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 23:07:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVSeV8e4LXE2BrWXjdEtD09kD4Igt3izSfoArum7G8XKsSMLPHwRkAgnnQ7GRPgGtmMh15RuMD6VuhgbTuXyDLPfMIfMdNUnOLtMqSmEXxQZW87WH696riP1dNFRhIp+P/5qlc6JUrsZblpYLTBUerU+EJMlcAXHh8McT5ca/+288jZaMnKnaDb3skMCZyoQy6aMx+H11UGuvjUa74QiD08dAdBfF7djleQXhkWHl4G8bIbi5h/Q/8VeEyfnxIQK3vNrzTvrhwE6fzC/nDQUYVRwWuPPFdRXwtNGx0IO9YBZoq/iqTa2J/aVKMzDEjvlTsLJ9IdLER1M9XHkZ5PmAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfX4mBDsuBCr3AAdOOD8MHZqfm+FIw6N0IaLkEYzFWg=;
 b=IDHW34RKS8ID77kaDHtPhFAhzyK8Cvvbx2gteDoXesbpZfJHnoNTpDDrPyNrDpuEKy03LdzdcVZw2/dzAqCUCAXQxnMgOBNisG4G+LGRyIOVliYBPK1bbwLYPeEgGlao+mR3K1SGc+88gthFBJeiTDJw2xCSGxiPSJJT/ofwzWyVk967llIa2P8DtbjZXNbLHojsIOxkueglWWx3lUgRUyfk+VOZ5ZzWftdw64kr6Zhvsrch3wo9DMB9HwBBX2/oYcT+e2URnzcwWYNwfGGh0+jbqnEPk0MmnDoqT3nsLpj6wvkk49P0hs2VXIFlzJ7eD6aEcr9jXbFUhdcAs87URA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfX4mBDsuBCr3AAdOOD8MHZqfm+FIw6N0IaLkEYzFWg=;
 b=lHMGrO05oJglb2n3wGOHojEE5upvGIP3AmeHTzorJ2mRyZJTjIp4wU0D0Co8U96dCl6EwEjBQYr6w4zHpewDcO1TR/xS7fUnWRDQRgcZsg84bfYOgDpxFt/sP1Fs41rdDE9pEYH5bLpi5Pv9ZYuI3xoRdKYYJxI/qZHD5chVERo=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2469.namprd10.prod.outlook.com (2603:10b6:a02:b0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 23:07:00 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 23:07:00 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 03/13] scsi: iscsi: prevent cmds from queueing to driver during ep_disconnect
Date:   Tue, 13 Apr 2021 18:06:38 -0500
Message-Id: <20210413230648.5593-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413230648.5593-1-michael.christie@oracle.com>
References: <20210413230648.5593-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DS7PR03CA0212.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::7) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DS7PR03CA0212.namprd03.prod.outlook.com (2603:10b6:5:3ba::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 23:06:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2809e527-5fd0-4eba-2f50-08d8fed0d7dd
X-MS-TrafficTypeDiagnostic: BYAPR10MB2469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2469CE3A40AD712411B8A24AF14F9@BYAPR10MB2469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +hQSiMH9UpRSst70LzYyWFlFBHa61uM1vBrm1EiHm8yCgm3YHo2jYehFyMaW5Wkh7PK0uDOptMfsdh6TuMcCYukgFhBGjlbPoSFZOHE7u8HVccBh2+xeyEvL4K0MqmBKHj5HPLHUYfg7yRLBiu/VnEB96qWFOLjqEpwPjHmZNeFKM2qfY//N5ozW2ZB+BEQIGx8NQtbYTL4tVhQtjnt1xeUl2x+phJuGtqobEkvBO2v0vt00nnkRZDPCrVM12Z5OvNbNXWsXjUlj/yJ+k37fRfZnegDP7bucyBwggtYz0/p703jPArS5t2vMRUmoL19PLz9ucPuQLFFrGmBu6CxCHvTkvlwaama8N9D/ERQ+40KyW0Nbx4EPUr2BXE6qLicH1pgRPTCzGYxSIHBXxKmAbkJQ6RHo6yGNotJsor0TXLp6keWp+uk87BLpJLfK3cNaYVyILcMZXtQrG1Hsf4e16gRsiqfsARPU7mBqr+8ZjNgdFkm+jsWaw3oo22/Hxom/Oomwwyx/85HSk5klow9/xpl/ljdbqypFvDt0zPbCaGnjsMFy+dZoPfuetsKR6Ee8SXwJZ67QsfwTDLWQQZX9qWyWfziramX3aUx2Qy33WFtiXiaE6ZOoZBaVMeqGK1oyu2F6Oeqn/D0NssPdkAzhLIxU0ayP/e3k/tU3sRg3I1BBt82q5klJEHrsvArciTqk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39860400002)(346002)(376002)(52116002)(6512007)(478600001)(16526019)(186003)(2616005)(8676002)(66476007)(956004)(69590400012)(4326008)(6506007)(66556008)(86362001)(8936002)(6486002)(83380400001)(107886003)(316002)(36756003)(38100700002)(6666004)(2906002)(66946007)(5660300002)(26005)(38350700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?H8xks9SMP5zW5ZdFA4ztX9qx0hx+LsAgIbm9SH8z7U89lXh4NGtbPRcK+plq?=
 =?us-ascii?Q?ITg4hzoi1N/UlFVgJkB2H27XpK2h3rp7NIidQEawXvI23qQn/opJBDbbuq31?=
 =?us-ascii?Q?S6eFgZZvUOUMx263/+MQgh06PpnaSIkiK7f0uPPjK++jAAWbGeea+JOGeSxk?=
 =?us-ascii?Q?GJ6+nsI9qILXTfEhVr6XXgHgU7YwmETBslFv6Wxdc7Tw0JFmMZVqkjrRy9Iu?=
 =?us-ascii?Q?uRdvoUCFrH3igmBc/ET58kzBO0VlUTm48nDAbbSf2W2us5DD82BtfhuBYuKJ?=
 =?us-ascii?Q?nyKFQmMvFnX8VkSJC3QnTVNgLNTw4H4B/PrsKoW7+snVY6Ar8ERElFGirI93?=
 =?us-ascii?Q?b4eFO9u3UJtjWPMAhqXtzGorWQym+JsKRDHN8tUgflen2Ub3wJfoWVdOX5D2?=
 =?us-ascii?Q?h7FZAhH2JvLBKp1emhZpEh5nkcmWChE9GThCSK13m7uqIIlEgU0ygozIq7hn?=
 =?us-ascii?Q?DBfK2dwejsZLMmX/+5OyC65wo3ARFSYeFqnrHWm8MePluPHxk+mTqOAPy/hq?=
 =?us-ascii?Q?0BgPwY3Sbirk49EZ8atUz6zWgjhw/DkohIUrEO4F9vKxN8ysRgBhEIYdL/q+?=
 =?us-ascii?Q?4EXuZsJ+Rt3THkvwkfWck6yZpgjPQpJChkUlQ50X8KHvlCKDFR9Z9MfnIhD0?=
 =?us-ascii?Q?F82twoos0iRjM/3/C2TY6VrPvmT8v9fN9BP4kb7X6YoOUYy0xTp0ms3tfSZj?=
 =?us-ascii?Q?AYKpcb63cI7Jx4TxUneV0+DmsV5a3Rz5duRMnKnLfQAU3XqAf4KSo7hNLNNw?=
 =?us-ascii?Q?1RHxMeMRUI/xhCBER+6DROQs+yF46SdG7K/92TJ+UgRVMMtvxeYKTqnvCfvX?=
 =?us-ascii?Q?vVXRwczwKnG0ap8KUD6RqhAB1Ax5PgAKNNH5lIKfOoYJUikY6HhsXAJfkSkt?=
 =?us-ascii?Q?V2EBFxSe6ne2U79vYGqKkppX1ftmxPds9iXSLPfueLnIcQkdyj/Dw3eV0A5K?=
 =?us-ascii?Q?TWWyhx+aRB9xaw+9Z/t+f+4m8Cpc3xHLXQSRDEcm2N8/9XeY7cyJ5RmNT0PE?=
 =?us-ascii?Q?VJYhOd/rBXkNIWUQ0t6KmnIaaiXHRs6DGxwh1sRw5ObXCGGtsScmg+uKxUNp?=
 =?us-ascii?Q?PiZU5QJZK7VLHzUF32Bqar8rnzsQyd3WnMPU7VUi9JvbSfIGPuCj8ypc7JAx?=
 =?us-ascii?Q?uew6daW4XKttC4lJ8sQoWu6J1gQng2p2YpTOtS5XRHyXzH+ZGpDGNT04z6EL?=
 =?us-ascii?Q?fci4+f5xMTQag+0ofRJUz9EHbI/50lFAGRj/tRrIc0JktTd/6pol0ByP0C1K?=
 =?us-ascii?Q?z2dB/MHnSp9YpIFt4uWctpX2kYUHE1ZFLvfc/7jPsYKakKefx9xkkno4J6BA?=
 =?us-ascii?Q?aXU6N/E3zDIpeGiH7JOLognk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2809e527-5fd0-4eba-2f50-08d8fed0d7dd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 23:07:00.3573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JAUQaBrMLU925jZEUtNOly7U+W0/5S2S7gHXBxBOQMqEHqEHoWOe2Qy6zliqS/iWDBxZVAL092UP+WDCGLkFU932d8R6QlsVxamThC1z+yc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130148
X-Proofpoint-ORIG-GUID: lER5tCPnEXvtwK_ENuZn_W_EWmAhlL_I
X-Proofpoint-GUID: lER5tCPnEXvtwK_ENuZn_W_EWmAhlL_I
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130148
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When we added iser and all thes offload drivers I goofed and didn't add
a unbind_conn nl cmd to undo the bind_conn. So during ep_disconnect we
have been doing iscsi_suspend_tx/queue to stop new IO but depending on
the driver we can still get IO from:

1. __iscsi_conn_send_pdu for TMFs and nops if we haven't called
iscsi_conn_failure before ep_disconnect.
2. Userspace did a ep_disconnect during shutdown before we saw a
logout command and userspace didn't do an session unbind event.

This patch fixes the issue by adding a helper which drivers implementing
ep_disconnect can use to make sure new IO is not queued to them after
calling it and until we do a new conn_bind.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  2 +
 drivers/scsi/be2iscsi/be_iscsi.c         |  2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c         |  2 +-
 drivers/scsi/cxgbi/libcxgbi.c            |  3 +-
 drivers/scsi/libiscsi.c                  | 56 +++++++++++++++++++++---
 drivers/scsi/qedi/qedi_iscsi.c           |  2 +-
 drivers/scsi/qla4xxx/ql4_def.h           |  1 +
 drivers/scsi/qla4xxx/ql4_os.c            |  2 +
 include/scsi/libiscsi.h                  |  1 +
 9 files changed, 61 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 8fcaa1136f2c..3089502116a5 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -899,6 +899,8 @@ iscsi_iser_ep_disconnect(struct iscsi_endpoint *ep)
 
 	iser_info("ep %p iser conn %p\n", ep, iser_conn);
 
+	iscsi_ep_prep_disconnect(iser_conn->iscsi_conn);
+
 	mutex_lock(&iser_conn->state_mutex);
 	iser_conn_terminate(iser_conn);
 
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index a13c203ef7a9..a3b5f7f6ccc8 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1314,7 +1314,7 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 
 	if (beiscsi_ep->conn) {
 		beiscsi_conn = beiscsi_ep->conn;
-		iscsi_suspend_queue(beiscsi_conn->conn);
+		iscsi_ep_prep_disconnect(beiscsi_conn->conn);
 	}
 
 	if (!beiscsi_hba_is_online(phba)) {
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 1e6d8f62ea3c..5cbca9657c35 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -2129,7 +2129,7 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
 	if (bnx2i_ep->conn) {
 		bnx2i_conn = bnx2i_ep->conn;
 		conn = bnx2i_conn->cls_conn->dd_data;
-		iscsi_suspend_queue(conn);
+		iscsi_ep_prep_disconnect(conn);
 	}
 	hba = bnx2i_ep->hba;
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index f078b3c4e083..dd7b41a092f1 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2968,7 +2968,8 @@ void cxgbi_ep_disconnect(struct iscsi_endpoint *ep)
 		ep, cep, cconn, csk, csk->state, csk->flags);
 
 	if (cconn && cconn->iconn) {
-		iscsi_suspend_tx(cconn->iconn);
+		iscsi_ep_prep_disconnect(cconn->iconn);
+
 		write_lock_bh(&csk->callback_lock);
 		cep->csk->user_data = NULL;
 		cconn->cep = NULL;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 3ff440d37a36..3a37628e4024 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1387,22 +1387,28 @@ void iscsi_session_failure(struct iscsi_session *session,
 }
 EXPORT_SYMBOL_GPL(iscsi_session_failure);
 
-void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
+static void iscsi_set_conn_failed(struct iscsi_conn *conn)
 {
 	struct iscsi_session *session = conn->session;
 
-	spin_lock_bh(&session->frwd_lock);
-	if (session->state == ISCSI_STATE_FAILED) {
-		spin_unlock_bh(&session->frwd_lock);
+	if (session->state == ISCSI_STATE_FAILED)
 		return;
-	}
 
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
-	spin_unlock_bh(&session->frwd_lock);
 
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+}
+
+void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
+{
+	struct iscsi_session *session = conn->session;
+
+	spin_lock_bh(&session->frwd_lock);
+	iscsi_set_conn_failed(conn);
+	spin_unlock_bh(&session->frwd_lock);
+
 	iscsi_conn_error_event(conn->cls_conn, err);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_failure);
@@ -2220,6 +2226,44 @@ static void iscsi_check_transport_timeouts(struct timer_list *t)
 	spin_unlock(&session->frwd_lock);
 }
 
+/*
+ * iscsi_ep_prep_disconnect - prepare the conn for a ep disconnect
+ * @conn: iscsi conn ep is bound to.
+ *
+ * This must be called by drivers implementing the ep_disconnect callout.
+ */
+void iscsi_ep_prep_disconnect(struct iscsi_conn *conn)
+{
+	struct iscsi_session *session;
+
+	/* Check if bound for the driver */
+	if (!conn)
+		return;
+
+	session = conn->session;
+	/*
+	 * Wait for iscsi_eh calls to exit. We don't wait for the tmf to
+	 * complete or timeout. The caller just wants to know what's running
+	 * is everything that needs to be cleaned up, and no cmds will be
+	 * queued.
+	 */
+	mutex_lock(&session->eh_mutex);
+	spin_lock_bh(&session->frwd_lock);
+
+	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
+	/*
+	 * if logout timed out before userspace could even send a PDU the
+	 * state might still be in ISCSI_STATE_LOGGED_IN and allowing new cmds
+	 * and TMFs.
+	 */
+	if (session->state == ISCSI_STATE_LOGGED_IN)
+		iscsi_set_conn_failed(conn);
+
+	spin_unlock_bh(&session->frwd_lock);
+	mutex_unlock(&session->eh_mutex);
+}
+EXPORT_SYMBOL_GPL(iscsi_ep_prep_disconnect);
+
 static void iscsi_prep_abort_task_pdu(struct iscsi_task *task,
 				      struct iscsi_tm *hdr)
 {
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 08c05403cd72..8ed1852627e7 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -1008,7 +1008,7 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
 	if (qedi_ep->conn) {
 		qedi_conn = qedi_ep->conn;
 		conn = qedi_conn->cls_conn->dd_data;
-		iscsi_suspend_queue(conn);
+		iscsi_ep_prep_disconnect(conn);
 		abrt_conn = qedi_conn->abrt_conn;
 
 		while (count--)	{
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 031569c496e5..4ca7f4228b4b 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -838,6 +838,7 @@ struct ql4_task_data {
 struct qla_endpoint {
 	struct Scsi_Host *host;
 	struct sockaddr_storage dst_addr;
+	struct iscsi_conn *conn;
 };
 
 struct qla_conn {
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 7bd9a4a04ad5..5977fe403086 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1772,6 +1772,7 @@ static void qla4xxx_ep_disconnect(struct iscsi_endpoint *ep)
 	ha = to_qla_host(qla_ep->host);
 	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: host: %ld\n", __func__,
 			  ha->host_no));
+	iscsi_ep_prep_disconnect(qla_ep->conn);
 	iscsi_destroy_endpoint(ep);
 }
 
@@ -3234,6 +3235,7 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
 	conn = cls_conn->dd_data;
 	qla_conn = conn->dd_data;
 	qla_conn->qla_ep = ep->dd_data;
+	qla_conn->qla_ep->conn = conn;
 	return 0;
 }
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 8c6d358a8abc..f409f521681d 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -441,6 +441,7 @@ extern int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
 extern void iscsi_suspend_tx(struct iscsi_conn *conn);
 extern void iscsi_suspend_queue(struct iscsi_conn *conn);
 extern void iscsi_conn_queue_work(struct iscsi_conn *conn);
+extern void iscsi_ep_prep_disconnect(struct iscsi_conn *conn);
 
 #define iscsi_conn_printk(prefix, _c, fmt, a...) \
 	iscsi_cls_conn_printk(prefix, ((struct iscsi_conn *)_c)->cls_conn, \
-- 
2.25.1

