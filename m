From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] scsi: remove driver_data direct access of struct device
Date: Thu, 30 Apr 2009 15:22:13 -0700
Message-ID: <20090430222213.GA18631@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:55457 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759660AbZD3W3k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2009 18:29:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>

From: Greg Kroah-Hartman <gregkh@suse.de>

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.

Cc: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/aha1740.c |    2 +-
 drivers/scsi/libsrp.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -646,7 +646,7 @@ static int aha1740_probe (struct device 
 
 static __devexit int aha1740_remove (struct device *dev)
 {
-	struct Scsi_Host *shpnt = dev->driver_data;
+	struct Scsi_Host *shpnt = dev_get_drvdata(dev);
 	struct aha1740_hostdata *host = HOSTDATA (shpnt);
 
 	scsi_remove_host(shpnt);
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -135,7 +135,7 @@ int srp_target_alloc(struct srp_target *
 	INIT_LIST_HEAD(&target->cmd_queue);
 
 	target->dev = dev;
-	target->dev->driver_data = target;
+	dev_set_drvdata(target->dev, target);
 
 	target->srp_iu_size = iu_size;
 	target->rx_ring_size = nr;
