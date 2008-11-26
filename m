From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 7/7] trivial: move a variable from function to if-scope
Date: Wed, 26 Nov 2008 19:32:53 +0100
Message-ID: <200811261932.54416.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:57641 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbYKZSc7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2008 13:32:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>

Move a variable from functions scope to if-scope.

Signed-off-by: Bernd Schubert <bs@q-leap.de>

---
 drivers/scsi/scsi_error.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_error.c
+++ linux-2.6/drivers/scsi/scsi_error.c
@@ -132,7 +132,6 @@ enum blk_eh_timer_return scsi_times_out(
 {
 	struct scsi_cmnd *scmd = req->special;
 	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
-	enum blk_eh_timer_return rtn = eh_timed_out(scmd);
 
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
@@ -152,6 +151,8 @@ enum blk_eh_timer_return scsi_times_out(
 		eh_timed_out = NULL;
 
 	if (eh_timed_out) {
+		enum blk_eh_timer_return rtn = eh_timed_out(scmd);
+
 		switch (rtn) {
 		case BLK_EH_NOT_HANDLED:
 			break;



-- 
Bernd Schubert
Q-Leap Networks GmbH
