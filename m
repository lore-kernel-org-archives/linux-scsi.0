From: David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH] xen-scsifront: don't deadlock if the ring becomes full
Date: Thu, 11 Sep 2014 14:31:53 +0100
Message-ID: <1410442313-19639-1-git-send-email-david.vrabel@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp02.citrix.com ([66.165.176.63]:61841 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbaIKNcj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2014 09:32:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: xen-devel@lists.xenproject.org
Cc: David Vrabel <david.vrabel@citrix.com>, linux-scsi@vger.kernel.org, Juergen Gross <jgross@suse.com>

scsifront_action_handler() will deadlock on host->host_lock, if the
ring is full and it has to wait for entries to become available.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
This was found with sparse. I've not tested it.
---
 drivers/scsi/xen-scsifront.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index 7e88659..cc14c8d 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -541,8 +541,9 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 	if (!shadow)
 		return FAILED;
 
+	spin_lock_irq(host->host_lock);
+
 	for (;;) {
-		spin_lock_irq(host->host_lock);
 		if (!RING_FULL(&info->ring)) {
 			ring_req = scsifront_command2ring(info, sc, shadow);
 			if (ring_req)
-- 
1.7.10.4

