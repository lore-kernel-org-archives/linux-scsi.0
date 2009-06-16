From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 47/64] scsi: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:36 -0700
Message-ID: <1245131213-24168-47-git-send-email-gregkh@suse.de>
References: <20090616051351.GA23627@kroah.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:48435 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935899AbZFPFvd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:33 -0400
In-Reply-To: <20090616051351.GA23627@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>

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

diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index ed0e3e5..5381357 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -646,7 +646,7 @@ static int aha1740_probe (struct device *dev)
 
 static __devexit int aha1740_remove (struct device *dev)
 {
-	struct Scsi_Host *shpnt = dev->driver_data;
+	struct Scsi_Host *shpnt = dev_get_drvdata(dev);
 	struct aha1740_hostdata *host = HOSTDATA (shpnt);
 
 	scsi_remove_host(shpnt);
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 15e2d13..2742ae8 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -135,7 +135,7 @@ int srp_target_alloc(struct srp_target *target, struct device *dev,
 	INIT_LIST_HEAD(&target->cmd_queue);
 
 	target->dev = dev;
-	target->dev->driver_data = target;
+	dev_set_drvdata(target->dev, target);
 
 	target->srp_iu_size = iu_size;
 	target->rx_ring_size = nr;
-- 
1.6.3.2

