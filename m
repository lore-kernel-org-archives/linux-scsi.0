From: Alan Stern <stern@rowland.harvard.edu>
Subject: scsi_forget_host() and scsi_remove_device()
Date: Thu, 3 Jul 2003 17:02:22 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307031650370.779-100000@ida.rowland.org>
References: <20030627110259.A3751@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:5892 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264312AbTGCUrz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2003 16:47:55 -0400
In-Reply-To: <20030627110259.A3751@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

There's a real problem about the way scsi_forget_host() calls
scsi_remove_device() for each device on the host's bus.  The problem is
that scsi_remove_device() unregisters the device in sysfs, which unbinds
the device's driver.  This happens immediately, without waiting for the
reference count to be 0.  So if the device is open (mounted, for example)  
when the host is unplugged, the filesystem will have a dangling reference
to the unbound driver.  Of course this will most likely cause a segfault
when the user attempts to unmount the device.

I don't know what the right way is to attack this problem, or what you're
planning to do about it.  One approach would be somehow to prevent any new
references to the device from being created while waiting for all the
existing references to go away.  But that doesn't seem feasible.

How are you going to address this problem?

Alan Stern

