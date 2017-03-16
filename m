From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] enclosure: fix sysfs symlinks creation when using
 multipath
Date: Thu, 16 Mar 2017 11:49:15 -0700
Message-ID: <1489690155.11068.10.camel@linux.vnet.ibm.com>
References: <1488454204-21251-1-git-send-email-mlombard@redhat.com>
         <yq1varaf6to.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52609 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753096AbdCPSt2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Mar 2017 14:49:28 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2GIheF9006925
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2017 14:49:26 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0b-001b2d01.pphosted.com with ESMTP id 297ym4hvtb-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2017 14:49:26 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Thu, 16 Mar 2017 14:49:25 -0400
In-Reply-To: <yq1varaf6to.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2017-03-15 at 19:39 -0400, Martin K. Petersen wrote:
> Maurizio Lombardi <mlombard@redhat.com> writes:
> 
> > With multipath, it may happen that the same device is passed to
> > enclosure_add_device() multiple times and that the
> > enclosure_add_links() function fails to create the symlinks because
> > the device's sysfs directory entry is still NULL.  In this case,
> > the
> > links will never be created because all the subsequent calls to
> > enclosure_add_device() will immediately fail with EEXIST.
> 
> James?

Well I don't think the patch is the correct way to do this.  The
problem is that if we encounter an error creating the links, we
shouldn't add the device to the enclosure.  There's no need of a
links_created variable (see below).

However, more interesting is why the link creation failed in the first
place.  The device clearly seems to exist because it was added to sysfs
at time index 19.2 and the enclosure didn't try to use it until 60.0. 
 Can you debug this a bit more, please?  I can't see anything specific
to multipath in the trace, so whatever this is looks like it could
happen in the single path case as well.

James

---

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
 
