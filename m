From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] a few storage topics
Date: Mon, 23 Jan 2012 14:19:33 -0500
Message-ID: <x49lioy9qgq.fsf@segfault.boston.devel.redhat.com>
References: <20120117200609.GA7933@redhat.com>
	<20120117213648.GA9457@quack.suse.cz>
	<20120118225808.GA3074@tux1.beaverton.ibm.com>
	<20120118232200.GA22019@quack.suse.cz> <4F1758D4.9010401@panasas.com>
	<20120119094637.GA23442@quack.suse.cz> <4F1BFF5F.6000502@panasas.com>
	<20120123161857.GC28526@quack.suse.cz>
	<20120123175353.GD30782@redhat.com>
	<x49r4yq9suf.fsf@segfault.boston.devel.redhat.com>
	<20120123185650.GF30782@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab2AWTUN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2012 14:20:13 -0500
In-Reply-To: <20120123185650.GF30782@redhat.com> (Andrea Arcangeli's message
	of "Mon, 23 Jan 2012 19:56:50 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Boaz Harrosh <bharrosh@panasas.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, neilb@suse.de, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, "Darrick J. Wong" <djwong@us.ibm.com>

Andrea Arcangeli <aarcange@redhat.com> writes:

> On Mon, Jan 23, 2012 at 01:28:08PM -0500, Jeff Moyer wrote:
>> Are you speaking from experience?  If so, what workloads were negatively
>> affected by merging, and how did you measure that?
>
> Any workload where two processes compete for accessing the same disk
> and one process writes big requests (usually async writes), the other
> small (usually sync reads). The one with the small 4k requests
> (usually reads) gets some artificial latency if the big requests are
> 512k. Vivek did a recent measurement to verify the issue is still
> there, and it's basically an hardware issue. Software can't do much
> other than possibly reducing the max request size when we notice such
> an I/O pattern coming in cfq. I did old measurements that's how I knew
> it, but they were so ancient they're worthless by now, this is why
> Vivek had to repeat it to verify before we could assume it still
> existed on recent hardware.
>
> These days with cgroups it may be a bit more relevant as max write
> bandwidth may be secondary to latency/QoS.

Thanks, Vivek was able to point me at the old thread:
  http://www.spinics.net/lists/linux-fsdevel/msg44191.html

Cheers,
Jeff
