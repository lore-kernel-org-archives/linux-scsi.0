From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid driver question
Date: Mon, 25 Aug 2003 15:32:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0998F43EAD645A47B3F6507196DD70EA2568CB@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:4255 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S262153AbTHYTdK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 15:33:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Mark Haverkamp' <markh@osdl.org>, linux-scsi@vger.kernel.org

Thems fighting words, Christoph ;-}

Adaptec Cares, it is a priority, as witnessed by the fact I *have* been
watching the 2.6.0 kernels with interest and merging those changes back into
our source trees. I have no problem working with Mark Haverkamp if that
smooths things out, threats to glory and title mean nothing.

Mark Haverkamp, once you have those changes, I would be pleased to push the
change into our test departments to bang around a bit. We have a few testers
that are interested in working with latest kernels.

Your assessment at the bottom is mainly correct, the AifEnContainerChange
can mean more than just online/offline, it also include when an array has
completed a clear operation so that the partition table needs to be reread
(and thus updated). I have yet to work out the mechanism to detect the
difference of online/offline/clear to mitigate the calls. I would expect
that scsi_rescan_device will work in the interim?

Sincerely -- Mark Salyzyn

-----Original Message-----
From: 'Christoph Hellwig' [mailto:hch@infradead.org]
Sent: Monday, August 25, 2003 3:22 PM
To: Salyzyn, Mark
Cc: 'Christoph Hellwig'; 'Mark Haverkamp'; linux-scsi@vger.kernel.org
Subject: Re: aacraid driver question


On Mon, Aug 25, 2003 at 02:58:01PM -0400, Salyzyn, Mark wrote:
> It may have been a fools overture for me to do the one driver for all
> kernels, but my build system for providing test and release products is
> currently not geared to multiple sources and this worked for me. So far
not
> a problem since we are only releasing to Distribution Kernels ...

Well, if Adaptec doesn't care for mainline we'll better mark
Mark Haverkamp official maintainer.  He does a very good job at keeping
the driver uptodate and clean - something that can't be said for
other drivers for adaptec hardware...

> Setting removable true is to force the SCSI subsystem to re-read the
> capacity and partition table on every fresh open since it may have changed
> through an array morph. We used to present the arrays as removable DASD's,
> and recently changed that to present them as Fixed DASD's, to deal with
many
> gripes, and setting the removable bit instead when a change occurred.

Well, that's exactly what scsi_rescan_device is for.  Mark (H.), could you
try to use it in your 2.6 driver instead?

> A scsi_rescan_device cool, but we have arrays coming, and arrays going.
When
> an array goes, I was supposed to mark it offline, the rescan I do right
now
> actually hurts under *very* heavy load and takes some time to report the
> deleted array (we managed to stall the report for almost half an hour
under
> load, but new devices came online almost instantly). So if I was to make a
> wish list, I would like to make the driver code more robust and also have
an
> entry to something like scsi_device_offline (remove single).

That would be scsi_set_device_offline.  So what are you doing exactly
in aac_handle_aif?  I'll guess now and you correct me, okay?

 - AifDenVolumeExtendComplete:  a lun has changed size
   In 2.6 we'd like to call scsi_rescan_device for this.
 - AifDenMorphComplete: some attribute change??
   If that's true scsi_rescan_device would be the way to go
   aswell.
 - AifEnContainerChange: a volume got added or deleted??
   If that's the case _and_ we know the channel, id, lun
   we can call scsi_add_device / scsi_remove_device

