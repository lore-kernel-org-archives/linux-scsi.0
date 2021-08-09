Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D8CC4320A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 09:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28E9160F35
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 09:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhHIJue (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 05:50:34 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:46638 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233166AbhHIJue (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 05:50:34 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 582481FDBC;
        Mon,  9 Aug 2021 09:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1628502613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=M7wLT5FacY3qF/mN1qBpHo6y8qdf8MSlGDyRYK6d2Po=;
        b=MMWce1PCm9YBb7sDkxd50qcGlB5eYGg+1vIcRWIZfVGmC0yEM9iaqSQJxwRlcbDDoYhHqf
        nR7w+l6Llv0406idwttpa9Uz06w1ontdmt3VUM6s4YzXMw/uqoK6ValX653LOo5i0Fp/cV
        +luqBpwwFfySQTn5nn+BN41pSS+kq9g=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 203A613656;
        Mon,  9 Aug 2021 09:50:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id pwekBVX6EGEEOQAAGKfGzw
        (envelope-from <mwilck@suse.com>); Mon, 09 Aug 2021 09:50:13 +0000
From:   mwilck@suse.com
To:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH] ibmvfc: do not wait for initial device scan
Date:   Mon,  9 Aug 2021 11:49:29 +0200
Message-Id: <20210809094929.3987-1-mwilck@suse.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

The initial device scan might take some time, and there really is
no need to wait for it during probe().
So return immediately from scsi_scan_host() during probe() and avoid
any udev stalls during booting.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 11 ++++++++---
 drivers/scsi/ibmvscsi/ibmvfc.h |  1 +
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 935b01ee44b7..9d6550488db1 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3292,14 +3292,18 @@ static int ibmvfc_scan_finished(struct Scsi_Host *shost, unsigned long time)
 	int done = 0;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	if (time >= (init_timeout * HZ)) {
+	if (!vhost->scan_timeout)
+		done = 1;
+	else if (time >= (vhost->scan_timeout * HZ)) {
 		dev_info(vhost->dev, "Scan taking longer than %d seconds, "
-			 "continuing initialization\n", init_timeout);
+			 "continuing initialization\n", vhost->scan_timeout);
 		done = 1;
 	}
 
-	if (vhost->scan_complete)
+	if (vhost->scan_complete) {
+		vhost->scan_timeout = init_timeout;
 		done = 1;
+	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	return done;
 }
@@ -6084,6 +6088,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	vhost->client_scsi_channels = min(shost->nr_hw_queues, nr_scsi_channels);
 	vhost->using_channels = 0;
 	vhost->do_enquiry = 1;
+	vhost->scan_timeout = 0;
 
 	strcpy(vhost->partition_name, "UNKNOWN");
 	init_waitqueue_head(&vhost->work_wait_q);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 92fb889d7eb0..3718406e0988 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -876,6 +876,7 @@ struct ibmvfc_host {
 	int reinit;
 	int delay_init;
 	int scan_complete;
+	int scan_timeout;
 	int logged_in;
 	int mq_enabled;
 	int using_channels;
-- 
2.32.0

