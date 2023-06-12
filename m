Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A7CAC88CB2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 16:52:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237350AbjFLQwO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 12:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236999AbjFLQvy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 12:51:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A9CE78;
        Mon, 12 Jun 2023 09:51:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 075BC22826;
        Mon, 12 Jun 2023 16:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686588712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3IDaylanWdawOCNvcT2h7jPPRY8HIy0sw13J65qgWCM=;
        b=PPpcHEijmEQ+8Z9szzCFLZeBTrb6DXgS4RfCY5Jv/YkNbdlmu5M/ObWFr5xPyNV4eOXxSQ
        03Ewu4dD2yrbpJeszzoOhrMUmXq5sor1Q+TpHC8IgxZH8IdqTg4N10KV2MpglC6PsyMYDH
        /l0tEg1MA//Gb22QWPITMINYrkxP1pw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9ECB01357F;
        Mon, 12 Jun 2023 16:51:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UE7xJCdNh2SOXwAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 12 Jun 2023 16:51:51 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 7/7] scsi: improve warning message in scsi_device_block()
Date:   Mon, 12 Jun 2023 18:50:49 +0200
Message-Id: <20230612165049.29440-8-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612165049.29440-1-mwilck@suse.com>
References: <20230612165049.29440-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

If __scsi_internal_device_block() returns an error, it is always -EINVAL
because of an invalid state transition. For debugging purposes, it makes
more sense to print the device state.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1ddd75e6d600..243c7e91e297 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2789,9 +2789,11 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_block_nowait);
 static void scsi_device_block(struct scsi_device *sdev, void *data)
 {
 	int err;
+	enum scsi_device_state state;
 
 	mutex_lock(&sdev->state_mutex);
 	err = __scsi_internal_device_block_nowait(sdev);
+	state = sdev->sdev_state;
 	if (err == 0)
 		/*
 		 * scsi_stop_queue() must be called with the state_mutex
@@ -2802,8 +2804,8 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
 
 	mutex_unlock(&sdev->state_mutex);
 
-	WARN_ONCE(err, "__scsi_internal_device_block_nowait(%s) failed: err = %d\n",
-		  dev_name(&sdev->sdev_gendev), err);
+	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
+		  __func__, dev_name(&sdev->sdev_gendev), state);
 }
 
 /**
-- 
2.40.1

