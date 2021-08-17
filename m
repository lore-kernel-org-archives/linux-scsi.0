Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4948EC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3244260FD7
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239749AbhHQJRp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:45 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47532 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235288AbhHQJRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:19 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 575E220021;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nMq7QBXKzgEGxvjDNIbW/aZPUnxVffZjRthph4T4fYg=;
        b=DN3HLqeV3IU6Ah/q27U7wz/xtdYIdHO/jKYcmio5Ne/SUbCNVWcaftUdtCJRYb1QPoYqC5
        oFqZ1J4Gye5Hi/WxaunTHZV7MqTvm30MqgqQVCTR64aYFppwXdJJ0eHZ4ct8eeKwQrj2Pz
        R/Kwb2+HCvlltA1kpN8y7FGuZ6mTVSo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nMq7QBXKzgEGxvjDNIbW/aZPUnxVffZjRthph4T4fYg=;
        b=4VNzhPzpjoRLob/cvQLWT9TTa+BA5EnwQAzSY7LCM5JVn/KDOw11ISF5tQmLztuuEUt3oq
        S9PRw/xnEGlpg6CQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 52EC9A3BAB;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 5043E518CE97; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 28/51] csiostor: use fc_block_rport()
Date:   Tue, 17 Aug 2021 11:14:33 +0200
Message-Id: <20210817091456.73342-29-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use fc_block_rport() instead of fc_block_scsi_eh() as the SCSI command
will be removed as argument for SCSI EH functions.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/csiostor/csio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 56b9ad0a1ca0..c22acfc7caba 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2084,7 +2084,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	}
 
 	/* Lnode is ready, now wait on rport node readiness */
-	ret = fc_block_scsi_eh(cmnd);
+	ret = fc_block_rport(rn->rport);
 	if (ret)
 		return ret;
 
-- 
2.29.2

