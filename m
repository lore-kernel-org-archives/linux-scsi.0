From: michaelc@cs.wisc.edu
Subject: [PATCH] ALUA: send STPG if explicit and implicit is supported
Date: Tue, 28 Jul 2009 23:08:06 -0500
Message-ID: <1248840486-4014-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53192 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbZG2EIM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 00:08:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hare@suse.de
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

alua_activate only sends a STPG if only explicit is suppored.
As a result, for EMC targets that support both we end up doing
a implicit failover when X commands are finally sent to
the other SP.

This patch does a AND on the h->tpgs, so we do a explicit failover
right away.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index dba154c..b5cdefa 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -663,7 +663,7 @@ static int alua_activate(struct scsi_device *sdev)
 			goto out;
 	}
 
-	if (h->tpgs == TPGS_MODE_EXPLICIT && h->state != TPGS_STATE_OPTIMIZED)
+	if (h->tpgs & TPGS_MODE_EXPLICIT && h->state != TPGS_STATE_OPTIMIZED)
 		err = alua_stpg(sdev, TPGS_STATE_OPTIMIZED, h);
 
 out:
-- 
1.6.2.2

