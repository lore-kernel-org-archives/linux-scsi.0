From: Kenn Humborg <kenn@linux.ie>
Subject: Possible use of uninitialized variable in sd.c
Date: Fri, 25 Feb 2005 21:06:29 +0000
Message-ID: <20050225210629.GA23018@excalibur.research.wombat.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mail2.mail.iol.ie ([193.95.141.54]:23955 "EHLO
	mail2.mail.iol.ie") by vger.kernel.org with ESMTP id S261402AbVBYVGG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 16:06:06 -0500
Received: from dialup0013.ts005.bmt.esat.net ([212.2.172.13] helo=excalibur.research.wombat.ie)
	by mail2.mail.iol.ie with esmtp (Exim 3.36 #9)
	id 1D4meu-0007la-00
	for linux-scsi@vger.kernel.org; Fri, 25 Feb 2005 21:06:00 +0000
Received: from excalibur.research.wombat.ie (IDENT:SQBE1S0a4pOZQGG1MIaB4X9ezvH5fM9F@excalibur [127.0.0.1])
	by excalibur.research.wombat.ie (8.12.11/8.12.10) with ESMTP id j1PL6TQS023320
	for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2005 21:06:29 GMT
Received: (from kenn@localhost)
	by excalibur.research.wombat.ie (8.12.11/8.12.10/Submit) id j1PL6Tt9023319
	for linux-scsi@vger.kernel.org; Fri, 25 Feb 2005 21:06:29 GMT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


In drivers/scsi/sd.c:sd_probe:

        int index;
...
        spin_lock(&sd_index_lock);
        error = idr_get_new(&sd_index_idr, NULL, &index);
        spin_unlock(&sd_index_lock);

        if (index >= SD_MAX_DISKS)
                error = -EBUSY;
        if (error)
                goto out_put;

Note that if idr_get_new() fails, index remains uninitialized.  If it
happens to be >= SD_MAX_DISKS, the error returned from idr_get_new will
be clobbered.  Patch initializes index to zero.

Signed-off-by: Kenn Humborg <kenn@linux.ie>


--- src/drivers/scsi/sd.c-2.6.10	2005-02-25 21:02:17.035529833 +0000
+++ src/drivers/scsi/sd.c	2005-02-25 21:03:09.057517937 +0000
@@ -1409,7 +1409,7 @@
 	struct scsi_device *sdp = to_scsi_device(dev);
 	struct scsi_disk *sdkp;
 	struct gendisk *gd;
-	u32 index;
+	u32 index = 0;
 	int error;
 
 	error = -ENODEV;
