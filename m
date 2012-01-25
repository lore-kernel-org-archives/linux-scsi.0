From: Steven Whitehouse <swhiteho@redhat.com>
Subject: RE: [Lsf-pc] [dm-devel]  [LSF/MM TOPIC] a few storage topics
Date: Wed, 25 Jan 2012 16:40:23 +0000
Message-ID: <1327509623.2720.52.camel@menhir>
References: <20120124151504.GQ4387@shiny>
	 <20120124165631.GA8941@infradead.org>
	 <186EA560-1720-4975-AC2F-8C72C4A777A9@dilger.ca>
	 <x49fwf5kmbl.fsf@segfault.boston.devel.redhat.com>
	 <20120124184054.GA23227@infradead.org> <20120124190732.GH4387@shiny>
	 <x49vco0kj5l.fsf@segfault.boston.devel.redhat.com>
	 <20120124200932.GB20650@quack.suse.cz>
	 <x49pqe8kgej.fsf@segfault.boston.devel.redhat.com>
	 <20120124203936.GC20650@quack.suse.cz> <20120125032932.GA7150@localhost>
	 <F6F2DEB8-F096-4A3B-89E3-3A132033BC76@dilger.ca>
	 <1327502034.2720.23.camel@menhir>
	 <D3F292ADF945FB49B35E96C94C2061B915A638A6@nsmail.netscout.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562Ab2AYQkY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2012 11:40:24 -0500
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B915A638A6@nsmail.netscout.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Wu Fengguang <fengguang.wu@gmail.com>, Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, neilb@suse.de, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Boaz Harrosh <bharrosh@panasas.com>, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, Chris Mason <chris.mason@oracle.com>, "Darrick J.Wong" <djwong@us.ibm.com>

Hi,

On Wed, 2012-01-25 at 11:22 -0500, Loke, Chetan wrote:
> > If the reason for not setting a larger readahead value is just that it
> > might increase memory pressure and thus decrease performance, is it
> > possible to use a suitable metric from the VM in order to set the value
> > automatically according to circumstances?
> > 
> 
> How about tracking heuristics for 'read-hits from previous read-aheads'? If the hits are in acceptable range(user-configurable knob?) then keep seeking else back-off a little on the read-ahead?
> 
> > Steve.
> 
> Chetan Loke

I'd been wondering about something similar to that. The basic scheme
would be:

 - Set a page flag when readahead is performed
 - Clear the flag when the page is read (or on page fault for mmap)
(i.e. when it is first used after readahead)

Then when the VM scans for pages to eject from cache, check the flag and
keep an exponential average (probably on a per-cpu basis) of the rate at
which such flagged pages are ejected. That number can then be used to
reduce the max readahead value.

The questions are whether this would provide a fast enough reduction in
readahead size to avoid problems? and whether the extra complication is
worth it compared with using an overall metric for memory pressure?

There may well be better solutions though,

Steve.


