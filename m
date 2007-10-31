From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices (fwd)
Date: Wed, 31 Oct 2007 10:15:01 -0500
Message-ID: <1193843701.3411.20.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0710291434370.11432-100000@iolanthe.rowland.org>
	 <1193685197.2321.9.camel@lov.site> <20071031042531.GB16426@kroah.com>
	 <1193827590.2423.42.camel@lov.site>  <20071031143255.GC7076@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55101 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754010AbXJaPPD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 11:15:03 -0400
In-Reply-To: <20071031143255.GC7076@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2007-10-31 at 07:32 -0700, Greg KH wrote:
> Hm, I seem to have missed the part in this thread where someone said
> that it was valid to have a parent reference a child device.  That's
> just wrong and needs to be fixed.  Is that in the scsi layer somewhere?
> The block layer?  It sure isn't in the driver core...

This is the piece I'm still not clear on.  It's something to do with the
gendisk.  I'd have to look in block, but I believe the queue takes a ref
to the gendisk.

The scsi_device has a ref to the queue and the scsi_disk (in sd) has a
ref to both the scsi_device and the gendisk.  That means, until sd is
unbound and the scsi_disk released, there's an implied unbreakable
reference chain.

at least, I think that's what the problem is.

James


