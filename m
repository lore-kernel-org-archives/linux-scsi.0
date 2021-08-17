Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA31C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 07:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B8546023B
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 07:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbhHQHyD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 03:54:03 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36390 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234402AbhHQHyD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 03:54:03 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 518531FF16;
        Tue, 17 Aug 2021 07:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1629186809; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=jR5mksTQbMltOxfHYpILuo1Kmh9W414axExGd8Q3OB0=;
        b=HphugntEi7+X/tZ11u0rhZgS7jZB7TudHmVPqugZ2uGB9+l4YfRIPqwl4IzJVmPqYBm7bW
        hbU7CaM/clEV0EMVtsoK21SxUGO292CtDD1b4vw+iDck+ObPiwJGCJEHqwOAcNY/1FEN1c
        OlxROHsMfS91F0XGur9aqm45KOE4pFs=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 1736413318;
        Tue, 17 Aug 2021 07:53:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id f5Y3A/lqG2EscAAAGKfGzw
        (envelope-from <mwilck@suse.com>); Tue, 17 Aug 2021 07:53:29 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH RESEND] ibmvfc: do not wait for initial device scan
Date:   Tue, 17 Aug 2021 09:53:06 +0200
Message-Id: <20210817075306.11315-1-mwilck@suse.com>
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
Signed-off-by: Martin Wilck <mwilck@suse.com>
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
Patch resent unchanged, with my s-o-b and Tyler's a-b added.

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

