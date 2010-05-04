From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Enable retries for SYNCRONIZE_CACHE commands
Date: Tue, 04 May 2010 16:49:21 +0200
Message-ID: <20100504144921.71BA62A207@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41799 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab0EDOtW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 10:49:22 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 988B8457F0
	for <linux-scsi@vger.kernel.org>; Tue,  4 May 2010 16:49:21 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org


sd is using SYNCHRONIZE_CACHE to simulate barrier requests;
however no error recovery is taking place as it's being injected
from the block layer. So we should be enable retries here
to clear any transient error.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8b827f3..de6c603 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1040,6 +1040,7 @@ static void sd_prepare_flush(struct request_queue *q, struct request *rq)
 {
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = SD_TIMEOUT;
+	rq->retries = SD_MAX_RETRIES;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
 	rq->cmd_len = 10;
 }
-- 
1.6.0.2

