Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4240C3B18C
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 14:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2B2C218AC
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 14:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbgBMOFc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 09:05:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:46298 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730168AbgBMOFa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Feb 2020 09:05:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 92D36AFBC;
        Thu, 13 Feb 2020 14:05:27 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/13] scsi: add scsi_host_busy_iter()
Date:   Thu, 13 Feb 2020 15:04:19 +0100
Message-Id: <20200213140422.128382-11-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200213140422.128382-1-hare@suse.de>
References: <20200213140422.128382-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add an iterator scsi_host_busy_iter() to traverse all busy commands.
If locking against concurrent command completions is required it
has to be provided by the caller.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hosts.c     | 33 +++++++++++++++++++++++++++++++++
 include/scsi/scsi_host.h |  5 +++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 00ae9d43ce9f..91987b9fb45f 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -678,3 +678,36 @@ void scsi_host_complete_all_commands(struct Scsi_Host *shost, int status)
 				&status);
 }
 EXPORT_SYMBOL_GPL(scsi_host_complete_all_commands);
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
index a230e2c0e11f..f5300ad887c4 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -760,6 +760,11 @@ extern void scsi_block_requests(struct Scsi_Host *);
 extern int scsi_host_block(struct Scsi_Host *shost);
 extern int scsi_host_unblock(struct Scsi_Host *shost, int new_state);
 
+typedef bool (scsi_host_busy_iter_fn)(struct scsi_cmnd *, void *, bool);
+
+void scsi_host_busy_iter(struct Scsi_Host *,
+			 scsi_host_busy_iter_fn *fn, void *priv);
+
 struct class_container;
 
 /*
-- 
2.16.4

