From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESUBMIT] Enclosure: fix WARN ON when doing dlpar
 removing an adapter in dual patch devices
Date: Wed, 18 Mar 2015 15:56:16 -0700
Message-ID: <1426719376.2307.36.camel@HansenPartnership.com>
References: <1426717101-26910-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36974 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753360AbbCRW4T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2015 18:56:19 -0400
In-Reply-To: <1426717101-26910-1-git-send-email-wenxiong@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, wenxiong@us.ibm.com

On Wed, 2015-03-18 at 17:18 -0500, wenxiong@linux.vnet.ibm.com wrote:
> From: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> 
> Hi James,
> 
> Our test teams still see lots of these errors in error log when dlpar removing
> the adapter in dual configuration. So I re-submit the patch.

OK so in this case you have two struct devices for one bay (one for each
path).  The links are screwed up because a bay only points at one device
(although each device points to an enclosure).

We have a check, so the enclosure backlink points to the first device it
encountered.

The scope for cockups in this situation is huge (like if the device the
enclosure points to gets removed

> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> index 38552a3..0d20e19 100644
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -209,6 +209,9 @@ static void enclosure_remove_links(struct enclosure_component *cdev)
>  	if (!cdev->dev->kobj.sd)
>  		return;
>  
> +	if (!cdev->cdev.kobj.sd)
> +		return;
> +
>  	enclosure_link_name(cdev, name);
>  	sysfs_remove_link(&cdev->dev->kobj, name);
>  	sysfs_remove_link(&cdev->cdev.kobj, "device");

This doesn't look right: for this to work it means you have to have a
dev with a kernfs link but a cdev without one.  We probably still need
to remove the dangling dev link.

Does this work?  It should remove either link if they exist.

James

---

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 38552a3..65fed71 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -202,16 +202,17 @@ static void enclosure_remove_links(struct enclosure_component *cdev)
 {
 	char name[ENCLOSURE_NAME_SIZE];
 
+	enclosure_link_name(cdev, name);
+
 	/*
 	 * In odd circumstances, like multipath devices, something else may
 	 * already have removed the links, so check for this condition first.
 	 */
-	if (!cdev->dev->kobj.sd)
-		return;
+	if (cdev->dev->kobj.sd)
+		sysfs_remove_link(&cdev->dev->kobj, name);
 
-	enclosure_link_name(cdev, name);
-	sysfs_remove_link(&cdev->dev->kobj, name);
-	sysfs_remove_link(&cdev->cdev.kobj, "device");
+	if (cdev->cdev.kobj.sd)
+		sysfs_remove_link(&cdev->cdev.kobj, "device");
 }
 
 static int enclosure_add_links(struct enclosure_component *cdev)


