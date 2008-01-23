From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: [PATCH 2.6.23.14] SCSI : scsi_device_lookup/scsi_device_lookup_by_target return NULL for an existent scsi_device
Date: Wed, 23 Jan 2008 01:56:14 -0800 (PST)
Message-ID: <622408.27957.qm@web53704.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web53704.mail.re2.yahoo.com ([206.190.37.25]:48593 "HELO
	web53704.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750942AbYAWKCy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jan 2008 05:02:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


__scsi_device_lookup and __scsi_device_lookup_by_target do not 
check for the sdev_state and hence return scsi_devices with 
sdev_state set to SDEV_DEL also. It has the following side effects.

We can have two scsi_devices with the same HBTL queued in 
the scsi_host->__devices/scsi_target->devices list, one
in the SDEV_DEL state and the other in, say SDEV_RUNNING state. 
    If the one in the SDEV_DEL state is before the one in SDEV_RUNNING 
state, (which will almost always be the case) the scsi_device_lookup and 
scsi_device_lookup_by_target will never find the totally legitimate
scsi_device (the one in the SDEV_RUNNING state).

This is because __scsi_device_lookup/__scsi_device_lookup_by_target 
always returns the first one in the list (which in our case is the 
one with the SDEV_DEL state) and the scsi_device_get() which is called by 
scsi_device_lookup/scsi_device_lookup_by_target will return -ENXIO 
for this scsi_device, resulting in scsi_device_lookup and 
scsi_device_lookup_by_target to return NULL.

        So we _cannot_ lookup a perfectly valid device present in the
list of scsi_devices. 

        The right thing to do is to not have __scsi_device_lookup
and __scsi_device_lookup_by_target match a device if the scsi_device
state is SDEV_DEL. This will also make these functions similar in 
behaviour to their scsi_device_lookup/scsi_device_lookup_by_target
counterparts, as the comments in the code suggest.

        One way by which we can have two scsi_devices in the list is 
as follows.        
        Suppose a scsi_device has some outstanding command(s) when 
scsi_remove_device is called for it. Due to the extra ref being held
by the command in flight, the __scsi_remove_device->put_device call 
will not actually free the scsi_device and it will remain in the 
scsi_device list albeit in the SDEV_DEL state. Now if we do a 
scsi_add_device for the same HBTL, a new device with the same HBTL
(this one in SDEV_RUNNING state) gets added to the scsi_device list. 
        
        Infact if we call scsi_add_device one more time, it happily 
goes ahead and tries to add it once more, as 
scsi_probe_and_add_lun->scsi_device_lookup_by_target does not return
the already existing device. This will though result in the kobject 
EEXIST warning dump.

        The patch below solves the problem described here by not
returning scsi_devices in SDEV_DEL state, thus allowing scsi_device
in SDEV_RUNNING state (if any) to be correctly returned, instead.


Thanx,
Tomar


Signed-off-by: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>
---

--- linux-2.6.23.14/drivers/scsi/scsi.c.orig	2008-01-23 18:06:02.000000000 +0530
+++ linux-2.6.23.14/drivers/scsi/scsi.c	2008-01-23 19:17:35.000000000 +0530
@@ -951,7 +951,7 @@ struct scsi_device *__scsi_device_lookup
 	struct scsi_device *sdev;
 
 	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
-		if (sdev->lun ==lun)
+		if (sdev->lun == lun && sdev->sdev_state != SDEV_DEL)
 			return sdev;
 	}
 
@@ -1008,7 +1008,7 @@ struct scsi_device *__scsi_device_lookup
 
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
 		if (sdev->channel == channel && sdev->id == id &&
-				sdev->lun ==lun)
+			sdev->lun == lun && sdev->sdev_state != SDEV_DEL)
 			return sdev;
 	}



      ___________________________________________________________
Support the World Aids Awareness campaign this month with Yahoo! For Good http://uk.promotions.yahoo.com/forgood/
