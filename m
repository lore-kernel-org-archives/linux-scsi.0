Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32237C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 22:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387827AbiEBWFe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 18:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387798AbiEBWDw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 18:03:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2922602
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 15:00:05 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E266621878;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651528800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ry5H6cMidPWYUAqkFmsNUYphLy8pO7JStnwRsjeJSZ0=;
        b=Q5Lw3i34ThhYAXf4jNqjWSqIN66EwlBvX+Sk1jTg+AYgff3zkvuSaTqxdXUMklPTsal5I3
        Xgk1aADl/EinDpa9DqSi3ArU2aVb6VqCu400Q6c2h62g6iggBxmHzTmMTLqtjRVVI1S3S1
        REXDMrESWI+K11gZK89l6+WJAHZJcKo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651528800;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ry5H6cMidPWYUAqkFmsNUYphLy8pO7JStnwRsjeJSZ0=;
        b=9KqoUFdmtvv3jI5ESWlBjjw3zpMlq1xQSJHeuGu6h17jrO4UJj/oklRaBvyF71LZX13HZY
        Da2xLH3jqZxr+/Dg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id DC6AF2C161;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id D9CBB5194160; Tue,  3 May 2022 00:00:00 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 09/11] xen-scsifront: add scsi device as argument to scsifront_do_request()
Date:   Mon,  2 May 2022 23:59:51 +0200
Message-Id: <20220502215953.5463-17-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502215953.5463-1-hare@suse.de>
References: <20220502215953.5463-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add scsi device as argument to scsifront_do_request() so that it
will be possible to call it with a NULL command pointer.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/xen-scsifront.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 12109e4c73d4..9de099532f8b 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -175,7 +175,8 @@ static void scsifront_put_rqid(struct vscsifrnt_info *info, uint32_t id)
 		scsifront_wake_up(info);
 }
 
-static int scsifront_do_request(struct vscsifrnt_info *info,
+static int scsifront_do_request(struct scsi_device *sdev,
+				struct vscsifrnt_info *info,
 				struct vscsifrnt_shadow *shadow)
 {
 	struct vscsiif_front_ring *ring = &(info->ring);
@@ -202,17 +203,25 @@ static int scsifront_do_request(struct vscsifrnt_info *info,
 	ring_req->ref_rqid    = shadow->ref_rqid;
 	ring_req->nr_segments = shadow->nr_segments;
 
-	ring_req->id      = sc->device->id;
-	ring_req->lun     = sc->device->lun;
-	ring_req->channel = sc->device->channel;
-	ring_req->cmd_len = sc->cmd_len;
+	ring_req->id      = sdev->id;
+	ring_req->lun     = sdev->lun;
+	ring_req->channel = sdev->channel;
 
-	BUG_ON(sc->cmd_len > VSCSIIF_MAX_COMMAND_SIZE);
+	if (sc) {
+		ring_req->cmd_len = sc->cmd_len;
 
-	memcpy(ring_req->cmnd, sc->cmnd, sc->cmd_len);
+		BUG_ON(sc->cmd_len > VSCSIIF_MAX_COMMAND_SIZE);
 
-	ring_req->sc_data_direction   = (uint8_t)sc->sc_data_direction;
-	ring_req->timeout_per_command = scsi_cmd_to_rq(sc)->timeout / HZ;
+		memcpy(ring_req->cmnd, sc->cmnd, sc->cmd_len);
+
+		ring_req->sc_data_direction   = (uint8_t)sc->sc_data_direction;
+		ring_req->timeout_per_command =
+			scsi_cmd_to_rq(sc)->timeout / HZ;
+	} else {
+		ring_req->cmd_len = VSCSIIF_MAX_COMMAND_SIZE;
+		memset(ring_req->cmnd, 0, VSCSIIF_MAX_COMMAND_SIZE);
+		ring_req->sc_data_direction = DMA_NONE;
+	}
 
 	for (i = 0; i < (shadow->nr_segments & ~VSCSIIF_SG_GRANT); i++)
 		ring_req->seg[i] = shadow->seg[i];
@@ -561,7 +570,7 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
 		return 0;
 	}
 
-	if (scsifront_do_request(info, shadow)) {
+	if (scsifront_do_request(sc->device, info, shadow)) {
 		scsifront_gnttab_done(info, shadow);
 		goto busy;
 	}
@@ -606,7 +615,7 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 		if (scsifront_enter(info))
 			goto fail;
 
-		if (!scsifront_do_request(info, shadow))
+		if (!scsifront_do_request(sc->device, info, shadow))
 			break;
 
 		scsifront_return(info);
-- 
2.29.2

