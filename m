From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid driver question
Date: Mon, 25 Aug 2003 16:50:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0998F43EAD645A47B3F6507196DD70EA2568D0@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:62119 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S262201AbTHYUuf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 16:50:35 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Mark Haverkamp' <markh@osdl.org>, linux-scsi@vger.kernel.org

A Volume is a sequential addition of drives, not like a striped array where
the new capacity is distributed rather than added to the end. Yes, from the
driver perspective, they are the same ...

Hope this following helps the Yikes a bit (!)

Container deletions have a Container Delete AIF, and a container change AIF.
The array goes offline and is no longer accessible. We could monitor the
Container Delete AIF event to trigger a scsi_remove_device for this. The
container change AIF could be used to call *something* with a null effect.

Creating an array has a Container Add AIF and a container change AIF. This
is a totally new array. We could monitor the Container Add AIF event to
trigger a scsi_add_device for this. The container change AIF could be used
to call *something* with a null effect.

Now I get `sticky' ...

Upon completion of a zero, we get just a container change AIF. But the array
had gone offline when the Zero started, no events, except periodic generic
percentage progress report AIFs, any I/O to the ID could return offline
errors while clearing. We want the container change AIF to get the SCSI
subsystem to re-activate this array. The ID did not really go away, it is
just write protected while zeroing. We may be able to report the I/O error
differently so that the SCSI subsystem does not take it permanently offline,
just temporarily inactive? If we altered the error report so that the device
information remained, could a triggered scsi_rescan_device be used to import
the zero'd partition table and have the side effect of bringing the device
active again? Would this have the null effect desired above?

The above issue was not a problem under Windoze, for instance, because the
SCSI Port would not take a device that reported offline status to requests
permanently offline. Simply running the Disk Administrator would rediscover
the array once the zero had completed. No event monitoring to speak of.

Yes, I will look into further refinements and details, the Windoze driver is
currently being refined to reduce the `event noise' so that the new Store
Port driver does not have a fit. The results of that study should help us
here.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: 'Christoph Hellwig' [mailto:hch@infradead.org]
Sent: Monday, August 25, 2003 4:09 PM
To: Salyzyn, Mark
Cc: 'Christoph Hellwig'; 'Mark Haverkamp'; linux-scsi@vger.kernel.org
Subject: Re: aacraid driver question


On Mon, Aug 25, 2003 at 03:56:27PM -0400, Salyzyn, Mark wrote:
> AifDenMorphComplete is issued after a Morph (ie, adding new driver to an
> existing array to expand it's capacity) has completed. Capacity reduction
is
> not typically a side effect, but redundancy can change (RAID-5 to RAID-0).

You managed to get me really confused :)

So AifDenMorphComplete and AifDenVolumeExtendComplete are the same from
the drivers perspective?

Anyway, for those two scsi_rescan_device is thw way to go.  I'll
export it in 2.6.

> A Zero of an array has the side effect of also clearing out the first
block
> of the array, and thus the partition table. The management applications
make
> this function available, and we must live with it's consequences.

Okay...

> Ok, looks like you've up'd my priority on finding out how to differentiate
> online/offline/clear; sadly AifEnContainerChange was a `catchall' for most
> changes to an array of all sorts. Even more sad is that there are no
details
> contained within the FIB and I am otherwise quite nervous issuing commands
> to the adapter to probe the cause. Yes, this makes a case for a user,
> instead of a kernel, daemon to perform this task. I will find a way.

Yikes!

> Are we truly painted in a corner here? The `proc_write' call to the
classic
> kernels I did had the side effects of bringing online/offline/changed
device
> status up to date; albeit, we had a performance issue when devices went
> offline. A compromise is that offline `will just happen' when someone
tries
> to communicate to the ID of the device. What will scsi_add_device do to us
> if the device was there and is no longer accessible? Could we make the
pair
> of calls (scsi_add_device + scsi_rescan_device) in the interim?

Well, we could keep the semantics without the proc_write mess by
exporting scsi_scan_host_selected as Mark H. did in the patch that
triggered this thread, but I'd be very unhappy to do that.  We have
the exported scsi_add_device and scsi_remove_device functions to
add/remove a selected lun and if possible at all I'd prefer to use those.

scsi_add_device will return an error it it's not actually present,
but we don't have a way to remove an existing volume going that route
unless we find out whether we really meant offlining it.

