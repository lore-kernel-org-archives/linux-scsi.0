From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH / RFC] scsi_get_host_dev
Date: Tue, 28 Jan 2003 10:39:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030128183933.GB1188@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e34.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id h0SIbuZU076282
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2003 13:37:56 -0500
Received: from dyn9-47-17-195 (dyn9-47-17-67.beaverton.ibm.com [9.47.17.67])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id h0SIbuYe094876
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2003 11:37:56 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Patch against: 2.5.59

This problem was noticed in a driver that was being ported from 2.4 to
2.5.xx.

The error signature was an oops in sg_attach do to sdev_driverfs_dev not
being registered. This is because the common scsi_alloc_sdev code puts
the scsi_device on the my_devices list that will later be iterated for
attach calls. Adding to the my_devices is probably a good side effect in
case this host scsi_device ever has a timeout and scsi_error fires up.

The failure mode can be inconsistent if you use the newer scsi_add_host
interface.

An alternate solution could have been to honor the comment in
scsi_get_host_dev to not have upper levels attach to the scsi_device by
setting the type to 0x1f (Unknown or no device type) and have sg not
attach to this type.


-andmike
--
Michael Anderson
andmike@us.ibm.com

 scsi_scan.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletion(-)
------

--- 1.52/drivers/scsi/scsi_scan.c	Sun Jan  5 06:22:21 2003
+++ edited/drivers/scsi/scsi_scan.c	Thu Jan 16 00:00:51 2003
@@ -1937,6 +1937,11 @@
 	if (sdev) {
 		sdev->borken = 0;
 	}
+
+	scsi_device_register(sdev);
+
+	scsi_attach_device(sdev);
+
 	return sdev;
 }
 
@@ -1945,7 +1950,7 @@
  *
  * Purpose:     Free a scsi_device that points to the host adapter itself.
  *
- * Arguments:   SHpnt   - Host that needs a Scsi_Device
+ * Arguments:   sdev   - Host Scsi_Device
  *
  * Lock status: None assumed.
  *
@@ -1956,5 +1961,8 @@
 void scsi_free_host_dev(struct scsi_device *sdev)
 {
 	BUG_ON(sdev->id != sdev->host->this_id);
+
+	scsi_detach_device(sdev);
+	scsi_device_unregister(sdev);
 	scsi_free_sdev(sdev);
 }

