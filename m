From: Alan Stern <stern@rowland.harvard.edu>
Subject: Host drivers and conversion of SCSI to the driver model
Date: Fri, 20 Jun 2003 16:05:02 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0306201555350.688-100000@ida.rowland.org>
References: <20030619213109.GB5644@kroah.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:8964 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264540AbTFTTvA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 15:51:00 -0400
In-Reply-To: <20030619213109.GB5644@kroah.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 19 Jun 2003, Greg KH wrote:

> I think it's more of the matter that Mike is still changing the way the
> SCSI core works with the class and driver model.  I suggest you take
> this to the linux-scsi list to hash out the way scsi should and does
> work in order to find the best solution for usb-storage, as I guess that
> it also would be the best solution for all other SCSI host drivers.

Mike:

What does the future for this progression look like?  Will there be some
standard place under /sys/class/scsi??? where a host driver like
usb-storage can register its class device?

And while I'm at it, let me remind you that the class_dev element of
struct Scsi_Host needs to have a release() method.  Probably the easiest 
way to make it work right is to do a "get_device(&shost->gendev)" when 
shost->class_dev is registered and have the release routine do 
"put_device(&shost->gendev)".

Alan Stern

