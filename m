Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D79DDC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 06:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbiEXGQ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 02:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbiEXGQP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 02:16:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B773311179
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 23:16:12 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D53731F925;
        Tue, 24 May 2022 06:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653372970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EHHWkdFLsSAFkAy9by9wkYrIAb1tj3q44mL+hQfWAkE=;
        b=URga6TYOHBcFnHurwfzArB7kXu2OcToI2T2KkCunqNBU6+UXADW9Dn1oPVZ07diRCj+lOG
        p36lMkyfkh7qR7TnJcUvTc/uvpV3AdZXOAlWlBGfbaeB3YwlZsVDrVHaammUffbBqoCLnI
        FeWjLhshQ7kJYQJZXA4IkK43UXNLmls=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653372970;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EHHWkdFLsSAFkAy9by9wkYrIAb1tj3q44mL+hQfWAkE=;
        b=mdIAbAE2BVBOI+zKmq2DMmsTs0pp3PtnQH/q2kZXnRkbjLsSo/16CepM3ofnutHMEp7K+O
        ICzo2JE2GPRr1DAA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 9B4842C143;
        Tue, 24 May 2022 06:16:10 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 8CCB2519463C; Tue, 24 May 2022 08:16:10 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 02/16] fc_fcp: use fc_block_rport()
Date:   Tue, 24 May 2022 08:15:48 +0200
Message-Id: <20220524061602.86760-3-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220524061602.86760-1-hare@suse.de>
References: <20220524061602.86760-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use fc_block_rport() instead of fc_block_scsi_eh() as the SCSI command
will be removed as argument for SCSI EH functions.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/libfc/fc_fcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index bce90eb56c9c..074996319df5 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2157,7 +2157,7 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	int rc = FAILED;
 	int rval;
 
-	rval = fc_block_scsi_eh(sc_cmd);
+	rval = fc_block_rport(rport);
 	if (rval)
 		return rval;
 
-- 
2.29.2

