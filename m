From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Thu, 31 Jan 2008 09:14:20 -0800
Message-ID: <1201799660.11265.121.camel@haakon2.linux-iscsi.org>
References: <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
	 <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
	 <e2e108260801310634n21473909o5abac021cc889de3@mail.gmail.com>
	 <47A1EE54.6000005@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:31505 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759461AbYAaROt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 12:14:49 -0500
In-Reply-To: <47A1EE54.6000005@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, FUJITA Tomonori <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Thu, 2008-01-31 at 18:50 +0300, Vladislav Bolkhovitin wrote:
> Bart Van Assche wrote:
> > On Jan 31, 2008 2:25 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > 
> >>Since this particular code is located in a non-data path critical
> >>section, the kernel vs. user discussion is a wash.  If we are talking
> >>about data path, yes, the relevance of DD tests in kernel designs are
> >>suspect :p.  For those IB testers who are interested, perhaps having a
> >>look with disktest from the Linux Test Project would give a better
> >>comparision between the two implementations on a RDMA capable fabric
> >>like IB for best case performance.  I think everyone is interested in
> >>seeing just how much data path overhead exists between userspace and
> >>kernel space in typical and heavy workloads, if if this overhead can be
> >>minimized to make userspace a better option for some of this very
> >>complex code.
> > 
> > I can run disktest on the same setups I ran dd on. This will take some
> > time however.
> 
> Disktest was already referenced in the beginning of the performance 
> comparison thread, but its results are not very interesting if we are 
> going to find out, which implementation is more effective, because in 
> the modes, in which usually people run this utility, it produces latency 
> insensitive workload (multiple threads working in parallel). So, such 
> multithreaded disktests results will be different between STGT and SCST 
> only if STGT's implementation will get target CPU bound. If CPU on the 
> target is powerful enough, even extra busy loops in the STGT or SCST hot 
> path code will change nothing.
> 

I think the really interesting numbers are the difference for bulk I/O
between kernel and userspace on both traditional iSCSI and the RDMA
enabled flavours.  I have not been able to determine anything earth
shattering from the current run of kernel vs. userspace tests, nor which
method of implementation for iSER, SRP, and generic Storage Engine are
'more effective' for that case.  Performance and latency to real storage
would make alot more sense for the kernel vs. user case.  Also workloads
against software LVM and Linux MD block devices would be of interest as
these would be some of the more typical deployments that would be in the
field, and is what Linux-iSCSI.org uses for our production cluster
storage today.

Having implemented my own iSCSI and SCSI Target mode Storage Engine
leads me to believe that putting logic in userspace is probably a good
idea in the longterm.  If this means putting the entire data IO path
into userspace for Linux/iSCSI, then there needs to be a good reason why
this will not not scale to multi-port 10 Gb/sec engines in traditional
and RDMA mode if we need to take this codepath back into the kernel.
The end goal is to have the most polished and complete storage engine
and iSCSI stacks designs go upstream, which is something I think we can
all agree on.

Also, with STGT being a pretty new design which has not undergone alot
of optimization, perhaps profiling both pieces of code against similar
tests would give us a better idea of where userspace bottlenecks reside.
Also, the overhead involved with traditional iSCSI for bulk IO from
kernel / userspace would also be a key concern for a much larger set of
users, as iSER and SRP on IB is a pretty small userbase and will
probably remain small for the near future.

> Additionally, multithreaded disktest over RAM disk is a good example of 
> a synthetic benchmark, which has almost no relation with real life 
> workloads. But people like it, because it produces nice looking results.
> 

Yes, people like to claim their stacks are the fastest with RAM disk
benchmarks.  But hooking up their fast network silicon to existing
storage hardware and OS storage subsystems and software is where the
real game is..

> Actually, I don't know what kind of conclusions it is possible to make 
> from disktest's results (maybe only how throughput gets bigger or slower 
> with increasing number of threads?), it's a good stress test tool,
> but 
> not more.
> 

Being able to have a best case baseline with disktest for kernel vs.
user would be of interest for both transport protocol and SCSI Target
mode Storage Engine profiling.  The first run of tests looked pretty
bandwith oriented, so disktest works well to determine maximum bandwith.
Disktest also is nice for getting reads from cache on hardware RAID
controllers because disktest only generates requests with LBAs from 0 ->
disktest BLOCKSIZE.

--nab

> > Disktest is new to me -- any hints with regard to suitable
> > combinations of command line parameters are welcome. The most recent
> > version I could find on http://ltp.sourceforge.net/ is ltp-20071231.
> > 
> > Bart Van Assche.
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 

