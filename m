From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [RFC] enclosure: fix sysfs symlinks creation when using multipath
Date: Fri, 16 Jun 2017 14:48:50 +0200
Message-ID: <f2ee7996-dd08-6716-f7fd-43ea94086876@redhat.com>
References: <1486476528-27580-2-git-send-email-mlombard@redhat.com>
 <12b5fa7f-3799-1223-db06-c233da3e7c33@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59062 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753265AbdFPMs5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jun 2017 08:48:57 -0400
In-Reply-To: <12b5fa7f-3799-1223-db06-c233da3e7c33@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Miller <dougmill@linux.vnet.ibm.com>, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org



Dne 16.6.2017 v 14:40 Douglas Miller napsal(a):
> 
> I'd like to add that we are seeing this problem with singlepath installations and need to get this fixed upstream as soon as possible. RHEL new product contains this fix and is working for us, but we need to be able to offer other distros as well. I am currently running this patch on a custom-built Ubuntu 16.04.2 kernel and it is fixing the problem there.
> 
> What needs to be done to get this patch accepted?
> 

Note that James proposed a different patch to fix this bug.

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 65fed71..ae89082 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -375,6 +375,7 @@ int enclosure_add_device(struct enclosure_device *edev, int component,
 			 struct device *dev)
 {
 	struct enclosure_component *cdev;
+	int err;
 
 	if (!edev || component >= edev->components)
 		return -EINVAL;
@@ -384,12 +385,15 @@ int enclosure_add_device(struct enclosure_device *edev, int component,
 	if (cdev->dev == dev)
 		return -EEXIST;
 
-	if (cdev->dev)
+	if (cdev->dev) {
 		enclosure_remove_links(cdev);
-
-	put_device(cdev->dev);
-	cdev->dev = get_device(dev);
-	return enclosure_add_links(cdev);
+		put_device(cdev->dev);
+		cdev->dev = NULL;
+	}
+	err = enclosure_add_links(cdev);
+	if (!err)
+		cdev->dev = get_device(dev);
+	return err;
 }
 EXPORT_SYMBOL_GPL(enclosure_add_device);
 
