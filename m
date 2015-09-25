From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v4 22/32] cxlflash: Remove unnecessary scsi_block_requests
Date: Fri, 25 Sep 2015 18:17:49 -0500
Message-ID: <1443223069-9770-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:39669 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbbIYXT1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2015 19:19:27 -0400
Received: from localhost
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 25 Sep 2015 17:19:27 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id C22751FF002D
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 17:10:33 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8PNJGW260096546
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 16:19:24 -0700
Received: from d03av01.boulder.ibm.com (localhost [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8PNIoMi032232
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 17:18:52 -0600
In-Reply-To: <1443222593-8828-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

The host reset handler is called with I/O already blocked, thus
there is no need to explicitly block and unblock I/O in the handler.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index cf6a067..729f742 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1966,7 +1966,6 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
 	switch (cfg->state) {
 	case STATE_NORMAL:
 		cfg->state = STATE_RESET;
-		scsi_block_requests(cfg->host);
 		cxlflash_mark_contexts_error(cfg);
 		rcr = afu_reset(cfg);
 		if (rcr) {
@@ -1975,7 +1974,6 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
 		} else
 			cfg->state = STATE_NORMAL;
 		wake_up_all(&cfg->reset_waitq);
-		scsi_unblock_requests(cfg->host);
 		break;
 	case STATE_RESET:
 		wait_event(cfg->reset_waitq, cfg->state != STATE_RESET);
-- 
2.1.0

