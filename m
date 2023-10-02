Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 546DBE784BF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238237AbjJBPtg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238228AbjJBPtf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:49:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1760D7
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:49:31 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B262D1F37C;
        Mon,  2 Oct 2023 15:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h+pTSru1/5Zskxjj1gROaT0Wm7ozGHCsG2zuQ90NTRM=;
        b=aPLCWGGPb3+4abun/F3Fa6URjjVt04wKfulhmex3LAnjw3uKU6PYKAMTVs2NZspw3i56BS
        OQSeuq/X9n3Hw9q72DeOYs1gMJ9OY7yv/teXpBRLX7svQ8wr023OjX2B7Ol1M9UqBvV6gx
        8x1cpToO1ElNmlFpZNflFFfl8qgug70=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261770;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h+pTSru1/5Zskxjj1gROaT0Wm7ozGHCsG2zuQ90NTRM=;
        b=co9D6p6rYXybzpZaWyb5y3tdYOAmgceT5UCqO+aAJ/vOL+B+17G8bSUCsKh8QWoP8W1wCv
        fZbjPjm7BFyQhtCw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 9148A2C143;
        Mon,  2 Oct 2023 15:49:30 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id A3BD351E755F; Mon,  2 Oct 2023 17:49:30 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: [PATCH 01/15] zfcp: do not wait for rports to become unblocked after host reset
Date:   Mon,  2 Oct 2023 17:49:13 +0200
Message-Id: <20231002154927.68643-2-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154927.68643-1-hare@suse.de>
References: <20231002154927.68643-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

zfcp_scsi_eh_host_reset_handler() would call fc_block_rport() to
wait for all rports to become unblocked after host reset.
But after host reset it might happen that the port is gone, hence
fc_block_rport() might fail due to a missing port.
But that's a perfectly legal operation; on FC remote ports might
come and go.
In the same vein FC HBAs are able to deal with ports being temporarily
blocked, so really there is not point in waiting for all ports
to become unblocked during host reset.
Hence remove the call to fc_block_rport() in host reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Steffen Maier <maier@linux.ibm.com
Cc: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_scsi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index b2a8cd792266..14f929cca271 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -383,10 +383,6 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 	}
 	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
 	zfcp_erp_wait(adapter);
-	fc_ret = fc_block_scsi_eh(scpnt);
-	if (fc_ret)
-		ret = fc_ret;
-
 	zfcp_dbf_scsi_eh("schrh_r", adapter, ~0, ret);
 	return ret;
 }
-- 
2.35.3

