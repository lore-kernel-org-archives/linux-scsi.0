From: Alan Stern <stern@rowland.harvard.edu>
Subject: Race in removal of host class device attribute file
Date: Thu, 16 Oct 2003 17:09:04 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0310161656400.890-100000@ida.rowland.org>
References: <20030709144410.GA3544@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:4356 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263201AbTJPVJF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Oct 2003 17:09:05 -0400
In-Reply-To: <20030709144410.GA3544@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

I've created a class device attribute file for the hosts supported by the
usb-storage driver, using the shost_attrs member of the host template.  
It seems to contain an intractable race condition when unregistering the
host.  There's no way for the driver to know when the scsi host's class
device is released, so there's no way to know when it's safe to deallocate
the host's driver-specific data structure.  Waiting until
scsi_remove_host() returns isn't good enough, because a user process might
keep the attribute file open and thus prevent release of the class device
indefinitely.

What's the right way to solve this problem?  It seems to me that it must 
involve creating a kobject in the driver-specific host data structure, on 
which the class device's release() routine could do a kobject_put().  That 
way the driver would be able to tell when it should free the data 
structure.  But code to handle this would have to be added to the scsi 
core.

Alan Stern

