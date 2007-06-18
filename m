From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 3/11] Remove stale put_device() from scsi_sysfs_add_sdev()
Date: Mon, 18 Jun 2007 11:01:41 +0200
Message-ID: <20070618090141.6C2C6D44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbXFRJBm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jun 2007 05:01:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


In one obscure error path someone decided to do a put_device()
on the sdev parent.
As this is the only reference to it I don't thing it makes much sense.
Remove it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index a31104f..7d67517 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -720,7 +720,6 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
-		put_device(sdev->sdev_gendev.parent);
 		sdev_printk(KERN_INFO, sdev,
 			    "failed to add device (error %d)\n", error);
 		return error;
-- 
1.4.3.4

