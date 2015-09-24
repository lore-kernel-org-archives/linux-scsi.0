From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v3 22/32] cxlflash: Remove unnecessary scsi_block_requests
Date: Thu, 24 Sep 2015 14:41:32 -0500
Message-ID: <1443123692-17504-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:54087 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbbIXTmP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2015 15:42:15 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 24 Sep 2015 13:42:15 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 1ACFA3E40044
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 13:42:14 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8OJf4o69634130
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 12:41:04 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8OJgCe9013748
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2015 13:42:13 -0600
In-Reply-To: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com>
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

