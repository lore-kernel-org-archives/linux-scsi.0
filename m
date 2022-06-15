Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C2B8C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jun 2022 16:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344720AbiFOQmP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jun 2022 12:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243553AbiFOQmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2022 12:42:12 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495CC4C79D
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2022 09:42:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 012D921C47;
        Wed, 15 Jun 2022 16:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655311330; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gu6YqYR40mZp80M1+u0HwlJhLM3b7TyZHvOeANbGHGM=;
        b=hikxZ0K6k6cM8X8MOsL7EAE+Um+WDzEWfKT+VEwfRDkRev8x+PJ1dBuZ8Zr+RBL75nwGYD
        vCBj65FwmK14/msz9GhJ4s9Qw0XjYpps2NBILZKtlosdLEO/2b5SxV3BKIrnQrQLG+B86i
        1o0Bg6TFwNXa5xZE7QO+7vvzsjfY6kM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B4884139F3;
        Wed, 15 Jun 2022 16:42:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mDtmKuELqmKIcwAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 15 Jun 2022 16:42:09 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/2] scsi: scan: retry INQUIRY after timeout
Date:   Wed, 15 Jun 2022 18:41:49 +0200
Message-Id: <20220615164149.3092-3-mwilck@suse.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220615164149.3092-1-mwilck@suse.com>
References: <20220615164149.3092-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
scsi_noretry_cmd()). Packet loss in the fabric can cause spurious timeouts
during SCSI device probing, causing device probing to fail. This has been
observed in FCoE uplink failover tests, for example.

This patch fixes the issue by retrying the INQUIRY up to 3 times (in practice,
we never observed more than a single retry),

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_scan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index b9b851ce1b72..f0a248bd1cd3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -700,6 +700,11 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 						"scsi scan: retry inquiry after REPORT LUNs\n"));
 				continue;
 			}
+			if (host_byte(result) == DID_TIME_OUT) {
+				SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+						"scsi scan: retry inquiry after timeout\n"));
+				continue;
+			}
 		} else if (result == 0) {
 			/*
 			 * if nothing was transferred, we try
-- 
2.36.1

