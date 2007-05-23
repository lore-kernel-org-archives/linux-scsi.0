From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 9/9] Leftovers
Date: Wed, 23 May 2007 10:56:00 +0200
Message-ID: <20070523085600.2BEB0D44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:35193 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758191AbXEWI4B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 04:56:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


Forgot to call scsi_destroy_device() in scsi_forget_host().
Shame on me.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 75b8a78..6a51ac5 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1877,6 +1877,7 @@ void scsi_forget_host(struct Scsi_Host *
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		__scsi_remove_device(sdev);
+		scsi_destroy_device(sdev);
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-- 
1.4.3.4

