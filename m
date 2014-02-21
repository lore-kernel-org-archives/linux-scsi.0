From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 3/6] hpsa: increase the probability of a reported success
	after a device reset
Date: Fri, 21 Feb 2014 16:25:05 -0600
Message-ID: <20140221222505.31344.94687.stgit@beardog.cce.hp.com>
References: <20140221222153.31344.99129.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:48952 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbaBUW0c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2014 17:26:32 -0500
Received: from g5t1626.atlanta.hp.com (g5t1626.atlanta.hp.com [15.192.137.9])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 5EFF8614C9
	for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2014 22:26:32 +0000 (UTC)
In-Reply-To: <20140221222153.31344.99129.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Tomas Henzl <thenzl@redhat.com>

rc is set in the loop, and it isn't set back to zero anywhere
this patch fixes it

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/hpsa.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a0fcaa6..23110a8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4142,7 +4142,7 @@ static int hpsa_register_scsi(struct ctlr_info *h)
 static int wait_for_device_to_become_ready(struct ctlr_info *h,
 	unsigned char lunaddr[])
 {
-	int rc = 0;
+	int rc;
 	int count = 0;
 	int waittime = 1; /* seconds */
 	struct CommandList *c;
@@ -4162,6 +4162,7 @@ static int wait_for_device_to_become_ready(struct ctlr_info *h,
 		 */
 		msleep(1000 * waittime);
 		count++;
+		rc = 0; /* Device ready. */
 
 		/* Increase wait time with each try, up to a point. */
 		if (waittime < HPSA_MAX_WAIT_INTERVAL_SECS)

