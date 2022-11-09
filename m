Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004D5C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 07:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiKIHsA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 02:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiKIHr7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 02:47:59 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20434186FE
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 23:47:57 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8DCF4224AB;
        Wed,  9 Nov 2022 07:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667980076; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ni8mIG4X2luKUxEEpKDKBXMxNMWttiKJSAvqEUE4a7U=;
        b=miQ+tWPT0yJ9oHz9ZXI7tiqLczAV7jEADn9nqqoclOyFVOFGnV/YUuxd5JgHtIxgAgIr6/
        nAdcLJAiXmk+4eIx4JaZOWcylfkwm1EEUOWfuRNuLxyN/whvFpNxhJG8sxH1E/G5q96OdA
        7kjCCkibDrJFqXRW3ZGTF06+zl1HvzI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667980076;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=ni8mIG4X2luKUxEEpKDKBXMxNMWttiKJSAvqEUE4a7U=;
        b=7mr0Q9hPljY6I0Yw5NgxcXSqbKPWkiv3jwxDNyZIDNNh5En2m3YsaxcTmXZo5AoNLU+YTT
        HATL3yOdQVR3NuAQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 3F1A22C141;
        Wed,  9 Nov 2022 07:47:56 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 0D82651ADAB9; Wed,  9 Nov 2022 08:47:56 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        John Garry <john.garry@oracle.com>
Subject: [PATCH] scsi_error: do not queue pointless abort workqueue functions
Date:   Wed,  9 Nov 2022 08:47:54 +0100
Message-Id: <20221109074754.24075-1-hare@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a host template doesn't implement the .eh_abort_handler()
there is no point in queueing the abort workqueue function;
all it does is invoking SCSI EH anyway.
So return 'FAILED' from scsi_abort_command() if the .eh_abort_handler()
is not implemented and save us from having to wait for the
abort workqueue function to complete.

Cc: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: John Garry <john.garry@oracle.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index be2a70c5ac6d..e9f9c8f52c59 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -242,6 +242,11 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 		return FAILED;
 	}
 
+	if (!shost->hostt->eh_abort_handler) {
+		/* No abort handler, fail command directly */
+		return FAILED;
+	}
+
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->eh_deadline != -1 && !shost->last_reset)
 		shost->last_reset = jiffies;
-- 
2.35.3

