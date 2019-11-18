Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2930C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DBF22073A
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfKRJWc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 04:22:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:54562 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726767AbfKRJWb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 04:22:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4EE36AE87;
        Mon, 18 Nov 2019 09:22:30 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/9] scsi: add scsi_host_flush_commands() helper
Date:   Mon, 18 Nov 2019 10:22:01 +0100
Message-Id: <20191118092208.54521-3-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191118092208.54521-1-hare@suse.de>
References: <20191118092208.54521-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a helper scsi_host_flush_commands() to terminate all outstanding
commands on a scsi host.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hosts.c     | 24 ++++++++++++++++++++++++
 include/scsi/scsi_host.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 1d669e47b692..da1df48ef27c 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -650,3 +650,27 @@ void scsi_flush_work(struct Scsi_Host *shost)
 	flush_workqueue(shost->work_q);
 }
 EXPORT_SYMBOL_GPL(scsi_flush_work);
+
+
+/**
+ * scsi_host_flush_commands -- Terminate all running commands
+ * @shost:	Scsi Host on which commands should be terminated
+ * @status:	Status to be set for the terminated commands
+ */
+static bool flush_cmds_iter(struct request *rq, void *data, bool reserved)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(rq);
+	int status = *(int *)data;
+
+	if (reserved)
+		return true;
+	scmd->result = status << 16;
+	scmd->scsi_done(scmd);
+	return true;
+}
+
+void scsi_host_flush_commands(struct Scsi_Host *shost, int status)
+{
+	blk_mq_tagset_busy_iter(&shost->tag_set, flush_cmds_iter, &status);
+}
+EXPORT_SYMBOL_GPL(scsi_host_flush_commands);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f577647bf5f2..cb9a6fe9ad5b 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -735,6 +735,7 @@ extern int scsi_host_busy(struct Scsi_Host *shost);
 extern void scsi_host_put(struct Scsi_Host *t);
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
 extern const char *scsi_host_state_name(enum scsi_host_state);
+extern void scsi_host_flush_commands(struct Scsi_Host *shost, int status);
 
 static inline int __must_check scsi_add_host(struct Scsi_Host *host,
 					     struct device *dev)
-- 
2.16.4

