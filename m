From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid driver question
Date: Mon, 25 Aug 2003 14:58:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0998F43EAD645A47B3F6507196DD70EA2568C6@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:10961 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S262085AbTHYS6W
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 14:58:22 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Mark Haverkamp' <markh@osdl.org>, linux-scsi@vger.kernel.org

It may have been a fools overture for me to do the one driver for all
kernels, but my build system for providing test and release products is
currently not geared to multiple sources and this worked for me. So far not
a problem since we are only releasing to Distribution Kernels ...

Setting removable true is to force the SCSI subsystem to re-read the
capacity and partition table on every fresh open since it may have changed
through an array morph. We used to present the arrays as removable DASD's,
and recently changed that to present them as Fixed DASD's, to deal with many
gripes, and setting the removable bit instead when a change occurred.

A scsi_rescan_device cool, but we have arrays coming, and arrays going. When
an array goes, I was supposed to mark it offline, the rescan I do right now
actually hurts under *very* heavy load and takes some time to report the
deleted array (we managed to stall the report for almost half an hour under
load, but new devices came online almost instantly). So if I was to make a
wish list, I would like to make the driver code more robust and also have an
entry to something like scsi_device_offline (remove single).

I know I am supposed to be monitoring the linux scsi list ...

Sincerely -- Mark Salyzyn

-----Original Message-----
From: 'Christoph Hellwig' [mailto:hch@infradead.org]
Sent: Monday, August 25, 2003 2:42 PM
To: Salyzyn, Mark
Cc: 'Mark Haverkamp'; linux-scsi@vger.kernel.org
Subject: Re: aacraid driver question


[adding linux-scsi to the Cc-list - it's becoming more a generic scsi issue]


On Mon, Aug 25, 2003 at 02:24:30PM -0400, Salyzyn, Mark wrote:
> Not having the procfs is no issue, the driver will then not have Plug and
> Play; I certainly need to add the ifdef for the CONFIG option though. I
had
> requested in the past having the scan_scsis made available to driver
modules
> (back in the dpt_i2o driver days), but the only workaround was to access
the
> public procfs.

Well, we can export scan_host_selected as in Mark Haverkamp 2.6 patch, but
I need to undesrtand those issues first and we need to fix the locking
in that area.  Even better move large parts into a helper in the scsi
core.

That's not going to mix with the one driver for all kernels crap, though.

> I am certainly interested in how we can improve the locking, what do you
> have in mind? This operation is carried out in a separate kernel thread
and
> not in an interrupt or command context, I may have been naive in my
> expectations though. However, experimentally this has been working fine
> (high speed SMP systems should have turned up some difficulties, but even
> heavily loaded found no problems in the 2.4.* streams), but I am not
always
> convinced ...

Plain 2.4 isn't much of an issue because it's mostly serialized by
io_request_lock and there's no real hotplugging support.  2.6 has
very finegrained locking and fully supports hotplugging.

Locking issues in aac_handle_aif:

 - drivers won't be allowed to look at shost->my_devices anymore very
   soon, but there will be locked and refcounted accessorcs be provided.
 - don't check sdev->access_count for business - you can always mark a
   scsi_device offline in 2.5 and it will go away once the last reference
   goes away.  What's the point of setting .removable to true?

but all this isn't nice yet.  You want to change the representation of a
lun, right?  What do you need in addition to scsi_rescan_device() ?
 
> I would appreciate being kept apprised of any changes or improvements that
> Mark Haverkamp makes so that I may merge them into my code base for
release.

Well, he's posting to linux-scsi - a list a driver maintainer probably
should be subscribed to..

