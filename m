From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: aacraid driver question
Date: Mon, 25 Aug 2003 21:08:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825210836.A11567@infradead.org>
References: <0998F43EAD645A47B3F6507196DD70EA2568CD@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:28677 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262091AbTHYUIj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 16:08:39 -0400
Content-Disposition: inline
In-Reply-To: <0998F43EAD645A47B3F6507196DD70EA2568CD@OTCEXC01>; from mark_salyzyn@adaptec.com on Mon, Aug 25, 2003 at 03:56:27PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, 'Mark Haverkamp' <markh@osdl.org>, linux-scsi@vger.kernel.org

On Mon, Aug 25, 2003 at 03:56:27PM -0400, Salyzyn, Mark wrote:
> AifDenMorphComplete is issued after a Morph (ie, adding new driver to an
> existing array to expand it's capacity) has completed. Capacity reduction is
> not typically a side effect, but redundancy can change (RAID-5 to RAID-0).

You managed to get me really confused :)

So AifDenMorphComplete and AifDenVolumeExtendComplete are the same from
the drivers perspective?

Anyway, for those two scsi_rescan_device is thw way to go.  I'll
export it in 2.6.

> A Zero of an array has the side effect of also clearing out the first block
> of the array, and thus the partition table. The management applications make
> this function available, and we must live with it's consequences.

Okay...

> Ok, looks like you've up'd my priority on finding out how to differentiate
> online/offline/clear; sadly AifEnContainerChange was a `catchall' for most
> changes to an array of all sorts. Even more sad is that there are no details
> contained within the FIB and I am otherwise quite nervous issuing commands
> to the adapter to probe the cause. Yes, this makes a case for a user,
> instead of a kernel, daemon to perform this task. I will find a way.

Yikes!

> Are we truly painted in a corner here? The `proc_write' call to the classic
> kernels I did had the side effects of bringing online/offline/changed device
> status up to date; albeit, we had a performance issue when devices went
> offline. A compromise is that offline `will just happen' when someone tries
> to communicate to the ID of the device. What will scsi_add_device do to us
> if the device was there and is no longer accessible? Could we make the pair
> of calls (scsi_add_device + scsi_rescan_device) in the interim?

Well, we could keep the semantics without the proc_write mess by
exporting scsi_scan_host_selected as Mark H. did in the patch that
triggered this thread, but I'd be very unhappy to do that.  We have
the exported scsi_add_device and scsi_remove_device functions to
add/remove a selected lun and if possible at all I'd prefer to use those.

scsi_add_device will return an error it it's not actually present,
but we don't have a way to remove an existing volume going that route
unless we find out whether we really meant offlining it.

