From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: [PATCH] scsierror: fix indentation and braces disagreement - add
 braces
Date: Thu, 30 Oct 2008 13:00:57 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0810301259000.7072@wrl-59.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-2034808059-1225364457=:7072"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60210 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYJ3LBA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 07:01:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Anderson <andmike@linux.vnet.ibm.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-2034808059-1225364457=:7072
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


...and the list of recent breakage goes on and on, this time
it's 242f9dcb8ba6f (block: unify request timeout handling)
which broke it.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/scsi_error.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 94ed262..a6b107c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -136,7 +136,7 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 	else
 		eh_timed_out = NULL;
 
-	if (eh_timed_out)
+	if (eh_timed_out) {
 		rtn = eh_timed_out(scmd);
 		switch (rtn) {
 		case BLK_EH_NOT_HANDLED:
@@ -144,6 +144,7 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 		default:
 			return rtn;
 		}
+	}
 
 	if (unlikely(!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
 		scmd->result |= DID_TIME_OUT << 16;
-- 
1.5.2.2

---696208474-2034808059-1225364457=:7072--
