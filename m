Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BEBC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 11:13:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353065AbiELLNT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 07:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353017AbiELLM5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 07:12:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4BC61631
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 04:12:47 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4E8F821C6E;
        Thu, 12 May 2022 11:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652353966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ahWiBlMogQTu8lBD9pGT9VhkCXsdK7AG5saDXzntehU=;
        b=T2fuu/mk2zZDZv9wm6dVToNEilBRdYyldMl+DAOcAeNDIuHlEHeZv5dsQbCY/pJWZqEKcr
        Wm0EidwErtMAhJCO7xSSZFay78o6j/Tjg3wmfxs3c2wHkKvkg3Wdox9U/orjq/kgf/P2U4
        Ti2oGUZ7/ThmcC0bGsoPZgJ6nh9y9lg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652353966;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ahWiBlMogQTu8lBD9pGT9VhkCXsdK7AG5saDXzntehU=;
        b=7kkrW6Hr10vTPC9G1/SXujXa7xdznB6wciprQteCC2yJhk6IZXGz5fKoZ7P2eu7ms+YrgK
        cTezmoI5U7LB1XDQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id F10DF2C141;
        Thu, 12 May 2022 11:12:45 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id E1FEB51943DA; Thu, 12 May 2022 13:12:45 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 01/20] csiostor: use fc_block_rport()
Date:   Thu, 12 May 2022 13:12:17 +0200
Message-Id: <20220512111236.109851-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220512111236.109851-1-hare@suse.de>
References: <20220512111236.109851-1-hare@suse.de>
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

