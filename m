From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] zfcp: correctly set this_id for hosts
Date: Thu, 2 Mar 2006 21:28:54 +0100
Message-ID: <20060302202854.GA9749@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:49496 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S932254AbWCBUaG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 15:30:06 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id k22KU5Qk104454
	for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 20:30:05 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k22KULxA226884
	for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 21:30:21 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k22KU49u006666
	for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 21:30:04 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

This patch is for 2.6.16.

It fixes a bug in zfcp which provokes a race
in scsi_scan.c. Finally this can lead to an Oops like:

kernel BUG at fs/sysfs/symlink.c:87!
...
sysfs_create_link+0x16e/0x1c4
class_device_add+0x194/0x3b8
attribute_container_add_class_device+0x26/0x50
transport_add_class_device+0x34/0x6c
attribute_container_device_trigger+0x170/0x174
scsi_alloc_target+0x22c/0x360
__scsi_add_device+0x3a/0x148
scsi_add_device+0x2c/0x54
zfcp_erp_thread+0xb90/0x152c
kernel_thread_starter+0x6/0xc

Please apply. Thanks!


Regards,

Andreas


zfcp: correctly set this_id for hosts

Correctly set this_id for the host. Otherwise we provoke
a race between scsi_target_reap_work and concurrent
scsi_add_device.


Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

 drivers/s390/scsi/zfcp_scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

c72e15b96925b812528f8877c13174992e1d3a42
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 9f6b4d7..a2de3c9 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -68,7 +68,7 @@ struct zfcp_data zfcp_data = {
 	      eh_host_reset_handler:   zfcp_scsi_eh_host_reset_handler,
 			               /* FIXME(openfcp): Tune */
 	      can_queue:               4096,
-	      this_id:	               0,
+	      this_id:	               -1,
 	      /*
 	       * FIXME:
 	       * one less? can zfcp_create_sbale cope with it?
-- 
0.99.9n-g5a22
