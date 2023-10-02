Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7ABE784BE
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238210AbjJBPoY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238206AbjJBPoC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:44:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361D5B8
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:43:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id B68D921871;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q0UUnKa+wq1IlAEu599ybvzy2zilPAiq8xY/HKBbqm8=;
        b=W7fuSdQiWZ0DV4xsz1LnPnfcoAI7Wy5IB4tQsbMjkttTbE1cOB7slmNQNpnWvM8hIbmQ2f
        HJLB6Og48tSrEltUKCUBuyqCpKAjcHtyIOodzNVTpQ+ypYqwotWV33datmAbBfPjnNF2Hc
        1zXS0XKaopQkTRJzpQZhQeTzjyxYzbI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261423;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q0UUnKa+wq1IlAEu599ybvzy2zilPAiq8xY/HKBbqm8=;
        b=oOOGxBxmsjfA+RD8NrR+nU2nkEV/ehMPAPPDpve/VyJzmKdHtEgbh6pYARdB4NL6mw8lOj
        h98K9qeXzbyXCACA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 8C7482C15C;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id A409A51E754F; Mon,  2 Oct 2023 17:43:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: [PATCH 12/18] ips: Do not try to abort command from host reset
Date:   Mon,  2 Oct 2023 17:43:22 +0200
Message-Id: <20231002154328.43718-13-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154328.43718-1-hare@suse.de>
References: <20231002154328.43718-1-hare@suse.de>
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
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
---
 drivers/scsi/ips.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index bb206509265e..10cf5775a939 100644
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
2.35.3

