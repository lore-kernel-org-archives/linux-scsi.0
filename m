From: Christoph Hellwig <hch@lst.de>
Subject: Two questions on scsi_device_{get,put}
Date: Fri, 8 Aug 2003 14:59:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030808125956.GA13589@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:23275 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S271317AbTHHNAC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2003 09:00:02 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: andmike@us.ibm.com
Cc: linux-scsi@vger.kernel.org

I'm trying to forward-port my locking infrastructure for
shost->my_devices to the current scsi tree.  As this list is
acquired from irq context we need these locks to be spinlocks,
but for that to work scsi_device_get/scsi_device_put must not
block.

But after your changes it's using the class r/w semaphore for
synchronisation.  What it this protecting except sdev->access_count?
Also what's the reason we can't do the device_del directly but have
to do it in scsi_device_put?

A final nitpick:  you're losing a module refernece for some failure
pathes of scsi_module_get.
