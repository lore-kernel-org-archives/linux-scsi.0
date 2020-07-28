Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB13C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 13:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77D6920663
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 13:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbgG1Nsg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 09:48:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:46678 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730018AbgG1Nsf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Jul 2020 09:48:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D492FAE87;
        Tue, 28 Jul 2020 13:48:45 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_transport_srp: sanitize scsi_target_block/unblock sequences
Date:   Tue, 28 Jul 2020 15:48:33 +0200
Message-Id: <20200728134833.42547-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SCSI midlayer does not allow state transitions from SDEV_BLOCK
to SDEV_BLOCK, so calling scsi_target_block() from __rport_fast_io_fail()
is wrong as the port is already blocked.
Similarly we don't need to call scsi_target_unblock() afterwards as the
function has already done this.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_transport_srp.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index d4d1104fac99..cba1cf6a1c12 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -395,6 +395,10 @@ static void srp_reconnect_work(struct work_struct *work)
 	}
 }
 
+/*
+ * scsi_target_block() must have been called before this function is
+ * called to guarantee that no .queuecommand() calls are in progress.
+ */
 static void __rport_fail_io_fast(struct srp_rport *rport)
 {
 	struct Scsi_Host *shost = rport_to_shost(rport);
@@ -404,11 +408,7 @@ static void __rport_fail_io_fast(struct srp_rport *rport)
 
 	if (srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST))
 		return;
-	/*
-	 * Call scsi_target_block() to wait for ongoing shost->queuecommand()
-	 * calls before invoking i->f->terminate_rport_io().
-	 */
-	scsi_target_block(rport->dev.parent);
+
 	scsi_target_unblock(rport->dev.parent, SDEV_TRANSPORT_OFFLINE);
 
 	/* Involve the LLD if possible to terminate all I/O on the rport. */
@@ -570,8 +570,6 @@ int srp_reconnect_rport(struct srp_rport *rport)
 		 * failure timers if these had not yet been started.
 		 */
 		__rport_fail_io_fast(rport);
-		scsi_target_unblock(&shost->shost_gendev,
-				    SDEV_TRANSPORT_OFFLINE);
 		__srp_start_tl_fail_timers(rport);
 	} else if (rport->state != SRP_RPORT_BLOCKED) {
 		scsi_target_unblock(&shost->shost_gendev,
-- 
2.16.4

