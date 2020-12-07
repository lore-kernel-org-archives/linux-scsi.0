Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98DDC2BB40
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B0D423403
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 12:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgLGMuQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 07:50:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:43220 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgLGMuM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 07:50:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 26DF1AEC3;
        Mon,  7 Dec 2020 12:48:32 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 33/35] qla2xxx: fc_remote_port_chkready() returns a SCSI result value
Date:   Mon,  7 Dec 2020 13:48:17 +0100
Message-Id: <20201207124819.95822-34-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201207124819.95822-1-hare@suse.de>
References: <20201207124819.95822-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

fc_remote_port_chkready() returns a SCSI result value, not the
port status. So fixup the value when the remote port isn't set.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f9c8ae9d669e..419f97467c15 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -957,7 +957,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 	srb_t *sp;
 	int rval;
 
-	rval = rport ? fc_remote_port_chkready(rport) : FC_PORTSTATE_OFFLINE;
+	rval = rport ? fc_remote_port_chkready(rport) : (DID_NO_CONNECT << 16);
 	if (rval) {
 		cmd->result = rval;
 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3076,
-- 
2.16.4

