From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid driver question
Date: Mon, 25 Aug 2003 15:56:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0998F43EAD645A47B3F6507196DD70EA2568CD@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:26831 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S262278AbTHYT4g
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 15:56:36 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Mark Haverkamp' <markh@osdl.org>, linux-scsi@vger.kernel.org

Not sure if there is public documentation, heck just finding out about
AifDenMorphComplete internally required me to look at Firmware Code ...

AifDenMorphComplete is issued after a Morph (ie, adding new driver to an
existing array to expand it's capacity) has completed. Capacity reduction is
not typically a side effect, but redundancy can change (RAID-5 to RAID-0).

A Zero of an array has the side effect of also clearing out the first block
of the array, and thus the partition table. The management applications make
this function available, and we must live with it's consequences.

Ok, looks like you've up'd my priority on finding out how to differentiate
online/offline/clear; sadly AifEnContainerChange was a `catchall' for most
changes to an array of all sorts. Even more sad is that there are no details
contained within the FIB and I am otherwise quite nervous issuing commands
to the adapter to probe the cause. Yes, this makes a case for a user,
instead of a kernel, daemon to perform this task. I will find a way.

I will pow-wow with the Firmware engineers and see what they have to say
about this. I expect the workaround will not go easy, but will keep Mark
Haverkamp apprised.

Are we truly painted in a corner here? The `proc_write' call to the classic
kernels I did had the side effects of bringing online/offline/changed device
status up to date; albeit, we had a performance issue when devices went
offline. A compromise is that offline `will just happen' when someone tries
to communicate to the ID of the device. What will scsi_add_device do to us
if the device was there and is no longer accessible? Could we make the pair
of calls (scsi_add_device + scsi_rescan_device) in the interim?

Thanks -- Mark Salyzyn

-----Original Message-----
From: 'Christoph Hellwig' [mailto:hch@infradead.org]
Sent: Monday, August 25, 2003 3:41 PM
To: Salyzyn, Mark
Cc: 'Mark Haverkamp'; linux-scsi@vger.kernel.org
Subject: Re: aacraid driver question


On Mon, Aug 25, 2003 at 03:32:32PM -0400, Salyzyn, Mark wrote:
> Your assessment at the bottom is mainly correct, the AifEnContainerChange
> can mean more than just online/offline, it also include when an array has
> completed a clear operation so that the partition table needs to be reread
> (and thus updated). I have yet to work out the mechanism to detect the
> difference of online/offline/clear to mitigate the calls. I would expect
> that scsi_rescan_device will work in the interim?

No, scsi_rescan_device won't work of bringing a new device online or
an old one offline.  It's just when attributes on an existing device
change.  So to get this sorted out nicely we'd really need to know
whether AifEnContainerChange means online/offline/clear.  BTW, why/how
does the hardware interact with partitioning on aacraid?

And what's the exact meaning of AifDenMorphComplete?  Is there some
hardware documentation on adaptec's website?

