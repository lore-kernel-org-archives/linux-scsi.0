From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: aacraid driver question
Date: Mon, 25 Aug 2003 19:42:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825194201.A10023@infradead.org>
References: <0998F43EAD645A47B3F6507196DD70EA2568C2@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:52754 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262122AbTHYSmE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 14:42:04 -0400
Content-Disposition: inline
In-Reply-To: <0998F43EAD645A47B3F6507196DD70EA2568C2@OTCEXC01>; from mark_salyzyn@adaptec.com on Mon, Aug 25, 2003 at 02:24:30PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: 'Mark Haverkamp' <markh@osdl.org>, linux-scsi@vger.kernel.org

[adding linux-scsi to the Cc-list - it's becoming more a generic scsi issue]


On Mon, Aug 25, 2003 at 02:24:30PM -0400, Salyzyn, Mark wrote:
> Not having the procfs is no issue, the driver will then not have Plug and
> Play; I certainly need to add the ifdef for the CONFIG option though. I had
> requested in the past having the scan_scsis made available to driver modules
> (back in the dpt_i2o driver days), but the only workaround was to access the
> public procfs.

Well, we can export scan_host_selected as in Mark Haverkamp 2.6 patch, but
I need to undesrtand those issues first and we need to fix the locking
in that area.  Even better move large parts into a helper in the scsi
core.

That's not going to mix with the one driver for all kernels crap, though.

> I am certainly interested in how we can improve the locking, what do you
> have in mind? This operation is carried out in a separate kernel thread and
> not in an interrupt or command context, I may have been naive in my
> expectations though. However, experimentally this has been working fine
> (high speed SMP systems should have turned up some difficulties, but even
> heavily loaded found no problems in the 2.4.* streams), but I am not always
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
> Mark Haverkamp makes so that I may merge them into my code base for release.

Well, he's posting to linux-scsi - a list a driver maintainer probably
should be subscribed to..

