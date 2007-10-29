From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
 devices (fwd)
Date: Mon, 29 Oct 2007 14:47:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0710291434370.11432-100000@iolanthe.rowland.org>
References: <1193672157.3383.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60529 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753273AbXJ2Sr7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2007 14:47:59 -0400
In-Reply-To: <1193672157.3383.22.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Hannes Reinecke <hare@suse.de>, Greg KH <greg@kroah.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 29 Oct 2007, James Bottomley wrote:

> I'm not sure if we can do this patch.  If you kill a device, you see
> there's a processing state in scsi_prep_fn() for SDEV_DEL, which has a
> printk message I see quite often when I unplug devices while they're
> operating.
> 
> If you NULL out and free the request queue immediately after setting
> SDEV_DEL, without allowing the devices and filesystems to finish, are
> you sure we're not going to get a null deref on sdev->request_queue?

Let's get at this another way.  The patch below probably should be 
applied in any case.  It's essentially a reversion of this patch from 
2003:

http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commit;h=10921a8f1305b8ec97794941db78b825db5839bc

which was written to compensate for problems in the SCSI stack.  The
idea was to avoid releasing a kobject before all its children were
released.  However as far as I can see, in general we should be able to
release a kobject as soon as all its children are removed and its
refcount drops to 0, without waiting for the children to be released.  
To put it another way, once a child is removed from visibility it
should not try (or need) to access its parent at all.  If it has to
then it should take an explicit reference to the parent.

Since the SCSI stack is now in much better shape, there doesn't seem to 
be any reason to keep the old code.  Do you agree that the patch below 
is worth merging?  I submitted it to Greg some time ago, but he didn't 
want to accept it without some assurance that it is now safe.

It would fix the problem Kay and saw with the circular references, 
because the references would all get dropped when the scsi_device is 
removed instead of waiting for a release that will never come.

Alan Stern



Index: usb-2.6/lib/kobject.c
===================================================================
--- usb-2.6.orig/lib/kobject.c
+++ usb-2.6/lib/kobject.c
@@ -206,12 +206,16 @@ void kobject_init(struct kobject * kobj)
 
 static void unlink(struct kobject * kobj)
 {
+	struct kobject *parent = kobj->parent;
+
 	if (kobj->kset) {
 		spin_lock(&kobj->kset->list_lock);
 		list_del_init(&kobj->entry);
 		spin_unlock(&kobj->kset->list_lock);
 	}
+	kobj->parent = NULL;
 	kobject_put(kobj);
+	kobject_put(parent);
 }
 
 /**
@@ -255,7 +259,6 @@ int kobject_add(struct kobject * kobj)
 	if (error) {
 		/* unlink does the kobject_put() for us */
 		unlink(kobj);
-		kobject_put(parent);
 
 		/* be noisy on error issues */
 		if (error == -EEXIST)
@@ -498,7 +501,6 @@ void kobject_cleanup(struct kobject * ko
 {
 	struct kobj_type * t = get_ktype(kobj);
 	struct kset * s = kobj->kset;
-	struct kobject * parent = kobj->parent;
 	const char *name = kobj->k_name;
 
 	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
@@ -515,7 +517,6 @@ void kobject_cleanup(struct kobject * ko
 	}
 	if (s)
 		kset_put(s);
-	kobject_put(parent);
 }
 
 static void kobject_release(struct kref *kref)

