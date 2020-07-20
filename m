Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D5DDC433E5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 02:57:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B291208B3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 02:57:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgGTC55 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 22:57:57 -0400
Received: from smtp.infotech.no ([82.134.31.41]:42973 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgGTC54 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Jul 2020 22:57:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 4545020425B;
        Mon, 20 Jul 2020 04:57:55 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qJ3vBswFCJhB; Mon, 20 Jul 2020 04:57:53 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id B625A20423F;
        Mon, 20 Jul 2020 04:57:51 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v5 6/9] scsi: avoid pointless memory allocation in scsi_alloc_target()
Date:   Sun, 19 Jul 2020 22:57:39 -0400
Message-Id: <20200720025742.349296-7-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200720025742.349296-1-dgilbert@interlog.com>
References: <20200720025742.349296-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

As we already know the index of the requested target in
scsi_alloc_target() we can try to fetch it first before trying
to allocate a new one. This will save us a pointless memory
allocation in case the target is already present and uncontended.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
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
2.25.1

