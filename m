From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] correct attribute_container list usage
Date: Mon, 22 Aug 2005 15:14:27 -0700
Message-ID: <20050822221427.GA26767@us.ibm.com>
References: <1124723180.5211.25.camel@mulgrave> <20050822214617.GA26441@us.ibm.com> <1124747956.5211.38.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:7079 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751266AbVHVWOa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 18:14:30 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j7MMER0a008632
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 18:14:27 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7MMDvcX540172
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 16:13:57 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j7MMEQRN012084
	for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2005 16:14:26 -0600
Content-Disposition: inline
In-Reply-To: <1124747956.5211.38.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Aug 22, 2005 at 04:59:16PM -0500, James Bottomley wrote:
> On Mon, 2005-08-22 at 14:46 -0700, Patrick Mansfield wrote:
> > Did you test with CONFIG_DEBUG_SLAB enabled?
> 
> Yes, but only on an ia64.
> 
> > I have a workaround for problems with device_for_each_child() not being
> > "safe", I'm trying to verify it right now, but the underlying problem is
> > in klist_next(), I don't have a general solution for it (it looks hard to
> > fix).
> 
> Could you elaborate ... the principle (hold refs to the node until
> you've extracted the next pointer) looks sound to me, even in the face
> of deletion.

[based on whatever was in current 2.6.x git tree a couple weeks ago.]

The klist is (effectively) embedded within the struct device.

The klist_next() gets and puts on the klist object, so when the struct
device ref (or kref) counts go to zero, we free up the klist independent
of its ref counts.

Attached is a test module, it oopsed for me with CONFIG_DEBUG_SLAB, on
ppc64. I was trying to complete testing of my hack (on current git tree,
rather than scsi-misc), but have been preempted by other work today.
The patch worked OK for rmmod qla2300.

You could modify it to test similar klist code.

Build and insmod, then test via:

echo 0 > /sys/module/dev_child/parameters/state
echo 1 > /sys/module/dev_child/parameters/state
echo 0 > /sys/module/dev_child/parameters/state
echo 2 > /sys/module/dev_child/parameters/state

0 creates the child, 1 removes it without using dev_for_each_child, 2
oopses when removing the device via dev_for_each_child.

Here is my hack workaround:

diff -uprN -X /home/patman/dontdiff scsi-misc-2.6.git/drivers/base/core.c dev-each-hack-scsi-misc-2.6/drivers/base/core.c
--- scsi-misc-2.6.git/drivers/base/core.c	2005-08-16 15:02:19.000000000 -0700
+++ dev-each-hack-scsi-misc-2.6/drivers/base/core.c	2005-08-22 12:14:27.000000000 -0700
@@ -366,13 +366,6 @@ void device_unregister(struct device * d
 	put_device(dev);
 }
 
-
-static struct device * next_device(struct klist_iter * i)
-{
-	struct klist_node * n = klist_next(i);
-	return n ? container_of(n, struct device, knode_parent) : NULL;
-}
-
 /**
  *	device_for_each_child - device child iterator.
  *	@dev:	parent struct device.
@@ -389,12 +382,27 @@ int device_for_each_child(struct device 
 		     int (*fn)(struct device *, void *))
 {
 	struct klist_iter i;
-	struct device * child;
+	struct device * child, * prev;
 	int error = 0;
+	struct klist_node * n;
 
 	klist_iter_init(&parent->klist_children, &i);
-	while ((child = next_device(&i)) && !error)
-		error = fn(child, data);
+
+	prev = NULL;
+	do {
+		n = klist_next(&i);
+		if (prev)
+			put_device(prev);
+		child = n ? container_of(n, struct device, knode_parent) : NULL;
+		if (child) {
+			prev = child;
+			get_device(prev);
+			error = fn(child, data);
+			if (error)
+				put_device(prev);
+		}
+	} while (child && !error);
+
 	klist_iter_exit(&i);
 	return error;
 }
-- Patrick Mansfield
