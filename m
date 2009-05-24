From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 09/10] libosd: Use REQ_QUIET requests.
Date: Sun, 24 May 2009 20:05:43 +0300
Message-ID: <1243184743-17145-1-git-send-email-bharrosh@panasas.com>
References: <4A197CB5.60709@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:2407 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754207AbZEXRFo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 May 2009 13:05:44 -0400
In-Reply-To: <4A197CB5.60709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>
Cc: Jeff Garzik <jeff@garzik.org>

libosd has it's own sense decoding and printout. Don't
let scsi_lib duplicate that printout. (Which is done wrong
in regard to osd commands)

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 3959797..71341ad 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -1340,6 +1340,8 @@ static int _init_blk_request(struct osd_request *or,
 
 	or->request = req;
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_flags |= REQ_QUIET;
+
 	req->timeout = or->timeout;
 	req->retries = or->retries;
 	req->sense = or->sense;
-- 
1.6.2.1

