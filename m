Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AFC2C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 11:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41F462068D
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 11:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbgFBLeV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 07:34:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:37940 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgFBLeV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Jun 2020 07:34:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B1D3EAE17;
        Tue,  2 Jun 2020 11:34:20 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/6] scsi: avoid pointless memory allocation in scsi_alloc_target()
Date:   Tue,  2 Jun 2020 13:33:11 +0200
Message-Id: <20200602113311.121513-7-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200602113311.121513-1-hare@suse.de>
References: <20200602113311.121513-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As we already know the index of the requested target in
scsi_alloc_target() we can try to fetch it first before trying
to allocate a new one. This will save us a pointless memory
allocation in case the target is already present and uncontended.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8afb71c036d5..41818111808e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -387,7 +387,7 @@ static void scsi_target_reap_ref_put(struct scsi_target *starget)
  * is responsible for both reaping and doing a last put
  */
 static struct scsi_target *scsi_alloc_target(struct device *parent,
-					     int channel, uint id)
+					     u16 channel, u16 id)
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	struct device *dev = NULL;
@@ -397,7 +397,23 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	struct scsi_target *starget;
 	struct scsi_target *found_target;
 	int error, ref_got;
-	unsigned long tid;
+	unsigned long tid = (channel << 16) | id;
+
+	/*
+	 * Try if the target is already present, and save us
+	 * a pointless memory allocation if so.
+	 */
+	spin_lock_irqsave(shost->host_lock, flags);
+	found_target = xa_load(&shost->__targets, tid);
+	if (found_target) {
+		get_device(&found_target->dev);
+		if (kref_get_unless_zero(&found_target->reap_ref)) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			return found_target;
+		}
+		put_device(&found_target->dev);
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	starget = kzalloc(size, GFP_KERNEL);
 	if (!starget) {
@@ -418,7 +434,6 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
 	starget->max_target_blocked = SCSI_DEFAULT_TARGET_BLOCKED;
-	tid = scsi_target_index(starget);
  retry:
 	spin_lock_irqsave(shost->host_lock, flags);
 	found_target = xa_load(&shost->__targets, tid);
-- 
2.16.4

