Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1122BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238391AbiECUKz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbiECUKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C4227143
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:16 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 042DB1F749;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zMhpcvLQJ9rgyWlHSsaKP0Ft84p32yPlR6XPjBWnU8c=;
        b=i3Ialq9Ak1D18+/BJ1lloxRoUZim5Ge8qks5hY2ehlKNxGqFF+5RDc5SAGGEIyw6WyrgHN
        p07iVoel0n6vsKva/+dzEAudvPJ5qNmmu5wMzPBdcxNKiFDKXTiVQ0DUgVHdNT5TZ3DsId
        WU5SGEoVENotIZuy0YxdQhZ0PGN0adE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zMhpcvLQJ9rgyWlHSsaKP0Ft84p32yPlR6XPjBWnU8c=;
        b=Cuhw4iJe8IgAlGnSJuBM72bwxb33J+S05eEsMuXAJaKElgwPrQ2jiPeCn2WIMj6Gc2df0k
        PqkJwibtbeyubNBw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id DD5302C145;
        Tue,  3 May 2022 20:07:14 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id DBD5551941C8; Tue,  3 May 2022 22:07:14 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 01/24] csiostor: use fc_block_rport()
Date:   Tue,  3 May 2022 22:06:41 +0200
Message-Id: <20220503200704.88003-2-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220503200704.88003-1-hare@suse.de>
References: <20220503200704.88003-1-hare@suse.de>
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

