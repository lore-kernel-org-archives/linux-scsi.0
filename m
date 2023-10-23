Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99B0C25B41
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 07:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbjJWHaO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 03:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbjJWHaL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 03:30:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADE6D66
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 00:30:09 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id EE4F41FD79;
        Mon, 23 Oct 2023 07:30:07 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B033C2CF26;
        Mon, 23 Oct 2023 07:30:07 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id E03DE51EC310; Mon, 23 Oct 2023 09:30:07 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH] mptfc: initialize return value in mptfc_bus_reset()
Date:   Mon, 23 Oct 2023 09:30:05 +0200
Message-Id: <20231023073005.20766-1-hare@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
Authentication-Results: smtp-out2.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out2.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [5.49 / 50.00];
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
         BAYES_HAM(-0.00)[36.58%]
X-Rspamd-Queue-Id: EE4F41FD79
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Detected by smatch.

Fixes: 17865dc2eccc ("scsi: message: fusion: Open-code mptfc_block_error_handler() for bus reset")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/message/fusion/mptfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index aa6bb764df3e..0581f855c72e 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -265,7 +265,7 @@ mptfc_bus_reset(struct scsi_cmnd *SCpnt)
 	MPT_SCSI_HOST __maybe_unused *hd = shost_priv(shost);
 	int channel = SCpnt->device->channel;
 	struct mptfc_rport_info *ri;
-	int rtn;
+	int rtn = FAILED;
 
 	list_for_each_entry(ri, &hd->ioc->fc_rports, list) {
 		if (ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED) {
-- 
2.35.3

