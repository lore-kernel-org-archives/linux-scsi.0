From: James.Smart@Emulex.Com
Subject: RE: [PATCH 2/2  scsi-rc-fixes-2.6] FC Remote Port patch
Date: Wed, 9 Feb 2005 13:07:25 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12EB56@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:58049 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261872AbVBISH1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Feb 2005 13:07:27 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mikenc@us.ibm.com
Cc: linux-scsi@vger.kernel.org

> Do you want to free the memory in the struct device's release
> function like the scsi_device's release function? If userspace
> has a sysfs file open and is reading or writing to it at the
> same time you free the memory here, will fun things happen?

Yep...

Here's a small patch to correct for this...

-- James S



diff -puN a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2005-02-09 09:04:32.000000000 -0500
+++ b/drivers/scsi/scsi_transport_fc.c	2005-02-09 09:06:33.000000000 -0500
@@ -984,7 +984,9 @@ static int fc_target_match(struct attrib
 
 static void fc_rport_dev_release(struct device *dev)
 {
+	struct fc_rport *rport = dev_to_rport(dev);
 	put_device(dev->parent);
+	kfree(rport);
 }
 
 int scsi_is_fc_rport(const struct device *dev)
@@ -1410,8 +1412,6 @@ fc_rport_terminate(struct fc_rport  *rpo
 	list_del(&rport->peers);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	put_device(&shost->shost_gendev);
-
-	kfree(rport);
 }
 
 /**
_
