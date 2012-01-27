From: Wu Fengguang <fengguang.wu@gmail.com>
Subject: Re: [Lsf-pc] [dm-devel]  [LSF/MM TOPIC] a few storage topics
Date: Fri, 27 Jan 2012 15:53:07 +0800
Message-ID: <20120127075306.GA8795@localhost>
References: <20120124200932.GB20650@quack.suse.cz>
 <x49pqe8kgej.fsf@segfault.boston.devel.redhat.com>
 <20120124203936.GC20650@quack.suse.cz>
 <20120125032932.GA7150@localhost>
 <F6F2DEB8-F096-4A3B-89E3-3A132033BC76@dilger.ca>
 <20120125063552.GA27375@localhost>
 <20120126162555.GF1891@redhat.com>
 <20120126223449.GZ15102@dastard>
 <20120127032734.GA16980@localhost>
 <20C51818-5C53-4417-B62A-AD7C020CE283@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33325 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2A0HxS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2012 02:53:18 -0500
Content-Disposition: inline
In-Reply-To: <20C51818-5C53-4417-B62A-AD7C020CE283@dilger.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Dave Chinner <david@fromorbit.com>, Vivek Goyal <vgoyal@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, "neilb@suse.de" <neilb@suse.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, Chris Mason <chris.mason@oracle.com>, "Darrick J.Wong" <djwong@us.ibm.com>

On Thu, Jan 26, 2012 at 10:25:33PM -0700, Andreas Dilger wrote:
[snip]
> Doesn't the kernel derive at least some idea of the speed of a device
> due to the writeback changes that you made?  It would be very useful
> if we could derive at least some rough metric for the device performance
> in the kernel and use that as input to the readahead window size as well.

Yeah we now have bdi->write_bandwidth (exported as "BdiWriteBandwidth"
in /debug/bdi/8:0/stats) for estimating the bdi write bandwidth.

However the value is not reflecting the sequential throughput in some
cases:

1) when doing random writes
2) when doing mixed reads+writes
3) when not enough IO have been issued
4) in the rare case, when writing to a small area repeatedly so that
   it's effectively writing to the internal disk buffer at high speed

So there are still some challenges in getting a reliably usable
runtime estimation.

Thanks,
Fengguang
