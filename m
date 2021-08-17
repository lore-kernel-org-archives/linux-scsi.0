Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9F7C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14DBA60EE4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239532AbhHQJRX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:23 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47532 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236163AbhHQJRQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:16 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E217720017;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bo6uQ0chpkau1qtFdd+KxWArWfDmM9TOCYqEcMyKxnU=;
        b=csr5XW9ZK81X6rduIClK9TyLvgh9eVUk88XtabGCgP0O95SWnq09YCHyI3hJeVgT1Qreu4
        OtQNXAqeALCH9JfOPmnUmk5CG4iycEIBnzB+Ag2Hkl1ebTtN+XbuHu8/8F4UeOg1bpTsR4
        OKsPpFXebxF/b/I2b40lrKj7Rv/k0LY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191801;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bo6uQ0chpkau1qtFdd+KxWArWfDmM9TOCYqEcMyKxnU=;
        b=kPppFjHYXX6dsT4oPfZhPMx8WKfu7BGww1uB9+HWLnQyZgYsIzczAj+mQ9vzM560NOnx5x
        aegDSu3BWzvuVTAA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B86A8A3B96;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id AD84D518CE67; Tue, 17 Aug 2021 11:16:41 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: [PATCH 04/51] ips: Do not try to abort command from host reset
Date:   Tue, 17 Aug 2021 11:14:09 +0200
Message-Id: <20210817091456.73342-5-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The code for aborting an outstanding command is a copy of the
functionality from command abort. As we already have called this
function once we reach host reset there's no point in trying to
do so again.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
---
 drivers/scsi/ips.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 8b33c9871484..3760bcfc40d1 100644
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

