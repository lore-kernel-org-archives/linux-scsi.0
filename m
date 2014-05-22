From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH] scsi_transport_sas: move bsg destructor into sas_rphy_remove
Date: Thu, 22 May 2014 17:30:54 -0400
Message-ID: <1400794254-23426-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o143.mxlogic.net ([208.65.145.66]:55786 "EHLO
	p01c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaEVVc1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2014 17:32:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, Joe Lawrence <joe.lawrence@stratus.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>

The recent change in sysfs, bcdde7e221a8750f9b62b6d0bd31b72ea4ad9309
"sysfs: make __sysfs_remove_dir() recursive" revealed an asymmetric
rphy device creation/deletion sequence in scsi_transport_sas:

  modprobe mpt2sas
    sas_rphy_add
      device_add A               rphy->dev
      device_add B               sas_device transport class
      device_add C               sas_end_device transport class
      device_add D               bsg class

  rmmod mpt2sas
    sas_rphy_delete
      sas_rphy_remove
        device_del B
        device_del C
        device_del A
          sysfs_remove_group     recursive sysfs dir removal
      sas_rphy_free
        device_del D             warning

  where device A is the parent of B, C, and D.

When sas_rphy_free tries to unregister the bsg request queue (device D
above), the ensuing sysfs cleanup discovers that its sysfs group has
already been removed and emits a warning, "sysfs group... not found for
kobject 'end_device-X:0'".

Since bsg creation is a side effect of sas_rphy_add, move its
complementary removal call into sas_rphy_remove. This imposes the
following tear-down order for the devices above: D, B, C, A.

Note the sas_device and sas_end_device transport class devices (B and C
above) are created and destroyed both via the list match traversal in
attribute_container_device_trigger, so the order in which they are
handled is fixed. This is fine as long as they are deleted before their
parent device.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/scsi_transport_sas.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 1b68142..c341f85 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1621,8 +1621,6 @@ void sas_rphy_free(struct sas_rphy *rphy)
 	list_del(&rphy->list);
 	mutex_unlock(&sas_host->lock);
 
-	sas_bsg_remove(shost, rphy);
-
 	transport_destroy_device(dev);
 
 	put_device(dev);
@@ -1681,6 +1679,7 @@ sas_rphy_remove(struct sas_rphy *rphy)
 	}
 
 	sas_rphy_unlink(rphy);
+	sas_bsg_remove(NULL, rphy);
 	transport_remove_device(dev);
 	device_del(dev);
 }
-- 
1.7.10.4

