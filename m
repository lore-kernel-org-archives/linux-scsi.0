From: Jan Kara <jack@suse.cz>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Thu, 19 Jan 2012 00:22:00 +0100
Message-ID: <20120118232200.GA22019@quack.suse.cz>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com>
 <20120117200609.GA7933@redhat.com>
 <20120117213648.GA9457@quack.suse.cz>
 <20120118225808.GA3074@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab2ARXWD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jan 2012 18:22:03 -0500
Content-Disposition: inline
In-Reply-To: <20120118225808.GA3074@tux1.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, neilb@suse.de

On Wed 18-01-12 14:58:08, Darrick J. Wong wrote:
> On Tue, Jan 17, 2012 at 10:36:48PM +0100, Jan Kara wrote:
> > On Tue 17-01-12 15:06:12, Mike Snitzer wrote:
> > > 5) Any more progress on stable pages?
> > >    - I know Darrick Wong had some proposals, what remains?
> >   As far as I know this is done for XFS, btrfs, ext4. Is more needed?
> 
> Yep, it's done for those three fses.
> 
> I suppose it might help some people if instead of wait_on_page_writeback we
> could simply page-migrate all the processes onto a new page...?
  Well, but it will cost some more memory & copying so whether it's faster
or not pretty much depends on the workload, doesn't it? Anyway I've already
heard one guy complaining that his RT application does redirtying of mmaped
pages and it started seeing big latencies due to stable pages work. So for
these guys migrating might be an option (or maybe fadvise/madvise flag to
do copy out before submitting for IO?).

> Or possibly modify md-raid5 not to snapshot dirty pages prior to xor/write?
> (I never really bothered to find out if it really does this.)
  Not sure either. Neil should know :) (added to CC).

								Honze
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
