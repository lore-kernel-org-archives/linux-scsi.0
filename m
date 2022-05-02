Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29201C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387758AbiEBVmc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387727AbiEBVmH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:42:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6767FE0D9
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:38:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 050C81F896;
        Mon,  2 May 2022 21:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651527513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ZKcU48Ce5ImF1Srtsx75MOxmZ03JNtLbn/4UPTG7rE=;
        b=y+JecxVs+/VZ0dY+dbPTq8h2R9QOzT5PGoC+ARepjyDPgpC4aE1ZRO8uq1iGASPR6pD+QK
        mryN3j2SGEEPQrmmKZMgEh66uSUmUiP3e4WUTujOMwVshe0sOxZcYmXKueclgswaLca0SF
        6L54CLMz5H8n0g8QqTwoNXeAh7DyKSo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651527513;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ZKcU48Ce5ImF1Srtsx75MOxmZ03JNtLbn/4UPTG7rE=;
        b=Xbqko5+pC58LIoaRgmFOsJpiIDHWUnaPKqpZe+5HTi8kq2JLZqx75WF9nl4wB+ozsfvNa/
        XF7lXomv5PictmBg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 010B62C149;
        Mon,  2 May 2022 21:38:33 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id F2006519410C; Mon,  2 May 2022 23:38:32 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/24] fnic: use fc_block_rport() correctly
Date:   Mon,  2 May 2022 23:38:08 +0200
Message-Id: <20220502213820.3187-13-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502213820.3187-1-hare@suse.de>
References: <20220502213820.3187-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use fc_block_rport() instead of fc_block_scsi_eh() and evaluate
the return value to avoid issuing TMF commands when the port
is still blocked.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/fnic/fnic_scsi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index b2ba731b67de..fb6dc59a5a7e 100644
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

