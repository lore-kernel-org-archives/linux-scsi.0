Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA36CDB474
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 07:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbjJWHaf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 03:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbjJWHaa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 03:30:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C011D65
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 00:30:24 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DB6BF1FE16;
        Mon, 23 Oct 2023 07:30:22 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id A01382CF26;
        Mon, 23 Oct 2023 07:30:22 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id D0A7851EC314; Mon, 23 Oct 2023 09:30:22 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] megaraid: fixup debug message in megaraid_abort_and_reset()
Date:   Mon, 23 Oct 2023 09:30:21 +0200
Message-Id: <20231023073021.21954-1-hare@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
Authentication-Results: smtp-out2.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out2.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [5.33 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[6];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-0.16)[69.23%]
X-Rspamd-Queue-Id: DB6BF1FE16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Found by Smatch.

Fixes: 5bcd3bfbda02 ("scsi: megaraid: Pass in NULL scb for host reset")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/megaraid.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 329c3da88416..d59964ceef47 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1925,10 +1925,12 @@ megaraid_abort_and_reset(adapter_t *adapter, struct scsi_cmnd *cmd, int aor)
 	struct list_head	*pos, *next;
 	scb_t			*scb;
 
-	dev_warn(&adapter->dev->dev, "%s cmd=%x <c=%d t=%d l=%d>\n",
-	     (aor == SCB_ABORT)? "ABORTING":"RESET",
-	     cmd->cmnd[0], cmd->device->channel,
-	     cmd->device->id, (u32)cmd->device->lun);
+	if (aor == SCB_ABORT)
+		dev_warn(&adapter->dev->dev, "ABORTING cmd=%x <c=%d t=%d l=%d>\n",
+			 cmd->cmnd[0], cmd->device->channel,
+			 cmd->device->id, (u32)cmd->device->lun);
+	else
+		dev_warn(&adapter->dev->dev, "RESETTING\n");
 
 	if(list_empty(&adapter->pending_list))
 		return FAILED;
-- 
2.35.3

