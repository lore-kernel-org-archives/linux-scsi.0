Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B147CC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A89460F11
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239891AbhHQJSJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:18:09 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47560 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239508AbhHQJRV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:21 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BB6952002C;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u3bjgrux7rsHECPmu52svL62wT8iytt2e+OmN1xrx3I=;
        b=EOc4+uBIQL9zFa+SfSEJeZzVa8xY7uzF2Bm8GZ9Gcv4Wdg6bhYEkMHRB0u4lB8M52qEo4Y
        cqG8v/B29NsagUtb/OEg1jyy+uoY2YQrJgTz3hfAcdRQJq3gOLdbX2vC56jz0xWwIGGSjg
        OCZ94IeOoxvJLL9D3VGjo2mLlt7GdVE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u3bjgrux7rsHECPmu52svL62wT8iytt2e+OmN1xrx3I=;
        b=R1IyHXeZyLJTqMggq6BuE4AhzxfsUXnLFBdwR0MgMJTLCpy/Z9KP8VzrHW2cfAb9vdVaw1
        6Enwruv53AwXZmDg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B728FA3BBA;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id B4760518CEB7; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 44/51] xen-scsifront: add scsi device as argument to scsifront_do_request()
Date:   Tue, 17 Aug 2021 11:14:49 +0200
Message-Id: <20210817091456.73342-45-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add scsi device as argument to scsifront_do_request() so that it
will be possible to call it with a NULL command pointer.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/xen-scsifront.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index ec9d399fbbd8..4f08fb4c1333 100644
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
@@ -202,17 +203,20 @@ static int scsifront_do_request(struct vscsifrnt_info *info,
 	ring_req->ref_rqid    = shadow->ref_rqid;
 	ring_req->nr_segments = shadow->nr_segments;
 
-	ring_req->id      = sc->device->id;
-	ring_req->lun     = sc->device->lun;
-	ring_req->channel = sc->device->channel;
-	ring_req->cmd_len = sc->cmd_len;
-
-	BUG_ON(sc->cmd_len > VSCSIIF_MAX_COMMAND_SIZE);
-
-	memcpy(ring_req->cmnd, sc->cmnd, sc->cmd_len);
-
-	ring_req->sc_data_direction   = (uint8_t)sc->sc_data_direction;
-	ring_req->timeout_per_command = sc->request->timeout / HZ;
+	ring_req->id      = sdev->id;
+	ring_req->lun     = sdev->lun;
+	ring_req->channel = sdev->channel;
+	if (sc) {
+		ring_req->cmd_len = sc->cmd_len;
+		BUG_ON(sc->cmd_len > VSCSIIF_MAX_COMMAND_SIZE);
+		memcpy(ring_req->cmnd, sc->cmnd, sc->cmd_len);
+		ring_req->sc_data_direction   = (uint8_t)sc->sc_data_direction;
+		ring_req->timeout_per_command = sc->request->timeout / HZ;
+	} else {
+		ring_req->cmd_len = VSCSIIF_MAX_COMMAND_SIZE;
+		memset(ring_req->cmnd, 0, VSCSIIF_MAX_COMMAND_SIZE);
+		ring_req->sc_data_direction = DMA_NONE;
+	}
 
 	for (i = 0; i < (shadow->nr_segments & ~VSCSIIF_SG_GRANT); i++)
 		ring_req->seg[i] = shadow->seg[i];
@@ -562,7 +566,7 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
 		return 0;
 	}
 
-	if (scsifront_do_request(info, shadow)) {
+	if (scsifront_do_request(sc->device, info, shadow)) {
 		scsifront_gnttab_done(info, shadow);
 		goto busy;
 	}
@@ -607,7 +611,7 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 		if (scsifront_enter(info))
 			goto fail;
 
-		if (!scsifront_do_request(info, shadow))
+		if (!scsifront_do_request(sc->device, info, shadow))
 			break;
 
 		scsifront_return(info);
-- 
2.29.2

