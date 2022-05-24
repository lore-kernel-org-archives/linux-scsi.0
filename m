Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFACC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 06:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbiEXGQn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 02:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiEXGQS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 02:16:18 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912ED10FF2
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 23:16:16 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0CEDA1F92D;
        Tue, 24 May 2022 06:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653372971; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yKicc2hl3SOPadeMaWpZjxLZd2bBlgjUggUf1gNYDRk=;
        b=iH+k3C4rCTCrKzlODpRzyuEqKoSTSW3Bp+XLFlKwo+uLq16Lx5Mi3huluj6M1Rbx7wPTSP
        /vIx1TNzE/EoBiuL5S6q2hwyr069YmOES/qLg9G9RoEsoJjN6L5MTPO7m0rfI5PyeroQpo
        n8eC0CT3YtvPodVMmJKcSUht457iSUY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653372971;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yKicc2hl3SOPadeMaWpZjxLZd2bBlgjUggUf1gNYDRk=;
        b=+JE9GMxi6Z9WVCAVRXrie73o65J6cAn+jWiSuSmQDqsfY9StSiYibC6BuP5yblMbitClm5
        H+gKQ7PAVPxSfjBA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id D536C2C146;
        Tue, 24 May 2022 06:16:10 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id D30005194656; Tue, 24 May 2022 08:16:10 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: [PATCH 15/16] ips: Do not try to abort command from host reset
Date:   Tue, 24 May 2022 08:16:01 +0200
Message-Id: <20220524061602.86760-16-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220524061602.86760-1-hare@suse.de>
References: <20220524061602.86760-1-hare@suse.de>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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

