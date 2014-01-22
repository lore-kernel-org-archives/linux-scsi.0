From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] really large storage sectors - going
 beyond 4096 bytes
Date: Wed, 22 Jan 2014 10:47:01 -0800
Message-ID: <1390416421.2372.68.camel@dabdike.int.hansenpartnership.com>
References: <20131220093022.GV11295@suse.de> <52DF353D.6050300@redhat.com>
	 <20140122093435.GS4963@suse.de> <52DFD168.8080001@redhat.com>
	 <20140122143452.GW4963@suse.de> <52DFDCA6.1050204@redhat.com>
	 <20140122151913.GY4963@suse.de>
	 <1390410233.1198.7.camel@ret.masoncoding.com>
	 <1390411300.2372.33.camel@dabdike.int.hansenpartnership.com>
	 <1390413819.1198.20.camel@ret.masoncoding.com>
	 <1390414439.2372.53.camel@dabdike.int.hansenpartnership.com>
	 <1390415924.1198.36.camel@ret.masoncoding.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1390415924.1198.36.camel@ret.masoncoding.com>
Sender: owner-linux-mm@kvack.org
To: Chris Mason <clm@fb.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "rwheeler@redhat.com" <rwheeler@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "mgorman@suse.de" <mgorman@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-01-22 at 18:37 +0000, Chris Mason wrote:
> On Wed, 2014-01-22 at 10:13 -0800, James Bottomley wrote:
> > On Wed, 2014-01-22 at 18:02 +0000, Chris Mason wrote:
[agreement cut because it's boring for the reader]
> > Realistically, if you look at what the I/O schedulers output on a
> > standard (spinning rust) workload, it's mostly large transfers.
> > Obviously these are misalgned at the ends, but we can fix some of that
> > in the scheduler.  Particularly if the FS helps us with layout.  My
> > instinct tells me that we can fix 99% of this with layout on the FS + io
> > schedulers ... the remaining 1% goes to the drive as needing to do RMW
> > in the device, but the net impact to our throughput shouldn't be that
> > great.
> 
> There are a few workloads where the VM and the FS would team up to make
> this fairly miserable
> 
> Small files.  Delayed allocation fixes a lot of this, but the VM doesn't
> realize that fileA, fileB, fileC, and fileD all need to be written at
> the same time to avoid RMW.  Btrfs and MD have setup plugging callbacks
> to accumulate full stripes as much as possible, but it still hurts.
> 
> Metadata.  These writes are very latency sensitive and we'll gain a lot
> if the FS is explicitly trying to build full sector IOs.

OK, so these two cases I buy ... the question is can we do something
about them today without increasing the block size?

The metadata problem, in particular, might be block independent: we
still have a lot of small chunks to write out at fractured locations.
With a large block size, the FS knows it's been bad and can expect the
rolled up newspaper, but it's not clear what it could do about it.

The small files issue looks like something we should be tackling today
since writing out adjacent files would actually help us get bigger
transfers.

James



--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
