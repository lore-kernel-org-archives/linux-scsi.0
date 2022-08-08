Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46DC2C00140
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Aug 2022 20:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243020AbiHHUU3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 16:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238363AbiHHUU2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 16:20:28 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3443EDF97
        for <linux-scsi@vger.kernel.org>; Mon,  8 Aug 2022 13:20:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 918B11F9D4;
        Mon,  8 Aug 2022 20:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659990022; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=hLrtVCmLFrNRZoPDdGAl9lOeldYe+aAks0jlj3elbD0=;
        b=FWT3+LxBKbfio/4089A9mSy78lGhDXh8uFaLThC6KxcA6eRQWJ+T2jEjYq/k9I65BKTf+D
        MDEyoKywMRU4/o81P+M25Llql4/ZzolH00tM9uF0wNYaqH2PJe8SnyAFMxS1SE6ph5J9gi
        gdEtIdvgnMnPmCDNTevVE5VDZPbQDRo=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 512AA13AB3;
        Mon,  8 Aug 2022 20:20:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Z81bEgZw8WJAFAAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 08 Aug 2022 20:20:22 +0000
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Martin Wilck <mwilck@suse.com>,
        Dave Prizer <dave.prizer@hpe.com>
Subject: [PATCH RESEND] scsi: scan: retry INQUIRY after timeout
Date:   Mon,  8 Aug 2022 22:20:18 +0200
Message-Id: <20220808202018.22224-1-mwilck@suse.com>
X-Mailer: git-send-email 2.37.1
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
Tested-by: Dave Prizer <dave.prizer@hpe.com>

---
This patch was previously part of the series "Fixes for device probing
on flaky connections", submitted on 2022/06/15. The first patch of the
series has been dropped as discussed in the review process. Testing
verified that just this patch was sufficient to solve the observed
issues.

---
 drivers/scsi/scsi_scan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 91ac901a66826..e859a648033f9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -697,6 +697,11 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 				    (sshdr.ascq == 0))
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
2.37.1

