From: Alan Stern <stern@rowland.harvard.edu>
Subject: Bug when rescanning partitions on -ENOMEDIA
Date: Thu, 16 Feb 2012 11:23:22 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202161111501.1268-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43354 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751836Ab2BPQXX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2012 11:23:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Huajun Li <huajun.li.lee@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

Tejun:

Please take a look at this thread:

	http://marc.info/?t=132214525000001&r=1&w=2

Evidently your commit 1196f8b814f32cd04df334abf47648c2a9fd8324 (block: 
rescan partitions on invalidated devices on -ENOMEDIA too) is causing 
crashes.  The problem is that the partition scanning code calls 
sd_revalidate_disk() after the underlying scsi_disk structure has been 
deallocated.

There have been numerous bug reports filed on multiple Bugzillas about 
this, for example, 

	https://bugzilla.redhat.com/show_bug.cgi?id=754518

I don't know the right way to fix this, but it looks like there needs
to be some synchronization between del_gendisk() and
rescan_partitions().

Or maybe you think the synchronization should be done in the SCSI layer 
instead.  But then what about non-SCSI users of the block layer?  Does 
the block layer guarantee that it won't call methods in disk->fops 
after del_gendisk() has returned?

Alan Stern

