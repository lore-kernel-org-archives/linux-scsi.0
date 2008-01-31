From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Thu, 31 Jan 2008 11:25:32 -0500
Message-ID: <47A1F67C.4020300@scalableinformatics.com>
References: <adazluoe2t3.fsf@cisco.com>		<20080130083239E.fujita.tomonori@lab.ntt.co.jp>		<e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>		<20080130195635T.tomof@acm.org>		<1201785938.7280.105.camel@haakon2.linux-iscsi.org>	<e2e108260801310634n21473909o5abac021cc889de3@mail.gmail.com> <47A1EE54.6000005@vlnb.net>
Reply-To: landman@scalableinformatics.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from scalableinformatics.com ([66.93.0.201]:39425 "EHLO
	mail.scalableinformatics.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757041AbYAaQ5K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 11:57:10 -0500
In-Reply-To: <47A1EE54.6000005@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, rdreier@cisco.com, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, fujita.tomonori@lab.ntt.co.jp, scst-devel@lists.sourceforge.net, akpm@linux-foundation.org, FUJITA Tomonori <tomof@acm.org>, torvalds@linux-foundation.org

Vladislav Bolkhovitin wrote:
> Bart Van Assche wrote:

[...]

>> I can run disktest on the same setups I ran dd on. This will take some
>> time however.
> 
> Disktest was already referenced in the beginning of the performance 
> comparison thread, but its results are not very interesting if we are 
> going to find out, which implementation is more effective, because in 
> the modes, in which usually people run this utility, it produces latency 
> insensitive workload (multiple threads working in parallel). So, such 

There are other issues with disktest, in that you can easily specify 
option combinations that generate apparently 5+ GB/s of IO, though 
actual traffic over the link to storage is very low.  Caveat disktest 
emptor.

> multithreaded disktests results will be different between STGT and SCST 
> only if STGT's implementation will get target CPU bound. If CPU on the 
> target is powerful enough, even extra busy loops in the STGT or SCST hot 
> path code will change nothing.
> 
> Additionally, multithreaded disktest over RAM disk is a good example of 
> a synthetic benchmark, which has almost no relation with real life 
> workloads. But people like it, because it produces nice looking results.

I agree.  The backing store should be a disk for it to have meaning, 
though please note my caveat above.

> 
> Actually, I don't know what kind of conclusions it is possible to make 
> from disktest's results (maybe only how throughput gets bigger or slower 
> with increasing number of threads?), it's a good stress test tool, but 
> not more.

Unfortunately, I agree.  Bonnie++, dd tests, and a few others seem to 
bear far closer to "real world" tests than disktest and iozone, the 
latter of which does more to test the speed of RAM cache and system call 
performance than actual IO.


>> Disktest is new to me -- any hints with regard to suitable
>> combinations of command line parameters are welcome. The most recent
>> version I could find on http://ltp.sourceforge.net/ is ltp-20071231.
>>
>> Bart Van Assche.

Here is what I have run:

disktest -K 8 -B 256k  -I F -N 20000000 -P A -w /big/file
disktest -K 8 -B 64k   -I F -N 20000000 -P A -w /big/file
disktest -K 8 -B 1k    -I B -N 2000000  -P A  /dev/sdb2

and many others.



Joe


-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics LLC,
email: landman@scalableinformatics.com
web  : http://www.scalableinformatics.com
        http://jackrabbit.scalableinformatics.com
phone: +1 734 786 8423
fax  : +1 866 888 3112
cell : +1 734 612 4615
