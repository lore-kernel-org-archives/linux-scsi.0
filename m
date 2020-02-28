Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186F6C3F2D3
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 07:53:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5D1F246AA
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 07:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgB1Hx2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 02:53:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:59826 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726998AbgB1HxZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 02:53:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5FFD5B1FE;
        Fri, 28 Feb 2020 07:53:21 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/13] aacraid: move scsi_(block,unblock)_requests out of _aac_reset_adapter()
Date:   Fri, 28 Feb 2020 08:53:12 +0100
Message-Id: <20200228075318.91255-8-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200228075318.91255-1-hare@suse.de>
References: <20200228075318.91255-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

_aac_reset_adapter() only has one caller, and that one already calls
scsi_block_requests(). So move the calls out of _aac_reset_adapter()
to avoid calling scsi_block_requests() twice.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Acked-by: Balsundar P < Balsundar.P@microchip.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/aacraid/commsup.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 8736a540a048..0d8c1ee40759 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1476,7 +1476,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 {
 	int index, quirks;
 	int retval;
-	struct Scsi_Host *host;
+	struct Scsi_Host *host = aac->scsi_host_ptr;
 	struct scsi_device *dev;
 	int jafo = 0;
 	int bled;
@@ -1493,8 +1493,6 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 *	- The card is dead, or will be very shortly ;-/ so no new
 	 *	  commands are completing in the interrupt service.
 	 */
-	host = aac->scsi_host_ptr;
-	scsi_block_requests(host);
 	aac_adapter_disable_int(aac);
 	if (aac->thread && aac->thread->pid != current->pid) {
 		spin_unlock_irq(host->host_lock);
@@ -1619,7 +1617,6 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 
 out:
 	aac->in_reset = 0;
-	scsi_unblock_requests(host);
 
 	/*
 	 * Issue bus rescan to catch any configuration that might have
@@ -1640,7 +1637,7 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 {
 	unsigned long flagv = 0;
 	int retval;
-	struct Scsi_Host * host;
+	struct Scsi_Host * host = aac->scsi_host_ptr;
 	int bled;
 
 	if (spin_trylock_irqsave(&aac->fib_lock, flagv) == 0)
@@ -1658,7 +1655,6 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 * target (block maximum 60 seconds). Although not necessary,
 	 * it does make us a good storage citizen.
 	 */
-	host = aac->scsi_host_ptr;
 	scsi_block_requests(host);
 
 	/* Quiesce build, flush cache, write through mode */
@@ -1670,6 +1666,8 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	retval = _aac_reset_adapter(aac, bled, reset_type);
 	spin_unlock_irqrestore(host->host_lock, flagv);
 
+	scsi_unblock_requests(host);
+
 	if ((forced < 2) && (retval == -ENODEV)) {
 		/* Unwind aac_send_shutdown() IOP_RESET unsupported/disabled */
 		struct fib * fibctx = aac_fib_alloc(aac);
-- 
2.16.4

