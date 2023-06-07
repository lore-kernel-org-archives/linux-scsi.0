Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4417DC7EE25
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 18:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjFGS0n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 14:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbjFGSYq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 14:24:46 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864122134;
        Wed,  7 Jun 2023 11:24:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D5CF221A1F;
        Wed,  7 Jun 2023 18:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686162199; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xr1XcDgRZw9XqtqsIfNxxAv7284ffceOajLjHlMMpp4=;
        b=cAGzOg5ynQmo8kTz93ic/RMaAf8m7w0Ji+4mj9dd2vzAAE7l+ukLuqL9wUOdwz1RBJNhlb
        /whl4Kf3jCvQRzCH9f59C54ARV65DDgITDmZ0K1FhkShCOHtfNq0h/ow0hHXdDlDYc/tby
        WVq/m2k8NNAQqbuTlDBlcqxC3fPlsdw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6A8321346D;
        Wed,  7 Jun 2023 18:23:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0G8vGBfLgGRzBQAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 07 Jun 2023 18:23:19 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 7/8] scsi: have scsi_target_block() expect a scsi_target parent argument
Date:   Wed,  7 Jun 2023 20:22:48 +0200
Message-Id: <20230607182249.22623-8-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607182249.22623-1-mwilck@suse.com>
References: <20230607182249.22623-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

All callers (fc_remote_port_delete(), __iscsi_block_session(),
__srp_start_tl_fail_timers(), srp_reconnect_rport(), snic_tgt_del()) pass
parent devices of scsi_target devices to scsi_target_block().
Simplify scsi_target_block() to assume that it is always passed a parent
device.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 25ec6eb8df7f..e572fc56a8dd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2884,17 +2884,25 @@ target_block(struct device *dev, void *data)
 	return 0;
 }
 
+/**
+ * scsi_target_block - transition all SCSI child devices to SDEV_BLOCK state
+ * @dev: a parent device of one or more scsi_target devices
+ *
+ * Iterate over all children of @dev, which should be scsi_target devices,
+ * and switch all subordinate scsi devices to SDEV_BLOCK state. Wait for
+ * ongoing scsi_queue_rq() calls to finish. May sleep.
+ *
+ * Returns zero if successful or a negative error code upon failure.
+ *
+ * Note:
+ * @dev must not itself be a scsi_target device.
+ */
 void
 scsi_target_block(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 
-	if (scsi_is_target_device(dev))
-		starget_for_each_device(to_scsi_target(dev), NULL,
-					scsi_device_block);
-	else
-		device_for_each_child(dev, NULL, target_block);
-
+	device_for_each_child(dev, NULL, target_block);
 	blk_mq_wait_quiesce_done(&shost->tag_set);
 }
 EXPORT_SYMBOL_GPL(scsi_target_block);
-- 
2.40.1

