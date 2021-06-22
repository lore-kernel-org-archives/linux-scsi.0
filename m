Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F6EFC2B9F4
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 09:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BD56611CE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 09:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhFVJOa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 05:14:30 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37240 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhFVJOa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jun 2021 05:14:30 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 40B82219AB;
        Tue, 22 Jun 2021 09:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624353134; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=KSWK8ki18wVvcYQC6XbHHuo2ZL29u3LbvBC057x5P9M=;
        b=NZSfEVrVjmdP6zhBZiNxjZleTUVHwBk8oJ3WiYI9w+gRUYJF8Hym+QElzjO7MdMD6r6MhQ
        SUDCS5y6dKMLSFGw+0p66yHCFVJIFAJSfrQwT8zfjul9rJVvbtKXa3rOKI2Ok8KPeWH7G4
        k+H5AAA+znaQBnDgLNV79F02eZ0DS9I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624353134;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=KSWK8ki18wVvcYQC6XbHHuo2ZL29u3LbvBC057x5P9M=;
        b=1XriRPAVDd51jt0EJbWVcip3IcA+xa7wReQXt+5stSeNP5Zy/iofko8t1atNiWKjhRSjp0
        6CtL0H99dzhMLvAQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 18FA9A3B84;
        Tue, 22 Jun 2021 09:12:14 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 04BC051707AC; Tue, 22 Jun 2021 11:12:13 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCHv2] virtio_scsi: do not overwrite SCSI status
Date:   Tue, 22 Jun 2021 11:11:53 +0200
Message-Id: <20210622091153.29231-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a sense code is present we should not override the scsi status;
the driver already sets it based on the response from the hypervisor.

Fixes:  464a00c9e0ad ("scsi: core: Kill DRIVER_SENSE")
Signed-off-by: Hannes Reinecke <hare@suse.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Jiri Slaby <jirislaby@kernel.org>
---
 drivers/scsi/virtio_scsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index fd69a03d6137..ad78bf631900 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -156,12 +156,11 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 
 	WARN_ON(virtio32_to_cpu(vscsi->vdev, resp->sense_len) >
 		VIRTIO_SCSI_SENSE_SIZE);
-	if (sc->sense_buffer) {
+	if (resp->sense_len) {
 		memcpy(sc->sense_buffer, resp->sense,
 		       min_t(u32,
 			     virtio32_to_cpu(vscsi->vdev, resp->sense_len),
 			     VIRTIO_SCSI_SENSE_SIZE));
-		set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
 	}
 
 	sc->scsi_done(sc);
-- 
2.29.2

