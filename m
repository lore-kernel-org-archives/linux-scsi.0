From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: libsas: question and suggested patch for hotplug issue in sas_discover.c
Date: Mon, 13 Sep 2010 14:08:03 +0800
Message-ID: <29C34F51E4A74AAB9C9E317960385C10@usish.com.cn>
References: <E3280858FA94444CA49D2BA02341C9830114B6452A@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:50940 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab0IMGKI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2010 02:10:08 -0400
In-Reply-To: <E3280858FA94444CA49D2BA02341C9830114B6452A@orsmsx506.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'Ciechanowski, Ed'" <ed.ciechanowski@intel.com>, linux-scsi@vger.kernel.org
Cc: "'Williams, Dan J'" <dan.j.williams@intel.com>, "'Neubauer, Wojciech'" <Wojciech.Neubauer@intel.com>, "'Fan, Haipao'" <haipao.fan@intel.com>, "'Jeppsen, Roger C'" <roger.c.jeppsen@intel.com>, 'James Bottomley' <James.Bottomley@suse.de>


We have found an issue with hot plugging behind an expander - After we
unplug a drive behind expander, the sas_unregister_dev function is called,
it then calls sas_rphy_delete to notify the upper layer that the device is
gone. 

However, this sas_rphy_delete is not returning for several minutes later
after the I/O timeout process is exhausted. Once sas_rphy_delete returns,
the sas_notify_lldd_dev_gone function is called to notify the lldd driver
the device is gone.

The problem we have seen is that the device is not posted after several
minutes of being unplugged and a then replugged.
 
The following change is in ../libsas/sas_discover.c file. By calling the
sas_notify_lldd_dev_gone function before calling the sas_unregister_dev
function we can resolve the hot plug drive behind expander issue.

--- linux-2.6.36-rc3/drivers/scsi/libsas/sas_discover.c.old	2010-09-09
06:54:05.096757412 -0700
+++ linux-2.6.36-rc3/drivers/scsi/libsas/sas_discover.c	2010-09-09
06:56:32.115230046 -0700
@@ -233,6 +233,7 @@
 {
 	if (dev->rphy) {
 		sas_remove_children(&dev->rphy->dev);
+		sas_notify_lldd_dev_gone(dev);
 		sas_rphy_delete(dev->rphy);
 		dev->rphy = NULL;
 	}

The above change is to call sas_notify_lldd_dev_gone before calling
sas_rphy_delete which causes I/O's to abort instead of timeout, so the
return from calling sas_rphy_delete is more like seconds instead of minutes.
[Jack] I don't think the patch is OK, the sas_notify_lldd_dev_gone(dev) will
be
called twice if you do this: once as you add, once in
sas_unregister_common_dev.

Thanks, 
ed.ciechanowski@intel.com

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

