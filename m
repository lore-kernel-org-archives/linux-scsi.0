Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DF8C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240069AbiECUK6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbiECUKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B0B26AEB
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:16 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0898B210E3;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pIFawAYIUoMlDzbK9bGwH3WNM9R48wAocD7L52QkO1I=;
        b=YTG7k+SpRZK7naIStYu585yx6A9vURT4fysVp4h3oFOM/8wKlPj8G/8cuDuJ2tAR9BK3lB
        c36JHRF76qimwa2kXzXGqmpZ2mO7Kp3W1L3gLjsQRQmZ08d3vOf7D/wzRb1bWdQoLOLI1n
        dGwcZ7DIlh+BSiycpMLmiNI5hwrgbZk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pIFawAYIUoMlDzbK9bGwH3WNM9R48wAocD7L52QkO1I=;
        b=jz8NhULldsfbeXbMa6ugsgkEAxn5siMqk2YLeSOJL474imzNRNOid59XbErBfU9WPBWMWB
        Iy+JdvUXlTSQWkCA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id E2D8F2C149;
        Tue,  3 May 2022 20:07:14 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id E0DA551941CA; Tue,  3 May 2022 22:07:14 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 02/24] fc_fcp: use fc_block_rport()
Date:   Tue,  3 May 2022 22:06:42 +0200
Message-Id: <20220503200704.88003-3-hare@suse.de>
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

