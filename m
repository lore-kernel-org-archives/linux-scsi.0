Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6101FCDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 09:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbjJPJY4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 05:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232723AbjJPJYt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 05:24:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA1AE1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 02:24:46 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B07BC1FEB8;
        Mon, 16 Oct 2023 09:24:44 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 1FD6C2D10E;
        Mon, 16 Oct 2023 09:24:44 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id DBF4A51EBDCD; Mon, 16 Oct 2023 11:24:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/17] xen-scsifront: rework scsifront_action_handler()
Date:   Mon, 16 Oct 2023 11:24:21 +0200
Message-Id: <20231016092430.55557-9-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231016092430.55557-1-hare@suse.de>
References: <20231016092430.55557-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++++++++
Authentication-Results: smtp-out2.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out2.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [11.49 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[5];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_SPAM_LONG(3.00)[1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-0.00)[22.91%]
X-Rspamd-Queue-Id: B07BC1FEB8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rework scsifront_action_handler() to add the SCSI device as the
first argument, and select between abort and device reset by
checking whether the scsi_cmnd argument is NULL.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/xen-scsifront.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index a0c13200d53a..26dd229aeb22 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -668,11 +668,11 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
  * We have to wait until an answer is returned. This answer contains the
  * result to be returned to the requestor.
  */
-static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
+static int scsifront_action_handler(struct scsi_device *sdev, struct scsi_cmnd *sc)
 {
-	struct Scsi_Host *host = sc->device->host;
+	struct Scsi_Host *host = sdev->host;
 	struct vscsifrnt_info *info = shost_priv(host);
-	struct vscsifrnt_shadow *shadow, *s = scsi_cmd_priv(sc);
+	struct vscsifrnt_shadow *shadow;
 	int err = 0;
 
 	if (info->host_active == STATE_ERROR)
@@ -682,10 +682,14 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 	if (!shadow)
 		return FAILED;
 
-	shadow->act = act;
+	shadow->act = sc ? VSCSIIF_ACT_SCSI_ABORT : VSCSIIF_ACT_SCSI_RESET;
 	shadow->rslt_reset = RSLT_RESET_WAITING;
 	shadow->sc = sc;
-	shadow->ref_rqid = s->rqid;
+	if (sc) {
+		struct vscsifrnt_shadow *s = scsi_cmd_priv(sc);
+
+		shadow->ref_rqid = s->rqid;
+	}
 	init_waitqueue_head(&shadow->wq_reset);
 
 	spin_lock_irq(host->host_lock);
@@ -735,13 +739,13 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 static int scsifront_eh_abort_handler(struct scsi_cmnd *sc)
 {
 	pr_debug("%s\n", __func__);
-	return scsifront_action_handler(sc, VSCSIIF_ACT_SCSI_ABORT);
+	return scsifront_action_handler(sc->device, sc);
 }
 
 static int scsifront_dev_reset_handler(struct scsi_cmnd *sc)
 {
 	pr_debug("%s\n", __func__);
-	return scsifront_action_handler(sc, VSCSIIF_ACT_SCSI_RESET);
+	return scsifront_action_handler(sc->device, NULL);
 }
 
 static int scsifront_sdev_configure(struct scsi_device *sdev)
-- 
2.35.3

