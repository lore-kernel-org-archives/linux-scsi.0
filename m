Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 900E3C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 25 May 2022 08:11:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236012AbiEYILx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 04:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236082AbiEYILr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 04:11:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E72637A07
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 01:11:46 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id CF7461F905;
        Wed, 25 May 2022 08:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653466304; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=OfP9r62jn+CXI2avoP5YI171LAlZH73VlP1pt+/Y2Pk=;
        b=vzerogMQFc+oqEQJAxhFGyKB0+im4Ubx7zgw0MnhLbra62TV7Dab/OPS5fa0TkScrSxcRd
        o4waPoDFXzGOucEChryC/t1sPpJjvTZxp7HuSTakzqmOc90K/J7VhTmaXDzFVXqqobt6aG
        F472DghUyL8zEWtDVDG6+mYUS8wL7dk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653466304;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=OfP9r62jn+CXI2avoP5YI171LAlZH73VlP1pt+/Y2Pk=;
        b=6+1b9V6sm8NP2romTR2oK6WeGYDSE4st/sWAF8o7L3EzeiLiyPWkUSJGNK6iXm+gWUiFjm
        DNeeG4Vy8RD0KUAA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id C13522C141;
        Wed, 25 May 2022 08:11:44 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id B453051946C4; Wed, 25 May 2022 10:11:44 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Brian Bunker <brian@purestorage.com>,
        Martin Wilck <mwilck@suse.de>
Subject: [PATCH] scsi_dh_alua: mark port group as failed after ALUA transitioning timeout
Date:   Wed, 25 May 2022 10:11:39 +0200
Message-Id: <20220525081139.88165-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When ALUA transitioning timeout triggers the path group state must
be considered invalid. So add a new flag ALUA_PG_FAILED to indicate
that the path state isn't necessarily valid, and keep the existing
path state until we get a valid response from a RTPG.

Cc: Brian Bunker <brian@purestorage.com>
Cc: Martin Wilck <mwilck@suse.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 24 +++++++---------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 1d9be771f3ee..6921490a5e65 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -49,6 +49,7 @@
 #define ALUA_PG_RUN_RTPG		0x10
 #define ALUA_PG_RUN_STPG		0x20
 #define ALUA_PG_RUNNING			0x40
+#define ALUA_PG_FAILED			0x80
 
 static uint optimize_stpg;
 module_param(optimize_stpg, uint, S_IRUGO|S_IWUSR);
@@ -420,7 +421,7 @@ static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
 			 */
 			rcu_read_lock();
 			pg = rcu_dereference(h->pg);
-			if (pg)
+			if (pg && !(pg->flags & ALUA_PG_FAILED))
 				pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
 			rcu_read_unlock();
 			alua_check(sdev, false);
@@ -694,7 +695,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 
  skip_rtpg:
 	spin_lock_irqsave(&pg->lock, flags);
-	if (transitioning_sense)
+	if (transitioning_sense && !(pg->flags & ALUA_PG_FAILED))
 		pg->state = SCSI_ACCESS_STATE_TRANSITIONING;
 
 	if (group_id_old != pg->group_id || state_old != pg->state ||
@@ -718,23 +719,10 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			pg->interval = ALUA_RTPG_RETRY_DELAY;
 			err = SCSI_DH_RETRY;
 		} else {
-			struct alua_dh_data *h;
-
-			/* Transitioning time exceeded, set port to standby */
+			/* Transitioning time exceeded, mark pg as failed */
 			err = SCSI_DH_IO;
-			pg->state = SCSI_ACCESS_STATE_STANDBY;
+			pg->flags |= ALUA_PG_FAILED;
 			pg->expiry = 0;
-			rcu_read_lock();
-			list_for_each_entry_rcu(h, &pg->dh_list, node) {
-				if (!h->sdev)
-					continue;
-				h->sdev->access_state =
-					(pg->state & SCSI_ACCESS_STATE_MASK);
-				if (pg->pref)
-					h->sdev->access_state |=
-						SCSI_ACCESS_STATE_PREFERRED;
-			}
-			rcu_read_unlock();
 		}
 		break;
 	case SCSI_ACCESS_STATE_OFFLINE:
@@ -746,6 +734,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		/* Useable path if active */
 		err = SCSI_DH_OK;
 		pg->expiry = 0;
+		/* RTPG succeeded, clear ALUA_PG_FAILED */
+		pg->flags &= ~ALUA_PG_FAILED;
 		break;
 	}
 	spin_unlock_irqrestore(&pg->lock, flags);
-- 
2.29.2

