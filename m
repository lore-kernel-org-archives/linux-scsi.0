From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Host drivers and conversion of SCSI to the driver model
Date: Fri, 20 Jun 2003 14:07:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030620210725.GB18449@beaverton.ibm.com>
References: <20030619213109.GB5644@kroah.com> <Pine.LNX.4.44L0.0306201555350.688-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:35463 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S264655AbTFTUuz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 16:50:55 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0306201555350.688-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern [stern@rowland.harvard.edu] wrote:
> On Thu, 19 Jun 2003, Greg KH wrote:
> 
> > I think it's more of the matter that Mike is still changing the way the
> > SCSI core works with the class and driver model.  I suggest you take
> > this to the linux-scsi list to hash out the way scsi should and does
> > work in order to find the best solution for usb-storage, as I guess that
> > it also would be the best solution for all other SCSI host drivers.
> 
> Mike:
> 
> What does the future for this progression look like?  Will there be some
> standard place under /sys/class/scsi??? where a host driver like
> usb-storage can register its class device?

Did you need your own class device or can you use the shost_attrs
capability that James added?

> 
> And while I'm at it, let me remind you that the class_dev element of
> struct Scsi_Host needs to have a release() method.  Probably the easiest 
> way to make it work right is to do a "get_device(&shost->gendev)" when 
> shost->class_dev is registered and have the release routine do 
> "put_device(&shost->gendev)".
> 

Yes I will add a class release function and the order you
describe sounds the easiest to make it work.

-andmike
--
Michael Anderson
andmike@us.ibm.com

