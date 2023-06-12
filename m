Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F314CC88CB7
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 15:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239134AbjFLPDj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 11:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239204AbjFLPDZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 11:03:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAF5186;
        Mon, 12 Jun 2023 08:03:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1DEEF2282D;
        Mon, 12 Jun 2023 15:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686582203; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z17y6TnSyJ/5qmpSAhVX+KctQTEdoiLh6ukFOT1911I=;
        b=lfec0NuNOSVYomsGJ8Rs3mf4DzZAawVJWzgvVLXNmGp9Mtgv4v3eMrks6EkoF+AZL9yDUC
        oyqeTrPaRdr+1GO+i603+cT6IoH/TXGiNIBtlFu8/r9bVp4sJnGKaYSIqWnZWtajtGgxFO
        TYVKFayNdThjnb/5pSEorgxzGm5QYW0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A5698138EC;
        Mon, 12 Jun 2023 15:03:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EPNxJrozh2RMMAAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 12 Jun 2023 15:03:22 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>
Subject: [PATCH v4 6/6] scsi: replace scsi_target_block() by scsi_block_targets()
Date:   Mon, 12 Jun 2023 17:03:09 +0200
Message-Id: <20230612150309.18103-7-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612150309.18103-1-mwilck@suse.com>
References: <20230612150309.18103-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

All callers (fc_remote_port_delete(), __iscsi_block_session(),
__srp_start_tl_fail_timers(), srp_reconnect_rport(), snic_tgt_del()) pass
parent devices of scsi_target devices to scsi_target_block().

Rename the function to scsi_block_targets(), and simplify it by assuming
that it is always passed a parent device. Also, have callers pass the
Scsi_Host pointer to scsi_block_targets(), as every caller has this pointer
readily available.

Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Karan Tilak Kumar <kartilak@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/scsi_lib.c             | 25 +++++++++++++++----------
 drivers/scsi/scsi_transport_fc.c    |  2 +-
 drivers/scsi/scsi_transport_iscsi.c |  3 ++-
 drivers/scsi/scsi_transport_srp.c   |  6 +++---
 drivers/scsi/snic/snic_disc.c       |  2 +-
 include/scsi/scsi_device.h          |  2 +-
 6 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 183f29705af7..8305e8160791 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2895,20 +2895,25 @@ target_block(struct device *dev, void *data)
 	return 0;
 }
 
+/**
+ * scsi_block_targets - transition all SCSI child devices to SDEV_BLOCK state
+ * @dev: a parent device of one or more scsi_target devices
+ * @shost: the Scsi_Host to which this device belongs
+ *
+ * Iterate over all children of @dev, which should be scsi_target devices,
+ * and switch all subordinate scsi devices to SDEV_BLOCK state. Wait for
+ * ongoing scsi_queue_rq() calls to finish. May sleep.
+ *
+ * Note:
+ * @dev must not itself be a scsi_target device.
+ */
 void
-scsi_target_block(struct device *dev)
+scsi_block_targets(struct device *dev, struct Scsi_Host *shost)
 {
-	struct Scsi_Host *shost = dev_to_shost(dev);
-
-	if (scsi_is_target_device(dev))
-		starget_for_each_device(to_scsi_target(dev), NULL,
-					scsi_device_block);
-	else
-		device_for_each_child(dev, NULL, target_block);
-
+	device_for_each_child(dev, NULL, target_block);
 	blk_mq_wait_quiesce_done(&shost->tag_set);
 }
-EXPORT_SYMBOL_GPL(scsi_target_block);
+EXPORT_SYMBOL_GPL(scsi_block_targets);
 
 static void
 device_unblock(struct scsi_device *sdev, void *data)
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 64ff2629eaf9..7fd90b51a7e6 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3451,7 +3451,7 @@ fc_remote_port_delete(struct fc_rport  *rport)
 
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	scsi_target_block(&rport->dev);
+	scsi_block_targets(&rport->dev, shost);
 
 	/* see if we need to kill io faster than waiting for device loss */
 	if ((rport->fast_io_fail_tmo != -1) &&
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index b9b97300e3b3..0a64ea20f71c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1943,13 +1943,14 @@ static void __iscsi_block_session(struct work_struct *work)
 	struct iscsi_cls_session *session =
 			container_of(work, struct iscsi_cls_session,
 				     block_work);
+	struct Scsi_Host *shost = iscsi_session_to_shost(session);
 	unsigned long flags;
 
 	ISCSI_DBG_TRANS_SESSION(session, "Blocking session\n");
 	spin_lock_irqsave(&session->lock, flags);
 	session->state = ISCSI_SESSION_FAILED;
 	spin_unlock_irqrestore(&session->lock, flags);
-	scsi_target_block(&session->dev);
+	scsi_block_targets(&session->dev, shost);
 	ISCSI_DBG_TRANS_SESSION(session, "Completed SCSI target blocking\n");
 	if (session->recovery_tmo >= 0)
 		queue_delayed_work(session->workq,
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 87d0fb8dc503..787b1a487e51 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -396,7 +396,7 @@ static void srp_reconnect_work(struct work_struct *work)
 }
 
 /*
- * scsi_target_block() must have been called before this function is
+ * scsi_block_targets() must have been called before this function is
  * called to guarantee that no .queuecommand() calls are in progress.
  */
 static void __rport_fail_io_fast(struct srp_rport *rport)
@@ -480,7 +480,7 @@ static void __srp_start_tl_fail_timers(struct srp_rport *rport)
 	    srp_rport_set_state(rport, SRP_RPORT_BLOCKED) == 0) {
 		pr_debug("%s new state: %d\n", dev_name(&shost->shost_gendev),
 			 rport->state);
-		scsi_target_block(&shost->shost_gendev);
+		scsi_block_targets(&shost->shost_gendev, shost);
 		if (fast_io_fail_tmo >= 0)
 			queue_delayed_work(system_long_wq,
 					   &rport->fast_io_fail_work,
@@ -548,7 +548,7 @@ int srp_reconnect_rport(struct srp_rport *rport)
 		 * later is ok though, scsi_internal_device_unblock_nowait()
 		 * treats SDEV_TRANSPORT_OFFLINE like SDEV_BLOCK.
 		 */
-		scsi_target_block(&shost->shost_gendev);
+		scsi_block_targets(&shost->shost_gendev, shost);
 	res = rport->state != SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODEV;
 	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
 		 dev_name(&shost->shost_gendev), rport->state, res);
diff --git a/drivers/scsi/snic/snic_disc.c b/drivers/scsi/snic/snic_disc.c
index 8fbf3c1b1311..f81abeccc386 100644
--- a/drivers/scsi/snic/snic_disc.c
+++ b/drivers/scsi/snic/snic_disc.c
@@ -214,7 +214,7 @@ snic_tgt_del(struct work_struct *work)
 		scsi_flush_work(shost);
 
 	/* Block IOs on child devices, stops new IOs */
-	scsi_target_block(&tgt->dev);
+	scsi_block_targets(&tgt->dev, shost);
 
 	/* Cleanup IOs */
 	snic_tgt_scsi_abort_io(tgt);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index b2cdb078b7bd..b31ec356e8f5 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -456,7 +456,7 @@ extern void scsi_scan_target(struct device *parent, unsigned int channel,
 			     unsigned int id, u64 lun,
 			     enum scsi_scan_mode rescan);
 extern void scsi_target_reap(struct scsi_target *);
-extern void scsi_target_block(struct device *);
+extern void scsi_block_targets(struct device *dev, struct Scsi_Host *shost);
 extern void scsi_target_unblock(struct device *, enum scsi_device_state);
 extern void scsi_remove_target(struct device *);
 extern const char *scsi_device_state_name(enum scsi_device_state);
-- 
2.40.1

