From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [Lsf-pc] [dm-devel]  [LSF/MM TOPIC] a few storage topics
Date: Thu, 26 Jan 2012 11:25:56 -0500
Message-ID: <20120126162555.GF1891@redhat.com>
References: <x49fwf5kmbl.fsf@segfault.boston.devel.redhat.com>
 <20120124184054.GA23227@infradead.org>
 <20120124190732.GH4387@shiny>
 <x49vco0kj5l.fsf@segfault.boston.devel.redhat.com>
 <20120124200932.GB20650@quack.suse.cz>
 <x49pqe8kgej.fsf@segfault.boston.devel.redhat.com>
 <20120124203936.GC20650@quack.suse.cz>
 <20120125032932.GA7150@localhost>
 <F6F2DEB8-F096-4A3B-89E3-3A132033BC76@dilger.ca>
 <20120125063552.GA27375@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab2AZQ0o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2012 11:26:44 -0500
Content-Disposition: inline
In-Reply-To: <20120125063552.GA27375@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wu Fengguang <fengguang.wu@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, "neilb@suse.de" <neilb@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Chris Mason <chris.mason@oracle.com>, "Darrick J.Wong" <djwong@us.ibm.com>

On Wed, Jan 25, 2012 at 02:35:52PM +0800, Wu Fengguang wrote:
> On Tue, Jan 24, 2012 at 11:15:13PM -0700, Andreas Dilger wrote:
> > On 2012-01-24, at 8:29 PM, Wu Fengguang wrote:
> > > On Tue, Jan 24, 2012 at 09:39:36PM +0100, Jan Kara wrote:
> > >> On Tue 24-01-12 15:13:40, Jeff Moyer wrote:
> > >>>> Maybe 128 KB is a too small default these days but OTOH noone prevents you
> > >>>> from raising it (e.g. SLES uses 1 MB as a default).
> > >>> 
> > >>> For some reason, I thought it had been bumped to 512KB by default.  Must
> > >>> be that overactive imagination I have...  Anyway, if all of the distros
> > >>> start bumping the default, don't you think it's time to consider bumping
> > >>> it upstream, too?  I thought there was a lot of work put into not being
> > >>> too aggressive on readahead, so the downside of having a larger
> > >>> read_ahead_kb setting was fairly small.
> > >> 
> > >>  Yeah, I believe 512KB should be pretty safe these days except for
> > >> embedded world. OTOH average desktop user doesn't really care so it's
> > >> mostly servers with beefy storage that care... (note that I wrote we raised
> > >> the read_ahead_kb for SLES but not for openSUSE or SLED (desktop enterprise
> > >> distro)).
> > > 
> > > Maybe we don't need to care much about the embedded world when raising
> > > the default readahead size? Because even the current 128KB is too much
> > > for them, and I see Android setting the readahead size to 4KB...
> > > 
> > > Some time ago I posted a series for raising the default readahead size
> > > to 512KB. But I'm open to use 1MB now (shall we vote on it?).
> > 
> > I'm all in favour of 1MB (aligned) readahead.
> 
> 1MB readahead aligned to i*1MB boundaries? I like this idea. It will
> work well if the filesystems employ the same alignment rule for large
> files.
> 
> > I think the embedded folks
> > already set enough CONFIG opts that we could trigger on one of those
> > (e.g. CONFIG_EMBEDDED) to avoid stepping on their toes.
> 
> Good point. We could add a configurable CONFIG_READAHEAD_KB=128 when
> CONFIG_EMBEDDED is selected.
> 
> > It would also be
> > possible to trigger on the size of the device so that the 32MB USB stick
> > doesn't sit busy for a minute with readahead that is useless.
> 
> Yeah, I do have a patch for shrinking readahead size based on device size.

Should it be a udev rule to change read_ahead_kb on device based on device
size, instead of a kernel patch?

This is assuming device size is a good way to determine read ahead window
size. I would guess that device speed should also matter though isn't it.
If device is small but fast then it is probably ok to have larger read ahead
window and vice versa.

Thanks
Vivek
