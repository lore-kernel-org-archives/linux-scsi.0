Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24121C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384965AbiEBVmK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352930AbiEBVmE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:42:04 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2263464D6
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:38:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D5C5D210E4;
        Mon,  2 May 2022 21:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651527512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y2IHj7NZU/S04A7NYh9uLbNYB5/F39o1BrhHLBHsW0c=;
        b=kAePpErka8HQg45OkK8N2kUhwA2Vlz6lo+eWL/IhPiQot2JSXFWFBnd0so6zi17gEPHQiz
        HtY4b0ti+66ITavMMqatXYya+IPt0/CmsxX3AQgfoATFmGVSvlaG3hVFTKavNlrMxu8u8g
        SsRTd25OeSB8nTXpkXtUixwAtsCo/D0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651527512;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y2IHj7NZU/S04A7NYh9uLbNYB5/F39o1BrhHLBHsW0c=;
        b=odApsR8K+83/n+tVJ/6rcB7sBFOsaEp1novmnrvE2fhavWt2sXkRJH8t0UmKPk2SDpjbGn
        AxjmM+KeULBcnsDw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id CC5AC2C141;
        Mon,  2 May 2022 21:38:32 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id BC7A651940F6; Mon,  2 May 2022 23:38:32 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/24] csiostor: use fc_block_rport()
Date:   Mon,  2 May 2022 23:37:57 +0200
Message-Id: <20220502213820.3187-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502213820.3187-1-hare@suse.de>
References: <20220502213820.3187-1-hare@suse.de>
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
index 9aafe0002ab1..c1c410a1cfe0 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2088,7 +2088,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	}
 
 	/* Lnode is ready, now wait on rport node readiness */
-	ret = fc_block_scsi_eh(cmnd);
+	ret = fc_block_rport(rn->rport);
 	if (ret)
 		return ret;
 
-- 
2.29.2

