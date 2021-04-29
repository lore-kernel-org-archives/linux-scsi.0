Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E679C43600
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 12:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1598613F0
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 12:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbhD2M0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Apr 2021 08:26:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:39524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234903AbhD2M0Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Apr 2021 08:26:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 31CD4B11D;
        Thu, 29 Apr 2021 12:25:36 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] fnic: check for started requests in fnic_wq_copy_cleanup_handler()
Date:   Thu, 29 Apr 2021 14:25:17 +0200
Message-Id: <20210429122517.39659-4-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210429122517.39659-1-hare@suse.de>
References: <20210429122517.39659-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

fnic_wq_copy_cleanup_handler() is using scsi_host_find_tag() to
map id to a scsi command. However, as per discussion on the mailinglist
scsi_host_find_tag() might return a non-started request, so we need
to check the returned command with blk_mq_request_started() to avoid
the function tripping over a non-initialized command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/fnic/fnic_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 762cc8bd2653..b9fd3d87416b 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1466,7 +1466,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
 		return;
 
 	sc = scsi_host_find_tag(fnic->lport->host, id);
-	if (!sc)
+	if (!sc || !blk_mq_request_started(sc->request))
 		return;
 
 	io_lock = fnic_io_lock_hash(fnic, sc);
-- 
2.29.2

