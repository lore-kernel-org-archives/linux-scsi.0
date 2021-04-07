Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FA9C433B4
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 01:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4589661369
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 01:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347662AbhDGBYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 21:24:55 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15143 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234286AbhDGBYx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 21:24:53 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FFRSj1Y54zpVN5;
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
Subject: [PATCH 1/2] scsi: libiscsi: Split iscsi_session_teardown() to destroy and free
Date:   Wed, 7 Apr 2021 09:24:49 +0800
Message-ID: <20210407012450.97754-2-haowenchao@huawei.com>
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

Split iscsi_session_teardown() to two steps: destroy and free, so we can
destroy a session without freeing it.

Signed-off-by: Wenchao Hao <haowenchao@huawei.com>
Signed-off-by: Wu Bo <wubo40@huawei.com>
---
 drivers/scsi/libiscsi.c | 19 ++++++++++++-------
 include/scsi/libiscsi.h |  1 +
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 04633e5157e9..9b7eb56e3bd8 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2929,11 +2929,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 }
 EXPORT_SYMBOL_GPL(iscsi_session_setup);
 
-/**
- * iscsi_session_teardown - destroy session, host, and cls_session
- * @cls_session: iscsi session
- */
-void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
+void iscsi_session_destroy(struct iscsi_cls_session *cls_session)
 {
 	struct iscsi_session *session = cls_session->dd_data;
 	struct module *owner = cls_session->transport->owner;
@@ -2957,11 +2953,20 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->portal_type);
 	kfree(session->discovery_parent_type);
 
-	iscsi_free_session(cls_session);
-
 	iscsi_host_dec_session_cnt(shost);
 	module_put(owner);
 }
+EXPORT_SYMBOL_GPL(iscsi_session_destroy);
+
+/**
+ * iscsi_session_teardown - destroy session, host, and cls_session
+ * @cls_session: iscsi session
+ */
+void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
+{
+	iscsi_session_destroy(cls_session);
+	iscsi_free_session(cls_session);
+}
 EXPORT_SYMBOL_GPL(iscsi_session_teardown);
 
 /**
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 02f966e9358f..d8eef420766d 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -404,6 +404,7 @@ extern int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
 extern struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *, struct Scsi_Host *shost,
 		    uint16_t, int, int, uint32_t, unsigned int);
+extern void iscsi_session_destroy(struct iscsi_cls_session *);
 extern void iscsi_session_teardown(struct iscsi_cls_session *);
 extern void iscsi_session_recovery_timedout(struct iscsi_cls_session *);
 extern int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
-- 
2.27.0

