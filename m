From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: aacraid driver question
Date: Mon, 25 Aug 2003 20:21:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825202139.A10609@infradead.org>
References: <0998F43EAD645A47B3F6507196DD70EA2568C6@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:17156 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262095AbTHYTVm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 15:21:42 -0400
Content-Disposition: inline
In-Reply-To: <0998F43EAD645A47B3F6507196DD70EA2568C6@OTCEXC01>; from mark_salyzyn@adaptec.com on Mon, Aug 25, 2003 at 02:58:01PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, 'Mark Haverkamp' <markh@osdl.org>, linux-scsi@vger.kernel.org

On Mon, Aug 25, 2003 at 02:58:01PM -0400, Salyzyn, Mark wrote:
> It may have been a fools overture for me to do the one driver for all
> kernels, but my build system for providing test and release products is
> currently not geared to multiple sources and this worked for me. So far not
> a problem since we are only releasing to Distribution Kernels ...

Well, if Adaptec doesn't care for mainline we'll better mark
Mark Haverkamp official maintainer.  He does a very good job at keeping
the driver uptodate and clean - something that can't be said for
other drivers for adaptec hardware...

> Setting removable true is to force the SCSI subsystem to re-read the
> capacity and partition table on every fresh open since it may have changed
> through an array morph. We used to present the arrays as removable DASD's,
> and recently changed that to present them as Fixed DASD's, to deal with many
> gripes, and setting the removable bit instead when a change occurred.

Well, that's exactly what scsi_rescan_device is for.  Mark (H.), could you
try to use it in your 2.6 driver instead?

> A scsi_rescan_device cool, but we have arrays coming, and arrays going. When
> an array goes, I was supposed to mark it offline, the rescan I do right now
> actually hurts under *very* heavy load and takes some time to report the
> deleted array (we managed to stall the report for almost half an hour under
> load, but new devices came online almost instantly). So if I was to make a
> wish list, I would like to make the driver code more robust and also have an
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

