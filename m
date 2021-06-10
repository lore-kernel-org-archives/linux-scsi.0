Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B47C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 13:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C022613E9
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 13:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhFJOAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 10:00:35 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:59930 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbhFJOAf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 10:00:35 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9697F1FD3F;
        Thu, 10 Jun 2021 13:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623333518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=V3w/OOXeUlFpg0DLWW8/k2IXW7PF/Z43rFj24yv3P/w=;
        b=owgvgJ3xBb7uzqRvzju7trpiy5oYT+iTXMSlmKEgd7oiGwmTyZBP/LecdsECSaJwvfc1fE
        1i4t4LoiBv8arIPKx6Anc+gk1sOOrb9jk8CYUAJDgfNsJpKRM9iIoyJ5Ipk7mpqBnsmjQQ
        wkukfinvza4L5JLaap+HJrdn0MV1HFE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623333518;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=V3w/OOXeUlFpg0DLWW8/k2IXW7PF/Z43rFj24yv3P/w=;
        b=+zCmQ/ciF4U3Z42YQoR79zFNKKLcMAiTPJpT6VpElKSvbnQ0S7tkYiNMeMtzw2eDdcsxrW
        BvnV3Nj1KUCGbDCQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 8FD9BA3B8F;
        Thu, 10 Jun 2021 13:58:38 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 779CF517002B; Thu, 10 Jun 2021 15:58:38 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Jiri Slaby <jslaby@suse.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] virtio_scsi: do not overwrite SCSI status
Date:   Thu, 10 Jun 2021 15:58:33 +0200
Message-Id: <20210610135833.46663-1-hare@suse.de>
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
---
 drivers/scsi/virtio_scsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index fd69a03d6137..43177a62916a 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -161,7 +161,6 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 		       min_t(u32,
 			     virtio32_to_cpu(vscsi->vdev, resp->sense_len),
 			     VIRTIO_SCSI_SENSE_SIZE));
-		set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
 	}
 
 	sc->scsi_done(sc);
-- 
2.26.2

