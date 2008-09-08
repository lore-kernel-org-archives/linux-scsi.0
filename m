From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/6] detect online disk resize
Date: Mon, 08 Sep 2008 14:01:14 -0400
Message-ID: <x49prnett3p.fsf@segfault.boston.devel.redhat.com>
References: <20080829231254.25065.66052.stgit@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41375 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbYIHSIN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2008 14:08:13 -0400
In-Reply-To: <20080829231254.25065.66052.stgit@bluto.andrew> (Andrew
	Patterson's message of "Fri, 29 Aug 2008 17:12:54 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com

Andrew Patterson <andrew.patterson@hp.com> writes:

> This is version 2 of a patch series I submitted back in May 2008. This
> version now checks for device size changes in the rescan_partitions()
> routine.  Which in turn is called when a device is opened and in the
> BLKRRPART ioctl.
>
> I am resubmitting this patch series as I got little response the
> previous time.  Al Viro has told me offline that he would look at it this
> time.

[...]

> I have tested this patch on SCSI and SmartArray (cciss)
> devices. Device mapper still does not recognize device size changes
> until the device is restarted.
>
> Jeff Moyer and Andy Ryan have done some light testing on the previous
> version of this series.

I re-tested this new patch series using an iSCSI target via the
following steps:

1) Connect to iSCSI storage, creating the /dev/sd* devices.
2) Create a file system on the block device
3) Mount the file system, and leave a shell active on the mount point.
4) resize the iSCSI LUN
5) rescan the iSCSI session
6) resize the file system

This procedure worked fine.

Cheers,

Jeff
