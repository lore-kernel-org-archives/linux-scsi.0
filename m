From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Fix reference counting for failed SCSI devices
Date: Wed, 25 May 2005 07:27:23 -0500
Message-ID: <1117024043.5071.6.camel@mulgrave>
References: <4292F631.9090300@suse.de> <1116975478.7710.28.camel@mulgrave>
	 <4294201D.4070304@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:55271 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262321AbVEYM11 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 08:27:27 -0400
In-Reply-To: <4294201D.4070304@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, 2005-05-25 at 08:50 +0200, Hannes Reinecke wrote:
> >>+	class_device_put(&sdev->sdev_classdev);
> > 
> > This is unnecessary since the class device is simply occupying a private
> > area in the scsi_device.  As long as its never made visible to the
> > system, its refcount is irrelevant
> > 
> It's not. Whenever you try to rmmod the adapter it becomes highly
> relevant. If it doesn't crash you've at least generated a memleak as the
> class device is never freed.
> (And these are quite a few for Wide-SCSI Double-channel adapters ...)

?  Look at the code; you're not doing a put on a pointer to the
sdev_classdev, you're doing a put on a reference to it.

It's defined in scsi_device.h:

struct scsi_device {
	...
	struct class_device sdev_classdev;
	...
};

so it's contained within the scsi_device.  Freeing the scsi_device frees
the classdev (and the gendev).

James


