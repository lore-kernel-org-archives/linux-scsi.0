Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0DCC25B41
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 07:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233517AbjJWHaX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 03:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbjJWHaS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 03:30:18 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB173D66
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 00:30:16 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 73F241FE14;
        Mon, 23 Oct 2023 07:30:15 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 399BD2CF26;
        Mon, 23 Oct 2023 07:30:15 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 6AC7051EC312; Mon, 23 Oct 2023 09:30:15 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] aic79xx: fix up NULL command in ahd_done()
Date:   Mon, 23 Oct 2023 09:30:14 +0200
Message-Id: <20231023073014.21438-1-hare@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++++
Authentication-Results: smtp-out2.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out2.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [7.95 / 50.00];
         ARC_NA(0.00)[];
         BAYES_SPAM(2.46)[91.29%];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[6];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2]
X-Rspamd-Queue-Id: 73F241FE14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Found by smatch.

Fixes: c67e63800446 ("scsi: aic79xx: Do not reference SCSI command when resetting device")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index b3075a022d99..77c91a405d20 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1834,7 +1834,7 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
 		} else {
 			ahd_set_transaction_status(scb, CAM_REQ_CMP);
 		}
-	} else if (ahd_get_transaction_status(scb) == CAM_SCSI_STATUS_ERROR) {
+	} else if (cmd && ahd_get_transaction_status(scb) == CAM_SCSI_STATUS_ERROR) {
 		ahd_linux_handle_scsi_status(ahd, cmd->device, scb);
 	}
 
@@ -1868,7 +1868,8 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
 	}
 
 	ahd_free_scb(ahd, scb);
-	ahd_linux_queue_cmd_complete(ahd, cmd);
+	if (cmd)
+		ahd_linux_queue_cmd_complete(ahd, cmd);
 }
 
 static void
-- 
2.35.3

