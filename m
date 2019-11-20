Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DECC432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 10:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BFBB2244A
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 10:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbfKTKb2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 05:31:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:49202 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727960AbfKTKb2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 05:31:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 74C4DB292;
        Wed, 20 Nov 2019 10:31:26 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 09/11] scsi: add scsi_host_busy_iter()
Date:   Wed, 20 Nov 2019 11:31:12 +0100
Message-Id: <20191120103114.24723-10-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191120103114.24723-1-hare@suse.de>
References: <20191120103114.24723-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add an iterator scsi_host_busy_iter() to traverse all busy commands.
If locking against concurrent command completions is required it
has to be provided by the caller.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hosts.c     | 33 +++++++++++++++++++++++++++++++++
 include/scsi/scsi_host.h |  5 +++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index c26fa1fe6103..23e8c8a38d1f 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -679,3 +679,36 @@ void scsi_host_flush_commands(struct Scsi_Host *shost, int status)
 	blk_mq_tagset_busy_iter(&shost->tag_set, flush_cmds_iter, &status);
 }
 EXPORT_SYMBOL_GPL(scsi_host_flush_commands);
+
+struct scsi_host_busy_iter_data {
+	scsi_host_busy_iter_fn *fn;
+	void *priv;
+};
+
+static bool __scsi_host_busy_iter_fn(struct request *req, void *priv,
+				   bool reserved)
+{
+	struct scsi_host_busy_iter_data *iter_data = priv;
+	struct scsi_cmnd *sc = blk_mq_rq_to_pdu(req);
+
+	return iter_data->fn(sc, iter_data->priv, reserved);
+}
+
+/**
+ * scsi_host_busy_iter - Iterate over all busy commands
+ * @shost:	Pointer to Scsi_Host.
+ * @fn:		Function to call on each busy command
+ * @priv:	Data pointer passed to @fn
+ **/
+void scsi_host_busy_iter(struct Scsi_Host *shost,
+			 scsi_host_busy_iter_fn *fn, void *priv)
+{
+	struct scsi_host_busy_iter_data iter_data = {
+		.fn = fn,
+		.priv = priv,
+	};
+
+	blk_mq_tagset_busy_iter(&shost->tag_set, __scsi_host_busy_iter_fn,
+				&iter_data);
+}
+EXPORT_SYMBOL_GPL(scsi_host_busy_iter);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index cb9a6fe9ad5b..1293d9686115 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -761,6 +761,11 @@ static inline int scsi_host_scan_allowed(struct Scsi_Host *shost)
 extern void scsi_unblock_requests(struct Scsi_Host *);
 extern void scsi_block_requests(struct Scsi_Host *);
 
+typedef bool (scsi_host_busy_iter_fn)(struct scsi_cmnd *, void *, bool);
+
+void scsi_host_busy_iter(struct Scsi_Host *,
+			 scsi_host_busy_iter_fn *fn, void *priv);
+
 struct class_container;
 
 /*
-- 
2.16.4

