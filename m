Return-Path: <SRS0=Uiav=5Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2293EC43331
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 08:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAB99206F6
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 08:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729819AbgCaIlO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 04:41:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:41350 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgCaIlO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Mar 2020 04:41:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 663D0AC77;
        Tue, 31 Mar 2020 08:41:13 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH] aacraid: do not overwrite retval in aac_reset_adapter()
Date:   Tue, 31 Mar 2020 10:41:11 +0200
Message-Id: <20200331084111.95039-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

'retval' got assigned a value twice, causing the original
value to be lost.

Fixes: 3d3ca53b1639 ("scsi: aacraid: use scsi_host_(block,unblock) to block I/O")
Reported-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/commsup.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 4725e4c763cf..ddd73f6798af 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1626,7 +1626,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 {
 	unsigned long flagv = 0;
-	int retval;
+	int retval, unblock_retval;
 	struct Scsi_Host *host = aac->scsi_host_ptr;
 	int bled;
 
@@ -1656,8 +1656,9 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	retval = _aac_reset_adapter(aac, bled, reset_type);
 	spin_unlock_irqrestore(host->host_lock, flagv);
 
-	retval = scsi_host_unblock(host, SDEV_RUNNING);
-
+	unblock_retval = scsi_host_unblock(host, SDEV_RUNNING);
+	if (!retval)
+		retval = unblock_retval;
 	if ((forced < 2) && (retval == -ENODEV)) {
 		/* Unwind aac_send_shutdown() IOP_RESET unsupported/disabled */
 		struct fib * fibctx = aac_fib_alloc(aac);
-- 
2.16.4

