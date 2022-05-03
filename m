Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 594B0C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240128AbiECULM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237775AbiECUKx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:53 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6EA26AEB
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:19 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 31EFB21875;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U8+smaTryB5o6YvC63tmMj1TeWOC8HivAq0CyNDM8j8=;
        b=2YXMPCefklHrW9+NdbmjrHTcyO49S1U2eiB1OP0lll7IfJHK7ul5RlC+KK8bgid3UhrLBE
        qWYIPN1RAuDWzgSPUybqunkcTrjXEeHPTIE6gyiXXCBvkGDvDvo33YBtlbMgDgUriglWMM
        tOdOui6JoYeWCnSUc8Xz7jnA25Zw+o0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U8+smaTryB5o6YvC63tmMj1TeWOC8HivAq0CyNDM8j8=;
        b=UlXQh9VWPbKfNgaHFY+TSgOFxJ22Xp9/8qp+rvq+VWaN93wZ8Gg9fzQchQBTQ2z4f8T21Q
        gQYe060ZbnXCa6BA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 1A9E42C141;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 2B30151941DE; Tue,  3 May 2022 22:07:15 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/24] fnic: use fc_block_rport() correctly
Date:   Tue,  3 May 2022 22:06:52 +0200
Message-Id: <20220503200704.88003-13-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220503200704.88003-1-hare@suse.de>
References: <20220503200704.88003-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use fc_block_rport() instead of fc_block_scsi_eh() and evaluate
the return value to avoid issuing TMF commands when the port
is still blocked.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/fnic/fnic_scsi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 4f72fac583b7..155662b13c83 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1733,9 +1733,6 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	unsigned long abt_issued_time;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
 
-	/* Wait for rport to unblock */
-	fc_block_scsi_eh(sc);
-
 	/* Get local-port, check ready and link up */
 	lp = shost_priv(sc->device->host);
 
@@ -1745,6 +1742,10 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	term_stats = &fnic->fnic_stats.term_stats;
 
 	rport = starget_to_rport(scsi_target(sc->device));
+	ret = fc_block_rport(rport);
+	if (ret)
+		return ret;
+
 	FNIC_SCSI_DBG(KERN_DEBUG,
 		fnic->lport->host,
 		"Abort Cmd called FCID 0x%x, LUN 0x%llx TAG %x flags %x\n",
-- 
2.29.2

