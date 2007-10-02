From: akpm@linux-foundation.org
Subject: [patch 07/17] nsp32_restart_autoscsi(): remove error check
Date: Tue, 02 Oct 2007 14:38:03 -0700
Message-ID: <200710022138.l92Lc3Gb023576@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754573AbXJBViQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:38:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@stusta.de, yokota@netlab.is.tsukuba.ac.jp

From: Adrian Bunk <bunk@stusta.de>

The Coverity checker noted that we'll anyway Oops later when we ran into
this condition - and the error check didn't prevent that.

Considering that the error condition shouldn't be possible, and we are
not able to handle it easily, this patch simply removes the pointless
error check.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: <yokota@netlab.is.tsukuba.ac.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/nsp32.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/scsi/nsp32.c~nsp32_restart_autoscsi-remove-error-check drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c~nsp32_restart_autoscsi-remove-error-check
+++ a/drivers/scsi/nsp32.c
@@ -1905,10 +1905,6 @@ static void nsp32_restart_autoscsi(struc
 
 	nsp32_dbg(NSP32_DEBUG_RESTART, "enter");
 
-	if (data->cur_target == NULL || data->cur_lunt == NULL) {
-		nsp32_msg(KERN_ERR, "Target or Lun is invalid");
-	}
-
 	/*
 	 * set SYNC_REG
 	 * Don't set BM_START_ADR before setting this register.
_
