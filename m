From: michaelc@cs.wisc.edu
Subject: [PATCH 13/13] libfc: remove unnessary casts
Date: Sun, 29 Jun 2008 13:24:03 -0500
Message-ID: <1214763843-5548-14-git-send-email-michaelc@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-2-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-3-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-4-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-5-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-6-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-7-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-8-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-9-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-10-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-11-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-12-git-send-email-michaelc@cs.wisc.edu>
 <1214763843-5548-13-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757549AbYF2SYL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2008 14:24:11 -0400
In-Reply-To: <1214763843-5548-13-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Trivial remove casts in fc_scsi.c. Just getting it out of the way
to make other patches smaller.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libfc/fc_scsi.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_scsi.c b/drivers/scsi/libfc/fc_scsi.c
index 2ca1db2..b9d0ec4 100644
--- a/drivers/scsi/libfc/fc_scsi.c
+++ b/drivers/scsi/libfc/fc_scsi.c
@@ -2028,7 +2028,7 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 	struct fc_lport *lp;
 
 	lp = shost_priv(sc_cmd->device->host);
-	return (lp->tt.reset_if(lp));
+	return lp->tt.reset_if(lp);
 }
 EXPORT_SYMBOL(fc_eh_host_reset);
 
@@ -2115,9 +2115,8 @@ int fc_scsi_init(struct fc_lport *lp,
 	if (!lp->tt.scsi_abort_io)
 		lp->tt.scsi_abort_io = fc_scsi_abort_io;
 	
-	si = (struct fc_scsi_internal*)kzalloc(sizeof(struct fc_scsi_internal),
-					       GFP_KERNEL);
-	lp->scsi_priv = (void*)si;
+	si = kzalloc(sizeof(struct fc_scsi_internal), GFP_KERNEL);
+	lp->scsi_priv = si;
 
 	/*
 	 * we will use openfc's scsi i/f only when lower level driver
-- 
1.5.4.1

