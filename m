From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] change dev_printk to printk in scsi_device_set_state
Date: Tue, 13 Apr 2004 14:39:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040413143957.A2906@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:32918 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263765AbUDMVkD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 17:40:03 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Hi James -

Patch against a recent scsi-misc-2.6.

Change the dev_printk to a regular printk, since scsi_device_set_state can
be called when no upper level driver is bound.

diff -uprN -X /home/patman/dontdiff scsi-misc-2.6/drivers/scsi/scsi_lib.c dev_printk-scsi-misc-2.6/drivers/scsi/scsi_lib.c
--- scsi-misc-2.6/drivers/scsi/scsi_lib.c	Thu Apr  8 22:21:44 2004
+++ dev_printk-scsi-misc-2.6/drivers/scsi/scsi_lib.c	Tue Apr 13 11:26:52 2004
@@ -1633,10 +1633,9 @@ scsi_device_set_state(struct scsi_device
 	return 0;
 
  illegal:
-	dev_printk(KERN_ERR, &sdev->sdev_gendev,
-		   "Illegal state transition %s->%s\n",
-		   scsi_device_state_name(oldstate),
-		   scsi_device_state_name(state));
+	printk(KERN_ERR "scsi device <%s> illegal state transition %s->%s\n",
+	       sdev->sdev_gendev.bus_id, scsi_device_state_name(oldstate),
+	       scsi_device_state_name(state));
 	WARN_ON(1);
 	return -EINVAL;
 }
