From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] mptsas: don't complain on bogus slave_alloc calls
Date: Mon, 30 Jan 2006 19:00:43 +0100
Message-ID: <20060130180043.GA5827@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:37866 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964858AbWA3SBF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 13:01:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com, Eric.Moore@lsil.com
Cc: linux-scsi@vger.kernel.org

When people use the userspace scanning facilities on SAS hardware the
LLDD gets bogus slave_alloc calls.  Just fail those gracefully instead
of printing a warning in mptsas and another one in the midlayer.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- linux-2.6.orig/drivers/message/fusion/mptsas.c	2006-01-15 21:45:28.000000000 +0100
+++ linux-2.6/drivers/message/fusion/mptsas.c	2006-01-30 18:52:58.000000000 +0100
@@ -301,9 +301,8 @@
 	}
 	mutex_unlock(&hd->ioc->sas_topology_mutex);
 
-	printk("No matching SAS device found!!\n");
 	kfree(vdev);
-	return -ENODEV;
+	return -ENXIO;
 
  out:
 	vtarget->ioc_id = vdev->ioc_id;
