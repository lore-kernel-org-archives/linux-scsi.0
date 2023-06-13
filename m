Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14043EB64D8
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 17:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239828AbjFMRmt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 13:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239815AbjFMRmi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 13:42:38 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C753C12C;
        Tue, 13 Jun 2023 10:42:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 790331FDB3;
        Tue, 13 Jun 2023 17:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686678156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WzUnbj2Z8R2eaoIp796RXqZoXFmua2lq+BATt4dO7+M=;
        b=fybD/6nJ5nm9pwxvwVFuQG0PwhN5jYfSiBzz8sB3Ln4enykuiGxKtYMEEvgCvbhkGX9RLF
        YRBctEUtEnk8V8F1NaHPYS04ujUFUnx1maPd4gDakRFQIqvl3kpo0OYvFMlMoUu6bCeh9z
        IFGaMWLQ5spHbRIVtmvpc9hYG3eC40k=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1E28A13483;
        Tue, 13 Jun 2023 17:42:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UM5yBYyqiGSWXwAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 13 Jun 2023 17:42:36 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v6 7/7] scsi: improve warning message in scsi_device_block()
Date:   Tue, 13 Jun 2023 19:42:27 +0200
Message-Id: <20230613174227.11235-8-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230613174227.11235-1-mwilck@suse.com>
References: <20230613174227.11235-1-mwilck@suse.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_lib.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4607e4ea169e..9fe0fe1feba7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2790,9 +2790,11 @@ EXPORT_SYMBOL_GPL(scsi_internal_device_block_nowait);
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
@@ -2803,8 +2805,8 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
 
 	mutex_unlock(&sdev->state_mutex);
 
-	WARN_ONCE(err, "__scsi_internal_device_block_nowait(%s) failed: err = %d\n",
-		  dev_name(&sdev->sdev_gendev), err);
+	WARN_ONCE(err, "%s: failed to block %s in state %d\n",
+		  __func__, dev_name(&sdev->sdev_gendev), state);
 }
 
 /**
-- 
2.40.1

