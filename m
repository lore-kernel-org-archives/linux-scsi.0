From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [Patch 1/2] cciss: fix for 2TB support
Date: Thu, 22 Feb 2007 10:51:23 -0600
Message-ID: <20070222165123.GC2672@beardog.cca.cpqcorp.net>
References: <20070221211039.GA2672@beardog.cca.cpqcorp.net> <20070221191427.9b7cf4b0.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel10.hp.com ([156.153.255.245]:38822 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbXBVQv0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Feb 2007 11:51:26 -0500
Content-Disposition: inline
In-Reply-To: <20070221191427.9b7cf4b0.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mike.miller@hp.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com

On Wed, Feb 21, 2007 at 07:14:27PM -0800, Andrew Morton wrote:
> On Wed, 21 Feb 2007 15:10:39 -0600 "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> 
> > Patch 1/2
> > 
> > This patch changes the way we determine if a logical volume is larger than 2TB. The
> > original test looked for a total_size of 0. Originally we added 1 to the total_size.
> > That would make our read_capacity return size 0 for >2TB lv's. We assumed that we
> > could not have a lv size of 0 so it seemed OK until we were in a clustered system. The
> > backup node would see a size of 0 due to the reservation on the drive. That caused
> > the driver to switch to 16-byte CDB's which are not supported on older controllers.
> > After that everything was broken.
> > It may seem petty but I don't see the value in trying to determine if the LBA is
> > beyond the 2TB boundary. That's why when we switch we use 16-byte CDB's for all
> > read/write operations.
> > Please consider this for inclusion.
> > 
> > ...
> >
> > +  	if (total_size == 0xFFFFFFFF) {
> 
> I seem to remember having already questioned this.  total_size is sector_t, which
> can be either 32-bit or 64-bit.  Are you sure that comparison works as
> intended in both cases?
> 
> 
> > +		if(total_size == 0xFFFFFFFF) {
> >  			cciss_read_capacity_16(cntl_num, i, 0,
> >  			&total_size, &block_size);
> >  			hba[cntl_num]->cciss_read = CCISS_READ_16;
> 
> Here too.
It has worked in all of the configs I've tested. Should I change it from sector_t to a
__64? I have not tested all possible configs.

-- mikem
