Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50215C1B0D8
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E46E233FB
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgLGMt6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 07:49:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:43274 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgLGMt4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 07:49:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C8091AE69;
        Mon,  7 Dec 2020 12:48:31 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/35] zfcp: do not set COMMAND_COMPLETE
Date:   Mon,  7 Dec 2020 13:47:58 +0100
Message-Id: <20201207124819.95822-15-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201207124819.95822-1-hare@suse.de>
References: <20201207124819.95822-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

COMMAND_COMPLETE is defined as '0', and it is a SCSI parallel message
to boot. So drop the call to set_msg_byte().

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_fc.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_fc.h b/drivers/s390/scsi/zfcp_fc.h
index 6902ae1f8e4f..8aaf409ce9cb 100644
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -275,7 +275,6 @@ void zfcp_fc_eval_fcp_rsp(struct fcp_resp_with_ext *fcp_rsp,
 	u32 sense_len, resid;
 	u8 rsp_flags;
 
-	set_msg_byte(scsi, COMMAND_COMPLETE);
 	scsi->result |= fcp_rsp->resp.fr_status;
 
 	rsp_flags = fcp_rsp->resp.fr_flags;
-- 
2.16.4

