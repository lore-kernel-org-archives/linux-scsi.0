Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE68C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 09:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C7946105A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 09:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbhDAJLc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 05:11:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:45542 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233604AbhDAJLW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Apr 2021 05:11:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617268281; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=r61cobOzD5Z1IIlyTpsn5NMbAhJSa0S16t24uwaQdHY=;
        b=dHjeyT1kG7rO42Ck4zR16MHd4kasRiJzBA5tOg87mLm/2uM8QpTH13tKEor93kO41/FRwt
        fAkHZMhoL8e1zfGhiXjIVvTphV40zvgRHHb9iR/aX9BF372pxbaEslbQdQYrgrNADsMCmO
        +eoUu2gvLpJR5G78gaFCjPtYgC/cTiA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9CF73B0B6;
        Thu,  1 Apr 2021 09:11:21 +0000 (UTC)
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH] scsi: scsi_transport_srp: don't block target in SRP_PORT_LOST state
Date:   Thu,  1 Apr 2021 11:11:05 +0200
Message-Id: <20210401091105.8046-1-mwilck@suse.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

rport_dev_loss_timedout() sets the rport state to SRP_PORT_LOST and
the SCSI target state to SDEV_TRANSPORT_OFFLINE. If this races with
srp_reconnect_work(), a warning is printed:

Mar 27 18:48:07 ictm1604s01h4 kernel: dev_loss_tmo expired for SRP port-18:1 / host18.
Mar 27 18:48:07 ictm1604s01h4 kernel: ------------[ cut here ]------------
Mar 27 18:48:07 ictm1604s01h4 kernel: scsi_internal_device_block(18:0:0:100) failed: ret = -22
Mar 27 18:48:07 ictm1604s01h4 kernel: Call Trace:
Mar 27 18:48:07 ictm1604s01h4 kernel:  ? scsi_target_unblock+0x50/0x50 [scsi_mod]
Mar 27 18:48:07 ictm1604s01h4 kernel:  starget_for_each_device+0x80/0xb0 [scsi_mod]
Mar 27 18:48:07 ictm1604s01h4 kernel:  target_block+0x24/0x30 [scsi_mod]
Mar 27 18:48:07 ictm1604s01h4 kernel:  device_for_each_child+0x57/0x90
Mar 27 18:48:07 ictm1604s01h4 kernel:  srp_reconnect_rport+0xe4/0x230 [scsi_transport_srp]
Mar 27 18:48:07 ictm1604s01h4 kernel:  srp_reconnect_work+0x40/0xc0 [scsi_transport_srp]

Avoid this by not trying to block targets for rports in SRP_PORT_LOST
state.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_transport_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 1e939a2a387f..98a34ed10f1a 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -541,7 +541,7 @@ int srp_reconnect_rport(struct srp_rport *rport)
 	res = mutex_lock_interruptible(&rport->mutex);
 	if (res)
 		goto out;
-	if (rport->state != SRP_RPORT_FAIL_FAST)
+	if (rport->state != SRP_RPORT_FAIL_FAST && rport->state != SRP_RPORT_LOST)
 		/*
 		 * sdev state must be SDEV_TRANSPORT_OFFLINE, transition
 		 * to SDEV_BLOCK is illegal. Calling scsi_target_unblock()
-- 
2.30.1

