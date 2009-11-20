From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/4 ver 3] SCSI: add construction flags to scsi_device
 structure
Date: Fri, 20 Nov 2009 15:55:43 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0911201422150.2903-100000@iolanthe.rowland.org>
References: <1258670909.6363.647.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:47323 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753928AbZKTUzn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2009 15:55:43 -0500
In-Reply-To: <1258670909.6363.647.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 19 Nov 2009, James Bottomley wrote:

> Your 5 constructor flags are what makes this so complex ... plus it now
> doesn't actually work with the memory leak fix commit:
> 
> commit 37e6ba00720c2786330dec2a9a5081e9e049422f
> Author: James Bottomley <James.Bottomley@suse.de>
> Date:   Fri Oct 2 13:30:08 2009 -0500
> 
>     [SCSI] fix memory leak in initialization

Yes, okay.  I'll rebase on top of that patch.

> I think you can make this much simpler just by having one visible flag
> (i.e. was scsi_sysfs_sdev_add() called or not) and making everything
> unwind back to either the alloc or the add state on failure.  Like the
> attached.  It also cleanly fixes the USB scan crash in an easily
> backportable manner.

That makes sense.  But there's still a little awkwardness caused by the
fact that the creation and destruction paths aren't clean mirror
images.  In broad outline and ignoring the state transitions, we have:

scsi_alloc_sdev():
	kzalloc and init sdev
	get_device(&starget->dev)
	scsi_alloc_queue()
	scsi_sysfs_device_initialize():
		device_initialize(&sdev->sdev_gendev)
		device_initialize(&sdev->sdev_dev)
		get_device(&sdev->sdev_gendev) for sdev_dev
		transport_setup_device()
		add sdev to host's and target's lists
	shost->hostt->slave_alloc()

scsi_add_lun():
	transport_configure_device()
	sdev->host->hostt->slave_configure()
	scsi_sysfs_add_sdev():
		device_add(&sdev->sdev_gendev)
		device_add(&sdev->sdev_dev)
		transport_add_device()
		bsg_register_queue()
		add extra host attributes

The removal routines look like this:

__scsi_remove_device():
	bsg_unregister_queue()
	device_unregister(&sdev->sdev_dev)
	transport_remove_device()
	device_del(&sdev->sdev_gendev)
	sdev->host->hostt->slave_destroy()
	transport_destroy_device()
	put_device(&sdev->sdev_gendev)

scsi_device_cls_release():
	put_device(&sdev->sdev_gendev)

scsi_device_dev_release_usercontext():
	remove sdev from host's and target's lists
	scsi_free_queue()
	kfree(sdev)
	put_device(&starget->dev)

Sorry for the large amount of detail.  But this does reveal some
oddities.

     1. __scsi_remove_device() is awkward because it encompasses both
	removal from visibility (its first four lines above) and
	deinitialization (the last three lines).  Adding the
	is_visible flag helps clarify this, of course.

     2. bsg_unregister_queue() is called even when
	bsg_register_queue() fails.  Is this legitimate?

     3. transport_setup_device() and adding sdev to the host's and 
	target's lists don't have anything to do with sysfs.  Hence
	they don't really belong in scsi_sysfs_device_initialize().
	Is there any reason not to move them up into scsi_alloc_lun()?

     4. bsg_register_queue() comes before transport_add_device() but
	bug_unregister_queue() doesn't come after
	transport_remove_device().  Maybe the order doesn't matter and
	maybe it does; but it isn't commented and it looks unclean.
	Should the second pair be reversed?

     5. scsi_sysfs_device_initialize() can't fail.  Hence it should
	come after the slave_alloc() call, which can, in order to
	simplify unwinding.  Unless there is an ordering restriction
	which prevents this?

Would it be okay to take your patch and modify it in accordance with
points 3 - 5?

Alan Stern

