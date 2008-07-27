From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC 03/14] osd_uld: OSD scsi ULD
Date: Sun, 27 Jul 2008 17:16:15 -0400
Message-ID: <1217193375.3503.31.camel@localhost.localdomain>
References: <48876009.8010701@panasas.com> <4888BC3B.1050406@panasas.com>
	 <4888C023.7070105@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38591 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758433AbYG0WkO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jul 2008 18:40:14 -0400
In-Reply-To: <4888C023.7070105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@panasas.com>, Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>

On Thu, 2008-07-24 at 20:47 +0300, Boaz Harrosh wrote:
> Add a Linux driver module that registers as a SCSI ULD and probes for OSD type
> SCSI devices.
> 
> When an OSD-type SCSI device is found a character device is created in the form
> of /dev/osdX - where X goes from 0 up to hard coded 64.
> The Major character device number used is *232*, which is free (as of Linux
> v2.6.27). The same Major was used by the old IBM initiator project.
> 
> TODO: How to dynamically allocate a Major and have a /dev/osdX entry linked
> to it? Do I need/should reserve the minor range in advance, if not how?
> 
> A single ioctl is currently supported that will invoke an in-kernel test on
> the specified OSD device (lun).

The first thing that immediately leaps to mind is are you sure this
should be a character device?  Since it's only open/close/ioctl (as in
no read/write) you could then use all the file bdev handling to get back
to struct osd_device, plus you can bind to bsg (and SG_IO) which is
unaccountably missing in this prototype.

The second observation is that refcounting in this driver is
non-existent.  Doing a kfree(osd_dev) from osd_remove makes open device
remove module do something else look to be a certain oops ... you can
use the refcounting models of sd or st to see how this is done.

There's a convention that gendisk->private_data points to a pointer to
the driver.  This was originally a viro clever trick to allow the
private_data to store both the driver and the uld device (struct
osd_dev).  I think we've dispensed with needing the driver, so perhaps
this trick is unnecessary, but you'll need something similar to do
refcounting properly.

Since OSDs are currently potentially removable spinning media with
caches, it looks like you potentially also need locking control.  You
might also need a shutdown method to cope with object flushing before
power down.

Somehow the capacity has to be plumbed in (this also really makes them
block devices not character devices).  It looks like the total capacity
attribute of the root information attributes page would be appropriate
for this.

The ioctl flow needs to be plumbed into scsi_ioctl() since the gendisk
ULD will need to handle all the standard SCSI ioctls.

You can't have 232 char as the major for this ... it's already assigned
to biometric devices (although I think 232 block is free).  Whatever
number you choose has to be requested through lanana and
Documentation/device-list.txt updated accordingly.

(as you noted, TYPE_OSD has to be correctly in the global headers)

Please don't use sysfs_create_file (it can be racy and accident prone);
just do the extra files as declared attributes of the osd class and let
drivers/base handle all the setup/teardown  (sd is a good template).

James


