Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739BCC10F27
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49E6D21D56
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgCJQap (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:30:45 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:35552 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726716AbgCJQap (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:30:45 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D7DFA548D466147AF310;
        Wed, 11 Mar 2020 00:30:33 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Mar 2020 00:30:26 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hch@infradead.org>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v2 08/24] scsi: add host tagset busy iterator
Date:   Wed, 11 Mar 2020 00:25:34 +0800
Message-ID: <1583857550-12049-9-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Add an iterator scsi_host_tagset_busy_iter() to easily traverse all
busy commands. No locking is done here; this need to be ensured by
the caller.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hosts.c     | 27 +++++++++++++++++++++++++++
 include/scsi/scsi_host.h |  5 +++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 1d669e47b692..97704a630f8e 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -650,3 +650,30 @@ void scsi_flush_work(struct Scsi_Host *shost)
 	flush_workqueue(shost->work_q);
 }
 EXPORT_SYMBOL_GPL(scsi_flush_work);
+
+struct scsi_host_tagset_busy_iter_data {
+	scsi_host_busy_iter_fn *fn;
+	void *priv;
+};
+
+static bool scsi_host_tagset_busy_iter_fn(struct request *req, void *priv,
+					  bool reserved)
+{
+	struct scsi_host_tagset_busy_iter_data *iter_data = priv;
+	struct scsi_cmnd *sc = blk_mq_rq_to_pdu(req);
+
+	return iter_data->fn(sc, iter_data->priv, reserved);
+}
+
+void scsi_host_tagset_busy_iter(struct Scsi_Host *shost,
+				scsi_host_busy_iter_fn *fn, void *priv)
+{
+	struct scsi_host_tagset_busy_iter_data iter_data = {
+		.fn = fn,
+		.priv = priv,
+	};
+
+	blk_mq_tagset_busy_iter(&shost->tag_set, scsi_host_tagset_busy_iter_fn,
+				&iter_data);
+}
+EXPORT_SYMBOL_GPL(scsi_host_tagset_busy_iter);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 2258a4f7b4d8..663aef22437a 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -767,6 +767,11 @@ static inline int scsi_host_scan_allowed(struct Scsi_Host *shost)
 extern void scsi_unblock_requests(struct Scsi_Host *);
 extern void scsi_block_requests(struct Scsi_Host *);
 
+typedef bool (scsi_host_busy_iter_fn)(struct scsi_cmnd *, void *, bool);
+
+void scsi_host_tagset_busy_iter(struct Scsi_Host *,
+				scsi_host_busy_iter_fn *fn, void *priv);
+
 struct class_container;
 
 /*
-- 
2.17.1

