From: "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
Subject: libsas: question and suggested patch for hotplug issue in
 sas_discover.c
Date: Fri, 10 Sep 2010 15:20:25 -0700
Message-ID: <E3280858FA94444CA49D2BA02341C9830114B6452A@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4270 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab0IJWUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2010 18:20:34 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Fan, Haipao" <haipao.fan@intel.com>, "Jeppsen, Roger C" <roger.c.jeppsen@intel.com>, James Bottomley <James.Bottomley@suse.de>

We have found an issue with hot plugging behind an expander - After we unplug a drive behind expander, the sas_unregister_dev function is called, it then calls sas_rphy_delete to notify the upper layer that the device is gone. 

However, this sas_rphy_delete is not returning for several minutes later after the I/O timeout process is exhausted. Once sas_rphy_delete returns, the sas_notify_lldd_dev_gone function is called to notify the lldd driver the device is gone.

The problem we have seen is that the device is not posted after several minutes of being unplugged and a then replugged.
 
The following change is in ../libsas/sas_discover.c file. By calling the sas_notify_lldd_dev_gone function before calling the sas_unregister_dev function we can resolve the hot plug drive behind expander issue.

--- linux-2.6.36-rc3/drivers/scsi/libsas/sas_discover.c.old	2010-09-09 06:54:05.096757412 -0700
+++ linux-2.6.36-rc3/drivers/scsi/libsas/sas_discover.c	2010-09-09 06:56:32.115230046 -0700
@@ -233,6 +233,7 @@
 {
 	if (dev->rphy) {
 		sas_remove_children(&dev->rphy->dev);
+		sas_notify_lldd_dev_gone(dev);
 		sas_rphy_delete(dev->rphy);
 		dev->rphy = NULL;
 	}

The above change is to call sas_notify_lldd_dev_gone before calling sas_rphy_delete which causes I/O's to abort instead of timeout, so the return from calling sas_rphy_delete is more like seconds instead of minutes.


Thanks, 
ed.ciechanowski@intel.com

