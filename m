From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: cciss update [2/2] fixes for Steeleye Lifekeeper
Date: 14 Oct 2004 09:37:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097764660.2198.11.camel@mulgrave>
References: <20041013212253.GB9866@beardog.cca.cpqcorp.net>
	<20041014083900.GB7747@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:45712 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265331AbUJNOiF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2004 10:38:05 -0400
In-Reply-To: <20041014083900.GB7747@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: mikem@beardog.cca.cpqcorp.net, Andrew Morton <akpm@osdl.org>, Jens Axboe <axboe@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-10-14 at 03:39, Christoph Hellwig wrote:
> No, this is bogus.  Never call add_disk on a volume that hasn't been
> configured and full set up.  If you need to talk to our driver without
> online volumes add a character device.

I don't think so ... it's a volume you know exists but you can't get
access to (in a shared storage configuration).  In SCSI we have two
examples of this now:

1. The case where the device responds to inquiry but errors read
capacity (usually because of a reservation conflict).  Here we configure
a totally bogus 1GB volume with 512 byte sectors.

2. The case where the device has an illegal sector size.  Here we
configure a zero size volume.

In both cases we expose the device in sd but make it effectively
inaccessible because we want to be able to send ioctls to it but not
allow ordinary read/writes.  (Although I'd really like not to configure
a bogus size in case 1.).  I don't see how the cciss case is any
different from this.

James


