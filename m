From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Thu, 31 Jan 2008 18:50:44 +0300
Message-ID: <47A1EE54.6000005@vlnb.net>
References: <adazluoe2t3.fsf@cisco.com>	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>	 <20080130195635T.tomof@acm.org>	 <1201785938.7280.105.camel@haakon2.linux-iscsi.org> <e2e108260801310634n21473909o5abac021cc889de3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:50031 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756793AbYAaPuv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 10:50:51 -0500
In-Reply-To: <e2e108260801310634n21473909o5abac021cc889de3@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, FUJITA Tomonori <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com, James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

Bart Van Assche wrote:
> On Jan 31, 2008 2:25 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> 
>>Since this particular code is located in a non-data path critical
>>section, the kernel vs. user discussion is a wash.  If we are talking
>>about data path, yes, the relevance of DD tests in kernel designs are
>>suspect :p.  For those IB testers who are interested, perhaps having a
>>look with disktest from the Linux Test Project would give a better
>>comparision between the two implementations on a RDMA capable fabric
>>like IB for best case performance.  I think everyone is interested in
>>seeing just how much data path overhead exists between userspace and
>>kernel space in typical and heavy workloads, if if this overhead can be
>>minimized to make userspace a better option for some of this very
>>complex code.
> 
> I can run disktest on the same setups I ran dd on. This will take some
> time however.

Disktest was already referenced in the beginning of the performance 
comparison thread, but its results are not very interesting if we are 
going to find out, which implementation is more effective, because in 
the modes, in which usually people run this utility, it produces latency 
insensitive workload (multiple threads working in parallel). So, such 
multithreaded disktests results will be different between STGT and SCST 
only if STGT's implementation will get target CPU bound. If CPU on the 
target is powerful enough, even extra busy loops in the STGT or SCST hot 
path code will change nothing.

Additionally, multithreaded disktest over RAM disk is a good example of 
a synthetic benchmark, which has almost no relation with real life 
workloads. But people like it, because it produces nice looking results.

Actually, I don't know what kind of conclusions it is possible to make 
from disktest's results (maybe only how throughput gets bigger or slower 
with increasing number of threads?), it's a good stress test tool, but 
not more.

> Disktest is new to me -- any hints with regard to suitable
> combinations of command line parameters are welcome. The most recent
> version I could find on http://ltp.sourceforge.net/ is ltp-20071231.
> 
> Bart Van Assche.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

