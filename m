From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 1/2] cciss: fix for 2TB support
Date: Thu, 22 Feb 2007 13:24:34 -0800
Message-ID: <20070222132434.d84d3248.akpm@linux-foundation.org>
References: <20070221211039.GA2672@beardog.cca.cpqcorp.net>
	<20070221191427.9b7cf4b0.akpm@linux-foundation.org>
	<20070222165123.GC2672@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39593 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbXBVV2F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Feb 2007 16:28:05 -0500
In-Reply-To: <20070222165123.GC2672@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: mike.miller@hp.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com

> On Thu, 22 Feb 2007 10:51:23 -0600 "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> On Wed, Feb 21, 2007 at 07:14:27PM -0800, Andrew Morton wrote:
> > On Wed, 21 Feb 2007 15:10:39 -0600 "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> > 
> > > Patch 1/2
> > > +  	if (total_size == 0xFFFFFFFF) {
> > 
> > I seem to remember having already questioned this.  total_size is sector_t, which
> > can be either 32-bit or 64-bit.  Are you sure that comparison works as
> > intended in both cases?
> > 
> > 
> > > +		if(total_size == 0xFFFFFFFF) {
> > >  			cciss_read_capacity_16(cntl_num, i, 0,
> > >  			&total_size, &block_size);
> > >  			hba[cntl_num]->cciss_read = CCISS_READ_16;
> > 
> > Here too.
> It has worked in all of the configs I've tested. Should I change it from sector_t to a
> __64? I have not tested all possible configs.
> 

I'd suggest using -1: that just works.
