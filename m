Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13D2C43470
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 12:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3D8D613C8
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 12:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbhD2M0Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Apr 2021 08:26:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:39512 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230148AbhD2M0Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Apr 2021 08:26:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2DB94B02C;
        Thu, 29 Apr 2021 12:25:36 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] fnic: kill 'exclude_id' argument to fnic_cleanup_io()
Date:   Thu, 29 Apr 2021 14:25:15 +0200
Message-Id: <20210429122517.39659-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210429122517.39659-1-hare@suse.de>
References: <20210429122517.39659-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'exclude_id' is always SCSI_NO_TAG, which will never be reached
when traversing the list of tags.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/fnic/fnic_scsi.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index e619a82f921b..f41d1b1c2e39 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -102,7 +102,7 @@ static const char *fnic_fcpio_status_to_str(unsigned int status)
 	return fcpio_status_str[status];
 }
 
-static void fnic_cleanup_io(struct fnic *fnic, int exclude_id);
+static void fnic_cleanup_io(struct fnic *fnic);
 
 static inline spinlock_t *fnic_io_lock_hash(struct fnic *fnic,
 					    struct scsi_cmnd *sc)
@@ -638,7 +638,7 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 	atomic64_inc(&reset_stats->fw_reset_completions);
 
 	/* Clean up all outstanding io requests */
-	fnic_cleanup_io(fnic, SCSI_NO_TAG);
+	fnic_cleanup_io(fnic);
 
 	atomic64_set(&fnic->fnic_stats.fw_stats.active_fw_reqs, 0);
 	atomic64_set(&fnic->fnic_stats.io_stats.active_ios, 0);
@@ -1361,7 +1361,7 @@ int fnic_wq_copy_cmpl_handler(struct fnic *fnic, int copy_work_to_do)
 	return wq_work_done;
 }
 
-static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
+static void fnic_cleanup_io(struct fnic *fnic)
 {
 	int i;
 	struct fnic_io_req *io_req;
@@ -1372,9 +1372,6 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
 	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
 	for (i = 0; i < fnic->fnic_max_tag_id; i++) {
-		if (i == exclude_id)
-			continue;
-
 		io_lock = fnic_io_lock_tag(fnic, i);
 		spin_lock_irqsave(io_lock, flags);
 		sc = scsi_host_find_tag(fnic->lport->host, i);
-- 
2.29.2

