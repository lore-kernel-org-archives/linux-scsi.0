From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi-misc-2.5 user per-device spare command
Date: 25 Apr 2003 12:57:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051289862.1756.34.camel@mulgrave>
References: <20030424100229.A32098@beaverton.ibm.com>
	<20030424100317.A32134@beaverton.ibm.com>
	<20030425111227.B28577@infradead.org>
	<20030425093718.A8776@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:48133 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263387AbTDYQqN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 12:46:13 -0400
In-Reply-To: <20030425093718.A8776@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2003-04-25 at 12:37, Patrick Mansfield wrote:
> Christoph -
> 
> On Fri, Apr 25, 2003 at 11:12:27AM +0100, Christoph Hellwig wrote:
> > On Thu, Apr 24, 2003 at 10:03:17AM -0700, Patrick Mansfield wrote:
> > > Patch against scsi-misc-2.5
> > > 
> > > Use a per-device spare command rather than a per-host spare.
> > 
> > Why?  This means we'll have a much bigger number of spare commands
> > around.
> 
> So we are guaranteed to be able to have at least one IO in flight for all
> devices. With a per-host spare, some device(s) might have to wait
> (generally polling based on an interval dependent on whatever blk_plug_device
> gives us) for a command to become available, and it is not clear what the
> IO behaviour - especially for swap - will be in such cases.

Yes, but we all agreed that we really only needed one guaranteed
commmand for the system to make forward progress.  It could be argued
that we only need one globally.  One per host seems a reasonable
compromise.

I don't really buy the in flight I/O argument because under normal
circumstances the slab allocation will cope correctly.  The slab
allocation only fails when we need to grow the slab *and* we're out of
readily available pages, so the system tips into paging mode anyway and
its throughput tanks.

Just the act of pre-allocating a single command means that we pin a slab
page and thus have at least a page full of commands to throw about even
in an out of memory situation.

James


