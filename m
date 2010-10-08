From: Oliver Neukum <oneukum@suse.de>
Subject: [PATCH 2/2] SCSI: sd_resume_ don't leak SCSI error codes
Date: Fri, 8 Oct 2010 15:33:02 +0200
Message-ID: <201010081533.02608.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757388Ab0JHNdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2010 09:33:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, hare@suse.de, Alan Stern <stern@rowland.harvard.edu>, teheo@suse.de, linux-scsi@vger.kernel.org

>From 563c176d617a56f390e89f1e9ded4946121ee63e Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Fri, 8 Oct 2010 15:19:49 +0200
Subject: [PATCH 2/2] SCSI: sd_resume_ don't leak SCSI error codes

The generic layer expects generic error codes
not codes specific to SCSI

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 drivers/scsi/sd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5784c94..51b3302 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2558,7 +2558,7 @@ static int sd_resume(struct device *dev)
 
 done:
 	scsi_disk_put(sdkp);
-	return ret;
+	return ret ? -EIO : 0;
 }
 
 /**
-- 
1.7.1

