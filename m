From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] correct attribute_container list usage
Date: Mon, 22 Aug 2005 21:03:03 -0500
Message-ID: <1124762584.5211.53.camel@mulgrave>
References: <1124723180.5211.25.camel@mulgrave>
	 <20050822214617.GA26441@us.ibm.com> <1124747956.5211.38.camel@mulgrave>
	 <20050822221427.GA26767@us.ibm.com> <1124750826.5211.46.camel@mulgrave>
	 <1124753185.5211.50.camel@mulgrave>  <20050823003938.GA29211@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:48566 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751300AbVHWCDL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 22:03:11 -0400
In-Reply-To: <20050823003938.GA29211@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Mon, 2005-08-22 at 17:39 -0700, Patrick Mansfield wrote:
> But, we have to pass in a struct kref, to affect put/get_device, correct?

Correct.  Let me post the code mods to drivers/base/core.c so you can
see how it works.

Incidentally, it now passes your dev_child test without causing a slab
corruption.

James

diff --git a/drivers/base/core.c b/drivers/base/core.c
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -191,6 +191,20 @@ void device_remove_file(struct device * 
 	}
 }
 
+static void klist_children_get(struct klist_node *n)
+{
+	struct device *dev = container_of(n, struct device, knode_parent);
+
+	get_device(dev);
+}
+
+static void klist_children_put(struct klist_node *n)
+{
+	struct device *dev = container_of(n, struct device, knode_parent);
+
+	put_device(dev);
+}
+
 
 /**
  *	device_initialize - init device structure.
@@ -207,7 +221,8 @@ void device_initialize(struct device *de
 {
 	kobj_set_kset_s(dev, devices_subsys);
 	kobject_init(&dev->kobj);
-	klist_init(&dev->klist_children);
+	klist_init_embedded(&dev->klist_children, klist_children_get,
+			    klist_children_put);
 	INIT_LIST_HEAD(&dev->dma_pools);
 	init_MUTEX(&dev->sem);
 }


