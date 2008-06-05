From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Thu, 05 Jun 2008 00:27:54 -0600
Message-ID: <20080605062754.GQ2961@webber.adilger.int>
References: <patchbomb.1212643369@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:50089 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbYFEG15 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 02:27:57 -0400
In-reply-to: <patchbomb.1212643369@sermon.lab.mkp.net>
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Jun 05, 2008  01:22 -0400, Martin K. Petersen wrote:
> This is just a proof of concept set of patches.  I'd like some
> feedback before I spend more time on them.
> 
> At the Filesystem & Storage Workshop there was lots of discussion
> about how to communicate I/O alignment, stripe width, etc. to the
> filesystems so they could lay out things properly.

Thanks for looking into this Martin.  We could use this pretty
immediately in ext4 for helping the block allocator make good
decisions.

> An addition to the up-and-coming version of the SCSI block protocol
> features an inquiry page that hardware RAIDs can use to indicate
> preferred I/O sizes for a given LUN.
> 
> This patch kit implements support for exporting those values in
> /sys/block/.  I have implemented support for it in sd.c using the
> Block Limits VPD and in MD using chunk size and stripe width.
> 
> The physical sector offset for the start of the "virtual" block device
> is also exported.  This includes partitions so you can get the actual
> physical start sector offset for - say - an MD device sitting on a
> partitioned set of drives.

The kernel part of the code seems pretty reasonable (nicely stackable,
as your MD examples show) and useful for filesystems.  Having this
information available in the kernel removes much of the need to find
this information in userspace, but unfortunately not all of it (e.g.
some mkfs-time layout decisions need to be done before the filesystem
is mounted, even if the allocator can use the kernel-supplied hits).

To be honest, however, having the information exported only via sysfs
is a bit ugly IMHO.  I've had all sorts of grief with settings there
because there isn't always a match between the device that is being
specified by the user and what appears in sysfs (e.g. /dev/disk/by-id/foo
doesn't match /sys/block/sda) and hoops have to be jumped through to
find this mapping, before parsing a text value in C.

Having an ioctl() that can be called on the block device (getting
the right device regardless of its name) seems a lot more useful to
applications in my experience, unless you are using a script.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

