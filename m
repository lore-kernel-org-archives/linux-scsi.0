From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Race in removal of host class device attribute file
Date: Thu, 16 Oct 2003 15:47:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031016224740.GE903@beaverton.ibm.com>
References: <20030709144410.GA3544@beaverton.ibm.com> <Pine.LNX.4.44L0.0310161656400.890-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:10441 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263214AbTJPWns
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Oct 2003 18:43:48 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0310161656400.890-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> I've created a class device attribute file for the hosts supported by the
> usb-storage driver, using the shost_attrs member of the host template.  
> It seems to contain an intractable race condition when unregistering the
> host.  There's no way for the driver to know when the scsi host's class
> device is released, so there's no way to know when it's safe to deallocate
> the host's driver-specific data structure.  Waiting until
> scsi_remove_host() returns isn't good enough, because a user process might
> keep the attribute file open and thus prevent release of the class device
> indefinitely.
> 
> What's the right way to solve this problem?  It seems to me that it must 
> involve creating a kobject in the driver-specific host data structure, on 
> which the class device's release() routine could do a kobject_put().  That 
> way the driver would be able to tell when it should free the data 
> structure.  But code to handle this would have to be added to the scsi 
> core.
> 
> Alan Stern
> 

The free of this data has to happen on some release function. How are
you allocating the data / class_device_attribute structure? If the
allocation came from the scsi_host_alloc extra bytes the data will not
be free'd until scsi_host_dev_release().

-andmike
--
Michael Anderson
andmike@us.ibm.com

