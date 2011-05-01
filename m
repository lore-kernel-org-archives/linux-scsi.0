From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH] fix oops in scsi_run_queue()
Date: Sun, 01 May 2011 09:42:07 -0500
Message-ID: <1304260927.2562.11.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab1EAOmN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 May 2011 10:42:13 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id DE8DA867E2
	for <linux-scsi@vger.kernel.org>; Sun,  1 May 2011 16:42:11 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The recent commit closing the race window in device teardown:

commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b
Author: James Bottomley <James.Bottomley@suse.de>
Date:   Fri Apr 22 10:39:59 2011 -0500

    [SCSI] put stricter guards on queue dead checks

is causing a potential NULL deref in scsi_run_queue() because the
q->queuedata may already be NULL by the time this function is called.
Since we shouldn't be running a queue that is being torn down, simply
add a NULL check in scsi_run_queue() to forestall this.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9901b8..03979f4 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -404,6 +404,10 @@ static void scsi_run_queue(struct request_queue *q)
 	LIST_HEAD(starved_list);
 	unsigned long flags;
 
+	/* if the device is dead, sdev will be NULL, so no queue to run */
+	if (!sdev)
+		return;
+
 	if (scsi_target(sdev)->single_lun)
 		scsi_single_lun_run(sdev);
 


