From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi_forget_host() and scsi_remove_device()
Date: Sun, 6 Jul 2003 17:13:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030706171347.C5690@infradead.org>
References: <20030627110259.A3751@infradead.org> <Pine.LNX.4.44L0.0307031650370.779-100000@ida.rowland.org> <20030703221940.GA5983@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.mvhi.com ([195.224.96.167]:31492 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262445AbTGFP7Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Jul 2003 11:59:16 -0400
Content-Disposition: inline
In-Reply-To: <20030703221940.GA5983@beaverton.ibm.com>; from andmike@us.ibm.com on Thu, Jul 03, 2003 at 03:19:40PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Jul 03, 2003 at 03:19:40PM -0700, Mike Anderson wrote:
> Yes, this is an issue. I became more of issue one we started using the
> LDM driver probe / remove functions.
> 
> I am still cleaning up a patch set for hosts and devices so it is not
> quite ready for review yet (I got pulled off on to some other issues for
> a few days).
> 
> For scsi devices here is a quick snap shot of what I trying to test.
> 	scsi_device_register:
> 		calls device_initialize on sdev_driverfs_dev
> 		calls class_device_initialize on sdev_classdev
> 		calls device_add on sdev_driverfs_dev
> 		calls class_device_add on sdev_classdev
> 		calls get_device on sdev_driverfs_dev
> 
> 	scsi_device_unregister:
> 		sets a state the scsi_device indicating "delete"
> 		calls class_device_unregister on sdev_classdev
> 
> 	scsi_device_cls_release:
> 		calls put_device on sdev_driverfs_dev

Hmm, where calling the put_device in the class device release func?

To be honest I'm everything but happy with the class_device / device
double-refcounting but it looks we can work around core issues in
scsi :P

