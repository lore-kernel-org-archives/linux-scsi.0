Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E889C43603
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 14:59:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5429E20833
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 14:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbfLDO70 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 09:59:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:36200 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727889AbfLDO7Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Dec 2019 09:59:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D948CADB5;
        Wed,  4 Dec 2019 14:59:23 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        Balsundar P <balsundar.p@microchip.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/13] scsi: add scsi_host_complete_all_commands() helper
Date:   Wed,  4 Dec 2019 15:59:07 +0100
Message-Id: <20191204145918.143134-3-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191204145918.143134-1-hare@suse.de>
References: <20191204145918.143134-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a helper scsi_host_complete_all_commands() to terminate all outstanding
commands on a scsi host.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hosts.c     | 28 ++++++++++++++++++++++++++++
 include/scsi/scsi_host.h |  1 +
 2 files changed, 29 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 1d669e47b692..00ae9d43ce9f 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -650,3 +650,31 @@ void scsi_flush_work(struct Scsi_Host *shost)
 	flush_workqueue(shost->work_q);
 }
 EXPORT_SYMBOL_GPL(scsi_flush_work);
+
+static bool complete_all_cmds_iter(struct request *rq, void *data, bool rsvd)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
+	int status = *(int *)data;
+
+	scsi_dma_unmap(scmd);
+	scmd->result = status << 16;
+	scmd->scsi_done(scmd);
+	return true;
+}
+
+/**
+ * scsi_host_complete_all_commands - Terminate all running commands
+ * @shost:	Scsi Host on which commands should be terminated
+ * @status:	Status to be set for the terminated commands
+ *
+ * There is no protection against modification of the number
+ * of outstanding commands. It is the responsibility of the
+ * caller to ensure that concurrent I/O submission and/or
+ * completion is stopped when calling this function.
+ */
+void scsi_host_complete_all_commands(struct Scsi_Host *shost, int status)
+{
+	blk_mq_tagset_busy_iter(&shost->tag_set, complete_all_cmds_iter,
+				&status);
+}
+EXPORT_SYMBOL_GPL(scsi_host_complete_all_commands);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f577647bf5f2..5c61f128f8e6 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -735,6 +735,7 @@ extern int scsi_host_busy(struct Scsi_Host *shost);
 extern void scsi_host_put(struct Scsi_Host *t);
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
 extern const char *scsi_host_state_name(enum scsi_host_state);
+extern void scsi_host_complete_all_commands(struct Scsi_Host *shost, int status);
 
 static inline int __must_check scsi_add_host(struct Scsi_Host *host,
 					     struct device *dev)
-- 
2.16.4

