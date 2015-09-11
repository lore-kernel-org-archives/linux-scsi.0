From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 23/29] cxlflash: Remove unnecessary scsi_block_requests
Date: Fri, 11 Sep 2015 16:17:56 -0500
Message-ID: <1442006276-47309-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:47689 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbbIKVSO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2015 17:18:14 -0400
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 11 Sep 2015 15:18:13 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 891211FF0042
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:09:20 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8BLHLw346727172
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 14:17:21 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8BLI9eM021585
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:18:10 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

The host reset handler is called with I/O already blocked, thus
there is no need to explicitly block and unblock I/O in the handler.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 922fac7..24ff8dc 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1977,7 +1977,6 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
 	switch (cfg->state) {
 	case STATE_NORMAL:
 		cfg->state = STATE_RESET;
-		scsi_block_requests(cfg->host);
 		cxlflash_mark_contexts_error(cfg);
 		rcr = afu_reset(cfg);
 		if (rcr) {
@@ -1986,7 +1985,6 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
 		} else
 			cfg->state = STATE_NORMAL;
 		wake_up_all(&cfg->reset_waitq);
-		scsi_unblock_requests(cfg->host);
 		break;
 	case STATE_RESET:
 		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
-- 
2.1.0

