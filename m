From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 0/4] Updated AN patches, now without gendisk
Date: Mon, 13 Aug 2007 09:26:43 -0700
Message-ID: <20070813092643.6f15aa8a.kristen.c.accardi@intel.com>
References: <20070808120739.c3097d19.kristen.c.accardi@intel.com>
	<3ae72650708110700x7ddf3d57ue9a8875761425f52@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55744 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031551AbXHMQ3p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 12:29:45 -0400
In-Reply-To: <3ae72650708110700x7ddf3d57ue9a8875761425f52@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: jeff@garzik.org, James.Bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, David Zeuthen <david@fubar.dk>

On Sat, 11 Aug 2007 16:00:53 +0200
"Kay Sievers" <kay.sievers@vrfy.org> wrote:

> On 8/8/07, Kristen Carlson Accardi <kristen.c.accardi@intel.com> wrote:
> > Here is an updated set of patches that implement Asynchronous Notification
> > support for ATAPI devices.  In this version I no longer export the AN
> > capability through genhd, and the uevent is sent by the scsi_device
> > instead of gendisk.  I added a generic SCSI device event mechanism so
> > that it can be expanded in the future with other types of events.  Please
> > let me know what you think.
> 
> Does that mean:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8ce7ad7b2d11fae2c3d285a6a0caea9322c0b8fc
> 
> will go away?

Yes - this method was rejected by James, so I had to change away from
using the genhd to transmit events.

> 
> Then we will need to come up with an idea to propagate that to the
> blockdev, it gets a bit nasty for userspace to find out which
> blockdevice it should update. It's certainly possible, but just not as
> easy as it is now, because userspace just doesn't really care in most
> cases what kind of bus device a block device is coming from.

Is it possible to use the linkage that is in the scsi_device directory
of the disk that is sending the event to find the relevant block devices?
For example, /sys/class/scsi_device/0:0:0:0/device/block:sda
on my system tells me which block devices belong to this device.
