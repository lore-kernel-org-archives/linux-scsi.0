From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] hpsa: increase the probability of a reported success after
 a device reset
Date: Tue, 03 Dec 2013 17:45:02 +0100
Message-ID: <529E0A8E.4050102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab3LCQqT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Dec 2013 11:46:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: scott.teel@hp.com, mikem@beardog.cce.hp.com, stephenmcameron@gmail.com, james.bottomley@hansenpartnership.com

rc is set in the loop, and it isn't set back to zero anywhere
this patch fixes it

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index fb5a898..e46b609 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2379,7 +2379,7 @@ static int hpsa_register_scsi(struct ctlr_info *h)
 static int wait_for_device_to_become_ready(struct ctlr_info *h,
 	unsigned char lunaddr[])
 {
-	int rc = 0;
+	int rc;
 	int count = 0;
 	int waittime = 1; /* seconds */
 	struct CommandList *c;
@@ -2399,6 +2399,7 @@ static int wait_for_device_to_become_ready(struct ctlr_info *h,
 		 */
 		msleep(1000 * waittime);
 		count++;
+		rc = 0; /* device ready. */
 
 		/* Increase wait time with each try, up to a point. */
 		if (waittime < HPSA_MAX_WAIT_INTERVAL_SECS)
-- 
1.8.3.1


