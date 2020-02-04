Return-Path: <SRS0=WdRn=3Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4060C3524D
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 10:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5DD021D7D
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 10:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgBDKXU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 05:23:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:44588 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726675AbgBDKXU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Feb 2020 05:23:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B66B9B06A;
        Tue,  4 Feb 2020 10:23:18 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: return correct status in scsi_host_eh_past_deadline()
Date:   Tue,  4 Feb 2020 11:23:16 +0100
Message-Id: <20200204102316.39000-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the user changed the 'eh_deadline' setting to 'off' while evaluating
the time_before() call we will return 'true', which is inconsistent
with the first conditional, where we return 'false' if 'eh_deadline'
is set to 'off'.

Reported-by: Martin Wilck <martin.wilck@suse.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ae2fa170f6ad..ae29a9b4af56 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -113,7 +113,7 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 	    shost->eh_deadline > -1)
 		return 0;
 
-	return 1;
+	return shost->eh_deadline == -1 ? 0 : 1;
 }
 
 /**
-- 
2.16.4

