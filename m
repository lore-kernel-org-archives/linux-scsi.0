Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94651C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238249AbiECUL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238318AbiECUKz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:55 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E7827143
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:21 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id DB64921883;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D2ayq6iWFQsACj+mwIsfmfVyr04/ST/y6XXgkwgyQV0=;
        b=e0fz6bg4hwBKRF/aYwoGezG0/uWka4C2jZ1oxNkpOEN5qLMPDKw2BM7t0rJI4OFjDP5oD9
        JNTljUs7Fmi+9tDFU+uPx0dOnEXofIvLGpvShEVOgljnqDWbCqkLGc9Pr4DVsHL70G/bn/
        uka7JM6glM1/IQ8fykeAdhELEhzmcak=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D2ayq6iWFQsACj+mwIsfmfVyr04/ST/y6XXgkwgyQV0=;
        b=YI/14cbeHMea2StYkueJrBleh9asnQbyp0tbhRSnJCkKh/xptQBuIOloy+Q/J1Gj7eKMjg
        +QcnmjXRKAz7KPBQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 52D2B2C16F;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 62D5E51941F0; Tue,  3 May 2022 22:07:15 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: [PATCH 21/24] ips: Do not try to abort command from host reset
Date:   Tue,  3 May 2022 22:07:01 +0200
Message-Id: <20220503200704.88003-22-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220503200704.88003-1-hare@suse.de>
References: <20220503200704.88003-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The code for aborting an outstanding command is a copy of the
functionality from command abort. As we already have called this
function once we reach host reset there's no point in trying to
do so again.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
---
 drivers/scsi/ips.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 16419aeec02d..d49c1d6df5d6 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -835,7 +835,6 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 	int i;
 	ips_ha_t *ha;
 	ips_scb_t *scb;
-	ips_copp_wait_item_t *item;
 
 	METHOD_TRACE("ips_eh_reset", 1);
 
@@ -860,23 +859,6 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 	if (!ha->active)
 		return (FAILED);
 
-	/* See if the command is on the copp queue */
-	item = ha->copp_waitlist.head;
-	while ((item) && (item->scsi_cmd != SC))
-		item = item->next;
-
-	if (item) {
-		/* Found it */
-		ips_removeq_copp(&ha->copp_waitlist, item);
-		return (SUCCESS);
-	}
-
-	/* See if the command is on the wait queue */
-	if (ips_removeq_wait(&ha->scb_waitlist, SC)) {
-		/* command not sent yet */
-		return (SUCCESS);
-	}
-
 	/* An explanation for the casual observer:                              */
 	/* Part of the function of a RAID controller is automatic error         */
 	/* detection and recovery.  As such, the only problem that physically   */
-- 
2.29.2

