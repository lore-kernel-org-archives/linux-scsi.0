Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCBFC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 13:03:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F25F23101
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 13:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391208AbhAZNDV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 08:03:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:37820 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392465AbhAZNDA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Jan 2021 08:03:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CE717AD19;
        Tue, 26 Jan 2021 13:02:14 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Martin Wilck <martin.wilck@suse.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH] scsi: do not retry FAILFAST commands on DID_TRANSPORT_DISRUPTED
Date:   Tue, 26 Jan 2021 14:02:12 +0100
Message-Id: <20210126130212.47998-1-hare@suse.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When a command is return with DID_TRANSPORT_DISRUPTED we should
be looking at the REQ_FAILFAST_TRANSPORT flag and do not retry
the command if set.
Otherwise multipath will be requeuing a command on the failed
path and not fail it over to one of the working paths.

Cc: Martin Wilck <martin.wilck@suse.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a52665eaf288..005118385b70 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1753,6 +1753,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	case DID_TIME_OUT:
 		goto check_type;
 	case DID_BUS_BUSY:
+	case DID_TRANSPORT_DISRUPTED:
 		return (scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT);
 	case DID_PARITY:
 		return (scmd->request->cmd_flags & REQ_FAILFAST_DEV);
-- 
2.29.2

