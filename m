Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7502C433ED
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 01:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FC6F61369
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 01:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347673AbhDGBY4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 21:24:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15142 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234200AbhDGBYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 21:24:53 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FFRSj1qhnzpVNR;
        Wed,  7 Apr 2021 09:21:57 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.498.0; Wed, 7 Apr 2021
 09:24:33 +0800
From:   Wenchao Hao <haowenchao@huawei.com>
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Wu Bo <wubo40@huawei.com>,
        <linfeilong@huawei.com>, Wenchao Hao <haowenchao@huawei.com>
Subject: [PATCH 2/2] scsi: iscsi_tcp: Fix use-after-free in iscsi_sw_tcp_host_get_param()
Date:   Wed, 7 Apr 2021 09:24:50 +0800
Message-ID: <20210407012450.97754-3-haowenchao@huawei.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210407012450.97754-1-haowenchao@huawei.com>
References: <20210407012450.97754-1-haowenchao@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iscsi_sw_tcp_host_get_param() would access struct iscsi_session, while
struct iscsi_session might be freed by session destroy flow in
iscsi_free_session(). This commit fix this condition by freeing session
after host has already been removed.

Signed-off-by: Wenchao Hao <haowenchao@huawei.com>
---
 drivers/scsi/iscsi_tcp.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index dd33ce0e3737..d559abd3694c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -839,6 +839,18 @@ iscsi_sw_tcp_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 	iscsi_tcp_conn_get_stats(cls_conn, stats);
 }
 
+static void
+iscsi_sw_tcp_session_teardown(struct iscsi_cls_session *cls_session)
+{
+	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
+
+	iscsi_session_destroy(cls_session);
+	iscsi_host_remove(shost);
+
+	iscsi_free_session(cls_session);
+	iscsi_host_free(shost);
+}
+
 static struct iscsi_cls_session *
 iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 			    uint16_t qdepth, uint32_t initial_cmdsn)
@@ -884,12 +896,13 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 	tcp_sw_host = iscsi_host_priv(shost);
 	tcp_sw_host->session = session;
 
-	if (iscsi_tcp_r2tpool_alloc(session))
-		goto remove_session;
+	if (iscsi_tcp_r2tpool_alloc(session)) {
+		iscsi_sw_tcp_session_teardown(cls_session);
+		return NULL;
+	}
+
 	return cls_session;
 
-remove_session:
-	iscsi_session_teardown(cls_session);
 remove_host:
 	iscsi_host_remove(shost);
 free_host:
@@ -899,17 +912,13 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 
 static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 {
-	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 	struct iscsi_session *session = cls_session->dd_data;
 
 	if (WARN_ON_ONCE(session->leadconn))
 		return;
 
 	iscsi_tcp_r2tpool_free(cls_session->dd_data);
-	iscsi_session_teardown(cls_session);
-
-	iscsi_host_remove(shost);
-	iscsi_host_free(shost);
+	iscsi_sw_tcp_session_teardown(cls_session);
 }
 
 static umode_t iscsi_sw_tcp_attr_is_visible(int param_type, int param)
-- 
2.27.0

