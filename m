Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE2EFC7EE2E
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 18:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjFGSYL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 14:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjFGSXr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 14:23:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314E62711;
        Wed,  7 Jun 2023 11:23:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0E6CD21A1E;
        Wed,  7 Jun 2023 18:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686162198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gcWJ/FMqmwc6clgHxsDNCZDPW0c5pmCkA5iwQiwV4Gc=;
        b=AX65f+3u4vUcDLJUTGCGeL84uf9W4yip8/BT2RzeMcvJ9tp0yncwk7ItUwFeO9RaIHAop0
        jRU6yWeUAIS6mWfcRV79RgAFqJ21naF2m9bJSxZe0CMNwRYh34R9Gh72WN3psBG3dw7yGI
        n1DasKknx2GwQ172loBgCz406Vqz7cI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6D49F1346D;
        Wed,  7 Jun 2023 18:23:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oPwKFxXLgGRzBQAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 07 Jun 2023 18:23:17 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 4/8] scsi: call scsi_stop_queue() without state_mutex held
Date:   Wed,  7 Jun 2023 20:22:45 +0200
Message-Id: <20230607182249.22623-5-mwilck@suse.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230607182249.22623-1-mwilck@suse.com>
References: <20230607182249.22623-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

sdev->state_mutex protects only sdev->sdev_state. There's no reason
to keep it held while calling scsi_stop_queue().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ce5788643011..26e7ce25fa05 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2795,9 +2795,9 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
 
 	mutex_lock(&sdev->state_mutex);
 	err = __scsi_internal_device_block_nowait(sdev);
+	mutex_unlock(&sdev->state_mutex);
 	if (err == 0)
 		scsi_stop_queue(sdev, false);
-	mutex_unlock(&sdev->state_mutex);
 
 	WARN_ONCE(err, "__scsi_internal_device_block_nowait(%s) failed: err = %d\n",
 		  dev_name(&sdev->sdev_gendev), err);
-- 
2.40.1

